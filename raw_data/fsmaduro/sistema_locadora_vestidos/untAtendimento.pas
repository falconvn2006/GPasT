unit untAtendimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxButtonEdit, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, dxGDIPlusClasses, Menus,
  cxLookAndFeelPainters, StdCtrls, DBCtrls, cxButtons, RxLookup,
  IBCustomDataSet, IBQuery, DBTables, rxMemTable, Buttons, Mask, untDados;

type
  rOrdensServico = record
    Prestador: Integer;
    Servico: Integer;
    obs: String;
    Produtos: Array of Integer;
  end;

type
  rOrcamento = record
    Cliente: Integer;
    Produtos: Array of TProdutosContrato;
  end;

type
  TfrmAtendimento = class(TForm)
    pnlTitulo: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlSelecionados: TPanel;
    Panel5: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBTableView1SELECTED: TcxGridDBColumn;
    cxGridDBTableView1CODIGO: TcxGridDBColumn;
    cxGridDBTableView1NOME: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    Image1: TImage;
    Panel4: TPanel;
    Image2: TImage;
    Panel6: TPanel;
    Panel7: TPanel;
    cxButton4: TcxButton;
    Panel8: TPanel;
    DBText1: TDBText;
    Label1: TLabel;
    edtAgenda: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtData: TEdit;
    edtHora: TEdit;
    Label4: TLabel;
    edtEvento: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtDataEvento: TEdit;
    edtHoraEvento: TEdit;
    Label7: TLabel;
    edtPedido: TEdit;
    Label8: TLabel;
    mmLocal: TDBMemo;
    Label9: TLabel;
    edtHorario: TEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cbTipoContrato: TComboBox;
    cbPerfil: TRxDBLookupCombo;
    Label10: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    cxGrid3: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    cxGrid4: TcxGrid;
    cxGridDBTableView4: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    cxGrid5: TcxGrid;
    cxGridDBTableView5: TcxGridDBTableView;
    cxGridLevel5: TcxGridLevel;
    Panel17: TPanel;
    qryPerfis: TIBQuery;
    qryPerfisCODIGO: TIntegerField;
    qryPerfisPERFIL: TIBStringField;
    qryPerfisPRODUTOS: TIntegerField;
    dtsPerfis: TDataSource;
    qryPerfisTIPOCONVIDADO: TIBStringField;
    cxGridDBTableView5CODIGO: TcxGridDBColumn;
    cxGridDBTableView5PERFIL: TcxGridDBColumn;
    cxGridDBTableView5PRODUTOS: TcxGridDBColumn;
    cxGridDBTableView5TIPOCONVIDADO: TcxGridDBColumn;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    mmSelecionados: TMemoryTable;
    mmSelecionadosCODIGO: TIntegerField;
    mmSelecionadosNOME: TStringField;
    dtsSelecionados: TDataSource;
    mmSelecionadosCODIGOARARA: TIntegerField;
    mmSelecionadosTEMSERVICO: TBooleanField;
    cxGridDBTableView1CODIGOARARA: TcxGridDBColumn;
    cxGridDBTableView1TEMSERVICO: TcxGridDBColumn;
    mmSelecionadosCODIGOSERVICO: TIntegerField;
    mmSelecionadosCODIGOPRESTADOR: TIntegerField;
    qryPrestador: TIBQuery;
    qryPrestadorCODIGO: TIntegerField;
    qryPrestadorNOME: TIBStringField;
    dtsPrestador: TDataSource;
    pnlImagem: TPanel;
    Edit2: TEdit;
    Panel18: TPanel;
    cxButton9: TcxButton;
    cxButton10: TcxButton;
    RxDBLookupCombo1: TRxDBLookupCombo;
    RxDBLookupCombo2: TRxDBLookupCombo;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    DBMemo2: TDBMemo;
    DBMemo1: TDBMemo;
    DBEdit6: TDBEdit;
    mmSelecionadosOBSSERVICO: TStringField;
    qryServicos: TIBQuery;
    qryServicosCODIGO: TIntegerField;
    qryServicosDECRICAO: TIBStringField;
    qryServicosDETALHAMENTO: TMemoField;
    dtsServicos: TDataSource;
    mmSelecionadosDetServico: TStringField;
    cxButton11: TcxButton;
    qryPerfilX: TIBQuery;
    dtsPerfilX: TDataSource;
    qryPerfilXCODIGOPERFIL: TIntegerField;
    qryPerfilXPERFIL: TIBStringField;
    dtsOrcamentos: TDataSource;
    qryOrcamentos: TIBQuery;
    qryOrcamentosCODIGO: TIntegerField;
    qryOrcamentosDATACADASTRO: TDateField;
    qryOrcamentosITENS: TIntegerField;
    cxGridDBTableView2CODIGO: TcxGridDBColumn;
    cxGridDBTableView2DATACADASTRO: TcxGridDBColumn;
    cxGridDBTableView2ITENS: TcxGridDBColumn;
    qryOS: TIBQuery;
    dtsOS: TDataSource;
    qryOSCODIGO: TIntegerField;
    qryOSDATA: TDateField;
    qryOSITENS: TIntegerField;
    cxGridDBTableView3CODIGO: TcxGridDBColumn;
    cxGridDBTableView3DATA: TcxGridDBColumn;
    cxGridDBTableView3ITENS: TcxGridDBColumn;
    qryContratos: TIBQuery;
    dtsContratos: TDataSource;
    qryContratosCODIGO: TIntegerField;
    qryContratosDATA: TDateField;
    qryContratosITENS: TIntegerField;
    cxGridDBTableView4CODIGO: TcxGridDBColumn;
    cxGridDBTableView4DATA: TcxGridDBColumn;
    cxGridDBTableView4ITENS: TcxGridDBColumn;
    qryPerfisCODPERFIL: TIntegerField;
    cxButton12: TcxButton;
    mmSelecionadosCODIGOCONTRATO: TIntegerField;
    chbSemFoto: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxGridDBTableView1SELECTEDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
    procedure cxButton11Click(Sender: TObject);
    procedure cbTipoContratoChange(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxGridDBTableView4CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBTableView3CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBTableView2CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBTableView5PERFILPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxButton12Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    procedure Carregar();
    { Private declarations }
  public
    CodigoAgenda, cTipoAgenda: Integer;
    { Public declarations }
    procedure PreencherProdutos;
  end;

var
  frmAtendimento: TfrmAtendimento;

implementation

uses untArara, untDtmRelatorios, funcao, untContrato, untOrcamento,
  untOrdemServico, form_cadastro_perfil, versao;

Const
  cCaption = 'ATENDIMENTO';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmAtendimento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmAtendimento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmAtendimento.cbTipoContratoChange(Sender: TObject);
begin
  cbPerfil.Visible := cbTipoContrato.ItemIndex = 1;
end;

procedure TfrmAtendimento.cxButton10Click(Sender: TObject);
begin
  mmSelecionados.Cancel;
  pnlImagem.Visible := False;
end;

procedure TfrmAtendimento.cxButton11Click(Sender: TObject);
begin
  if not (mmSelecionados.State in [dsInsert,dsEdit]) then
    mmSelecionados.Edit;

  mmSelecionadosTEMSERVICO.AsBoolean := False;
  mmSelecionadosCODIGOSERVICO.Text := '';
  mmSelecionadosCODIGOPRESTADOR.Text := '';
  mmSelecionadosOBSSERVICO.Text := '';
  mmSelecionados.Post;
  pnlImagem.Visible := False;
end;

procedure TfrmAtendimento.cxButton12Click(Sender: TObject);
begin


  if Application.MessageBox('Deseja realmente gerar a devolução dos produtos?'#13,
                          'Devolução',MB_YESNO+MB_ICONQUESTION) = IDNO then
  Exit;


  try

    mmSelecionados.First;

    While not mmSelecionados.Eof do
    begin
      Dados.GerarDevolucao(mmSelecionadosCODIGOCONTRATO.AsInteger,1,mmSelecionadosCODIGO.AsInteger);
      mmSelecionados.Next;
    end;


    Application.MessageBox('Devolução efetuada com sucesso!','Terminado!',MB_OK+MB_ICONEXCLAMATION);

    cxButton6.Click;

  except
    on e:Exception do
      application.MessageBox(Pchar('Erro ao gerar Devolução.'+#13+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;


end;

procedure TfrmAtendimento.cxButton1Click(Sender: TObject);
var
  x, codPerfil: integer;
  arrOrcamentos: array of rOrcamento;

  function Localiza(xCli, xProd: Integer; xVal: Real): integer;
  var
    i, j: integer;
    xBool: boolean;
  begin
    result := -1;
    xBool := False;
    for i := 0 to length(arrOrcamentos) - 1 do
    begin
      if (arrOrcamentos[i].Cliente = xCli) then
      begin
        result := i;
        for j := 0 to length(arrOrcamentos[i].Produtos) do
        begin
          if arrOrcamentos[i].Produtos[j].CodigoProduto = xProd then
            xBool := True;

          if xBool then
            Break;
        end;

        if not xBool then
        begin
          SetLength(arrOrcamentos[i].Produtos, length(arrOrcamentos[i].Produtos) + 1);
          arrOrcamentos[i].Produtos[length(arrOrcamentos[i].Produtos)-1].CodigoProduto := xProd;
          arrOrcamentos[i].Produtos[length(arrOrcamentos[i].Produtos)-1].Valor := xVal;
        end;

        break;
      end;
    end;
  end;
begin
  if Application.MessageBox('Deseja Realmente Gerar Orçamento(s)?'#13,
                            'Gerar Orçamento',MB_YESNO+MB_ICONQUESTION) = IDNO then
    Exit;

  mmSelecionados.First;
  while not mmSelecionados.Eof do
  begin
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select VALORALUGUEL1 from TABPRODUTOS where CODIGO = ' +intToStr(mmSelecionadosCODIGO.AsInteger);
    dados.Geral.Open;

    if cbTipoContrato.ItemIndex = 0 then
    begin
      qryPerfis.Locate('CODIGO',mmSelecionadosCODIGOARARA.AsInteger,[]);

      codPerfil := qryPerfisCODPERFIL.AsInteger;
    end
    else
      codPerfil := cbPerfil.KeyValue;

    if Localiza(codPerfil,mmSelecionadosCODIGO.AsInteger,dados.Geral.FieldByName('VALORALUGUEL1').AsCurrency) = -1 then
    begin
      SetLength(arrOrcamentos,length(arrOrcamentos)+1);
      arrOrcamentos[length(arrOrcamentos)-1].Cliente := codPerfil;
      SetLength(arrOrcamentos[length(arrOrcamentos)-1].Produtos, length(arrOrcamentos[length(arrOrcamentos)-1].Produtos) + 1);
      arrOrcamentos[length(arrOrcamentos)-1].Produtos[length(arrOrcamentos[length(arrOrcamentos)-1].Produtos)-1].CodigoProduto := mmSelecionadosCODIGO.AsInteger;
      arrOrcamentos[length(arrOrcamentos)-1].Produtos[length(arrOrcamentos[length(arrOrcamentos)-1].Produtos)-1].Valor := dados.Geral.FieldByName('VALORALUGUEL1').AsCurrency;
    end;
    mmSelecionados.Next;
  end;

  for x := 0 to length(arrOrcamentos) - 1 do
  begin
    Dados.InserirOrcamento(arrOrcamentos[x].Cliente,
                           arrOrcamentos[x].Produtos,
                           StrToIntDef(edtPedido.Text,0),CodigoAgenda);
  end;

  qryOrcamentos.Close;
  qryOrcamentos.Params[0].AsInteger := CodigoAgenda;
  qryOrcamentos.Open;

end;

procedure TfrmAtendimento.cxButton2Click(Sender: TObject);
var
  x, codPerfil: integer;
  arrOrcamentos: array of rOrcamento;

  function Localiza(xCli, xProd: Integer; xVal: Real): integer;
  var
    i, j: integer;
    xBool: boolean;
  begin
    result := -1;
    xBool := False;
    for i := 0 to length(arrOrcamentos) - 1 do
    begin
      if (arrOrcamentos[i].Cliente = xCli) then
      begin
        result := i;
        for j := 0 to length(arrOrcamentos[i].Produtos) do
        begin
          if arrOrcamentos[i].Produtos[j].CodigoProduto = xProd then
            xBool := True;

          if xBool then
            Break;
        end;

        if not xBool then
        begin
          SetLength(arrOrcamentos[i].Produtos, length(arrOrcamentos[i].Produtos) + 1);
          arrOrcamentos[i].Produtos[length(arrOrcamentos[i].Produtos)-1].CodigoProduto := xProd;
          arrOrcamentos[i].Produtos[length(arrOrcamentos[i].Produtos)-1].Valor := xVal;
        end;

        break;
      end;
    end;
  end;
begin

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'Select distinct p.codigo '+
                          '  from TABARARA a '+
                          '  left join tabperfil p on a.codigoperfil = p.codigo '+
                          '  left join tabtipoperfil tp on (p.CODIGOTIPOPERFIL = tp.codigo) '+
                          ' where a.codigoagenda =0'+intToStr(CodigoAgenda)+
                          '   and coalesce(tp.tipo,0) <> 1  ';
  Dados.Geral.Open;

  if not Dados.Geral.IsEmpty then
  begin
    application.MessageBox(Pchar('Não é pemitido gerar contrato para um perfil que não for do tipo cliente!'+#13+
                                 ''),'',mb_OK+MB_ICONWARNING);

    Abort;
  end;


  if Application.MessageBox('Deseja Realmente Gerar Contrato(s)?'#13,
                            'Gerar Contrato',MB_YESNO+MB_ICONQUESTION) = IDNO then
    Exit;

  mmSelecionados.First;
  while not mmSelecionados.Eof do
  begin
    dados.Geral.Close;
    dados.Geral.sql.Text := 'Select VALORALUGUEL1 from TABPRODUTOS where CODIGO = ' +intToStr(mmSelecionadosCODIGO.AsInteger);
    dados.Geral.Open;

    if cbTipoContrato.ItemIndex = 0 then
    begin
      qryPerfis.Locate('CODIGO',mmSelecionadosCODIGOARARA.AsInteger,[]);

      codPerfil := qryPerfisCODPERFIL.AsInteger;
    end
    else
      codPerfil := cbPerfil.KeyValue;

    if Localiza(codPerfil,mmSelecionadosCODIGO.AsInteger,dados.Geral.FieldByName('VALORALUGUEL1').AsCurrency) = -1 then
    begin
      SetLength(arrOrcamentos,length(arrOrcamentos)+1);
      arrOrcamentos[length(arrOrcamentos)-1].Cliente := codPerfil;
      SetLength(arrOrcamentos[length(arrOrcamentos)-1].Produtos, length(arrOrcamentos[length(arrOrcamentos)-1].Produtos) + 1);
      arrOrcamentos[length(arrOrcamentos)-1].Produtos[length(arrOrcamentos[length(arrOrcamentos)-1].Produtos)-1].CodigoProduto := mmSelecionadosCODIGO.AsInteger;
      arrOrcamentos[length(arrOrcamentos)-1].Produtos[length(arrOrcamentos[length(arrOrcamentos)-1].Produtos)-1].Valor := dados.Geral.FieldByName('VALORALUGUEL1').AsCurrency;
    end;
    mmSelecionados.Next;
  end;

  for x := 0 to length(arrOrcamentos) - 1 do
  begin
    Dados.InserirContrato(arrOrcamentos[x].Cliente,
                          arrOrcamentos[x].Produtos,
                          0,
                          CodigoAgenda);
  end;

  qryContratos.Close;
  qryContratos.Params[0].AsInteger := CodigoAgenda;
  qryContratos.Open;

end;

procedure TfrmAtendimento.cxButton3Click(Sender: TObject);
var
  x: integer;
  arrServicos: array of rOrdensServico;

  function Localiza: integer;
  var
    i, j: integer;
    xBool: boolean;
  begin
    result := -1;
    xBool := False;
    for i := 0 to length(arrServicos) - 1 do
    begin
      if (arrServicos[i].Prestador = mmSelecionadosCODIGOPRESTADOR.AsInteger) and
         (arrServicos[i].Servico   = mmSelecionadosCODIGOSERVICO.AsInteger) then
      begin
        Localiza := i;
        for j := 0 to length(arrServicos[i].Produtos) do
        begin
          if arrServicos[i].Produtos[j] = mmSelecionadosCODIGO.AsInteger then
            xBool := True;

          if xBool then
            Break;
        end;

        if not xBool then
        begin
          SetLength(arrServicos[i].Produtos, length(arrServicos[i].Produtos) + 1);
          arrServicos[i].Produtos[length(arrServicos[i].Produtos)-1] := mmSelecionadosCODIGO.AsInteger;
        end;

        break;
      end;
    end;
  end;
begin
  if Application.MessageBox('Deseja Realmente Gerar Orden(s) de Serviço?'#13,
                            'Gerar OS',MB_YESNO+MB_ICONQUESTION) = IDNO then
    Exit;

  mmSelecionados.First;
  while not mmSelecionados.Eof do
  begin
    if mmSelecionadosTEMSERVICO.AsBoolean then
    begin
      if Localiza = -1 then
      begin
        SetLength(arrServicos,length(arrServicos)+1);
        arrServicos[length(arrServicos)-1].Prestador := mmSelecionadosCODIGOPRESTADOR.AsInteger;
        arrServicos[length(arrServicos)-1].Servico   := mmSelecionadosCODIGOSERVICO.AsInteger;
        SetLength(arrServicos[length(arrServicos)-1].Produtos, length(arrServicos[length(arrServicos)-1].Produtos) + 1);
        arrServicos[length(arrServicos)-1].Produtos[length(arrServicos[length(arrServicos)-1].Produtos)-1] := mmSelecionadosCODIGO.AsInteger;
      end;
    end;
    mmSelecionados.Next;
  end;

  for x := 0 to length(arrServicos) - 1 do
  begin
    Dados.GerarOS(CodigoAgenda,
                  arrServicos[x].Prestador,
                  arrServicos[x].Servico,
                  arrServicos[x].obs,
                  arrServicos[x].Produtos);
  end;

  qryOS.Close;
  qryOS.Params[0].AsInteger := CodigoAgenda;
  qryOS.Open;

end;

procedure TfrmAtendimento.cxButton4Click(Sender: TObject);
var
  i: integer;
begin
  If Application.FindComponent('frmARARA') = Nil then
    FreeAndNil(frmARARA);
  Application.CreateForm(TfrmARARA, frmARARA);

  frmARARA.vCodigo := qryPerfisCODIGO.AsInteger;

  frmARARA.ShowModal;

  for i := 0 to Length(frmARARA.ProdutosSelecionados) - 1 do
  begin
    mmSelecionados.Append;
    mmSelecionadosCODIGOARARA.AsInteger := qryPerfisCODIGO.AsInteger;
    mmSelecionadosCODIGO.AsInteger := frmARARA.ProdutosSelecionados[i];
    dados.Geral.SQL.Text := 'select descricao from tabprodutos where codigo = '+IntToStr(frmARARA.ProdutosSelecionados[i]);
    dados.Geral.Open;
    mmSelecionadosNOME.Text := dados.Geral.Fields[0].AsString;
    mmSelecionadosTEMSERVICO.AsBoolean := False;
    mmSelecionados.Post;
  end;
end;

procedure TfrmAtendimento.cxButton5Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja Realmente Abandonar Atendimento?'#13'Atenção:'#13'Após Execução sem Guardar Atendimento Seleção será Perdida!',
                            'Abandonar Atendimento',MB_YESNO+MB_ICONQUESTION) = IDYES then
    Close;
end;

procedure TfrmAtendimento.cxButton6Click(Sender: TObject);
begin
  dados.Geral.SQL.Text := 'Delete from TABTEMP_ATENDIMENTO where codigoagenda = '+intToStr(CodigoAgenda);
  dados.Geral.ExecSQL;
  dados.Geral.Transaction.CommitRetaining;
  mmSelecionados.First;
  while not mmSelecionados.Eof do
  begin
    Dados.Geral.SQL.Text := 'insert into TABTEMP_ATENDIMENTO values ('+
                            intToStr(CodigoAgenda)+','+ //CODIGOAGENDA INTEGER,
                            IntToStr(mmSelecionadosCODIGOARARA.AsInteger)+','+ //CODIGOARARA INTEGER,
                            IntToStr(mmSelecionadosCODIGO.AsInteger)+','+ //COIGOPRODUTO INTEGER,
                            iif(mmSelecionadosTEMSERVICO.AsBoolean,'1','0')+','+ //TEMSERVICO INTEGER,
                            IntToStr(mmSelecionadosCODIGOSERVICO.AsInteger)+','+ //CODIGOSERVICO INTEGER,
                            IntToStr(mmSelecionadosCODIGOPRESTADOR.AsInteger)+','+ //CODIGOPRESTADOR INTEGER
                            QuotedStr(mmSelecionadosOBSSERVICO.AsString)+
                            ')';
    dados.Geral.ExecSQL;
    dados.Geral.Transaction.CommitRetaining;
    mmSelecionados.Next;
  end;
  Close;
end;

procedure TfrmAtendimento.cxButton7Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirArara(qryPerfisCODIGO.AsInteger, chbSemFoto.Checked);
end;

procedure TfrmAtendimento.cxButton8Click(Sender: TObject);
begin
  mmSelecionados.First;
  while not mmSelecionados.Eof do
    mmSelecionados.Delete;
end;

procedure TfrmAtendimento.cxButton9Click(Sender: TObject);
begin
  if not (mmSelecionados.State in [dsInsert,dsEdit]) then
    mmSelecionados.Edit;

  mmSelecionadosTEMSERVICO.AsBoolean := True;
  mmSelecionados.Post;
  pnlImagem.Visible := False;
end;

procedure TfrmAtendimento.cxGridDBTableView1SELECTEDPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if AButtonIndex = 0 then
    mmSelecionados.Delete
  else
  begin
    pnlImagem.Visible := True;
    pnlImagem.Left := 509;
    pnlImagem.Top  := 115;
  end;
end;

procedure TfrmAtendimento.cxGridDBTableView2CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if qryOrcamentosCODIGO.AsInteger > 0 then
  begin

    If Application.FindComponent('frmOrcamento') = Nil then
           Application.CreateForm(TfrmOrcamento, frmOrcamento);

    frmOrcamento.Show;

    frmOrcamento.qryOrcamento.Locate('CODIGO',qryOrcamentosCODIGO.AsInteger,[]);
    
  end;
end;

procedure TfrmAtendimento.cxGridDBTableView3CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if qryOSCODIGO.AsInteger > 0 then
  begin
    If Application.FindComponent('frmOrdemServico') = Nil then
           Application.CreateForm(TfrmOrdemServico, frmOrdemServico);

    frmOrdemServico.pubCodigo := qryOSCODIGO.AsInteger;

    frmOrdemServico.Show;
  end;
end;

procedure TfrmAtendimento.cxGridDBTableView4CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin

  if qryContratosCODIGO.AsInteger > 0 then
  begin

    If Application.FindComponent('frmContrato') = Nil then
           Application.CreateForm(TfrmContrato, frmContrato);

    frmContrato.Show;

    frmContrato.qryContrato.Close;
    frmContrato.qryContrato.ParamByName('CODIGO').AsInteger := qryContratosCODIGO.AsInteger;
    frmContrato.qryContrato.Open;
  end;
end;

procedure TfrmAtendimento.cxGridDBTableView5PERFILPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  If Application.FindComponent('cadastro_perfil') = Nil then
         Application.CreateForm(Tcadastro_perfil, cadastro_perfil);

  cadastro_perfil.Show;

  cadastro_perfil.qryPerfil.Close;
  cadastro_perfil.qryPerfil.ParamByName('Codigo').AsInteger := qryPerfisCODPERFIL.AsInteger;
  cadastro_perfil.qryPerfil.Open;
end;

procedure TfrmAtendimento.FormCreate(Sender: TObject);
begin
  CarregarImagem(Image1,'topo.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmAtendimento.FormShow(Sender: TObject);
begin
  Carregar();
end;

procedure TfrmAtendimento.PreencherProdutos;
begin
//

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT D.*, P.DESCRICAO '+
                          '  FROM TABCONTRATODETALHE D '+
                          ' INNER JOIN TABPRODUTOS P ON (D.CODIGOPRODUTO = P.CODIGO) '+
                          ' WHERE D.CODIGO =0'+qryContratosCODIGO.Text;
  Dados.Geral.Open;

  if not mmSelecionados.Active then
    mmSelecionados.Open;

  While not Dados.Geral.Eof do
  begin

    mmSelecionados.Append;
    mmSelecionadosCODIGOCONTRATO.AsInteger  := Dados.Geral.FieldByName('CODIGO').AsInteger;
    mmSelecionadosCODIGO.AsInteger          := Dados.Geral.FieldByName('CODIGOPRODUTO').AsInteger;
    mmSelecionadosNOME.Text                 := Dados.Geral.FieldByName('DESCRICAO').Text;
    mmSelecionadosTEMSERVICO.AsBoolean      := False;
    mmSelecionados.Post;

    Dados.Geral.Next;
  end;

end;

procedure TfrmAtendimento.Carregar();
begin

  qryPrestador.Close;
  qryPrestador.Open;

  qryServicos.Close;
  qryServicos.Open;

  edtAgenda.Clear;
  edtData.Clear;
  edtHora.Clear;
  edtPedido.Clear;
  edtEvento.Clear;
  edtDataEvento.Clear;
  edtHoraEvento.Clear;
  edtHorario.Clear;
  mmLocal.Clear;

  Dados.Geral.SQL.Text := 'SELECT AG.codigo, AG.data, AG.hora, '+
                          '        P.codigo AS CodPedido, '+
                          '        E.codigo||'' - ''||E.nome AS EVENTO, '+
                          '        p.dataevento, p.horaevendo, '+
                          '        TRIM(case when p.horarioevento = 1 then ''MANHÃ'' '+
                          '             when p.horarioevento = 2 then ''ALMOÇO'' '+
                          '             when p.horarioevento = 3 then ''TARDE'' '+
                          '             when p.horarioevento = 4 then ''NOITE''  '+
                          '             when p.horarioevento = 5 then ''OUTROS''  '+
                          '             ELSE '''' END) AS HORARIO, '+
                          '        P.localevento  '+
                          '      FROM TABAGENDA AG  '+
                          '      LEFT JOIN tabpedidoagendamento P ON AG.idpedidoagenda = P.codigo  '+
                          '      LEFT JOIN tabevento E ON P.codigoevento = E.codigo '+
                          '      where AG.CODIGO = '+intToStr(CodigoAgenda);
  Dados.Geral.Open();

  edtAgenda.Text       := Dados.Geral.FieldByName('CODIGO').Text;
  edtData.Text         := FormatDateTime('dd/MM/yyyy',Dados.Geral.FieldByName('data').AsDateTime);
  edtHora.Text         := FormatDateTime('hh:mm',Dados.Geral.FieldByName('hora').AsDateTime);
  edtPedido.Text       := Dados.Geral.FieldByName('CODPEDIDO').Text;
  edtEvento.Text       := Dados.Geral.FieldByName('EVENTO').Text;
  edtDataEvento.Text   := FormatDateTime('dd/MM/yyyy',Dados.Geral.FieldByName('dataevento').AsDateTime);
  edtHoraEvento.Text   := FormatDateTime('hh:mm',Dados.Geral.FieldByName('horaevendo').AsDateTime);
  edtHorario.Text      := Dados.Geral.FieldByName('HORARIO').Text;
  mmLocal.Lines.Text   := Dados.Geral.FieldByName('LOCALEVENTO').AsString;

  qryPerfis.Close;
  qryPerfis.Params[0].AsInteger := CodigoAgenda;
  qryPerfis.Open;

  qryPerfilX.Close;
  qryPerfiLX.Params[0].AsInteger := CodigoAgenda;
  qryPerfilX.Open;

  qryOrcamentos.Close;
  qryOrcamentos.Params[0].AsInteger := CodigoAgenda;
  qryOrcamentos.Open;

  qryOS.Close;
  qryOS.Params[0].AsInteger := CodigoAgenda;
  qryOS.Open;

  qryContratos.Close;
  qryContratos.Params[0].AsInteger := CodigoAgenda;
  qryContratos.Params[1].AsInteger := CodigoAgenda;
  qryContratos.Open;

  mmSelecionados.Close;
  mmSelecionados.EmptyTable;
  mmSelecionados.Open;

  dados.Geral.SQL.Text := 'Select t.*, p.descricao from TABTEMP_ATENDIMENTO t '+
                          '  left join tabprodutos p on t.coigoproduto = p.codigo '+
                          ' where t.codigoagenda = '+intToStr(CodigoAgenda)+' order by t.codigoarara, t.coigoproduto ';
  dados.Geral.Open;
  while not Dados.Geral.Eof do
  begin
    mmSelecionados.Append;
    mmSelecionadosCODIGOARARA.AsInteger     := dados.Geral.FieldByName('CODIGOARARA').AsInteger;
    mmSelecionadosCODIGO.AsInteger          := dados.Geral.FieldByName('coigoproduto').AsInteger;
    mmSelecionadosNOME.AsString             := dados.Geral.FieldByName('descricao').AsString;
    mmSelecionadosTEMSERVICO.AsBoolean      := dados.Geral.FieldByName('TEMSERVICO').AsInteger = 1;
    mmSelecionadosCODIGOSERVICO.AsInteger   := dados.Geral.FieldByName('CODIGOSERVICO').AsInteger;
    mmSelecionadosCODIGOPRESTADOR.AsInteger := dados.Geral.FieldByName('CODIGOPRESTADOR').AsInteger;
    mmSelecionadosOBSSERVICO.AsString       := dados.Geral.FieldByName('OBSSERVICO').AsString;
    mmSelecionados.Post;
    dados.Geral.Next;
  end;


  case cTipoAgenda of
    0,1:
    begin
      cxButton1.Enabled := True;
      cxButton2.Enabled := True;
      cxButton3.Enabled := True;
      cxButton12.Enabled := False;

      cxButton4.Enabled := True;
      cxButton7.Enabled := True;
    end;

    2,3:
    begin
      cxButton1.Enabled := False;
      cxButton2.Enabled := False;
      cxButton3.Enabled := True;
      cxButton12.Enabled := False;

      cxButton4.Enabled := False;
      cxButton7.Enabled := False;
    end;

    4:
    begin
      cxButton1.Enabled := False;
      cxButton2.Enabled := False;
      cxButton3.Enabled := True;
      cxButton12.Enabled := True;

      cxButton4.Enabled := False;
      cxButton7.Enabled := False;

      PreencherProdutos;
      
    end;


  end;


end;

end.
