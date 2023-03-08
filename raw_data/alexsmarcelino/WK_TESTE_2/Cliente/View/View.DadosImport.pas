unit View.DadosImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmDadosImport = class(TForm)
    Panel1: TPanel;
    pnlPrincipal: TPanel;
    imgIcone: TImage;
    GroupBox1: TGroupBox;
    btnSelecionar: TButton;
    edtArquivo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDadosImport: TfrmDadosImport;

implementation

{$R *.dfm}

uses Dm.Imagens;

procedure TfrmDadosImport.btnSelecionarClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(Self);
  OD.Title := 'Selecione o arquivo CSV a ser importado';
  OD.Filter := '*.csv';
  try
    if OD.Execute then
    begin
      //Validar e carregar o arquivo CSV...
    end;
  finally
    FreeAndNil(OD);
  end;
end;

procedure TfrmDadosImport.FormCreate(Sender: TObject);
begin
  dmImagens.img48.GetIcon(0,imgIcone.Picture.Icon);
end;

end.
