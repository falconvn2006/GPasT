unit DaoAbastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Conexao, Data.DB, Data.Win.ADODB;

type
  TfrmDaoAbastecimento = class(TForm)
    qryAcao: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SalvarAbastecimento(sID_Posto, sID_Bomba, sLitro, sValorLitro, sValorImposto, sValor, sData, sID_Tanque:String);
  end;

var
  frmDaoAbastecimento: TfrmDaoAbastecimento;

implementation

{$R *.dfm}

{ TfrmDaoAbastecimento }

procedure TfrmDaoAbastecimento.SalvarAbastecimento(sID_Posto, sID_Bomba, sLitro,
  sValorLitro, sValorImposto, sValor, sData, sID_Tanque: String);
begin
  qryAcao.Close;
  qryAcao.SQL.Text := '';
  qryAcao.SQL.Text := 'Insert Into Abastecimento(ID_Posto,ID_Bomba,Litro,ValorLitro,ValorImposto,Valor,Data) ';
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' Values (' + sID_Posto + ',';
  qryAcao.SQL.Text := qryAcao.SQL.Text + sID_Bomba + ',' + sLitro + ',';
  qryAcao.SQL.Text := qryAcao.SQL.Text + sValorLitro + ',' + sValorImposto + ',';
  qryAcao.SQL.Text := qryAcao.SQL.Text + sValor + ',''' + sData + ''')';
  qryAcao.ExecSQL;

  qryAcao.Close;
  qryAcao.SQL.Text := '';
  qryAcao.SQL.Text := 'Update Tanque ';
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' Set LitroRestante = LitroRestante - ' + sLitro;
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' Where ID_Tanque = ' + sID_Tanque;
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' AND ID_Posto = ' + sID_Posto;
  qryAcao.ExecSQL;
end;

end.
