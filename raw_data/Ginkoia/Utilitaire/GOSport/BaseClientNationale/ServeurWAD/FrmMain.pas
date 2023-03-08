unit FrmMain;

interface

uses
  SysUtils, Classes, Forms, Controls, ExtCtrls, StdCtrls, Dialogs;

type
  TMainFrm = class(TForm)
    PnlMain: TPanel;
  private
  public
  end;

var
  MainFrm: TMainFrm;

implementation

uses SockApp,
uCtrlBaseClientNationale;

{$R *.dfm}

initialization
  TWebAppSockObjectFactory.Create('c_BaseClientNationale')

end.
