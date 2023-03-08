unit ModalDialogForm;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  uEntropy.TForm.Constrained,
  uEntropy.TSpeedButton.Colored,
  uApplicationVersion, FMX.Controls.Presentation;

type
  TFrm_ModalDialog = class(TForm)
    Lay_Wrapper: TLayout;
    Img_Background: TImage;
    Lay_Header: TLayout;
    Rec_Header: TRectangle;
    Lay_AppBar: TLayout;
    Lab_AppCaption: TLabel;
    Img_AppIcon: TImage;
    Lay_Footer: TLayout;
    SBtn_Close: TSpeedButton;
    Img_CloseBtn: TImage;
    SBtn_Ok: TSpeedButton;
    Img_OkBtn: TImage;
    SBox_Contents: TScrollBox;
    Lab_Message: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
  private
    function GetMessage: string;
    procedure SetMessage(const Value: string);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property message: string
      read   GetMessage
      write  SetMessage;
  end;

var
  Frm_ModalDialog: TFrm_ModalDialog;

implementation

{$R *.fmx}

procedure TFrm_ModalDialog.FormCreate(Sender: TObject);
begin
  Caption             := Format('%s (%s)', ['Utilitaire de capture', GetAppVersionStrFull]);
  Lab_AppCaption.Text := Caption;
  SizeGrid.Visible    := False;
  MinWidth            := 300;
  MinHeight           := 100;
end;

procedure TFrm_ModalDialog.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    vkReturn:
      ModalResult := mrOk;
    vkEscape:
      ModalResult := mrCancel;
  end;
end;

function TFrm_ModalDialog.GetMessage: string;
begin
  Result := Lab_Message.Text;
end;

procedure TFrm_ModalDialog.OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  // Populate
  DoMouseDown(Button, Shift, X, Y);
end;

procedure TFrm_ModalDialog.SetMessage(const Value: string);
begin
  Lab_Message.Text := Value;
end;

end.
