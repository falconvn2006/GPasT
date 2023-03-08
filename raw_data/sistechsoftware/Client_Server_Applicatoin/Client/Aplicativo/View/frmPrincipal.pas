unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfPrincipal = class(TForm)
    btnNovoCliente: TButton;
    btnAtualizarEnderecos: TButton;
    procedure btnNovoClienteClick(Sender: TObject);
    procedure btnAtualizarEnderecosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
  frmCadPessoa, EnderecoController;

{$R *.dfm}
procedure TfPrincipal.btnAtualizarEnderecosClick(Sender: TObject);
var
  enderecoController : TEnderecoController;
begin
  try
    enderecoController := TEnderecoController.Create;
    enderecoController.AtualizarEndIntegracao;
  finally
    FreeAndNil(enderecoController);
  end;
end;

procedure TfPrincipal.btnNovoClienteClick(Sender: TObject);
begin
  try
    fCadPessoa := TFCadPessoa.Create(Self);
    fCadPessoa.ShowModal;
  finally
    FreeAndNil(fCadPessoa);
  end;
end;

end.
