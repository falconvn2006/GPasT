unit Relatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit, JvMaskEdit, JvCheckedMaskEdit, JvDatePickerEdit, Conexao,
  JvDBDatePickerEdit, Vcl.Grids, Vcl.DBGrids, Data.DB, Data.Win.ADODB,
  Vcl.ComCtrls, JvExComCtrls, JvDateTimePicker, JvDBDateTimePicker;

type
  TfrmRelatorio = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    GroupBox1: TGroupBox;
    edtInicio: TJvDBDatePickerEdit;
    edtFim: TJvDBDatePickerEdit;
    Label1: TLabel;
    Label2: TLabel;
    btOk: TButton;
    btSair: TButton;
    qryRelDia: TADOQuery;
    qrySoma: TADOQuery;
    dsRelDia: TDataSource;
    dsSoma: TDataSource;
    qryRelDiaData: TStringField;
    qryRelDiaTanque: TStringField;
    qryRelDiaBomba: TStringField;
    qryRelDiaValor: TStringField;
    qrySomaTanque: TStringField;
    qrySomaBomba: TStringField;
    qrySomaValorTotal: TStringField;
    procedure btSairClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
    procedure Relatorio;
    procedure RelDia(dInicio, dFim : String);
    procedure RelSoma(dInicio, dFim : String);
    function ValidarPesquisa:Boolean;
  public
    { Public declarations }
  end;

var
  frmRelatorio: TfrmRelatorio;

implementation

{$R *.dfm}

procedure TfrmRelatorio.btOkClick(Sender: TObject);
begin
  if not ValidarPesquisa then
  begin
    exit;
  end;
  Relatorio;

//  sPeriodo := ''''+ sInicio + ''' And ''' + sFim + '''';
//  StringReplace(qryRelDia.SQL.Text, '.', sPeriodo, [rfReplaceAll]);
end;

procedure TfrmRelatorio.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRelatorio.Relatorio;
var
  sInicio, sFim:String;
begin
  sInicio := FormatDateTime('yyyy-mm-dd', edtInicio.Date);
  sFim := FormatDateTime('yyyy-mm-dd', edtFim.Date);
  RelDia(sInicio,sFim);
  RelSoma(sInicio,sFim);
//  qryRelDia.Close;
//  qryRelDia.Parameters.ParamByName('Inicio').Value := ini.DateTime;
//  qryRelDia.Parameters.ParamByName('Fim').Value := fim.DateTime;
//  qryRelDia.Open;
//  qrySoma.Close;
//  qrySoma.Parameters.ParamByName('Inicio').Value := ini.DateTime;
//  qrySoma.Parameters.ParamByName('Fim').Value := fim.DateTime;
//  qrySoma.Open;
end;

procedure TfrmRelatorio.RelDia(dInicio, dFim : String);
begin
  qryRelDia.Close;
  qryRelDia.SQL.Text := '';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Select CONVERT(VarChar(10), Data, 103) Data, ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + '''Tanque ''+Ltrim(Rtrim(CONVERT(VarChar(3),T.ID_Tanque))) + '' - '' + C.Nome Tanque, ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + '''Bomba ''+Ltrim(Rtrim(CONVERT(VarChar(3),B.ID_Bomba))) Bomba, ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + '''R$ ''+ ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'REPLACE( ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + ' replace( ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + ' replace(convert(varchar, cast(Valor as money), 1),'','','';'') ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + ' ,''.'','','') ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + ' ,'';'',''.'') Valor ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'From Abastecimento A ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Join Bomba B ON A.ID_Bomba = B.ID_Bomba ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Join Tanque T ON B.ID_Tanque = T.ID_Tanque ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Join Combustivel C On T.ID_Combustivel = C.ID_Combustivel ';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Where Data Between '''+ dInicio +''' And '''+ dFim +'''';
  qryRelDia.SQL.Text := qryRelDia.SQL.Text + 'Order By YEAR(Data), MONTH(Data), DAY(Data), T.ID_Tanque, B.ID_Bomba ';
  qryRelDia.Open;
end;

procedure TfrmRelatorio.RelSoma(dInicio, dFim : String);
begin
  qrySoma.Close;
  qrySoma.SQL.Text := '';
  qrySoma.SQL.Text := 'Select Ltrim(Rtrim(CONVERT(VarChar(3),T.ID_Tanque))) + '' - '' + C.Nome Tanque, ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  '''Bomba ''+Ltrim(Rtrim(CONVERT(VarChar(3),B.ID_Bomba))) Bomba, ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  '''R$ ''+ ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'REPLACE( ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' replace( ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' replace(convert(varchar, cast(Sum(Valor) as money), 1),'','','';'') ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' ,''.'','','') ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' ,'';'',''.'') ValorTotal ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'From Abastecimento A ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Join Bomba B ON A.ID_Bomba = B.ID_Bomba ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Join Tanque T ON B.ID_Tanque = T.ID_Tanque ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Join Combustivel C On T.ID_Combustivel = C.ID_Combustivel ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Where Data Between'''+ dInicio +''' And '''+ dFim +'''';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Group By T.ID_Tanque, C.Nome, B.ID_Bomba ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Union All ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Select ''Total'' Tanque, ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  '''-'' Bomba, ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  '''R$ ''+ ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'REPLACE( ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' replace( ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' replace(convert(varchar, cast(Sum(Valor) as money), 1),'','','';'') ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' ,''.'','','') ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  ' ,'';'',''.'') ValorTotal ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'From Abastecimento ';
  qrySoma.SQL.Text := qrySoma.SQL.Text +  'Where Data Between'''+ dInicio +''' And '''+ dFim +'''';
  qrySoma.Open;
end;

function TfrmRelatorio.ValidarPesquisa: Boolean;
Var
  Valida:Boolean;
begin
  Valida := True;
  if (edtInicio.Text = '') or (edtFim.Text = '') then
  begin
    MessageDlg('Necessário escolher uma data!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  Result := Valida;
end;

end.
