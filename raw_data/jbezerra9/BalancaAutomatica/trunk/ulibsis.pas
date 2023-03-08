unit Ulibsis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg;

type
  TFLibsis = class(TForm)
    Panel1: TPanel;
    edsen: TEdit;
    Label1: TLabel;
    OK: TButton;
    Cancela: TButton;
    Panel2: TPanel;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    
    procedure CancelaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure edsenKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLibsis: TFLibsis;
  //senha:string;
  
implementation

uses USplash, UModulo, uMensagem;

{$R *.DFM}

procedure TFLibsis.CancelaClick(Sender: TObject);
begin
     FLibsis.Tag := 0;
     Close;
end;

procedure TFLibsis.FormActivate(Sender: TObject);
begin
     edsen.Text := '';
     FLibsis.Tag := 0;
end;

procedure TFLibsis.OKClick(Sender: TObject);
begin
     if edsen.Text = senha then
     begin
          FLibsis.Tag := 1;
          Close;
     end
     else
     begin

          try
               Application.CreateForm(tFrMensagem,FrMensagem);
               FrMensagem.sMensagem := 'Senha inválida !';
               FrMensagem.pnlMensagem.Font.Size := 30;
               FrMensagem.ShowModal();
          finally
               FreeAndNil(FrMensagem);
          end;

          edsen.SetFocus;
     end;
end;

procedure TFLibsis.edsenKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
          OK.SetFocus;
end;

end.
