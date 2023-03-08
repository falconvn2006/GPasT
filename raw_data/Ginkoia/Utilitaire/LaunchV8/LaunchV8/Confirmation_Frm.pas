unit Confirmation_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  // Uses perso
  AlgolDialogForms,
  // Fin uses perso
  Dialogs,
  StdCtrls,
  LMDCustomButton,
  LMDButton,
  ExtCtrls,
  RzPanel,
  RzLabel,
  dxGDIPlusClasses,
  AdvGlowButton;

type
  TFrm_Confirmation = class(TAlgolDialogForm)
    Img_Ques: TImage;
    Lab_Confirmation: TRzLabel;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolDialogFormVkReturnKey(Sender: TObject; var AKey: Word;
      var ADone: Boolean);
    procedure AlgolDialogFormVkEscapeKey(Sender: TObject; var AKey: Word;
      var ADone: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Confirmation: TFrm_Confirmation;

Function ConfirmerSortie(AText: string = ''): boolean;

implementation

USES GinkoiaStyle_DM;

{$R *.dfm}

Function ConfirmerSortie(AText: string = ''): boolean;
begin
  Result           := False;
  Frm_Confirmation := TFrm_Confirmation.Create(Nil);
  TRY
    if AText <> '' then
      Frm_Confirmation.Lab_Confirmation.Caption := AText;

    Result := Frm_Confirmation.ShowModal = mrOk;
  FINALLY
    Frm_Confirmation.Release;
  END;
end;

procedure TFrm_Confirmation.AlgolDialogFormVkEscapeKey(Sender: TObject;
  var AKey: Word; var ADone: Boolean);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_Confirmation.AlgolDialogFormVkReturnKey(Sender: TObject;
  var AKey: Word; var ADone: Boolean);
begin
  ModalResult := mrOk;
end;

procedure TFrm_Confirmation.FormCreate(Sender: TObject);
begin
  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
end;

procedure TFrm_Confirmation.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_Confirmation.Nbt_PostClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
