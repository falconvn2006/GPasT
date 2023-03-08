unit FUPDATE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ExtActns,IniFiles,
  ShellApi, ExtCtrls, Menus, jpeg,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAntiFreezeBase, IdAntiFreeze, Buttons, ComCtrls;

type
  TFormUPDATE = class(TForm)
    Panel1: TPanel;
    LabelMAJ: TLabel;
    LabelUpdate: TLabel;
    LabelVersion: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    BFERMER: TBitBtn;
    ProgressBar: TProgressBar;
    TimerClose: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BFERMERClick(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
  private
    { Déclarations privées }
    FTimer         : integer;
    FUrl           : string;
    FLocalFile     : string;
    FRemoteVersion : string;
    procedure URL_OnDownloadProgress(Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean);
    function DoDownload(aUrl:string;aLocalFile:string):boolean;
    procedure Telechargement;
    function FileUrlExists(const AUrl:string):boolean;
  public
    property Url           : string read FUrl           write FUrl;
    property LocalFile     : string read FLocalFile     write FLocalFile;
    property RemoteVersion : string read FRemoteVersion write FRemoteVersion;
    { Déclarations publiques }
  end;

var
  FormUPDATE: TFormUPDATE;
  InformationsFile:string;


implementation

uses UCommun;

{$R *.dfm}

function TFormUPDATE.FileUrlExists(const aUrl:string):boolean;
var FUpdateInfo:TidHttp;
begin
     result:=true;
     FUpdateInfo := TidHttp.Create(nil);
     try
        FUpdateInfo.ConnectTimeout := 2000;
        try
            FUpdateInfo.Get(aUrl);
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

function TFormUPDATE.DoDownload(aUrl:string;aLocalFile:string):boolean;
var savName:string;
begin
     result:=true;
     with TDownloadURL.Create(self) do
         try
            Url                := aUrl;
            // Renommage du fichier aLocalFile en aLocalFile_yyyymmdd_hhnnss.zzzz
            // DeleteFile(aLocalFile);
            savName := aLocalFile + '_'  +  FormatDateTime('yyyymmdd_hhnnsszzz',now());
            if RenameFile(aLocalFile, savName) then
              begin
                FileName           := aLocalFile;
                OnDownloadProgress := URL_OnDownloadProgress;
                try
                   If FileExists(aURL) or FileUrlExists(aURL)
                      then
                          begin
                             ExecuteTarget(nil);
                             LabelMAJ.Caption:='Nouvelle version de la base installée';
                             FTimer:=5;
                             LabelUpdate.Caption:=Format('Fermeture automatique dans %d secondes....',[FTimer]);
                             TimerClose.Enabled:=true;
                          end;
              Except
                 On e : Exception do
                    begin
                         LabelMAJ.Caption:='Erreur de Connexion Internet';
                         LabelMAJ.Refresh;
                         result:=false;
                    end;
                end;
              end;
         Finally
              BFERMER.Visible:=true;
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
     LabelMAJ.Caption:='Mise à jour en cours. Veuillez patienter...';
     LabelMAJ.Visible:=true;
     LabelMAJ.Refresh;
     LabelMAJ.Refresh;
     DoDownload(Url,LocalFile);
end;

procedure TFormUPDATE.TimerCloseTimer(Sender: TObject);
begin
    Dec(FTimer);
    Self.DoubleBuffered:=true;
    LabelUpdate.Caption:=Format('Fermeture automatique dans %d secondes....',[FTimer]);
    if Ftimer<=0 then Close;
end;

procedure TFormUPDATE.FormActivate(Sender: TObject);
begin
    LabelVersion.Caption:=Format('Dernière Version Disponible : %s',[RemoteVersion]);
    Telechargement;
end;

procedure TFormUPDATE.FormCreate(Sender: TObject);
begin
    ProgressBar.Visible:=true;
    LabelMAJ.Caption:='Recherche en cours. Veuillez patienter...';
    LabelMAJ.Visible:=true;
    LabelMAJ.Refresh;
    LabelUpdate.Caption:='Récupération en de la dernière version en cours...';
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

end.
