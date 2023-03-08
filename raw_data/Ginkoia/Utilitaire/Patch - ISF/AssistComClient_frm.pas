unit AssistComClient_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, Buttons, ExtCtrls;

type
  TFrm_AssistComClient = class(TForm)
    Pan_Script: TPanel;
    Pan_Script_Btn: TPanel;
    Nbt_Supprimer: TSpeedButton;
    Nbt_Terminer: TSpeedButton;
    Lab_Previsualiser: TLabel;
    Pan_SaisirURL: TPanel;
    Edit_URL: TEdit;
    Pan_Previsualisation: TPanel;
    Btn_okUrl: TButton;
    Pan_WebBrowser: TPanel;
    WB_PrevisualisationURL: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure Edit_URLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_okUrlClick(Sender: TObject);
    procedure Nbt_TerminerClick(Sender: TObject);
    procedure Nbt_SupprimerClick(Sender: TObject);
    procedure WB_PrevisualisationURLDownloadComplete(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_AssistComClient: TFrm_AssistComClient;

function ExecuteAssitComClient : String ;

implementation

{$R *.dfm}

function ExecuteAssitComClient : String ;
var
  AssistComClient : TFrm_AssistComClient ;
begin
  Result := '' ;
  try
    Application.createform(TFrm_AssistComClient, AssistComClient);
    AssistComClient.Pan_Previsualisation.Color := clWebLightBlue;
    AssistComClient.Pan_SaisirURL.Color := clWebLightBlue;
    AssistComClient.Pan_Script_Btn.Color := clWebLightBlue;
    if AssistComClient.ShowModal = mrOk then
    begin
      Result := AssistComClient.Edit_URL.text;
    end ;
  except
    Result := '' ;
  end;
end;

procedure TFrm_AssistComClient.Btn_okUrlClick(Sender: TObject);
begin
  WB_PrevisualisationURL.Navigate(Edit_URL.text);
end;

procedure TFrm_AssistComClient.Edit_URLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN : Btn_okUrlClick(self);
  end;
end;

procedure TFrm_AssistComClient.FormCreate(Sender: TObject);
begin
  Pan_WebBrowser.Visible := false;
end;

procedure TFrm_AssistComClient.Nbt_SupprimerClick(Sender: TObject);
begin
  Edit_URL.Text := '';
  Pan_WebBrowser.Visible := false;
end;

procedure TFrm_AssistComClient.Nbt_TerminerClick(Sender: TObject);
begin
  if (Edit_URL.Text = '')
    then showmessage('L''URL est vide !')
    else if length(Edit_URL.Text) > 250
      then showmessage('L''URL est trop longue !')
      else ModalResult := mrOk;
end;

procedure TFrm_AssistComClient.WB_PrevisualisationURLDownloadComplete(
  Sender: TObject);
begin
  Pan_WebBrowser.Visible := true;
end;

end.
