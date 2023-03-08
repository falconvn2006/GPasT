unit FrmMain;

interface

uses
  SysUtils, Classes, Forms, Controls, ExtCtrls;

type
  TMainFrm = class(TForm)
    PnlMain: TPanel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MainFrm: TMainFrm;

implementation

uses SockApp;

{$R *.dfm}

initialization
  TWebAppSockObjectFactory.Create('c_Maintenance')

end.
