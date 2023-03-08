unit uCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,DBCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfCadastro = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtNome: TEdit;
    Label2: TLabel;
    dtpNasc: TDateTimePicker;
    Label3: TLabel;
    edtProfissao: TEdit;
    Label4: TLabel;
    edtEndereco: TEdit;
    edtNumero: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtBairro: TEdit;
    Label7: TLabel;
    cbEstado: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edtEmail: TEdit;
    cbEmail: TCheckBox;
    edtEmail2: TEdit;
    Label11: TLabel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    Panel2: TPanel;
    msTelefone: TMaskEdit;
    msCelular: TMaskEdit;
    cbTelefone: TCheckBox;
    Label12: TLabel;
    msCep: TMaskEdit;
    fdcad: TFDQuery;
    edtCidade: TEdit;
    Label13: TLabel;
    procedure cbTelefoneClick(Sender: TObject);
    procedure cbEmailClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }

    procedure limpar;
  public
    { Public declarations }
  end;

var
  fCadastro: TfCadastro;

implementation

{$R *.dfm}

uses uDM;

procedure TfCadastro.cbTelefoneClick(Sender: TObject);
begin
 if cbTelefone.Checked then
 begin
 msCelular.visible := true;
 Label9.Visible:=true;

 end
 else
 begin
 msCelular.visible := false;
 Label9.Visible:= false;
 end;

end;

procedure TfCadastro.limpar;
begin
 edtNome.Text:='';
  edtProfissao.Text:='';
  edtEndereco.Text:='';
  edtNumero.Text:='';
  cbEstado.Text:='selecione';
  msTelefone.Text:='';
  msCelular.Text:='';
  edtBairro.Text:='';
  edtCidade.Text:='';
  msCep.Text:='';
  edtEmail.Text:='';
  edtEmail2.Text:='';
  edtEmail2.Visible:=false;
  msCelular.Visible:=false;
  label9.Visible:=false;
  label11.Visible:=false;
  cbTelefone.Checked:=false;
  cbEmail.Checked:=false;
  dtpNasc.Date:=now;
end;

procedure TfCadastro.btnCancelarClick(Sender: TObject);
begin

 limpar;;
 close;

end;

procedure TfCadastro.btnSalvarClick(Sender: TObject);
var
celular,email2 : string;
begin

   if cbTelefone.Checked = true then
  begin
  celular := msCelular.Text;
  end
 else
  begin
  celular :='';
  end;

   if cbEmail.Checked = true then
  begin
  email2 := edtEmail2.Text;
  end
 else
  begin
  email2 :='';
  end;

  if(edtNome.Text='') OR
    (edtEndereco.Text='') OR
    (edtNumero.Text=''  ) OR
    (msCep.Text='') then
  raise Exception.Create('Verifique se os campos nome,endereço ou num estão preenchidos !');

  fdcad.Close;
  fdcad.SQL.Clear;
  fdcad.SQL.Add('INSERT INTO contato ( nome , data_nasc, profissao, endereco, '+
  'num_end, cep, bairro, uf, cidade, telefone, celular, email, email2 ) VALUES '+
  '('''+edtNome.Text+''', '''+DateToStr(dtpNasc.Date)+''','''+edtProfissao.Text+''','''+edtEndereco.Text+'''  , '+
  ' '''+edtNumero.Text+''', '''+msCep.Text+''','''+edtBairro.Text+''','''+cbEstado.Text+''','''+edtCidade.Text+''' ,'''+msTelefone.Text+''', '+
  ' '''+celular+''', '''+edtEmail.Text+''', '''+email2+'''  )   ' );
  fdcad.ExecSQL;

 // limpa componentes


   limpar;

   ShowMessage('Dados salvos com sucesso !');

end;

procedure TfCadastro.cbEmailClick(Sender: TObject);
begin

 if cbEmail.Checked then
 begin
 Label11.visible := true;
 edtEmail2.Visible:=true;

 end
 else
 begin
 Label11.Visible:= false;
 edtEmail2.visible := false;
 end;

end;

end.
