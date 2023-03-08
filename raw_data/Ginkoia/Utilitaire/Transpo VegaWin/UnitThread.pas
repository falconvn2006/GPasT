unit UnitThread;

interface

uses
  Classes, SysUtils, Forms, DateUtils, DBClient, DB, StrUTils, Variants;

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
    Procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
    Procedure Add_csv(Fichier,Texte:String);
    
Var
  Compteur     : Integer=0;          //Compte le nombre de matériel traité
  NbLigne      : Integer;            //Nombre de ligne à traité
  StartImport  : Boolean=False;      //Variable de démarrage du traitement
  StopImport   : Boolean=False;      //Interrompt le traitement
  LibInfo      : String;             //Message d'information pour l'utilisateur
  ChemSource   : String;             //Chemin des fichiers sources

  CDS_Couleur     : TClientDataSet;     //Liste des couleurs
  CDS_Fourn       : TClientDataSet;     //Liste des fournisseurs
  CDS_Modele      : TClientDataSet;     //Liste des modele
  CDS_CritModele  : TClientDataSet;     //Liste des critères des modele
  CDS_Rayon       : TClientDataSet;     //Liste des rayons
  CDS_Famille     : TClientDataSet;     //Liste des familles d'articles
  CDS_SSFamille   : TClientDataSet;     //Liste des Sous familles d'articles
  CDS_Prix        : TClientDataSet;     //Liste des prix d'articles
  CDS_EanArt      : TClientDataSet;     //Liste des code barre
  CDS_Taille      : TClientDataSet;     //Liste des tailles par grille de taille
  CDS_TVA         : TClientDataSet;     //Liste des taux de TVA

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
  if StartImport then
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
  I,J         : Integer;      //Variable de boucle
  ChemImport  : String;       //Chemin des fichiers créer pour l'import GINKOIA
  CSV_Import  : TStringList;  //Variable de création du fichier csv
  TabCouleur  : Array [1..20] of String;       //Couleur de l'article
  Num_CritMod : String;
  Num_Modele  : String;
  Traitement  : Boolean;
Begin
  //Verrouille le traitement pour qu'il ne se relance pas
  StartImport := False;

  //Message d'information
  LibInfo := 'Traitement en cours...';

  //Initialise le chemin pour la création des fichier
  ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\';

  //Création des ClientsDataSet pour l'intégration des informations source
  CDS_Couleur     := TClientDataSet.Create(nil);
  CDS_Fourn       := TClientDataSet.Create(nil);
  CDS_Taille      := TClientDataSet.Create(nil);
  CDS_Modele      := TClientDataSet.Create(nil);
  CDS_CritModele  := TClientDataSet.Create(nil);
  CDS_Rayon       := TClientDataSet.Create(nil);
  CDS_Famille     := TClientDataSet.Create(nil);
  CDS_SSFamille   := TClientDataSet.Create(nil);
  CDS_EanArt      := TClientDataSet.Create(nil);
  CDS_Prix        := TClientDataSet.Create(nil);
  CDS_TVA         := TClientDataSet.Create(nil);

  //Récupération des informations à intégrer
  LibInfo   := 'Récupération des informations couleur en cours...';
  CSV_To_ClientDataSet(ChemSource+'Couleur.csv',CDS_Couleur,'NO_COULEUR');
  //CDS_Couleur.IndexName := 'idx';

  LibInfo   := 'Récupération des informations fourn en cours...';
  CSV_To_ClientDataSet(ChemSource+'Fourn.csv',CDS_Fourn,'CODE_FOURN');
  //CDS_Fourn.IndexName := 'idx';

  LibInfo   := 'Récupération des informations taille en cours...';
  CSV_To_ClientDataSet(ChemSource+'Taille.csv',CDS_Taille,'CODE_GT');
  //CDS_Taille.IndexName := 'idx';

  LibInfo   := 'Récupération des informations tva en cours...';
  CSV_To_ClientDataSet(ChemSource+'Tva.csv',CDS_TVA,'CODE_TVA');
  //CDS_TVA.IndexName := 'idx';

  LibInfo   := 'Récupération des informations modele en cours...';
  CSV_To_ClientDataSet(ChemSource+'Modele.csv',CDS_Modele,'NO_MODELE;CODE_GT');
  //CDS_Modele.IndexName := 'idx';

  LibInfo   := 'Récupération des informations critère modele en cours...';
  CSV_To_ClientDataSet(ChemSource+'CritMod.csv',CDS_CritModele,'NO_CRITMOD;NO_MODELE');
  //CDS_CritModele.IndexName := 'idx';

  LibInfo   := 'Récupération des informations rayons en cours...';
  CSV_To_ClientDataSet(ChemSource+'Rayon.csv',CDS_Rayon,'CODE_RAYON');
  //CDS_Rayon.IndexName := 'idx';

  LibInfo   := 'Récupération des informations famille en cours...';
  CSV_To_ClientDataSet(ChemSource+'Famille.csv',CDS_Famille,'CODE_RF');
  //CDS_Famille.IndexName := 'idx';

  LibInfo   := 'Récupération des informations sous famille en cours...';
  CSV_To_ClientDataSet(ChemSource+'SSFamille.csv',CDS_SSFamille,'CODE_RFS');
  //CDS_SSFamille.IndexName := 'idx';

  LibInfo   := 'Récupération des informations code barre en cours...';
  CSV_To_ClientDataSet(ChemSource+'EanArt.csv',CDS_EanArt,'NO_CRITMOD');
  //CDS_EanArt.IndexName := 'idx';

  LibInfo   := 'Récupération des informations prix en cours...';
  CSV_To_ClientDataSet(ChemSource+'PrixArt.csv',CDS_Prix,'NO_CRITMOD');
  //CDS_Prix.IndexName := 'idx';

  //Ajout du code couleur 0 - UNICOLOR
    //Traitement des Couleurs
  LibInfo  := 'Traitement des Couleurs en cours...';
  if FileExists(ChemSource+'Couleurs.csv') then
    DeleteFile(ChemSource+'Couleurs.csv');

  CDS_Couleur.Insert;
  CDS_Couleur.FieldByName('NO_COULEUR').AsString := 'UNICOLOR';
  CDS_Couleur.FieldByName('CODE_COULEUR').AsString := 'UNICOLOR';
  CDS_Couleur.Post;

  //Traitement des fourniseurs
  LibInfo  := 'Traitement des fournisseurs en cours...';
  if FileExists(ChemImport+'fourn.csv') then
    DeleteFile(ChemImport+'fourn.csv');

  CDS_Fourn.First;
  NbLigne  := CDS_Fourn.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'fourn.csv'  ,'CODE;' +
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
                                   'NUM_COMPTA;');
  while (Not CDS_Fourn.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'fourn.csv',CDS_Fourn.FieldByName('CODE_FOURN').asString + ';' +
                                   CDS_Fourn.FieldByName('SOCIETE').asString + ';' +
                                   CDS_Fourn.FieldByName('ADRESSE_1').asString + ';' +
                                   CDS_Fourn.FieldByName('ADRESSE_2').asString + ';' +
                                   CDS_Fourn.FieldByName('ADRESSE_3').asString + ';' +
                                   CDS_Fourn.FieldByName('CODE_POSTAL').asString + ';' +
                                   CDS_Fourn.FieldByName('VILLE').asString + ';' +
                                   CDS_Fourn.FieldByName('PAYS').asString + ';' +
                                   CDS_Fourn.FieldByName('TEL').asString + ';' +
                                   CDS_Fourn.FieldByName('FAX').asString + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('MAIL').asString + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('CODE_COMPTA').asString + ';');
        Inc(Compteur);
        CDS_Fourn.Next;
  End;

  //Traitement des marques
  LibInfo  := 'Traitement des marques en cours...';
  if FileExists(ChemImport+'marque.csv') then
    DeleteFile(ChemImport+'marque.csv');

  CDS_Fourn.First;
  NbLigne  := CDS_Fourn.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'marque.csv'  ,'CODE;' +
                                    'CODE_FOU;' +
                                    'NOM;');
  while Not (CDS_Fourn.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'marque.csv',CDS_Fourn.FieldByName('CODE_FOURN').asString + ';' +
                                   CDS_Fourn.FieldByName('CODE_FOURN').asString + ';' +
                                   CDS_Fourn.FieldByName('SOCIETE').asString + ';');
        Inc(Compteur);
        CDS_Fourn.Next;
  End;

  //Traitement des grilles de taille
  LibInfo  := 'Traitement des grilles de taille en cours...';
  if FileExists(ChemImport+'gr_taille.csv') then
    DeleteFile(ChemImport+'gr_taille.csv');

  CDS_Taille.First;
  NbLigne  := CDS_Taille.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                       'NOM;' +
                                       'TYPE_GRILLE;');
  while (Not CDS_Taille.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'gr_taille.csv',CDS_Taille.FieldByName('CODE_GT').asString + ';' +
                                       CDS_Taille.FieldByName('LIBELLE').asString + ';' +
                                       'IMPORT-VegaWin;');
        Inc(Compteur);
        CDS_Taille.Next;
  End;

  //Traitement des lignes de taille
  LibInfo  := 'Traitement des lignes de taille en cours...';
  if FileExists(ChemImport+'Gr_Taille_Lig.csv') then
    DeleteFile(ChemImport+'Gr_Taille_Lig.csv');

  CDS_Taille.First;
  NbLigne  := CDS_Taille.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'Gr_Taille_Lig.csv','CODE_GT;' +
                                         'NOM;');
  while (Not CDS_Taille.eof) and (not stopImport) do
  Begin
    for I := 7 to CDS_Taille.FieldCount - 1 do
    Begin
      if (Trim(CDS_Taille.Fields[I].AsString) <> '') then
      Begin
        Add_CSV(ChemImport+'Gr_Taille_Lig.csv',CDS_Taille.FieldByName('CODE_GT').asString + ';' +
                                               CDS_Taille.Fields[I].asString);
      End;
    end;
    Inc(Compteur);
    CDS_Taille.Next;
  End;

  //Traitement des articles
  LibInfo  := 'Traitement des articles en cours...';
  if FileExists(ChemImport+'Articles.csv') then
    DeleteFile(ChemImport+'Articles.csv');

  CDS_Modele.First;
  NbLigne  := CDS_Modele.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'Articles.csv','CODE;' +
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
  while (Not CDS_Modele.eof) and (not stopImport) do
  Begin
    CDS_SSFamille.Locate('CODE_RFS',Trim(CDS_Modele.FieldByName('CODE_RFS').asString),[]);
    CDS_Famille.Locate('CODE_RF',Trim(CDS_SSFamille.FieldByName('CODE_RF').asString),[]);
    CDS_Rayon.Locate('CODE_RAYON',Trim(CDS_Famille.FieldByName('CODE_RAYON').asString),[]);

    Num_Modele := CDS_Modele.FieldByName('NO_MODELE').asString;

    CDS_CritModele.Filtered := False;
    CDS_CritModele.Filter := 'NO_MODELE = ''' + Num_Modele + '''';
    CDS_CritModele.Filtered := True;

    CDS_CritModele.First;
    I := 1;
    TabCouleur[1] := 'UNICOLOR';

    While (I <= 20) do
    Begin
      While (Not CDS_CritModele.eof) AND (I <= 20) do
      Begin
        if ((CDS_CritModele.FieldByName('NIVEAU2').asString <> '') or (CDS_CritModele.FieldByName('NIVEAU3').asString <> '')) then
        begin
          TabCouleur[I] := CDS_CritModele.FieldByName('NIVEAU2').asString + ' - ' + CDS_CritModele.FieldByName('NIVEAU3').asString;
          inc(I);
        end;

        if (not CDS_CritModele.eof) AND (I > 20) then
          Add_CSV(ChemImport+'LogArticles.csv', CDS_Modele.FieldByName('CODE_MODELE').asString + ';' +
                                                AnsiReplaceStr(Num_Modele, ',', '') + ';' +
                                                'Nb CritModele = ' + IntToStr(CDS_CritModele.RecordCount));
        CDS_CritModele.Next;
      End;
      TabCouleur[I] := '';
      inc(I);
    End;

    CDS_TVA.Locate('CODE_TVA',CDS_Modele.FieldByName('CODE_TVA').asString,[]);

    Add_CSV(ChemImport+'Articles.csv',AnsiReplaceStr(Num_Modele, ',', '') + ';' +
                                      CDS_Modele.FieldByName('CODE_FOURN').asString + ';' +
                                      CDS_Modele.FieldByName('CODE_GT').asString + ';' +
                                      CDS_Modele.FieldByName('CODE_MODELE').asString + ';' +
                                      CDS_Modele.FieldByName('LIBELLE').asString + ';' +
                                      '' + ';' +
                                      CDS_Rayon.FieldByName('LIBELLE').asString + ';' +
                                      CDS_Famille.FieldByName('LIBELLE').asString + ';' +
                                      CDS_SSFamille.FieldByName('LIBELLE').asString + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      TabCouleur[1] + ';' +
                                      TabCouleur[2] + ';' +
                                      TabCouleur[3] + ';' +
                                      TabCouleur[4] + ';' +
                                      TabCouleur[5] + ';' +
                                      TabCouleur[6] + ';' +
                                      TabCouleur[7] + ';' +
                                      TabCouleur[8] + ';' +
                                      TabCouleur[9] + ';' +
                                      TabCouleur[10] + ';' +
                                      TabCouleur[11] + ';' +
                                      TabCouleur[12] + ';' +
                                      TabCouleur[13] + ';' +
                                      TabCouleur[14] + ';' +
                                      TabCouleur[15] + ';' +
                                      TabCouleur[16] + ';' +
                                      TabCouleur[17] + ';' +
                                      TabCouleur[18] + ';' +
                                      TabCouleur[19] + ';' +
                                      TabCouleur[20] + ';' +
                                      '1' + ';' +
                                      '' + ';' +
                                      CDS_Modele.FieldByName('THEME').asString + ';' +
                                      '' + ';' +
                                      '' + ';' +
                                      CDS_TVA.FieldByName('MONTANT').asString);

    Inc(Compteur);

    CDS_Modele.Next;
  End;
  CDS_CritModele.Filtered := False;
  CDS_CritModele.Filter := '';

  //Traitement des code barre
  LibInfo  := 'Traitement des code barre en cours...';
  if FileExists(ChemImport+'code_barre.csv') then
    DeleteFile(ChemImport+'code_barre.csv');

  CDS_EanArt.First;
  NbLigne  := CDS_EanArt.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                        'TAILLE;' +
                                        'COULEUR;' +
                                        'EAN;' +
                                        'QTTE;');
  while (Not CDS_EanArt.eof) and (not stopImport) do
  Begin
    If CDS_CritModele.locate('NO_CRITMOD',CDS_EanArt.FieldByName('NO_CRITMOD').asString,[]) then
    Begin
      If CDS_Modele.Locate('NO_MODELE',CDS_CritModele.FieldByName('NO_MODELE').asString,[]) then
      Begin
        if (CDS_CritModele.FieldByName('NIVEAU2').asString <> '') then
          TabCouleur[1] := CDS_CritModele.FieldByName('NIVEAU2').asString + ' - ' + CDS_CritModele.FieldByName('NIVEAU3').asString
        Else
          TabCouleur[1] := 'UNICOLOR';

        CDS_Taille.Locate('CODE_GT',CDS_Modele.FieldByName('CODE_GT').asString,[]);

        Add_CSV(ChemImport+'code_barre.csv',AnsiReplaceStr(CDS_CritModele.FieldByName('NO_MODELE').AsString, ',', '') + ';' +
                                            CDS_Taille.Fields[6+CDS_EanArt.FieldByName('TAILLE').AsInteger].asString + ';' +
                                            TabCouleur[1] + ';' +
                                            RightStr('000000000000' + AnsiReplaceStr(AnsiReplaceStr(CDS_EanArt.FieldByName('EAN13').AsString, ',', ''), ' ', ''),12) + ';' +
                                            '');
      End;
    End;
    Inc(Compteur);
    CDS_EanArt.Next;
  End;

  //Traitement des prix
  LibInfo  := 'Traitement des prix en cours...';
  if FileExists(ChemImport+'prix.csv') then
    DeleteFile(ChemImport+'prix.csv');

  CDS_Modele.First;
  NbLigne  := CDS_Modele.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                  'TAILLE;' +
                                  'PXCATALOGUE;' +
                                  'PX_ACHAT;' +
                                  'PX_VENTE;' +
                                  'CODE_FOU;');
  while (Not CDS_Modele.eof) and (not stopImport) do
  Begin
    If CDS_CritModele.Locate('NO_MODELE',CDS_Modele.FieldByName('NO_MODELE').asString,[]) then
    Begin
      Traitement := True;
      If not CDS_Prix.locate('NO_CRITMOD;CODE_MAG',VarArrayOf([CDS_CritModele.FieldByName('NO_CRITMOD').asString,'1']),[]) then
      Begin
        If not CDS_Prix.locate('NO_CRITMOD;CODE_MAG',VarArrayOf([CDS_CritModele.FieldByName('NO_CRITMOD').asString,'2']),[]) then
        Begin
          If not CDS_Prix.locate('NO_CRITMOD;CODE_MAG',VarArrayOf([CDS_CritModele.FieldByName('NO_CRITMOD').asString,'0']),[]) then
          Begin
            Traitement := False;  // Si pas de prix trouvé on sort.
          End;
        End;
      End;

      If Traitement then
      Begin
        CDS_EanArt.locate('NO_CRITMOD',CDS_CritModele.FieldByName('NO_CRITMOD').asString,[]);
        CDS_Taille.Locate('CODE_GT',CDS_Modele.FieldByName('CODE_GT').asString,[]);

        Add_CSV(ChemImport+'prix.csv',AnsiReplaceStr(CDS_CritModele.FieldByName('NO_MODELE').asString, ',', '') + ';' +
                                      CDS_Taille.Fields[6+CDS_EanArt.FieldByName('TAILLE').AsInteger].asString + ';' +
                                      CDS_Prix.FieldByName('PA').asString + ';' +
                                      CDS_Prix.FieldByName('PA').asString + ';' +
                                      CDS_Prix.FieldByName('PV').asString + ';' +
                                      '');
      End;
    End;
    Inc(Compteur);
    CDS_Modele.Next;
  End;

  //Fermeture des accès BdD et des ClientDataSet
  FreeAndNil(CDS_Couleur);    //Liste des couleurs
  FreeAndNil(CDS_Fourn);      //Liste des fournisseurs
  FreeAndNil(CDS_Modele);     //Liste des modele
  FreeAndNil(CDS_CritModele); //Liste des critères des modele
  FreeAndNil(CDS_Rayon);      //Liste des rayons
  FreeAndNil(CDS_Famille);    //Liste des familles d'articles
  FreeAndNil(CDS_SSFamille);  //Liste des Sous familles d'articles
  FreeAndNil(CDS_Prix);       //Liste des prix d'articles
  FreeAndNil(CDS_EanArt);     //Liste des code barre
  FreeAndNil(CDS_Taille);     //Liste des tailles par grille de taille
  FreeAndNil(CDS_TVA);        //Liste des taux de TVA

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

Procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
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
  //CDS.AddIndex('idx', Index, []);

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
    end;
  //CDS.Close;

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
