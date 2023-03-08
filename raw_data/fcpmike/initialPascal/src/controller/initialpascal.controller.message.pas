{ ******************************************************************************
  Title: Mensagem
  Description: Controller relacionado à [Mensagem]

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add initial
  **************************************************************************** }
unit initialPascal.Controller.Message;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms,
  initialPascal.Types,
  initialPascal.Controller.Interfaces,
  initialPascal.View.Message;

type

  { TControllerMessage }

  TControllerMessage = class(TInterfacedObject, iControllerMessage, iControllerForms)
  private
    FForm: TFViewMessage;
    FMessagm: TStringList;
    FTypeMessage: TFormMessage;
    FSetTimer: Integer;
    FFormResult: TModalResult;
    FMessageLeft: Boolean;
    procedure ConfigureView;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: iControllerMessage;
    function Message(aValue: String): iControllerMessage;
    function MessageLeft(aValue: Boolean): iControllerMessage;
    function SetTimer(aValue: Integer): iControllerMessage;
    function TypeMessage(aValue: TFormMessage): iControllerMessage;
    function &End: iControllerForms;
    function FormResult: TModalResult;
    function ShowView: iControllerForms;

  end;

implementation

uses
  LCLType, sysutils, Controls,
  initialPascal.Constants,
  initialPascal.View.Background;

{ TControllerMessage }

procedure TControllerMessage.ConfigureView;
begin
  try
    if FMessageLeft then
      FForm.memMessage.Alignment:=TAlignment.taLeftJustify;
    FForm.FTypeMessage:=FTypeMessage;
    FForm.FMessage:=FMessagm.Text;
    if FSetTimer > 0 then
    begin
      FForm.timRegressive.Interval := FSetTimer * 1000;
      FForm.FTimer:=True;
      FForm.timRegressive.Interval :=Pred(FSetTimer);
    end;
    case FTypeMessage of
      fmAlert:
        begin
          FForm.imgLeft.Picture.LoadFromFile(TConstantes.LAYOUT_FOLDER_IMG + 'alert.png');
          FForm.btnClose.Visible:=True;
          FForm.btnClose.ModalResult:=mrOK;
          FForm.timAction.OnTimer:=@FForm.btnCloseExecute;
        end;
      fmInfo:
        begin
          FForm.imgLeft.Picture.LoadFromFile(TConstantes.LAYOUT_FOLDER_IMG + 'info.png');
          FForm.btnClose.Visible:=True;
          FForm.btnClose.Caption:='Ok [Enter]';
          FForm.btnClose.ModalResult:=mrOK;
          FForm.timAction.OnTimer:=@FForm.btnCloseExecute;
        end;
      fmQuestion:
        begin
          FForm.imgLeft.Picture.LoadFromFile(TConstantes.LAYOUT_FOLDER_IMG + 'question.png');
          FForm.btnConfirm.Visible:=True;
          FForm.btnConfirm.Caption:='Sim [F12]';
          FForm.btnConfirm.ModalResult:=mrYes;
          FForm.btnCancel.Visible:=True;
          FForm.btnCancel.Caption:='Não [F11]';
          FForm.btnCancel.ModalResult:=mrNo;
          FForm.ActiveControl:=FForm.btnConfirm;
        end;
    end;
  except
  end;
end;

constructor TControllerMessage.Create;
begin
  FSetTimer:=0;
  FMessagm:=TStringList.Create;
end;

destructor TControllerMessage.Destroy;
begin
  FMessagm.Free;
  inherited Destroy;
end;

class function TControllerMessage.New: iControllerMessage;
begin
  Result := Self.Create;
end;

function TControllerMessage.Message(aValue: String): iControllerMessage;
begin
  Result := Self;
  FMessagm.Add(aValue);
end;

function TControllerMessage.MessageLeft(aValue: Boolean): iControllerMessage;
begin
  Result := Self;
  FMessageLeft:=aValue;
end;

function TControllerMessage.SetTimer(aValue: Integer): iControllerMessage;
begin
  Result := Self;
  FSetTimer:=aValue;
end;

function TControllerMessage.TypeMessage(aValue: TFormMessage
  ): iControllerMessage;
begin
  Result := Self;
  FTypeMessage:=aValue;
end;

function TControllerMessage.&End: iControllerForms;
begin
  Result := Self;
end;

function TControllerMessage.FormResult: TModalResult;
begin
  Result:=FFormResult;
end;

function TControllerMessage.ShowView: iControllerForms;
var
  FFormBack: TForm;
begin
  Result := Self;
  FFormBack:=TFViewBackground.Create(Application);
  FForm := TFViewMessage.Create(Application, Self);
  try
    FFormBack.AlphaBlend:=True;
    FFormBack.AlphaBlendValue:=200;
    FFormBack.Show;
    Self.ConfigureView;
    FForm.ShowModal;
    FFormResult:=FForm.ModalResult;
  finally
    FreeAndNil(FForm);
    FreeAndNil(FFormBack);
  end;
end;

end.
