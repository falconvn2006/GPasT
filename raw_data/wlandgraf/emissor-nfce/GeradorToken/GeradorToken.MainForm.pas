unit GeradorToken.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TGeradorTokenMainForm = class(TForm)
    Label3: TLabel;
    edtIssuedAtDate: TDateTimePicker;
    edtIssuedAtTime: TDateTimePicker;
    Label4: TLabel;
    edtExpiresDate: TDateTimePicker;
    edtExpiresTime: TDateTimePicker;
    btGerarToken: TButton;
    mmToken: TMemo;
    btCopiar: TButton;
    edJwtSecret: TEdit;
    Label1: TLabel;
    procedure btGerarTokenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCopiarClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetNow;
    function GerarToken(AJwtSecret: string): string;
  public
    { Public declarations }
  end;

var
  GeradorTokenMainForm: TGeradorTokenMainForm;

implementation

uses
  System.DateUtils, Vcl.Clipbrd,

  Bcl.JOSE.Core.JWT, Bcl.JOSE.Core.Builder, Bcl.JOSE.Core.JWA,
  Bcl.JOSE.Core.JWK, Bcl.Jose.Types.Bytes;

{$R *.dfm}

procedure TGeradorTokenMainForm.btGerarTokenClick(Sender: TObject);
begin
  mmToken.Clear;
  mmToken.Lines.Add(GerarToken(edJwtSecret.Text));
  SetNow;
  btCopiar.Enabled := True;
  btCopiar.Caption := 'Copiar';
end;

procedure TGeradorTokenMainForm.btCopiarClick(Sender: TObject);
begin
  if mmToken.Text <> '' then
  begin
    Clipboard.AsText := mmToken.Text;
    btCopiar.Caption := 'Copiado!';
    btCopiar.Enabled := False;
  end;
end;

procedure TGeradorTokenMainForm.FormShow(Sender: TObject);
begin
  SetNow;
  btCopiar.Enabled := False;
end;

function TGeradorTokenMainForm.GerarToken(AJwtSecret: string): string;
var
  Token: TJWT;
  JWK: TJWK;
begin
  Token := TJWT.Create;
  JWK := TJWK.Create(AJwtSecret);
  try
    Token.Claims.IssuedAt := edtIssuedAtDate.Date + edtIssuedAtTime.Time;
    Token.Claims.Expiration := edtExpiresDate.Date + edtExpiresTime.Time;
    Result := TJOSE.SerializeCompact(JWK, TJOSEAlgorithmId.HS256, Token);
  finally
    JWK.Free;
    Token.Free;
  end;
end;

procedure TGeradorTokenMainForm.SetNow;
var
  lNow: TDateTime;
begin
  lNow := Now;

  edtIssuedAtDate.Date := lNow;
  edtIssuedAtTime.Time := lNow;

  edtExpiresDate.Date := IncMonth(lNow, 1);
  edtExpiresTime.Time := IncMonth(lNow, 1);
end;

end.
