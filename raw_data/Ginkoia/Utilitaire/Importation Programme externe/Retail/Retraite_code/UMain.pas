UNIT UMain;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  //début uses
  FileCtrl, ShellApi,
  //fin uses
  Dialogs, ApFolderDlg, Db, dxmdaset, StdCtrls, Buttons, Grids, DBGrids;

CONST
  DELIMITEUR = ';';
TYPE
  Tfmain = CLASS(TForm)
    MemD_Taille: TdxMemData;
    edt_PathSrc: TEdit;
    Nbt_PathSrc: TSpeedButton;
    Nbt_Quitter: TSpeedButton;
    Nbt_Traiter: TSpeedButton;
    edt_PathDest: TEdit;
    Nbt_PathDest: TSpeedButton;
    Lab_Source: TLabel;
    Lab_Dest: TLabel;
    MemD_TailleSidStyl: TStringField;
    MemD_TailleLibelletaille: TStringField;
    Op_Dest: TApFolderDialog;
    OpenDlg: TOpenDialog;
    lblTaille: TLabel;
    lbltaillelig: TLabel;
    MemD_NoDouble: TdxMemData;
    MemD_NoDoubleSidStyl: TStringField;
    MemD_NoDoubleLibelletaille: TStringField;
    MemD_NoDoubleSortCol: TStringField;
    Lab_Dedouble: TLabel;
    MemD_CodeBarres: TdxMemData;
    MemD_CodeBarresCode_art: TStringField;
    MemD_CodeBarresTaille: TStringField;
    MemD_CodeBarresCouleur: TStringField;
    MemD_CodeBarresEAN: TStringField;
    MemD_CodeBarresQtte: TIntegerField;
    PROCEDURE Nbt_QuitterClick(Sender: TObject);
    PROCEDURE Nbt_TraiterClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE boutons();
    PROCEDURE edt_PathSrcChange(Sender: TObject);
    PROCEDURE edt_PathDestChange(Sender: TObject);
    PROCEDURE grilleTaille_creer();
    PROCEDURE titreColonne_controle();
    PROCEDURE Nbt_PathSrcClick(Sender: TObject);
    PROCEDURE Nbt_PathDestClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE Dedoublonnage(sFilePath: STRING);
  PRIVATE
    { Déclarations privées }
    copieChemin: STRING;
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  fmain: Tfmain;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE Tfmain.Nbt_QuitterClick(Sender: TObject);
BEGIN
  //fermeture de la fiche
  Self.Close();
END;

PROCEDURE Tfmain.Nbt_TraiterClick(Sender: TObject);
var
  CodeEAN : integer;
BEGIN
  //tester existence du fichier
  IF FileExists(edt_PathSrc.Text) THEN
  BEGIN
    // Sauvegarde du fichier source
    CopyFile(pchar(edt_PathSrc.Text), pchar(ChangeFileExt(edt_PathSrc.Text,'.svg')), False);

    // On charge la liste des CB dans un MemD pour ensuite formater les CB sur 6 CHAR.
    MemD_CodeBarres.Close;
    MemD_CodeBarres.LoadFromTextFile(edt_PathSrc.Text);
    MemD_CodeBarres.First;
    WHILE NOT MemD_CodeBarres.Eof DO
    BEGIN
      MemD_CodeBarres.Edit;
      CodeEAN := StrToInt(MemD_CodeBarresEAN.AsString);
      MemD_CodeBarresEAN.AsString := format('%.06d', [CodeEAN]);
      MemD_CodeBarres.Next;
    END;
    MemD_CodeBarres.SaveToTextFile(edt_PathSrc.Text);
    MemD_CodeBarres.Close;


    //créer une copie du fichier
    copieChemin := ExtractFilePath(edt_PathSrc.Text) + 'Copie de ' + ExtractFileName(edt_PathSrc.Text);
    CopyFile(pchar(edt_PathSrc.Text), pchar(copieChemin), False);
    //présence du '\' obligatoire
    edt_PathDest.Text := IncludeTrailingBackslash(edt_PathDest.text);
    //vérifier chemin
    IF NOT ForceDirectories(edt_PathDest.Text) THEN
    BEGIN
      //message erreur
      MessageDlg('Chemin de dossier inexistant, veuillez saisir un chemin valide', mtError, [mbOK], 0);
    END
      //si le dossier peut être existe/créer
    ELSE
    BEGIN
      //formatter le nom des colonnes
      titreColonne_controle();


      // FC : déboulonnage le 27/08/08
      Dedoublonnage(copieChemin);

      //      MemD_Taille.LoadFromTextFile(copieChemin);

      //trier la colonne SidStyl
      MemD_Taille.SortedField := 'SidStyl';

      //traitement 1 : sauver colonne 1 et 2
      MemD_Taille.SaveToTextFile(edt_PathDest.Text + 'GR_TAILLE_LIG.CSV');
      //renseigné le label
      lbltaillelig.Caption := 'GR_TAILLE_LIG : ' + IntToStr(MemD_Taille.RecordCount) + ' lignes';
      lbltaillelig.Update;
      //traitement 2 : créer la grille de taille et sauver
      grilleTaille_creer();
      //détruire la copie
//      DeleteFile(copieChemin);
    END;
  END
    //message chemin non valide
  ELSE
  BEGIN
    //message
    MessageDlg('Fichier introuvable, veuillez saisir un nom de fichier valide', mtError, [mbOK], 0);
  END;
END;

PROCEDURE Tfmain.FormCreate(Sender: TObject);
BEGIN
  //défintion du délimeteur
  MemD_Taille.DelimiterChar := DELIMITEUR;
  MemD_NoDouble.DelimiterChar := DELIMITEUR;
  MemD_CodeBarres.DelimiterChar := DELIMITEUR;

  //gestion des boutons
  boutons();
END;

//Gérer la disponibilité des boutons de la form

PROCEDURE Tfmain.boutons;
BEGIN
  //traiter
  Nbt_Traiter.enabled := (edt_PathSrc.Text <> '') AND (edt_PathDest.Text <> '');
END;

PROCEDURE Tfmain.edt_PathSrcChange(Sender: TObject);
BEGIN
  //renseigner par défaut le chemin destination
  edt_PathDest.Text := ExtractFilePath(edt_PathSrc.Text);
  //signaler la modification
  edt_PathSrc.Modified := True;
  //gestion des boutons
  boutons();
END;

PROCEDURE Tfmain.edt_PathDestChange(Sender: TObject);
BEGIN
  //signaler la modification
  edt_PathDest.Modified := True;
  //gestion des boutons
  boutons();
END;

//procédure qui créer la grille de taille et la sauve

PROCEDURE Tfmain.grilleTaille_creer();
VAR
  strList: TStringList;
  strSidStyl: STRING;
BEGIN
  //créer une string list
  strList := TStringList.Create();
  //créer la première ligne
  strList.Add('SidStyl' + DELIMITEUR + 'Libelletaille' + DELIMITEUR + 'Import');
  //se placer sur le premier enregistrement
  MemD_Taille.First();
  //parcourir le memdata
  WHILE NOT MemD_Taille.Eof DO
  BEGIN
    //tester le champs de la colonne Sid
    //si nouveau
    IF MemD_TailleSidStyl.AsString <> strSidStyl THEN
    BEGIN
      //mémoriser
      strSidStyl := MemD_TailleSidStyl.AsString;
      //enregistrer
      strList.Add(strSidStyl + DELIMITEUR + strSidStyl + DELIMITEUR + '"IMPORT"');
    END;
    //passer au suivant
    MemD_Taille.Next();
  END;
  //sauver
  strList.SaveToFile(edt_PathDest.text + 'GR_TAILLE.CSV');
  //renseigner le label compteur
  lbltaille.Caption := 'GR_TAILLE : ' + IntToStr(strList.Count) + ' lignes';
  //libèrer la mémoire
  strList.Free;
END;

//procédure qui donne aux colonnes du fichier le même nom que celle du memData

PROCEDURE Tfmain.titreColonne_controle();
VAR
  strList: TStringList;
BEGIN
  //créer un mémo
  strList := TStringList.Create();
  //charger le fichier
  strList.LoadFromFile(copieChemin);
  //changer le contenu de la première ligne
  strList[0] := 'SidStyl' + DELIMITEUR + 'Libelletaille' + DELIMITEUR + DELIMITEUR + DELIMITEUR;
  //sauver
  strList.SaveToFile(copieChemin);
  //libèrer la mémoire
  strList.Free;
END;

PROCEDURE Tfmain.Nbt_PathSrcClick(Sender: TObject);
BEGIN
  //répertoire par défaut
  OpenDlg.InitialDir := '';
  //ouvrir la dialogue
  IF OpenDlg.Execute THEN
  BEGIN
    //si réponse afficher le choix
    edt_PathSrc.Text := OpenDlg.FileName;
    //initialiser les labels
    Lab_Dedouble.Caption := 'Aucun traitement';
    lbltaillelig.Caption := 'Aucun traitement';
    lbltaille.Caption := 'Aucun traitement';
  END;
END;

PROCEDURE Tfmain.Nbt_PathDestClick(Sender: TObject);
BEGIN
  //init du répertoire par défaut
  Op_Dest.InitialDir := ExtractFilePath(edt_PathDest.Text);
  //si choix de l'utilisateur
  IF Op_Dest.Execute THEN
  BEGIN
    //mémoriser le chemin
    edt_PathDest.Text := Op_Dest.FolderName;
    //signaler la modification
    edt_PathDest.Modified := True;
  END;
END;

PROCEDURE Tfmain.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  IF OpenDlg <> NIL THEN
  BEGIN
    //libèrer
    OpenDlg.Free;
  END;
  //tester les composants
  IF Op_Dest <> NIL THEN
  BEGIN
    //libèrer
    Op_Dest.Free;
  END;
  //fermeture memdata
  MemD_Taille.Close;
  //libèrer
  MemD_Taille.Free;
END;

PROCEDURE Tfmain.Dedoublonnage(sFilePath: STRING);
VAR
  i: integer;
  iNbMax: integer;
  curTaille: STRING;
BEGIN
  MemD_Taille.Close;
  MemD_Taille.Open;
  MemD_NoDouble.DisableControls;
  MemD_Taille.DisableControls;

  //charger le fichier
  MemD_NoDouble.Close;
  MemD_NoDouble.LoadFromTextFile(sFilePath);

  // compose la clé de tri
  MemD_NoDouble.First;
  iNbMax := MemD_NoDouble.RecordCount;
  i := 1;
  WHILE NOT MemD_NoDouble.Eof DO
  BEGIN
    Lab_Dedouble.Caption := 'Calcul colonne tri : ' + inttostr(i) + '/' + inttostr(iNbMax);
    Lab_Dedouble.Update;
    inc(i);
    MemD_NoDouble.Edit;
    MemD_NoDoubleSortCol.AsString := MemD_NoDoubleSidStyl.AsString + MemD_NoDoubleLibelletaille.AsString;
    MemD_NoDouble.Post;
    MemD_NoDouble.Next;
  END;


  Lab_Dedouble.Caption := 'Tri en cours...';
  Lab_Dedouble.Update;
  // Trie la liste
  MemD_NoDouble.SortedField := 'SortCol';

  i := 1;
  // copie dans MemD_Taille sans doublon
  curTaille := ''; // Init de la sauvegarde de la taille courante
  MemD_NoDouble.First;
  WHILE NOT MemD_NoDouble.Eof DO
  BEGIN
    Lab_Dedouble.Caption := 'Dedoublonnage enregistrement : ' + inttostr(i) + '/' + inttostr(iNbMax);
    inc(i);
    Lab_Dedouble.Update;

    // On a change de taille ou d'article, on stocke
    IF MemD_NoDoubleSortCol.AsString <> curTaille THEN
    BEGIN
      // Nouvel article, ou nouvelle taille, on ajoute la ligne
      MemD_Taille.Append;
      MemD_TailleSidStyl.AsString := MemD_NoDoubleSidStyl.AsString;
      MemD_TailleLibelletaille.AsString := MemD_NoDoubleLibelletaille.AsString;
      MemD_Taille.Post;

      // Stock la taille que l'on a ajouté
      curTaille := MemD_NoDoubleSortCol.AsString;
    END;

    MemD_NoDouble.Next;
  END;

  MemD_NoDouble.EnableControls;
  MemD_Taille.EnableControls;
END;

END.

