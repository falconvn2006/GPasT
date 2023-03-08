unit UnitThread;

interface
uses Windows, Classes, SysUtils,IB_Components,IBODataset,ADODB,Forms,DateUtils;

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

Var
  Compteur  : Integer=0;        //Compte le nombre de matériel traité
  NbMat     : Integer;          //Nombre de matériel à traité
  Start     : Boolean=False;    //Variable de démarrage du traitement
  Stop      : Boolean=False;    //Interrompt le traitement 
  LibInfo   : String;           //Message d'information pour l'utilisateur
  MAGID     : Integer;          //ID Magasin à traiter
implementation

uses UnitPrincipale;

constructor TTranspoThread.Create(CreateSuspended:boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:=false;
  Priority:=tpHigher;
end;

destructor TTranspoThread.Destroy;
begin
  inherited;
end;

procedure TTranspoThread.CentralControl;
begin
  if Start then
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
var
  CLTID         : Integer;            //ID du client en cours
  Transaction   : TIB_Transaction;    //Transaction
  Que_Client    : TIBOQuery;          //Query des données clients
  Que_Source    : TADOQuery;          //Query des données source
  Que_DPV       : TIBOQuery;          //Query des données de DPV
  Que_NEWK      : TIBOQuery;          //Query des K_ID
  Que_CEENEWNUM : TIBOQuery;          //Query des chono de contrat
  Que_MDVNEWNUM : TIBOQuery;          //Query des chono de matériel
  Que_GENIMPORT : TIBOQuery;          //Query d'écriture des matériel importé
  Que_ParamDPV  : TIBOQuery;          //Query des paramètres de DPV
  CEEID         : Integer;            //Stocke ID du contrat
  CEECHRONO     : String;             //Stocke le chrono du contrat
  MDVID         : Integer;            //Stocke ID du matériel
  MDVCHRONO     : String;             //Stocke le chrono du matériel
  SDVID         : Integer;            //ID du statut par défaut
  CELID         : Integer;            //ID de ligne de contrat
  MDVPVDIMIUE   : Integer;            //Indique si le prix du matériel à déjà était réajusté
Begin
  //Verrouille le traitement pour qu'il ne se relance pas
  Start := False;

  //Message d'information
  LibInfo := 'Traitement en cours...';

  //Création de la transaction
  Transaction               := TIB_Transaction.Create(nil);
  Transaction.IB_Connection := Frm_Principale.Ginkoia;
  Transaction.AutoCommit    := False;
  Frm_Principale.Ginkoia.DefaultTransaction := Transaction;
  Transaction.StartTransaction;

  //Récupération des informations à intégrer
  Que_Source  := TADOQuery.Create(nil);
  Que_Source.ConnectionString := Frm_Principale.ADOConnection.ConnectionString;
  Que_Source.SQL.Text := 'Select Déposants.[Dép-Ref] ' +
                               ',Déposants.[Dép-Nom] ' +
                               ',Déposants.[Dép-Prénom] ' +
                               ',Déposants.[Dép-Rue] ' +
                               ',Déposants.[Dép-Codpost] ' +
                               ',Déposants.[Dép-Ville] ' +
                               ',Déposants.[Dép-Tél] ' +
                               ',Déposants.[Dép-Fax] ' +
                               ',Articles.[A-Clé] ' +
                               ',Articles.[A_Dépot] ' +
                               ',Articles.[A-Libre] ' +
                               ',Articles.[A-Type] ' +
                               ',Articles.[A-Marque] ' +
                               ',Articles.[A-Modèle] ' +
                               ',Articles.[A-Taille] ' +
                               ',Articles.[A_Pv_Euro] ' +
                               ',Articles.[A_Pdép_Euro] ' +
                         'from Articles ' +
                         'inner join Déposants on Articles.[A-Dép-Ref] = Déposants.[Dép-Ref] ' +
                         'where Articles.[A-Vendu] = False ' +
                         '  and Articles.[A-Dép-Ref] <> 1 ' +
                         'order by Articles.[A-Clé];';
  Que_Source.Open;
  Que_Source.First;

  //Initialisation de variable
  Compteur      := 0;
  NbMat         := Que_Source.RecordCount;
  Que_Client    := TIBOQuery.Create(nil);
  Que_DPV       := TIBOQuery.Create(nil);
  Que_NEWK      := TIBOQuery.Create(nil);
  Que_CEENEWNUM := TIBOQuery.Create(nil);
  Que_MDVNEWNUM := TIBOQuery.Create(nil);
  Que_GENIMPORT := TIBOQuery.Create(nil);
  Que_ParamDPV  := TIBOQuery.Create(nil);

  //Configuration des query
  Que_Client.Close;
  Que_Client.DatabaseName        := Frm_Principale.Ginkoia.DatabaseName;
  Que_Client.IB_Connection       := Frm_Principale.Ginkoia;
  que_client.CachedUpdates := false;
  Que_DPV.Close;
  Que_DPV.DatabaseName           := Frm_Principale.Ginkoia.DatabaseName;
  Que_DPV.IB_Connection          := Frm_Principale.Ginkoia;
  Que_NEWK.Close;
  Que_NEWK.DatabaseName          := Frm_Principale.Ginkoia.DatabaseName;
  Que_NEWK.IB_Connection         := Frm_Principale.Ginkoia;
  Que_NEWK.SQL.Text              := 'SELECT ID FROM PR_NEWK(:TABLENAME);';
  Que_CEENEWNUM.Close;
  Que_CEENEWNUM.DatabaseName     := Frm_Principale.Ginkoia.DatabaseName;
  Que_CEENEWNUM.IB_Connection    := Frm_Principale.Ginkoia;
  Que_CEENEWNUM.SQL.Text         := 'SELECT NEWNUM FROM CEE_NEWNUM;';
  Que_MDVNEWNUM.Close;
  Que_MDVNEWNUM.DatabaseName     := Frm_Principale.Ginkoia.DatabaseName;
  Que_MDVNEWNUM.IB_Connection    := Frm_Principale.Ginkoia;
  Que_MDVNEWNUM.SQL.Text         := 'SELECT NEWNUM FROM MDV_NEWNUM;';
  Que_GENIMPORT.Close;
  Que_GENIMPORT.DatabaseName     := Frm_Principale.Ginkoia.DatabaseName;
  Que_GENIMPORT.IB_Connection    := Frm_Principale.Ginkoia;
  Que_ParamDPV.Close;
  Que_ParamDPV.DatabaseName      := Frm_Principale.Ginkoia.DatabaseName;
  Que_ParamDPV.IB_Connection     := Frm_Principale.Ginkoia;

  //Traitement des données
  Try
    while (Not Que_Source.Eof) and (Not Stop) do
      Begin
        CLTID := 0;
        //Contrôle si le client à déjà était importé
        Que_Client.Close;
        Que_Client.SQL.Text := 'Select IMP_GINKOIA From GENIMPORT WHERE IMP_NUM=1002 AND IMP_REF='+Que_Source.fieldbyname('Dép-Ref').asString;
        Que_Client.Open;
        if (Not Que_Client.Eof) then
          if Que_Client.FieldByName('IMP_GINKOIA').AsInteger>0 then
            CLTID := Que_Client.FieldByName('IMP_GINKOIA').AsInteger;

        //Traitement du client s'il n'est pas déjà importé
        if (CLTID=0) then
          Begin
            Que_Client.Close;
            Que_Client.SQL.Text := 'Select CLT_ID from PR_CRER_CLIENT('+
                                   '1002,' +
                                   Que_Source.fieldbyname('Dép-Ref').asString +',' +
                                   '0,' +
                                   QuotedStr(UpperCase(Que_Source.fieldbyname('Dép-Nom').asString))+',' +
                                   QuotedStr(UpperCase(Que_Source.fieldbyname('Dép-Prénom').asString))+',' +
                                   QuotedStr(UpperCase(Que_Source.fieldbyname('Dép-Rue').asString))+',' +
                                   QuotedStr(Que_Source.fieldbyname('Dép-Codpost').asString)+',' +
                                   QuotedStr(UpperCase(Que_Source.fieldbyname('Dép-Ville').asString))+',' +
                                   '94115,' +
                                   QuotedStr('')+',' +
                                   QuotedStr(Que_Source.fieldbyname('Dép-Tél').asString)+',' +
                                   IntTostr(MAGID)+',' +
                                   '1)';

            Que_Client.Open;
            CLTID := Que_Client.FieldByName('CLT_ID').asInteger;
            Que_Client.Close;
          End;

        //Contrôle si le matériel n'a pas déjà était importé
        Que_GENIMPORT.Close;
        Que_GENIMPORT.SQL.text  := 'Select IMP_GINKOIA From GENIMPORT WHERE IMP_NUM=1003 AND IMP_REF='+Que_Source.fieldbyname('A-Clé').asString;
        Que_GENIMPORT.Open;
        if (Que_GENIMPORT.Eof) then
          if Que_GENIMPORT.FieldByName('IMP_GINKOIA').AsInteger<=0 then
            Begin
              //Recup de l'ID contrat
              Que_NEWK.Close;
              Que_NEWK.ParamByName('TABLENAME').asString  := 'DPVCONTRATE';
              Que_NEWK.Open;
              CEEID := Que_NEWK.FieldByName('ID').asInteger;
              Que_NEWK.Close;

              //Recup du Chrono contrat
              Que_CEENEWNUM.Close;
              Que_CEENEWNUM.Open;
              CEECHRONO := Que_CEENEWNUM.FieldByName('NEWNUM').asString;
              Que_CEENEWNUM.Close;

              //Création du contrat
              Que_DPV.Close;
              Que_DPV.SQL.Text  := 'INSERT INTO DPVCONTRATE (CEE_ID' +
                                                           ',CEE_CHRONO' +
                                                           ',CEE_CLTID' +
                                                           ',CEE_DATEDEPOT' +
                                                           ',CEE_COMMENT' +
                                                           ',CEE_ARCHIVE' +
                                                           ',CEE_SMS' +
                                                           ',CEE_MAGID' +
                                                           ',CEE_MAIL)' +

                                                    'VALUES ('+IntToStr(CEEID)+
                                                           ','+QuotedStr(CEECHRONO)+
                                                           ','+IntToStr(CLTID)+
                                                           ',:DATEDEPOT'+
                                                           ','+QuotedStr(Que_Source.fieldbyname('A-Libre').asString)+
                                                           ',0'+
                                                           ',0'+
                                                           ','+IntToStr(MAGID)+
                                                           ',0);';

              Que_DPV.ParamByName('DATEDEPOT').AsDateTime := Que_Source.fieldbyname('A_Dépot').AsDateTime;
              Que_DPV.ExecSQL;

              //Recup de l'ID materiel
              Que_NEWK.Close;
              Que_NEWK.ParamByName('TABLENAME').asString  := 'DPVMATERIEL';
              Que_NEWK.Open;
              MDVID := Que_NEWK.FieldByName('ID').asInteger;
              Que_NEWK.Close;

              //Recup du Chrono materiel
              Que_MDVNEWNUM.Close;
              Que_MDVNEWNUM.Open;
              MDVCHRONO := Que_MDVNEWNUM.FieldByName('NEWNUM').asString;
              Que_MDVNEWNUM.Close;

              //Recup du stat par defaut
              Que_ParamDPV.Close;
              Que_ParamDPV.SQL.text := 'SELECT DVP_CREASDVID FROM DPVPARAM WHERE DVP_MAGID='+IntToStr(MAGID);
              Que_ParamDPV.Open;
              SDVID := Que_ParamDPV.FieldByName('DVP_CREASDVID').asInteger;
              Que_ParamDPV.Close;

              //Détermine si le prix à déjà était réajusté
              if (IncMonth(Que_Source.fieldbyname('A_Dépot').AsDateTime,2)<now) then
                MDVPVDIMIUE := 1
              else
                MDVPVDIMIUE := 0;

              //Création du matériel
              Que_DPV.Close;
              Que_DPV.SQL.Text  := 'INSERT INTO DPVMATERIEL (MDV_ID'+
                                                           ',MDV_CHRONO'+
                                                           ',MDV_NOM'+
                                                           ',MDV_DESCRIPTION'+
                                                           ',MDV_MRKID'+
                                                           ',MDV_SSFID'+
                                                           ',MDV_ICLID1'+
                                                           ',MDV_ICLID2'+
                                                           ',MDV_ICLID3'+
                                                           ',MDV_ICLID4'+
                                                           ',MDV_ICLID5'+
                                                           ',MDV_TAILLE'+
                                                           ',MDV_COUL'+
                                                           ',MDV_PXO'+
                                                           ',MDV_PXC'+
                                                           ',MDV_PXD'+
                                                           ',MDV_SDVID'+
                                                           ',MDV_DATEVENTE'+
                                                           ',MDV_ARCHIVE'+
                                                           ',MDV_PVDIMINUE'+
                                                           ',MDV_TKLID'+
                                                           ',MDV_MAGID)'+

                                                   'VALUES ('+IntToStr(MDVID)+
                                                           ','+QuotedStr(MDVCHRONO)+
                                                           ','+QuotedStr(Que_Source.fieldbyname('A-Type').asString+' \ '+Que_Source.fieldbyname('A-Marque').asString+' \ '+Que_Source.fieldbyname('A-Modèle').asString)+
                                                           ','+QuotedStr(Que_Source.fieldbyname('A-Libre').asString)+
                                                           ',0'+
                                                           ',0'+
                                                           ',0'+
                                                           ',0'+
                                                           ',0'+
                                                           ',0'+
                                                           ',0'+
                                                           ','+QuotedStr(Que_Source.fieldbyname('A-Taille').asString)+
                                                           ','+QuotedStr('')+
                                                           ','+FloatToStr(Que_Source.fieldbyname('A_Pv_Euro').AsFloat)+
                                                           ','+FloatToStr(Que_Source.fieldbyname('A_Pv_Euro').AsFloat)+
                                                           ','+FloatToStr(Que_Source.fieldbyname('A_Pdép_Euro').AsFloat)+
                                                           ','+IntToStr(SDVID)+
                                                           ',null'+
                                                           ',0'+
                                                           ','+IntToStr(MDVPVDIMIUE)+
                                                           ',0'+
                                                           ','+IntToStr(MAGID)+');';

              Que_DPV.ExecSQL;

              //Recup de l'ID de la ligne de contrat
              Que_NEWK.Close;
              Que_NEWK.ParamByName('TABLENAME').asString  := 'DPVCONTRATL';
              Que_NEWK.Open;
              CELID := Que_NEWK.FieldByName('ID').asInteger;
              Que_NEWK.Close;

              //Création de la ligne de contrat
              Que_DPV.Close;
              Que_DPV.SQL.Text  := 'INSERT INTO DPVCONTRATL (CEL_ID'+
                                                           ',CEL_CEEID'+
                                                           ',CEL_MDVID)'+

                                                   'VALUES ('+IntToStr(CELID)+
                                                           ','+IntToStr(CEEID)+
                                                           ','+IntToStr(MDVID)+');';
              Que_DPV.ExecSQL;

              //Enregistre l'import dans GENIMPORT
              Que_GENIMPORT.Close;
              Que_GENIMPORT.SQL.Text  := 'SELECT ID FROM SM_MAJIMPORT('+Que_Source.fieldbyname('A-Clé').asString+
                                                                    ',-11111602'+
                                                                    ',1003'+
                                                                    ',1'+
                                                                    ',:DATEIMPORT'+
                                                                    ',:DATEIMPORT);';

              Que_GENIMPORT.ParamByName('DATEIMPORT').AsDateTime  := now;
              Que_GENIMPORT.ExecSQL;
            End;


        //Valide le traitemnent et passe au suivant
        Transaction.Commit;
        Inc(Compteur);
        Que_Source.Next;
      End;
  Except
    Transaction.Rollback;
  End;

  //Nettoyage de GENIMPORT, supprimer les lignes IMP_NUM=1002 et 1003 dans GENIMPORT et Les K Correspondant
  //J'utile Que_NEWK pour la nettoyage de la table K
  Transaction.StartTransaction;
  Que_GENIMPORT.Close;
  Que_GENIMPORT.SQL.Text    := 'Select IMP_ID FROM GENIMPORT WHERE IMP_NUM in (1002,1003)';
  Que_GENIMPORT.Open;
  Que_GENIMPORT.First;
  while Not Que_GENIMPORT.eof do
    Begin
      Que_NEWK.Close;
      Que_NEWK.SQL.Text := 'DELETE FROM K WHERE K_ID = :IMPID';
      Que_NEWK.ParamByName('IMPID').asInteger := Que_GENIMPORT.FieldByName('IMP_ID').asInteger;
      Que_NEWK.ExecSQL;
      Que_NEWK.Close;
      Que_NEWK.SQL.Text := 'DELETE FROM GENIMPORT WHERE IMP_ID = :IMPID';
      Que_NEWK.ParamByName('IMPID').asInteger := Que_GENIMPORT.FieldByName('IMP_ID').asInteger;
      Que_NEWK.ExecSQL;
      Que_GENIMPORT.Next;
    End;
  Transaction.Commit;

  //Fermeture des accès BdD
  Que_NEWK.Close;
  Que_NEWK.free;
  Que_CEENEWNUM.Close;
  Que_CEENEWNUM.free;
  Que_MDVNEWNUM.Close;
  Que_MDVNEWNUM.free;
  Que_GENIMPORT.Close;
  Que_GENIMPORT.free;
  Que_Client.Close;
  Que_Client.free;
  Que_DPV.Close;
  Que_DPV.free;
  Que_Source.Close;
  Que_Source.free;
  Transaction.free;

  //Message d'information
  if stop then
    LibInfo := 'Traitement interrompu'
  else
    LibInfo := 'Traitement terminé';

  //Signale que le traitement n'est plus en cours pour l'affichage
  NbMat := -1;

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

end.
