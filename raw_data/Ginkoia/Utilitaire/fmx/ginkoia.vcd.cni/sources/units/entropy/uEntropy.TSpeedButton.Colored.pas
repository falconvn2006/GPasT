unit uEntropy.TSpeedButton.Colored;

interface

uses
  System.Classes,
  System.UITypes,
  FMX.StdCtrls;

type
  TSpeedButton = class(FMX.StdCtrls.TSpeedButton)
  private const
    cEnter: TAlphaColor = TAlphaColorRec.Black;
    cLeave: TAlphaColor = TAlphaColorRec.White;
  protected
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;
  end;

implementation

{ TSpeedButton }

procedure TSpeedButton.DoMouseEnter;
begin
  inherited;
  FontColor := cEnter;
end;

procedure TSpeedButton.DoMouseLeave;
begin
  inherited;
  FontColor := cLeave;
end;

end.
