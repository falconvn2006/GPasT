unit UnitThread;

interface

uses
  DateUtils, DBClient, DB, StrUTils, Variants, StdCtrls, ExtCtrls, Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

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
  CDS_Modele      : TClientDataSet;     //Liste des articles
  CDS_Groupe      : TClientDataSet;     //Liste des groupes d'articles
  CDS_Rayon       : TClientDataSet;     //Liste des rayons
  CDS_Famille     : TClientDataSet;     //Liste des familles d'articles
  CDS_Taille      : TClientDataSet;     //Liste des tailles par grille de taille
  CDS_TVA         : TClientDataSet;     //Liste des taux de TVA
  CDS_CodeBarre   : TClientDataSet;     //Code Barre inventaire

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
  function FindCouleur(aCouleur:string;aTabCouleur:Array of String):Boolean;
  var
    i : Integer;
  begin
    Result := False;
    i := 0;
    While (i < 20) do
    begin
      if (aCouleur = aTabCouleur[i]) then
      begin
        Result := True;
        Exit;
      end;

      Inc(i);
    end;
  end;

  function ConvertEAN(aEAN:string):string;
  var
    j,
    iCle,
    iVal  : Integer;
  begin
    Result := '';

    j := 1;
    while j <= Length(aEAN) do         //On boucle sur les 12 caractères pour savoir s'il n'y a que des Chiffres
    begin
      if not (aEAN[j] in ['0' .. '9']) then
      begin
        Result := aEan;   //On le retourne Telquel
        Exit;
      end;
      Inc(j);
    end;

    if Length(aEAN) <> 12 then //Si le code EAN est <> de 12 chiffres
    begin
      Result := aEan;         //On retourne le code EAN d'origine
    end
    else
    begin
      j     := 1;
      iCle  := 0;
      iVal  := 1;

      while j <= 12 do         //On boucle sur les 12 caractères
      begin
        iCle := iCle + (StrToInt(Copy(aEAN,j,1))*iVal);
        if iVal = 1 then      //On alterne la valeur 1 ou 3 pour calculer la clé
          iVal := 3
        else
          iVal := 1;
        Inc(j);
      end;
      if (iCle mod 10) = 0 then
        Result := aEAN + '0'
      else
        Result := aEAN + IntToStr(10 - (iCle mod 10));
    end;
  end;

Var
  I           : Integer;        //Variable de boucle
  ChemImport  : string;       //Chemin des fichiers créer pour l'import GINKOIA
  CSV_Import  : TStringList;  //Variable de création du fichier csv
  TabCouleur  : Array [1..20] of String;       //Couleur de l'article
  Couleur     : string;
  Num_CritMod : string;
  Num_Modele  : String;
  sEAN        : string;
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
  CDS_Groupe      := TClientDataSet.Create(nil);
  CDS_Rayon       := TClientDataSet.Create(nil);
  CDS_Famille     := TClientDataSet.Create(nil);
  CDS_TVA         := TClientDataSet.Create(nil);
  CDS_CodeBarre   := TClientDataSet.Create(nil);

  //Récupération des informations à intégrer
  LibInfo   := 'Récupération des informations couleur en cours...';
  CSV_To_ClientDataSet(ChemSource+'Couleur.csv',CDS_Couleur,'CouleurId');

  LibInfo   := 'Récupération des informations fourn en cours...';
  CSV_To_ClientDataSet(ChemSource+'Fourn.csv',CDS_Fourn,'FournisseurId');

  LibInfo   := 'Récupération des informations taille en cours...';
  CSV_To_ClientDataSet(ChemSource+'Taille.csv',CDS_Taille,'TailleId');

  LibInfo   := 'Récupération des informations tva en cours...';
  CSV_To_ClientDataSet(ChemSource+'Tva.csv',CDS_TVA,'TvaId');

  LibInfo   := 'Récupération des informations modele en cours...';
  CSV_To_ClientDataSet(ChemSource+'Modele.csv',CDS_Modele,'ArticleId');

  LibInfo   := 'Récupération des informations groupe en cours...';
  CSV_To_ClientDataSet(ChemSource+'Groupe.csv',CDS_Groupe,'GroupeId');

  LibInfo   := 'Récupération des informations rayons en cours...';
  CSV_To_ClientDataSet(ChemSource+'Rayon.csv',CDS_Rayon,'RayonId');

  LibInfo   := 'Récupération des informations famille en cours...';
  CSV_To_ClientDataSet(ChemSource+'Famille.csv',CDS_Famille,'FamilleId');

  LibInfo   := 'Récupération des informations code barre en cours...';
  CSV_To_ClientDataSet(ChemSource+'CodeBarre.csv',CDS_CodeBarre,'CodeBarre');

  //Ajout du code couleur 0 - UNICOLOR
    //Traitement des Couleurs
  LibInfo  := 'Traitement des Couleurs en cours...';
  if FileExists(ChemSource+'Couleurs.csv') then
    DeleteFile(ChemSource+'Couleurs.csv');

  CDS_Couleur.Insert;
  CDS_Couleur.FieldByName('CouleurId').AsInteger := 0;
  CDS_Couleur.FieldByName('Libelle').AsString := 'UNICOLOR';
  CDS_Couleur.FieldByName('Status').AsInteger := 1;
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
    Add_CSV(ChemImport+'fourn.csv',CDS_Fourn.FieldByName('FournisseurId').asString + ';' +
                                   CDS_Fourn.FieldByName('Nom').asString + ';' +
                                   CDS_Fourn.FieldByName('Adresse').asString + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('CP').asString + ';' +
                                   CDS_Fourn.FieldByName('Ville').asString + ';' +
                                   CDS_Fourn.FieldByName('Pays').asString + ';' +
                                   CDS_Fourn.FieldByName('Tel').asString + ';' +
                                   CDS_Fourn.FieldByName('Fax').asString + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('Email').asString + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('CodeComptable').asString + ';');
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
    Add_CSV(ChemImport+'marque.csv',CDS_Fourn.FieldByName('FournisseurId').asString + ';' +
                                   CDS_Fourn.FieldByName('FournisseurId').asString + ';' +
                                   CDS_Fourn.FieldByName('Nom').asString + ';');
    Inc(Compteur);
    CDS_Fourn.Next;
  End;

  //Traitement des grilles de taille
  LibInfo  := 'Traitement des grilles de taille en cours...';
  if FileExists(ChemImport+'gr_taille.csv') then
    DeleteFile(ChemImport+'gr_taille.csv');

  Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                       'NOM;' +
                                       'TYPE_GRILLE;');
  Add_CSV(ChemImport+'gr_taille.csv','10' + ';' +
                                     'IMPORT-Innomedia' + ';' +
                                     'IMPORT-Innomedia' + ';');

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
    Add_CSV(ChemImport+'Gr_Taille_Lig.csv','10' + ';' +
                                           CDS_Taille.FieldByName('Libelle').asString + ';');
    Inc(Compteur);
    CDS_Taille.Next;
  End;

  //Traitement des articles
  LibInfo  := 'Traitement des articles en cours...';
  if FileExists(ChemImport+'Articles.csv') then
    DeleteFile(ChemImport+'Articles.csv');

  CDS_Groupe.First;
  NbLigne  := CDS_Groupe.RecordCount;
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
  while (Not CDS_Groupe.eof) and (not stopImport) do
  Begin
    Num_Modele := CDS_Groupe.FieldByName('LeaderArticleId').AsString;

    CDS_Modele.Filtered := False;
    CDS_Modele.Filter := 'GroupeId = ''' + CDS_Groupe.FieldByName('GroupeId').AsString + '''';
    CDS_Modele.Filtered := True;

    for I := 1 to 21 do
      TabCouleur[I] := '';

    I := 1;
    TabCouleur[1] := 'UNICOLOR';

    While (I <= 20) do
    Begin
      While (Not CDS_Modele.eof) AND (I < 20) do
      Begin
        if (CDS_Modele.FieldByName('CouleurId').asString <> '') And (CDS_Modele.FieldByName('CouleurId').AsInteger <> 0) then
        begin
          CDS_Couleur.Locate('CouleurId',CDS_Modele.FieldByName('CouleurId').AsInteger,[]);
          if not FindCouleur(CDS_Couleur.FieldByName('Libelle').asString, TabCouleur) then
          begin
            TabCouleur[I] := CDS_Couleur.FieldByName('Libelle').asString;
            inc(I);
          end;
        end;

        if (not CDS_Modele.eof) AND (I > 20) then
          Add_CSV(ChemImport+'LogArticles.csv', CDS_Modele.FieldByName('CODE_MODELE').asString + ';' +
                                                AnsiReplaceStr(Num_Modele, ',', '') + ';' +
                                                'Nb Modele = ' + IntToStr(CDS_Modele.RecordCount));
        CDS_Modele.Next;
      End;
      TabCouleur[I] := '';
      inc(I);
    End;

    CDS_Modele.Locate('ArticleId',CDS_Groupe.FieldByName('LeaderArticleId').AsInteger,[]);
    CDS_Famille.Locate('FamilleId',CDS_Modele.FieldByName('FamilleId').AsInteger,[]);
    CDS_Rayon.Locate('RayonId',CDS_Famille.FieldByName('NumRayon').AsInteger,[]);

    CDS_TVA.Locate('TvaId',CDS_Modele.FieldByName('TvaIdAchat').asString,[]);

    Add_CSV(ChemImport+'Articles.csv',CDS_Modele.FieldByName('ArticleId').asString + ';' +        //CODE
                                      CDS_Modele.FieldByName('FournisseurId').asString + ';' +    //CODE_MRQ
                                      '10' + ';' +                                                //CODE_GT
                                      CDS_Modele.FieldByName('Reference').AsString + ';' +        //CODE_FOURN
                                      CDS_Modele.FieldByName('NomArticle').asString + ';' +       //NOM
                                      CDS_Modele.FieldByName('InfoArticle').asString + ';' +      //DESCRIPTION
                                      CDS_Rayon.FieldByName('Nom').asString + ';' +               //RAYON
                                      CDS_Famille.FieldByName('Nom').asString + ';' +             //FAMILLE
                                      '.' + ';' +                                                  //SS_FAM
                                      '' + ';' +                                                  //GENRE
                                      '' + ';' +                                                  //CLASS1
                                      '' + ';' +                                                  //CLASS2
                                      '' + ';' +                                                  //CLASS3
                                      '' + ';' +                                                  //CLASS4
                                      '' + ';' +                                                  //CLASS5
                                      '' + ';' +                                                  //IDREF_SSFAM
                                      TabCouleur[1] + ';' +                                       //COUL1
                                      TabCouleur[2] + ';' +                                       //COUL2
                                      TabCouleur[3] + ';' +                                       //COUL3
                                      TabCouleur[4] + ';' +                                       //COUL4
                                      TabCouleur[5] + ';' +                                       //COUL5
                                      TabCouleur[6] + ';' +                                       //COUL6
                                      TabCouleur[7] + ';' +                                       //COUL7
                                      TabCouleur[8] + ';' +                                       //COUL8
                                      TabCouleur[9] + ';' +                                       //COUL9
                                      TabCouleur[10] + ';' +                                      //COUL10
                                      TabCouleur[11] + ';' +                                      //COUL11
                                      TabCouleur[12] + ';' +                                      //COUL12
                                      TabCouleur[13] + ';' +                                      //COUL13
                                      TabCouleur[14] + ';' +                                      //COUL14
                                      TabCouleur[15] + ';' +                                      //COUL15
                                      TabCouleur[16] + ';' +                                      //COUL16
                                      TabCouleur[17] + ';' +                                      //COUL17
                                      TabCouleur[18] + ';' +                                      //COUL18
                                      TabCouleur[19] + ';' +                                      //COUL19
                                      TabCouleur[20] + ';' +                                      //COUL20
                                      '1' + ';' +                                                 //FIDELITE
                                      CDS_Modele.FieldByName('DateCreation').AsString + ';' +     //DATECREATION
                                      '' + ';' +                                                  //COLLECTION
                                      '' + ';' +                                                  //COMENT1
                                      '' + ';' +                                                  //COMENT2
                                      CDS_TVA.FieldByName('Taux').asString);                      //TVA

    Inc(Compteur);

    CDS_Groupe.Next;
  End;

  CDS_Modele.Filtered := False;
  CDS_Modele.Filter := 'GroupeId = ''0'' AND TypeArticle = ''1''';
  CDS_Modele.Filtered := True;

  LibInfo  := 'Traitement des articles sans groupe en cours...';

  CDS_Modele.First;
  NbLigne  := CDS_Modele.RecordCount;
  Compteur := 0;

  for I := 1 to 21 do
    TabCouleur[I] := '';

  while (Not CDS_Modele.eof) and (not stopImport) do
  Begin
    Num_Modele := CDS_Modele.FieldByName('ArticleId').AsString;
    CDS_Couleur.Locate('CouleurId',CDS_Modele.FieldByName('CouleurId').AsInteger,[]);

    if CDS_Couleur.FieldByName('Libelle').asString <> '' then
      TabCouleur[1] := CDS_Couleur.FieldByName('Libelle').asString
    else
      TabCouleur[1] := 'UNICOLOR';

    CDS_Famille.Locate('FamilleId',CDS_Modele.FieldByName('FamilleId').AsInteger,[]);
    CDS_Rayon.Locate('RayonId',CDS_Famille.FieldByName('NumRayon').AsInteger,[]);

    CDS_TVA.Locate('TvaId',CDS_Modele.FieldByName('TvaIdAchat').asString,[]);

    Add_CSV(ChemImport+'Articles.csv',CDS_Modele.FieldByName('ArticleId').asString + ';' +        //CODE
                                      CDS_Modele.FieldByName('FournisseurId').asString + ';' +    //CODE_MRQ
                                      '10' + ';' +                                                //CODE_GT
                                      CDS_Modele.FieldByName('Reference').AsString + ';' +        //CODE_FOURN
                                      CDS_Modele.FieldByName('NomArticle').asString + ';' +       //NOM
                                      CDS_Modele.FieldByName('InfoArticle').asString + ';' +      //DESCRIPTION
                                      CDS_Rayon.FieldByName('Nom').asString + ';' +               //RAYON
                                      CDS_Famille.FieldByName('Nom').asString + ';' +             //FAMILLE
                                      '.' + ';' +                                                  //SS_FAM
                                      '' + ';' +                                                  //GENRE
                                      '' + ';' +                                                  //CLASS1
                                      '' + ';' +                                                  //CLASS2
                                      '' + ';' +                                                  //CLASS3
                                      '' + ';' +                                                  //CLASS4
                                      '' + ';' +                                                  //CLASS5
                                      '' + ';' +                                                  //IDREF_SSFAM
                                      TabCouleur[1] + ';' +                                       //COUL1
                                      TabCouleur[2] + ';' +                                       //COUL2
                                      TabCouleur[3] + ';' +                                       //COUL3
                                      TabCouleur[4] + ';' +                                       //COUL4
                                      TabCouleur[5] + ';' +                                       //COUL5
                                      TabCouleur[6] + ';' +                                       //COUL6
                                      TabCouleur[7] + ';' +                                       //COUL7
                                      TabCouleur[8] + ';' +                                       //COUL8
                                      TabCouleur[9] + ';' +                                       //COUL9
                                      TabCouleur[10] + ';' +                                      //COUL10
                                      TabCouleur[11] + ';' +                                      //COUL11
                                      TabCouleur[12] + ';' +                                      //COUL12
                                      TabCouleur[13] + ';' +                                      //COUL13
                                      TabCouleur[14] + ';' +                                      //COUL14
                                      TabCouleur[15] + ';' +                                      //COUL15
                                      TabCouleur[16] + ';' +                                      //COUL16
                                      TabCouleur[17] + ';' +                                      //COUL17
                                      TabCouleur[18] + ';' +                                      //COUL18
                                      TabCouleur[19] + ';' +                                      //COUL19
                                      TabCouleur[20] + ';' +                                      //COUL20
                                      '1' + ';' +                                                 //FIDELITE
                                      CDS_Modele.FieldByName('DateCreation').AsString + ';' +     //DATECREATION
                                      '' + ';' +                                                  //COLLECTION
                                      '' + ';' +                                                  //COMENT1
                                      '' + ';' +                                                  //COMENT2
                                      CDS_TVA.FieldByName('Taux').asString);                      //TVA

    Inc(Compteur);

    CDS_Modele.Next;
  End;
  CDS_Modele.Filtered := False;
  CDS_Modele.Filter := '';

  //Traitement des code barre
  try
    LibInfo  := 'Traitement des code barre en cours...';
    if FileExists(ChemImport+'code_barre.csv') then
      DeleteFile(ChemImport+'code_barre.csv');

    CDS_Modele.Filtered := False;
    CDS_Modele.Filter := 'TypeArticle = 1';
    CDS_Modele.Filtered := True;

    CDS_Modele.First;
    NbLigne  := CDS_Modele.RecordCount;
    Compteur := 0;
    Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                          'TAILLE;' +
                                          'COULEUR;' +
                                          'EAN;' +
                                          'QTTE;');

    while (Not CDS_Modele.eof) and (not stopImport) do
    Begin
      Couleur := '';
      CDS_Couleur.Locate('CouleurId',CDS_Modele.FieldByName('CouleurId').AsInteger,[]);
      Couleur := CDS_Couleur.FieldByName('Libelle').asString;
      if Couleur = '' then
        Couleur := 'UNICOLOR';

      CDS_Taille.Locate('TailleId',CDS_Modele.FieldByName('TailleId').asString,[]);

      if CDS_Modele.FieldByName('GroupeId').AsInteger = 0 then
        Num_Modele := CDS_Modele.FieldByName('ArticleId').asString
      else
      begin
        CDS_Groupe.Locate('GroupeId',CDS_Modele.FieldByName('GroupeId').asString,[]);
        Num_Modele := CDS_Groupe.FieldByName('LeaderArticleId').asString;
      end;

      if CDS_Modele.FieldByName('CodeBarre1').asString <> '' then
      begin
        CDS_CodeBarre.Filtered  := False;
        CDS_CodeBarre.Filter    := 'CodeBarre = ''' + CDS_Modele.FieldByName('CodeBarre1').asString + '''';
        CDS_CodeBarre.Filtered  := True;
        CDS_CodeBarre.First;

        if CDS_CodeBarre.IsEmpty then
          sEAN := ConvertEAN(AnsiReplaceStr(AnsiReplaceStr(CDS_Modele.FieldByName('CodeBarre1').asString, ',', ''), ' ', ''))
        else
          sEAN := CDS_Modele.FieldByName('CodeBarre1').asString;

        Add_CSV(ChemImport+'code_barre.csv',Num_Modele + ';' +
                                            CDS_Taille.FieldByName('Libelle').asString + ';' +
                                            Couleur + ';' +
                                            //RightStr('000000000000' +
                                            sEAN + ';' +
                                            //,13) + ';' +
                                            '');
      end;

      if CDS_Modele.FieldByName('CodeBarre2').asString <> '' then
      begin
        CDS_CodeBarre.Filtered  := False;
        CDS_CodeBarre.Filter    := 'CodeBarre = ''' + CDS_Modele.FieldByName('CodeBarre2').asString + '''';
        CDS_CodeBarre.Filtered  := True;
        CDS_CodeBarre.First;

        if CDS_CodeBarre.IsEmpty then
          sEAN := ConvertEAN(AnsiReplaceStr(AnsiReplaceStr(CDS_Modele.FieldByName('CodeBarre2').asString, ',', ''), ' ', ''))
        else
          sEAN := CDS_Modele.FieldByName('CodeBarre2').asString;

        Add_CSV(ChemImport+'code_barre.csv',Num_Modele + ';' +
                                            CDS_Taille.FieldByName('Libelle').asString + ';' +
                                            Couleur + ';' +
                                            //RightStr('000000000000' +
                                            sEAN + ';' +
                                            //,13) + ';' +
                                            '');
      end;

      if CDS_Modele.FieldByName('CodeBarre3').asString <> '' then
      begin
        CDS_CodeBarre.Filtered  := False;
        CDS_CodeBarre.Filter    := 'CodeBarre = ''' + CDS_Modele.FieldByName('CodeBarre3').asString + '''';
        CDS_CodeBarre.Filtered  := True;
        CDS_CodeBarre.First;

        if CDS_CodeBarre.IsEmpty then
          sEAN := ConvertEAN(AnsiReplaceStr(AnsiReplaceStr(CDS_Modele.FieldByName('CodeBarre3').asString, ',', ''), ' ', ''))
        else
          sEAN := CDS_Modele.FieldByName('CodeBarre3').asString;

        Add_CSV(ChemImport+'code_barre.csv',Num_Modele + ';' +
                                            CDS_Taille.FieldByName('Libelle').asString + ';' +
                                            Couleur + ';' +
                                            //RightStr('000000000000' +
                                            sEAN + ';' +
                                            //,13) + ';' +
                                            '');
      end;

      Inc(Compteur);
      CDS_Modele.Next;
    End;
    CDS_Modele.Filtered := False;
    CDS_Modele.Filter := '';

    CDS_CodeBarre.Filtered := False;
    CDS_CodeBarre.Filter := '';
  except on E : Exception do
    ShowMessage('Erreur dans les Code Barre : ' + E.Message);
  end;

  //Traitement des prix
  LibInfo  := 'Traitement des prix en cours...';
  if FileExists(ChemImport+'prix.csv') then
    DeleteFile(ChemImport+'prix.csv');

  CDS_Modele.Filtered := False;
  CDS_Modele.Filter := 'TypeArticle = 1';
  CDS_Modele.Filtered := True;

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
    CDS_Taille.Locate('TailleId',CDS_Modele.FieldByName('TailleId').asString,[]);

    CDS_Groupe.Locate('GroupeId',CDS_Modele.FieldByName('GroupeId').asString,[]);

    Add_CSV(ChemImport+'prix.csv',CDS_Groupe.FieldByName('LeaderArticleId').asString + ';' +
                                  CDS_Taille.FieldByName('Libelle').asString + ';' +
                                  CDS_Modele.FieldByName('PrixAchatSuggere').asString + ';' +
                                  CDS_Modele.FieldByName('PAchatHtMon1').asString + ';' +
                                  CDS_Modele.FieldByName('PvTtcMon1Sess1').asString + ';' +
                                  '');
    Inc(Compteur);
    CDS_Modele.Next;
  End;
  CDS_Modele.Filtered := False;
  CDS_Modele.Filter := '';

  //Fermeture des accès BdD et des ClientDataSet
  FreeAndNil(CDS_Couleur);    //Liste des couleurs
  FreeAndNil(CDS_Fourn);      //Liste des fournisseurs
  FreeAndNil(CDS_Modele);     //Liste des modele
  FreeAndNil(CDS_Groupe);
  FreeAndNil(CDS_Rayon);      //Liste des rayons
  FreeAndNil(CDS_Famille);    //Liste des familles d'articles
  FreeAndNil(CDS_Taille);     //Liste des tailles par grille de taille
  FreeAndNil(CDS_TVA);        //Liste des taux de TVA
  FreeAndNil(CDS_CodeBarre);

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
