unit FUPDATE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ExtActns,IniFiles,
  ShellApi, ExtCtrls, Menus, jpeg,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAntiFreezeBase, IdAntiFreeze, Buttons, ComCtrls;

Const InfFile='http://lame2.no-ip.com/algol/Srv_DEV/GR/product/updates.inf';

type
  TFormUPDATE = class(TForm)
    Panel1: TPanel;
    LabelMAJ: TLabel;
    LabelUpdate: TLabel;
    LabelVersion: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    Timer: TTimer;
    BFERMER: TBitBtn;
    BUPDATE: TBitBtn;
    ProgressBar: TProgressBar;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFERMERClick(Sender: TObject);
    procedure BUPDATEClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Déclarations privées }
    UpdateFile:string;
    procedure URL_OnDownloadProgress(Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean);
    procedure GetNewVersion;
    function DoDownload(const AUrl:string;Const ALocalFile:string):boolean;
    procedure Telechargement;
    function FileUrlExists(const AUrl:string):boolean;
    procedure Execute;    
  public
    { Déclarations publiques }
  end;

resourcestring
  R_FormUPDATE001 = 'Erreur de Connexion Internet';
  R_FormUPDATE002 = 'Mise à jour en cours. Veuillez patienter...';
  R_FormUPDATE003 = 'Dernière Version Disponible : %s';
  R_FormUPDATE004 = 'Vous possédez la dernière version';
  R_FormUPDATE005 = 'Version Actuelle : %s';
  R_FormUPDATE006 = 'Les mises à jour ne sont pas automatiques';


var
  FormUPDATE: TFormUPDATE;
  InformationsFile:string;


implementation

uses UCommun;

{$R *.dfm}

function TFormUPDATE.FileUrlExists(const AUrl:string):boolean;
var FUpdateInfo:TidHttp;
begin
     If VAR_GLOB.DEBUG then WriteOnDebugFile('TFormUPDATE.FileUrlExists');
     result:=true;
     FUpdateInfo := TidHttp.Create(nil);
     try
        FUpdateInfo.ConnectTimeout := 2000;
        try
            FUpdateInfo.Get(AUrl);
            If FUpdateInfo.ResponseCode<>200 then result:=false;
            except
                on e:exception do
                    begin
                         result:=false;
                    end;
        end;
        finally
              FUpdateInfo.Free;
       end;
end;

function TFormUPDATE.DoDownload(const AUrl:string;Const ALocalFile:string):boolean;
begin
     If Var_Glob.DEBUG then WriteOnDebugFile('TFormUPDATE.DoDownload');
     result:=true;
     with TDownloadURL.Create(self) do
         try
            URL:=AUrl;
            // MessageDlg(URL, mtWarning, [mbOK], 0);
            FileName := GetTmpDir + ALocalFile;
            DeleteFile(FileName);
            // désormai un pb avec la barre de progression...
            // surment 1 soucis avec la taille de la barre qui ne peut etre caculer..
            // ou un truc comme ça
            OnDownloadProgress := URL_OnDownloadProgress;
            try
               If FileExists(URL) or FileUrlExists(URL)
                  then
                      begin
                           ExecuteTarget(nil);
                      end;
            Except
               On e : Exception do
                  begin
                       LabelMAJ.Caption:=R_FormUPDATE001;
                       // 'Erreur de Connexion Internet';
                       LabelMAJ.Refresh;
                       result:=false;
                  end;
            end;
         Finally
              ProgressBar.Position:=100;
              ProgressBar.Refresh;
              Free;
         end;
end;


procedure TFormUPDATE.URL_OnDownloadProgress(Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean);
begin
   If ProgressBar.Max=0
      then ProgressBar.Max := ProgressMax;
   ProgressBar.Position:= Progress;
   ProgressBar.Refresh;
   Application.ProcessMessages;
end;

procedure TFormUPDATE.Telechargement;
begin
     LabelUpdate.Visible:=true;
     LabelUpdate.Refresh;
     ProgressBar.Visible:=true;
     ProgressBar.Refresh;

     LabelMAJ.Caption:=R_FormUPDATE002;
     LabelMAJ.Visible:=true;
     LabelMAJ.Refresh;
     //'Mise à jour en cours. Veuillez patienter...';
     LabelMAJ.Refresh;
     try
        DoDownload(UpdateFile, GetInfo('InternalName') + '_update.exe');
        //---------------------------------------------------------------------
        // KillProcess(FindWindow(nil,PChar('VJETONS')));    Pas besoin c'est fait dans l'installeur
        // KillProcess(FindWindow(nil,PChar('VMONITOR')));
        // KillProcess(FindWindow(nil,PChar('WDPOST')));
        //----------------------------------------------------------------------
        ShellExecute(0,'OPEN', PChar(GetTmpDir + GetInfo('InternalName') + '_update.exe'), Pchar(' /DIR="'+Var_Glob.DIRECTORY +'" /VERYSILENT'), Nil, SW_SHOW);
        finally
        Application.Terminate;
     end;
end;

procedure TFormUPDATE.GetNewVersion;
var // Fs : TFileStream;
    Ini: TIniFile;
    NewVersion:string;
begin
     If Var_Glob.DEBUG then WriteOnDebugFile('TFormUPDATE.GetNewVersion');
     If DoDownload(InformationsFile, GetInfo('InternalName') + '_update.ini')
        then
            begin
                 Ini := TIniFile.Create(GetTmpDir + GetInfo('InternalName') + '_update.ini');
                 try
                    NewVersion := Ini.ReadString(GetInfo('InternalName'), 'Version', '');
                    UpdateFile := Ini.ReadString(GetInfo('InternalName'), 'File', '');
                    LabelUpdate.Caption:=Format(R_FormUPDATE003,[NewVersion]);
                    LabelUpdate.Visible:=true;
                    LabelUpdate.Refresh;
                    Application.ProcessMessages;
                 finally
                 Ini.Free;
                 end;
                 If CompareVersion(GetInfo('Version'),NewVersion)<0
                    then BUPDATE.Enabled:=true
                        else
                            begin
                                 LabelMAJ.Caption:=R_FormUPDATE004;
                                 // 'Vous possédez la dernière version';
                                 LabelMAJ.Visible:=true;
                                 LabelMAJ.Refresh;
                            end;
            end
        else  // Erreur de connexion internet : il faut qu'on puisse lancer le pg quand meme
            begin
                 // BValider.Enabled:=true;
            end;
    LabelMAJ.Refresh;
end;


procedure TFormUPDATE.FormActivate(Sender: TObject);
begin
     LabelVersion.Caption:=Format(R_FormUPDATE005,[GetInfo('Version')]);
     Application.ProcessMessages;
     Execute;
end;

procedure TFormUPDATE.Execute;
begin
     Refresh;
     Timer.Enabled:=true;
end;

procedure TFormUPDATE.FormCreate(Sender: TObject);
begin
     If Var_Glob.DEBUG then WriteOnDebugFile('TFormUPDATE.FormCreate');
     //BEGIN 2012-04-06
     DoubleBuffered:=true;
     //END 2012-04-06
     UpdateFile:='';
     LabelUpdate.Visible:=False;
     ProgressBar.Visible:=False;
     LabelMAJ.Visible:=false;
     InformationsFile:=LoadFromRegStr('Infile',InfFile);
     BUPDATE.Enabled:=false;
     If (ParamStr(1)='') or (Var_Glob.DEBUG) then
        begin
             LabelMAJ.Caption:=R_FormUPDATE002;
        end
        else
        begin
             LabelMAJ.Caption:=R_FormUPDATE006;
             LabelUpdate.Caption:='';
        end;
    SaveToRegStr('Infile',InformationsFile);
    LabelMAJ.Caption:='Recherche en cours. Veuillez patienter...';
    LabelMAJ.Visible:=true;
    LabelMAJ.Refresh;
    LabelUpdate.Caption:='Récupération en cours...';
    LabelUpdate.visible:=true;
    Application.ProcessMessages;
end;

procedure TFormUPDATE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action:=CaFree;
end;

procedure TFormUPDATE.BFERMERClick(Sender: TObject);
begin
     Close;
end;

procedure TFormUPDATE.BUPDATEClick(Sender: TObject);
begin
     Telechargement;
end;

procedure TFormUPDATE.TimerTimer(Sender: TObject);
begin
     Timer.Enabled:=false;
     GetNewVersion;
end;

end.
