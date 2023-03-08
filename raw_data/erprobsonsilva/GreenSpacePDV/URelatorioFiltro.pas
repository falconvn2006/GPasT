unit URelatorioFiltro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.WinXPickers,
  Vcl.StdCtrls, Data.FMTBcd, Data.DB, Data.SqlExpr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Udm, URelatorio, URelatorioVendaPagamento;

type
  TFRelatorioFiltro = class(TForm)
    PageControl1: TPageControl;
    TsProduto: TTabSheet;
    TsResumoVenda: TTabSheet;
    Label1: TLabel;
    EdNomeProduto: TEdit;
    EdCodProduto: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    DtpDataInicio: TDateTimePicker;
    DtpDataFim: TDateTimePicker;
    Label4: TLabel;
    DtpInicioVenda: TDateTimePicker;
    DtpVendaFim: TDateTimePicker;
    Label5: TLabel;
    CbTipoPagamento: TComboBox;
    Label6: TLabel;
    Button1: TButton;
    procedure DpDataInicioChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EdCodProdutoExit(Sender: TObject);
    procedure EdCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure AtualizaProduto;
  end;

var
  FRelatorioFiltro: TFRelatorioFiltro;

implementation

{$R *.dfm}

procedure TFRelatorioFiltro.AtualizaProduto;
var
  xFdQuery: TFDQuery;
  xCodigo: String;
begin
if (length(EdCodProduto.Text) = 13) and (copy(EdCodProduto.Text,0,1) = '2') then
    xCodigo := copy(EdCodProduto.Text,2,4)
  else
    xCodigo := EdCodProduto.Text;

  EdNomeProduto.Text := '';
  if xCodigo = '' then
  begin
    exit;
  end;

  try
    xFdQuery := TFDQuery.Create(nil);
    xFdQuery.Connection := dm.ConnectionPostgres;
    xFdQuery.SQL.Add(' select * ');
    xFdQuery.SQL.Add('   from produto ');
    if (Length(xCodigo) < 6) then
    begin
      xFdQuery.SQL.Add('   where ((cod_produto = :cod_produto) ');
      xFdQuery.SQL.Add('     or (cod_balanca = :cod_balanca)) ');
      xFdQuery.ParamByName('cod_produto').AsInteger := StrToInt(xCodigo);
      xFdQuery.ParamByName('cod_balanca').AsInteger := StrToInt(xCodigo);
    end
    else
    begin
      xFdQuery.SQL.Add('   where ((cod_barra = :cod_barra) ');
      xFdQuery.SQL.Add('     or (cod_barra_caixa = :cod_barra_caixa)) ');
      xFdQuery.ParamByName('cod_barra').AsString := xCodigo;
      xFdQuery.ParamByName('cod_barra_caixa').AsString := xCodigo;
    end;
    xFdQuery.Open;

    if xFdQuery.IsEmpty then
    begin
      ShowMessage('Produto não cadastrado!');
      exit;
    end
    else
    begin
      EdNomeProduto.Text := xFdQuery.FieldByName('descricao').AsString;
    end;

    EdCodProduto.Text := xFdQuery.FieldByName('cod_produto').AsString;
  finally
    xFdQuery.Close;
    FreeAndNil(xFdQuery);
  end;
end;

procedure TFRelatorioFiltro.Button1Click(Sender: TObject);
var
  TRelatorioVendaPagamento : TFRelatorioVendaPagamento;
begin
  TRelatorioVendaPagamento := TFRelatorioVendaPagamento.Create(nil);
  if (CbTipoPagamento.ItemIndex = 4) then
  begin
    TRelatorioVendaPagamento.FdGeral.ParamByName('tp_pagamento').DataType := ftInteger;
    TRelatorioVendaPagamento.FdGeral.ParamByName('tp_pagamento').Clear;
  end
  else
  begin
    TRelatorioVendaPagamento.FdGeral.ParamByName('tp_pagamento').AsInteger := CbTipoPagamento.ItemIndex;
  end;
  TRelatorioVendaPagamento.FdGeral.ParamByName('data_movimento_ini').AsDate := DtpInicioVenda.Date;
  TRelatorioVendaPagamento.FdGeral.ParamByName('data_movimento_fim').AsDate := DtpVendaFim.Date;
  TRelatorioVendaPagamento.RLReport1.Preview();
  FreeAndNil(TRelatorioVendaPagamento);
end;

procedure TFRelatorioFiltro.Button2Click(Sender: TObject);
var
  TRelatorio : TFRelatorio;
begin
  TRelatorio := TFRelatorio.Create(nil);
  if (EdCodProduto.Text = '') then
  begin
    TRelatorio.FdGeral.ParamByName('cod_produto').DataType := ftInteger;
    TRelatorio.FdGeral.ParamByName('cod_produto').Clear;
  end
  else
  begin
    TRelatorio.FdGeral.ParamByName('cod_produto').AsInteger := StrToInt(EdCodProduto.Text);
  end;
  TRelatorio.FdGeral.ParamByName('data_movimento_ini').AsDate := DtpDataInicio.Date;
  TRelatorio.FdGeral.ParamByName('data_movimento_fim').AsDate := DtpDataFim.Date;
  TRelatorio.RLReport1.Preview();
  FreeAndNil(TRelatorio);
end;

procedure TFRelatorioFiltro.DpDataInicioChange(Sender: TObject);
begin
  DtpDataInicio.Date := Date;
  DtpDataFim.Date := Date;
end;

procedure TFRelatorioFiltro.EdCodProdutoExit(Sender: TObject);
begin
  AtualizaProduto;
end;

procedure TFRelatorioFiltro.EdCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then // Tecla Enter
  begin
    AtualizaProduto;
  end;
end;

procedure TFRelatorioFiltro.FormCreate(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
end;

end.
