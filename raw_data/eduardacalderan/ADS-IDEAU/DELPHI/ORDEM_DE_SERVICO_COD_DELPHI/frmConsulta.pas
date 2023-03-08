unit frmConsulta;

// Observações importantes:
// - Formulário padrão para consultas de dados e uso a partir do cadastro.
// - Verificar Eventos do Grid (OnDblClick)
// - Códigos serão implementados em cada descendente.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TformConsulta = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnSelecionar: TButton;
    btnCancelar: TButton;
    dsConsulta: TDataSource;
    Panel2: TPanel;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formConsulta: TformConsulta;

implementation

{$R *.dfm}

procedure TformConsulta.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel; // informa que o form foi encerrado sem escolha
end;

procedure TformConsulta.btnSelecionarClick(Sender: TObject);
begin
  ModalResult := mrOk; // informa que o form foi encerrado com escolha
end;

end.
