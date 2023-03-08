unit uFormMensagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormMensagem = class(TForm)
    RichEditMensagem: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FormMensagem: TFormMensagem;

implementation

{$R *.dfm}

procedure TFormMensagem.FormCreate(Sender: TObject);
begin
   Self.Caption := 'Mensagem';
   Self.Position := poDesktopCenter;
   Self.KeyPreview := true;
   Self.BorderIcons := Self.BorderIcons - [biMinimize];

   RichEditMensagem.Clear();
   RichEditMensagem.Align := alClient;
   RichEditMensagem.ReadOnly := true;

end;

procedure TFormMensagem.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then Close;

end;

end.
