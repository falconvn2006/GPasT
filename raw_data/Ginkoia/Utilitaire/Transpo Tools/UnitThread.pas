unit UnitThread;

interface

uses
  DateUtils, DBClient, DB, StrUTils, Variants, StdCtrls, ExtCtrls, Windows,
  //Debut Uses Perso
  uDefs, Math,
  //Fin Uses Perso
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TTranspoThread = class(TThread)
  private
    DoClient,
    DoVente,
    DoLocation  : Boolean;
    TypeTranspo : Integer;
    Log         : TStringList;
    PathExe     : string;
    LogFileName : string;
    procedure CentralControl;
    procedure Traitement;
    procedure TraitementCileaLoc;
    procedure TraitementSportsRental;
    procedure TraitementEasyRent8;
    procedure TraitementEram96;
    procedure TraitementFlexo;
    procedure TraitementBoutiquePlus;
    procedure TraitementBeauteConcept;
    procedure TraitementHusky;
    procedure TraitementL2GI;
    procedure AjouterLog(Texte:String; Err:Boolean = False);
    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
    function LoadDataSet(aMsg:string;aPathFile:string;aCle:string;aCDS:TclientDataSet):Boolean;
  public
    constructor Create(CreateSuspended:boolean);
    procedure SetTypeTranspo(aType:Integer);
    procedure SetDoClient(aValue:Boolean);
    procedure SetDoVente(aValue:Boolean);
    procedure SetDoLocation(aValue:Boolean);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

Type
  TProcedure = procedure;


  Procedure Add_csv(Fichier,Texte:String);

Var
  Compteur      : Integer=0;          //Compte le nombre de matériel traité
  NbLigne       : Integer;            //Nombre de ligne à traité
  StartImport   : Boolean=False;      //Variable de démarrage du traitement
  StopImport    : Boolean=False;      //Interrompt le traitement
  LibInfo       : String;             //Message d'information pour l'utilisateur
  ChemSource    : String;             //Chemin des fichiers sources
  ChemImport    : string;             //Chemin des fichiers créer pour l'import GINKOIA

implementation

uses UnitPrincipale;

constructor TTranspoThread.Create(CreateSuspended:boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := false;
  Priority        := tpHigher;
  Log             := TStringList.Create;
  PathExe         := IncludeTrailingPathDelimiter(ExtractFilePath(application.exename));
  LogFileName     := 'Log_'+IntToStr(yearof(now))+IntToStr(monthof(now))+IntToStr(dayof(now))+'.log';
  DoClient        := True;
  DoVente         := True;
  DoLocation      := True;
end;

destructor TTranspoThread.Destroy;
begin
  FreeAndNil(Log);
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

function TTranspoThread.LoadDataSet(aMsg, aPathFile, aCle: string;
  aCDS: TclientDataSet):Boolean;
begin
  try
    LibInfo   := 'Récupération des informations ' + aMsg + ' en cours...';
    AjouterLog(LibInfo);
    if FileExists(aPathFile) then
    begin
      CSV_To_ClientDataSet(aPathFile,aCDS,aCle);
      Result := True
    end
    else
    begin
      AjouterLog('Le fichier ' + aPathFile + ' n''éxiste pas.', True);
      Result := False;
    end;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors de la récupération des informations ' + aMsg + ' : ' + E.Message, True);
      Result := False;
    end;
  end;
end;

procedure TTranspoThread.SetDoClient(aValue: Boolean);
begin
  DoClient := aValue;
end;

procedure TTranspoThread.SetDoLocation(aValue: Boolean);
begin
  DoLocation := aValue;
end;

procedure TTranspoThread.SetDoVente(aValue: Boolean);
begin
  DoVente := aValue;
end;

procedure TTranspoThread.SetTypeTranspo(aType: Integer);
begin
  TypeTranspo := aType;
end;

procedure TTranspoThread.Traitement;
begin
  case TypeTranspo of
    0 : TraitementSportsRental;
    1 : TraitementCileaLoc;
    2 : TraitementEasyRent8;
    3 : TraitementEram96;
    4 : TraitementFlexo;
    5 : TraitementBoutiquePlus;
    6 : TraitementBeauteConcept;
    7 : TraitementHusky;
    8 : TraitementL2GI;
  end;
end;

procedure TTranspoThread.TraitementEasyRent8;
const
  TranspoEasyRent8 = 'IMPORT-EasyRent8';
  PathEasyRent8 = 'EasyRent8\';

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
var
  I                 : Integer;      //Variable de boucle
  Tmp_SL_Marque     : TStringList;  //String List temporaire pour les Marques
  Tmp_SL_Fourn      : TStringList;  //String List temporaire pour les Fournisseurs
  Tmp_SL_Taille     : TStringList;  //String List temporaire pour les lignes de taille
  Tmp_SL_Article    : TStringList;  //String List temporaire pour les Articles
  Tmp_SL_CodeBarre  : TStringList;  //String List temporaire pour les CodeBarre
  Tmp_SL_Prix       : TStringList;  //String List temporaire pour les Prix
  Tmp_SL            : TStringList;  //String List temporaire
  TabCouleur        : Array [1..20] of String;  //Couleur de l'article
  sCodeArticle      : string;
  sCodeClient       : string;
  sNom_Famille      : string;
  sTaille           : string;
  sMarque           : string;
  sCouleur          : string;
  sFournisseur      : string;
  sRefFourn         : string;
  sCommentaire      : string;
  sDate             : string;
  sPrix             : string;

  CDS_Client    : TclientDataSet;     //Liste des clients
  CDS_Vente     : TClientDataSet;     //Liste des article de vente
  CDS_Location  : TClientDataSet;     //Liste des article de Location
  CDS_Stocks    : TClientDataSet;     //Liste des Stocks
Begin
  {$REGION 'EasyRent8'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement EasyRent 8');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathEasyRent8;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Client      := TClientDataSet.Create(nil);
    CDS_Vente       := TClientDataSet.Create(nil);
    CDS_Location    := TClientDataSet.Create(nil);
    CDS_Stocks      := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoClient then
    begin
      if not LoadDataSet('clients',ChemSource+'Kundenliste.csv','Code',CDS_Client) then
        Exit;
    end;

    if DoVente then
    begin
      if not LoadDataSet('articles de vente',ChemSource+'Article de vente.csv','Code',CDS_Vente) then
        Exit;
      if not LoadDataSet('stocks',ChemSource+'Stock.csv','Code_de_l''article',CDS_Stocks) then
        Exit;
    end;

    if DoLocation then
    begin
      if not LoadDataSet('articles de location',ChemSource+'Article de location.csv','Code_article',CDS_Location) then
        Exit;
    end;

    if DoClient then
    begin
      //Traitement des clients
      try
        LibInfo  := 'Traitement des clients en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'clients.csv') then
          DeleteFile(ChemImport+'clients.csv');

        CDS_Client.First;
        NbLigne  := CDS_Client.RecordCount;
        Compteur := 0;
        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.Add('CODE;' +
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
            sCodeClient := CDS_Client.FieldByName('Code').asString;
            sNom_Famille := CDS_Client.FieldByName('Nom_de_famille').asString;
            if (sCodeClient <> '')
              and (CDS_Client.FieldByName('Nom_de_famille').asString <> '') then

              Tmp_SL.Add(sCodeClient + ';' +                                        //CODE
                         'PART' + ';' +                                             //Type
                         sNom_Famille + ';' +                                       //Nom
                         CDS_Client.FieldByName('Prénom').asString + ';' +          //Prénom
                         '' + ';' +                                                 //Civilité
                         CDS_Client.FieldByName('Adresse').asString + ';' +         //Adresse 1
                         CDS_Client.FieldByName('Adresse_2').asString + ';' +       //Adresse 2
                         '' + ';' +                                                 //Adresse 3
                         CDS_Client.FieldByName('Code_postal').asString + ';' +     //Code postal
                         CDS_Client.FieldByName('Lieu').asString + ';' +            //Ville
                         CDS_Client.FieldByName('Pays').asString + ';' +            //Pays
                         '' + ';' +                                                 //Code comptable
                         CDS_Client.FieldByName('Remarque').asString + ';' +        //Commentaire
                         CDS_Client.FieldByName('Téléphone').asString + ';' +       //Téléphone
                         CDS_Client.FieldByName('Fax').asString + ';' +             //FAX
                         CDS_Client.FieldByName('Portable').asString + ';' +        //Portable
                         CDS_Client.FieldByName('E-mail').asString + ';' +          //E-Mail
                         '' + ';' +                                                 //Code Barre national
                         '' + ';' +                                                 //Class 1
                         '' + ';' +                                                 //Class 2
                         '' + ';' +                                                 //Class 3
                         '' + ';' +                                                 //Class 4
                         '' + ';' +                                                 //Class 5
                         '');                                                       //Numéro
            Inc(Compteur);
            AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
            CDS_Client.Next;
          End;
        finally
          Tmp_SL.SaveToFile(ChemImport+'clients.csv');
          FreeAndNil(Tmp_SL);
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des clients : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoVente then
    begin
      //Traitement des grilles de taille
      try
        LibInfo  := 'Traitement des grilles de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille.csv') then
          DeleteFile(ChemImport+'gr_taille.csv');

        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.Add('CODE;NOM;TYPE_GRILLE');
          Tmp_SL.Add('0;UNIQUE;TranspoEasyRent8');
        finally
          Tmp_SL.SaveToFile(ChemImport+'gr_taille.csv');
          FreeAndNil(Tmp_SL);
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des fourniseurs, des marques et des lignes de taille
      try
        LibInfo  := 'Traitement des fournisseurs, des marques et des lignes de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'fourn.csv') then
          DeleteFile(ChemImport+'fourn.csv');

        if FileExists(ChemImport+'marque.csv') then
          DeleteFile(ChemImport+'marque.csv');

        if FileExists(ChemImport+'gr_taille_lig.csv') then
          DeleteFile(ChemImport+'gr_taille_lig.csv');

        CDS_Vente.Filtered  := False;
        CDS_Vente.Filter    := 'Actif = ' + QuotedStr('oui') +
                               ' AND Stock <> ' + QuotedStr('');
        CDS_Vente.Filtered  := True;
        CDS_Vente.First;

        NbLigne  := CDS_Vente.RecordCount;
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
        Add_CSV(ChemImport+'fourn.csv'  ,TranspoEasyRent8 + ';' +
                                         TranspoEasyRent8+ ';' +
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
                                         '');

        Add_CSV(ChemImport+'marque.csv' ,'CODE;' +
                                         'CODE_FOU;' +
                                         'NOM');
        Add_CSV(ChemImport+'marque.csv' ,TranspoEasyRent8 + ';' +
                                         TranspoEasyRent8 + ';' +
                                         TranspoEasyRent8);

        Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                               'UNIQUE');

        Tmp_SL_Fourn := TStringList.Create;
        Tmp_SL_Marque := TStringList.Create;
        Tmp_SL_Taille := TStringList.Create;
        try
          while (Not CDS_Vente.eof) and (not stopImport) do
          begin
            //Fournisseurs
            sFournisseur := CDS_Vente.FieldByName('Fournisseur_').asString;
            if (not Tmp_SL_Fourn.Find(sFournisseur,I))
              and (sFournisseur <> '-') then
            begin
              Add_CSV(ChemImport+'fourn.csv', sFournisseur + ';' +
                                              sFournisseur + ';' +
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
                                              '');
              Tmp_SL_Fourn.Add(sFournisseur);
              Tmp_SL_Fourn.Sort;
            end
            else
              sFournisseur := TranspoEasyRent8;

            //Marques
            sMarque := CDS_Vente.FieldByName('Marque').asString;
            if not Tmp_SL_Marque.Find(sMarque,I) and (sMarque <> '') then
            begin
              Add_CSV(ChemImport+'marque.csv',sMarque + ';' +
                                              sFournisseur + ';' +
                                              sMarque);
              Tmp_SL_Marque.Add(sMarque);
              Tmp_SL_Marque.Sort;
            end;

            //lignes de taille
            if (CDS_Vente.FieldByName('Type_1').asString <> '')
              and (not Tmp_SL_Taille.Find(CDS_Vente.FieldByName('Type_1').asString,I)) then
            begin
              Add_CSV(ChemImport+'gr_taille_lig.csv', '0'+ ';' +
                                                      CDS_Vente.FieldByName('Type_1').asString);
              Tmp_SL_Taille.Add(CDS_Vente.FieldByName('Type_1').asString);
              Tmp_SL_Taille.Sort;
            end;

            Inc(Compteur);
            AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
            CDS_Vente.Next;
          end;
        finally
          FreeAndNil(Tmp_SL_Fourn);
          FreeAndNil(Tmp_SL_Marque);
          FreeAndNil(Tmp_SL_Taille);
        end;

        //Tri des ligne de taille
        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.LoadFromFile(ChemImport+'gr_taille_lig.csv');
          Tmp_SL.Sort;
          Tmp_SL.Insert(0,'CODE_GT;NOM');
          Tmp_SL.SaveToFile(ChemImport+'gr_taille_lig.csv');
        finally
          FreeAndNil(Tmp_SL);
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des fournisseurs, des marques et des lignes de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des articles de vente
      try
        LibInfo  := 'Traitement des articles de vente en cours...';
        if FileExists(ChemImport+'Articles.csv') then
          DeleteFile(ChemImport+'Articles.csv');

        if FileExists(ChemImport+'code_barre.csv') then
          DeleteFile(ChemImport+'code_barre.csv');

        if FileExists(ChemImport+'prix.csv') then
          DeleteFile(ChemImport+'prix.csv');


        CDS_Vente.Filtered  := False;
        CDS_Vente.Filter    := 'Actif = ' + QuotedStr('oui') +
                               ' AND Stock <> ' + QuotedStr('');
        CDS_Vente.Filtered  := True;
        CDS_Vente.First;
        NbLigne  := CDS_Vente.RecordCount;
        Compteur := 0;

        Tmp_SL_Article    := TStringList.Create;
        Tmp_SL_CodeBarre  := TStringList.Create;
        Tmp_SL_Prix       := TStringList.Create;
        try
            Tmp_SL_Article.Add( 'CODE;' +
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
                                'TVA');

          Tmp_SL_CodeBarre.Add('CODE_ART;TAILLE;COULEUR;EAN;QTTE');
          Tmp_SL_Prix.Add('CODE_ART;TAILLE;PXCATALOGUE;PX_ACHAT;PX_VENTE;CODE_FOU');

          while (Not CDS_Vente.eof) and (not stopImport) do
          begin
            sCodeArticle := CDS_Vente.FieldByName('Code').AsString;
            sMarque := CDS_Vente.FieldByName('Marque').asString;
            sFournisseur := CDS_Vente.FieldByName('Ref._Fourn.').asString;
            if Copy(sCodeArticle, 1, 1) = 'T' then
            begin
              CDS_Vente.Filtered  := False;
              CDS_Vente.Filter    := 'Actif = ' + QuotedStr('oui') +
                                     ' AND Stock <> ' + QuotedStr('') +
                                     ' AND Marque = ' + QuotedStr(sMarque) +
                                     ' AND Ref._Fourn. = ' + QuotedStr(sFournisseur) +
                                     ' AND Code Like ' + QuotedStr(Copy(sCodeArticle, 1, (Length(sCodeArticle)-4)) + '%');
              CDS_Vente.Filtered  := True;
              CDS_Vente.First;
            end
            else
            begin
              CDS_Vente.Filtered  := False;
              CDS_Vente.Filter    := 'Actif = ' + QuotedStr('oui') +
                                     ' AND Stock <> ' + QuotedStr('') +
                                     ' AND Code = ' + QuotedStr(sCodeArticle);
              CDS_Vente.Filtered  := True;
              CDS_Vente.First;
            end;

            //Gestion de la marque.
            if CDS_Vente.FieldByName('Marque').asString = '' then
              sMarque := TranspoEasyRent8
            else
              sMarque := CDS_Vente.FieldByName('Marque').asString;

            //Gestion des Couleurs
            for I := 1 to 21 do
              TabCouleur[I] := '';

            I := 1;
            TabCouleur[1] := 'UNICOLOR';

            While (Not CDS_Vente.eof) AND (I < 20) do
            Begin
              if CDS_Vente.FieldByName('Type_2').asString <> '' then
                if not FindCouleur(CDS_Vente.FieldByName('Type_2').asString, TabCouleur) then
                begin
                  TabCouleur[I] := CDS_Vente.FieldByName('Type_2').asString;
                  inc(I);
                end;
              CDS_Vente.Next;
            End;

            if not CDS_Stocks.Locate('Code_de_l''article',sCodeArticle,[]) then
              sDate := '01/01/1980'
            else
              sDate := StringReplace(CDS_Stocks.FieldByName('Dernière_entrée').AsString, '.', '/', [rfReplaceAll]);

            CDS_Vente.First;

            Tmp_SL_Article.Add( sCodeArticle + ';' +                                      //CODE
                                sMarque + ';' +                                           //CODE_MRQ
                                '0' + ';' +                                               //CODE_GT
                                sFournisseur + ';' +                                      //CODE_FOURN
                                CDS_Vente.FieldByName('Dénomination').AsString + ';' +    //NOM
                                '' + ';' +                                                //DESCRIPTION
                                TranspoEasyRent8 + ';' +                                  //RAYON
                                TranspoEasyRent8 + ';' +                                  //FAMILLE
                                CDS_Vente.FieldByName('Groupe_produit').AsString + ';' +  //SS_FAM
                                '' + ';' +                                                //GENRE
                                '' + ';' +                                                //CLASS1
                                '' + ';' +                                                //CLASS2
                                '' + ';' +                                                //CLASS3
                                '' + ';' +                                                //CLASS4
                                '' + ';' +                                                //CLASS5
                                '' + ';' +                                                //IDREF_SSFAM
                                TabCouleur[1] + ';' +                                     //COUL1
                                TabCouleur[2] + ';' +                                     //COUL2
                                TabCouleur[3] + ';' +                                     //COUL3
                                TabCouleur[4] + ';' +                                     //COUL4
                                TabCouleur[5] + ';' +                                     //COUL5
                                TabCouleur[6] + ';' +                                     //COUL6
                                TabCouleur[7] + ';' +                                     //COUL7
                                TabCouleur[8] + ';' +                                     //COUL8
                                TabCouleur[9] + ';' +                                     //COUL9
                                TabCouleur[10] + ';' +                                    //COUL10
                                TabCouleur[11] + ';' +                                    //COUL11
                                TabCouleur[12] + ';' +                                    //COUL12
                                TabCouleur[13] + ';' +                                    //COUL13
                                TabCouleur[14] + ';' +                                    //COUL14
                                TabCouleur[15] + ';' +                                    //COUL15
                                TabCouleur[16] + ';' +                                    //COUL16
                                TabCouleur[17] + ';' +                                    //COUL17
                                TabCouleur[18] + ';' +                                    //COUL18
                                TabCouleur[19] + ';' +                                    //COUL19
                                TabCouleur[20] + ';' +                                    //COUL20
                                '1' + ';' +                                               //FIDELITE
                                sDate + ';' +                                             //DATECREATION
                                CDS_Vente.FieldByName('saison').AsString + ';' +          //COLLECTION
                                '' + ';' +                                                //COMENT1
                                '' + ';' +                                                //COMENT2
                                '19.6');                                                  //TVA

            while (Not CDS_Vente.eof) do
            begin
              //Gestion Taille
              if CDS_Vente.FieldByName('Type_1').asString = '' then
                sTaille := 'UNIQUE'
              else
              begin
                sTaille := CDS_Vente.FieldByName('Type_1').AsString;
              end;

              //Gestion Couleur
              if CDS_Vente.FieldByName('Type_2').asString = '' then
                sCouleur := 'UNICOLOR'
              else
                sCouleur := CDS_Vente.FieldByName('Type_2').asString;

              //Gestion du du prix
              if not CDS_Stocks.Locate('Code_de_l''article',CDS_Vente.FieldByName('Code').AsString,[]) then
                sPrix := StringReplace(CDS_Vente.FieldByName('Prix_d''achat').asString, '.', ',', [rfReplaceAll])
              else
              begin
                if (CDS_Stocks.FieldByName('Prix_d''achat_moyen').AsString <> '')
                  and (CDS_Stocks.FieldByName('Prix_d''achat_moyen').AsString <> '0.00') then
                begin
                  sPrix := StringReplace(CDS_Stocks.FieldByName('Prix_d''achat_moyen').asString, '.', ',', [rfReplaceAll]);
                end
                else
                  sPrix := StringReplace(CDS_Stocks.FieldByName('Dernier_achat').asString, '.', ',', [rfReplaceAll]);
              end;


              Tmp_SL := TStringList.Create;
              try
                if CDS_Vente.FieldByName('Gencod').asString <> '' then
                begin
                  Tmp_SL.Text := StringReplace(CDS_Vente.FieldByName('Gencod').asString, ',', #13#10, [rfReplaceAll]);

                  for I := 0 to Tmp_SL.Count -1 do
                  begin
                    Tmp_SL_CodeBarre.Add(sCodeArticle + ';' +
                                         sTaille + ';' +
                                         sCouleur + ';' +
                                         Copy(Tmp_SL.Strings[I], 1, 64) + ';' +
                                         '0');
                  end;
                end;

                Tmp_SL_CodeBarre.Add(sCodeArticle + ';' +
                                     sTaille + ';' +
                                     sCouleur + ';' +
                                     CDS_Vente.FieldByName('Code').AsString + ';' +
                                     '0');
              finally
                FreeAndNil(Tmp_SL);
              end;

              Tmp_SL_Prix.Add(sCodeArticle + ';' +
                              sTaille + ';' +
                              sPrix + ';' +
                              sPrix + ';' +
                              StringReplace(CDS_Vente.FieldByName('Prix_de_vente').asString, '.', ',', [rfReplaceAll]) + ';' +
                              sFournisseur);
              Inc(Compteur);
              CDS_Vente.Edit;
              CDS_Vente.Delete;
            end;

            CDS_Vente.Filtered  := False;
            CDS_Vente.Filter    := 'Actif = ' + QuotedStr('oui') +
                                   ' AND Stock <> ' + QuotedStr('');
            CDS_Vente.Filtered  := True;
            CDS_Vente.First;
          end;
        finally
          Tmp_SL_Article.SaveToFile(ChemImport+'Articles.csv');
          Tmp_SL_CodeBarre.SaveToFile(ChemImport+'code_barre.csv');
          Tmp_SL_Prix.SaveToFile(ChemImport+'prix.csv');
          FreeAndNil(Tmp_SL_Article);
          FreeAndNil(Tmp_SL_CodeBarre);
          FreeAndNil(Tmp_SL_Prix);
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoLocation then
    begin
      //Traitement des articles de location
      try
        LibInfo  := 'Traitement des articles de location en cours...';
        if FileExists(ChemImport+'Loc\'+'Articles.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles.csv');

        CDS_Location.Filtered := False;
        CDS_Location.Filter := 'Statut = ''OK''';
        CDS_Location.Filtered := True;
        CDS_Location.First;
        CDS_Location.First;
        NbLigne  := CDS_Location.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT');
        while (Not CDS_Location.eof) and (not stopImport) do
        Begin
          //Gestion du code marque
          if CDS_Location.FieldByName('Marques').asString = '' then
            sMarque := TranspoEasyRent8
          else
            sMarque := CDS_Location.FieldByName('Marques').asString;

          //Gestion des Tailles
          if CDS_Location.FieldByName('Prop.1').asString = '' then
            sTaille := 'UNIQUE'
          else
          begin
            sTaille := CDS_Location.FieldByName('Prop.1').AsString;
          end;

          //Gestion du commentaire
          sCommentaire := 'Vente/jour : ' + CDS_Location.FieldByName('Groupe_de_location').asString + ' - ' +
                          'Profit : ' + CDS_Location.FieldByName('Profit').asString + ' - ' +
                          'Prop.2 : ' + CDS_Location.FieldByName('Prop.2').asString;

          //Gestion des dates
          if CDS_Location.FieldByName('Annexe').asString = '' then
            sDate := '01/01/1980'
          else
            sDate := StringReplace(CDS_Location.FieldByName('Annexe').asString, '.', '/', [rfReplaceAll]);

          Add_CSV(ChemImport+'Loc\'+'Articles.csv', CDS_Location.FieldByName('Code_article').asString + ';' +
                                                    CDS_Location.FieldByName('Dénomination').asString + ';' +
                                                    '' + ';' +
                                                    '' + ';' +
                                                    CDS_Location.FieldByName('Groupe_de_location').asString + ';' +
                                                    sCommentaire + ';' +
                                                    sMarque + ';' +
                                                    TranspoEasyRent8 + ';' +
                                                    sTaille + ';' +
                                                    CDS_Location.FieldByName('Code_article').asString + ';' +
                                                    '' + ';' +
                                                    '' + ';' +
                                                    '' + ';' +
                                                    'LOCATION' + ';' +
                                                    sDate + ';' +
                                                    StringReplace(CDS_Location.FieldByName('Ach').AsString, '.', ',', [rfReplaceAll]) + ';' +
                                                    StringReplace(CDS_Location.FieldByName('Vte').AsString, '.', ',', [rfReplaceAll]) + ';' +
                                                    '' + ';' +
                                                    '' + ';' +
                                                    '3' + ';' +
                                                    'N' + ';' +
                                                    'N' + ';' +
                                                    '' + ';' +
                                                    '');

          Inc(Compteur);

          CDS_Location.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_Client.Close;
    CDS_Vente.Close;
    CDS_Location.Close;

    FreeAndNil(CDS_Client);
    FreeAndNil(CDS_Vente);
    FreeAndNil(CDS_Location);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
end;

procedure TTranspoThread.TraitementEram96;
Const
  TranspoEram96 = 'IMPORT-Eram96';
  PathEram96 = 'Eram96\';

  function GetHeader(aTab:array of string):string;
  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;

  function GetCheckDigit(Barcode:String):String;
  var
    I,SumOdd,SumEven,Tot:Integer;
  begin
    SumOdd := 0;
    SumEven := 0;
    for I := 1 to length(Barcode) do
    begin
      if Odd(I) then
        SumOdd := SumOdd + StrToInt(Copy(Barcode,I,1))
      else
        SumEven := SumEven + StrToInt(Copy(Barcode,I,1));
    end;
    Tot := ( (SumOdd*3) + SumEven );
    if Tot mod 10 = 0 then
      Tot := 0
    else
      Tot := 10 - (Tot mod 10);
    Result := Trim(IntToStr(Tot));
  end;

  function MakeCodeBarre(aRef:string;aRefCB:string;aCodeTaille:string):string;
  var
    tmp : string;
  begin
    if StrToInt(Copy(aRef, 1, 2)) in [10, 11, 12, 14, 15] then
    begin
      if Length(aRefCB) = 5 then
      begin
        tmp := '2001' + aRefCB + aCodeTaille;
        Result := tmp + GetCheckDigit(tmp);
      end
      else
        if Length(aRefCB) = 7 then
        begin
          tmp := '20' + aRefCB + aCodeTaille;
          Result := tmp + GetCheckDigit(tmp);
        end
        else
          Result := '';
    end
    else
      if StrToInt(Copy(aRef, 1, 2)) in [30, 36] then
      begin
        if Length(aRefCB) = 5 then
        begin
          tmp := '2000' + aRefCB + aCodeTaille;
          Result := tmp + GetCheckDigit(tmp);
        end
        else
          if Length(aRefCB) = 7 then
          begin
            tmp := '20' + aRefCB + aCodeTaille;
            Result := tmp + GetCheckDigit(tmp);
          end
          else
            Result := '';
      end
      else
        if StrToInt(Copy(aRef, 1, 2)) in [40, 42] then
        begin
          if Length(aRefCB) = 6 then
          begin
            tmp := '206' + aRefCB + aCodeTaille;
            Result := tmp + GetCheckDigit(tmp);
          end
          else
            if Length(aRefCB) = 7 then
            begin
              tmp := '20' + aRefCB + aCodeTaille;
              Result := tmp + GetCheckDigit(tmp);
            end
            else
              Result := '';
        end
        else
          if StrToInt(Copy(aRef, 1, 2)) in [61, 62, 65, 68] then
          begin
            if Length(aRefCB) = 7 then
            begin
              tmp := '330767' + aRefCB + aCodeTaille;
              Result := tmp + GetCheckDigit(tmp);
            end
            else
              Result := '';
          end
          else
          begin
            if Length(aRefCB) = 7 then
            begin
              tmp := '27' + aRefCB + aCodeTaille;
              Result := tmp + GetCheckDigit(tmp);
            end
            else
              if Length(aRefCB) = 6 then
              begin
                tmp := '26' + aRefCB + aCodeTaille + '0';
                Result := tmp + GetCheckDigit(tmp);
              end
              else
                if Length(aRefCB) = 5 then
                begin
                  tmp := '25' + aRefCB + aCodeTaille + '00';
                  Result := tmp + GetCheckDigit(tmp);
                end
                else
                  Result := '';
          end;
  end;
Var
  TmpCompteur   : Integer;
  TmpNbLigne    : Integer;
  I             : Integer;                  //Variable de boucle
  TabCouleur    : Array [1..20] of String;  //Couleur de l'article
  Tmp_SL,                                   //String List temporaire
  Tmp_PA00nnn,                              //String List pour le traitement du fichier PA00nnn
  Tmp_SERVICE,
  Tmp_SERIE,
  Tmp_SAISON,
  Tmp_FAMILLE,
  Tmp_COULEUR,
  Tmp_ECHELLE,
  Tmp_FOURNISSEUR,
  Tmp_AUTRES      : TStringList;
  sPathTM00nnn  : string;                   //Path du fichier TM00nnn
  sPathUMxxnnn  : string;                   //Path du fichier UMxxnnn
  sPathPA00nnn  : string;                   //Path du fichier PA00nnn
  sCodeTaille   : string;
  sTaille       : string;
  sMarque       : string;
  sCouleur      : string;
  sFournisseur  : string;
  sRayon        : string;
  sFamille      : string;
  sSSFamille    : string;
  sSaison       : string;
  sCodeArticle  : string;
  sRefCodeBarre : string;
  sDate         : string;
  sDateCreation : string;
  bExitTaille   : Boolean;            //Variable pour la sortie de la boucle de taille.

  CDS_TM00nnn,                        //Fichier stocks tous magasins
  CDS_UMxxnnn,                        //Fichier stock magasin
  CDS_SERVICE,                        //Fichier Rayon
  CDS_SERIE,                          //Fichier Famille
  CDS_SAISON,                         //Fichier Collection
  CDS_FAMILLE,                        //Fichier Sous-Famille
  CDS_COULEUR,                        //Fichier Couleur
  CDS_ECHELLE,                        //Fichier Taille
  CDS_FOURNISSEUR : TClientDataSet;   //Liste des fournisseurs
Begin
  {$REGION 'Eram96'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Eram96');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathEram96;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_TM00nnn     := TClientDataSet.Create(nil);
    CDS_UMxxnnn     := TClientDataSet.Create(nil);
    CDS_SERVICE     := TClientDataSet.Create(nil);
    CDS_SERIE       := TClientDataSet.Create(nil);
    CDS_SAISON      := TClientDataSet.Create(nil);
    CDS_FAMILLE     := TClientDataSet.Create(nil);
    CDS_COULEUR     := TClientDataSet.Create(nil);
    CDS_ECHELLE     := TClientDataSet.Create(nil);
    CDS_FOURNISSEUR := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoVente then
    begin
      sPathTM00nnn := ChemSource + 'TM00' + Frm_Principale.GetQuantieme + '.txt';
      if FileExists(sPathTM00nnn) then
      begin
        if Frm_Principale.GetAddHeader then   //On ajoute les en-tête
        begin
          Tmp_SL := TStringList.Create;
          try
            Tmp_SL.LoadFromFile(sPathTM00nnn);      //Chargement du fichier
            Tmp_SL.Insert(0,GetHeader(TM00nnn_COL));          //Ajout de l'en-tête
            Tmp_SL.SaveToFile(sPathTM00nnn);        //Enregistrement du fichier
          finally
            FreeAndNil(Tmp_SL);
          end;
        end;
        if not LoadDataSet('TM00nnn',sPathTM00nnn,'REFERENCE',CDS_TM00nnn) then
          Exit;
      end
      else
      begin
        AjouterLog('Le fichier ' + sPathTM00nnn + ' n''éxiste pas.', True);
        Exit;
      end;

      sPathUMxxnnn := ChemSource+'UM' + Frm_Principale.GetNumMagasin + Frm_Principale.GetQuantieme + '.txt';
      if FileExists(sPathUMxxnnn) then
      begin
        if Frm_Principale.GetAddHeader then   //On ajoute les en-tête
        begin
          Tmp_SL := TStringList.Create;
          try
            Tmp_SL.LoadFromFile(sPathUMxxnnn);      //Chargement du fichier
            Tmp_SL.Insert(0,GetHeader(UMxxnnn_COL));          //Ajout de l'en-tête
            Tmp_SL.SaveToFile(sPathUMxxnnn);        //Enregistrement du fichier
          finally
            FreeAndNil(Tmp_SL);
          end;
        end;
        if not LoadDataSet('UMxxnnn',sPathUMxxnnn,'REFERENCE',CDS_UMxxnnn) then
          Exit;
      end
      else
      begin
        AjouterLog('Le fichier ' + sPathUMxxnnn + ' n''éxiste pas.', True);
        Exit;
      end;

      sPathPA00nnn := ChemSource+'PA00' + Frm_Principale.GetQuantieme + '.txt';
      if FileExists(sPathPA00nnn) then
      begin
        if FileExists(ChemImport+'SERVICE.txt') then
          DeleteFile(ChemImport+'SERVICE.txt');
        if FileExists(ChemImport+'SERIE.txt') then
          DeleteFile(ChemImport+'SERIE.txt');
        if FileExists(ChemImport+'SAISON.txt') then
          DeleteFile(ChemImport+'SAISON.txt');
        if FileExists(ChemImport+'FAMILLE.txt') then
          DeleteFile(ChemImport+'FAMILLE.txt');
        if FileExists(ChemImport+'COULEUR.txt') then
          DeleteFile(ChemImport+'COULEUR.txt');
        if FileExists(ChemImport+'ECHELLE.txt') then
          DeleteFile(ChemImport+'ECHELLE.txt');
        if FileExists(ChemImport+'FOURNISSEUR.txt') then
          DeleteFile(ChemImport+'FOURNISSEUR.txt');
        if FileExists(ChemImport+'AUTRES.txt') then
          DeleteFile(ChemImport+'AUTRES.txt');

        Tmp_PA00nnn     := TStringList.Create;
        Tmp_SERVICE     := TStringList.Create;
        Tmp_SERIE       := TStringList.Create;
        Tmp_SAISON      := TStringList.Create;
        Tmp_FAMILLE     := TStringList.Create;
        Tmp_COULEUR     := TStringList.Create;
        Tmp_ECHELLE     := TStringList.Create;
        Tmp_FOURNISSEUR := TStringList.Create;
        Tmp_AUTRES      := TStringList.Create;
        try
          Tmp_PA00nnn.LoadFromFile(sPathPA00nnn);      //Chargement du fichier

          Tmp_SERVICE.Add(GetHeader(PA00nnn_SERVICE_COL));
          Tmp_SERIE.Add(GetHeader(PA00nnn_SERIE_COL));
          Tmp_SAISON.Add(GetHeader(PA00nnn_SAISON_COL));
          Tmp_FAMILLE.Add(GetHeader(PA00nnn_FAMILLE_COL));
          Tmp_COULEUR.Add(GetHeader(PA00nnn_COULEUR_COL));
          Tmp_ECHELLE.Add(GetHeader(PA00nnn_ECHELLE_COL));
          Tmp_FOURNISSEUR.Add(GetHeader(PA00nnn_FOURNISSEUR_COL));

          for I := 0 to Tmp_PA00nnn.Count - 1 do
          begin
            if Pos('SERVICE;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
              Tmp_SERVICE.Add(Tmp_PA00nnn.Strings[I])
            else
              if Pos('SERIE;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                Tmp_SERIE.Add(Tmp_PA00nnn.Strings[I])
              else
                if Pos('SAISON;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                  Tmp_SAISON.Add(Tmp_PA00nnn.Strings[I])
                else
                  if Pos('FAMILLE;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                    Tmp_FAMILLE.Add(Tmp_PA00nnn.Strings[I])
                  else
                    if Pos('COULEUR;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                      Tmp_COULEUR.Add(Tmp_PA00nnn.Strings[I])
                    else
                      if Pos('FOURNISSEUR;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                          Tmp_FOURNISSEUR.Add(Tmp_PA00nnn.Strings[I])
                        else
                          if Pos('ECHELLE;',UpperCase(Tmp_PA00nnn.Strings[I])) <> 0 then
                            Tmp_ECHELLE.Add(Tmp_PA00nnn.Strings[I])
                          else
                            Tmp_AUTRES.Add(Tmp_PA00nnn.Strings[I]);
          end;
        finally
          Tmp_SERVICE.SaveToFile(ChemSource + 'SERVICE.txt');
          Tmp_SERIE.SaveToFile(ChemSource + 'SERIE.txt');
          Tmp_SAISON.SaveToFile(ChemSource + 'SAISON.txt');
          Tmp_FAMILLE.SaveToFile(ChemSource + 'FAMILLE.txt');
          Tmp_COULEUR.SaveToFile(ChemSource + 'COULEUR.txt');
          Tmp_ECHELLE.SaveToFile(ChemSource + 'ECHELLE.txt');
          Tmp_FOURNISSEUR.SaveToFile(ChemSource + 'FOURNISSEUR.txt');
          Tmp_AUTRES.SaveToFile(ChemSource + 'AUTRES.txt');
          FreeAndNil(Tmp_PA00nnn);
          FreeAndNil(Tmp_SERVICE);
          FreeAndNil(Tmp_SERIE);
          FreeAndNil(Tmp_SAISON);
          FreeAndNil(Tmp_FAMILLE);
          FreeAndNil(Tmp_ECHELLE);
          FreeAndNil(Tmp_FOURNISSEUR);
          FreeAndNil(Tmp_AUTRES);
        end;
        if not LoadDataSet('SERVICE',ChemSource + 'SERVICE.txt','NUMERO',CDS_SERVICE) then
          Exit;
        if not LoadDataSet('SERIE',ChemSource + 'SERIE.txt','NUMERO',CDS_SERIE) then
          Exit;
        if not LoadDataSet('SAISON',ChemSource + 'SAISON.txt','NUMERO',CDS_SAISON) then
          Exit;
        if not LoadDataSet('FAMILLE',ChemSource + 'FAMILLE.txt','NUMERO',CDS_FAMILLE) then
          Exit;
        if not LoadDataSet('COULEUR',ChemSource + 'COULEUR.txt','NUMERO',CDS_COULEUR) then
          Exit;
        if not LoadDataSet('ECHELLE',ChemSource + 'ECHELLE.txt','NUMERO',CDS_ECHELLE) then
          Exit;
        if not LoadDataSet('FOURNISSEUR',ChemSource + 'FOURNISSEUR.txt','NUMERO',CDS_FOURNISSEUR) then
          Exit;
      end
      else
      begin
        AjouterLog('Le fichier ' + sPathPA00nnn + ' n''éxiste pas.', True);
        Exit;
      end;

    end;

    if DoVente then
    begin
      //Traitement des fourniseurs
      try
        LibInfo  := 'Traitement des fournisseurs en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'fourn.csv') then
          DeleteFile(ChemImport+'fourn.csv');

        CDS_FOURNISSEUR.First;
        NbLigne  := CDS_FOURNISSEUR.RecordCount;
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

        Add_CSV(ChemImport+'fourn.csv'  ,TranspoEram96 + ';' +
                                         TranspoEram96+ ';' +
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
                                         '');

        while (Not CDS_FOURNISSEUR.eof) and (not stopImport) do
        begin
          Add_CSV(ChemImport+'fourn.csv',CDS_FOURNISSEUR.FieldByName('NUMERO').asString + ';' +
                                         CDS_FOURNISSEUR.FieldByName('NOM').asString + ';' +
                                         CDS_FOURNISSEUR.FieldByName('ADRESSE').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         CDS_FOURNISSEUR.FieldByName('CODE_POSTAL').asString + ';' +
                                         CDS_FOURNISSEUR.FieldByName('VILLE').asString + ';' +
                                         '' + ';' +
                                         CDS_FOURNISSEUR.FieldByName('TELEPHONE').asString + ';' +
                                         CDS_FOURNISSEUR.FieldByName('FAX').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         CDS_FOURNISSEUR.FieldByName('REPRESENTANT').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         '');
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_FOURNISSEUR.Next;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des fournisseurs : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des marques
      try
        LibInfo  := 'Traitement des marques en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'marque.csv') then
          DeleteFile(ChemImport+'marque.csv');

        CDS_FOURNISSEUR.First;
        NbLigne  := CDS_FOURNISSEUR.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'marque.csv' ,'CODE;' +
                                         'CODE_FOU;' +
                                         'NOM');
        Add_CSV(ChemImport+'marque.csv' ,TranspoEram96 + ';' +
                                         TranspoEram96 + ';' +
                                         TranspoEram96);
        while Not (CDS_FOURNISSEUR.eof) and (not stopImport) do
        begin
          Add_CSV(ChemImport+'marque.csv',CDS_FOURNISSEUR.FieldByName('NUMERO').asString + ';' +
                                          CDS_FOURNISSEUR.FieldByName('NUMERO').asString + ';' +
                                          CDS_FOURNISSEUR.FieldByName('NOM').asString);
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_FOURNISSEUR.Next;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des marques : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des grilles de taille
      try
        LibInfo  := 'Traitement des grilles de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille.csv') then
          DeleteFile(ChemImport+'gr_taille.csv');

        CDS_ECHELLE.First;
        NbLigne  := CDS_ECHELLE.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                             'NOM;' +
                                             'TYPE_GRILLE');
        Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +
                                           'UNIQUE' + ';' +
                                           TranspoEram96);

        while (Not CDS_ECHELLE.eof) and (not stopImport) do
        Begin
          Add_CSV(ChemImport+'gr_taille.csv',CDS_ECHELLE.FieldByName('NUMERO').asString + ';' +
                                             CDS_ECHELLE.FieldByName('LIBELLE_ECHELLE').asString + ';' +
                                             TranspoEram96);
              Inc(Compteur);
              CDS_ECHELLE.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des lignes de taille
      try
        LibInfo  := 'Traitement des lignes de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille_lig.csv') then
          DeleteFile(ChemImport+'gr_taille_lig.csv');

        CDS_ECHELLE.First;
        NbLigne  := CDS_ECHELLE.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +
                                               'NOM');
        Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                               'UNIQUE');
        while (Not CDS_ECHELLE.eof) and (not stopImport) do
        Begin
          for I := 43 to 61 do
          Begin
            if (Trim(CDS_ECHELLE.Fields[I].AsString) <> '') then
            Begin
              Add_CSV(ChemImport+'gr_taille_lig.csv',CDS_ECHELLE.FieldByName('NUMERO').asString + ';' +
                                                     CDS_ECHELLE.Fields[I].asString);
            End;
          end;
          Inc(Compteur);
          CDS_ECHELLE.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des lignes de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des articles de vente
      try
        LibInfo  := 'Traitement des articles de vente en cours...';
        if FileExists(ChemImport+'Articles.csv') then
          DeleteFile(ChemImport+'Articles.csv');

        if FileExists(ChemImport+'code_barre.csv') then
          DeleteFile(ChemImport+'code_barre.csv');

        if FileExists(ChemImport+'prix.csv') then
          DeleteFile(ChemImport+'prix.csv');

        CDS_TM00nnn.First;
        NbLigne  := CDS_TM00nnn.RecordCount;
        TmpNbLigne := NbLigne;
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
                                          'TVA');

        Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                              'TAILLE;' +
                                              'COULEUR;' +
                                              'EAN;' +
                                              'QTTE');

        Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                        'TAILLE;' +
                                        'PXCATALOGUE;' +
                                        'PX_ACHAT;' +
                                        'PX_VENTE;' +
                                        'CODE_FOU');

        while (Not CDS_TM00nnn.eof) and (not stopImport) do
        Begin
          //Gestion du code article
          sCodeArticle := CDS_TM00nnn.FieldByName('REFERENCE').asString;
          sRefCodeBarre := CDS_TM00nnn.FieldByName('REF_CODEBARRE').asString;
          //Gestion date de création
          sDate := CDS_TM00nnn.FieldByName('1ERE_DATE_RECEPTION').asString;
          if (sDate = '') or (sDate = '0') or (sDate = '000000') then
            sDateCreation := '01/01/1990'
          else
            sDateCreation := Copy(sDate,5,2) + '/' + Copy(sDate,3,2) + '/' + Copy(sDate,1,2);

          //Gestion des Couleurs
          if not CDS_COULEUR.Locate('NUMERO',CDS_TM00nnn.FieldByName('COULEUR').AsString,[]) then
            sCouleur := 'UNICOLOR'
          else
            sCouleur := CDS_COULEUR.FieldByName('LIBELLE_COULEUR').AsString;

          //Gestion des Rayons
          if not CDS_SERVICE.Locate('NUMERO',CDS_TM00nnn.FieldByName('SERVICE').AsString,[]) then
            sRayon := TranspoEram96
          else
            sRayon := CDS_SERVICE.FieldByName('LIBELLE_SERVICE').AsString;

          //Gestion des Familles
          if not CDS_SERIE.Locate('NUMERO',CDS_TM00nnn.FieldByName('SERIE').AsString,[]) then
            sFamille := TranspoEram96
          else
            sFamille := CDS_SERIE.FieldByName('LIBELLE_SERIE').AsString;

          //Gestion des Sous-Familles
          if not CDS_FAMILLE.Locate('NUMERO',CDS_TM00nnn.FieldByName('FAMILLE').AsString,[]) then
            sSSFamille := TranspoEram96
          else
            sSSFamille := CDS_FAMILLE.FieldByName('LIBELLE_LONG').AsString;

          //Gestion des Collections
          if not CDS_SAISON.Locate('NUMERO',CDS_TM00nnn.FieldByName('SAISON').AsString,[]) then
            sSaison := TranspoEram96
          else
            sSaison := CDS_SAISON.FieldByName('LIBELLE_LONG_SAISON').AsString;

          //Gestion du code marque et code fournisseur
          if CDS_TM00nnn.FieldByName('FOURNISSEUR').asString = '' then
          begin
            sMarque       := TranspoEram96;
            sFournisseur  := TranspoEram96;
          end
          else
          begin
            if not CDS_FOURNISSEUR.Locate('NUMERO',CDS_TM00nnn.FieldByName('FOURNISSEUR').AsString,[]) then
            begin
              sMarque       := TranspoEram96;
              sFournisseur  := TranspoEram96;
            end
            else
            begin
              sMarque       := CDS_TM00nnn.FieldByName('FOURNISSEUR').asString;
              sFournisseur  := CDS_TM00nnn.FieldByName('FOURNISSEUR').asString;
            end;
          end;

          //Gestion de la Taille
          if CDS_TM00nnn.FieldByName('ECHELLE_DE_TAILLE').asString = '' then
            sCodeTaille := '0'
          else
          begin
            if not CDS_ECHELLE.Locate('NUMERO',CDS_TM00nnn.FieldByName('ECHELLE_DE_TAILLE').AsString,[]) then
              sCodeTaille := '0'
            else
              sCodeTaille := CDS_TM00nnn.FieldByName('ECHELLE_DE_TAILLE').asString;
          end;

          Add_CSV(ChemImport+'Articles.csv',  sCodeArticle + ';' +                                              //CODE
                                              sMarque + ';' +                                                   //CODE_MRQ
                                              sCodeTaille + ';' +                                               //CODE_GT
                                              sFournisseur + ';' +                                              //CODE_FOURN
                                              CDS_TM00nnn.FieldByName('DESIGNATION').asString + ';' +           //NOM
                                              '' + ';' +                                                        //DESCRIPTION
                                              sRayon + ';' +                                                    //RAYON
                                              sFamille + ';' +                                                  //FAMILLE
                                              sSSFamille + ';' +                                                //SS_FAM
                                              '' + ';' +                                                        //GENRE
                                              Copy(sCodeArticle, 1, 2) + ';' +                                  //CLASS1
                                              '' + ';' +                                                        //CLASS2
                                              '' + ';' +                                                        //CLASS3
                                              '' + ';' +                                                        //CLASS4
                                              '' + ';' +                                                        //CLASS5
                                              '' + ';' +                                                        //IDREF_SSFAM
                                              sCouleur + ';' +                                                  //COUL1
                                              '' + ';' +                                                        //COUL2
                                              '' + ';' +                                                        //COUL3
                                              '' + ';' +                                                        //COUL4
                                              '' + ';' +                                                        //COUL5
                                              '' + ';' +                                                        //COUL6
                                              '' + ';' +                                                        //COUL7
                                              '' + ';' +                                                        //COUL8
                                              '' + ';' +                                                        //COUL9
                                              '' + ';' +                                                        //COUL10
                                              '' + ';' +                                                        //COUL11
                                              '' + ';' +                                                        //COUL12
                                              '' + ';' +                                                        //COUL13
                                              '' + ';' +                                                        //COUL14
                                              '' + ';' +                                                        //COUL15
                                              '' + ';' +                                                        //COUL16
                                              '' + ';' +                                                        //COUL17
                                              '' + ';' +                                                        //COUL18
                                              '' + ';' +                                                        //COUL19
                                              '' + ';' +                                                        //COUL20
                                              '1' + ';' +                                                       //FIDELITE
                                              sDateCreation + ';' +                                             //DATECREATION
                                              sSaison + ';' +                                                   //COLLECTION
                                              '' + ';' +                                                        //COMENT1
                                              '' + ';' +                                                        //COMENT2
                                              '19.6');                                                          //TVA

          bExitTaille := False;
          I := 3;                 //Début de code taille
          while (I < 23) and (Not bExitTaille) do   //Boucle et 3 à 22 pour la plage des codes de taille
          begin
            if (Trim(CDS_ECHELLE.Fields[I].AsString) <> '') then
            begin
              if CDS_ECHELLE.Fields[I].AsString = CDS_TM00nnn.FieldByName('ASSORTIMENT_DEB').asString then
              begin
                while CDS_ECHELLE.Fields[I].AsString <> CDS_TM00nnn.FieldByName('ASSORTIMENT_FIN').asString do
                begin
                  //Gestion Taille
                  sTaille := CDS_ECHELLE.Fields[I+40].asString;     //On se décale de 40 pour avoir le nom.

                  Add_CSV(ChemImport+'code_barre.csv',sCodeArticle + ';' +
                                                      sTaille + ';' +
                                                      sCouleur + ';' +
                                                      MakeCodeBarre(sCodeArticle,sRefCodeBarre,CDS_ECHELLE.Fields[I].asString) + ';' +
                                                      '');

                  Add_CSV(ChemImport+'prix.csv',sCodeArticle + ';' +
                                                sTaille + ';' +
                                                CDS_TM00nnn.FieldByName('PA1').asString + ';' +
                                                CDS_TM00nnn.FieldByName('PA1').asString + ';' +
                                                CDS_TM00nnn.FieldByName('PV1').asString + ';' +
                                                sFournisseur);

                  Inc(I);
                end;
                if CDS_ECHELLE.Fields[I].AsString = CDS_TM00nnn.FieldByName('ASSORTIMENT_FIN').asString then
                begin

                end;
              end;
              Inc(I);
            end
            else
              bExitTaille := True;    //Si la chaine est vide on sort.
          end;

          Inc(Compteur);
          CDS_TM00nnn.next;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_TM00nnn.Close;
    CDS_UMxxnnn.Close;
    CDS_SERVICE.Close;
    CDS_SERIE.Close;
    CDS_SAISON.Close;
    CDS_FAMILLE.Close;
    CDS_COULEUR.Close;
    CDS_ECHELLE.Close;
    CDS_FOURNISSEUR.Close;

    FreeAndNil(CDS_TM00nnn);
    FreeAndNil(CDS_UMxxnnn);
    FreeAndNil(CDS_SERVICE);
    FreeAndNil(CDS_SERIE);
    FreeAndNil(CDS_SAISON);
    FreeAndNil(CDS_FAMILLE);
    FreeAndNil(CDS_COULEUR);
    FreeAndNil(CDS_ECHELLE);
    FreeAndNil(CDS_FOURNISSEUR);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement Eram96 : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
End;

procedure TTranspoThread.TraitementSportsRental;
Const
  TranspoSportsRental = 'IMPORT-SportsRental';
  PathSportsRental = 'SportsRental\';

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
Var
  TmpCompteur   : Integer;
  TmpNbLigne    : Integer;
  I             : Integer;                  //Variable de boucle
  TabCouleur    : Array [1..20] of String;  //Couleur de l'article
  Tmp_SL        : TStringList;              //String List temporaire
  sTVA          : string;
  sCodeTaille   : string;
  sTaille       : string;
  sMarque       : string;
  sCouleur      : string;
  sFournisseur  : string;
  sEAN          : string;
  sCategorie    : string;
  sSSFamille    : string;
  sCodeArticle  : string;
  sNomArticle   : string;
  sDate         : string;
  sFamille      : string;

  CDS_Client    : TclientDataSet;     //Liste des clients
  CDS_Fourn     : TClientDataSet;     //Liste des fournisseurs
  CDS_Vente     : TClientDataSet;     //Liste des article de vente
  CDS_Location  : TClientDataSet;     //Liste des article de Location
  CDS_Famille   : TClientDataSet;     //Liste des familles d'articles
  CDS_SSFamille : TClientDataSet;     //Liste des sous familles d'articles
  CDS_Taille    : TClientDataSet;     //Liste des tailles par grille de taille
  CDS_LigTaille : TClientDataSet;     //Liste des ligne de taille
  CDS_Marque    : TClientDataSet;     //Liste des Marques
Begin
  {$REGION 'SportsRental'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Sports Rental');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathSportsRental;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Client      := TClientDataSet.Create(nil);
    CDS_Fourn       := TClientDataSet.Create(nil);
    CDS_Vente       := TClientDataSet.Create(nil);
    CDS_Location    := TClientDataSet.Create(nil);
    CDS_Famille     := TClientDataSet.Create(nil);
    CDS_SSFamille   := TClientDataSet.Create(nil);
    CDS_Taille      := TClientDataSet.Create(nil);
    CDS_LigTaille   := TClientDataSet.Create(nil);
    CDS_Marque      := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoClient then
    begin
      if not LoadDataSet('clients',ChemSource+'Kunde.csv','Kunde_ID',CDS_Client) then
        Exit;
    end;

    if DoVente then
    begin
      if not LoadDataSet('fournisseur',ChemSource+'Hotel.csv','Hotel_ID',CDS_Fourn) then
        Exit;

      if not LoadDataSet('familles',ChemSource+'Ordner.csv','Ordner_ID',CDS_Famille) then
        Exit;

      if not LoadDataSet('tailles',ChemSource+'Size.csv','Size_ID',CDS_Taille) then
        Exit;
    end;

    if DoLocation then
    begin
      if not LoadDataSet('articles de location',ChemSource+'Artikel.csv','Artikel_ID',CDS_Location) then
        Exit;
    end;

    if DoLocation or DoVente then
    begin
      if not LoadDataSet('articles de vente',ChemSource+'Modell.csv','Modell_ID',CDS_Vente) then
        Exit;

      if not LoadDataSet('sous-familles',ChemSource+'Preisgruppe.csv','Preisgruppe_ID',CDS_SSFamille) then
        Exit;
    end;

    if DoClient then
    begin
      //Traitement des clients
      try
        LibInfo  := 'Traitement des clients en cours...';
        AjouterLog(LibInfo);

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
          Add_CSV(ChemImport+'clients.csv',CDS_Client.FieldByName('Kunde_ID').asString + ';' +
                                           'PART' + ';' +
                                           CDS_Client.FieldByName('Name').asString + ';' +
                                           CDS_Client.FieldByName('Vorname').asString + ';' +
                                           '' + ';' +
                                           CDS_Client.FieldByName('Strasse').asString + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           CDS_Client.FieldByName('Postleitzahl').asString + ';' +
                                           CDS_Client.FieldByName('Wohnort').asString + ';' +
                                           CDS_Client.FieldByName('Land').asString + ';' +
                                           '' + ';' +
                                           CDS_Client.FieldByName('Bemerkung').asString + ';' +
                                           CDS_Client.FieldByName('Telefon').asString + ';' +
                                           CDS_Client.FieldByName('Fax').asString + ';' +
                                           '' + ';' +
                                           CDS_Client.FieldByName('Email').asString + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           '' + ';' +
                                           '');
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Client.Next;
        End;
        CDS_Client.Close;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des clients : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoVente then
    begin
      //Traitement des fourniseurs
      try
        LibInfo  := 'Traitement des fournisseurs en cours...';
        AjouterLog(LibInfo);

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
                                         'NUM_COMPTA');

        Add_CSV(ChemImport+'fourn.csv'  ,TranspoSportsRental + ';' +
                                         TranspoSportsRental+ ';' +
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
                                         '');

        while (Not CDS_Fourn.eof) and (not stopImport) do
        begin
          Add_CSV(ChemImport+'fourn.csv',CDS_Fourn.FieldByName('Name').asString + ';' +
                                         CDS_Fourn.FieldByName('Name').asString + ';' +
                                         CDS_Fourn.FieldByName('Strasse').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         CDS_Fourn.FieldByName('Postleitzahl').asString + ';' +
                                         CDS_Fourn.FieldByName('Ort').asString + ';' +
                                         CDS_Fourn.FieldByName('Land').asString + ';' +
                                         CDS_Fourn.FieldByName('Telefon').asString + ';' +
                                         CDS_Fourn.FieldByName('Fax').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         CDS_Fourn.FieldByName('Bemerkung').asString + ';' +
                                         '' + ';' +
                                         '' + ';' +
                                         '');
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Fourn.Next;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des fournisseurs : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des marques
      try
        LibInfo  := 'Traitement des marques en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'marque.csv') then
          DeleteFile(ChemImport+'marque.csv');

        CDS_Fourn.First;
        NbLigne  := CDS_Fourn.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'marque.csv' ,'CODE;' +
                                         'CODE_FOU;' +
                                         'NOM');
        Add_CSV(ChemImport+'marque.csv' ,TranspoSportsRental + ';' +
                                         TranspoSportsRental + ';' +
                                         TranspoSportsRental);
        while Not (CDS_Fourn.eof) and (not stopImport) do
        begin
          Add_CSV(ChemImport+'marque.csv',CDS_Fourn.FieldByName('Name').asString + ';' +
                                         CDS_Fourn.FieldByName('Name').asString + ';' +
                                         CDS_Fourn.FieldByName('Name').asString);
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Fourn.Next;
        end;

        if not LoadDataSet('marques',ChemSource+'marque.csv','CODE',CDS_Marque) then
          Exit;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des marques : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des grilles de taille
      try
        LibInfo  := 'Traitement des grilles de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille.csv') then
          DeleteFile(ChemImport+'gr_taille.csv');

        CDS_Taille.Open;
        CDS_Taille.First;
        NbLigne  := CDS_Taille.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                             'NOM;' +
                                             'TYPE_GRILLE');
        while (Not CDS_Taille.eof) and (not stopImport) do
        Begin
          Add_CSV(ChemImport+'gr_taille.csv',CDS_Taille.FieldByName('Size_ID').asString + ';' +
                                             CDS_Taille.FieldByName('Bezeichnung').asString + ';' +
                                             TranspoSportsRental);
              Inc(Compteur);
              CDS_Taille.Next;
        End;
        Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +
                                           'UNIQUE' + ';' +
                                           TranspoSportsRental);
        CDS_Taille.Close;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des lignes de taille
      try
        LibInfo  := 'Traitement des lignes de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille_lig.csv') then
          DeleteFile(ChemImport+'gr_taille_lig.csv');

        CDS_Taille.Open;
        CDS_Taille.First;
        NbLigne  := CDS_Taille.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +
                                               'NOM');
        while (Not CDS_Taille.eof) and (not stopImport) do
        Begin
          for I := 5 to CDS_Taille.FieldCount - 1 do
          Begin
            if (Trim(CDS_Taille.Fields[I].AsString) <> '') then
            Begin
              Add_CSV(ChemImport+'gr_taille_lig.csv',CDS_Taille.FieldByName('Size_ID').asString + ';' +
                                                     CDS_Taille.Fields[I].asString);
            End;
          end;
          Inc(Compteur);
          CDS_Taille.Next;
        End;
        Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                               'UNIQUE');
        CDS_Taille.Close;

        if not LoadDataSet('lignes de taille',ChemSource+'gr_taille_lig.csv','NOM',CDS_LigTaille) then
          Exit;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des lignes de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des articles de vente
      try
        LibInfo  := 'Traitement des articles de vente en cours...';
        if FileExists(ChemImport+'Articles.csv') then
          DeleteFile(ChemImport+'Articles.csv');

        if FileExists(ChemImport+'code_barre.csv') then
          DeleteFile(ChemImport+'code_barre.csv');

        if FileExists(ChemImport+'prix.csv') then
          DeleteFile(ChemImport+'prix.csv');

        CDS_Vente.Filtered := False;
        CDS_Vente.Filter := 'ArtikelIdentifizieren = ''FAUX''';
        CDS_Vente.Filtered := True;
        CDS_Vente.First;
        NbLigne  := CDS_Vente.RecordCount;
        TmpNbLigne := NbLigne;
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
                                          'TVA');

        Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                              'TAILLE;' +
                                              'COULEUR;' +
                                              'EAN;' +
                                              'QTTE');

        Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                        'TAILLE;' +
                                        'PXCATALOGUE;' +
                                        'PX_ACHAT;' +
                                        'PX_VENTE;' +
                                        'CODE_FOU');

        while (Not CDS_Vente.eof) and (not stopImport) do
        Begin
          sNomArticle := CDS_Vente.FieldByName('Bezeichnung').AsString;
          CDS_Vente.Filtered  := False;
          CDS_Vente.Filter    := 'ArtikelIdentifizieren = ''FAUX'' AND Bezeichnung = ''' + sNomArticle + '''';
          CDS_Vente.Filtered  := True;

          CDS_Vente.First;

          sCodeArticle := 'SR-' + CDS_Vente.FieldByName('Modell_ID').asString;

          //Gestion des Couleurs
          for I := 1 to 21 do
            TabCouleur[I] := '';

          I := 1;
          TabCouleur[1] := 'UNICOLOR';

          While (Not CDS_Vente.eof) AND (I < 20) do
          Begin
            if CDS_Vente.FieldByName('Farbe').asString <> '' then
              if not FindCouleur(CDS_Vente.FieldByName('Farbe').asString, TabCouleur) then
              begin
                TabCouleur[I] := CDS_Vente.FieldByName('Farbe').asString;
                inc(I);
              end;
            CDS_Vente.Next;
          End;

          CDS_Vente.First;

          //Gestion des Sous-Familles
          CDS_SSFamille.Locate('Preisgruppe_ID',CDS_Vente.FieldByName('Preisgruppe_ID').AsString,[]);
          sSSFamille := CDS_SSFamille.FieldByName('Bezeichnung').AsString;
          if sSSFamille = '' then
            sSSFamille := TranspoSportsRental;

          //Gestion des Familles
          if sSSFamille <> TranspoSportsRental then
          begin
            CDS_Famille.Locate('Ordner_ID',CDS_SSFamille.FieldByName('Ordner_ID').AsString,[]);
            sFamille := CDS_Famille.FieldByName('Bezeichnung').AsString;
            if sFamille = '' then
              sFamille := TranspoSportsRental;
          end
          else
            sFamille := TranspoSportsRental;


          //Gestion du code marque et code fournisseur
          if CDS_Vente.FieldByName('Hersteller').asString = '' then
          begin
            sMarque       := TranspoSportsRental;
            sFournisseur  := TranspoSportsRental;
          end
          else
          begin
            if not CDS_Marque.Locate('NOM',CDS_Vente.FieldByName('Hersteller').AsString,[]) then
            begin
              Add_CSV(ChemImport+'marque.csv',CDS_Vente.FieldByName('Hersteller').AsString + ';' +
                                              TranspoSportsRental + ';' +
                                              CDS_Vente.FieldByName('Hersteller').AsString + ';');

              TmpCompteur := Compteur;
              CDS_Marque.Close;
              FreeAndNil(CDS_Marque);
              CDS_Marque      := TClientDataSet.Create(nil);

              if not LoadDataSet('marques',ChemSource+'marque.csv','CODE',CDS_Marque) then
                Exit;

              Compteur := TmpCompteur;
              NbLigne := TmpNbLigne;

              sMarque       := CDS_Vente.FieldByName('Hersteller').AsString;
              sFournisseur  := TranspoSportsRental;
            end
            else
            begin
              sMarque       := CDS_Vente.FieldByName('Hersteller').asString;
              sFournisseur  := CDS_Marque.FieldByName('CODE_FOU').asString;
            end;
          end;

          //Gestion de la Taille
          if CDS_Vente.FieldByName('Groesse').asString = '' then
            sCodeTaille := '0'
          else
          begin
            if not CDS_LigTaille.Locate('NOM',CDS_Vente.FieldByName('Groesse').AsString,[]) then
              sCodeTaille := '0'
            else
              sCodeTaille := CDS_LigTaille.FieldByName('CODE_GT').asString;
          end;


          Add_CSV(ChemImport+'Articles.csv',  sCodeArticle + ';' +                                        //CODE
                                              sMarque + ';' +                                             //CODE_MRQ
                                              sCodeTaille + ';' +                                         //CODE_GT
                                              sFournisseur + ';' +                                        //CODE_FOURN
                                              sNomArticle + ';' +                                         //NOM
                                              '' + ';' +                                                  //DESCRIPTION
                                              TranspoSportsRental + ';' +                                 //RAYON
                                              sFamille + ';' +                                            //FAMILLE
                                              sSSFamille + ';' +                                          //SS_FAM
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
                                              CDS_Vente.FieldByName('Datum').asString + ';' +             //DATECREATION
                                              '' + ';' +                                                  //COLLECTION
                                              '' + ';' +                                                  //COMENT1
                                              '' + ';' +                                                  //COMENT2
                                              '19.6');                                                    //TVA

          while (Not CDS_Vente.eof) do
          begin
            //Gestion Taille
            if CDS_Vente.FieldByName('Groesse').asString = '' then
              sTaille := 'UNIQUE'
            else
            begin
              if not CDS_LigTaille.Locate('NOM',CDS_Vente.FieldByName('Groesse').AsString,[]) then
                sTaille := 'UNIQUE'
              else
                sTaille := CDS_Vente.FieldByName('Groesse').AsString;
            end;

            //Gestion Couleur
            if CDS_Vente.FieldByName('Farbe').asString = '' then
              sCouleur := 'UNICOLOR'
            else
              sCouleur := CDS_Vente.FieldByName('Farbe').asString;

            Add_CSV(ChemImport+'code_barre.csv',sCodeArticle + ';' +
                                              sTaille + ';' +
                                              sCouleur + ';' +
                                              CDS_Vente.FieldByName('V_Modell_ID').asString + ';' +
                                              '');

            Add_CSV(ChemImport+'prix.csv',sCodeArticle + ';' +
                                        sTaille + ';' +
                                        CDS_Vente.FieldByName('NeuPreis').asString + ';' +
                                        CDS_Vente.FieldByName('NeuPreis').asString + ';' +
                                        CDS_Vente.FieldByName('Verkaufspreis').asString + ';' +
                                        sFournisseur);

            Inc(Compteur);
            CDS_Vente.Edit;
            CDS_Vente.Delete;
          end;

          CDS_Vente.Filtered := False;
          CDS_Vente.Filter := 'ArtikelIdentifizieren = ''FAUX''';
          CDS_Vente.Filtered := True;
          CDS_Vente.First;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
          Exit;
        end;
      end;

      FreeAndNil(CDS_Vente);
      CDS_Vente       := TClientDataSet.Create(nil);
      if not LoadDataSet('articles de vente',ChemSource+'Modell.csv','Modell_ID',CDS_Vente) then
        Exit;
    end;

    if DoLocation then
    begin
      //Traitement des articles de location
      try
        LibInfo  := 'Traitement des articles de location en cours...';
        if FileExists(ChemImport+'Loc\'+'Articles.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles.csv');

        CDS_Vente.Filtered := False;
        CDS_Vente.Filter := 'ArtikelIdentifizieren = ''VRAI''';
        CDS_Vente.Filtered := True;
        CDS_Vente.First;

        CDS_Location.First;
        NbLigne  := CDS_Location.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT');
        while (Not CDS_Location.eof) and (not stopImport) do
        Begin
          //Gestion du code marque
          if CDS_Location.FieldByName('Hersteller').asString = '' then
            sMarque := TranspoSportsRental
          else
            sMarque := CDS_Location.FieldByName('Hersteller').asString;

          //Gestion Catégorie Vente
          CDS_Vente.Locate('Modell_ID',CDS_Location.FieldByName('Modell_ID').AsString,[]);
          sCategorie := CDS_Vente.FieldByName('Bezeichnung').AsString;
          if sCategorie = '' then
            sCategorie := TranspoSportsRental;

          //Gestion des Sous Familles
          CDS_SSFamille.Locate('Preisgruppe_ID',CDS_Vente.FieldByName('Preisgruppe_ID').AsString,[]);
          sSSFamille := CDS_SSFamille.FieldByName('Bezeichnung').AsString;
          if sSSFamille = '' then
            sSSFamille := TranspoSportsRental;

          if CDS_Location.FieldByName('Datum').asString = '00/01/1900' then
            sDate := '01/01/1980';


          Add_CSV(ChemImport+'Loc\'+'Articles.csv',CDS_Location.FieldByName('Artikel_ID').asString + ';' +
                                                CDS_Location.FieldByName('Bezeichnung').asString + ';' +
                                                '' + ';' +
                                                CDS_Location.FieldByName('SerienNr').asString + ';' +
                                                sSSFamille + ';' +
                                                sCategorie + ';' +
                                                sMarque + ';' +
                                                TranspoSportsRental + ';' +
                                                'UNIQUE' + ';' +
                                                CDS_Location.FieldByName('V_Artikel_ID').asString + ';' +
                                                CDS_Location.FieldByName('V_Artikel_ID2').asString + ';' +
                                                '' + ';' +
                                                '' + ';' +
                                                'LOCATION' + ';' +
                                                sDate + ';' +
                                                CDS_Location.FieldByName('Neupreis').asString + ';' +
                                                CDS_Location.FieldByName('Verkaufspreis').asString + ';' +
                                                '' + ';' +
                                                '' + ';' +
                                                '3' + ';' +
                                                'N' + ';' +
                                                'N' + ';' +
                                                '' + ';' +
                                                '');

          Inc(Compteur);

          CDS_Location.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_Fourn.Close;
    CDS_Vente.Close;
    CDS_Location.Close;
    CDS_Famille.Close;
    CDS_SSFamille.Close;
    CDS_Taille.Close;
    CDS_LigTaille.Close;
    CDS_Marque.Close;

    FreeAndNil(CDS_Fourn);
    FreeAndNil(CDS_Vente);
    FreeAndNil(CDS_Location);
    FreeAndNil(CDS_Famille);
    FreeAndNil(CDS_SSFamille);
    FreeAndNil(CDS_Taille);
    FreeAndNil(CDS_LigTaille);
    FreeAndNil(CDS_Marque);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
End;

procedure TTranspoThread.TraitementFlexo;
Const
  TranspoFlexo = 'IMPORT-Flexo';
  PathFlexo = 'Flexo\';

Var
  sCodeArticle  : string;
  sSFamille     : string;
  sFamille      : string;

  CDS_Vente     : TClientDataSet;     //Liste des article de vente
Begin
  {$REGION 'Flexo'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Flexo');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathFlexo;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Vente       := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if not LoadDataSet('Fichier article',ChemSource+'articles.csv','CODE_ART',CDS_Vente) then
      Exit;

    //Traitement des fourniseurs
    try
      LibInfo  := 'Traitement des fournisseurs en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'fourn.csv') then
        DeleteFile(ChemImport+'fourn.csv');

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

      Add_CSV(ChemImport+'fourn.csv'  ,TranspoFlexo + ';' +
                                       TranspoFlexo + ';' +
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
                                       '');
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des fournisseurs : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des marques
    try
      LibInfo  := 'Traitement des marques en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'marque.csv') then
        DeleteFile(ChemImport+'marque.csv');

      Add_CSV(ChemImport+'marque.csv' ,'CODE;' +
                                       'CODE_FOU;' +
                                       'NOM');

      Add_CSV(ChemImport+'marque.csv' ,TranspoFlexo + ';' +
                                       TranspoFlexo + ';' +
                                       TranspoFlexo);
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des marques : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des grilles de taille
    try
      LibInfo  := 'Traitement des grilles de taille en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'gr_taille.csv') then
        DeleteFile(ChemImport+'gr_taille.csv');

      Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                           'NOM;' +
                                           'TYPE_GRILLE');

      Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +
                                         'UNIQUE' + ';' +
                                         TranspoFlexo);
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des lignes de taille
    try
      LibInfo  := 'Traitement des lignes de taille en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'gr_taille_lig.csv') then
        DeleteFile(ChemImport+'gr_taille_lig.csv');

      Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +
                                             'NOM');

      Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                             'UNIQUE');
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des lignes de taille : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des articles de vente
    try
      LibInfo  := 'Traitement des articles de vente en cours...';
      if FileExists(ChemImport+'Articles.csv') then
        DeleteFile(ChemImport+'Articles.csv');

      if FileExists(ChemImport+'code_barre.csv') then
        DeleteFile(ChemImport+'code_barre.csv');

      if FileExists(ChemImport+'prix.csv') then
        DeleteFile(ChemImport+'prix.csv');

      CDS_Vente.First;
      NbLigne  := CDS_Vente.RecordCount;
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
                                        'TVA');

      Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                            'TAILLE;' +
                                            'COULEUR;' +
                                            'EAN;' +
                                            'QTTE');

      Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                      'TAILLE;' +
                                      'PXCATALOGUE;' +
                                      'PX_ACHAT;' +
                                      'PX_VENTE;' +
                                      'CODE_FOU');

      while (Not CDS_Vente.eof) and (not stopImport) do
      Begin
        sCodeArticle := StringReplace(CDS_Vente.FieldByName('CODE_ART').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]);

        sSFamille := StringReplace(CDS_Vente.FieldByName('SCATEGORIE').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]);
        if sSFamille = '' then
          sSFamille  := TranspoFlexo;

        sFamille := StringReplace(CDS_Vente.FieldByName('CATEGORIE').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]);
        if sFamille = '' then
          sFamille  := TranspoFlexo;

        Add_CSV(ChemImport+'Articles.csv',  sCodeArticle + ';' +                                        //CODE
                                            TranspoFlexo + ';' +                                        //CODE_MRQ
                                            '0' + ';' +                                                 //CODE_GT
                                            TranspoFlexo + ';' +                                        //CODE_FOURN
                                            StringReplace(CDS_Vente.FieldByName('NOM_ART').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]) + ';' +           //NOM
                                            StringReplace(CDS_Vente.FieldByName('REMARQUE1').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]) + ';' +         //DESCRIPTION
                                            TranspoFlexo + ';' +                                        //RAYON
                                            sFamille + ';' +                                            //FAMILLE
                                            sSFamille + ';' +                                           //SS_FAM
                                            '' + ';' +                                                  //GENRE
                                            '' + ';' +                                                  //CLASS1
                                            '' + ';' +                                                  //CLASS2
                                            '' + ';' +                                                  //CLASS3
                                            '' + ';' +                                                  //CLASS4
                                            '' + ';' +                                                  //CLASS5
                                            '' + ';' +                                                  //IDREF_SSFAM
                                            'UNICOLOR' + ';' +                                          //COUL1
                                            '' + ';' +                                                  //COUL2
                                            '' + ';' +                                                  //COUL3
                                            '' + ';' +                                                  //COUL4
                                            '' + ';' +                                                  //COUL5
                                            '' + ';' +                                                  //COUL6
                                            '' + ';' +                                                  //COUL7
                                            '' + ';' +                                                  //COUL8
                                            '' + ';' +                                                  //COUL9
                                            '' + ';' +                                                  //COUL10
                                            '' + ';' +                                                  //COUL11
                                            '' + ';' +                                                  //COUL12
                                            '' + ';' +                                                  //COUL13
                                            '' + ';' +                                                  //COUL14
                                            '' + ';' +                                                  //COUL15
                                            '' + ';' +                                                  //COUL16
                                            '' + ';' +                                                  //COUL17
                                            '' + ';' +                                                  //COUL18
                                            '' + ';' +                                                  //COUL19
                                            '' + ';' +                                                  //COUL20
                                            '1' + ';' +                                                 //FIDELITE
                                            '' + ';' +                                                  //DATECREATION
                                            '' + ';' +                                                  //COLLECTION
                                            StringReplace(CDS_Vente.FieldByName('REMARQUE2').AsString, '"', '', [rfReplaceAll,rfIgnoreCase]) + ';' +         //COMENT1
                                            '' + ';' +                                                  //COMENT2
                                            '19.6');                                                    //TVA

        Add_CSV(ChemImport+'code_barre.csv',sCodeArticle + ';' +
                                            'UNIQUE' + ';' +
                                            'UNICOLOR' + ';' +
                                            sCodeArticle + ';' +
                                            '');

        Add_CSV(ChemImport+'prix.csv',sCodeArticle + ';' +
                                      'UNIQUE' + ';' +
                                      CDS_Vente.FieldByName('PRIX_ACHAT').asString + ';' +
                                      CDS_Vente.FieldByName('PRIX_ACHAT').asString + ';' +
                                      CDS_Vente.FieldByName('PRIX_VENTE').asString + ';' +
                                      TranspoFlexo);

        Inc(Compteur);
        CDS_Vente.Next;
      end;
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
        Exit;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_Vente.Close;
    FreeAndNil(CDS_Vente);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
End;

procedure TTranspoThread.TraitementHusky;
Const
  TranspoHusky = 'IMPORT-Husky';
  PathHusky = 'Husky\';

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
Var
  sMarque       : string;
  sDateCession  : string;
  sPrixCession  : string;
  sCommentaire  : string;
  sCategorie    : string;
  sDate         : string;
  sStatut       : string;
  sCB1          : string;

  CDS_Fourn       : TClientDataSet;     //Liste des fournisseurs
//  CDS_Famille_Loc : TClientDataSet;     //Liste des Famille de Location
  CDS_Location    : TClientDataSet;     //Liste des article de Location
Begin
  {$REGION 'Husky'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Husky');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathHusky;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Fourn       := TClientDataSet.Create(nil);
//    CDS_Famille_Loc := TClientDataSet.Create(nil);
    CDS_Location    := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoLocation then
    begin
      if not LoadDataSet('articles de location',ChemSource+'LocArticle.txt','NUM',CDS_Location) then
        Exit;

      if not LoadDataSet('fournisseur',ChemSource+'Fourn.txt','Num',CDS_Fourn) then
        Exit;

//      if not LoadDataSet('catégorie des articles',ChemSource+'Famille_Loc.csv','IDFamille_Loc',CDS_Famille_Loc) then
//        Exit;
//

    end;

    if DoLocation then
    begin
      //Traitement des articles de location
      try
        LibInfo  := 'Traitement des articles de location en cours...';
        if FileExists(ChemImport+'Loc\'+'Articles.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles.csv');

        if FileExists(ChemImport+'Loc\'+'Articles_OLD.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles_OLD.csv');

        CDS_Location.First;
        NbLigne  := CDS_Location.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT');

        Add_CSV(ChemImport+'Loc\'+'Articles_OLD.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT');

        while (Not CDS_Location.eof) and (not stopImport) do
        Begin
          sPrixCession := '';
          sDateCession := '';
          sCB1 := '';

          //Gestion Catégorie Vente
          sCategorie := CDS_Location.FieldByName('categ').AsString;
          if sCategorie = '' then
            sCategorie := TranspoHusky;

          //Gestion du statut
          sStatut := CDS_Location.FieldByName('statut').AsString;
          if sStatut = '' then
            sStatut := 'INCONNU';

          //Gestion du code marque
          CDS_Fourn.Locate('Num',CDS_Location.FieldByName('fourn').AsString,[]);
          sMarque := CDS_Fourn.FieldByName('RS').AsString;
          if sMarque = '' then
            sMarque := TranspoHusky;

          //Gestion de la date achat
          sDate := DateToStr(CDS_Location.FieldByName('dateachat').AsDateTime);
          if sDate = '' then
            sDate := '01/01/1980';

          //Gestion de la date de cession
          if CDS_Location.FieldByName('datecession').AsString <> '' then
            sDateCession := DateToStr(CDS_Location.FieldByName('datecession').AsDateTime)
          else
            sDateCession := '02/01/2013';

          sCommentaire := 'Fixa./Divers : ' + CDS_Location.FieldByName('divers').AsString;

          //Gestion Code barre
          sCB1 := CDS_Location.FieldByName('CB').asString;
          if CDS_Location.FieldByName('Num').asString = sCB1 then
            sCB1 := '';

          if (((sStatut = 'vente materiel location')
            OR (sStatut = 'CASSE')
            OR (sStatut = 'DONNATION')
            OR (sStatut = 'PERDU')
            OR (sStatut = 'VOLE')
            OR (sStatut = 'ECHANGE')
            OR (sStatut = 'S.A.V')
            OR (sStatut = 'RETOUR FOURNISSEUR')
            OR (sStatut = 'TEST')) AND (StrToDate(sDateCession) > StrToDate('01/01/2013'))) OR (sStatut = 'LOCATION') then
          begin
            if sDateCession = '02/01/2013' then sDateCession := '';
            Add_CSV(ChemImport+'Loc\'+'Articles.csv', CDS_Location.FieldByName('Num').asString + ';' +                  //CODE
                                                      CDS_Location.FieldByName('Lib1').asString + ';' +                 //LIBELLE
                                                      '' + ';' +                                                        //REFMARQUE
                                                      CDS_Location.FieldByName('serie').asString + ';' +                //NUMSERIE
                                                      sCategorie + ';' +                                                //CATEGORIE
                                                      sCommentaire + ';' +                                              //COMMENTAIRE
                                                      sMarque + ';' +                                                   //MARQUE
                                                      TranspoHusky + ';' +                                              //GRILLETAILLE
                                                      CDS_Location.FieldByName('libtaille').asString + ';' +            //TAILLE
                                                      sCB1 + ';' +                                                      //CB1
                                                      '' + ';' +                                                        //CB2
                                                      '' + ';' +                                                        //CB3
                                                      '' + ';' +                                                        //CB4
                                                      sStatut + ';' +                                                   //STATUT
                                                      sDate + ';' +                                                     //DATEACHAT
                                                      StringReplace(CDS_Location.FieldByName('pxa').AsString, '.', ',', [rfReplaceAll]) + ';' +       //PRIXACHAT
                                                      '' + ';' +                                                        //PRIXVENTE
                                                      sDateCession + ';' +                                              //DATECESSION
                                                      StringReplace(CDS_Location.FieldByName('pxcession').AsString, '.', ',', [rfReplaceAll]) + ';' + //PRIXCESSION
                                                      StringReplace(CDS_Location.FieldByName('dureeamt').asString, '.', '', [rfReplaceAll]) + ';' +  //DUREEAMT
                                                      'N' + ';' +                                                       //LOCFOURNISSEUR
                                                      'N' + ';' +                                                       //SOUSFICHE
                                                      '' + ';' +                                                        //SFCODE
                                                      '');                                                              //RESULTAT
          end
          else
          begin
            if sDateCession = '02/01/2013' then sDateCession := '';
            Add_CSV(ChemImport+'Loc\'+'Articles_OLD.csv', CDS_Location.FieldByName('Num').asString + ';' +                  //CODE
                                                          CDS_Location.FieldByName('Lib1').asString + ';' +                 //LIBELLE
                                                          '' + ';' +                                                        //REFMARQUE
                                                          CDS_Location.FieldByName('serie').asString + ';' +                //NUMSERIE
                                                          sCategorie + ';' +                                                //CATEGORIE
                                                          sCommentaire + ';' +                                              //COMMENTAIRE
                                                          sMarque + ';' +                                                   //MARQUE
                                                          TranspoHusky + ';' +                                              //GRILLETAILLE
                                                          CDS_Location.FieldByName('libtaille').asString + ';' +            //TAILLE
                                                          sCB1 + ';' +                                                      //CB1
                                                          '' + ';' +                                                        //CB2
                                                          '' + ';' +                                                        //CB3
                                                          '' + ';' +                                                        //CB4
                                                          sStatut + ';' +                                                   //STATUT
                                                          sDate + ';' +                                                                                     //DATEACHAT
                                                          StringReplace(CDS_Location.FieldByName('pxa').AsString, '.', ',', [rfReplaceAll]) + ';' +         //PRIXACHAT
                                                          '' + ';' +                                                                                        //PRIXVENTE
                                                          sDateCession + ';' +                                                                              //DATECESSION
                                                          StringReplace(CDS_Location.FieldByName('pxcession').AsString, '.', ',', [rfReplaceAll]) + ';' +   //PRIXCESSION
                                                          StringReplace(CDS_Location.FieldByName('dureeamt').asString, '.', '', [rfReplaceAll]) + ';' +     //DUREEAMT
                                                          'N' + ';' +                                                       //LOCFOURNISSEUR
                                                          'N' + ';' +                                                       //SOUSFICHE
                                                          '' + ';' +                                                        //SFCODE
                                                          '');                                                              //RESULTAT
          end;
          Inc(Compteur);

          CDS_Location.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_Fourn.Close;
    CDS_Location.Close;

    FreeAndNil(CDS_Fourn);
    FreeAndNil(CDS_Location);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
end;

procedure TTranspoThread.TraitementL2GI;
Const
  TranspoL2GI = 'IMPORT-L2GI';
  PathL2GI = 'L2GI\';

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
Var
  sSFamille     : string;
  sMarque       : string;
  sDateCession  : string;
  sCommentaire  : string;
  sCategorie    : string;
  sDate         : string;
  sStatut       : string;
  sCB1          : string;
  sCB2          : string;
  sGender       : string;
  sLevel        : string;
  sCategory     : string;
  sRadius       : string;
  sWaist        : string;
  sTva          : string;
  sCodeCouleur  : string;
  sCouleur      : string;
  sTaille       : string;
  sDateCreation : string;
  sDateDernierPass : string;
  sRefArt       : string;
  sStrings      : TStrings;
  TabCouleur    : Array [1..20] of String;  //Couleur de l'article

  I, J : Integer;
  CDS_Ski_Cat     : TClientDataSet;     //Liste des Article de Vente
  CDS_Ski_Fix     : TClientDataSet;     //Liste des Article de Location
  CDS_Ski_Modele  : TClientDataSet;     //Liste des Article de Location
  CDS_Client_Loc  : TClientDataSet;     //Liste des Clients
  CDS_Fournisseur : TClientDataSet;     //Liste des Fournisseurs
  CDS_Ski_Stock   : TClientDataSet;     //Liste des Grilles de taille
  CDS_TVA         : TClientDataSet;     //Liste des TVA
Begin
  {$REGION 'L2GI'}
  try
    sStrings := TStringList.Create;

    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement L2GI');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathL2GI;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Ski_Cat     := TClientDataSet.Create(nil);
    CDS_Ski_Fix     := TClientDataSet.Create(nil);
    CDS_Ski_Modele  := TClientDataSet.Create(nil);
    CDS_Client_Loc  := TClientDataSet.Create(nil);
    CDS_Fournisseur := TClientDataSet.Create(nil);
    CDS_Ski_Stock   := TClientDataSet.Create(nil);
    CDS_TVA         := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoClient then
    begin
      if not LoadDataSet('clients',ChemSource+'CLIENTLOC.csv','NUMCLI',CDS_Client_Loc) then
        Exit;
    end;

    if DoLocation then
    begin
      if not LoadDataSet('Ski Categorie',ChemSource+'SKI_CAT.csv','NUMCAT',CDS_Ski_Cat) then
        Exit;
      if not LoadDataSet('Ski Fixation',ChemSource+'SKI_FIX.csv','NUMCAT;NUMFIX',CDS_Ski_Fix) then
        Exit;
      if not LoadDataSet('Ski Modele',ChemSource+'SKI_MODELE.csv','NUMMOD',CDS_Ski_Modele) then
        Exit;
      if not LoadDataSet('Fournisseur',ChemSource+'FOURNISSEUR.csv','CODE_FOUR',CDS_Fournisseur) then
        Exit;
      if not LoadDataSet('Ski Stock',ChemSource+'SKI_STOCK.csv','REFMAGA',CDS_Ski_Stock) then
        Exit;
      if not LoadDataSet('TVA',ChemSource+'TVA.csv','CODE_TVA',CDS_TVA) then
        Exit;
    end;

    if DoClient then
    begin
      //Traitement des clients
      try
        LibInfo  := 'Traitement des clients en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'clients.csv') then
          DeleteFile(ChemImport+'clients.csv');

        CDS_Client_Loc.Open;
        CDS_Client_Loc.First;
        NbLigne  := CDS_Client_Loc.RecordCount;
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
                                         'NUMERO;' +
                                         'DATE_NAISSANCE;' +
                                         'DATE_CREATION');
        while (Not CDS_Client_Loc.eof) and (not stopImport) do
        Begin
          Add_CSV(ChemImport+'clients.csv',CDS_Client_Loc.FieldByName('NUMCLI').asString + ';' +          //CODE
                                           'PART' + ';' +                                                 //TYP
                                           CDS_Client_Loc.FieldByName('NOM').asString + ';' +             //NOM_RS1
                                           CDS_Client_Loc.FieldByName('PRENOM').asString + ';' +          //PREN_RS2
                                           CDS_Client_Loc.FieldByName('TITRE').asString + ';' +           //CIV
                                           CDS_Client_Loc.FieldByName('ADR1').asString + ';' +            //ADR1
                                           CDS_Client_Loc.FieldByName('ADR2').asString + ';' +            //ADR2
                                           '' + ';' +                                                     //ADR3
                                           CDS_Client_Loc.FieldByName('CP').asString + ';' +              //CP
                                           CDS_Client_Loc.FieldByName('VILLE').asString + ';' +           //VILLE
                                           CDS_Client_Loc.FieldByName('PAYS').asString + ';' +            //PAYS
                                           '' + ';' +                                                     //CODE_COMPTABLE
                                           CDS_Client_Loc.FieldByName('COMMENTAIRE').asString + ';' +     //COM
                                           CDS_Client_Loc.FieldByName('TEL').asString + ';' +             //TEL
                                           CDS_Client_Loc.FieldByName('FAX').asString + ';' +             //FAX_TTRAV
                                           CDS_Client_Loc.FieldByName('GSM').asString + ';' +             //PORTABLE
                                           CDS_Client_Loc.FieldByName('EMAIL').asString + ';' +           //EMAIL
                                           '' + ';' +                                                     //CB_NATIONAL
                                           '' + ';' +                                                     //CLASS1
                                           '' + ';' +                                                     //CLASS2
                                           '' + ';' +                                                     //CLASS3
                                           '' + ';' +                                                     //CLASS4
                                           '' + ';' +                                                     //CLASS5
                                           '' + ';' +                                                     //CHRONO
                                           '' + ';' +                                                     //DATE_NAISSANCE
                                           '');                                                           //DATE_CREATION
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Client_Loc.Next;
        End;
        CDS_Client_Loc.Close;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des clients : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoLocation then
    begin
      //Traitement des articles de location
      try
        LibInfo  := 'Traitement des articles de location en cours...';
        if FileExists(ChemImport+'Loc\'+'Articles.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles.csv');

        if FileExists(ChemImport+'Loc\'+'Articles_SF.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles_SF.csv');

        CDS_Ski_Stock.First;
        NbLigne  := CDS_Ski_Stock.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT;' +
                                                  'DESCRIPTION;' +
                                                  'ARCHIVER;' +
                                                  'LOUEAUFOURN;' +
                                                  'DATEFAB;' +
                                                  'DUREEVIE;' +
                                                  'CHRONO;' +
                                                  'CLASSEMENT1;' +
                                                  'CLASSEMENT2;' +
                                                  'CLASSEMENT3;' +
                                                  'CLASSEMENT4;' +
                                                  'CLASSEMENT5');

        Add_CSV(ChemImport+'Loc\'+'Articles_SF.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT;' +
                                                  'DESCRIPTION;' +
                                                  'ARCHIVER;' +
                                                  'LOUEAUFOURN;' +
                                                  'DATEFAB;' +
                                                  'DUREEVIE;' +
                                                  'CHRONO;' +
                                                  'CLASSEMENT1;' +
                                                  'CLASSEMENT2;' +
                                                  'CLASSEMENT3;' +
                                                  'CLASSEMENT4;' +
                                                  'CLASSEMENT5');

        while (Not CDS_Ski_Stock.eof) and (not stopImport) do
        Begin
          sCommentaire := '';
          sDateCession := '';
          sCB1 := '';
          sCB2 := '';

          //Gestion Catégorie Loc
          CDS_Ski_Cat.Locate('NUMCAT',CDS_Ski_Stock.FieldByName('NUMCAT').AsString,[]);
          sCategorie := CDS_Ski_Cat.FieldByName('CATEGORIE').AsString;
          if sCategorie = '' then
            sCategorie := TranspoL2GI;

          //Modèle du ski
          CDS_Ski_Modele.Locate('NUMCAT;NUMMOD',VarArrayOf([CDS_Ski_Stock.FieldByName('NUMCAT').AsString,CDS_Ski_Stock.FieldByName('NUMMOD').AsString]),[]);

          //Gestion du code marque
          CDS_Fournisseur.Locate('CODE_FOUR',CDS_Ski_Modele.FieldByName('CODE_FOUR').AsString,[]);
          sMarque := CDS_Fournisseur.FieldByName('NOM_FOUR').AsString;
          if sMarque = '' then
            sMarque := TranspoL2GI;

          sCommentaire := CDS_Ski_Stock.FieldByName('COMMENTAIRE').asString;

          //Gestion du statut
          if CDS_Ski_Stock.FieldByName('ETAT').AsString = '0' then
          begin
            sStatut := 'LOCATION';
          end
          else
            if CDS_Ski_Stock.FieldByName('ETAT').AsString = '2' then
            begin
              sStatut := 'VENDU';

            end
            else
              if CDS_Ski_Stock.FieldByName('ETAT').AsString = '3' then
              begin
                sStatut := 'CASSE';
              end
              else
                if CDS_Ski_Stock.FieldByName('ETAT').AsString = '4' then
                begin
                  sStatut := 'VOLE';
                end;

          //Gestion de la date
          if CDS_Ski_Stock.FieldByName('SAISON').asString = '' then
            sDate := '01/01/1980'
          else
            sDate := '01/01/' + CDS_Ski_Stock.FieldByName('SAISON').asString;

          Add_CSV(ChemImport+'Loc\'+'Articles.csv',CDS_Ski_Stock.FieldByName('REFMAGA').asString + ';' +    //CODE
                                                CDS_Ski_Modele.FieldByName('DESIGNATION').asString + ';' +  //LIBELLE
                                                CDS_Ski_Modele.FieldByName('REF_FOUR').asString + ';' +     //REFMARQUE
                                                CDS_Ski_Stock.FieldByName('REFFOUR1').asString + ';' +      //NUMSERIE
                                                sCategorie + ';' +                                          //CATEGORIE
                                                sCommentaire + ';' +                                        //COMMENTAIRE
                                                sMarque + ';' +                                             //MARQUE
                                                TranspoL2GI + ';' +                                         //GRILLETAILLE
                                                CDS_Ski_Stock.FieldByName('TAILLE').asString + ';' +        //TAILLE
                                                CDS_Ski_Stock.FieldByName('BARCODE').asString + ';' +       //CB1
                                                '' + ';' +                                                  //CB2
                                                '' + ';' +                                                  //CB3
                                                '' + ';' +                                                  //CB4
                                                sStatut + ';' +                                             //STATUT
                                                sDate + ';' +                                               //DATEACHAT
                                                CDS_Ski_Modele.FieldByName('PUHT').asString + ';' +         //PRIXACHAT
                                                '' + ';' +                                                  //PRIXVENTE
                                                sDateCession + ';' +                                        //DATECESSION
                                                '' + ';' +                                                  //PRIXCESSION
                                                '3' + ';' +                                                 //DUREEAMT
                                                'N' + ';' +                                                 //LOCFOURNISSEUR
                                                'N' + ';' +                                                 //SOUSFICHE
                                                '' + ';' +                                                  //SFCODE
                                                '' + ';' +                                                  //RESULTAT
                                                '' + ';' +                                                  //DESCRIPTION
                                                '0' + ';' +                                                 //ARCHIVER
                                                '0' + ';' +                                                 //LOUEAUFOURN
                                                '' + ';' +                                                  //DATEFAB
                                                '' + ';' +                                                  //DUREEVIE
                                                CDS_Ski_Stock.FieldByName('REFMAGA').asString + ';' +       //CHRONO
                                                '' + ';' +                                                  //CLASSEMENT1
                                                '' + ';' +                                                  //CLASSEMENT2
                                                '' + ';' +                                                  //CLASSEMENT3
                                                '' + ';' +                                                  //CLASSEMENT4
                                                ''                                                          //CLASSEMENT5
                                                );

          //Création d'une sous fiche pour les fixations
          if CDS_Ski_Stock.FieldByName('NUMFIX').asString <> '0' then
          begin
            //Recherche Fixation
            CDS_Ski_Fix.Locate('NUMCAT;NUMFIX',VarArrayOf([CDS_Ski_Stock.FieldByName('NUMFIX').AsString,CDS_Ski_Stock.FieldByName('NUMFIX').AsString]),[]);

            //Gestion du code marque
            CDS_Fournisseur.Locate('CODE_FOUR',CDS_Ski_Fix.FieldByName('CODE_FOUR').AsString,[]);
            sMarque := CDS_Fournisseur.FieldByName('NOM_FOUR').AsString;
            if sMarque = '' then
              sMarque := TranspoL2GI;

            Add_CSV(ChemImport+'Loc\'+'Articles_SF.csv',CDS_Ski_Fix.FieldByName('NUMFIX').asString + ';' +      //CODE
                                                        CDS_Ski_Fix.FieldByName('DESIGNATION').asString + ';' + //LIBELLE
                                                        CDS_Ski_Fix.FieldByName('REF_FOUR').asString + ';' +    //REFMARQUE
                                                        CDS_Ski_Stock.FieldByName('REFFOUR1').asString + ';' +  //NUMSERIE
                                                        '' + ';' +                                              //CATEGORIE
                                                        '' + ';' +                                              //COMMENTAIRE
                                                        sMarque + ';' +                                         //MARQUE
                                                        '' + ';' +                                              //GRILLETAILLE
                                                        '' + ';' +                                              //TAILLE
                                                        '' + ';' +                                              //CB1
                                                        '' + ';' +                                              //CB2
                                                        '' + ';' +                                              //CB3
                                                        '' + ';' +                                              //CB4
                                                        sStatut + ';' +                                         //STATUT
                                                        sDate + ';' +                                           //DATEACHAT
                                                        CDS_Ski_Fix.FieldByName('PUHT').asString + ';' +        //PRIXACHAT
                                                        '' + ';' +                                              //PRIXVENTE
                                                        sDateCession + ';' +                                    //DATECESSION
                                                        '' + ';' +                                              //PRIXCESSION
                                                        '3' + ';' +                                             //DUREEAMT
                                                        'N' + ';' +                                             //LOCFOURNISSEUR
                                                        'O' + ';' +                                             //SOUSFICHE
                                                        CDS_Ski_Stock.FieldByName('REFMAGA').asString + ';' +   //SFCODE
                                                        '' + ';' +                                              //RESULTAT
                                                        '' + ';' +                                              //DESCRIPTION
                                                        '0' + ';' +                                             //ARCHIVER
                                                        '0' + ';' +                                             //LOUEAUFOURN
                                                        '' + ';' +                                              //DATEFAB
                                                        '' + ';' +                                              //DUREEVIE
                                                        '' + ';' +                                              //CHRONO
                                                        '' + ';' +                                              //CLASSEMENT1
                                                        '' + ';' +                                              //CLASSEMENT2
                                                        '' + ';' +                                              //CLASSEMENT3
                                                        '' + ';' +                                              //CLASSEMENT4
                                                        ''                                                      //CLASSEMENT5
                                                        );
          end;

          Inc(Compteur);

          CDS_Ski_Stock.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    FreeAndNil(CDS_Ski_Cat);
    FreeAndNil(CDS_Ski_Fix);
    FreeAndNil(CDS_Ski_Modele);
    FreeAndNil(CDS_Client_Loc);
    FreeAndNil(CDS_Fournisseur);
    FreeAndNil(CDS_Ski_Stock);
    FreeAndNil(CDS_TVA);


    FreeAndNil(sStrings);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;

  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
end;

procedure TTranspoThread.TraitementBeauteConcept;
Const
  TranspoBeauteConcept = 'IMPORT-BeauteConcept';
  PathBeauteConcept = 'BeauteConcept\';

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

Var
  CDS_Vente     : TClientDataSet;     //Liste des article de vente
  CDS_Client    : TClientDataSet;

  TabCouleur    : Array [1..20] of String;  //Couleur de l'article
  sCodeArticle  : string;
  I             : Integer;
Begin
  {$REGION 'BeauteConcept'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement BeauteConcept');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathBeauteConcept;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Vente       := TClientDataSet.Create(nil);
    CDS_Client       := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if not LoadDataSet('Fichier article',ChemSource+'Articles.csv','Code_article',CDS_Vente) then
      Exit;

    //Récupération des informations à intégrer
    if DoClient then
    begin
      if not LoadDataSet('clients',ChemSource+'Clients.csv','Code',CDS_Client) then
        Exit;
    end;

    if DoClient then
    begin
      //Traitement des clients
      try
        LibInfo  := 'Traitement des clients en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'clients.csv') then
          DeleteFile(ChemImport+'clients.csv');


        CDS_Client.First;
        NbLigne  := CDS_Client.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'clients.csv', 'CODE;' +
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
          Add_CSV(ChemImport+'clients.csv',
            CDS_Client.FieldByName('Code').AsString + ';' +             //CODE
            'PRO' + ';' +                                               //Type
            CDS_Client.FieldByName('Nom').AsString + ';' +              //Nom
            CDS_Client.FieldByName('Prenom').asString + ';' +           //Prénom
            CDS_Client.FieldByName('Type').asString + ';' +             //Civilité
            CDS_Client.FieldByName('Adresse').asString + ';' +          //Adresse 1
            '' + ';' +                                                  //Adresse 2
            '' + ';' +                                                  //Adresse 3
            CDS_Client.FieldByName('CP').asString + ';' +               //Code postal
            CDS_Client.FieldByName('Ville').asString + ';' +            //Ville
            '' + ';' +                                                  //Pays
            '' + ';' +                                                  //Code comptable
            CDS_Client.FieldByName('Tel2').asString + ';' +             //Commentaire
            CDS_Client.FieldByName('Tel').asString + ';' +              //Téléphone
            '' + ';' +                                                  //FAX
            CDS_Client.FieldByName('Port').asString + ';' +             //Portable
            CDS_Client.FieldByName('Mail').asString + ';' +             //E-Mail
            '' + ';' +                                                  //Code Barre national
            '' + ';' +                                                  //Class 1
            '' + ';' +                                                  //Class 2
            '' + ';' +                                                  //Class 3
            '' + ';' +                                                  //Class 4
            '' + ';' +                                                  //Class 5
            '');                                                        //Numéro
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Client.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des clients : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Traitement des fourniseurs
    try
      LibInfo  := 'Traitement des fournisseurs en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'fourn.csv') then
        DeleteFile(ChemImport+'fourn.csv');

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

      Add_CSV(ChemImport+'fourn.csv'  ,TranspoBeauteConcept + ';' +
                                       TranspoBeauteConcept + ';' +
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
                                       '');
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des fournisseurs : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des marques
    try
      LibInfo  := 'Traitement des marques en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'marque.csv') then
        DeleteFile(ChemImport+'marque.csv');

      Add_CSV(ChemImport+'marque.csv' ,'CODE;' +
                                       'CODE_FOU;' +
                                       'NOM');

      Add_CSV(ChemImport+'marque.csv' ,TranspoBeauteConcept + ';' +
                                       TranspoBeauteConcept + ';' +
                                       TranspoBeauteConcept);
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des marques : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des grilles de taille
    try
      LibInfo  := 'Traitement des grilles de taille en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'gr_taille.csv') then
        DeleteFile(ChemImport+'gr_taille.csv');

      Add_CSV(ChemImport+'gr_taille.csv'  ,'CODE;' +
                                           'NOM;' +
                                           'TYPE_GRILLE');

      Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +
                                         'UNIQUE' + ';' +
                                         TranspoBeauteConcept);
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des lignes de taille
    try
      LibInfo  := 'Traitement des lignes de taille en cours...';
      AjouterLog(LibInfo);

      if FileExists(ChemImport+'gr_taille_lig.csv') then
        DeleteFile(ChemImport+'gr_taille_lig.csv');

      Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +
                                             'NOM');

      Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +
                                             'UNIQUE');
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des lignes de taille : ' + E.Message, True);
        Exit;
      end;
    end;

    //Traitement des articles de vente
    try
      LibInfo  := 'Traitement des articles de vente en cours...';
      if FileExists(ChemImport+'Articles.csv') then
        DeleteFile(ChemImport+'Articles.csv');

      if FileExists(ChemImport+'code_barre.csv') then
        DeleteFile(ChemImport+'code_barre.csv');

      if FileExists(ChemImport+'prix.csv') then
        DeleteFile(ChemImport+'prix.csv');

      CDS_Vente.First;
      NbLigne  := CDS_Vente.RecordCount;
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
                                        'TVA');

      Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                            'TAILLE;' +
                                            'COULEUR;' +
                                            'EAN;' +
                                            'QTTE');

      Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                      'TAILLE;' +
                                      'PXCATALOGUE;' +
                                      'PX_ACHAT;' +
                                      'PX_VENTE;' +
                                      'CODE_FOU');

      while (Not CDS_Vente.eof) and (not stopImport) do
      Begin
        sCodeArticle := CDS_Vente.FieldByName('Code_article').AsString;

        Add_CSV(ChemImport+'Articles.csv',  CDS_Vente.FieldByName('Barcode').AsString + ';' +           //CODE
                                            TranspoBeauteConcept + ';' +                                //CODE_MRQ
                                            '0' + ';' +                                                 //CODE_GT
                                            sCodeArticle + '.' + CDS_Vente.FieldByName('Code_couleur').asString + ';' +                                        //CODE_FOURN
                                            CDS_Vente.FieldByName('Nom_articles').AsString + ';' +      //NOM
                                            '' + ';' +                                                  //DESCRIPTION
                                            TranspoBeauteConcept + ';' +                                //RAYON
                                            TranspoBeauteConcept + ';' +                                //FAMILLE
                                            TranspoBeauteConcept + ';' +                                //SS_FAM
                                            '' + ';' +                                                  //GENRE
                                            '' + ';' +                                                  //CLASS1
                                            '' + ';' +                                                  //CLASS2
                                            '' + ';' +                                                  //CLASS3
                                            '' + ';' +                                                  //CLASS4
                                            '' + ';' +                                                  //CLASS5
                                            '' + ';' +                                                  //IDREF_SSFAM
                                            CDS_Vente.FieldByName('Code_couleur').asString + ';' +      //COUL1
                                            '' + ';' +                                                  //COUL2
                                            '' + ';' +                                                  //COUL3
                                            '' + ';' +                                                  //COUL4
                                            '' + ';' +                                                  //COUL5
                                            '' + ';' +                                                  //COUL6
                                            '' + ';' +                                                  //COUL7
                                            '' + ';' +                                                  //COUL8
                                            '' + ';' +                                                  //COUL9
                                            '' + ';' +                                                  //COUL10
                                            '' + ';' +                                                  //COUL11
                                            '' + ';' +                                                  //COUL12
                                            '' + ';' +                                                  //COUL13
                                            '' + ';' +                                                  //COUL14
                                            '' + ';' +                                                  //COUL15
                                            '' + ';' +                                                  //COUL16
                                            '' + ';' +                                                  //COUL17
                                            '' + ';' +                                                  //COUL18
                                            '' + ';' +                                                  //COUL19
                                            '' + ';' +                                                  //COUL20
                                            '1' + ';' +                                                 //FIDELITE
                                            '' + ';' +                                                  //DATECREATION
                                            '' + ';' +                                                  //COLLECTION
                                            '' + ';' +                                                  //COMENT1
                                            '' + ';' +                                                  //COMENT2
                                            '20.0');                                                    //TVA

        Add_CSV(ChemImport+'code_barre.csv',CDS_Vente.FieldByName('Barcode').AsString + ';' +
                                            'UNIQUE' + ';' +
                                            CDS_Vente.FieldByName('Code_couleur').AsString + ';' +
                                            CDS_Vente.FieldByName('Barcode').AsString + ';' +
                                            '0');

        Add_CSV(ChemImport+'prix.csv',CDS_Vente.FieldByName('Barcode').AsString + ';' +
                                      'UNIQUE' + ';' +
                                      CDS_Vente.FieldByName('Prix_achat').asString + ';' +
                                      CDS_Vente.FieldByName('Prix_achat').asString + ';' +
                                      FloatToStr(RoundTo(StrToFloat(StringReplace(CDS_Vente.FieldByName('Prix_de_vente').AsString, ',', '.', [rfReplaceAll, rfIgnoreCase])) * 1.20, -2)) + ';' +
                                      sCodeArticle);

        Inc(Compteur);
        CDS_Vente.Next;
      end;
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
        Exit;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_Vente.Close;
    CDS_Client.Close;
    FreeAndNil(CDS_Vente);
    FreeAndNil(CDS_Client);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
end;

procedure TTranspoThread.TraitementBoutiquePlus;
Const
  TranspoBoutiquePlusFlexo = 'IMPORT-BoutiquePlus';
  PathBoutiquePlus = 'BoutiquePlus\';

  function GetHeader(aTab:array of string):string;
  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;

Var
  Tmp_SL          : TStringList;
  sPathARTICLE    : string;
  sPathPED_PRIX   : string;
  sPathPEDIGREE   : string;

  sTaille         : string;
  sRefFournisseur : string;
  sPx_Achat       : string;
  sPx_Vente       : string;

  CDS_ARTICLE   : TClientDataSet;     //Liste des Article
  CDS_PED_PRIX  : TClientDataSet;     //Liste des article de vente
  CDS_PEDIGREE  : TClientDataSet;     //Liste des article de vente
  //CDS_Article : TClientDataSet;     //Liste des article de vente
  //CDS_Article : TClientDataSet;     //Liste des article de vente
Begin
  {$REGION 'BoutiquePlus'}
  try
    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Flexo');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathBoutiquePlus;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_ARTICLE   := TClientDataSet.Create(nil);
    CDS_PED_PRIX  := TClientDataSet.Create(nil);
    CDS_PEDIGREE  := TClientDataSet.Create(nil);

    sPathARTICLE := ChemSource+ 'ARTICLE.TXT';
    if FileExists(sPathARTICLE) then
    begin
      if Frm_Principale.GetAddHeader then   //On ajoute les en-tête
      begin
        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.LoadFromFile(sPathARTICLE);      //Chargement du fichier
          Tmp_SL.Insert(0,GetHeader(BP_ARTICLE_COL));   //Ajout de l'en-tête
          Tmp_SL.SaveToFile(sPathARTICLE);        //Enregistrement du fichier
        finally
          FreeAndNil(Tmp_SL);
        end;
      end;
      if not LoadDataSet('ARTICLE',sPathARTICLE,'IDENT.',CDS_ARTICLE) then
        Exit;
    end
    else
    begin
      AjouterLog('Le fichier ' + sPathARTICLE + ' n''éxiste pas.', True);
      Exit;
    end;

    sPathPEDIGREE := ChemSource+ 'PEDIGREE.TXT';
    if FileExists(sPathPEDIGREE) then
    begin
      if Frm_Principale.GetAddHeader then   //On ajoute les en-tête
      begin
        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.LoadFromFile(sPathPEDIGREE);      //Chargement du fichier
          Tmp_SL.Insert(0,GetHeader(BP_PEDIGREE_COL));   //Ajout de l'en-tête
          Tmp_SL.SaveToFile(sPathPEDIGREE);        //Enregistrement du fichier
        finally
          FreeAndNil(Tmp_SL);
        end;
      end;
      if not LoadDataSet('PEDIGREE',sPathPEDIGREE,'CODE_PEDIGREE',CDS_PEDIGREE) then
        Exit;
    end
    else
    begin
      AjouterLog('Le fichier ' + sPathPEDIGREE + ' n''éxiste pas.', True);
      Exit;
    end;

    sPathPED_PRIX := ChemSource+ 'PED_PRIX.TXT';
    if FileExists(sPathPED_PRIX) then
    begin
      if Frm_Principale.GetAddHeader then   //On ajoute les en-tête
      begin
        Tmp_SL := TStringList.Create;
        try
          Tmp_SL.LoadFromFile(sPathPED_PRIX);      //Chargement du fichier
          Tmp_SL.Insert(0,GetHeader(BP_PED_PRIX_COL));   //Ajout de l'en-tête
          Tmp_SL.SaveToFile(sPathPED_PRIX);        //Enregistrement du fichier
        finally
          FreeAndNil(Tmp_SL);
        end;
      end;
      if not LoadDataSet('PED_PRIX',sPathPED_PRIX,'CODE_PEDIGREE',CDS_PED_PRIX) then
        Exit;
    end
    else
    begin
      AjouterLog('Le fichier ' + sPathPED_PRIX + ' n''éxiste pas.', True);
      Exit;
    end;

    //Traitement des articles de location
    try
      LibInfo  := 'Traitement des articles de location en cours...';
      if FileExists(ChemImport+'Loc\'+'Articles.csv') then
        DeleteFile(ChemImport+'Loc\'+'Articles.csv');

      CDS_ARTICLE.First;
      NbLigne  := CDS_ARTICLE.RecordCount;
      Compteur := 0;
      Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                'LIBELLE;' +
                                                'REFMARQUE;' +
                                                'NUMSERIE;' +
                                                'CATEGORIE;' +
                                                'COMMENTAIRE;' +
                                                'MARQUE;' +
                                                'GRILLETAILLE;' +
                                                'TAILLE;' +
                                                'CB1;' +
                                                'CB2;' +
                                                'CB3;' +
                                                'CB4;' +
                                                'STATUT;' +
                                                'DATEACHAT;' +
                                                'PRIXACHAT;' +
                                                'PRIXVENTE;' +
                                                'DATECESSION;' +
                                                'PRIXCESSION;' +
                                                'DUREEAMT;' +
                                                'LOCFOURNISSEUR;' +
                                                'SOUSFICHE;' +
                                                'SFCODE;' +
                                                'RESULTAT');
      while (Not CDS_ARTICLE.eof) and (not stopImport) do
      Begin
        //Gestion du code produit et CB
        if CDS_ARTICLE.FieldByName('REFERENCE_FOURNISSEUR').asString = '' then
          sRefFournisseur := TranspoBoutiquePlusFlexo
        else
          sRefFournisseur := CDS_ARTICLE.FieldByName('REFERENCE_FOURNISSEUR').asString;

        //Gestion taille
        CDS_PEDIGREE.Locate('CODE_PEDIGREE',CDS_ARTICLE.FieldByName('CODE_PEDIGREE').AsString,[]);
        sTaille := CDS_PEDIGREE.FieldByName('TEXTE_LIBRE').AsString;
        if sTaille = '' then
          sTaille := 'UNIQUE';

        //Gestion des prix
        CDS_PED_PRIX.Locate('CODE_PEDIGREE',CDS_ARTICLE.FieldByName('CODE_PEDIGREE').AsString,[]);
        sPx_Achat := StringReplace(CDS_PED_PRIX.FieldByName('PX_ACHAT_HT').AsString, '.', ',', [rfReplaceAll,rfIgnoreCase]);
        if sPx_Achat = '' then
          sPx_Achat := '0';

        sPx_Vente := StringReplace(CDS_PED_PRIX.FieldByName('PX_VENTE_TTC').AsString, '.', ',', [rfReplaceAll,rfIgnoreCase]);
        if sPx_Vente = '' then
          sPx_Vente := '0';

        Add_CSV(ChemImport+'Loc\'+'Articles.csv', sRefFournisseur + ';' +
                                                  CDS_PEDIGREE.FieldByName('DESIGNATION_DE_L_ARTICLE').AsString + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  TranspoBoutiquePlusFlexo + ';' +
                                                  sTaille + ';' +
                                                  sRefFournisseur + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  'LOCATION' + ';' +
                                                  '01/01/1980' + ';' +
                                                  sPx_Achat + ';' +
                                                  sPx_Vente + ';' +
                                                  '' + ';' +
                                                  '' + ';' +
                                                  '3' + ';' +
                                                  'N' + ';' +
                                                  'N' + ';' +
                                                  '' + ';' +
                                                  '');

        Inc(Compteur);

        CDS_ARTICLE.Next;
      End;
    except
      on E:Exception do
      begin
        AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
        Exit;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    CDS_ARTICLE.Close;
    CDS_PED_PRIX.Close;
    CDS_PEDIGREE.Close;
    FreeAndNil(CDS_ARTICLE);
    FreeAndNil(CDS_PED_PRIX);
    FreeAndNil(CDS_PEDIGREE);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
End;


procedure TTranspoThread.TraitementCileaLoc;
Const
  TranspoCileaLoc = 'IMPORT-CileaLoc';
  PathCileaLoc = 'CileaLoc\';

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
Var
  sSFamille     : string;
  sMarque       : string;
  sDateCession  : string;
  sCommentaire  : string;
  sCategorie    : string;
  sDate         : string;
  sStatut       : string;
  sCB1          : string;
  sCB2          : string;
  sGender       : string;
  sLevel        : string;
  sCategory     : string;
  sRadius       : string;
  sWaist        : string;
  sTva          : string;
  sCodeCouleur  : string;
  sCouleur      : string;
  sTaille       : string;
  sDateCreation : string;
  sDateDernierPass : string;
  sRefArt       : string;
  sStrings      : TStrings;
  TabCouleur    : Array [1..20] of String;  //Couleur de l'article

  I, J : Integer;
  CDS_Article           : TClientDataSet;     //Liste des Article de Vente
  CDS_Article_Loc       : TClientDataSet;     //Liste des Article de Location
  CDS_Article_Loc_Class : TClientDataSet;     //Liste des Article de Location
  CDS_Client            : TClientDataSet;     //Liste des Clients
  CDS_Couleur           : TClientDataSet;     //Liste des Couleurs
  CDS_Famille           : TClientDataSet;     //Liste des Familles
  CDS_Famille_Loc       : TClientDataSet;     //Liste des Familles de Location
  CDS_Fourn             : TClientDataSet;     //Liste des Fournisseurs
  CDS_Prix_art          : TClientDataSet;     //Liste des Prix des articles
  CDS_Taille            : TClientDataSet;     //Liste des Grilles de taille
  CDS_TVA               : TClientDataSet;     //Liste des TVA
  CDS_CodeBarre         : TClientDataSet;     //Liste des Codes Barres
Begin
  {$REGION 'CileaLoc'}
  try
    sStrings := TStringList.Create;

    //Verrouille le traitement pour qu'il ne se relance pas
    StartImport := False;

    //Message d'information
    LibInfo := 'Traitement en cours...';

    //Log
    AjouterLog('Début du traitement Sports Rental');

    //Initialise le chemin pour la création des fichier
    ChemImport  := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName))+'Import\' + PathCileaLoc;

    //Création des ClientsDataSet pour l'intégration des informations source
    CDS_Article           := TClientDataSet.Create(nil);
    CDS_Article_Loc       := TClientDataSet.Create(nil);
    CDS_Article_Loc_Class := TClientDataSet.Create(nil);
    CDS_Client            := TClientDataSet.Create(nil);
    CDS_Couleur           := TClientDataSet.Create(nil);
    CDS_Famille           := TClientDataSet.Create(nil);
    CDS_Famille_Loc       := TClientDataSet.Create(nil);
    CDS_Fourn             := TClientDataSet.Create(nil);
    CDS_Prix_art          := TClientDataSet.Create(nil);
    CDS_Taille            := TClientDataSet.Create(nil);
    CDS_TVA               := TClientDataSet.Create(nil);
    CDS_CodeBarre         := TClientDataSet.Create(nil);

    //Récupération des informations à intégrer
    if DoClient then
    begin
      if not LoadDataSet('clients',ChemSource+'Client.csv','CodeCli',CDS_Client) then
        Exit;
    end;

    if DoLocation or DoVente then
    begin
      if not LoadDataSet('fournisseur',ChemSource+'Fourn.csv','Codefour',CDS_Fourn) then
        Exit;
    end;

    if DoLocation then
    begin
      if not LoadDataSet('articles de location',ChemSource+'Article_Loc.csv','REFART_LOC',CDS_Article_Loc) then
        Exit;

      if not LoadDataSet('articles de location classement',ChemSource+'Article_Loc_Class.csv','REF_ART',CDS_Article_Loc_Class) then
        Exit;

      if not LoadDataSet('catégorie des articles de location',ChemSource+'Famille_Loc.csv','IDFamille_Loc',CDS_Famille_Loc) then
        Exit;
    end;

    if DoVente then
    begin
      if not LoadDataSet('articles',ChemSource+'Article.csv','RefArt',CDS_Article) then
        Exit;

      if not LoadDataSet('Couleur',ChemSource+'Couleur.csv','CodeCouleur',CDS_Couleur) then
        Exit;

      if not LoadDataSet('catégorie des articles',ChemSource+'Famille.csv','CodeFam',CDS_Famille) then
        Exit;

      if not LoadDataSet('Prix article',ChemSource+'Prix_art.csv','PRCLEUNIK',CDS_Prix_art) then
        Exit;

      if not LoadDataSet('grilles de taille',ChemSource+'Taille.csv','Codetaille',CDS_Taille) then
        Exit;

      if not LoadDataSet('TVA',ChemSource+'TVA.csv','CodeTVA',CDS_TVA) then
        Exit;

      if not LoadDataSet('Codes Barres',ChemSource+'Arttay.csv','codebarre',CDS_CodeBarre) then
        Exit;
    end;

    if DoClient then
    begin
      //Traitement des clients
      try
        LibInfo  := 'Traitement des clients en cours...';
        AjouterLog(LibInfo);

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
                                         'NUMERO;' +
                                         'DATE_NAISSANCE;' +
                                         'DATE_CREATION');
        while (Not CDS_Client.eof) and (not stopImport) do
        Begin
          sDateCreation := '';
          if CDS_Client.FindField('date_Reelle_creation') <> nil then
            sDateCreation := CDS_Client.FieldByName('date_Reelle_creation').asString;
          if sDateCreation = '' then
            if CDS_Client.FindField('Date_creation') <> nil then
              sDateCreation := CDS_Client.FieldByName('Date_creation').asString;

          sDateDernierPass := '';
          if CDS_Client.FindField('Date_DernierPass') <> nil then
            sDateDernierPass := 'Date de dernier passage : ' +CDS_Client.FieldByName('Date_DernierPass').asString;

          Add_CSV(ChemImport+'clients.csv',CDS_Client.FieldByName('CodeCli').asString + ';' +                                         //CODE
                                           'PART' + ';' +                                                                             //TYP
                                           CDS_Client.FieldByName('NomCli').asString + ';' +                                          //NOM_RS1
                                           CDS_Client.FieldByName('PreCli').asString + ';' +                                          //PREN_RS2
                                           '' + ';' +                                                                                 //CIV
                                           CDS_Client.FieldByName('AdrCli1').asString + ';' +                                         //ADR1
                                           CDS_Client.FieldByName('AdrCli2').asString + ';' +                                         //ADR2
                                           '' + ';' +                                                                                 //ADR3
                                           CDS_Client.FieldByName('CPCli').asString + ';' +                                           //CP
                                           CDS_Client.FieldByName('VilCli').asString + ';' +                                          //VILLE
                                           '' + ';' +                                                                                 //PAYS
                                           CDS_Client.FieldByName('num_comptable').asString + ';' +                                   //CODE_COMPTABLE
                                           sDateDernierPass + ';' +                                                                   //COM
                                           CDS_Client.FieldByName('TelCli').asString + ';' +                                          //TEL
                                           '' + ';' +                                                                                 //FAX_TTRAV
                                           '' + ';' +                                                                                 //PORTABLE
                                           CDS_Client.FieldByName('EmailCli').asString + ';' +                                        //EMAIL
                                           '' + ';' +                                                                                 //CB_NATIONAL
                                           '' + ';' +                                                                                 //CLASS1
                                           '' + ';' +                                                                                 //CLASS2
                                           '' + ';' +                                                                                 //CLASS3
                                           '' + ';' +                                                                                 //CLASS4
                                           '' + ';' +                                                                                 //CLASS5
                                           '' + ';' +                                                                                 //CHRONO
                                           '' + ';' +                                                                                 //DATE_NAISSANCE
                                           sDateCreation);                                                                            //DATE_CREATION
          Inc(Compteur);
          AjouterLog(IntToStr(Compteur) + '/' + IntToStr(NbLigne));
          CDS_Client.Next;
        End;
        CDS_Client.Close;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des clients : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoLocation then
    begin
      //Traitement des articles de location
      try
        LibInfo  := 'Traitement des articles de location en cours...';
        if FileExists(ChemImport+'Loc\'+'Articles.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles.csv');

        if FileExists(ChemImport+'Loc\'+'Articles_SF.csv') then
          DeleteFile(ChemImport+'Loc\'+'Articles_SF.csv');

        CDS_Article_Loc.First;
        NbLigne  := CDS_Article_Loc.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Loc\'+'Articles.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT;' +
                                                  'DESCRIPTION;' +
                                                  'ARCHIVER;' +
                                                  'LOUEAUFOURN;' +
                                                  'DATEFAB;' +
                                                  'DUREEVIE;' +
                                                  'CHRONO;' +
                                                  'CLASSEMENT1;' +
                                                  'CLASSEMENT2;' +
                                                  'CLASSEMENT3;' +
                                                  'CLASSEMENT4;' +
                                                  'CLASSEMENT5');

        Add_CSV(ChemImport+'Loc\'+'Articles_SF.csv' ,'CODE;' +
                                                  'LIBELLE;' +
                                                  'REFMARQUE;' +
                                                  'NUMSERIE;' +
                                                  'CATEGORIE;' +
                                                  'COMMENTAIRE;' +
                                                  'MARQUE;' +
                                                  'GRILLETAILLE;' +
                                                  'TAILLE;' +
                                                  'CB1;' +
                                                  'CB2;' +
                                                  'CB3;' +
                                                  'CB4;' +
                                                  'STATUT;' +
                                                  'DATEACHAT;' +
                                                  'PRIXACHAT;' +
                                                  'PRIXVENTE;' +
                                                  'DATECESSION;' +
                                                  'PRIXCESSION;' +
                                                  'DUREEAMT;' +
                                                  'LOCFOURNISSEUR;' +
                                                  'SOUSFICHE;' +
                                                  'SFCODE;' +
                                                  'RESULTAT;' +
                                                  'DESCRIPTION;' +
                                                  'ARCHIVER;' +
                                                  'LOUEAUFOURN;' +
                                                  'DATEFAB;' +
                                                  'DUREEVIE;' +
                                                  'CHRONO;' +
                                                  'CLASSEMENT1;' +
                                                  'CLASSEMENT2;' +
                                                  'CLASSEMENT3;' +
                                                  'CLASSEMENT4;' +
                                                  'CLASSEMENT5');

        while (Not CDS_Article_Loc.eof) and (not stopImport) do
        Begin
          sCommentaire := '';
          sDateCession := '';
          sCB1 := '';
          sCB2 := '';

          //Gestion Catégorie Vente
          CDS_Famille_Loc.Locate('IDFamille_Loc',CDS_Article_Loc.FieldByName('IDFamille_Loc').AsString,[]);
          sCategorie := CDS_Famille_Loc.FieldByName('libfam_loc').AsString;
          if sCategorie = '' then
            sCategorie := TranspoCileaLoc;

          //Gestion du code marque
          CDS_Fourn.Locate('Codefour',CDS_Article_Loc.FieldByName('Codefour').AsString,[]);
          sMarque := CDS_Fourn.FieldByName('LibFour').AsString;
          if sMarque = '' then
            sMarque := TranspoCileaLoc;

          //Gestion du statut
          if CDS_Article_Loc.FieldByName('etat_art').AsString = '' then
          begin
            sStatut := 'LOCATION';
          end
          else
            if CDS_Article_Loc.FieldByName('etat_art').AsString = 'C' then
            begin
              sStatut := 'CASSE';
              sCommentaire := 'Date du Statut : ' + CDS_Article_Loc.FieldByName('Date_sortie').asString;
            end
            else
              if CDS_Article_Loc.FieldByName('etat_art').AsString = 'V' then
              begin
                sStatut := 'VENDU';
                sCommentaire := 'Date du Statut : ' + CDS_Article_Loc.FieldByName('Date_sortie').asString;
                sDateCession := CDS_Article_Loc.FieldByName('Date_sortie').asString;
              end
              else
                if CDS_Article_Loc.FieldByName('etat_art').AsString = 'P' then
                begin
                  sStatut := 'PERDU';
                  sCommentaire := 'Date du Statut : ' + CDS_Article_Loc.FieldByName('Date_sortie').asString;
                end
                else
                  if CDS_Article_Loc.FieldByName('etat_art').AsString = 'N' then
                  begin
                    sStatut := 'N';
                    sCommentaire := 'Date du Statut : ' + CDS_Article_Loc.FieldByName('Date_sortie').asString;
                  end
                  else
                  begin
                    sStatut := 'INCONNU';
                    sCommentaire := 'Date du Statut : ' + CDS_Article_Loc.FieldByName('Date_sortie').asString;
                  end;

          if CDS_Article_Loc.FieldByName('Fixation').asString <> '' then
          begin
            sCommentaire := sCommentaire + ' - Fixation = ' + CDS_Article_Loc.FieldByName('Fixation').asString;
          end;

          if sMarque = '' then
            sMarque := TranspoCileaLoc;

          //Gestion de la date
          if CDS_Article_Loc.FieldByName('Date_Entree_ARTLOC').asString = '' then
            sDate := '01/01/1980'
          else
            sDate := CDS_Article_Loc.FieldByName('Date_Entree_ARTLOC').asString;

          if CDS_Article_Loc.FieldByName('REFART_LOC').asString <> '' then
          begin
            sStrings.Clear;
            ExtractStrings(['/'], [], PChar(CDS_Article_Loc.FieldByName('REFART_LOC').asString), sStrings);
            sRefArt := sStrings.Strings[0];
          end
          else
            sRefArt := '';

          //Gestion des classements
          if CDS_Article_Loc_Class.Locate('REF_ART',sRefArt + '/',[loCaseInsensitive]) then
          begin
            sGender := CDS_Article_Loc_Class.FieldByName('GENDER').AsString;
            sLevel := CDS_Article_Loc_Class.FieldByName('LEVEL').AsString;
            sCategory := CDS_Article_Loc_Class.FieldByName('CATEGORY').AsString;
            sRadius := CDS_Article_Loc_Class.FieldByName('RADIUS').AsString;
            sWaist := CDS_Article_Loc_Class.FieldByName('WAIST').AsString;
          end
          else
          begin
            sGender := '';
            sLevel := '';
            sCategory := '';
            sRadius := '';
            sWaist := '';
          end;

          //Gestion Code barre
          sCB1 := CDS_Article_Loc.FieldByName('CB_ARTLOC1').asString;
          sCB2 := CDS_Article_Loc.FieldByName('CB_ARTLOC2').asString;
          if sCB1 = '' then
            sCB1 := sRefArt;
          if sCB2 = sCB1 then
            sCB2 := '';

          Add_CSV(ChemImport+'Loc\'+'Articles.csv',sCB1 + ';' +                                                   //CODE
                                                CDS_Article_Loc.FieldByName('Libelle_ARTLOC').asString + ';' +    //LIBELLE
                                                sRefArt + ';' +                                                   //REFMARQUE
                                                CDS_Article_Loc.FieldByName('NUM_SERIE').asString + ';' +         //NUMSERIE
                                                sCategorie + ';' +                                                //CATEGORIE
                                                sCommentaire + ';' +                                              //COMMENTAIRE
                                                sMarque + ';' +                                                   //MARQUE
                                                TranspoCileaLoc + ';' +                                           //GRILLETAILLE
                                                CDS_Article_Loc.FieldByName('TAILLE_ARTLOC').asString + ';' +     //TAILLE
                                                sCB2 + ';' +                                                      //CB1
                                                '' + ';' +                                                        //CB2
                                                '' + ';' +                                                        //CB3
                                                '' + ';' +                                                        //CB4
                                                sStatut + ';' +                                                   //STATUT
                                                sDate + ';' +                                                     //DATEACHAT
                                                CDS_Article_Loc.FieldByName('Prix_Achat_ARTLOC').asString + ';' + //PRIXACHAT
                                                CDS_Article_Loc.FieldByName('PRIX_VENTE_ARTLOC').asString + ';' + //PRIXVENTE
                                                sDateCession + ';' +                                              //DATECESSION
                                                '' + ';' +                                                        //PRIXCESSION
                                                '3' + ';' +                                                       //DUREEAMT
                                                'N' + ';' +                                                       //LOCFOURNISSEUR
                                                'N' + ';' +                                                       //SOUSFICHE
                                                '' + ';' +                                                        //SFCODE
                                                '' + ';' +                                                        //RESULTAT
                                                '' + ';' +                                                        //DESCRIPTION
                                                '0' + ';' +                                                       //ARCHIVER
                                                '0' + ';' +                                                       //LOUEAUFOURN
                                                '' + ';' +                                                        //DATEFAB
                                                '' + ';' +                                                        //DUREEVIE
                                                '' + ';' +                                                        //CHRONO
                                                sGender + ';' +                                                   //CLASSEMENT1
                                                sLevel + ';' +                                                    //CLASSEMENT2
                                                sCategory + ';' +                                                 //CLASSEMENT3
                                                sRadius + ';' +                                                   //CLASSEMENT4
                                                sWaist                                                            //CLASSEMENT5
                                                );

          //Création d'une sous fiche pour les fixations
          if CDS_Article_Loc.FieldByName('Fixation').asString <> '' then
          begin
            Add_CSV(ChemImport+'Loc\'+'Articles_SF.csv',CDS_Article_Loc.FieldByName('REFART_LOC').asString + '-FIX;' +  //CODE
                                                  'FIXATION' + CDS_Article_Loc.FieldByName('Fixation').asString + ';' + //LIBELLE
                                                  '' + ';' +                                                            //REFMARQUE
                                                  '' + ';' +                                                            //NUMSERIE
                                                  '' + ';' +                                                            //CATEGORIE
                                                  '' + ';' +                                                            //COMMENTAIRE
                                                  sMarque + ';' +                                                       //MARQUE
                                                  '' + ';' +                                                            //GRILLETAILLE
                                                  '' + ';' +                                                            //TAILLE
                                                  '' + ';' +                                                            //CB1
                                                  '' + ';' +                                                            //CB2
                                                  '' + ';' +                                                            //CB3
                                                  '' + ';' +                                                            //CB4
                                                  sStatut + ';' +                                                       //STATUT
                                                  sDate + ';' +                                                         //DATEACHAT
                                                  '' + ';' +                                                            //PRIXACHAT
                                                  '' + ';' +                                                            //PRIXVENTE
                                                  sDateCession + ';' +                                                  //DATECESSION
                                                  '' + ';' +                                                            //PRIXCESSION
                                                  '3' + ';' +                                                           //DUREEAMT
                                                  'N' + ';' +                                                           //LOCFOURNISSEUR
                                                  'O' + ';' +                                                           //SOUSFICHE
                                                  CDS_Article_Loc.FieldByName('REFART_LOC').asString + ';' +            //SFCODE
                                                  '' + ';' +                                                            //RESULTAT
                                                  '' + ';' +                                                            //DESCRIPTION
                                                  '0' + ';' +                                                           //ARCHIVER
                                                  '0' + ';' +                                                           //LOUEAUFOURN
                                                  '' + ';' +                                                            //DATEFAB
                                                  '' + ';' +                                                            //DUREEVIE
                                                  '' + ';' +                                                            //CHRONO
                                                  '' + ';' +                                                            //CLASSEMENT1
                                                  '' + ';' +                                                            //CLASSEMENT2
                                                  '' + ';' +                                                            //CLASSEMENT3
                                                  '' + ';' +                                                            //CLASSEMENT4
                                                  ''                                                                    //CLASSEMENT5
                                                  );
          end;

          Inc(Compteur);

          CDS_Article_Loc.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    if DoVente then
    begin
      //Traitement des fourniseurs & marque
      try
        LibInfo  := 'Traitement des fournisseurs & marque en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'fourn.csv') then
          DeleteFile(ChemImport+'fourn.csv');

        if FileExists(ChemImport+'marque.csv') then
          DeleteFile(ChemImport+'marque.csv');

        Add_CSV(ChemImport+'fourn.csv'  ,'CODE;' +          //CODE
                                         'NOM;' +           //NOM
                                         'ADR1;' +          //LIGNE1
                                         'ADR2;' +          //LIGNE2
                                         'ADR3;' +          //LIGNE3
                                         'CP;' +            //CP
                                         'VILLE;' +         //VILLE
                                         'PAYS;' +          //PAYS
                                         'TEL;' +           //TEL
                                         'FAX;' +           //FAX
                                         'PORTABLE;' +      //PORTABLE
                                         'EMAIL;' +         //EMAIL
                                         'COMMENTAIRE;' +   //COMMENTAIRE
                                         'NUM_CLT;' +       //NUM_CLT_FOU
                                         'COND_PAIE');      //COND_PAIE

        Add_CSV(ChemImport+'fourn.csv'  ,TranspoCileaLoc + ';' +  //CODE
                                         TranspoCileaLoc + ';' +  //NOM
                                         '' + ';' +               //LIGNE1
                                         '' + ';' +               //LIGNE2
                                         '' + ';' +               //LIGNE3
                                         '' + ';' +               //CP
                                         '' + ';' +               //VILLE
                                         '' + ';' +               //PAYS
                                         '' + ';' +               //TEL
                                         '' + ';' +               //FAX
                                         '' + ';' +               //PORTABLE
                                         '' + ';' +               //EMAIL
                                         '' + ';' +               //COMMENTAIRE
                                         '' + ';' +               //NUM_CLT_FOU
                                         '');                     //COND_PAIE

        Add_CSV(ChemImport+'marque.csv' ,'CODE;' +      //CODE
                                         'CODE_FOU;' +  //CODE_FOU
                                         'NOM');        //NOM

        Add_CSV(ChemImport+'marque.csv' ,TranspoCileaLoc + ';' +  //CODE
                                         TranspoCileaLoc + ';' +  //CODE_FOU
                                         TranspoCileaLoc);        //NOM

        CDS_Fourn.First;
        while (Not CDS_Fourn.eof) and (not stopImport) do
        begin
          Add_CSV(ChemImport+'fourn.csv'  ,CDS_Fourn.FieldByName('Codefour').AsString + ';' +  //CODE
                                           CDS_Fourn.FieldByName('LibFour').AsString + ';' +   //NOM
                                           CDS_Fourn.FieldByName('AdrFour1').AsString + ';' +  //LIGNE1
                                           CDS_Fourn.FieldByName('AdrFour2').AsString + ';' +  //LIGNE2
                                           '' + ';' +                                          //LIGNE3
                                           CDS_Fourn.FieldByName('CPFour').AsString + ';' +    //CP
                                           CDS_Fourn.FieldByName('VilFour').AsString + ';' +   //VILLE
                                           '' + ';' +                                          //PAYS
                                           CDS_Fourn.FieldByName('TelFour').AsString + ';' +   //TEL
                                           CDS_Fourn.FieldByName('FaxFour').AsString + ';' +   //FAX
                                           '' + ';' +                                          //PORTABLE
                                           CDS_Fourn.FieldByName('EmailFour').AsString + ';' + //EMAIL
                                           CDS_Fourn.FieldByName('Contact').AsString + ';' +   //COMMENTAIRE
                                           '' + ';' +                                          //NUM_CLT_FOU
                                           '');                                                //COND_PAIE

          Add_CSV(ChemImport+'marque.csv' ,CDS_Fourn.FieldByName('Codefour').AsString + ';' +   //CODE
                                           CDS_Fourn.FieldByName('Codefour').AsString + ';' +   //CODE_FOU
                                           CDS_Fourn.FieldByName('LibFour').AsString);          //NOM

          CDS_Fourn.Next;
        end;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des fournisseurs et fournisseur : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des grilles de taille
      try
        LibInfo  := 'Traitement des grilles de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille.csv') then
          DeleteFile(ChemImport+'gr_taille.csv');

        CDS_Taille.Open;
        CDS_Taille.First;
        NbLigne  := CDS_Taille.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille.csv','CODE;' +        //CODE
                                           'NOM;' +         //NOM
                                           'TYPE_GRILLE');  //TYPE_GRILLE

        Add_CSV(ChemImport+'gr_taille.csv','0' + ';' +        //CODE
                                           'UNIQUE' + ';' +   //NOM
                                           TranspoCileaLoc);  //TYPE_GRILLE

        while (Not CDS_Taille.eof) and (not stopImport) do
        Begin
          Add_CSV(ChemImport+'gr_taille.csv',CDS_Taille.FieldByName('Codetaille').asString + ';' +    //CODE
                                             CDS_Taille.FieldByName('libtaille').asString + ';' +     //NOM
                                             TranspoCileaLoc);                                        //TYPE_GRILLE
              Inc(Compteur);
              CDS_Taille.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des grilles de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des lignes de taille
      try
        LibInfo  := 'Traitement des lignes de taille en cours...';
        AjouterLog(LibInfo);

        if FileExists(ChemImport+'gr_taille_lig.csv') then
          DeleteFile(ChemImport+'gr_taille_lig.csv');

        CDS_Taille.First;
        NbLigne  := CDS_Taille.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'gr_taille_lig.csv','CODE_GT;' +   //CODE_GT
                                               'NOM');        //NOM

        Add_CSV(ChemImport+'gr_taille_lig.csv','0' + ';' +    //CODE_GT
                                               'UNIQUE');     //NOM

        while (Not CDS_Taille.eof) and (not stopImport) do
        Begin
          for I := 2 to CDS_Taille.FieldCount - 1 do
          Begin
            if (Trim(CDS_Taille.Fields[I].AsString) <> '') then
            Begin
              Add_CSV(ChemImport+'gr_taille_lig.csv',CDS_Taille.FieldByName('Codetaille').asString + ';' +    //CODE_GT
                                                     CDS_Taille.Fields[I].asString);                          //NOM
            End;
          end;
          Inc(Compteur);
          CDS_Taille.Next;
        End;
      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des lignes de taille : ' + E.Message, True);
          Exit;
        end;
      end;

      //Traitement des articles de vente
      try
        LibInfo  := 'Traitement des articles de vente en cours...';
        if FileExists(ChemImport+'Articles.csv') then
          DeleteFile(ChemImport+'Articles.csv');

        if FileExists(ChemImport+'code_barre.csv') then
          DeleteFile(ChemImport+'code_barre.csv');

        if FileExists(ChemImport+'prix.csv') then
          DeleteFile(ChemImport+'prix.csv');

        CDS_Article.First;
        NbLigne  := CDS_Article.RecordCount;
        Compteur := 0;
        Add_CSV(ChemImport+'Articles.csv','CODE;' +
                                          'CODE_MRQ;' +
                                          'CODE_GT;' +
                                          'CODE_FOURN;' +
                                          'NOM;' +
                                          'DESCRIPTION;' +
                                          'ACTIVITE;' +
                                          'UNIVERS;' +
                                          'SECTEUR;' +
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
                                          'TVA');

        Add_CSV(ChemImport+'code_barre.csv'  ,'CODE_ART;' +
                                              'TAILLE;' +
                                              'COULEUR;' +
                                              'EAN;' +
                                              'QTTE');

        Add_CSV(ChemImport+'prix.csv'  ,'CODE_ART;' +
                                        'TAILLE;' +
                                        'PXCATALOGUE;' +
                                        'PX_ACHAT;' +
                                        'PX_VENTE;' +
                                        'CODE_FOU;' +
                                        'COULEUR');

        while (Not CDS_Article.eof) and (not stopImport) do
        Begin
          //Traitement des familles
          if CDS_Famille.Locate('CodeFam',CDS_Article.FieldByName('CodeFam').AsString,[]) then
            sSFamille := CDS_Famille.FieldByName('LibFam').AsString
          else
            sSFamille := '';
          if sSFamille = '' then
            sSFamille  := TranspoCileaLoc;

          //Traitement des couleurs.
          for I := 1 to 21 do
            TabCouleur[I] := '';
          J := 1;
          if CDS_Couleur.Locate('CodeCouleur',CDS_Article.FieldByName('CodeCouleur').AsString,[]) then
          begin
            for I := 2 to CDS_Couleur.FieldCount - 1 do
            begin
              if (CDS_Couleur.Fields[I].AsString <> '') then
              begin
                if J < 21 then
                begin
                  TabCouleur[J] := CDS_Couleur.Fields[I].AsString;
                  Inc(J);
                end
                else
                  AjouterLog('Plus de couleur, Article : ' + CDS_Article.FieldByName('RefArt').AsString + ' - Couleur : ' + CDS_Couleur.Fields[I].AsString, False);
              end;
            end;
          end;
          if TabCouleur[1] = '' then
            TabCouleur[1] := 'UNICOLOR';

          //Traitement de la TVA
          if CDS_TVA.Locate('CodeTVA',CDS_Article.FieldByName('CodeTVA').AsString,[]) then
            sTva := CDS_TVA.FieldByName('TauxTVA').AsString
          else
            sTva := '';
          if (sTva = '') or (sTva = '0') then
            sTva  := '20';

          Add_CSV(ChemImport+'Articles.csv',  CDS_Article.FieldByName('RefArt').AsString + ';' +          //CODE
                                              CDS_Article.FieldByName('Codefour').AsString + ';' +        //CODE_MRQ
                                              CDS_Article.FieldByName('Codetaille').AsString + ';' +      //CODE_GT
                                              CDS_Article.FieldByName('REF_FOURN').AsString + ';' +       //CODE_FOURN
                                              CDS_Article.FieldByName('LibArtFacture').AsString + ';' +   //NOM
                                              '' + ';' +                                                  //DESCRIPTION
                                              'Domaine principale' + ';' +                                //ACTIVITE
                                              'TEXTILE' + ';' +                                           //UNIVERS
                                              'Non défini' + ';' +                                        //SECTEUR
                                              TranspoCileaLoc + ';' +                                     //RAYON
                                              TranspoCileaLoc + ';' +                                     //FAMILLE
                                              sSFamille + ';' +                                           //SS_FAM
                                              '' + ';' +                                                  //GENRE
                                              '' + ';' +                                                  //CLASS1
                                              '' + ';' +                                                  //CLASS2
                                              '' + ';' +                                                  //CLASS3
                                              '' + ';' +                                                  //CLASS4
                                              '' + ';' +                                                  //CLASS5
                                              '0' + ';' +                                                 //IDREF_SSFAM
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
                                              CDS_Article.FieldByName('date_entree').AsString + ';' +     //DATECREATION
                                              '' + ';' +                                                  //COLLECTION
                                              '' + ';' +                                                  //COMENT1
                                              '' + ';' +                                                  //COMENT2
                                              sTva);                                                      //TVA

          CDS_CodeBarre.Filtered  := False;
          CDS_CodeBarre.Filter    := 'RefArt = ' + QuotedStr(CDS_Article.FieldByName('RefArt').AsString);
          CDS_CodeBarre.Filtered  := True;
          CDS_CodeBarre.First;

          //code barre de base
          if CDS_Article.FieldByName('CodBarArt').AsString <> '' then
            Add_CSV(ChemImport+'code_barre.csv',CDS_Article.FieldByName('RefArt').AsString + ';' +
                                               'UNIQUE' + ';' +
                                               'UNICOLOR' + ';' +
                                               CDS_Article.FieldByName('CodBarArt').AsString + ';' +
                                               CDS_Article.FieldByName('Stockinv').AsString);

          while not CDS_CodeBarre.Eof do
          begin
            if CDS_Taille.Locate('Codetaille',CDS_Article.FieldByName('Codetaille').AsString,[]) then
              sTaille := CDS_Taille.Fields[1+CDS_CodeBarre.FieldByName('lataille').AsInteger].AsString
            else
              sTaille := '';
            if sTaille = '' then
              sTaille := 'UNIQUE';

            if CDS_Couleur.Locate('CodeCouleur',CDS_Article.FieldByName('CodeCouleur').AsString,[]) then
              sCouleur := CDS_Couleur.Fields[1+CDS_CodeBarre.FieldByName('CodeCouleur').AsInteger].AsString
            else
              sCouleur := '';
            if sCouleur = '' then
              sCouleur := 'UNICOLOR';


            Add_CSV(ChemImport+'code_barre2.csv',CDS_CodeBarre.FieldByName('RefArt').AsString + ';' +
                                                sTaille + ';' +
                                                sCouleur + ';' +
                                                CDS_CodeBarre.FieldByName('codebarre').AsString + ';' +
                                                CDS_CodeBarre.FieldByName('qte_taille').AsString);
            CDS_CodeBarre.Next;
          end;

          CDS_Prix_art.Filtered  := False;
          CDS_Prix_art.Filter    := 'lien_art = ' + QuotedStr(CDS_Article.FieldByName('RefArt').AsString);
          CDS_Prix_art.Filtered  := True;
          CDS_Prix_art.First;

          while not CDS_Prix_art.Eof do
          begin
            Add_CSV(ChemImport+'prix.csv',CDS_Prix_art.FieldByName('lien_art').asString + ';' +       //CODE_ART
                                          '' + ';' +                                                  //TAILLE
                                          CDS_Prix_art.FieldByName('prix_acaht_e').asString + ';' +   //PXCATALOGUE
                                          CDS_Prix_art.FieldByName('prix_acaht_e').asString + ';' +   //PX_ACHAT
                                          CDS_Prix_art.FieldByName('prix_ttc2').asString + ';' +      //PX_VENTE
                                          TranspoCileaLoc + ';' +                                     //CODE_FOU
                                          '' + ';');                                                  //COULEUR
            CDS_Prix_art.Next;
          end;

          Inc(Compteur);
          CDS_Article.Next;
        end;

      except
        on E:Exception do
        begin
          AjouterLog('Erreur lors du traitement des articles de vente : ' + E.Message, True);
          Exit;
        end;
      end;
    end;

    //Fermeture des accès BdD et des ClientDataSet
    FreeAndNil(CDS_Article);
    FreeAndNil(CDS_Article_Loc);
    FreeAndNil(CDS_Article_Loc_Class);
    FreeAndNil(CDS_Client);
    FreeAndNil(CDS_Couleur);
    FreeAndNil(CDS_Famille);
    FreeAndNil(CDS_Famille_Loc);
    FreeAndNil(CDS_Fourn);
    FreeAndNil(CDS_Prix_art);
    FreeAndNil(CDS_Taille);
    FreeAndNil(CDS_TVA);
    FreeAndNil(CDS_CodeBarre);

    FreeAndNil(sStrings);

    //Message d'information
    if stopImport then
      LibInfo := 'Traitement interrompu'
    else
      LibInfo := 'Traitement terminé';

    //Signale que le traitement n'est plus en cours pour l'affichage
    NbLigne := -1;

  except
    on E:Exception do
    begin
      AjouterLog('Erreur lors du traitement des articles de location : ' + E.Message, True);
      Exit;
    end;
  end;
  {$ENDREGION}
end;

procedure TTranspoThread.AjouterLog(Texte:String;Err:Boolean);
begin
  try
    if Err then
    begin
      AjouterLog('------------------------------------------------------------------');
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);
      AjouterLog('------------------------------------------------------------------');
      ShowMessage('Erreur lors du traitement. Consulter les logs');
    end
    else
      Log.Add(DateTimeToStr(Now) + '  ' + Texte);

    Log.SaveToFile(PathExe + 'Log\' + LogFileName);
  except
  end;
end;

Procedure TTranspoThread.CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    //Charge le fichier csv
  InfoLigne : TStringList;    //Découpe la ligne en cours de traitement
  I,J       : Integer;        //Variable de boucle
  Chaine    : String;         //Variable de traitement des lignes
Begin
  try
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
    InfoLigne.StrictDelimiter := True;
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
        InfoLigne.StrictDelimiter := True;
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

    CDS.AddIndex('idx', Index, []);
    CDS.IndexName := 'idx';

    //Suppression des variables en mémoire
    Donnees.free;
    InfoLigne.Free;
  except
    on E:Exception do
    begin
      AjouterLog('Erreur dans CSV_To_ClientDataSet : ' + E.Message, True);
      Exit;
    end;
  end;
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
