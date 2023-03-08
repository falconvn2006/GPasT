unit Abastecer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Mask, JvExMask, JvToolEdit,
  JvBaseEdits, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Conexao,
  Data.DB, Data.Win.ADODB, Datasnap.DBClient, Datasnap.Provider,
  Vcl.Imaging.pngimage, ControllerAbastecer, JvMaskEdit, JvCheckedMaskEdit,
  JvDatePickerEdit, JvDBDatePickerEdit;

type
  TfrmAbastecer = class(TForm)
    pnAbastecer: TPanel;
    edtValor: TJvCalcEdit;
    pbTanque: TProgressBar;
    edtQtdLitros: TJvCalcEdit;
    edtValorAbastecimento: TJvCalcEdit;
    edtValorImposto: TJvCalcEdit;
    edtValorTotal: TJvCalcEdit;
    Label1: TLabel;
    Image1: TImage;
    btSalvar: TButton;
    btSair: TButton;
    qryBomba: TADOQuery;
    cdBomba: TClientDataSet;
    dsBomba: TDataSource;
    dspBomba: TDataSetProvider;
    cbBombas: TDBLookupComboBox;
    qryBombaID_Bomba: TAutoIncField;
    qryBombaBomba: TStringField;
    qryBombaTotalLitro: TBCDField;
    qryBombaLitroRestante: TBCDField;
    qryBombaValor: TBCDField;
    qryBombaPercentual: TIntegerField;
    cdBombaID_Bomba: TAutoIncField;
    cdBombaBomba: TStringField;
    cdBombaTotalLitro: TBCDField;
    cdBombaLitroRestante: TBCDField;
    cdBombaValor: TBCDField;
    cdBombaPercentual: TIntegerField;
    Valor: TLabel;
    edtImposto: TJvCalcEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbTanque: TLabel;
    edtData: TJvDBDatePickerEdit;
    Label8: TLabel;
    qryBombaID_Tanque: TAutoIncField;
    cdBombaID_Tanque: TAutoIncField;
    procedure cbBombasClick(Sender: TObject);
    procedure edtQtdLitrosExit(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure edtQtdLitrosChange(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FControllerAbastecimento :TfrmControllerAbastecer;
    procedure PreencheTela;
    function ValidarAbastecimento:Boolean;
  public
    { Public declarations }
    ID_Posto, ID_Tanque:string;
  end;

var
  frmAbastecer: TfrmAbastecer;

implementation

{$R *.dfm}

procedure TfrmAbastecer.btSalvarClick(Sender: TObject);
Var
  sData,sValorLitro, sValorImposto, sValor:string;
begin
  if not ValidarAbastecimento then
    Exit;
  if edtData.Text <> '' then
  sData := FormatDateTime('yyyy-mm-dd', edtData.Date);
  sValorLitro := StringReplace(StringReplace(edtValorAbastecimento.Text, '.', '', [rfReplaceAll]),',','.',[rfReplaceAll]);
  sValorImposto := StringReplace(StringReplace(edtValorImposto.Text, '.', '', [rfReplaceAll]),',','.',[rfReplaceAll]);
  sValor := StringReplace(StringReplace(edtValorTotal.Text, '.', '', [rfReplaceAll]),',','.',[rfReplaceAll]);
  if edtQtdLitros.Value > pbTanque.Position then
    MessageDlg('Quantidade de litros maior que a quantidade no tanque!', mtWarning,[mbOk], 0, mbOk)
  else
  begin
    FControllerAbastecimento.SalvarAbastecimento(ID_Posto, IntToStr(cbBombas.KeyValue),
                                                 edtQtdLitros.Text, sValorLitro, sValorImposto,
                                                 sValor, sData, ID_Tanque);
    MessageDlg('Abastecimento gravado com sucesso!', mtInformation,[mbOk], 0, mbOk);
    Close;
  end;
end;

procedure TfrmAbastecer.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbastecer.cbBombasClick(Sender: TObject);
begin
  PreencheTela;
end;

procedure TfrmAbastecer.edtQtdLitrosChange(Sender: TObject);
begin
  edtValorAbastecimento.Value := edtQtdLitros.Value * edtValor.Value;
  edtValorImposto.Value := (edtValorAbastecimento.Value * edtImposto.Value) / 100;
  edtValorTotal.Value := edtValorAbastecimento.Value + edtValorImposto.Value;
end;

procedure TfrmAbastecer.edtQtdLitrosExit(Sender: TObject);
begin
//  edtValorAbastecimento.Value := edtQtdLitros.Value * edtValor.Value;
//  edtValorImposto.Value := (edtValorAbastecimento.Value * edtImposto.Value) / 100;
//  edtValorTotal.Value := edtValorAbastecimento.Value + edtValorImposto.Value;
end;

procedure TfrmAbastecer.FormDestroy(Sender: TObject);
begin
  FControllerAbastecimento.Free;
end;

procedure TfrmAbastecer.FormShow(Sender: TObject);
begin
  qryBomba.Close;
  qryBomba.Parameters.ParamByName('ID_Posto').Value := StrToInt(ID_Posto);
  qryBomba.Open;
  cdBomba.Close;
  cdBomba.Open;
  FControllerAbastecimento := TfrmControllerAbastecer.Create(FControllerAbastecimento);
  FControllerAbastecimento.Visible := False;
end;

procedure TfrmAbastecer.PreencheTela;
begin
  edtValor.Value := cdBomba.FieldByName('Valor').Value;
  edtImposto.Value := cdBomba.FieldByName('Percentual').Value;
  pbTanque.Max := cdBomba.FieldByName('TotalLitro').Value;
  pbTanque.Position := cdBomba.FieldByName('LitroRestante').Value;
  lbTanque.Caption := 'Litros no Tanque: ' + cdBomba.FieldByName('LitroRestante').AsString
                    + ' de ' + cdBomba.FieldByName('TotalLitro').AsString;
  ID_Tanque := cdBomba.FieldByName('ID_Tanque').AsString;
end;

function TfrmAbastecer.ValidarAbastecimento: Boolean;
Var
  Valida:Boolean;
begin
  Valida := True;
  if edtData.Text = '' then
  begin
    MessageDlg('Necessário escolher uma data!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  if edtQtdLitros.Text = '' then
  begin
    MessageDlg('Necessário escolher quantidade de litros abastecido!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  if edtQtdLitros.Value > pbTanque.Position then
  begin
    MessageDlg('Quantidade de litros maior que quantidade de litros no reservatório!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  Result := Valida;
end;

end.
