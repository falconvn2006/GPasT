{ ******************************************************************************
  Title: View Message
  Description: Tela relacionado à [Mensagem]

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add initial
  **************************************************************************** }
unit initialPascal.View.Message;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls,
  initialPascal.Types,
  initialPascal.Controller.Interfaces;

type

  { TFViewMessage }

  TFViewMessage = class(TForm)
    btnCancel: TBitBtn;
    btnConfirm: TBitBtn;
    btnClose: TBitBtn;
    imgLeft: TImage;
    memMessage: TMemo;
    panButtons: TPanel;
    panImg: TPanel;
    timRegressive: TTimer;
    timAction: TTimer;
    procedure btnCancelExecute(Sender: TObject);
    procedure btnConfirmExecute(Sender: TObject);
    procedure btnCloseExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure timRegressiveTimer(Sender: TObject);
  private
    FController: iControllerMessage;
  public
    FTypeMessage: TFormMessage;
    FRegressive: Integer;
    FTimer: Boolean;
    FMessage: String;
    constructor Create(aOwner: TComponent; aController: iControllerMessage); reintroduce;
  end;

var
  FViewMessage: TFViewMessage;

implementation

uses
  LCLType;

{$R *.lfm}

{ TFViewMessage }

procedure TFViewMessage.btnCancelExecute(Sender: TObject);
begin
  timAction.Enabled:=False;
  if btnCancel.Visible then
    btnCancel.Click;
end;

procedure TFViewMessage.btnConfirmExecute(Sender: TObject);
begin
  timAction.Enabled:=False;
  if btnConfirm.Visible then
    btnConfirm.Click;
end;

procedure TFViewMessage.btnCloseExecute(Sender: TObject);
begin
  timAction.Enabled:=False;
  if btnClose.Visible then
    btnClose.Click;
end;

procedure TFViewMessage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if btnClose.Visible then btnClose.Click;
    VK_F4: if ssAlt in Shift then Key:=VK_UNKNOWN;
    VK_F11: if btnCancel.Visible then btnCancel.Click;
    VK_F12: if btnConfirm.Visible then btnConfirm.Click;
  end;
end;

procedure TFViewMessage.FormShow(Sender: TObject);
begin
  memMessage.Lines.Clear;
  memMessage.Lines.AddStrings(FMessage);
  timAction.Enabled:= FTimer;
  timRegressive.Enabled:= FTimer;
end;

procedure TFViewMessage.timRegressiveTimer(Sender: TObject);
begin
  if btnClose.Visible then
  begin
    btnClose.Caption:='Fechando ' + IntToStr(FRegressive) + '...';
    Dec(FRegressive);
    Sleep(2);
    if FRegressive < 0 then
      timRegressive.Enabled:=False;
  end;
end;

constructor TFViewMessage.Create(aOwner: TComponent; aController: iControllerMessage);
begin
  inherited Create(aOwner);
  FController := aController;
end;

end.

