unit IgorEdit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TIgorEdit }

  TIgorEdit = class(TEdit)
  private
    FMudarColor: TColor;
    procedure SetMudarColor(AValue: TColor);

  protected
    procedure DoEnter; override;
    procedure DoExit;  override;

  public
    constructor Create (AOwner: TComponent); override;

  published
    property MudarColor: TColor read FMudarColor write SetMudarColor;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Componentes Visuais Igor',[TIgorEdit]);
end;

{ TIgorEdit }

procedure TIgorEdit.SetMudarColor(AValue: TColor);
begin
  if FMudarColor=AValue then Exit;
  FMudarColor:=AValue;
end;

procedure TIgorEdit.DoEnter;
begin
  inherited DoEnter;
  Color:= FMudarColor;
end;

procedure TIgorEdit.DoExit;
begin
  inherited DoExit;
  Color:= clWhite;
end;

constructor TIgorEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMudarColor:= $00D6F4FE;
end;

end.
