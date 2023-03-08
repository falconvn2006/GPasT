unit Controle.Relatorio.Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniButton, uniGUIBaseClasses, uniPanel
;

type
  TControleRelatorioMenu = class(TUniFrame)
    UniPanel1: TUniPanel;
    UniPanel2: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    UniPanel3: TUniPanel;
    UniButton3: TUniButton;
    UniButton4: TUniButton;
    UniButton5: TUniButton;
    UniButton6: TUniButton;
    procedure UniButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation


{$R *.dfm}

uses Controle.Relatorio,
     Controle.Relatorio.ContasReceber,
     uniPageControl,
     Controle.Main.Module,
     Controle.Funcoes;

procedure TControleRelatorioMenu.UniButton1Click(Sender: TObject);
begin
   ControleRelatorio.RelatorioAba(TFrame(TControleRelatorioContasReceber), 'Geração de relatórios', True);
end;

end.
