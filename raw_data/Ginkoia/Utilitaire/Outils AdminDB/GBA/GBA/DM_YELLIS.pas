unit DM_YELLIS;

{Tables originales de la base Yellis
Ordre d'importation :
1. Version (ID réutilisé dans Clients et Fichiers)
2. Clients (ID réutilisé dans Specifique Histo et PlageMAJ)
3. Fichiers Specifique Histo et PlageMAJ
}
interface

uses
  SysUtils, Classes, Forms, DB, UPost, Variants,
  Provider, Xmlxform, DBClient, xmldom, IBODataset,
     IB_Components, SqlExpr, Generics.Collections;

type

  TChampFonc      = reference to function(var Stop: boolean): TField;
  TMapping        = TDictionary<string, TChampFonc>;   //Champ destination, fonctions de lookup et mémorisation FK
  TDatasetMapping = TPair<TIBOTable, TMapping>;        //Table destination, Mapping des champs
  TImport         = TPair<TDataset, TDatasetMapping>;  //Table source, Mapping destination <--> champs
  TListeImport    = TList<TImport>;                    //Liste ordonnée des traitements

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
    YELLIS_VERSION: TClientDataSet;
    IntegerField14: TIntegerField;
    IntegerField15: TIntegerField;
    CDS_NULL: TClientDataSet;
    CDS_NULLID: TIntegerField;
    YELLIS_CLIENT: TClientDataSet;
    IntegerField12: TIntegerField;
    IntegerField13: TIntegerField;
  private
    { Déclarations privées }
  public
    procedure LesChrichri;

    procedure OuvrirTables;
    function  NbLignesHisto : integer;
    procedure OuvrirTableHisto(Limite : integer); //parser XML minimaliste, pour une unique valeur

    function XmlStrToFloat(Value: OleVariant): Extended;
    function XmlStrToDate(Value: OleVariant): TDateTime;
    function XmlStrToInt(Value: OleVariant; DefaultInt : Integer = 0): Integer;
    function XmlStrToStr(Value: OleVariant): string;
  end;

var
  DMYellis: TDMYellis;

implementation

uses MAINTENANCE_DM;
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

procedure TDMYellis.LesChrichri;
var
  TC : TConnexion;
  vStrl : TStringList;
begin
  TC    := TConnexion.create;
  vStrl := TStringList.Create;

  try
    vStrl.Add(TC.Select('select * from fichiers limit 0,30'));

    vStrl.SaveToFile('c:\cbr_test.xml');

  finally
    freeandNil(vStrl);
    TC.Free;
  end;
end;


procedure TDMYellis.OuvrirTables;
var TC : TConnexion;
begin
   TC := TConnexion.create;
   try
//      XTP_VERSION.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Version.xtr';
//      XTP_VERSION.TransformRead.SourceXml := TC.Select('select * from version');
//
//      XTP_CLIENTS.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Clients.xtr';
//      XTP_CLIENTS.TransformRead.SourceXml := TC.Select('select * from clients');
//
//      XTP_SPECIFIQUE.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Specifique.xtr';
//      XTP_SPECIFIQUE.TransformRead.SourceXml := TC.Select('select * from specifique');
//
//      XTP_PLAGEMAJ.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'plageMAJ.xtr';
//      XTP_PLAGEMAJ.TransformRead.SourceXml := TC.Select('select * from plageMAJ');

      XTP_FICHIERS.TransformRead.TransformationFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Fichiers.xtr';
      XTP_FICHIERS.TransformRead.SourceXml := TC.Select('select * from fichiers');

   finally
      TC.Free;
   end;
end;


function TDMYellis.XmlStrToStr(Value: OleVariant): string;
begin
  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
    Result := Trim(Value)
  else
    Result := '';
end;

function TDMYellis.XmlStrToFloat(Value: OleVariant): Extended;
var
  TpS: string;
begin
  try
    if VarIsNull(Value) or VarIsType(Value,varUnknown) then
    begin
      Result := 0;
      Exit;
    end;

    //test si les bons caractères sont mis au bon endroit
    //mechant mais, ils n'ont qu'à prendre ATIPIC
    TpS := XmlStrToStr(Value);
    if Pos(',',TpS)>0 then  //il ne faut pas de virgule !
    begin
      raise Exception.Create(TpS + ' ne doit pas avoir de , comme séparateur décimal');
    end;

    TpS[Pos('.',TpS)] := DecimalSeparator;
    Result := StrToFloat(TpS);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TDMYellis.XmlStrToDate(Value: OleVariant): TDateTime;
var
  d, m, y : Word;
  TpS: string;
begin
  Result := 0.0;
  if not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
  Try
    y := StrToIntDef(Copy(Value, 1, 4), 1899);
    m := StrToIntDef(Copy(Value, 5, 2), 1);
    d := StrToIntDef(Copy(Value, 7, 2), 1);
    Result := EncodeDate(y, m, d);
  except on E:Exception do
    raise Exception.Create('XmlStrToDate -> ' + E.Message);
  end;
end;

function TDMYellis.XmlStrToInt(Value: OleVariant; DefaultInt : Integer): Integer;
begin
  Try
    if Not VarIsNull(Value) and not VarIsType(Value,varUnknown) then
      Result := StrToIntDef(Trim(Value),DefaultInt)
    else
      Result := DefaultInt;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;


end.
