unit untPesquisa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Grids, DBGrids, DB, IBCustomDataSet,
  IBQuery, Funcao, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, cxDBData, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  dxGDIPlusClasses, cxCheckBox, Menus, cxLookAndFeelPainters,
  cxButtons, cxButtonEdit, DBTables, rxMemTable, cxVariants, untDados;

type
  TfrmPesquisa = class(TForm)
    qryPesquisar: TIBQuery;
    dtsPesquisar: TDataSource;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    BitBtn1: TBitBtn;
    btnImprimir: TBitBtn;
    RunSQL: TSpeedButton;
    Panel1: TPanel;
    pnlTitulo: TPanel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure qryPesquisarAfterOpen(DataSet: TDataSet);
    procedure RunSQLClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure edtIncrementalChange(Sender: TObject);
    procedure cxGrid1DBTableView1KeyPress(Sender: TObject; var Key: Char);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    vFieldIncremental: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPesquisa: TfrmPesquisa;
  nome_tabela,
  Campo_Codigo,
  Campo_Nome,
  Nome_Campo_Codigo,
  Nome_Campo_Nome,
  Titulo_Janela: String;
  Resultado: Variant;

implementation

uses versao;

Const
  cCaption = 'PESQUISAR';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmPesquisa.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmPesquisa.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmPesquisa.BitBtn1Click(Sender: TObject);
begin
  ExportarGrid(cxGrid1);
end;

procedure TfrmPesquisa.btnImprimirClick(Sender: TObject);
begin
  ImprimirGrid(cxGrid1,frmPesquisa.Caption);
end;

procedure TfrmPesquisa.cxGrid1DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  SpeedButton1.Click;
end;

procedure TfrmPesquisa.cxGrid1DBTableView1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    SpeedButton1.Click;
end;

procedure TfrmPesquisa.edtIncrementalChange(Sender: TObject);
begin
//  if Trim(edtIncremental.Text) <> '' then
//    qryPesquisar.sql.Text := Dados.MontarSQL(nome_tabela,vFieldIncremental+' like '+QuotedStr('%'+edtIncremental.Text+'%'))
//  else
//    qryPesquisar.sql.Text := Dados.MontarSQL(nome_tabela);
//  qryPesquisar.Open;
end;

procedure TfrmPesquisa.FormCreate(Sender: TObject);
begin
  Caption := CaptionTela(cCaption);
end;

procedure TfrmPesquisa.FormShow(Sender: TObject);
begin
//  TOP := 0;
//  LEFT := 124;

  Dados.Geral.SQL.Text := 'Select * from TABCONTROLEPESQUISA where TABELA = '+QuotedStr(nome_tabela);
  Dados.Geral.Open;

  if Dados.Geral.IsEmpty then
  begin
    Dados.Geral.SQL.Text := 'INSERT INTO TABCONTROLEPESQUISA (TABELA, TITULO, CAMPOPESQUISAINCREMENTAL) VALUES ('+QuotedStr(nome_tabela)+', '+QuotedStr(Titulo_Janela)+', '+QuotedStr(Campo_Nome)+')';
    Dados.Geral.ExecSql;
    Dados.Geral.Transaction.CommitRetaining;

    Dados.Geral .SQL.Text := 'INSERT INTO TABCONTROLEPESQUISACAMPOS (TABELA, ORDEM, FIELDNAME, TITULO) VALUES '+
                            '('+QuotedStr(nome_tabela)+', 1, '+QuotedStr(Campo_Codigo)+', '+QuotedStr(Nome_Campo_Codigo)+')';
    Dados.Geral.ExecSql;
    Dados.Geral.Transaction.CommitRetaining;

    Dados.Geral.SQL.Text := 'INSERT INTO TABCONTROLEPESQUISACAMPOS (TABELA, ORDEM, FIELDNAME, TITULO) VALUES '+
                            '('+QuotedStr(nome_tabela)+', 2, '+QuotedStr(Campo_Nome)+', '+QuotedStr(Nome_Campo_Nome)+')';
    Dados.Geral.ExecSql;
    Dados.Geral.Transaction.CommitRetaining;
  end;

  Dados.Geral.SQL.Text := 'Select * from TABCONTROLEPESQUISA where TABELA = '+QuotedStr(nome_tabela);
  Dados.Geral.Open;

  Caption := 'AMVSystem 1.0 | PESQUISAR - '+Dados.Geral.FieldByName('TITULO').AsString+' ('+nome_tabela+')';
  pnlTitulo.Caption := 'PESQUISAR - '+Dados.Geral.FieldByName('TITULO').AsString+' ('+nome_tabela+')';

  Dados.Geral.SQL.Text := 'Select x.CAMPOPESQUISAINCREMENTAL, c.TITULO from TABCONTROLEPESQUISA x '+
      ' left join tabcontrolepesquisacampos c on x.tabela = c.tabela and x.campopesquisaincremental = c.fieldname'+
      ' where x.TABELA = '+QuotedStr(nome_tabela);
  Dados.Geral.Open;
//  lblIncremental.Caption := Dados.Geral.FieldByName('TITULO').AsString;
  vFieldIncremental := Dados.Geral.FieldByName('CAMPOPESQUISAINCREMENTAL').AsString;

  qryPesquisar.sql.Text := Dados.MontarSQL(nome_tabela);
  qryPesquisar.Open;

//  cxGrid1DBTableView1.FilterRow.


// cxGrid1DBTableView1.Controller.FocusedRow := cxGrid1DBTableView1.ViewData.FilterRow;

// cxGrid1DBTableView1.Controller.EditingController.ShowEdit(cxGrid1DBTableView1.Columns[0]);

//  edtIncremental.Text := '';
//  edtIncremental.SetFocus;
end;

procedure TfrmPesquisa.qryPesquisarAfterOpen(DataSet: TDataSet);
begin
  cxGrid1DBTableView1.ClearItems;
  cxGrid1DBTableView1.DataController.CreateAllItems;
end;

procedure TfrmPesquisa.RunSQLClick(Sender: TObject);
begin
  Dados.ConfigurarPesquisa(nome_tabela);

  Dados.Geral.SQL.Text := 'Select x.CAMPOPESQUISAINCREMENTAL, c.titulo from TABCONTROLEPESQUISA x '+
      ' left join tabcontrolepesquisacampos c on x.tabela = c.tabela and x.campopesquisaincremental = c.fieldname'+
      ' where x.TABELA = '+QuotedStr(nome_tabela);
  Dados.Geral.Open;
//  lblIncremental.Caption := Dados.Geral.FieldByName('Titulo').AsString;
//  vFieldIncremental := Dados.Geral.FieldByName('CAMPOPESQUISAINCREMENTAL').AsString;

  qryPesquisar.Close;
  qryPesquisar.sql.Text := Dados.MontarSQL(nome_tabela);
  qryPesquisar.Open;
end;

procedure TfrmPesquisa.SpeedButton1Click(Sender: TObject);
begin
  Resultado := qryPesquisar.Fields[0].Value;
  close;
end;

procedure TfrmPesquisa.SpeedButton2Click(Sender: TObject);
begin
  Resultado := 0;
  Close;
end;

end.
