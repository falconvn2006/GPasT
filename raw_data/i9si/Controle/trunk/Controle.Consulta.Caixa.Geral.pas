unit Controle.Consulta.Caixa.Geral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, uniSweetAlert, Vcl.Menus,
  uniMainMenu, frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF,
  uniGridExporters, uniBasicGrid, Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, uniButton, uniEdit, uniDateTimePicker;

type
  TControleConsultaCaixaGeral = class(TControleConsulta)
    CdsConsultaLOGIN: TWideStringField;
    CdsConsultaDATA_ABERTURA: TWideStringField;
    CdsConsultaDATA_FECHAMENTO: TWideStringField;
    CdsConsultaENTRADA: TFloatField;
    CdsConsultaSAIDA: TFloatField;
    CdsConsultaDATA: TDateTimeField;
    CdsConsultaID: TFloatField;
    CdsConsultaUSUARIO_ID: TFloatField;
    UniEdit1: TUniEdit;
    UniPopupMenuOpcoes: TUniPopupMenu;
    Deletarmovimento1: TUniMenuItem;
    dtpInicial: TUniDateTimePicker;
    dtpFinal: TUniDateTimePicker;
    btnFiltrar: TUniButton;
    UniPanel3: TUniPanel;
    UniLabel1: TUniLabel;
    edtSaldo: TUniFormattedNumberEdit;
    UniLabel2: TUniLabel;
    edtEntradas: TUniFormattedNumberEdit;
    UniLabel3: TUniLabel;
    edtSaidas: TUniFormattedNumberEdit;
    CdsConsultaTOTAL_ENTRADAS: TAggregateField;
    CdsConsultaTOTAL_SAIDAS: TAggregateField;
    CdsConsultaSALDO: TAggregateField;
    procedure BotaoAbrirClick(Sender: TObject);
    procedure GrdResultadoDblClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure CdsConsultaAfterRefresh(DataSet: TDataSet);
    procedure CdsConsultaAfterOpen(DataSet: TDataSet);
  private
    procedure filtraCaixa(vDataInicial : string = '';vDataFinal : string = '');
    procedure AtualizaTotais;
    { Private declarations }
  public
    { Public declarations }
  //procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}

uses Controle.Cadastro.Caixa, Controle.Main.Module, Controle.Main;

procedure TControleConsultaCaixaGeral.BotaoAbrirClick(Sender: TObject);
var
  MesmoUsuarioLogado : Boolean;
begin
  //inherited;
  MesmoUsuarioLogado := True;
  // Indica que o usuario do caixa geral pode alterar outros caixas!!
  ControleCadastroCaixa.GestorCaixaGeral := True;

  if CdsConsultaUSUARIO_ID.AsInteger = ControleMainModule.FUsuarioId then
    MesmoUsuarioLogado := true;

  if ControleCadastroCaixa.AbrirCaixa(CdsConsultaID.AsInteger,MesmoUsuarioLogado) then
  begin
    ControleCadastroCaixa.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaCaixaGeral.btnFiltrarClick(Sender: TObject);
begin
  inherited;
  filtraCaixa(Trim(DateToStr(dtpInicial.DateTime)),
              Trim(DateToStr(dtpFinal.DateTime)));
end;

procedure TControleConsultaCaixaGeral.CdsConsultaAfterOpen(DataSet: TDataSet);
begin
  inherited;
  AtualizaTotais;
end;

procedure TControleConsultaCaixaGeral.CdsConsultaAfterRefresh(
  DataSet: TDataSet);
begin
  inherited;
  AtualizaTotais;
end;

procedure TControleConsultaCaixaGeral.GrdResultadoDblClick(Sender: TObject);
begin
  //  inherited;
  BotaoAbrir.Click;
end;

procedure TControleConsultaCaixaGeral.filtraCaixa(vDataInicial : string = '';vDataFinal : string = '');
var
  sql : string;
begin
   with ControleMainModule do
    begin
      CdsConsulta.Close;
      QryConsulta.SQL.Clear;
      QryConsulta.Parameters.Clear;
            sql :=         ' SELECT c.id,'
                          +'          usu.login,'
                          +'          c.data_abertura data,'
                          +'          c.usuario_id,'
                          +'          TO_CHAR(c.data_abertura, ''dd/mm/yy hh:mm'') data_abertura,'
                          +'          CASE'
                          +'             WHEN c.data_fechamento IS NULL THEN ''ABERTO'' '
                          +'             ELSE TO_CHAR (C.data_fechamento, ''dd/mm/yy hh:mm'')'
                          +'          END'
                          +'             DATA_FECHAMENTO,'
                          +'          SUM ('
                          +'             CASE'
                          +'                WHEN cm.operacao <> ''E'' AND cm.natureza = ''RC'' THEN VALOR'
                          +'                WHEN cm.operacao <> ''E'' AND cm.natureza = ''SU'' THEN VALOR'
                          +'             END)'
                          +'             ENTRADA,'
                          +'          SUM ('
                          +'             CASE'
                          +'                WHEN cm.operacao <> ''E'' AND cm.natureza = ''PG'' THEN VALOR'
                          +'                WHEN cm.operacao <> ''E'' AND cm.natureza = ''SA'' THEN VALOR'
                          +'             END)'
                          +'             SAIDA'
                          +'     FROM caixa C'
                          +'          INNER JOIN caixa_movimento cm'
                          +'             ON CM.CAIXA_ID = c.id'
                          +'          LEFT JOIN condicoes_pagamento cp'
                          +'             ON cp.id = cm.forma_pagamento_id'
                          +'          INNER JOIN usuario.usuario usu'
                          +'             ON usu.ID = c.usuario_id'
                          +'    WHERE usu.login LIKE :login ';
          if (vDataFinal <> '') and (vDataInicial <> '') then
          begin
            sql := sql
                          +'   AND TRUNC(c.data_abertura)'
                          +'              BETWEEN to_date(''' + Trim(DateToStr(dtpInicial.DateTime)) + ''', ''dd/mm/yyyy'')'
                          +'              AND to_date(''' + Trim(DateToStr(dtpFinal.DateTime)) + ''', ''dd/mm/yyyy'')'
          end;

            sql := sql
                          +'    GROUP BY c.id,'
                          +'          usu.login,'
                          +'          c.data_abertura,'
                          +'          c.usuario_id,'
                          +'          c.data_fechamento'
                          +'    ORDER BY 2,1 DESC';
//      QryConsulta.SaveToFile('testeSql.txt');
      QryConsulta.SQL.Text := sql;
      CdsConsulta.Open;
    end;
end;

procedure TControleConsultaCaixaGeral.AtualizaTotais;
begin

  edtEntradas.Value := StrToFloatDef(CdsConsultaTOTAL_ENTRADAS.AsString,0);
  edtSaidas.Value := StrToFloatDef(CdsConsultaTOTAL_SAIDAS.AsString,0);
  edtSaldo.Value := (edtEntradas.Value - edtSaidas.Value);
end;

end.
