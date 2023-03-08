unit Pix;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, QRCodeAPIGoogle, StrUtils;

type
  TFPix = class(TForm)
    GroupBox18: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    vNomePix: TEdit;
    vChavePix: TEdit;
    vPix: TEdit;
    vValorPIX: TEdit;
    vCidadePix: TEdit;
    ckTelPix: TCheckBox;
    GroupBox17: TGroupBox;
    QRCodePix: TImage;
    Button1: TButton;
  private
    { Private declarations }
  public
    function GerarPIX(chave: string; telefone: boolean; valor: string; cidade: string; nome: string): string;
    function CalculaCRC16(chave: string): string;
    function Crc16(texto: string; Polynom: WORD = $1021; Seed: WORD = $FFFF): WORD;
  end;

var
  FPix: TFPix;

implementation

{$R *.dfm}

function TFPix.GerarPIX(chave: string; telefone: boolean; valor: string; cidade: string; nome: string): string;
var
  v00: string;
  v26: string;
  v52: string;
  v53: string;
  v54: string;
  v58: string;
  v59: string;
  v60: string;
  v62: string;
  v63: string;

  auxTel: string;

  FGoogleQRCode: TFQRCodeAPIGoogle;
  vResp: string;
begin
  vResp:='';
  try
    // TratandoCampos
    // 00 - Payload Format
    v00:='000201';

    // 26 - Merchant Acount (contem a chave)
    if telefone=true then     // Trata se For telefone
      v26:='+55'+trim(chave)
    else
      v26:=trim(chave);

    v26:='01'+IntTOStr(length(trim(v26)))+v26;  // Chave

    v26:='0014BR.GOV.BCB.PIX'+v26;
    v26:='26'+IntTOStr(Length(v26))+v26;

    // 52 - Merchant Category Code
    v52:='52040000';

    // 53 - Transaction Currency (Moeda Local)
    v53:='5303986';   // Codigo do REAL R$

    // 54 - Valor
    v54:=FormatFloat( '#,##0.00; (#,##0.00)' , StrToFloat(valor));
    v54:=StringReplace(v54, '.', '@', [rfReplaceAll, rfIgnoreCase]);
    v54:=StringReplace(v54, ',', '.', [rfReplaceAll, rfIgnoreCase]);
    v54:=StringReplace(v54, '@', ',', [rfReplaceAll, rfIgnoreCase]);

    if leftStr(RIghtStr(v54,3),1)=',' then
    begin
      v54:=StringReplace(v54, ',', '@', [rfReplaceAll, rfIgnoreCase]);
      v54:=StringReplace(v54, '.', ',', [rfReplaceAll, rfIgnoreCase]);
      v54:=StringReplace(v54, '@', '.', [rfReplaceAll, rfIgnoreCase]);
    end;

    v54:='540'+IntToStr(Length(v54))+v54;

    // 58 - Country
    v58:='5802BR';     // Brasil

    // 59 - Merchant Name
    v59:='59'+IntTOStr(Length(trim(leftStr(nome,25))))+trim(leftStr(nome,25));

    // 60 - City
    v60:='600'+IntTOStr(Length(trim(cidade)))+trim(cidade);

    // 62 - Additional Data Field Template
    v62:='62070503***';

    // 63 - CRC16
    v63:='6304';

    // Preenche Campo com todos os dados Pix para Gerar o CRC16
    vPix.Text:=CalculaCRC16(v00+v26+v52+v53+v54+v58+v59+v60+v62+v63);

    // Pix tem q ser gerado QRCode com API do Google, a local ignora os "0 - Zeros"
    // e Gera Codigo Errado.
    try
      FGoogleQRCode:=TFQRCodeAPIGoogle.Create(nil);
      FGoogleQRCode.GeraQRCode(vPix.Text);
    finally
      QRCodePix.Picture:=FGoogleQRCode.ImageQRCode.Picture;
      FGoogleQRCode.Free;
    end;

  finally
    vResp:=vPix.Text;
  end;

  result:=vResp;
end;

function TFPix.CalculaCRC16(chave: string): string;
var
  valorHex: string;
begin
  valorHex:=IntTOHex(Crc16(chave, $1021, $FFFF));
  result:=trim(chave)+valorHex;
end;

// Função usada para Validar e Construir Informações de QRCode Usada no "PIX"
function TFPix.Crc16(texto: string; Polynom: WORD = $1021; Seed: WORD = $FFFF): WORD;
var
  i, j: Integer;
begin
  Result := Seed;
  for i := 1 to length(texto) do
  begin
    Result := Result xor (ord(texto[i]) shl 8);
    for j := 0 to 7 do
    begin
      if (Result and $8000) <> 0 then
        Result := (Result shl 1) xor Polynom
      else
        Result := Result shl 1;
    end;
  end;
  Result := Result and $FFFF;
end;

end.
