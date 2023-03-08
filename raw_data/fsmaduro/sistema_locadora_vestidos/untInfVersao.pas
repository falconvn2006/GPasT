unit untInfVersao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, MSHTML, ActiveX;

type
  TfrmInfVersao = class(TForm)
    wbListagem: TWebBrowser;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
  public
    { Public declarations }
    procedure CarregarHtml(iHtml: String);

  end;

var
  frmInfVersao: TfrmInfVersao;

implementation

uses funcao;

{$R *.dfm}

procedure TfrmInfVersao.FormCreate(Sender: TObject);
begin
   Caption := CaptionTela('INFORMAÇÕES SOBRE ALTERAÇÕES NA TELA');
   wbListagem.Navigate('about:blank');
end;

procedure TfrmInfVersao.CarregarHtml(iHtml: String);
begin

  ExibirCodigoHTML(wbListagem, iHtml);

end;

Procedure TfrmInfVersao.ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
var
   V            : Variant;
   HTMLDocument : IHTMLDocument2;
begin
   try
      // Carrega Safe Array
      HTMLDocument := iWeb.Document as IHTMLDocument2;
      V            := VarArrayCreate([0,0], varVariant);
      V[0]         := i_Codigo;

      // Escreve código HTML no documento do Browser
      try
         HTMLDocument.Write(PSafeArray(TVarData(V).VArray));
         HTMLDocument.Close();
      except
         raise Exception.Create('Não foi exibido as implementações no sistema, verifique a versão do "internet explorer"');
      end;

   except
      On E: Exception do
        ShowMessage('Error 62504:'+E.Message);
   end;
end;


end.
