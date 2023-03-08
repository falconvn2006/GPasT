unit UnitThread;

interface
uses Windows, Classes, SysUtils,IB_Components,IBODataset,ADODB,Forms,DateUtils,
DBClient,DB,StrUTils;

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
Var
  CDS_Client    : TclientDataSet;     //Liste des clients
  CDS_Article   : TClientDataSet;     //Liste des articles
  CDS_Fourn     : TClientDataSet;     //Liste des fournisseurs

  CurrentFile   : String;             //Nom du fichier à traiter, à remplacer en début de traitement, facilité les copier/Coller
  CurrentCDS    : TClientDataSet;     //Permets de passer la CDS Principale dans une variable, facilité les copier/Coller

  I,J           : Integer;            //Variable de boucle
  ChemImport    : String;             //Chemin des fichiers créer pour l'import GINKOIA
  NomClt        : String;             //Nom du client
  FournPays     : String;             //Pays du fournisseur
  CodeMrk       : String;             //Code de la marque
  PxVte         : Double;             //Prix de vente ttc
  SSF_Nom       : String;             //Nom de la sous famille
Begin
  //Verrouille le traitement pour qu'il ne se relance pas
  Start := False;

  //Message d'information
  LibInfo := 'Traitement en cours...';

  //Initialise le chemin pour la création des fichier
  ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\';

  //Création des ClientsDataSet pour l'intégration des informations source
  CDS_Client  := TClientDataSet.Create(nil);
  CDS_Fourn   := TClientDataSet.Create(nil);
  CDS_Article := TClientDataSet.Create(nil);


  //Récupération des informations à intégrer
  LibInfo   := 'Récupération des informations clients en cours...';
  CSV_To_ClientDataSet(ChemSource+'Client.csv',CDS_Client);
  LibInfo   := 'Récupération des informations fourn en cours...';
  CSV_To_ClientDataSet(ChemSource+'fournisseur.csv',CDS_Fourn);
  LibInfo   := 'Récupération des informations articles en cours...';
  CSV_To_ClientDataSet(ChemSource+'pieces.csv',CDS_Article);

  //Traitement des clients
  LibInfo  := 'Traitement des clients en cours...';
  CurrentFile := 'clients.csv';
  CurrentCDS  := CDS_Client;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile  ,'CODE;' +
                                   'TYP;' +
                                   'NOM_RS1;' +
                                   'PREN_RS2;' +
                                   'CIV;' +
                                   'ADR1;' +
                                   'ADR2;' +
                                   'ADR3;' +
                                   'CP;' +
                                   'VILLE;' +
                                   'PAYS;' +
                                   'CODE_COMPTABLE;' +
                                   'COM;' +
                                   'TEL;' +
                                   'FAX_TTRAV;' +
                                   'PORTABLE;' +
                                   'EMAIL;' +
                                   'CB_NATIONAL;' +
                                   'CLASS1;' +
                                   'CLASS2;' +
                                   'CLASS3;' +
                                   'CLASS4;' +
                                   'CLASS5;' +
                                   'NUMERO');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    NomClt  := Trim(LeftStr(CurrentCDS.FieldByName('client').asString,Pos(LowerCase(CurrentCDS.FieldByName('prenom').asString),LowerCase(CurrentCDS.FieldByName('client').asString))-1));
    if NomClt = '' then
    Begin
      NomClt  := CurrentCDS.FieldByName('client').asString;
    End;
    Add_CSV(ChemImport+CurrentFile  ,CurrentCDS.FieldByName('numero').asString + ';' +
                                     'PART' + ';' +
                                     NomClt + ';' +
                                     CurrentCDS.FieldByName('prenom').asString + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('adresse').asString + ';' +
                                     CurrentCDS.FieldByName('adresse_suite').asString + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('code_postal').asString + ';' +
                                     CurrentCDS.FieldByName('Ville').asString + ';' +
                                     'FRANCE' + ';' +
                                     CurrentCDS.FieldByName('code_ventilation').asString + CurrentCDS.FieldByName('compte').asString + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('tel').asString + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('email').asString + ';' +
                                     CurrentCDS.FieldByName('carte_fidelite').asString + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';');
        Inc(Compteur);
        CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des fourniseurs
  LibInfo  := 'Traitement des fournisseurs en cours...';
  CurrentFile := 'fourn.csv';
  CurrentCDS  := CDS_Fourn;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile  ,'CODE;' +
                                   'NOM;' +
                                   'ADR1;' +
                                   'ADR2;' +
                                   'ADR3;' +
                                   'CP;' +
                                   'VILLE;' +
                                   'PAYS;' +
                                   'TEL;' +
                                   'FAX;' +
                                   'PORTABLE;' +
                                   'EMAIL;' +
                                   'COMMENTAIRE;' +
                                   'NUM_CLT;' +
                                   'COND_PAIE;' +
                                   'NUM_COMPTA');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    FournPays := Trim(CurrentCDS.FieldByName('pays').asString);
    if FournPays='' then
    Begin
      FournPays := 'FRANCE';
    End;
    Add_CSV(ChemImport+CurrentFile  ,CurrentCDS.FieldByName('numero').asString + ';' +
                                     CurrentCDS.FieldByName('fournisseur').asString + ';' +
                                     CurrentCDS.FieldByName('adresse').asString + ';' +
                                     CurrentCDS.FieldByName('adresse_suite').asString + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('code_postal').asString + ';' +
                                     CurrentCDS.FieldByName('ville').asString + ';' +
                                     FournPays + ';' +
                                     CurrentCDS.FieldByName('tel').asString + ';' +
                                     CurrentCDS.FieldByName('fax').asString + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('email').asString + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('code_ventilation').asString + CurrentCDS.FieldByName('compte').asString + ';');
        Inc(Compteur);
        CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des marques
  LibInfo  := 'Traitement des marques en cours...';
  CurrentFile := 'marque.csv';
  CurrentCDS  := CDS_Fourn;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile  ,'CODE;' +
                                   'CODE_FOU;' +
                                   'NOM;');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    Add_CSV(ChemImport+CurrentFile  ,CurrentCDS.FieldByName('numero').asString + ';' +
                                     CurrentCDS.FieldByName('numero').asString + ';' +
                                     CurrentCDS.FieldByName('fournisseur').asString + ';');
        Inc(Compteur);
        CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des grilles de taille
  LibInfo     := 'Traitement des grilles de taille en cours...';
  CurrentFile := 'gr_taille.csv';
  NbLigne     := 1;
  Compteur    := 0;
  Add_CSV(ChemImport+ CurrentFile  ,'CODE;' +
                                    'NOM;' +
                                    'TYPE_GRILLE;');

  Add_CSV(ChemImport+ CurrentFile  ,'1' + ';' +
                                    'IMPORT' + ';' +
                                    'IMPORT');
  Inc(Compteur);


  //Traitement des lignes de taille
  LibInfo     := 'Traitement des lignes de taille en cours...';
  CurrentFile := 'gr_taille_lig.csv';
  NbLigne     := 1;
  Compteur    := 0;
  Add_CSV(ChemImport+ CurrentFile  ,'CODE_GT;' +
                                    'NOM;');

  Add_CSV(ChemImport+ CurrentFile  ,'1' + ';' +
                                    'UNIQUE');
  Inc(Compteur);


  //Traitement des articles
  LibInfo     := 'Traitement des articles en cours...';
  CurrentFile := 'Articles.csv';
  CurrentCDS  := CDS_Article;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CDS_Fourn.Open;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile  ,'CODE;' +
                                   'CODE_MRQ;' +
                                   'CODE_GT;' +
                                   'CODE_FOURN;' +
                                   'NOM;' +
                                   'DESCRIPTION;' +
                                   'RAYON;' +
                                   'FAMILLE;' +
                                   'SS_FAM;' +
                                   'GENRE;' +
                                   'CLASS1;' +
                                   'CLASS2;' +
                                   'CLASS3;' +
                                   'CLASS4;' +
                                   'CLASS5;' +
                                   'IDREF_SSFAM;' +
                                   'COUL1;' +
                                   'COUL2;' +
                                   'COUL3;' +
                                   'COUL4;' +
                                   'COUL5;' +
                                   'COUL6;' +
                                   'COUL7;' +
                                   'COUL8;' +
                                   'COUL9;' +
                                   'COUL10;' +
                                   'COUL11;' +
                                   'COUL12;' +
                                   'COUL13;' +
                                   'COUL14;' +
                                   'COUL15;' +
                                   'COUL16;' +
                                   'COUL17;' +
                                   'COUL18;' +
                                   'COUL19;' +
                                   'COUL20;' +
                                   'FIDELITE;' +
                                   'DATECREATION;' +
                                   'COLLECTION;' +
                                   'COMENT1;' +
                                   'COMENT2;' +
                                   'TVA;');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    CodeMrk := '';
    CDS_Fourn.Locate('fournisseur',CurrentCDS.FieldByName('fournisseur').asString,[]);
    CodeMrk := CDS_Fourn.FieldByName('numero').AsString;
    SSF_Nom := Trim(CurrentCDS.FieldByName('categorie').asString);
    if SSF_Nom='' then
    begin
      SSF_NOM := 'AUCUNE';
    end;
    Add_CSV(ChemImport+CurrentFile  ,CurrentCDS.FieldByName('num').asString + ';' +
                                     CodeMrk + ';' +
                                     '1' + ';' +
                                     CurrentCDS.FieldByName('ref_principal').asString + CurrentCDS.FieldByName('ref_taille_couleur').asString + ';' +
                                     CurrentCDS.FieldByName('designation').asString + ';' +
                                     '' + ';' +
                                     'IMPORT' + ';' +
                                     'IMPORT' + ';' +
                                     SSF_Nom + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('ref_taille_couleur').asString + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '1' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     CurrentCDS.FieldByName('tva_vente').asString);
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;
  CDS_Fourn.Close;


  //Traitement des code barre
  LibInfo  := 'Traitement des code barre en cours...';
  CurrentFile := 'code_barre.csv';
  CurrentCDS  := CDS_Article;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile       ,'CODE_ART;' +
                                        'TAILLE;' +
                                        'COULEUR;' +
                                        'EAN;' +
                                        'QTTE;');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    Add_CSV(ChemImport+CurrentFile     ,CurrentCDS.FieldByName('num').asString + ';' +
                                        'UNIQUE' + ';' +
                                        CurrentCDS.FieldByName('ref_taille_couleur').asString + ';' +
                                        CurrentCDS.FieldByName('ref_principal').asString + CurrentCDS.FieldByName('ref_taille_couleur').asString + ';' +
                                        '');
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Traitement des prix
  LibInfo  := 'Traitement des prix en cours...';
  CurrentFile := 'prix.csv';
  CurrentCDS  := CDS_Article;
  if FileExists(ChemImport+CurrentFile) then
  Begin
    DeleteFile(ChemImport+CurrentFile);
  end;
  CurrentCDS.Open;
  CurrentCDS.First;
  NbLigne  := CurrentCDS.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+CurrentFile ,'CODE_ART;' +
                                  'TAILLE;' +
                                  'PXCATALOGUE;' +
                                  'PX_ACHAT;' +
                                  'PX_VENTE;' +
                                  'CODE_FOU;');
  while (Not CurrentCDS.eof) and (not stop) do
  Begin
    PxVte := (StrToFloat(StringReplace(CurrentCDS.FieldByName('prix_vente').Asstring,',','.',[rfReplaceAll]))) * (1+((StrToFloat(StringReplace(CurrentCDS.FieldByName('tva_vente').Asstring,',','.',[rfReplaceAll])))/100));
    Add_CSV(ChemImport+CurrentFile,CurrentCDS.FieldByName('num').asString + ';' +
                                  'UNIQUE' + ';' +
                                  CurrentCDS.FieldByName('prix_achat').asString + ';' +
                                  CurrentCDS.FieldByName('prix_achat').asString + ';' +
                                  FloatToStrF(PxVte,ffFixed,8,2) + ';' +
                                  '');
    Inc(Compteur);
    CurrentCDS.Next;
  End;
  CurrentCDS.Close;


  //Fermeture des accès BdD et des ClientDataSet
  CDS_Client.Close;
  CDS_Client.Free;
  CDS_Fourn.Close;
  CDS_Fourn.Free;
  CDS_Article.Close;
  CDS_Article.Free;

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
      //if (Trim(InfoLigne.Strings[24])<>'0') or (ExtractFileName(FichCsv)<>'pieces.csv') then   //Limite en fonction du stock
      begin
        CDS.Insert;
        for J := 0 to CDS.FieldCount - 1 do
          Begin
            CDS.Fields[J].AsString  := InfoLigne.Strings[J];
          End;
        CDS.Post;
      end;
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
