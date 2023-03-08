unit Controle.Consulta.Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit,
  uniGridExporters, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniCheckBox, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, uniMultiItem, uniComboBox;

type
  TControleConsultaProduto = class(TControleConsulta)
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaNCM: TWideStringField;
    QryConsultaCEST: TWideStringField;
    QryConsultaPRECO_VENDA: TFloatField;
    QryConsultaICMS_CST: TWideStringField;
    QryConsultaSALDO_OPERACIONAL: TFloatField;
    QryConsultaVALOR_TOTAL: TFloatField;
    QryConsultaCODIGO: TWideStringField;
    QryConsultaUNIDADE_MEDIDA: TWideStringField;
    QryConsultaATIVO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaNCM: TWideStringField;
    CdsConsultaCEST: TWideStringField;
    CdsConsultaPRECO_VENDA: TFloatField;
    CdsConsultaICMS_CST: TWideStringField;
    CdsConsultaSALDO_OPERACIONAL: TFloatField;
    CdsConsultaVALOR_TOTAL: TFloatField;
    CdsConsultaCODIGO: TWideStringField;
    CdsConsultaUNIDADE_MEDIDA: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    QryConsultaCATEGORIA: TWideStringField;
    CdsConsultaCATEGORIA: TWideStringField;
    QryConsultaPALAVRA_CHAVE: TWideStringField;
    CdsConsultaPALAVRA_CHAVE: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure CdsConsultaATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

uses
  Controle.Main.Module, Controle.Cadastro.Produto;

{$R *.dfm}

procedure TControleConsultaProduto.CdsConsultaATIVOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  inherited;
  if Sender.AsString = 'SIM' then
    Text := '<img src=./files/icones/check-outline.png height=20 align="center" />'
  else if Sender.AsString = 'NÃO' then
    Text := '<img src=./files/icones/close-thick.png height=20 align="center" />';
end;

procedure TControleConsultaProduto.Novo;
begin
  inherited;
  if ControleCadastroProduto.Novo() then
  begin
    ControleCadastroProduto.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaProduto.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroProduto.Abrir(Id) then
  begin
    ControleCadastroProduto.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaProduto.UniFrameCreate(Sender: TObject);
begin
  CdsConsulta.Params.ParamByName('filial_id').Value := ControleMainModule.FFilial;
  inherited;
  FNomeTabela := 'produto';
end;

end.
