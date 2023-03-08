unit form_cadastro_produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  ppDB, ppComm, ppRelatv, ppDBPipe, RxLookup, RxDBComb, wwdbdatetimepicker,
  wwdbedit, Grids, Wwdbigrd, Wwdbgrid, ExtDlgs, Wwdotdot, Wwdbcomb, wwdblook,
  DBCGrids, LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit,
  ComCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGrid, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxGridDBTableView, OleCtrls, SHDocVw, MSHTML, ActiveX,
  Jpeg;

type
  TUrl = record
     Acao: string;
     Rotina: string;
     Chave: string;
  end;
  Tcadastro_produto = class(TForm)
    lblCodigo: TLabel;
    Label30: TLabel;
    edtCodigo: TDBEdit;
    Panel2: TPanel;
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsProduto: TDataSource;
    qryProduto: TIBQuery;
    udpProduto: TIBUpdateSQL;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    lblNome: TLabel;
    edtNome: TDBEdit;
    Label20: TLabel;
    Label27: TLabel;
    Panel3: TPanel;
    cbcidade: TRxDBLookupCombo;
    dtsPerfil: TDataSource;
    qryPerfil: TIBQuery;
    Label28: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Panel4: TPanel;
    DBEdit18: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit22: TDBEdit;
    SpeedButton7: TSpeedButton;
    dtsProdutoPreferencias: TDataSource;
    qryProdutoPreferencias: TIBQuery;
    qryProdutoPreferenciasDESCRICAO: TIBStringField;
    Label2: TLabel;
    DBMemo1: TDBMemo;
    qryProdutoCODIGO: TIntegerField;
    qryProdutoDATA: TDateField;
    qryProdutoDESCRICAO: TIBStringField;
    qryProdutoCODIGOUSUARIO: TIntegerField;
    qryProdutoDETALHE: TIBStringField;
    qryProdutoORIGEM: TIBStringField;
    qryProdutoIDPERFIL: TIntegerField;
    qryProdutoDATAAQUISICAO: TDateField;
    qryProdutoVALOR1: TIBBCDField;
    qryProdutoVALOR2: TIBBCDField;
    qryProdutoVALOR3: TIBBCDField;
    qryProdutoVALOR4: TIBBCDField;
    qryProdutoVALORALUGUEL1: TIBBCDField;
    qryProdutoVALORALUGUEL2: TIBBCDField;
    qryProdutoVALORALUGUEL3: TIBBCDField;
    qryProdutoVALORALUGUEL4: TIBBCDField;
    Label3: TLabel;
    cmbOrigem: TwwDBComboBox;
    Label4: TLabel;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label9: TLabel;
    Panel1: TPanel;
    qryPerfilCODIGO: TIntegerField;
    qryPerfilNOME: TIBStringField;
    qryProdutoFoto: TIBQuery;
    dtsProdutoFoto: TDataSource;
    udpProdutoFoto: TIBUpdateSQL;
    qryProdutoFotoCODIGOPRODUTO: TIntegerField;
    qryProdutoFotoID: TIntegerField;
    qryProdutoFotoCODIGOTIPOFOTO: TIntegerField;
    qryProdutoFotoURLFOTO: TMemoField;
    dtsTipoFoto: TDataSource;
    qryTipoFoto: TIBQuery;
    IntegerField1: TIntegerField;
    qryTipoFotoDESCRICAO: TIBStringField;
    Panel7: TPanel;
    qryProdutoFotoDESCRICAO: TIBStringField;
    Label12: TLabel;
    DBEdit5: TDBEdit;
    Label13: TLabel;
    DBEdit6: TDBEdit;
    Label14: TLabel;
    DBEdit7: TDBEdit;
    qryProdutoVERSAO: TIntegerField;
    qryProdutoVIDAUTIL: TIntegerField;
    qryProdutoPORCENTAGEM_TERCEIRO: TIBBCDField;
    Label15: TLabel;
    DBEdit8: TDBEdit;
    qryProdutoCOMPLEMENTO: TMemoField;
    dtsUsuario: TDataSource;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    qryProdutoNomeUsuario: TStringField;
    DBEdit9: TDBEdit;
    Label16: TLabel;
    DBMemo2: TDBMemo;
    qryProdutoRESUMOPREFERENCIAS: TStringField;
    Label45: TLabel;
    qryProdutoCODIGOSITUACAO: TIntegerField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label10: TLabel;
    SpeedButton9: TSpeedButton;
    Label11: TLabel;
    btnInserirPreferencias: TSpeedButton;
    btnPeca: TSpeedButton;
    btnModelo: TSpeedButton;
    btnEstilo: TSpeedButton;
    btnMarca: TSpeedButton;
    btnCor: TSpeedButton;
    btnComplemento: TSpeedButton;
    SpeedButton13: TSpeedButton;
    memComplemento: TDBMemo;
    wwDBGrid1: TwwDBGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    lbPreferncias: TListBox;
    dtsProdutoManequim: TDataSource;
    qryProdutoManequim: TIBQuery;
    qryProdutoManequimDESCRICAO: TIBStringField;
    qryProdutoManequimVALORINICIAL: TIBBCDField;
    qryProdutoManequimVALORFINAL: TIBBCDField;
    TabSheet2: TTabSheet;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    wwDBComboBox1: TwwDBComboBox;
    dtsHistorico: TDataSource;
    qryHistorico: TIBQuery;
    qryProdutoREFERENCIA: TIBStringField;
    DBEdit10: TDBEdit;
    Label17: TLabel;
    qryHistoricoDATAINICIO: TDateField;
    qryHistoricoDATAFIM: TDateField;
    qryHistoricoDATAHORAINICIO: TDateTimeField;
    qryHistoricoDATAHORAFINAL: TDateTimeField;
    qryHistoricoTIPO: TIntegerField;
    qryHistoricoNOMETIPO: TIBStringField;
    qryHistoricoCODIGOCLIENTE: TIntegerField;
    qryHistoricoNOMECLIENTE: TIBStringField;
    qryHistoricoCODIGOPRODUTO: TIntegerField;
    qryHistoricoNOMEPRODUTO: TIBStringField;
    qryHistoricoCODIGOREGISTRO: TIntegerField;
    qryHistoricoOBSERVACOES: TMemoField;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelDBTableView1CODIGOREGISTRO: TcxGridDBColumn;
    grdPainelDBTableView1NOMETIPO: TcxGridDBColumn;
    grdPainelDBTableView1DATAHORAINICIO: TcxGridDBColumn;
    grdPainelDBTableView1DATAHORAFINAL: TcxGridDBColumn;
    grdPainelDBTableView1NOMECLIENTE: TcxGridDBColumn;
    grdPainelDBTableView1OBSERVACOES: TcxGridDBColumn;
    grdPainelLevel1: TcxGridLevel;
    wbListagem: TWebBrowser;
    Panel8: TPanel;
    btnInserirFoto: TSpeedButton;
    TabSheet3: TTabSheet;
    dtsLocal: TDataSource;
    qryLocal: TIBQuery;
    IntegerField2: TIntegerField;
    qryLocalDESCRICAO: TIBStringField;
    Label18: TLabel;
    RxDBLookupCombo1: TRxDBLookupCombo;
    qryProdutoCODIGOLOCALIZACAO: TIntegerField;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryProdutoBeforeDelete(DataSet: TDataSet);
    procedure qryProdutoBeforePost(DataSet: TDataSet);
    procedure qryProdutoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsProdutoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInserirFotoClick(Sender: TObject);
    procedure qryProdutoPreferenciasAfterOpen(DataSet: TDataSet);
    procedure SpeedButton11Click(Sender: TObject);
    procedure qryProdutoAfterScroll(DataSet: TDataSet);
    procedure btnPecaClick(Sender: TObject);
    procedure btnInserirPreferenciasClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure qryProdutoFotoNewRecord(DataSet: TDataSet);
    procedure qryProdutoFotoBeforePost(DataSet: TDataSet);
    procedure SpeedButton9Click(Sender: TObject);
    procedure qryProdutoFotoAfterPost(DataSet: TDataSet);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure qryProdutoFotoAfterDelete(DataSet: TDataSet);
    procedure qryPerfilBeforeOpen(DataSet: TDataSet);
    procedure cmbOrigemChange(Sender: TObject);
    procedure qryProdutoCalcFields(DataSet: TDataSet);
    procedure qryProdutoAfterPost(DataSet: TDataSet);
    procedure SpeedButton13Click(Sender: TObject);
    procedure btnBloqueadoClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure qryProdutoDeleteError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure wbListagemBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    iBaseFoto: integer;
    vUrlFoto: String;
    vPercCompress: Integer;
    function CriaTextoHTMLFotos():string;
    function ProcessaURL(url:String):TUrl;
    Procedure ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
    procedure AbrirFoto(iID: Integer);
    procedure CarregarFotos();
    procedure SetJPGCompression(ACompression : integer; const AInFile : string;
                            const AOutFile : string);
    function GetCodigo(lCodigo, lAndamento: Integer): Integer;
    { Private declarations }
  public
    cOldSituacao : String;
    { Public declarations }
    procedure VerificaProdutoBloqueado;
  end;

var
  cadastro_produto: Tcadastro_produto;

implementation

uses untPesquisa, untDados, form_cadastro_perfil,
  form_inserir_preferencias, form_inserir_manequim, form_carregar_Foto,
  form_inserir_avaliacao, form_valor_universal, form_cadastro_situacao_produto,
  untConsultaProdutos, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcadastro_produto.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcadastro_produto.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure Tcadastro_produto.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tcadastro_produto.CarregarFotos();
var
  vHtml : String;
begin

  vHTML := CriaTextoHTMLFotos();
  ExibirCodigoHTML(wbListagem, vHTML);

end;

procedure Tcadastro_produto.AbrirFoto(iID: Integer);
var
  xID: Integer;
begin
  if qryProduto.State in [dsInsert, dsEdit] then
  begin
    application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                           'Antes de Definir Fotos Grave o Registro!','ALTERAR FOTO',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  if not qryProdutoFoto.Locate('ID',iID,[]) then
  begin
    application.MessageBox('Foto ainda não foi definida!'#13+
                           'Para Inserir Nova Foto Clique no Botão "Adcionar Foto".','EDITAR FOTO',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('carregar_Foto') = Nil then
    Application.CreateForm(Tcarregar_Foto, carregar_Foto);

  carregar_Foto._UrlFoto := qryProdutoFotoURLFOTO.AsString;
  carregar_Foto._TipoFoto := qryProdutoFotoCODIGOTIPOFOTO.AsInteger;
  carregar_Foto._CodigoProduto := qryProdutoCODIGO.AsInteger;

  carregar_Foto.ShowModal;

  if carregar_Foto._Operacao = toGravar then
  begin
    qryProdutoFoto.Edit;
    qryProdutoFotoCODIGOTIPOFOTO.AsInteger := carregar_Foto._TipoFoto;
    qryProdutoFotoURLFOTO.AsString := carregar_Foto._UrlFoto;
    qryProdutoFoto.Post;

    qryProduto.Edit;
    qryProduto.Post;

    CarregarFotos();
  end
  else if carregar_Foto._Operacao = toExcluir then
  begin
    qryProdutoFoto.Delete;

    dados.Geral.SQL.Text := 'update TABPRODUTOFOTOS f set f.ID = f.ID - 1 where f.CODIGOPRODUTO = '+qryProdutoCODIGO.Text+' and f.ID > '+IntToStr(xID);
    dados.Geral.ExecSql;
    dados.Geral.Transaction.CommitRetaining;

    qryProduto.Edit;
    qryProduto.Post;

    CarregarFotos();
  end;
end;

procedure Tcadastro_produto.PageControl1Change(Sender: TObject);
begin
  qryHistorico.Close;
  qryHistorico.Open;
end;

procedure Tcadastro_produto.dtsProdutoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure Tcadastro_produto.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryProduto.State in [dsInsert, dsEdit] then
       qryProduto.Post;
  end;
end;

procedure Tcadastro_produto.btn_novoClick(Sender: TObject);
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
       qryProduto.Post;
  end;
  qryProduto.Insert;
end;

procedure Tcadastro_produto.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsProduto, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryProduto.Delete;
end;

procedure Tcadastro_produto.btn_pesquisarClick(Sender: TObject);
var
  lFrmConsultaProduto: TfrmConsultaProdutos;
begin
  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try

    lFrmConsultaProduto._porCadastro := True;

    lFrmConsultaProduto.ShowModal;

    if lFrmConsultaProduto.CodigoSelecionado <> 0 then
      begin
      qryProduto.Close;
      qryProduto.ParamByName('Codigo').AsInteger := lFrmConsultaProduto.CodigoSelecionado;
      qryProduto.Open;
      end;

    dados.Log(2, 'Código: '+ qryProdutoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;

end;

procedure Tcadastro_produto.qryPerfilBeforeOpen(DataSet: TDataSet);
begin

  case cmbOrigem.ItemIndex of
    0 : qryPerfil.SQL.Strings[qryPerfil.sql.IndexOf('--WHERE') + 1 ] := 'where codigotipoperfil in (Select codigo from tabtipoperfil where tipo = 2)';
    1 : qryPerfil.SQL.Strings[qryPerfil.sql.IndexOf('--WHERE') + 1 ] := 'where codigotipoperfil in (Select codigo from tabtipoperfil where tipo = 3)';
    2 : qryPerfil.SQL.Strings[qryPerfil.sql.IndexOf('--WHERE') + 1 ] := 'where codigotipoperfil in (Select codigo from tabtipoperfil where tipo = 4)';
  end;
  
end;

procedure Tcadastro_produto.qryProdutoAfterPost(DataSet: TDataSet);
begin
//  VerificaProdutoBloqueado;
end;

procedure Tcadastro_produto.qryProdutoAfterScroll(DataSet: TDataSet);
begin
//  if FileExists(qryProdutoURLFOTO.Text) then
//    Image1.Picture.LoadFromFile(qryProdutoURLFOTO.Text)
//  else
//    Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');

//  if not cNaoExecutarScrool then
//  begin

    cmbOrigemChange(cmbOrigem);

    qryProdutoManequim.Close;
    qryProdutoManequim.Open;

    qryHistorico.Close;
    qryHistorico.Open;

    btnPeca.Down := True;
    btnPecaClick(btnPeca);

    iBaseFoto := 1;
    CarregarFotos();

//  end;

//  VerificaProdutoBloqueado;

end;

procedure Tcadastro_produto.qryProdutoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryProdutoCODIGO.Text + ' Nome: '+qryProdutoManequimDESCRICAO.Text+' Janela: '+copy(Caption,17,length(Caption)));

end;

procedure Tcadastro_produto.qryProdutoBeforePost(DataSet: TDataSet);
begin

  if qryProdutoFoto.State in [dsInsert, dsEdit] then
  begin
    if (qryProdutoFotoCODIGOTIPOFOTO.Text = '') and (qryProdutoFotoURLFOTO.Text = '') then
      qryProdutoFoto.Cancel
    else
      qryProdutoFoto.Post;
  end;

  IF qryProdutoCODIGO.Value = 0 THEN
    qryProdutoCODIGO.Value := Dados.NovoCodigo('TABPRODUTOS');

  if dtsProduto.State = dsInsert then
    dados.Log(3, 'Código: '+ qryProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsProduto.State = dsEdit then
    dados.Log(4, 'Código: '+ qryProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)));

  qryProdutoCODIGOUSUARIO.AsInteger := untDados.CodigoUsuarioCorrente;
  qryProdutoVERSAO.AsInteger := qryProdutoVERSAO.AsInteger + 1;

  if Trim(qryProdutoREFERENCIA.Text) = '' then
  begin

    dados.Geral.Close;
    dados.Geral.sql.Text := ' SELECT P.CODIGOAUX '+
                            '  FROM TABPREFERENCIASPRODUTO PP '+
                            '  INNER JOIN tabpreferencias P ON PP.codigopreferencia = P.codigo '+
                            '  WHERE PP.codigoproduto =0'+qryProdutoCODIGO.Text +
                            '    AND P.TIPO = 1 ';
    dados.Geral.Open;

    if dados.Geral.FieldByName('CODIGOAUX').Text <> '' then
      qryProdutoREFERENCIA.Text := dados.Geral.FieldByName('CODIGOAUX').Text+'.'+qryProdutoCODIGO.Text;

  end;
end;

procedure Tcadastro_produto.qryProdutoCalcFields(DataSet: TDataSet);
var
  ResumoPrefencias : String;
begin

  ResumoPrefencias := '';

  dados.Geral.Close;
  dados.Geral.sql.Text := ' SELECT '+
                          '  CASE P.TIPO '+
                          '    WHEN 1 THEN ''Peça'' '+
                          '    WHEN 2 THEN ''Acessórios'' '+
                          '    WHEN 3 THEN ''Marca'' '+
                          '    WHEN 4 THEN ''Estilo'' '+
                          '    WHEN 5 THEN ''Cor'' '+
                          '    WHEN 6 THEN ''Exigência'' '+
                          '   END AS TIPO, LIST(P.descricao,'','') AS DESCRICAO '+
                          '  FROM TABPREFERENCIASPRODUTO PP '+
                          '  INNER JOIN tabpreferencias P ON PP.codigopreferencia = P.codigo '+
                          '  WHERE PP.codigoproduto =0'+qryProdutoCODIGO.Text +
                          '  GROUP BY 1 ';
  dados.Geral.Open;

  While not dados.Geral.Eof do
  begin

    if ResumoPrefencias = '' then
      ResumoPrefencias := Trim(dados.Geral.FieldByName('TIPO').AsString) +': '+Trim(dados.Geral.FieldByName('DESCRICAO').AsString)
    else
      ResumoPrefencias := ResumoPrefencias +' - '+ Trim(dados.Geral.FieldByName('TIPO').AsString) +': '+Trim(dados.Geral.FieldByName('DESCRICAO').AsString);

    dados.Geral.Next;
  end;


  dados.Geral.Close;
  dados.Geral.sql.Text := ' SELECT VALORINICIAL '+
                          '   FROM TABPRODUTOMANEQUIM o '+
                          '  WHERE o.codigoproduto =0'+qryProdutoCODIGO.Text;
  dados.Geral.Open;

  ResumoPrefencias := ResumoPrefencias + ' - '+ ' Tamanho: '+dados.Geral.FieldByName('VALORINICIAL').Text;

  qryProdutoRESUMOPREFERENCIAS.Text := ResumoPrefencias;

end;

procedure Tcadastro_produto.qryProdutoDeleteError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  if pos('FOREIGN', e.Message) > 0 then
  begin
    application.MessageBox(Pchar('Nao é possivel excluir o cadastro!'+#13+
                                 'Existem registros vinculados.'),'',mb_OK+MB_ICONWARNING);
    Action:= daAbort;
  end;
end;

procedure Tcadastro_produto.qryProdutoFotoAfterDelete(DataSet: TDataSet);
begin
  qryProdutoFoto.Transaction.CommitRetaining;
end;

procedure Tcadastro_produto.qryProdutoFotoAfterPost(DataSet: TDataSet);
begin
  qryProdutoFoto.Transaction.CommitRetaining;
end;

procedure Tcadastro_produto.qryProdutoFotoBeforePost(DataSet: TDataSet);
begin

  IF (qryProdutoFotoID.Value = 0) THEN
    qryProdutoFotoID.Value := Dados.NovoCodigo('TABPRODUTOFOTOS', 'ID', ' CODIGOPRODUTO = '+qryProdutoCODIGO.Text);

  if dtsProduto.State = dsInsert then
    dados.Log(3, 'Foto: '+qryProdutoFotoID.Text+' em Código: '+ qryProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsProduto.State = dsEdit then
    dados.Log(4, 'Foto: '+qryProdutoFotoID.Text+' em Código: '+ qryProdutoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure Tcadastro_produto.qryProdutoFotoNewRecord(DataSet: TDataSet);
begin
  qryProdutoFotoCODIGOPRODUTO.AsInteger := qryProdutoCODIGO.AsInteger;
  qryProdutoFotoID.AsInteger := 0;
end;

procedure Tcadastro_produto.qryProdutoNewRecord(DataSet: TDataSet);
begin
  qryProdutoCODIGO.Value := 0;
  qryProdutoDATA.AsDateTime := Date;
  qryProdutoORIGEM.Text := 'C';
  qryProdutoCODIGOSITUACAO.AsInteger := 1;

  iBaseFoto := 1;
  CarregarFotos();
end;

procedure Tcadastro_produto.qryProdutoPreferenciasAfterOpen(DataSet: TDataSet);
begin
  lbPreferncias.Clear;
  qryProdutoPreferencias.First;
  while not qryProdutoPreferencias.Eof do
  begin
    lbPreferncias.Items.Add(qryProdutoPreferenciasDESCRICAO.Text);
    qryProdutoPreferencias.Next;
  end;
end;

procedure Tcadastro_produto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryProduto.Post;
  end;
  qryProduto.Close;

  qryPerfil.Close;
end;

procedure Tcadastro_produto.FormCreate(Sender: TObject);
begin
  NomeMenu := 'Produto';
end;

procedure Tcadastro_produto.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try

    vUrlFoto := Dados.ValidaURL(tuProduto);
    vPercCompress := Dados.ValorConfig('principal','PERC_COMPRESS_FOTO',50,tcInteiro).vcInteger;

    wbListagem.Navigate('about:blank');

    qryPerfil.Open;
    qryUsuario.Open;
    qryTipoFoto.Open;
    qrySituacao.Close;
    qrySituacao.Open;
    qryLocal.Open;

    qryProduto.Close;
    qryProduto.ParamByName('Codigo').AsInteger := 0;
    qryProduto.Open;

    cOldSituacao := '';

    Dados.NovoRegistro(qryProduto);
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tcadastro_produto.SpeedButton5Click(Sender: TObject);
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryProduto.Post;
  end;

  qryProduto.Close;
  qryProduto.ParamByName('Codigo').AsInteger := GetCodigo(0,1);
  qryProduto.Open;
end;

function Tcadastro_produto.GetCodigo(lCodigo, lAndamento: Integer): Integer;
var
  lSql : String;
begin

  if lAndamento = 1 then //Primeiro
     lSql := 'Select codigo from TABPRODUTOS order by codigo rows 1'
  else if lAndamento = 2 then //Anterior
     lSql := 'Select codigo from TABPRODUTOS where codigo < '+IntToStr(lCodigo)+' order by codigo desc rows 1'
  else if lAndamento = 3 then //Proximo
     lSql := 'Select codigo from TABPRODUTOS where codigo > '+IntToStr(lCodigo)+' order by codigo rows 1'
  else if lAndamento = 4 then //Ultimo
     lSql := 'Select codigo from TABPRODUTOS order by codigo desc rows 1';

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := lSql;
  Dados.Geral.Open;

  Result := Dados.Geral.FieldByName('codigo').AsInteger;

  Dados.Geral.Close;

end;

procedure Tcadastro_produto.SpeedButton6Click(Sender: TObject);
begin
  if iBaseFoto > 1 then
  begin
    iBaseFoto := iBaseFoto - 4;
    CarregarFotos();
  end;
end;

procedure Tcadastro_produto.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.ShowModal;

  qryPerfil.Close;
  qryPerfil.Open;
end;

procedure Tcadastro_produto.SpeedButton9Click(Sender: TObject);
begin
  If Application.FindComponent('inserir_manequim') = Nil then
    Application.CreateForm(Tinserir_manequim, inserir_manequim);

  inserir_manequim._Finalidade := tfmProduto;

  inserir_manequim._codigo := qryProdutoCODIGO.AsInteger;

  inserir_manequim.ShowModal;

  qryProduto.Edit;
  qryProduto.Post;

  qryProdutoManequim.Close;
  qryProdutoManequim.Open;

end;

procedure Tcadastro_produto.VerificaProdutoBloqueado;
begin
{  if qryProdutoCODIGOSITUACAO.Text <> '' then
  begin
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select OPERACAO from TABSITUACAOPRODUTO where CODIGO = ' + qryProdutoCODIGOSITUACAO.Text;
    dados.Geral.Open;

    btnBloqueado.Visible := dados.Geral.FieldByName('OPERACAO').AsInteger = 1

  end
  else
    btnBloqueado.Visible := False;        }

end;

procedure Tcadastro_produto.wbListagemBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
   lUrl : TUrl;
begin
   lUrl := ProcessaURL(URL);

   if (lUrl.Acao = '') and (lUrl.Rotina = '') then
      Exit;

   if lUrl.Acao = 'ACAO' then
   begin
     Try
       if lUrl.Rotina = 'SELECIONAR' then
         AbrirFoto(StrToIntDef(lUrl.Chave,0));
     finally
       Cancel := True;
     end;
     end;


end;

procedure Tcadastro_produto.SpeedButton2Click(Sender: TObject);
var
  lCodigo : Integer;
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryProduto.Post;
  end;

  lCodigo := GetCodigo(qryProdutoCODIGO.AsInteger,2);

  qryProduto.Close;
  qryProduto.ParamByName('Codigo').AsInteger := lCodigo;
  qryProduto.Open;
end;

procedure Tcadastro_produto.SpeedButton3Click(Sender: TObject);
begin
  iBaseFoto := iBaseFoto + 4;
  CarregarFotos();
end;

procedure Tcadastro_produto.btnBloqueadoClick(Sender: TObject);
begin
  If Application.FindComponent('cadastro_situacao_produto') = Nil then
         Application.CreateForm(Tcadastro_situacao_produto, cadastro_situacao_produto);

  cadastro_situacao_produto.Show;

  qrySituacao.Close;
  qrySituacao.Open;
end;

procedure Tcadastro_produto.SetJPGCompression(ACompression : integer; const AInFile : string;
                            const AOutFile : string);
var iCompression : integer;
    oJPG : TJPegImage;
    oBMP : TBitMap;
begin
  // Force Compression to range 1..100
  iCompression := abs(ACompression);
  if iCompression = 0 then iCompression := 1;
  if iCompression > 100 then iCompression := 100;

  // Create Jpeg and Bmp work classes
  oJPG := TJPegImage.Create;
  oJPG.LoadFromFile(AInFile);
  oBMP := TBitMap.Create;
  oBMP.Assign(oJPG);

  // Do the Compression and Save New File
  oJPG.CompressionQuality := iCompression;
  oJPG.Compress;
  oJPG.SaveToFile(AOutFile);

  // Clean Up
  oJPG.Free;
  oBMP.Free;
end;

procedure Tcadastro_produto.btnInserirFotoClick(Sender: TObject);
var
  xNewUrl: String;
  Jpg: TJpegImage;
begin
  if qryProduto.State in [dsInsert, dsEdit] then
  begin
    application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                           'Antes de Definir Fotos Grave o Registro!','INSERIR FOTO',MB_OK+MB_ICONEXCLAMATION);
    Abort;
  end;

  If Application.FindComponent('carregar_Foto') = Nil then
    Application.CreateForm(Tcarregar_Foto, carregar_Foto);

  carregar_Foto._UrlFoto := '';
  carregar_Foto._TipoFoto := 0;
  carregar_Foto._CodigoProduto := qryProdutoCODIGO.AsInteger;
  
  carregar_Foto.cmbTipoFoto.Text := '';
  carregar_Foto.edtUrlFoto.Text := '';

  carregar_Foto.ShowModal;

  if carregar_Foto._Operacao = toGravar then
  begin
    xNewUrl := 'AMV_'+qryProdutoCODIGO.Text+'_'+FormatDateTime('ddMMyyyyhhmmss', now)+'.jpg';

    try
      SetJPGCompression(vPercCompress,carregar_Foto._UrlFoto,vUrlFoto+xNewUrl);
    Except
      Application.MessageBox(Pchar('Falha ao Copiar Foto "'+carregar_Foto._UrlFoto+'" para "'+vUrlFoto+xNewUrl+'"!'),'Falha',MB_OK+MB_ICONERROR);
      Abort;
    end;

    qryProdutoFoto.Insert;
    qryProdutoFotoCODIGOTIPOFOTO.AsInteger := carregar_Foto._TipoFoto;
    qryProdutoFotoURLFOTO.AsString := xNewUrl;
    qryProdutoFoto.Post;

    qryProduto.Edit;
    qryProduto.Post;

    CarregarFotos();
  end;

end;

function Tcadastro_produto.CriaTextoHTMLFotos():string;
const Espaco='&nbsp;';
var lURLFoto: String;
begin
   try

      qryProdutoFoto.Close;
      qryProdutoFoto.Open;

      Result :=   '<html><body>'+
                  '<b> '+
                  '<table style="font-family: arial, verdana; font-size: 12px;'+
                  'font-weight: bold; color: #801919;">'#13#10;

      qryProdutoFoto.First;
      while not qryProdutoFoto.Eof do
         begin

         if qryProdutoFotoURLFOTO.AsString = '' then
           lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png'
         else
           if FileExists(vUrlFoto+qryProdutoFotoURLFOTO.AsString) then
              lURLFoto := vUrlFoto+qryProdutoFotoURLFOTO.AsString
           else
              lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png';

         if not qryProdutoFoto.Bof then
           Result := Result+
              '<tr BGCOLOR="#CCFFFF" valign="top"><td HEIGHT="10"></td></tr>';

         Result := Result+
            '<tr BGCOLOR="#D2D2D2" valign="top">'+
            '<td BGCOLOR="#D2D2D2" ALIGN="center"><a href="acao:selecionar?'+qryProdutoFotoID.Text+'">'+qryProdutoFotoDESCRICAO.Text+'</a></td></tr>'+
            '<tr BGCOLOR="#FFFF99" valign="top">'+
            '<td BGCOLOR="#FFFF99" ALIGN="center"><img src="'+lURLFoto+'" height="250" width="250"></td></tr>'#13#10;

         qryProdutoFoto.Next;
         end;

      Result := Result+'</table></body></html>';
   except
      on e: exception do
         ShowMessage('Error 55224:'+E.Message);
   end;
end;

function Tcadastro_produto.ProcessaURL(url:String):TUrl;
var
   lUrl: string;
begin
   lUrl := UpperCase(url);
   result.Acao   := Copy(lUrl,1,Pos(':',url) - 1);
   lUrl := Copy(lUrl,Pos(':',lUrl) + 1 ,Length(lUrl));
   result.Rotina := Copy(lUrl,1 ,Pos('?',lUrl) - 1);
   lUrl := Copy(lUrl,Pos('?',lUrl) + 1 ,Length(lUrl));
   result.Chave  := lUrl;
end;

Procedure Tcadastro_produto.ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
var
   V            : Variant;
   HTMLDocument : IHTMLDocument2;
begin
   try
      // Carrega Safe Array
      HTMLDocument := iWeb.Document as IHTMLDocument2;
      V            := VarArrayCreate([0,0], varVariant);
      V[0]         := i_Codigo;

      // Escreve código HTML no documento do Browser
      try
         HTMLDocument.Write(PSafeArray(TVarData(V).VArray));
         HTMLDocument.Close();
      except
         raise Exception.Create('Não foi exibido as implementações no sistema, verifique a versão do "internet explorer"');
      end;

   except
      On E: Exception do
        ShowMessage('Error 62504:'+E.Message);
   end;
end;


procedure Tcadastro_produto.cmbOrigemChange(Sender: TObject);
begin
  qryPerfil.close;
  qryPerfil.Open;

  Label14.Enabled := cmbOrigem.ItemIndex = 1;
  DBEdit7.Enabled := cmbOrigem.ItemIndex = 1;
end;

procedure Tcadastro_produto.SpeedButton4Click(Sender: TObject);
var
  lCodigo : Integer;
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryProduto.Post;
  end;

  lCodigo := GetCodigo(qryProdutoCODIGO.AsInteger,3);

  qryProduto.Close;
  qryProduto.ParamByName('Codigo').AsInteger := lCodigo;
  qryProduto.Open;
end;

procedure Tcadastro_produto.btnInserirPreferenciasClick(Sender: TObject);
begin
  If Application.FindComponent('inserir_preferencias') = Nil then
    Application.CreateForm(Tinserir_preferencias, inserir_preferencias);

  inserir_preferencias._Finalidade := tfpProduto;

  if btnPeca.Down then
    inserir_preferencias._Tipo := 1
  else if btnModelo.Down then
    inserir_preferencias._Tipo := 2
  else if btnMarca.Down then
    inserir_preferencias._Tipo := 3
  else if btnEstilo.Down then
    inserir_preferencias._Tipo := 4
  else if btnCor.Down then
    inserir_preferencias._Tipo := 5
//  else if btnExigencia.Down then
//    inserir_preferencias._Tipo := 6
  else if btnComplemento.Down then
    inserir_preferencias._Tipo := 7;

  inserir_preferencias._codigo := qryProdutoCODIGO.AsInteger;

  inserir_preferencias.ShowModal;

  qryProduto.Edit;
  qryProduto.Post;

  qryProdutoPreferencias.Close;
  qryProdutoPreferencias.ParamByName('TIPO').AsInteger := inserir_preferencias._Tipo;
  qryProdutoPreferencias.Open;
end;

procedure Tcadastro_produto.SpeedButton11Click(Sender: TObject);
begin
//  if qryProdutoCodigo.Text <> '' then
//  begin
//    if opdFoto.Execute() then
//    begin
//
//      if not (qryProduto.State in [dsInsert, dsEdit]) then
//        qryProduto.Edit;
//
//      qryProdutoURLFOTO.Text := opdFoto.FileName;
//      Image1.Picture.LoadFromFile(qryProdutoURLFOTO.Text);
//    end;
//  end;
end;

procedure Tcadastro_produto.SpeedButton13Click(Sender: TObject);
begin

  if application.MessageBox('Deseja realmente fazer a avaliação do produto?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
  begin

    if Application.FindComponent('inserir_avaliacao') = Nil then
      Application.CreateForm(Tinserir_avaliacao, inserir_avaliacao);

    inserir_avaliacao._Finalidade := tAvProduto;

    inserir_avaliacao._codigoOrigem := qryProdutoCODIGO.AsInteger;

    inserir_avaliacao.ShowModal;

    qryHistorico.Close;
    qryHistorico.Open;
    
  end;
end;

procedure Tcadastro_produto.btnPecaClick(Sender: TObject);
var
  CodTipo : Integer;
begin

  memComplemento.Visible := False;
  lbPreferncias.Visible := True;
  btnInserirPreferencias.Visible := True;

  if sender = btnPeca then CodTipo := 1
  else if sender = btnModelo then CodTipo := 2
  else if sender = btnMarca then CodTipo := 3
  else if sender = btnEstilo then CodTipo := 4
  else if sender = btnCor then CodTipo := 5
//  else if sender = btnExigencia then CodTipo := 6
  else if sender = btnComplemento then
  begin
    memComplemento.Visible := True;
    lbPreferncias.Visible := False;
    btnInserirPreferencias.Visible := False;
  end;

  if sender <> btnComplemento then
  begin
    qryProdutoPreferencias.Close;
    qryProdutoPreferencias.ParamByName('TIPO').AsInteger := CodTipo;
    qryProdutoPreferencias.ParamByName('CODIGO').AsInteger := qryProdutoCODIGO.AsInteger;
    qryProdutoPreferencias.Open;
  end;
end;

procedure Tcadastro_produto.SpeedButton1Click(Sender: TObject);
begin
  if dtsProduto.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryProduto.Post;
  end;

  qryProduto.Close;
  qryProduto.ParamByName('Codigo').AsInteger := GetCodigo(0,4);
  qryProduto.Open;
end;

procedure Tcadastro_produto.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
