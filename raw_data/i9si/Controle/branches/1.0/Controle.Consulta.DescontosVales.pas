unit Controle.Consulta.DescontosVales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Vcl.Menus, uniMainMenu,
  uniSweetAlert, frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF,
  uniGridExporters, uniBasicGrid, Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniButton, uniCheckBox,
  uniLabel, uniPanel, uniDBGrid, uniEdit, uniMultiItem, uniComboBox,
  uniDateTimePicker;

type
  TControleConsultaDescontosVales = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaCLIENTE_ID: TFloatField;
    CdsConsultaVALOR: TFloatField;
    CdsConsultaCUPOM_ORIGINAL: TFloatField;
    CdsConsultaDATA_EMISSAO: TDateTimeField;
    CdsConsultaMOTIVO: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    CdsConsultaSITUACAO: TWideStringField;
    UniComboBox1: TUniComboBox;
    UniSweetAlertCancelar: TUniSweetAlert;
    UniEdit1: TUniEdit;
    UniEdit5: TUniEdit;
    UniSweetAlertImprimirComprovante: TUniSweetAlert;
    Conexao: TfrxDBDataset;
    Relatorio: TfrxReport;
    CdsConsultaIMP: TFloatField;
    CdsConsultaOBSERVACAO_MOVIMENTO: TWideStringField;
    procedure GrdResultadoDrawColumnCell(Sender: TObject; ACol, ARow: Integer;
      Column: TUniDBGridColumn; Attribs: TUniCellAttribs);
    procedure UniSweetAlertCancelarConfirm(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
    procedure UniSweetAlertImprimirComprovanteConfirm(Sender: TObject);
    procedure CdsConsultaIMPGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
  private
      procedure Abrir(Id: Integer); override;
      procedure Novo; override;
    { Private declarations }
  public
    IdDescontoVale : Integer;
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses Controle.Cadastro.DescontosVales,
     Controle.Main.Module,
     Controle.Funcoes;


procedure TControleConsultaDescontosVales.BotaoApagarClick(Sender: TObject);
begin
  inherited;
  if CdsConsultaSITUACAO.AsString <> 'ATIVO' then
  begin
   ControleMainModule.MensageiroSweetAlerta('Atenção', 'Só é permitido cancelar um desconto ATIVO.');
  end
  else
  begin
    UniSweetAlertCancelar.Show;
  end;

end;

procedure TControleConsultaDescontosVales.CdsConsultaIMPGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  inherited;
  if CdsConsultaIMP.AsString = '' then
    Text := '<img src=./files/icones/printer-settings.png height=22 align="center" />'
  else
    Text := '<img src=./files/icones/printer-settings.png height=22 align="center" />'
end;

procedure TControleConsultaDescontosVales.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
begin
  inherited;
  if Column.FieldName = 'IMP' then
  begin
    Relatorio.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
    ControleMainModule.ExportarPDF('Relatorio',Relatorio);
  end;
end;

procedure TControleConsultaDescontosVales.GrdResultadoDrawColumnCell(
  Sender: TObject; ACol, ARow: Integer; Column: TUniDBGridColumn;
  Attribs: TUniCellAttribs);
begin
  inherited;
 if Column.FieldName = 'SITUACAO' then
  begin
    if CdsConsultaSITUACAO.AsString = 'ATIVO' then
      Attribs.Font.Color := clBlue
    else if CdsConsultaSITUACAO.AsString = 'UTILIZADO' then
      Attribs.Font.Color := clGreen
    else if CdsConsultaSITUACAO.AsString = 'CANCELADO' then
      Attribs.Font.Color := clWebOrange
  end;
end;

procedure TControleConsultaDescontosVales.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroDescontosVales.Abrir(Id) then
  begin
    ControleCadastroDescontosVales.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaDescontosVales.Novo;
begin
  if ControleCadastroDescontosVales.Novo() then
  begin
    ControleCadastroDescontosVales.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
      begin
        IdDescontoVale := ControleCadastroDescontosVales.CadastroId;
        CdsConsulta.Refresh;

        UniSweetAlertImprimirComprovante.Show;
      end;
    end);
  end;
end;



procedure TControleConsultaDescontosVales.UniSweetAlertCancelarConfirm(
  Sender: TObject);
begin
  inherited;
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

    // Passo Unico - Salva os dados da cidade
    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    begin
      // Update
      QryAx1.SQL.Text :=
                         ' UPDATE DESCONTO_VALE SET       '
                        +'       	SITUACAO	 	    =''C''  '
                        +' WHERE id               = :ID   ';
    end;

    QryAx1.Parameters.ParamByName('ID').Value := CdsConsultaID.AsInteger;

    try
      // Tenta salvar os dados
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        // Descarta a transação
        ADOConnection.RollbackTrans;
        MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
        Exit;
      end;
    end;

    // Confirma a transação
    ADOConnection.CommitTrans;
    MensageiroSweetAlerta('Sucesso!', 'Desconto/Vale cancelado!',atSuccess);

    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaDescontosVales.UniSweetAlertImprimirComprovanteConfirm(
  Sender: TObject);
var
  Test: string;
begin
  inherited;
  CdsConsulta.Locate('id',IdDescontoVale,[]);

  Relatorio.Variables.Variables['RazaoEmpresa'] := QuotedStr(ControleMainModule.FRazaoSocial);
  ControleMainModule.ExportarPDF('Relatorio',Relatorio);
end;

end.
