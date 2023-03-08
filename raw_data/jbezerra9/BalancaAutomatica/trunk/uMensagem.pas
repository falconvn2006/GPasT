unit uMensagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,DateUtils,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TFrMensagem = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BtOk: TBitBtn;
    pnlMensagem: TPanel;
    Timer: TTimer;
    Timer2: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtOkClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tempoInicial : TDateTime;
    sMensagem,sMensagem2 : string;
  end;

var
  FrMensagem: TFrMensagem;

implementation

uses uFuncoes;

{$R *.dfm}

procedure TFrMensagem.BtOkClick(Sender: TObject);
begin
     Timer.enabled  := False;
     Timer2.enabled := False;
     Close;
end;

procedure TFrMensagem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := CaFree;
end;

procedure TFrMensagem.FormDestroy(Sender: TObject);
begin
     FrMensagem := nil;
end;

procedure TFrMensagem.FormShow(Sender: TObject);
 var
     vFrMensagem: TFrMensagem;
begin
     pnlMensagem.caption := sMensagem +  #13 + sMensagem2;

     Timer.Enabled := True;
     tempoInicial  := Now;
end;

procedure TFrMensagem.Timer2Timer(Sender: TObject);
begin
      TimerTimer(Sender);
end;

procedure TFrMensagem.TimerTimer(Sender: TObject);
begin
     if SecondsBetween(tempoInicial,Now) >= 5 then
     begin
          BtOkClick(BtOk);
     end;
end;

end.
