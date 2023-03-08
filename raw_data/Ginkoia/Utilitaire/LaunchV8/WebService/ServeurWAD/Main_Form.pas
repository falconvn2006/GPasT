unit Main_Form;

interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls;

type
  TForm5 = class(TForm)
    Btn_: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form5: TForm5;

implementation

uses SockApp;

{$R *.dfm}

initialization
  TWebAppSockObjectFactory.Create('JetonLaunch')

end.
