unit ReaAutoMain_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, IB_Components, IBODataset, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdFTP, dxmdaset, Stdctrls, uDefs, ComCtrls, DateUtils, Windows, forms,
  IB_Access, ExtCtrls, IniCfg_Frm;

type
  TDM_ReaAuto = class(TDataModule)
    GinkoiaIBDB: TIBODatabase;
    IdFTP1: TIdFTP;
    aQue_LstMag: TADOQuery;
    aQue_lstMarque_S2K: TADOQuery;
    aQue_LstArt: TADOQuery;
    MemD_StockTemp_S2K: TdxMemData;
    MemD_StockTemp_S2KDate: TDateField;
    MemD_StockTemp_S2KNomMagasin: TStringField;
    MemD_StockTemp_S2KNomMarque: TStringField;
    MemD_StockTemp_S2KNomFournisseur: TStringField;
    MemD_StockTemp_S2KCodeArticle: TStringField;
    MemD_StockTemp_S2KQuantite: TIntegerField;
    aQue_Tmp: TADOQuery;
    Que_Tmp: TIBOQuery;
    iboSPRecalc: TIBOStoredProc;
    MemD_FTPToSend: TdxMemData;
    MemD_FTPToSendMAG_CODE: TStringField;
    MemD_FTPToSendRAM_TRIGRAM: TStringField;
    MemD_FTPToSendFileName: TStringField;
    MemD_FTPToSendFTPDir: TStringField;
    MemD_FTPToSendMAG_ID: TIntegerField;
    MemD_FTPToSendMRK_ID: TIntegerField;
    MemD_VenteTemp_S2K: TdxMemData;
    MemD_VenteTemp_S2KNomMagasin: TStringField;
    MemD_VenteTemp_S2KDate: TDateTimeField;
    MemD_VenteTemp_S2KNomMarque: TStringField;
    MemD_VenteTemp_S2KNomFournisseur: TStringField;
    MemD_VenteTemp_S2KCodeArticle: TStringField;
    MemD_VenteTemp_S2KValeurMoneraire: TCurrencyField;
    MemD_VenteTemp_S2KPrix1: TCurrencyField;
    MemD_VenteTemp_S2KPrix2: TCurrencyField;
    MemD_VenteTemp_S2KQuantiteVendue: TIntegerField;
    MemD_VenteTemp_S2KQuantiteRetournee: TIntegerField;
    Que_GetVersion: TIBOQuery;
    Que_Ventes: TIBOQuery;
    ADOConnection: TADOConnection;
    Que_GetNomfourn: TIBOQuery;
    MemD_StockTemp_S2KIdMagasin: TStringField;
    MemD_VenteTemp_S2KIdMagasin: TStringField;
    aQue_GetInfoMrk: TADOQuery;
    MemD_VenteTemp_ISF: TdxMemData;
    MemD_StockTemp_ISF: TdxMemData;
    MemD_StockTemp_ISFExpediteur: TStringField;
    MemD_StockTemp_ISFDestinataire: TStringField;
    MemD_StockTemp_ISFTypeEDIINVRPT: TStringField;
    MemD_StockTemp_ISFIdMessage: TStringField;
    MemD_StockTemp_ISFTypeDate1: TIntegerField;
    MemD_StockTemp_ISFDate1: TDateTimeField;
    MemD_StockTemp_ISFTypeDate2: TIntegerField;
    MemD_StockTemp_ISFDate2: TDateField;
    MemD_StockTemp_ISFTypeDate3: TIntegerField;
    MemD_StockTemp_ISFDate3: TDateField;
    MemD_StockTemp_ISFTypeDate4: TIntegerField;
    MemD_StockTemp_ISFDate4: TDateField;
    MemD_StockTemp_ISFTypePartenaire1: TStringField;
    MemD_StockTemp_ISFIdPartenaire1: TStringField;
    MemD_StockTemp_ISFNomPartenaire1: TStringField;
    MemD_StockTemp_ISFTypePartenaire2: TStringField;
    MemD_StockTemp_ISFIdPartenaire2: TStringField;
    MemD_StockTemp_ISFNomPartenaire2: TStringField;
    MemD_StockTemp_ISFLigneIdLigne: TIntegerField;
    MemD_StockTemp_ISFLigneCodeArticle: TStringField;
    MemD_StockTemp_ISFLigneQuantiteTypeQuantite: TIntegerField;
    MemD_StockTemp_ISFLigneQuantiteQuantite: TIntegerField;
    MemD_StockTemp_ISFLigneQuantiteIdAcheteur: TStringField;
    MemD_StockTemp_ISFLigneQuantiteNomAcheteur: TStringField;
    MemD_StockTemp_ISFLigneQuantiteTypeLieu: TStringField;
    MemD_StockTemp_ISFLigneQuantiteLieu: TStringField;
    aQue_lstMarque_ISF: TADOQuery;
    MemD_VenteTemp_ISFExpediteur: TStringField;
    MemD_VenteTemp_ISFDestinataire: TStringField;
    MemD_VenteTemp_ISFTypeEDISLSRPT: TStringField;
    MemD_VenteTemp_ISFIdMessage: TStringField;
    MemD_VenteTemp_ISFTypeDate1: TIntegerField;
    MemD_VenteTemp_ISFTypeDate2: TIntegerField;
    MemD_VenteTemp_ISFTypeDate3: TIntegerField;
    MemD_VenteTemp_ISFDate1: TDateTimeField;
    MemD_VenteTemp_ISFDate2: TDateTimeField;
    MemD_VenteTemp_ISFTypePartenaire1: TStringField;
    MemD_VenteTemp_ISFIdPartenaire1: TStringField;
    MemD_VenteTemp_ISFNomPartenaire1: TStringField;
    MemD_VenteTemp_ISFTypePartenaire2: TStringField;
    MemD_VenteTemp_ISFIdPartenaire2: TStringField;
    MemD_VenteTemp_ISFNomPartenaire2: TStringField;
    MemD_VenteTemp_ISFDevise: TStringField;
    MemD_VenteTemp_ISFLieuTypeLieu: TIntegerField;
    MemD_VenteTemp_ISFLieuLieu: TStringField;
    MemD_VenteTemp_ISFLieuLigneIdLigne: TIntegerField;
    MemD_VenteTemp_ISFLieuLigneCodeArticle: TStringField;
    MemD_VenteTemp_ISFLieuLigneTypeReference: TStringField;
    MemD_VenteTemp_ISFLieuLigneReference: TStringField;
    MemD_VenteTemp_ISFLieuLigneTypeValeurMonetaire: TStringField;
    MemD_VenteTemp_ISFLieuLigneValeurMonetaire: TStringField;
    MemD_VenteTemp_ISFLieuLigneTypePrix1: TStringField;
    MemD_VenteTemp_ISFLieuLignePrix1: TStringField;
    MemD_VenteTemp_ISFLieuLigneTypePrix2: TStringField;
    MemD_VenteTemp_ISFLieuLignePrix2: TStringField;
    MemD_VenteTemp_ISFLieuLigneTypeQuantite: TStringField;
    MemD_VenteTemp_ISFLieuLigneQuantite: TIntegerField;
    MemD_VenteTemp_ISFLieuLigneTypePartenaire: TStringField;
    MemD_VenteTemp_ISFLieuLigneIdPartenaire: TStringField;
    MemD_VenteTemp_ISFLieuLigneNomPartenaire: TStringField;
    Tim_TimoutDb: TTimer;
    MemD_VenteTemp_ISFDate3: TStringField;
    aQue_LstMagDbL: TADOQuery;
    procedure Tim_TimoutDbTimer(Sender: TObject);
  private
    { Déclarations privées }
    FMemo : TMemo;
    FProgressMag: TProgressBar;
    FProgressMrk: TprogressBar;
    FProgressFTP: TProgressBar;

    FIsTimeOut : Boolean;
    FLabMagNom: TLabel;
    FLabMrkNom: TLabel;
  public
    { Déclarations publiques }
    // Fonction d'ajout de données de tracage
    function AddToTrace(MAG_ID, MRK_ID : Integer; NOMFIC : String;dDateGene : TDateTime) : Boolean;
    function UpdateTrace(NOMFIC : String;dDateFTP : TDateTime) : Boolean;
    // Fonction qui permet de traiter les fichiers restant dans ToSend
    function CheckToSend : Boolean;
    function GetInfoMrk(sField : String;MRK_ID : Integer) : String;
    // Fonction d'ajout de logs (Memo et fichier log
    procedure AddToMemo(sText : String);

    procedure AddtoLabMag(sText : String);
    procedure AddToLabMrk(sText : String);

    // fonction de gestion de l'historique
    function AddtoHisto(REH_MAGID,REH_MRKID : Integer;REH_DATE : TDateTime;REH_OK, REH_TYP, REH_VERSIONTCK, REH_VERSIONNEGBL,REH_VERSIONNEGFCT : Integer) : Boolean;

    // Ouverture de la base de données SP2K
    function Open2kDatabase : Boolean;
    // Ouverture de la base ginkoia et mise ne place des procédure stockée selon le MODE
    function InitGinkoiaDB(BasePath : String;Mode : TMode) : Boolean;
    // Permet de retrouver l'MAG_ID ginkoia
    function FindMagID(MAG_CODE : String) : Integer;
    // Permet de retrouver le MRK_Id par le nom de la marque, retourne -1 si non trouvé
    function FindMrkId(MRK_NOM : String) : Integer;
    // Permet de retrouver le nom du fouunisseur d'une marque
    function FindFourNom(MRK_ID : Integer) : String;

  // ---- Gestion des K ----
    // récupère le dernier KHisto dans la base de données MSSQL
    function GetLastHisto(REH_MAGID, REH_MRKID, Mode : Integer) : TKVersion;
    // Récupère le dernier K_ID de la base de données IB en cours
    function GetLastGenID : Integer;
    // Permet de récupérer le dernier K_ID à une date d'une table
    function GetMaxKVersion(KTB_ID : integer;K_INSERTED : TDateTime) : Integer;

  // Fonction FTP
    function SendFileToFTP : Boolean;

  // Fonctions de gestion du recalcul des stocks
    // Retourne si le AREAN existe bien dans la base de données pour le TYPE
    function ExecutePSStock(AREA_EAN : String;ACBI_TYPE : Integer; ADoRecalc : Boolean = True) : Boolean;
//    procedure CreatePSStock;
//    Procedure DeletePsStock;

    // Retourne le BAS_GUID à partir du BAS_MAGID
    function FindGUID(const MAG_ID: Integer): String;

    property Memo : TMemo read FMemo write FMemo;
    property ProgressMag : TProgressBar read FProgressMag Write FProgressMag;
    Property ProgressMrk : TprogressBar read FProgressMrk Write FProgressMrk;
    property ProgressFTP : TProgressBar read FProgressFTP Write FProgressFTP;
    property LabMagNom : TLabel read FLabMagNom write FLabMagNom;
    property LabMrkNom : TLabel read FLabMrkNom write FLabMrkNom;
  end;

var
  DM_ReaAuto: TDM_ReaAuto;

implementation

{$R *.dfm}

{ TDM_ReaAuto }
{ TDM_ReaAuto }

function TDM_ReaAuto.AddtoHisto(REH_MAGID, REH_MRKID: Integer;
  REH_DATE: TDateTime; REH_OK, REH_TYP, REH_VERSIONTCK, REH_VERSIONNEGBL,
  REH_VERSIONNEGFCT: Integer): Boolean;
begin
  With aQue_Tmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Insert into REAMAGASINHISTO');
    SQL.Add('(REH_MAGID, REH_MRKID,REH_DATE,REH_OK, REH_TYP, REH_KVERSIONTCK, REH_KVERSIONNEGBL,REH_KVERSIONNEGFCT, REH_INSERTED)');
    SQL.Add('Values');
    SQL.Add('(:PMAGID,:PMRKID,:PDATE,:POK,:PTYP,:PTCK,:PNEGBL,:PNEGFCT,:PINSERTED)');
    ParamCheck := True;
    With Parameters do
    begin
      ParamByName('PMAGID').Value    := REH_MAGID;
      ParamByName('PMRKID').Value    := REH_MRKID;
      ParamByName('PDATE').Value     := REH_DATE;
      ParamByName('POK').Value       := REH_OK;
      ParamByName('PTYP').Value      := REH_TYP;
      ParamByName('PTCK').Value      := REH_VERSIONTCK;
      ParamByName('PNEGBL').Value    := REH_VERSIONNEGBL;
      ParamByName('PNEGFCT').Value   := REH_VERSIONNEGFCT;
      ParamByName('PINSERTED').Value := Now;
    end;
    ExecSQL;
  Except on E:Exception do
    raise Exception.create('AddtoHisto -> ' + E.Message);
  end;
end;

procedure TDM_ReaAuto.AddtoLabMag(sText: String);
begin
  if Assigned(FLabMagNom) then
  begin
    FLabMagNom.Caption := sText;
    FLabMagNom.Update;
  end;
end;

procedure TDM_ReaAuto.AddToLabMrk(sText: String);
begin
  if Assigned(FLabMrkNom) then
  begin
    FLabMrkNom.Caption := sText;
    FLabMrkNom.Update;
  end;
end;

procedure TDM_ReaAuto.AddToMemo(sText: String);
var
  FFile : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;

begin
  With FMemo do
  begin
    sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + sText;
    if Assigned(FMemo) then
      FMemo.Lines.Add(sLigne);

    if FileExists(GFILELOG) then
    begin
      FFile := TFileStream.Create(GFILELOG,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd);
    end else
      FFile := TFileStream.Create(GFILELOG,fmCreate);
    try
      // Ajoute un retour à la ligne pour le fichier text
      sLigne := sLigne + #13#10;
      Encoding := TEncoding.Default;
      Buffer := Encoding.GetBytes(sLigne);
      FFile.Write(Buffer[0],Length(Buffer));

      //      FFile.Write(sLigne[1],Length(sLigne));
    finally
      FFile.Free;
    end;
  end;
end;

function TDM_ReaAuto.AddToTrace(MAG_ID, MRK_ID: Integer; NOMFIC: String;
  dDateGene: TDateTime): Boolean;
begin
  Result := False;
  With aQue_Tmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Insert into REATRACE (RET_MAGID, RET_MRKID, RET_NOMFIC, RET_DATEGENE)'); //, RET_DATEENVOI)');
    SQL.Add('Values (:PMAGID, :PMRKID, :PNOMFIC, :PDATEGENE)'); // , :PDATEENVOI)');
    ParamCheck := True;
    With Parameters do
    begin
      ParamByName('PMAGID').Value := MAG_ID;
      ParamByName('PMRKID').Value := MRK_ID;
      ParamByName('PNOMFIC').Value := NOMFIC;
      ParamByName('PDATEGENE').Value := dDateGene;
//      ParamByName('PDATEENVOI').Value := Now;
    end;
    ExecSQL;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('AddToTrace -> ' + E.Message);
  end;
end;

function TDM_ReaAuto.CheckToSend: Boolean;
var
  lst : TStringList;
begin
  lst := TStringList.Create;
  With aQue_Tmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from REATRACE');
    SQL.Add('Where RET_DATEENVOI IS NULL Or RET_DATEENVOI = :PDATEENVOI');
    ParamCheck := True;
    Parameters.ParamByName('PDATEENVOI').Value := 0;
    Open;

    First;
    while not EOF do
    begin
      if not MemD_FTPToSend.Locate('Filename',FieldByName('RET_NOMFIC').AsString,[locaseInsensitive]) then
      begin
        lst.Text := StringReplace(FieldByName('RET_NOMFIC').AsString,'_',#13#10,[rfReplaceAll]);

        MemD_FTPToSend.Append;
        MemD_FTPToSend.FieldByName('MAG_ID').AsInteger := FieldByName('RET_MAGID').AsInteger;
        MemD_FTPToSend.FieldByName('MRK_ID').AsInteger := FieldByName('RET_MRKID').AsInteger;
//        if (IniStruct.Client = 2) then
        if (IniCfg.ClientType = 2) then
        begin
          MemD_FTPToSend.FieldByName('MAG_CODE').AsString :='';
          MemD_FTPToSend.FieldByName('RAM_TRIGRAM').AsString := '';
        end
        else
        begin
          MemD_FTPToSend.FieldByName('MAG_CODE').AsString :=lst[3];
          MemD_FTPToSend.FieldByName('RAM_TRIGRAM').AsString := lst[1];
        end;
        MemD_FTPToSend.FieldByName('FileName').AsString := FieldByName('RET_NOMFIC').AsString;
        MemD_FTPToSend.FieldByName('FTPDir').AsString := GetInfoMrk('RAM_REPFTP',FieldByName('RET_MRKID').AsInteger);
        MemD_FTPToSend.Post;
      end;

      Next;
    end;
  finally
    lst.free;
  end;
end;

//procedure TDM_ReaAuto.CreatePSStock;
//begin
//  With GinkoiaIBDB do
//  begin
//    Try
//      With TStringList.Create do
//      try
//        iboSPRecalc.Close;
//        iboSPRecalc.StoredProcName := '';
//        LoadFromFile(GDIRFILES + 'TF_TRIGGERDIFFERE_ARTICLE.sql');
//        ExecSQL(Text);
//        iboSPRecalc.StoredProcName := 'TF_TRIGGERDIFFERE_ARTICLE';
//      finally
//        Free;
//      end;
//    Except on E:Exception do
//      AddToMemo('-- Erreur de création de la procédure recalculstock : ' + E.Message);
//    End;
//  end;
//end;

//procedure TDM_ReaAuto.DeletePsStock;
//begin
//  With GinkoiaIBDB do
//  begin
//    Try
//      ExecSQL('Drop procedure TF_TRIGGERDIFFERE_ARTICLE');
//    Except on E:Exception do
//      AddToMemo('-- Erreur de suppression de la priocédure stockée de recalcul : ' + E.Message);
//    End;
//  end;
//end;

function TDM_ReaAuto.ExecutePSStock(AREA_EAN: String;ACBI_TYPE : Integer; ADoRecalc: Boolean) : Boolean;
begin
  Result := False;
  With Que_Tmp do
  begin
    SQL.Clear;
    SQL.Add('Select ART_ID, CBI_CB from ARTARTICLE');
    SQL.Add(' join K on K_ID = ART_ID and K_Enabled = 1');
    SQL.Add(' join ARTREFERENCE on ART_ID = ARF_ARTID');
    SQL.Add(' join ARTCODEBARRE on CBI_ARFID = ARF_ID');
    SQL.Add(' join K on K_ID = CBI_ID and K_Enabled = 1');
    SQL.Add('Where CBI_CB = :PEAN');
    SQL.Add('  and CBI_TYPE = :PTYPE');
    ParamCheck := True;
    ParamByName('PEAN').AsString := AREA_EAN;
    ParamByName('PTYPE').AsInteger := ACBI_TYPE;
    Open;
  end;

  if Que_Tmp.RecordCount > 0 then
  begin
    if ADoRecalc then
      With iboSPRecalc do
      try
        AddToMemo(' Recalcul Triggerdiff');
        StoredProcName := 'TF_TRIGGERDIFFERE_ARTICLE';
        if Trim(StoredProcName) <> '' then
        begin
          ParamCheck := True;
          ParamByName('ART_ID').AsInteger := Que_Tmp.FieldByName('ART_ID').AsInteger;
          Open;
        end;
      Except on E:Exception do
        AddToMemo('--Erreur Execution recalcul : ' + E.Message);
      end;
    Result := (Que_Tmp.RecordCount > 0);
  end;
end;

function TDM_ReaAuto.FindFourNom(MRK_ID: Integer): String;
begin
  With Que_GetNomfourn do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select FOU_NOM from ARTFOURN join K on K_ID = FOU_ID and K_Enabled = 1');
    SQL.Add('  join ARTMRKFOURN on FOU_ID = FMK_FOUID');
    SQL.Add('  join ARTMARQUE on MRK_ID = FMK_MRKID');
    SQL.Add('Where FMK_PRIN = 1');
    SQL.Add('  and MRK_ID = :PMRKID');
    ParamCheck := True;
    ParamByName('PMRKID').AsInteger := MRK_ID;
    Open;

    Result := FieldByName('FOU_NOM').AsString;
  end;
end;

function TDM_ReaAuto.FindGUID(const MAG_ID: Integer): String;
begin
  Result := SysUtils.EmptyStr;
  try
    try
      Que_Tmp.Close;
      Que_Tmp.SQL.Clear;
      Que_Tmp.SQL.Add( 'select GENBASES.BAS_GUID from GENBASES' );
      Que_Tmp.SQL.Add( 'join K KBAS on KBAS.K_ID = GENBASES.BAS_ID and KBAS.K_ENABLED = 1' );
      Que_Tmp.SQL.Add( 'join K KMAG on KMAG.K_ID = GENBASES.BAS_MAGID and KMAG.K_ENABLED = 1' );
      Que_Tmp.SQL.Add( 'where GENBASES.BAS_MAGID = :MAG_ID;' );
      Que_Tmp.ParamByName( 'MAG_ID' ).AsInteger := MAG_ID;
      Que_Tmp.Open;
      case Que_Tmp.RecordCount of
        0: raise Exception.CreateFmt( 'Aucun GUID ne correspond au magasin %d', [ MAG_ID ] );
        1: Exit( Que_Tmp.Fields[ 0 ].AsString );
        else raise Exception.CreateFmt( 'Plusieurs GUID correspondent au magasin %d', [ MAG_ID ] );
      end;
    finally
      Que_Tmp.Close;
      Que_Tmp.SQL.Clear;
    end;
  except
  end;
end;

function TDM_ReaAuto.FindMagID(MAG_CODE: String): Integer;
begin
  With Que_Tmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select MAG_ID from GENMAGASIN');
    SQL.Add('Where MAG_CODEADH = :PCODEADH');
    ParamCheck := True;
    ParamByName('PCODEADH').AsString := MAG_CODE;
    Open;

    Result := FieldByName('MAG_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('FindMagID -> ' + E.Message);
  end;
end;

function TDM_ReaAuto.FindMrkId(MRK_NOM: String): Integer;
begin
  Result := -1;
  With Que_Tmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select MRK_ID from ARTMARQUE');
    SQL.Add('  join K on K_Id = MRK_ID and K_Enabled = 1');
    SQL.Add(' Where UPPER(MRK_NOM) = :PMRKNOM');
    ParamCheck := True;
    ParamByName('PMRKNOM').AsString := UpperCase(MRK_NOM);
    Open;

    if RecordCount > 0 then
      Result := FieldByName('MRK_ID').AsInteger;
  Except on E:Exception do
    Raise Exception.Create('FindMrkId -> ' + E.Message);
  end;
end;



function TDM_ReaAuto.GetInfoMrk(sField : String;MRK_ID : Integer): String;
begin
  With aQue_GetInfoMrk do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select ' + sField + ' from REAMARQUE');
    SQL.Add('Where RAM_MRKID = :PMRKID');
    ParamCheck := True;
    Parameters.ParamByName('PMRKID').Value := MRK_ID;
    Open;
    Result := FieldByName(sField).AsString;
  end;
end;

function TDM_ReaAuto.GetLastGenID: Integer;
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

function TDM_ReaAuto.GetLastHisto(REH_MAGID, REH_MRKID, Mode : Integer): TKVersion;
begin
  With aQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.add('Select * from REAMAGASINHISTO');
    SQL.Add('Where REH_MAGID = :PMAGID');
    SQL.Add('  and REH_MRKID = :PMRKID');
    SQL.Add('  and REH_OK = 1');
    SQL.Add('  and (REH_TYP = :PType or REH_TYP = 0)');
    SQL.Add('  and REH_ID = (Select Max(REH_ID) FROM REAMAGASINHISTO Where (REH_TYP = :PTYPE2 or REH_TYP = 0) and REH_MAGID = :PMAGID2 and REH_MRKID = :PMRKID2 and REH_OK = 1)');
    SQL.Add('Order by REH_ID DESC');
    With Parameters do
    begin
      ParamByName('PMAGID').Value  := REH_MAGID;
      ParamByName('PMAGID2').Value := REH_MAGID;
      ParamByName('PMRKID').Value  := REH_MRKID;
      ParamByName('PMRKID2').Value := REH_MRKID;
      ParamByName('PType').Value   := Mode;
      ParamByName('PType2').Value  := Mode;
    end;
    Open;

    if RecordCount <= 0 then
    begin
      // Ne devrait pas ce produire mais mis en place au cas où
      Result.K_DATE           := Now + 1; // On met à J + 1 afin que cela ne soit pas traiter plus tard
      Result.iKVERSION_TCK    := 0;
      Result.iKVERSION_NEGBL  := 0;
      Result.iKVERSION_NEGFCT := 0;
    end
    else begin
      Result.K_DATE           := FieldByName('REH_DATE').AsDateTime;
      Result.iKVERSION_TCK    := FieldByName('REH_KVERSIONTCK').AsInteger;
      Result.iKVERSION_NEGBL  := FieldByName('REH_KVERSIONNEGBL').AsInteger;
      Result.iKVERSION_NEGFCT := FieldByName('REH_KVERSIONNEGFCT').AsInteger;
    end;

    AddToMemo('Dernier K Histo : ' + IntToStr(Result.iKVERSION_TCK) + ' ' +  IntToStr(Result.iKVERSION_NEGBL) + ' ' +  IntToStr(Result.iKVERSION_NEGFCT));
  end;

end;

function TDM_ReaAuto.GetMaxKVersion(KTB_ID: integer;
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
    ParamByName('PDate').AsDatetime := K_INSERTED;
    ParamByName('PKTBID').AsInteger := KTB_ID;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('Resultat').AsInteger
    else
      Result := 0;
  end;
end;

function TDM_ReaAuto.InitGinkoiaDB(BasePath: String; Mode : TMode): Boolean;
var
  sFileName : String;
  lst : TStringList;
begin
  AddToMemo('Connexion à la base de données : ' + BasePath);
  Result := False;
  // Ouverture de la base GINKOIA
  sFileName := '';
  with GinkoiaIBDB do
  begin
    Close;
    DatabaseName := BasePath;
    try
      FIsTimeOut := False;
      Tim_TimoutDb.Enabled := True;
      Open;
      Tim_TimoutDb.Enabled := False;
      if FIsTimeOut then
        raise Exception.Create('Time out');
    Except on E:Exception do
      raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
    end;
  end;

  case mode of
    mStock: begin
      // Envoi de la procédure stockée pour le recalcul
//      AddToMemo('Recalcul du stock en cours');
//      iboSPRecalc.Close;
//      try
//        iboSPRecalc.Open;
//      Except on E:Exception do
//        raise Exception.Create('InitGinkoiaDB SP Recalc Error -> ' + E.Message);
//      end;
//      AddToMemo('Recalcul du stock terminé');
//      Application.ProcessMessages;

//      sFileName := 'TF_GETSTOCKFROMEANANDMRK';
    end;
    mVente: begin
      sFileName := '';
      With Que_Ventes do
      begin
        Close;
        SQL.Clear;
        SQL.LoadFromFile(GDIRFILES + 'TF_QRYVENTESByMAGAndMRK.sql');
      end;
    end;
  end;

//  if Trim(sFileName) <> '' then
//    With GinkoiaIBDB do
//    begin
//      // Suppression de l'ancienne procédure stockée
//      try
//        ExecSQL('Drop procedure ' + sFileName);
//      Except on E:Exception do
//        // on ne fait rien
//        // raise Exception.Create('Drop error : ' + E.Message);
//      end;
//      // ajout de la procédure stockée
//      Try
//        lst := TStringList.Create;
//        try
//          lst.LoadFromFile(GDIRFILES + sFileName + '.sql');
//          ExecSQL(lst.text);
//        finally
//          lst.free;
//        end;
//      Except on E:Exception do
//        raise Exception.Create('InitGinkoiaDB Create error -> ' + E.Message);
//      end;
//    end; //with
end;

function TDM_ReaAuto.Open2kDatabase: Boolean;
begin
  Result := False;
  With ADOConnection do
  Try
    Connected := False;

    //Exemple de chaine de connexion
    //Provider=SQLOLEDB.1;
    //Password=ch@mon1x;
    //Persist Security Info=True;
    //User ID=DA_GINKOIA;
    //Data Source=lame5.no-ip.com

//    if IniStruct.IsDevMode then
//    begin
//      //Dev
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.PasswordDev + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.LoginDev + ';' +
//                          'Initial Catalog=' + IniStruct.CatalogDev + ';' +
//                          'Data Source=' + IniStruct.ServerDev ;
//      AddToMemo('Connexion à : ' + IniStruct.ServerDev);
//    end
//    else
//    begin
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.PasswordPrd + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.LoginPrd + ';' +
//                          'Initial Catalog=' + IniStruct.CatalogPrd + ';' +
//                          'Data Source=' + IniStruct.ServerPrd;
//      AddToMemo('Connexion à : ' + IniStruct.ServerPrd);
//    end;
    ConnectionString := IniCfg.MsSqlConnectionString;
    AddToMemo('Connexion à : ' + IniCfg.ServeurUrl);
    Connected := True;
    aQue_LstMag.Close;
    aQue_LstMag.Open;

    aQue_LstMagDbL.Close;
    aQue_LstMagDbL.Open;

    Result := True;
  Except on E:Exception do
    raise Exception.Create('Open2kDatabase -> ' + E.Message);
  end;
end;

function TDM_ReaAuto.SendFileToFTP: Boolean;
var
  BaseDir : String;
  iMax, i : Integer;
begin
  Result := False;

  With IdFTP1 do
  Try
    // Conenxion
    Disconnect;
//    Host := IniStruct.FTP.Host;
//    Port := IniStruct.FTP.Port;
//    Username := IniStruct.FTP.UserName;
//    Password := IniStruct.FTP.PassWord;
    Host := IniCfg.FtpHost;
    Port := IniCfg.FtpPort;
    Username := IniCfg.FtpUser;
    Password := IniCfg.FtpPass;
    Passive := True;
    Connect;

    BaseDir := IdFTP1.RetrieveCurrentDir;
    GDIRARCHIV := GAPPPATH + 'Archiv\' + FormatDateTime('YYYY\MM\',Now);
    DoDir(GDIRARCHIV);

    // transfert des fichiers
    With MemD_FTPToSend do
    begin
      CheckToSend;

      First;
      iMax := Recordcount;
      i := 0;
      while not EOF do
      begin
        if Trim(FieldByName('FTPDir').AsString) <> '' then
          ChangeDir(FieldByName('FTPDir').AsString);

        try
          if Trim(ExtractFileName(FieldByName('FileName').AsString)) <> '' then
          begin
            if FileExists((GDIRTOSEND + ExtractFileName(FieldByName('FileName').AsString))) then
            Begin
              AddToMemo('Envoi du fichier : ' + ExtractFileName(FieldByName('FileName').AsString));
              Put(GDIRTOSEND + ExtractFileName(FieldByName('FileName').AsString));
              AddToMemo('  - Transfert Ok');
              UpdateTrace(ExtractFileName(FieldByName('FileName').AsString),Now);
              AddToMemo('  - Trace Ok');
              if Movefile(PChar(GDIRTOSEND + ExtractFileName(FieldByName('FileName').AsString)),PChar(GDIRARCHIV + ExtractFileName(FieldByName('FileName').AsString))) then
                AddToMemo('  - Archivage Ok : ' + ExtractFileName(FieldByName('FileName').AsString))
              else
                AddToMemo('  -Echec de l''archivage de : ' + ExtractFileName(FieldByName('FileName').AsString));
            End;
            Delete;
          end;
          if Assigned(FProgressFTP) then
            FProgressFTP.Position := (i+1) * 100 Div iMax;
          Application.ProcessMessages;
          Inc(i);
        Except on E:Exception do
          begin
            AddToMemo(Format('--Send File Error %s : ',[FieldByName('FileName').AsString]) + E.Message);
            Next;
          end;
        end;

        // Revenir au répertoire de base
        while IdFTP1.RetrieveCurrentDir <> Basedir do
          ChangeDirUp;
      end; // while
    end; // with

  Except on E:Exception do
    raise Exception.Create('SendFileToFTP -> ' + E.Message);
  End;
end;

procedure TDM_ReaAuto.Tim_TimoutDbTimer(Sender: TObject);
begin
  Tim_TimoutDb.Enabled := False;
  FIsTimeOut := True;
  GinkoiaIBDB.ForceDisconnect;
end;

function TDM_ReaAuto.UpdateTrace(NOMFIC: String;dDateFTP : TDateTime): Boolean;
var
  RET_ID : Integer;
begin
  With aQue_Tmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from REATRACE');
    SQL.Add('Where RET_NOMFIC = :PNOMFIC');
    ParamCheck := True;
    Parameters.ParamByName('PNOMFIC').Value := ExtractFileName(NOMFIC);
    Open;

    if RecordCount > 0 then
    begin
      RET_ID := FieldByName('RET_ID').asInteger;

      Close;
      SQL.Clear;
      SQL.Add('Update REATRACE set');
      SQL.Add('  RET_DATEENVOI = :PDTENVOI');
      SQL.Add('where RET_ID = :PRETID');
      ParamCheck := True;
      With Parameters do
      begin
        ParamByName('PDTENVOI').Value := dDateFTP;
        ParamByName('PRETID').Value   := RET_ID;
      end;
      ExecSQL;
    end;
  Except on E:Exception do
    raise Exception.Create('UpdateTrace -> ' + E.Message);
  end;
end;

end.
