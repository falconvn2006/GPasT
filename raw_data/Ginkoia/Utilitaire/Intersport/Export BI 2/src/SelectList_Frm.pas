unit SelectList_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UItem,
  uLogFile;

const
  SQL_ASK_DOSSIERS = 'select dos_id, dos_codegroupebi, dos_nom, dos_actifbi, '
                   + '       upper(f_left(dos_basepath, f_substr('':'', dos_basepath))) as server, '
                   + '       upper(f_right(dos_basepath, f_stringlength(dos_basepath) - f_substr('':'', dos_basepath) -1)) as datafile '
                   + 'from dossiers '
                   + 'where dos_id != 0 /* WHERE */ '
                   + 'order by 4, 2;';
  SQL_ASK_MAGASINS = 'select mag_id, mag_codeadh, mag_nom, mag_enseigne, '
                   + '       prm_string, prm_integer, prm_float, '
                   + '       (select max(imt_datevalide) from isfmvtbitraite where imt_magid = genmagasin.mag_id) as imt_datevalide '
                   + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                   + 'left join genparam on prm_magid = mag_id and prm_type = 3 and prm_code = 67 '
                   + 'where mag_id != 0 /* WHERE */ '
                   + 'order by mag_codeadh, mag_nom;';
//  SQL_PARAM_MAGASINS = 'select prm_string, prm_integer, prm_float '
//                     + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
//                     + 'where prm_type = 3 and prm_code = 67 and prm_magid = :idmagasin;';

type
  Tfrm_SelectList = class(TForm)
    lv_ToSelect: TListView;
    btn_OK: TButton;
    btn_Annuler: TButton;
    chk_SelectAll: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure chk_SelectAllClick(Sender: TObject);
    procedure lv_ToSelectColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_ToSelectCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lv_ToSelectItemChecked(Sender: TObject; Item: TListItem);
  private
    { Déclarations privées }
    FSortedColumn : integer;

    function GetSelectCount() : integer;
    function GetSelected(idx : integer) : TItem;
  public
    { Déclarations publiques }
    function Add(Value : TItem) : integer; overload;
    function Add(Id : integer; Code, Nom : string; Actif : boolean) : integer; overload;

    property SelectedCount : integer read GetSelectCount;
    property Selected[idx : integer] : TItem read GetSelected;
  end;

function GetListeDossierMagasin(MainFrm : TForm; Logs : TLogFile; SelectDos : boolean = false; SelectMag : boolean = false; WhereDos : string = 'and dos_actifbi = 1'; WhereMag : string = 'and prm_float = 1') : TItemDictionary<TDossierItem, TMagasinItem>;
function DialogSelectDossiers(Logs : TLogFile; FicheDos : Tfrm_SelectList; WhereDos : string = '') : boolean;
function DialogSelectMagasins(Logs : TLogFile; FicheDos, FicheMag : Tfrm_SelectList; WhereDos : string = ''; WhereMag : string = '') : boolean;

implementation

uses
  System.Math,
  System.UITypes,
  System.DateUtils,
  FireDAC.Comp.Client,
  system.Generics.Defaults,
  system.Generics.Collections,
  ULectureIniFile,
  uGestionBDD,
  UResourceString;

{$R *.dfm}

// selections

function GetListeDossierMagasin(MainFrm : TForm; Logs : TLogFile; SelectDos : boolean; SelectMag : boolean; WhereDos : string; WhereMag : string) : TItemDictionary<TDossierItem, TMagasinItem>;
var
  DataBaseFile : string;
  i : integer;
  oldDossier, newDossier : TDossierItem;
  oldMagasin, newMagasin : TMagasinItem;
  CnxConfig, CnxGinkoia : TFDConnection;
  QryConfig, QryGinkoia : TFDQuery;
  FicheDos, FicheMag : Tfrm_SelectList;
begin
  Result := TItemDictionary<TDossierItem, TMagasinItem>.Create([doOwnsKeys, doOwnsValues],
                                                               TDelegatedEqualityComparer<TDossierItem>.Construct(function(const Left, Right : TDossierItem): boolean begin Result := (Left.Id = Right.Id); end,
                                                                                                                  function(const Value : TDossierItem): integer begin Result := Value.Id; end));

  if not ReadIniBase(DataBaseFile) then
  begin
    if Assigned(Logs) then
      Logs.Log(rs_ErreurLectureFichierIni, logCritical);
    Exit;
  end;

  if SelectMag then
  begin
    try
      FicheDos := Tfrm_SelectList.Create(MainFrm);
      FicheMag := Tfrm_SelectList.Create(MainFrm);

      if DialogSelectMagasins(Logs, FicheDos, FicheMag, WhereDos, WhereMag) then
      begin
        for i := 0 to FicheMag.SelectedCount -1 do
        begin
          oldMagasin := TMagasinItem(FicheMag.Selected[i]);
          oldDossier := oldMagasin.Dossier;
          if Result.ContainsKey(oldDossier) then
            newDossier := Result[oldDossier][0].Dossier
          else
          begin
            newDossier := TDossierItem(oldDossier.Clone());
            Result.Add(newDossier, TObjectList<TMagasinItem>.Create(true));
          end;
          newMagasin := TMagasinItem(oldMagasin.Clone());
          newMagasin.Dossier := newDossier;
          Result[newDossier].Add(newMagasin);
        end;
      end;
    finally
      FreeAndNil(FicheMag);
      FreeAndNil(FicheDos);
    end;
  end
  else if SelectDos then
  begin
    try
      FicheDos := Tfrm_SelectList.Create(MainFrm);

      if DialogSelectDossiers(Logs, FicheDos, WhereDos) then
      begin
        for i := 0 to FicheDos.SelectedCount -1 do
        begin
          oldDossier := TDossierItem(FicheDos.Selected[i]);
          newDossier := TDossierItem(oldDossier.Clone());
          Result.Add(newDossier, TObjectList<TMagasinItem>.Create(true));
          try
            try
              CnxGinkoia := GetNewConnexion(newDossier.Serveur, newDossier.FileName, 'ginkoia', 'ginkoia', false);
              CnxGinkoia.FetchOptions.Unidirectional := true;
              CnxGinkoia.Open();
              QryGinkoia := GetNewQuery(CnxGinkoia);
              if Trim(WhereMag) = '' then
                QryGinkoia.SQL.Text := SQL_ASK_MAGASINS
              else
                QryGinkoia.SQL.Text := StringReplace(SQL_ASK_MAGASINS, '/* WHERE */', WhereMag, []);
              try
                QryGinkoia.Open();
                while not QryGinkoia.Eof do
                begin
                  newMagasin := TMagasinItem.Create(QryGinkoia.FieldByName('mag_id').AsInteger,
                                                    QryGinkoia.FieldByName('mag_codeadh').AsString,
                                                    QryGinkoia.FieldByName('mag_enseigne').AsString,
                                                    QryGinkoia.FieldByName('prm_float').AsInteger = 1,
                                                    QryGinkoia.FieldByName('prm_integer').AsInteger = 1,
                                                    StrToDateDef(QryGinkoia.FieldByName('prm_string').AsString, 0),
                                                    IncDay(QryGinkoia.FieldByName('imt_datevalide').AsDateTime, -1),
                                                    newDossier);
                  Result[newDossier].Add(newMagasin);
                  QryGinkoia.Next();
                end;
              finally
                QryGinkoia.Close();
              end;
            finally
              FreeAndNil(QryGinkoia);
              FreeAndNil(CnxGinkoia);
            end;
          except
            on e : Exception do
              if Assigned(Logs) then
                Logs.Log(Format(rs_ExceptionRequeteMagasin, [e.ClassName, e.Message]), logError);
          end;
        end;
      end;
    finally
      FreeAndNil(FicheDos);
    end;
  end
  else
  begin
    try
      try
        CnxConfig := GetNewConnexion(DataBaseFile, 'sysdba', 'masterkey', false);
        CnxConfig.FetchOptions.Unidirectional := true;
        CnxConfig.Open();
        QryConfig := GetNewQuery(CnxConfig);
        if Trim(WhereDos) = '' then
          QryConfig.SQL.Text := SQL_ASK_DOSSIERS
        else
          QryConfig.SQL.Text := StringReplace(SQL_ASK_DOSSIERS, '/* WHERE */', WhereDos, []);
        try
          QryConfig.Open();
          while not QryConfig.Eof do
          begin
            if Length(QryConfig.FieldByName('server').AsString) = 1 then // une seul lettre ?? un lecteur !
              newDossier := TDossierItem.Create(QryConfig.FieldByName('dos_id').AsInteger,
                                                QryConfig.FieldByName('dos_codegroupebi').AsString,
                                                QryConfig.FieldByName('dos_nom').AsString,
                                                'localhost',
                                                QryConfig.FieldByName('server').AsString + ':' + QryConfig.FieldByName('datafile').AsString,
                                                QryConfig.FieldByName('dos_actifbi').AsInteger = 1)
            else
              newDossier := TDossierItem.Create(QryConfig.FieldByName('dos_id').AsInteger,
                                                QryConfig.FieldByName('dos_codegroupebi').AsString,
                                                QryConfig.FieldByName('dos_nom').AsString,
                                                QryConfig.FieldByName('server').AsString,
                                                QryConfig.FieldByName('datafile').AsString,
                                                QryConfig.FieldByName('dos_actifbi').AsInteger = 1);
            Result.Add(newDossier, TObjectList<TMagasinItem>.Create(false));
            try
              try
                CnxGinkoia := GetNewConnexion(newDossier.Serveur, newDossier.FileName, 'ginkoia', 'ginkoia', false);
                CnxGinkoia.FetchOptions.Unidirectional := true;
                CnxGinkoia.Open();
                QryGinkoia := GetNewQuery(CnxGinkoia);
                if Trim(WhereMag) = '' then
                  QryGinkoia.SQL.Text := SQL_ASK_MAGASINS
                else
                  QryGinkoia.SQL.Text := StringReplace(SQL_ASK_MAGASINS, '/* WHERE */', WhereMag, []);
                try
                  QryGinkoia.Open();
                  while not QryGinkoia.Eof do
                  begin
                    newMagasin := TMagasinItem.Create(QryGinkoia.FieldByName('mag_id').AsInteger,
                                                      QryGinkoia.FieldByName('mag_codeadh').AsString,
                                                      QryGinkoia.FieldByName('mag_enseigne').AsString,
                                                      QryGinkoia.FieldByName('prm_float').AsInteger = 1,
                                                      QryGinkoia.FieldByName('prm_integer').AsInteger = 1,
                                                      StrToDateDef(QryGinkoia.FieldByName('prm_string').AsString, 0),
                                                      IncDay(QryGinkoia.FieldByName('imt_datevalide').AsDateTime, -1),
                                                      newDossier);
                    Result[newDossier].Add(newMagasin);
                    QryGinkoia.Next();
                  end;
                finally
                  QryGinkoia.Close();
                end;
              finally
                FreeAndNil(QryGinkoia);
                FreeAndNil(CnxGinkoia);
              end;
            except
              on e : Exception do
                if Assigned(Logs) then
                  Logs.Log(Format(rs_ExceptionRequeteMagasin, [e.ClassName, e.Message]), logError);
            end;
            QryConfig.Next();
          end;
        finally
          QryConfig.Close();
        end;
      finally
        FreeAndNil(QryConfig);
        FreeAndNil(CnxConfig);
      end;
    except
      on e : Exception do
        if Assigned(Logs) then
          Logs.Log(Format(rs_ExceptionRequeteDossier, [e.ClassName, e.Message]), logError);
    end;
  end;
end;

function DialogSelectDossiers(Logs : TLogFile; FicheDos : Tfrm_SelectList; WhereDos : string) : boolean;
var
  DataBaseFile : string;
  Connexion : TFDConnection;
  Query : TFDQuery;
begin
  Result := false;
  FicheDos.lv_ToSelect.Clear();

  if ReadIniBase(DataBaseFile) and not (Trim(DataBaseFile) = '') then
  begin
    try
      try
        Connexion := GetNewConnexion(DataBaseFile, 'sysdba', 'masterkey', false);
        Connexion.FetchOptions.Unidirectional := true;
        Connexion.Open();
        Query := GetNewQuery(Connexion);
        if Trim(WhereDos) = '' then
          Query.SQL.Text := SQL_ASK_DOSSIERS
        else
          Query.SQL.Text := StringReplace(SQL_ASK_DOSSIERS, '/* WHERE */', WhereDos, []);
        try
          Query.Open();
          if Query.Eof then
            MessageDlg('Pas de dossier configuré dans cette base !', mtWarning, [mbOK], 0)
          else
          begin
            while not Query.Eof do
            begin
              if Length(Query.FieldByName('server').AsString) = 1 then // une seul lettre ?? un lecteur !
                FicheDos.Add(TDossierItem.Create(Query.FieldByName('dos_id').AsInteger,
                                                 Query.FieldByName('dos_codegroupebi').AsString,
                                                 Query.FieldByName('dos_nom').AsString,
                                                 'localhost',
                                                 Query.FieldByName('server').AsString + ':' + Query.FieldByName('datafile').AsString,
                                                 Query.FieldByName('dos_actifbi').AsInteger = 1))
              else
                FicheDos.Add(TDossierItem.Create(Query.FieldByName('dos_id').AsInteger,
                                                 Query.FieldByName('dos_codegroupebi').AsString,
                                                 Query.FieldByName('dos_nom').AsString,
                                                 Query.FieldByName('server').AsString,
                                                 Query.FieldByName('datafile').AsString,
                                                 Query.FieldByName('dos_actifbi').AsInteger = 1));
              Query.Next();
            end;
          end;
        finally
          Query.Close();
        end;
      finally
        FreeAndNil(Query);
        FreeAndNil(Connexion);
      end;
    except
      on e : Exception do
        if Assigned(Logs) then
          Logs.Log(Format(rs_ExceptionSelectionDossier, [e.ClassName, e.Message]), logError);
    end;
    if FicheDos.lv_ToSelect.Items.Count = 0 then
      MessageDlg('Pas de magasins configuré dans ces bases !', mtWarning, [mbOK], 0)
    else if FicheDos.ShowModal() = mrOK then
      Result := true;
  end
  else
    MessageDlg('Erreur de lecture du fichier de config', mtError, [mbOK], 0);
end;

function DialogSelectMagasins(Logs : TLogFile; FicheDos, FicheMag : Tfrm_SelectList; WhereDos : string; WhereMag : string) : boolean;
var
  DataBaseFile : string;
  Connexion : TFDConnection;
  Query : TFDQuery;
  i : integer;
  Dossier : TDossierItem;
begin
  Result := false;
  FicheDos.lv_ToSelect.Clear();
  FicheMag.lv_ToSelect.Clear();

  if ReadIniBase(DataBaseFile) and not (Trim(DataBaseFile) = '') then
  begin
    if DialogSelectDossiers(Logs, FicheDos, WhereDos) then
    begin
      for i := 0 to FicheDos.SelectedCount -1 do
      begin
        Dossier := TDossierItem(FicheDos.Selected[i]);
        try
          try
            Connexion := GetNewConnexion(Dossier.Serveur, Dossier.FileName, 'ginkoia', 'ginkoia', false);
            Connexion.FetchOptions.Unidirectional := true;
            Connexion.Open();
            Query := GetNewQuery(Connexion);
            if Trim(WhereMag) = '' then
              Query.SQL.Text := SQL_ASK_MAGASINS
            else
              Query.SQL.Text := StringReplace(SQL_ASK_MAGASINS, '/* WHERE */', WhereMag, []);
            try
              Query.Open();
              if not Query.Eof then
              begin
                while not Query.Eof do
                begin
                  FicheMag.Add(TMagasinItem.Create(Query.FieldByName('mag_id').AsInteger,
                                                   Query.FieldByName('mag_codeadh').AsString,
                                                   Query.FieldByName('mag_enseigne').AsString,
                                                   Query.FieldByName('prm_float').AsInteger = 1,
                                                   Query.FieldByName('prm_integer').AsInteger = 1,
                                                   StrToDateDef(Query.FieldByName('prm_string').AsString, 0),
                                                   IncDay(Query.FieldByName('imt_datevalide').AsDateTime, -1),
                                                   Dossier));
                  Query.Next();
                end;
              end;
            finally
              Query.Close();
            end;
          finally
            FreeAndNil(Query);
            FreeAndNil(Connexion);
          end;
        except
          on e : Exception do
            if Assigned(Logs) then
              Logs.Log(Format(rs_ExceptionSelectionMagasin, [e.ClassName, e.Message]), logError);
        end;
      end;
      if FicheMag.lv_ToSelect.Items.Count = 0 then
        MessageDlg('Pas de magasins configuré dans ces bases !', mtWarning, [mbOK], 0)
      else if FicheMag.ShowModal() = mrOK then
        Result := true;
    end;
  end
  else
    MessageDlg('Erreur de lecture du fichier de config', mtError, [mbOK], 0);
end;

{ Tfrm_SelectList }

procedure Tfrm_SelectList.FormCreate(Sender: TObject);
begin
  FSortedColumn := -1;
end;

procedure Tfrm_SelectList.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to lv_ToSelect.Items.Count -1 do
    TItem(lv_ToSelect.Items[i].Data).Free();
end;

procedure Tfrm_SelectList.FormShow(Sender: TObject);
begin
  try
    lv_ToSelect.SortType := stNone;
    FSortedColumn := 1;
  finally
    lv_ToSelect.SortType := stBoth;
  end;
end;

procedure Tfrm_SelectList.chk_SelectAllClick(Sender: TObject);
var
  i : integer;
begin
  try
    lv_ToSelect.OnItemChecked := nil;
    try
      lv_ToSelect.Items.BeginUpdate();
      for i := 0 to lv_ToSelect.Items.Count -1 do
        lv_ToSelect.Items[i].Checked := chk_SelectAll.Checked
    finally
      lv_ToSelect.Items.EndUpdate();
    end;
  finally
    lv_ToSelect.OnItemChecked := lv_ToSelectItemChecked;
  end;
end;

procedure Tfrm_SelectList.lv_ToSelectColumnClick(Sender: TObject; Column: TListColumn);
begin
  try
    lv_ToSelect.SortType := stNone;
    if (Column.Index +1 = FSortedColumn) then
      FSortedColumn := -FSortedColumn
    else
      FSortedColumn := Column.Index +1;
  finally
    lv_ToSelect.SortType := stBoth;
  end;
end;

procedure Tfrm_SelectList.lv_ToSelectCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortedColumn = 0 then
    Compare := 0
  else
  begin
    if Abs(FSortedColumn) = 1 then
      Compare := Sign(FSortedColumn) * CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := Sign(FSortedColumn) * CompareStr(Item1.SubItems[Abs(FSortedColumn) -2], Item2.SubItems[Abs(FSortedColumn) -2]);
  end;
end;

procedure Tfrm_SelectList.lv_ToSelectItemChecked(Sender: TObject; Item: TListItem);
var
  nbSelected : integer;
begin
  try
    chk_SelectAll.OnClick := nil;
    nbSelected := GetSelectCount();
    if nbSelected = 0 then
      chk_SelectAll.State := cbUnchecked
    else if nbSelected = lv_ToSelect.Items.Count then
      chk_SelectAll.State := cbChecked
    else
      chk_SelectAll.State := cbGrayed;
  finally
    chk_SelectAll.OnClick := chk_SelectAllClick;
  end;
end;

function Tfrm_SelectList.GetSelectCount() : integer;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to lv_ToSelect.Items.Count -1 do
    if lv_ToSelect.Items[i].Checked then
      Inc(Result);
end;

function Tfrm_SelectList.GetSelected(idx : integer) : TItem;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to lv_ToSelect.Items.Count -1 do
    if lv_ToSelect.Items[i].Checked then
    begin
      if Idx = 0 then
        Exit(TItem(lv_ToSelect.Items[i].Data))
      else
        Dec(idx);
    end;
end;

function Tfrm_SelectList.Add(Value : TItem) : integer;
const
  marge = 14;
var
  tmp : TListItem;
begin
  tmp := lv_ToSelect.Items.Add();
  tmp.Caption := Value.Code;
  tmp.SubItems.Add(Value.Nom);
  tmp.Data := Value;
  lv_ToSelect.Columns[0].Width := Max(lv_ToSelect.Columns[0].Width, lv_ToSelect.Canvas.TextWidth(tmp.Caption) + marge * 2);
  lv_ToSelect.Columns[1].Width := Max(lv_ToSelect.Columns[1].Width, lv_ToSelect.Canvas.TextWidth(tmp.SubItems[0]) + marge);
  Result := tmp.Index;
end;

function Tfrm_SelectList.Add(Id : integer; Code, Nom : string; Actif : boolean) : integer;
begin
  Result := Add(TItem.Create(Id, Code, Nom, Actif));
end;

end.
