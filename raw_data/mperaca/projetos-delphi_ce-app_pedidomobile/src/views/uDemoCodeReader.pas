unit uDemoCodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
//  CodeReader.FMX.CodeReader,
  FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls,  System.Permissions,
  {$IFDEF ANDROID}
    ZXing.BarcodeFormat,
    ZXing.ReadResult,
    ZXing.ScanManager,
    Androidapi.JNI.JavaTypes,
    Androidapi.JNI.GraphicsContentViewText,
    FMX.Helpers.Android,
    Androidapi.Helpers,
    Androidapi.NativeActivity,
    Androidapi.JNIBridge,
    IdURI,
    Androidapi.Jni.Net,
    Androidapi.JNI.Os,
  {$ELSE}
//     Winapi.Windows,
  {$ENDIF}

  //CodeReader.FMX.Android.Permissions,
  FMX.CodeReader, FMX.Ani;

type
  TF_CodeReader = class(TForm)
    CodeReader1: TCodeReader;
    Text1: TText;
    Button1: TButton;
    Rectangle1: TRectangle;
    FloatKeyAnimation1: TFloatKeyAnimation;
//    AndroidPermissions1: TAndroidPermissions;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CodeReader1CodeReady(aCode: string);
    procedure CodeReader1Start(Sender: TObject);
    procedure CodeReader1Stop(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fPermissionCamera: String;
    procedure CameraPermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>;
      const APostRationaleProc: TProc);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_CodeReader: TF_CodeReader;

implementation

{$R *.fmx}

procedure TF_CodeReader.Button1Click(Sender: TObject);
begin
  PermissionsService.RequestPermissions([fPermissionCamera],
    CameraPermissionRequestResult, ExplainReason);
if Button1.Text = 'Start' then
   CodeReader1.Start
Else
   CodeReader1.Stop;
end;

procedure TF_CodeReader.ExplainReason(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  ShowMessage('O app necessita acesso a câmera para scanear o código de barras...');
//    procedure(const AResult: TModalResult)
//    begin
//      APostRationaleProc;
//    end)
end;
{ Make sure the camera is released if you're going away. }


procedure TF_CodeReader.CameraPermissionRequestResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 1) and
    (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    Text1.Text := '';
  end
  else
    ShowMessage('Requerida permissão para leitura do código de barras');
end;

procedure TF_CodeReader.CodeReader1Start(Sender: TObject);
begin
Button1.Text := 'Stop';
end;

procedure TF_CodeReader.CodeReader1Stop(Sender: TObject);
begin
Button1.Text := 'Start';
end;

procedure TF_CodeReader.FormCreate(Sender: TObject);
begin
//  if TPlatformServices.Current.SupportsPlatformService
//    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
//  begin
//    AppEventSvc.SetApplicationEventHandler(AppEvent);
//  end;
//  fFrameTake := 0;
//  fScanBitmap := nil;
{$IFDEF ANDROID}
  fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
{$ENDIF}
end;

procedure TF_CodeReader.FormShow(Sender: TObject);
begin
CodeReader1Stop(Sender);
end;

procedure TF_CodeReader.CodeReader1CodeReady(aCode: string);
begin
Text1.Text := aCode;
end;

end.
