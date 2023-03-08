unit GSDataExtract_DM;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components, IB_Access, DBClient, UcreateCSV, dialogs, Windows, StrUtils;

type
  TDm_GSDataExtract = class(TDataModule)
    cds_OFRTETE: TClientDataSet;
    cds_OFRTETEOFE_CHRONO: TStringField;
    cds_OFRTETEOFE_NOM: TStringField;
    cds_OFRTETEOFE_CODECENTRAL: TIntegerField;
    cds_OFRTETEOFE_TYPE: TIntegerField;
    cds_OFRTETEOFE_ACTIF: TIntegerField;
    cds_OFRTETEOFE_CUMUL: TIntegerField;
    cds_OFRTETEOFE_CENTRALE: TIntegerField;
    cds_OFRTETEOFE_DATE: TDateTimeField;
    cds_OFRTETEOFE_CODTVALDEB: TDateTimeField;
    cds_OFRTETEOFE_CODTVALFIN: TDateTimeField;
    cds_OFRTETEOFE_COPERM: TIntegerField;
    cds_OFRTETEOFE_COOPTYPDEC: TIntegerField;
    cds_OFRTETEOFE_COOPCB: TStringField;
    cds_OFRTETEOFE_COBRPREFIXE: TStringField;
    cds_OFRTETEOFE_COBRLGVAL: TIntegerField;
    cds_OFRTETEOFE_COBRLGDEC: TIntegerField;
    cds_OFRTETEOFE_COCLTTYP: TIntegerField;
    cds_OFRTETEOFE_COCLTFID: TIntegerField;
    cds_OFRTETEOFE_COCLTCLA: TIntegerField;
    cds_OFRTETEOFE_COPALIERFID: TIntegerField;
    cds_OFRTETEOFE_COTYPVTEN: TIntegerField;
    cds_OFRTETEOFE_COTYPVTES: TIntegerField;
    cds_OFRTETEOFE_COTYPVTEP: TIntegerField;
    cds_OFRTETEOFE_COREMMAX: TFloatField;
    cds_OFRTETEOFE_COMINPAN: TFloatField;
    cds_OFRTETEOFE_COMAXPAN: TFloatField;
    cds_OFRTETEOFE_COPERIMPAN: TIntegerField;
    cds_OFRTETEOFE_COMINART: TIntegerField;
    cds_OFRTETEOFE_COMAXART: TIntegerField;
    cds_OFRTETEOFE_COPERIMART: TIntegerField;
    cds_OFRTETEOFE_COPERIM: TIntegerField;
    cds_OFRTETEOFE_COMODCONTRAC: TIntegerField;
    cds_OFRTETEOFE_COMODCOMPLE: TIntegerField;
    cds_OFRTETEOFE_CACLTPERIM: TIntegerField;
    cds_OFRTETEOFE_CATYPVTEN: TIntegerField;
    cds_OFRTETEOFE_CATYPVTES: TIntegerField;
    cds_OFRTETEOFE_CATYPVTEP: TIntegerField;
    cds_OFRTETEOFE_CAREMMAX: TFloatField;
    cds_OFRTETEOFE_CAPXMIN: TIntegerField;
    cds_OFRTETEOFE_CAMINPAN: TFloatField;
    cds_OFRTETEOFE_CAMAXPAN: TFloatField;
    cds_OFRTETEOFE_CAPERIMPAN: TIntegerField;
    cds_OFRTETEOFE_CAMINART: TIntegerField;
    cds_OFRTETEOFE_CAMAXART: TIntegerField;
    cds_OFRTETEOFE_CAPERIMART: TIntegerField;
    cds_OFRTETEOFE_CAPERIM: TIntegerField;
    cds_OFRTETEOFE_CAMODCONTRAC: TIntegerField;
    cds_OFRTETEOFE_CAMODCOMPLE: TIntegerField;
    cds_OFRTETEOFE_AVTYPLIGNE: TIntegerField;
    cds_OFRTETEOFE_AVVALX: TIntegerField;
    cds_OFRTETEOFE_AVTYPREM: TIntegerField;
    cds_OFRTETEOFE_AVVAL1: TFloatField;
    cds_OFRTETEOFE_AVVAL2: TFloatField;
    cds_OFRTETEOFE_AVVAL3: TFloatField;
    cds_OFRTETEOFE_AVVAL4: TFloatField;
    cds_OFRTETEOFE_AVVAL5: TFloatField;
    cds_OFRMAGASIN: TClientDataSet;
    cds_OFRMAGASINOFM_OFECHRONO: TStringField;
    cds_OFRMAGASINOFM_FOUCODE: TStringField;
    cds_OFRMAGASINOFM_FOUNOM: TStringField;
    cds_OFRLIGNEBR: TClientDataSet;
    cds_OFRLIGNEBROFL_OFECHRONO: TStringField;
    cds_OFRLIGNEBROFL_DTUTILDEB: TDateTimeField;
    cds_OFRLIGNEBROFL_DTUTILFIN: TDateTimeField;
    cds_OFRLIGNEBROFL_REPART: TIntegerField;
    cds_OFRIMPBR: TClientDataSet;
    cds_OFRIMPBROFI_OFECHRONO: TStringField;
    cds_OFRIMPBROFI_TYPLIGNE: TIntegerField;
    cds_OFRIMPBROFI_NUMLIGNE: TIntegerField;
    cds_OFRIMPBROFI_DATA: TStringField;
    cds_OFRPERIMETRE: TClientDataSet;
    cds_OFRPERIMETREOFP_OFECHRONO: TStringField;
    cds_OFRPERIMETREOFP_TYPPERIM: TIntegerField;
    cds_OFRPERIMETREOFP_TYPDATA: TIntegerField;
    cds_OFRPERIMETREOFP_LIGNEID: TIntegerField;
    cds_OFRPERIMETREOFP_INCLUEXCLU: TIntegerField;
    cds_OFRPERIMETREOFP_PERIMCODE: TStringField;
    cds_OFRPERIMETREOFP_PERIMNOM: TStringField;
    Ds_OFRTETE: TDataSource;
    cds_OFRTYPCARTEFID: TClientDataSet;
    cds_OFRTYPCARTEFIDTCF_OFECHRONO: TStringField;
    cds_OFRTYPCARTEFIDTCF_TYPE: TIntegerField;
    cds_OFRTYPCARTEFIDTCF_CENTRALE: TIntegerField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Procedure Test;
    procedure ClearCdsExtract;
    Function  CreateCsvExtract(cds : TClientDataSet; DirExtract, DateExtract, NomTable : String; IdExtract : Integer) : Boolean;
    Function  CreateTemoin(DirExtract, DateExtract : String; IdExtract : Integer) : Boolean;
    Function  GetFicFromTemoin(DossierOrigine, Filtre : string) : TStringList;
    Function  LoadCsvExtract(AFileName: String; Cds : TClientDataset; AEmpty : Boolean): Boolean;
  end;

var
  Dm_GSDataExtract: TDm_GSDataExtract;

implementation

{$R *.dfm}

{ TDm_GSDataExtract }

function TDm_GSDataExtract.CreateCsvExtract(cds: TClientDataSet; DirExtract, DateExtract, NomTable: String;
  IdExtract: Integer): Boolean;
var
  Csv             : TExportHeaderOL;
  I, FieldIndex   : Integer;
  FicExtract      : TStringList;
  Ligne           : String;
begin
  //Function qui permettra de générer les fichiers csv d'offre de réduction
  Csv        := TExportHeaderOL.Create;
  I          := 0;

  if not (DirExtract[Length(DirExtract)] = '\') then
          DirExtract := DirExtract + '\';
      //DirExtract := ExtractFilePath(DirExtract);

  try
    try
      FicExtract := TStringList.Create;
      try
        cds.First;
        while not cds.Eof do
        begin
          Ligne := '';
          for i := 0 to cds.Fields.Count -1 do
          begin
            if ligne = '' then
              Ligne := cds.Fields[i].AsString
            else
              Ligne := Ligne + ';' + cds.Fields[i].AsString;
          end;
          FicExtract.Add(Ligne);
          cds.Next;
        end;

        FicExtract.WriteBOM := False;
        FicExtract.SaveToFile(DirExtract+'GSEXTRACT-'+IntToStr(IdExtract)+'-'+NomTable+'-'+DateExtract+'.csv', TEncoding.UTF8);
      finally
        FicExtract.Free;
      end;

    Except on e : Exception do
      begin
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    csv.Free;
  end;
end;


function TDm_GSDataExtract.CreateTemoin(DirExtract, DateExtract: String; IdExtract: Integer): Boolean;
var
  Temoin : TextFile;
begin
  //Function pour la création du fichier TEMOIN
  if not (DirExtract[Length(DirExtract)] = '\') then
          DirExtract := DirExtract + '\';

  try
    AssignFile(Temoin, DirExtract+'GSEXTRACT-'+IntToStr(IdExtract)+'-TEMOIN-'+DateExtract+'.csv');
    Rewrite(Temoin);
  finally
    CloseFile(Temoin);
  end;
end;

function TDm_GSDataExtract.GetFicFromTemoin(DossierOrigine, Filtre : string) : TStringList;
var
  Search  : TSearchRec;
  i       : Integer;
begin
  //Function pour le déplacement de fichier par rapport au filtre
  if FindFirst(DossierOrigine + Filtre, faAnyFile, Search) = 0 then
  begin
    Result := TStringList.Create;

    try
      repeat
      if not ((Search.Attr = faDirectory) or (Search.Name = '.') or (Search.Name = '..')) then
      begin
        if Pos('TEMOIN', Search.Name) = 0 then
        begin
          Result.Add(Search.Name);
        end;
      end;
    until (FindNext(Search) <> 0);
    finally
      SysUtils.FindClose(Search);
    end;

  end;
end;

function TDm_GSDataExtract.LoadCsvExtract(AFileName: String; Cds: TClientDataset; AEmpty: Boolean): Boolean;
var
  LstDonneeFic, LstDonneeCsv : TStringList;
  i,j                        : Integer;
begin
  //Procedure qui rempli les cds pour les offres de réduction
  Result := False;
  try
    try
      LstDonneeFic := TStringList.Create;
      LstDonneeCsv := TStringList.Create;

      LstDonneeFic.LoadFromFile(AFileName);

      for I := 0 to LstDonneeFic.Count - 1 do
      begin
        LstDonneeCsv.Text := StringReplace(LstDonneeFic[i], ';',#13#10,[rfReplaceAll]);
        With Cds do
        begin
          Append;
          for j := 0 to LstDonneeCsv.Count -1 do
          begin
            Fields.Fields[j].AsString := LstDonneeCsv[j];
          end;
          Post;
        end;
      end;

      Result       := True;
    finally
      LstDonneeFic.Free;
      LstDonneeCsv.Free;
    end;
  except on e:Exception do
    begin
      raise Exception.Create('LoadCsvToCDS -> ' + ExtractFileName(AFileName) + ' : ' + E.Message);
    end;
  end;

end;

procedure TDm_GSDataExtract.Test;
var
  CSV : TExportHeaderOL;
begin
//  csv := TExportHeaderOL.Create;
//
//  try
//  case cds_OFRTETE.FieldList.Fields[i].DataType of
//    ftString : Csv.Add(cds_OFRTETE.FieldList.Fields[i].FieldName,cds_OFRTETE.FieldList.Fields[i].Size);
//    ftInteger: Csv.Add(cds_OFRTETE.FieldList.Fields[i].FieldName,cds_OFRTETE.FieldList.Fields[i].Size,alleft,fmInteger);
//    ftFloat: Csv.Add(cds_OFRTETE.FieldList.Fields[i].FieldName,cds_OFRTETE.FieldList.Fields[i].Size,alLeft,fmFloat,'0.00','.');
//  end;
//
//  Csv.ConvertToCsv(cds_OFRTETE,'Chemin\MonFichier.csv');
//  finally
//    CSV.Free;
//  end;

//    Csv.Separator    := ';';
//    Csv.bWriteHeader := False;
////    Csv.bAlign       := False;
//
//    //Je parcours tous les champs du cds
//    for I := 0 to cds.FieldList.Count - 1 do
//    begin
//      case cds.FieldList.Fields[i].DataType of
//        ftString    : Csv.Add(cds.FieldList.Fields[i].FieldName,64);
//        ftInteger   : Csv.Add(cds.FieldList.Fields[i].FieldName,8,alleft,fmInteger);
//        ftFloat     : Csv.Add(cds.FieldList.Fields[i].FieldName,16,alLeft,fmFloat,'0.00','.');
//        ftDate      : Csv.Add(cds.FieldList.Fields[i].FieldName,0,alLeft,fmDate,'DD/MM/YYYY', '/');
//        ftDateTime  : Csv.Add(cds.FieldList.Fields[i].FieldName,0,alLeft,fmDate,'DD/MM/YYYY', '/');
//      end;
//    end;
//
//    Csv.ConvertToCsv(cds,DirExtract+'GSEXTRACT-['+IntToStr(IdExtract)+']-['+NomTable+']-['+DateExtract+'].csv');

end;

procedure TDm_GSDataExtract.ClearCdsExtract;
begin
  //Procedure qui permet de vider les cds
  with Dm_GSDataExtract do
  begin
    cds_OFRTETE.EmptyDataSet;
    cds_OFRMAGASIN.EmptyDataSet;
    cds_OFRLIGNEBR.EmptyDataSet;
    cds_OFRIMPBR.EmptyDataSet;
    cds_OFRPERIMETRE.EmptyDataSet;
    cds_OFRTYPCARTEFID.EmptyDataSet;
  end;
end;

end.
