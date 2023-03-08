unit untApuracaoMensal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, RXDBCtrl,
  ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons,  rxToolEdit, dxGDIPlusClasses,
  Grids, Wwdbigrd, Wwdbgrid, wwdbdatetimepicker, RxLookup, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, ppStrtch, ppMemo, cxStyles,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxDBLookupComboBox, cxButtonEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView,
  cxGrid, Menus, cxLookAndFeelPainters, cxButtons, cxContainer, cxGroupBox,
  cxGridBandedTableView, cxGridDBBandedTableView, wwdbedit, Wwdotdot, Wwdbcomb,
  cxCheckComboBox;

type
  TfrmApuracaoMensal = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsApuraMensal: TDataSource;
    qryApuraMensal: TIBQuery;
    updApuraMensal: TIBUpdateSQL;
    dtsApuraMensalDetalhe: TDataSource;
    qryApuraMensalDetalhe: TIBQuery;
    updApuraMensalDetalhe: TIBUpdateSQL;
    Panel1: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    Panel3: TPanel;
    Panel2: TPanel;
    Label30: TLabel;
    edtCodigo: TDBEdit;
    lblCodigo: TLabel;
    Label1: TLabel;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    SpeedButton5: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    Panel4: TPanel;
    Label5: TLabel;
    qryApuraMensalCODIGO: TIntegerField;
    qryApuraMensalDATA: TDateField;
    qryApuraMensalANOMES: TIBStringField;
    qryApuraMensalDESCRICAO: TIBStringField;
    qryApuraMensalSALDOINICIAL: TIBBCDField;
    qryApuraMensalDetalheCODIGOAPURACAO: TIntegerField;
    qryApuraMensalDetalheID: TIntegerField;
    qryApuraMensalDetalheDATA: TDateField;
    qryApuraMensalDetalheVALORCREDITO: TIBBCDField;
    qryApuraMensalDetalheVALORDEBITO: TIBBCDField;
    qryApuraMensalDetalheSALDO: TIBBCDField;
    qryApuraMensalDetalheCODIGOCONTACONTABIL: TIBStringField;
    qryApuraMensalDetalheCODIGOEXPLICACAO: TIntegerField;
    cxGrid1DBTableView1ID: TcxGridDBColumn;
    cxGrid1DBTableView1DATA: TcxGridDBColumn;
    cxGrid1DBTableView1VALORCREDITO: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGOCONTACONTABIL: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGOEXPLICACAO: TcxGridDBColumn;
    dtsContaContabil: TDataSource;
    qryContaContabil: TIBQuery;
    qryContaContabilCODIGO: TIBStringField;
    qryContaContabilNOME: TIBStringField;
    qryContaContabilCONTAMAE: TIBStringField;
    qryContaContabilNATUREZA: TIntegerField;
    qryContaContabilCODIGOAUXILIAR: TIBStringField;
    DBEdit4: TDBEdit;
    qryApuraMensalSALDOATUAL: TIBBCDField;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    qryExplicacao: TIBQuery;
    dtsExplicacao: TDataSource;
    qryExplicacaoCODIGO: TIntegerField;
    qryExplicacaoDESCRICAO: TIBStringField;
    qryApuraMensalDetalheOBSERVACAO: TIBStringField;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    wwDBComboBox1: TwwDBComboBox;
    Label6: TLabel;
    qryApuraMensalMES: TIntegerField;
    Image1: TImage;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryApuraMensalAfterPost(DataSet: TDataSet);
    procedure qryApuraMensalBeforeDelete(DataSet: TDataSet);
    procedure qryApuraMensalBeforePost(DataSet: TDataSet);
    procedure qryApuraMensalNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsApuraMensalStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryApuraMensalDetalheNewRecord(DataSet: TDataSet);
    procedure qryApuraMensalDetalheBeforeInsert(DataSet: TDataSet);
    procedure cxGrid1Enter(Sender: TObject);
    procedure qryApuraMensalDetalheBeforePost(DataSet: TDataSet);
    procedure qryApuraMensalDetalheAfterDelete(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    NomeMenu: String;
    { Private declarations }
  public
    pubCodigo: integer;
    cInserindo : Boolean;
    { Public declarations }
    procedure SalvarRegistro;
    procedure TotalizarSaldo;
  end;

var
  frmApuracaoMensal: TfrmApuracaoMensal;

implementation

uses untPesquisa, untDados, untDtmRelatorios, versao, funcao;

Const
  cCaption = 'APURAÇÃO MENSAL';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmApuracaoMensal.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmApuracaoMensal.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmApuracaoMensal.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmApuracaoMensal.cxGrid1Enter(Sender: TObject);
begin
  if qryApuraMensal.State in [dsInsert, dsEdit] then
    qryApuraMensal.Post;
    
  if qryApuraMensalDetalhe.IsEmpty then
    qryApuraMensalDetalhe.Append;
end;

procedure TfrmApuracaoMensal.dtsApuraMensalStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmApuracaoMensal.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryApuraMensal.State in [dsInsert, dsEdit] then
       qryApuraMensal.Post;
  end;
end;

procedure TfrmApuracaoMensal.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryApuraMensal.Insert;
end;

procedure TfrmApuracaoMensal.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsApuraMensal, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryApuraMensal.Delete;
end;

procedure TfrmApuracaoMensal.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABAPURACAOMENSAL';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBEdit1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := Label2.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryApuraMensal.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryApuraMensalCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmApuracaoMensal.qryApuraMensalAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmApuracaoMensal.qryApuraMensalBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryApuraMensalCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmApuracaoMensal.qryApuraMensalBeforePost(DataSet: TDataSet);
begin
  IF qryApuraMensalCODIGO.Value = 0 THEN
    qryApuraMensalCODIGO.Value := Dados.NovoCodigo('TABAPURACAOMENSAL');
  if dtsApuraMensal.State = dsInsert then
    dados.Log(3, 'Código: '+ qryApuraMensalCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsApuraMensal.State = dsEdit then
    dados.Log(4, 'Código: '+ qryApuraMensalCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure TfrmApuracaoMensal.qryApuraMensalNewRecord(DataSet: TDataSet);
begin
  qryApuraMensalCODIGO.Value := 0;
  qryApuraMensalDATA.AsDateTime := Date;
end;

procedure TfrmApuracaoMensal.qryApuraMensalDetalheAfterDelete(
  DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;

  TotalizarSaldo;
end;

procedure TfrmApuracaoMensal.qryApuraMensalDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryApuraMensal.State = dsInsert then
    qryApuraMensal.Post;
end;

procedure TfrmApuracaoMensal.qryApuraMensalDetalheBeforePost(DataSet: TDataSet);
begin
  qryApuraMensalDetalheSALDO.AsCurrency :=  qryApuraMensalDetalheVALORCREDITO.AsCurrency - qryApuraMensalDetalheVALORDEBITO.AsCurrency;
end;

procedure TfrmApuracaoMensal.qryApuraMensalDetalheNewRecord(DataSet: TDataSet);
begin

  qryApuraMensalDetalheCODIGOAPURACAO.AsInteger := qryApuraMensalCODIGO.AsInteger;

  qryApuraMensalDetalheID.AsInteger := Dados.NovoCodigo('TABAPURACAOMENSALDETALHE','ID','CODIGOAPURACAO = 0'+qryApuraMensalCODIGO.Text);

end;

procedure TfrmApuracaoMensal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryApuraMensal.Close;
  qryApuraMensalDetalhe.Close;
end;

procedure TfrmApuracaoMensal.FormCreate(Sender: TObject);
begin
  NomeMenu := 'ApuraoMensal1';
  CarregarImagem(Image1,'topo.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmApuracaoMensal.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
  
    qryApuraMensal.Close;
    qryApuraMensal.Open;

    qryApuraMensalDetalhe.Close;
    qryApuraMensalDetalhe.Open;

    qryContaContabil.Close;
    qryContaContabil.Open;

    qryExplicacao.Close;
    qryExplicacao.Open;

    Dados.NovoRegistro(qryApuraMensal);

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmApuracaoMensal.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryApuraMensal.First;
end;

procedure TfrmApuracaoMensal.TotalizarSaldo;
begin

  if not (qryApuraMensal.State in [dsEdit,dsInsert]) then
    qryApuraMensal.Edit;

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT SUM(SALDO * CASE WHEN P.NATUREZA = 1 THEN (-1) ELSE 1 END) AS SALDO '+
                          '  FROM TABAPURACAOMENSALDETALHE D '+
                          ' INNER JOIN TABPLANOCONTAS P ON (D.CODIGOCONTACONTABIL = P.CODIGO) '+
                          ' WHERE CODIGOAPURACAO =0'+qryApuraMensalCODIGO.Text;
  Dados.Geral.Open;

  qryApuraMensalSALDOATUAL.AsCurrency := qryApuraMensalSALDOINICIAL.AsCurrency + Dados.Geral.FieldByName('SALDO').AsCurrency;
  qryApuraMensal.Post;
  
end;

procedure TfrmApuracaoMensal.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryApuraMensal.Prior;
end;

procedure TfrmApuracaoMensal.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryApuraMensal.Next;
end;

procedure TfrmApuracaoMensal.SalvarRegistro;
begin
  if qryApuraMensal.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryApuraMensal.Post;
  end;
end;

procedure TfrmApuracaoMensal.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryApuraMensal.Last;
end;

procedure TfrmApuracaoMensal.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
