unit Controle.Consulta.TituloReceber.Opcoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniButton, uniRadioGroup, uniGUIBaseClasses,
  uniPanel, uniImageList;

type
  TControleConsultaTituloReceberOpcoes = class(TUniForm)
    UniPanel1: TUniPanel;
    UniRadioTituloReceberOpcoes: TUniRadioGroup;
    BotaoConfirmar: TUniButton;
    BotaoCancelar: TUniButton;
    UniPanel2: TUniPanel;
    UniPanel3: TUniPanel;
    procedure BotaoCancelarClick(Sender: TObject);
    procedure BotaoConfirmarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleConsultaTituloReceberOpcoes: TControleConsultaTituloReceberOpcoes;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleConsultaTituloReceberOpcoes: TControleConsultaTituloReceberOpcoes;
begin
  Result := TControleConsultaTituloReceberOpcoes(ControleMainModule.GetFormInstance(TControleConsultaTituloReceberOpcoes));
end;

procedure TControleConsultaTituloReceberOpcoes.BotaoConfirmarClick(
  Sender: TObject);
begin
  if UniRadioTituloReceberOpcoes.ItemIndex <> -1 then
  begin
    BotaoConfirmar.ModalResult := mrOk;
  end
  else
  begin
    BotaoCancelar.ModalResult := mrNone;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Por favor, escolha uma opção!');
  end;
end;

procedure TControleConsultaTituloReceberOpcoes.BotaoCancelarClick(Sender: TObject);
begin
  UniRadioTituloReceberOpcoes.ItemIndex := -1;
  BotaoCancelar.ModalResult := mrCancel;
end;

end.
