unit prv.arqNFeXML;

interface

uses
  System.SysUtils, System.Classes, ACBrBase, ACBrDFe, ACBrNFe, XMLDoc, XMLIntf,
  Winapi.Activex, IniFiles;

type
  TProviderArquivoNFeXML = class(TDataModule)
    ACBrNFeAPI: TACBrNFe;
  private
    function RetornaArquivo(XChave: string): string;
    { Private declarations }
  public
    function RetornaNFeXML(XChave: string): TFileStream;
    { Public declarations }
  end;

var
  ProviderArquivoNFeXML: TProviderArquivoNFeXML;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderArquivoNFeXML }

function TProviderArquivoNFeXML.RetornaNFeXML(XChave: string): TFileStream;
var wret: TFileStream;
    warquivo: string;
begin
  try
    warquivo := RetornaArquivo(XChave);
    wret     := TFileStream.Create(warquivo,fmOpenRead);
  finally
    Result := wret;
  end;
end;

function TProviderArquivoNFeXML.RetornaArquivo(XChave: string): string;
var wret,wano,wmes,wcaminho,warquivo: string;
    wdata: tdate;
    warqini: TIniFile;
begin
  warqini  := TIniFile.Create(GetCurrentDir+'\Autorizador.ini');
  wcaminho := warqini.ReadString('Geral','CaminhoSalvar','');

  wano  := '20'+Copy(XChave,3,2);
  wmes  := Copy(XChave,5,2);
  wdata := StrToDate('01/'+wmes+'/'+wano);
  wmes  := FormatDateTime('mmmm',wdata);

  warquivo := wcaminho + '\'+wano+'\'+wmes+'\'+XChave+'-nfe.xml';
  if FileExists(warquivo) then
     wret := warquivo
  else
     wret := '';

  Result := wret;
end;

end.
