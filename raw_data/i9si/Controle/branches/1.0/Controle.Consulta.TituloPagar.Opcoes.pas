unit Controle.Consulta.TituloPagar.Opcoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses,  uniButton,
  uniRadioGroup, uniPanel;

type
  TControleConsultaTituloPagarOpcoes = class(TUniForm)
    UniPanel2: TUniPanel;
    UniPanel1: TUniPanel;
    UniRadioTituloPagarOpcoes: TUniRadioGroup;
    BotaoConfirmar: TUniButton;
    BotaoCancelar: TUniButton;
    UniPanel3: TUniPanel;
    procedure BotaoConfirmarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaTituloPagarOpcoes: TControleConsultaTituloPagarOpcoes;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaTituloPagarOpcoes: TControleConsultaTituloPagarOpcoes;
begin
  Result := TControleConsultaTituloPagarOpcoes(ControleMainModule.GetFormInstance(TControleConsultaTituloPagarOpcoes));
end;

procedure TControleConsultaTituloPagarOpcoes.BotaoCancelarClick(
  Sender: TObject);
begin
  UniRadioTituloPagarOpcoes.ItemIndex := -1;
  BotaoCancelar.ModalResult := mrCancel;
end;

procedure TControleConsultaTituloPagarOpcoes.BotaoConfirmarClick(
  Sender: TObject);
begin
  if UniRadioTituloPagarOpcoes.ItemIndex <> -1 then
  begin
    BotaoConfirmar.ModalResult := mrOk;
  end
  else
  begin
    BotaoCancelar.ModalResult := mrNone;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Por favor, escolha uma opção!');
  end;
end;

end.
