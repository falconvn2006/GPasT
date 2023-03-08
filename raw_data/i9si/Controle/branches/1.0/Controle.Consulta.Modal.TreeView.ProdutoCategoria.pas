unit Controle.Consulta.Modal.TreeView.ProdutoCategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Consulta.Modal.TreeView, uniTimer,
  Data.DB, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient,
  uniGUIBaseClasses, uniImageList, uniLabel, uniTreeView, Vcl.Imaging.pngimage,
  uniImage, uniButton, uniPanel;

type
  TControleConsultaModalTreeViewProdutoCategorias = class(TControleConsultaModalTreeView)
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO_CATEGORIA_REC: TWideStringField;
    CdsConsultaPRODUTO_CATEGORIA_ID: TFloatField;
    CdsConsultaORDEM: TFloatField;
    CdsConsultaDESCRICAO_CATEGORIA: TWideStringField;
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MontaLista(); override;
  end;

function ControleConsultaModalTreeViewProdutoCategorias: TControleConsultaModalTreeViewProdutoCategorias;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

procedure TControleConsultaModalTreeViewProdutoCategorias.MontaLista;
var
  ItemTopo, ItemPai, ItemFilho: TUniTreeNode;
begin
  inherited;

  CdsConsulta.First;
  TreeModulo.Items.Clear;

  // Inserindo o Cabeçalho da lista
  ItemTopo := TreeModulo.Items.AddChild(Nil, 'Itens da lista');
  ItemTopo.ImageIndex    := 0;
  ItemTopo.SelectedIndex := 0;
  ItemTopo.Tag := 0; // Atribuindo o id para pesquisar e abrir o cadastro

  ItemTopo := nil;
  ItemFilho := nil;

  while not CdsConsulta.Eof do
  begin
    if CdsConsultaID.AsInteger = CdsConsultaPRODUTO_CATEGORIA_ID.AsInteger then
    begin
      ItemPai := TreeModulo.Items.AddChild(ItemTopo, CdsConsulta.FieldByName('descricao_categoria').AsString);
      ItemPai.ImageIndex    := 0;
      ItemPai.SelectedIndex := 0;
      ItemPai.Tag := CdsConsulta.FieldByName('id').AsInteger; // Atribuindo o id para pesquisar e abrir o cadastro
    end
    else if CdsConsultaID.AsInteger <> CdsConsultaPRODUTO_CATEGORIA_ID.AsInteger then
    begin
      // Encontrou que o registro é um filho de outro. Porem temos que verificar se o mesmo é filho ou neto, bisneto etc..

      ItemFilho := TreeModulo.Items.AddChild(ItemPai, CdsConsulta.FieldByName('descricao_categoria_rec').AsString);
      ItemFilho.ImageIndex    := 0;
      ItemFilho.SelectedIndex := 0;
      ItemFilho.Tag := CdsConsulta.FieldByName('id').AsInteger; // Atribuindo o id para pesquisar e abrir o cadastro
    end;

    CdsConsulta.Next;
  end;
  UniTimerAbreNodeTreeView.Enabled := True;
end;

function ControleConsultaModalTreeViewProdutoCategorias: TControleConsultaModalTreeViewProdutoCategorias;
begin
  Result := TControleConsultaModalTreeViewProdutoCategorias(ControleMainModule.GetFormInstance(TControleConsultaModalTreeViewProdutoCategorias));
end;

procedure TControleConsultaModalTreeViewProdutoCategorias.UniFormShow(
  Sender: TObject);
begin
  inherited;
  MontaLista;
end;

end.


