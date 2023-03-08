unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Buttons;

type
  Tfrm_principal = class(TForm)
    Image1: TImage;
    btnCadEPI: TSpeedButton;
    btnCadFun: TSpeedButton;
    btnEPI: TSpeedButton;
    procedure btnCadEPIClick(Sender: TObject);
    procedure btnCadFunClick(Sender: TObject);
    procedure btnEPIClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_principal: Tfrm_principal;

implementation

{$R *.dfm}

uses UCadastroEPI, UCadastroFun, ULista, UDM;


procedure Tfrm_principal.btnCadEPIClick(Sender: TObject);
begin
  frm_principal.visible:= false;
  frm_cadastroepi.visible:= true;
  dm.UniTable1.Active := True;
  dm.UniTable1.Insert;
end;



procedure Tfrm_principal.btnCadFunClick(Sender: TObject);
begin
  frm_principal.visible:= false;
  frm_cadastrofun.visible:= true;
  dm.UniTable2.Active := True;
  dm.UniTable2.Insert;
end;


procedure Tfrm_principal.btnEPIClick(Sender: TObject);
begin
  frm_principal.visible:= false;
  frm_lista.visible:= true;
  dm.UniTable1.Active := True;
  dm.UniTable4.Active := True;
  dm.UniTable4.Insert;
end;

end.
