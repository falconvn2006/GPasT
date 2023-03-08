unit Controle.Modal.Ajuda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniSyntaxEditorBase, uniSyntaxEditor,
  uniGUIBaseClasses, uniURLFrame, uniButton, uniTimer, uniPanel, uniScreenMask,
  uniHTMLFrame;

type
  TControleModalAjuda = class(TUniForm)
    UniTimer1: TUniTimer;
    UniScreenMask1: TUniScreenMask;
    UniHTMLFrame1: TUniHTMLFrame;
    procedure UniTimer1Timer(Sender: TObject);
    procedure UniURLFrame1FrameLoaded(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleModalAjuda: TControleModalAjuda;

implementation

uses
  Controle.Main.Module, uniGUIApplication, Controle.Funcoes;

function ControleModalAjuda: TControleModalAjuda;
begin
  Result := TControleModalAjuda(ControleMainModule.GetFormInstance(TControleModalAjuda));
end;


{$R *.dfm}


procedure TControleModalAjuda.UniTimer1Timer(Sender: TObject);
begin
  UniTimer1.Enabled := False;
//  UniURLFrame1.HTML.Text := UniSyntaxEdit1.Text;
end;

procedure TControleModalAjuda.UniURLFrame1FrameLoaded(Sender: TObject);
begin
  // tem que ter alguma coisa para processar o aguarde, nemq ue seja comentado
end;

end.
