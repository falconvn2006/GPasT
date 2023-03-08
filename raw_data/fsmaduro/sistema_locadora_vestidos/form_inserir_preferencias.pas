unit form_inserir_preferencias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, CheckLst;

type TPreferencia = record
  Codigo: Integer;
  Nome: String;
  Selecionado: Boolean;
end;

type TTipoFinalidadePreferencia = (tfpPerfil, tfpProduto, tfpPedidoAgenda);

//type TTipoPreferencia = (tpPeca,tpModelo,tpMarca,tpEstilo,tpCor,tpExigencia,tpComplemento);

type
  Tinserir_preferencias = class(TForm)
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    qryGeral: TIBQuery;
    clbPreferncias: TCheckListBox;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_okClick(Sender: TObject);
    procedure clbPrefernciasKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    arrPreferencias : Array Of TPreferencia;
    { Private declarations }
  public
    ok: Boolean;
    FormChamado : Tform;
    _Finalidade : TTipoFinalidadePreferencia;
    _codigo : Integer;
    _codigoPedido, _id : Integer;
    _Tipo : Integer;
    { Public declarations }
  end;

var
  inserir_preferencias: Tinserir_preferencias;

implementation

uses funcao, untDados;

Const
  cCaption = 'DEFINIR PREFERENCIAS';

{$R *.dfm}

procedure Tinserir_preferencias.btn_okClick(Sender: TObject);
var
  i: Integer;
begin

  if _Finalidade = tfpPerfil then
    qryGeral.SQL.Text := 'Delete from tabpreferenciaspessoas where codigopessoa = '+IntToStr(_codigo)+' and Tipo = '+intToStr(_Tipo)
  else if _Finalidade = tfpPedidoAgenda then
    qryGeral.SQL.Text := 'Delete from tabpreferenciaspessoas where codigopessoa = '+IntToStr(_codigo)+' and codigopedido = '+IntToStr(_codigoPedido)+' and Tipo = '+intToStr(_Tipo) + ' and id ='+intToStr(_id)
  else if _Finalidade = tfpProduto then
    qryGeral.SQL.Text := 'Delete from TABPREFERENCIASPRODUTO where codigoproduto = '+IntToStr(_codigo)+' and Tipo = '+intToStr(_Tipo);

  qryGeral.ExecSQL();
  qryGeral.Transaction.CommitRetaining();

  for i := 0 to clbPreferncias.Items.Count - 1 do
  begin

    if clbPreferncias.Checked[i] then
    begin

      if _Finalidade in [tfpPerfil,tfpPedidoAgenda] then
        qryGeral.SQL.Text := 'insert into tabpreferenciaspessoas values ('+IntToStr(_codigo)+','+IntToStr(arrPreferencias[i].Codigo)+','+
                                                                           intToStr(_Tipo)+','+intToStr(_codigoPedido)+','+intToStr(_id)+')'
      else if _Finalidade = tfpProduto then
        qryGeral.SQL.Text := 'insert into TABPREFERENCIASPRODUTO values ('+IntToStr(_codigo)+','+IntToStr(arrPreferencias[i].Codigo)+','+intToStr(_Tipo)+')';


      qryGeral.ExecSQL();
      qryGeral.Transaction.CommitRetaining();

    end;
    
  end;

  close;
end;

procedure Tinserir_preferencias.btn_sairClick(Sender: TObject);
begin
  ok := False;
  close;
end;

procedure Tinserir_preferencias.clbPrefernciasKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btn_ok.Click;
end;

procedure Tinserir_preferencias.FormShow(Sender: TObject);
var
  i: Integer;
begin
  TOP := 175;
  LEFT := 185;
  try
    clbPreferncias.Clear;
    clbPreferncias.ClearSelection;

    if _Finalidade = tfpPerfil then
    begin
      qryGeral.SQL.Text := 'Select p.codigo, p.descricao, '#13+
                           '   Case when Exists(Select *  '#13+
                           '                      from tabpreferenciaspessoas pp '#13+
                           '                     where pp.codigopreferencia = p.codigo  '#13+
                           '                       and pp.codigopessoa = '+IntToStr(_Codigo)+' ) then 1 else 0 end as checked '#13+
                           ' from tabpreferencias p '#13+
                           ' where p.tipo = '+IntToStr(_Tipo)+#13+
                           ' order by p.descricao ';
    end
    else if _Finalidade = tfpPedidoAgenda then
    begin
      qryGeral.SQL.Text := 'Select p.codigo, p.descricao, '#13+
                           '   Case when Exists(Select *  '#13+
                           '                      from tabpreferenciaspessoas pp '#13+
                           '                     where pp.codigopreferencia = p.codigo  '#13+
                           '                       and pp.codigopedido = '+IntToStr(_codigoPedido)+#13+
                           '                       and pp.codigopessoa = '+IntToStr(_Codigo)+#13+
                           '                       and pp.id ='+intToStr(_Id)+') then 1 else 0 end as checked '#13+
                           ' from tabpreferencias p '#13+
                           ' where p.tipo = '+IntToStr(_Tipo)+#13+
                           ' order by p.descricao ';
    end
    else if _Finalidade = tfpProduto then
    begin
      qryGeral.SQL.Text := 'Select p.codigo, p.descricao, '#13+
                           '   Case when Exists(Select *  '#13+
                           '                      from TABPREFERENCIASPRODUTO pp '#13+
                           '                     where pp.codigopreferencia = p.codigo  '#13+
                           '                       and pp.codigoproduto = '+IntToStr(_Codigo)+' ) then 1 else 0 end as checked '#13+
                           ' from tabpreferencias p '#13+
                           ' where p.tipo = '+IntToStr(_Tipo)+#13+
                           ' order by p.descricao ';
    end;
    qryGeral.Open;

    SetLength(arrPreferencias,0);
    qryGeral.First;
    while not qryGeral.Eof do
    begin

      SetLength(arrPreferencias,Length(arrPreferencias) + 1);
      i := clbPreferncias.Items.Add(qryGeral.FieldByName('descricao').Text);

      if qryGeral.FieldByName('checked').AsInteger = 1 then
        clbPreferncias.Checked[i] := True;

      arrPreferencias[i].Codigo := qryGeral.FieldByName('codigo').AsInteger;
      arrPreferencias[i].Nome := qryGeral.FieldByName('descricao').Text;
      arrPreferencias[i].Selecionado := qryGeral.FieldByName('checked').AsInteger = 1;

      qryGeral.Next;

    end;


  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tinserir_preferencias.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryGeral.Close;
end;

procedure Tinserir_preferencias.FormCreate(Sender: TObject);
begin
  _id := 0;
  Caption := CaptionTela(cCaption);
end;

end.
