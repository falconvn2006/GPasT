unit uManager;

interface

uses
  uBinds,
  uDocuments,
  uParameters,
  uPermissions,
  uWebcam,
  System.SysUtils,
  { User Interface }
  FMX.Forms,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit,
  FMX.Layouts;

type
  TManager = class sealed
  private
    FBinds: TBinds;
    FDocuments: TMultipleDocument;
    FParameters: TParameters;
    FWebcam: TWebcam; // TWebcamPlugAndPlay;

    FWebcamImage: TImage;
    FDocumentCaption: TLabel;
    FUserId: TEdit;
    FBtnCapture: TSpeedButton;
    FWebcamError: TLayout;
    procedure ProceedIfPermitted(const Permissions: array of TPermission;
      const Proc: TProc);
    function GetCanSave: Boolean;
  protected
    procedure OnBindClick(const BindControl: TBindControl;
      const BindAction: TBindAction); virtual;
    procedure OnWebcamConnect(const Webcam: TWebcam); virtual;
    procedure OnWebcamDisconnect(const Webcam: TWebcam); virtual;
    procedure OnWebcamSampleBufferReady(const Webcam: TWebcam); virtual;
    procedure OnDocumentChange(const Document: TSingleDocument); virtual;
    procedure OnDocumentBitmapChange(const Document: TSingleDocument); virtual;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    { methods }
    procedure ForceRefresh;
    procedure Close;
    procedure Save;
    procedure Load(const Filename: String);
    procedure Delete(const Filename: String);

    { properties }
    property Binds: TBinds read FBinds write FBinds;
    property Documents: TMultipleDocument read FDocuments write FDocuments;
    property Parameters: TParameters read FParameters write FParameters;
    property Webcam: TWebcam read FWebcam write FWebcam;
    property WebcamImage: TImage read FWebcamImage write FWebcamImage;
    property DocumentCaption: TLabel read FDocumentCaption write FDocumentCaption;
    property UserId: TEdit read FUserId write FUserId;
    property BtnCapture: TSpeedButton read FBtnCapture write FBtnCapture;
    property WebcamError: TLayout read FWebcamError write FWebcamError;
    property CanSave: Boolean read GetCanSave;
    { events }
  end;

  EManagerNotPermitted = class( Exception );

implementation

uses
  FMX.Dialogs;

{ TManager }

procedure TManager.Close;
begin
  case FDocuments.State of
    dsUncompleted: Application.MainForm.Close;
    dsHalfCompleted: ;
    dsCompleted: ;
  end;
end;

constructor TManager.Create;
begin
  inherited;

  FParameters := TParameters.Parse;

  if Trim( FParameters.ID ) = '' then
    Application.Terminate;

  FBinds := TBinds.Create;
  FBinds.OnClick := OnBindClick;

  FWebcam := TWebcam.Create;
  FWebcam.OnConnect := OnWebcamConnect;
  FWebcam.OnDisconnect := OnWebcamDisconnect;
  FWebcam.OnSampleBufferReady := OnWebcamSampleBufferReady;
  FWebcam.Connect;
//  FWebcam := TWebcamPlugAndPlay.Create;

  FDocuments := TMultipleDocument.CNI;
  FDocuments.OnChange := OnDocumentChange;
  FDocuments.OnBitmapChange := OnDocumentBitmapChange;
end;

procedure TManager.Delete(const Filename: String);
begin
  FDocuments.DeleteFile( Format( '%s*.*', [ UserId.Text ] ) );
end;

destructor TManager.Destroy;
begin
  FBinds.Free;
  FDocuments.Free;
  FParameters.Free;{ TODO -cfix : fix? record>class pour destruction propre ? }
  FWebcam.Free;
  inherited;
end;

procedure TManager.ForceRefresh;
begin
  FDocuments.Refresh;
end;

function TManager.GetCanSave: Boolean;
begin
  Result := FDocuments.State <> TDocumentState.dsUncompleted;
end;

procedure TManager.Load(const Filename: String);
begin
  FDocuments.LoadFromFile( Format( '%s*.*', [ UserId.Text ] ) );
end;

procedure TManager.OnBindClick(const BindControl: TBindControl;
  const BindAction: TBindAction);
begin
  case BindAction of
    TBindActionRec.Prior:
      ProceedIfPermitted( [], FDocuments.Prior );
    TBindActionRec.Next:
      ProceedIfPermitted( [], FDocuments.Next );
    TBindActionRec.Capture:
      ProceedIfPermitted( [],
        procedure
        begin
          FDocuments.Current.Capture( FWebcam.Bitmap );
        end
      );
    TBindActionRec.Uncapture:
      ProceedIfPermitted( [],
        procedure
        begin
          FDocuments.Current.Clear;
        end
      );
    TBindActionRec.ToggleCapture: begin
      if FDocuments.Current.Captured then
        FDocuments.Current.Clear
      else
        FDocuments.Current.Capture( FWebcam.Bitmap );
    end;
    TBindActionRec.Close:
      ProceedIfPermitted( [],  Application.MainForm.Close );
    TBindActionRec.Save:
      ProceedIfPermitted( [], Save );
    TBindActionRec.Permissions:;
  else

  end;
end;

procedure TManager.OnDocumentBitmapChange(const Document: TSingleDocument);
var
  i: Integer;
begin
  if Assigned( FDocumentCaption ) then
    FDocumentCaption.Text := Format( '[%d/%d] %s', [ Documents.Index + 1, Documents.Count, Document.Caption ] );

  if Assigned( FBtnCapture ) then begin
    if Document.Captured then
      FBtnCapture.Text := 'Annuler le cliché'
    else
      FBtnCapture.Text := 'Prendre le cliché';
  end;
  WebcamError.Visible := not ( Webcam.Connected or Document.Captured );
  Binds.Enabled[ TBindActionRec.Capture ] := ( not Document.Captured ) and Webcam.Connected;
  Binds.Enabled[ TBindActionRec.Uncapture ] := Document.Captured and Webcam.Connected;
  Binds.Enabled[ TBindActionRec.ToggleCapture ] := Webcam.Connected;
  Binds.Enabled[ TBindActionRec.Save ] := FDocuments.State = TDocumentState.dsCompleted;
end;

procedure TManager.OnDocumentChange(const Document: TSingleDocument);
begin
  if Document.Captured then begin
    FWebcamImage.Bitmap.SetSize( Document.Bitmap.Width, Document.Bitmap.Height );
    FWebcamImage.Bitmap.CopyFromBitmap( Document.Bitmap );
  end;
  OnDocumentBitmapChange( Document );
end;

procedure TManager.OnWebcamConnect(const Webcam: TWebcam);
begin
//  ShowMessage( 'connect' );
end;

procedure TManager.OnWebcamDisconnect(const Webcam: TWebcam);
begin
//  ShowMessage( 'disconnect' );
end;

procedure TManager.OnWebcamSampleBufferReady(const Webcam: TWebcam);
begin
  if not FDocuments.Current.Captured then begin
    FWebcamImage.Bitmap.SetSize( Webcam.Bitmap.Width, Webcam.Bitmap.Height );
    FWebcamImage.Bitmap.CopyFromBitmap( Webcam.Bitmap );
  end;
end;

procedure TManager.ProceedIfPermitted(const Permissions: array of TPermission;
  const Proc: TProc);
begin
  if FParameters.Permissions.IsPermitted( Permissions ) or FParameters.Debug then
    Proc
  else
    raise EManagerNotPermitted.Create('not permitted');
end;

procedure TManager.Save;
begin
  if not CanSave then
    exit;

  FDocuments.SaveToFile(
    Format(
      '%s%s',
      [
        FParameters.Directory,
        FParameters.ID
      ]
    )
  );
end;

end.
