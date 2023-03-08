unit MainFrm;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons, System.INIFiles, System.DateUtils, System.Types, Data.DB, Vcl.FileCtrl;

type
  Tfrm_Main = class(TForm)
    lbl_Serveur: TLabel;
    edt_Serveur: TEdit;
    lbl_Database: TLabel;
    edt_Database: TEdit;
    Panel1: TPanel;
    lv_ListeMagasins: TListView;
    btn_Lister: TButton;
    rg_ActiveBI: TRadioGroup;
    Panel2: TPanel;
    btn_Quitter: TButton;
    pb_Progress: TProgressBar;
    btn_Fixe: TButton;
    LabelEtape: TLabel;
    btn_SaveList: TBitBtn;
    Btn_ListeMagISF: TBitBtn;
    PanelArticlesVendus: TPanel;
    BtnArticlesVendus: TBitBtn;
    DateTimePickerDebut: TDateTimePicker;
    DateTimePickerFin: TDateTimePicker;
    LabelDebut: TLabel;
    LabelFin: TLabel;
    Panel3: TPanel;
    EditRepertoireDest: TLabeledEdit;
    BtnRepertoireDest: TBitBtn;
    FileOpenDialog: TFileOpenDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_ServeurExit(Sender: TObject);
    procedure edt_DatabaseExit(Sender: TObject);
    procedure btn_ListerClick(Sender: TObject);
    procedure btn_FixeClick(Sender: TObject);
    procedure lv_ListeMagasinsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_ListeMagasinsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure BtnRepertoireDestClick(Sender: TObject);
    procedure BtnArticlesVendusClick(Sender: TObject);
    procedure btn_SaveListClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
    procedure Btn_ListeMagISFClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

  private
    // gestion du tri !
    FSortIdx: integer;
    sCheminExport: String;
    FIsDebug: Boolean;

    procedure PurgeFichiersExport(const iNbJoursPurge: Integer);

    // traitement du programme !
    function TraitementListe(out error : string) : boolean;
    function TraitementFixe(out error : string) : boolean;

    // activation
    procedure GestionInterface(Enabled : Boolean);
    // acces BDD
    function CanConnect(Serveur, DataBaseFile : string) : boolean;

    procedure AjoutLog(const sLigne: String; const bNouveau: Boolean = False);

  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

uses
  System.Math,
  System.StrUtils,
  System.UITypes,
  Winapi.ShellAPI,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  FireDAC.VCLUI.Wait;

{ Tfrm_Main }

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  FichierINI: TIniFile;
  iNbJoursPurge: Integer;
  sErreur: String;
begin
  FSortIdx := 0;
  AjoutLog('Chargement des paramètres.', True);

  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ListeMagBI.ini');
  try
    sCheminExport := IncludeTrailingPathDelimiter(FichierINI.ReadString('Paramètres', 'Chemin export', ExtractFilePath(Application.ExeName)));
    if sCheminExport = '\' then
    begin
      AjoutLog('Paramètre chemin export non défini !');
      sCheminExport := ExtractFilePath(Application.ExeName);
    end;
    iNbJoursPurge := FichierINI.ReadInteger('Paramètres', 'Nb jours purge fichiers', 30);

    if not FichierINI.ValueExists('Paramètres', 'Chemin export') then
      FichierINI.WriteString('Paramètres', 'Chemin export', ExtractFilePath(Application.ExeName));
    if not FichierINI.ValueExists('Paramètres', 'Nb jours purge fichiers') then
      FichierINI.WriteInteger('Paramètres', 'Nb jours purge fichiers', 30);
  finally
    FichierINI.Free;
  end;

  // Création, si le chemin n'existe pas.
  if not System.SysUtils.ForceDirectories(sCheminExport) then
  begin
    AjoutLog('Erreur :  la création du chemin [' + sCheminExport + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
    if Visible then
      Application.MessageBox(PChar('Erreur :  la création du chemin [' + sCheminExport + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError)), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
    sCheminExport := ExtractFilePath(Application.ExeName);
  end;

  // Purge des fichiers d'export.
  PurgeFichiersExport(iNbJoursPurge);
  AjoutLog('Purge des fichiers d''export.');

  if(ParamCount = 1) and (UpperCase(Trim(ParamStr(1))) = 'DEBUG') then
    FIsDebug := True;
  {$IFDEF DEBUG}
    FIsDebug := True;
  {$ENDIF}

  if ParamCount >= 3 then
  begin
    // Si traitement automatique.
    if UpperCase(ParamStr(1)) = 'AUTO' then
    begin
      AjoutLog('Début mode automatique.');
      edt_Serveur.Text := ParamStr(2);
      edt_Database.Text := ParamStr(3);
      rg_ActiveBI.ItemIndex := 2;

      if(Trim(edt_Serveur.Text) <> '') and ((Trim(edt_Database.Text) <> '') and CanConnect(edt_Serveur.Text, edt_Database.Text)) then
      begin
        // Recherche.
        TraitementListe(sErreur);

        // Export ListeMagISF.csv.
        Btn_ListeMagISFClick(Sender);
      end;

      AjoutLog('Fin mode automatique.');
      Application.Terminate;
    end;
  end;
end;

procedure Tfrm_Main.PurgeFichiersExport(const iNbJoursPurge: Integer);
var
  sr: TSearchRec;
begin
  // Parcours des fichiers d'export.
  if FindFirst(sCheminExport + '*.csv', faAnyFile, sr) = 0 then
  begin
    repeat
      if((sr.Attr and faDirectory) <> faDirectory) and (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si fichier plus vieux.
        if CompareDateTime(sr.TimeStamp, IncDay(Now, -Abs(iNbJoursPurge))) = LessThanValue then
        begin
          if not DeleteFile(sCheminExport + sr.Name) then
            AjoutLog('Erreur :  la suppression du fichier [' + sCheminExport + sr.Name + '] a échoué :  ' + SysErrorMessage(GetLastError));
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  btn_Fixe.Visible := FIsDebug;
  btn_Lister.SetFocus();
end;

procedure Tfrm_Main.edt_ServeurExit(Sender: TObject);
begin
  GestionInterface(True);
end;

procedure Tfrm_Main.edt_DatabaseExit(Sender: TObject);
begin
  GestionInterface(True);
end;

procedure Tfrm_Main.btn_ListerClick(Sender: TObject);
var
  error : string;
begin
  try
    GestionInterface(false);
    if not TraitementListe(error) then
      MessageDlg('Erreur lors du traitement : ' + error, mtError, [mbOK], 0);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_FixeClick(Sender: TObject);
var
  error : string;
begin
  try
    GestionInterface(false);
    if TraitementFixe(error) then
      MessageDlg('Traitement effectué correctement.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Erreur lors du traitement : ' + error, mtError, [mbOK], 0);
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.lv_ListeMagasinsColumnClick(Sender: TObject; Column: TListColumn);
begin
  try
    lv_ListeMagasins.SortType := stNone;
    if (Column.Index +1 = FSortIdx) then
      FSortIdx := -FSortIdx
    else
      FSortIdx := Column.Index +1;
  finally
    lv_ListeMagasins.SortType := stBoth;
  end;
end;

procedure Tfrm_Main.lv_ListeMagasinsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if FSortIdx = 0 then
    Compare := 0
  else
  begin
    if Abs(FSortIdx) = 1 then
      Compare := Sign(FSortIdx) * CompareStr(Item1.Caption, Item2.Caption)
    else
      Compare := Sign(FSortIdx) * CompareStr(Item1.SubItems[Abs(FSortIdx) -2], Item2.SubItems[Abs(FSortIdx) -2]);
  end;
end;

procedure Tfrm_Main.BtnRepertoireDestClick(Sender: TObject);
var
  sRepertoire: String;
begin
  // Si supérieur à Windows XP.
  if Win32MajorVersion >= 6 then
  begin
    FileOpenDialog.FileName := '';

    // Si validation.
    if FileOpenDialog.Execute then
      EditRepertoireDest.Text := FileOpenDialog.FileName;
  end
  else
  begin
    // Si validation.
    if SelectDirectory(' Sélectionner un répertoire', '', sRepertoire, [sdNewFolder, sdShowEdit, sdShowShares, sdValidateDir]) then
      EditRepertoireDest.Text := sRepertoire;
  end;
end;

procedure Tfrm_Main.BtnArticlesVendusClick(Sender: TObject);
{$REGION 'BtnArticlesVendusClick'}
  function LPAD(const sChaine: String; const nLongueur: Integer; const Caractere: Char): String;
  begin
    if Length(sChaine) < nLongueur then
      Result := sChaine + DupeString(Caractere, nLongueur - Length(sChaine))
    else
      Result := LeftStr(sChaine, nLongueur);
  end;

  procedure GenererFichier(const sNomFichier, sListe: String);
  var
    F: TextFile;
  begin
    // Création du fichier.
    AssignFile(F, IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sNomFichier);
    try
      Rewrite(F);
      Writeln(F, sListe);
    finally
      CloseFile(F);
    end;
  end;
{$ENDREGION}
var
  ConnexionMdc, ConnexionSym: TFDConnection;
  QueryMdc, QuerySym: TFDQuery;
  sCodeAdherent, sListe, sNomFichier: String;
  nDebut, nDuree: Cardinal;
begin
  // Si pas de répertoire de destination valide.
  if(EditRepertoireDest.Text = '') or (not System.SysUtils.DirectoryExists(EditRepertoireDest.Text)) then
  begin
    Application.MessageBox('Attention :  il faut saisir un répertoire de destination valide !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    EditRepertoireDest.SetFocus;
    Exit;
  end;

  // Si date fin antérieure à date début.
  if CompareDate(DateTimePickerDebut.Date, DateTimePickerFin.Date) = GreaterThanValue then
  begin
    Application.MessageBox('Attention :  la date de fin ne doit pas être antérieure à la date de début !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    DateTimePickerDebut.SetFocus;
    Exit;
  end;


  BtnArticlesVendus.Enabled := False;
  GestionInterface(False);
  try
    AjoutLog('Début extraction articles vendus.');
    LabelEtape.Caption := 'Connexion ...';
    pb_Progress.Position := 0;
    Application.ProcessMessages;

    ConnexionMdc := TFDConnection.Create(Self);
    try
      ConnexionMdc.DriverName := 'IB';
      ConnexionMdc.Params.Clear;
      ConnexionMdc.Params.Add('Server=' + edt_Serveur.Text);
      ConnexionMdc.Params.Add('port=3050');
      ConnexionMdc.Params.Add('Database=' + edt_Database.Text);
      ConnexionMdc.Params.Add('User_Name=sysdba');
      ConnexionMdc.Params.Add('Password=masterkey');
      ConnexionMdc.Params.Add('Protocol=TCPIP');
      ConnexionMdc.Params.Add('DriverID=IB');
      try
        ConnexionMdc.Open;
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Erreur :  la connexion a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;

      QueryMdc := TFDQuery.Create(Self);
      try
        QueryMdc.Connection := ConnexionMdc;

        // Recherche du nombre de bases.
        QueryMdc.Close;
        QueryMdc.SQL.Clear;
        QueryMdc.SQL.Add('select count(*) from DOSSIERS');
        try
          QueryMdc.Open;
        except
          on E: Exception do
          begin
            Application.MessageBox(PChar('Erreur :  la recherche du nombre de bases a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;
        if not QueryMdc.IsEmpty then
        begin
          pb_Progress.Max := QueryMdc.Fields[0].AsInteger;
          LabelEtape.Caption := 'Recherche des bases ...';
          Application.ProcessMessages;

          // Recherche des bases.
          QueryMdc.Close;
          QueryMdc.SQL.Clear;
          QueryMdc.SQL.Add('select DOS_GROUPE, DOS_NOM, upper(f_left(DOS_BASEPATH, f_substr('':'', DOS_BASEPATH))) as SERVEUR,');
          QueryMdc.SQL.Add('upper(f_right(DOS_BASEPATH, f_stringlength(DOS_BASEPATH) - f_substr('':'', DOS_BASEPATH) -1)) as DATAFILE');
          QueryMdc.SQL.Add('from DOSSIERS');
          QueryMdc.SQL.Add('order by DOS_GROUPE, DOS_NOM');
//          QueryMdc.SQL.Add('rows 1');
          try
            QueryMdc.Open;
          except
            on E: Exception do
            begin
              Application.MessageBox(PChar('Erreur :  la recherche des bases a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;
          if not QueryMdc.IsEmpty then
          begin
            pb_Progress.Position := 0;
            QueryMdc.First;
            while not QueryMdc.Eof do
            begin
              LabelEtape.Caption := 'Traitement de [ ' + QueryMdc.FieldByName('DATAFILE').AsString + ' ] ...';
              Application.ProcessMessages;

              ConnexionSym := TFDConnection.Create(Self);
              try
                // Connexion à la base.
                ConnexionSym.DriverName := 'IB';
                ConnexionSym.Params.Clear;
                ConnexionSym.Params.Add('Server=' + QueryMdc.FieldByName('SERVEUR').AsString + '.no-ip.org');
                ConnexionSym.Params.Add('port=3050');
                ConnexionSym.Params.Add('Database=' + QueryMdc.FieldByName('DATAFILE').AsString);
                ConnexionSym.Params.Add('User_Name=ginkoia');
                ConnexionSym.Params.Add('Password=ginkoia');
                ConnexionSym.Params.Add('Protocol=TCPIP');
                ConnexionSym.Params.Add('DriverID=IB');
                try
                  ConnexionSym.Open;
                except
                  on E: Exception do
                  begin
                    AjoutLog('Erreur :  la connexion à [' + QueryMdc.FieldByName('SERVEUR').AsString + '.no-ip.org] a échoué !' + #13#10 + E.Message);
                    QueryMdc.Next;
                    pb_Progress.Position := pb_Progress.Position + 1;
                    Continue;
                  end;
                end;

                AjoutLog('[' + QueryMdc.FieldByName('SERVEUR').AsString + '.no-ip.org]  ' + QueryMdc.FieldByName('DATAFILE').AsString);
                nDebut := GetTickCount;

                QuerySym := TFDQuery.Create(Self);
                try
                  QuerySym.Connection := ConnexionSym;

                  // Recherche des articles vendus.
                  QuerySym.Close;
                  QuerySym.SQL.Clear;
                  QuerySym.SQL.Add('select MAG_CODEADH, ART_REFMRK, COU_CODE, TGF_CODE');
                  QuerySym.SQL.Add('from GENMAGASIN join K on (K_ID = MAG_ID and K_ENABLED = 1)');
                  QuerySym.SQL.Add('join GENPOSTE on (POS_MAGID = MAG_ID)');
                  QuerySym.SQL.Add('join CSHSESSION on (SES_POSID = POS_ID)');
                  QuerySym.SQL.Add('join CSHTICKET on (TKE_SESID = SES_ID)');
                  QuerySym.SQL.Add('join CSHTICKETL on (TKL_TKEID = TKE_ID)  join K on (K_ID = TKL_ID and K_ENABLED = 1)');
                  QuerySym.SQL.Add('join ARTARTICLE on (TKL_ARTID = ART_ID)');
                  QuerySym.SQL.Add('join PLXCOULEUR on (TKL_COUID = COU_ID)');
                  QuerySym.SQL.Add('join PLXTAILLESGF on (TKL_TGFID = TGF_ID)');
                  QuerySym.SQL.Add('where MAG_ID <> 0');
                  QuerySym.SQL.Add('and (TKE_DATE >= :DATE_DEBUT and TKE_DATE <= :DATE_FIN)');
                  QuerySym.SQL.Add('and ART_CENTRALE <> 0');
                  QuerySym.SQL.Add('group by MAG_CODEADH, ART_REFMRK, COU_CODE, TGF_CODE');
                  QuerySym.SQL.Add('union');
                  QuerySym.SQL.Add('select MAG_CODEADH, ART_REFMRK, COU_CODE, TGF_CODE');
                  QuerySym.SQL.Add('from GENMAGASIN join K on (K_ID = MAG_ID and K_ENABLED = 1)');
                  QuerySym.SQL.Add('join NEGFACTURE on (FCE_MAGID = MAG_ID)');
                  QuerySym.SQL.Add('join NEGFACTUREL on (FCL_FCEID = FCE_ID)  join K on (K_ID = FCE_ID and K_ENABLED = 1)');
                  QuerySym.SQL.Add('join ARTARTICLE on (FCL_ARTID = ART_ID)');
                  QuerySym.SQL.Add('join PLXCOULEUR on (FCL_COUID = COU_ID)');
                  QuerySym.SQL.Add('join PLXTAILLESGF on (FCL_TGFID = TGF_ID)');
                  QuerySym.SQL.Add('where MAG_ID <> 0');
                  QuerySym.SQL.Add('and (FCE_DATE >= :DATE_DEBUT and FCE_DATE <= :DATE_FIN)');
                  QuerySym.SQL.Add('and ART_CENTRALE <> 0');
                  QuerySym.SQL.Add('group by MAG_CODEADH, ART_REFMRK, COU_CODE, TGF_CODE');
                  try
                    QuerySym.ParamByName('DATE_DEBUT').AsDateTime := DateTimePickerDebut.DateTime;
                    QuerySym.ParamByName('DATE_FIN').AsDateTime := DateTimePickerFin.DateTime;
                    QuerySym.Open;
                  except
                    on E: Exception do
                    begin
                      AjoutLog('Erreur :  la recherche des articles vendus a échoué !' + #13#10 + E.Message);
                      QueryMdc.Next;
                      pb_Progress.Position := pb_Progress.Position + 1;
                      Continue;
                    end;
                  end;
                  if not QuerySym.IsEmpty then
                  begin
                    QuerySym.First;
                    sCodeAdherent := QuerySym.FieldByName('MAG_CODEADH').AsString;      sListe := '';
                    while not QuerySym.Eof do
                    begin
                      // Changement de magasin.
                      if QuerySym.FieldByName('MAG_CODEADH').AsString <> sCodeAdherent then
                      begin
                        sNomFichier := 'ArticlesVendus-' + FormatDateTime('ddmmyyyy', DateTimePickerDebut.Date) + '-' + FormatDateTime('ddmmyyyy', DateTimePickerFin.Date) + '-' + StringReplace(sCodeAdherent, '/', '-', [rfReplaceAll]) + '.csv';
                        GenererFichier(sNomFichier, sListe);
                        sCodeAdherent := QuerySym.FieldByName('MAG_CODEADH').AsString;      sListe := '';
                      end
                      else
                        sListe := sListe + QuerySym.FieldByName('MAG_CODEADH').AsString + #9 + LPAD(QuerySym.FieldByName('ART_REFMRK').AsString, 7, ' ') + LPAD(QuerySym.FieldByName('COU_CODE').AsString, 3, ' ') + LPAD(QuerySym.FieldByName('TGF_CODE').AsString, 5, ' ') + #13#10;

                      QuerySym.Next;
                    end;

                    // Si dernier magasin.
                    if sListe <> '' then
                    begin
                      sNomFichier := 'ArticlesVendus-' + FormatDateTime('ddmmyyyy', DateTimePickerDebut.Date) + '-' + FormatDateTime('ddmmyyyy', DateTimePickerFin.Date) + '-' + StringReplace(sCodeAdherent, '/', '-', [rfReplaceAll]) + '.csv';
                      GenererFichier(sNomFichier, sListe);
                    end;
                  end
                  else
                  begin
                    // Recherche du code adhérent.
                    QuerySym.Close;
                    QuerySym.SQL.Clear;
                    QuerySym.SQL.Add('select MAG_CODEADH');
                    QuerySym.SQL.Add('from GENMAGASIN join K on (K_ID = MAG_ID and K_ENABLED = 1)');
                    QuerySym.SQL.Add('where MAG_ID <> 0');
                    try
                      QuerySym.Open;
                    except
                      on E: Exception do
                      begin
                        AjoutLog('Erreur :  la recherche du code adhérent a échoué !');
                        QueryMdc.Next;
                        pb_Progress.Position := pb_Progress.Position + 1;
                        Continue;
                      end;
                    end;
                    if not QuerySym.IsEmpty then
                    begin
                      sNomFichier := 'ArticlesVendus-' + FormatDateTime('ddmmyyyy', DateTimePickerDebut.Date) + '-' + FormatDateTime('ddmmyyyy', DateTimePickerFin.Date) + '-' + StringReplace(QuerySym.FieldByName('MAG_CODEADH').AsString, '/', '-', [rfReplaceAll]) + '.csv';
                      GenererFichier(sNomFichier, '');
                    end
                    else
                      AjoutLog('Erreur :  pas de code adhérent trouvé !');
                  end;
                finally
                  QuerySym.Free;
                end;
              finally
                ConnexionSym.Free;
              end;

              nDuree := (GetTickCount - nDebut);
              AjoutLog('>> ' + FormatFloat(',#00', (nDuree div 1000 div 60)) + ':' + FormatFloat('00', nDuree div 1000 mod 60) + ':' + FormatFloat('0000', nDuree mod 1000));

              QueryMdc.Next;
              pb_Progress.Position := pb_Progress.Position + 1;
              Application.ProcessMessages;
            end;
          end
          else
            Application.MessageBox(PChar('Erreur :  pas de bases trouvées !'), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        end
        else
          Application.MessageBox(PChar('Erreur :  pas de bases trouvées !'), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      finally
        QueryMdc.Free;
      end;
    finally
      ConnexionMdc.Free;
    end;

    AjoutLog('Fin extraction articles vendus.');
  finally
    GestionInterface(True);
    BtnArticlesVendus.Enabled := True;
  end;
end;

procedure Tfrm_Main.btn_SaveListClick(Sender: TObject);
var
  Save : TSaveDialog;
  Fichier : TextFile;
  Line : string;
  i, j : integer;
begin
  try
    Save := TSaveDialog.Create(Self);
    Save.Filter := 'Fichier CSV|*.csv';
    Save.DefaultExt := '.csv';
    if Save.Execute() then
    begin
      try
        AssignFile(Fichier, Save.FileName);
        Rewrite(Fichier);

        // entete
        Line := '';
        for i := 0 to lv_ListeMagasins.Columns.Count -1 do
          Line := Line + lv_ListeMagasins.Columns[i].Caption + ';';
        Writeln(Fichier, Line);

        // lignes
        for i := 0 to lv_ListeMagasins.Items.Count -1 do
        begin
          Line := lv_ListeMagasins.Items[i].Caption + ';';
          for j := 0 to lv_ListeMagasins.Items[i].SubItems.Count -1 do
            Line := Line + lv_ListeMagasins.Items[i].SubItems[j] + ';';
          Writeln(Fichier, Line);
        end;
      finally
        CloseFile(Fichier);
      end;
    end;
  finally
    FreeAndNil(Save);
  end;

  AjoutLog('Export terminé !');
end;

procedure Tfrm_Main.Btn_ListeMagISFClick(Sender: TObject);
var
  Fichier: TextFile;
  sLigne: String;
  i: Integer;
begin
  if not System.SysUtils.DirectoryExists(sCheminExport) then
  begin
    AjoutLog('Le répertoire [' + sCheminExport + '] n''existe pas !');
    if not System.SysUtils.ForceDirectories(sCheminExport) then
    begin
      AjoutLog('Erreur :  la création du chemin [' + sCheminExport + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
      if Visible then
        Application.MessageBox(PChar('Erreur :  la création du chemin [' + sCheminExport + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError)), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      sCheminExport := ExtractFilePath(Application.ExeName);
    end;
  end;

  Btn_ListeMagISF.Enabled := False;
  try
    // Génération fichier.
    AssignFile(Fichier, IncludeTrailingPathDelimiter(sCheminExport) + 'ListeMagMDC_' + FormatDateTime('YYYYMMDD_HHNNSS', Now) + '.csv');
    try
      Rewrite(Fichier);

      // Entête.
      sLigne := 'DOSSIER;VILLE;MAGASIN;CODE GINKOIA;CODE SOCIETAIRE IF;CODE CETELEM;SRV REPLIC;CODE MDC;MDC ACTIF;BI-OLD ACTIF;BI-15 ACTIF;BASE SENDER;URL_WS_KDO;BASE_TAMPON;SERVEUR;LECTEUR;GRP PUMP;GRP TARIF;GRP CLIENT;GRP FID;';
      Writeln(Fichier, sLigne);

      // Lignes.
      for i:=0 to Pred(lv_ListeMagasins.Items.Count) do
      begin
        if lv_ListeMagasins.Items[i].SubItems.Count >= 15 then
        begin
          sLigne := lv_ListeMagasins.Items[i].SubItems[1] + ';';      // Nom Groupe.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[12] + ';';      // Ville.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[7] + ';';      // Nom Magasin.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[13] + ';';      // Code Tiers.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[6] + ';';      // Code Magasin.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[10] + ';';      // Code CETELEM.
          sLigne := sLigne + lv_ListeMagasins.Items[i].Caption + ';';      // Serveur.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[4] + ';';      // Code MDC.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[5] + ';';      // MDC Actif.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[9] + ';';      // Mag. Actif.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[14] + ';';      // BI-15 Actif.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[15] + ';';      // Base sender.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[11] + ';';      // URL WebService.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[16] + ';';      // Chemin base tampon.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[17] + ';';      // Serveur.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[18] + ';';      // Lecteur.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[19] + ';';      // Groupe pump.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[20] + ';';      // Groupe tarif.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[21] + ';';      // Groupe client.
          sLigne := sLigne + lv_ListeMagasins.Items[i].SubItems[22] + ';';      // Groupe fid.
          Writeln(Fichier, sLigne);
        end;
      end;
    finally
      CloseFile(Fichier);
    end;
  finally
    Btn_ListeMagISF.Enabled := True;
  end;

  AjoutLog('Export "Liste mag ISF" terminé !');
  if Visible then
    Application.MessageBox('Export terminé !', PChar(Caption + ' - message'), MB_ICONINFORMATION + MB_OK);
end;

procedure Tfrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// Traitement !

function Tfrm_Main.TraitementListe(out error: String): Boolean;
const
  marge = 14;
var
  ConnexionMdc, ConnexionSym: TFDConnection;
  QueryMdc, QuerySym, QueryTmp: TFDQuery;
  Item: TListItem;
  i, nBI15Actif: Integer;
  sCodeTiers, sBaseSender, sCheminBaseTampon, sServeur, sLecteur: String;
begin
  result := false;
  error := '';
  lv_ListeMagasins.Items.Clear();
  lv_ListeMagasins.SortType := stNone;
  FSortIdx := 0;

  AjoutLog('Début traitement.');
  try
    lv_ListeMagasins.Items.BeginUpdate();
    try
      LabelEtape.Caption := 'Connexion ...';
      pb_Progress.Position := 0;
      Application.ProcessMessages;

      try
        ConnexionMdc := TFDConnection.Create(nil);
        ConnexionMdc.DriverName := 'IB';
        ConnexionMdc.Params.Clear();
        ConnexionMdc.Params.Add('Server=' + edt_Serveur.Text);
        ConnexionMdc.Params.Add('port=3050');
        ConnexionMdc.Params.Add('Database=' + edt_Database.Text);
        ConnexionMdc.Params.Add('User_Name=sysdba');
        ConnexionMdc.Params.Add('Password=masterkey');
        ConnexionMdc.Params.Add('Protocol=TCPIP');
        ConnexionMdc.Params.Add('DriverID=IB');
        ConnexionMdc.Open();

        QueryMdc := TFDQuery.Create(nil);
        QueryMdc.Connection := ConnexionMdc;
        QueryMdc.SQL.Text := 'select count(*) from DOSSIERS';
        QueryMdc.Open;
        if not QueryMdc.IsEmpty then
        begin
          pb_Progress.Max := QueryMdc.Fields[0].AsInteger;
          LabelEtape.Caption := 'Recherche des bases ...';
          Application.ProcessMessages;

          QueryMdc.Close;
          QueryMdc.SQL.Clear;
          QueryMdc.SQL.Text := 'select DOS_CODEGROUPEBI, DOS_NOM, DOS_ACTIFBI, DOS_GROUPE, DOS_ACTIF, '
                             + 'upper(f_left(dos_basepath, f_substr('':'', dos_basepath))) as server, '
                             + 'upper(f_right(dos_basepath, f_stringlength(dos_basepath) - f_substr('':'', dos_basepath) -1)) as datafile '
                             + 'from dossiers '
                             + 'order by 4, 2;';
//                             + 'order by 4, 2'
//                             + 'rows 5;';
          QueryMdc.Open;
          pb_Progress.Position := 0;
          while not QueryMdc.Eof do
          begin
            LabelEtape.Caption := 'Traitement de [ ' + QueryMdc.FieldByName('datafile').AsString + ' ] ...';
            Application.ProcessMessages;

            if(rg_ActiveBI.ItemIndex = 2) or (rg_ActiveBI.ItemIndex = QueryMdc.FieldByName('dos_actifbi').AsInteger) then
            begin
              try
                try
                  ConnexionSym := TFDConnection.Create(nil);
                  ConnexionSym.DriverName := 'IB';
                  ConnexionSym.Params.Clear();
                  ConnexionSym.Params.Add('Server=' + QueryMdc.FieldByName('server').AsString + '.no-ip.org');
                  ConnexionSym.Params.Add('port=3050');
                  ConnexionSym.Params.Add('Database=' + QueryMdc.FieldByName('datafile').AsString);
                  ConnexionSym.Params.Add('User_Name=ginkoia');
                  ConnexionSym.Params.Add('Password=ginkoia');
                  ConnexionSym.Params.Add('Protocol=TCPIP');
                  ConnexionSym.Params.Add('DriverID=IB');
                  ConnexionSym.Open();

                  QuerySym := TFDQuery.Create(nil);
                  QuerySym.Connection := ConnexionSym;
                  QueryTmp := TFDQuery.Create(nil);
                  QueryTmp.Connection := ConnexionSym;

                  QuerySym.SQL.Text := 'select MAG_ID, mag_codeadh, mag_nom, mag_enseigne, '
                                     + '      (select prm_float '
                                     + '       from genparam join k on k_id = prm_id and k_enabled = 1 '
                                     + '       where prm_type = 3 and prm_code = 67 and prm_magid = genmagasin.mag_id '
                                     + '      ) as magactif, '
                                     + '      (select PRM_STRING '
                                     + '       from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1 '
                                     + '       where PRM_MAGID = GENMAGASIN.MAG_ID and PRM_TYPE = 13 and PRM_CODE = 4) as CODE_CETELEM, '
                                     + '      (select PRM_STRING '
                                     + '       from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1 '
                                     + '       where PRM_MAGID = GENMAGASIN.MAG_ID and PRM_TYPE = 13 and PRM_CODE = 15) as URL_WEB_SERVICE, '
                                     + '       VIL_NOM, GCP_NOM as GRP_PUMP, TVT_NOM as GRP_TARIF, GCL_NOM as GRP_CLIENT, GCF_NOM as GRP_FID '
                                     + 'from GENMAGASIN join K on K_ID = MAG_ID and K_ENABLED = 1 '
                                     + 'join GENADRESSE on ADR_ID = MAG_ADRID '
                                     + 'join GENVILLE on VIL_ID = ADR_VILID '
                                     + 'join (GENMAGGESTIONPUMP join K on K_ID = MPU_ID and K_ENABLED = 1) on MPU_MAGID = MAG_ID '
                                     + 'join GENGESTIONPUMP on GCP_ID = MPU_GCPID '
                                     + 'left join (TARVENTE join K on K_ID = TVT_ID and K_ENABLED = 1) on TVT_ID = MAG_TVTID '
                                     + 'left join ((GENMAGGESTIONCLT join K on K_ID = MGC_ID and K_ENABLED = 1) join GENGESTIONCLT on GCL_ID = MGC_GCLID) on MGC_MAGID = MAG_ID '
                                     + 'left join ((GENMAGGESTIONCF join K on K_ID = MCF_ID and K_ENABLED = 1) join GENGESTIONCARTEFID on GCF_ID = MCF_GCFID) on MCF_MAGID = MAG_ID '
                                     + 'where MAG_ID != 0 '
                                     + 'order by mag_codeadh, mag_nom;';
                  QuerySym.Open;
                  if QuerySym.IsEmpty then
                    raise Exception.Create('### Erreur :  pas de données trouvées !')
                  else
                  begin
                    while not QuerySym.Eof do
                    begin
                      // Recherche du code tiers (si renseigné).
                      QueryTmp.Close;
                      QueryTmp.SQL.Clear;
                      QueryTmp.SQL.Add('select BAS_CODETIERS');
                      QueryTmp.SQL.Add('from GENBASES');
                      QueryTmp.SQL.Add('where BAS_MAGID = :MAG_ID');
                      QueryTmp.SQL.Add('and upper(BAS_NOM) like ''%SERVEUR%''');
                      QueryTmp.ParamByName('MAG_ID').AsInteger := QuerySym.FieldByName('MAG_ID').AsInteger;
                      try
                        QueryTmp.Open;
                        if QueryTmp.IsEmpty then
                          sCodeTiers := ''
                        else
                          sCodeTiers := QueryTmp.FieldByName('BAS_CODETIERS').AsString;
                      finally
                        QueryTmp.Close;
                      end;

                      // Recherche si BI-15 Actif.
                      nBI15Actif := 0;
                      QueryTmp.Close;
                      QueryTmp.SQL.Clear;
                      QueryTmp.SQL.Add('select PRM_INTEGER, PRM_FLOAT');
                      QueryTmp.SQL.Add('from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1');
                      QueryTmp.SQL.Add('where PRM_MAGID = :MAG_ID and PRM_TYPE = 25 and PRM_CODE = 1');
                      QueryTmp.ParamByName('MAG_ID').AsInteger := QuerySym.FieldByName('MAG_ID').AsInteger;
                      try
                        QueryTmp.Open;
                        if not QueryTmp.IsEmpty then
                        begin
                          if QueryTmp.FieldByName('PRM_INTEGER').AsInteger = 1 then
                            nBI15Actif := 1
                          else if QueryTmp.FieldByName('PRM_FLOAT').AsFloat > 2 then
                            nBI15Actif := 1;
                        end;
                      finally
                        QueryTmp.Close;
                      end;

                      // Recherche base sender.
                      QueryTmp.Close;
                      QueryTmp.SQL.Clear;
                      QueryTmp.SQL.Add('select BAS_SENDER');
                      QueryTmp.SQL.Add('from GENBASES');
                      QueryTmp.SQL.Add('where BAS_ID in (select PRM_INTEGER');
                      QueryTmp.SQL.Add('                 from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1');
                      QueryTmp.SQL.Add('                 where PRM_MAGID = :MAG_ID and PRM_TYPE = 25 and PRM_CODE = 2)');
                      QueryTmp.ParamByName('MAG_ID').AsInteger := QuerySym.FieldByName('MAG_ID').AsInteger;
                      try
                        QueryTmp.Open;
                        if QueryTmp.IsEmpty then
                          sBaseSender := ''
                        else
                          sBaseSender := QueryTmp.FieldByName('BAS_SENDER').AsString;
                      finally
                        QueryTmp.Close;
                      end;

                      // Recherche du chemin de la base tampon (si renseigné).
                      QueryTmp.Close;
                      QueryTmp.SQL.Clear;
                      QueryTmp.SQL.Add('select coalesce(PRM_STRING, ''Non paramétré'') as CHEMIN_BASE_TAMPON');
                      QueryTmp.SQL.Add('from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1');
                      QueryTmp.SQL.Add('where PRM_MAGID = :MAG_ID and PRM_TYPE = 25 and PRM_CODE = 5');
                      QueryTmp.ParamByName('MAG_ID').AsInteger := QuerySym.FieldByName('MAG_ID').AsInteger;
                      try
                        QueryTmp.Open;
                        if(QueryTmp.IsEmpty) or (QueryTmp.FieldByName('CHEMIN_BASE_TAMPON').AsString = '') then
                          sCheminBaseTampon := 'Non paramétré'
                        else
                          sCheminBaseTampon := QueryTmp.FieldByName('CHEMIN_BASE_TAMPON').AsString;
                      finally
                        QueryTmp.Close;
                      end;

                      // Recherche du serveur.
                      QueryTmp.Close;
                      QueryTmp.SQL.Clear;
                      QueryTmp.SQL.Add('select PRM_STRING as SERVEUR, PRM_INFO as LECTEUR');
                      QueryTmp.SQL.Add('from GENPARAM join K on K_ID = PRM_ID and K_ENABLED = 1');
                      QueryTmp.SQL.Add('where PRM_MAGID = :MAG_ID and PRM_TYPE = 3 and PRM_CODE = 110');
                      QueryTmp.ParamByName('MAG_ID').AsInteger := QuerySym.FieldByName('MAG_ID').AsInteger;
                      try
                        QueryTmp.Open;
                        if QueryTmp.IsEmpty then
                        begin
                          sServeur := '';
                          sLecteur := '';
                        end
                        else
                        begin
                          sServeur := QueryTmp.FieldByName('SERVEUR').AsString;
                          sLecteur := QueryTmp.FieldByName('LECTEUR').AsString;
                        end;
                      finally
                        QueryTmp.Close;
                      end;


                      Item := lv_ListeMagasins.Items.Add;

                      Item.Caption := QueryMdc.FieldByName('server').AsString;   // serveur
                      Item.SubItems.Add(QueryMdc.FieldByName('dos_codegroupebi').AsString);   // code grp
                      Item.SubItems.Add(QueryMdc.FieldByName('dos_nom').AsString);   // nom dossier
                      Item.SubItems.Add(QueryMdc.FieldByName('datafile').AsString);   // fichier
                      Item.SubItems.Add(IfThen(QueryMdc.FieldByName('dos_actifbi').AsInteger = 1, 'oui', 'non'));
                      Item.SubItems.Add(QueryMdc.FieldByName('DOS_GROUPE').AsString);   // Code MDC
                      Item.SubItems.Add(QueryMdc.FieldByName('DOS_ACTIF').AsString);   // MDC Actif

                      Item.SubItems.Add(QuerySym.FieldByName('mag_codeadh').AsString);   // code adh
                      Item.SubItems.Add(QuerySym.FieldByName('mag_nom').AsString);       // nom
                      Item.SubItems.Add(QuerySym.FieldByName('mag_enseigne').AsString);   // enseigne
                      Item.SubItems.Add(IfThen(QuerySym.FieldByName('magactif').AsInteger = 1, 'oui', 'non'));
                      Item.SubItems.Add(QuerySym.FieldByName('CODE_CETELEM').AsString);   // Code CETELEM
                      Item.SubItems.Add(QuerySym.FieldByName('URL_WEB_SERVICE').AsString);   // URL WebService
                      Item.SubItems.Add(QuerySym.FieldByName('VIL_NOM').AsString);   // Ville
                      Item.SubItems.Add(sCodeTiers);   // Code Tiers
                      Item.SubItems.Add(IfThen(nBI15Actif = 1, 'oui', 'non'));   // BI-15 Actif
                      Item.SubItems.Add(sBaseSender);   // Base sender
                      Item.SubItems.Add(sCheminBaseTampon);   // Chemin base tampon
                      Item.SubItems.Add(sServeur);   // Serveur
                      Item.SubItems.Add(sLecteur);   // Lecteur
                      Item.SubItems.Add(QuerySym.FieldByName('GRP_PUMP').AsString);   // Groupe pump
                      Item.SubItems.Add(QuerySym.FieldByName('GRP_TARIF').AsString);   // Groupe tarif
                      Item.SubItems.Add(QuerySym.FieldByName('GRP_CLIENT').AsString);   // Groupe client
                      Item.SubItems.Add(QuerySym.FieldByName('GRP_FID').AsString);   // Groupe fid

                      lv_ListeMagasins.Columns[0].Width := Max(lv_ListeMagasins.Columns[0].Width, lv_ListeMagasins.Canvas.TextWidth(Item.Caption) + marge);
                      for i := 1 to lv_ListeMagasins.Columns.Count -1 do
                        lv_ListeMagasins.Columns[i].Width := Max(lv_ListeMagasins.Columns[i].Width, lv_ListeMagasins.Canvas.TextWidth(Item.SubItems[i - 1]) + marge);

                      QuerySym.Next;
                      Application.ProcessMessages;
                    end;
                  end;
                finally
                  FreeAndNil(QueryTmp);
                  FreeAndNil(QuerySym);
                  ConnexionSym.Close();
                  FreeAndNil(ConnexionSym);
                end;
              except
                on E: Exception do
                begin
                  Item := lv_ListeMagasins.Items.Add();

                  Item.Caption := QueryMdc.FieldByName('server').AsString;   // serveur
                  Item.SubItems.Add('');   // code grp
                  Item.SubItems.Add(QueryMdc.FieldByName('dos_nom').AsString);   // nom dossier
                  Item.SubItems.Add(QueryMdc.FieldByName('datafile').AsString);   // fichier
                  Item.SubItems.Add('');
                  Item.SubItems.Add('');   // Code MDC
                  Item.SubItems.Add('');   // MDC Actif

                  Item.SubItems.Add('');   // code adh
                  Item.SubItems.Add(E.ClassName);       // nom
                  Item.SubItems.Add(StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]));   // enseigne
                  Item.SubItems.Add('');
                  Item.SubItems.Add('');   // Code CETELEM
                  Item.SubItems.Add('');   // URL WebService
                  Item.SubItems.Add('');   // Ville
                  Item.SubItems.Add('');   // Code Tiers
                  Item.SubItems.Add('');   // BI-15 Actif
                  Item.SubItems.Add('');   // Base sender
                  Item.SubItems.Add('');   // Chemin base tampon
                  Item.SubItems.Add('');   // Serveur
                  Item.SubItems.Add('');   // Lecteur
                  Item.SubItems.Add('');   // Groupe pump
                  Item.SubItems.Add('');   // Groupe tarif
                  Item.SubItems.Add('');   // Groupe client
                  Item.SubItems.Add('');   // Groupe fid

                  lv_ListeMagasins.Columns[0].Width := Max(lv_ListeMagasins.Columns[0].Width, lv_ListeMagasins.Canvas.TextWidth(Item.Caption) + marge);
                  for i := 1 to lv_ListeMagasins.Columns.Count -1 do
                    lv_ListeMagasins.Columns[i].Width := Max(lv_ListeMagasins.Columns[i].Width, lv_ListeMagasins.Canvas.TextWidth(Item.SubItems[i -1]) + marge);
                end;
              end;
            end;
            AjoutLog('Traitement de [ ' + QueryMdc.FieldByName('datafile').AsString + ' ]');

            QueryMdc.Next;
            pb_Progress.Position := pb_Progress.Position + 1;
            Application.ProcessMessages();
          end;
        end;

        Result := true;
      finally
        FreeAndNil(QueryMdc);
        ConnexionMdc.Close();
        FreeAndNil(ConnexionMdc);
      end;
    except
      on E: Exception do
      begin
        error := 'exception : "' + E.ClassName + '" - "' + E.Message + '"';
        AjoutLog(error);
      end;
    end;
  finally
    lv_ListeMagasins.Items.EndUpdate();
    pb_Progress.Position := 0;
    LabelEtape.Caption := '';
    AjoutLog('Fin traitement.');
  end;
end;

function Tfrm_Main.TraitementFixe(out error : string) : boolean;
var
  ConnexionMdc : TFDConnection;
  TransactionMdc : TFDTransaction;
  QueryMdc : TFDQuery;
begin
  Result := false;
  try
    try
      ConnexionMdc := TFDConnection.Create(nil);
      ConnexionMdc.DriverName := 'IB';
      ConnexionMdc.Params.Clear();
      ConnexionMdc.Params.Add('Server=' + edt_Serveur.Text);
      ConnexionMdc.Params.Add('port=3050');
      ConnexionMdc.Params.Add('Database=' + edt_Database.Text);
      ConnexionMdc.Params.Add('User_Name=sysdba');
      ConnexionMdc.Params.Add('Password=masterkey');
      ConnexionMdc.Params.Add('Protocol=TCPIP');
      ConnexionMdc.Params.Add('DriverID=IB');
      ConnexionMdc.Open();

      TransactionMdc := TFDTransaction.Create(nil);
      TransactionMdc.Connection := ConnexionMdc;
      TransactionMdc.StartTransaction();
      try
        QueryMdc := TFDQuery.Create(nil);
        QueryMdc.Connection := ConnexionMdc;
        QueryMdc.Transaction := TransactionMdc;

        QueryMdc.SQL.Clear();
        QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_LEFT');
        QueryMdc.SQL.Add('    CSTRING(254),');
        QueryMdc.SQL.Add('    INTEGER');
        QueryMdc.SQL.Add('RETURNS CSTRING(254)');
        QueryMdc.SQL.Add('ENTRY_POINT ''Left'' MODULE_NAME ''FreeUDFLib.dll'';');
        QueryMdc.ExecSQL();

        QueryMdc.SQL.Clear();
        QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_RIGHT');
        QueryMdc.SQL.Add('    CSTRING(254),');
        QueryMdc.SQL.Add('    INTEGER');
        QueryMdc.SQL.Add('RETURNS CSTRING(254)');
        QueryMdc.SQL.Add('ENTRY_POINT ''Right'' MODULE_NAME ''FreeUDFLib.dll'';');
        QueryMdc.ExecSQL();

        QueryMdc.SQL.Clear();
        QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_SUBSTR');
        QueryMdc.SQL.Add('    CSTRING(254),');
        QueryMdc.SQL.Add('    CSTRING(254)');
        QueryMdc.SQL.Add('RETURNS INTEGER BY VALUE');
        QueryMdc.SQL.Add('ENTRY_POINT ''SubStr'' MODULE_NAME ''FreeUDFLib.dll'';');
        QueryMdc.ExecSQL();

        QueryMdc.SQL.Clear();
        QueryMdc.SQL.Add('DECLARE EXTERNAL FUNCTION F_STRINGLENGTH');
        QueryMdc.SQL.Add('    CSTRING(254)');
        QueryMdc.SQL.Add('RETURNS INTEGER BY VALUE');
        QueryMdc.SQL.Add('ENTRY_POINT ''StringLength'' MODULE_NAME ''FreeUDFLib.dll'';');
        QueryMdc.ExecSQL();

        TransactionMdc.Commit();
        Result := true;
      except
        TransactionMdc.Rollback();
        raise;
      end;
    finally
      FreeAndNil(QueryMdc);
      FreeAndNil(TransactionMdc);
      ConnexionMdc.Close();
      FreeAndNil(ConnexionMdc);
    end;
  except
    on e : Exception do
      error := 'exception : "' + e.ClassName + '" - "' + e.Message + '"';
  end;
end;

// fonctions utilitaires

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
var
  CanDo : boolean;
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  try
    // blocage temporaire
    Self.Enabled := False;

    lbl_Serveur.Enabled := Enabled;
    edt_Serveur.Enabled := Enabled;

    lbl_Database.Enabled := Enabled;
    edt_Database.Enabled := Enabled;

    rg_ActiveBI.Enabled := Enabled;

    PanelArticlesVendus.Enabled := Enabled;
    LabelDebut.Enabled := Enabled;
    LabelFin.Enabled := Enabled;

    btn_SaveList.Enabled := Enabled;
    Btn_ListeMagISF.Enabled := Enabled;

    CanDo := Enabled and
             (Trim(edt_Serveur.Text) <> '') and
             ((Trim(edt_Database.Text) <> '') and CanConnect(edt_Serveur.Text, edt_Database.Text));

    btn_Lister.Enabled := CanDo;
    btn_Fixe.Enabled := CanDo;

    btn_Quitter.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.CanConnect(Serveur, DataBaseFile : string) : boolean;
var
  Connexion : TFDConnection;
begin
  Result := false;

  if (Trim(Serveur) <> '') and (Trim(DataBaseFile) <> '') then
  begin
    try
      try
        Connexion := TFDConnection.Create(Self);
        Connexion.DriverName := 'IB';
        Connexion.Params.Clear();
        Connexion.Params.Add('Server=' + Serveur);
        Connexion.Params.Add('Port=3050');
        Connexion.Params.Add('Database=' + DataBaseFile);
        Connexion.Params.Add('User_Name=sysdba');
        Connexion.Params.Add('Password=masterkey');
        Connexion.Params.Add('Protocol=TCPIP');
        Connexion.Params.Add('DriverID=IB');
        Connexion.Open();
        if Connexion.Connected then
          Result := true;
      finally
        Connexion.Close();
        FreeAndNil(Connexion);
      end;
    except
      Result := false;
    end;
  end;
end;

procedure Tfrm_Main.AjoutLog(const sLigne: String; const bNouveau: Boolean);
var
  F: TextFile;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + 'ListeMagBI.log');
  try
    if bNouveau then
      Rewrite(F)
    else
      Append(F);
    Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + sLigne);
  finally
    CloseFile(F);
  end;
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Quitter.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  // arf !
end;

end.

