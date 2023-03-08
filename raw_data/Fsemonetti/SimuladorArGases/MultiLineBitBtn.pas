unit MultiLineBitBtn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, LCLType, Windows;

type

  { TMultiLineBitBtn }

  TMultiLineBitBtn = class(TButton)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('teste',[TMultiLineBitBtn]);
end;

{ TMultiLineBitBtn }

procedure TMultiLineBitBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or BS_MULTILINE;
end;

end.

