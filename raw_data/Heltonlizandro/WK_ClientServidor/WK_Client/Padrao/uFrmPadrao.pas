unit uFrmPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, JPEG, ppCtrls,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.Menus, Vcl.ComCtrls, Vcl.Buttons, RxToolEdit, RxCurrEdit;

type
  TBotao = (btInserir, btAlterar, btCancelar, btExcluir, btBrowser, btImprimir, btSair);

  TFrmPadrao = class(TForm)
    MemTable: TFDMemTable;
    procedure ApenasNumero(Sender: TObject; var Key: Char);
    procedure ApenasNumeroVirgula(Sender: TObject; var Key: Char);
    procedure ValidaNotaEdit(Sender: TObject);
    procedure MascaraExit(Sender: TObject);
    procedure MaxLengthZeroEsquerda(Sender: TObject; ObrigaZeroEsquerda : Boolean = False);

    procedure DoPositiveValidate(Sender: TObject); virtual;
    procedure DoPositiveValidateRequired(Sender: TObject); virtual;
    procedure DoRequiredValidate(Sender: TObject); virtual;
    function  Padl(Valor : String; Tam: Integer; Complemento : String): String;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ChangeEditFiltro(Sender: TObject);
  private
    { Private declarations }
    procedure Imagem(campo: TBlobField; Foto: TImage);
    { Private declarations }
  protected
    sTabSheetPadrao : TTabSheet;
  public
    { Public declarations }
    bShowOk : Boolean;
    Botao : TBotao;
    iCasasDecimais : String;
    procedure ppImagem(campo: TBlobField; foto: TppImage);
  end;

var
  FrmPadrao: TFrmPadrao;

const
  msgErroAdm = 'Entre entre em contato com o Administrador';
  ConstApenasNumero  = ['0','1','2','3','4','5','6','7','8','9',#13,#27,#8];                        //,#46 = .
  ConstNumeroVirgula = ['0','1','2','3','4','5','6','7','8','9',#13,#27,#8,','];


implementation

uses uFrmPrincipal, F_Funcao; //, uDM, uDM;

{$R *.dfm}

{ TFrmPadrao }

procedure TFrmPadrao.ApenasNumero(Sender: TObject; var Key: Char);
begin
  if not (key in ConstApenasNumero) then
    key := #0;
end;

procedure TFrmPadrao.ApenasNumeroVirgula(Sender: TObject; var Key: Char);
begin
  if not (key in ConstNumeroVirgula) then
//    TEdit(Sender).Text := TEdit(Sender).Text + FloatToStr(StrToFloatDef(TEdit(Sender).Text,0))
//  else
    key := #0;
end;

procedure TFrmPadrao.DoPositiveValidate(Sender: TObject);
var
  dValor : Double;
begin
  if Sender is TEdit then
  begin
    try
      dValor := StrToFloat(TEdit(Sender).Text);
    except
      TMens.Aviso('Valor Inválido', True, TEdit(Sender));
    end;
  end
  else
  if Sender is TRxCalcEdit then
  begin
    if TRxCalcEdit(Sender).Value < 0 then
      TMens.Aviso('Valor Inválido', True, TRxCalcEdit(Sender));
  end;
end;

procedure TFrmPadrao.DoPositiveValidateRequired(Sender: TObject);
begin
  DoRequiredValidate(Sender);
  DoPositiveValidate(Sender);
end;

procedure TFrmPadrao.DoRequiredValidate(Sender: TObject);
begin
  if Sender is TEdit then
  begin
    if Trim(TEdit(Sender).Text) = EmptyStr then
      TMens.Aviso('Campo Obrigatório.', True, TEdit(Sender));
  end
  else
  if Sender is TMemo then
  begin
    if Trim(TMemo(Sender).Lines.Text) = EmptyStr then
      TMens.Aviso('Campo Obrigatório.', True, TMemo(Sender));
  end
  else
  if Sender is TRxCalcEdit then
  begin
    if TRxCalcEdit(Sender).Value = 0 then
      TMens.Aviso('Campo Obrigatório.', True, TRxCalcEdit(Sender));
  end
  else
  if Sender is TDateEdit then
  begin
    if TDateEdit(Sender).Date = 0 then
      TMens.Aviso('Campo Obrigatório.', True, TDateEdit(Sender));
  end;
end;

procedure TFrmPadrao.ChangeEditFiltro(Sender: TObject);
var
  sLabel : String;
begin
  if TEdit(Sender).Text = EmptyStr then
  begin
    try
      TEdit(Sender).OnExit(Sender);
    except
    end;
//    sLabel := 'lb'+Copy(TEdit(Sender).Name, 4);
//    if FindComponent(sLabel) is TLabel then
//      TLabel(FindComponent(sLabel)).Caption := TLabel(FindComponent(sLabel)).Hint;
  end;
end;

procedure TFrmPadrao.FormCreate(Sender: TObject);
begin
  bShowOk := False;
end;

procedure TFrmPadrao.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmPadrao.Imagem(campo: TBlobField; Foto: TImage);
begin

end;

procedure TFrmPadrao.MascaraExit(Sender: TObject);
begin
  TEdit(Sender).Text := FormatFloat(',0.00',StrToFloatDef(ReplaceStr(TEdit(Sender).Text,'.',''), 0));
end;

procedure TFrmPadrao.MaxLengthZeroEsquerda(Sender: TObject;
  ObrigaZeroEsquerda: Boolean);
begin
  try
    {Se existir MaxLength independete de ser um TEdit
     Processa com o valo a esquerda}
    if TEdit(Sender).MaxLength > 0 then
      if TEdit(Sender).Text <> EmptyStr then
        TEdit(Sender).Text := F_Funcao.TMetodo.GetFormatar(TEdit(Sender).Text, TEdit(Sender).MaxLength, False, '0');

    if (ObrigaZeroEsquerda) and (TEdit(Sender).Text = EmptyStr) then
      if TEdit(Sender).MaxLength > 0 then
        TEdit(Sender).Text := F_Funcao.TMetodo.GetFormatar('0', TEdit(Sender).MaxLength, False, '0');
  except
  end;
end;

function TFrmPadrao.Padl(Valor: String; Tam: Integer;
  Complemento: String): String;
var
  I: Integer;
  Retorno : String;
begin

  if Length(Valor) < (Tam) then
  begin
    repeat
      Retorno := Retorno + Complemento;
    until Length(Retorno) >= (Tam - length(Valor));
    Result := Retorno + Valor;
  end
  else
    Result := Valor;
end;

procedure TFrmPadrao.ppImagem(campo: TBlobField; foto: TppImage);
var
  BS: TStream;
  MinhaImagem: TJPEGImage;
begin
  if campo.AsString <> '' then
  begin
    BS          := TStream.Create;
    BS          := Campo.DataSet.CreateBlobStream((campo as TBlobField), bmread);
    MinhaImagem := TJPEGImage.Create;
    MinhaImagem.LoadFromStream(BS);
    Foto.Picture.Assign(MinhaImagem);
    BS.Free;
    MinhaImagem.Free;
  end
  else
    Foto.Picture.Assign(nil);
end;

procedure TFrmPadrao.ValidaNotaEdit(Sender: TObject);
var
  dNota : Double;
begin
  dNota := StrToFloatDef(TEdit(Sender).Text, 0);
  if (dNota > 10) and (dNota < 11) then
    TCurrencyEdit(Sender).Value := 10;

  if (dNota > 11) and (dNota < 12) then
    TCurrencyEdit(Sender).Value := 11;

  if (dNota >= 12) then
    TCurrencyEdit(Sender).Value := 12;
end;

end.
