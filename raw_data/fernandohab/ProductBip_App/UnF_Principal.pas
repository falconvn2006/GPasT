unit UnF_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Media, System.Permissions,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  // ZXing
  ZXing.ScanManager, ZXing.ReadResult, ZXing.BarcodeFormat, FMX.Platform, ZXing.ResultPoint,
  // System
  System.Math.Vectors, FMX.Layouts,  System.Generics.Defaults, System.Generics.Collections,
  System.Diagnostics, System.Threading, System.Math, System.IOUtils, FMX.ListBox, FMX.ExtCtrls,
  FMX.ScrollBox, FMX.Memo, FMX.Ani, FMX.Effects, System.Rtti, FMX.Memo.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TPrincipal = class(TForm)
    Iniciar: TButton;
    imgCam: TImage;
    CamComponent: TCameraComponent;
    Memo1: TMemo;
    conn: TFDConnection;
    qry: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure IniciarClick(Sender: TObject);
    procedure CamComponentSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    procedure ImageStream;



  private
    { Private declarations }
    FScanManager : TScanManager;
    FReadResult : string;
    FPermissionCamera, FPermissionReadExternalStorage, FPermissionWriteExternalStorage: string;
		FScanInProgress: Boolean;
		FFrameTake: Integer;
		FStopwatch: TStopwatch;
		FFrameCount: Integer;
		FCaptureSettings: TArray<TVideoCaptureSetting>;
		targetRect: TRect;
		FActive: Boolean;
		FBuffer: TBitmap;
		FScanBitmap: TBitmap;
  public
    //
  end;

var
  Principal : TPrincipal;


implementation

{$R *.fmx}

uses
{$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
{$ENDIF}
  FMX.DialogService;

procedure TPrincipal.CamComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  ImageStream;
end;

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  {$IFDEF ANDROID}
   FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  {$ENDIF}
end;

procedure TPrincipal.ImageStream;
var
  bmp : TBitmap;
  ReadResult : TReadResult;
begin
  CamComponent.SampleBufferToBitmap(imgCam.Bitmap, true);
  try
    // Memo1.Lines.Add('Init');
    bmp := TBitmap.Create;
    bmp.Assign(imgCam.Bitmap);
    ReadResult := FScanManager.Scan(bmp);
    if ReadResult <> nil then
      begin
       // CamComponent.Active := false;
          Memo1.Lines.Add(ReadResult.text);
          Close;
      end;
  finally
    bmp.Free;
  end;

end;

procedure TPrincipal.IniciarClick(Sender: TObject);
begin
  PermissionsService.RequestPermissions([FPermissionCamera], nil, nil);
  CamComponent.Kind := TCameraKind.BackCamera;
  CamComponent.FocusMode := TFocusMode.ContinuousAutoFocus;
  CamComponent.Quality := TVideoCaptureQuality.MediumQuality;
  imgCam.Enabled := True;
  CamComponent.Active := True;
end;




end.
