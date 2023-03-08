{ ******************************************************************************
  Title: Initial Pascal
  Description:  Model Main

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add Initial
  **************************************************************************** }
unit InitialPascal.Model.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls,
  initialPascal.Types,
  initialPascal.Model.Interfaces;

type

  { TModelMain }

  TModelMain = class(TInterfacedObject, iModelMain)
  private
    FForm: Pointer;
    FProgressbarMax: Integer;
    FProgressbarUpdate: TProcInteger;
    procedure FecharSplash;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelMain;
    function Initialize: iModelMain;
    function SplashAddForm(aForm: Pointer): iModelMain;
    function SplashUpdateProgressbar(aMax: Integer; aPosition: TProcInteger): iModelMain;
  end;

implementation

{ TModelMain }

procedure TModelMain.FecharSplash;
begin
  TForm(FForm).ModalResult := mrOK;
end;

constructor TModelMain.Create;
begin

end;

destructor TModelMain.Destroy;
begin
  inherited Destroy;
end;

class function TModelMain.New: iModelMain;
begin
  Result := Self.Create;
end;

function TModelMain.Initialize: iModelMain;
var
  vCount: Integer;
begin
  Result := Self;
  for vCount := 1 to 100 do
    FProgressbarUpdate(vCount);
end;

function TModelMain.SplashAddForm(aForm: Pointer): iModelMain;
begin
  Result := Self;
  FForm:=aForm;
end;

function TModelMain.SplashUpdateProgressbar(aMax: Integer;
  aPosition: TProcInteger): iModelMain;
begin
  Result := Self;
  FProgressbarUpdate:=aPosition;
  FProgressbarMax:=aMax;
end;

end.
