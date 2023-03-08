UNIT Unit_Backup;

INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Forms, StdCtrls, ComCtrls,
  //Uses Perso
  UAffiche,
  Xml_Unit,
  IcXMLParser,
  Inifiles,
  Unit_Choix,
  UChxPeriode,
  //Fin Uses Perso
  IBDatabaseInfo, ExtCtrls, Dialogs, Menus, Controls, Buttons;

TYPE
  PUneBase = ^TuneBase;
  TuneBase = RECORD
    LaBase: Shortstring;
    LaVraiBase: Shortstring;
    Lerep: Shortstring;
    LastBck: Shortstring;
    LastTime: Shortstring;
    LastRESULT: Shortstring;
    Buffers     ,
    Pagesize    : Integer;
  END;
  TListeBases = array of TUneBase;

  TFrm_BackupPt = CLASS(TForm)
    Label1: TLabel;
    Lab_Base: TLabel;
    Pb: TProgressBar;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    lab_titreprochbase: TLabel;
    lab_prochbase: TLabel;
    menu: TMainMenu;
    Configuration1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    Nomaccept1: TMenuItem;
    Repertoireracine1: TMenuItem;
    Rpertoiresaccepts1: TMenuItem;
    Od: TOpenDialog;
    Lb: TListBox;
    tim: TTimer;
    Progress: TTimer;
    Lab_Quoi: TLabel;
    lab_tps: TLabel;
    Lab_TpsSuiv: TLabel;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    Pan_Infos: TPanel;
    Lab_dureeTotale: TLabel;
    Lab_tpsTotal: TLabel;
    Lab_EstimationTotale: TLabel;
    Lab_TotalLame: TLabel;
    Lab_TpsTotalLame: TLabel;
    SpeedButton3: TSpeedButton;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE Quitter1Click(Sender: TObject);
    PROCEDURE SpeedButton4Click(Sender: TObject);
    PROCEDURE timTimer(Sender: TObject);
    PROCEDURE ProgressTimer(Sender: TObject);
    PROCEDURE SpeedButton1Click(Sender: TObject);
    PROCEDURE Repertoireracine1Click(Sender: TObject);
    PROCEDURE Rpertoiresaccepts1Click(Sender: TObject);
    PROCEDURE SpeedButton2Click(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  PRIVATE
    SommeTaille: Integer;
    SommeTemps: TTime;
    Nombredebase: Integer;
    PROCEDURE AjHorraire(Sender: TObject);
    PROCEDURE HorraireDblCkick(Sender: TObject);
    PROCEDURE initTimer;
    FUNCTION tailleFichier(Nom: STRING): Integer;
    PROCEDURE OnFait(Sender: TObject; S: STRING);

    procedure FileSearch(CONST aDirectory : string;aList:TStringList);
    procedure DirectorySearch(CONST aRootPath : string;aList:TStringList; recurs : boolean = false);

    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
    tpsprob           : TTime;
    Debut             : TTime;
    Tsl_Horraire      : TstringList;
    Active            : boolean;
    Hencours          : Integer;
    RepRacine         : string;     //Repertoire racine.
    RepDossier        : string;     //Si on est en 12.1 c'est le répertoire Dossier.
    RepFichier        : string;
    RepSave           : string;
    Encours           : boolean;
    //Log: TStringList;
    dateDebut         : Tdatetime;
    estimTotal        : Tdatetime;
    estimTotalLame    : Tdatetime;
    cumulTempsBackUp  : Tdatetime;
    bTempsTotalEstime : boolean;
    PROCEDURE Remplie_Lb;
    FUNCTION Choix_ProchaineBase(B: TuneBase): TUneBase;
    procedure GetListBases(var Liste : TListeBases);
    PROCEDURE Marque_la_base(B: TuneBase);
    FUNCTION TempsBase(S: STRING): TTime;

    procedure Research(aRootPath:string;aList:TStringList);

  END;

VAR
  Frm_BackupPt: TFrm_BackupPt;

const
  //Fichier que l'on recherche
  FileResearch = 'delosQPMagent.dll';

IMPLEMENTATION

USES
  Unit_geneBackup,
  UchxDivers,
  ChoixBasesFrm;

{$R *.DFM}

procedure TFrm_BackupPt.Research(aRootPath: string;aList: TStringList);
begin
  try
    if Length(aRootPath) > 3 then
    begin
      aRootPath := aRootPath + '\';
    end;

    aList.Clear;

    FileSearch(aRootPath,aList);

    DirectorySearch(aRootPath, aList, true);
  except on e : Exception do
    ShowMessage('TResearchFile.Research() : '+e.Message);
  end;
end;

//Recherche de fichiers d'extension "FileExtension" dans un répertoire "Directory"
procedure TFrm_BackupPt.FileSearch(CONST aDirectory : string;aList:TStringList);
var
  SearchFileRec : TSearchRec;
begin
  if FindFirst(aDirectory + FileResearch, faAnyFile, SearchFileRec)=0 then
  begin
    aList.Add(aDirectory); // + SearchFileRec.Name);
    while FindNext(SearchFileRec)=0 do
    begin
      aList.Add(aDirectory); // + SearchFileRec.Name);
    end;
  end;
  FindClose(SearchFileRec);
end;

//Recherche récursive ou non à partir d'un répertoire racine "RootFolder"
procedure TFrm_BackupPt.DirectorySearch(CONST aRootPath : string;aList:TStringList; recurs : boolean);
var
  SearchDirRec  : TSearchRec;
  FolderFound   : string;
begin
  FindFirst(aRootPath + '*', faDirectory, SearchDirRec);
  //Test permettant de déterminer s'il s'agit bien d'un dossier et non d'un fichier
  //C'est un dossier si : "valeur de l'attribut (nombre entier) AND constante d'attribut (faDirectory) > 0)
  //"." et ".." représente respectivement le répertoire courant et le répertoire parent
  if (SearchDirRec.Name<>'.') and (SearchDirRec.Name<>'..') and ((SearchDirRec.Attr and faDirectory)>0) then
  begin
    FolderFound := aRootPath + SearchDirRec.Name;
  end;

  while FindNext(SearchDirRec)=0 do
  begin
    if (SearchDirRec.Name<>'.') and (SearchDirRec.Name<>'..') and ((SearchDirRec.Attr and faDirectory)>0) then
    begin
      FolderFound := aRootPath + SearchDirRec.Name + '\';
      FileSearch(FolderFound,aList);
      if recurs then
        DirectorySearch(FolderFound,aList);
    end;
  end;
  FindClose(SearchDirRec);
end;
//-------------------------------//

PROCEDURE TFrm_BackupPt.FormCreate(Sender: TObject);
VAR
  ini: TInifile;
BEGIN
  encours := false;
  try
    ini := TInifile.create(ChangeFileExt(Application.ExeName, '.ini'));
    SommeTaille := ini.readInteger('VARIABLES', 'SommeTaille', 0);
    SommeTemps := ini.ReadTime('VARIABLES', 'SommeTemps', 0);
    Nombredebase := ini.readInteger('VARIABLES', 'Nombredebase', 0);
    RepRacine := ini.readString('VARIABLES', 'RepRacine', 'D:\EAI\');
    RepDossier := ini.ReadString('VARIABLES', 'RepDossier', '');
    RepFichier := ini.readString('VARIABLES', 'RepFichier', 'DATA');
    RepSave := ini.ReadString('VARIABLES', 'RepSave', '\\GSA-BACKUP\')
  finally
    FreeAndNil(ini);
  end;
  
  Lab_Base.caption := '';
  lab_prochbase.caption := '';
  lab_tps.Caption := '';
  Lab_TpsSuiv.Caption := '';
  Tsl_Horraire := TstringList.Create;
  Active := false;
  Hencours := -1;
  //lab connaitre le point de départ : on a bouclée la boucle lorsqu'on arrive aux bases dont le backup est plus récent que ce point
  dateDebut := now;
  estimTotal := 0;
  estimTotalLame := 0;
  cumulTempsBackUp := 0;
  bTempsTotalEstime := true;

  IF fileexists(changefileext(application.exename, '.HOR')) THEN
    Tsl_Horraire.LoadFromFile(changefileext(application.exename, '.HOR'));
  Remplie_Lb;
  Lab_Quoi.caption := '';
  Dm_BckGene.OnFait := OnFait;
  IF NOT encours THEN
    tim.enabled := true;

  //lab log propre à l'exe et non aux bases
  //Log := TStringList.Create;
END;

PROCEDURE TFrm_BackupPt.FormDestroy(Sender: TObject);
BEGIN
  //Log.free;
END;

PROCEDURE TFrm_BackupPt.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  Canclose := application.messageBox('Etes vous vraiment sur de vouloir fermer ce programme', ' ATTENTION', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = Mryes;
END;

PROCEDURE TFrm_BackupPt.Quitter1Click(Sender: TObject);
BEGIN
  close;
END;

PROCEDURE TFrm_BackupPt.AjHorraire(Sender: TObject);
VAR
  ChoixPeriode: TChoixPeriode;
  S2: STRING;
BEGIN
  Application.createForm(TChoixPeriode, ChoixPeriode);
  IF ChoixPeriode.ShowModal = MrOk THEN
  BEGIN
    IF ChoixPeriode.toto = 1 THEN
      S2 := 'Dimanche '
    ELSE IF ChoixPeriode.toto = 2 THEN
      S2 := 'Lundi '
    ELSE IF ChoixPeriode.toto = 3 THEN
      S2 := 'Mardi '
    ELSE IF ChoixPeriode.toto = 4 THEN
      S2 := 'Mercredi '
    ELSE IF ChoixPeriode.toto = 5 THEN
      S2 := 'Jeudi '
    ELSE IF ChoixPeriode.toto = 6 THEN
      S2 := 'Vendredi '
    ELSE
      S2 := 'Samedi ';
    S2 := S2 + 'de ' + ChoixPeriode.ed_de.Text + ' à ' + ChoixPeriode.ed_a.Text;
    TFrm_Choix(TwinControl(Sender).parent).Lb.items.Add(S2);
  END;
  ChoixPeriode.release;
END;

PROCEDURE TFrm_BackupPt.SpeedButton4Click(Sender: TObject);
VAR
  Tsl: TstringList;
  S, S1, S2: STRING;
  i: integer;
BEGIN
  tim.enabled := False;
  Tsl := TstringList.Create;
  FOR i := 0 TO Tsl_Horraire.Count - 1 DO
  BEGIN
    S := Tsl_Horraire[i];
    S1 := Copy(S, 1, pos(';', S) - 1);
    delete(S, 1, pos(';', S));
    IF S1 = '1' THEN
      S2 := 'Dimanche '
    ELSE IF S1 = '2' THEN
      S2 := 'Lundi '
    ELSE IF S1 = '3' THEN
      S2 := 'Mardi '
    ELSE IF S1 = '4' THEN
      S2 := 'Mercredi '
    ELSE IF S1 = '5' THEN
      S2 := 'Jeudi '
    ELSE IF S1 = '6' THEN
      S2 := 'Vendredi '
    ELSE
      S2 := 'Samedi ';
    S1 := Copy(S, 1, pos(';', S) - 1);
    delete(S, 1, pos(';', S));
    S2 := S2 + 'de ' + S1 + ' à ' + S;
    tsl.add(S2);
  END;
  Chxexecute('Ajout d''un horraire', 'Horraires actuellement référencés', Tsl, AjHorraire, HorraireDblCkick);
  Tsl_Horraire.Clear;
  FOR i := 0 TO tsl.count - 1 DO
  BEGIN
    S := Tsl[i];
    IF copy(S, 1, 5) = 'Diman' THEN
      S1 := '1;'
    ELSE IF copy(S, 1, 5) = 'Lundi' THEN
      S1 := '2;'
    ELSE IF copy(S, 1, 5) = 'Mardi' THEN
      S1 := '3;'
    ELSE IF copy(S, 1, 5) = 'Mercr' THEN
      S1 := '4;'
    ELSE IF copy(S, 1, 5) = 'Jeudi' THEN
      S1 := '5;'
    ELSE IF copy(S, 1, 5) = 'Vendr' THEN
      S1 := '6;'
    ELSE
      S1 := '7;';
    Delete(s, 1, pos(' ', S));
    Delete(s, 1, pos(' ', S));
    S1 := S1 + Copy(S, 1, pos(' ', S) - 1) + ';';
    Delete(s, 1, pos(' ', S));
    Delete(s, 1, pos(' ', S));
    S1 := S1 + S;
    Tsl_Horraire.Add(S1);
  END;
  Tsl_Horraire.SaveToFile(changefileext(application.exename, '.HOR'));
  tsl.free;
  Remplie_Lb;
  initTimer;
END;

PROCEDURE TFrm_BackupPt.Remplie_Lb;
VAR
  S, S1, S2: STRING;
  i: integer;
BEGIN
  Lb.items.clear;
  FOR i := 0 TO Tsl_Horraire.Count - 1 DO
  BEGIN
    S := Tsl_Horraire[i];
    S1 := Copy(S, 1, pos(';', S) - 1);
    delete(S, 1, pos(';', S));
    IF S1 = '1' THEN
      S2 := 'Dimanche '
    ELSE IF S1 = '2' THEN
      S2 := 'Lundi '
    ELSE IF S1 = '3' THEN
      S2 := 'Mardi '
    ELSE IF S1 = '4' THEN
      S2 := 'Mercredi '
    ELSE IF S1 = '5' THEN
      S2 := 'Jeudi '
    ELSE IF S1 = '6' THEN
      S2 := 'Vendredi '
    ELSE
      S2 := 'Samedi ';
    S1 := Copy(S, 1, pos(';', S) - 1);
    delete(S, 1, pos(';', S));
    S2 := S2 + 'de ' + S1 + ' à ' + S;
    Lb.items.add(S2);
  END;
END;

PROCEDURE TFrm_BackupPt.initTimer;
VAR
  Jour: Integer;
  S, J, HD, HF: STRING; // J=jour ; HD=HeureDebut ; HF=HeureFin
  i: Integer;
  Tps: DWord;

  LaBase: TuneBase;
  LaBase2: TuneBase;
BEGIN
  LaBase.LaBase := '';
  SpeedButton3.enabled := false;
  SpeedButton4.enabled := false;
  Jour := DayOfWeek(date);
  TRY
    tim.enabled := false;
    IF SpeedButton1.Down THEN
      active := false
    ELSE
    BEGIN
      FOR i := 0 TO Tsl_Horraire.Count - 1 DO
      BEGIN
        S := Tsl_Horraire[i];
        J := copy(S, 1, pos(';', S) - 1);
        Delete(S, 1, pos(';', S));
        HD := copy(S, 1, pos(';', S) - 1);
        Delete(S, 1, pos(';', S));
        HF := S;
        IF J = Inttostr(jour) THEN
        BEGIN
          //Delete(S, 1, pos(';', S));
          IF frac(Now) >= StrToTime(HD) THEN
          BEGIN
            //Delete(S, 1, pos(';', S));
            IF frac(Now) < StrToTime(HF) THEN
            BEGIN
              active := true;
              Hencours := i;
              BREAK;
            END
            ELSE
            BEGIN
              active := False;
              BREAK;
            END
          END;
        END;
      END;
      IF NOT active THEN
      BEGIN
        Hencours := -1;
        tps := 1000 * 60 * 60; // soit 1h
        FOR i := 0 TO Tsl_Horraire.Count - 1 DO
        BEGIN
          S := Tsl_Horraire[i];
          J := copy(S, 1, pos(';', S) - 1);
          Delete(S, 1, pos(';', S));
          HD := copy(S, 1, pos(';', S) - 1);
          Delete(S, 1, pos(';', S));
          HF := S;
          IF J = Inttostr(jour) THEN
          BEGIN
            //Delete(S, 1, pos(';', S));
            IF frac(Now) <= StrToTime(HD) THEN
            BEGIN
              IF (StrToTime(HD) * 24 * 60 * 60 * 1000) < tps THEN
                tps := trunc(StrToTime(HD) * 24 * 60 * 60 * 1000);
            END;
          END;
        END;
        Tim.interval := tps;
        Tim.enabled := true;
        lab_prochbase.Caption := Choix_ProchaineBase(labase).LaBase;
        bTempsTotalEstime := false; // lab flag pour ne faire qu'une fois le calcul du temps total de back up de la lame
        Lab_tpsTotal.Caption := '(00:00:00/' + timetostr(estimTotal) + ')';
        Lab_tpsTotalLame.Caption := '(' + timetostr(estimTotalLame) + ')';
        IF lab_prochbase.Caption = '' THEN
        BEGIN
          lab_prochbase.Caption := 'Plus de base pour aujourdhui';
          Lab_TpsSuiv.Caption := '';
        END;
      END;
    END;
    IF active THEN
    BEGIN
      LaBase := Choix_ProchaineBase(labase);
      //lab
      bTempsTotalEstime := false; // lab flag pour ne faire qu'une fois le calcul du temps total de back up de la lame
      Lab_tpsTotal.Caption := '(' + timetostr(cumulTempsBackUp) + '/' + timetostr(estimTotal) + ')';
      Lab_tpsTotalLame.Caption := '(' + timetostr(estimTotalLame) + ')';
      Lab_Base.Caption := LaBase.LaBase;
      IF LaBase.LaBase = '' THEN
      BEGIN
        Lab_Base.Caption := 'Plus de base pour aujourdhui';
        lab_prochbase.Caption := 'Plus de base pour aujourdhui';
        Lab_TpsSuiv.Caption := '';
        lab_tps.Caption := '';
        tps := 1000 * 60 * 60; // soit 1h
        FOR i := 0 TO Tsl_Horraire.Count - 1 DO
        BEGIN
          S := Tsl_Horraire[i];
          J := copy(S, 1, pos(';', S) - 1);
          Delete(S, 1, pos(';', S));
          HD := copy(S, 1, pos(';', S) - 1);
          Delete(S, 1, pos(';', S));
          HF := S;
          IF J = Inttostr(jour) THEN
          BEGIN
            //Delete(S, 1, pos(';', S));
            IF frac(Now) <= StrToTime(HD) THEN
            BEGIN
              IF StrToTime(HD) * 24 * 60 * 60 * 1000 < tps THEN
                tps := trunc(StrToTime(HD) * 24 * 60 * 60 * 1000);
            END;
          END;
        END;
        Tim.interval := tps;
        Tim.enabled := true;
      END
      ELSE
      BEGIN
//        IF fileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log') THEN
//        BEGIN
//          Log.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
//          Log.Add(DateTimeToStr(Now) + '      Back Up en cours :' + LaBase.LaBase);
//          Log.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
//        END;
        tpsprob := strtotime(labase.LastTime);
        lab_tps.Caption := '(00:00:00/' + timetostr(TpsProb) + ')';
        LaBase2 := Choix_ProchaineBase(LaBase);
        //lab
//        Log.Add(DateTimeToStr(Now) + '      Prochain prévu :  ' + LaBase2.LaBase);
//        Log.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
        lab_prochbase.Caption := LaBase2.LaBase;
        IF lab_prochbase.Caption = '' THEN
        BEGIN
          lab_prochbase.Caption := 'Plus de base pour aujourdhui';
          Lab_TpsSuiv.Caption := '';
        END
        ELSE
          Lab_TpsSuiv.Caption := LaBase2.LastTime;
        Pb.Position := 0;
        Pb.Max := trunc(tpsprob * 100000);
        Debut := Now;
        Progress.enabled := true;
        TRY
          //lab coeur du backup
          IF Dm_BckGene.Sauvegarde(LaBase.LaBase) THEN
            LaBase.LastRESULT := 'OK'
          ELSE
            LaBase.LastRESULT := 'NOK';
          debut := Now - Debut;
          LaBase.LastTime := TimeToStr(debut);
          Marque_la_base(LaBase);
          //lab
          cumulTempsBackUp := cumulTempsBackUp + debut;
          Lab_tpsTotal.Caption := '(' + timetostr(cumulTempsBackUp) + '/' + timetostr(estimTotal) + ')';
        FINALLY
          Pb.Position := 0;
          Progress.enabled := False;
          Lab_Quoi.caption := '';
          lab_tps.Caption := '';
          Update;
        END;
        Lab_Base.Caption := '';
        Tim.interval := 1000;
        Tim.enabled := true;
      END;
    END;
  FINALLY
    SpeedButton3.enabled := true;
    SpeedButton4.enabled := true;
  END;
END;

PROCEDURE TFrm_BackupPt.timTimer(Sender: TObject);
BEGIN
  encours := true;
  TRY
    tim.enabled := false;
    initTimer;
  FINALLY
    encours := false;
  END;
END;

FUNCTION TFrm_BackupPt.tailleFichier(Nom: STRING): Integer;
VAR
  F: TSearchRec;
BEGIN
  FindFirst(Nom, FaAnyFile, F);
  result := f.Size;
  FindClose(f);
END;

FUNCTION TrieBase(List: TStringList; Index1, Index2: Integer): Integer;
VAR
  S1, S2: STRING;
BEGIN
  S1 := list[index1];
  s2 := list[index2];
  IF copy(S1, 1, 1) < copy(S2, 1, 1) THEN
    result := -1
  ELSE IF copy(S1, 1, 1) > copy(S2, 1, 1) THEN
    result := 1
  ELSE
  BEGIN
    delete(S1, 1, 2);
    delete(S2, 1, 2);
    IF copy(list[index1], 1, 1) = '0' THEN
    BEGIN
      IF Strtoint(copy(S1, 1, Pos(';', S1) - 1)) < Strtoint(copy(S2, 1, Pos(';', S2) - 1)) THEN
        result := 1
      ELSE IF Strtoint(copy(S1, 1, Pos(';', S1) - 1)) > Strtoint(copy(S2, 1, Pos(';', S2) - 1)) THEN
        result := -1
      ELSE
        result := 0;
    END
    ELSE
    BEGIN
      IF StrtoDate(copy(S1, 1, Pos(';', S1) - 1)) < StrtoDate(copy(S2, 1, Pos(';', S2) - 1)) THEN
        result := -1
      ELSE IF StrtoDate(copy(S1, 1, Pos(';', S1) - 1)) > StrtoDate(copy(S2, 1, Pos(';', S2) - 1)) THEN
        result := 1
      ELSE
      BEGIN
        delete(S1, 1, pos(';', S1));
        delete(S2, 1, pos(';', S2));
        IF Strtoint(copy(S1, 1, Pos(';', S1) - 1)) < Strtoint(copy(S2, 1, Pos(';', S2) - 1)) THEN
          result := 1
        ELSE IF Strtoint(copy(S1, 1, Pos(';', S1) - 1)) > Strtoint(copy(S2, 1, Pos(';', S2) - 1)) THEN
          result := -1
        ELSE
          result := 0;
      END
    END;
  END;
END;

PROCEDURE TFrm_BackupPt.Marque_la_base(B: TuneBase);
VAR
  Xml: TmonXML;
  passXML: TIcXMLElement;
  passXML2: TIcXMLElement;
  lastBack: TDatetime;
BEGIN
  Xml := TmonXML.create;
  //lab
//  if fileExists(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log') then
//    Log.LoadFromFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
//  Log.Add(DateTimeToStr(Now) + '     Enregistrement de la date du dernier back up ' + B.LaBase);
//  Log.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
  TRY
    Xml.LoadFromFile(RepRacine + B.Lerep + 'DelosQPMAgent.Databases.xml'); //lab RepRacine à la place de 'D:\EAI'
    passXML := Xml.find('/DataSources/DataSource');
    WHILE (PassXML <> NIL) DO
    BEGIN
      passXML2 := xml.FindTag(passxml, 'Params');
      passXML2 := xml.FindTag(passxml2, 'Param');
      WHILE (passXML2 <> NIL) AND (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') DO
        passXML2 := passXML2.NextSibling;
      IF Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' THEN
      BEGIN
        IF B.LaVraiBase = Xml.ValueTag(passXML2, 'Value') THEN
        BEGIN
          lastBack := Now; //lab
          xml.SetTag(passXML2, 'lastBCK', DateTimeToStr(lastBack));
          xml.SetTag(passXML2, 'lastTIME', B.LastTime);
          xml.SetTag(passXML2, 'lastRESULT', B.LastRESULT);
          //lab
//          Log.Add(DateTimeToStr(Now) + '     - Last back :' + DateTimeToStr(lastBack));
//          Log.Add(DateTimeToStr(Now) + '     - Last Time :' + B.LastTime);
//          Log.Add(DateTimeToStr(Now) + '     - Last Result :' + B.LastRESULT);
//          Log.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
          BREAK;
        END;
      END;
      PassXML := PassXML.NextSibling;
    END;
    Xml.SavetoFile(RepRacine + B.Lerep + 'DelosQPMAgent.Databases.xml');
  EXCEPT ON stan: exception DO
    BEGIN
    with Dm_BckGene do
    begin
       LogIncident.Add(DateTimeToStr(Now) + #9 + formatMessage(copy(StringReplace(Stan.message, #13#10, #29, [rfReplaceAll, rfIgnoreCase]), 1, 511)) + #9 + 'MARQUAGE DE BASE' + #9 + copy(B.LaVraiBase,1,127) );
       LogIncident.saveToFile(PathLogIncident);
    end;
//      Log.Add(DateTimeToStr(Now) + '     problème d''accès au fichier xml pour mise à jour des infos :' + stan.message);
//      Log.SaveToFile(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'BackupRestorPantin.log');
      Xml.free;
    END;
  END;

END;

FUNCTION TFrm_BackupPt.Choix_ProchaineBase(B: TuneBase): TUneBase;
//VAR
//  S : string;
//  i : Integer;
//
//  Xml: TmonXML;
//  passXML: TIcXMLElement;
//  passXML2: TIcXMLElement;
//
//  F: TsearchRec;
//
//  lsFile  : TStringList;
//
//  LaBase      : string;
//  Lavraibase  : string;
//  Lerep       : string;
//  LastBck     : string;
//  LastTime    : string;
//  LastRESULT  : string;
//
//  replicName: STRING;
//  LeTempRestant: ttime;
//  Ajoute: boolean;
//  Buffers     ,
//  Pagesize    : Integer;
//
var
  LeTempRestant: ttime;
  S : string;
  Liste : TListeBases;
  i : integer;
  Ajoute: boolean;
begin
  // On recherche toute les bases qui ne sont pas encore backup
//  result.LaBase := '';
//  IF Hencours > -1 THEN
//  BEGIN
//    S := Tsl_Horraire[Hencours];
//    delete(S, 1, pos(';', S));
//    delete(S, 1, pos(';', S));
//    LeTempRestant := strtotime(S) - frac(now);
//  END
//  ELSE
//    LeTempRestant := 0.1;
//
//  Xml := TmonXML.create;
//  IF findfirst(RepRacine + '*.*', faDirectory, f) = 0 THEN
//  begin
//    try
//      lsFile  := TStringList.Create;
//      REPEAT
//        IF ((f.attr AND faDirectory) = faDirectory) AND
//          (Uppercase(Copy(f.Name, 1, 1)) = 'V') THEN
//        BEGIN
//          if ((RepDossier <> '') and (RepDossier = F.Name))  then   //Si l'on est en 12.1
//          begin
//            Research(RepRacine + F.name,lsFile);
//          end
//          else
//          begin
//            lsFile.Clear;
//            lsFile.Add(RepRacine + F.name);
//          end;
//
//          i := 0;
//          while i <lsFile.Count do
//          begin
//            lsFile.Strings[i] := IncludeTrailingPathDelimiter(lsFile.Strings[i]);
//            IF fileexists(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml') THEN
//            BEGIN
//              Lerep := StringReplace(lsFile.Strings[i], RepRacine, '', [rfReplaceAll]); //f.name;
//              Xml.LoadFromFile(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml');
//              passXML := Xml.find('/DataSources/DataSource');
//              WHILE (PassXML <> NIL) DO
//              BEGIN
//                replicName := xml.ValueTag(passxml, 'Name');
//                passXML2 := xml.FindTag(passxml, 'Params');
//                passXML2 := xml.FindTag(passxml2, 'Param');
//                WHILE (passXML2 <> NIL) AND (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') DO
//                  passXML2 := passXML2.NextSibling;
//                IF Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' THEN
//                BEGIN
//                  LaBase := Xml.ValueTag(passXML2, 'Value');
//                  Lavraibase := LaBase;
//                  LastBck := Xml.ValueTag(passXML2, 'lastBCK');
//                  lastTIME := Xml.ValueTag(passXML2, 'lastTIME');
//                  lastRESULT := Xml.ValueTag(passXML2, 'lastRESULT');
//                  Try
//                    Buffers    := StrToIntDef(Xml.ValueTag(PassXml2,'Buffers'),0);
//                    PageSize   := StrToIntDef(Xml.ValueTag(PassXml2,'PageSize'),0);
//                  Except
//                    begin
//                      Buffers := 4096;
//                      PageSize := 4096;
//                    end;
//                  End;
//
//                  //lab cumuler les temps estimés pour connaitre le total pour la lame
//                  if (bTempsTotalEstime AND (lastTime <> '')) then
//                  begin
//                    estimTotalLame := estimTotalLame + strToTime(lastTime);
//                  end;
//                  if pos(':', LaBase) > 2 THEN
//                    delete(LaBase, 1, pos(':', LaBase));
//                  IF fileexists(LaBase) THEN
//                  BEGIN
//                    IF (B.lavraibase = lavraibase) THEN
//                    ELSE IF (LastBck = '') OR (Now - strtodatetime(LastBck) > 1) THEN
//                    BEGIN
//                      IF (bTempsTotalEstime AND (lastTime <> '')) THEN
//                      BEGIN
//                        //lab cumuler les temps estimés pour connaitre le total pour la cession
//                        estimTotal := estimTotal + strToTime(lastTime);
//                      END;
//                      IF LastTime = '' THEN
//                        // calcule du temps probable
//                        LastTime := TimetoStr((tailleFichier(LaBase) / 1024 / 1024) / (30000));
//                      IF strtotime(LastTime) < LeTempRestant THEN
//                      BEGIN
//                        Ajoute := False;
//                        IF (result.labase = '') THEN
//                          Ajoute := true
//                        ELSE IF (result.LastBck <> '') AND (LastBck = '') THEN
//                          Ajoute := true
//                        ELSE IF (result.LastBck = '') AND (LastBck = '') THEN
//                        BEGIN
//                          IF Strtotime(result.LastTime) < Strtotime(LastTime) THEN
//                            Ajoute := true;
//                        END
//                        ELSE IF (result.LastBck <> '') AND (LastBck <> '') THEN
//                        BEGIN
//                          IF Strtodatetime(result.LastBck) - Strtodatetime(LastBck) > 1 THEN
//                            Ajoute := true
//                          ELSE IF Strtodatetime(LastBck) - Strtodatetime(result.LastBck) < 1 THEN
//                          BEGIN
//                            IF Strtotime(result.LastTime) < Strtotime(LastTime) THEN
//                              Ajoute := true;
//                          END;
//                        END;
//
//                        IF Ajoute THEN
//                        BEGIN
//                          result.LaBase := LaBase;
//                          result.LaVraiBase := Lavraibase;
//                          result.Lerep := Lerep;
//                          result.LastBck := LastBck;
//                          result.LastTime := LastTime;
//                          result.LastRESULT := LastRESULT;
//                          Result.Buffers := Buffers;
//                          Result.Pagesize := Pagesize;
//                        END;
//                      END;
//                    END;
//                  END
//                END;
//                PassXML := PassXML.NextSibling;
//              END;
//            END;
//            Inc(i);
//          end;    //While
//        end;    //If
//      UNTIL FindNext(f) <> 0;
//    finally
//      FreeAndNil(lsFile);
//    end;
//  end;
//  Xml.free;

  result.LaBase := '';
  IF Hencours > -1 THEN
  BEGIN
    S := Tsl_Horraire[Hencours];
    delete(S, 1, pos(';', S));
    delete(S, 1, pos(';', S));
    LeTempRestant := strtotime(S) - frac(now);
  END
  ELSE
    LeTempRestant := 0.1;

  try
    GetListBases(Liste);
    for i := 0 to Length(Liste) -1 do
    begin
      // estimation du temps
      if (bTempsTotalEstime AND (Liste[i].lastTime <> '')) then
        estimTotalLame := estimTotalLame + strToTime(Liste[i].lastTime);

      // recherche de la base
      IF (B.lavraibase = Liste[i].lavraibase) THEN
      ELSE IF (Liste[i].LastBck = '') OR (Now - strtodatetime(Liste[i].LastBck) > 1) THEN
      BEGIN
        IF (bTempsTotalEstime AND (Liste[i].lastTime <> '')) THEN
        BEGIN
          //lab cumuler les temps estimés pour connaitre le total pour la cession
          estimTotal := estimTotal + strToTime(Liste[i].lastTime);
        END;

        IF Liste[i].LastTime = '' THEN // calcule du temps probable
          Liste[i].LastTime := TimetoStr((tailleFichier(Liste[i].LaBase) / 1024 / 1024) / (30000));
          
        IF strtotime(Liste[i].LastTime) < LeTempRestant THEN
        BEGIN
          Ajoute := False;
          IF (result.labase = '') THEN
            Ajoute := true
          ELSE IF (result.LastBck <> '') AND (Liste[i].LastBck = '') THEN
            Ajoute := true
          ELSE IF (result.LastBck = '') AND (Liste[i].LastBck = '') THEN
          BEGIN
            IF Strtotime(result.LastTime) < Strtotime(Liste[i].LastTime) THEN
              Ajoute := true;
          END
          ELSE IF (result.LastBck <> '') AND (Liste[i].LastBck <> '') THEN
          BEGIN
            IF Strtodatetime(result.LastBck) - Strtodatetime(Liste[i].LastBck) > 1 THEN
              Ajoute := true
            ELSE IF Strtodatetime(Liste[i].LastBck) - Strtodatetime(result.LastBck) < 1 THEN
            BEGIN
              IF Strtotime(result.LastTime) < Strtotime(Liste[i].LastTime) THEN
                Ajoute := true;
            END;
          END;

          IF Ajoute THEN
          BEGIN
            result := Liste[i];
          END;
        END;
      END;
    end;
  finally
    SetLength(Liste, 0);
  end;
END;

procedure TFrm_BackupPt.GetListBases(var Liste : TListeBases);
VAR
  i : Integer;
  Xml: TmonXML;
  passXML: TIcXMLElement;
  passXML2: TIcXMLElement;

  F: TsearchRec;

  lsFile  : TStringList;

  LaBase      : string;
  Lavraibase  : string;
  Lerep       : string;
  LastBck     : string;
  LastTime    : string;
  LastRESULT  : string;

  replicName: STRING;
  Buffers     ,
  Pagesize    : Integer;

  Idx : integer;
begin
  // On recherche toute les bases qui ne sont pas encore backup
  SetLength(Liste, 0);
  
  Xml := TmonXML.create;
  IF findfirst(RepRacine + '*.*', faDirectory, f) = 0 THEN
  begin
    try
      lsFile  := TStringList.Create;
      REPEAT
        IF ((f.attr AND faDirectory) = faDirectory) AND (Uppercase(Copy(f.Name, 1, 1)) = 'V') THEN
        BEGIN
          if ((RepDossier <> '') and (RepDossier = F.Name))  then   //Si l'on est en 12.1
          begin
            Research(RepRacine + F.name,lsFile);
          end
          else
          begin
            lsFile.Clear;
            lsFile.Add(RepRacine + F.name);
          end;

          i := 0;
          while i <lsFile.Count do
          begin
            lsFile.Strings[i] := IncludeTrailingPathDelimiter(lsFile.Strings[i]);
            IF fileexists(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml') THEN
            BEGIN
              Lerep := StringReplace(lsFile.Strings[i], RepRacine, '', [rfReplaceAll]); //f.name;
              Xml.LoadFromFile(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml');
              passXML := Xml.find('/DataSources/DataSource');
              WHILE (PassXML <> NIL) DO
              BEGIN
                replicName := xml.ValueTag(passxml, 'Name');
                passXML2 := xml.FindTag(passxml, 'Params');
                passXML2 := xml.FindTag(passxml2, 'Param');
                WHILE (passXML2 <> NIL) AND (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') DO
                  passXML2 := passXML2.NextSibling;
                IF Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' THEN
                BEGIN
                  LaBase := Xml.ValueTag(passXML2, 'Value');
                  Lavraibase := LaBase;
                  LastBck := Xml.ValueTag(passXML2, 'lastBCK');
                  lastTIME := Xml.ValueTag(passXML2, 'lastTIME');
                  lastRESULT := Xml.ValueTag(passXML2, 'lastRESULT');
                  Try
                    Buffers    := StrToIntDef(Xml.ValueTag(PassXml2,'Buffers'),0);
                    PageSize   := StrToIntDef(Xml.ValueTag(PassXml2,'PageSize'),0);
                  Except
                    begin
                      Buffers := 4096;
                      PageSize := 4096;
                    end;
                  End;

                  // suppression du nom de machine !
                  if pos(':', LaBase) > 2 THEN
                    delete(LaBase, 1, pos(':', LaBase));

                  IF lastTIME = '' THEN // calcule du temps probable
                    lastTIME := TimetoStr((tailleFichier(LaBase) / 1024 / 1024) / (30000));
                    
                  IF fileexists(LaBase) THEN
                  BEGIN
                    Idx := Length(Liste);
                    SetLength(Liste, Idx +1);

                    Liste[Idx].LaBase := LaBase;
                    Liste[Idx].LaVraiBase := Lavraibase;
                    Liste[Idx].Lerep := Lerep;
                    Liste[Idx].LastBck := LastBck;
                    Liste[Idx].LastTime := LastTime;
                    Liste[Idx].LastRESULT := LastRESULT;
                    Liste[Idx].Buffers := Buffers;
                    Liste[Idx].Pagesize := Pagesize;
                  END
                END;
                PassXML := PassXML.NextSibling;
              END;
            END;
            Inc(i);
          end;    //While
        end;    //If
      UNTIL FindNext(f) <> 0;
    finally
      FreeAndNil(lsFile);
    end;
  end;
  Xml.free;
END;

PROCEDURE TFrm_BackupPt.OnFait(Sender: TObject; S: STRING);
BEGIN
  Lab_Quoi.caption := S;
  Update;
END;

PROCEDURE TFrm_BackupPt.ProgressTimer(Sender: TObject);
BEGIN
  Pb.Position := trunc((now - debut) * 100000);
  lab_tps.Caption := '(' + timetostr(now - debut) + '/' + timetostr(TpsProb) + ')';

  Update;
END;

PROCEDURE TFrm_BackupPt.SpeedButton1Click(Sender: TObject);
BEGIN
  IF NOT SpeedButton1.Down THEN
  BEGIN
    Tim.interval := 1000;
    IF NOT encours THEN
      Tim.enabled := true;
  END;
END;

FUNCTION TFrm_BackupPt.TempsBase(S: STRING): TTime;
BEGIN
  IF pos(';', S) > 0 THEN
  BEGIN
    // NomBase;DateDernBackup;DernTps;ETAT
    delete(S, 1, pos(';', S));
    delete(S, 1, pos(';', S));
    result := Strtotime(Copy(S, 1, pos(';', S) - 1));
  END
  ELSE
  BEGIN
    IF Nombredebase > 0 THEN
      result := (tailleFichier(S) / 1024 / 1024) / SommeTaille * SommeTemps
    ELSE
      result := (tailleFichier(S) / 1024 / 1024) / (12000);
  END;
END;

PROCEDURE TFrm_BackupPt.HorraireDblCkick(Sender: TObject);
VAR
  S: STRING;
  ChoixPeriode: TChoixPeriode;
BEGIN
  IF TlistBox(Sender).ItemIndex > -1 THEN
  BEGIN
    S := TlistBox(Sender).Items[TlistBox(Sender).ItemIndex];
    Application.createForm(TChoixPeriode, ChoixPeriode);
    IF copy(S, 1, 5) = 'Diman' THEN
      ChoixPeriode.RadioButton7.Checked := true
    ELSE IF copy(S, 1, 5) = 'Lundi' THEN
      ChoixPeriode.RadioButton1.Checked := true
    ELSE IF copy(S, 1, 5) = 'Mardi' THEN
      ChoixPeriode.RadioButton2.Checked := true
    ELSE IF copy(S, 1, 5) = 'Mercr' THEN
      ChoixPeriode.RadioButton3.Checked := true
    ELSE IF copy(S, 1, 5) = 'Jeudi' THEN
      ChoixPeriode.RadioButton4.Checked := true
    ELSE IF copy(S, 1, 5) = 'Vendr' THEN
      ChoixPeriode.RadioButton5.Checked := true
    ELSE
      ChoixPeriode.RadioButton6.Checked := true;
    Delete(s, 1, pos(' ', S));
    Delete(s, 1, pos(' ', S));
    ChoixPeriode.ed_de.text := Copy(S, 1, pos(' ', S) - 1);
    Delete(s, 1, pos(' ', S));
    Delete(s, 1, pos(' ', S));
    ChoixPeriode.ed_a.text := S;
    IF ChoixPeriode.ShowModal = MrOk THEN
    BEGIN
      IF ChoixPeriode.toto = 1 THEN
        S := 'Dimanche '
      ELSE IF ChoixPeriode.toto = 2 THEN
        S := 'Lundi '
      ELSE IF ChoixPeriode.toto = 3 THEN
        S := 'Mardi '
      ELSE IF ChoixPeriode.toto = 4 THEN
        S := 'Mercredi '
      ELSE IF ChoixPeriode.toto = 5 THEN
        S := 'Jeudi '
      ELSE IF ChoixPeriode.toto = 6 THEN
        S := 'Vendredi '
      ELSE
        S := 'Samedi ';
      S := S + 'de ' + ChoixPeriode.ed_de.Text + ' à ' + ChoixPeriode.ed_a.Text;
      TlistBox(Sender).Items[TlistBox(Sender).ItemIndex] := S;
    END;
    ChoixPeriode.release;
  END;
END;

PROCEDURE TFrm_BackupPt.Repertoireracine1Click(Sender: TObject);
VAR
  Frm_Chxdivers: TFrm_Chxdivers;
  ini: Tinifile;
BEGIN
  application.createform(TFrm_Chxdivers, Frm_Chxdivers);
  Frm_Chxdivers.Caption := ' Répertoire racine';
  Frm_Chxdivers.Edit1.text := RepRacine;
  IF Frm_Chxdivers.ShowModal = mrok THEN
  BEGIN
    RepRacine := Frm_Chxdivers.Edit1.text;
    ini := TInifile.create(ChangeFileExt(Application.exename, '.ini'));
    ini.WriteString('VARIABLES', 'RepRacine', RepRacine);
    ini.free;
  END;
  Frm_Chxdivers.release;
END;

PROCEDURE TFrm_BackupPt.Rpertoiresaccepts1Click(Sender: TObject);
VAR
  Frm_Chxdivers: TFrm_Chxdivers;
  ini: Tinifile;
BEGIN
  application.createform(TFrm_Chxdivers, Frm_Chxdivers);
  Frm_Chxdivers.Caption := ' Répertoire Acceptés';
  Frm_Chxdivers.Edit1.text := RepFichier;
  IF Frm_Chxdivers.ShowModal = mrok THEN
  BEGIN
    RepFichier := uppercase(Frm_Chxdivers.Edit1.text);
    ini := TInifile.create(ChangeFileExt(Application.exename, '.ini'));
    ini.WriteString('VARIABLES', 'RepFichier', RepFichier);
    ini.free;
  END;
  Frm_Chxdivers.release;
END;

PROCEDURE TFrm_BackupPt.SpeedButton2Click(Sender: TObject);
VAR
  Xml: TmonXML;
  passXML: TIcXMLElement;
  passXML2: TIcXMLElement;

  F: TsearchRec;

  i : Integer;
  lsFile : TStringList;

  LaBase: STRING;
  Lavraibase: STRING;
  LastBck: STRING;
  LastTime: STRING;
  LastRESULT: STRING;

  Frm_Affiche: TFrm_Affiche;
  prem: Boolean;
BEGIN
  Application.CreateForm(TFrm_Affiche, Frm_Affiche);
  Xml := TmonXML.create;
  IF findfirst(RepRacine + '*.*', faDirectory, f) = 0 THEN
  BEGIN
    try
      lsFile  := TStringList.Create;
      REPEAT
        IF ((f.attr AND faDirectory) = faDirectory) AND
          (Uppercase(Copy(f.Name, 1, 1)) = 'V') THEN
        BEGIN
          if ((RepDossier <> '') and (RepDossier = F.Name))  then   //Si l'on est en 12.1
          begin
            Research(RepRacine + F.name,lsFile);
          end
          else
          begin
            lsFile.Clear;
            lsFile.Add(RepRacine + F.name);
          end;

          i := 0;
          while i <lsFile.Count do
          begin
            IF fileexists(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml') THEN
            BEGIN
              prem := true;
              Xml.LoadFromFile(lsFile.Strings[i] + 'DelosQPMAgent.Databases.xml');
              passXML := Xml.find('/DataSources/DataSource');
              WHILE (PassXML <> NIL) DO
              BEGIN
                passXML2 := xml.FindTag(passxml, 'Params');
                passXML2 := xml.FindTag(passxml2, 'Param');
                WHILE (passXML2 <> NIL) AND (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') DO
                  passXML2 := passXML2.NextSibling;
                IF Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' THEN
                BEGIN
                  LaBase := Xml.ValueTag(passXML2, 'Value');
                  Lavraibase := LaBase;
                  LastBck := Xml.ValueTag(passXML2, 'lastBCK');
                  lastTIME := Xml.ValueTag(passXML2, 'lastTIME');
                  lastRESULT := Xml.ValueTag(passXML2, 'lastRESULT');
                  IF pos(':', LaBase) > 2 THEN
                    delete(LaBase, 1, pos(':', LaBase));
                  IF fileexists(LaBase) THEN
                  BEGIN
                    IF (LastBck = '') THEN
                    BEGIN
                      IF prem THEN
                      BEGIN
                        Frm_Affiche.Mem.lines.add('Version ' + lsFile.Strings[i]);  //f.Name);
                        prem := false;
                      END;
                      Frm_Affiche.Mem.lines.add(Labase + ' n''a jamais eu de Backup');
                    END
                    ELSE IF lastRESULT <> 'OK' THEN
                    BEGIN
                      IF prem THEN
                      BEGIN
                        Frm_Affiche.Mem.lines.add('Version ' + lsFile.Strings[i]);  //f.Name);
                        prem := false;
                      END;
                      Frm_Affiche.Mem.lines.add(Labase + ' a un problème sur le backup');
                    END
                    ELSE IF Now - strtodatetime(LastBck) > 10 THEN
                    BEGIN
                      IF prem THEN
                      BEGIN
                        Frm_Affiche.Mem.lines.add('Version ' + lsFile.Strings[i]);  //f.Name);
                        prem := false;
                      END;
                      Frm_Affiche.Mem.lines.add(Labase + ' n''a pas eu de backup depuis plus de 10 Jours')
                    END;
                  END
                  ELSE
                  BEGIN
                    IF prem THEN
                    BEGIN
                      Frm_Affiche.Mem.lines.add('Version ' + lsFile.Strings[i]);  //f.Name);
                      prem := false;
                    END;
                    Frm_Affiche.Mem.lines.add(Labase + ' N''existe pas');
                  END;
                END;
                PassXML := PassXML.NextSibling;
              END;
            END;
            Inc(i);
          end;  //If
        END;
      UNTIL FindNext(f) <> 0;
    finally
      lsFile.Free;
    end;
  END;
  Xml.free;
  //charger le log des incidents
    TRY
    if FileExists(Dm_BckGene.PathLogIncident) then
    begin
      Frm_Affiche.memd_log.LoadFromTextFile(Dm_BckGene.PathLogIncident);
    end;
  FINALLY

  END;
  IF (Frm_Affiche.Mem.lines.count > 0) or (Frm_Affiche.memd_log.RecordCount > 0 )then
  begin
    Frm_Affiche.ShowModal;
    Frm_Affiche.memd_log.close;
  end
  ELSE
    Application.MessageBox('Aucun problème détecté', ' Information', Mb_OK);
  Frm_Affiche.Release;
END;

procedure TFrm_BackupPt.SpeedButton3Click(Sender: TObject);
var
  Liste : TListeBases;
  Fiche : Tfrm_ChoixBases;
  i : integer;
  tmp : TuneBase;
begin
  try
    // desactivation
    SpeedButton3.enabled := false;
    SpeedButton4.enabled := false;
    tim.enabled := false;

    // recherche des bases
    GetListBases(Liste);

    // affiché la liste des base
    try
      Fiche := Tfrm_ChoixBases.Create(Self);
      Fiche.Initialise(Liste);
      if Fiche.ShowModal() = mrOK then
      begin
        for i := 0 to Fiche.Count -1 do
        begin
          if Fiche.Selected[i] then
          begin
            tmp := Fiche.Base[i];

            Lab_Base.Caption := tmp.LaBase;
            tpsprob := StrToTimeDef(tmp.LastTime, 0);
            Pb.Position := 0;
            Pb.Max := trunc(tpsprob * 100000);
            Debut := Now;
            Progress.enabled := true;
            TRY
              //lab coeur du backup
              IF Dm_BckGene.Sauvegarde(tmp.LaBase) THEN
                tmp.LastRESULT := 'OK'
              ELSE
                tmp.LastRESULT := 'NOK';
              debut := Now - Debut;
              tmp.LastTime := TimeToStr(debut);
              Marque_la_base(tmp);
            FINALLY
              Pb.Position := 0;
              Progress.enabled := False;
              Lab_Quoi.caption := '';
              lab_tps.Caption := '';
              Update;
            END;
            Lab_Base.Caption := '';
          end;
        end;
      end;
    finally
      FreeAndNil(Fiche);
    end;
  finally
    SetLength(Liste, 0);
    // reactivation !
    SpeedButton3.enabled := true;
    SpeedButton4.enabled := true;
    Tim.interval := 1000;
    tim.enabled := true;
  end;
end;

END.

