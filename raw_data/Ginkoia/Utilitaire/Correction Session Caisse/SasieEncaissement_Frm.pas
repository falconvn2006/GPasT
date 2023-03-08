unit SasieEncaissement_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls, DB, IBODataset;

type
  TFrm_SasieEncaissement = class(TForm)
    lblMontant: TLabel;
    edtMontant: TEdit;
    btnValider: TBitBtn;
    btnCancel: TBitBtn;
    lblModeEnc: TLabel;
    queModeEnc: TIBOQuery;
    queModeEncMEN_ID: TIntegerField;
    queModeEncMEN_NOM: TStringField;
    lblMotif: TLabel;
    edtMotif: TEdit;
    cbxModeEnc: TComboBox;
    chkCorrFDC: TCheckBox;
    procedure edtMontantKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    function GetMagID() : Integer;
    procedure SetMagID(Value : Integer);
    function GetMotif() : string;
    procedure SetMotif(Value : string);
    function GetModEncId() : Integer;
    procedure SetModEncId(Value : Integer);
    function GetMontant() : Double;
    procedure SetMontant(Value : Double);
    function GetCorrFDC() : boolean;
    procedure SetCorrFDC(Value : boolean);
  public
    { Déclarations publiques }
  published
    { Déclarations publiées }
    property MagID : Integer read GetMagID write SetMagID;
    property Motif : string read GetMotif write SetMotif;
    property ModEncId : Integer read GetModEncId write SetModEncId;
    property Montant : Double read GetMontant write SetMontant;
    property CorrFDC : boolean read GetCorrFDC write SetCorrFDC;
  end;

function InputEncaissement(MagID : Integer; var Motif : string; var ModEncId : integer; var Montant : Double; var CorrFDC : boolean) : Boolean;

implementation

{$R *.dfm}

procedure TFrm_SasieEncaissement.edtMontantKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['.', ',']) then
    Key := FormatSettings.DecimalSeparator;

  if not CharInSet(Key, ['0'..'9', '-', FormatSettings.DecimalSeparator, Chr(VK_BACK)]) then
    Key := #0
  else if (Key = '-') and not (edtMontant.SelStart = 0) then
    Key := #0
  else if (Key = FormatSettings.DecimalSeparator) and (Pos(FormatSettings.DecimalSeparator,edtMontant.Text) > 0) then
    Key := #0;
end;

function TFrm_SasieEncaissement.GetMagID() : Integer;
begin
  Result := queModeEnc.ParamByName('magid').AsInteger;
end;

procedure TFrm_SasieEncaissement.SetMagID(Value : Integer);
begin
  queModeEnc.Close();
  queModeEnc.ParamByName('magid').AsInteger := Value;
  queModeEnc.Open();
  cbxModeEnc.Items.Clear();
  while not queModeEnc.Eof do
  begin
    cbxModeEnc.Items.AddObject(queModeEnc.FieldByName('men_nom').AsString, Pointer(queModeEnc.FieldByName('men_id').AsInteger));
    queModeEnc.Next();
  end;
end;

function TFrm_SasieEncaissement.GetMotif() : string;
begin
  Result := edtMotif.Text;
end;

procedure TFrm_SasieEncaissement.SetMotif(Value : string);
begin
  edtMotif.Text := Value;
end;

function TFrm_SasieEncaissement.GetModEncId() : Integer;
begin
  if cbxModeEnc.ItemIndex >= 0 then
    Result := Integer(Pointer(cbxModeEnc.Items.Objects[cbxModeEnc.ItemIndex]))
  else
    Result := 0;
end;

procedure TFrm_SasieEncaissement.SetModEncId(Value : Integer);
begin
  if Value = 0 then
    cbxModeEnc.ItemIndex := -1
  else
    cbxModeEnc.ItemIndex := cbxModeEnc.Items.IndexOfObject(Pointer(Value));
end;

function TFrm_SasieEncaissement.GetMontant() : Double;
begin
  Result := StrToFloatDef(edtMontant.Text, 0);
end;

procedure TFrm_SasieEncaissement.SetMontant(Value : Double);
begin
  edtMontant.Text := FloatToStr(Value);
end;

function TFrm_SasieEncaissement.GetCorrFDC() : boolean;
begin
  Result := chkCorrFDC.Checked;
end;

procedure TFrm_SasieEncaissement.SetCorrFDC(Value : boolean);
begin
  chkCorrFDC.Checked := Value;
end;

function InputEncaissement(MagID : Integer; var Motif : string; var ModEncId : integer; var Montant : Double; var CorrFDC : boolean) : Boolean;
var
  Saisie : TFrm_SasieEncaissement;
begin
  Result := False;
  Saisie := TFrm_SasieEncaissement.Create(Application);
  try
    Saisie.MagID := MagID;
    Saisie.Motif := Motif;
    Saisie.ModEncId := ModEncId;
    Saisie.Montant := Montant;
    Saisie.CorrFDC := CorrFDC;
    if Saisie.ShowModal() = mrOk then
    begin
      Motif := Saisie.Motif;
      ModEncId := Saisie.ModEncId;
      Montant := Saisie.Montant;
      CorrFDC := Saisie.CorrFDC;
      Result := True;
    end;
  finally
    FreeAndNil(Saisie);
  end;
end;

end.
