unit parametros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { Tparametros }

  Tparametros = class(Tcomponent)
  private
    FTCxVv: double;
    FTmpe: double;
    FTVpCv: double;
     procedure Verificacoes;
    procedure SetTCxVv(AValue: double);
    procedure SetTmpe(AValue: double);
    procedure SetTVpCv(AValue: double);
  protected

  public

  published
      property Tmpe  : double read FTmpe write SetTmpe;
      property TCxVv : double read FTCxVv write SetTCxVv;
      property TVpCv : double read FTVpCv write SetTVpCv;
     property   TtipoPartida   : string[6];
     property   TPreAquecerTB  : string[3];
      property  TPreAquecerCV  : string[3];

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Turbina',[Tparametros]);
end;

{ Tparametros }


procedure Tparametros.Verificacoes;
Begin
  //FTCxVv: double;
   // FTmpe: double;
   // FTVpCv: double;


  If FTmpe<150 then TPreAquecerTB:='Sim' else TPreAquecerTB:='Não';
  If FTmpe>370 then TtipoPartida:='Quente' else TtipoPartida:='Fria';
  IF ((FTVpCv-FTCxVv)>120) then TPreAquecerCV:='Sim' else TPreAquecerCV:='Não';

end;

procedure Tparametros.SetTmpe(AValue: double);
begin
  if FTmpe=AValue then Exit;
  FTmpe:=AValue;
end;

procedure Tparametros.SetTVpCv(AValue: double);
begin
  if FTVpCv=AValue then Exit;
  FTVpCv:=AValue;
end;

procedure Tparametros.SetTCxVv(AValue: double);
begin
  if FTCxVv=AValue then Exit;
  FTCxVv:=AValue;
end;


end.
