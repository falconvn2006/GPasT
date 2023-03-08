unit uDocuments;

interface

uses
  System.Generics.Collections,
  FMX.Graphics;

type
  TDocumentFormat = type Cardinal;
  TDocumentFormatRec = record
  const
    JPG = TDocumentFormat( $0000A0 );
    PNG = TDocumentFormat( $0000A1 );
    BMP = TDocumentFormat( $0000A2 );
    DAT = TDocumentFormat( $0000A3 );
  public
    DocumentFormat: TDocumentFormat;
    constructor Create(const DocumentFormat: TDocumentFormat);
  end;

  { Forward class declarations }
  TSingleDocument = class;

  TDocumentState = ( dsUncompleted, dsHalfCompleted, dsCompleted );

  TDocumentEvent = procedure(const Document: TSingleDocument) of object;

  TSingleDocument = class
  private
    FBitmap: TBitmap;
    FCaption: String;
    FState: TDocumentState;
    FOnBitmapChange: TDocumentEvent;
    function GetCaptured: Boolean; inline;
    procedure DoBitmapChange(const Document: TSingleDocument);
  public
    constructor Create(const Caption: String); reintroduce;
    destructor Destroy; override;
    { methods }
    procedure Capture(const Bitmap: TBitmap);
    procedure Clear;
    procedure LoadFromFile(const Filename: String);
    procedure SaveToFile(const Filename: String;
      const DocumentFormat: TDocumentFormat = TDocumentFormatRec.JPG); overload;
    { properties }
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property Caption: String read FCaption write FCaption;
    property Captured: Boolean read GetCaptured;
    { events }
    property OnBitmapChange: TDocumentEvent read FOnBitmapChange
      write FOnBitmapChange;
  end;

  TMultipleDocument = class( TObjectList< TSingleDocument > )
  private
    FIndex: Integer;
    FState: TDocumentState;
    FOnChange, FOnBitmapChange: TDocumentEvent;
    procedure SetIndex(const Value: Integer);
    function GetCurrent: TSingleDocument;
    procedure SetCurrent(const Value: TSingleDocument);
    procedure DoChange(const Document: TSingleDocument);
    procedure DoBitmapChange(const Document: TSingleDocument);
    function GetDocumentState: TDocumentState;
    function GetCapturedCount: Integer;
  public
    constructor Create; reintroduce; overload;
    constructor Create(const Documents: array of TSingleDocument); overload;
    function Add(const Value: TSingleDocument): Integer; reintroduce;
    { methods }
    class function CNI: TMultipleDocument;
    procedure Prior;
    procedure Next;
    procedure Refresh;
    procedure Clear;
    procedure DeleteFile(const Filename: String);
    procedure LoadFromFile(const Filename: String); overload;
    procedure LoadFromFile(const Format: String;
      const Args: array of const); overload;
    procedure SaveToFile(const Filename: String;
      const DocumentFormat: TDocumentFormat = TDocumentFormatRec.JPG); overload;
    procedure SaveToFile(const Format: String;
      const Args: array of const;
      const DocumentFormat: TDocumentFormat = TDocumentFormatRec.JPG); overload;
    { properties }
    property Index: Integer read Findex write SetIndex;
    property Current: TSingleDocument read GetCurrent write SetCurrent;
    property State: TDocumentState read GetDocumentState;
    { events }
    property OnChange: TDocumentEvent read FOnChange write FOnChange;
    property OnBitmapChange: TDocumentEvent read FOnBitmapChange
      write FOnBitmapChange;
  end;

  TDocuments = class( TObjectList< TMultipleDocument > )
  public
    constructor Create; reintroduce; overload;
    constructor Create(const Documents: array of TMultipleDocument); overload;
    { TODO -cTodo : list/load/save from models }
  end;

implementation

uses
  System.SysUtils, System.Types, System.IOUtils;

{ TSingleDocument }

procedure TSingleDocument.Capture(const Bitmap: TBitmap);
begin
  try
    if Captured then begin
      FreeAndNil( FBitmap );
      FState := TDocumentState.dsUncompleted;
    end;
    if not Assigned( Bitmap ) then
      exit;
    FBitmap := TBitmap.Create( Bitmap.Width, Bitmap.Height );
    FBitmap.CopyFromBitmap( Bitmap );
    FState := TDocumentState.dsCompleted;
  finally
    if Assigned( FOnBitmapChange ) then
      FOnBitmapChange( Self );
  end;
end;

procedure TSingleDocument.Clear;
begin
  Capture( nil );
end;

constructor TSingleDocument.Create(const Caption: String);
begin
  inherited Create;
  FCaption := Caption;
  FBitmap := nil;
  FState := TDocumentState.dsUncompleted;
end;

destructor TSingleDocument.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TSingleDocument.DoBitmapChange(const Document: TSingleDocument);
begin
  if Assigned( FOnBitmapChange ) then
    FOnBitmapChange( Document );
end;

function TSingleDocument.GetCaptured: Boolean;
begin
  Result := Assigned( FBitmap );
end;

procedure TSingleDocument.LoadFromFile(const Filename: String);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromFile( Filename );
    Capture( Bitmap );
  finally
    Bitmap.Free;
  end;
//  FBitmap.LoadFromFile( Filename );
//  FOnBitmapChange( Self );
end;

procedure TSingleDocument.SaveToFile(const Filename: String;
  const DocumentFormat: TDocumentFormat);
begin
  if not Assigned( FBitmap ) then
    exit;

  case DocumentFormat of
    TDocumentFormatRec.JPG: FBitmap.SaveToFile( Format( '%s.%s', [ Filename, 'jpg' ] ) );
    TDocumentFormatRec.PNG: FBitmap.SaveToFile( Format( '%s.%s', [ Filename, 'png' ] ) );
    TDocumentFormatRec.BMP: FBitmap.SaveToFile( Format( '%s.%s', [ Filename, 'bmp' ] ) );
//    TDocumentFormatRec.DAT:;
  end;

end;

{ TMultipleDocument }

constructor TMultipleDocument.Create;
begin
  inherited Create( True );
  FIndex := -1;
  FState := TDocumentState.dsUncompleted;
end;

function TMultipleDocument.Add(const Value: TSingleDocument): Integer;
begin
  Value.OnBitmapChange := DoBitmapChange;
  inherited Add( Value );
  if FIndex < 0 then
    FIndex := 0;
end;

procedure TMultipleDocument.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[ i ].Clear;
end;

class function TMultipleDocument.CNI: TMultipleDocument;
begin
  Result := TMultipleDocument.Create([
    TSingleDocument.Create( 'Carte Nationale d''Identité (recto)' ),
    TSingleDocument.Create( 'Carte Nationale d''Identité (verso)' )
  ]);
end;

constructor TMultipleDocument.Create(const Documents: array of TSingleDocument);
var
  i: Integer;
begin
  Create;
  for i := Low( Documents ) to High( Documents ) do
    Add( Documents[ i ] );
end;

procedure TMultipleDocument.DeleteFile(const Filename: String);
var
  Files: TStringDynArray;
  i: Integer;
begin
  Files := TDirectory.GetFiles(
    TDirectory.GetCurrentDirectory,
    Filename,
    TSearchOption.soTopDirectoryOnly
  );
  Assert( Length( Files ) = Count );
  for i := Low( Files ) to High( Files ) do
    System.SysUtils.DeleteFile( Files[ i ] );
end;

procedure TMultipleDocument.DoBitmapChange(const Document: TSingleDocument);
begin
  if Assigned( FOnBitmapChange ) then
    FOnBitmapChange( Document );
end;

procedure TMultipleDocument.DoChange(const Document: TSingleDocument);
begin
  if Assigned( FOnChange ) then
    FOnChange( Document )
end;

function TMultipleDocument.GetCapturedCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if Items[ i ].Captured then
      Inc( Result );
end;

function TMultipleDocument.GetCurrent: TSingleDocument;
begin
  if FIndex < 0 then
    Result := nil
  else
    Result := Items[ FIndex ];
end;

function TMultipleDocument.GetDocumentState: TDocumentState;
var
  iCapturedCount: Integer;
begin
  iCapturedCount := GetCapturedCount;
  if iCapturedCount = 0 then
    Result := TDocumentState.dsUncompleted
  else
    if iCapturedCount = Count then
      Result := TDocumentState.dsCompleted
    else
      Result := TDocumentState.dsHalfCompleted;
end;

procedure TMultipleDocument.LoadFromFile(const Format: String;
  const Args: array of const);
begin
  LoadFromFile( System.SysUtils.Format( Format, Args ) );
end;

procedure TMultipleDocument.LoadFromFile(const Filename: String);
var
  Files: TStringDynArray;
  i: Integer;
begin
  Files := TDirectory.GetFiles(
    TDirectory.GetCurrentDirectory,
    Filename,
    TSearchOption.soTopDirectoryOnly
  );
  Assert( Length( Files ) = Count );
  for i := High( Files ) downto Low( Files ) do
    Items[ i ].LoadFromFile( Files[ i ] );
  DoChange( Current );
end;

procedure TMultipleDocument.Next;
begin
  SetIndex( ( FIndex + 1 + Count ) mod Count );
end;

procedure TMultipleDocument.Prior;
begin
  SetIndex( ( FIndex - 1 + Count ) mod Count );
end;

procedure TMultipleDocument.Refresh;
begin
  DoChange( Items[ FIndex ] );
end;

procedure TMultipleDocument.SaveToFile(const Filename: String;
  const DocumentFormat: TDocumentFormat);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[ i ].SaveToFile( Format( '%s_CNI%d', [ Filename, i ] ), DocumentFormat );
end;

procedure TMultipleDocument.SaveToFile(const Format: String;
  const Args: array of const; const DocumentFormat: TDocumentFormat);
begin
  SaveToFile( System.SysUtils.Format( Format, Args ), DocumentFormat );
end;

procedure TMultipleDocument.SetCurrent(const Value: TSingleDocument);
begin
  SetIndex( IndexOf( Value ) );
end;

procedure TMultipleDocument.SetIndex(const Value: Integer);
begin
  if ( Value < 0 ) or ( FIndex = Value ) then
    exit;
  FIndex := Value;
  DoChange( Items[ FIndex ] );
end;

{ TDocumentFormatRec }

constructor TDocumentFormatRec.Create(const DocumentFormat: TDocumentFormat);
begin
  Self := TDocumentFormatRec( DocumentFormat );
end;

{ TDocuments }

constructor TDocuments.Create;
begin
  inherited Create( True );
end;

constructor TDocuments.Create(const Documents: array of TMultipleDocument);
var
  i: Integer;
begin
  Create;
  for i := Low( Documents ) to High( Documents ) do
    Add( Documents[ i ] );
end;

end.
