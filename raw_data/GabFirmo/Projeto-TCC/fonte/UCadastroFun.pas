unit UCadastroFun;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Mask, Vcl.DBCtrls;

type
  Tfrm_cadastrofun = class(TForm)
    btn_voltar: TButton;
    Image1: TImage;
    txt_nomeFun: TDBEdit;
    txt_idFun: TDBEdit;
    btn_cancelar: TButton;
    btn_enviar: TButton;
    procedure btn_voltarClick(Sender: TObject);
    procedure btn_enviarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cadastrofun: Tfrm_cadastrofun;

implementation

{$R *.dfm}

uses UPrincipal, UDM;

procedure Tfrm_cadastrofun.btn_cancelarClick(Sender: TObject);
begin
  dm.UniTable2.Active := False;
  txt_nomeFun.Text:=('');
  txt_idFun.Text:=('');
  btn_voltar.visible:=true;
end;

procedure Tfrm_cadastrofun.btn_enviarClick(Sender: TObject);
begin
  dm.UniTable2.Post;
  ShowMessage('Salvo com sucesso!');
  txt_nomeFun.Text:=('');
  txt_idFun.Text:=('');
end;

procedure Tfrm_cadastrofun.btn_voltarClick(Sender: TObject);
begin
  frm_cadastrofun.visible:= false;
  frm_principal.visible:= true;
end;

end.
