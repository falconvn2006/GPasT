unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Datasnap.DBClient, Datasnap.Provider, MidasLib, Dm.Dados;

type

  TfrmPrincipal = class(TForm)
    ToolBar1: TToolBar;
    pcPessoas: TPageControl;
    tsListagem: TTabSheet;
    pngDados: TPanel;
    dbgDados: TDBGrid;
    tbbIncluir: TToolButton;
    tbbExcluir: TToolButton;
    tbbEditar: TToolButton;
    tbbPrimeiro: TToolButton;
    tbbAnterior: TToolButton;
    tbbProximo: TToolButton;
    tbbUltimo: TToolButton;
    tbbImportar: TToolButton;
    tbbConectar: TToolButton;
    tbbViaCep: TToolButton;
    tbbAtualizar: TToolButton;
    procedure dbgDadosDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses Dm.Imagens, View.DadosImport, View.Manutencao;

procedure TfrmPrincipal.dbgDadosDblClick(Sender: TObject);
begin
   if dmDados.cdsDados.IsEmpty then
     Abort;
   dmDados.acEditarExecute(Self);
end;

end.
