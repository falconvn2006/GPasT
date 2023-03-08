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
  Start        : Boolean=False;      //Variable de démarrage du traitement
  Stop         : Boolean=False;      //Interrompt le traitement
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
Var
  I,J                 : Integer;         //Variable de boucle
  Transaction         : TIB_Transaction; //Transaction
  CDS_CptClient       : TclientDataSet;  //Liste des lignes de comptes clients à intégrer
  CurrentFile         : String;          //Nom du fichier à traiter, à remplacer en début de traitement, facilité les copier/Coller
  CurrentCDS          : TClientDataSet;  //Permets de passer la CDS Principale dans une variable, facilité les copier/Coller
  Que_CtrlCLTCOMPTE   : TIBOQuery;       //Query de contrôle de l'existance de la ligne dans CLTCOMPTE
  Que_CtrlK           : TIBOQuery;       //Query de contrôle de l'existance de la ligne dans K
  Que_DeleteCLTCOMPTE : TIBOQuery;       //Query de suppreesion de la ligne dans CLTCOMPTE
  Que_DeleteK         : TIBOQuery;       //Query de suppreesion de la ligne dans K
  Que_InsertCLTCOMPTE : TIBOQuery;       //Query d'insertion de la ligne dans CLTCOMPTE
  Que_InsertK         : TIBOQuery;       //Query d'insertion de la ligne dans K
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

  //Création des query d'intégration
  Que_CtrlCLTCOMPTE   := TIBOQuery.Create(nil);
  Que_CtrlK           := TIBOQuery.Create(nil);
  Que_DeleteCLTCOMPTE := TIBOQuery.Create(nil);
  Que_DeleteK         := TIBOQuery.Create(nil);
  Que_InsertCLTCOMPTE := TIBOQuery.Create(nil);
  Que_InsertK         := TIBOQuery.Create(nil);

  //Initialisation
  Que_CtrlCLTCOMPTE.DatabaseName      := Frm_Principale.Ginkoia.DatabaseName;
  Que_CtrlCLTCOMPTE.IB_Connection     := Frm_Principale.Ginkoia;
  Que_CtrlCLTCOMPTE.SQL.Text          := 'select CTE_ID from CLTCOMPTE WHERE CTE_ID=:ID;';

  Que_CtrlK.DatabaseName              := Frm_Principale.Ginkoia.DatabaseName;
  Que_CtrlK.IB_Connection             := Frm_Principale.Ginkoia;
  Que_CtrlK.SQL.Text                  := 'select K_ID from K WHERE K_ID=:ID;';

  Que_DeleteCLTCOMPTE.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_DeleteCLTCOMPTE.IB_Connection   := Frm_Principale.Ginkoia;
  Que_DeleteCLTCOMPTE.SQL.Text        := 'Delete from CLTCOMPTE WHERE CTE_ID=:ID;';

  Que_DeleteK.DatabaseName            := Frm_Principale.Ginkoia.DatabaseName;
  Que_DeleteK.IB_Connection           := Frm_Principale.Ginkoia;
  Que_DeleteK.SQL.Text                := 'Delete from K WHERE K_ID=:ID;';

  Que_InsertCLTCOMPTE.DatabaseName    := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertCLTCOMPTE.IB_Connection   := Frm_Principale.Ginkoia;
  Que_InsertCLTCOMPTE.SQL.Text := 'Insert into CLTCOMPTE (CTE_ID'           +
                                                        ',CTE_CLTID'        +
                                                        ',CTE_MAGID'        +
                                                        ',CTE_LIBELLE'      +
                                                        ',CTE_DATE'         +
                                                        ',CTE_DEBIT'        +
                                                        ',CTE_CREDIT'       +
                                                        ',CTE_REGLER'       +
                                                        ',CTE_TKEID'        +
                                                        ',CTE_TYP'          +
                                                        ',CTE_ORIGINE'      +
                                                        ',CTE_FCEID'        +
                                                        ',CTE_RVSID'        +
                                                        ',CTE_LETTRAGE'     +
                                                        ',CTE_LETTRAGENUM'  +
                                                        ',CTE_CTEID'        +
                                                        ',CTE_DVEID'        +
                                                        ',CTE_BLLID'        +
                                                        ',CTE_IDPIECE'      +
                                                        ',CTE_KTBPIECE)'    +

                                                 'VALUES (:CTEID'           +
                                                        ',:CTECLTID'        +
                                                        ',:CTEMAGID'        +
                                                        ',:CTELIBELLE'      +
                                                        ',:CTEDATE'         +
                                                        ',:CTEDEBIT'        +
                                                        ',:CTECREDIT'       +
                                                        ',:CTEREGLER'       +
                                                        ',:CTETKEID'        +
                                                        ',:CTETYP'          +
                                                        ',:CTEORIGINE'      +
                                                        ',:CTEFCEID'        +
                                                        ',:CTERVSID'        +
                                                        ',:CTELETTRAGE'     +
                                                        ',:CTELETTRAGENUM'  +
                                                        ',:CTECTEID'        +
                                                        ',:CTEDVEID'        +
                                                        ',:CTEBLLID'        +
                                                        ',:CTEIDPIECE'      +
                                                        ',:CTEKTBPIECE);';

  Que_InsertK.DatabaseName     := Frm_Principale.Ginkoia.DatabaseName;
  Que_InsertK.IB_Connection    := Frm_Principale.Ginkoia;
  Que_InsertK.SQL.Text         :=         'Insert into K (K_ID'             +
                                                        ',KRH_ID'           +
                                                        ',KTB_ID'           +
                                                        ',K_VERSION'        +
                                                        ',K_ENABLED'        +
                                                        ',KSE_OWNER_ID'     +
                                                        ',KSE_INSERT_ID'    +
                                                        ',K_INSERTED'       +
                                                        ',KSE_DELETE_ID'    +
                                                        ',K_DELETED'        +
                                                        ',KSE_UPDATE_ID'    +
                                                        ',K_UPDATED'        +
                                                        ',KSE_LOCK_ID'      +
                                                        ',KMA_LOCK_ID)'     +

                                                'VALUES (:KID'             +
                                                       ',:KRHID'           +
                                                       ',:KTBID'           +
                                                       ',:KVERSION'        +
                                                       ',:KENABLED'        +
                                                       ',:KSEOWNER_ID'     +
                                                       ',:KSEINSERT_ID'    +
                                                       ',:KINSERTED'       +
                                                       ',:KSEDELETE_ID'    +
                                                       ',:KDELETED'        +
                                                       ',:KSEUPDATE_ID'    +
                                                       ',:KUPDATED'        +
                                                       ',:KSELOCK_ID'      +
                                                       ',:KMALOCK_ID);';

  //Création des ClientsDataSet pour l'intégration des informations source
  CDS_CptClient  := TClientDataSet.Create(nil);

  //Récupération des informations à intégrer
  LibInfo   := 'Changement des informations à intégrer en cours...';
  CSV_To_ClientDataSet(ChemSource,CDS_CptClient);

  {//Test d'affichage
  CurrentCDS  := CDS_CptClient;
  CurrentCDS.Open;
  CurrentCDS.First;
  Frm_Principale.StringGrid1.RowCount := CurrentCDS.RecordCount+1;
  Frm_Principale.StringGrid1.ColCount := CurrentCDS.FieldCount;
  J := 1;
  for I := 0 to CurrentCDS.FieldCount - 1 do
    Frm_Principale.StringGrid1.Cells[I,0] := CurrentCDS.FieldDefs[I].Name;
  while Not CurrentCDS.eof do
  Begin
    for I := 0 to CurrentCDS.FieldCount - 1 do
    Begin
      Frm_Principale.StringGrid1.Cells[I,J] := CurrentCDS.Fields[I].asString;
    End;
    CurrentCDS.Next;
    Inc(J);
  End;
  CurrentCDS.Close;}


  //Traitement des comptes clients
  LibInfo  := 'Intégration des lignes en cours...';

  CurrentCDS  := CDS_CptClient;

  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    //Ouverture de la transaction
    Transaction.StartTransaction;
    Try
      //Contrôle de l'existance de la ligne dans CLTCOMPTE et suppression si elle existe
      Que_CtrlCLTCOMPTE.Close;
      Que_CtrlCLTCOMPTE.ParamByName('ID').AsInteger := CurrentCDS.FieldByName('CTE_ID').asInteger;
      Que_CtrlCLTCOMPTE.Open;
      if Que_CtrlCLTCOMPTE.FieldByName('CTE_ID').AsInteger>0 then
      Begin
        Que_DeleteCLTCOMPTE.Close;
        Que_DeleteCLTCOMPTE.ParamByName('ID').AsInteger := CurrentCDS.FieldByName('CTE_ID').asInteger;
        Que_DeleteCLTCOMPTE.ExecSQL;
      End;
      Que_CtrlCLTCOMPTE.Close;

      //Contrôle de l'existance de la ligne dans K et suppression si elle existe
      Que_CtrlK.Close;
      Que_CtrlK.ParamByName('ID').AsInteger := CurrentCDS.FieldByName('K_ID').asInteger;
      Que_CtrlK.Open;
      if Que_CtrlK.FieldByName('K_ID').AsInteger>0 then
      Begin
        Que_DeleteK.Close;
        Que_DeleteK.ParamByName('ID').AsInteger := CurrentCDS.FieldByName('K_ID').asInteger;
        Que_DeleteK.ExecSQL;
      End;
      Que_CtrlK.Close;

      //Insertion de la ligne dans CLTCOMPTE
      Que_InsertCLTCOMPTE.Close;
      Que_InsertCLTCOMPTE.ParamByName('CTEID').AsInteger         := CurrentCDS.FieldByName('CTE_ID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTECLTID').AsInteger      := CurrentCDS.FieldByName('CTE_CLTID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEMAGID').AsInteger      := CurrentCDS.FieldByName('CTE_MAGID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTELIBELLE').AsString     := CurrentCDS.FieldByName('CTE_LIBELLE').AsString;
      Que_InsertCLTCOMPTE.ParamByName('CTEDATE').AsDateTime      := CurrentCDS.FieldByName('CTE_DATE').AsDateTime;
      Que_InsertCLTCOMPTE.ParamByName('CTEDEBIT').AsFloat        := StrToFloat(StringReplace(CurrentCDS.FieldByName('CTE_DEBIT').AsString,',','.',[rfReplaceAll]));
      Que_InsertCLTCOMPTE.ParamByName('CTECREDIT').AsFloat       := StrToFloat(StringReplace(CurrentCDS.FieldByName('CTE_CREDIT').AsString,',','.',[rfReplaceAll]));
      Que_InsertCLTCOMPTE.ParamByName('CTEREGLER').AsDateTime    := CurrentCDS.FieldByName('CTE_REGLER').AsDateTime;
      Que_InsertCLTCOMPTE.ParamByName('CTETKEID').AsInteger      := CurrentCDS.FieldByName('CTE_TKEID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTETYP').AsInteger        := CurrentCDS.FieldByName('CTE_TYP').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEORIGINE').AsInteger    := CurrentCDS.FieldByName('CTE_ORIGINE').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEFCEID').AsInteger      := CurrentCDS.FieldByName('CTE_FCEID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTERVSID').AsInteger      := CurrentCDS.FieldByName('CTE_RVSID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTELETTRAGE').AsInteger   := CurrentCDS.FieldByName('CTE_LETTRAGE').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTELETTRAGENUM').AsString := CurrentCDS.FieldByName('CTE_LETTRAGENUM').AsString;
      Que_InsertCLTCOMPTE.ParamByName('CTECTEID').AsInteger      := CurrentCDS.FieldByName('CTE_CTEID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEDVEID').AsInteger      := CurrentCDS.FieldByName('CTE_DVEID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEBLLID').AsInteger      := CurrentCDS.FieldByName('CTE_BLLID').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEIDPIECE').AsInteger    := CurrentCDS.FieldByName('CTE_IDPIECE').asInteger;
      Que_InsertCLTCOMPTE.ParamByName('CTEKTBPIECE').AsInteger   := CurrentCDS.FieldByName('CTE_KTBPIECE').asInteger;
      Que_InsertCLTCOMPTE.ExecSQL;

      //Insertion de la ligne dans K
      Que_InsertK.Close;
      Que_InsertK.ParamByName('KID').AsInteger          := CurrentCDS.FieldByName('K_ID').asInteger;
      Que_InsertK.ParamByName('KRHID').AsInteger        := CurrentCDS.FieldByName('KRH_ID').asInteger;
      Que_InsertK.ParamByName('KTBID').AsInteger        := CurrentCDS.FieldByName('KTB_ID').asInteger;
      Que_InsertK.ParamByName('KVERSION').AsInteger     := CurrentCDS.FieldByName('K_VERSION').asInteger;
      Que_InsertK.ParamByName('KENABLED').AsInteger     := CurrentCDS.FieldByName('K_ENABLED').asInteger;
      Que_InsertK.ParamByName('KSEOWNER_ID').AsInteger  := CurrentCDS.FieldByName('KSE_OWNER_ID').asInteger;
      Que_InsertK.ParamByName('KSEINSERT_ID').AsInteger := CurrentCDS.FieldByName('KSE_INSERT_ID').asInteger;
      Que_InsertK.ParamByName('KINSERTED').AsDateTime   := CurrentCDS.FieldByName('K_INSERTED').AsDateTime;
      Que_InsertK.ParamByName('KSEDELETE_ID').AsInteger := CurrentCDS.FieldByName('KSE_DELETE_ID').asInteger;
      Que_InsertK.ParamByName('KDELETED').AsDateTime    := CurrentCDS.FieldByName('K_DELETED').AsDateTime;
      Que_InsertK.ParamByName('KSEUPDATE_ID').AsInteger := CurrentCDS.FieldByName('KSE_UPDATE_ID').asInteger;
      Que_InsertK.ParamByName('KUPDATED').AsDateTime    := CurrentCDS.FieldByName('K_UPDATED').AsDateTime;
      Que_InsertK.ParamByName('KSELOCK_ID').AsInteger   := CurrentCDS.FieldByName('KSE_LOCK_ID').asInteger;
      Que_InsertK.ParamByName('KMALOCK_ID').AsInteger   := CurrentCDS.FieldByName('KMA_LOCK_ID').asInteger;
      Que_InsertK.ExecSQL;

      //Validation du traitement de la ligne
      Transaction.Commit;
      
    Except on E:Exception do
      Begin
        Log(DateTimeToStr(Now) + ' -> Id: ' + CurrentCDS.FieldByName('CTE_ID').AsString + ' - ' + E.Message);
        Transaction.Rollback;
      End;
    End;

    //Changement de ligne
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Fermeture des accès BdD et des ClientDataSet
  CDS_CptClient.Close;
  CDS_CptClient.Free;
  Que_CtrlCLTCOMPTE.Close;
  Que_CtrlCLTCOMPTE.Free;
  Que_CtrlK.Close;
  Que_CtrlK.Free;
  Que_DeleteCLTCOMPTE.Close;
  Que_DeleteCLTCOMPTE.Free;
  Que_DeleteK.Close;
  Que_DeleteK.Free;
  Que_InsertCLTCOMPTE.Close;
  Que_InsertCLTCOMPTE.Free;
  Que_InsertK.Close;
  Que_InsertK.Free;

  //Message d'information
  if stop then
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
          CDS.Fields[J].AsString  := InfoLigne.Strings[J];
        End;
      CDS.Post;
      Inc(Compteur);
      if Stop then break;
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
