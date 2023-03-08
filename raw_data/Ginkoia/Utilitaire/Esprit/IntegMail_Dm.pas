//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit IntegMail_Dm;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ActionRv,
    IB_Components,
    Db,
    IBODataset,
    dxmdaset,Dlgstd_frm,IntegEsprit_Frm, wwDialog, wwidlg, wwLookupDialogRv;

type
    TDm_Integmail = class(TDataModule)
        Grd_Close: TGroupDataRv;
        IbC_Script: TIB_Cursor;
        Que_TCommande: TIBOQuery;
        Que_Param: TIBOQuery;
        Que_ArtArti: TIBOQuery;
        Que_SSFam: TIBOQuery;
        Que_Plxgtf: TIBOQuery;
        Que_Arttypecomptable: TIBOQuery;
        Que_Taille: TIBOQuery;
        Que_TailleTrav: TIBOQuery;
        Que_Couleur: TIBOQuery;
        Que_CBEsprit: TIBOQuery;
        Que_CBGinkoia: TIBOQuery;
        Que_Tarclgfourn: TIBOQuery;
        Que_PXVente: TIBOQuery;
        Que_TVA: TIBOQuery;
        Que_Magasin: TIBOQuery;
        Que_NoPJ: TIBOQuery;
        Que_ECommande: TIBOQuery;
        Que_ARTREFERENCE: TIBOQuery;
        Que_ArtArticle: TIBOQuery;
        Que_Commande: TIBOQuery;
        Que_ArtRef: TIBOQuery;
        IbC_Que_UpdateCommande: TIB_Cursor;
        memd: TdxMemData;
        memddatatype: TStringField;
        memdean: TStringField;
        memddescription: TStringField;
        memdPxVente: TStringField;
        memdStylenumber: TStringField;
        memdStylecolor: TStringField;
        memdStyleColorDescription: TStringField;
        memdtaille: TStringField;
        memdSaison: TStringField;
        memdDivision: TStringField;
        memdProductClass: TStringField;
        memdPxAchat: TStringField;
        memdsaisonYear: TStringField;
        memdISS: TStringField;
        memdSSP: TStringField;
        memdCmd: TStringField;
        memdNumberCMD: TStringField;
        memdorderNumber: TStringField;
        memdDateInvoice: TStringField;
        memdDateOrder: TStringField;
        memdCodeclient: TStringField;
        memddeliveryloc: TStringField;
        MemD_TVA: TdxMemData;
        MemD_TVATXTVA: TStringField;
        MemD_TVAQuantite: TStringField;
        MemD_TVAPXAchat: TStringField;
        IbC_Typegt: TIB_Cursor;
        IbC_Ordreaff: TIB_Cursor;
        grd_open: TGroupDataRv;
        Que_Rayon: TIBOQuery;
        Que_Famille: TIBOQuery;
        Que_SSFamille: TIBOQuery;
        Que_RayonRAY_ID: TIntegerField;
        Que_RayonRAY_UNIID: TIntegerField;
        Que_RayonRAY_IDREF: TIntegerField;
        Que_RayonRAY_NOM: TStringField;
        Que_RayonRAY_ORDREAFF: TIBOFloatField;
        Que_RayonRAY_VISIBLE: TIntegerField;
        Que_RayonRAY_SECID: TIntegerField;
        Que_FamilleFAM_ID: TIntegerField;
        Que_FamilleFAM_RAYID: TIntegerField;
        Que_FamilleFAM_IDREF: TIntegerField;
        Que_FamilleFAM_NOM: TStringField;
        Que_FamilleFAM_ORDREAFF: TIBOFloatField;
        Que_FamilleFAM_VISIBLE: TIntegerField;
        Que_FamilleFAM_CTFID: TIntegerField;
        Que_SSFamilleSSF_ID: TIntegerField;
        Que_SSFamilleSSF_FAMID: TIntegerField;
        Que_SSFamilleSSF_IDREF: TIntegerField;
        Que_SSFamilleSSF_NOM: TStringField;
        Que_SSFamilleSSF_ORDREAFF: TIBOFloatField;
        Que_SSFamilleSSF_VISIBLE: TIntegerField;
        Que_SSFamilleSSF_CATID: TIntegerField;
        Que_SSFamilleSSF_TVAID: TIntegerField;
        Que_SSFamilleSSF_TCTID: TIntegerField;
    Que_GetMaxFromTable: TIBOQuery;
    Que_Temp: TIBOQuery;
    MemD_Rapport: TdxMemData;
    MemD_RapportNoCommande: TStringField;
    MemD_RapportLigneCommande: TStringField;
    MemD_RapportErreur: TStringField;
    MemD_RapportMotif: TStringField;
    LK_SSFamille: TwwLookupDialogRV;
    MemD_SSFamille: TdxMemData;
    MemD_SSFamilleIdSSFAMILLE: TStringField;
        procedure DataModuleDestroy(Sender: TObject);
        procedure GenerikAfterCancel3(DataSet: TDataSet);
        procedure GenerikAfterPost3(DataSet: TDataSet);
        procedure GenerikBeforeDelete3(DataSet: TDataSet);
        procedure GenerikNewRecord3(DataSet: TDataSet);
        procedure GenerikUpdateRecord3(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel11(DataSet: TDataSet);
        procedure GenerikAfterPost11(DataSet: TDataSet);
        procedure GenerikBeforeDelete11(DataSet: TDataSet);
        procedure GenerikNewRecord11(DataSet: TDataSet);
        procedure GenerikUpdateRecord11(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel9(DataSet: TDataSet);
        procedure GenerikAfterPost9(DataSet: TDataSet);
        procedure GenerikBeforeDelete9(DataSet: TDataSet);
        procedure GenerikNewRecord9(DataSet: TDataSet);
        procedure GenerikUpdateRecord9(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel1(DataSet: TDataSet);
        procedure GenerikAfterPost1(DataSet: TDataSet);
        procedure GenerikBeforeDelete1(DataSet: TDataSet);
        procedure GenerikNewRecord1(DataSet: TDataSet);
        procedure GenerikUpdateRecord1(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure DataModuleCreate(Sender: TObject);
    private
        { Déclarations privées }
        FNbRayon,FNbSousFamille : Integer;
    public
        { Déclarations publiques }
        function Ecommande(NUMFOURN, client, date: string;var CDE_NUMERO:string): string;
        function ArtArticle(Division, ProductClass, ISS, description, Year, Stylenumber,appli: string): string;
        function ArtReference(Division, ProductClass, ART_ID: string): string;
        function Lcommande(CDE_ID, ART_ID, TGF_ID, COU_ID, Cmd, PxAchat, TX_TVA, PxVente, CDL_OFFSET: string): string;

        function CreationNomenclature(Division,ProductClass : String) : Integer;
        function GetMaxFromTable(sTableName, sFieldId, sFieldMax : String) : Integer;
        function GetSecteurID(sSecNom : String) : Integer;
        function GetTCTID : Integer;

        procedure RapportPJ(memD_Rapport: TdxMemData; NumComm, LigneComm, Erreur, Motif: string);
        procedure RapportSSFamilleAdd(Memd : TdxMemData; IdSSFamille : String);

        property NbRayon : Integer Read FNbRayon Write FNbRayon;
        property NbSSFamille : Integer Read FNbSousFamille Write FNbSousFamille;
    end;

var
    Dm_IntegMail: TDm_Integmail;

implementation
uses
    GinkoiaresStr,
    GinkoiaStd,
    Main_Dm;
{$R *.DFM}

procedure TDm_Integmail.DataModuleDestroy(Sender: TObject);
begin
       Grd_close.Close;
end;

//-------------------------------------------------------------------------
//
//                  Creation d'une entete de commande
//
//-------------------------------------------------------------------------

function TDm_Integmail.Ecommande(NUMFOURN, client, date: string;var CDE_NUMERO:string): string;
var
    CDE_ID: string;
    CDE_SAISON, CDE_EXEID, CDE_CPAID: string;
    CDE_MAGID, CDE_FOUID, CDE_LIVRAISON, CDE_OFFSET, CDE_TYPID: string;
    TempsString, StrQuery: string;
    TempDate: TDateTime;
    An, Mois, Jour: string;
begin
    CDE_ID := '0';
    // Creation d'une entete de commande
    // La commande en cours n'a pas encore etait traité la ligne precedente.
    // -- Creation de l'entete de commande --
        // - 0 : Recherche des divers champs de remplissage
        // - CDE_NUMERO
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.sql.Add('select NewNum from BC_NEWNUM');
    IbC_Script.open;
    CDE_NUMERO := IbC_Script.fieldbyname('NewNum').AsString;
    // - CDE_SAISON
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=8';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_SAISON := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_EXEID
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=2';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_EXEID := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_CPAID
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=3';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_CPAID := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_MAGID
    StrQuery := 'Select prm_magid, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=1 And prm_String= ''' + client + '''';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_MAGID := Que_Param.fieldbyname('prm_magid').AsString;
    // - CDE_FOUID
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=4';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_FOUID := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_LIVRAISON
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=6 ';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_LIVRAISON := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_OFFSET
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=7';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    CDE_OFFSET := Que_Param.fieldbyname('prm_integer').AsString;
    // - CDE_TYPID
    StrQuery := 'Select typ_id from gentypcdv where typ_cod=101';
    Que_TCommande.sql.clear;
    Que_TCommande.sql.Add(StrQuery);
    Que_TCommande.ExecSql;
    CDE_TYPID := Que_TCommande.fieldbyname('typ_id').AsString;
    // - Date de la commande
    // Mise au format Date
    TempsString := date;
    An := copy(TempsString, 1, 4);
    Mois := copy(TempsString, 5, 2);
    Jour := copy(TempsString, 7, 2);
    TempsString := Jour + '/' + Mois + '/' + An;
    TempDate := StrToDate(TempsString);
    // - 1 : insertion d'une entete de commande
    if CDE_MAGID = '' then CDE_MAGID := '0';
    Que_ECommande.insert;
    Que_ECommande.fieldbyname('CDE_NUMERO').asstring := CDE_NUMERO;
    Que_ECommande.fieldbyname('CDE_SAISON').asstring := CDE_SAISON;
    Que_ECommande.fieldbyname('CDE_EXEID').asstring := CDE_EXEID;
    Que_ECommande.fieldbyname('CDE_CPAID').asstring := CDE_CPAID;
    Que_ECommande.fieldbyname('CDE_MAGID').asstring := CDE_MAGID;
    Que_ECommande.fieldbyname('CDE_FOUID').asstring := CDE_FOUID;
    Que_ECommande.fieldbyname('CDE_NUMFOURN').asstring := NUMFOURN;
    Que_ECommande.fieldbyname('CDE_DATE').asstring := TempsString;
    Que_ECommande.fieldbyname('CDE_REMISE').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVAHT1').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVATAUX1').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVA1').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVAHT2').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVATAUX2').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVA2').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVAHT3').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVATAUX3').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVA3').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVAHT4').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVATAUX4').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVA4').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVAHT5').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVATAUX5').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_TVA5').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_FRANCO').AsInteger := 1;
    Que_ECommande.fieldbyname('CDE_MODIF').AsInteger := 0;
    // Conversion format date pour calcul de date (Date commande + Nb Jour)
    TempDate := TempDate + StrToInt(CDE_LIVRAISON);

    DateTimeToString(TempsString, 'dd/mm/yy', TempDate);

    Que_ECommande.fieldbyname('CDE_LIVRAISON').asstring := TempsString;
    //Que_ECommande.fieldbyname('CDE_LIVRAISON').AsDateTime := TempDate;
    Que_ECommande.fieldbyname('CDE_OFFSET').asstring := CDE_OFFSET;
    Que_ECommande.fieldbyname('CDE_REMGLO').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_ARCHIVE').AsInteger := 0;
    //- NULL -             Que_ECommande.fieldbyname('CDE_REGLEMENT').AsInteger :=
    Que_ECommande.fieldbyname('CDE_TYPID').asstring := CDE_TYPID;
    Que_ECommande.fieldbyname('CDE_NOTVA').AsInteger := 0;
    Que_ECommande.fieldbyname('CDE_CENTRALE').AsInteger := 0;
    // ! En base mais non compris par le composant                Que_ECommande.fieldbyname('CDE_USRID').AsInteger := 0;
    // ! En base mais non compris par le composant                Que_ECommande.fieldbyname('CDE_COMENT').asstring := '';
    //--- A decommenter apres             Que_ECommande.post;
    Que_ECommande.post;
    //- Recuperation de CDE_ID (table COMBCDE)
    //- A decommenter apres                CDE_ID := Que_ECommande.FieldByName('CDE_ID').AsString;
    CDE_ID := Que_ECommande.FieldByName('CDE_ID').AsString;
    result := CDE_ID;
end;

//-------------------------------------------------------------------------
//
//                  Creation d'une Ligne de commande
//
//-------------------------------------------------------------------------

function TDm_Integmail.Lcommande(CDE_ID, ART_ID, TGF_ID, COU_ID, Cmd, PxAchat, TX_TVA, PxVente, CDL_OFFSET: string): string;
var
    CDL_ID: string;
begin
    CDL_ID := '0';
    // insertion
    Que_Commande.insert;
    Que_Commande.fieldbyname('CDL_CDEID').AsString := CDE_ID;
    Que_Commande.fieldbyname('CDL_ARTID').AsString := ART_ID;
    Que_Commande.fieldbyname('CDL_TGFID').AsString := TGF_ID;
    Que_Commande.fieldbyname('CDL_COUID').AsString := COU_ID;
    Que_Commande.fieldbyname('CDL_QTE').AsString := Cmd;
    Que_Commande.fieldbyname('CDL_PXCTLG').AsString := PxAchat;
    Que_Commande.fieldbyname('CDL_REMISE1').AsInteger := 0;
    Que_Commande.fieldbyname('CDL_REMISE2').AsInteger := 0;
    Que_Commande.fieldbyname('CDL_REMISE3').AsInteger := 0;
    Que_Commande.fieldbyname('CDL_PXACHAT').AsString := PxAchat;
    Que_Commande.fieldbyname('CDL_TVA').AsString := TX_TVA;
    Que_Commande.fieldbyname('CDL_PXVENTE').AsString := PxVente;
    Que_Commande.fieldbyname('CDL_OFFSET').AsString := CDL_OFFSET;
    Que_Commande.fieldbyname('CDL_LIVRAISON').Asstring :=Que_ECommande.fieldbyname('CDE_LIVRAISON').asstring ;
    Que_Commande.fieldbyname('CDL_TARTAILLE').AsInteger := 0;
    Que_Commande.fieldbyname('CDL_VALREMGLO').AsInteger := 0;
    Que_Commande.post;
    CDL_ID := Que_Commande.fieldbyname('CDL_ID').AsString;
    result := CDL_ID;
end;

procedure TDm_Integmail.RapportPJ(memD_Rapport: TdxMemData; NumComm, LigneComm,
  Erreur, Motif: string);
begin
    // Creation d'un rapport de fonctionnement
    memD_Rapport.open;
    memD_Rapport.append;
    MemD_RapportNoCommande.asstring := NumComm;
    MemD_RapportLigneCommande.asstring := LigneComm;
    MemD_RapportErreur.asstring := Erreur;
    MemD_RapportMotif.asstring := Motif;
    memD_Rapport.post;
end;

procedure TDm_Integmail.RapportSSFamilleAdd(Memd: TdxMemData;
  IdSSFamille: String);
begin
  With Memd do
  begin
    Open;
    Append;
    FieldByName('IdSSFamille').AsString := IdSSFamille;
    Post;
  end;
end;

//-------------------------------------------------------------------------
//
//                  Creation d'un Modele Article
//
//-------------------------------------------------------------------------

function TDm_Integmail.ArtArticle(Division, ProductClass, ISS, description, Year, Stylenumber,appli: string): string;
var
    StrQuery: string;
    ART_MRKID, ART_SSFID, ART_GTFID, ART_ID: string;
    TempsString: string;
begin
    
    ART_ID := '0';
    // Creation d'un modele ArtArticle
    // ---- Creation du modele ---- //
        // - Recherche ART_MRKID
    StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=5';
    Que_Param.sql.clear;
    Que_Param.sql.Add(StrQuery);
    Que_Param.ExecSql;
    ART_MRKID := Que_Param.fieldbyname('prm_integer').AsString;
    // - Recherche ART_SSFID
    TempsString := ProductClass+Division ;
    StrQuery := 'select ssf_id,ssf_tvaid from nklssfamille join k on ssf_id=k_id and k_enabled=1 where ssf_nom= ''' + TempsString + ' '' ';
    Que_SSFam.sql.clear;
    Que_SSFam.sql.Add(StrQuery);
    Que_SSFam.ExecSql;
    ART_SSFID := Que_SSFam.fieldbyname('ssf_id').AsString;
    if ART_SSFID = '' then
    begin
      ART_SSFID := IntToStr(CreationNomenclature(Division,ProductClass));
      //ART_SSFID := '0';
    end;
    // - Recherche ART_GTFID
//    StrQuery := 'Select gtf_id from plxgtf join k on k_id=gtf_id and k_enabled=1 where gtf_idref= ' + ISS;
//    Que_Plxgtf.sql.clear;
//    Que_Plxgtf.sql.Add(StrQuery);
//    Que_Plxgtf.ExecSql;
    que_plxgtf.close;
    que_plxgtf.parambyname('GRILLETAILLE').asstring:=iss;
    que_plxgtf.open;
    ART_GTFID := Que_Plxgtf.fieldbyname('gtf_id').AsString;

    if ART_GTFID = '' then
    begin
        //Attention la GT n'existe pas
        if appli = 'ESPRIT' then
        begin
            ibc_typegt.open;
            que_plxgtf.insert;
            que_plxgtf.fieldbyname('gtf_idref').asstring := ISS;
            que_plxgtf.fieldbyname('gtf_nom').asstring := 'ESPRIT ' + ISS;
            if ibc_typegt.eof then
                que_plxgtf.fieldbyname('gtf_tgtid').asinteger := 0
            else
                que_plxgtf.fieldbyname('gtf_tgtid').asinteger := ibc_typegt.fieldbyname('tgt_id').asinteger;
            ibc_ordreaff.open;
            que_plxgtf.fieldbyname('gtf_ordreaff').asfloat := ibc_ordreaff.fieldbyname('ordreaff').asfloat + 10;
            que_plxgtf.post;
            ART_GTFID := Que_Plxgtf.fieldbyname('gtf_id').AsString;
        end;
    end;



    // - Insertion Table ARTARTICLE :
    Que_ArtArticle.insert;
    Que_ArtArticle.fieldbyname('ART_IDREF').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_NOM').asstring := description;
    Que_ArtArticle.fieldbyname('ART_ORIGINE').AsInteger := 1;
    Que_ArtArticle.fieldbyname('ART_DESCRIPTION').asstring := Year;
    Que_ArtArticle.fieldbyname('ART_MRKID').asstring := ART_MRKID;
    Que_ArtArticle.fieldbyname('ART_REFMRK').asstring := Stylenumber;
    Que_ArtArticle.fieldbyname('ART_SSFID').asstring := ART_SSFID;
    Que_ArtArticle.fieldbyname('ART_PUB').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_GTFID').asstring := ART_GTFID;
    Que_ArtArticle.fieldbyname('ART_SESSION').asstring := '';
    Que_ArtArticle.fieldbyname('ART_GREID').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_THEME').asstring := '';
    Que_ArtArticle.fieldbyname('ART_GAMME').asstring := '';
    Que_ArtArticle.fieldbyname('ART_CODECENTRALE').asstring := '';
    Que_ArtArticle.fieldbyname('ART_TAILLES').asstring := '';
    Que_ArtArticle.fieldbyname('ART_POS').asstring := '';
    Que_ArtArticle.fieldbyname('ART_GAMPF').asstring := '';
    Que_ArtArticle.fieldbyname('ART_POINT').asstring := '';
    Que_ArtArticle.fieldbyname('ART_GAMPRODUIT').asstring := '';
    Que_ArtArticle.fieldbyname('ART_SUPPRIME').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_REFREMPLACE').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_GARID').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_CODEGS').AsInteger := 0;
    Que_ArtArticle.fieldbyname('ART_COMENT1').asstring := '';
    Que_ArtArticle.fieldbyname('ART_COMENT2').asstring := '';
    Que_ArtArticle.fieldbyname('ART_COMENT3').asstring := '';
    Que_ArtArticle.fieldbyname('ART_COMENT4').asstring := '';
    Que_ArtArticle.fieldbyname('ART_COMENT5').asstring := '';
    Que_ArtArticle.fieldbyname('ART_CODEDOUANIER').asstring := '';
    Que_ArtArticle.fieldbyname('ART_CPTANA').asstring := '';
    Que_ArtArticle.post;
    // - Recuperation de ART_ID(table ARTARTICLE)
    ART_ID := Que_ArtArticle.FieldByName('ART_ID').AsString;
    result := ART_ID;
    
end;

//-------------------------------------------------------------------------
//
//                  Creation d'un Modele Reference
//
//-------------------------------------------------------------------------

function TDm_Integmail.ArtReference(Division, ProductClass, ART_ID: string): string;
var
    ART_SSFID: string;
    ARF_TVAID, ARF_TCTID, DATEJOUR, ARF_CHRONO: string;
    ARF_ID: string;
    TempsString, StrQuery: string;
begin
    ARF_ID := '0';
    // Creation d'un modele ArtReference
    // - Insertion Table ARTREFERENCE :
       // - Recherche ART_SSFID
    TempsString := ProductClass+Division;
    StrQuery := 'select ssf_id,ssf_tvaid from nklssfamille join k on ssf_id=k_id and k_enabled=1 where ssf_nom= ''' + TempsString + ' '' ';
    Que_SSFam.sql.clear;
    Que_SSFam.sql.Add(StrQuery);
    Que_SSFam.ExecSql;
    ART_SSFID := Que_SSFam.fieldbyname('ssf_id').AsString;
    if ART_SSFID = '' then ART_SSFID := '0';
    // - ARF_TVAID
    StrQuery := 'Select ssf_id, ssf_tvaid from nklssfamille join k on ssf_id=k_id and k_enabled=1 where ssf_id= ' + ART_SSFID;
    Que_SSFam.sql.clear;
    Que_SSFam.sql.Add(StrQuery);
    Que_SSFam.ExecSql;
    ARF_TVAID := Que_SSFam.fieldbyname('ssf_tvaid').AsString;
    if ARF_TVAID = '' then ARF_TVAID := '0';
    // - ARF_TCTID
    StrQuery := 'Select tct_id from arttypecomptable join k on k_id=tct_id and k_enabled=1 where tct_code=1';
    Que_Arttypecomptable.sql.clear;
    Que_Arttypecomptable.sql.Add(StrQuery);
    Que_Arttypecomptable.ExecSql;
    ARF_TCTID := Que_Arttypecomptable.fieldbyname('tct_id').AsString;
    if ARF_TCTID = '' then ARF_TCTID := '0';
    // - DATEJOUR
    DATEJOUR := DateTimeToStr(DATE);
    // - ARF_CHRONO
    IbC_Script.sql.Clear;
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.sql.Add('select NewNum from ART_CHRONO');
    IbC_Script.open;
    ARF_CHRONO := IbC_Script.fieldbyname('NewNum').AsString;
    // Insertion
    Que_ARTREFERENCE.insert;
    Que_ARTREFERENCE.fieldbyname('ARF_ARTID').asstring := ART_ID;
    Que_ARTREFERENCE.fieldbyname('ARF_CATID').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_TVAID').asstring := ARF_TVAID;
    Que_ARTREFERENCE.fieldbyname('ARF_TCTID').asstring := ARF_TCTID;
    Que_ARTREFERENCE.fieldbyname('ARF_ICLID1').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_ICLID2').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_ICLID3').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_ICLID4').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_ICLID5').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_CREE').asstring := DATEJOUR;
    // - NULL            Que_ARTREFERENCE.fieldbyname('ARF_MODIF').AsInteger :=
    Que_ARTREFERENCE.fieldbyname('ARF_CHRONO').asstring := ARF_CHRONO;
    Que_ARTREFERENCE.fieldbyname('ARF_DIMENSION').AsInteger := 1;
    Que_ARTREFERENCE.fieldbyname('ARF_DEPRECIATION').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_VIRTUEL').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_SERVICE').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_COEFT').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_STOCKI').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_VTFRAC').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_CDNMT').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_CDNMTQTE').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_UNITE').asstring := '';
    Que_ARTREFERENCE.fieldbyname('ARF_CDNMTOBLI').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_GUELT').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_CPFA').AsInteger := 1;
    Que_ARTREFERENCE.fieldbyname('ARF_FIDELITE').AsInteger := 1;
    Que_ARTREFERENCE.fieldbyname('ARF_ARCHIVER').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_FIDPOINT').AsInteger := 0;
    // - NULL            Que_ARTREFERENCE.fieldbyname('ARF_FIDDEBUT').AsInteger :=
    // - NULL            Que_ARTREFERENCE.fieldbyname('ARF_FIDFIN').AsInteger :=
    Que_ARTREFERENCE.fieldbyname('ARF_DEPTAUX').AsInteger := 0;
    // -             Que_ARTREFERENCE.fieldbyname('ARF_DEPDATE').AsInteger :=
    Que_ARTREFERENCE.fieldbyname('ARF_DEPMOTIF').AsString := '';
    Que_ARTREFERENCE.fieldbyname('ARF_CGTID').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_GLTMONTANT').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_GLTPXV').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_GLTMARGE').AsInteger := 0;
    // - NULL            Que_ARTREFERENCE.fieldbyname('ARF_GLTDEBUT').AsInteger :=
    // - NULL            Que_ARTREFERENCE.fieldbyname('ARF_GLTFIN').AsInteger :=
    Que_ARTREFERENCE.fieldbyname('ARF_MAGORG').AsInteger := 0;
    Que_ARTREFERENCE.fieldbyname('ARF_CATALOG').AsInteger := 0;
    Que_ARTREFERENCE.post;
    // - Recuperation de ARF_ID
    ARF_ID := Que_ARTREFERENCE.FieldByName('ARF_ID').AsString;
    result := ARF_ID;
end;

function TDm_Integmail.GetMaxFromTable(sTableName, sFieldId, sFieldMax: String): Integer;
begin
  With Que_GetMaxFromTable do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select Max(' + sFieldMax + ') as Resultat From ' + sTableName );
    SQL.Add('Join K on (K_ID = ' + sFieldId + ' and K_Enabled = 1)');
    Open;

    Result := FieldByName('Resultat').AsInteger;
  end;
end;


function TDm_Integmail.GetSecteurID(sSecNom: String): Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select SEC_ID From NKLSECTEUR');
    SQL.Add('JOIN K on (K_ID = sec_id and K_enabled = 1)');
    SQL.Add('Where SEC_NOM = ' + QuotedStr(sSecNom));
    Open;

    if Recordcount > 0 then
      Result := FieldByName('SEC_ID').AsInteger
    else
      Result := -1;
  end;
end;

function TDm_Integmail.GetTCTID: Integer;
begin
  With Que_Temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select TCT_ID From ARTTYPECOMPTABLE');
    SQL.Add('Join k on (k_id = TCT_ID and k_enabled = 1)');
    SQL.Add('Where TCT_CODE = 1');
    Open;
    if RecordCount > 0 then
      Result := FieldByName('TCT_ID').AsInteger
    else
      Result := -1;
  end;
end;

function TDm_Integmail.CreationNomenclature(Division,
  ProductClass: String): Integer;
var
  iRayId,iFamId : Integer;
  iRayMax,iFamMax, iSSFMax : Integer;
begin
  Result := -1;

  // suppression des évenements pour la gestion de la transaction des 3 requetes
  Que_Rayon.AfterPost := nil;
  Que_Famille.AfterPost := nil;
  Que_SSFamille.AfterPost := nil;
  try

    Dm_Main.StartTransaction;
    try
      // Vérification si le rayon existe
      With Que_Rayon do
      begin
        Close;
        ParamByName('CODERAYON').AsString := Division + '%';
        Open;

        if Recordcount = 0 then
        begin
          // Création du rayon s'il n'existe pas
          Insert;
          FieldByName('RAY_UNIID').AsInteger    := StdGinKoia.UniVers;
          FieldByName('RAY_IDREF').AsInteger    := 0;
          FieldByName('RAY_NOM').AsString       := Division + ' - << Libellé à définir >>';
          FieldByName('RAY_ORDREAFF').AsInteger := GetMaxFromTable('NKLRAYON','RAY_ID','RAY_ORDREAFF') + 10;
          FieldByname('RAY_VISIBLE').AsInteger  := 1;
          FieldByName('RAY_SECID').AsInteger    := GetSecteurID('ESPRIT');
          try
            Post;
            RapportPJ(memD_Rapport, '0', 'OK', Division,'Nouveau Rayon');
            Inc(FNbRayon);
          Except on E:Exception do
            begin
              Cancel;
              InfoMessHP('Erreur lors de la création du rayon de l''article',True,0,0,'Erreur');
              Raise;
            end;
          end;  // try
        end;  // else
        // récupération de l'id du rayon
        iRayId := FieldByName('RAY_ID').AsInteger;
      end; // with

      // création de la famille
      With Que_Famille do
      begin
        Close;
        Open;

        Insert;
        FieldByName('FAM_RAYID').AsInteger    := iRayId;
        FieldByName('FAM_IDREF').AsInteger    := 0;
        FieldByName('FAM_NOM').AsString       := ProductClass + ' << Libellé à définir >>';
        FieldByName('FAM_ORDREAFF').AsInteger := GetMaxFromTable('NKLFAMILLE','FAM_ID','FAM_ORDREAFF') + 10;
        FieldByName('FAM_VISIBLE').AsInteger  := 1;
        FieldByName('FAM_CTFID').AsInteger    := 0;
        try
          Post;
          iFamId := FieldByName('FAM_ID').asInteger;
          RapportPJ(memD_Rapport, '0', 'OK', ProductClass, 'Nouvelle famille');
        Except on E:Exception do
          begin
            Cancel;
            InfoMessHP('Erreur lors de la création de la famille de l''article',True,0,0,'Erreur');
            Raise;
          end;
        end;
      end;

      // Créer la sous famille
      With Que_SSFamille do
      begin
        Close;
        Open;

        Insert;
        FieldByName('SSF_FAMID').AsInteger    := iFamId;
        FieldByName('SSF_IDREF').AsInteger    := 0;
        FieldByName('SSF_NOM').AsString       := ProductClass + Division;
        FieldByName('SSF_ORDREAFF').AsInteger := GetMaxFromTable('NKLSSFAMILLE','SSF_ID','SSF_ORDREAFF') + 10;
        FieldByName('SSF_VISIBLE').AsInteger  := 1;
        FieldByName('SSF_CATID').AsInteger    := 0;
        FieldByName('SSF_TVAID').AsInteger    := StdGinKoia.DefTvaId;
        FieldByName('SSF_TCTID').AsInteger    := GetTCTID;
        try
          Post;
          // Retourner le SSF_ID
          Result := FieldByName('SSF_ID').AsInteger;
          Dm_Main.Commit;
          RapportPJ(memD_Rapport, '0', 'OK', ProductClass + Division,'Nouvelle sousfamille' );
          Inc(FNbSousFamille);
          RapportSSFamilleAdd(MemD_SSFamille,ProductClass + Division);
        Except on E:Exception do
          begin
            Cancel;
            InfoMessHP('Erreur lors de la création de la sous-famille de l''article',True,0,0,'Erreur');
            Raise;
          end;
        end;
      end;
      // tout c'est bien passé on update les tables
      Dm_Main.IBOUpDateCache(Que_Rayon);
      Dm_Main.IBOUpDateCache(Que_Famille);
      Dm_Main.IBOUpDateCache(Que_SSFamille);

    Except on E:Exception do
      begin
        Dm_Main.IBOCancelCache(Que_Rayon);
        Dm_Main.IBOCancelCache(Que_Famille);
        Dm_Main.IBOCancelCache(Que_SSFamille);
        Dm_Main.Rollback;
      end;
    end;
  finally
    // remise en place des events des composants
    Que_Rayon.AfterPost := GenerikAfterPost1;
    Que_Famille.AfterPost := GenerikAfterPost1;
    Que_SSFamille.AfterPost := GenerikAfterPost1;

    Dm_Main.IBOCommitCache(Que_Rayon);
    Dm_Main.IBOCommitCache(Que_Famille);
    Dm_Main.IBOCommitCache(Que_SSFamille);
  end;
end;

procedure TDm_Integmail.GenerikAfterCancel3(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikAfterPost3(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikBeforeDelete3(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TDm_Integmail.GenerikNewRecord3(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_Integmail.GenerikUpdateRecord3(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_Integmail.GenerikAfterCancel11(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikAfterPost11(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikBeforeDelete11(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TDm_Integmail.GenerikNewRecord11(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_Integmail.GenerikUpdateRecord11(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TDm_Integmail.GenerikAfterCancel9(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikAfterPost9(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikBeforeDelete9(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TDm_Integmail.GenerikNewRecord9(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_Integmail.GenerikUpdateRecord9(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

//

procedure TDm_Integmail.GenerikAfterCancel1(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikAfterPost1(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TDm_Integmail.GenerikBeforeDelete1(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TDm_Integmail.GenerikNewRecord1(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TDm_Integmail.GenerikUpdateRecord1(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;













procedure TDm_Integmail.DataModuleCreate(Sender: TObject);
begin
grd_open.open;
end;

end.

