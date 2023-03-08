unit Controle.Consulta.Modal.TreeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniButton, uniPanel,
  uniTreeView, Vcl.Imaging.pngimage, uniImage, uniTimer, uniLabel;

type
  TControleConsultaModalTreeView = class(TUniForm)
    UniPanel1: TUniPanel;
    BotaoConfirma: TUniButton;
    BotaoNovo: TUniButton;
    UniPanel2: TUniPanel;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    UniImageList1: TUniImageList;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    DscConsulta: TDataSource;
    TreeModulo: TUniTreeView;
    UniTimerAbreNodeTreeView: TUniTimer;
    UniImageCollapse: TUniImage;
    UniImageExpand: TUniImage;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    procedure UniTimerAbreNodeTreeViewTimer(Sender: TObject);
    procedure UniImageCollapseClick(Sender: TObject);
    procedure UniImageExpandClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure BotaoConfirmaClick(Sender: TObject);
    procedure TreeModuloDblClick(Sender: TObject);
    procedure TreeModuloChange(Sender: TObject; Node: TUniTreeNode);
    procedure TreeModuloNodeCollapse(Sender: TObject; Node: TUniTreeNode);
    procedure TreeModuloNodeExpand(Sender: TObject; Node: TUniTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
    vNode: string;
    procedure MontaLista; virtual; abstract;
  end;

function ControleConsultaModalTreeView: TControleConsultaModalTreeView;

implementation

{$R *.dfm}

uses  TypInfo,
  uniGUIDialogs, System.DateUtils,
  uniGUIApplication, Controle.Main.Module, Controle.Funcoes, 
  Controle.Server.Module;

  // fazer um herdado desse para o produto


function ControleConsultaModalTreeView: TControleConsultaModalTreeView;
begin
  Result := TControleConsultaModalTreeView(ControleMainModule.GetFormInstance(TControleConsultaModalTreeView));
end;

procedure TControleConsultaModalTreeView.BotaoConfirmaClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TControleConsultaModalTreeView.TreeModuloChange(Sender: TObject;
  Node: TUniTreeNode);
begin
  vNode := Node.tag.ToString;
  if not CdsConsulta.Locate('id', StrToInt(Node.tag.ToString),[]) then
  begin
    // Não encontrou então é porque ele esta clicando no topo da lista
    vNode := '0';
  end;
end;

procedure TControleConsultaModalTreeView.TreeModuloDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TControleConsultaModalTreeView.TreeModuloNodeCollapse(Sender: TObject;
  Node: TUniTreeNode);
begin
  UniImageCollapse.Visible := True;
  UniImageExpand.Visible   := False;
end;

procedure TControleConsultaModalTreeView.TreeModuloNodeExpand(Sender: TObject;
  Node: TUniTreeNode);
begin
  UniImageCollapse.Visible := False;
  UniImageExpand.Visible   := True;
end;

procedure TControleConsultaModalTreeView.UniFormShow(Sender: TObject);
Var
  Dia, Mes, Ano : Word;
begin
  CdsConsulta.Open;

  // Colocando a data no bottom
  DecodeDate(Now, Ano, Mes, Dia);
  UniLabelCorpright.Caption := 'Copyright © ' + InttoStr(Ano) + ' I9si Sistemas. Todos os direitos reservados.';
end;

procedure TControleConsultaModalTreeView.UniImageCollapseClick(Sender: TObject);
begin
  TreeModulo.FullExpand;
  UniImageCollapse.Visible := False;
  UniImageExpand.Visible   := True;
end;

procedure TControleConsultaModalTreeView.UniImageExpandClick(Sender: TObject);
begin
  TreeModulo.FullCollapse;
  UniImageCollapse.Visible := True;
  UniImageExpand.Visible   := False;
end;

procedure TControleConsultaModalTreeView.UniTimerAbreNodeTreeViewTimer(
  Sender: TObject);
begin
  // Necessário pois no metodo convencional nao funciona
  UniTimerAbreNodeTreeView.Enabled := False;
  TreeModulo.FullExpand;
end;

end.
