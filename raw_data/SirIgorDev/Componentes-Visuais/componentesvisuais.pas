{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ComponentesVisuais;

{$warn 5023 off : no warning about unused units}
interface

uses
  IgorEdit, IgorMaskEdit, IgorComboBox, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('IgorEdit', @IgorEdit.Register);
  RegisterUnit('IgorMaskEdit', @IgorMaskEdit.Register);
  RegisterUnit('IgorComboBox', @IgorComboBox.Register);
end;

initialization
  RegisterPackage('ComponentesVisuais', @Register);
end.
