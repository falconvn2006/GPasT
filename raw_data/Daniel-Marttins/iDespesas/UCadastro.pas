unit UCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.WinXPickers, Data.DB, Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Param, FireDAC.Phys.Intf, FireDAC.Comp.Client,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Phys;

type
  TFormCadastro = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtNOME: TEdit;
    edtEMAIL: TEdit;
    Label6: TLabel;
    edtUSUARIO: TEdit;
    edtSENHA: TEdit;
    cboUF: TComboBox;
    Label7: TLabel;
    edtENDERECO: TEdit;
    Panel2: TPanel;
    Image2: TImage;
    btnConfirmar: TButton;
    datNASCIMENTO: TDateTimePicker;
    QueryCadastro: TADOQuery;
    QueryCadastroUS_NOME: TStringField;
    QueryCadastroUS_USUARIO: TStringField;
    QueryCadastroUS_EMAIL: TStringField;
    QueryCadastroUS_SENHA: TIntegerField;
    QueryCadastroUS_NASCIMENTO: TWideStringField;
    QueryCadastroUS_UF: TStringField;
    QueryCadastroUS_ENDERECO: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnConfirmarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCadastro: TFormCadastro;

implementation

{$R *.dfm}

uses ULogin, UDados;

procedure TFormCadastro.btnConfirmarClick(Sender: TObject);
begin

  ShowMessage('Cadastr Realizado com Sucesso!');
  FormCadastro.Close;
  FormLogin.Visible := True;
end;

procedure TFormCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FormLogin.Visible := True;
end;

procedure TFormCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F5 then
    begin
      QueryCadastro.SQL.Clear;
      QueryCadastro.SQL.Text := 'SELECT * FROM USUARIO WHERE US_USUARIO = ' + QuotedStr(edtUSUARIO.Text) + ' OR US_EMAIL = ' + QuotedStr(edtEMAIL.Text);
      QueryCadastro.Open;

      if QueryCadastro.RecordCount > 0 then
      begin
        ShowMessage('Usuário ou Email já existem, tente outro nome!');
        Exit;
      end

      else
      begin
        try
          QueryCadastro.Append;

          QueryCadastroUS_NOME.AsString := edtNOME.Text;
          QueryCadastroUS_USUARIO.AsString := edtUSUARIO.Text;
          QueryCadastroUS_EMAIL.AsString := edtEMAIL.Text;
          QueryCadastroUS_SENHA.AsString := edtSENHA.Text;
          QueryCadastroUS_NASCIMENTO.AsString := datNASCIMENTO.Format;
          QueryCadastroUS_UF.AsString := cboUF.Text;
          QueryCadastroUS_ENDERECO.AsString := edtENDERECO.Text;

          QueryCadastro.Post;

          ShowMessage('Cadastro Realizado com Sucesso!');
          FormCadastro.Close;
          FormLogin.Visible := True;
        except
          On e: Exception do
            showMessage('Não Foi Possivel Concluir o Cadastro, Tente Novamente mais tarde!');
        end;
      end;
    end;
end;

end.
