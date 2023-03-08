unit Main_Frm;

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
  Vcl.ComCtrls;

const
  WM_LAUNCH_AUTO = WM_APP + 11;

type
  Tfrm_Main = class(TForm)
    lbl_Source: TLabel;
    edt_SourceServeur: TEdit;
    lbl_Destination: TLabel;
    edt_DestinationServeur: TEdit;
    lbl_Filtre: TLabel;
    edt_Filtre: TEdit;
    btn_Copier: TButton;
    btn_Quitter: TButton;
    edt_SourceFile: TEdit;
    edt_DestinationFile: TEdit;
    dtp_Premier: TDateTimePicker;
    dtp_Second: TDateTimePicker;
    lbl_Planification: TLabel;
    btn_Plannification: TButton;
    lbl_Et: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure btn_CopierClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);

    procedure btn_PlannificationClick(Sender: TObject);
  private
    { Déclarations privées }
    FLogFile : string;
    FNbLigneLog : integer;
    FAuto : Boolean;

    procedure AddLog(msg : string);

    procedure GestionInterface(Enabled : Boolean);
    function Traitement() : boolean;

    procedure MessageTrtAuto(var msg : TMessage); message WM_LAUNCH_AUTO;
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

uses
  System.StrUtils,
  System.IniFiles,
  System.UITypes,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Option,
  uGestionBDD,
  LaunchProcess;

const
  POS_MARGIN = 50;

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  FNbLigneLog := 60;

  if FileExists(ChangeFileExt(ParamStr(0), '.ini')) then
  begin
    try
      IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      edt_SourceServeur.Text := IniFile.ReadString('SOURCE', 'SERVEUR', edt_SourceServeur.Text);
      edt_SourceFile.Text := IniFile.ReadString('SOURCE', 'FICHIER', edt_SourceFile.Text);
      edt_DestinationServeur.Text := IniFile.ReadString('DESTINATION', 'SERVEUR', edt_DestinationServeur.Text);
      edt_DestinationFile.Text := IniFile.ReadString('DESTINATION', 'FICHIER', edt_DestinationFile.Text);
      edt_Filtre.Text := IniFile.ReadString('FILTRE', 'FILTRE', edt_Filtre.Text);
      dtp_Premier.Time := IniFile.ReadTime('PLANIF', 'PREMIER', dtp_Premier.Time);
      dtp_Second.Time := IniFile.ReadTime('PLANIF', 'SECOND', dtp_Second.Time);
      FLogFile := IniFile.ReadString('LOG', 'FICHIER', FLogFile);
      FNbLigneLog := IniFile.ReadInteger('LOG', 'NBLIGNE', FNbLigneLog);
    finally
      FreeAndNil(IniFile);
    end;
  end;
  FAuto := FindCmdLineSwitch('AUTO');
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  if FAuto then
    PostMessage(Handle, WM_LAUNCH_AUTO, 0, 0);
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btn_Quitter.Enabled;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
var
  IniFile : TIniFile;
begin
  try
    IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    IniFile.WriteString('SOURCE', 'SERVEUR', edt_SourceServeur.Text);
    IniFile.WriteString('SOURCE', 'FICHIER', edt_SourceFile.Text);
    IniFile.WriteString('DESTINATION', 'SERVEUR', edt_DestinationServeur.Text);
    IniFile.WriteString('DESTINATION', 'FICHIER', edt_DestinationFile.Text);
    IniFile.WriteString('FILTRE', 'FILTRE', edt_Filtre.Text);
    IniFile.WriteTime('PLANIF', 'PREMIER', dtp_Premier.Time);
    IniFile.WriteTime('PLANIF', 'SECOND', dtp_Second.Time);
    IniFile.WriteString('LOG', 'FICHIER', FLogFile);
    IniFile.WriteInteger('LOG', 'NBLIGNE', FNbLigneLog);
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure Tfrm_Main.btn_CopierClick(Sender: TObject);
begin
  try
    GestionInterface(false);

    if Traitement() then
    begin
      if not FAuto then
        MessageDlgPos('Traitement effectué correctement.', mtInformation, [mbOK], 0, Self.Left + POS_MARGIN, Self.Top + POS_MARGIN);
      AddLog('Traitement effectué correctement.');
      ExitCode := 0;
    end
    else
    begin
      if not FAuto then
        MessageDlgPos('Erreur lors du traitement.', mtError, [mbOK], 0, Self.Left + POS_MARGIN, Self.Top + POS_MARGIN);
      AddLog('Erreur lors du traitement.');
      ExitCode := 1;
    end;
  finally
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

procedure Tfrm_Main.btn_PlannificationClick(Sender: TObject);

  function GetNomJourFrancais(Nom : string) : string;
  begin
    case IndexStr(Nom, ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']) of
      0 : Result := 'LUN';
      1 : Result := 'MAR';
      2 : Result := 'MER';
      3 : Result := 'JEU';
      4 : Result := 'VEN';
      5 : Result := 'SAM';
      6 : Result := 'DIM';
    end;
  end;

const
  BAT_NAME = 'TmpTask.bat' ;
Var
  cmds : TStringList;
  filename, error, Commande : string;
begin
  // schtasks /delete /TN "Test Benoit" /F
  // schtasks /Create /RU SYSTEM /SC DAILY /ST 15:30:00 /TN "Test Benoit" /TR notepad.exe
  cmds := TStringList.Create();
  try
    filename := ExtractFilePath(ParamStr(0)) + BAT_NAME;
    cmds.Add('schtasks /delete /TN "CopieDbMagPremier" /F');
    cmds.Add('schtasks /delete /TN "CopieDbMagSecond" /F');
    cmds.Add('schtasks /Create /RU SYSTEM /SC DAILY /ST ' + FormatDateTime('hh:nn:ss', dtp_Premier.Time) + ' /TN "CopieDbMagPremier" /TR "\"' + ParamStr(0) + '\" /AUTO"');
    cmds.Add('schtasks /Create /RU SYSTEM /SC DAILY /ST ' + FormatDateTime('hh:nn:ss', dtp_Second.Time) + ' /TN "CopieDbMagSecond" /TR "\"' + ParamStr(0) + '\" /AUTO"');
    cmds.SaveToFile(filename);
    ExecAndWaitProcess(error, filename, '');
    DeleteFile(filename);
  finally
    FreeAndNil(cmds);
  end;
end;

procedure Tfrm_Main.AddLog(msg : string);
var
  Log : TStringList;
begin
  try
    Log := TStringList.Create();
    if FileExists(FLogFile) then
      Log.LoadFromFile(FLogFile);
    Log.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - ' + msg);
    while Log.Count > FNbLigneLog do
      Log.Delete(0);
    Log.SaveToFile(FLogFile);
  finally
    FreeAndNil(Log);
  end;
end;

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  try
    // blocage temporaire
    Self.Enabled := False;

    lbl_Source.Enabled := Enabled;
    edt_SourceServeur.Enabled := Enabled;
    edt_SourceFile.Enabled := Enabled;
    lbl_Destination.Enabled := Enabled;
    edt_DestinationServeur.Enabled := Enabled;
    edt_DestinationFile.Enabled := Enabled;
    lbl_Filtre.Enabled := Enabled;
    edt_Filtre.Enabled := Enabled;
    lbl_Planification.Enabled := Enabled;
    dtp_Premier.Enabled := Enabled;
    lbl_Et.Enabled := Enabled;
    dtp_Second.Enabled := Enabled;
    btn_Plannification.Enabled := Enabled;
    btn_Copier.Enabled := Enabled;
    btn_Quitter.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

function Tfrm_Main.Traitement() : boolean;

  function GetFieldData(Field : TField) : string;
  begin
    if Field.IsNull then
      Result := 'NULL'
    else
    begin
      case Field.DataType of
        // non géré
        ftUnknown,
        ftVarBytes,
        ftBlob,
        ftMemo,
        ftGraphic,
        ftFmtMemo,
        ftParadoxOle,
        ftDBaseOle,
        ftTypedBinary,
        ftCursor,
        ftADT,
        ftArray,
        ftReference,
        ftDataSet,
        ftOraBlob,
        ftOraClob,
        ftVariant,
        ftInterface,
        ftIDispatch,
        ftGuid,
        ftWideMemo,
        ftOraInterval,
        ftConnection,
        ftParams,
        ftStream,
        ftObject
          : raise EConvertError.Create('Type non pris en charge');
        // string
        ftString,
        ftFixedChar,
        ftWideString,
        ftFixedWideChar
          : Result := QuotedStr(Field.AsString);
        // entier
        ftSmallint,
        ftInteger,
        ftWord,
        ftBytes,
        ftAutoInc,
        ftLargeint,
        ftLongWord,
        ftShortint,
        ftByte
          : Result := Field.AsString;
        // boolean
        ftBoolean
          : Result := BoolToStr(Field.AsBoolean, true);
        // flotant
        ftFloat,
        ftCurrency,
        ftBCD,
        ftFMTBcd,
        ftExtended,
        ftSingle
          : Result := StringReplace(Field.AsString, FormatSettings.DecimalSeparator, '.', []);
        // DateTime
        ftDate
          : Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Field.AsDateTime));
        ftTime
          : Result := QuotedStr(FormatDateTime('hh:nn:ss.zzz', Field.AsDateTime));
        ftDateTime,
        ftTimeStamp,
        ftOraTimeStamp,
        ftTimeStampOffset
          : Result := QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Field.AsDateTime));
      end;
    end;
  end;

var
  ConnexionSrc, ConnexionDst : TFDConnection;
  TransactionSrc, TransactionDst : TFDTransaction;
  QuerySrc, QueryDst : TFDQuery;
  i : integer;
begin
  Result := false;
  ConnexionSrc := nil;
  ConnexionDst := nil;
  TransactionSrc := nil;
  TransactionDst := nil;
  QuerySrc := nil;
  QueryDst := nil;

  try
    // connexion a la source
    try
      ConnexionSrc := GetNewConnexion(edt_SourceServeur.Text, edt_SourceFile.Text, 'sysdba', 'masterkey');
      TransactionSrc := GetNewTransaction(ConnexionSrc, false);
      QuerySrc := GetNewQuery(TransactionSrc);
    except
      on e : Exception do
      begin
        AddLog('Erreur de connexion a la source : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    // connexion a la destination
    try
      ConnexionDst := GetNewConnexion(edt_DestinationServeur.Text, edt_DestinationFile.Text, 'sysdba', 'masterkey');
      TransactionDst := GetNewTransaction(ConnexionDst, false);
      QueryDst := GetNewQuery(TransactionDst);
    except
      on e : Exception do
      begin
        AddLog('Erreur de connexion a la destination : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    //==========================================================================
    // nettoyage !!
    //==========================================================================

    // des dossiers
    try
      TransactionDst.StartTransaction();
      QueryDst.SQL.Text := 'delete from dossiers;';
      QueryDst.ExecSQL();
      TransactionDst.Commit();
    except
      on e : Exception do
      begin
        TransactionDst.Rollback();
        AddLog('Erreur de nettoyage (dossier) de la destination : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    // des params
    try
      TransactionDst.StartTransaction();
      QueryDst.SQL.Text := 'delete from params;';
      QueryDst.ExecSQL();
      TransactionDst.Commit();
    except
      on e : Exception do
      begin
        TransactionDst.Rollback();
        AddLog('Erreur de nettoyage (params) de la destination : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    //==========================================================================
    // Copie !!
    //==========================================================================

    // des dossiers
    try
      try
        TransactionSrc.StartTransaction();
        if (Trim(edt_Filtre.Text) = '') then
          QuerySrc.SQL.Text := 'select * from dossiers;'
        else
          QuerySrc.SQL.Text := 'select * from dossiers where ' + edt_Filtre.Text + ';';

        try
          QuerySrc.Open();
          if not QuerySrc.Eof then
          begin
            try
              TransactionDst.StartTransaction();
              while not QuerySrc.Eof do
              begin
                QueryDst.SQL.Clear();
                QueryDst.SQL.Add('insert into dossiers (');
                // nom des champs
                for i := 0 to QuerySrc.Fields.Count -1 do
                  if i = 0 then
                    QueryDst.SQL.Add(QuerySrc.Fields[i].FieldName)
                  else
                    QueryDst.SQL.Add(', ' + QuerySrc.Fields[i].FieldName);
                QueryDst.SQL.Add(') values (');
                // valeurs
                for i := 0 to QuerySrc.Fields.Count -1 do
                  if i = 0 then
                    QueryDst.SQL.Add(GetFieldData(QuerySrc.Fields[i]))
                  else
                    QueryDst.SQL.Add(', ' + GetFieldData(QuerySrc.Fields[i]));
                QueryDst.SQL.Add(');');
                QueryDst.ExecSQL();
                // suivant !!
                QuerySrc.Next();
              end;
              TransactionDst.Commit();
            except
              TransactionDst.Rollback();
              raise
            end;
          end;
        finally
          QuerySrc.Close();
        end;
      finally
        TransactionSrc.Rollback();
      end;
    except
      on e : Exception do
      begin
        AddLog('Erreur de copie (dossier) : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    // des params
    try
      try
        TransactionSrc.StartTransaction();
        QuerySrc.SQL.Text := 'select * from params;';

        try
          QuerySrc.Open();
          if not QuerySrc.Eof then
          begin
            try
              TransactionDst.StartTransaction();
              while not QuerySrc.Eof do
              begin
                QueryDst.SQL.Clear();
                QueryDst.SQL.Add('insert into params (');
                // nom des champs
                for i := 0 to QuerySrc.Fields.Count -1 do
                  if i = 0 then
                    QueryDst.SQL.Add(QuerySrc.Fields[i].FieldName)
                  else
                    QueryDst.SQL.Add(', ' + QuerySrc.Fields[i].FieldName);
                QueryDst.SQL.Add(') values (');
                // valeurs
                for i := 0 to QuerySrc.Fields.Count -1 do
                  if i = 0 then
                    QueryDst.SQL.Add(GetFieldData(QuerySrc.Fields[i]))
                  else
                    QueryDst.SQL.Add(', ' + GetFieldData(QuerySrc.Fields[i]));
                QueryDst.SQL.Add(');');
                QueryDst.ExecSQL();
                // suivant !!
                QuerySrc.Next();
              end;
              TransactionDst.Commit();
            except
              TransactionDst.Rollback();
              raise
            end;
          end;
        finally
          QuerySrc.Close();
        end;
      finally
        TransactionSrc.Rollback();
      end;
    except
      on e : Exception do
      begin
        AddLog('Erreur de copie (param) : ' + e.ClassName + ' - ' + e.Message);
        Exit;
      end;
    end;

    // si on arrive ici :
    Result := true;
  finally
    // source
    FreeAndNil(TransactionSrc);
    FreeAndNil(ConnexionSrc);
    FreeAndNil(QuerySrc);
    // destination
    FreeAndNil(TransactionDst);
    FreeAndNil(ConnexionDst);
    FreeAndNil(QueryDst);
  end;
end;

procedure Tfrm_Main.MessageTrtAuto(var msg : TMessage);
begin
  if btn_Copier.Enabled then
    btn_CopierClick(nil)
  else
    AddLog('Traitement impossible, bouton grisé.');
  btn_QuitterClick(nil);
end;

end.
