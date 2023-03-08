unit EasyRepriseCrash_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Vcl.ComCtrls,uInstallDossierMag, uSevenZip, System.IniFiles,
  {dxGDIPlusClasses,}uDownloadHTTP, IdURI, System.JSON,  System.RegularExpressionsCore, ShellAPI,
  Vcl.Menus;

type
  TForm17 = class(TForm)
    gr: TGroupBox;
    Label1: TLabel;
    BSTOPEASY: TButton;
    Label2: TLabel;
    Label3: TLabel;
    BLISTSPLIT: TButton;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    BSTARTEASY: TButton;
    Label9: TLabel;
    GroupBox1: TGroupBox;
    lblInfoEASY: TLabel;
    Label5: TLabel;
    BDELETETMP: TButton;
    Label10: TLabel;
    BCCLAME: TButton;
    BCCMAG: TButton;
    Label11: TLabel;
    Lbl_Update: TLabel;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    N2: TMenuItem;
    Mettrejour: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BLISTSPLITClick(Sender: TObject);
    procedure Creation7zdll;
    procedure BSTOPEASYClick(Sender: TObject);
    procedure BSTARTEASYClick(Sender: TObject);
    procedure BCCLAMEClick(Sender: TObject);
    procedure BCCMAGClick(Sender: TObject);
    procedure BDELETETMPClick(Sender: TObject);
  private
    FDossier     : string;
    FUrlLameApp  : string;
//    procedure Un7zSplitFile(zipFullFname:string);
    procedure GetInfoServiceEASY;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form17: TForm17;

implementation

{$R *.dfm}

Uses UWMI,UCommun, uListSplittagesDistants, ServiceControler;

procedure TForm17.BSTOPEASYClick(Sender: TObject);
var vStart: cardinal;
begin
    BSTOPEASY.Enabled:=false;
    ServiceStop('', 'EASY');
    vStart := GetTickCount();
    while GetTickCount-vStart<1000 do
      begin
         Sleep(100);
         Application.ProcessMessages;
      end;
    GetInfoServiceEASY;
end;

procedure TForm17.BDELETETMPClick(Sender: TObject);
var ShOp: TSHFileOpStruct;
begin
  ShOp.Wnd := Self.Handle;
  ShOp.wFunc := FO_DELETE;
  ShOp.pFrom := PChar(VGSYMDS[0].Directory+'\tmp\*.*'#0);
  ShOp.pTo := nil;
  ShOp.fFlags := 0 or FOF_ALLOWUNDO;
  SHFileOperation(ShOp);
end;

procedure TForm17.BLISTSPLITClick(Sender: TObject);
var ShOp: TSHFileOpStruct;
begin
    ShOp.Wnd := Self.Handle;
    ShOp.wFunc := FO_DELETE;
    ShOp.pFrom := PChar(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'split\*.*'#0);
    ShOp.pTo := nil;
    ShOp.fFlags := FOF_NOCONFIRMATION or FOF_ALLOWUNDO;
    SHFileOperation(ShOp);

    if FileExists(VGIB[0].DatabaseFile) then
      begin
         // votre fichier est présent
         MessageDlg('Le fichier ' + VGIB[0].DatabaseFile + ' est déjà présent',  mtError, [mbOK], 0);
         exit;
         //
      end;
    Application.CreateForm(TFrm_SplittagesDistants,Frm_SplittagesDistants);
    Frm_SplittagesDistants.NomPourNous    := FDossier;
    Frm_SplittagesDistants.AutoClose      := true;
    Frm_SplittagesDistants.Unzip          := true;
    Frm_SplittagesDistants.InstallDB      := true;
    Frm_SplittagesDistants.DataBaseFile   := VGIB[0].DatabaseFile;
    Frm_SplittagesDistants.ShowModal;
end;


procedure TForm17.BCCLAMEClick(Sender: TObject);
begin
   ShellExecute(0, 'OPEN', PChar(FUrlLameApp), '', '', SW_SHOWNORMAL);
end;

procedure TForm17.BCCMAGClick(Sender: TObject);
begin
   ShellExecute(0, 'OPEN', PChar(Format('http://localhost:%d/app',[VGSYMDS[0].http])), '', '', SW_SHOWNORMAL);
end;

procedure TForm17.BSTARTEASYClick(Sender: TObject);
var vStart: cardinal;
begin
    //
    if not(FileExists(VGIB[0].DatabaseFile)) then
      begin
         // votre fichier est présent
         MessageDlg('Le fichier ' + VGIB[0].DatabaseFile + ' n''est pas présent',  mtError, [mbOK], 0);
         exit;
         //
      end;
    //
    BSTOPEASY.Enabled:=false;
    ServiceStart('', 'EASY');
    vStart := GetTickCount();
    while GetTickCount-vStart<1000 do
      begin
         Sleep(100);
         Application.ProcessMessages;
      end;
    GetInfoServiceEASY;
end;

procedure TForm17.Creation7zdll;
var ResScripts:TResourceStream;
    vMydll:TFileName;
begin
    vMydll := IncludeTrailingPathDelimiter(VGSE.ExePath)+'7z.dll';
    if not(FileExists(vMydll))
      then
       begin
          ResScripts := TResourceStream.Create(HInstance, '7zdll', RT_RCDATA);
          try
            if not(FileExists(vMydll)) then
              ResScripts.SaveToFile(vMydll);
            finally
            ResScripts.Free();
          end;
       end;

   {
    vMydll := IncludeTrailingPathDelimiter(VGSE.ExePath)+'libeay32.dll';
    if not(FileExists(vMydll))
      then
       begin
          ResScripts := TResourceStream.Create(HInstance, 'libeay32dll', RT_RCDATA);
          try
            if not(FileExists(vMydll)) then
              ResScripts.SaveToFile(vMydll);
            finally
            ResScripts.Free();
          end;
       end;

    vMydll := IncludeTrailingPathDelimiter(VGSE.ExePath)+'ssleaylibeay32.dll';
    if not(FileExists(vMydll))
      then
       begin
          ResScripts := TResourceStream.Create(HInstance, 'libeay32dll', RT_RCDATA);
          try
            if not(FileExists(vMydll)) then
              ResScripts.SaveToFile(vMydll);
            finally
            ResScripts.Free();
          end;
       end;
    }





end;



procedure TForm17.FormCreate(Sender: TObject);
begin
    Creation7zdll;
    lblInfoEASY.Caption := '';
    GetInfoServiceEASY;
end;


procedure TForm17.GetInfoServiceEASY;
var vPropFile:TStringList;
    vUrl : string;
    vExternalId:string;
    vURI: TIdURI;
begin
    WMI_GetServicesSYMDS_ONLY_EASY();
    GetDatabases;
    vPropFile := TStringList.Create();
    FDossier := '';
    FUrlLameApp := '';

    try
      vPropFile.LoadFromFile(VGIB[0].PropertiesFile);
      vExternalId  := vPropFile.Values['external.id'];   // = Node
      vUrl         := StringReplace(vPropFile.Values['registration.url'],'\','',[rfReplaceAll]);
      vURI         := TIdURI.Create(vURL);
      if Pos('easy_',vURI.Document)=1
        then FDossier := UpperCase(Copy(vURI.Document,6,Length((vURI.Document))));

      FUrlLameApp  := vURI.Protocol + '://' + vURI.Host + ':' + vURI.Port + '/app';

    finally
      vPropFile.DisposeOf;
    end;


    // il faut arriver a recuperer le nom du dossier sans la base


    lblInfoEASY.Caption := 'Service : '+ VGSYMDS[0].ServiceName + #13+#10 +
           'Etat du service : ' + VGSYMDS[0].Status + #13+#10 +
           'Fichier .properties : ' + VGIB[0].PropertiesFile + #13+#10 +
           'Noeud : ' + vExternalId + #13+#10 +
           'Url Synchro Lame : ' + vUrl + #13+#10 +
           'Dossier : ' + FDossier;


  if VGSYMDS[0].Status='Stopped' then
    begin
      BSTOPEASY.Enabled  := false;
      BLISTSPLIT.Enabled := true;
      BDELETETMP.Enabled := true;
      BSTARTEASY.Enabled := true;
      BCCMAG.Enabled     := false;
    end;

  if VGSYMDS[0].Status='Running' then
    begin
      BSTOPEASY.Enabled  := true;
      BLISTSPLIT.Enabled := false;
      BDELETETMP.Enabled := false;
      BSTARTEASY.Enabled := false;
      BCCMAG.Enabled     := true;
    end;

end;




end.
