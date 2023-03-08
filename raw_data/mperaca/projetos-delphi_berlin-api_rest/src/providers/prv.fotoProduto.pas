unit prv.fotoProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TProviderFotoProduto = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    function SaveToStream: TStringStream;
    { Public declarations }
  end;

var
  ProviderFotoProduto: TProviderFotoProduto;

implementation

{$R *.dfm}

function TProviderFotoProduto.SaveToStream: TStringStream;
var input: TStringStream;
    j: TJPEGImage;
begin
  input  := TStringStream.Create;
  j := TJPEGImage.Create;
  j.Assign(Image1.Picture.Graphic);
  j.SaveToStream(input);
  Result := input;
end;

end.
