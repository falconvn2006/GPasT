unit Controle.Mensagem.Erro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniMemo, uniImageList,
  uniButton, uniBitBtn, uniSpeedButton, uniLabel, uniPanel;

type
  TControleMensagemErro = class(TUniForm)
    UniMemo1: TUniMemo;
    UniPanel1: TUniPanel;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionClose: TUniImageList;
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleMensagemErro: TControleMensagemErro;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleMensagemErro: TControleMensagemErro;
begin
  Result := TControleMensagemErro(ControleMainModule.GetFormInstance(TControleMensagemErro));
end;

procedure TControleMensagemErro.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleMensagemErro.UniSpeedCaptionCloseClick(Sender: TObject);
begin
  Close;
end;

end.
