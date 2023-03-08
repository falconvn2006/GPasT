unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  // Uses perso
  IniFiles,
  FileCtrl,
  Variants,
  // Fin uses perso
  IB_Components, StdCtrls, RzLabel, Mask, wwdbedit, IBODataset, ActionRv, DB,
  LMDCustomButton, LMDButton, wwDBEditRv, ExtCtrls, RzPanel, RzPanelRv;

type stParams = record
    iCliIDMag, iFouIDCent: integer;
    iUsrIDMag, iUsrIDCent: integer;
    iMagIDMag, iMagIDCent: integer;
    iExeIdCent: integer;
    iCpaIDCent, iTypeCpaCent: integer;
    iCpaIDMag, iTypeCpaMag: integer;
    iMrgIDMag, iMrgIDCent: integer;
    iPseudoFPMag, iPseudoFPCent: integer;
    fTvaFPMag: double;
  end;

type stArticleInfos = record
    iArfId, iArtId, iTgfId, iCouId: integer;
    fPxAchat, fTVA: double;
  end;

type stMontant = record
    fTVA: double;
    fMontantTVA: double;
    fMontantHT: double;
  end;

type
  TFrm_SynchroStock = class(TForm)
    IbC_Mag: TIB_Connection;
    IbC_Cent: TIB_Connection;
    IbC_Int: TIB_Connection;
    IbT_Mag: TIB_Transaction;
    IbT_Cent: TIB_Transaction;
    IbT_Int: TIB_Transaction;
    Pan_PathDB: TRzPanelRv;
    RzLabel6: TRzLabel;
    RzLabel2: TRzLabel;
    Chp_DBInt: TwwDBEditRv;
    Chp_DBCent: TwwDBEditRv;
    RzLabel1: TRzLabel;
    Lab_PathDBMag: TRzLabel;
    Chp_DBMag: TwwDBEditRv;
    Nbt_DBSave: TLMDButton;
    Nbt_DBCancel: TLMDButton;
    Nbt_TestConnect: TLMDButton;
    Nbt_DBInt: TLMDButton;
    Nbt_DBCent: TLMDButton;
    Nbt_DBMag: TLMDButton;
    Que_GetFacture: TIBOQuery;
    Que_GetFactureL: TIBOQuery;
    Que_CreerReception: TIBOQuery;
    Que_CreerReceptionL: TIBOQuery;
    Que_CreerFactRetro: TIBOQuery;
    Que_CreerFactRetroL: TIBOQuery;
    Que_CreerRetFourn: TIBOQuery;
    Que_CreerRetFournL: TIBOQuery;
    Que_KCent: TIBOQuery;
    Que_KMag: TIBOQuery;
    Que_GetParam: TIBOQuery;
    Que_GetCliInfo: TIBOQuery;
    Que_GetArtInfos: TIBOQuery;
    QryCent: TIBOQuery;
    QryMag: TIBOQuery;
    Que_GetBL: TIBOQuery;
    Que_GetBLL: TIBOQuery;
    Que_CreerBonResa: TIBOQuery;
    Que_CreerBonResaL: TIBOQuery;
    Que_GetBleID: TIBOQuery;
    Que_DelK: TIBOQuery;
    Que_GetBllID: TIBOQuery;
    Que_GetTvaFP: TIBOQuery;
    Grd_CloseAll: TGroupDataRv;
    Que_MajBLL: TIBOQuery;
    procedure Nbt_DBSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Nbt_TestConnectClick(Sender: TObject);
    procedure Nbt_DBIntClick(Sender: TObject);
    procedure Nbt_DBCentClick(Sender: TObject);
    procedure Nbt_DBMagClick(Sender: TObject);
    procedure Nbt_DBCancelClick(Sender: TObject);
  private
    MyParams    : stParams;
    LogAction   : Boolean;        //Vrai si on log sinon faux.
    LogNbLigne  : Integer;        //Nb ligne de log dans le fichier.
    PathExe     : string;
    Log         : TStringList;    //Pour les log de l'appli.

    // GENPARAM
    function GetParam(iCode: integer; AType: integer; var PrmInteger, PrmMag, PrmPos: integer; var PrmFloat: double; var PrmString: string; ADB: TIB_Connection): boolean; // récupère les infos dans genparam a partri d'un code pour le prm_type=9
    function GetParamInteger(ACode: integer; AType: integer; ADB: TIB_Connection): integer; // récupération dabs genparam en fct du type
    function GetParamMag(ACode: integer; AType: integer; ADB: TIB_Connection): integer;
    function GetParamPos(ACode: integer; AType: integer; ADB: TIB_Connection): integer;
    function GetParamString(ACode: integer; AType: integer; ADB: TIB_Connection): string;
    function GetParamFloat(ACode: integer; AType: integer; ADB: TIB_Connection): double;


    function GetArticleInfos(sCodeBar: string): stArticleInfos;

    { Déclarations privées }
    procedure InitParams();
    procedure SaveParams();
    function ConnectDBs(bShowMess: boolean): boolean;
    procedure DisconnectDBs();
    function DoConnect(ADB: TIB_Connection; APath: string; bShowMess: boolean): boolean;

    function NewKCent(Ktb: string): integer;
    function NewKMag(Ktb: string): integer;


    function DoFacture(AFce_ID: integer): boolean;
    function DoBonResaAdd(ABle_ID: integer): boolean;
    function DoBonResaDel(ABle_ID: integer): boolean;
    function DoTraitement(ATypeTrt: string; A_ID: integer): boolean;

    function GetNewNumMag(S: string): string;
    function GetNewNumCent(S: string): string;

    function CreateBonResaMag(): boolean;
    function CreateRecepCent(): boolean;
    function CreateFactAvoirMag(): boolean;
    function CreateRFCent(): boolean;

    function DernierJour(ADate: TDateTime): TDateTime;

    function GetIdByLibMag(sNomTbl, sColId, sColLib, sNomRecherche: string; sAddSQL: string = ''): integer;
    function GetIdByLibCent(sNomTbl, sColId, sColLib, sNomRecherche: string; sAddSQL: string = ''): integer;

    procedure EndProg(Error: integer);

    function ArrondiMonetaire(X: double): double;

    procedure LogAjoute(aLogMess : string);
  public
    { Déclarations publiques }
  end;

var
  Frm_SynchroStock: TFrm_SynchroStock;
  MyExCode: integer;

const
  LogFile = 'SynchroStock.log';

implementation

{$R *.DFM}

function TFrm_SynchroStock.DoTraitement(ATypeTrt: string; A_ID: integer): boolean;
begin
  try
    Result := False;
    if ATypeTrt = 'FACT' then
    begin
      Result := DoFacture(A_ID);
    end
    else if ATypeTrt = 'RESA_ADD' then
    begin
      Result := DoBonResaAdd(A_ID);
    end
    else if ATypeTrt = 'RESA_DEL' then
    begin
      Result := DoBonResaDel(A_ID);
    end;
  except on E: Exception do
    begin
      LogAjoute('DoTraitement() : ' + E.Message);
    end;
  end;
end;


function TFrm_SynchroStock.DoBonResaAdd(ABle_ID: integer): boolean;
begin
  MyExCode := 3;
  Result := False;
  // 1 : Récupération de la facture dans la base de la centrale
  try
    IbT_Mag.StartTransaction;

    // Entete de la facture
    Que_GetBL.Close;
    Que_GetBL.ParamByName('BLEID').AsInteger := ABle_ID;
    Que_GetBL.Open;

    // Lignes
    Que_GetBLL.Close;
    Que_GetBLL.ParamByName('BLEID').AsInteger := ABle_ID;
    Que_GetBLL.Open;

    if Que_GetBL.RecordCount > 0 then
    begin
      // Vérif si facture déjà existante
      QryMag.Close;
      QryMag.SQL.Text := 'SELECT * FROM NEGBL JOIN K ON (K_ID = BLE_ID AND K_ENABLED = 1) WHERE BLE_NUMERO = ' + QuotedStr(Que_GetBL.FieldByName('BLE_NUMERO').AsString);

      QryMag.Open;
      if QryMag.RecordCount > 0 then
      begin
        MyExCode := 4;
        Result := False;
      end
      else begin
        QryMag.Close;

        Result := CreateBonResaMag(); // 1 Un bon de résa dans la base -> MAGASIN <-
      end;
    end;
  except on E: exception do
    begin
      LogAjoute('DoBonResaAdd() : ' + E.Message);
      Result := False;
    end;
  end;
  Que_GetBLL.Close;
  Que_GetBL.Close;

  if Result then
  begin
    IbT_Mag.Commit;
  end
  else begin
    IbT_Mag.Rollback;
  end;

end;

function TFrm_SynchroStock.DoBonResaDel(ABle_ID: integer): boolean;
var
  iBleID: integer;
begin
  Result := False;

  IbT_Mag.StartTransaction;
  try
    // Entete de la facture
    Que_GetBL.Close;
    Que_GetBL.ParamByName('BLEID').AsInteger := ABle_ID;
    Que_GetBL.Open;

    // Lignes
    Que_GetBleID.Close;
    Que_GetBleID.ParamByName('BLENUM').AsString := Que_GetBL.FieldByName('BLE_NUMERO').AsString;
    Que_GetBleID.Open;

    iBleID := Que_GetBleID.FieldByName('BLE_ID').AsInteger;

    if Que_GetBleID.RecordCount > 0 then
    begin
      // 1 Del le bon de résa dans la base -> MAGASIN <-
      Que_DelK.Close;
      Que_DelK.ParamByName('ID').AsInteger := iBleID;
      Que_DelK.ExecSQL;
      Que_DelK.Close;
      Que_GetBllID.Close;
      Que_GetBllID.ParamByName('BLEID').AsInteger := iBleID;
      Que_GetBllID.Open;

      Que_GetBllID.First; // Del les lignes du bon de resa
      while not Que_GetBllID.Eof do
      begin
        Que_DelK.Close;
        Que_DelK.ParamByName('ID').AsInteger := Que_GetBllID.FieldByName('BLL_ID').AsInteger;
        Que_DelK.ExecSQL;
        Que_DelK.Close;

        Que_MajBLL.Close;
        Que_MajBLL.ParamByName('BLLID').AsInteger := Que_GetBllID.FieldByName('BLL_ID').AsInteger;
        Que_MajBLL.ExecSQL;
        Que_MajBLL.Close;

        Que_GetBllID.Next;
      end;
      Result := True;
    end;
  except on E: exception do
    begin
      LogAjoute('DoBonResaDel() : ' + E.Message);
      Result := False;
    end;
  end;
  Que_GetBL.Close;
  Que_GetBleID.Close;
  Que_GetBllID.Close;

  if Result then
  begin
    IbT_Mag.Commit;
  end
  else begin
    IbT_Mag.Rollback;
  end;

end;

function TFrm_SynchroStock.CreateBonResaMag: boolean;
var
  i, iBleID: integer;
  MyArticle: stArticleInfos;
begin
  iBleID := NewKMag('NEGBL');
  try

    // Charge les champs de la ligne de BL d'origine dans le BL de résa
    for i := 0 to (Que_GetBL.Fields.Count - 1) do
    begin
      Que_CreerBonResa.ParamByName(Que_GetBL.Fields[i].FieldName).Value := Que_GetBL.Fields[i].Value;
    end;

    Que_CreerBonResa.ParamByName('BLE_ID').AsInteger := iBleID;
    Que_CreerBonResa.ParamByName('BLE_MAGID').AsInteger := MyParams.iMagIDMag;
    Que_CreerBonResa.ParamByName('BLE_CLTID').AsInteger := MyParams.iCliIDMag;

    Que_GetCliInfo.Close;
    Que_GetCliInfo.ParamByName('CLTID').AsInteger := MyParams.iCliIDMag;
    Que_GetCliInfo.Open;
    Que_CreerBonResa.ParamByName('BLE_CLTNOM').AsString := Que_GetCliInfo.FieldByName('CLT_NOM').AsString;
    Que_CreerBonResa.ParamByName('BLE_CLTPRENOM').AsString := Que_GetCliInfo.FieldByName('CLT_PRENOM').AsString;
    Que_CreerBonResa.ParamByName('BLE_ADRLIGNE').AsString := Que_GetCliInfo.FieldByName('ADR_LIGNE').AsString;
    Que_CreerBonResa.ParamByName('BLE_CIVID').AsInteger := Que_GetCliInfo.FieldByName('CLT_CIVID').AsInteger;
    Que_CreerBonResa.ParamByName('BLE_VILID').AsInteger := Que_GetCliInfo.FieldByName('ADR_VILID').AsInteger;
    Que_GetCliInfo.Close;


    Que_CreerBonResa.ParamByName('BLE_USRID').AsInteger := MyParams.iUsrIDMag;
    Que_CreerBonResa.ParamByName('BLE_TYPID').AsInteger := -101408028;
    Que_CreerBonResa.ParamByName('BLE_MRGID').AsInteger := MyParams.iMrgIDMag;
    Que_CreerBonResa.ParamByName('BLE_CPAID').AsInteger := MyParams.iCpaIDMag;

    case MyParams.iTypeCpaCent of
      1:
        Que_CreerBonResa.ParamByName('BLE_REGLEMENT').AsDateTime := DernierJour(Que_GetBL.FieldByName('BLE_DATE').AsDateTime);
      2:
        Que_CreerBonResa.ParamByName('BLE_REGLEMENT').AsDateTime := Que_GetBL.FieldByName('BLE_DATE').AsDateTime;
    else
      Que_CreerBonResa.ParamByName('BLE_REGLEMENT').AsDateTime := Que_GetBL.FieldByName('BLE_DATE').AsDateTime;
    end;



    Que_CreerBonResa.ExecSQL; // Création de la facture

    Que_GetBLL.First;
    while not Que_GetBLL.EOF do
    begin
      // Charge les champs de la ligne de facture d'origine dans la rétro TODO : voir si c'est utile ....
      for i := 0 to (Que_GetBLL.Fields.Count - 1) do
      begin
        if Que_GetBLL.Fields[i].FieldName <> 'CBI_CB' then
          Que_CreerBonResaL.ParamByName(Que_GetBLL.Fields[i].FieldName).Value := Que_GetBLL.Fields[i].Value;    //SR - 23/10/2012 - AsVariant en Value
      end;

      // Charge les infos particulières

      // Modifie le USRID, le FCEID et le FCL_ID
      Que_CreerBonResaL.ParamByName('BLL_USRID').AsInteger := MyParams.iUsrIDMag;
      Que_CreerBonResaL.ParamByName('BLL_BLEID').AsInteger := iBleId;
      Que_CreerBonResaL.ParamByName('BLL_ID').AsInteger := NewKMag('NEGBLL');


      // Prix
      if Que_GetBLL.FieldByName('BLL_ARTID').AsInteger = MyParams.iPseudoFPCent then
      begin
        // Frais de port
        Que_CreerBonResaL.ParamByName('BLL_ARTID').AsInteger := MyParams.iPseudoFPMag;
        Que_CreerBonResaL.ParamByName('BLL_TGFID').AsInteger := 0;
        Que_CreerBonResaL.ParamByName('BLL_COUID').AsInteger := 0;
      end
      else begin
        // Infos articles
        MyArticle := GetArticleInfos(Que_GetBLL.FieldByName('CBI_CB').AsString);
        Que_CreerBonResaL.ParamByName('BLL_ARTID').AsInteger := MyArticle.iArtId;
        Que_CreerBonResaL.ParamByName('BLL_TGFID').AsInteger := MyArticle.iTgfId;
        Que_CreerBonResaL.ParamByName('BLL_COUID').AsInteger := MyArticle.iCouId;
      end;

      Que_CreerBonResaL.ExecSQL;
      Que_CreerBonResaL.Close;

      Que_GetBLL.Next;
    end;
    Result := True;
  except on E: Exception do
    begin
      LogAjoute('CreateBonResaMag() : ' + E.Message);
      Result := False;
    end;
  end;
  Que_CreerBonResa.Close;
end;


function TFrm_SynchroStock.DoFacture(AFce_ID: integer): boolean;
begin
  MyExCode := 3;

  Result := False;
  // 1 : Récupération de la facture dans la base de la centrale
  try
    IbT_Mag.StartTransaction;
    IbT_Cent.StartTransaction;
    // Entete de la facture
    Que_GetFacture.Close;
    Que_GetFacture.ParamByName('FCEID').AsInteger := AFce_ID;
    Que_GetFacture.Open;

    // Lignes
    Que_GetFactureL.Close;
    Que_GetFactureL.ParamByName('FCEID').AsInteger := AFce_ID;
    Que_GetFactureL.Open;

    if Que_GetFacture.RecordCount > 0 then
    begin
      // Vérif si facture déjà existante
      QryMag.Close;
      QryMag.SQL.Text := 'SELECT * FROM NEGFACTURE JOIN K ON (K_ID = FCE_ID AND K_ENABLED = 1) WHERE FCE_NUMERO = ' + QuotedStr(Que_GetFacture.FieldByName('FCE_NUMERO').AsString);

      QryMag.Open;
      if QryMag.RecordCount > 0 then
      begin
        MyExCode := 4;
        Result := False;
      end
      else begin
        QryMag.Close;

        // Déterminer si on a à faire avec un avoir ou une facture
        if Que_GetFacture.FieldByName('FCE_TOTALHT').AsFloat >= 0 then
        begin
          // On est dans le cas d'une facture, il faut créer

          // 1 Une facture de rétro dans la base -> MAGASIN <-
          Result := CreateFactAvoirMag();

          // 2 Une réception dans la base -> CENTRALE <-
          Result := (Result) and (CreateRecepCent());
        end
        else
        begin
          // cas d'un Avoir

          // 1 Créer un avoir de rétro (= facture négative) dans la base -> MAGASIN <-
          Result := CreateFactAvoirMag();

          // 2 Creer un retour fournisseur dans la base de -> CENTRALE <-
          Result := (Result) and (CreateRFCent());
        end;
      end;
    end;
  except on E: exception do
    begin
      LogAjoute('DoFacture() : ' + E.Message);
      Result := False;
    end;
  end;
  Que_GetFactureL.Close;
  Que_GetFacture.Close;

  if Result then
  begin
    IbT_Mag.Commit;
    IbT_Cent.Commit;
  end
  else begin
    IbT_Mag.Rollback;
    IbT_Cent.Rollback;
  end;

end;

function TFrm_SynchroStock.CreateRFCent: boolean;
var
  i, j: integer;
  tabMontant: array of stMontant;
  iRetId: integer;
  fFraisP, fMontant: double;
  MyArticle: stArticleInfos;
begin
  Result := False;
  try
    iRetId := NewKCent('COMRETOUR');

    Que_CreerRetFourn.ParamByName('RET_ID').AsInteger := iRetId;
    Que_CreerRetFourn.ParamByName('RET_NUMERO').AsString := GetNewNumCent('BRF_NEWNUM');
    Que_CreerRetFourn.ParamByName('RET_MAGID').AsInteger := MyParams.iMagIDCent;
    Que_CreerRetFourn.ParamByName('RET_FOUID').AsInteger := MyParams.iFouIDCent;
    Que_CreerRetFourn.ParamByName('RET_NUMFOURN').AsString := Que_GetFacture.FieldByName('FCE_NUMERO').AsString;
    Que_CreerRetFourn.ParamByName('RET_DATE').AsString := Que_GetFacture.FieldByName('FCE_DATE').AsString;
    Que_CreerRetFourn.ParamByName('RET_COMENT').AsString := Que_GetFacture.FieldByName('FCE_COMENT').AsString;



    fMontant := 0;


    // Calcul des prix
    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      // On ne traite pas les frais de ports
      if (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> MyParams.iPseudoFPCent) and (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0) then
      begin
        MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
        MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);


        j := 0;
        while j <= High(tabMontant) do // High renvoie -1 si tableau vide
        begin
          if tabMontant[j].fTVA = MyArticle.fTVA then
          begin
            // Ok, on a trouvé la bonne TVA, on sort
            BREAK;
          end;
          // Suivant
          inc(j);
        end;

        try
          // si on l'a trouvé
          if j <= High(tabMontant) then
          begin
            // Cumul des quantités
            tabMontant[j].fMontantTVA := tabMontant[j].fMontantTVA + ((MyArticle.fPxAchat * (MyArticle.fTva / 100)) * Abs(Que_GetFactureL.FieldByName('FCL_QTE').AsFloat));
            tabMontant[j].fMontantHT := tabMontant[j].fMontantHT + (MyArticle.fPxAchat * Abs(Que_GetFactureL.FieldByName('FCL_QTE').AsFloat));
          end
          else
          begin
            // On l'a pas trouvé, on ajoute la ligne de tva
            // Augmente le nombre de ligne dans le tableau
            SetLength(tabMontant, (Length(TabMontant) + 1));
            tabMontant[High(tabMontant)].fTVA := MyArticle.fTVA;
            tabMontant[High(tabMontant)].fMontantTVA := MyArticle.fPxAchat * (MyArticle.fTva / 100) * Abs(Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
            tabMontant[High(tabMontant)].fMontantHT := MyArticle.fPxAchat * Abs(Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
          end;
        except on E: Exception do
          begin
          LogAjoute('CreateRFCent() Ligne 549 : ' + E.Message); // TODO
          end;
        end;

      end;
      Que_GetFactureL.Next;
    end;

    // Totaux HT + TVA -> Init
    for i := 1 to 5 do
    begin
      Que_CreerRetFourn.ParamByName('RET_TVAHT' + IntToStr(i)).AsFloat := 0;
      Que_CreerRetFourn.ParamByName('RET_TVATAUX' + IntToStr(i)).AsFloat := 0;
      Que_CreerRetFourn.ParamByName('RET_TVA' + IntToStr(i)).AsFloat := 0;
    end;

    fMontant := 0;
    // Totaux HT + TVA
    for i := 1 to Length(tabMontant) do
    begin
      Que_CreerRetFourn.ParamByName('RET_TVAHT' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantHT);
      Que_CreerRetFourn.ParamByName('RET_TVATAUX' + IntToStr(i)).AsFloat := tabMontant[i - 1].fTVA;
      Que_CreerRetFourn.ParamByName('RET_TVA' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantTVA);
      fMontant := fMontant + tabMontant[i - 1].fMontantTVA + tabMontant[i - 1].fMontantHT;
    end;

    Finalize(tabMontant);

    fFraisP := 0;
    if Que_GetFactureL.Locate('FCL_ARTID', VarArrayOf([MyParams.iPseudoFPCent]), [loCaseInsensitive]) then
    begin
      fFraisP := ArrondiMonetaire(Que_GetFactureL.FieldByName('FCL_PXNET').AsFloat / (1 + (MyParams.fTvaFPMag / 100)));
    end;

    Que_CreerRetFourn.ParamByName('RET_FOURNTTC').AsFloat := ArrondiMonetaire(fMontant + Que_GetFactureL.FieldByName('FCL_PXNET').AsFloat);

    Que_CreerRetFourn.ParamByName('RET_CLOTURE').AsInteger := 1;
    Que_CreerRetFourn.ParamByName('RET_ARCHIVE').AsInteger := 0;

    case MyParams.iTypeCpaCent of
      1:
        Que_CreerRetFourn.ParamByName('RET_REGLEMENT').AsDateTime := DernierJour(Que_GetFacture.FieldByName('FCE_DATE').AsDateTime);
      2:
        Que_CreerRetFourn.ParamByName('RET_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    else
      Que_CreerRetFourn.ParamByName('RET_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    end;

    Que_CreerRetFourn.ParamByName('RET_MRGID').AsInteger := MyParams.iMrgIDCent;
    Que_CreerRetFourn.ParamByName('RET_USRID').AsInteger := MyParams.iUsrIDCent;


    Que_CreerRetFourn.ExecSQL; // Création de l'entete

    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      // On ne traite pas les frais de ports
      if (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> MyParams.iPseudoFPCent) and (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0) then
      begin
        Que_CreerRetFournL.ParamByName('REL_RETID').AsInteger := iRetID;
        Que_CreerRetFournL.ParamByName('REL_ID').AsInteger := NewKCent('COMRETOURL');


        Que_CreerRetFournL.ParamByName('REL_ARTID').AsInteger := Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger;
        Que_CreerRetFournL.ParamByName('REL_TGFID').AsInteger := Que_GetFactureL.FieldByName('FCL_TGFID').AsInteger;
        Que_CreerRetFournL.ParamByName('REL_COUID').AsInteger := Que_GetFactureL.FieldByName('FCL_COUID').AsInteger;
        Que_CreerRetFournL.ParamByName('REL_QTE').AsFloat := Abs(Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);

        MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
        MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);
        Que_CreerRetFournL.ParamByName('REL_PX').AsFloat := MyArticle.fPxAchat;
        Que_CreerRetFournL.ParamByName('REL_TVA').AsFloat := MyArticle.fTVA;

  //  , REL_COMENT
//    , REL_LIGNE
        Que_CreerRetFournL.ParamByName('REL_COMENT').AsString := 'Avoir ' + Que_GetFacture.FieldByName('FCE_NUMERO').AsString;

        Que_CreerRetFournL.ParamByName('REL_LIGNE').AsInteger := Que_CreerRetFournL.ParamByName('REL_ID').AsInteger;

        Que_CreerRetFournL.ExecSQL;
        Que_CreerRetFournL.Close;
      end;

      Que_GetFactureL.Next;

      Result := True;
    end;
  except on E: exception do
    begin
      LogAjoute('CreateRFCent() : ' + E.Message);
      result := False;
    end;
  end;

end;


function TFrm_SynchroStock.CreateFactAvoirMag(): boolean;
var
  iFceId: integer;
  MyArticle: stArticleInfos;
  i, j: integer;
  tabMontant: array of stMontant;
begin
  Result := False;
  Que_CreerFactRetro.Close;
  try
    iFceId := NewKMag('NEGFACTURE');

    // Id facture
    Que_CreerFactRetro.ParamByName('FCE_ID').AsInteger := iFceId;

    // User
    Que_CreerFactRetro.ParamByName('FCE_USRID').AsInteger := MyParams.iUsrIDMag;

    // Client 'Centrale'
    Que_CreerFactRetro.ParamByName('FCE_CLTID').AsInteger := MyParams.iCliIDMag;
    Que_GetCliInfo.Close;
    Que_GetCliInfo.ParamByName('CLTID').AsInteger := MyParams.iCliIDMag;
    Que_GetCliInfo.Open;
    Que_CreerFactRetro.ParamByName('FCE_CLTNOM').AsString := Que_GetCliInfo.FieldByName('CLT_NOM').AsString;
    Que_CreerFactRetro.ParamByName('FCE_CLTPRENOM').AsString := Que_GetCliInfo.FieldByName('CLT_PRENOM').AsString;
    Que_CreerFactRetro.ParamByName('FCE_ADRLIGNE').AsString := Que_GetCliInfo.FieldByName('ADR_LIGNE').AsString;
    Que_CreerFactRetro.ParamByName('FCE_CIVID').AsInteger := Que_GetCliInfo.FieldByName('CLT_CIVID').AsInteger;
    Que_CreerFactRetro.ParamByName('FCE_VILID').AsInteger := Que_GetCliInfo.FieldByName('ADR_VILID').AsInteger;
    Que_GetCliInfo.Close;

    // TODO, selon réponse SM
    Que_CreerFactRetro.ParamByName('FCE_MAGID').AsInteger := MyParams.iMagIDMag;

    Que_CreerFactRetro.ParamByName('FCE_NUMERO').AsString := Que_GetFacture.FieldByName('FCE_NUMERO').AsString;

    Que_CreerFactRetro.ParamByName('FCE_WEB').AsInteger := 1;

    Que_CreerFactRetro.ParamByName('FCE_TYPID').AsInteger := -101408033;
    Que_CreerFactRetro.ParamByName('FCE_MRGID').AsInteger := MyParams.iMrgIDMag;
    Que_CreerFactRetro.ParamByName('FCE_CPAID').AsInteger := MyParams.iCpaIDMag;

    case MyParams.iTypeCpaMag of
      1:
        Que_CreerFactRetro.ParamByName('FCE_REGLEMENT').AsDateTime := DernierJour(Que_GetFacture.FieldByName('FCE_DATE').AsDateTime);
      2:
        Que_CreerFactRetro.ParamByName('FCE_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    else
      Que_CreerFactRetro.ParamByName('FCE_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    end;


    // Date de facture : idem facture origine
    Que_CreerFactRetro.ParamByName('FCE_DATE').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;

    // Commentaire (TODO, selon réponse SM)
    Que_CreerFactRetro.ParamByName('FCE_COMENT').AsString := Que_GetFacture.FieldByName('FCE_COMENT').AsString;


    // Calcul des tva
    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      if Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0 then
      begin
        if Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> MyParams.iPseudoFPCent then
        begin
          MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
        end
        else begin
          MyArticle.fTva := MyParams.fTvaFPMag;
          MyArticle.fPxAchat := Que_GetFactureL.FieldByName('FCL_PXNN').AsFloat / (1 + (MyArticle.fTva / 100));
        end;

        MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);

        j := 0;
        while j <= High(tabMontant) do // High renvoie -1 si tableau vide
        begin
          if tabMontant[j].fTVA = MyArticle.fTVA then
          begin
            // Ok, on a trouvé la bonne TVA, on sort
            BREAK;
          end;
          // Suivant
          inc(j);
        end;

        try
          // si on l'a trouvé
          if j <= High(tabMontant) then
          begin
            // Cumul des quantités
            tabMontant[j].fMontantTVA := tabMontant[j].fMontantTVA + ((MyArticle.fPxAchat * (MyArticle.fTva / 100)) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
            tabMontant[j].fMontantHT := tabMontant[j].fMontantHT + ((MyArticle.fPxAchat * (1 + (MyArticle.fTva / 100))) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
          end
          else
          begin
            // On l'a pas trouvé, on ajoute la ligne de tva
            // Augmente le nombre de ligne dans le tableau
            SetLength(tabMontant, (Length(TabMontant) + 1));
            tabMontant[High(tabMontant)].fTVA := MyArticle.fTVA;
            tabMontant[High(tabMontant)].fMontantTVA := MyArticle.fPxAchat * (MyArticle.fTva / 100) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;
            tabMontant[High(tabMontant)].fMontantHT := MyArticle.fPxAchat * (1 + (MyArticle.fTva / 100)) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;
          end;
        except on E: Exception do
          begin
            LogAjoute('CreateFactAvoirMag() Ligne 753 : ' + E.Message); // TODO
          end;
        end;

      end;
      Que_GetFactureL.Next;
    end;

    // Totaux HT + TVA -> Init
    for i := 1 to 5 do
    begin
      Que_CreerFactRetro.ParamByName('FCE_TVAHT' + IntToStr(i)).AsFloat := 0;
      Que_CreerFactRetro.ParamByName('FCE_TVATAUX' + IntToStr(i)).AsFloat := 0;
      Que_CreerFactRetro.ParamByName('FCE_TVA' + IntToStr(i)).AsFloat := 0;
    end;

    // Totaux HT + TVA
    for i := 1 to Length(tabMontant) do
    begin
      Que_CreerFactRetro.ParamByName('FCE_TVAHT' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantHT);
      Que_CreerFactRetro.ParamByName('FCE_TVATAUX' + IntToStr(i)).AsFloat := tabMontant[i - 1].fTVA;
      Que_CreerFactRetro.ParamByName('FCE_TVA' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantTVA);
    end;

    Finalize(tabMontant);

    Que_CreerFactRetro.ExecSQL; // Création de la facture

    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      if Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0 then
      begin
        Que_CreerFactRetroL.Close;
        // Charge les champs de la ligne de facture d'origine dans la rétro TODO : voir si c'est utile ....
        for i := 0 to (Que_GetFactureL.Fields.Count - 1) do
        begin
          if Que_GetFactureL.Fields[i].FieldName <> 'CBI_CB' then
            Que_CreerFactRetroL.ParamByName(Que_GetFactureL.Fields[i].FieldName).Value := Que_GetFactureL.Fields[i].Value;
        end;

        // Modifie le USRID, le FCEID et le FCL_ID
        Que_CreerFactRetroL.ParamByName('FCL_USRID').AsInteger := MyParams.iUsrIDMag;
        Que_CreerFactRetroL.ParamByName('FCL_FCEID').AsInteger := iFceId;
        Que_CreerFactRetroL.ParamByName('FCL_ID').AsInteger := NewKMag('NEGFACTUREL');


        // Prix
        if Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger = MyParams.iPseudoFPCent then
        begin
          // Frais de port
          Que_CreerFactRetroL.ParamByName('FCL_ARTID').AsInteger := MyParams.iPseudoFPMag;
          Que_CreerFactRetroL.ParamByName('FCL_TGFID').AsInteger := 0;
          Que_CreerFactRetroL.ParamByName('FCL_COUID').AsInteger := 0;

          // On récup les infos de prix dans la facture
          Que_CreerFactRetroL.ParamByName('FCL_PXBRUT').AsFloat := Que_GetFactureL.FieldByName('FCL_PXBRUT').AsFloat;
          Que_CreerFactRetroL.ParamByName('FCL_PXNET').AsFloat := Que_GetFactureL.FieldByName('FCL_PXNET').AsFloat;
          Que_CreerFactRetroL.ParamByName('FCL_PXNN').AsFloat := Que_GetFactureL.FieldByName('FCL_PXNN').AsFloat;
        end
        else begin
          // Infos articles
          MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
          MyArticle.fPxAchat := MyArticle.fPxAchat * (1 + (MyArticle.fTva / 100));
          MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);
          Que_CreerFactRetroL.ParamByName('FCL_ARTID').AsInteger := MyArticle.iArtId;
          Que_CreerFactRetroL.ParamByName('FCL_TGFID').AsInteger := MyArticle.iTgfId;
          Que_CreerFactRetroL.ParamByName('FCL_COUID').AsInteger := MyArticle.iCouId;
          Que_CreerFactRetroL.ParamByName('FCL_PXBRUT').AsFloat := MyArticle.fPxAchat;
          Que_CreerFactRetroL.ParamByName('FCL_PXNET').AsFloat := MyArticle.fPxAchat * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;
          Que_CreerFactRetroL.ParamByName('FCL_PXNN').AsFloat := MyArticle.fPxAchat;
        end;

        Que_CreerFactRetroL.ParamByName('FCL_FROMBLL').AsInteger := 0;
        Que_CreerFactRetroL.ParamByName('FCL_DATEBLL').AsDateTime := 0;   //.ISNull := True

        //        Que_CreerFactRetroL.ParamByName('FCL_TYPID').AsInteger := Que_GetFactureL.FieldByN;


        Que_CreerFactRetroL.ExecSQL;

        Que_CreerFactRetroL.Close;
      end;
      Que_GetFactureL.Next;
    end;
    Result := True;
  except on E: Exception do
    begin
      LogAjoute('CreateFactAvoirMag() : ' + E.Message);
    end;
  end;
  Que_CreerFactRetroL.Close;
  Que_CreerFactRetro.Close;

end;

function TFrm_SynchroStock.CreateRecepCent: boolean;
var
  iBreId: integer;
  MyArticle: stArticleInfos;
  i, j: integer;
  fMontant: double;
  tabMontant: array of stMontant;
begin
  Result := False;
  Que_CreerReception.Close;
  try
    iBreId := NewKCent('RECBR');

    Que_CreerReception.ParamByName('BRE_ID').AsInteger := iBreID;
    Que_CreerReception.ParamByName('BRE_NUMERO').AsString := GetNewNumCent('BR_NEWNUM');
    Que_CreerReception.ParamByName('BRE_SAISON').AsInteger := 1;
    Que_CreerReception.ParamByName('BRE_EXEID').AsInteger := MyParams.iExeIdCent;
    Que_CreerReception.ParamByName('BRE_CPAID').AsInteger := MyParams.iCpaIDCent;
    Que_CreerReception.ParamByName('BRE_MAGID').AsInteger := MyParams.iMagIDCent;
    Que_CreerReception.ParamByName('BRE_USRID').AsInteger := MyParams.iUsrIDCent;
    Que_CreerReception.ParamByName('BRE_FOUID').AsInteger := MyParams.iFouIDCent;
    Que_CreerReception.ParamByName('BRE_NUMFOURN').AsString := Que_GetFacture.FieldByName('FCE_NUMERO').AsString;
    Que_CreerReception.ParamByName('BRE_DATE').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;


    // Calcul des prix
    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      // On ne traite pas les frais de ports
      if (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> MyParams.iPseudoFPCent) and (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0) then
      begin
        MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
        MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);

        j := 0;
        while j <= High(tabMontant) do // High renvoie -1 si tableau vide
        begin
          if tabMontant[j].fTVA = MyArticle.fTVA then
          begin
            // Ok, on a trouvé la bonne TVA, on sort
            BREAK;
          end;
          // Suivant
          inc(j);
        end;

        try
          // si on l'a trouvé
          if j <= High(tabMontant) then
          begin
            // Cumul des quantités
            tabMontant[j].fMontantTVA := tabMontant[j].fMontantTVA + ((MyArticle.fPxAchat * (MyArticle.fTva / 100)) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
            tabMontant[j].fMontantHT := tabMontant[j].fMontantHT + (MyArticle.fPxAchat * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat);
          end
          else
          begin
            // On l'a pas trouvé, on ajoute la ligne de tva
            // Augmente le nombre de ligne dans le tableau
            SetLength(tabMontant, (Length(TabMontant) + 1));
            tabMontant[High(tabMontant)].fTVA := MyArticle.fTVA;
            tabMontant[High(tabMontant)].fMontantTVA := MyArticle.fPxAchat * (MyArticle.fTva / 100) * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;
            tabMontant[High(tabMontant)].fMontantHT := MyArticle.fPxAchat * Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;
          end;
        except on E: Exception do
          begin
            LogAjoute('CreateRecepCent() Ligne 915 : ' + E.Message); // TODO
          end;
        end;

      end;
      Que_GetFactureL.Next;
    end;

    // Totaux HT + TVA -> Init
    for i := 1 to 5 do
    begin
      Que_CreerReception.ParamByName('BRE_TVAHT' + IntToStr(i)).AsFloat := 0;
      Que_CreerReception.ParamByName('BRE_TVATAUX' + IntToStr(i)).AsFloat := 0;
      Que_CreerReception.ParamByName('BRE_TVA' + IntToStr(i)).AsFloat := 0;
    end;

    fMontant := 0;
    // Totaux HT + TVA
    for i := 1 to Length(tabMontant) do
    begin
      Que_CreerReception.ParamByName('BRE_TVAHT' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantHT);
      Que_CreerReception.ParamByName('BRE_TVATAUX' + IntToStr(i)).AsFloat := tabMontant[i - 1].fTVA;
      Que_CreerReception.ParamByName('BRE_TVA' + IntToStr(i)).AsFloat := ArrondiMonetaire(tabMontant[i - 1].fMontantTVA);
      fMontant := fMontant + (tabMontant[i - 1].fMontantHT + tabMontant[i - 1].fMontantTVA);
    end;

    Finalize(tabMontant);

    case MyParams.iTypeCpaCent of
      1:
        Que_CreerReception.ParamByName('BRE_REGLEMENT').AsDateTime := DernierJour(Que_GetFacture.FieldByName('FCE_DATE').AsDateTime);
      2:
        Que_CreerReception.ParamByName('BRE_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    else
      Que_CreerReception.ParamByName('BRE_REGLEMENT').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsDateTime;
    end;

    Que_CreerReception.ParamByName('BRE_MRGID').AsInteger := MyParams.iMrgIDCent;

    if Que_GetFactureL.Locate('FCL_ARTID', VarArrayOf([MyParams.iPseudoFPCent]), [loCaseInsensitive]) then
    begin
      Que_CreerReception.ParamByName('BRE_FRAISPORT').AsFloat := ArrondiMonetaire(Que_GetFactureL.FieldByName('FCL_PXNET').AsFloat / (1 + (MyParams.fTvaFPMag / 100)));
    end;

    Que_CreerReception.ParamByName('BRE_FOURNTTC').AsFloat := ArrondiMonetaire(fMontant + Que_GetFactureL.FieldByName('FCL_PXNET').AsFloat);


    // Lignes
    Que_CreerReception.ExecSQL;
    Que_GetFactureL.First;
    while not Que_GetFactureL.EOF do
    begin
      // On ne traite pas les frais de ports
      if (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> MyParams.iPseudoFPCent) and (Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger <> 0) then
      begin
        Que_CreerReceptionL.ParamByName('BRL_BREID').AsInteger := iBreID;
        Que_CreerReceptionL.ParamByName('BRL_ID').AsInteger := NewKCent('RECBRL');


        Que_CreerReceptionL.ParamByName('BRL_ARTID').AsInteger := Que_GetFactureL.FieldByName('FCL_ARTID').AsInteger;
        Que_CreerReceptionL.ParamByName('BRL_TGFID').AsInteger := Que_GetFactureL.FieldByName('FCL_TGFID').AsInteger;
        Que_CreerReceptionL.ParamByName('BRL_COUID').AsInteger := Que_GetFactureL.FieldByName('FCL_COUID').AsInteger;
        Que_CreerReceptionL.ParamByName('BRL_QTE').AsFloat := Que_GetFactureL.FieldByName('FCL_QTE').AsFloat;

        MyArticle := GetArticleInfos(Que_GetFactureL.FieldByName('CBI_CB').AsString);
        MyArticle.fPxAchat := ArrondiMonetaire(MyArticle.fPxAchat);
        Que_CreerReceptionL.ParamByName('BRL_PXCTLG').AsFloat := ArrondiMonetaire(MyArticle.fPxAchat);
        Que_CreerReceptionL.ParamByName('BRL_PXNN').AsFloat := ArrondiMonetaire(MyArticle.fPxAchat);
        Que_CreerReceptionL.ParamByName('BRL_PXACHAT').AsFloat := ArrondiMonetaire(MyArticle.fPxAchat);
        Que_CreerReceptionL.ParamByName('BRL_TVA').AsFloat := MyArticle.fTVA;

        Que_CreerReceptionL.ParamByName('BRL_PXVENTE').AsFloat := Que_GetFactureL.FieldByName('FCL_PXNN').AsFloat;

        Que_CreerReceptionL.ParamByName('BRL_CDLLIVRAISON').AsDateTime := Que_GetFacture.FieldByName('FCE_DATE').AsFloat;

        Que_CreerReceptionL.ExecSQL;
        Que_CreerReceptionL.Close;
      end;

      Que_GetFactureL.Next;

    end;
    Result := True;
  except on E: Exception do
    begin
      LogAjoute('CreateRecepCent() : ' + E.Message);
    end;
  end;
  Que_CreerReception.Close;
end;


procedure TFrm_SynchroStock.FormCreate(Sender: TObject);
var
  bModeParam, bModeAuto: boolean;
  sTypeTrt: string;
  iTheId: integer;

begin
  InitParams();

  // Init du log
  if LogAction then
  begin
    Log     := TstringList.Create;
    PathExe := ExtractFilePath(Application.ExeName);

    try
      if FileExists(PathExe + LogFile) THEN
        Log.LoadFromFile(PathExe + LogFile);
    except on E: exception do
      begin
        LogAjoute('FormCreate()         Exception récup du fichier : ' + E.message);
      end;
    end;

    while Log.Count > LogNbLigne do   //On ne garde que le nombre de ligne de log qui est dans l'ini
    begin
      Log.Delete(0);
    end;

    LogAjoute('-----------------------------------------------------------------');
  end;
  //------

  // init des variables
  bModeAuto := False;
  bModeParam := False;
  iTheId := 0;
  ExitCode := 0;

  if ParamCount > 0 then
  begin
    try
      // Défini si on est en mode auto ou en mode param
      sTypeTrt := UpperCase(ParamStr(1));
      bModeAuto := (sTypeTrt = 'FACT') or (sTypeTrt = 'RESA_ADD') or (sTypeTrt = 'RESA_DEL');
      bModeParam := (sTypeTrt = 'PARAM') or (sTypeTrt = 'SETTINGS') or (sTypeTrt = '?');

      // Lecture des variables
      if bModeAuto then
      begin
        iTheID := StrToInt(ParamStr(2));
      end;
    except on E: Exception do
      begin
        LogAjoute('FormCreate() Ligne 1061 : ' + E.Message); // TODO
        EndProg(2);
      end;
    end;
  end
  else begin
    bModeAuto := False;
    bModeParam := False; // Si on souhaite que sans rien sur la ligne de commande, on affiche le paramétrage, mettre true ici
  end;

  if bModeParam then
  begin
    // Mode param : Paramétrage, on ne connecte pas les DB, etc...
  end
  else if (bModeAuto) and (iTheId > 0) then
  begin
    // Mode automatique
    if ConnectDBs(False) then
    begin
      if DoTraitement(sTypeTrt, iTheId) then
      begin
        EndProg(0);
      end
      else
      begin
        EndProg(MyExCode);
      end;
    end
    else begin
      EndProg(1);
    end;

  end
  else if sTypeTrt = 'TESTDB' then
  begin
    // Vérification de la connection à la base de donnée
    if ConnectDBs(False) then
    begin

      EndProg(0);
    end
    else begin
      EndProg(1);
    end;
  end
  else
  begin
    Showmessage('Synchrostock : Erreur de paramétrage');
    EndProg(2);
  end;

end;

procedure TFrm_SynchroStock.DisconnectDBs;
begin
  IbC_Mag.Close;
  IbC_Cent.Close;
  IbC_Int.Close;
end;

function TFrm_SynchroStock.ConnectDBs(bShowMess: boolean): boolean;
begin
  try
    Result := False;
    if DoConnect(IbC_Mag, Chp_DBMag.Text, bShowMess) then
      if DoConnect(IbC_Cent, Chp_DBCent.Text, bShowMess) then
        if DoConnect(IbC_Int, Chp_DBInt.Text, bShowMess) then
          Result := True;

    if Result then
    begin
      // Lecture des paramètres

      // Pour la base -> MAGASIN <-
      // client centrale dans la base du magasin
      MyParams.iCliIDMag := GetParamInteger(301, 9, IbC_Mag);
      // Mag id utilisé dans le magasin
      MyParams.iMagIDMag := GetParamInteger(303, 9, IbC_Mag);

      // Mode reg et cdt de paiement
      MyParams.iMrgIDMag := GetParamInteger(304, 9, IbC_Mag);
      MyParams.iCpaIDMag := GetParamInteger(305, 9, IbC_Mag);
      MyParams.iTypeCpaMag := Trunc(GetParamFloat(305, 9, IbC_Mag));

      // User ID
      MyParams.iUsrIDMag := GetParamInteger(204, 9, IbC_Mag);
      // Pseudo frais de port
      MyParams.iPseudoFPMag := GetParamInteger(200, 9, IbC_Mag);

      // Récup de la tva des FP
      Que_GetTvaFP.Close;
      Que_GetTvaFP.ParamByName('ARTID').AsInteger := MyParams.iPseudoFPMag;
      Que_GetTvaFP.Open;
      MyParams.fTvaFPMag := Que_GetTvaFP.FieldByName('TVA_TAUX').AsFloat;
      Que_GetTvaFP.Close;


      // Pour la base -> Centrale <-
      // fournisseur magasin dans la base de la centrale
      MyParams.iFouIDCent := GetParamInteger(300, 9, IbC_Cent);

      // Mode reg et cdt de paiement
      MyParams.iMrgIDCent := GetParamInteger(304, 9, IbC_Cent);
      MyParams.iCpaIDCent := GetParamInteger(305, 9, IbC_Cent);
      MyParams.iTypeCpaCent := Trunc(GetParamFloat(305, 9, IbC_Cent));

      // Magid utilisé pour créer les réceptions dans la base centrale
      MyParams.iMagIDCent := GetParamMag(203, 9, IbC_Cent);
      // User
      MyParams.iUsrIDCent := GetParamInteger(204, 9, IbC_Cent);
      // Exercice commercial
      MyParams.iExeIdCent := GetParamInteger(22, 2, IbC_Cent);
      // Pseudo frais de port
      MyParams.iPseudoFPCent := GetParamInteger(200, 9, IbC_Cent);

    end;
  except on E: Exception do
    begin
      LogAjoute('ConnectDBs() : ' + E.Message);
    end;
  end;
end;

function TFrm_SynchroStock.DoConnect(ADB: TIB_Connection;
  APath: string; bShowMess: boolean): boolean;
begin
  if APath <> '' then
  begin
    ADB.Disconnect;
    ADB.Database := APath;
    ADB.LoginUsername := 'ginkoia';
    ADB.Password := 'ginkoia';
    LogAjoute('DoConnect() Path   : ' + ADB.Database);
    LogAjoute('DoConnect() Params : ' + ADB.Params.Text);
    try
      ADB.Connect;
      Result := ADB.Connected;
    except on E: Exception do
      begin
        LogAjoute('DoConnect() : ' + E.Message);
        Result := False;
        if bShowMess then
          showmessage(e.message);
      end;
    end;
  end
  else begin
    if bShowMess then
      showmessage('Chemin vers la base de donnée vide');
    Result := False;
  end;
end;

procedure TFrm_SynchroStock.InitParams;
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    Chp_DBMag.Text  := MyIni.ReadString('PATH', 'DBMAG', '');
    Chp_DBCent.Text := MyIni.ReadString('PATH', 'DBCENT', '');
    Chp_DBInt.Text  := MyIni.ReadString('PATH', 'DBINT', '');
    //Log
    LogAction   := MyIni.ReadBool('LOG', 'ACTIF', False);
    LogNbLigne  := MyIni.ReadInteger('LOG', 'NBLIGNE', 500);
  finally
    MyIni.Free
  end;
end;

procedure TFrm_SynchroStock.LogAjoute(aLogMess: string);
begin
  if LogAction then
  begin
    try
      Log.Add(DateTimeToStr(Now) + '  ' + ALogMess);
      Log.SaveToFile(PathExe + LogFile);
    except
    end;
  end;
end;

procedure TFrm_SynchroStock.SaveParams;
var
  MyIni: TIniFile;
begin
  MyIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    MyIni.WriteString('PATH', 'DBMAG', Chp_DBMag.Text);
    MyIni.WriteString('PATH', 'DBCENT', Chp_DBCent.Text);
    MyIni.WriteString('PATH', 'DBINT', Chp_DBInt.Text);
    //Log
    MyIni.WriteBool('LOG', 'ACTIF', LogAction);
    MyIni.WriteInteger('LOG', 'NBLIGNE', LogNbLigne);
  finally
    MyIni.Free
  end;
end;


procedure TFrm_SynchroStock.FormDestroy(Sender: TObject);
begin
  DisconnectDBs();

  LogAjoute('Fin du programe');
  try
    FreeAndNil(Log);
  except
  end;
end;

procedure TFrm_SynchroStock.Nbt_TestConnectClick(Sender: TObject);
begin
  if ConnectDBs(True) then
    Showmessage('Connexion réussie')
  else
    Showmessage('Connexion échoué');
end;

procedure TFrm_SynchroStock.Nbt_DBIntClick(Sender: TObject);
begin
  try
    if DoConnect(IbC_Int, Chp_DBInt.Text, True) then
    begin
      Showmessage('Connexion réussie');
      LogAjoute('Connexion réussie : IbC_Int');
    end
    else
      Showmessage('Connexion échoué');
  except on E: Exception do
    begin
      LogAjoute('Nbt_DBIntClick() - ' + E.Message);
    end;
  end;
end;

procedure TFrm_SynchroStock.Nbt_DBCentClick(Sender: TObject);
begin
  try
    if DoConnect(IbC_Cent, Chp_DBCent.Text, True) then
    begin
      Showmessage('Connexion réussie');
      LogAjoute('Connexion réussie : IbC_Cent');
    end
    else
      Showmessage('Connexion échoué');
  except on E: Exception do
    begin
      LogAjoute('Nbt_DBCentClick() - ' + E.Message);
    end;
  end;
end;

procedure TFrm_SynchroStock.Nbt_DBMagClick(Sender: TObject);
begin
  try
    if DoConnect(IbC_Mag, Chp_DBMag.Text, True) then
    begin
      Showmessage('Connexion réussie');
      LogAjoute('Connexion réussie : IbC_Mag');
    end
    else
      Showmessage('Connexion échoué');
  except on E: Exception do
    begin
      LogAjoute('Nbt_DBMagClick() - ' + E.Message);
    end;
  end;
end;


procedure TFrm_SynchroStock.Nbt_DBSaveClick(Sender: TObject);
begin
  SaveParams();
  Close;
end;

procedure TFrm_SynchroStock.Nbt_DBCancelClick(Sender: TObject);
begin
  Close;
end;


function TFrm_SynchroStock.NewKCent(Ktb: string): integer;
begin
  with Que_KCent do
  begin
    try
      Close;
      ParamByName('KTB').AsString := Ktb;
      Open;
      Result := FieldByName('ID').AsInteger;
    except on E: Exception do
      begin
        LogAjoute('NewKCent() : ' + E.Message);
        Result := 0;
      end;
    end;
    Close;
  end;
end;

function TFrm_SynchroStock.NewKMag(Ktb: string): integer;
begin
  with Que_KMag do
  begin
    try
      Close;
      ParamByName('KTB').AsString := Ktb;
      Open;
      Result := FieldByName('ID').AsInteger;
    except on E: Exception do
      begin
        LogAjoute('NewKMag() : ' + E.Message);
        Result := 0;
      end;
    end;
    Close;
  end;
end;


function TFrm_SynchroStock.GetParam(iCode: integer; AType: integer;
  var PrmInteger, PrmMag, PrmPos: integer; var PrmFloat: double;
  var PrmString: string; ADB: TIB_Connection): boolean;
begin
  Result := True;
  Que_GetParam.Close;
  Que_GetParam.IB_Connection := ADB;
  try
    Que_GetParam.ParamByName('PRMCODE').AsInteger := iCode;
    Que_GetParam.ParamByName('PRMTYPE').AsInteger := AType;
    Que_GetParam.Open;
    PrmInteger := Que_GetParam.FieldByName('PRM_INTEGER').AsInteger;
    PrmMag := Que_GetParam.FieldByName('PRM_MAGID').AsInteger;
    PrmPos := Que_GetParam.FieldByName('PRM_POS').AsInteger;
    PrmFloat := Que_GetParam.FieldByName('PRM_FLOAT').AsFloat;
    PrmString := Que_GetParam.FieldByName('PRM_STRING').AsString;
    Que_GetParam.Close;
  except on E: Exception do
    begin
      LogAjoute('GetParam() : ' + E.Message);
      Result := False;
    end;
  end;
  Que_GetParam.Close;
end;

function TFrm_SynchroStock.GetParamFloat(ACode: integer; AType: integer; ADB: TIB_Connection): double;
var
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: string;
begin
  Result := 0;
  try
    if GetParam(ACode, Atype, iInt, iMag, iPos, fFlt, sStr, ADB) then
      Result := fFlt;
  except on E: Exception do
    begin
      LogAjoute('GetParamFloat() : ' + E.Message);
    end;
  end;
end;

function TFrm_SynchroStock.GetParamInteger(ACode: integer; AType: integer; ADB: TIB_Connection): integer;
var
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: string;
begin
  Result := 0;
  try
    if GetParam(ACode, Atype, iInt, iMag, iPos, fFlt, sStr, ADB) then
      Result := iInt;
  except on E: Exception do
    begin
      LogAjoute('GetParamInteger() : ' + E.Message);
    end;
  end;
end;

function TFrm_SynchroStock.GetParamMag(ACode, AType: integer;
  ADB: TIB_Connection): integer;
var
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: string;
begin
  Result := 0;
  try
    if GetParam(ACode, Atype, iInt, iMag, iPos, fFlt, sStr, ADB) then
      Result := iMag;
  except on E: Exception do
    begin
      LogAjoute('GetParamMag() : ' + E.Message);
    end;
  end;
end;

function TFrm_SynchroStock.GetParamPos(ACode, AType: integer;
  ADB: TIB_Connection): integer;
var
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: string;
begin
  Result := 0;
  try
    if GetParam(ACode, Atype, iInt, iMag, iPos, fFlt, sStr, ADB) then
      Result := iPos;
  except on E: Exception do
    begin
      LogAjoute('GetParamPos() : ' + E.Message);
    end;
  end;
end;

function TFrm_SynchroStock.GetParamString(ACode: integer; AType: integer; ADB: TIB_Connection): string;
var
  iInt, iMag, iPos: integer;
  fFlt: double;
  sStr: string;
begin
  Result := '';
  try
    if GetParam(ACode, Atype, iInt, iMag, iPos, fFlt, sStr, ADB) then
      Result := sStr;
  except on E: Exception do
    begin
      LogAjoute('GetParamString() : ' + E.Message);
    end;
  end;
end;


function TFrm_SynchroStock.GetArticleInfos(sCodeBar: string): stArticleInfos;
begin
  Que_GetArtInfos.Close;
  Que_GetArtInfos.ParamByName('CBICB').AsString := sCodeBar;
  //  Que_GetArtInfos.ParamByName('MAGID').AsInteger := MyParams.iMagIDMag;
  try
    Que_GetArtInfos.Open;
    Result.iArfId := Que_GetArtInfos.FieldByName('ARF_ID').AsInteger;
    Result.iArtId := Que_GetArtInfos.FieldByName('ARF_ARTID').AsInteger;
    Result.iTgfId := Que_GetArtInfos.FieldByName('CBI_TGFID').AsInteger;
    Result.iCouId := Que_GetArtInfos.FieldByName('CBI_COUID').AsInteger;
    Result.fTVA := Que_GetArtInfos.FieldByName('TVA_TAUX').AsFloat;
    Result.fPxAchat := Que_GetArtInfos.FieldByName('PXACHAT').AsFloat;
  except on E: Exception do
    begin
      LogAjoute('GetArticleInfos() : ' + E.Message);
      Result.iArfId := 0;
      Result.iArtId := 0;
      Result.iTgfId := 0;
      Result.iCouId := 0;
      Result.fTVA := 0;
      Result.fPxAchat := 0;
    end;
  end;
  Que_GetArtInfos.Close;
end;

function TFrm_SynchroStock.GetNewNumMag(S: string): string;
begin
  try
    QryMag.Close;
    QryMag.SQL.Text := 'SELECT NEWNUM FROM ' + S;
    QryMag.Open;
    Result := QryMag.Fields[0].AsString;
  except on E: Exception do
    begin
      LogAjoute('GetNewNumMag() : ' + E.Message);
      Result := '';
    end;
  end;
  QryMag.Close;
end;

function TFrm_SynchroStock.GetNewNumCent(S: string): string;
begin
  try
    QryCent.Close;
    QryCent.SQL.Text := 'SELECT NEWNUM FROM ' + S;
    QryCent.Open;
    Result := QryCent.Fields[0].AsString;
  except on E: Exception do
    begin
      LogAjoute('GetNewNumCent() : ' + E.Message);
      Result := '';
    end;
  end;
  QryCent.Close;
end;

function TFrm_SynchroStock.DernierJour(ADate: TDateTime): TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(IncMonth(ADate, 1), Year, Month, Day);
  Result := EncodeDate(Year, Month, 1) - 1;
end;


function TFrm_SynchroStock.GetIdByLibCent(sNomTbl, sColId, sColLib,
  sNomRecherche, sAddSQL: string): integer;
begin
  Result := 0;
  try
    QryMag.Close;
    QryMag.SQL.Text := 'SELECT ' + sColId + ' FROM ' + sNomTbl + ' JOIN K ON (K_ID = ' + sColId + ' AND K_ENABLED = 1) WHERE ' + sColLib + ' = :' + sColLib + ' ' + sAddSQL;
    QryMag.ParamByName(sColLib).asString := sNomRecherche;
    QryMag.Open;
    Result := QryMag.FieldByName(sColId).AsInteger;
    QryMag.Close;
  except on E: Exception do
    begin
      LogAjoute('GetIdByLibCent() : ' + E.Message);
      //      LogAction('Erreur lecture table ' + sNomTbl + ' : ' + Stan.Message);
    end;
  end;

end;

function TFrm_SynchroStock.GetIdByLibMag(sNomTbl, sColId, sColLib,
  sNomRecherche, sAddSQL: string): integer;
begin
  Result := 0;
  try
    QryCent.Close;
    QryCent.SQL.Text := 'SELECT ' + sColId + ' FROM ' + sNomTbl + ' JOIN K ON (K_ID = ' + sColId + ' AND K_ENABLED = 1) WHERE ' + sColLib + ' = :' + sColLib + ' ' + sAddSQL;
    QryCent.ParamByName(sColLib).asString := sNomRecherche;
    QryCent.Open;
    Result := QryCent.FieldByName(sColId).AsInteger;
    QryCent.Close;
  except on E: Exception do
    begin
      LogAjoute('GetIdByLibMag() : ' + E.Message);
      //    LogAction('Erreur lecture table ' + sNomTbl + ' : ' + Stan.Message);
    end;
  end;

end;

procedure TFrm_SynchroStock.EndProg(Error: integer);
begin
  try
    Grd_CloseAll.Close;
    ExitCode := Error;
    Application.Terminate
  except on E: Exception do
    begin
      LogAjoute('TFrm_SynchroStock() : ' + E.Message);
      //showmessage(e.message);
    end;
  end;
end;

function TFrm_SynchroStock.ArrondiMonetaire(X: double): double;
begin
  try
    Result := Round(X * 100) / 100;
  except on E: Exception do
    begin
      LogAjoute('ArrondiMonetaire() : ' + E.Message);
      Result := 0;
    end;
  end;
end;

end.

