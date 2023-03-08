unit UnitThread;

interface
uses Windows, Classes, SysUtils,IB_Components,IBODataset,ADODB,Forms,DateUtils,
DBClient,DB,StrUTils,midaslib;

type
  TTranspoThread = class(TThread)
  private
    procedure CentralControl;
  public
    constructor Create(CreateSuspended:boolean);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

Type
  TProcedure = procedure;
    Procedure Traitement;
    Procedure Log(Texte:String);
    Procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet);
    Procedure Add_csv(Fichier,Texte:String);
    
Var
  Compteur     : Integer=0;          //Compte le nombre de matériel traité
  NbLigne      : Integer;            //Nombre de ligne à traité
  StartImport  : Boolean=False;      //Variable de démarrage du traitement
  StopImport   : Boolean=False;      //Interrompt le traitement
  LibInfo      : String;             //Message d'information pour l'utilisateur
  ChemSource   : String;             //Chemin des fichiers sources

implementation

uses UnitPrincipale;

constructor TTranspoThread.Create(CreateSuspended:boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:=false;
  Priority:=tpNormal;
end;

destructor TTranspoThread.Destroy;
begin
  inherited;
end;

procedure TTranspoThread.CentralControl;
begin
  if StartImport=True then
    Traitement;
end;

procedure TTranspoThread.Execute;
begin
  repeat
    Sleep(1000); //en millisecondes
    CentralControl;
  until Terminated;
end;

procedure Traitement;
//Effectue la transpo des données
Var
  I,J                 : Integer;         //Variable de boucle
  Transaction         : TIB_Transaction; //Transaction
  CDS_Rayon           : TclientDataSet;  //Liste des lignes de rayn
  CDS_Famille         : TclientDataSet;  //Liste des lignes de famille
  CDS_SousFamille     : TclientDataSet;  //Liste des lignes de sous famille
  CurrentFile         : String;          //Nom du fichier à traiter, à remplacer en début de traitement, facilité les copier/Coller
  CurrentCDS          : TClientDataSet;  //Permets de passer la CDS Principale dans une variable, facilité les copier/Coller
  RAY_ID              : Integer;         //ID du rayon dans NKLRAYON
  FAM_ID              : Integer;         //ID du rayon dans NKLFAMILLE
  SSF_ID              : Integer;         //ID du rayon dans NKLSSFAMILLE
  Que_InsertRayon     : TIBOQuery;       //Query d'insertion d'un rayon
  Que_InsertFamille   : TIBOQuery;       //Query d'insertion d'une famille
  Que_InsertSSFamille : TIBOQuery;       //Query d'insertion d'une sous famille
  Que_UpdateRayon     : TIBOQuery;       //Query d'update d'un rayon
  Que_UpdateFamille   : TIBOQuery;       //Query d'update d'une famille
  Que_UpdateSSFamille : TIBOQuery;       //Query d'update d'une sous famille
  Que_CtrlGENIMPORT   : TIBOQuery;       //Query de contrôle de référencement dans GENIMPORT
  Que_Univers         : TIBOQuery;       //Query de recherche de l'univers
  Que_NEWK            : TIBOQuery;       //Query de création d'un K
  Que_InsertGENIMPORT : TIBOQuery;       //Query de référencement dans GENIMPORT
  Que_UpdateGENIMPORT : TIBOQuery;       //Query de mise à jour référencement dans GENIMPORT
  Que_SearchGENIMPORT : TIBOQuery;       //Query de recherche d'un ID_GINKOIA dans GENIMPORT
  Que_SearchTVAID     : TIBOQuery;       //Query de recherche du taux de tva (ARTTVA)
  Que_SearchTCTID     : TIBOQuery;       //Query de recherche du type d'article comptable ARTTYPECOMPTABLE)
  Que_SearchSECID     : TIBOQuery;       //Query de recherche du secteur WEB
Begin
  //Verrouille le traitement pour qu'il ne se relance pas
  StartImport := False;

  //Message d'information
  LibInfo := 'Traitement en cours...';

  //Création de la transaction
  Transaction               := TIB_Transaction.Create(nil);
  Transaction.IB_Connection := Frm_Principale.Ginkoia;
  Transaction.AutoCommit    := False;
  Frm_Principale.Ginkoia.DefaultTransaction := Transaction;

  //Création des query d'intégration
  Que_Univers         := TIBOQuery.Create(nil);
  Que_CtrlGENIMPORT   := TIBOQuery.Create(nil);
  Que_NewK            := TIBOQuery.Create(nil);
  Que_InsertGENIMPORT := TIBOQuery.Create(nil);
  Que_UpdateGENIMPORT := TIBOQuery.Create(nil);
  Que_SearchGENIMPORT := TIBOQuery.Create(nil);
  Que_InsertRayon     := TIBOQuery.Create(nil);
  Que_InsertFamille   := TIBOQuery.Create(nil);
  Que_InsertSSFamille := TIBOQuery.Create(nil);
  Que_UpdateRayon     := TIBOQuery.Create(nil);
  Que_UpdateFamille   := TIBOQuery.Create(nil);
  Que_UpdateSSFamille := TIBOQuery.Create(nil);
  Que_SearchTVAID     := TIBOQuery.Create(nil);
  Que_SearchTCTID     := TIBOQuery.Create(nil);
  Que_SearchSECID     := TIBOQuery.Create(nil);

  //Initialisation
  Que_CtrlGENIMPORT.DatabaseName      := Frm_Principale.Ginkoia.DatabaseName;
  Que_CtrlGENIMPORT.IB_Connection     := Frm_Principale.Ginkoia;
  Que_CtrlGENIMPORT.SQL.Text          := 'SELECT IMP_ID, IMP_GINKOIA FROM GENIMPORT ' +
                                         'WHERE IMP_REF =:IMP_REF AND IMP_NUM = 30 AND IMP_KTBID = :IMP_KTBID;';

  Que_Univers.DatabaseName            := Frm_Principale.Ginkoia.DatabaseName;
  Que_Univers.IB_Connection           := Frm_Principale.Ginkoia;
  Que_Univers.SQL.Text                := 'SELECT MAX(UNI_ID) AS UNI_ID FROM NKLUNIVERS ' +
                                         'JOIN K ON K_ID=UNI_ID AND K_ENABLED=1 ' +
                                         'WHERE UNI_ID<>0;';


  Que_InsertRayon.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertRayon.IB_Connection       := Frm_Principale.Ginkoia;
  Que_InsertRayon.SQL.Text            := 'INSERT INTO NKLRAYON (RAY_ID,RAY_UNIID,RAY_IDREF,RAY_NOM,RAY_ORDREAFF,RAY_VISIBLE,RAY_SECID) ' +
                                         'VALUES(:RAY_ID,:RAY_UNIID,:RAY_IDREF,:RAY_NOM,:RAY_ORDREAFF,:RAY_VISIBLE,:RAY_SECID);';


  Que_UpdateRayon.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_UpdateRayon.IB_Connection       := Frm_Principale.Ginkoia;
  Que_UpdateRayon.SQL.Text            := 'UPDATE NKLRAYON SET RAY_NOM =:RAYNOM WHERE RAY_ID=:RAYID;';


  Que_NewK.DatabaseName               := Frm_Principale.Ginkoia.DatabaseName;
  Que_NewK.IB_Connection              := Frm_Principale.Ginkoia;
  Que_NewK.SQL.Text                   := 'SELECT ID FROM PR_NEWK(:TABLE);';


  Que_InsertGENIMPORT.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertGENIMPORT.IB_Connection   := Frm_Principale.Ginkoia;
  Que_InsertGENIMPORT.SQL.Text        := 'INSERT INTO GENIMPORT (IMP_ID,IMP_GINKOIA,IMP_REF,IMP_KTBID,IMP_NUM,IMP_REFSTR) ' +
                                         'VALUES(:IMP_ID,:IMP_GINKOIA,:IMP_REF,:IMP_KTBID,:IMP_NUM,:IMP_REFSTR);';


  Que_UpdateGENIMPORT.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_UpdateGENIMPORT.IB_Connection   := Frm_Principale.Ginkoia;
  Que_UpdateGENIMPORT.SQL.Text        := 'UPDATE GENIMPORT SET IMP_REFSTR =:IMPREFSTR WHERE IMP_ID=:IMPID;';


  Que_SearchGENIMPORT.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_SearchGENIMPORT.IB_Connection   := Frm_Principale.Ginkoia;
  Que_SearchGENIMPORT.SQL.Text        := 'SELECT IMP_GINKOIA FROM GENIMPORT ' +
                                         'WHERE IMP_REF=:IMP_REF AND IMP_NUM=30 AND IMP_KTBID=:IMP_KTBID;';


  Que_InsertFamille.DatabaseName      := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertFamille.IB_Connection     := Frm_Principale.Ginkoia;
  Que_InsertFamille.SQL.Text          := 'INSERT INTO NKLFAMILLE (FAM_ID,FAM_RAYID,FAM_IDREF,FAM_NOM,FAM_ORDREAFF,FAM_VISIBLE,FAM_CTFID) ' +
                                         'VALUES(:FAM_ID,:FAM_RAYID,:FAM_IDREF,:FAM_NOM,:FAM_ORDREAFF,:FAM_VISIBLE,:FAM_CTFID);';


  Que_UpdateFamille.DatabaseName      := Frm_Principale.Ginkoia.DatabaseName;
  Que_UpdateFamille.IB_Connection     := Frm_Principale.Ginkoia;
  Que_UpdateFamille.SQL.Text          := 'UPDATE NKLFAMILLE SET FAM_NOM =:FAMNOM WHERE FAM_ID=:FAMID;';


  Que_InsertSSFamille.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertSSFamille.IB_Connection   := Frm_Principale.Ginkoia;
  Que_InsertSSFamille.SQL.Text        := 'INSERT INTO NKLSSFAMILLE (SSF_ID,SSF_FAMID,SSF_IDREF,SSF_NOM,SSF_ORDREAFF,SSF_VISIBLE,SSF_CATID,SSF_TVAID,SSF_TCTID) ' +
                                         'VALUES(:SSF_ID,:SSF_FAMID,:SSF_IDREF,:SSF_NOM,:SSF_ORDREAFF,:SSF_VISIBLE,:SSF_CATID,:SSF_TVAID,:SSF_TCTID);';


  Que_UpdateSSFamille.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_UpdateSSFamille.IB_Connection   := Frm_Principale.Ginkoia;
  Que_UpdateSSFamille.SQL.Text        := 'UPDATE NKLSSFAMILLE SET SSF_NOM =:SSFNOM WHERE SSF_ID=:SSFID;';


  Que_SearchTVAID.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_SearchTVAID.IB_Connection       := Frm_Principale.Ginkoia;
  Que_SearchTVAID.SQL.Text            := 'SELECT TVA_ID FROM ARTTVA ' +
                                         'JOIN K ON K_ID=TVA_ID AND K_ENABLED=1 ' +
                                         'WHERE TVA_TAUX=:TVA_TAUX;';


  Que_SearchTCTID.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_SearchTCTID.IB_Connection       := Frm_Principale.Ginkoia;
  Que_SearchTCTID.SQL.Text            := 'SELECT TCT_ID FROM ARTTYPECOMPTABLE ' +
                                         'JOIN K ON K_ID=TCT_ID AND K_ENABLED=1 ' +
                                         'WHERE TCT_NOM=:TCT_NOM;';


  Que_SearchSECID.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_SearchSECID.IB_Connection       := Frm_Principale.Ginkoia;
  Que_SearchSECID.SQL.Text            := 'SELECT SEC_ID FROM NKLSECTEUR ' +
                                         'JOIN K ON K_ID=SEC_ID AND K_ENABLED=1 ' +
                                         'WHERE SEC_NOM=''WEB''';


  //Création des ClientsDataSet pour l'intégration des informations source
  CDS_Rayon      := TClientDataSet.Create(nil);
  CDS_Famille    := TClientDataSet.Create(nil);
  CDS_SousFamille:= TClientDataSet.Create(nil);

  //Récupération des informations à intégrer
  LibInfo   := 'Changement des rayons en cours...';
  CSV_To_ClientDataSet(ChemSource+'rayon.csv',CDS_Rayon);
  LibInfo   := 'Changement des familles en cours...';
  CSV_To_ClientDataSet(ChemSource+'famille.csv',CDS_Famille);
  LibInfo   := 'Changement des sous familles en cours...';
  CSV_To_ClientDataSet(ChemSource+'sfamille.csv',CDS_SousFamille);

  //Traitement des rayons
  LibInfo  := 'Intégration des rayons en cours...';

  Que_Univers.Open;

  CurrentCDS  := CDS_Rayon;

  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  while (Not CurrentCDS.eof) and (not stopImport) do
  Begin
    //Ouverture de la transaction
    Transaction.StartTransaction;
    Try
      //Contrôle si le rayon est déjà référencé dans GENIMPORT
      Que_CtrlGENIMPORT.Close;
      Que_CtrlGENIMPORT.ParamByName('IMP_REF').AsInteger    := CurrentCDS.FieldByName('RAY_ID').asInteger;
      Que_CtrlGENIMPORT.ParamByName('IMP_KTBID').AsInteger  := -11111356;
      Que_CtrlGENIMPORT.Open;

      //Recherche du secteur WEB
      Que_SearchSECID.Close;
      Que_SearchSECID.Open;

      //Création du rayon
      if (Que_CtrlGENIMPORT.IsEmpty) AND (Not Que_SearchSECID.IsEmpty) then
      Begin
        //Insertion dans NKLRAYON
        Que_NEWK.Close;
        Que_NEWK.ParamByName('TABLE').asString  := 'NKLRAYON';
        Que_NEWK.ExecSQL;
        RAY_ID  := Que_NEWK.FieldByName('ID').asInteger;

        Que_InsertRayon.Close;
        Que_InsertRayon.ParamByName('RAY_ID').asInteger      := RAY_ID;
        Que_InsertRayon.ParamByName('RAY_UNIID').asInteger   := Que_Univers.FieldByName('UNI_ID').asInteger;
        Que_InsertRayon.ParamByName('RAY_IDREF').asInteger   := CurrentCDS.FieldByName('RAY_IDREF').AsInteger;
        Que_InsertRayon.ParamByName('RAY_NOM').AsString      := CurrentCDS.FieldByName('RAY_NOM').AsString;
        Que_InsertRayon.ParamByName('RAY_ORDREAFF').asfloat  := CurrentCDS.FieldByName('RAY_ORDREAFF').Asfloat;
        Que_InsertRayon.ParamByName('RAY_VISIBLE').asInteger := 1;
        Que_InsertRayon.ParamByName('RAY_SECID').asInteger   := Que_SearchSECID.FieldByName('SEC_ID').asInteger;
        Que_InsertRayon.ExecSQL;

        //Référencement dans GENIMPORT
        Que_NEWK.Close;
        Que_NEWK.ParamByName('TABLE').asString  := 'GENIMPORT';
        Que_NEWK.ExecSQL;

        Que_InsertGENIMPORT.Close;
        Que_InsertGENIMPORT.ParamByName('IMP_ID').asInteger      := Que_NEWK.FieldByName('ID').asInteger;
        Que_InsertGENIMPORT.ParamByName('IMP_GINKOIA').asInteger := RAY_ID;
        Que_InsertGENIMPORT.ParamByName('IMP_REF').asInteger     := CurrentCDS.FieldByName('RAY_ID').AsInteger;
        Que_InsertGENIMPORT.ParamByName('IMP_KTBID').AsInteger   := -11111356;
        Que_InsertGENIMPORT.ParamByName('IMP_NUM').asInteger     := 30;
        Que_InsertGENIMPORT.ParamByName('IMP_REFSTR').asString   := LeftStr(CurrentCDS.FieldByName('RAY_NOM').AsString,32);
        Que_InsertGENIMPORT.ExecSQL;
      End
      else begin
        Que_UpdateRayon.Close;
        Que_UpdateRayon.ParamByName('RAYID').AsInteger           := Que_CtrlGENIMPORT.FieldByName('IMP_GINKOIA').AsInteger;
        Que_UpdateRayon.ParamByName('RAYNOM').AsString           := CurrentCDS.FieldByName('RAY_NOM').AsString;
        Que_UpdateRayon.ExecSQL;

        Que_UpdateGENIMPORT.Close;
        Que_UpdateGENIMPORT.ParamByName('IMPID').AsInteger       := Que_CtrlGENIMPORT.FieldByName('IMP_ID').AsInteger;
        Que_UpdateGENIMPORT.ParamByName('IMPREFSTR').AsString    := LeftStr(CurrentCDS.FieldByName('RAY_NOM').AsString,32);
        Que_UpdateGENIMPORT.ExecSQL;
      end;

      //Validation du traitement de la ligne
      Transaction.Commit;

    Except on E:Exception do
      Begin
        Log(DateTimeToStr(Now) + ' -> RAY_ID: ' + CurrentCDS.FieldByName('RAY_ID').AsString + ' - ' + E.Message);
        Transaction.Rollback;
      End;
    End;

    //Changement de ligne
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des familles
  LibInfo  := 'Intégration des familles en cours...';

  CurrentCDS  := CDS_Famille;

  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  while (Not CurrentCDS.eof) and (not stopImport) do
  Begin
    //Ouverture de la transaction
    Transaction.StartTransaction;
    Try
      //Contrôle si la famille est déjà référencé dans GENIMPORT
      Que_CtrlGENIMPORT.Close;
      Que_CtrlGENIMPORT.ParamByName('IMP_REF').AsInteger    := CurrentCDS.FieldByName('FAM_ID').asInteger;
      Que_CtrlGENIMPORT.ParamByName('IMP_KTBID').AsInteger  := -11111355;
      Que_CtrlGENIMPORT.Open;

      //Création de la famille
      if Que_CtrlGENIMPORT.IsEmpty then
      Begin
        //Recherche du RAY_ID correspondant à IMP_REF de GENIMPORT
        Que_SearchGENIMPORT.Close;
        Que_SearchGENIMPORT.ParamByName('IMP_REF').asInteger    := CurrentCDS.FieldByName('FAM_RAYID').asInteger;
        Que_SearchGENIMPORT.ParamByName('IMP_KTBID').asInteger  := -11111356;
        Que_SearchGENIMPORT.Open;

        if Not Que_SearchGENIMPORT.IsEmpty then
        begin
          //Insertion dans NKLFAMILLE
          Que_NEWK.Close;
          Que_NEWK.ParamByName('TABLE').asString  := 'NKLFAMILLE';
          Que_NEWK.ExecSQL;
          FAM_ID  := Que_NEWK.FieldByName('ID').asInteger;

          Que_InsertFamille.Close;
          Que_InsertFamille.ParamByName('FAM_ID').asInteger      := FAM_ID;
          Que_InsertFamille.ParamByName('FAM_RAYID').asInteger   := Que_SearchGENIMPORT.FieldByName('IMP_GINKOIA').asInteger;
          Que_InsertFamille.ParamByName('FAM_IDREF').asInteger   := CurrentCDS.FieldByName('FAM_IDREF').AsInteger;
          Que_InsertFamille.ParamByName('FAM_NOM').AsString      := CurrentCDS.FieldByName('FAM_NOM').AsString;
          Que_InsertFamille.ParamByName('FAM_ORDREAFF').AsFloat  := CurrentCDS.FieldByName('FAM_ORDREAFF').AsFloat;
          Que_InsertFamille.ParamByName('FAM_VISIBLE').asInteger := 1;
          Que_InsertFamille.ParamByName('FAM_CTFID').asInteger   := 0;
          Que_InsertFamille.ExecSQL;

          //Référencement dans GENIMPORT
          Que_NEWK.Close;
          Que_NEWK.ParamByName('TABLE').asString  := 'GENIMPORT';
          Que_NEWK.ExecSQL;

          Que_InsertGENIMPORT.Close;
          Que_InsertGENIMPORT.ParamByName('IMP_ID').asInteger      := Que_NEWK.FieldByName('ID').asInteger;
          Que_InsertGENIMPORT.ParamByName('IMP_GINKOIA').asInteger := FAM_ID;
          Que_InsertGENIMPORT.ParamByName('IMP_REF').asInteger     := CurrentCDS.FieldByName('FAM_ID').AsInteger;
          Que_InsertGENIMPORT.ParamByName('IMP_KTBID').AsInteger   := -11111355;
          Que_InsertGENIMPORT.ParamByName('IMP_NUM').asInteger     := 30;
          Que_InsertGENIMPORT.ParamByName('IMP_REFSTR').asString   := LeftStr(CurrentCDS.FieldByName('FAM_NOM').AsString,32);
          Que_InsertGENIMPORT.ExecSQL;
        end;
      End
      else begin
        Que_UpdateFamille.Close;
        Que_UpdateFamille.ParamByName('FAMID').AsInteger           := Que_CtrlGENIMPORT.FieldByName('IMP_GINKOIA').AsInteger;
        Que_UpdateFamille.ParamByName('FAMNOM').AsString           := CurrentCDS.FieldByName('FAM_NOM').AsString;
        Que_UpdateFamille.ExecSQL;

        Que_UpdateGENIMPORT.Close;
        Que_UpdateGENIMPORT.ParamByName('IMPID').AsInteger         := Que_CtrlGENIMPORT.FieldByName('IMP_ID').AsInteger;
        Que_UpdateGENIMPORT.ParamByName('IMPREFSTR').AsString      := LeftStr(CurrentCDS.FieldByName('FAM_NOM').AsString,32);
        Que_UpdateGENIMPORT.ExecSQL;
      end;

      //Validation du traitement de la ligne
      Transaction.Commit;

    Except on E:Exception do
      Begin
        Log(DateTimeToStr(Now) + ' -> FAM_ID: ' + CurrentCDS.FieldByName('FAM_ID').AsString + ' - ' + E.Message);
        Transaction.Rollback;
      End;
    End;

    //Changement de ligne
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des sous familles
  LibInfo  := 'Intégration des sous familles en cours...';

  CurrentCDS  := CDS_SousFamille;

  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  while (Not CurrentCDS.eof) and (not stopImport) do
  Begin
    //Ouverture de la transaction
    Transaction.StartTransaction;
    Try
      //Contrôle si la sous famille est déjà référencé dans GENIMPORT
      Que_CtrlGENIMPORT.Close;
      Que_CtrlGENIMPORT.ParamByName('IMP_REF').AsInteger    := CurrentCDS.FieldByName('SSF_ID').asInteger;
      Que_CtrlGENIMPORT.ParamByName('IMP_KTBID').AsInteger  := -11111359;
      Que_CtrlGENIMPORT.Open;

      //Création de la sous famille
      if Que_CtrlGENIMPORT.IsEmpty then
      Begin
        //Recherche du FAM_ID correspondant à IMP_REF de GENIMPORT
        Que_SearchGENIMPORT.Close;
        Que_SearchGENIMPORT.ParamByName('IMP_REF').asInteger    := CurrentCDS.FieldByName('SSF_FAMID').asInteger;
        Que_SearchGENIMPORT.ParamByName('IMP_KTBID').asInteger  := -11111355;
        Que_SearchGENIMPORT.Open;

        //Recherche de TVA_ID
        Que_SearchTVAID.Close;
        Que_SearchTVAID.ParamByName('TVA_TAUX').AsFloat         := CurrentCDS.FieldByName('TVA_TAUX').AsFloat;
        Que_SearchTVAID.Open;

        //Recherche de TCT_ID
        Que_SearchTCTID.Close;
        Que_SearchTCTID.ParamByName('TCT_NOM').AsString         := CurrentCDS.FieldByName('TCT_NOM').AsString;
        Que_SearchTCTID.Open;

        if (Not Que_SearchGENIMPORT.IsEmpty) and (Not Que_SearchTVAID.IsEmpty) AND (Not Que_SearchTCTID.IsEmpty) then
        begin
          //Insertion dans NKLSSFAMILLE
          Que_NEWK.Close;
          Que_NEWK.ParamByName('TABLE').asString  := 'NKLSSFAMILLE';
          Que_NEWK.ExecSQL;
          SSF_ID  := Que_NEWK.FieldByName('ID').asInteger;

          Que_InsertSSFamille.Close;
          Que_InsertSSFamille.ParamByName('SSF_ID').asInteger      := SSF_ID;
          Que_InsertSSFamille.ParamByName('SSF_FAMID').asInteger   := Que_SearchGENIMPORT.FieldByName('IMP_GINKOIA').asInteger;
          Que_InsertSSFamille.ParamByName('SSF_IDREF').asInteger   := CurrentCDS.FieldByName('SSF_IDREF').AsInteger;
          Que_InsertSSFamille.ParamByName('SSF_NOM').AsString      := CurrentCDS.FieldByName('SSF_NOM').AsString;
          Que_InsertSSFamille.ParamByName('SSF_ORDREAFF').AsFloat  := CurrentCDS.FieldByName('SSF_ORDREAFF').AsFloat;
          Que_InsertSSFamille.ParamByName('SSF_VISIBLE').asInteger := 1;
          Que_InsertSSFamille.ParamByName('SSF_CATID').asInteger   := 0;
          Que_InsertSSFamille.ParamByName('SSF_TVAID').asInteger   := Que_SearchTVAID.FieldByName('TVA_ID').asInteger;
          Que_InsertSSFamille.ParamByName('SSF_TCTID').asInteger   := Que_SearchTCTID.FieldByName('TCT_ID').asInteger;
          Que_InsertSSFamille.ExecSQL;

          //Référencement dans GENIMPORT
          Que_NEWK.Close;
          Que_NEWK.ParamByName('TABLE').asString  := 'GENIMPORT';
          Que_NEWK.ExecSQL;

          Que_InsertGENIMPORT.Close;
          Que_InsertGENIMPORT.ParamByName('IMP_ID').asInteger      := Que_NEWK.FieldByName('ID').asInteger;
          Que_InsertGENIMPORT.ParamByName('IMP_GINKOIA').asInteger := SSF_ID;
          Que_InsertGENIMPORT.ParamByName('IMP_REF').asInteger     := CurrentCDS.FieldByName('SSF_ID').AsInteger;
          Que_InsertGENIMPORT.ParamByName('IMP_KTBID').AsInteger   := -11111359;
          Que_InsertGENIMPORT.ParamByName('IMP_NUM').asInteger     := 30;
          Que_InsertGENIMPORT.ParamByName('IMP_REFSTR').asString   := LeftStr(CurrentCDS.FieldByName('SSF_NOM').AsString,32);
          Que_InsertGENIMPORT.ExecSQL;
        end;
      End
      else begin
        Que_UpdateSSFamille.Close;
        Que_UpdateSSFamille.ParamByName('SSFID').AsInteger         := Que_CtrlGENIMPORT.FieldByName('IMP_GINKOIA').AsInteger;
        Que_UpdateSSFamille.ParamByName('SSFNOM').AsString         := CurrentCDS.FieldByName('SSF_NOM').AsString;
        Que_UpdateSSFamille.ExecSQL;

        Que_UpdateGENIMPORT.Close;
        Que_UpdateGENIMPORT.ParamByName('IMPID').AsInteger         := Que_CtrlGENIMPORT.FieldByName('IMP_ID').AsInteger;
        Que_UpdateGENIMPORT.ParamByName('IMPREFSTR').AsString      := LeftStr(CurrentCDS.FieldByName('SSF_NOM').AsString,32);
        Que_UpdateGENIMPORT.ExecSQL;
      end;

      //Validation du traitement de la ligne
      Transaction.Commit;

    Except on E:Exception do
      Begin
        Log(DateTimeToStr(Now) + ' -> FAM_ID: ' + CurrentCDS.FieldByName('FAM_ID').AsString + ' - ' + E.Message);
        Transaction.Rollback;
      End;
    End;

    //Changement de ligne
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Fermeture des accès BdD et des ClientDataSet
  CDS_Rayon.Close;
  CDS_Rayon.Free;
  CDS_Famille.Close;
  CDS_Famille.Free;
  CDS_SousFamille.Close;
  CDS_SousFamille.Free;

  Que_CtrlGENIMPORT.Close;
  Que_CtrlGENIMPORT.Free;
  Que_Univers.Close;
  Que_Univers.Free;
  Que_InsertRayon.Close;
  Que_InsertRayon.Free;
  Que_NEWK.Close;
  Que_NEWK.Free;
  Que_InsertGENIMPORT.Close;
  Que_InsertGENIMPORT.Free;
  Que_InsertFamille.Close;
  Que_InsertFamille.Free;
  Que_InsertSSFamille.Close;
  Que_InsertSSFamille.Free;
  Que_SearchGENIMPORT.Close;
  Que_SearchGENIMPORT.Free;
  
  //Message d'information
  if stopImport then
    LibInfo := 'Traitement interrompu'
  else
    LibInfo := 'Traitement terminé';

  //Signale que le traitement n'est plus en cours pour l'affichage
  NbLigne := -1;

End;

Procedure Log(Texte:String);
Var
  LogFile       : TextFile;   //Varialbe d'accès au fichier
  Chemin        : String;     //Chemin du fichier de log
  FileLogName   : String;     //Nom du fichier de log
Begin
  Chemin      := IncludeTrailingPathDelimiter(ExtractFilePath(application.exename))+'Log\';
  FileLogName := Chemin+'Log_'+IntToStr(yearof(now))+'-'+IntToStr(monthof(now))+'-'+IntToStr(dayof(now))+'.log';
  ForceDirectories(Chemin);
  AssignFile(LogFile,FileLogName);
  if Not FileExists(FileLogName) then
    ReWrite(LogFile)
  else
    Append(LogFile);
  try
    Writeln(LogFile,Texte);
  finally
    CloseFile(LogFile);
  end;

End;

Procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin
  //Création des variables
  Donnees   := TStringList.Create;
  InfoLigne := TStringList.Create;

  //Chargement du csv
  Donnees.LoadFromFile(FichCsv);

  //Initialisation de variable
  NbLigne   := Donnees.Count;
  Compteur  := 0;

  //Traitement de la ligne d'entête
  InfoLigne.Clear;
  InfoLigne.Delimiter := ';';
  InfoLigne.DelimitedText := Donnees.Strings[0];
  for I := 0 to InfoLigne.Count - 1 do
    Begin
      CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
    End;
  CDS.CreateDataSet;
  
  //Traitement des lignes de données
  CDS.Open;

  for I := 1 to Donnees.Count - 1 do
    begin
      InfoLigne.Clear;
      InfoLigne.Delimiter := ';';
      InfoLigne.QuoteChar := '''';
      Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
      Chaine  := ReplaceStr(Chaine,';',''';''');
      Chaine  := Chaine + '''';

      InfoLigne.DelimitedText := Chaine;
      CDS.Insert;
      for J := 0 to CDS.FieldCount - 1 do
        Begin
          CDS.Fields[J].AsString  := Trim(InfoLigne.Strings[J]);
        End;
      CDS.Post;
      Inc(Compteur);
      if StopImport then break;
    end;
  CDS.Close;

  //Suppression des variables en mémoire
  Donnees.free;
  InfoLigne.Free;
End;

Procedure Add_csv(Fichier,Texte:String);
//Ajoute une ligne à un fichier CSV
Var
  FileCsv       : TextFile;   //Variable d'accès au fichier
  ChemCsv       : String;     //Chemin du fichier csv
  FileCsvName   : String;     //Nom du fichier de csv
Begin
  ChemCsv       := IncludeTrailingPathDelimiter(ExtractFilePath(Fichier));
  FileCsvName   := Fichier;
  ForceDirectories(ChemCsv);
  AssignFile(FileCsv,FileCsvName);
  if Not FileExists(FileCsvName) then
    ReWrite(FileCsv)
  else
    Append(FileCsv);
  try
    Writeln(FileCsv,Texte);
  finally
    CloseFile(FileCsv);
  end;
End;

end.
