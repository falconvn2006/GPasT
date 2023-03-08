unit FSP2K_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, IB_Components, IBODataset, FSP2KTypes, StdCtrls, ComCtrls, Forms,
  dxmdaset, Variants;

type
  TDM_FSP2K = class(TDataModule)
    GinkoiaIBDB: TIBODatabase;
    ADOConnection: TADOConnection;
    aQue_LstDossier: TADOQuery;
    MemD_Fedas: TdxMemData;
    MemD_FedasCTF_NOM: TStringField;
    MemD_FedasRAY_IDREF: TIntegerField;
    MemD_FedasRAY_NOM: TStringField;
    MemD_FedasFAM_IDREF: TIntegerField;
    MemD_FedasFAM_NOM: TStringField;
    MemD_FedasSSF_IDREF: TIntegerField;
    MemD_FedasSSF_NOM: TStringField;
    Que_Temp: TIBOQuery;
    MemD_Rayon: TdxMemData;
    MemD_RayonRAY_ID: TIntegerField;
    MemD_RayonRAY_IDREF: TIntegerField;
    MemD_RayonRAY_NOM: TStringField;
    MemD_Famille: TdxMemData;
    MemD_FamilleRAY_IDREF: TIntegerField;
    MemD_FamilleFAM_IDREF: TIntegerField;
    MemD_FamilleFAM_NOM: TStringField;
    MemD_FamilleFAM_ID: TIntegerField;
    Que_NewK: TIBOQuery;
    Que_GetMaxID: TIBOQuery;
    MemD_CatFamille: TdxMemData;
    MemD_CatFamilleCTF_NOM: TStringField;
    MemD_CatFamilleCTF_ID: TIntegerField;
    MemD_FedasSSF_ID: TIntegerField;
    Que_ListArtImportSP2K: TIBOQuery;
    ibs_UPDATEK: TIBOStoredProc;
  private
    { Déclarations privées }
    FLabAjout: TLabel;
    FPgAjout: TProgressBar;
    FLabModif: TLabel;
    FPgModif: TProgressBar;
    FLabOldImp: TLabel;
    FPgOldImp: TProgressBar;
    FLabEncours: TLabel;
    FMemoLogs: TMemo;

    FAddRayonCount,
    FAddFamilleCount,
    FAddSSFamilleCount : Integer;
    FMajRayoncount,
    FMajFamilleCount,
    FMajSSFamilleCount : Integer;
    FMajArtCount : Integer;

    // Procedure d'affichage des label
    procedure LabCaption(ALab : TLabel;ACaption : String);

    // Procedure de gestion des progressbar
    procedure InitProgress(AProgress : TProgressBar);
    procedure PosProgress(AProgress : TProgressBar;AMax, APos : Integer);

    // Création d'un nouveau K
    function GetNewK(ATableName : String) : Integer;
    // Met à jour la table K
    function UpdateKId(K_ID, Suppression : Integer) : Boolean;

    // Permet de récupérer le max d'un champ
    function GetMaxID(AField, ATableName : String) : Integer;
    // Permet de récupérer l'id d'une SousFamille par son nom
    function GetSSFIDByName(ASSF_NOM :String) : Integer;
  public
    { Déclarations publiques }
    // Ouverture de la base de données SP2K
    function Open2kDatabase : Boolean;
    // Ouverture de la base ginkoia et mise ne place des procédures stockées.
    function InitGinkoiaDB(BasePath : String) : Boolean;
    // traitement d'une base ginkoia
    function DoTraitement(ABasePath : String) : Boolean;
    // procedure de gestion des memo
    procedure AddToMemo(Text : String);
    // Chargement du fichier FEdas en mémoire
    function LoadFedasFile : Boolean;
    // Verifie que la base est en base 0
    function IsOnlyPantin : Boolean;
    // vérifie que la FEDAS existe
    function IsFedasExist(AIDFedas : Integer) : Boolean;
    // Récupère les informations de secteur et d'univers de la fedas sp2000
    function GetInfoSecUni(AIdFedas : Integer) : TNomenclature;
    // Permet de récupérer l'ID du Rayon (Créer le rayon s'il nexiste pas
    function GetRayId(ANomFedas : TNomenclature;ARAY_IDREF : Integer; ARAY_NOM : String) : Integer;
    // Permet de récupérer l'id de la famille( créer la famille si elle n'existe pas)
    function GetFamId(ARAY_ID, AFAM_IDREF : Integer; AFAM_NOM : String; AFAM_CTFID : Integer) : Integer;
    // Permet de récupérer l'id du CTF (Créer s'il n'existe pas)
    function GetCTFId(AUNI_ID : Integer;ACTF_NOM : String) : Integer;
    // Permet de récupérer l'id de la sous famille (Créer si elle n'existe pas)
    function GetSSFId(AFAM_ID, ASSF_IDREF : Integer; ASSF_NOM : String) : Integer;
    // Mise à jour de la sous famille de l'article
    function SetMajArticle(AART_ID, ASSF_ID : Integer) : Boolean;

    property LabEncours : TLabel read FLabEncours Write FLabEncours;
    property LabAjout : TLabel read FLabAjout Write FLabAjout;
    property LabModif : TLabel read FLabModif Write FLabModif;
    property LabOldImp : TLabel read FLabOldImp Write FLabOldImp;

    property PgAjout : TProgressBar read FPgAjout write FPgAjout;
    property PgModif : TProgressBar read FPgModif write FPgModif;
    property PgOldImp : TProgressBar read FPgOldImp write FPgOldImp;

    property MemoLogs : TMemo read FMemoLogs write FMemoLogs;
  end;

var
  DM_FSP2K: TDM_FSP2K;

implementation

{$R *.dfm}

{ TDM_FSP2K }

procedure TDM_FSP2K.AddToMemo(Text: String);
var
  FFile : TFileStream;
  sLigne : String;
begin
  sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] -> ', Now) + Text;
  if Assigned(FMemoLogs) then
  begin
    while FMemoLogs.Lines.Count > 500 do
      FMemoLogs.Lines.Delete(0);

    FMemoLogs.Lines.Add(sLigne);
  end;

  if FileExists(GLOGFILEPATH + GLOGFILENAME) then
  begin
    FFile := TFileStream.Create(GLOGFILEPATH + GLOGFILENAME,fmOpenReadWrite);
    FFile.Seek(0,soFromEnd);
  end
  else
    FFile := TFileStream.Create(GLOGFILEPATH + GLOGFILENAME,fmCreate);
  Try
    sLigne := sLigne + #13#10;
    FFile.Write(sLigne[1],Length(sLigne));
  Finally
    FFile.free;
  End;
end;

function TDM_FSP2K.DoTraitement(ABasePath: String): Boolean;
var
  stNomenclatureFedas : TNomenclature;
  iRAY_ID, iFAM_ID, iCTF_ID, iSSF_ID : Integer;
  iSSF_ID_IMPORTSP2K : Integer;
begin
  Try
    // Initialisation des compteurs
    FAddRayonCount := 0;
    FAddFamilleCount := 0;
    FAddSSFamilleCount := 0;
    FMajRayoncount := 0;
    FMajFamilleCount := 0;
    FMajSSFamilleCount := 0;
    FMajArtCount := 0;
    // Ouverture de la base de données
    LabCaption(FLabEncours,'Traitement de ' + ABasePath);
    LabCaption(FLabOldImp,'...');
    AddToMemo('------------------------------------------------');
    AddToMemo('------------------------------------------------');
    AddToMemo('Ouverture de la base de données : ' + ABasePath);
    AddToMemo('------------------------------------------------');

    if InitGinkoiaDB(ABasePath) then
      if IsOnlyPantin then
      begin
        if IsFedasExist(IniStruct.FedasRef) then
        begin
          // Chargement du fichier fedas dans la mémoire
          if LoadFedasFile then
          begin
            // Récupération des informations du secteur et univers de la Fedas
            stNomenclatureFedas := GetInfoSecUni(IniStruct.FedasRef);

            // Traitement de la liste du fichier Fedas
            GinkoiaIBDB.StartTransaction;
            With MemD_Fedas do
            begin
              First;
              LabCaption(FLabAjout,'Ajout et mise à jour de la FEDAS');
              InitProgress(FPgAjout);
              while not EOF do
              begin
                Try
                  // Vérification de la catégorie famille
                  iCTF_ID := 0;
                  if MemD_CatFamille.Locate('CTF_NOM',FieldByName('CTF_NOM').AsString,[loCaseInsensitive]) then
                  begin
                    if MemD_CatFamille.FieldByName('CTF_ID').AsInteger = 0 then
                    begin
                      iCTF_ID := GetCTFId(stNomenclatureFedas.UNI_ID,FieldByName('CTF_NOM').AsString);
                      MemD_CatFamille.Edit;
                      MemD_CatFamille.FieldByName('CTF_ID').AsInteger;
                      MemD_CatFamille.Post;
                    end
                    else
                      iCTF_ID := MemD_CatFamille.FieldByName('CTF_ID').AsInteger;
                  end; // if

                  // Vérification si le rayon a déja été traité
                  iRAY_ID := 0;
                  if MemD_Rayon.Locate('RAY_IDREF',FieldByName('RAY_IDREF').AsInteger,[]) then
                  begin
                    if MemD_Rayon.FieldByName('RAY_ID').AsInteger = 0 then
                    begin
                      iRAY_ID := GetRayID(stNomenclatureFedas,FieldByName('RAY_IDREF').AsInteger, FieldByName('RAY_NOM').AsString);
                      MemD_Rayon.Edit;
                      MemD_Rayon.FieldByName('RAY_ID').AsInteger := iRAY_ID;
                      MemD_Rayon.Post;
                    end
                    else
                      iRAY_ID := MemD_Rayon.FieldByName('RAY_ID').AsInteger;
                  end; // if

                  // Vérification que la famille a été traitée
                  iFAM_ID := 0;
                  if MemD_Famille.Locate('RAY_IDREF;FAM_IDREF',VarArrayOf([FieldByName('RAY_IDREF').AsInteger, FieldByName('FAM_IDREF').AsInteger]),[]) then
                  begin
                    if MemD_Famille.FieldByName('FAM_ID').AsInteger = 0 then
                    begin
                      iFAM_ID := GetFamId(IRAY_ID, FieldByName('FAM_IDREF').AsInteger,FieldByName('FAM_NOM').AsString, iCTF_ID);
                      MemD_Famille.Edit;
                      MemD_Famille.FieldByName('FAM_ID').AsInteger := iFAM_ID;
                      MemD_Famille.Post;
                    end
                    else
                      iFAM_ID := MemD_Famille.FieldByName('FAM_ID').AsInteger
                  end;  // if

                  // Vérification pour la SousFamille
                  iSSF_ID := 0;
                  if MemD_Fedas.FieldByName('SSF_ID').AsInteger = 0 then
                  begin
                    iSSF_ID := GetSSFId(iFAM_ID, FieldByName('SSF_IDREF').AsInteger, FieldByName('SSF_NOM').AsString);
                    MemD_Fedas.Edit;
                    MemD_Fedas.FieldByName('SSF_ID').AsInteger := iSSF_ID;
                    MemD_Fedas.Post;
                  end
                  else
                    iSSF_ID := MemD_Fedas.FieldByName('SSF_ID').AsInteger;

                Except on E:Exception do
                  begin
                    AddToMemo('-- Err : Ligne en erreur : ' + E.Message);
                    AddToMEmo('-- ' + FieldByName('RAY_NOM').AsString + ' / '
                                    + FieldByName('FAM_NOM').AsString + ' / '
                                    + FieldByName('SSF_NOM').AsString);
                  end;
                End;
                Next;
                PosProgress(FPgAjout,RecordCount,RecNo);
              end; // while

            end; // with
            GinkoiaIBDB.Commit;

            // Traitement des articles ayant un SSF_ID et un classement5 différent
            // récupération de l'ID de sous famille IMPORTSP2000
            iSSF_ID_IMPORTSP2K := GetSSFIDByName('IMPORTSP2000');
            if iSSF_ID_IMPORTSP2K <> -1 then
            begin
              LabCaption(FLabOldImp,'Vérification des anciens article');
              InitProgress(FPgOldImp);
              With Que_ListArtImportSP2K do
              begin
                Close;
                ParamCheck := True;
                ParamByName('PSSFID').AsInteger := iSSF_ID_IMPORTSP2K;
                Open;

                GinkoiaIBDB.StartTransaction;
                while not EOF do
                begin
                  Try
                    if Trim(FieldByName('ART_COMENT5').AsString) <> '' then
                      if MemD_Fedas.Locate('SSF_IDREF',FieldByName('ART_COMENT5').AsInteger,[]) then
                      begin
                        if SetMajArticle(FieldByName('ART_ID').AsInteger,MemD_Fedas.FieldByName('SSF_ID').AsInteger) then
                          AddToMemo('MAJ Article : ' + FieldByName('ARF_CHRONO').AsString + ' - ' +
                                                       FieldByName('ART_NOM').AsString + ' - ' +
                                                       ' SSF_ID : ' + MemD_Fedas.FieldByName('SSF_ID').AsString);
                      end;
                  Except on E:Exception do
                    AddToMemo('-- Err : Erreur de modication d''article : ' + E.Message);
                  End;
                  Next;
                  PosProgress(FPgOldImp,RecordCount,RecNo);
                end; // while
                GinkoiaIBDB.Commit;
              end;
            end
            else
              AddToMemo('-- Err : Sous famille inexistante : IMPORTSP2000');
          end; // if loadfedas
          AddToMemo('Rayon Ajoutés / Mis à jour : ' + IntToStr(FAddRayonCount) + ' / ' + IntToStr(FMajRayoncount));
          AddToMemo('Famille Ajoutées / Mises à jour : ' + IntToStr(FAddFamilleCount) + ' / ' + IntToStr(FMajFamilleCount));
          AddToMemo('Sous Famille Ajoutées / Mises à jour : ' + IntToStr(FAddSSFamilleCount) + ' / ' + IntToStr(FMajSSFamilleCount));
          AddToMemo('Nombre d''article mis à jour : ' + IntToStr(FMajArtCount));
        end
        else
          AddToMemo('-- Err : Fedas inexistante (' + IntToStr(IniStruct.FedasRef) + ')');
      end
      else
        AddToMemo('-- Err : Base non pantin');
  Except on E:Exception do
    raise Exception.Create('DoTraitement -> ' + E.Message);
  End;
end;

function TDM_FSP2K.GetCTFId(AUNI_ID : Integer;ACTF_NOM: String): Integer;
var
  iCTF_ID : Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select CTF_ID from NKLCATFAMILLE');
    SQL.Add('  join K on K_ID = CTF_ID and K_Enabled = 1');
    SQL.Add('Where Upper(CTF_NOM) = :PCTFNOM');
    SQL.Add('  and CTF_UNIID      = :PCTFUNIID');
    ParamCheck := True;
    ParamByName('PCTFNOM').AsString := UpperCase(ACTF_NOM);
    ParamByName('PCTFUNIID').AsInteger := AUNI_ID;
    Open;

    if RecordCount = 0 then
    begin
      iCTF_ID := GetNewK('NKLCATFAMILLE');
      Close;
      SQL.Clear;
      SQL.Add('Insert into NKLCATFAMILLE');
      SQL.Add('(CTF_ID, CTF_NOM, CTF_UNIID)');
      SQL.Add('Values(:PCTFID, :PCTFNOM, :PCTFUNIID)');
      ParamCheck := True;
      ParamByName('PCTFID').AsInteger := iCTF_ID;
      ParamByName('PCTFNOM').AsString := ACTF_NOM;
      ParamByName('PCTFUNIID').AsInteger := AUNI_ID;
      ExecSQL;
      AddToMemo('Nouvelle catégorie famille : ' + ACTF_NOM);
    end
    else
      iCTF_ID := FieldByName('CTF_ID').AsInteger;
  end;
  Result := iCTF_ID;
end;

function TDM_FSP2K.GetFamId(ARAY_ID, AFAM_IDREF: Integer;
  AFAM_NOM : String; AFAM_CTFID : Integer): Integer;
var
  iFAM_ID : Integer;
  iCTF_ID : Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select FAM_ID, FAM_NOM from NKLFAMILLE');
    SQL.Add(' join K on K_ID = FAM_ID and K_Enabled = 1');
    SQL.Add('Where FAM_RAYID = :PRAY_ID');
    SQL.Add('  and FAM_IDREF = :PFAMIDREF');
    ParamCheck := True;
    ParamByName('PRAY_ID').AsInteger   := ARAY_ID;
    ParamByName('PFAMIDREF').AsInteger := AFAM_IDREF;
    Open;

    if RecordCount = 0 then
    begin
      iFAM_ID := GetNewK('NKLFAMILLE');
      Close;
      SQL.Clear;
      SQL.Add('insert into NKLFAMILLE');
      SQL.Add('(FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID)');
      SQL.Add('Values(:PFAMID, :PFAMRAYID, :PFAMIDREF, :PFAMNOM, :PFAMORDREAFF, :PFAMVISIBLE, :PFAMCTFID)');
      ParamCheck := True;
      ParamByName('PFAMID').AsInteger := iFAM_ID;
      ParamByName('PFAMRAYID').AsInteger := ARAY_ID;
      ParamByName('PFAMIDREF').AsInteger := AFAM_IDREF;
      ParamByName('PFAMNOM').AsString    := IntToStr(AFAM_IDREF) + ' - ' + AFAM_NOM;
      ParamByName('PFAMORDREAFF').AsInteger := GetMaxID('FAM_ORDREAFF','NKLFAMILLE') + 10;
      ParamByName('PFAMVISIBLE').AsInteger  := 1;
      ParamByName('PFAMCTFID').AsInteger    := AFAM_CTFID;
      ExecSQL;
      AddToMemo('Nouvelle Famille : ' + AFAM_NOM + ' [' + IntToStr(AFAM_IDREF) + ']');
      Inc(FAddFamilleCount);
    end
    else begin
      iFAM_ID := FieldByName('FAM_ID').AsInteger;
      if Pos(UpperCase(AFAM_NOM),UpperCase(fieldByName('FAM_NOM').AsString)) = 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update NKLFAMILLE Set');
        SQL.Add('  FAM_NOM = :PFAM_NOM');
        SQL.Add('where FAM_ID = :PFAMID');
        ParamCheck := True;
        ParamByName('PFAM_NOM').AsString := IntToStr(AFAM_IDREF) + ' - ' + AFAM_NOM;
        ParamByName('PFAMID').AsInteger  := iFAM_ID;
        ExecSQL;

        UpdateKId(iFAM_ID,0);

        AddToMemo('MAJ Famille :' + IntToStr(AFAM_IDREF) + ' - ' + AFAM_NOM);
        Inc(FMajFamilleCount);
      end;
    end;
  end;
  Result := iFAM_ID;
end;

function TDM_FSP2K.GetInfoSecUni(AIdFedas: Integer): TNomenclature;
begin
  Result.UNI_ID := 0;
  Result.SEC_ID := 0;
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select distinct ray_secid,ray_uniid from nklrayon');
    SQL.Add('  join k on (ray_id=k_id and k_enabled=1)');
    SQL.Add('  join nklfamille on ( fam_rayid=ray_id)');
    SQL.Add('  join nklssfamille on (ssf_famid=fam_id)');
    SQL.Add('  join k on (fam_id=k_id and k_enabled=1)');
    SQL.Add('  join K on (K_ID=SSF_ID and K_ENABLED=1)');
    SQL.Add('Where  SSF_IDREF = :PSSFIDREF and SSF_NOM Like :PSSFNOM');
    ParamCheck := True;
    ParamByName('PSSFIDREF').AsInteger := AIdFedas;
    ParamByName('PSSFNOM').AsString    := ('%[' + IntToStr(AIdFedas) + ']');
    Open;

    if RecordCount > 0 then
    begin
      Result.UNI_ID := FieldByName('RAY_UNIID').AsInteger;
      Result.SEC_ID := FieldByName('RAY_SECID').AsInteger;
    end;
  end;
end;

function TDM_FSP2K.GetMaxID(AField, ATableName : String): Integer;
begin
  With Que_GetMaxID do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select Max(' + AField + ') as Resultat from ' + ATableName);
    Open;

    Result := FieldByName('Resultat').AsInteger;
  end;
end;

function TDM_FSP2K.GetNewK(ATableName: String): Integer;
begin
  With Que_NewK do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PTABLENAME').AsString := ATableName;
    Open;

    Result := FieldByName('ID').AsInteger;
  end;
end;

function TDM_FSP2K.GetRayId(ANomFedas: TNomenclature; ARAY_IDREF: Integer;
  ARAY_NOM: String): Integer;
var
  iRAY_ID : Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select RAY_ID, RAY_NOM from NKLRAYON');
    SQL.Add('  join K on K_ID = RAY_ID and K_Enabled = 1');
    SQL.Add('Where RAY_IDREF = :PRAYIDREF');
    SQL.Add('  and RAY_SECID = :PRAYSECID');
    SQL.Add('  and RAY_UNIID = :PRAYUNIID');
    ParamCheck := True;
    ParamByName('PRAYIDREF').AsInteger := ARAY_IDREF;
    ParamByName('PRAYSECID').AsInteger := ANomFedas.SEC_ID;
    ParamByName('PRAYUNIID').AsInteger := ANomFedas.UNI_ID;
    Open;

    if Recordcount = 0 then
    begin
      iRAY_ID := GetNewK('NKLRAYON');
      Close;
      SQL.Clear;
      SQL.Add('Insert into NKLRAYON');
      SQL.Add('(RAY_ID,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID)');
      SQL.Add('Values(:PRAYID, :PRAYUNIID, :PRAYIDREF, :PRAYNOM, :PRAYORDREAFF, :PRAYVISIBLE, :PRAYSECID)');
      ParamCheck := True;
      ParamByName('PRAYID').AsInteger       := iRAY_ID;
      ParamByName('PRAYUNIID').AsInteger    := ANomFedas.UNI_ID;
      ParamByName('PRAYIDREF').AsInteger    := ARAY_IDREF;
      ParamByName('PRAYNOM').AsString       := ARAY_NOM;
      ParamByName('PRAYORDREAFF').AsInteger := GetMaxID('RAY_ORDREAFF','NKLRAYON') + 10;
      ParamByName('PRAYVISIBLE').AsInteger  := 1;
      ParamByName('PRAYSECID').AsInteger    := ANomFedas.SEC_ID;
      ExecSQL;

      AddToMemo('Nouveau Rayon : ' + ARAY_NOM + ' [' + IntToStr(ARAY_IDREF) + ']');
      Inc(FAddRayonCount);
    end
    else begin
      iRAY_ID := FieldByName('RAY_ID').AsInteger;
      if Pos(UpperCase(ARAY_NOM), UpperCase(FieldByName('RAY_NOM').AsString)) = 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update NKLRAYON Set');
        SQL.Add('  RAY_NOM = :PRAYNOM');
        SQL.Add('Where RAY_ID = :PRAYID');
        ParamCheck := True;
        ParamByName('PRAYNOM').AsString := ARAY_NOM;
        ParamByName('PRAYID').AsInteger := iRAY_ID;
        ExecSQL;

        UpdateKId(iRAY_ID,0);

        AddToMemo('MAJ Rayon : ' + ARAY_NOM + ' [' + IntToStr(ARAY_IDREF) + ']');
        Inc(FMajRayoncount);
      end;
    end;
  end;
  Result := iRAY_ID;
end;

function TDM_FSP2K.GetSSFId(AFAM_ID, ASSF_IDREF: Integer;
  ASSF_NOM: String): Integer;
var
  iSSF_ID : Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select SSF_ID, SSF_NOM from NKLSSFAMILLE');
    SQL.Add(' join K on K_ID = SSF_ID and K_Enabled = 1');
    SQL.Add('Where SSF_FAMID = :PSSFFAMID');
    SQL.Add('  and SSF_IDREF = :PSSFIDREF');
    ParamCheck := True;
    ParamByName('PSSFFAMID').AsInteger := AFAM_ID;
    ParamByName('PSSFIDREF').AsInteger := ASSF_IDREF;
    Open;

    if RecordCount = 0 then
    begin
      iSSF_ID := GetNewK('NKLSSFAMILLE');
      Close;
      SQL.Clear;
      SQL.Add('Insert into NKLSSFAMILLE');
      SQL.Add('(SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID)');
      SQL.Add('Values(:PSSFID, :PSSFFAMID, :PSSFIDREF, :PSSFNOM, :PSSFORDREAFF, :PSSFVISIBLE, :PSSFCATID, :PSSFTVAID, :PSSFTCTID)');
      ParamCheck := True;
      ParamByName('PSSFID').AsInteger       := iSSF_ID;
      ParamByName('PSSFFAMID').AsInteger    := AFAM_ID;
      ParamByName('PSSFIDREF').AsInteger    := ASSF_IDREF;
      ParamByName('PSSFNOM').AsString       := ASSF_NOM + ' [' + IntToStr(ASSF_IDREF) + ']';
      ParamByName('PSSFORDREAFF').AsInteger := GetMaxID('SSF_ORDREAFF','NKLSSFAMILLE') + 10;
      ParamByName('PSSFVISIBLE').AsInteger  := 1;
      ParamByName('PSSFCATID').AsInteger    := 0;
      ParamByName('PSSFTVAID').AsInteger    := 144; // TVA
      ParamByName('PSSFTCTID').AsInteger    := 138; // Type comptable
      ExecSQL;

      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO NKLSSFGTS');
      SQL.Add('(REL_ID,REL_SSFID,REL_GTSID)');
      SQL.Add('Values(:PRELID,:PRELSSFID,:PGTSID)');
      ParamCheck := True;
      ParamByName('PRELID').AsInteger := GetNewK('NKLSSFGTS');
      ParamByName('PRELSSFID').AsInteger := iSSF_ID;
      ParamByName('PGTSID').AsInteger := 0;
      ExecSQL;

      AddToMemo('Nouvelle sous famille : ' + ASSF_NOM + ' [' + IntToStr(ASSF_IDREF) + ']');
      Inc(FAddSSFamilleCount);
    end
    else begin
      iSSF_ID := FieldByName('SSF_ID').AsInteger;
      if Pos(UpperCase(ASSF_NOM),UpperCase(FieldByName('SSF_NOM').AsString)) = 0 then
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update NKLSSFAMILLE Set');
        SQL.Add('  SSF_NOM = :PSSFNOM');
        SQL.Add('Where SSF_ID = :PSSFID');
        ParamCheck := True;
        ParamByName('PSSFNOM').AsString := ASSF_NOM + ' [' + IntToStr(ASSF_IDREF) + ']';
        ParamByName('PSSFID').AsInteger := iSSF_ID;
        ExecSQL;

        UpdateKId(iSSF_ID,0);

        AddToMemo('MAJ sous famille : ' + ASSF_NOM + ' [' + IntToStr(ASSF_IDREF) + ']');
        Inc(FMajSSFamilleCount);
      end;
    end;
  end;
  Result := iSSF_ID;
end;

function TDM_FSP2K.GetSSFIDByName(ASSF_NOM: String): Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select SSF_ID from NKLSSFAMILLE');
    SQL.Add('  join K on K_ID = SSF_ID and K_Enabled = 1');
    SQL.Add('Where Upper(SSF_NOM) = :PSSFNOM');
    ParamCheck := True;
    ParamByName('PSSFNOM').AsString := UpperCase(ASSF_NOM);
    Open;
    if RecordCount > 0 then
      Result := FieldByName('SSF_ID').AsInteger
    else
      Result := -1;
  end;
end;

procedure TDM_FSP2K.PosProgress(AProgress: TProgressBar;AMax, APos : Integer);
begin
  if Assigned(AProgress) and (AMax <> 0) then
    AProgress.Position := APos * 100 Div AMax;
  Application.ProcessMessages;
end;

function TDM_FSP2K.SetMajArticle(AART_ID, ASSF_ID: Integer): Boolean;
begin
  Result := False;
  With Que_Temp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Update ARTARTICLE Set');
    SQL.Add('  ART_SSFID = :PSSFID');
    SQL.Add('Where ART_ID = :PARTID');
    ParamCheck := True;
    ParamByName('PSSFID').AsInteger := ASSF_ID;
    ParamByName('PARTID').AsInteger := AART_ID;
    ExecSQL;

    UpdateKId(AART_ID,0);

    Inc(FMajArtCount);
    Result := True;
  Except on E:Exception do
    AddToMemo('--Err : Erreur lors de la mise à jour de l''article : ' + E.MEssage);
  end;
end;

function TDM_FSP2K.UpdateKId(K_ID, Suppression: Integer): Boolean;
begin
  Result := False;
  With ibs_UPDATEK do
  Try
    Close;
    ParamByName('K_ID').AsInteger := K_ID;
    ParamByName('SUPRESSION').AsInteger := Suppression;
    ExecSQL;
  Except on E:Exception do
    raise Exception.Create('UpdateKid -> ' + E.Message);
  end;
  Result := True;
end;

function TDM_FSP2K.InitGinkoiaDB(BasePath: String): Boolean;
begin
  Result := False;
  // Ouverture de la base GINKOIA
  with GinkoiaIBDB do
  begin
    Close;
    DatabaseName := BasePath;
    try
      Open;
      Result := True;
    Except on E:Exception do
      raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
    end;
  end;
end;

procedure TDM_FSP2K.InitProgress(AProgress: TProgressBar);
begin
  if Assigned(AProgress) then
    aProgress.Position := 0;
  Application.ProcessMessages;
end;

function TDM_FSP2K.IsFedasExist(AIDFedas : Integer): Boolean;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat from NKLSSFAMILLE');
    SQL.Add('  join K on K_ID = SSF_ID and K_Enabled = 1');
    SQL.Add('Where SSF_IDREF = :PIDREF and SSF_NOM Like :PSSFNOM');
    ParamCheck := True;
    ParamByName('PIDREF').AsInteger := AIDFedas;
    ParamByName('PSSFNOM').AsString := ('%[' + IntToStr(AIDFedas) + ']'); // QuotedStr
    Open;

    Result := (FieldByName('Resultat').AsInteger > 0);
  end;
end;

function TDM_FSP2K.IsOnlyPantin: Boolean;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select Retour from BN_ONLY_PANTIN');
    Open;

    Result := (FieldByName('Retour').AsInteger <> 0);
  end;
end;

procedure TDM_FSP2K.LabCaption(aLab: TLabel; ACaption: String);
begin
  if Assigned(ALab) then
    ALab.Caption := ACaption;
  Application.ProcessMessages;
end;

function TDM_FSP2K.LoadFedasFile: Boolean;
var
  lstFile, lstLigne : TStringList;
  i, j : Integer;
begin
  Result := False;
  lstFile := TStringList.Create;
  lstLigne := TStringList.Create;
  With MemD_Fedas do
  Try
    // Initialisation des memdata
    Close;
    Open;
    MemD_Rayon.Close;
    MemD_Rayon.Open;
    MemD_Famille.Close;
    MemD_Famille.Open;
    MemD_CatFamille.Close;
    MemD_CatFamille.Open;
    // Chargement du fichier
    try
      lstFile.LoadFromFile(GAPPPATH + IniStruct.FedasFile);
    Except on E:Exception do
      begin
        AddToMemo(' -- Err : Problème de chargement du fichier Fedas : ' + E.Message);
        Exit;
      end;
    end;

    // On commence à 1 pour ne pas prendre en compte la ligne d'entête
    for i := 1 to lstFile.Count - 1 do
    begin
      lstLigne.Text := StringReplace(lstFile[i],';',#13#10,[rfReplaceAll]);
      try
        Append;
        FieldByName('CTF_NOM').AsString    := Trim(AnsiDequotedStr(lstLigne[0],'"'));
        FieldByName('RAY_IDREF').AsInteger := StrToInt(lstLigne[1]);
        FieldByName('RAY_NOM').AsString    := Trim(AnsiDequotedStr(lstLigne[2],'"'));
        FieldByName('FAM_IDREF').AsInteger := StrToInt(lstLigne[3]);
        FieldByName('FAM_NOM').AsString    := Trim(AnsiDequotedStr(lstLigne[4],'"'));
        FieldByName('SSF_IDREF').AsInteger := StrToInt(lstLigne[5]);
        FieldByName('SSF_NOM').AsString    := trim(AnsiDequotedStr(lstLigne[6],'"'));
        FieldByName('SSF_ID').AsInteger    := 0;
        Post;

        // Mise en mémoire de la catégorie famille
        if not MemD_CatFamille.Locate('CTF_NOM',FieldByName('CTF_NOM').AsString,[loCaseInsensitive]) then
        begin
          MemD_CatFamille.Append;
          MemD_CatFamille.FieldByName('CTF_NOM').AsString := FieldbyName('CTF_NOM').AsString;
          MemD_CatFamille.FieldByName('CTF_ID').AsInteger := 0;
          MemD_CatFamille.Post;
        end;

        // Mise en memoire des rayons différents
        if not MemD_Rayon.Locate('RAY_IDREF',FieldByName('RAY_IDREF').AsInteger,[]) then
        begin
          MemD_Rayon.Append;
          MemD_Rayon.FieldByName('RAY_IDREF').AsInteger := FieldByName('RAY_IDREF').AsInteger;
          MemD_Rayon.FieldByName('RAY_NOM').AsString    := FieldByName('RAY_NOM').AsString;
          MemD_Rayon.FieldByName('RAY_ID').AsInteger    := 0;
          MemD_Rayon.Post;
        end;

        // Mise en mémoire des familles différentes
        If not MemD_Famille.Locate('RAY_IDREF;FAM_IDREF',VarArrayOf([FieldByName('RAY_IDREF').AsInteger,
                                                                     FieldByName('FAM_IDREF').AsInteger]),[]) then
        begin
          MemD_Famille.Append;
          MemD_Famille.FieldByName('RAY_IDREF').AsInteger := FieldByName('RAY_IDREF').AsInteger;
          MemD_Famille.FieldByName('FAM_IDREF').AsInteger := FieldByName('FAM_IDREF').AsInteger;
          MemD_Famille.FieldByName('FAM_NOM').AsString    := FieldByName('FAM_NOM').AsString;
          MemD_Famille.FieldByName('FAM_ID').AsInteger    := 0;
          MemD_Famille.Post;
        end;
      Except on E:Exception do
        begin
          if MemD_Fedas.State in [dsEdit,dsInsert] then
            MemD_Fedas.Cancel;

          if MemD_CatFamille.State in [dsEdit,dsInsert] then
            MemD_CatFamille.Cancel;

          if MemD_Rayon.State in [dsEdit,dsInsert] then
            MemD_Rayon.Cancel;

          if MemD_Famille.State in [dsEdit,dsInsert] then
            MemD_Famille.Cancel;

          AddToMemo('-- Err : Ligne fichier incorrecte : (' + IntToStr(i) + ') ' + E.Message);
        end;
      end;
    end;
  finally
    lstFile.Free;
    lstLigne.Free;
  end;
  Result := True;
end;

function TDM_FSP2K.Open2kDatabase: Boolean;
begin
  Result := False;
  With ADOConnection do
  Try
    Connected := False;

    if IniStruct.IsDebugMode then
    begin
      ConnectionString := 'Provider=SQLOLEDB.1;' +
                          'Password=' + IniStruct.pwDebugMode + ';' +
                          'Persist Security Info=True;' +
                          'User ID=' + IniStruct.lgDebugMode + ';' +
                          'Initial Catalog=' + IniStruct.ctDebugMode + ';' +
                          'Data Source=' + IniStruct.dbDebugMode ; // + ';'
    end else
//    Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Data Source=lame5.no-ip.com
      ConnectionString := 'Provider=SQLOLEDB.1;' +
                          'Password=' + IniStruct.PasswordDb + ';' +
                          'Persist Security Info=True;' +
                          'User ID=' + IniStruct.LoginDb + ';' +
                          'Initial Catalog=' + IniStruct.CatalogDb + ';' +
                          'Data Source=' + IniStruct.Database; // + ';'

    Connected := True;

    aQue_LstDossier.Close;
    aQue_LstDossier.Open;

    Result := True;
  Except on E:Exception do
    raise Exception.Create('Open2kDatabase -> ' + E.Message);
  end;
end;

end.
