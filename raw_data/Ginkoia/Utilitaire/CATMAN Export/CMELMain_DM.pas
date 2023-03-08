unit CMELMain_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, IBODataset, IB_Components, dxmdaset, uDefs ,StdCtrls, ComCtrls, DateUtils
  ,StrUtils;

type
  TDM_CMEL = class(TDataModule)
    ADOConnection: TADOConnection;
    aQue_MagList: TADOQuery;
    GinkoiaIBDB: TIBODatabase;
    iboSPRecalc: TIBOStoredProc;
    Que_Tmp: TIBOQuery;
    MemD_Stock: TdxMemData;
    MemD_StockSourceSystemCode: TStringField;
    MemD_StockSourceSystemStoreId: TStringField;
    MemD_StockDate: TStringField;
    MemD_StockEANCode: TStringField;
    iboSPStock: TIBOStoredProc;
    MemD_StockQuantity: TFloatField;
    Que_Stock: TIBOQuery;
    Que_GetVersion: TIBOQuery;
    aQue_HistoLevis: TADOQuery;
    aQue_Temp: TADOQuery;
    MemD_Ventes: TdxMemData;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    FloatField1: TFloatField;
    MemD_VentesType: TIntegerField;
    MemD_VentesAmount: TCurrencyField;
    MemD_VentesVAT: TCurrencyField;
    Que_Ventes: TIBOQuery;
    Que_CMD: TIBOQuery;
    MemD_CMD: TdxMemData;
    MemD_CMDCONST: TStringField;
    MemD_CMDMAG_CODE: TStringField;
    MemD_CMDMAG_LIB: TStringField;
    MemD_CMDOrderNbr: TStringField;
    MemD_CMDOrderType: TStringField;
    MemD_CMDOrderDate: TStringField;
    MemD_CMDReqDelivDate: TStringField;
    MemD_CMDLateDelivDate: TStringField;
    MemD_CMDEANCode: TStringField;
    MemD_CMDQuantity: TFloatField;
    MemD_CMDTmp: TdxMemData;
    MemD_CMDTmpARF_ARTID: TIntegerField;
    MemD_CMDTmpDATECOM: TDateTimeField;
    MemD_CMDTmpQTE: TFloatField;
    MemD_CMDTmpPXNN: TFloatField;
    MemD_CMDTmpTVA: TFloatField;
    MemD_CMDTmpTGFID: TIntegerField;
    MemD_CMDTmpCOUID: TIntegerField;
    MemD_CMDTmpEAN: TStringField;
    Que_ChronoCMD: TIBOQuery;
    Que_NewKId: TIBOQuery;
    IBOTrans: TIBOTransaction;
    MemD_CMDTmpPxVTE: TFloatField;
    MemD_Compare: TdxMemData;
    MemD_CompareEAN: TStringField;
    MemD_CompareART_NOM: TStringField;
    MemD_CompareARF_CHRONO: TStringField;
    MemD_CompareMRK_NOM: TStringField;
    MemD_CompareTGF_NOM: TStringField;
    MemD_CompareCOU_NOM: TStringField;
    aQue_Levis_T1: TADOQuery;
    aQue_Levis_T2: TADOQuery;
    aQue_Levis: TADOQuery;
    procedure ADOConnectionAfterConnect(Sender: TObject);
    procedure ADOConnectionBeforeConnect(Sender: TObject);
  private
    { Déclarations privées }
    FMemo : TMemo;
    FProgBarClient   ,
    FProgressArticle : TProgressBar;
  public
    { Déclarations publiques }
    // Ouverture de la base et des tables SQL Serveur
    function Open2kDatabase : Boolean;
    // Ouverture de la base ginkoia et mise ne place des procédure stockkée selon le MODE
    function InitGinkoiaDB(BasePath : String;Mode : Integer) : Boolean;

    //Ajoute le Texte au memo de log
    procedure AddToMemo(sText : String);
    procedure SaveMemo(MAG_CODE : String;Mode : Integer);    

    // Permet de récupérer le dernier K_ID à une date d'une table
    function GetMaxKVersion(KTB_ID : integer;K_INSERTED : TDateTime) : Integer;
    function GetLastGenID : Integer;
    // Permet de retrouver l'MAG_ID ginkoia
    function FindMagID(MAG_CODE :String) : Integer;

    // Sauvegarde dans l'historique SQL SERVEUR
    function SaveHistoLevis(iMagId,iType, iEtat,GEN_ID : Integer) : Boolean;

    // retourne les dernieres données des K_Version d'un magasin et son mode
    function GetLastHistoLevis(iMagID, Mode : Integer) : TKVersion;

    // retourne l'id fournisseur (le créé s'il n'existe pas)
    function GetfournisseurID (sFouName : String) : Integer;
    // Retourne l'id des condition de paiment
    function GetCDTPaiement(Idfournisseur,IdMagasin : Integer) : Integer;

    // Retourne un nouveau K_ID;
    function GetNewKId(sTableName: String): Integer;
    // retourne un chrono commande
    function GetNewChronoCMD : String;
    // Créer une commande et retourne son id
    function SetCommande(CDE_NUMERO: String; CDE_SAISON, CDE_EXEID,
                         CDE_CPAID, CDE_MAGID, CDE_FOUID: Integer; CDE_NUMFOURN: String;
                         CDE_DATE: TDateTime; CDE_REMISE, CDE_TVAHT1, CDE_TVATAUX1, CDE_TVA1,
                         CDE_TVAHT2, CDE_TVATAUX2, CDE_TVA2, CDE_TVAHT3, CDE_TVATAUX3, CDE_TVA3,
                         CDE_TVAHT4, CDE_TVATAUX4, CDE_TVA4, CDE_TVAHT5, CDE_TVATAUX5,
                         CDE_TVA5: single; CDE_FRANCO, CDE_MODIF: Integer; CDE_LIVRAISON: TDateTime;
                         CDE_OFFSET: integer; CDE_REMGLO: single; CDE_ARCHIVE: integer;
                         CDE_REGLEMENT: TDateTime; CDE_TYPID, CDE_NOTVA, CDE_USRID: integer;
                         CDE_COMENT: String): Integer;
    function SetCommandeLigneId(CDL_CDEID, CDL_ARTID, CDL_TGFID,
                                CDL_COUID: integer; CDL_QTE, CDL_PXCTLG, CDL_REMISE1, CDL_REMISE2,
                                CDL_REMISE3, CDL_PXACHAT, CDL_TVA, CDL_PXVENTE: single; CDL_OFFSET: integer;
                                CDL_LIVRAISON: TDateTime; CDL_TARTAILLE: integer;
                                CDL_VALREMGLO: single): Integer;

    // function de gestion du fournisseur
    function SetFournisseur(FOU_IDREF: integer; FOU_NOM: String;
                            FOU_ADRID: integer; FOU_TEL, FOU_FAX, FOU_EMAIL: String; FOU_REMISE: single;
                            FOU_GROS: integer; FOU_CDTCDE, FOU_CODE, FOU_TEXTCDE: String;
                            FOU_MAGIDPF: integer): integer;
    function SetFournisseurDetails(FOD_FOUID, FOD_MAGID: Integer;
                                   FOD_NUMCLIENT, FOD_COMENT: String; FOD_FTOID, FOD_MRGID, FOD_CPAID: Integer;
                                   FOD_ENCOURSA: single; FOD_COMPTA: String; FOD_FRANCOPORT: Single): Integer;

    // Gestion de la marque du fournisseur
    function GetMarqueId(MRK_IDREF: integer; MRK_NOM, MRK_CONDITION, MRK_CODE: String): integer;
    // Génère la jointure en la marque et le fournisseur
    function SetMrkFour(FMK_FOUID,FMK_MRKID,FMK_PRIN : integer) : Integer;

    // function qui récupère le dernier exercice commercial
    function GetLastEXECOM : integer;

    // Récupère le mail du magasin
    function GetMagMail(GK_MAGID : integer) : String;

    property Memo : TMemo read FMemo Write FMemo;
    property ProgBarArticle : TProgressBar read FProgressArticle Write FProgressArticle;
    property ProgBarClient : TProgressBar read FProgBarClient write FProgBarClient;
  end;

var
  DM_CMEL: TDM_CMEL;

implementation

{$R *.dfm}

{ TDM_CMEL }

procedure TDM_CMEL.AddToMemo(sText: String);
begin
  FMemo.Lines.Add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + sText);
end;

procedure TDM_CMEL.ADOConnectionAfterConnect(Sender: TObject);
begin
  AddToMemo('Connexion à la base SQL Serveur effectuée');
end;

procedure TDM_CMEL.ADOConnectionBeforeConnect(Sender: TObject);
begin
  AddToMemo('Connexion à la base de données SQL Serveur en cours');
end;

function TDM_CMEL.FindMagID(MAG_CODE: String): Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear; 
    SQL.Add('Select MAG_ID from GENMAGASIN');
    SQL.Add('Where MAG_CODEADH = :PCODEADH');
    ParamCheck := True;
    ParamByName('PCODEADH').AsString := MAG_CODE;
    Open;

    Result := FieldByName('MAG_ID').AsInteger;
  end;
end;

function TDM_CMEL.GetCDTPaiement(Idfournisseur, IdMagasin: Integer): Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ARTFOURNDETAIL');
    SQL.Add(' join k on k_id = fod_id and k_enabled = 1');
    SQL.Add('where FOD_FOUID = :PFOUID');
    SQL.Add('  and FOD_MAGID = :PMAGID');
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger := Idfournisseur;
    ParamByName('PMAGID').AsInteger := IdMagasin;
    Open;

    if RecordCount = 0  then
    begin
      Close;
      ParamCheck := True;
      ParamByName('PFOUID').AsInteger := Idfournisseur;
      ParamByName('PMAGID').AsInteger := 0;
      Open;
    end;

    if FieldByName('FOD_CPAID').AsInteger = 0 then
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from  GENCDTPAIEMENT');
      SQL.Add('Where CPA_CODE = 2');
      Open;

      Result := FieldByName('CPA_ID').AsInteger;
    end
    else begin
      Result := FieldByName('FOD_CPAID').AsInteger
    end;
  end;

end;

function TDM_CMEL.GetfournisseurID(sFouName : String): Integer;
var
  IdFOUID ,
  IdADRID ,
  IdMRK   : integer;
begin
  With Que_Tmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select FOU_ID from ARTFOURN');
    SQL.Add('Where FOU_NOM = :PNOM');
    ParamCheck := True;
    ParamByName('PNOM').AsString := UpperCase(sFouName);
    Open;

    if RecordCount <= 0 then
    begin
      // Création de l'adresse
      IdADRID := GetNewKId('GENADRESSE');
      Close;
      SQL.Clear;
      SQL.Add('Insert into GENADRESSE');
      SQL.Add('(ADR_ID,ADR_LIGNE,ADR_VILID,ADR_TEL,ADR_FAX,ADR_GSM,ADR_EMAIL,ADR_COMMENT)');
      SQL.Add('Values(:PADRID,:PADRLIGNE,:PADRVILID,:PADRTEL,:PADRFAX,:PADRGSM,:PADREMAIL,:PADRCOMMENT)');
      ParamCheck := True;
      ParamByName('PADRID').AsInteger     := IdADRID;
      ParamByName('PADRLIGNE').AsString   := '';
      ParamByName('PADRVILID').AsInteger  := 0;
      ParamByName('PADRTEL').AsString     := '';
      ParamByName('PADRFAX').AsString     := '';
      ParamByName('PADRGSM').AsString     := '';
      ParamByName('PADREMAIL').AsString   := '';
      ParamByName('PADRCOMMENT').AsString := '';
      ExecSQL;

      // création du fournisseur
      IdFOUID := SetFournisseur(0,sFouName,IdADRID,'','','',0,0,'','','',0);
      SetFournisseurDetails(IdFOUID,0,'','',0,0,0,0,'',0);

      // Gestion de la marque
      IdMRK := GetMarqueId(0,'LEVIS','','LEVIS');
      // Liaison entre la marque et le fournisseur
      SetMrkFour(IdFOUID,IdMRK,0);

      Result := IdFOUID;
    end else
      Result := FieldByName('FOU_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('GetFournisseurID -> ' + E.Message);
  end;
end;

function TDM_CMEL.GetLastEXECOM: integer;
var
  sExercice : String;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from GENEXERCICECOMMERCIAL');
    SQL.Add('Where EXE_FIN <= :PDATEFIN');
    SQL.Add('  and EXE_DEBUT >= :PDATEDEBUT');
    ParamCheck := True;
    ParamByName('PDATEFIN').AsDate   := Now;
    ParamByName('PDATEDEBUT').AsDate := Now;
    Open;

    // On cherche si aujourd'hui est bien dans un des exercice commercial saisie
    if Recordcount > 0 then
    begin
      Result := FieldByName('EXE_ID').AsInteger;
      Exit;
    end;

    // Si on ne trouve pas on regarde le dernier utilisé
    Close;
    SQL.Clear;
    SQL.Add('Select * from GENPARAM');
    SQL.Add('Where PRM_TYPE = 2 and PRM_CODE = 20');
    Open;
    if Recordcount > 0 then
    begin
      sExercice := FieldByName('PRM_STRING').AsString;

      Close;
      SQL.Clear;
      SQL.Add('Select * from GENEXERCICECOMMERCIAL');
      SQL.Add('Where EXE_ANNEE = :PANNEE');
      ParamCheck := True;
      ParamByName('PANNEE').AsString := sExercice;
      Open;

      if RecordCount > 0 then
      begin
        Result := FieldByName('EXE_ID').AsInteger;
        Exit;
      end;

      // Si on ne trouve toujours pas on prend l'exercice avec la date la plus récente
      Close;
      SQL.Clear;
      sQL.Add('Select * from GENEXERCICECOMMERCIAL');
      SQL.Add('Where EXE_FIN <= :PDATE');
      SQL.Add('Order By EXE_FIN DESC');
      ParamCheck := True;
      ParamByName('PDATE').AsDate := Now;
      Open;

      if RecordCount > 0 then
        Result := FieldByName('EXE_ID').AsInteger
      else
        raise Exception.Create('GetLastEXECOM -> Erreur données d''exercice commerciale incomplète');
    end;
  end;
end;

function TDM_CMEL.GetLastGenID: Integer;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select GEN_ID(GENERAL_ID,1) as Resultat from GENBASES');
    SQL.Add('Where BAS_ID = 0');
    Open;

    Result := FieldByName('Resultat').AsInteger;
  end;
end;

function TDM_CMEL.GetLastHistoLevis(iMagID, Mode : Integer): TKVersion;
begin
  With aQue_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.add('Select * from MAGASINHISTOLEVIS');
    SQL.Add('Where MHL_MAGID = :PMAGID');
    SQL.Add('  and MHL_OK = 1');
    SQL.Add('  and MHL_TYP = :PType');
    SQL.Add('  and MHL_DATE = (Select Max(MHL_DATE) FROM MAGASINHISTOLEVIS Where MHL_TYP = :PTYPE2 and MHL_MAGID = :PMAGID2 and MHL_OK = 1)');
    SQL.Add('Order by MHL_ID DESC');
    With Parameters do
    begin
      ParamByName('PMAGID').Value := iMagID;
      ParamByName('PMAGID2').Value := iMagId;
      ParamByName('PType').Value   := Mode;
      ParamByName('PType2').Value  := Mode;
    end;
    Open;

    // si on ne trouve pas une existante on prend celle de l'activation
    if RecordCount <= 0 then
    begin
      Close;
      SQL.Clear;
      SQL.add('Select * from MAGASINHISTOLEVIS');
      SQL.Add('Where MHL_MAGID = :PMAGID');
      SQL.Add('  and MHL_OK = 0');
      SQL.Add('  and MHL_TYP = 0');
      SQL.Add('Order by MHL_DATE DESC, MHL_ID DESC');
      With Parameters do
      begin
        ParamByName('PMAGID').Value := iMagID;
      end;
      Open;
    end;

    Result.IdKvTicket := FieldByName('MHL_KVERSIONTCK').AsInteger;
    Result.IdKvBL     := FieldByName('MHL_KVERSIONNEGBL').AsInteger;
    Result.IdKvFact   := FieldByName('MHL_KVERSIONNEGFCT').AsInteger;

    AddToMemo('Dernier K Histo : ' + IntToStr(Result.IdKvTicket) + ' ' +  IntToStr(Result.IdKvBL) + ' ' +  IntToStr(Result.IdKvFact));
  end;
end;

function TDM_CMEL.GetMagMail(GK_MAGID: integer): String;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ADR_EMAIL from GENADRESSE');
    SQL.Add('  join GENMAGASIN on MAG_ADRID = ADR_ID');
    SQL.Add('Where MAG_ID = :PMAGID');
    ParamCheck := True;
    ParamByName('PMAGID').AsInteger := GK_MAGID;
    Open;

    Result := FieldByName('ADR_EMAIL').AsString;
  end;
end;

function TDM_CMEL.GetMarqueId(MRK_IDREF: integer; MRK_NOM, MRK_CONDITION,
  MRK_CODE: String): integer;
var
  iMRKId : Integer;
begin
  Try
    With Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from ARTMARQUE');
      SQL.Add(' join k on k_id = MRK_ID and k_enabled = 1');
      SQL.Add('Where MRK_NOM = :PMRKNOM');
      ParamCheck := True;
      ParamByName('PMRKNOM').AsString := UpperCase(MRK_NOM);
      Open;

      if RecordCount <= 0 then
      begin
        iMRKId := GetNewKId('ARTMARQUE');
        Close;
        SQL.Clear;
        SQL.add('Insert into ARTMARQUE');
        SQL.Add('(MRK_ID,MRK_IDREF,MRK_NOM,MRK_CONDITION,MRK_CODE)');
        SQL.Add('values(:PMRKID,:PMRKIDREF,:PMRKNOM,:PMRKCONDITION,:PMRKCODE)');
        ParamCheck := True;
        ParamByName('PMRKID').AsInteger       := iMRKId;
        ParamByName('PMRKIDREF').AsInteger    := MRK_IDREF;
        ParamByName('PMRKNOM').AsString       := UpperCase(MRK_NOM);
        ParamByName('PMRKCONDITION').AsString := MRK_CONDITION;
        ParamByName('PMRKCODE').AsString      := MRK_CODE;
        ExecSQL;
      end
      else
        iMRKId := FieldByName('MRK_ID').AsInteger;

      Result := iMRKId;
    end;
  Except on E:Exception do
    Raise Exception.Create('GetMarqueId -> ' + E.Message);
  End;
end;

function TDM_CMEL.GetMaxKVersion(KTB_ID: integer;
  K_INSERTED: TDateTime): Integer;
begin
  With Que_GetVersion do
  begin
    close;
    SQL.Clear;
    SQL.Add('Select max(K_VERSION) as Resultat from K');
    SQL.Add('Where K_enabled = 1');
    SQL.Add('  and K_INSERTED <= :PDate');
    SQL.Add('  and KTB_ID = :PKTBID');
    ParamCheck := True;
    ParamByName('PDate').AsDateTime := K_INSERTED;
    ParamByName('PKTBID').AsInteger := KTB_ID;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('Resultat').AsInteger
    else
      Result := 0;

    AddToMemo('GetMaxKVersion : ' + IntToStr(KTB_ID) + ' - ' + IntToStr(Result));
  end;
end;

function TDM_CMEL.GetNewChronoCMD: String;
begin
With Que_ChronoCMD do
  begin
    Close;
    Open;

    Result := FieldByName('NEWNUM').AsString;
  end;
end;

function TDM_CMEL.GetNewKId(sTableName: String): Integer;
begin
  With Que_NewKId do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PTBNAME').AsString := UpperCase(sTableName);
    Open;

    Result := FieldByName('ID').AsInteger;
  end;
end;

function TDM_CMEL.InitGinkoiaDB(BasePath: String; Mode: Integer): Boolean;
var
  sFileName : String;
  lst : TStringList;
begin
  AddToMemo('Connexion à la base de données : ' + BasePath);
  Result := False;
  // Ouverture de la base GINKOIA
  with GinkoiaIBDB do
  begin
    Close;
    DatabaseName := BasePath;
    try
      Open;
      AddToMemo('Connexion effectuée');
    Except on E:Exception do
      raise Exception.Create('Connexion Db Ginkoia Error : ' + E.Message);
    end;
  end;

  case Mode of
    MODESTOCK: begin
      // Envoi de la procédure stockée pour le recalcul
      iboSPRecalc.Close;
      try
        iboSPRecalc.Open;
      Except on E:Exception do
        raise Exception.Create('SP Recalc Error : ' + E.Message);
      end;

      sFileName := 'TF_GETSTOCKFROMEAN';
    end;
    MODEVENTE: begin
      sFileName := '';
      Que_Ventes.Close;
      Que_Ventes.SQL.LoadFromFile(GPATHQRY + 'TF_QRYVENTES.sql');
    end;
    MODECMD: begin
       sFileName := '';
       Que_CMD.Close;
       Que_CMD.SQL.LoadFromFile(GPATHQRY + 'TF_QRYVENTESSEMAINE.sql');
    end;
  end;

  if Trim(sFileName) <> '' then
    With GinkoiaIBDB do
    begin
      // Suppression de l'ancienne procédure stockée
      try
        ExecSQL('Drop procedure ' + sFileName);
      Except on E:Exception do
        // on ne fait rien
        // raise Exception.Create('Drop error : ' + E.Message);
      end;
      // ajout de la procédure stockée
      Try
        lst := TStringList.Create;
        try
          lst.LoadFromFile(GPATHQRY + sFileName + '.sql');
          ExecSQL(lst.text);
        finally
          lst.free;
        end;
      Except on E:Exception do
        raise Exception.Create('Create error : ' + E.Message);
      end;
    end; //with

  Result := True;
end;

function TDM_CMEL.Open2kDatabase: Boolean;
begin
  Result := True;
  try
    ADOConnection.Connected := false;
    ADOConnection.Connected := True;

    aQue_MagList.Close;
    aQue_MagList.Open;

    // Ouvreture de la requete pour la récupération des données de type 1
    // (Stock / Vente)
    aQue_Levis_T1.Close;
    aQue_Levis_T1.Open;

    // Ouverture de la requête pour la récupération des données de type 2
    // (Commande)
    aQue_Levis_T2.Close;
    aQue_Levis_T2.Open;
    
  Except on E:Exception do
    Result := False;
  end;
end;

function TDM_CMEL.SaveHistoLevis(iMagId,iType, iEtat, GEN_ID : Integer): Boolean;
begin
  With aQue_HistoLevis do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Insert into MAGASINHISTOLEVIS');
    SQL.Add('(MHL_MAGID,MHL_DATE,MHL_TYP,MHL_OK,MHL_KVERSIONTCK,MHL_KVERSIONNEGBL,MHL_KVERSIONNEGFCT)');
    SQL.Add('Values(:PMAGID,:PDATE,:PMHLTYP,:PMHLOK,:PKVERSIONTCK,:PKVERSIONNEGBL,:PKVERSIONNEGFCT)');
    ParamCheck := True;
    With Parameters do
    begin
      ParamByName('PMAGID').Value           := iMagId;
      ParamByName('PDATE').Value            := DateOf(Now);
      ParamByName('PMHLTYP').Value          := iType;
      ParamByName('PMHLOK').Value           := iEtat;
      ParamByName('PKVERSIONTCK').Value     := GEN_ID; // GetMaxKVersion(-11111423,Dateof(Now) + Timeof(StrToTime('23:59:59')));
      ParamByName('PKVERSIONNEGBL').Value   := GEN_ID; // GetMaxKVersion(-11111425,Dateof(Now) + Timeof(StrToTime('23:59:59')));
      ParamByName('PKVERSIONNEGFCT').Value  := GEN_ID; // GetMaxKVersion(-11111429,Dateof(Now) + Timeof(StrToTime('23:59:59')));
    end;
    ExecSQL;
  end;
end;

procedure TDM_CMEL.SaveMemo(MAG_CODE : String;Mode : Integer);
var
  sDir : String;
  sMode : String;
begin
  sDir := GAPPPATH + '\Logs\' + FormatDateTime('YYYY\MM\DD\',Now);
  if not DirectoryExists(sDir) then
    ForceDirectories(sDir);

  sMode := '';
  case Mode of
    MODESTOCK: sMode := 'STK_';
    MODEVENTE: sMode := 'VTE_';
    MODECMD  : sMode := 'CMD_';
  end;
  
  FMemo.Lines.SaveToFile(sDir + sMode + MAG_CODE + FormatDateTime('_YYYYMMDDhhmmss',Now) + '.txt');
  FMemo.Clear;
end;

function TDM_CMEL.SetCommande(CDE_NUMERO: String; CDE_SAISON, CDE_EXEID,
  CDE_CPAID, CDE_MAGID, CDE_FOUID: Integer; CDE_NUMFOURN: String;
  CDE_DATE: TDateTime; CDE_REMISE, CDE_TVAHT1, CDE_TVATAUX1, CDE_TVA1,
  CDE_TVAHT2, CDE_TVATAUX2, CDE_TVA2, CDE_TVAHT3, CDE_TVATAUX3, CDE_TVA3,
  CDE_TVAHT4, CDE_TVATAUX4, CDE_TVA4, CDE_TVAHT5, CDE_TVATAUX5,
  CDE_TVA5: single; CDE_FRANCO, CDE_MODIF: Integer; CDE_LIVRAISON: TDateTime;
  CDE_OFFSET: integer; CDE_REMGLO: single; CDE_ARCHIVE: integer;
  CDE_REGLEMENT: TDateTime; CDE_TYPID, CDE_NOTVA, CDE_USRID: integer;
  CDE_COMENT: String): Integer;
var
  iCDEId : Integer;
begin
  With Que_Tmp do
  try
      iCDEId := GetNewKId('COMBCDE');

      Close;
      SQL.Clear;
      SQL.Add('Insert into COMBCDE');
      SQL.Add('(CDE_ID,CDE_NUMERO,CDE_SAISON,CDE_EXEID,CDE_CPAID,CDE_MAGID,CDE_FOUID,');
      SQL.Add('CDE_NUMFOURN, CDE_DATE,CDE_REMISE, CDE_TVAHT1, CDE_TVATAUX1, CDE_TVA1,');
      SQL.Add('CDE_TVAHT2, CDE_TVATAUX2, CDE_TVA2, CDE_TVAHT3, CDE_TVATAUX3, CDE_TVA3,');
      SQL.Add('CDE_TVAHT4, CDE_TVATAUX4, CDE_TVA4, CDE_TVAHT5, CDE_TVATAUX5,');
      SQL.Add('CDE_TVA5,CDE_FRANCO,CDE_MODIF,CDE_LIVRAISON,CDE_OFFSET,CDE_REMGLO,CDE_ARCHIVE,');
      SQL.Add('CDE_REGLEMENT,CDE_TYPID, CDE_NOTVA, CDE_USRID,CDE_COMENT)');
      SQL.Add('Values(:PCDEID,:PCDENUMERO,:PCDESAISON,:PCDEEXEID,:PCDECPAID,:PCDEMAGID,:PCDEFOUID,');
      SQL.Add(':PCDENUMFOURN,:PCDEDATE,:PCDEREMISE,:PCDETVAHT1,:PCDETVATAUX1,:PCDETVA1,');
      SQL.Add(':PCDETVAHT2,:PCDETVATAUX2,:PCDETVA2,:PCDETVAHT3,:PCDETVATAUX3,:PCDETVA3,');
      SQL.Add(':PCDETVAHT4,:PCDETVATAUX4,:PCDETVA4,:PCDETVAHT5,:PCDETVATAUX5,');
      SQL.Add(':PCDETVA5,:PCDEFRANCO,:PCDEMODIF,:PCDELIVRAISON,:PCDEOFFSET,:PCDEREMGLO,:PCDEARCHIVE,');
      SQL.Add(':PCDEREGLEMENT,:PCDETYPID,:PCDENOTVA,:PCDEUSRID,:PCDECOMENT)');
      ParamCheck := True;
      ParamByName('PCDEID').AsInteger      := iCDEId;
      ParamByName('PCDENUMERO').AsString   := CDE_NUMERO;
      ParamByName('PCDESAISON').AsInteger  := CDE_SAISON;
      ParamByName('PCDEEXEID').AsInteger   := CDE_EXEID;
      ParamByName('PCDECPAID').AsInteger   := CDE_CPAID;
      ParamByName('PCDEMAGID').AsInteger   := CDE_MAGID;
      ParamByName('PCDEFOUID').AsInteger   := CDE_FOUID;
      ParamByName('PCDENUMFOURN').AsString := CDE_NUMFOURN;
      ParamByName('PCDEDATE').AsDate       := CDE_DATE;
      ParamByName('PCDEREMISE').AsFloat    := CDE_REMISE;
      ParamByName('PCDETVAHT1').AsCurrency := CDE_TVAHT1;
      ParamByName('PCDETVATAUX1').AsCurrency := CDE_TVATAUX1;
      ParamByName('PCDETVA1').AsCurrency   := CDE_TVA1;
      ParamByName('PCDETVAHT2').AsCurrency := CDE_TVAHT2;
      ParamByName('PCDETVATAUX2').AsCurrency := CDE_TVATAUX2;
      ParamByName('PCDETVA2').AsCurrency   := CDE_TVA2;
      ParamByName('PCDETVAHT3').AsCurrency := CDE_TVAHT3;
      ParamByName('PCDETVATAUX3').AsCurrency := CDE_TVATAUX3;
      ParamByName('PCDETVA3').AsCurrency   := CDE_TVA3;
      ParamByName('PCDETVAHT4').AsCurrency := CDE_TVAHT4;
      ParamByName('PCDETVATAUX4').AsCurrency := CDE_TVATAUX4;
      ParamByName('PCDETVA4').AsCurrency   := CDE_TVA4;
      ParamByName('PCDETVAHT5').AsCurrency := CDE_TVAHT5;
      ParamByName('PCDETVATAUX5').AsCurrency := CDE_TVATAUX5;
      ParamByName('PCDETVA5').AsCurrency   := CDE_TVA5;
      ParamByName('PCDEFRANCO').AsInteger  := CDE_FRANCO;
      ParamByName('PCDEMODIF').AsInteger   := CDE_MODIF;
      ParamByName('PCDELIVRAISON').AsDate  := CDE_LIVRAISON;
      ParamByName('PCDEOFFSET').AsInteger  := CDE_OFFSET;
      ParamByName('PCDEREMGLO').AsFloat    := CDE_REMGLO;
      ParamByName('PCDEARCHIVE').AsInteger := CDE_ARCHIVE;
      ParamByName('PCDEREGLEMENT').AsDate  := CDE_REGLEMENT;
      ParamByName('PCDETYPID').AsInteger   := CDE_TYPID;
      ParamByName('PCDENOTVA').AsInteger   := CDE_NOTVA;
      ParamByName('PCDEUSRID').AsInteger   := CDE_USRID;
      ParamByName('PCDECOMENT').AsString   := CDE_COMENT;
      ExecSQL;

      Result := iCDEId;
  Except on E:Exception do
    raise Exception.Create('SetCMD -> ' + E.Message);
  end;
end;

function TDM_CMEL.SetCommandeLigneId(CDL_CDEID, CDL_ARTID, CDL_TGFID,
  CDL_COUID: integer; CDL_QTE, CDL_PXCTLG, CDL_REMISE1, CDL_REMISE2,
  CDL_REMISE3, CDL_PXACHAT, CDL_TVA, CDL_PXVENTE: single; CDL_OFFSET: integer;
  CDL_LIVRAISON: TDateTime; CDL_TARTAILLE: integer;
  CDL_VALREMGLO: single): Integer;
var
  iCDLId : integer;
begin
  With Que_Tmp do
  try
    iCDLId := GetNewKId('COMBCDEL');
    Close;
    SQL.Clear;
    SQL.Add('insert into COMBCDEL');
    SQL.Add('(CDL_ID,CDL_CDEID, CDL_ARTID, CDL_TGFID,CDL_COUID,CDL_QTE,CDL_PXCTLG,CDL_REMISE1,');
    SQL.Add('CDL_REMISE2,CDL_REMISE3,CDL_PXACHAT,CDL_TVA,CDL_PXVENTE,CDL_OFFSET,');
    SQL.Add('CDL_LIVRAISON,CDL_TARTAILLE,CDL_VALREMGLO)');
    SQL.Add('Values(:PCDLID,:PCDLCDEID,:PCDLARTID,:PCDLTGFID,:PCDLCOUID,:PCDLQTE,:PCDLPXCTLG,:PCDLREMISE1,');
    SQL.Add(':PCDLREMISE2,:PCDLREMISE3,:PCDLPXACHAT,:PCDLTVA,:PCDLPXVENTE,:PCDLOFFSET,');
    SQL.Add(':PCDLLIVRAISON,:PCDLTARTAILLE,:PCDLVALREMGLO)');
    ParamCheck := True;
    ParamByName('PCDLID').AsInteger        := iCDLId;
    ParamByName('PCDLCDEID').AsInteger     := CDL_CDEID;
    ParamByName('PCDLARTID').AsInteger     := CDL_ARTID;
    ParamByName('PCDLTGFID').AsInteger     := CDL_TGFID;
    ParamByName('PCDLCOUID').AsInteger     := CDL_COUID;
    ParamByName('PCDLQTE').AsFloat         := CDL_QTE;
    ParamByName('PCDLPXCTLG').AsFloat      := CDL_PXCTLG;
    ParamByName('PCDLREMISE1').AsFloat     := CDL_REMISE1;
    ParamByName('PCDLREMISE2').AsFloat     := CDL_REMISE2;
    ParamByName('PCDLREMISE3').AsFloat     := CDL_REMISE3;
    ParamByName('PCDLPXACHAT').AsCurrency  := CDL_PXACHAT;
    ParamByName('PCDLTVA').AsCurrency      := CDL_TVA;
    ParamByName('PCDLPXVENTE').AsCurrency  := CDL_PXVENTE;
    ParamByName('PCDLOFFSET').AsInteger    := CDL_OFFSET;
    ParamByName('PCDLLIVRAISON').AsDate    := CDL_LIVRAISON;
    ParamByName('PCDLTARTAILLE').AsInteger := CDL_TARTAILLE;
    ParamByName('PCDLVALREMGLO').AsFloat   := CDL_VALREMGLO;
    ExecSQL;

    Result := iCDLId;

  Except on E:Exception do
    raise Exception.Create('SetCMDLigne -> ' + E.Message);
  end;
end;

function TDM_CMEL.SetFournisseur(FOU_IDREF: integer; FOU_NOM: String;
  FOU_ADRID: integer; FOU_TEL, FOU_FAX, FOU_EMAIL: String; FOU_REMISE: single;
  FOU_GROS: integer; FOU_CDTCDE, FOU_CODE, FOU_TEXTCDE: String;
  FOU_MAGIDPF: integer): integer;
var
  iFOUID : integer;
begin
  Try
    With Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTFOURN');
      SQL.Add(' join k on k_id = FOU_ID and k_enabled = 1');
      SQL.Add('Where FOU_ADRID = :PADRID');
      SQL.Add('  and FOU_NOM   = :PFOUNOM');
      Open;

      if Recordcount <= 0 then
      begin
        iFOUID := GetNewKId('ARTFOURN');
        Close;
        SQL.Clear;
        SQL.Add('Insert into ARTFOURN');
        SQL.Add('(FOU_ID,FOU_IDREF,FOU_NOM,FOU_ADRID,FOU_TEL,FOU_FAX,FOU_EMAIL,');
        SQL.Add('FOU_REMISE,FOU_GROS,FOU_CDTCDE,FOU_CODE,FOU_TEXTCDE,FOU_MAGIDPF)');
        SQL.Add('Values(:PFOUID,:PFOUIDREF,:PFOUNOM,:PFOUADRID,:PFOUTEL,:PFOUFAX,:PFOUEMAIL,');
        SQL.Add(':PFOUREMISE,:PFOUGROS,:PFOUCDTCDE,:PFOUCODE,:PFOUTEXTCDE,:PFOUMAGIDPF)');
        ParamCheck := True;
        ParamByName('PFOUID').AsInteger      := iFOUID;
        ParamByName('PFOUIDREF').AsInteger   := FOU_IDREF;
        ParamByName('PFOUNOM').AsString      := UpperCase(FOU_NOM);
        ParamByName('PFOUADRID').AsInteger   := FOU_ADRID;
        ParamByName('PFOUTEL').AsString      := FOU_TEL;
        ParamByName('PFOUFAX').AsString      := FOU_FAX;
        ParamByName('PFOUEMAIL').AsString    := FOU_EMAIL;
        ParamByName('PFOUREMISE').AsFloat    := FOU_REMISE;
        ParamByName('PFOUGROS').AsInteger    := FOU_GROS;
        ParamByName('PFOUCDTCDE').AsString   := FOU_CDTCDE;
        ParamByName('PFOUCODE').AsString     := FOU_CODE;
        ParamByName('PFOUTEXTCDE').AsString  := FOU_TEXTCDE;
        ParamByName('PFOUMAGIDPF').AsInteger := FOU_MAGIDPF;
        ExecSQL;
      end
      else
        iFOUID := FieldByName('FOU_ID').AsInteger;
         
      Result := iFOUID;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetFournisseur -> ' + E.Message);
  End;
end;

function TDM_CMEL.SetFournisseurDetails(FOD_FOUID, FOD_MAGID: Integer;
  FOD_NUMCLIENT, FOD_COMENT: String; FOD_FTOID, FOD_MRGID, FOD_CPAID: Integer;
  FOD_ENCOURSA: single; FOD_COMPTA: String; FOD_FRANCOPORT: Single): Integer;
var
  IdFOD : integer;
begin
  Try
    With Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTFOURNDETAIL');
      SQL.Add('  join k on K_ID = FOD_ID and k_enabled = 1');
      SQL.Add('Where FOD_FOUID = :PFOUID');
      ParamCheck := True;
      ParamByName('PFOUID').AsInteger := FOD_FOUID;
      Open;

      If RecordCount  = 0 then
      begin
        IdFod := GetNewKId('ARTFOURNDETAIL');
        Close;
        SQL.Clear;
        SQL.Add('Insert into ARTFOURNDETAIL');
        SQL.Add('(FOD_ID,FOD_FOUID,FOD_MAGID,FOD_NUMCLIENT,FOD_COMENT,FOD_FTOID,FOD_MRGID,FOD_CPAID,FOD_ENCOURSA,FOD_COMPTA)');
        SQL.Add('Values(:PFODID,:PFODFOUID,:PFODMAGID,:PFODNUMCLIENT,:PFODCOMENT,:PFODFTOID,:PFODMRGID,:PFODCPAID,:PFODENCOURSA,:PFODCOMPTA)');
        ParamCheck := True;
        ParamByName('PFODID').AsInteger       := IdFod;
        ParamByName('PFODFOUID').AsInteger    := FOD_FOUID;
        ParamByName('PFODMAGID').AsInteger    := FOD_MAGID;
        ParamByName('PFODNUMCLIENT').AsString := FOD_NUMCLIENT;
        ParamByName('PFODCOMENT').AsString    := FOD_COMENT;
        ParamByName('PFODFTOID').AsInteger    := FOD_FTOID;
        ParamByName('PFODMRGID').AsInteger    := FOD_MRGID;
        ParamByName('PFODCPAID').AsInteger    := FOD_CPAID;
        ParamByName('PFODENCOURSA').AsFloat   := FOD_ENCOURSA;
        ParamByName('PFODCOMPTA').AsFloat     := FOD_FRANCOPORT;
        ExecSQL;
      end
      else
        IdFod := FieldByName('FOD_ID').AsInteger;
    end;
    
    Result := IdFOD;
  Except on E:Exception do
    raise Exception.Create('SetFournisseursDetails -> ' + E.Message);
  End;
end;

function TDM_CMEL.SetMrkFour(FMK_FOUID, FMK_MRKID, FMK_PRIN: integer): Integer;
var
  idMrkFOU : integer;
  bPrinExist : Boolean;
begin
  try
    With Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTMRKFOURN');
      SQL.Add('  Join k on K_ID = FMK_ID and k_enabled = 1');
      SQL.Add('Where FMK_FOUID = :PFOUID');
      SQL.Add('  and FMK_MRKID = :PMRKID');
      ParamCheck := True;
      ParamByName('PFOUID').AsInteger := FMK_FOUID;
      ParamByName('PMRKID').AsInteger := FMK_MRKID;
      Open;

      if Recordcount = 0 then
      begin
        idMrkFOU := GetNewKId('ARTMRKFOURN');
        // vérification si la marque a déjà un fournisseur par défaut
        Close;
        SQL.Clear;
        SQL.Add('Select * from ARTMRKFOURN');
        SQL.Add(' join k on k_id = FMK_ID and k_enabled = 1');
        SQL.Add('Where FMK_MRKID = :PMRKID');
        SQL.Add('  and FMK_PRIN = 1');
        ParamCheck := True;
        ParamByName('PMRKID').AsInteger := FMK_MRKID;
        Open;
        bPrinExist := (RecordCount >= 1);


        Close;
        SQL.Clear;
        SQL.Add('insert into ARTMRKFOURN');
        SQL.Add('(FMK_ID, FMK_FOUID,FMK_MRKID,FMK_PRIN)');
        SQL.Add('Values(:PFMKID,:PFMKFOUID,:PFMKMRKID,:PFMKPRIN)');
        ParamCheck := True;
        ParamByName('PFMKID').AsInteger    := idMrkFOU;
        ParamByName('PFMKFOUID').AsInteger := FMK_FOUID;
        ParamByName('PFMKMRKID').AsInteger := FMK_MRKID;
        if bPrinExist then
          ParamByName('PFMKPRIN').AsInteger  := 0
        else
          ParamByName('PFMKPRIN').AsInteger  := 1;

        ExecSQL;
      end else
        idMrkFOU := FieldByName('FMK_ID').AsInteger;
    end;
    Result := idMrkFOU;
  Except on E:Exception do
    raise Exception.Create('SetMrkFour -> ' + E.Message);
  end;
end;

end.
