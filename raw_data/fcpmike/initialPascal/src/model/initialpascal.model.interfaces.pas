{ ******************************************************************************
  Title: Initial Pascal
  Description: Interfaces Model

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add Initial
  **************************************************************************** }
unit InitialPascal.Model.Interfaces;

{$mode objfpc}{$H+}

interface

uses
  initialPascal.Types;

type

  iModelMain = interface
    ['{C97CAA5B-A180-4E40-8E4F-15615DBE17E5}']
    function Initialize: iModelMain;
    function SplashAddForm(aForm: Pointer): iModelMain;
    function SplashUpdateProgressbar(aMax: Integer; aPosition: TProcInteger): iModelMain;
  end;

implementation

end.

