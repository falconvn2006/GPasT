{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit NovoPacote;

{$warn 5023 off : no warning about unused units}
interface

uses
  ShapeF, Mutishape, GGAUGE, PROGRESS, ALProgressBar, RLed, 
  gridparaprogressbar, janRoundedButton, atshapeline, gridparaprogressCur, 
  AMAdvLed, EscalaQualquer, Valve, MultiLineBitBtn, PanelEstacaoMotor, Mgauge, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ShapeF', @ShapeF.Register);
  RegisterUnit('Mutishape', @Mutishape.Register);
  RegisterUnit('GGAUGE', @GGAUGE.Register);
  RegisterUnit('PROGRESS', @PROGRESS.Register);
  RegisterUnit('ALProgressBar', @ALProgressBar.Register);
  RegisterUnit('RLed', @RLed.Register);
  RegisterUnit('gridparaprogressbar', @gridparaprogressbar.Register);
  RegisterUnit('janRoundedButton', @janRoundedButton.Register);
  RegisterUnit('atshapeline', @atshapeline.Register);
  RegisterUnit('gridparaprogressCur', @gridparaprogressCur.Register);
  RegisterUnit('AMAdvLed', @AMAdvLed.Register);
  RegisterUnit('EscalaQualquer', @EscalaQualquer.Register);
  RegisterUnit('Valve', @Valve.Register);
  RegisterUnit('MultiLineBitBtn', @MultiLineBitBtn.Register);
  RegisterUnit('PanelEstacaoMotor', @PanelEstacaoMotor.Register);
  RegisterUnit('Mgauge', @Mgauge.Register);
end;

initialization
  RegisterPackage('NovoPacote', @Register);
end.
