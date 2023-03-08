unit OC_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, AlgolDialogForms,
  Dialogs, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, Main_Dm;


type
  TModeList = (mlInsert, mlUpdate);

  Tfrm_OC = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_Ou: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Lab_Nom: TLabel;
    edt_Nom: TEdit;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FMode: TModeList;
    FId: Integer;
    function FGetNom : String;
    procedure FWriteNom (AValue : String);

    { Déclarations privées }
  public
    { Déclarations publiques }
  published
    property Mode : TModeList read FMode write FMode;
    property Nom : string read FGetNom write FWriteNom;
    property Id : Integer read FId write FID;
  end;

var
  frm_OC: Tfrm_OC;

implementation

{$R *.dfm}

{ TForm1 }

function Tfrm_OC.FGetNom: String;
begin
  Result := edt_Nom.Text;
end;

procedure Tfrm_OC.FormShow(Sender: TObject);
begin
  case FMode of
    mlInsert: Caption := 'Création d''une nouvelle offre commerciale';
    mlUpdate: Caption := 'Modification d''une offre commerciale';
  end;
end;

procedure Tfrm_OC.FWriteNom(AValue: String);
begin
  edt_Nom.Text := AValue;
end;

procedure Tfrm_OC.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_OC.Nbt_PostClick(Sender: TObject);
begin

  if Trim(edt_Nom.Text) = '' then
  begin
    ShowMessage('Veuilllez saisir un nom pour l''offre');
    Exit;
  end;

  With Dm_Main.QTemp do
  begin
    Close;
    SQL.clear;
    SQL.Add('SELECT count(*) as Resultat from [Database].Dbo.OCSP2K');
    SQL.Add('Where OSO_SUPP = 0 and OSO_NOM = ' + QuotedStr(edt_Nom.Text));

    case FMode of
      mlUpdate: SQL.Add('And OSO_ID <> ' + IntToStr(FId));
    end;

//    ParamCheck := True;
//    Parameters.ParamByName('POSONOM').Value := Text;

//    case FMode of
//      mlUpdate: Parameters.ParamByName('POSOID').Value := FId;
//    end;
    Open;

    if FieldByName('Resultat').AsInteger > 0 then
    begin
      ShowMessage('Une offre possède déjà ce nom');
      Exit;
    end;
  end;

  ModalResult := mrOk;
end;

end.
