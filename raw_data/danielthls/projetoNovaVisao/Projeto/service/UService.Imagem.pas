unit UService.Imagem;

interface

uses fmx.Dialogs, SysUtils, fmx.Graphics, Classes;
type
  TServiceImagem = class
  private

    FBitmapOriginal: TBitmap;
    FBitmapCopia: TBitmap;
    FOpenDialog: TOpenDialog;

    FCaminhoImagem: String;
    function GetCaminhoImagem: String;
    function GetBitmapOriginal: TBitmap;

  public

    property BitmapOriginal: TBitmap read GetBitmapOriginal;
    property CaminhoImagem: String read GetCaminhoImagem;
    constructor Create;
    destructor Destroy; override;
    procedure CarregarImagem;
    procedure RedimensionarImagem;
    procedure CriarImagemTemporaria;
    class procedure ExcluirImagemTemporaria;
end;

implementation

{ TImagem }

procedure TServiceImagem.CarregarImagem;
begin
  if FOpenDialog.Execute then
  begin
    FCaminhoImagem := FOpenDialog.FileName;
    FBitMapOriginal.LoadFromFile(FCaminhoImagem);
  end;
end;

constructor TServiceImagem.Create;
begin
  FCaminhoImagem := 'Nenhuma imagem selectionada';
  FOpenDialog := TOpenDialog.Create(nil);
  FOpenDialog.Filter := 'Arquivos PNG (*.png)|*.png';
  FBitmapOriginal := TBitmap.Create;
end;

procedure TServiceImagem.CriarImagemTemporaria;
begin
  if not ((FBitmapCopia.Width = 0) and (FBitmapCopia.Height = 0)) then
    FBitmapCopia.SaveToFile('ImagemTemporaria.png')
  else
    raise Exception.Create('Erro: Nenhuma imagem foi carregada');
end;

destructor TServiceImagem.Destroy;
begin
  FreeAndNil(FBitMapOriginal);
  FreeAndNil(FBitMapCopia);
  FreeAndNil(FOpenDialog);
  inherited;
end;

class procedure TServiceImagem.ExcluirImagemTemporaria;
begin
  if FileExists('ImagemTemporaria.png') then
    DeleteFile('ImagemTemporaria.png')

end;

function TServiceImagem.GetBitmapOriginal: TBitmap;
begin
  Result := FBitmapOriginal;
end;

function TServiceImagem.GetCaminhoImagem: String;
begin
  Result := FCaminhoImagem;
end;

procedure TServiceImagem.RedimensionarImagem;
const
  ALTURA = 256;
  LARGURA = 256;
begin
  FBitmapCopia.Assign(FBitmapOriginal);
  FBitmapCopia.SetSize(ALTURA, LARGURA); //Altera as dimensões do TBitmap vazio
end;

end.
