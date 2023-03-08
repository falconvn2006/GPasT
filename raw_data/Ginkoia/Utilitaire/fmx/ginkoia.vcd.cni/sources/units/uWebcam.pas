unit uWebcam;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Media,
  FMX.Graphics;

type
  { Forward class declarations }
  TWebcam = class;

  TWebcamEvent = procedure(const Webcam: TWebcam) of object;

  TWebcam = class sealed
  private
    FBitmap: TBitmap;
    FOnConnect, FOnDisconnect, FOnSampleBufferReady: TWebcamEvent;
    FVideoCaptureDevice: FMX.Media.TVideoCaptureDevice;
    procedure DoConnect;
    procedure DoDisconnect;
    procedure DoSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    function GetConnected: Boolean; inline;
    procedure SetConnected(const Value: Boolean);
  public
    constructor Create(const AutoConnect: Boolean = False); reintroduce; overload;
    constructor Create(const VideoCaptureDevice: FMX.Media.TVideoCaptureDevice;
      const AutoConnect: Boolean = False); overload;
    destructor Destroy; override;
    { methods }
    function Connect: Boolean; overload;
    function Connect(const VideoCaptureDevice: FMX.Media.TVideoCaptureDevice): Boolean; overload;
    procedure Disconnect;
    procedure StartCapture;
    procedure StopCapture;
    { properties }
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property Connected: Boolean read GetConnected write SetConnected;
    property VideoCaptureDevice: FMX.Media.TVideoCaptureDevice
      read FVideoCaptureDevice write FVideoCaptureDevice;
    { events }
    property OnConnect: TWebcamEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TWebcamEvent read FOnDisconnect write FOnDisconnect;
    property OnSampleBufferReady: TWebcamEvent read FOnSampleBufferReady write FOnSampleBufferReady;
  end;

  TWebcamPlugAndPlay = class( System.Classes.TThread )
  private
    class var FWebcam: TWebcam;
  protected
    procedure Execute; override;
  private
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  EWebcamNotFound = class( Exception );


implementation

{ TWebcam }

function TWebcam.Connect(
  const VideoCaptureDevice: FMX.Media.TVideoCaptureDevice): Boolean;
begin
  Result := Assigned( VideoCaptureDevice );
  if not Result then
    exit;
  FVideoCaptureDevice := VideoCaptureDevice;
  FVideoCaptureDevice.OnSampleBufferReady := DoSampleBufferReady;
  StartCapture;
  DoConnect;
end;

constructor TWebcam.Create(const AutoConnect: Boolean);
begin
  Create( nil, False );
end;

constructor TWebcam.Create(
  const VideoCaptureDevice: FMX.Media.TVideoCaptureDevice;
  const AutoConnect: Boolean);
begin
  inherited Create;
  FBitmap := TBitmap.Create;
  try
    if not AutoConnect then
      exit;
    if Assigned( VideoCaptureDevice ) then
      Connect( VideoCaptureDevice )
    else
      Connect;
  except
    raise EWebcamNotFound.Create('Message d''erreur');
  end;
end;

function TWebcam.Connect: Boolean;
begin
  Result := Connect( TCaptureDeviceManager.Current.DefaultVideoCaptureDevice );
end;

destructor TWebcam.Destroy;
begin
  Disconnect;
  FBitmap.Free;
  inherited;
end;

procedure TWebcam.Disconnect;
begin
  StopCapture;
  FVideoCaptureDevice := nil;
  DoDisconnect;
end;

procedure TWebcam.DoConnect;
begin
  if Assigned( FOnConnect ) then
    FOnConnect( Self );
end;

procedure TWebcam.DoDisconnect;
begin
  if Assigned( FOnDisconnect ) then
    FOnDisconnect( Self );
end;

procedure TWebcam.DoSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
begin
  if Assigned( FBitmap ) then begin
    FVideoCaptureDevice.SampleBufferToBitmap( FBitmap, True );
    if Assigned( FOnSampleBufferReady ) then
      FOnSampleBufferReady( Self );
  end;
end;

function TWebcam.GetConnected: Boolean;
begin
  Result := Assigned( FVideoCaptureDevice );
end;

procedure TWebcam.SetConnected(const Value: Boolean);
begin
  if Value then
    Connect( TCaptureDeviceManager.Current.DefaultVideoCaptureDevice )
  else
    Disconnect;
end;

procedure TWebcam.StartCapture;
begin
  if Connected then
    FVideoCaptureDevice.StartCapture;
end;

procedure TWebcam.StopCapture;
begin
  if Connected then
    FVideoCaptureDevice.StopCapture;
end;

{ TWebcamPlugAndPlay }

constructor TWebcamPlugAndPlay.Create;
begin
  inherited Create( True );
  FWebcam := TWebcam.Create;
end;

destructor TWebcamPlugAndPlay.Destroy;
begin
  FWebcam.Free;
  inherited;
end;

procedure TWebcamPlugAndPlay.Execute;
begin
  inherited;
  while not Terminated do
    try
      if not FWebcam.Connected then
        FWebcam.Connect;
    finally
      Sleep( 1000 );
    end;
end;

end.
