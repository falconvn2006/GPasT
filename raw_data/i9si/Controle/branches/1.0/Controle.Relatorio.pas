unit Controle.Relatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUImJSForm, unimPanel, uniCheckBox, uniLabel,
  uniButton, uniGUIBaseClasses, uniPanel, uniPageControl, uniImage, uniScrollBox;

type
  TControleRelatorio = class(TUniFrame)
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    UniPanel2: TUniPanel;
    UniPanel3: TUniPanel;
    UniLabel1: TUniLabel;
    UniPanel5: TUniPanel;
    UniImage1: TUniImage;
    PageControlMenu: TUniPageControl;
    UniPanel4: TUniPanel;
    UniPanel6: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    procedure UniButton1Click(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
  private
     { Private declarations }
  public
    { Public declarations }
    procedure RelatorioAba(nomeFormFrame: TFrame; descFormFrame: string;
      Fechar: Boolean);
  end;

function ControleRelatorio: TControleRelatorio;

implementation

{$R *.dfm}

uses
 Controle.Main.Module, Controle.Funcoes, Controle.Relatorio.Cadastro.ContasReceber,
  Controle.Relatorio.Cadastro.ContasPagar;

function ControleRelatorio: TControleRelatorio;
begin
  Result := TControleRelatorio(ControleMainModule.GetFormInstance(TControleRelatorio));
end;


procedure TControleRelatorio.RelatorioAba(nomeFormFrame: TFrame; descFormFrame: string; Fechar: Boolean);
var TabSheet      :TUniTabSheet;
    FCurrentFrame :TUniFrame;
    I             :Integer;
begin
  PageControlMenu.Visible := True;

  {Verificando se a tela já está aberto e redireciona a ela}
  for I := 0 to PageControlMenu.PageCount - 1 do
    with PageControlMenu do
      if Pages[I].Caption = descFormFrame  then
        begin
          PageControlMenu.ActivePageIndex := I;
          Exit;
        end;

  TabSheet              := TUniTabSheet.Create(Self);
  TabSheet.PageControl  := PageControlMenu;
  TabSheet.Caption      := descFormFrame;
  TabSheet.Closable     := Fechar;

  Try
    FCurrentFrame:= TUniFrameClass(nomeFormFrame).Create(Self);
  Except
    on e:Exception do
      ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
   End;

  with FCurrentFrame do
  begin
    Align               := alClient;
    Parent              := TabSheet;
  end;

  Refresh;
  PageControlMenu.ActivePage := TabSheet;
end;

procedure TControleRelatorio.UniButton1Click(Sender: TObject);
begin
   RelatorioAba(TFrame(TControleRelatorioCadastroContasReceber), 'Geração de relatórios', True);
end;

procedure TControleRelatorio.UniButton2Click(Sender: TObject);
begin
  RelatorioAba(TFrame(TControleRelatorioCadastroContasPagar), 'Geração de relatórios', True);
end;

end.
