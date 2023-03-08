unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls;

type
  TFrm_Main = class(TForm)
    Pan_ScriptMaj: TPanel;
    Lab_ScriptMaj: TLabel;
    Lbx_ScriptMaj: TListBox;
    Pan_RepVersion: TPanel;
    Lbx_RepVersion: TListBox;
    edt_RepVersion: TEdit;
    Lab_RepVersion: TLabel;
    Nbt_RepVersion: TSpeedButton;
    Pan_Control: TPanel;
    Splitter1: TSplitter;
    Btn_Quitter: TButton;
    Btn_Traitement: TButton;
    Nbt_ScriptMaj_Add: TSpeedButton;
    Nbt_ScriptMaj_Del: TSpeedButton;
    Btn_SaveIni: TButton;
    Tim_Auto: TTimer;
    Splitter2: TSplitter;
    Pan_Log: TPanel;
    Lab_Log: TLabel;
    mem_log: TMemo;
    Lab_YellisVersion: TLabel;
    Chk_ScriptSCR: TCheckBox;
    Lab_MaitreMAJ: TLabel;
    Edt_MaitreMAJ: TEdit;
    Nbt_MaitreMAJ: TSpeedButton;
    Chk_MigreV13: TCheckBox;
    Chk_KeepIni: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure edt_RepVersionChange(Sender: TObject);
    procedure Nbt_RepVersionClick(Sender: TObject);
    procedure Nbt_ScriptMaj_AddClick(Sender: TObject);
    procedure Nbt_ScriptMaj_DelClick(Sender: TObject);
    procedure Btn_SaveIniClick(Sender: TObject);
    procedure Btn_TraitementClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Tim_AutoTimer(Sender: TObject);
    procedure Nbt_MaitreMAJClick(Sender: TObject);
    procedure Edt_MaitreMAJChange(Sender: TObject);
  private
    { Déclarations privées }
    FAutomatique : boolean;

    FLogFile : string;
    FLogMemo : TMemo;

    FnewCRC : boolean;

    function GetVersionsFromYellis() : TStringList;

    procedure AllowEdit(AValue : boolean);

    procedure InitLog(Prefix : string; memo : TMemo);
    procedure DoLog(txt : string);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  IniFiles,
  BrowseForFolderU,
  ComCtrls,
  UPost,
  UmakePatch,
  ShellAPI,
  ShlObj,
  ComObj,
  ActiveX,
  IdHTTP,
  IdURI,
  IdCompressorZLib,
  AddRep_Frm;

{$R *.dfm}

const
  SCRIPTEXE = 'SCRIPT.EXE';
  SCRIPTSCR = 'SCRIPT.SCR';
  MIGREV13EXE = 'MIGREV13.EXE';

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  IniFile : string;
  Ini : TInifile;
  Versions : TStringList;
  i : integer;
begin
  FAutomatique := false;
  FLogFile := '';
  FLogMemo := nil;
  FnewCRC := false;

  // recup des version de Yellis
  try
    Versions := GetVersionsFromYellis();
    for i := 0 to Versions.Count -1 do
      Lbx_RepVersion.Items.AddObject(Versions[i], Versions.Objects[i]);
  finally
    FreeAndNil(Versions)
  end;

  // lecture des paramètres
  IniFile := ChangeFileExt(ParamStr(0), '.ini');
  if FileExists(IniFile) then
  begin
    try
      Ini := TIniFile.Create(IniFile);
      edt_RepVersion.Text := Ini.ReadString('Conf', 'RepVersion', '');
      Edt_MaitreMAJ.Text := Ini.ReadString('Conf', 'MaitreMAJ', '');
      Lbx_ScriptMaj.Items.Delimiter := ';';
      Lbx_ScriptMaj.Items.DelimitedText := Ini.ReadString('Conf', 'ScriptMaj', '');
      Lbx_ScriptMaj.SelectAll();
      Chk_MigreV13.Checked := Ini.ReadBool('Conf', 'MigreV13', true);
    finally
      FreeAndNil(Ini);
    end;
  end;

  // paramètres
  if (ParamCount() >= 1) then
  begin
    for i := 1 to ParamCount() do
    begin
      if (UpperCase(ParamStr(i)) = 'AUTO') then
        Tim_Auto.Enabled := true
      else if (UpperCase(ParamStr(i)) = 'SCR') then
        Chk_ScriptSCR.Checked := true
      else if (UpperCase(ParamStr(i)) = 'INI') then
        Chk_KeepIni.Checked := true
      else
        ;
    end
  end;
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  // arf
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Btn_Quitter.Enabled;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  // arf
end;

procedure TFrm_Main.edt_RepVersionChange(Sender: TObject);
var
  Res : integer;
  FindFile : TSearchRec;
  Idx : integer;
begin
  if DirectoryExists(edt_RepVersion.Text) then
  begin
    Lbx_RepVersion.ClearSelection();
    Res := FindFirst(IncludeTrailingPathDelimiter(edt_RepVersion.Text) + '*', faDirectory, FindFile);
    if Res = 0 then
    begin
      try
        while res = 0 do
        begin
          Idx := Lbx_RepVersion.Items.IndexOf(FindFile.Name);
          if Idx >= 0 then
            Lbx_RepVersion.Selected[Idx] := true;
          Res := FindNext(FindFile);
        end;
      finally
        FindClose(FindFile);
      end;
    end;
  end;
end;

procedure TFrm_Main.Nbt_RepVersionClick(Sender: TObject);
var
  tmpRep : string;
begin
  tmpRep := BrowseForFolder('Séléctionnez un repertoire', edt_RepVersion.Text, true);
  if not (Trim(tmpRep) = '') then
  begin
    edt_RepVersion.Text := '';
    edt_RepVersion.Text := tmpRep;
  end;
end;

procedure TFrm_Main.Edt_MaitreMAJChange(Sender: TObject);
begin
  // arf
end;

procedure TFrm_Main.Nbt_MaitreMAJClick(Sender: TObject);
var
  tmpRep : string;
begin
  tmpRep := BrowseForFolder('Séléctionnez un repertoire', edt_RepVersion.Text, true);
  if not (Trim(tmpRep) = '') then
  begin
    Edt_MaitreMAJ.Text := '';
    Edt_MaitreMAJ.Text := tmpRep;
  end;
end;

procedure TFrm_Main.Nbt_ScriptMaj_AddClick(Sender: TObject);
var
  tmpRep : string;
  idx : integer;
begin
  if GetNewRep(Self, tmpRep) then
  begin
    idx := Lbx_ScriptMaj.Items.Add(tmpRep);
    Lbx_ScriptMaj.Selected[idx] := true;
  end;
end;

procedure TFrm_Main.Nbt_ScriptMaj_DelClick(Sender: TObject);
begin
  if Lbx_ScriptMaj.ItemIndex >= 0 then
  begin
    Lbx_ScriptMaj.Items.Delete(Lbx_ScriptMaj.ItemIndex);
    Lbx_ScriptMaj.ItemIndex := -1;
  end;
end;

// Traitements

procedure TFrm_Main.Btn_SaveIniClick(Sender: TObject);
var
  IniFile, tmpInfo : string;
  i : integer;
  Ini : TInifile;
begin
  // lecture des paramètres
  IniFile := ChangeFileExt(ParamStr(0), '.ini');
  try
    Ini := TIniFile.Create(IniFile);
    Ini.WriteString('Conf', 'RepVersion', edt_RepVersion.Text);
    Ini.WriteString('Conf', 'MaitreMAJ', Edt_MaitreMAJ.Text);

    tmpInfo := '';
    for i := 0 to Lbx_ScriptMaj.Items.Count -1 do
    begin
      if Trim(tmpInfo) = '' then
        tmpInfo := '"' + Lbx_ScriptMaj.Items[i] + '"'
      else
        tmpInfo := tmpInfo + ';"' + Lbx_ScriptMaj.Items[i] + '"'
    end;
    Ini.WriteString('Conf', 'ScriptMaj', '"' + tmpInfo + '"');
    Ini.WriteBool('Conf', 'MigreV13', Chk_MigreV13.Checked);
  finally
    FreeAndNil(Ini);
  end;
end;

procedure TFrm_Main.Btn_TraitementClick(Sender: TObject);

  function GetFileCRC(FileName : string) : string;
  var
    CRCold : LongWord;
    CRCnew : Cardinal;
  begin
    if FileExists(FileName) then
    begin
      try
        CRCold := FileCRC32(FileName);
      except
        CRCold := 0;
      end;
      try
        CRCnew := DoNewCalcCRC32(FileName);
      except
        CRCnew := 0;
      end;
      if FnewCRC then
        Result := IntToStr(CRCnew)
      else
        Result := IntToStr(CRCold);
    end
    else
      Result := '';
  end;

  procedure GetExistingFiles(Repertoire : string; var ExistingFiles : TStringList);
  var
    Res : integer;
    FindFile : TSearchRec;
  begin
    // les fichiers
    try
      Res := FindFirst(IncludeTrailingPathDelimiter(Repertoire) + '*', faAnyFile, FindFile);
      while res = 0 do
      begin
        if ((FindFile.Name = '.') or (FindFile.Name = '..')) then
          // do nothing !
        else if (FindFile.Attr and faDirectory) = faDirectory then
        begin
          GetExistingFiles(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Repertoire) + FindFile.Name), ExistingFiles);
          ExistingFiles.Add(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Repertoire) + FindFile.Name));
        end
        else
          ExistingFiles.Add(IncludeTrailingPathDelimiter(Repertoire) + FindFile.Name);
        Res := FindNext(FindFile);
      end;
    finally
      FindClose(FindFile);
    end;
  end;

  function PutFileOnRep(FileName, DestPath : string) : boolean;
  var
    FileDest : string;
    CRCloc, CRCdis : string;
  begin
    Result := false;
    if FileExists(Filename) then
    begin
      ForceDirectories(DestPath);
      FileDest := IncludeTrailingPathDelimiter(DestPath) + ExtractFileName(Filename);
      CRCloc := GetFileCRC(FileDest);
      CRCdis := GetFileCRC(Filename);
      if not (CRCloc = CRCdis) then
      begin
        // Suppresion
        if FileExists(FileDest) then
          DeleteFile(FileDest);
        // Copie
        DoLog('Copie du fichier depuis : ' + Filename);
        Result := CopyFile(PChar(Filename), PChar(FileDest), true);
        // Vérification
        CRCloc := GetFileCRC(FileDest);
        if not (CRCloc = CRCdis) then
          DoLog(' -> ATTENTION : erreur de verification du CRC (CRC local : ' + CRCloc + '; CRC distant : ' + CRCdis + ')');
      end
      else
        Result := true;
    end;
  end;

  function TraiteFileToRep(FilePath, FileName, DestPath : string) : boolean;
  begin
    if FileExists(IncludeTrailingPathDelimiter(FilePath) + FileName) then
    begin
      DoLog('Traitement de ' + FileName);
      Result := PutFileOnRep(IncludeTrailingPathDelimiter(FilePath) + FileName, DestPath);
    end
    else
    begin
      DoLog('Le fichier ' + FileName + ' n''existe pas');
      Result := true;
    end;
  end;

  procedure CreateLink(FicSource, Args, FicRaccourci, Description, DossierDeTravail, NomIconeAssociee : string; NumIcone : integer);
  var
    ShellLink : IShellLink;
  begin
    if UpperCase(extractFileExt(FicRaccourci)) <> '.LNK' then
      FicRaccourci := FicRaccourci + '.lnk';

    ShellLink := CreateComObject(CLSID_ShellLink) as IShellLink;
    ShellLink.SetDescription(PChar(Description));
    ShellLink.SetPath(PChar(FicSource));
    ShellLink.SetArguments(PChar(Args));
    ShellLink.SetWorkingDirectory(PChar(DossierDeTravail));
    ShellLink.SetShowCmd(SW_SHOW);
    if (NomIconeAssociee<>'') then
      ShellLink.SetIconLocation(PChar(NomIconeAssociee), NumIcone);
    (ShellLink as IpersistFile).Save(StringToOleStr(FicRaccourci), true);
  end;

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
        on e : Exception do
          DoLog(' -> Exception lors du telechargement : ' + e.ClassName + ' - ' + e.Message);
      end;
    finally
      FreeAndNil(FileStream);
      FreeAndNil(IdCompres);
      FreeAndNil(IdHTTP);
    end;
  end;

const
  CST_ERROR_NO_REP_VERSION = 'Le répertoire de destination des version n''est pas renseigné.';
  CST_ERROR_NO_REP_MAITREMAJ = 'Le repertoire maitre des ScriptMaj n''est pas rensigné.';
  CST_ERROR_NO_VERSION_SELECTED = 'Aucune version n''est sélectionné a traité.';
  CST_ERROR_NO_SCRIPTMAJ_SELECTED = 'Aucun repertoire de ScriptMAJ n''est sélectionné a traité.';
  CST_CONTINUE = #13'Voulez-vous continuer ?';
var
  i, j, k : integer;
  Yellis : Tconnexion;
  Fichiers, FilesToKeep, ExistingFiles : TStringList;
  BasePath, FileName, FilePath, FileDest, MasterMAJPath, DestPath : string;
  CRCloc, CRCdis : string;
  URLFichier : string;
  FErreur, FWarning, res : boolean;
begin
  FErreur := false;
  FWarning := false;
  try
    mem_log.Lines.Clear();
    InitLog('', mem_log);
    DoLog('==================================================');
    DoLog('Debut du traitement');
    DoLog('==================================================');

{$REGION '    Vérification des paramètres '}
    // Vérification des paramètres obligatoires
    if (Trim(edt_RepVersion.Text) = '') then
    begin
      edt_RepVersion.SetFocus();
      DoLog(CST_ERROR_NO_REP_VERSION);
      if not FAutomatique then
        MessageDlg(CST_ERROR_NO_REP_VERSION, mtError, [mbOK], 0);
      Exit;
    end;
    // Vérification des paramètres facultatif
    if Lbx_RepVersion.SelCount < 1 then
    begin
      DoLog(CST_ERROR_NO_VERSION_SELECTED);
      if not FAutomatique and (MessageDlg(CST_ERROR_NO_VERSION_SELECTED + CST_CONTINUE, mtWarning, [mbYes, mbNo], 0) = mrNo) then
        Exit;
    end;
    if (Trim(Edt_MaitreMAJ.Text) = '') then
    begin
      DoLog(CST_ERROR_NO_REP_MAITREMAJ);
      if not FAutomatique and (MessageDlg(CST_ERROR_NO_REP_MAITREMAJ + CST_CONTINUE, mtWarning, [mbYes, mbNo], 0) = mrNo) then
        Exit;
    end
    else
    begin
      if Lbx_ScriptMaj.SelCount < 1 then
      begin
        DoLog(CST_ERROR_NO_SCRIPTMAJ_SELECTED);
        if not FAutomatique and (MessageDlg(CST_ERROR_NO_SCRIPTMAJ_SELECTED + CST_CONTINUE, mtWarning, [mbYes, mbNo], 0) = mrNo) then
          Exit;
      end;
    end;
{$ENDREGION}

    try
      AllowEdit(false);
      FilesToKeep := TStringList.Create();
      ExistingFiles := TStringList.Create();

      for i := 0 to Lbx_RepVersion.Items.Count -1 do
      begin
        if Lbx_RepVersion.Selected[i] then
        begin
          try
            BasePath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(edt_RepVersion.Text) + Lbx_RepVersion.Items[i]);
            DoLog('--------------------------------------------------');
            DoLog('Gestion de la version : ' + Lbx_RepVersion.Items[i]);
            DoLog('Traitement du repertoire : ' + BasePath);
            ExistingFiles.Clear();
            FilesToKeep.Clear();

{$REGION '            Recup de la version sur Yellis/Lame2 '}
            //======================================
            // Recup de la version sur Yellis/Lame2
            //======================================
            try
              Yellis := Tconnexion.Create();
              Fichiers := Yellis.Select('Select fichier, crc from fichiers Where id_ver = ' + IntToStr(Integer(Pointer(Lbx_RepVersion.Items.Objects[i]))) + ';');
              for j := 0 to  Yellis.recordCount(Fichiers) -1 do
              begin
                FileName := BasePath + Yellis.UneValeur(Fichiers, 'fichier', j);
                FilePath := ExtractFilePath(FileName);
                if FilesToKeep.IndexOf(FilePath) < 0 then
                  FilesToKeep.Add(FilePath);
                FilesToKeep.Add(FileName);
                ForceDirectories(FilePath);
                CRCloc := GetFileCRC(FileName);
                CRCdis := Yellis.UneValeur(Fichiers, 'crc', j);

                DoLog('Gestion du fichier : ' + FileName + ' (CRC local : ' + CRCloc + '; CRC distant : ' + CRCdis + ')');

                // doit on recupéré le fichier ?
                if not (CRCloc = CRCdis) then
                begin
                  // suppression
                  if FileExists(FileName) then
                    DeleteFile(FileName);
                  // Téléchargement
                  URLFichier := 'http://lame2.no-ip.com/maj/' + Lbx_RepVersion.Items[i] + '/' + StringReplace(Yellis.UneValeur(Fichiers, 'fichier', j), '\', '/', [rfReplaceAll, rfIgnoreCase]);
                  DoLog('Telechargement depuis : ' + URLFichier);
                  if not DownloadHTTP(URLFichier, FileName) then
                    Raise Exception.Create('Erreur lors du téléchargement de ' + FileName);
                  // Verification
                  CRCloc := GetFileCRC(FileName);
                  if not (CRCloc = CRCdis) then
                  begin
                    FWarning := true;
                    DoLog(' -> ATTENTION : erreur de verification du CRC (CRC local : ' + CRCloc + '; CRC distant : ' + CRCdis + ')');
                  end
                end;
              end;
              Yellis.FreeResult(Fichiers);
            finally
              FreeAndNil(Yellis);
            end;
{$ENDREGION}

{$REGION '            Gestion de script.scr ! '}
            //======================================
            // Gestion de script.scr !
            // il n'est pas dans la version
            //======================================
            FilesToKeep.Add(BasePath + SCRIPTSCR);
            if not FileExists(BasePath + SCRIPTSCR) or Chk_ScriptSCR.Checked then
            begin
              DoLog('Gestion du fichier : ' + BasePath + SCRIPTSCR + ' (CRC local : ???; CRC distant : ???)');
              // suppression
              if FileExists(BasePath + SCRIPTSCR) then
                DeleteFile(BasePath + SCRIPTSCR);
              // Téléchargement
              URLFichier := 'http://lame2.no-ip.com/maj/' + Lbx_RepVersion.Items[i] + '/' + SCRIPTSCR;
              DoLog('Telechargement depuis : ' + URLFichier);
              if not DownloadHTTP(URLFichier, BasePath + SCRIPTSCR) then
                Raise Exception.Create('Erreur lors du téléchargement de ' + BasePath + SCRIPTSCR);
            end
            else
              FilesToKeep.Add(BasePath + SCRIPTSCR);
{$ENDREGION}

{$REGION '            Nettoyage des fichier de la version ! '}
            //======================================
            // Nettoyage des fichier de la version !
            //======================================
            GetExistingFiles(BasePath, ExistingFiles);
            for j := 0 to ExistingFiles.Count -1 do
            begin
              if FilesToKeep.IndexOf(ExistingFiles[j]) < 0 then
              begin
                // gestion repertoire / non repertoire
                if FileGetAttr(ExistingFiles[j]) and faDirectory = faDirectory then
                begin
                  DoLog('Repertoire ' + ExistingFiles[j] + ' non present sur Yellis, suppression');
                  res := RemoveDir(ExistingFiles[j]);
                end
                // gestion des fichier ini
                else if (ExtractFileExt(ExistingFiles[j]) = '.ini') and (FilesToKeep.IndexOf(ChangeFileExt(ExistingFiles[j], '.exe')) >= 0) and Chk_KeepIni.Checked  then
                begin
                  DoLog('Fichier ' + ExistingFiles[j] + ' conservation des fichiers ini');
                end
                else
                begin
                  DoLog('Fichier ' + ExistingFiles[j] + ' non present sur Yellis, suppression');
                  res := DeleteFile(ExistingFiles[j]);
                end;
              end;
            end;
{$ENDREGION}

            if not (Trim(Edt_MaitreMAJ.Text) = '') then
            begin
{$REGION '              Copie des script vers le repertoire maitre des ScriptMAJ '}
              //======================================
              // Copie des script vers ScriptMAJ
              //======================================
              MasterMAJPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Edt_MaitreMAJ.Text) + Lbx_RepVersion.Items[i]);
              DoLog('');
              DoLog('Copie des fichier de version dans : ' + MasterMAJPath);
              // BasePath + 'script.exe';
              if not TraiteFileToRep(BasePath, SCRIPTEXE, MasterMAJPath) then
                Raise Exception.Create('Erreur lors de la copy de ' + SCRIPTEXE + ' dans ' + MasterMAJPath);
              CreateLink(MasterMAJPath + SCRIPTEXE, 'MANU', MasterMAJPath + 'Raccourci vers ' + SCRIPTEXE, SCRIPTEXE, MasterMAJPath, MasterMAJPath + SCRIPTEXE, 0);
              // BasePath + 'script.scr';
              if not TraiteFileToRep(BasePath, SCRIPTSCR, MasterMAJPath) then
                Raise Exception.Create('Erreur lors de la copy de ' + SCRIPTSCR + ' dans ' + MasterMAJPath);
              // IncludeTrailingPathDelimiter(BasePath + 'exe') + 'migrev13.exe';
              if Chk_MigreV13.Checked then
              begin
                if not TraiteFileToRep(IncludeTrailingPathDelimiter(BasePath + 'EXE'), MIGREV13EXE, MasterMAJPath) then
                  Raise Exception.Create('Erreur lors de la copy de ' + MIGREV13EXE + ' dans ' + MasterMAJPath);
              end;
              // recuperation du contenue du repertoire
              ExistingFiles.Clear();
              GetExistingFiles(MasterMAJPath, ExistingFiles);
{$ENDREGION}

{$REGION '              Duplication du repertoire ScriptMAJ '}
              //======================================
              // Duplication du repertoire ScriptMAJ
              //======================================
              for j := 0 to Lbx_ScriptMaj.Items.Count -1 do
              begin
                if Lbx_ScriptMaj.Selected[j] then
                begin
                  try
                    DestPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Lbx_ScriptMaj.Items[j]) + Lbx_RepVersion.Items[i]);
                    DoLog('');
                    DoLog('Traitement du partage : ' + DestPath);
                    // duplication du repertoire
                    for k := 0 to ExistingFiles.Count -1 do
                    begin
                      if not (ExtractFileName(ExistingFiles[k]) = 'Raccourci vers ' + SCRIPTEXE + '.lnk') then
                      begin
                        FileDest := DestPath + Copy(ExistingFiles[k], Length(MasterMAJPath) +1, Length(ExistingFiles[k]));
                        CRCloc := GetFileCRC(ExistingFiles[k]);
                        CRCdis := GetFileCRC(FileDest);
                        if not (CRCloc = CRCdis) then
                        begin
                          // Suppresion
                          if FileExists(FileDest) then
                            DeleteFile(FileDest);
                          DoLog('Copie du fichier depuis : ' + ExistingFiles[k]);
                          ForceDirectories(ExtractFileDir(FileDest));
                          if not CopyFile(PChar(ExistingFiles[k]), PChar(FileDest), false) then
                            Raise Exception.Create('Erreur de copie du fichier ' + ExistingFiles[k]);
                          // Vérification
                          CRCdis := GetFileCRC(FileDest);
                          if not (CRCloc = CRCdis) then
                            DoLog(' -> ATTENTION : erreur de verification du CRC (CRC local : ' + CRCloc + '; CRC distant : ' + CRCdis + ')');
                        end;
                      end;
                    end;
                    // fichier de racourci
                    CreateLink(DestPath + SCRIPTEXE, 'MANU', DestPath + 'Raccourci vers ' + SCRIPTEXE, SCRIPTEXE, DestPath, DestPath + SCRIPTEXE, 0);
                  except
                    on e : exception do
                    begin
                      FWarning := true;
                      DoLog('Exception lors de la copie vers : ' + Lbx_ScriptMaj.Items[j]);
                      DoLog('Exception : ' + e.ClassName + ' - ' + e.Message);
                      DoLog(' -> Celui ci n''est PAS A JOUR !!!');
                    end;
                  end;
                end;
              end;
{$ENDREGION}
            end;
          except
            on e : Exception do
            begin
              FErreur := true;
              DoLog('Exception lors du traitement de la version : ' + Lbx_RepVersion.Items[i]);
              DoLog('Exception : ' + e.ClassName + ' - ' + e.Message);
              DoLog(' -> Celle ci n''est PAS A JOUR !!!');
              if not FAutomatique then
                Raise;
            end;
          end
        end;
      end;

    finally
      AllowEdit(true);
    end;
  except
    on e : Exception do
    begin
      FErreur := true;
      DoLog('Fin du traitement suite a - Exception : ' + e.ClassName + ' - ' + e.Message);
    end;
  end;

  if FErreur then
  begin
    ExitCode := 1;
    if not FAutomatique then
    begin
      if MessageDlg('Il y a eu des erreurs lors du traitement.'#13'Voir le fichier de log.'#13 + FLogFile, mtError, [mbYes, mbNo], 0) = mrYes then
        ShellExecute(0, 'open', PChar(FLogFile), '', '', SW_SHOWDEFAULT);
    end;
  end
  else if FWarning then
  begin
    ExitCode := 2;
    if not FAutomatique then
    begin
      if MessageDlg('Il y a eu des warnings lors du traitement.'#13'Voir le fichier de log.'#13 + FLogFile, mtWarning, [mbYes, mbNo], 0) = mrYes then
        ShellExecute(0, 'open', PChar(FLogFile), '', '', SW_SHOWDEFAULT);
    end;
  end
  else
  begin
    ExitCode := 0;
    if not FAutomatique then
      MessageDlg('Traitement effectué sans erreur.', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

procedure TFrm_Main.Tim_AutoTimer(Sender: TObject);
begin
  Tim_Auto.Enabled := false;
  FAutomatique := true;
  Btn_TraitementClick(Sender);
  Btn_QuitterClick(Sender);
end;

// recherche des versions

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

// gestion de l'affichage

procedure TFrm_Main.AllowEdit(AValue : boolean);

  procedure EnabledAndChild(container: TWinControl; enabled : boolean);
  var
    index : integer;
    aControl : TControl;
  begin
    for index := 0 to container.ControlCount -1 do
    begin
      aControl := container.Controls[index];
      if ((csAcceptsControls in aControl.ControlStyle) or (aControl is TPageControl)) and (aControl is TWinControl) then
        EnabledAndChild(TWinControl(container.Controls[index]), enabled)
      else if not (acontrol is TCustomMemo) then
        aControl.Enabled := enabled;
    end;
    container.Enabled := enabled;
  end;

begin
  EnabledAndChild(Self, AValue);
  Application.ProcessMessages();
end;

// gestion de log

procedure TFrm_Main.InitLog(Prefix : string; memo : TMemo);
var
  Fichier : TextFile;
begin
  FLogFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log') + Prefix + FormatDateTime('yyyymmdd-hhnnss-zzz', Now()) + '.log';
  FLogMemo := memo;

  ForceDirectories(ExtractFilePath(FLogFile));
  try
    try
      AssignFile(Fichier, FLogFile);
      Rewrite(Fichier);
      Writeln(Fichier, 'Initialisation du log');
    finally
      CloseFile(Fichier);
    end;
  except
    // que faire...
  end;
end;

procedure TFrm_Main.DoLog(txt : string);
var
  Fichier : TextFile;
begin
  try
    // Memo ...
    if assigned(FLogMemo) then
    begin
      FLogMemo.Lines.Add(txt);
      Application.ProcessMessages();
    end;
    // Fichier ...
    if not (Trim(FLogFile) = '') then
    begin
      try
        AssignFile(Fichier, FLogFile);
        Append(Fichier);
        Writeln(Fichier, FormatDateTime('hh:nn:ss.zzz', Now) + ' - ' + txt);
      finally
        CloseFile(Fichier);
      end;
    end;
  except
    // que faire...
  end;
end;

end.
