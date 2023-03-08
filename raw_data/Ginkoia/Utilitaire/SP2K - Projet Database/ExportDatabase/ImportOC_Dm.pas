unit ImportOC_Dm;

interface

uses
  SysUtils, Classes, ADODB, DB, IBCustomDataSet, IBQuery,
  uLog, uCommon, IBDatabase, DateUtils, Types ;

type
  TDm_ImportOC = class(TDataModule)
    queOC: TIBQuery;
    AdQueOC: TADOQuery;
    queTmp: TIBQuery;
    AdQueTmp: TADOQuery;
    IBTransaction1: TIBTransaction;
  private
    { Déclarations privées }
  public
    function doImportOC(aBasePath, aMagCodeAdh : String ;  aDossId, aDbMagId : Int64) : boolean ;
  end;

var
  Dm_ImportOC: TDm_ImportOC;

function BoolToInt(aBool : boolean) : integer;


implementation

{$R *.dfm}

uses ExtractDatabase_Dm ;

{ TDm_ImportOC }

function BoolToInt(aBool : boolean) : integer;
begin
  if aBool
    then Result := 1
    else Result := 0 ;
end;

function TDm_ImportOC.doImportOC(aBasePath, aMagCodeAdh: String; aDossId,
  aDbMagId: Int64): boolean;
var
  vOsoId : Int64 ;
  vOsoNom : string ;
  vDebut, vFin : TDate ;
  vActif : boolean ;
  vCreer : TDateTime ;
  vModif : TDateTime ;

  procedure doInsertHisto(aMsg : string) ;
  begin
    Dm_ExtractDatabase.ADODatabase.BeginTrans;
    try
      Dm_ExtractDatabase.InsertHisto(0, ADbMagId, 0, 0, 0, 0, Now(), Now(), aMsg);
      Dm_ExtractDatabase.ADODatabase.CommitTrans;
    except
      Dm_ExtractDatabase.ADODatabase.RollbackTrans ;
    end;
  end;

begin
  Result := False ;

  LogAction('Import des OC Centrale', logInfo);

  if aBasePath = '' then
  begin
    doInsertHisto('Base Ginkoia non paramétrée') ;
    Exit;
  end;

  LogAction('Connexion base Ginkoia ' + aBasePAth, logInfo);
  Dm_ExtractDatabase.Ginkoia.Close;
  Dm_ExtractDatabase.Ginkoia.DatabaseName := aBasePath ;
  try
    Dm_ExtractDatabase.Ginkoia.Open;
  except
    LogAction(AMagCodeAdh + ' : Connection Ginkoia échouée - ' + aBasePath, logError);
    doInsertHisto('Connexion à la base Ginkoia impossible : ' + aBasePath) ;
    Exit ;
  end;

  {$REGION 'Vérification de l''existance des tables'}
  queTmp.Close;
  queTmp.SQL.Clear;
  queTmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
  queTmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
  queTmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
  queTmp.SQL.Add('and RDB$RELATION_NAME = ''OCSP2K''');
  queTmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
  queTmp.Open;

  if queTmp.FieldByName('Resultat').AsInteger = 0 then
  begin
    LogAction('Annulation du traitement : base non prévu pour la gestion des OC (Version < 15)', logInfo);
    Exit;
  end;

  queTmp.Close;
  queTmp.SQL.Clear;
  queTmp.SQL.Add('select distinct count(*) as Resultat from rdb$RELATION_FIELDS');
  queTmp.SQL.Add('where RDB$VIEW_CONTEXT is null');
  queTmp.SQL.Add('and RDB$SYSTEM_FLAG = 0');
  queTmp.SQL.Add('and RDB$RELATION_NAME = ''OCSP2KMAG''');
  queTmp.SQL.Add('GROUP BY  RDB$RELATION_NAME;');
  queTmp.Open;

  if queTmp.FieldByName('Resultat').AsInteger = 0 then
  begin
    LogAction('Annulation du traitement : base non prévu pour la gestion des OC (Version < 15)', logInfo);
    Exit;
  end;

  {$ENDREGION}

  try
    // Récupération des OC du magasin dans Ginkoia
    queOC.Close ;
    queOC.ParamByName('MAGCODE').asString := aMagCodeAdh ;
    queOC.Open ;

    // Récuperation des OC prévues dans Database
    AdQueOC.Close ;
    AdQueOC.ParamCheck := true ;
    AdQueOC.Parameters.ParamValues['MAGCODE'] := aMagCodeAdh ;
    AdQueOC.Open ;

    // Ajouts / modifs d'OC
    while not AdQueOc.Eof do
    begin
      vOsoId  := AdQueOc.FieldValues['OSO_ID'] ;

      if queOC.Locate('OSO_IDREF', vOsoId,[]) then
      begin
        vOsoNom := queOc.FieldByName('OSO_NOM').AsString ;
        vDebut  := queOC.FieldByName('OSM_DEBUT').AsDateTime ;
        vFin    := queOC.FieldByName('OSM_FIN').AsDateTime ;
        vActif  := (queOC.FieldByName('OSM_ACTIF').AsInteger = 1) ;
        vCreer  := queOC.FieldByName('OSM_CREER').AsDateTime ;
        vModif  := queOC.FieldByName('OSM_MODIF').AsDateTime ;

        if   ((CompareDate(vDebut,AdQueOC.FieldByName('OSM_DEBUT').AsDateTime) <> EqualsValue)
          or  (CompareDate(vFin, AdQueOC.FieldByName('OSM_FIN').AsDateTime) <> EqualsValue)
          or  (vOsoNom <> AdQueOC.FieldByName('OSO_NOM').AsString)
          or  (vCreer <> AdQueOC.FieldByName('OSM_CREER').AsDateTime))
          and (CompareDate(vCreer, vModif) = EqualsValue) then
        begin
          // OC modifiée
          queTmp.SQL.Text := 'EXECUTE PROCEDURE SP2K_DTB_UPDATEOC(:OSOID, :OSONOM, :MAGCODEADH, :OSMDEBUT, :OSMFIN, :OSMCREER)' ;
          queTmp.ParamByName('OSOID').AsLargeInt    := vOsoId ;
          queTmp.ParamByName('OSONOM').AsString     := AdQueOC.FieldByName('OSO_NOM').AsString ;
          queTmp.ParamByName('MAGCODEADH').AsString := aMagCodeAdh ;
          queTmp.ParamByName('OSMCREER').AsDateTime := AdQueOC.FieldByName('OSM_CREER').AsDateTime ;


          if vCreer = vModif then
          begin
            // mise a jour integrale
            queTmp.ParamByName('OSMDEBUT').AsDate := AdQueOC.FieldByName('OSM_DEBUT').AsDateTime ;
            queTmp.ParamByName('OSMFIN').AsDate   := AdQueOC.FieldByName('OSM_FIN').AsDateTime ;
          end else begin
            // Le magasin a modifié l'OC, on ne met a jour que le nom
            queTmp.ParamByName('OSMDEBUT').AsDate := 0 ;
            queTmp.ParamByName('OSMFIN').AsDate   := 0 ;
          end ;

          try
            queTmp.ExecSQL ;
            queTmp.Transaction.Commit ;
          except on E:Exception do
            begin
              LogAction('SP2K_DTB_UPDATEOC -> ' + E.Message, logError);
              queTmp.Transaction.Rollback ;
            end;
          end ;
        end ;
      end else begin
        queTmp.SQL.Text := 'EXECUTE PROCEDURE SP2K_DTB_CREATEOC(:OSOID, :OSONOM, :MAGCODEADH, :OSMDEBUT, :OSMFIN, :OSMCREER)' ;
        queTmp.ParamByName('OSOID').AsLargeInt    := vOsoId ;
        queTmp.ParamByName('OSONOM').AsString     := AdQueOC.FieldByName('OSO_NOM').AsString ;
        queTmp.ParamByName('MAGCODEADH').AsString := aMagCodeAdh ;
        queTmp.ParamByName('OSMDEBUT').AsDate     := AdQueOC.FieldByName('OSM_DEBUT').AsDateTime ;
        queTmp.ParamByName('OSMFIN').AsDate       := AdQueOC.FieldByName('OSM_FIN').AsDateTime ;
        queTmp.ParamByName('OSMCREER').AsDateTime := AdQueOC.FieldByName('OSM_CREER').AsDateTime ;

        try
          queTmp.ExecSQL ;
          queTmp.Transaction.Commit ;
        except on E:Exception do
        begin
            LogAction('SP2K_DTB_CREATEOC -> ' + E.Message, logError);
            queTmp.Transaction.Rollback ;

        end ;
        end;
      end ;
      AdQueOc.Next;
    end ;

    // traitement des OC supprimées
    queOC.First ;
    while not queOC.Eof do
    begin
      vOsoId := queOC.FieldByName('OSO_IDREF').AsLargeInt ;
      vOsoNom := queOc.FieldByName('OSO_NOM').AsString ;
      vDebut  := queOC.FieldByName('OSM_DEBUT').AsDateTime ;
      vFin    := queOC.FieldByName('OSM_FIN').AsDateTime ;
      vActif  := (queOC.FieldByName('OSM_ACTIF').AsInteger = 1) ;
      vCreer  := queOC.FieldByName('OSM_CREER').AsDateTime ;
      vModif  := queOC.FieldByName('OSM_MODIF').AsDateTime ;

      if AdQueOC.Locate('OSO_ID',vOsoId,[]) then
      begin
        if    (vCreer <> vModif)
          and (CompareDate(vModif, AdQueOC.FieldByName('OSM_OSMMODIF').AsDateTime) <> EqualsValue) then
        begin
          // OC modifiée en magasin
          AdQueTmp.Connection.BeginTrans ;
          try
            AdQueTmp.SQL.Text := 'INSERT INTO OCSP2KHISTO (OSH_MAGCODE, OSH_ACTIF, OSH_OSOID, OSH_DEBUT, OSH_FIN, OSH_DATE) ' +
                                 'VALUES (:MAGCODE, :ACTIF, :OSOID, :DEBUT, :FIN, :DATE)' ;
            AdQueTmp.ParamCheck := true ;
            AdQueTmp.Parameters.ParamValues['MAGCODE'] := aMagCodeAdh ;
            AdQueTmp.Parameters.ParamValues['ACTIF']   := BoolToInt(vActif) ;
            AdQueTmp.Parameters.ParamValues['OSOID']   := vOsoId ;
            AdQueTmp.Parameters.ParamValues['DEBUT']   := vDebut ;
            AdQueTmp.Parameters.ParamValues['FIN']     := vFin ;
            AdQueTmp.Parameters.ParamValues['DATE']    := vModif ;
            AdQueTmp.ExecSQL ;

            // Modification de la date de mise à jour de l'OC magasin
            AdQueTmp.SQL.Clear;
            AdQueTmp.SQL.Add('Update OCSP2KMAG Set');
            AdQueTmp.SQL.Add('OSM_OSMMODIF = :PMODIF');
            AdQueTmp.SQL.Add('Where OSM_OSOID =:POSMOSOID');
            AdQueTmp.SQL.Add('  And OSM_MAGCODE = :PMAGCODE');
            AdQueTmp.paramcheck := True;
            AdQueTmp.Parameters.ParamValues['PMODIF'] := vModif;
            AdQueTmp.Parameters.ParamValues['POSMOSOID'] := vOsoId;
            AdQueTmp.Parameters.ParamValues['PMAGCODE'] := aMagCodeAdh;
            AdQueTmp.ExecSQL ;

            AdQueTmp.Connection.CommitTrans ;
          except
            AdQueTmp.Connection.RollbackTrans ;
          end ;
        end ;
      end else begin
        // OC supprimée du magasin
        queTmp.SQL.Text := 'EXECUTE PROCEDURE SP2K_DTB_DELETEOC(:OSOID, :MAGCODEADH)' ;
        queTmp.ParamByName('OSOID').AsLargeInt    := vOsoId ;
        queTmp.ParamByName('MAGCODEADH').AsString := aMagCodeAdh ;

        try
          queTmp.ExecSQL ;
          queTmp.Transaction.Commit ;
        except on E:Exception do
          begin
            LogAction('SP2K_DTB_DELETEOC -> ' + E.Message, logError);
            queTmp.Transaction.Rollback ;
          end;
        end ;
      end ;
      queOC.Next;
    end ;
  finally
    Dm_ExtractDatabase.Ginkoia.Close ;
  end ;
end;

end.
