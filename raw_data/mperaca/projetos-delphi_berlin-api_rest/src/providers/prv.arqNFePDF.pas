unit prv.arqNFePDF;

interface

uses
  System.SysUtils, System.Classes, ACBrDFeReport, ACBrDFeDANFeReport, VCL.Dialogs,
  ACBrNFeDANFEClass, ACBrNFeDANFeRLClass, ACBrBase, ACBrDFe, ACBrNFe, IniFiles;

type
  TProviderArquivoNFePDF = class(TDataModule)
    ACBrNFeAPI: TACBrNFe;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
  private
    function RetornaArquivo(XChave: string): string;
    function RetornaCaminho(XChave: string): string;
    { Private declarations }
  public
    function RetornaNFePDF(XChave: string): TFileStream;
    { Public declarations }
  end;

var
  ProviderArquivoNFePDF: TProviderArquivoNFePDF;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderArquivoNFePDF }

function TProviderArquivoNFePDF.RetornaNFePDF(XChave: string): TFileStream;
var warqxml,warqpdf,wcaminho: string;
    warqstream: TFileStream;
begin
  try
    warqxml  := RetornaArquivo(XChave);
    wcaminho := RetornaCaminho(XChave);
    warqpdf  := wcaminho+'\'+XChave+'-nfe.pdf';
    // Carrega o arquivo xml da nfe
    if FileExists(warqxml) then
       begin
         ACBrNFeAPI.NotasFiscais.LoadFromFile(warqxml);
        // Define caminho para salvar o PDF
        ACBrNFeDANFeRL1.PathPDF := wcaminho;
        ACBrNFeAPI.NotasFiscais.ImprimirPDF;
        if FileExists(warqpdf) then
           warqstream  := TFileStream.Create(warqpdf,fmOpenRead);
       end;
  except
  end;
  Result := warqstream;
end;

// Retorna arquivo xml
function TProviderArquivoNFePDF.RetornaArquivo(XChave: string): string;
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

// Retorna caminho arquivo
function TProviderArquivoNFePDF.RetornaCaminho(XChave: string): string;
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

  wcaminho := wcaminho + '\'+wano+'\'+wmes;

  if not DirectoryExists(wcaminho) then
     ForceDirectories(wcaminho);

  Result   := wcaminho;
end;
end.
