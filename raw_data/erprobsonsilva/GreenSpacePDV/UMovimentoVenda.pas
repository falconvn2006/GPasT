unit UMovimentoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMovimentoEntrada, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, UDM,
  Vcl.Buttons;

type
  TFMovimentoVenda = class(TFMovimentoEntrada)
    procedure BtIniciarClick(Sender: TObject);
    procedure EdCodProdutoExit(Sender: TObject);
    procedure EdCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizarProduto;
  end;

var
  FMovimentoVenda: TFMovimentoVenda;

implementation

{$R *.dfm}

procedure TFMovimentoVenda.AtualizarProduto;
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
      if (length(EdCodProduto.Text) = 13) and (copy(EdCodProduto.Text,0,1) = '2') then
        EdQuantidade.Text := FormatFloat('#0.000', StrToFloat(copy(EdCodProduto.Text,7,4) +
                                                              ',' + copy(EdCodProduto.Text,11,2)) /
                                                                xFdQuery.FieldByName('preco').AsFloat);

      EdPrecoProduto.Text := FormatFloat('#0.00', (xFdQuery.FieldByName('preco').AsFloat * StrToFloat(EdQuantidade.Text)));
      EdUnidadeMedida.Text := xFdQuery.FieldByName('tp_unidade_medida').AsString;
    end;

    EdCodProduto.Text := xFdQuery.FieldByName('cod_produto').AsString;
  finally
    xFdQuery.Close;
    FreeAndNil(xFdQuery);
  end;

  BtAdicionarProduto.Click;
end;

procedure TFMovimentoVenda.BtIniciarClick(Sender: TObject);
var
  xFbMovimento : TFDQuery;
  xFdQuerySeqMovimento: TFDQuery;
begin
  try
    xFdQuerySeqMovimento := TFDQuery.Create(nil);
    xFdQuerySeqMovimento.Connection := dm.ConnectionPostgres;
    xFdQuerySeqMovimento.SQL.Add(' select coalesce(max(cod_movimento),0) + 1 cod_movimento ');
    xFdQuerySeqMovimento.SQL.Add('   from movimento ');
    xFdQuerySeqMovimento.Open;
    FSequenciaMovimento := xFdQuerySeqMovimento.FieldByName('cod_movimento').AsInteger;

    xFbMovimento := TFDQuery.Create(nil);
    xFbMovimento.Connection := dm.ConnectionPostgres;
    xFbMovimento.SQL.Add(' insert into movimento (cod_movimento, tipo_movimento, cod_entidade, data_movimento) ');
    xFbMovimento.SQL.Add('                values (:cod_movimento, :tipo_movimento, :cod_entidade, :data_movimento)');
    xFbMovimento.ParamByName('cod_movimento').AsInteger := FSequenciaMovimento;
    xFbMovimento.ParamByName('tipo_movimento').AsString := 'S';

    if EdCodigo.Text <> '' then
      xFbMovimento.ParamByName('cod_entidade').AsInteger := StrToInt(EdCodigo.Text)
    else
    begin
      xFbMovimento.ParamByName('cod_entidade').DataType := ftInteger;
      xFbMovimento.ParamByName('cod_entidade').Clear;
    end;

    xFbMovimento.ParamByName('data_movimento').AsDateTime := Now;
    xFbMovimento.ExecSQL;

    FdQMovimentoItem.Close;
    FdQMovimentoItem.ParamByName('cod_movimento').AsInteger := FSequenciaMovimento;
    FdQMovimentoItem.Open;

  finally
    xFbMovimento.Close;
    FreeAndNil(xFbMovimento);
    xFdQuerySeqMovimento.Close;
    FreeAndNil(xFdQuerySeqMovimento);
  end;

  Tsgeral.TabIndex := 1;
  EdCodProduto.SetFocus;
end;

procedure TFMovimentoVenda.EdCodProdutoExit(Sender: TObject);
begin
  AtualizarProduto;
end;

procedure TFMovimentoVenda.EdCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 88 then // Tecla X
  begin
    EdQuantidade.Text := EdCodProduto.Text;
    EdCodProduto.Text := '';
  end;

  if key = 70 then // Tecla F
  begin
    BtFinalizarItem.Click;
  end;

  if key = 13 then // Tecla Enter
  begin
    AtualizarProduto;
  end;
end;

end.
