unit Controle.Consulta.Geracao.Documento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniPanel, uniLabel,
  uniPageControl, uniBasicGrid, uniDBGrid, Data.Win.ADODB, Datasnap.Provider,
  Data.DB, Datasnap.DBClient, uniEdit, uniButton, uniMemo,  frxClass,
  frxExportBaseDialog, frxExportPDF, frxDBSet,  uniHTMLMemo;

type
  TControleConsultaGeracaoDocumento = class(TUniForm)
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    UniPanel5: TUniPanel;
    UniPageControlCentral: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniPanel2: TUniPanel;
    GrdResultado: TUniDBGrid;
    DscConsulta: TDataSource;
    CdsConsulta: TClientDataSet;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaPOSSUI_ANEXO: TWideStringField;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaPOSSUI_ANEXO: TWideStringField;
    UniHiddenPanel1: TUniHiddenPanel;
    UniEdit1: TUniEdit;
    UniPanelTop: TUniPanel;
    BotaoConfirmar: TUniButton;
    BotaoSalvar: TUniButton;
    UniDBGrid1: TUniDBGrid;
    BotaoConfirmarModelo: TUniButton;
    CdsCampos: TClientDataSet;
    DscCampos: TDataSource;
    CdsCamposDESCRICAO: TStringField;
    CdsCamposCAMPO: TStringField;
    frxDBDataset: TfrxDBDataset;
    frxReport: TfrxReport;
    frxPDFExport: TfrxPDFExport;
    UniPanelPanelRight: TUniPanel;
    UniPanelTopRight: TUniPanel;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniMemo: TUniMemo;
    UniMemo1: TUniMemo;
    DscConsultaClone: TDataSource;
    CdsConsultaClone: TClientDataSet;
    DspConsultaClone: TDataSetProvider;
    QryConsultaClone: TADOQuery;
    UniMemoAlteraDocumento: TUniHTMLMemo;
    procedure GrdResultadoColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoConfirmarModeloClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure GrdResultadoDblClick(Sender: TObject);
    procedure UniDBGrid1CellClick(Column: TUniDBGridColumn);
  private
    procedure ExportarPDF(arquivoPDF: string; Report: TfrxReport);
    procedure ImprimirDocumento(URL: string);
    procedure LocalizarSubstituir(MemoSubstitui: TUniHTMLMemo;
                                                                Localizar,
                                                                Substituir: string);
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaGeracaoDocumento: TControleConsultaGeracaoDocumento;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes, frxRich,
  Controle.Server.Module, Controle.Impressao.Documento;

function ControleConsultaGeracaoDocumento: TControleConsultaGeracaoDocumento;
begin
  Result := TControleConsultaGeracaoDocumento(ControleMainModule.GetFormInstance(TControleConsultaGeracaoDocumento));
end;

procedure TControleConsultaGeracaoDocumento.BotaoSalvarClick(Sender: TObject);
begin
  UniPageControlCentral.ActivePageIndex := 0;
end;

procedure TControleConsultaGeracaoDocumento.GrdResultadoColumnFilter(
  Sender: TUniDBGrid; const Column: TUniDBGridColumn; const Value: Variant);
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

procedure TControleConsultaGeracaoDocumento.GrdResultadoDblClick(
  Sender: TObject);
begin
  BotaoConfirmarModelo.Click;
end;

procedure TControleConsultaGeracaoDocumento.BotaoConfirmarModeloClick(Sender: TObject);
begin
  UniPageControlCentral.ActivePageIndex := 1;
  ControleMainModule.modelo_id_m := CdsConsultaID.AsInteger;
//  Cdsconsulta.Refresh;
  ControleMainModule.CarregaListaDeArquivos(ControleMainModule.modelo_id_m,
                                            'MODELO');
end;

procedure TControleConsultaGeracaoDocumento.UniDBGrid1CellClick(
  Column: TUniDBGridColumn);
  var
    docOrigem, DocTemp, ArquivoPDF, textoPlanos: string;
    RTF: TfrxRichView;
begin
  if Column.FieldName = 'CAMINHO' then
  begin
    // Se for RTF ele converte para pdf e depois abre
    if ControleFuncoes.CopyReverse(ControleMainModule.CdsListaArquivosCAMINHO.AsString,1,3) = 'rtf' then
    begin
      ImprimirDocumento(ControleMainModule.CdsListaArquivosCAMINHO.AsString);
    end
    else
    begin
      ControleImpressaoDocumento.UniURLFrame1.URL := ControleMainModule.CdsListaArquivosCAMINHO.AsString;
      ControleImpressaoDocumento.ShowModal;
    end;
  end;
end;

procedure TControleConsultaGeracaoDocumento.UniFormCreate(Sender: TObject);
begin
  CdsConsulta.Open;
end;

procedure TControleConsultaGeracaoDocumento.UniFormShow(Sender: TObject);
begin
  UniPageControlCentral.ActivePageIndex := 0;
end;

procedure TControleConsultaGeracaoDocumento.ExportarPDF(arquivoPDF: string; Report: TfrxReport);
var
  assinatura, logo: string;
  imgLogo, imgAssinatura: TfrxPictureView;
  textoassinatura: TfrxMemoView;
  thr: TThread;
begin
  try
    Report.PrintOptions.ShowDialog := False;
    Report.ShowProgress := false;

    Report.EngineOptions.SilentMode := True;
    Report.EngineOptions.EnableThreadSafe := True;
    Report.EngineOptions.DestroyForms := False;
    Report.EngineOptions.UseGlobalDataSetList := False;

    frxPDFExport.Background := True;
    frxPDFExport.ShowProgress := False;
    frxPDFExport.ShowDialog := False;
    frxPDFExport.FileName := ControleServerModule.NewCacheFileUrl(False, 'pdf', '', '', arquivoPDF, True);
    frxPDFExport.DefaultPath := '';

    thr := TThread.CurrentThread;
    Report.EngineOptions.ReportThread := thr;
    Report.PreviewOptions.AllowEdit := False;
    Report.PrepareReport;
    Report.Export(frxPDFExport);

    if FileExists(frxPDFExport.FileName) then
    begin
      ControleImpressaoDocumento.UniURLFrame1.URL := arquivoPDF;
      ControleImpressaoDocumento.ShowModal;
    end
    else
      ControleMainModule.MensageiroSweetAlerta('Atenção','Falha ao gerar PDF, tente novamente!');
  except
    raise Exception.Create('Não foi possível concluir a operação, entre em contato com o suporte.');
  end;
end;

procedure TControleConsultaGeracaoDocumento.ImprimirDocumento(URL: string);
var
  docOrigem, DocTemp, ArquivoPDF, textoPlanos: string;
  RTF: TfrxRichView;
  i: integer;
  CaminhoArquivo, NomeArquivo: string;
  teste1, teste2: string;
begin
  CaminhoArquivo := ExtractFileDir(URL);
  NomeArquivo    := ExtractFileName(URL);

  //Pegando o documento original para fazer alterações
  docOrigem := URL;

  //Criando um novo arquivo para receber um cópia do documento original
  DocTemp := CaminhoArquivo + '\' + FormatDateTime('ddmmyyyyhhmmssmm', Now) + '_' + NomeArquivo;

  //Verificando se o documento foi copiado
  if not CopyFile(pchar(docOrigem), pchar(DocTemp), false) then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção',SysErrorMessage(GetLastError()));
    Exit;
  end;
   // utilizar o exemplo do unigui apra fazer download
   // verificar se é necessario fazer uma copia do arquivo, porque nao carregar o arquivo original na hora de gerar?
  try
    //Abrindo um editor para fazer a substituição das tags
    //Obs.: Essa alteração é invisível ao usuário
    UniMemoAlteraDocumento.Lines.LoadFromFile(DocTemp);

    // Verificando varrendo todos os campos para substituir no documento
    for i := 0 to UniMemo1.Lines.Count - 1 do
    begin
      //dados do contrato
      LocalizarSubstituir(UniMemoAlteraDocumento,
                          UniMemo1.Lines.Strings[i],
                          CdsConsultaClone.FieldByName(Trim(ControleFuncoes.RemoveMascaraMaiorQ_MenorQ(UniMemo1.Lines.Strings[i]))).AsString);
    end;

    // Salva em arquivo texto as mudanças
    if FileExists(DocTemp) then
      DeleteFile(DocTemp);

    UniMemoAlteraDocumento.Lines.SaveToFile(DocTemp);

    // Carrega o arquivo salvo com as mudancas dentro do fastreport
   { RTF := TfrxRichView(frxReport.FindObject('Rich1'));
    if RTF <> nil then
    begin
      RTF.RichEdit.Lines.Clear;
      RTF.RichEdit.Lines.LoadFromFile(DocTemp);
    end;

    DeleteFile(DocTemp);}
  except
    raise Exception.Create('Não foi possível concluir a operação, entre em contato com o suporte.');
  end;
//  ArquivoPDF := FormatDateTime('ddmmyyyyhhmmssmm', Now) + '_' + 'tmp';

  // Filtrando apenas o registro escolhido
  With ControleMainModule do
  begin
    CdsListaArquivos.Filtered := False;
    CdsListaArquivos.Filter   := 'id = ' + QuotedStr(ControleMainModule.CdsListaArquivos.FieldByName('id').AsString);
    CdsListaArquivos.Filtered := True;
  end;

  //Método de exportação para PDF
//  ExportarPDF(ArquivoPDF, frxReport);

  ControleImpressaoDocumento.UniURLFrame1.URL := DocTemp;
  ControleImpressaoDocumento.ShowModal;

  // Retirando o filtro aplicado anteriormente
  ControleMainModule.CdsListaArquivos.Filtered := False;
end;

procedure TControleConsultaGeracaoDocumento.LocalizarSubstituir(MemoSubstitui: TUniHTMLMemo;
                                                                Localizar,
                                                                Substituir: string);
var
  X: integer;
begin
  X := 0;
  X := Pos(Localizar, MemoSubstitui.Text); //FindText(Localizar, X, ToEnd, []) ;
  while X <> 0 do
  begin
    MemoSubstitui.SetFocus;
    MemoSubstitui.Text := StringReplace(MemoSubstitui.Text,
                                        Localizar,
                                        Substituir, [rfreplaceall]);
    X := Pos(Localizar,
             MemoSubstitui.Text);
  end;
end;

end.
