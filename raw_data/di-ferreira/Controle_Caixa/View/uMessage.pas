unit uMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage;

type
  tpMessage = (tSuccess, tInfo, tError, tQuestion);

type
  TFrmShowMessage = class(TForm)
    PanelMain: TPanel;
    BtnFechar: TSpeedButton;
    PanelText: TPanel;
    PanelIcon: TPanel;
    Panel1: TPanel;
    LblTitle: TLabel;
    LblMessage: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    IconImage: TImage;
    CloseTimer: TTimer;
    ContainerButtonSim: TPanel;
    BtnSim: TSpeedButton;
    ContainerButtonNao: TPanel;
    BtnNao: TSpeedButton;
    Panel4: TPanel;
    procedure BtnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnSimClick(Sender: TObject);
    procedure BtnNaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    FTipoMessage: tpMessage;
    FMessage: String;
    FTituloMessage: String;
    ResultQuestion: Boolean;
  end;

var
  FrmShowMessage: TFrmShowMessage;

implementation

{$R *.dfm}

procedure TFrmShowMessage.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmShowMessage.BtnNaoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TFrmShowMessage.BtnSimClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TFrmShowMessage.FormShow(Sender: TObject);
var
  vIconFile: String;
begin
  LblTitle.Caption := FTituloMessage;
  LblMessage.Caption := FMessage;
  CloseTimer.Enabled := True;
  ContainerButtonSim.Visible := False;
  ContainerButtonNao.Visible := False;

  case FTipoMessage of
    tSuccess:
      vIconFile := '\Assets\icon_success.png';
    tInfo:
      vIconFile := '\Assets\icon_info.png';
    tError:
      vIconFile := '\Assets\icon_error.png';
    tQuestion:
      begin
        CloseTimer.Enabled := False;
        ContainerButtonSim.Visible := True;
        ContainerButtonNao.Visible := True;
        vIconFile := '\Assets\icon_question.png';
      end;
  end;

  IconImage.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) +
    vIconFile);
end;

end.
