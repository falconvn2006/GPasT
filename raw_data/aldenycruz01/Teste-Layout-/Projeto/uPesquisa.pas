unit uPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TfPesquisa = class(TForm)
    Panel1: TPanel;
    edtPesquisa: TEdit;
    btnPesquisar: TBitBtn;
    btnContato: TBitBtn;
    Label1: TLabel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    dsPesquisarContato: TDataSource;
    fdPesquisarContato: TFDQuery;
    fdPesquisarContatonome: TWideStringField;
    fdPesquisarContatodata_nasc: TDateField;
    fdPesquisarContatoprofissao: TWideStringField;
    fdPesquisarContatoendereco: TWideStringField;
    fdPesquisarContatonum_end: TIntegerField;
    fdPesquisarContatocep: TWideStringField;
    fdPesquisarContatobairro: TWideStringField;
    fdPesquisarContatouf: TWideStringField;
    fdPesquisarContatocidade: TWideStringField;
    fdPesquisarContatotelefone: TWideStringField;
    fdPesquisarContatocelular: TWideStringField;
    fdPesquisarContatoemail: TWideStringField;
    fdPesquisarContatoemail2: TWideStringField;
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnContatoClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }

    procedure carregarDados;
  public
    { Public declarations }
  end;

var
  fPesquisa: TfPesquisa;

implementation

{$R *.dfm}

uses uDM, uCadastro;

procedure TfPesquisa.btnContatoClick(Sender: TObject);
begin
  if DBGrid1.Columns[0].Field.AsString='' then
     raise Exception.Create('Selecione o Cliente')
  else
  begin

  carregarDados;
  fCadastro.ShowModal;

  end;
end;

procedure TfPesquisa.btnPesquisarClick(Sender: TObject);
begin
 if edtPesquisa.Text<>'' then
 begin
   fdPesquisarContato.Close;
   fdPesquisarContato.SQL.Clear;
   fdPesquisarContato.SQL.Add('SELECT * FROM contato WHERE nome LIKE ''%'+edtPesquisa.Text+'%'' ');
   fdPesquisarContato.Open;
 end
 else
 begin
   fdPesquisarContato.Close;
   fdPesquisarContato.SQL.Clear;
   fdPesquisarContato.SQL.Add('SELECT * FROM contato  ');
   fdPesquisarContato.Open;
 end;
end;

procedure TfPesquisa.carregarDados;
begin
    fCadastro.edtNome.Text:=DBGrid1.Columns[0].Field.AsString;
    fCadastro.dtpNasc.Date:=DBGrid1.Columns[1].Field.value;
    fCadastro.edtProfissao.Text:=DBGrid1.Columns[2].Field.AsString;
    fCadastro.edtEndereco.Text:=DBGrid1.Columns[3].Field.AsString;
    fCadastro.edtNumero.Text:=DBGrid1.Columns[4].Field.value;
    fCadastro.edtBairro.Text:=DBGrid1.Columns[6].Field.AsString;
    fCadastro.edtCidade.Text:=DBGrid1.Columns[8].Field.AsString;
    fCadastro.msCep.Text:=DBGrid1.Columns[5].Field.value;
    fCadastro.cbEstado.Text:=DBGrid1.Columns[7].Field.AsString;
    fCadastro.msTelefone.Text:=DBGrid1.Columns[9].Field.value;
    fCadastro.msCelular.Text:=DBGrid1.Columns[10].Field.value;
    fCadastro.edtEmail.Text:=DBGrid1.Columns[11].Field.AsString;
    fCadastro.edtEmail2.Text:=DBGrid1.Columns[12].Field.AsString;

    fCadastro.label9.Visible:=true;
    fCadastro.msCelular.Visible:=true;
    fCadastro.Label11.Visible:=true;
    fCadastro.edtEmail2.Visible:=true;

    fCadastro.cbEmail.Visible:=false;
    fCadastro.cbTelefone.Visible:=false;

    fCadastro.btnSalvar.Visible:=false;

end;

procedure TfPesquisa.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
 with DBGrid1 do
    begin
      if Odd( DataSource.DataSet.RecNo) then
        Canvas.Brush.Color := clGradientInactiveCaption
      else
        Canvas.Brush.Color := clWindow;

      Canvas.FillRect(Rect);
      DefaultDrawColumnCell(Rect,DataCol,Column,State);
    end;
end;

procedure TfPesquisa.FormShow(Sender: TObject);
begin
fdPesquisarContato.Open;
end;

end.
