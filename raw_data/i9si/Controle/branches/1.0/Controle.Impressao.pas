unit Controle.Impressao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniHTMLFrame, uniBitBtn, uniSpeedButton, uniLabel,
  uniButton, uniGUIBaseClasses, uniPanel, uniImageList, uniURLFrame,
  uniScreenMask,  ACBrBase, ACBrDownload, uniTimer;

type
  TControleImpressao = class(TUniForm)
    UniPanel1: TUniPanel;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniImageList1: TUniImageList;
    UniURLFrame1: TUniURLFrame;
    UniImageList2: TUniImageList;
    UniScreenMask1: TUniScreenMask;
    UniLabelAguarde: TUniLabel;
    UniTimer1: TUniTimer;
    UniImageCaptionMaximizar: TUniSpeedButton;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionClose: TUniImageList;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniSpeedButtonResizeClick(Sender: TObject);
    procedure UniTimer1Timer(Sender: TObject);
    procedure UniImageCaptionMaximizarClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

function ControleImpressao: TControleImpressao;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleImpressao: TControleImpressao;
begin
  Result := TControleImpressao(ControleMainModule.GetFormInstance(TControleImpressao));
end;

procedure TControleImpressao.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleImpressao.UniFormShow(Sender: TObject);
var
  I: Integer;
begin
  UniLabelCaption.Text := Self.Caption;
  UniTimer1.Enabled := True;
end;

procedure TControleImpressao.UniImageCaptionMaximizarClick(Sender: TObject);
begin
  WindowState := wsMaximized;
  UniImageCaptionMaximizar.Visible := False;
end;

procedure TControleImpressao.UniSpeedButtonResizeClick(Sender: TObject);
begin
  if WindowState = wsNormal then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TControleImpressao.UniSpeedCaptionCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TControleImpressao.UniTimer1Timer(Sender: TObject);
begin
  if UniLabelAguarde.Visible = True then
  begin
    if UniLabelAguarde.Font.Color = $00DEC05B then
      UniLabelAguarde.Font.Color := clRed
    else
      UniLabelAguarde.Font.Color := $00DEC05B;

  // em produção o splash nao sai
  //  UniSFHold_Aguarde.MaskShow('Aguarde...');
  end;

end;

end.
