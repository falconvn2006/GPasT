unit Controle.Consulta.TreeView.ProdutoCategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta.TreeView, 
  Data.DB, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient,
  uniGUIBaseClasses, uniImageList, uniLabel, uniTreeView, uniButton, uniPanel,
  Vcl.Imaging.pngimage, uniImage, uniTimer;

type
  TControleConsultaTreeViewProdutoCategoria = class(TControleConsultaTreeView)
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO_CATEGORIA_REC: TWideStringField;
    CdsConsultaPRODUTO_CATEGORIA_ID: TFloatField;
    CdsConsultaORDEM: TFloatField;
    CdsConsultaDESCRICAO_CATEGORIA: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
    procedure MontaLista(); override;
  end;

implementation

uses
  Controle.Cadastro.ProdutoCategoria;

{$R *.dfm}

procedure TControleConsultaTreeViewProdutoCategoria.MontaLista;
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

procedure TControleConsultaTreeViewProdutoCategoria.Novo;
begin
  // Se for inserido um novo id raiz então executa essa função
  if vNode = '0' then
  begin
    if ControleCadastroProdutoCategoria.NovoTreeView(StrToInt(vNode)) then
    begin
      ControleCadastroProdutoCategoria.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
  //      if Result = 1 then
        CdsConsulta.Refresh;
        MontaLista;
      end);
    end;
  end
  else
  begin
    if ControleCadastroProdutoCategoria.NovoTreeView(CdsConsultaPRODUTO_CATEGORIA_ID.AsInteger) then
    begin
      ControleCadastroProdutoCategoria.ShowModal(procedure(Sender: TComponent; Result: Integer)
      begin
  //      if Result = 1 then
        CdsConsulta.Refresh;
        MontaLista;
      end);
    end;
  end;
end;

procedure TControleConsultaTreeViewProdutoCategoria.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroProdutoCategoria.Abrir(Id) then
  begin
    ControleCadastroProdutoCategoria.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
      CdsConsulta.Refresh;
      MontaLista;
      vNode := '';
    end);
  end;
end;

procedure TControleConsultaTreeViewProdutoCategoria.UniFrameCreate(
  Sender: TObject);
begin
  inherited;
  FNomeTabela := 'produto_categoria';
  MontaLista;
end;



end.
