unit Controle.Envia.Mensagem.Confirma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniEdit, uniButton, uniCheckBox,
  uniBitBtn, uniSpeedButton, uniLabel, uniPanel, uniImageList;

type
  TControleEnviaMensagemConfirma = class(TUniForm)
    UniEdtCelular: TUniEdit;
    UniPanel1: TUniPanel;
    BotaoSalvar: TUniButton;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniButton1: TUniButton;
    UniImageCaptionClose: TUniImageList;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleEnviaMensagemConfirma: TControleEnviaMensagemConfirma;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleEnviaMensagemConfirma: TControleEnviaMensagemConfirma;
begin
  Result := TControleEnviaMensagemConfirma(ControleMainModule.GetFormInstance(TControleEnviaMensagemConfirma));
end;

procedure TControleEnviaMensagemConfirma.BotaoSalvarClick(Sender: TObject);
begin
  if Length(UniEdtCelular.Text) < 9 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Digite o DDD + número celular (11 digitos)');
    Exit;
  end;

  BotaoSalvar.ModalResult := mrOk;
end;

procedure TControleEnviaMensagemConfirma.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleEnviaMensagemConfirma.UniFormShow(Sender: TObject);
begin
  UniLabelCaption.Text := Self.Caption;
end;

procedure TControleEnviaMensagemConfirma.UniSpeedCaptionCloseClick(
  Sender: TObject);
begin
  Close;
end;

end.
