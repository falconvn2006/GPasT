(*******************************************************************************

      Mac style Progressbar v1.0

                                               Copyrights (C) 1997 Youngjae Ha
                                               E-mail: vaio91@yahoo.com

                                               ALL RIGHTS RESERVED

*******************************************************************************)

unit MacProgressBar;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TMacProgressBar = class(TGraphicControl)
  private
    TS, TB, TE, PS, PB, PE : TBitmap;
    BufferBmp : TBitmap;
    FPos : Integer;
    FProgress : Integer;

    procedure SetProgress( Value : Integer );
  protected
    procedure Paint; override;
    procedure SetBounds( ALeft : Integer; ATop : Integer; AWidth : Integer; AHeight : Integer ); override;
    procedure Calculate;
  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;
  published
    property Progress : Integer read FProgress write SetProgress default 0;
  end;

procedure Register;

implementation

{$R ProImage.RES}

procedure Register;
begin
  RegisterComponents('Fabricio', [TMacProgressBar]);
end;

constructor TMacProgressBar.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );

  ControlStyle := [csDesignInteractive, csFramed, csOpaque];

  Width := 180;
  Height := 12;
  FPos := 0;

  // Å×µÎ¸® ±×¸²...
  TS := TBitmap.Create;
  TB := TBitmap.Create;
  TE := TBitmap.Create;
  // Bar ±×¸²...
  PS := TBitmap.Create;
  PB := TBitmap.Create;
  PE := TBitmap.Create;

  BufferBmp := TBitmap.Create;
  BufferBmp.Canvas.Brush.Color := clBlack;
  BufferBmp.Canvas.Brush.Style := bsSolid;

  TS.Handle := LoadBitmap( HInstance, 'TrailStartBMP' );
  TE.Handle := LoadBitmap( HInstance, 'TrailEndBMP' );
  TB.Handle := LoadBitmap( HInstance, 'TrailBodyBMP' );

  PS.Handle := LoadBitmap( HInstance, 'ProgressSBMP' );
  PB.Handle := LoadBitmap( HInstance, 'ProgressBodyBMP' );
  PE.Handle := LoadBitmap( HInstance, 'ProgressEBMP' );
end;

destructor TMacProgressBar.Destroy;
begin
  TS.Free;
  TB.Free;
  TE.Free;

  PS.Free;
  PB.Free;
  PE.Free;

  BufferBmp.Free;

  inherited;
end;

procedure TMacProgressBar.SetProgress( Value : Integer );
begin
  if Value <> FProgress then
  begin
    if ( Value > 100 ) or ( Value < 0 ) then
      FProgress := 0
    else
      FProgress := Value;

    Refresh;
  end;
end;

procedure TMacProgressBar.Calculate;
begin
  FPos := Trunc( Width * ( FProgress * 0.01 ) );
end;

procedure TMacProgressBar.Paint;
begin
  inherited Paint;

  BufferBmp.Width := Width;
  BufferBmp.Height := 12;
  BufferBmp.Canvas.FloodFill( 0, 0, clWhite, fsSurface );

  Bitblt( BufferBmp.Canvas.Handle, 0, 0, 2, 12, TS.Canvas.Handle, 0, 0, SRCCOPY );
  StretchBlt( BufferBmp.Canvas.Handle, 2, 0, Width - 4, 12, TB.Canvas.Handle, 0, 0, 2, 12, SRCCOPY );
  Bitblt( BufferBmp.Canvas.Handle, Width - 2, 0, 2, 12, TE.Canvas.Handle, 0, 0, SRCCOPY );

  Calculate;

  if FProgress <> 0 then
  begin
    Bitblt( BufferBmp.Canvas.Handle, 0, 0, 3, 12, PS.Canvas.Handle, 0, 0, SRCCOPY );
    StretchBlt( BufferBmp.Canvas.Handle, 2, 0, FPos - 2, 12, PB.Canvas.Handle, 0, 0, 2, 12, SRCCOPY );
    Bitblt( BufferBmp.Canvas.Handle, FPos - 2, 0, 3, 12, PE.Canvas.Handle, 0, 0, SRCCOPY );
  end;

  Canvas.Draw( 0, 0, BufferBmp );
end;

procedure TMacProgressBar.SetBounds( ALeft : Integer; ATop : Integer; AWidth : Integer; AHeight : Integer );
begin
  AHeight := 12;

  inherited SetBounds( ALeft, ATop, AWidth, AHeight );
end;

end.
