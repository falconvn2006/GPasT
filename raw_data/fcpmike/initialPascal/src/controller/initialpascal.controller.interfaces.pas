{ ******************************************************************************
  Title: InitialPascal
  Description: Interfaces de Controller

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add Initial
  **************************************************************************** }
unit initialPascal.Controller.Interfaces;

{$mode objfpc}{$H+}

interface

uses
  Forms,
  initialPascal.Types;

type

  iControllerForms = interface
    ['{55D6156C-6948-4709-9325-0A853DF1E375}']
    function FormResult: TModalResult;
    function ShowView: iControllerForms;
  end;

  iControllerMain = interface
    ['{50DDA051-9EC3-4145-94F3-93489EBEFB44}']
    function Run: iControllerMain;
    function SplashView: iControllerForms;
    function &End: iControllerForms;
  end;

  iControllerMessage = interface
    ['{0544A097-BC29-4D53-BFBA-8AA7C2337547}']
    function Message(aValue: String): iControllerMessage;
    function MessageLeft(aValue: Boolean): iControllerMessage;
    function SetTimer(aValue: Integer): iControllerMessage;
    function TypeMessage(aValue: TFormMessage): iControllerMessage;
    function &End: iControllerForms;
  end;

  iFactoryController = interface
    ['{2E433779-B8E9-448E-8606-14E58A6B1E30}']
    function Main: iControllerMain;
  end;

implementation

end.
