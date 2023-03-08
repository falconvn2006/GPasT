unit Main_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, GinPanel, ExtCtrls, RzPanel, AdvGlowButton,
  AdvOfficePager, AdvOfficePagerStylers, StdCtrls, Main_DM, Cfg_Frm, uCommon,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,winsock, uCommonThread, uTCPThread,
  cxContainer, cxGroupBox, ComCtrls, Grids, DBGrids, uHttpThread, AdvProgr,
  Buttons, UVersion;

type
  Tfrm_BckMain = class(TAlgolDialogForm)
    Pan_Main: TRzPanel;
    GinPanel1: TGinPanel;
    Pan_Left: TRzPanel;
    Pan_Client: TRzPanel;
    GinPanel2: TGinPanel;
    aop_Main: TAdvOfficePager;
    AdvOfficePage1: TAdvOfficePage;
    AdvOfficePage2: TAdvOfficePage;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    Pan_PGBottom: TRzPanel;
    Pan_PGClient: TRzPanel;
    Pan_PGLeft: TRzPanel;
    Pan_PGRight: TRzPanel;
    SBx_Thread: TScrollBox;
    mmLogs: TMemo;
    Nbt_Parametres: TAdvGlowButton;
    nbt_Executer: TAdvGlowButton;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1SourceIP: TcxGridDBColumn;
    cxGrid1DBTableView1SourceDirectory: TcxGridDBColumn;
    cxGrid1DBTableView1SourceFile: TcxGridDBColumn;
    cxGrid1DBTableView1SourceFileDate: TcxGridDBColumn;
    cxGrid1DBTableView1DestinationPath: TcxGridDBColumn;
    cxGrid1DBTableView1SourceDelete: TcxGridDBColumn;
    cxGrid1DBTableView1DestinationZip: TcxGridDBColumn;
    cxGrid1DBTableView1DestinationSplit: TcxGridDBColumn;
    cxGrid1DBTableView1DestinationVersionning: TcxGridDBColumn;
    cxGrid1DBTableView1CopyDone: TcxGridDBColumn;
    cxGrid1DBTableView1ZipDone: TcxGridDBColumn;
    Tim_ThreadScan: TTimer;
    Label1: TLabel;
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
    procedure aop_MainChanging(Sender: TObject; FromPage, ToPage: Integer;
      var AllowChange: Boolean);
    procedure Nbt_ParametresClick(Sender: TObject);
    procedure nbt_ExecuterClick(Sender: TObject);
    procedure AlgolDialogFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Tim_ThreadScanTimer(Sender: TObject);
  private
    { Déclarations privées }
    iNbFile : Integer;
    iSizeFile : Int64;
    bModeAuto : Boolean;
  public
    { Déclarations publiques }
    // Ajout au Memo de logs et dans le fichier de logs
    procedure AddToMemo(AText : String);
    procedure GetFileList(sDir, sFilter : String);

  end;

var
  frm_BckMain: Tfrm_BckMain;

implementation

{$R *.dfm}

procedure Tfrm_BckMain.AddToMemo(AText: String);
var
  FFile : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;
begin
  With mmLogs do
  begin
    sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText;
    if Assigned(mmLogs) then
      mmLogs.Lines.Add(sLigne);

    if FileExists(GLOGSPATH + GLOGSNAME) then
    begin
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd);
    end else
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmCreate);
    try
      // Ajoute un retour à la ligne pour le fichier text
      sLigne := sLigne + #13#10;

      Encoding := TEncoding.Default;
      Buffer := Encoding.GetBytes(sLigne);
      FFile.Write(Buffer[0],Length(Buffer));
    finally
      FFile.Free;
    end;
  end;
end;

procedure Tfrm_BckMain.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DM_BckMain.Free;
end;

procedure Tfrm_BckMain.AlgolDialogFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not bInProgress;
end;

procedure Tfrm_BckMain.AlgolDialogFormCreate(Sender: TObject);
begin
  Caption := 'BackUp2011 - Version ' + GetNumVersionSoft;
  // Initialisation
  DM_BckMain := TDM_BckMain.Create(Self);
  FCanChangePage := False;
  AdvOfficePage2.TabVisible := False;
  bInProgress := False;

  GAPPPATH := ExtractFilePath(Application.ExeName);
  GAPPCFGPATH := GAPPPATH + 'config\';
  GLOGSPATH  := GAPPPATH + 'Logs\' + FormatDateTime('YY\MM\',Now);
  GLOGSNAME  := FormatDateTime('YYYYMMDDhhmmss',Now) + '.txt';

  DoDir(GAPPCFGPATH);
  DoDir(GLOGSPATH);

  // Chargement de la configuration
  MainCfg.LoadConfig;
  DM_BckMain.LoadConfig;

  bModeAuto := False;
  if ParamCount > 0 then
    if Uppercase(ParamStr(1)) = 'AUTO' then
    begin
      bModeAuto := True;
      nbt_Executer.Click;
    end;
end;

procedure Tfrm_BckMain.aop_MainChanging(Sender: TObject; FromPage,
  ToPage: Integer; var AllowChange: Boolean);
begin
  AllowChange := FCanChangePage;
end;

procedure Tfrm_BckMain.GetFileList(sDir, sFilter: String);
var
  i : integer;
  Search : TSearchRec;
  sTmp : String;
begin
  try
    i := FindFirst(IncludeTrailingPathDelimiter(sDir) + '*.*',faAnyFile,Search);
    while i = 0 do
    begin
      if (Search.Name <> '.') and (Search.Name <> '..') then
      begin
        label1.Caption := 'Scan en cours : ' + IncludeTrailingPathDelimiter(sDir) + Search.Name;
        if (Search.Attr and faDirectory) <> 0 then
        begin
          // On ne traite que les répertoires qui n'ont pas DelosQPMAgent.dll
          if (not FileExists(IncludeTrailingPathDelimiter(sDir) + Search.Name + '\DelosQPMAgent.dll')) or (Not MainCfg.GinKoiaMode)  then
            GetFileList(IncludeTrailingPathDelimiter(sDir) + Search.Name,sFilter)
        end
        else
          if (UpperCase(ExtractFileExt(Search.Name)) = Uppercase(sFilter)) or (sFilter = '.*') then
            if not DM_BckMain.cds_ExcludeList.Locate('FileName', ExtractFileName(Search.Name),[loCaseInsensitive]) then
              With DM_BckMain do
              begin
                inc(iNbFile);
                iSizeFile := iSizeFile + Search.Size;
                sTmp := ExtractFileDrive(sDir);
//                sTmp := Copy(sTmp,1,Length(sTmp) - (Length(ExtractFilePath(sTmp)) + 1));
                if cds_ListDirectory.FieldByName('LogonActive').AsBoolean then
                  AddToFileList(sTmp,
                                cds_ListDirectory.FieldByName('MainDirectory').AsString,
                                IncludeTrailingPathDelimiter(sDir) + Search.Name,
                                cds_ListDirectory.FieldByName('DestDirectory').AsString,
                                cds_ListExtensionFile.FieldByName('SourceDelete').AsBoolean,
                                cds_ListExtensionFile.FieldByName('DestZip').AsBoolean,
                                cds_ListExtensionFile.FieldByName('SplitZip').AsBoolean,
                                cds_ListExtensionFile.FieldByName('Versionning').AsBoolean,
                                cds_ListDirectory.FieldByName('TypeTransfert').AsInteger,
                                True,
                                cds_ListDirectory.FieldByName('LogonUser').AsString,
                                cds_ListDirectory.FieldByName('LogonPasword').AsString)
                else
                  AddToFileList(sTmp,
                                cds_ListDirectory.FieldByName('MainDirectory').AsString,
                                IncludeTrailingPathDelimiter(sDir) + Search.Name,
                                cds_ListDirectory.FieldByName('DestDirectory').AsString,
                                cds_ListExtensionFile.FieldByName('SourceDelete').AsBoolean,
                                cds_ListExtensionFile.FieldByName('DestZip').AsBoolean,
                                cds_ListExtensionFile.FieldByName('SplitZip').AsBoolean,
                                cds_ListExtensionFile.FieldByName('Versionning').AsBoolean,
                                cds_ListDirectory.FieldByName('TypeTransfert').AsInteger);
              end; // with
      end;
      i := FindNext(Search);
      Application.ProcessMessages;
    end;
    FindClose(Search);
  Except on E:Exception do
    raise Exception.Create('GetFileList -> ' + E.Message);
  end;
end;

procedure Tfrm_BckMain.nbt_ExecuterClick(Sender: TObject);
begin
  if bInProgress then
    exit;

  AddToMemo('------ Début du traitement ------');
  bInProgress := True;
  // Scan du répertoire source par rapport à la configuration
  AddToMemo('Récupération des fichiers à traiter');

  With DM_BckMain do
  try
    OT_ThreadList := TOLThread.create;
    OT_ThreadList.OwnsObjects := True;

    cds_ListDirectory.First;
    cds_ListExtensionFile.First;

    while not cds_ListDirectory.Eof do
    begin
      Try
        case cds_ListDirectory.FieldByName('Typetransfert').AsInteger of
          0: begin
          if cds_ListExtensionFile.Locate('Idx',cds_ListDirectory.FieldByName('Idx').AsInteger,[]) then
            while (cds_ListDirectory.FieldByName('Idx').AsInteger = cds_ListExtensionFile.FieldByName('Idx').AsInteger) and
                  (not cds_ListExtensionFile.Eof) do
            begin
              // récupération de la liste des fichiers
              iNbFile := 0;
              iSizeFile := 0;
              GetFileList(cds_ListDirectory.FieldByName('MainDirectory').AsString,'.' + cds_ListExtensionFile.FieldByName('ExtName').AsString);
              AddToMemo('source : ' + cds_ListDirectory.FieldByName('MainDirectory').AsString +
                        ' - Nombre Fichiers ' + UpperCase(cds_ListExtensionFile.FieldByName('ExtName').AsString) + ' : (' + IntToStr(iNbFile) + ')' +
                        ' - Taille totale : ' + FormatFloat('0.00',iSizeFile / 1024 / 1024 / 1024) + 'Go');
              cds_ListExtensionFile.Next;
            end;
          end; // 0
          1: AddToFileList('HTTP','',cds_ListDirectory.FieldByName('MainDirectory').AsString,cds_ListDirectory.FieldByName('DestDirectory').AsString,False,False,False,False,cds_ListDirectory.FieldByName('Typetransfert').AsInteger);
        end;
      Except on E:Exception do
        begin
          AddToMemo('Erreur : ' + E.Message);
          AddToMemo('Source : ' + cds_ListDirectory.FieldByName('MainDirectory').AsString);
        end;
      End;
      cds_ListDirectory.Next;
    end;

  // Gestion du timer pour les traitements des thread
  GActionMode:= maCopy; // Initilisation de la première action à rélaliser
  Tim_ThreadScan.Enabled := True;
  while bInProgress do
    Application.ProcessMessages;
  Tim_ThreadScan.Enabled := False;

  finally
    OT_ThreadList.free;
  end;
  AddToMemo('------  fin du traitement  ------');
  if bModeAuto then
    Application.Terminate;
end;

procedure Tfrm_BckMain.Nbt_ParametresClick(Sender: TObject);
begin
  if bInProgress then
    exit;

  FCanChangePage := True;
  aop_Main.ActivePageIndex := 1;

//  AdvOfficePage2.Visible := True;
   AdvOfficePage2.TabVisible := True;
  if AdvOfficePage2.ComponentCount < 1 then
    With Tfrm_CFG.Create(AdvOfficePage2) do
    begin
      Parent := AdvOfficePage2;
      Visible := True;
      Align := alClient;
    end;
  FCanChangePage := False;
end;

procedure Tfrm_BckMain.Tim_ThreadScanTimer(Sender: TObject);
var
  bNew : Boolean;
  i, j : Integer;
  NewThread : TCMNThread;
  bZipMode, bDelMode, bCopyMode : Boolean;

begin
  Tim_ThreadScan.Enabled := False;
  try
    if bInProgress then
    begin
      With DM_BckMain do
      begin
        bNew := True;
        while bNew Do
        begin
          bNew := False;
//          AddToMemo('Thread : '  + IntToStr(OT_ThreadList.Count));
          if OT_ThreadList.Count <= MainCfg.NbThread then
          begin
            cds_FileList.DisableControls;
            cds_FileList.First;
            cds_FileList.Filtered := False;
            case GActionMode of
              maCopy : cds_FileList.Filter    := 'CopyDone = 0';
              maZip  : cds_FileList.Filter    := 'CopyDone <> 0 and ZipDone = 0 and DestinationZip = 1';
              maDel  : cds_FileList.Filter    := 'Copydone <> 0 and DelDone = 0 and SourceDelete = 1';
            end;
            cds_FileList.Filtered := True;
            while (not cds_FileList.Eof) and not bNew do
            begin
              // Permet de traiter les modes séquentiellement
              bCopyMode := (not cds_FileList.FieldByName('CopyDone').AsBoolean and
                          (GActionMode = maCopy));
              bZipMode := (not cds_FileList.FieldByName('ZipDone').AsBoolean and
                          cds_FileList.FieldByName('DestinationZip').AsBoolean and
                          (GActionMode = maZip));
              bDelMode := (not cds_FileList.FieldByName('DelDone').AsBoolean and
                          cds_FileList.FieldByName('SourceDelete').AsBoolean and
                          (GActionMode = maDel));

              if bCopyMode or bZipMode or bDelMode then
              begin
                // Vérification qu'un thread avec cette ip n'est pas déjà en cours
                bNew := True;
                for i := 0 to OT_ThreadList.Count -1 do
                  if (OT_ThreadList.Items[i].IpSource = cds_FileList.FieldByName('SourceIp').AsString) then
                    bNew := False;
                // Création d'un nouveau Thread
                if bNew then
                begin
                 case cds_FileList.FieldByName('TypeTransfert').AsInteger of
                   0: NewThread := TTCPThread.Create(True);
                   1: NewThread := THTTPThread.Create(True);
                 end;
                 OT_ThreadList.Add(NewThread);
                 NewThread.IpSource        := cds_FileList.FieldByName('SourceIp').AsString;
                 NewThread.SourceDir       := cds_FileList.FieldByName('SourceDirectory').AsString;
                 NewThread.SourceFile      := cds_FileList.FieldByName('SourceFile').AsString;
                 NewThread.DestinationDir  := cds_FileList.FieldByName('DestinationPath').AsString;
                 NewThread.Versionning     := cds_FileList.FieldByName('DestinationVersionning').AsBoolean;
                 NewThread.SplitZip        := cds_FileList.FieldByName('DestinationSplit').AsBoolean;
                 NewThread.ParentScrollBox := SBx_Thread;
                 NewThread.LogNetWork := cds_FileList.FieldByName('LogonActive').AsBoolean;
                 if cds_FileList.FieldByName('LogonActive').AsBoolean then
                 begin
                   NewThread.LogUser := cds_FileList.FieldByName('LogonUser').AsString;
                   NewThread.LogPassword := cds_FileList.FieldByName('LogonPassword').AsString;
                 end;
                 NewThread.ActionMode      := GActionMode;

                 case GActionMode of
                   maCopy: begin
                     AddToMemo('Copie de : ' + cds_FileList.FieldByName('SourceFile').AsString + ' Vers ' + cds_FileList.FieldByName('DestinationPath').AsString);
                     NewThread.CreateLogBox('Copie du fichier : ');
                   end;
                   maZip : NewThread.CreateLogBox('Compression du fichier : ', cmZip);
                   maDel : NewThread.CreateLogBox('Suppression du fichier : ', cmDel);
                 end;

                 NewThread.Resume;
                 bNew := True;
                end;
              end;
              cds_FileList.Next;
            end; // while
            cds_FileList.EnableControls;
          end;

          // Vérification qu'un thread n'est pas fini
          for i := OT_ThreadList.Count -1 Downto 0 do
            if OT_ThreadList.Items[i].isTerminated then
            begin
              // Mise à jour des information de la grille
              if cds_FileList.Locate('SourceIP;SourceFile',VarArrayOf([OT_ThreadList.Items[i].IpSource,OT_ThreadList.Items[i].SourceFile]),[loCaseInsensitive]) then
              begin
                cds_FileList.Edit;
                case GActionMode of
                  maCopy: cds_FileList.FieldByName('CopyDone').AsBoolean := True;
                  maZip: cds_FileList.FieldByName('ZipDone').AsBoolean := True;
                  maDel: cds_FileList.FieldByName('DelDone').AsBoolean := True;
                end;
                cds_FileList.Post;
                for j := 0 to OT_ThreadList.Items[i].Logs.Count -1 do
                  AddToMemo(OT_ThreadList.Items[i].Logs[j]);
                OT_ThreadList.Items[i].DestroyLogBox;
                OT_ThreadList.Delete(i);
              end;
            end;

          if cds_FileList.Eof and cds_FileList.Bof then
          begin
            case GActionMode of
              maCopy: GActionMode := maZip;
              maZip: begin
                case cds_FileList.FieldByName('TypeTransfert').AsInteger of
                  0: GActionMode := maDel; // TCP
                  1: GActionMode := maEnd; // HTTP
                end;
              end;
              maDel: GActionMode := maEnd;
            end;
            bInProgress := GActionMode <> maEnd;
          end;
        end; // while bFound
      end;  // with
    end;
  finally
    Tim_ThreadScan.Enabled := True;
  end;
end;

end.
