unit uInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TF_Inicio = class(TForm)
    lytBackground: TLayout;
    rectInicio: TRectangle;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image1: TImage;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label2: TLabel;
    Image4: TImage;
    Image5: TImage;
    imgAudioOn: TImage;
    imgAudioOff: TImage;
    lytHeader: TLayout;
    imgAudio: TImage;
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgAudioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Inicio: TF_Inicio;

implementation

{$R *.fmx}

uses Globais, uPermissions, uEscolhaTelas;


procedure TF_Inicio.FormCreate(Sender: TObject);
begin
    {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
    TMyPermissions.RequestMyPermission(
    [
       TMyPermissions.Camera,
       TMyPermissions.WifiState,
       TMyPermissions.ReadExternalStorage,
       TMyPermissions.WriteExternalStorage
    ]
    );
    {$ENDIF}

    DesabilitaAudio    := false;


end;

procedure TF_Inicio.imgAudioClick(Sender: TObject);
begin
    if DesabilitaAudio = false then
    begin
        imgAudio.Bitmap := imgAudioOff.Bitmap;
        DesabilitaAudio := true;
    end else if DesabilitaAudio = true then
    begin
        imgAudio.Bitmap := imgAudioOn.Bitmap;
        DesabilitaAudio := false;
    end;
end;

procedure TF_Inicio.Label1Click(Sender: TObject);
begin
    try
        F_EscolhaTelas := TF_EscolhaTelas.Create(self);
        F_EscolhaTelas.Show;
    finally
//        F_EscolhaTelas.DisposeOf;
    end;

end;

end.
