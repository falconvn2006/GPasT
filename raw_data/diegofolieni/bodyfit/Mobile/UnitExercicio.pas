unit UnitExercicio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmExercicio = class(TForm)
    lytToolbar: TLayout;
    lblTitulo: TLabel;
    imgFechar: TImage;
    WebBrowser1: TWebBrowser;
    lblDescricao: TLabel;
    procedure imgFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    FIdExercicio: Integer;
    procedure LoadVideoYoutube(browser: TWebBrowser; video: String);
    procedure AjustarTamanhoVideo(browser: TWebBrowser);
    procedure DadosExercicio;
  public
    property IdExercicio: Integer read FIdExercicio write FIdExercicio;
  end;

var
  FrmExercicio: TFrmExercicio;

const
  PROPORCAO = 0.5625; //1920*1080 (1080 dividido por 1920)

implementation

uses
 DataModule.Global;

{$R *.fmx}

procedure TFrmExercicio.AjustarTamanhoVideo(browser: TWebBrowser);
var
  w, h: integer;
begin
  w := Trunc(browser.Width - 30);
  h := Trunc(w * PROPORCAO) + 10;

  browser.Height := h;
end;

procedure TFrmExercicio.DadosExercicio;
begin
  dmGlobal.DetalheExercicio(IdExercicio);

  if(dmGlobal.qryConsExercicio.FieldByName('url_video').AsString <> '')then
    LoadVideoYoutube(WebBrowser1, dmGlobal.qryConsExercicio.FieldByName('url_video').AsString)
  else
    WebBrowser1.Visible := False;

  lblTitulo.Text    := dmGlobal.qryConsExercicio.FieldByName('exercicio').AsString;
  lblDescricao.Text := dmGlobal.qryConsExercicio.FieldByName('descr_exercicio').AsString;
end;

procedure TFrmExercicio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmExercicio := nil;
end;

procedure TFrmExercicio.FormResize(Sender: TObject);
begin
  AjustarTamanhoVideo(WebBrowser1);
end;

procedure TFrmExercicio.FormShow(Sender: TObject);
begin
  DadosExercicio;
end;

procedure TFrmExercicio.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmExercicio.LoadVideoYoutube(browser: TWebBrowser; video: String);
var
  html: string;
begin
  html := '<!DOCTYPE HTML>' +
          '<html lang="pt-br">'+
          '<head>' +
          '<style>' +
          '.container {position: relative; overflow: hidden; width: 100%; padding-top: 56.25%; } ' +
          '.responsive-iframe {position: absolute; top: 0; left: 0; bottom:0; right: 0; width: 100%; height: 100%; }' +
          '</style>' +
          '<meta http-equiv="X-UA-Compatible" content="IE-edge"></meta>'+ //Compatibility mode
          '</head>' +
          '<body style="margin:0; height: 100%; overflow: hidden">'+
          '<iframe class="responsive-iframe" '+
          'src="' + video +
          '?controls=0' +
          ' frameborder="0" '+
          ' autoplay=1&rel=0&controls=0&showinfo=0" '+ // autoplay, no related videos, no info nor controls
          ' allow="autoplay" frameborder="0">'+ // allow autoplay, no border
          '</iframe>'+
          '</body>' +
          '</html>';

  AjustarTamanhoVideo(browser);
  browser.LoadFromStrings(html, '');
end;

end.
