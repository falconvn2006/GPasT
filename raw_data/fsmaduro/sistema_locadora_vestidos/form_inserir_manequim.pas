unit form_inserir_manequim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, CheckLst, Grids, Wwdbigrd, Wwdbgrid, RxMemDS, wwdblook;

type TTipoFinalidadeManequim = (tfmPerfil, tfmProduto, tfmPedidoAgenda);

type
  Tinserir_manequim = class(TForm)
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    qryGeral: TIBQuery;
    memManequim: TRxMemoryData;
    memManequimcodigo: TIntegerField;
    memManequimdescricao: TStringField;
    memManequimvalor: TFloatField;
    grdManequim: TwwDBGrid;
    dtsManequim: TDataSource;
    memManequimProduto: TRxMemoryData;
    memManequimProdutovalorfinal: TFloatField;
    grdManequimProduto: TwwDBGrid;
    dtsManequimProduto: TDataSource;
    memManequimProdutocodigo: TIntegerField;
    memManequimProdutodescricao: TStringField;
    memManequimProdutovalor: TFloatField;
    qryValorPadrao: TIBQuery;
    cmbManequim1: TwwDBLookupCombo;
    cmbManequimProduto1: TwwDBLookupCombo;
    cmbManequimProduto2: TwwDBLookupCombo;
    qryValorPadraoCODIGOTIPOMANEQUIM: TIntegerField;
    qryValorPadraoVALORINICIAL: TIBBCDField;
    qryValorPadraoVALORFINAL: TIBBCDField;
    qryValorPadraoDESCRICAO: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_okClick(Sender: TObject);
    procedure memManequimBeforeDelete(DataSet: TDataSet);
    procedure memManequimBeforeInsert(DataSet: TDataSet);
    procedure memManequimAfterScroll(DataSet: TDataSet);
    procedure qryValorPadraoBeforeOpen(DataSet: TDataSet);
    procedure memManequimProdutoAfterScroll(DataSet: TDataSet);
    procedure cmbManequim1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    bIniciando: Boolean;
    { Private declarations }
  public
    ok: Boolean;
    FormChamado : Tform;
    _Finalidade : TTipoFinalidadeManequim;
    _codigo, _codigoPedido : Integer;
    { Public declarations }
  end;

var
  inserir_manequim: Tinserir_manequim;

implementation

uses funcao;

Const
  cCaption = 'DEFINIR MANEQUIM';


{$R *.dfm}

procedure Tinserir_manequim.btn_okClick(Sender: TObject);
var
  i: Integer;
begin

  if _Finalidade = tfmPerfil then
  begin
    if memManequim.State = dsEdit then
      memManequim.Post;
    qryGeral.SQL.Text := 'Delete from tabpessomanequim where codigoperfil = '+IntToStr(_codigo);
  end
  else if _Finalidade = tfmPedidoAgenda then
  begin
    if memManequim.State = dsEdit then
      memManequim.Post;
    qryGeral.SQL.Text := 'Delete from tabpessomanequim where codigoperfil = '+IntToStr(_codigo)+' and codigopedido = '+IntToStr(_codigoPedido);
  end
  else if _Finalidade = tfmProduto then
  begin
    if memManequimProduto.State = dsEdit then
      memManequimProduto.Post;
    qryGeral.SQL.Text := 'Delete from TABPRODUTOMANEQUIM where codigoproduto = '+IntToStr(_codigo);
  end;

  qryGeral.ExecSQL();
  qryGeral.Transaction.CommitRetaining();

  if _Finalidade in [tfmPerfil, tfmPedidoAgenda] then
  begin
    memManequim.First;
    while not memManequim.Eof do
    begin
      if memManequimvalor.AsFloat > 0 then
      begin

        qryGeral.SQL.Text := 'insert into tabpessomanequim values (:codigo,:codmanequim,:valor,:codigopedido)';
        qryGeral.ParamByName('codigo').AsInteger := _codigo;
        qryGeral.ParamByName('codmanequim').AsInteger := memManequimcodigo.AsInteger;
        qryGeral.ParamByName('valor').AsFloat := memManequimvalor.AsFloat;
        qryGeral.ParamByName('codigopedido').AsInteger := _codigoPedido;

        qryGeral.ExecSQL();
        qryGeral.Transaction.CommitRetaining();
      end;

      memManequim.Next;
    end;
  end
  else if _Finalidade = tfmProduto then
  begin
    memManequimProduto.First;
    while not memManequimProduto.Eof do
    begin
      if (memManequimProdutovalor.AsFloat > 0) or (memManequimProdutovalorfinal.AsFloat > 0) then
      begin

        qryGeral.SQL.Text := 'insert into TABPRODUTOMANEQUIM values (:codigo,:codmanequim,:valor, :valorfinal)';
        qryGeral.ParamByName('codigo').AsInteger := _codigo;
        qryGeral.ParamByName('codmanequim').AsInteger := memManequimProdutocodigo.AsInteger;
        qryGeral.ParamByName('valor').AsFloat := memManequimProdutovalor.AsFloat;
        qryGeral.ParamByName('valorfinal').AsFloat := memManequimProdutovalorfinal.AsFloat;

        qryGeral.ExecSQL();
        qryGeral.Transaction.CommitRetaining();

      end;

      memManequimProduto.Next;
    end;

  end;

  close;
end;

procedure Tinserir_manequim.btn_sairClick(Sender: TObject);
begin
  ok := False;
  close;
end;

procedure Tinserir_manequim.cmbManequim1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btn_ok.Click;
end;

procedure Tinserir_manequim.FormShow(Sender: TObject);
var
  i: Integer;
begin
  TOP := 175;
  LEFT := 185;
  bIniciando := True;

  if _Finalidade in [tfmPerfil,tfmPedidoAgenda] then
  begin
    grdManequimProduto.Visible := False;
    grdManequim.Visible := True;
    try
      memManequim.Close;
      memManequim.Open;
      memManequim.EmptyTable;

      qryGeral.SQL.Text := 'Select m.codigo, m.descricao, '#13+
                           '   (Select pm.valor '#13+
                           '      from tabpessomanequim pm '#13+
                           '     where pm.codigotipomanequim = m.codigo '#13+
                           //'       and pm.codigopedido = '+IntToStr(_CodigoPedido)+#13+
                           '       and pm.codigoperfil = '+IntToStr(_Codigo)+' ) as Valor '#13+
                           ' from tabtipomanequim m '#13+
                           ' where M.aplicacao in (2,3) '#13+
                           ' order by m.descricao ';

      qryGeral.Open;

      qryGeral.First;
      while not qryGeral.Eof do
      begin

        memManequim.Append();
        memManequimcodigo.AsInteger   := qryGeral.FieldByName('codigo').AsInteger;
        memManequimdescricao.AsString := qryGeral.FieldByName('descricao').AsString;
        memManequimvalor.AsFloat      := qryGeral.FieldByName('Valor').AsFloat;
        memManequim.Post;

        qryGeral.Next;

      end;

    except
      application.MessageBox('Erro ao abrir consulta com banco de dados de Perfis','ERRO',mb_OK+MB_ICONERROR);
    end;
  end
  else if _Finalidade = tfmProduto then
  begin
    grdManequim.Visible := False;
    grdManequimProduto.Visible := True;
    try
      memManequimProduto.Close;
      memManequimProduto.Open;
      memManequimProduto.EmptyTable;

      qryGeral.SQL.Text := 'Select m.codigo, m.descricao, '#13+
                           '   (Select pm.valorinicial '#13+
                           '      from TABPRODUTOMANEQUIM pm '#13+
                           '     where pm.codigotipomanequim = m.codigo '#13+
                           '       and pm.codigoproduto = '+IntToStr(_Codigo)+' ) as valorinicial, '#13+
                           '   (Select  pm.valorfinal '#13+
                           '      from TABPRODUTOMANEQUIM pm '#13+
                           '     where pm.codigotipomanequim = m.codigo '#13+
                           '       and pm.codigoproduto = '+IntToStr(_Codigo)+' ) as Valorfinal '#13+
                           ' from tabtipomanequim m '#13+
                           ' where M.aplicacao in (1,3) '#13+
                           ' order by m.descricao ';

      qryGeral.Open;

      qryGeral.First;
      while not qryGeral.Eof do
      begin

        memManequimProduto.Append();
        memManequimProdutocodigo.AsInteger   := qryGeral.FieldByName('codigo').AsInteger;
        memManequimProdutodescricao.AsString := qryGeral.FieldByName('descricao').AsString;
        memManequimProdutovalor.AsFloat      := qryGeral.FieldByName('valorinicial').AsFloat;
        memManequimProdutovalorfinal.AsFloat := qryGeral.FieldByName('Valorfinal').AsFloat;
        memManequimProduto.Post;

        qryGeral.Next;

      end;

    except
      application.MessageBox('Erro ao abrir consulta com banco de dados de Produto','ERRO',mb_OK+MB_ICONERROR);
    end;
  end;

  qryValorPadrao.Close;
  qryValorPadrao.Open;

  bIniciando := False;
end;

procedure Tinserir_manequim.memManequimAfterScroll(DataSet: TDataSet);
begin
  qryValorPadrao.Close;
  qryValorPadrao.Open;
end;

procedure Tinserir_manequim.memManequimBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure Tinserir_manequim.memManequimBeforeInsert(DataSet: TDataSet);
begin
  if not bIniciando then
    Abort;
end;

procedure Tinserir_manequim.memManequimProdutoAfterScroll(DataSet: TDataSet);
begin
  qryValorPadrao.Close;
  qryValorPadrao.Open;
end;

procedure Tinserir_manequim.qryValorPadraoBeforeOpen(DataSet: TDataSet);
var
  Codigo : String;
begin
  if _Finalidade in [tfmPerfil,tfmPedidoAgenda] then
    Codigo := memManequimcodigo.Text
  else
    Codigo := memManequimProdutocodigo.Text;

  qryValorPadrao.SQL.Strings[qryValorPadrao.SQL.IndexOf('--AND')+1] := 'AND CODIGOTIPOMANEQUIM = 0'+Codigo;

end;

procedure Tinserir_manequim.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryGeral.Close;
end;

procedure Tinserir_manequim.FormCreate(Sender: TObject);
begin
  Caption := CaptionTela(cCaption);
end;

end.
