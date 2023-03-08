unit Controle.Impressao.Carne;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Impressao, uniGUIBaseClasses,
  uniImageList, uniHTMLFrame, uniBitBtn, uniSpeedButton, uniLabel, uniButton,
  uniPanel, uniURLFrame, uniScreenMask,  uniTimer, ACBrBase,
  ACBrDownload ;

type
  TControleImpressaoCarne = class(TControleImpressao)
    procedure UniURLFrame1FrameLoaded(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
    CarregouComponenteURL : Integer;
  public
    { Public declarations }
    titulo_id : integer;
  end;

function ControleImpressaoCarne: TControleImpressaoCarne;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication ;

function ControleImpressaoCarne: TControleImpressaoCarne;
begin
  Result := TControleImpressaoCarne(ControleMainModule.GetFormInstance(TControleImpressaoCarne));
end;

procedure TControleImpressaoCarne.UniFormShow(Sender: TObject);
begin
  inherited;
  UniLabelAguarde.visible := True;
  CarregouComponenteURL := 0;
  //controleOperacoesTitulosCarne.showModal;
  ControleImpressaoCarne.UniURLFrame1.URL := ControleMainModule.SelecionaLink_Boleto(titulo_id);
  // Em produção a tela de Splash nao sai com esse codigo
  {  UniSFHold_Aguarde.MaskShow('Aguarde...',
                              procedure(const Mask:Boolean)
                              begin
                                //controleOperacoesTitulosCarne.showModal;
                                ControleImpressaoCarne.UniURLFrame1.URL := UniMainModule.SelecionaLink_Boleto(titulo_id);
                              end
                               );}
end;

procedure TControleImpressaoCarne.UniURLFrame1FrameLoaded(Sender: TObject);
begin
  inherited;
  CarregouComponenteURL := CarregouComponenteURL + 1;
  // Se alterar para 2 esta travando o fim do splash
  if CarregouComponenteURL = 1 then
  begin
    UniLabelAguarde.visible := False;
  // Em produção a tela de Splash nao sai com esse codigo
   // UniSFHold_Aguarde.MaskHide;
  end;
end;
end.
