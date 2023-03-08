unit Tanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Datasnap.DBClient, Datasnap.Provider,
  Data.DB, Data.Win.ADODB, ControllerTanque, Vcl.Mask, JvExMask, JvToolEdit,
  JvBaseEdits;

type
  TfrmTanque = class(TForm)
    Image1: TImage;
    pbTanque: TProgressBar;
    cbTanque: TDBLookupComboBox;
    btSalvar: TButton;
    btSair: TButton;
    dsTanque: TDataSource;
    qryTanque: TADOQuery;
    dspTanque: TDataSetProvider;
    cdTanque: TClientDataSet;
    lbTanque: TLabel;
    edtQtdLitros: TJvCalcEdit;
    Label4: TLabel;
    qryTanqueID_Tanque: TAutoIncField;
    qryTanqueTanque: TStringField;
    qryTanqueLitroRestante: TBCDField;
    qryTanqueTotalLitro: TBCDField;
    cdTanqueID_Tanque: TAutoIncField;
    cdTanqueTanque: TStringField;
    cdTanqueLitroRestante: TBCDField;
    cdTanqueTotalLitro: TBCDField;
    procedure cbTanqueClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
  private
    { Private declarations }
    ID_Tanque:String;
    FControllerTanque : TfrmControllerTanque;
    procedure PreencheTela;
    function Validar:boolean;
  public
    { Public declarations }
    ID_Posto:string;
  end;

var
  frmTanque: TfrmTanque;

implementation

{$R *.dfm}

{ TfrmTanque }

procedure TfrmTanque.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTanque.btSalvarClick(Sender: TObject);
var
  sLitro:string;
begin
  if not Validar then
    exit;
  sLitro := StringReplace(StringReplace(edtQtdLitros.Text, '.', '', [rfReplaceAll]),',','.',[rfReplaceAll]);
  FControllerTanque.SalvarAbastecimento(ID_Posto, ID_Tanque, sLitro);
  MessageDlg('Abastecimento gravado com sucesso!', mtWarning,[mbOk], 0, mbOk);
  Close;
end;

procedure TfrmTanque.cbTanqueClick(Sender: TObject);
begin
  PreencheTela;
end;

procedure TfrmTanque.FormDestroy(Sender: TObject);
begin
  FControllerTanque.Free;
end;

procedure TfrmTanque.FormShow(Sender: TObject);
begin
  qryTanque.Close;
  qryTanque.Parameters.ParamByName('ID_Posto').Value := StrToInt(ID_Posto);
  qryTanque.Open;
  cdTanque.Close;
  cdTanque.Open;
  FControllerTanque := TfrmControllerTanque.Create(FControllerTanque);
  FControllerTanque.Visible := False;
end;

procedure TfrmTanque.PreencheTela;
begin
  pbTanque.Max := cdTanque.FieldByName('TotalLitro').Value;
  pbTanque.Position := cdTanque.FieldByName('LitroRestante').Value;
  lbTanque.Caption := 'Litros no Tanque: ' + cdTanque.FieldByName('LitroRestante').AsString
                       + ' de ' + cdTanque.FieldByName('TotalLitro').AsString;
  ID_Tanque := cdTanque.FieldByName('ID_Tanque').AsString;
end;

function TfrmTanque.Validar: boolean;
Var
  Valida:Boolean;
begin
  Valida := True;
  if edtQtdLitros.Text = '' then
  begin
    MessageDlg('Necessário escolher quantidade de litros!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  if edtQtdLitros.value + cdTanque.FieldByName('LitroRestante').Value >
     cdTanque.FieldByName('TotalLitro').Value then
  begin
    MessageDlg('Quantidade de litros ultrapassou a quantidade total do reservatório!', mtWarning,[mbOk], 0, mbOk);
    Valida := False;
  end;
  Result := Valida;
end;

end.
