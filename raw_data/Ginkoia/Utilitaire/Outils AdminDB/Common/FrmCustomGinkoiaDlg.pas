unit FrmCustomGinkoiaDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoia, StdCtrls, Buttons, ExtCtrls, DB;

type
  TCustomGinkoiaDlgFrm = class(TCustomGinkoiaFrm)
    PnlBottom: TPanel;
    SpdBtnOk: TSpeedButton;
    SpdBtnCancel: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpdBtnCancelClick(Sender: TObject);
    procedure SpdBtnOkClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FAction: TUpdateKind;
    FUseUpdateKind: Boolean;
    FBtnExit: Boolean;
    FFramMode: Boolean;
    procedure SetFAction(const Value: TUpdateKind);
    procedure SetBtnExit(const Value: Boolean);
    procedure SetFramMode(const Value: Boolean);
  protected
    FModified: Boolean;
    function PostValues: Boolean; virtual;
  public
    property AAction: TUpdateKind read FAction write SetFAction;
    property UseUpdateKind: Boolean read FUseUpdateKind write FUseUpdateKind;
    property Modified: Boolean read FModified;
    property BtnExit: Boolean read FBtnExit write SetBtnExit;
    property FramMode: Boolean read FFramMode write SetFramMode;
  end;

var
  CustomGinkoiaDlgFrm: TCustomGinkoiaDlgFrm;

implementation

uses dmdClients, uTool;

{$R *.dfm}

{ TCustomGinkoiaDlgFrm }

procedure TCustomGinkoiaDlgFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if FUseUpdateKind then
    begin
      if (ModalResult = mrOk) and (FModified) then
        CanClose:= PostValues;
    end;
end;

procedure TCustomGinkoiaDlgFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FAction:= ukModify;
  FUseUpdateKind:= False;
  FModified:= True;
  FBtnExit:= False;
end;

procedure TCustomGinkoiaDlgFrm.FormDestroy(Sender: TObject);
begin
  inherited;
  if FUseUpdateKind then
    GIsBrowse:= True;
end;

procedure TCustomGinkoiaDlgFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  EnterAsTabFormKeyPress(Self, Key);
end;

procedure TCustomGinkoiaDlgFrm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    SpdBtnCancel.Click;
end;

procedure TCustomGinkoiaDlgFrm.FormShow(Sender: TObject);
begin
  inherited;
  if FUseUpdateKind then
    GIsBrowse:= False;
end;

procedure TCustomGinkoiaDlgFrm.SpdBtnOkClick(Sender: TObject);
begin
  inherited;
  Perform(WM_NEXTDLGCTL, 0, 0);
  ModalResult:= mrOk;
end;

procedure TCustomGinkoiaDlgFrm.SpdBtnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult:= mrCancel;
end;

function TCustomGinkoiaDlgFrm.PostValues: Boolean;
begin
  Result:= False;
end;

procedure TCustomGinkoiaDlgFrm.SetBtnExit(const Value: Boolean);
begin
  FBtnExit := Value;
  if FBtnExit then
    begin
      SpdBtnOk.Visible:= False;
      SpdBtnCancel.Caption:= 'Fermer';
      SpdBtnCancel.Glyph:= nil;
      dmClients.ImgLst.GetBitmap(13, SpdBtnCancel.Glyph);
    end;
end;

procedure TCustomGinkoiaDlgFrm.SetFAction(const Value: TUpdateKind);
begin
  FAction := Value;
  if FUseUpdateKind then
    begin
      case FAction of
        ukModify: Caption:= Caption + ' - Modifier';
        ukInsert: Caption:= Caption + ' - Nouveau';
      end;
    end;
end;

procedure TCustomGinkoiaDlgFrm.SetFramMode(const Value: Boolean);
begin
  FFramMode := Value;
  if FFramMode then
    begin
      PnlBottom.Visible:= False;
      BorderStyle:= bsNone;
    end;
end;

end.
