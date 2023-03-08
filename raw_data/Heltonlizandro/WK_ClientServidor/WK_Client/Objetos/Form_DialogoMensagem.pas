unit Form_DialogoMensagem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  Form_DialogoPadrao,
//  Classes_CoreDialogs,
  F_Funcao,
  ImgList;

type
  TFrm_DialogoMensagem = class(TFrm_DialogoPadrao)
  protected
    { Protected declarations }
    procedure AtualizaDialogo (ATitulo: string; ATexto: string; ACaptionBotoes: array of string; AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False); override;
  public
    { Public declarations }
    function  Exibe (ATitulo: string; ATexto: string; ACaptionBotoes: array of string; {ATipoSom: TTipoSom = tsNormal; }AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False): Integer;
  end;

implementation

{$R *.DFM}

procedure TFrm_DialogoMensagem.AtualizaDialogo(ATitulo: string; ATexto: string; ACaptionBotoes: array of string; AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False);
begin
  // Apenas coloca em maiusuculas a primeira letra de cada frase do texto
  ATexto := CAPSOnWords(ATexto,ccFirstsPhrase);

  // Chama método herdado
  inherited AtualizaDialogo(ATitulo, ATexto, ACaptionBotoes, AIconKind, ABigSize);
end;

function TFrm_DialogoMensagem.Exibe(ATitulo: string; ATexto: string; ACaptionBotoes: array of string; {ATipoSom: TTipoSom = tsNormal; }AIconKind: TIconKind = ikAutomatic; ABigSize: Boolean = False): Integer;
begin
  // Metodo utilizado para exibir o dialogo de mensagem
  Result := -1;
  try
    if Visible then Exit; // Se ja estiver sendo mostrado, sai

    // Tipo de som
//    TipoSom := ATipoSom;

    AtualizaDialogo(ATitulo, ATexto, ACaptionBotoes, AIconKind, ABigSize); // Atualiza a caixa de dialogo
    ShowModal;                                        // Mostra a caixa de dialogo
  finally
    Result := BotaoPress;                             // Retorna o indice do botao pressionado
  end;
end;

end.
