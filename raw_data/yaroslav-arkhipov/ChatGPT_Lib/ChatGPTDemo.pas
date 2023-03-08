unit ChatGPTDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ChatGPT_API, Vcl.ComCtrls, Winapi.RichEdit;

type
  TfrmChatGPTDemo = class(TForm)
    mTypeMessage: TMemo;
    btnSendMessage: TButton;
    Label1: TLabel;
    Label2: TLabel;
    reChat: TRichEdit;
    procedure btnSendMessageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FChat: TChatGPT;
    const
      cAPIKey = <Your API Key>;
    function AddColorText(Text: String; Color: TColor): String;
  public
    { Public declarations }
  end;

var
  frmChatGPTDemo: TfrmChatGPTDemo;

implementation

{$R *.dfm}

function TfrmChatGPTDemo.AddColorText(Text: String; Color: TColor): String;
begin
  reChat.SelAttributes.Color := Color;
  reChat.SelAttributes.Style := [fsBold];
  reChat.SelText := Text;
  reChat.SelAttributes.Color := clBlack;
  reChat.SelAttributes.Style := [];
  reChat.Update;
end;

procedure TfrmChatGPTDemo.btnSendMessageClick(Sender: TObject);
var
  LMsg, LResponse: String;
begin
  LMsg := mTypeMessage.Text;
  mTypeMessage.Clear;

  reChat.Lines.Add(AddColorText('You: ', clRed) + LMsg + sLineBreak);
  LResponse := FChat.SendMessage(LMsg);
  reChat.Lines.Add(AddColorText('ChatGPT: ', clGreen) + LResponse + sLineBreak);
  SendMessage(reChat.Handle, EM_LINESCROLL, 0, reChat.Lines.Count);
  reChat.Update;
end;

procedure TfrmChatGPTDemo.FormCreate(Sender: TObject);
begin
  FChat := TChatGPT.Create(cAPIKey);
  SendMessage(reChat.Handle, EM_EXLIMITTEXT, 0, $7FFFFFF0);
end;

procedure TfrmChatGPTDemo.FormDestroy(Sender: TObject);
begin
  FChat.Free;
end;

end.
