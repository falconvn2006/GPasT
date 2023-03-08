unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons,
  IB_Components,
  IBODataset, ComCtrls, ExtCtrls;

type
  TFrm_Main = class(TForm)
    Pgc_Choix: TPageControl;
    Tab_Script: TTabSheet;
    Tab_Patchs: TTabSheet;
    Chp_Max: TSpinEdit;
    Chp_Min: TSpinEdit;
    edt_RepPatch: TEdit;
    Lab_Max: TLabel;
    Lab_Min: TLabel;
    Lab_RepPatch: TLabel;
    Nbt_RepPatch: TSpeedButton;
    Pan_DataBase: TPanel;
    Lab_DataBase: TLabel;
    edt_Database: TEdit;
    Nbt_DataBase: TSpeedButton;
    Lab_Login: TLabel;
    edt_login: TEdit;
    Lab_Password: TLabel;
    edt_Password: TEdit;
    Pan_Control: TPanel;
    Pan_Logs: TPanel;
    Btn_Traitement: TButton;
    Btn_Quitter: TButton;
    mem_Logs: TMemo;
    pgb_Progression: TProgressBar;
    Nbt_SaveLog: TSpeedButton;
    Lab_FileScript: TLabel;
    edt_FileScript: TEdit;
    Nbt_FileScript: TSpeedButton;
    Tab_Patch: TTabSheet;
    Lab_: TLabel;
    edt_FilePatch: TEdit;
    Nbt_FilePatch: TSpeedButton;
    Panel1: TPanel;
    Chk_GoodVerif: TCheckBox;
    Chk_TransactionPatch: TCheckBox;
    Btn_Download: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_DatabaseChange(Sender: TObject);
    procedure Nbt_DataBaseClick(Sender: TObject);

    procedure edt_FileScriptChange(Sender: TObject);
    procedure Nbt_FileScriptClick(Sender: TObject);

    procedure edt_RepPatchChange(Sender: TObject);
    procedure Nbt_RepPatchClick(Sender: TObject);
    procedure Btn_DownloadClick(Sender: TObject);
    procedure Chp_MinChange(Sender: TObject);
    procedure Chp_MaxChange(Sender: TObject);
    procedure Chk_GoodVerifClick(Sender: TObject);

    procedure edt_FilePatchChange(Sender: TObject);
    procedure Nbt_FilePatchClick(Sender: TObject);

    procedure Nbt_SaveLogClick(Sender: TObject);

    procedure Btn_TraitementClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
  private
    { Déclarations privées }
    FVersions : TStringList;

    function VerifVersion() : boolean;
    function GetVersionBase() : string;
    function GetVersionsFromYellis() : TStringList;

    function GetNomFichier(numPatch : integer) : string;

    procedure DoScript();
    procedure DoPatchs();
    procedure DoPatchFile(aFilename : string);

    function DoPatch(aConnex : TIB_Connection ; aTrans : TIB_Transaction ; aFileName : string) : boolean ;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  FileCtrl,
  uGestionBDD,
  UPost,
  ShellAPI,
  Version_Frm,
  IdHTTP,
  IdURI,
  IdCompressorZLib;

{$R *.dfm}

const
  URL_SERVEUR_MAJ = 'lame2.no-ip.com';

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  // liste des version
  FVersions := GetVersionsFromYellis();
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Btn_Quitter.Enabled;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FVersions);
end;

// Fichier de base de données

procedure TFrm_Main.edt_DatabaseChange(Sender: TObject);
begin
  Btn_Traitement.Enabled := VerifVersion();
end;

procedure TFrm_Main.Nbt_DataBaseClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier Interbase (*.ib)|*.ib';
    Open.InitialDir := ExtractFilePath(edt_Database.Text);
    Open.FileName := ExtractFileName(edt_Database.Text);
    if Open.Execute() then
      edt_Database.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

// page de script

procedure TFrm_Main.edt_FileScriptChange(Sender: TObject);
begin
  Btn_Traitement.Enabled := VerifVersion();
end;

procedure TFrm_Main.Nbt_FileScriptClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier de script (*.scr)|*.scr';
    Open.InitialDir := ExtractFilePath(edt_FileScript.Text);
    Open.FileName := ExtractFileName(edt_FileScript.Text);
    if Open.Execute() then
      edt_FileScript.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

// page de patchs

procedure TFrm_Main.edt_RepPatchChange(Sender: TObject);
var
  numPatch : integer;
begin
  if DirectoryExists(edt_RepPatch.Text) then
  begin
    numPatch := 0;
    while FileExists(GetNomFichier(numPatch +1)) do
      Inc(numPatch);

    if numPatch > 0 then
    begin
      Chp_Min.Enabled := true;
      Chp_Max.Enabled := true;
      Chp_Min.Value := 1;
      Chp_Max.Value := numPatch;
      Btn_Traitement.Enabled := VerifVersion();
    end
    else
    begin
      Chp_Min.Enabled := false;
      Chp_Max.Enabled := false;
      Chp_Min.Value := 1;
      Chp_Max.Value := 9999;
      Btn_Traitement.Enabled := false;
    end;
  end
  else
  begin
    Chp_Min.Enabled := false;
    Chp_Max.Enabled := false;
    Chp_Min.Value := 1;
    Chp_Max.Value := 9999;
    Btn_Traitement.Enabled := false;
  end;
end;

procedure TFrm_Main.Nbt_RepPatchClick(Sender: TObject);
var
  ChosenDir : string;
begin
  if Trim(edt_RepPatch.Text) = '' then
    ChosenDir := ExtractFileDir(ParamStr(0))
  else
    ChosenDir := edt_RepPatch.Text;
  if SelectDirectory('Selectionnez un repertoir', '', ChosenDir) then
    edt_RepPatch.Text := ChosenDir;
end;

procedure TFrm_Main.Btn_DownloadClick(Sender: TObject);

  function DownloadHTTP(const AUrl, FileName : string) : boolean;
  var
    IdHTTP : TIdHTTP;
    IdCompres : TIdCompressorZLib;
    FileStream : TStream;
  begin
    Result := false;
    try
      IdHTTP :=  TIdHTTP.Create(nil);
      IdCompres := TIdCompressorZLib.Create();
      IdHTTP.Compressor := IdCompres;
      IdHTTP.HandleRedirects := true;
      IdHTTP.RedirectMaximum := 15;
      IdHTTP.Request.AcceptEncoding := 'gzip,deflate';
      IdHTTP.Request.ContentEncoding := 'gzip';
      FileStream := TFileStream.Create(FileName, fmCreate);
      try
        IdHTTP.Get(TIdURI.URLEncode(AUrl), FileStream);
        Result := true;
      except
        // ne rien faire ...
      end;
    finally
      FreeAndNil(FileStream);
      FreeAndNil(IdCompres);
      FreeAndNil(IdHTTP);
    end;
  end;

var
  Version, DestPath : string;
  Yellis : Tconnexion;
  Res : TStringList;
  MaxPatch, i : integer;
begin
  Version := SelectVersion(FVersions);
  if not (Trim(Version) = '') then
  begin
    try
      Self.Enabled := false;
      Screen.Cursor := crHourGlass;
      mem_Logs.Lines.Clear();
      pgb_Progression.Position := 0;
      pgb_Progression.Step := 1;
      Application.ProcessMessages();

      // recup du nombre de patch
      try
        Yellis := Tconnexion.Create();
        Res := Yellis.Select('Select patch from version where nomversion = ' + QuotedStr(Version) + ';');
        MaxPatch := StrToIntDef(Trim(Yellis.UneValeur(Res, 'patch', 0)), 0);
        Yellis.FreeResult(Res);
      finally
        FreeAndNil(Yellis);
      end;

      pgb_Progression.Max := MaxPatch;
      Application.ProcessMessages();

      // telechargement des patch (s'il y en a)
      if MaxPatch > 0 then
      begin
        if Trim(edt_RepPatch.Text) = '' then
          DestPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + Version)
        else
          DestPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(edt_RepPatch.Text) + Version);
        ForceDirectories(DestPath);
        for i := 1 to MaxPatch do
        begin
          if not DownloadHTTP('http://' + URL_SERVEUR_MAJ + '/maj/patch/' + Version + '/script' + Inttostr(i) + '.SQL', DestPath + 'script' + Inttostr(i) + '.SQL') then
          begin
            MessageDlg('Erreur au téléchargement du patch n°' + IntToStr(i), mtError, [mbOK], 0);
            Break;
          end;
          pgb_Progression.StepIt();
          Application.ProcessMessages();
        end;

        // set du repertoire
        edt_RepPatch.Text := DestPath;
      end
      else
        MessageDlg('Pas de patch à télécharger', mtWarning, [mbOK], 0);
    finally
      Screen.Cursor := crDefault;
      Self.Enabled := true;
    end;
  end;
end;

procedure TFrm_Main.Chp_MinChange(Sender: TObject);
begin
  if Chp_Min.Value > chp_Max.Value then
    Chp_Min.Value := chp_Max.Value;
end;

procedure TFrm_Main.Chp_MaxChange(Sender: TObject);
begin
  if Chp_Max.Value < Chp_Min.Value then
    Chp_Max.Value := chp_Min.Value;
end;

procedure TFrm_Main.Chk_GoodVerifClick(Sender: TObject);
begin
  Chk_TransactionPatch.Enabled := Chk_GoodVerif.Checked;
  if not Chk_TransactionPatch.Enabled then
    Chk_TransactionPatch.Checked := false;
end;

// page pour un patch

procedure TFrm_Main.edt_FilePatchChange(Sender: TObject);
begin
  Btn_Traitement.Enabled := VerifVersion();
end;

procedure TFrm_Main.Nbt_FilePatchClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier patch (*.sql)|*.sql';
    Open.InitialDir := ExtractFilePath(edt_FilePatch.Text);
    Open.FileName := ExtractFileName(edt_FilePatch.Text);
    if Open.Execute() then
      edt_FilePatch.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

// panel de logs

procedure TFrm_Main.Nbt_SaveLogClick(Sender: TObject);
var
  Save : TSaveDialog;
begin
  if not (Trim(mem_Logs.Lines.Text) = '') then
  begin
    try
      Save := TSaveDialog.Create(Self);
      Save.Filter := 'Fichier de logs (*.log)|*.log';
      Save.DefaultExt := 'log';
      Save.InitialDir := ExtractFilePath(edt_Database.Text);
      Save.FileName := ExtractFileName(edt_Database.Text);
      if Save.Execute() then
        mem_Logs.Lines.SaveToFile(Save.FileName);
    finally
      FreeAndNil(Save);
    end;
  end;
end;

// panel de control

procedure TFrm_Main.Btn_TraitementClick(Sender: TObject);
begin
  case Pgc_Choix.ActivePageIndex of
    0 : DoScript(); // script !
    1 : DoPatchs(); // patchs !
    2 : DoPatchFile(edt_Filepatch.Text); // patch file
    else MessageDlg('Fonction non implementer.', mtWarning, [mbOK], 0);
  end;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// utilitaires ...

function TFrm_Main.VerifVersion() : boolean;
var
  Query : TIBOQuery;
begin
  Result := false;

  case pgc_Choix.ActivePageIndex of
    0 :
      Exit;
    1 :
      if not DirectoryExists(edt_RepPatch.Text) then
        Exit;
    2 :
      if not FileExists(edt_FilePatch.Text) then
        Exit;
  end;

  if FileExists(edt_Database.Text) then
  begin
    try
      try
        Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_Database.Text, edt_login.Text, edt_Password.Text)));
        Query.ParamCheck := false;

        Result := true;
      finally
        Query.IB_Transaction.Rollback();
        Query.IB_Transaction.Close();
        Query.IB_Transaction.Free();
        Query.IB_Connection.Free();
        FreeAndNil(Query);
      end;
    except
      on e : exception do
      begin
        MessageDlg('Exception : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

function TFrm_Main.GetVersionBase() : string;
var
  Query : TIBOQuery;
begin
  Result := '0.0.0.0';

  if FileExists(edt_Database.Text) then
  begin
    try
      Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_Database.Text, edt_login.Text, edt_Password.Text)));
      Query.ParamCheck := false;
      Query.SQL.Text := 'select ver_version from genversion order by ver_date desc rows 1;';
      Query.Open();
      if not Query.Eof then
        Result := Query.FieldByName('ver_version').AsString;
    finally
      Query.IB_Transaction.Rollback();
      Query.IB_Transaction.Close();
      Query.IB_Transaction.Free();
      Query.IB_Connection.Free();
      FreeAndNil(Query);
    end;
  end;
end;

function TFrm_Main.GetVersionsFromYellis() : TStringList;
var
  Yellis : Tconnexion;
  Versions : TStringList;
  i : integer;
begin
  Result := TStringList.Create();
  try
    Yellis := Tconnexion.Create();
    Versions := Yellis.Select('Select id, nomversion from version where id >= 38 order by nomversion;');
    for i := 0 to Yellis.recordCount(Versions) -1 do
    begin
      if not (Trim(Yellis.UneValeur(Versions, 'nomversion', i)) = '') then
        Result.AddObject(Yellis.UneValeur(Versions, 'nomversion', i), Pointer(Strtoint(Yellis.UneValeur(Versions, 'id', i))));
    end;
    Yellis.FreeResult(Versions);
  finally
    FreeAndNil(Yellis);
  end;
end;

function TFrm_Main.GetNomFichier(numPatch : integer) : string;
begin
  Result := IncludeTrailingPathDelimiter(edt_RepPatch.Text) + 'script' + IntToStr(numPatch) + '.sql'
end;

procedure TFrm_Main.DoScript();
var
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;
    mem_Logs.Lines.Clear();
    pgb_Progression.Position := 0;
//    pgb_Progression.Max := Chp_Max.Value - Chp_Min.Value +1;
//    pgb_Progression.Step := 1;

    try
      Connex := GetNewConnexion(edt_Database.Text, edt_login.Text, edt_Password.Text);
      Trans := GetNewTransaction(Connex, false);

      // TODO -obpy : gestion du script
      MessageDlg('Non implementé !', mtWarning, [mbOK], 0);

    finally
      FreeAndNil(Trans);
      FreeAndNil(Connex);
    end;
  finally
    MessageDlg('Traitement terminé.', mtInformation, [mbOK], 0);
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

procedure TFrm_Main.DoPatchs();
var
  numPatch : integer;
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;
    mem_Logs.Lines.Clear();
    pgb_Progression.Position := 0;
    pgb_Progression.Max := Chp_Max.Value - Chp_Min.Value +1;
    pgb_Progression.Step := 1;

    numPatch := Chp_Min.Value;

    try
      Connex := GetNewConnexion(edt_Database.Text, edt_login.Text, edt_Password.Text);
      Trans := GetNewTransaction(Connex, false);

      repeat
        if not DoPatch(Connex, Trans, GetNomFichier(numPatch)) then
          Exit;
        Inc(numPatch);
      until (not FileExists(GetNomFichier(numPatch))) or (numPatch > Chp_Max.Value);
    finally
      FreeAndNil(Trans);
      FreeAndNil(Connex);
    end;
  finally
    MessageDlg('Traitement terminé.', mtInformation, [mbOK], 0);
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

procedure TFrm_Main.DoPatchFile(aFilename: string);
var
  Connex : TIB_Connection;
  Trans : TIB_Transaction;
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;
    mem_Logs.Lines.Clear();
    pgb_Progression.Position := 0;
    pgb_Progression.Max := 1;
    pgb_Progression.Step := 1;

    try
      Connex := GetNewConnexion(edt_Database.Text, edt_login.Text, edt_Password.Text);
      Trans := GetNewTransaction(Connex, false);

      DoPatch(Connex, Trans, aFileName);
    finally
      FreeAndNil(Trans);
      FreeAndNil(Connex);
    end;
  finally
    MessageDlg('Traitement terminé.', mtInformation, [mbOK], 0);
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

function TFrm_Main.DoPatch(aConnex : TIB_Connection ; aTrans : TIB_Transaction ; aFileName : string) : boolean;

  function GetSQLName(text : string; start : integer) : string;
  begin
    Result := Copy(text, start, Length(text));
    if pos(' ', Result) > 0 then
      Result := Copy(Result, 1, pos(' ', Result) -1)
    else if pos('(', Result) > 0 then
      Result := Copy(Result, 1, pos('(', Result) -1);
  end;

  function VerifExistance(Trans : TIB_Transaction; table, champ, valeur : string) : boolean;
  var
    QVerif : TIBOQuery;
  begin
    try
      QVerif := GetNewQuery(Trans);
      QVerif.ParamCheck := false;
      QVerif.SQL.Text := 'select ' + champ + ' from ' + table + ' where ' + champ + ' = ' + QuotedStr(valeur);
      QVerif.Open();
      Result := not QVerif.Eof;
    finally
      FreeAndNil(QVerif);
    end;
  end;

  function DoRequeteCorrect(Trans : TIB_Transaction; Text : TStrings; var Output : string) : boolean;
  var
    ItemName : string;
    Query : TIBOQuery;
  begin
    Result := false;
    Output := '';
    try
      Query := GetNewQuery(Trans);
      Query.SQL.AddStrings(Text);
      try
        Trans.StartTransaction();

        if UpperCase(Copy(Query.SQL[0], 1, 17)) = 'CREATE GENERATOR ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 18);
          if VerifExistance(Trans, 'rdb$generators', 'rdb$generator_name', ItemName) then
          begin
            Output := 'Generateur existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 15)) = 'CREATE TRIGGER ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 16);
          if VerifExistance(Trans, 'rdb$triggers', 'rdb$trigger_name', ItemName) then
          begin
            Output := 'trigger existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 13)) = 'CREATE INDEX ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 14);
          if VerifExistance(Trans, 'rdb$indices', 'rdb$index_name', ItemName) then
          begin
            Output := 'index existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 17)) = 'CREATE PROCEDURE ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 18);
          if VerifExistance(Trans, 'rdb$procedures', 'rdb$procedure_name', ItemName) then
            Query.SQL[0] := StringReplace(Query.SQL[0], 'CREATE PROCEDURE ', 'ALTER PROCEDURE ', [rfIgnoreCase]);
          Output := 'procedure existante : ' + ItemName + ' tentative d''alter';
        end;

        Query.ExecSQL();
        Trans.Commit();
        Result := true;
      except
        on e : Exception do
        begin
          Trans.Rollback();
          Output := e.ClassName + ' - ' + e.Message;
          Result := false;
        end;
      end;
    finally
      FreeAndNil(Query);
    end;
  end;

  function DoRequeteCorrectNoTrans(Trans : TIB_Transaction; Text : TStrings; var Output : string) : boolean;
  var
    ItemName : string;
    Query : TIBOQuery;
  begin
    Result := false;
    Output := '';
    try
      Query := GetNewQuery(Trans);
      Query.ParamCheck := false;
      Query.SQL.AddStrings(Text);
      try
        if UpperCase(Copy(Query.SQL[0], 1, 17)) = 'CREATE GENERATOR ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 18);
          if VerifExistance(Trans, 'rdb$generators', 'rdb$generator_name', ItemName) then
          begin
            Output := 'Generateur existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 15)) = 'CREATE TRIGGER ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 16);
          if VerifExistance(Trans, 'rdb$triggers', 'rdb$trigger_name', ItemName) then
          begin
            Output := 'trigger existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 13)) = 'CREATE INDEX ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 14);
          if VerifExistance(Trans, 'rdb$indices', 'rdb$index_name', ItemName) then
          begin
            Output := 'index existant : ' + ItemName + ' ignoré !';
            Trans.Rollback();
            Result := true;
            Exit;
          end;
        end
        else if UpperCase(Copy(Query.SQL[0], 1, 17)) = 'CREATE PROCEDURE ' then
        begin
          ItemName := GetSQLName(Query.SQL[0], 18);
          if VerifExistance(Trans, 'rdb$procedures', 'rdb$procedure_name', ItemName) then
            Query.SQL[0] := StringReplace(Query.SQL[0], 'CREATE PROCEDURE ', 'ALTER PROCEDURE ', [rfIgnoreCase]);
          Output := 'procedure existante : ' + ItemName + ' tentative d''alter';
        end;

        Query.ExecSQL();
        Result := true;
      except
        on e : Exception do
        begin
          Output := e.ClassName + ' - ' + e.Message;
          Result := false;
        end;
      end;
    finally
      FreeAndNil(Query);
    end;
  end;

  function DoRequetePorc(Trans : TIB_Transaction; Text : TStrings; var Output : string) : boolean;
  var
    Query : TIBOQuery;
  begin
    Result := false;
    Output := '';
    try
      Query := GetNewQuery(Trans);
      Query.ParamCheck := false;
      Query.SQL.AddStrings(Text);
      try
        Trans.StartTransaction();
        Query.ExecSQL();
        Trans.Commit();
        Result := true;
      except
        on e : Exception do
        begin
          Trans.Rollback();

          if UpperCase(Copy(Text[0], 1, 17)) = 'CREATE GENERATOR ' then
          begin
            Output := 'generateur existant : ' + GetSQLName(Query.SQL[0], 18) + ' ignoré !';
            Result := true
          end
          else if UpperCase(Copy(Text[0], 1, 15)) = 'CREATE TRIGGER ' then
          begin
            Output := 'trigger existant : ' + GetSQLName(Query.SQL[0], 16) + ' ignoré !';
            Result := true
          end
          else if UpperCase(Copy(Text[0], 1, 13)) = 'CREATE INDEX ' then
          begin
            Output := 'index existant : ' + GetSQLName(Query.SQL[0], 14) + ' ignoré !';
            Result := true
          end
          else if UpperCase(Copy(Text[0], 1, 17)) = 'CREATE PROCEDURE ' then
          begin
            Output := 'procedure existante : ' + GetSQLName(Query.SQL[0], 18) + ' tentative d''alter';
            try
              Trans.StartTransaction();
              Query.SQL.Clear();
              Query.SQL.AddStrings(Text);
              Query.SQL[0] := StringReplace(Query.SQL[0], 'CREATE PROCEDURE ', 'ALTER PROCEDURE ', [rfIgnoreCase]);
              Query.ExecSQL();
              Trans.Commit();
              Result := true;
            except
              on e : Exception do
              begin
                Trans.Rollback();
                Output := e.ClassName + ' - ' + e.Message;
                Result := false
              end;
            end;
          end
          else
          begin
            Output := e.ClassName + ' - ' + e.Message;
            Result := false
          end;
        end;
      end;
    finally
      FreeAndNil(Query);
    end;
  end;

var
  numReq : integer;
  Output : string;
  PatchLines, QueryLines : TStringList;
  ResQuery : boolean;
  scriptName : string;
begin
  Result := true;
  ResQuery := false;
  numReq := 1;

  PatchLines := TStringList.Create();
  QueryLines := TStringList.Create();
  try
    scriptName := ExtractFileName(aFileName);
    PatchLines.LoadFromFile(aFileName);
    pgb_Progression.StepIt();
    Application.ProcessMessages();

    if Chk_GoodVerif.Checked and Chk_TransactionPatch.Checked then
      aTrans.StartTransaction();

    while (PatchLines.Count > 0) do
    begin
      QueryLines.Clear();
      while (PatchLines.Count > 0) do
      begin
        if (Trim(PatchLines[0]) = '<---->') then
        begin
          PatchLines.Delete(0);
          Break;
        end
        else
        begin
          QueryLines.Add(PatchLines[0]);
          PatchLines.Delete(0);
        end;
      end;

      if Chk_GoodVerif.Checked and Chk_TransactionPatch.Checked then
        ResQuery := DoRequeteCorrectNoTrans(aTrans, QueryLines, Output)
      else if Chk_GoodVerif.Checked then
        ResQuery := DoRequeteCorrect(aTrans, QueryLines, Output)
      else
        ResQuery := DoRequetePorc(aTrans, QueryLines, Output);

      if not ResQuery then
      begin
        mem_Logs.Lines.Add('Patch ' + scriptName + ' requete ' + IntToStr(numReq) + ' : Erreur : ' + Output + '.');
        mem_Logs.Lines.Add('');
        mem_Logs.Lines.Add('==========');
        mem_Logs.Lines.Add('Requete : ');
        mem_Logs.Lines.AddStrings(QueryLines);
        mem_Logs.Lines.Add('==========');
        mem_Logs.Lines.Add('');

        if Chk_GoodVerif.Checked and Chk_TransactionPatch.Checked then
        begin
          Break;
        end
        else
        begin
          if MessageDlg('Erreur : ' + Output + #13
                      + 'lors de l''execution du patch ' + scriptName + ', requete ' + IntToStr(numReq) + #13
                      + 'Voullez-vous continuer (requete suivante) ?',
                        mtError, [mbYes, mbNo], 0) = mrNo then
          begin
            Result := false ;
            Exit;
          end ;
        end;
      end
      else if not (output = '') then
      begin
        mem_Logs.Lines.Add('Patch ' + scriptName + ' requete ' + IntToStr(numReq) + ' : Avertissement : ' + Output + '.');
      end
      else
      begin
        mem_Logs.Lines.Add('Patch ' + scriptName + ' requete ' + IntToStr(numReq) + ' : Execution OK.');
      end;
      Application.ProcessMessages();
      Inc(numReq);
    end;

    if Chk_GoodVerif.Checked and Chk_TransactionPatch.Checked then
    begin
      if ResQuery then
        aTrans.Commit()
      else
      begin
        aTrans.Rollback();
        if MessageDlg('Erreur : ' + Output + #13
                    + 'lors de l''execution du patch ' + scriptName + ', requete ' + IntToStr(numReq) + #13
                    + 'Voulez-vous continuer (patch suivant) ?',
                      mtError, [mbYes, mbNo], 0) = mrNo then
        begin
          Result := false ;
          Exit;
        end ;
      end;
    end;

  finally
    FreeAndNil(QueryLines);
    FreeAndNil(PatchLines);
  end;
end;

// Gestion du Drag and Drop

procedure TFrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count, Attr : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);

      Attr := FileGetAttr(FileName);
      if (Attr and faDirectory) > 0 then
      begin
        edt_RepPatch.Text := FileName;
        Pgc_Choix.ActivePage := Tab_Patchs;
      end
      else
      begin
        FileExt := UpperCase(ExtractFileExt(FileName));
        if FileExt = '.IB' then
          edt_Database.Text := FileName
        else if FileExt = '.SQL' then
        begin
          edt_FilePatch.Text := FileName;
          Pgc_Choix.ActivePage := Tab_Patch;
        end
        else if FileExt = '.SCR' then
        begin
          edt_FileScript.Text := FileName;
          Pgc_Choix.ActivePage := Tab_Script;
        end;
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

end.

