unit Controle.Consulta.TreeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton, uniTreeView, uniTimer, uniSweetAlert;

type
  TControleConsultaTreeView = class(TUniFrame)
    UniPanel1: TUniPanel;
    BotaoNovo: TUniButton;
    BotaoAbrir: TUniButton;
    BotaoApagar: TUniButton;
    BotaoAtualizar: TUniButton;
    UniPanel21: TUniPanel;
    UniPanel2: TUniPanel;
    UniPanelLeft: TUniPanel;
    UniPanelRight: TUniPanel;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    UniImageList1: TUniImageList;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    DscConsulta: TDataSource;
    TreeModulo: TUniTreeView;
    UniImageExpand: TUniImage;
    UniImageCollapse: TUniImage;
    UniTimerAbreNodeTreeView: TUniTimer;
    UniSweetExclusaoRegistro: TUniSweetAlert;
    procedure UniFrameCreate(Sender: TObject);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
    procedure BotaoAtualizarClick(Sender: TObject);
    procedure UniImageCollapseClick(Sender: TObject);
    procedure UniImageExpandClick(Sender: TObject);
    procedure TreeModuloChange(Sender: TObject; Node: TUniTreeNode);
    procedure TreeModuloNodeExpand(Sender: TObject; Node: TUniTreeNode);
    procedure TreeModuloNodeCollapse(Sender: TObject; Node: TUniTreeNode);
    procedure UniTimerAbreNodeTreeViewTimer(Sender: TObject);
    procedure UniSweetExclusaoRegistroConfirm(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FNomeTabela: String; //Guarda o nome da tabela para a passagem de parametro para o delete
    vNode: string;
    procedure Novo; virtual; abstract;
    procedure Abrir(Id: Integer); virtual; abstract;
    procedure Apagar(Id: Integer; tabela: String);
    procedure AtualizaComandos; virtual; abstract;
    procedure MontaLista; virtual; abstract;
  end;

implementation

{$R *.dfm}

uses  TypInfo,
  uniGUIDialogs, System.DateUtils,
  uniGUIApplication, Controle.Main.Module, Controle.Funcoes, 
  Controle.Server.Module;

procedure TControleConsultaTreeView.Apagar(Id: Integer; tabela: String);
var
  Erro: String;
begin
  Erro := '';
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Inserindo o login do usuario em tabela temporaria,
    // Utilizado para auditoria
    Insere_Tabela_Temp_Login;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'DELETE FROM '+ tabela +''
      + ' WHERE id = :id';
    QryAx1.Parameters.ParamByName('id').Value := Id;

    try
      // Tenta apagar o registro
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;

    if Erro = '' then
    begin
      // Confirma a transação
      ADOConnection.CommitTrans;

      // Atualiza a lista
      CdsConsulta.Refresh;
    end
    else
    begin
      // Descarta a transação
      ADOConnection.RollbackTrans;
    end;
  end;
end;

procedure TControleConsultaTreeView.BotaoAbrirClick(Sender: TObject);
begin
  if not CdsConsulta.Active or CdsConsulta.IsEmpty  then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Nenhum registro encontrado!')
  else
  begin
    // Abre o registro para visualização
    if vNode <> '' then
      if vNode <> '0' then
        Abrir(CdsConsulta.FieldByName('id').AsInteger)
      else
        ControleMainModule.MensageiroSweetAlerta('Atenção', 'Escolha um item na lista para abrir/editar!')
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção', 'Escolha um item na lista para abrir/editar!');
  end;
end;

procedure TControleConsultaTreeView.BotaoApagarClick(Sender: TObject);
begin
  UniSweetExclusaoRegistro.Show;
end;

procedure TControleConsultaTreeView.BotaoAtualizarClick(Sender: TObject);
begin
  CdsConsulta.Refresh;
  MontaLista;
end;

procedure TControleConsultaTreeView.BotaoNovoClick(Sender: TObject);
begin
  if vNode = '' then
    vNode := '0';

  if vNode <> '' then
    Novo
  else
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Escolha um item na lista para inserir!');
end;

procedure TControleConsultaTreeView.TreeModuloChange(Sender: TObject;
  Node: TUniTreeNode);
begin
  vNode := Node.tag.ToString;
  if not CdsConsulta.Locate('id', StrToInt(Node.tag.ToString),[]) then
  begin
    // Não encontrou então é porque ele esta clicando no topo da lista
    vNode := '0';
  end;
end;

procedure TControleConsultaTreeView.TreeModuloNodeCollapse(Sender: TObject;
  Node: TUniTreeNode);
begin
  UniImageCollapse.Visible := True;
  UniImageExpand.Visible   := False;
end;

procedure TControleConsultaTreeView.TreeModuloNodeExpand(Sender: TObject;
  Node: TUniTreeNode);
begin
  UniImageCollapse.Visible := False;
  UniImageExpand.Visible   := True;
end;

procedure TControleConsultaTreeView.UniFrameCreate(Sender: TObject);
Var
  Dia, Mes, Ano : Word;
begin
  CdsConsulta.Open;

  // Colocando a data no bottom
  DecodeDate(Now, Ano, Mes, Dia);
  UniLabelCorpright.Caption := 'Copyright © ' + InttoStr(Ano) + ' I9si Sistemas. Todos os direitos reservados.';
end;

procedure TControleConsultaTreeView.UniImageCollapseClick(Sender: TObject);
begin
  TreeModulo.FullExpand;
  UniImageCollapse.Visible := False;
  UniImageExpand.Visible   := True;
end;

procedure TControleConsultaTreeView.UniImageExpandClick(Sender: TObject);
begin
  TreeModulo.FullCollapse;
  UniImageCollapse.Visible := True;
  UniImageExpand.Visible   := False;
end;

procedure TControleConsultaTreeView.UniSweetExclusaoRegistroConfirm(
  Sender: TObject);
begin
  Apagar(CdsConsulta.FieldByName('id').AsInteger,
         FNomeTabela);
  MontaLista;
end;

procedure TControleConsultaTreeView.UniTimerAbreNodeTreeViewTimer(Sender: TObject);
begin
  // Necessário pois no metodo convencional nao funciona
  UniTimerAbreNodeTreeView.Enabled := False;
  TreeModulo.FullExpand;
end;

end.
