unit DaoTanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Conexao, Data.DB, Data.Win.ADODB;

type
  TfrmDaoTanque = class(TForm)
    qryAcao: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SalvarAbastecimento(sID_Posto, sID_Tanque, sLitro:String);
  end;

var
  frmDaoTanque: TfrmDaoTanque;

implementation

{$R *.dfm}

{ TfrmDaoTanque }

procedure TfrmDaoTanque.SalvarAbastecimento(sID_Posto, sID_Tanque, sLitro:String);
begin
  qryAcao.Close;
  qryAcao.SQL.Text := '';
  qryAcao.SQL.Text := 'Update Tanque Set LitroRestante = LitroRestante + ' + sLitro;
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' Where ID_Tanque = ' + sID_Tanque;
  qryAcao.SQL.Text := qryAcao.SQL.Text + ' And ID_Posto = ' + sID_Posto;
  qryAcao.ExecSQL;
end;

end.
