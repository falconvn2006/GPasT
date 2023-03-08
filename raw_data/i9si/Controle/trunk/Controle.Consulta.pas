unit Controle.Consulta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses,  uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniMultiItem, uniComboBox,
  uniDBComboBox, uniDBLookupComboBox, uniEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, uniScreenMask,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, System.Math,
  System.MaskUtils, uniCanvas, uniLabel, uniMemo,  System.Win.ComObj,
  uniGridExporters, uniRadioGroup, uniCheckBox, frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn,  
   uniImage, Vcl.Imaging.pngimage, uniSweetAlert, Vcl.Menus, uniMainMenu;

type
  TControleConsulta = class(TUniFrame)
    UniImageList1: TUniImageList;
    UniPanel1: TUniPanel;
    BotaoNovo: TUniButton;
    BotaoAbrir: TUniButton;
    BotaoApagar: TUniButton;
    UniPanel2: TUniPanel;
    GrdResultado: TUniDBGrid;
    UniPanelLeft: TUniPanel;
    UniHiddenPanel1: TUniHiddenPanel;
    UniPanelRight: TUniPanel;
    UniPanelBottom: TUniPanel;
    BotaoAtualizar: TUniButton;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    DscConsulta: TDataSource;
    UniPanel21: TUniPanel;
    UniGridHTMLExporter1: TUniGridHTMLExporter;
    UniLabelCorpright: TUniLabel;
    UniCheckBoxLimitePagina: TUniCheckBox;
    frxPDFExport: TfrxPDFExport;
    frxDBDataset: TfrxDBDataset;
    frxReport: TfrxReport;
    UniSweetExclusaoRegistro: TUniSweetAlert;
    UniPopupMenuExportar: TUniPopupMenu;
    Exportardadosexcel1: TUniMenuItem;
    Exportardadoshtml1: TUniMenuItem;
    Gerardocumento1: TUniMenuItem;
    UniImageListExportar: TUniImageList;
    botaoExportar: TUniButton;
    UniGridExcelExporter2: TUniGridExcelExporter;
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure UniFrameCreate(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
    procedure GrdResultadoTitleClick(Column: TUniDBGridColumn);
    procedure BotaoNovoClick(Sender: TObject);
    procedure BotaoAtualizarClick(Sender: TObject);
    procedure GrdResultadoDblClick(Sender: TObject);
    procedure UniCheckBoxLimitePaginaChange(Sender: TObject);
    procedure UniSweetExclusaoRegistroConfirm(Sender: TObject);
    procedure botaoExportarClick(Sender: TObject);
    procedure Exportardadosexcel1Click(Sender: TObject);
    procedure Exportardadoshtml1Click(Sender: TObject);
    procedure Gerardocumento1Click(Sender: TObject);
  private
    { Private declarations }
    function SortCustomClientDataSet(DataSet: TCustomClientDataSet;
      const FieldName: String): Boolean;
    function ExibeMostraCamposUniDbGridDescricao: String;
    function ExibeMostraCamposUniDbGridCampo: String;
//    procedure ImprimirDocumentoContrato(NomeArquivo: string);
//    procedure LocalizarSubstituir(Localizar, Substituir: string);
  public
    { Public declarations }
    PosicaoMouseX : Integer;
    PosicaoMouseY : Integer;
    FNomeTabela: String; //Guarda o nome da tabela para a passagem de parametro para o delete
    UniMemoCamposUniDBGridDescricao : TUniMemo;
    UniMemoCamposUniDBGridCampo     : TUniMemo;
    procedure Novo; virtual; abstract;
    procedure Abrir(Id: Integer); virtual; abstract;
    procedure Apagar(Id: Integer; tabela: String);
    procedure AtualizaComandos; virtual; abstract;
  end;


implementation

{$R *.dfm}

uses  TypInfo,
  uniGUIDialogs, System.DateUtils,
  uniGUIApplication, Controle.Main.Module, Controle.Funcoes, 
  Controle.Server.Module, Controle.Consulta.Geracao.Documento,
  frxRich, Controle.Main;

procedure TControleConsulta.BotaoAbrirClick(Sender: TObject);
begin
  if not CdsConsulta.Active or CdsConsulta.IsEmpty  then
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Nenhum registro encontrado!')
  else
  begin
    // Abre o registro para visualização
    Abrir(CdsConsulta.FieldByName('id').AsInteger);
  end;
end;

procedure TControleConsulta.BotaoApagarClick(Sender: TObject);
begin
  UniSweetExclusaoRegistro.Show;
end;

procedure TControleConsulta.BotaoAtualizarClick(Sender: TObject);
begin
  CdsConsulta.Refresh;
end;

procedure TControleConsulta.botaoExportarClick(Sender: TObject);
begin
  UniPopupMenuExportar.Popup(ControleMain.PosicaoMouseX +10,ControleMain.PosicaoMouseY +10) ;
end;

procedure TControleConsulta.BotaoNovoClick(Sender: TObject);
begin
  Novo;
end;

procedure TControleConsulta.Gerardocumento1Click(Sender: TObject);
begin
  // Abre o formulário em modal e aguarda
  ControleConsultaGeracaoDocumento.UniMemo.Text  := ExibeMostraCamposUniDbGridDescricao;
  ControleConsultaGeracaoDocumento.UniMemo1.Text := ExibeMostraCamposUniDbGridCampo;
  ControleConsultaGeracaoDocumento.CdsConsultaClone.CloneCursor(CdsConsulta,False,false);
  ControleConsultaGeracaoDocumento.ShowModal;
end;

procedure TControleConsulta.GrdResultadoColumnFilter(Sender: TUniDBGrid;
  const Column: TUniDBGridColumn; const Value: Variant);
var
  V : Variant;
  I : Integer;
begin
  if CdsConsulta.Active then
  begin
    for I := 0 to Sender.Columns.Count - 1  do
      if Sender.Columns[I].Filtering.Enabled then
      begin
        V := StringReplace(Sender.Columns[I].Filtering.VarValue, ',', '.', [rfReplaceAll]);
        CdsConsulta.Params.ParamByName(Sender.Columns[I].FieldName).Value := '%'+V+'%';
      end;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsulta.GrdResultadoDblClick(Sender: TObject);
begin
  BotaoAbrir.Click;
end;

procedure TControleConsulta.GrdResultadoTitleClick(Column: TUniDBGridColumn);
begin
  SortCustomClientDataSet(CdsConsulta, Column.FieldName);
end;

function TControleConsulta.SortCustomClientDataSet(DataSet: TCustomClientDataSet;
  const FieldName: String): Boolean;
var
  i: Integer;
  IndexDefs: TIndexDefs;
  IndexName: String;
  IndexOptions: TIndexOptions;
  Field: TField;
begin
  Result := False;
  Field := DataSet.Fields.FindField(FieldName);
  //If invalid field name, exit.
  if Field = nil then Exit;
  //if invalid field type, exit.
  if (Field is TObjectField) or (Field is TBlobField) or
    (Field is TAggregateField) or (Field is TVariantField)
     or (Field is TBinaryField) then Exit;
  //Get IndexDefs and IndexName using RTTI
  if IsPublishedProp(DataSet, 'IndexDefs') then
    IndexDefs := GetObjectProp(DataSet, 'IndexDefs') as TIndexDefs
  else
    Exit;
  if IsPublishedProp(DataSet, 'IndexName') then
    IndexName := GetStrProp(DataSet, 'IndexName')
  else
    Exit;
  //Ensure IndexDefs is up-to-date
  IndexDefs.Update;
  //If an ascending index is already in use,
  //switch to a descending index
  if IndexName = FieldName + '__IdxA'
  then
    begin
      IndexName := FieldName + '__IdxD';
      IndexOptions := [ixDescending];
    end
  else
    begin
      IndexName := FieldName + '__IdxA';
      IndexOptions := [];
    end;
  //Look for existing index
  for i := 0 to Pred(IndexDefs.Count) do
  begin
    if IndexDefs[i].Name = IndexName then
      begin
        Result := True;
        Break
      end;  //if
  end; // for
  //If existing index not found, create one
  if not Result then
      begin
        DataSet.AddIndex(IndexName, FieldName, IndexOptions);
        Result := True;
      end; // if not
  //Set the index
  SetStrProp(DataSet, 'IndexName', IndexName);
end;

procedure TControleConsulta.Apagar(Id: Integer; tabela: String);
var
  Erro: String;
begin
  Erro := '';
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnection.BeginTrans;

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

// -------------------------------------------------------------------------- //
procedure TControleConsulta.UniCheckBoxLimitePaginaChange(Sender: TObject);
var
  newpageSize: String;
begin
  if UniCheckBoxLimitePagina.Checked = True then
  begin
    newpageSize := '100000';
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().pageSize = '+newpageSize+';');
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().reload({params:{start:0, limit:'+newpageSize+'}});');
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().loadPage(1);');
    UniSession.AddJS(Self.Name + '.GrdResultado.getView().refresh();');
  end
  else
  begin
    newpageSize := '25';
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().pageSize = '+newpageSize+';');
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().reload({params:{start:0, limit:'+newpageSize+'}});');
    UniSession.AddJS(Self.Name + '.GrdResultado.getStore().loadPage(1);');
    UniSession.AddJS(Self.Name + '.GrdResultado.getView().refresh();');
    CdsConsulta.Refresh;
  end;
  GrdResultado.LoadMask.Enabled := False;
end;

procedure TControleConsulta.UniFrameCreate(Sender: TObject);
Var
  Dia, Mes, Ano : Word;
begin
  CdsConsulta.Open;

  // Colocando a data no bottom
  DecodeDate(Now, Ano, Mes, Dia);
  UniLabelCorpright.Caption := 'Copyright © ' + InttoStr(Ano) + ' I9si Sistemas. Todos os direitos reservados.';
end;

procedure TControleConsulta.UniSweetExclusaoRegistroConfirm(Sender: TObject);
begin
  Apagar(CdsConsulta.FieldByName('id').AsInteger,
         FNomeTabela);
end;

function TControleConsulta.ExibeMostraCamposUniDbGridDescricao: String;
var
  I: Integer;
begin
  UniMemoCamposUniDBGridDescricao  := TUniMemo.Create(UniApplication);

  for I := 0 to GrdResultado.Columns.Count - 1  do
  begin
    if GrdResultado.Columns[I].Filtering.Enabled then
    begin
      UniMemoCamposUniDBGridDescricao.Lines.Add(GrdResultado.Columns[I].Title.Caption);
    end;
  end;

  Result := UniMemoCamposUniDBGridDescricao.Text;
end;

procedure TControleConsulta.Exportardadosexcel1Click(Sender: TObject);
begin
  // Abre o formulário em modal e aguarda
  self.ShowMask('Carregando');
  UniSession.Synchronize();
  GrdResultado.Exporter.Exporter := UniGridExcelExporter2;
  GrdResultado.Exporter.ExportGrid;
  self.HideMask;
end;

procedure TControleConsulta.Exportardadoshtml1Click(Sender: TObject);
begin
  // Abre o formulário em modal e aguarda
  self.ShowMask('Carregando');
  UniSession.Synchronize();
  GrdResultado.Exporter.Exporter := UniGridhtmlExporter1;
  GrdResultado.Exporter.ExportGrid;
  self.HideMask;
end;

function TControleConsulta.ExibeMostraCamposUniDbGridCampo: String;
var
  I: Integer;
begin
  UniMemoCamposUniDBGridCampo := TUniMemo.Create(UniApplication);

  for I := 0 to GrdResultado.Columns.Count - 1  do
  begin
    if GrdResultado.Columns[I].Filtering.Enabled then
    begin
      UniMemoCamposUniDBGridCampo.Lines.Add(' <'+ GrdResultado.Columns[I].FieldName + '> ');
    end;
  end;

  Result := UniMemoCamposUniDBGridCampo.Text;
end;



end.

