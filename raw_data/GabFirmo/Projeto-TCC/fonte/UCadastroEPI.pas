unit UCadastroEPI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Mask, Vcl.DBCtrls;

type
  Tfrm_cadastroepi = class(TForm)
    btn_voltarEPI: TButton;
    Image1: TImage;
    txt_nomeEquip: TDBEdit;
    txt_tipoEquip: TDBEdit;
    txt_quantidadeEquip: TDBEdit;
    btn_enviar: TButton;
    btn_cancelar: TButton;
    procedure btn_voltarEPIClick(Sender: TObject);
    procedure btn_enviarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cadastroepi: Tfrm_cadastroepi;

implementation

{$R *.dfm}

uses UPrincipal, UDM, ULista;

procedure Tfrm_cadastroepi.btn_cancelarClick(Sender: TObject);
begin
  dm.UniTable1.Active := False;
  txt_nomeEquip.Text:=('');
  txt_tipoEquip.Text:=('');
  txt_quantidadeEquip.Text:=('');
  btn_voltarEpi.visible:=true;
end;

procedure Tfrm_cadastroepi.btn_enviarClick(Sender: TObject);
begin
  dm.UniTable1.Post;
  ShowMessage('Salvo com sucesso!');
  txt_nomeEquip.Text:=('');
  txt_tipoEquip.Text:=('');
  txt_quantidadeEquip.Text:=('');
end;

procedure Tfrm_cadastroepi.btn_voltarEPIClick(Sender: TObject);
begin
  frm_cadastroepi.visible:= false;
  frm_principal.visible:= true;
end;



end.
