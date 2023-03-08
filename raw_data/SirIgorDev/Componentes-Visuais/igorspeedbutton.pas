unit IgorSpeedButton;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons;

type

  { TIgorSpeedButton }

  TIgorSpeedButton = class(TSpeedButton)
  private
    FMudarColor: TColor;
    procedure SetMudarColor(AValue: TColor);

  protected

    procedure OnMouseEnter;
    procedure OnMouseLeave;

  public
    constructor Create (AOwner: TComponent); override;

  published
    property MudarColor: TColor read FMudarColor write SetMudarColor;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Componentes Visuais Igor',[TIgorSpeedButton]);
end;

{ TIgorSpeedButton }

procedure TIgorSpeedButton.SetMudarColor(AValue: TColor);
begin
  if FMudarColor=AValue then Exit;
  FMudarColor:=AValue;
end;


procedure TIgorSpeedButton.OnMouseEnter;
begin
 inherited
 Color:= FMudarColor;
end;

procedure TIgorSpeedButton.OnMouseLeave;
begin
 inherited
 Color:= FMudarColor;
end;

constructor TIgorSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMudarColor:= $00D0B84B;
end;

end.
