unit untPrevisaoOrcamento;

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
  cxCheckComboBox, DateUtils, math ;

type
  TfrmPrevisaoOrcamento = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    btn_pesquisar: TSpeedButton;
    btn_novo: TSpeedButton;
    dtsOrcamento: TDataSource;
    qryOrcamento: TIBQuery;
    updOrcamento: TIBUpdateSQL;
    dtsOrcamentoDetalhe: TDataSource;
    qryOrcamentoDetalhe: TIBQuery;
    updOrcamentoDetalhe: TIBUpdateSQL;
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
    dtsContaContabil: TDataSource;
    qryContaContabil: TIBQuery;
    qryContaContabilCODIGO: TIBStringField;
    qryContaContabilNOME: TIBStringField;
    qryContaContabilCONTAMAE: TIBStringField;
    qryContaContabilNATUREZA: TIntegerField;
    qryContaContabilCODIGOAUXILIAR: TIBStringField;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle2: TcxStyle;
    qryOrcamentoCODIGO: TIntegerField;
    qryOrcamentoDATA: TDateField;
    qryOrcamentoDESCRICAO: TIBStringField;
    qryOrcamentoANO: TIntegerField;
    qryOrcamentoDetalheCODIGOORCAMENTO: TIntegerField;
    qryOrcamentoDetalheID: TIntegerField;
    qryOrcamentoDetalheDESCRICAO: TIBStringField;
    qryOrcamentoDetalheVALORTOTAL: TIBBCDField;
    qryOrcamentoDetalheVALORMES01: TIBBCDField;
    qryOrcamentoDetalheVALORMES02: TIBBCDField;
    qryOrcamentoDetalheVALORMES03: TIBBCDField;
    qryOrcamentoDetalheVALORMES04: TIBBCDField;
    qryOrcamentoDetalheVALORMES05: TIBBCDField;
    qryOrcamentoDetalheVALORMES06: TIBBCDField;
    qryOrcamentoDetalheVALORMES07: TIBBCDField;
    qryOrcamentoDetalheVALORMES08: TIBBCDField;
    qryOrcamentoDetalheVALORMES09: TIBBCDField;
    qryOrcamentoDetalheVALORMES10: TIBBCDField;
    qryOrcamentoDetalheVALORMES11: TIBBCDField;
    qryOrcamentoDetalheVALORMES12: TIBBCDField;
    cxGrid1DBTableView1ID: TcxGridDBColumn;
    cxGrid1DBTableView1CODIGOCONTACONTABIL: TcxGridDBColumn;
    cxGrid1DBTableView1VALORTOTAL: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES01: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES02: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES03: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES04: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES05: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES06: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES07: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES08: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES09: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES10: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES11: TcxGridDBColumn;
    cxGrid1DBTableView1VALORMES12: TcxGridDBColumn;
    qryOrcamentoDetalheCODIGOCONTACONTABIL: TIBStringField;
    PopupMenu1: TPopupMenu;
    Ratearvalorparaosmeses1: TMenuItem;
    Ratearvalorproporcionalmenteaosdiasdecadams1: TMenuItem;
    procedure btn_sairClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure qryOrcamentoAfterPost(DataSet: TDataSet);
    procedure qryOrcamentoBeforeDelete(DataSet: TDataSet);
    procedure qryOrcamentoBeforePost(DataSet: TDataSet);
    procedure qryOrcamentoNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dtsOrcamentoStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryOrcamentoDetalheNewRecord(DataSet: TDataSet);
    procedure qryOrcamentoDetalheBeforeInsert(DataSet: TDataSet);
    procedure cxGrid1Enter(Sender: TObject);
    procedure qryOrcamentoDetalheAfterDelete(DataSet: TDataSet);
    procedure Ratearvalorparaosmeses1Click(Sender: TObject);
    procedure Ratearvalorproporcionalmenteaosdiasdecadams1Click(
      Sender: TObject);
    procedure qryOrcamentoDetalheBeforePost(DataSet: TDataSet);

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
  end;

var
  frmPrevisaoOrcamento: TfrmPrevisaoOrcamento;

implementation

uses untPesquisa, untDados, untDtmRelatorios, Funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmPrevisaoOrcamento.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmPrevisaoOrcamento.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmPrevisaoOrcamento.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrevisaoOrcamento.cxGrid1Enter(Sender: TObject);
begin
  if qryOrcamento.State in [dsInsert, dsEdit] then
    qryOrcamento.Post;
    
  if qryOrcamentoDetalhe.IsEmpty then
    qryOrcamentoDetalhe.Append;
end;

procedure TfrmPrevisaoOrcamento.dtsOrcamentoStateChange(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, (Sender as TDatasource));
end;

procedure TfrmPrevisaoOrcamento.btn_gravarClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja Gravar Registro?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
  begin
     if qryOrcamento.State in [dsInsert, dsEdit] then
       qryOrcamento.Post;
  end;
end;

procedure TfrmPrevisaoOrcamento.btn_novoClick(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Insert;
end;

procedure TfrmPrevisaoOrcamento.btn_excluirClick(Sender: TObject);
begin
  dados.VerificaPermicaoOPBD(NomeMenu, dtsOrcamento, True);

  if Application.MessageBox('Deseja Excluir Registro?','Excluir',MB_YESNO+MB_ICONQUESTION) = idyes then
     qryOrcamento.Delete;
end;

procedure TfrmPrevisaoOrcamento.btn_pesquisarClick(Sender: TObject);
begin
  If Application.FindComponent('frmPesquisa') = Nil then
    Application.CreateForm(TfrmPesquisa, frmPesquisa);

  untPesquisa.Resultado := 0;
  untPesquisa.nome_tabela       := 'TABPREVISAOORCAMENTODETALHE';
  untPesquisa.Campo_Codigo      := edtCodigo.DataField;
  untPesquisa.Campo_Nome        := DBEdit1.DataField;
  untPesquisa.Nome_Campo_Codigo := lblCodigo.Caption;
  untPesquisa.Nome_Campo_Nome   := Label2.Caption;

  frmPesquisa.ShowModal;

  if untPesquisa.Resultado <> 0 then
    qryOrcamento.Locate(edtCodigo.DataField,untPesquisa.Resultado,[]);

  dados.Log(2, 'Código: '+ qryOrcamentoCODIGO.Text + ' Janela: '+ copy(Caption,17,length(Caption)));

end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoBeforeDelete(DataSet: TDataSet);
begin
  dados.Log(5, 'Código: '+ qryOrcamentoCODIGO.Text +' Janela: '+copy(Caption,17,length(Caption)));
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoBeforePost(DataSet: TDataSet);
begin
  IF qryOrcamentoCODIGO.Value = 0 THEN
    qryOrcamentoCODIGO.Value := Dados.NovoCodigo('TABPREVISAOORCAMENTO');
  if dtsOrcamento.State = dsInsert then
    dados.Log(3, 'Código: '+ qryOrcamentoCODIGO.Text + ' Janela: '+copy(Caption,17,length(Caption)))
  else if dtsOrcamento.State = dsEdit then
    dados.Log(4, 'Código: '+ qryOrcamentoCODIGO  .Text + ' Janela: '+copy(Caption,17,length(Caption)))
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoNewRecord(DataSet: TDataSet);
begin
  qryOrcamentoCODIGO.Value := 0;
  qryOrcamentoDATA.AsDateTime := Date;
end;

procedure TfrmPrevisaoOrcamento.Ratearvalorparaosmeses1Click(Sender: TObject);
var
  x : Integer;
begin

  qryOrcamentoDetalhe.edit;

  for x := 1 to 12 do
  begin
    qryOrcamentoDetalhe.FieldByName('VALORMES'+AddZero(inttostr(x),2)).AsCurrency := qryOrcamentoDetalheVALORTOTAL.AsCurrency / 12
  end;

  qryOrcamentoDetalhe.Post;
  
end;

procedure TfrmPrevisaoOrcamento.Ratearvalorproporcionalmenteaosdiasdecadams1Click(
  Sender: TObject);
var
  QtdDiasAno, QtdDiasMes, x: Integer;
begin

  QtdDiasAno := DaysInAYear(qryOrcamentoANO.AsInteger);

  qryOrcamentoDetalhe.edit;

  for x := 1 to 12 do
  begin
    qryOrcamentoDetalhe.FieldByName('VALORMES'+AddZero(inttostr(x),2)).AsCurrency := qryOrcamentoDetalheVALORTOTAL.AsCurrency / (QtdDiasAno/DaysInAMonth(qryOrcamentoANO.AsInteger, x));
  end;

  qryOrcamentoDetalhe.Post;
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoDetalheAfterDelete(
  DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoDetalheBeforeInsert(
  DataSet: TDataSet);
begin
  if qryOrcamento.State = dsInsert then
    qryOrcamento.Post;
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoDetalheBeforePost(
  DataSet: TDataSet);
var
  cValorSoma : Currency;
begin

  cValorSoma := qryOrcamentoDetalheVALORMES01.AsCurrency + qryOrcamentoDetalheVALORMES02.AsCurrency + qryOrcamentoDetalheVALORMES03.AsCurrency +
                qryOrcamentoDetalheVALORMES04.AsCurrency + qryOrcamentoDetalheVALORMES05.AsCurrency + qryOrcamentoDetalheVALORMES06.AsCurrency +
                qryOrcamentoDetalheVALORMES07.AsCurrency + qryOrcamentoDetalheVALORMES08.AsCurrency + qryOrcamentoDetalheVALORMES09.AsCurrency +
                qryOrcamentoDetalheVALORMES10.AsCurrency + qryOrcamentoDetalheVALORMES11.AsCurrency + qryOrcamentoDetalheVALORMES12.AsCurrency;


  if RoundTo(qryOrcamentoDetalheVALORTOTAL.AsCurrency,2) < RoundTo(cValorSoma,2) then
  begin
    Application.MessageBox(Pchar('A soma dos valores rateados é maior que o valor total previsto no ano!'),'',mb_OK+MB_ICONWARNING);
    Abort;
  end;
end;

procedure TfrmPrevisaoOrcamento.qryOrcamentoDetalheNewRecord(DataSet: TDataSet);
begin

  qryOrcamentoDetalheCODIGOORCAMENTO.AsInteger := qryOrcamentoCODIGO.AsInteger;

  qryOrcamentoDetalheID.AsInteger := Dados.NovoCodigo('TABPREVISAOORCAMENTODETALHE','ID','CODIGOORCAMENTO = 0'+qryOrcamentoCODIGO.Text);

end;

procedure TfrmPrevisaoOrcamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SalvarRegistro;
  qryOrcamento.Close;
  qryOrcamentoDetalhe.Close;
end;

procedure TfrmPrevisaoOrcamento.FormCreate(Sender: TObject);
begin
  NomeMenu := 'ApuraoMensal1';
end;

procedure TfrmPrevisaoOrcamento.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
  
    qryOrcamento.Close;
    qryOrcamento.Open;

    qryOrcamentoDetalhe.Close;
    qryOrcamentoDetalhe.Open;

    qryContaContabil.Close;
    qryContaContabil.Open;


    Dados.NovoRegistro(qryOrcamento);

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmPrevisaoOrcamento.SpeedButton5Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.First;
end;

procedure TfrmPrevisaoOrcamento.SpeedButton2Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Prior;
end;

procedure TfrmPrevisaoOrcamento.SpeedButton4Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Next;
end;

procedure TfrmPrevisaoOrcamento.SalvarRegistro;
begin
  if qryOrcamento.State in [dsEdit, dsInsert] then
  begin
    if application.MessageBox('Registro em Estado de Edição ou Inserção.'+#13+
                              'Deseja Grava-lo?','GRAVAR',MB_YESNO+MB_ICONQUESTION)=idyes then
      qryOrcamento.Post;
  end;
end;

procedure TfrmPrevisaoOrcamento.SpeedButton1Click(Sender: TObject);
begin
  SalvarRegistro;
  qryOrcamento.Last;
end;

procedure TfrmPrevisaoOrcamento.FormActivate(Sender: TObject);
begin
  Try
    dados.Log(1,copy(Caption,17,length(Caption)));
  except
  End;
end;

end.
