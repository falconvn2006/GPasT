unit uParams;

// transporteur des paramétres
interface

uses Winapi.Windows, Winapi.Messages, SysUtils, System.Variants, System.Classes, System.Types,
  System.IOUtils, IniFiles, Dialogs,
  // Début Uses Perso
  uFunctions,
  uRessourcestr,
  uSevenZip,
  // uLogfile, ancien log
  uLog,
  uLameFileparser,
  uDownloadfromlame,
  uPatchScript,
  uInstallbase,
  uBasetest,
  registry,
  ShlObj,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.Win.msxmldom,
  Xml.XMLDoc,
  // Fin Uses Perso
  Vcl.Forms, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  System.StrUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.CheckLst;

Const
  WM_LOADLISTFROMLAME = WM_USER + 101;
  FROMLAME = 3;
  Log_Mdl = 'uParams';

Type
  TransportParam = Class
  class var
    lame: string;
    class var lamemaj: string;
    class var ticket: string;
    class var Pathbasetest: string;
    procedure LoadListFromLame;
    function LoadIniVersionLame: Boolean;
    function LoadSoftwarLame(NomVersion: string): Boolean;
  private
    { Déclarations privées }
    ptAfterDownload: TAfterDownload;
    ptBeforeDownload: TBeforeDownload;
    ptProgress: TDisplayprogress;
    ptBeforeReset: TBeforeReset;
    function getDeploiementIni(aFileName: string): Boolean;
  public
    { Déclarations publiques }
    IniParam: TIniFile;
    procedure InitLoadUtil;
    procedure CreateIni(aPath: String);
    function DownloadIni(aType: String): Boolean;
    function DownloadVersionIni(aType: String): Boolean;
    procedure EncrypFieldIni(aPath: String);
    function UpVersionIni(aPathDL, aPathIn: String): Boolean;
    Function IsRightVersion: Boolean;
    function DownloadSofware(NumVersion: String): Boolean;
    function XmlSetLetterDir(DirGinkoia: string): Boolean;
  published
    { Déclarations published }
  End;

Var
  VersionSoftLame: string;

implementation

uses Main_Dm;

{ TransportParam }

procedure TransportParam.CreateIni(aPath: String);
var
  oMsg: TForm;
begin
  // Ouverture ou creation du fichier iNi
  if FileExists(aPath) then
  begin
    // IniParam := TIniFile.Create(aPath);
  end
  else
  begin
    // oMsg := CreateMessageDialog('Fichier Deploiement.ini introuvable' + #10 + 'Voulez-vous le télécharger', mtConfirmation, [mbYes, mbNo]);
    // oMsg.Position := poScreenCenter;
    // oMsg.FormStyle := fsStayOnTop;
    //
    // if oMsg.ShowModal = IDYES then
    // begin
    // getDeploiementIni(ExtractFilePath(ParamStr(0)) + NameFileParam);
    // end;

    // on créé l'ini en local directement à présent

    // si l'ini n'existe pas on le télécharge par défaut
    getDeploiementIni(ExtractFilePath(ParamStr(0)) + NameFileParam);

  end;

end;

function TransportParam.getDeploiementIni(aFileName: string): Boolean;
Const
	Log_Key = 'getDeploiementIni';
var
  vClient: TidHTTP;
  vUrl: string;
  vStream: TStringStream;
begin
  try
    vUrl := 'http://lame2.ginkoia.eu/algol/Deploy/Deploiement.ini';

    vClient := TidHTTP.Create(nil);
    try
      vStream := TStringStream.Create;
      try
        try
          vClient.Get(vUrl, vStream);
        except
        end;

        Result := (vClient.ResponseCode = 200);

        if Result then
        begin
          vStream.SaveToFile(aFileName);
        end;

      finally
        vStream.Free;
      end;
    finally
      vClient.Free;
    end;

    if Result then
      EncrypFieldIni(aFileName);
  except
    on E: Exception do
      //Log.Log('Erreur lors de la récupèration de la version lame : ' + E.Message, logError, 'getVersionDeployLame');
      Log.Log(Log_Mdl,Log_Key, 'Erreur lors de la récupèration de la version lame : ' + E.Message, logError, True, 0, ltBoth);
  end;
end;

function TransportParam.DownloadIni(aType: String): Boolean;
Const
	Log_Key = 'DownloadIni';
var
  sTemp, sTempPath, aMsg: string;
  af: TStringDynArray; // pour rechercher le fichier
  fs: string; // pour évaluer chacune des valeurs de af
  IniDL, IniHere: TIniFile;
begin
  // Fonction qui permet de télécharger le fichier .Ini de paramétrage
  try
    TLameFileDownloader.Reset;
    Postmessage(Application.Handle, WM_LOADLISTFROMLAME, 0, 0);
    LoadListFromLame;

    TLameFileParser.GetClientFiles('Deploiement');

    TLameFileParser.GetFile('Deploiement');
    fs := TLameFileParser.GetFullFileToDownloadPath;

    TLameFileDownloader.SetUrl(fs);

    Try
      TLameFileDownloader.Downloadfile(FROMLAME);
    Finally
      // TLameFileDownloader.Done := True;
      // compare version
      if UpVersionIni(TLameFileDownloader.Localfile, PChar(ExtractFilePath(ParamStr(0)) + NameFileParam)) then
      begin
        // Delete file if it exist
        if FileExists(ExtractFilePath(ParamStr(0)) + NameFileParam) then
          DeleteFile(ExtractFilePath(ParamStr(0)) + NameFileParam);

        // To Move the .ini file
        if FileExists(TLameFileDownloader.Localfile) then
          MoveFile(PChar(TLameFileDownloader.Localfile), PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));

        if FileExists(TLameFileDownloader.Localfile) then
          DeleteFile(TLameFileDownloader.Localfile);
      end
      else
      begin
        // No update delete ini file's downloaded
        if FileExists(TLameFileDownloader.Localfile) then
          DeleteFile(TLameFileDownloader.Localfile);
      end;

      TLameFileDownloader.Reset;

      EncrypFieldIni(PChar(ExtractFilePath(ParamStr(0)) + NameFileParam));
    End;
  Except
    On E: Exception do
    begin
      // Tlogfile.Addline('****'+DateTimeToStr(Now)+' '+E.Message);
      //Log.Log(E.Message, logError);
      Log.Log(Log_Mdl,Log_Key, 'Erreur ' + E.Message, logError, True, 0, ltBoth);
      Showmessage(E.Message);
    end;
  End;
end;

function TransportParam.DownloadSofware(NumVersion: String): Boolean;
Const
	Log_Key = 'DownloadSofware';
var
  sTemp, sTempPath, aMsg: string;
  af: TStringDynArray; // pour rechercher le fichier
  fs: string; // pour évaluer chacune des valeurs de af
begin
  // Function used for downloading the latest software version
  try
    TLameFileDownloader.Reset;
    Postmessage(Application.Handle, WM_LOADLISTFROMLAME, 0, 0);
    LoadSoftwarLame(NumVersion);

    TLameFileParser.GetClientFiles(NumVersion);

    TLameFileParser.GetFile(NumVersion);
    fs := TLameFileParser.GetFullFileToDownloadPath;

    TLameFileDownloader.SetUrl(fs);

    Try
      TLameFileDownloader.Downloadfile(FROMLAME);

    Finally
      // TLameFileDownloader.Reset;
    End;
  Except
    On E: Exception do
    begin
      //Log.Log(E.Message, logError);
      Log.Log(Log_Mdl,Log_Key, 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
      Showmessage(E.Message);
    end;
  End;
end;

function TransportParam.DownloadVersionIni(aType: String): Boolean;
Const
	Log_Key = 'DownloadVersionIni';
var
  sTemp, sTempPath, aMsg: string;
  af: TStringDynArray; // pour rechercher le fichier
  fs: string; // pour évaluer chacune des valeurs de af
  IniDL, IniHere: TIniFile;
begin
  // Function used for downloading of ini version file of this software
  try
    TLameFileDownloader.Reset;
    Postmessage(Application.Handle, WM_LOADLISTFROMLAME, 0, 0);
    LoadIniVersionLame;

    TLameFileParser.GetClientFiles('Version_Deploy');

    TLameFileParser.GetFile('Version_Deploy');
    fs := TLameFileParser.GetFullFileToDownloadPath;

    TLameFileDownloader.SetUrl(fs);

    Try
      TLameFileDownloader.Downloadfile(FROMLAME);

      // To Move the .ini file
      if FileExists(ExtractFilePath(ParamStr(0)) + NameVersion) then
        DeleteFile(ExtractFilePath(ParamStr(0)) + NameVersion);

      if FileExists(TLameFileDownloader.Localfile) then
        MoveFile(PChar(TLameFileDownloader.Localfile), PChar(ExtractFilePath(ParamStr(0)) + NameVersion));
    Finally
      // TLameFileDownloader.Done := True;
      TLameFileDownloader.Reset;

    End;
  Except
    On E: Exception do
    begin
      // Tlogfile.Addline('****'+DateTimeToStr(Now)+' '+E.Message);
      //Log.Log(E.Message, logError);
      Log.Log(Log_Mdl,Log_Key, 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
      Showmessage(E.Message);
    end;
  End;
end;

procedure TransportParam.EncrypFieldIni(aPath: String);
var
  ParamIni: TIniFile;
  ValueLstSection, ValueLstInSection, ValueLstInGSection: TStringList;
  i: Integer;
  Value, ValueMaj: String;
begin
  // procedure to encript ini field
  // Open File
  ParamIni := TIniFile.Create(aPath);
  ValueLstSection := TStringList.Create;
  ValueLstInSection := TStringList.Create;
  ValueLstInGSection := TStringList.Create;
  i := 0;

  try
    // Looking for the existance of the section
    // Intersport
    if ParamIni.SectionExists('LAME_ISF') then
    begin
      ParamIni.ReadSections(ValueLstSection);
      ParamIni.ReadSection('LAME_ISF', ValueLstInSection);

      for i := 0 to ValueLstInSection.Count do
      begin
        // Look over ini file sections
        if ParamIni.ValueExists('LAME_ISF', 'SYMR' + IntToStr(i)) then
        begin
          Value := ParamIni.ReadString('LAME_ISF', 'SYMR' + IntToStr(i), '');
          if (Value.Contains('sym')) or (Value.Contains('http')) then
          begin
            // It's unccoded we should code it
            Value := EnCryptDeCrypt(Value);
            ParamIni.WriteString('LAME_ISF', 'SYMR' + IntToStr(i), Value);
          end;
        end;

        if ParamIni.ValueExists('LAME_ISF', 'MAJ' + IntToStr(i)) then
        begin
          ValueMaj := ParamIni.ReadString('LAME_ISF', 'MAJ' + IntToStr(i), '');
          if (ValueMaj.Contains('sym')) or (ValueMaj.Contains('http')) then
          begin
            // It's unccoded we should code it
            ValueMaj := EnCryptDeCrypt(ValueMaj);
            ParamIni.WriteString('LAME_ISF', 'MAJ' + IntToStr(i), ValueMaj);
          end;
        end;

      end;
    end;

    // Ginkoia
    i := 0;
    Value := '';

    if ParamIni.SectionExists('LAME_GINKOIA') then
    begin
      ParamIni.ReadSection('LAME_GINKOIA', ValueLstInGSection);

      for i := 0 to ValueLstInGSection.Count do
      begin
        Value := ParamIni.ReadString('LAME_GINKOIA', 'LAME' + IntToStr(i), '');
        if (Value.Contains('lame')) or (Value.Contains('http')) then
        begin
          // It's unccoded we should code it
          Value := EnCryptDeCrypt(Value);
          ParamIni.WriteString('LAME_GINKOIA', 'LAME' + IntToStr(i), Value);
        end;

        ValueMaj := ParamIni.ReadString('LAME_GINKOIA', 'MAJ' + IntToStr(i), '');
        if (ValueMaj.Contains('sym')) or (ValueMaj.Contains('http')) then
        begin
          ValueMaj := EnCryptDeCrypt(ValueMaj);
          ParamIni.WriteString('LAME_GINKOIA', 'MAJ' + IntToStr(i), ValueMaj);
        end;

      end;
    end;
  finally
    ParamIni.Free;
    ValueLstSection.Free;
    ValueLstInSection.Free;
  end;
end;

procedure TransportParam.InitLoadUtil;
begin
  // procedure d'initialisation
  // Tlogfile.InitLog(False);

end;

function TransportParam.IsRightVersion: Boolean;
const
  Log_Key = 'IsRightVersion';
var
  VersionIni: TIniFile;
  NumInIniVersion: string;
  NumSoftVersion: string;
begin
  // function used for know if the  software's version is the latest
  Result := false;

  try
    VersionIni := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0)) + NameVersion));
    NumInIniVersion := VersionIni.ReadString('VERSION_DEPLOY', 'VERSION', '');

    if NumInIniVersion <> '' then
      VersionSoftLame := NumInIniVersion;

    try
      NumSoftVersion := uFunctions.GetVersion(Application.ExeName, Application.Handle);

      if ContainsStr(NumSoftVersion, NumInIniVersion) then
        Result := True;

    except
      on E: Exception do
      begin
        //Log.Log(E.Message, logError);
        Log.Log(Log_Mdl,Log_Key, 'Erreur : ' + E.Message, logError, True, 0, ltBoth);
        Showmessage(E.Message);
      end;
    end;
  finally
    VersionIni.Free;
  end;
end;

function TransportParam.LoadIniVersionLame: Boolean;
var
  fs, sLame: string;
  ptFilter: TFilter_Perso;
  bOk: Boolean;
  Nbtentative: Integer;
  oMsg: TForm;
begin
  // this procedure is used for downloading ini's version file from LAME 2
  ptFilter := function(sFile: string): Boolean
    begin
      if sFile.Contains('Version_Deploy') = True then
        Exit(True)
      else
        Exit(false);
    end;

  Application.ProcessMessages;
  bOk := false;
  if (bOk = false) and (Nbtentative = 0) then
  begin
    sLame := 'http://lame2.ginkoia.eu/algol/Deploy/';

    TLameFileParser.SetUrl(sLame);
    TLameFileParser.Filter := ptFilter;
    TLameFileParser.GetFiles('.ini');

    for fs in TLameFileParser.TlistFiles do
    begin
      if fs.Contains('Version_Deploy') = True then
      begin
        bOk := True;
        break;
      end;
    end;

    if bOk = false then
    begin
      Try
        if TLameFileParser.noFile = false then
          oMsg := CreateMessageDialog('Le fichier Deploy-Version.ini est introuvable', mtError, [mbOk])
        else
        begin
          // pas de fichiers sur la lame problème de connection ?
          oMsg := CreateMessageDialog(RST_NOFILE, mtError, [mbOk])
        end;

        oMsg.Position := poOwnerFormCenter;
        oMsg.FormStyle := fsStayOnTop;
        oMsg.ShowModal;
      Finally
        FreeAndNil(oMsg);
      End;
    end;
  end;

end;

procedure TransportParam.LoadListFromLame;
var
  fs, sLame: string;
  ptFilter: TFilter_Perso;
  bOk: Boolean;
  oMsg: TForm;
  Nbtentative: Integer;
begin
  ptFilter := function(sFile: string): Boolean
    begin
      if sFile.Contains('Deploiement') = True then
        Exit(True)
      else
        Exit(false);
    end;

  Application.ProcessMessages;
  bOk := false;
  if (bOk = false) and (Nbtentative = 0) then
  begin
    sLame := 'http://lame2.ginkoia.eu/algol/Deploiement/';

    TLameFileParser.SetUrl(sLame);
    TLameFileParser.Filter := ptFilter;
    TLameFileParser.GetFiles('.ini');

    for fs in TLameFileParser.TlistFiles do
    begin
      if fs.Contains('Deploiement') = True then
      begin
        bOk := True;
        break;
      end;
    end;
  end;
  if bOk = false then
  begin
    Try
      if TLameFileParser.noFile = false then
        oMsg := CreateMessageDialog('Le fichier Deploiement.ini est introuvable', mtError, [mbOk])
      else
      begin
        // pas de fichiers sur la lame problème de connection ?
        oMsg := CreateMessageDialog(RST_NOFILE, mtError, [mbOk])
      end;

      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      oMsg.ShowModal;
    Finally
      FreeAndNil(oMsg);
    End;
  end;
end;

function TransportParam.LoadSoftwarLame(NomVersion: string): Boolean;
var
  fs, sLame: string;
  ptFilter: TFilter_Perso;
  bOk: Boolean;
  oMsg: TForm;
  Nbtentative: Integer;
begin
  ptFilter := function(sFile: string): Boolean
    begin
      if sFile.Contains(NomVersion) = True then
        Exit(True)
      else
        Exit(false);
    end;

  Application.ProcessMessages;
  bOk := false;
  if (bOk = false) then
  begin
    sLame := 'http://lame2.ginkoia.eu/algol/Deploy/';

    TLameFileParser.SetUrl(sLame);
    TLameFileParser.Filter := ptFilter;
    TLameFileParser.GetFiles('.zip');

    for fs in TLameFileParser.TlistFiles do
    begin
      if fs.Contains(NomVersion) = True then
      begin
        bOk := True;
        break;
      end;
    end;
  end;
  if bOk = false then
  begin
    Try
      if TLameFileParser.noFile = false then
        oMsg := CreateMessageDialog('Le fichier est introuvable', mtError, [mbOk])
      else
      begin
        // pas de fichiers sur la lame problème de connection ?
        oMsg := CreateMessageDialog(RST_NOFILE, mtError, [mbOk])
      end;

      oMsg.Position := poOwnerFormCenter;
      oMsg.FormStyle := fsStayOnTop;
      oMsg.ShowModal;
    Finally
      FreeAndNil(oMsg);
    End;
  end;
end;

function TransportParam.UpVersionIni(aPathDL, aPathIn: String): Boolean;
var
  IniDL, IniIn: TIniFile;
  VersionDL, VersionIn: String;
begin
  // function use to check ini's version for update or not
  Result := false;
  try
    IniDL := TIniFile.Create(aPathDL);

    if aPathIn <> '' then
    begin
      IniIn := TIniFile.Create(aPathIn);
    end
    else
    begin
      Result := True;
      Exit;
    end;

    VersionDL := IniDL.ReadString('VERSION_PARAM', 'VERSION', '');
    VersionIn := IniIn.ReadString('VERSION_PARAM', 'VERSION', '');

    if (VersionDL <> VersionIn) then
      Result := True;

  finally
    IniDL.Free;
    IniIn.Free;
  end;
end;

function TransportParam.XmlSetLetterDir(DirGinkoia: string): Boolean;
var
  LetterDirectory: string;
  DirInXml: String;
  XmlData: IXMLDocument;
  SNode, SidNode, SubNode, SsNode, SSsNode: IXMLNode;
begin
  // function used for write in the xmldata file the letter install ginkoia directory
  // Get the first charactere
  LetterDirectory := LeftStr(DirGinkoia, 1);

  // let's open xml file
  XmlData := TXMLDocument.Create(DirGinkoia + 'GINKOIA\EAI\DelosQPMAgent.DataSources.xml');
  try
    XmlData.Active := True;

    SNode := XmlData.ChildNodes.FindNode('DataSources');
    SidNode := SNode.ChildNodes.FindNode('DataSource');
    SubNode := SidNode.ChildNodes.FindNode('Params');
    SsNode := SubNode.ChildNodes.FindNode('Param');
    SSsNode := SsNode.ChildNodes.FindNode('Value');

    DirInXml := SSsNode.Text;

    DirInXml := LeftStr(DirInXml, 1);

    if LetterDirectory <> DirInXml then
    begin
      SSsNode.ChildNodes.BeginUpdate;
      SSsNode.NodeValue := LetterDirectory + '\GINKOIA\DATA\GINKOIA.IB';
      SSsNode.ChildNodes.EndUpdate;
      XmlData.SaveToFile(DirGinkoia + 'GINKOIA\EAI\DelosQPMAgent.DataSources.xml');
    end;
  finally
    XmlData.Active := false;
  end;
end;

end.
