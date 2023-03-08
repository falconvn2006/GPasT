unit UnitThread;

interface
uses Windows, Classes, SysUtils,IB_Components,IBODataset,ADODB,Forms,DateUtils,
DBClient,DB,StrUTils,Dialogs;

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

  CDS_Client    : TclientDataSet;     //Liste des clients
  CDS_Article   : TClientDataSet;     //Liste des articles
  CDS_Couleur   : TClientDataSet;     //Liste des couleurs
  CDS_Famille   : TClientDataSet;     //Liste des familles d'articles
  CDS_Fourn     : TClientDataSet;     //Liste des fournisseurs
  CDS_Prix      : TClientDataSet;     //Liste des prix d'articles
  CDS_Taille    : TClientDataSet;     //Liste des tailles par grille de taille
  CDS_TVA       : TClientDataSet;     //Liste des taux de TVA
  CDS_CodeBarre : TClientDataSet;     //Liste des codes barre
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
  function IsInTab(Value : string; Tab : Array of String):Boolean;
  var
    I : Integer;
  begin
    Result := False;

    try
      for I := 1 to Length(Tab)-1 do
        if Value = Tab[I] then
        begin
          Result := True;
          Exit;
        end;
    except on e:Exception do
      ShowMessage(e.Message);
    end;
  end;

//Effectue la transpo des données
Var
  I,J         : Integer;      //Variable de boucle
  ChemImport  : String;       //Chemin des fichiers créer pour l'import GINKOIA
  CSV_Import  : TStringList;  //Variable de création du fichier csv
  CodeTaille  : String;       //Code de la grille de taille
  SSF_Nom     : String;       //Nom de la sous famille
  Couleur     : String;       //Couleur de l'article
  Taille      : string;
  TabCouleur  : Array [1..20] of String;       //Couleur de l'article
  aCodeBarre  : TAggregate;
Begin
  //Verrouille le traitement pour qu'il ne se relance pas
  StartImport := False;

  //Message d'information
  LibInfo := 'Traitement en cours...';

  //Initialise le chemin pour la création des fichier
  ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\';

  //Création des ClientsDataSet pour l'intégration des informations source
  CDS_Client    := TClientDataSet.Create(nil);
  CDS_Article   := TClientDataSet.Create(nil);
  CDS_Couleur   := TClientDataSet.Create(nil);
  CDS_Famille   := TClientDataSet.Create(nil);
  CDS_Fourn     := TClientDataSet.Create(nil);
  CDS_Prix      := TClientDataSet.Create(nil);
  CDS_Taille    := TClientDataSet.Create(nil);
  CDS_TVA       := TClientDataSet.Create(nil);
  CDS_CodeBarre := TClientDataSet.Create(nil);

  //Récupération des informations à intégrer
  try
    LibInfo   := 'Récupération des informations clients en cours...';
    CSV_To_ClientDataSet(ChemSource+'Client.csv',CDS_Client);
    LibInfo   := 'Récupération des informations articles en cours...';
    CSV_To_ClientDataSet(ChemSource+'Article.csv',CDS_Article);
    LibInfo   := 'Récupération des informations couleur en cours...';
    CSV_To_ClientDataSet(ChemSource+'Couleur.csv',CDS_Couleur);
    LibInfo   := 'Récupération des informations famille en cours...';
    CSV_To_ClientDataSet(ChemSource+'Famille.csv',CDS_Famille);
    LibInfo   := 'Récupération des informations fourn en cours...';
    CSV_To_ClientDataSet(ChemSource+'Fourn.csv',CDS_Fourn);
    LibInfo   := 'Récupération des informations prix en cours...';
    CSV_To_ClientDataSet(ChemSource+'Prix_art.csv',CDS_Prix);
    LibInfo   := 'Récupération des informations taille en cours...';
    CSV_To_ClientDataSet(ChemSource+'Taye.csv',CDS_Taille);
    LibInfo   := 'Récupération des informations tva en cours...';
    CSV_To_ClientDataSet(ChemSource+'Tva.csv',CDS_TVA);
    LibInfo   := 'Récupération des informations Code Barre en cours...';
    CSV_To_ClientDataSet(ChemSource+'Arttay.csv',CDS_CodeBarre);
  except on e: Exception do
    ShowMessage('Avec le message : ' + e.Message);
  end;

  //Ajout du code couleur 0 - UNICOLOR
  CDS_Couleur.Open;
  CDS_Couleur.Insert;
  CDS_Couleur.FieldByName('CodeCouleur').AsString := '0';
  CDS_Couleur.FieldByName('LibCouleur').AsString  := 'UNICOLOR';
  CDS_Couleur.FieldByName('C1').AsString          := 'UNICOLOR';
  CDS_Couleur.Post;
  CDS_Couleur.Close;


  {//Test d'affichage
  CDS_Client.Open;
  CDS_Client.First;
  Frm_Principale.StringGrid1.RowCount := CDS_Client.RecordCount+1;
  Frm_Principale.StringGrid1.ColCount := CDS_Client.FieldCount;
  J := 1;
  for I := 0 to CDS_Client.FieldCount - 1 do
    Frm_Principale.StringGrid1.Cells[I,0] := CDS_Client.FieldDefs[I].Name;
  while Not CDS_Client.eof do
  Begin
    for I := 0 to CDS_Client.FieldCount - 1 do
    Begin
      Frm_Principale.StringGrid1.Cells[I,J] := CDS_Client.Fields[I].asString;
    End;
    CDS_Client.Next;
    Inc(J);
  End;
  CDS_Client.Close;}

  //Traitement des clients
  LibInfo  := 'Traitement des clients en cours...';
  if FileExists(ChemImport+'clients.csv') then
    DeleteFile(ChemImport+'clients.csv');
  
  CDS_Client.Open;
  CDS_Client.First;
  NbLigne  := CDS_Client.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'clients.csv','CODE;' +
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
  while (Not CDS_Client.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'clients.csv',CDS_Client.FieldByName('CodeCli').asString + ';' +
                                     'PART' + ';' +
                                     CDS_Client.FieldByName('NomCli').asString + ';' +
                                     CDS_Client.FieldByName('PreCli').asString + ';' +
                                     '' + ';' +
                                     CDS_Client.FieldByName('AdrCli1').asString + ';' +
                                     CDS_Client.FieldByName('AdrCli2').asString + ';' +
                                     '' + ';' +
                                     CDS_Client.FieldByName('CPCli').asString + ';' +
                                     CDS_Client.FieldByName('VilCli').asString + ';' +
                                     'FRANCE' + ';' +
                                     '' + ';' +
                                     CDS_Client.FieldByName('Memocli').asString + ';' +
                                     CDS_Client.FieldByName('TelCli').asString + ';' +
                                     '' + ';' +
                                     CDS_Client.FieldByName('FaxCli').asString + ';' +
                                     CDS_Client.FieldByName('EmailCli').asString + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';' +
                                     '' + ';');
        Inc(Compteur);
        CDS_Client.Next;
  End;
  CDS_Client.Close;

  
  //Traitement des fourniseurs
  LibInfo  := 'Traitement des fournisseurs en cours...';
  if FileExists(ChemImport+'fourn.csv') then
    DeleteFile(ChemImport+'fourn.csv');

  CDS_Fourn.Open;
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
                                   'NUM_COMPTA');
  while (Not CDS_Fourn.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'fourn.csv',CDS_Fourn.FieldByName('Codefour').asString + ';' +
                                   CDS_Fourn.FieldByName('LibFour').asString + ';' +
                                   CDS_Fourn.FieldByName('AdrFour1').asString + ';' +
                                   CDS_Fourn.FieldByName('AdrFour2').asString + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('CPFour').asString + ';' +
                                   CDS_Fourn.FieldByName('VilFour').asString + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('TelFour').asString + ';' +
                                   CDS_Fourn.FieldByName('FaxFour').asString + ';' +
                                   '' + ';' +
                                   CDS_Fourn.FieldByName('EmailFour').asString + ';' +
                                   CDS_Fourn.FieldByName('MemoF').asString + ';' +
                                   '' + ';' +
                                   '' + ';' +
                                   '' + ';');
        Inc(Compteur);
        CDS_Fourn.Next;
  End;
  CDS_Fourn.Close;


  //Traitement des marques
  LibInfo  := 'Traitement des marques en cours...';
  if FileExists(ChemImport+'marque.csv') then
    DeleteFile(ChemImport+'marque.csv');

  CDS_Fourn.Open;
  CDS_Fourn.First;
  NbLigne  := CDS_Fourn.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'marque.csv'  ,'CODE;' +
                                    'CODE_FOU;' +
                                    'NOM;');
  while Not (CDS_Fourn.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'marque.csv',CDS_Fourn.FieldByName('Codefour').asString + ';' +
                                   CDS_Fourn.FieldByName('Codefour').asString + ';' +
                                   CDS_Fourn.FieldByName('LibFour').asString);
        Inc(Compteur);
        CDS_Fourn.Next;
  End;
  CDS_Fourn.Close;


  //Traitement des grilles de taille
  LibInfo  := 'Traitement des grilles de taille en cours...';
  if FileExists(ChemImport+'gr_taille.csv') then
    DeleteFile(ChemImport+'gr_taille.csv');

  CDS_Taille.Open;
  CDS_Taille.First;
  NbLigne  := CDS_Taille.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                       'NOM;' +
                                       'TYPE_GRILLE;');
  while (Not CDS_Taille.eof) and (not stopImport) do
  Begin
    Add_CSV(ChemImport+'gr_taille.csv',CDS_Taille.FieldByName('Codetaille').asString + ';' +
                                       CDS_Taille.FieldByName('libtaille').asString + ';' +
                                       'IMPORT-CILEA');
        Inc(Compteur);
        CDS_Taille.Next;
  End;
  Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +
                                     'UNIQUE' + ';' +
                                     'IMPORT-CILEA');
  CDS_Taille.Close;


  //Traitement des lignes de taille
  LibInfo  := 'Traitement des lignes de taille en cours...';
  if FileExists(ChemImport+'gr_taille_lig.csv') then
    DeleteFile(ChemImport+'gr_taille_lig.csv');

  CDS_Taille.Open;
  CDS_Taille.First;
  NbLigne  := CDS_Taille.RecordCount;
  Compteur := 0;
  Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +
                                         'NOM;');
  while (Not CDS_Taille.eof) and (not stopImport) do
  Begin
    for I := 2 to CDS_Taille.FieldCount - 1 do
    Begin
      if (Trim(CDS_Taille.Fields[I].AsString) <> '') then
      Begin
        Add_CSV(ChemImport+'gr_taille_lig.csv',CDS_Taille.FieldByName('Codetaille').asString + ';' +
                                               CDS_Taille.Fields[I].asString);
      End;
    end;
    Inc(Compteur);
    CDS_Taille.Next;
  End;
  Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                         'UNIQUE');
  CDS_Taille.Close;


  //Traitement des articles
  LibInfo  := 'Traitement des articles en cours...';
  if FileExists(ChemImport+'Articles.csv') then
    DeleteFile(ChemImport+'Articles.csv');

  if FileExists(ChemImport+'code_barre.csv') then
    DeleteFile(ChemImport+'code_barre.csv');

  try
    CDS_Article.Open;
    CDS_Famille.Open;
    CDS_Couleur.Open;
    CDS_TVA.Open;
    CDS_Taille.Open;
    CDS_CodeBarre.Open;

    CDS_Article.First;
    NbLigne  := CDS_Article.RecordCount;
    Compteur := 0;

    Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                          'TAILLE;' +
                                          'COULEUR;' +
                                          'EAN;' +
                                          'QTTE;');

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

    while (Not CDS_Article.eof) and (not stopImport) do
    Begin
      if Trim(CDS_Article.FieldByName('Codetaille').asString)<>'0' then
        CodeTaille  := CDS_Article.FieldByName('Codetaille').asString
      else
        CodeTaille  := '0';

      CDS_Famille.Locate('CodeFam',Trim(CDS_Article.FieldByName('CodeFam').asString),[]);
      SSF_Nom       := CDS_Famille.FieldByName('LibFam').asString;


      CDS_TVA.Locate('CodeTVA',CDS_Article.FieldByName('CodeTVA').asString,[]);

      for I := 1 to 21 do
        TabCouleur[I] := '';

      I := 2;
      TabCouleur[1] := 'UNICOLOR';

      CDS_CodeBarre.Filtered := False;
      CDS_CodeBarre.Filter := 'RefArt = ''' + CDS_Article.FieldByName('RefArt').asString + '''';
      CDS_CodeBarre.Filtered := True;
      CDS_CodeBarre.First;
      CDS_Couleur.locate('CodeCouleur',CDS_Article.FieldByName('CodeCouleur').asString,[]);

      while (Not CDS_CodeBarre.eof) do
      Begin
        Couleur := CDS_Couleur.Fields[1+CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger].AsString;
        if Couleur = '' then
        begin
          CDS_CodeBarre.Edit;
          CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger := 99;
          CDS_CodeBarre.Post;
        end
        else
        begin
          if not IsInTab(Couleur,TabCouleur) then
          begin
            if I <= 20 then
            begin
              TabCouleur[I] := Couleur;
              Inc(I);
            end
            else
            begin
              CDS_CodeBarre.Edit;
              CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger := 99;
              CDS_CodeBarre.Post;
            end;
          end;
        end;
        CDS_CodeBarre.Next;
      End;

      CDS_CodeBarre.Filtered := False;
      CDS_CodeBarre.Filter := '';

      Add_CSV(ChemImport+'Articles.csv',CDS_Article.FieldByName('num_chrono_art').asString + ';' +
                                        CDS_Article.FieldByName('Codefour').asString + ';' +
                                        CodeTaille + ';' +
                                        CDS_Article.FieldByName('RefArt').asString + ';' +
                                        CDS_Article.FieldByName('LibArtFacture').asString + ';' +
                                        CDS_Article.FieldByName('REF_FOURN').asString + ';' +
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
                                        '1' + ';' +
                                        '' + ';' +
                                        '' + ';' +
                                        CDS_Article.FieldByName('Commentaires').asString + ';' +
                                        '' + ';' +
                                        CDS_TVA.FieldByName('TauxTVA').asString);


      CDS_Taille.Locate('Codetaille',CodeTaille,[]);

      if CodeTaille <> '0' then
        Taille := CDS_Taille.Fields[2].AsString
      else
        Taille := '';

      if Taille = '' then
        Taille := 'UNIQUE';

      Add_CSV(ChemImport+'code_barre.csv',CDS_Article.FieldByName('num_chrono_art').asString + ';' +
                                          Taille + ';' +
                                          TabCouleur[1] + ';' +
                                          CDS_Article.FieldByName('CodBarArt').asString + ';' +
                                          '');

      Inc(Compteur);
      CDS_Article.Next;
    End;
    CDS_Article.Close;
    CDS_Famille.Close;
    CDS_Couleur.Close;
    CDS_TVA.Close;
    CDS_Taille.Close;
    CDS_CodeBarre.Close;
  except on e: Exception do
    ShowMessage('Erreur lors du Traitement des articles avec le message : ' + e.Message);
  end;

  //Traitement des code barre
  LibInfo  := 'Traitement des code barre Taille/Couleur en cours...';
  try
    CDS_Article.Open;
    CDS_Couleur.Open;
    CDS_Taille.Open;
    CDS_CodeBarre.Open;

    CDS_CodeBarre.First;
    NbLigne  := CDS_CodeBarre.RecordCount;
    Compteur := 0;
    while (Not CDS_CodeBarre.eof) and (not stopImport) do
    Begin
      CDS_Article.Locate('RefArt', CDS_CodeBarre.FieldByName('RefArt').AsString,[]);
      CDS_Taille.Locate('Codetaille',CDS_Article.FieldByName('Codetaille').asString,[]);
      CDS_Couleur.locate('CodeCouleur',CDS_Article.FieldByName('CodeCouleur').asString,[]);

      if CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger <> 99 then
        Couleur := CDS_Couleur.Fields[1+CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger].AsString
      else
        Couleur := '';

      if Couleur = '' then
        Couleur := 'UNICOLOR';

      Taille := CDS_Taille.Fields[1+CDS_CodeBarre.FieldByName('LaTaille').AsInteger].AsString;
      if Taille = '' then
        Taille := 'UNIQUE';

      Add_CSV(ChemImport+'code_barre.csv',CDS_Article.FieldByName('num_chrono_art').asString + ';' +
                                          Taille + ';' +
                                          Couleur + ';' +
                                          CDS_CodeBarre.FieldByName('CodeBarre').asString + ';' +
                                          '');
      Inc(Compteur);
      CDS_CodeBarre.Next;
    End;

    CDS_Article.Close;
    CDS_Couleur.Close;
    CDS_Taille.Close;
    CDS_CodeBarre.Close;
  except on e: Exception do
    ShowMessage('Erreur lors du Traitement des code barre avec le message : ' + e.Message);
  end;

  //Traitement des prix
  LibInfo  := 'Traitement des prix en cours...';
  if FileExists(ChemImport+'prix.csv') then
    DeleteFile(ChemImport+'prix.csv');

  try
    CDS_Article.Open;
    CDS_Prix.Open;
    CDS_Taille.Open;
    CDS_Prix.First;
    NbLigne  := CDS_Prix.RecordCount;
    Compteur := 0;
    Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                    'TAILLE;' +
                                    'PXCATALOGUE;' +
                                    'PX_ACHAT;' +
                                    'PX_VENTE;' +
                                    'CODE_FOU;');
    while (Not CDS_Prix.eof) and (not stopImport) do
    Begin
      CDS_Article.Locate('RefArt',CDS_Prix.FieldByName('Lien_Art').asString,[]);

  // A utiliser avec Ciléa Cash3000
  //    if not (MatchStr(Trim(CDS_Prix.FieldByName('Num_TypeCli').AsString), ['HCEE', 'HTTC', 'PERSO', 'ASPIR', 'CLT', 'GUID', 'Alpin'])) then
  //    begin
  //      Add_CSV(ChemImport+'prix.csv',CDS_Article.FieldByName('num_chrono_art').asString + ';' +
  //                                        '0' + ';' +
  //                                        CDS_Prix.FieldByName('prix_acaht_e').asString + ';' +
  //                                        CDS_Prix.FieldByName('prix_acaht_e').asString + ';' +
  //                                        CDS_Prix.FieldByName('prix_ttc2').asString + ';' +
  //                                        '');
  // A utiliser avec Ciléa Cash3000
        Add_CSV(ChemImport+'prix.csv',CDS_Article.FieldByName('num_chrono_art').asString + ';' +
                                          '0' + ';' +
                                          CDS_Prix.FieldByName('PA_HT_Brut').asString + ';' +
                                          CDS_Prix.FieldByName('PA_HT_Net').asString + ';' +
                                          CDS_Prix.FieldByName('PV_TTC').asString + ';' +
                                          '');
  //    end;

      Inc(Compteur);
      CDS_Prix.Next;
    End;
    CDS_Article.Close;
    CDS_Prix.Close;
    CDS_Taille.Close;
    except on e: Exception do
    ShowMessage('Erreur lors du Traitement des prix avec le message : ' + e.Message);
  end;

  //Fermeture des accès BdD et des ClientDataSet
  CDS_Client.Close;
  CDS_Client.Free;
  CDS_Article.Close;
  CDS_Article.Free;
  CDS_Couleur.Close;
  CDS_Couleur.Free;
  CDS_Famille.Close;
  CDS_Famille.Free;
  CDS_Fourn.Close;
  CDS_Fourn.Free;
  CDS_Prix.Close;
  CDS_Prix.Free;
  CDS_Taille.Close;
  CDS_Taille.Free;
  CDS_TVA.Close;
  CDS_TVA.Free;

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
    try
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
    except on e: Exception do
      ShowMessage('Erreur à la ligne : ' + IntToStr(I) + '. Avec le message :' + e.Message);
    end;
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
