unit uCamera;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
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
  TForm1 = class(TForm)
    LayoutBottom: TLayout;
    RoundRectSair: TRoundRect;
    LabelSair: TLabel;
    LayoutTopo: TLayout;
    RectangleTopo: TRectangle;
    LabelTitulo: TLabel;
    CodeReader1: TCodeReader;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Text1: TText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RoundRectSairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CodeReader1CodeReady(aCode: string);
    procedure FormShow(Sender: TObject);
  private
    fPermissionCamera: String;
    fScanInProgress: Boolean;
    fFrameTake: Integer;
    fScanBitmap: TBitmap;
    procedure CameraPermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure ExplainReason(Sender: TObject; const APermissions: TArray<string>;
      const APostRationaleProc: TProc);
    procedure AbreCamera;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses FMX.DialogService, uNovoPedido;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1  := nil;
  Action := TCloseAction.caFree;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CodeReader1.Stop;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Text1.Text := '';
{$IFDEF ANDROID}
  fPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
{$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  AbreCamera;
end;

procedure TForm1.CameraPermissionRequestResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 1) and
    (AGrantResults[0] = TPermissionStatus.Granted) then
  begin
    Text1.Text := '';
  end
  else
    TDialogService.ShowMessage
      ('Cannot scan for barcodes because the required permissions is not granted')
end;

procedure TForm1.CodeReader1CodeReady(aCode: string);
var wobject: TObject;
    wkeyword: word;
    wkeychar: char;
    wshift: TShiftState;
begin
  wobject  := F_NovoPedido.EditPesquisa;
  wkeyword := vkReturn;
  wkeychar := #13;
  wshift   := [];
  F_NovoPedido.EditPesquisa.Text := aCode;
  F_NovoPedido.EditPesquisa.OnKeyDown(wobject,wkeyword,wkeychar,wshift);
  Form1.Close;
//  Text1.Text := aCode;
end;

procedure TForm1.ExplainReason(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  ShowMessage('O app necessita acesso a câmera para scanear o código de barras...');
end;

procedure TForm1.AbreCamera;
begin
  PermissionsService.RequestPermissions([fPermissionCamera],CameraPermissionRequestResult, ExplainReason);
  CodeReader1.Start;
end;


procedure TForm1.RoundRectSairClick(Sender: TObject);
begin
  Form1.Close;
end;

end.
