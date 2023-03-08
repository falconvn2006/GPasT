unit DM_YELLIS;

{Tables originales de la base Yellis
Ordre d'importation :
1. Version (ID réutilisé dans Clients et Fichiers)
2. Clients (ID réutilisé dans Specifique Histo et PlageMAJ)
3. Fichiers Specifique Histo et PlageMAJ
}
interface

uses
  SysUtils, Classes, Forms, DB, UPost,
  Provider, Xmlxform, DBClient, xmldom;

type
  TDMYellis = class(TDataModule)
    CDS_VERSION: TClientDataSet;
    XTP_VERSION: TXMLTransformProvider;
    CDS_CLIENTS: TClientDataSet;
    XTP_CLIENTS: TXMLTransformProvider;
    CDS_SPECIFIQUE: TClientDataSet;
    XTP_SPECIFIQUE: TXMLTransformProvider;
    CDS_HISTO: TClientDataSet;
    XTP_HISTO: TXMLTransformProvider;
    CDS_PLAGEMAJ: TClientDataSet;
    XTP_PLAGEMAJ: TXMLTransformProvider;
    CDS_FICHIERS: TClientDataSet;
    XTP_FICHIERS: TXMLTransformProvider;
  private
    { Déclarations privées }
  public
    procedure OuvrirTables;
    function NbLignesHisto : integer;
    procedure OuvrirTableHisto(Limite : integer); //parser XML minimaliste, pour une unique valeur
  end;

var
  DMYellis: TDMYellis;

implementation
uses DM_MAINTENANCE;
{$R *.dfm}

{ TDMYellis }

function TDMYellis.NbLignesHisto: integer;
var chn : string;
    p1, p2 : integer;
begin
   Result := 0;
   if XTP_HISTO.TransformRead.SourceXml = '' then
      exit;
   p1 := pos('<NBLIGNE>', XTP_HISTO.TransformRead.SourceXml) + 9;
   p2 := pos('</NBLIGNE>', XTP_HISTO.TransformRead.SourceXml) - p1;
   chn := copy( XTP_HISTO.TransformRead.SourceXml, p1, p2);
   if chn <> '' then
      Result := StrToInt(chn);

end;

procedure TDMYellis.OuvrirTableHisto(Limite: integer);
var TC : TConnexion;
begin
   TC := TConnexion.create;
   try
      CDS_HISTO.Close;
      XTP_HISTO.TransformRead.SourceXml := TC.Select('select * from histo LIMIT ' + IntToStr(Limite) + ', 1000');
      CDS_HISTO.Open;
   finally
      TC.Free;
   end;
end;

procedure TDMYellis.OuvrirTables;
var TC : TConnexion;
begin
   TC := TConnexion.create;
   try
      XTP_VERSION.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Version.xtr';
      XTP_VERSION.TransformRead.SourceXml := TC.Select('select * from version');
{      with tstringlist.Create do
      begin
      text := XTP_VERSION.TransformRead.SourceXml;
      savetofile('c:\ybe\versiondebug.xml');
       free;
      end;}
      XTP_CLIENTS.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Clients.xtr';
      XTP_CLIENTS.TransformRead.SourceXml := TC.Select('select * from clients');
{      with tstringlist.Create do
      begin
      text := XTP_CLIENTS.TransformRead.SourceXml;
      savetofile('c:\ybe\clientsdebug.xml');
       free;
      end;}
      XTP_SPECIFIQUE.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Specifique.xtr';
      XTP_SPECIFIQUE.TransformRead.SourceXml := TC.Select('select * from specifique');
{      with tstringlist.Create do
      begin
      text := XTP_SPECIFIQUE.TransformRead.SourceXml;
      savetofile('c:\ybe\specifiquedebug.xml');
       free;
      end;}
//      XTP_HISTO.TransformRead.SourceXml := TC.Select('select * from histo LIMIT 1, 60000');
      XTP_PLAGEMAJ.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'plageMAJ.xtr';
      XTP_PLAGEMAJ.TransformRead.SourceXml := TC.Select('select * from plageMAJ');
{      with tstringlist.Create do
      begin
      text := XTP_PLAGEMAJ.TransformRead.SourceXml;
      savetofile('c:\ybe\plagemajdebug.xml');
       free;
      end;}
      XTP_FICHIERS.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Fichiers.xtr';
      XTP_FICHIERS.TransformRead.SourceXml := TC.Select('select * from fichiers');
{      with tstringlist.Create do
      begin
      text := XTP_FICHIERS.TransformRead.SourceXml;
      savetofile('c:\ybe\fichiersdebug.xml');
       free;
      end;}
   finally
      TC.Free;
   end;
end;

end.
