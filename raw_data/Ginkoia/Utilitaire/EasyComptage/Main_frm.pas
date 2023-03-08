//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           : Page standard d'une application "Page"
// Auteur         :
// Historique     :
// 20/08/2000 - Hervé PULLUARD - v 1.0.0 : Création
//------------------------------------------------------------------------------

{***************************************************************
   CTRL+TAB pour passer d'un onglet à l'autre.
   Contrôle du changement de page :
       Les formes de chaque page au standard TAlgolstdFrm ont une propriété "StdTag"
       qui est utilisé ici.
       Si StdTag de la page courante est >= 0 le changement de page est interdit
       Il nous suffit donc d'agir sur cette propriété pour contrôler...
       Rem : cela ne sert que dans une forme utilisée comme "page" ailleurs
       StdTag est aussi utilisé de la même façon pour inhiber les boutons de menus.

       Exception : la MainForm d'un projet page utilise StdTag pour contrôler
       le nombre de pages Maximum autorisé. Cela n'a aucune incidence puisque
       dans ce contexte la MainForm n'est jamais la forme active
       (au plus bas niveau c'est l'écran de contrôle qui est actif).

   ATTENTION : lorsque "StdTag" de la forme est >= 0 les "boutons de menu"
       dont le tag est >= 0 sont inhibés.
       Nota :
           1. StdTag par defaut = -1 c'est pourquoi je considère une valeur >= 0
           2. Par défaut tout nouveau bouton menu posé est inhibé car son Tag = 0.
              (Les boutons de menu des projets "modèles" ont tous leur tag mis
              à = -1 sauf quitter. Ils restent ainsi toujours actifs 'aide, tip ...etc.
           3. Cette solution nous permet de continuer à utiliser des valeurs absolues
              significatives pour les Tags et donc d'effectuer nos tests sur celle-ci.
              Cela nous évite aussi de mémoriser des valeurs de Tags pour les restituer
              en fin de traitement. Il suffit de d'inverser le signe du Tag momentanément
              pour obtenir le résultat souhaité

   ON NE PEUT PAS NON PLUS QUITTER une application "page" tant qu'il y a encore
   des pages ouvertes hors écran de contrôle.

   NE PAS OUBLIER qu'il existe aussi une propriété STDSTR qui peut servir...

   INTERDIRE L'OUVERTURE DE PLUSIEURS OCCURRENCES D'UNE PAGE :
   (seulement pour les TAlgolStdFrm)
   Mettre la propriété "OnlyOneInstance" à TRUE

   Numérotation des pages automatique sur les instances d'un même module

   Nota : le système fonctionne sans que les pages aient à déclarer la MainForm
   dans sa clause Uses. Toutefois il est évident que cela pourra être nécessaire
   pour d'autres motifs.

   Les Events Key des pages n'interceptent pas les touches système (flêches par exemple)

   On peut aussi utiliser le composant WindowList de LMD pour gérer les pages
   Une fenêtre pour changer (c'est automatique)
   Une fenêtre pour détruire (en sortie si execute on tue la page sélectée)

   **************************************************************************

   ATTENTION :
   *********
   EVENTS STANDARDS NON EXECUTES par les Pages du composant dockpage de LMD.
   DONC A NE PAS UTILISER ou à des fins personnelles et qui donc doivent explicitement
   être appelées

   1. Form Deactivate
   2. Form Activate
   3. Form Close
   4. Form KeyDown
   *************************************************************************** }

UNIT Main_frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    AlgolStdFrm,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzPanel,
    StdCtrls,
    LMDCustomScrollBox,
    LMDScrollBox,
    LMDCustomButton,
    LMDButton,
    RzLabel, Buttons,uDefs,IniFiles, Mask, RzEdit,DateUtils, LMDCustomComponent,
  LMDWndProcComponent, LMDTrayIcon, Menus, ComCtrls;

TYPE
    Tfrm_Main = CLASS(TAlgolStdFrm)
    Lab_Heure: TLabel;
    Label1: TLabel;
    Nbt_Parametrage: TBitBtn;
    Pan_Page: TRzPanel;
    Nbt_test: TBitBtn;
    RzDateTimeEdit1: TRzDateTimeEdit;
    RzDateTimeEdit2: TRzDateTimeEdit;
    Tim_Heure: TTimer;
    Tray_EasyCmpt: TLMDTrayIcon;
    popTray: TPopupMenu;
    popRestaurer: TMenuItem;
    N1: TMenuItem;
    popQuitter: TMenuItem;
    Lab_tmprestant: TLabel;
    Tim_tmprestant: TTimer;
    Lab_HeureArret: TLabel;
    Tim_ArretAuto: TTimer;
    Nbt_TestPeriode: TBitBtn;
    Dtp_DebutPeriode: TDateTimePicker;
    Dtp_FinPeriode: TDateTimePicker;
    PROCEDURE Nbt_QuitClick(Sender: TObject);
    PROCEDURE AlgolStdFrmShow(Sender: TObject);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Nbt_ParametrageClick(Sender: TObject);
    procedure Nbt_testClick(Sender: TObject);
    procedure Tim_HeureTimer(Sender: TObject);
    procedure popRestaurerClick(Sender: TObject);
    procedure popQuitterClick(Sender: TObject);
    procedure Tim_tmprestantTimer(Sender: TObject);
    procedure Tim_ArretAutoTimer(Sender: TObject);
    procedure Nbt_TestPeriodeClick(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
      PROCEDURE LoadParam;
      PROCEDURE SaveParam;
      function DoTraitement(): Boolean;

    PUBLISHED
    { Published declarations }
    END;


     VAR frm_Main: Tfrm_Main;
IMPLEMENTATION

USES
    GinkoiaResStr,
    DlgStd_Frm, GinKoiaStd, Param_frm, Easycomptage_dm, Uil_Dm;

{$R *.DFM}


PROCEDURE Tfrm_Main.AlgolStdFrmCreate(Sender: TObject);
BEGIN
  Tim_tmprestant.Enabled :=  False;

  if ParamCount > 0 then
  begin
    GTESTMODE := FindCmdLineSwitch('TEST');
    Nbt_test.Visible          := GTESTMODE;
    RzDateTimeEdit1.Visible   := GTESTMODE;
    RzDateTimeEdit2.Visible   := GTESTMODE;
    Lab_tmprestant.Visible    := GTESTMODE;
    Tim_tmprestant.Enabled    := GTESTMODE;
    Nbt_TestPeriode.Visible   := GTESTMODE;
    Dtp_DebutPeriode.Visible  := GTESTMODE;
    Dtp_FinPeriode.Visible    := GTESTMODE;
  end;

  // Initialisation du chemin global de l'application
  GAPPPATH := ExtractFilePath(Application.ExeName);
  GINIFILE := ExtractFileName(ChangeFileExt(Application.ExeName,'.ini'));

  // Chargement de la base de données
  StdGinKoia.LoadIniFileFromDatabase;

  if not Dm_Uil.HasPermissionModule('EASYCOMPTAGE') then
  begin
    InfoMessHP('Vous n''avez pas les permissions nécessaire pour exécuter cette application',True,0,0,'Sécurité');
    Tray_EasyCmpt.NoClose := False;
    Application.Terminate;
  end;

  Caption := 'EasyComptage Export : ' +  StdGinKoia.MagasinName;
//    Showmessage(Dm_EasyComptage.Que_GenParam.DatabaseName);

  TRY
      screen.Cursor := crSQLWait;

      // pour si des fois qu'init longue car ouverture de tables ...etc

      //CurCtrl := xxx;
      // contôle qui doit avoir le focus en entrée

      Hint := Caption;
      StdGinkoia.AffecteHintEtBmp(self);
      UserVisuMags := StdGinkoia.UserVisuMags;
      UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
  FINALLY
      screen.Cursor := crDefault;
  END;

  // Récupération de la configuration
  LoadParam;

  if FindCmdLineSwitch('PARAM') then
    Nbt_Parametrage.Click();  
END;

PROCEDURE Tfrm_Main.Nbt_QuitClick(Sender: TObject);
VAR
    CanClose: Boolean;
BEGIN
    CanClose := True;
//    AlgolStdFrmCloseQuery(Sender, CanClose);
    IF CanClose THEN KillAction.Execute;
END;


procedure Tfrm_Main.Nbt_testClick(Sender: TObject);
var
  iResult : Integer;
  Periode : TPeriodeTranche;
//  tbTranche : TTranche;
  olTranche : TTrancheObList;
  bTraitementOk : Boolean;
begin
  olTranche := TTrancheObList.Create;
  try
    olTranche.OwnsObjects := True;
  case GCONFIGAPP.Periodicite of
    0: begin
      // Configuration des dates pour le traitement
      Periode.dDateDebut := StrToDateTime(FormatDateTime('DD/MM/YYYY 00:00:00',RzDateTimeEdit1.Date));
      Periode.dDateFin   := StrToDateTime(FormatDateTime('DD/MM/YYYY 23:59:59',RzDateTimeEdit1.Date));
    end; // 0
    1: begin
      Periode.dDateDebut := IncMinute(StrToDateTime(FormatDateTime('DD/MM/YYYY', RzDateTimeEdit1.Date) + FormatDateTime('hh:mm:ss', RzDateTimeEdit2.Time)),-15);
      iResult := CalculTranche(Periode.dDateDebut);
      Periode := CalculPeriode(Periode.dDateDebut,iResult);
      Periode.dDateFin := IncMinute(Periode.dDateDebut,GCONFIGAPP.Minutes - 15);
    end; // 1
  end; // case

  // Creation du tableau avec mes données de la base
  bTraitementOk := Dm_EasyComptage.SetTbFromTrancheList(olTranche,Periode.dDateDebut,Periode.dDateFin,StdGinKoia.MagasinID);

  // génération du fichier
  if bTraitementOk then
    SetTbTrancheListToFile(olTranche,Periode.dDateDebut,Periode.dDateFin);

  // Mise à jour des timers et prochaines actions
 { case GCONFIGAPP.Periodicite of
    0: begin // Cas Une fois par jour
      if bTraitementOk then
      begin
        GCONFIGAPP.dPrevAction := GCONFIGAPP.dNextAction;
        GCONFIGAPP.dNextAction := GCONFIGAPP.dNextAction + 1;
        Tim_Heure.Interval := 15 * 60 * 1000;
      end;
    end;
    1: begin // cas plusieurs fois par jour
     // Pour faire passer l'heure de, par exemple, 10:14:59 à 10:15:00
     if bTraitementOk then
       GCONFIGAPP.dPrevAction := IncSecond(GCONFIGAPP.dNextAction,1);
       IncMinute(GCONFIGAPP.dNextAction, GCONFIGAPP.Minutes);
//     GCONFIGAPP.dNextAction := IncSecond(GCONFIGAPP.dNextAction,-1);
     Tim_Heure.Interval := (SecondsBetween(Now,GCONFIGAPP.dNextAction) + 1) * 1000;
    end;
  end; }
  finally
    olTranche.Free;
  end;
end;

procedure Tfrm_Main.Nbt_TestPeriodeClick(Sender: TObject);
var
  iResult : Integer;
  Periode : TPeriodeTranche;
  olTranche : TTrancheObList;
  bTraitementOk : Boolean;
begin
  olTranche := TTrancheObList.Create();
  try
    olTranche.OwnsObjects := True;

    // Configuration des dates pour le traitement
    Periode.dDateDebut := StrToDateTime(FormatDateTime('DD/MM/YYYY 00:00:00', Dtp_DebutPeriode.Date));
    Periode.dDateFin   := StrToDateTime(FormatDateTime('DD/MM/YYYY 23:59:59', Dtp_FinPeriode.Date));

    // Creation du tableau avec mes données de la base
    bTraitementOk := Dm_EasyComptage.SetTbFromTrancheList(olTranche, Periode.dDateDebut, Periode.dDateFin, StdGinKoia.MagasinID);

    // Génération du fichier
    if bTraitementOk then
      SetTbTrancheListToFile(olTranche,Periode.dDateDebut,Periode.dDateFin);

  finally
    olTranche.Free();
  end;
end;

procedure Tfrm_Main.popQuitterClick(Sender: TObject);
begin
  Tray_EasyCmpt.NoClose := False;
  Close;
end;

procedure Tfrm_Main.popRestaurerClick(Sender: TObject);
begin
  Show;
end;

PROCEDURE Tfrm_Main.AlgolStdFrmShow(Sender: TObject);
BEGIN

{ Important :
  Ici ne pas toucher à l'aspect visuel des composants visuels de la forme car cela
  perturbe l'affichage -> Le maximized interne et nécessaire de la page dockée ne se
  fait fait plus ...

  Ici à la création de la forme et jusqu'au 1er show la propriété INit de la forme
  est toujours à False ! C'est aprés le "DoSwow" qu'elle est automatiquement mise à
  True ... Donc le 2ème entrée ici INit est théoriquement à False.
  Cette propriété est visible et gérable dans l'inspecteur d'objets.
  A noter que si la propriété InitTrueOnShow est mise à False ce qui est dit
  précèdemment n'est plus de rigueur...
}

    IF Init THEN
    BEGIN
        { Ne passe donc pas ici lors de la création !}

        {
        A mettre impérativement si bouton de convertor
        Nbt_Convert.ControlConvertor;
        }

        { Attention ici faut peut être chaîner sur
          un traitement spécifique si on veut gérer
          les cas de "surConnection"
        UserVisuMags := StdGinkoia.UserVisuMags;
        UserCanModify := StdGinkoia.UserCanModify('xxx');
        }
    END;
END;

procedure Tfrm_Main.LoadParam;
var
  iResult : Integer;
  Periode : TPeriodeTranche;
begin
  // pour le cas 1er configuration
  GCONFIGAPP.Jours       := 10;

  With Dm_EasyComptage do
  begin
    // vérification que les lignes de paramètrages n'existent pas dans la base de données
    if not (IsParamExist(StdGinKoia.MagasinID,3,10200)
       and  IsParamExist(StdGinKoia.MagasinID,3,10201)
       and  IsParamExist(StdGinKoia.MagasinID,3,10202)
       and  IsParamExist(StdGinKoia.MagasinID,3,10203)) then
    begin
      // Si oui on ferme le programme
      InfoMessHP('Erreur lors du chargement des paramètres.'#13#10#13#10'Ceci sont absents de la base de données.', True, 0, 0 , 'Erreur paramètres');
      Application.Terminate();
    end
    else begin
      // Sinon on récupère la configuration
      GCONFIGAPP := GetConfig(StdGinKoia.MagasinID);
    end;

    // Vérifie si un dossier d'export est paramétré et existe
    if not(DirectoryExists(GCONFIGAPP.DestPath)) and not(FindCmdLineSwitch('PARAM')) then
    begin
      // S'il n'existe pas : on ferme le programme
      InfoMessHP('Erreur lors du chargement des paramètres.'#13#10#13#10'Le dossier d''export n''existe pas ou n''est pas paramétré.', True, 0, 0 , 'Erreur paramètres');
      Application.Terminate();
    end;

    With TIniFile.Create(GAPPPATH + GINIFILE) do
    try
      {
        GCONFIGAPP.DestPath    := ReadString('DIR','DIRDEST',GAPPPATH);
        GCONFIGAPP.Periodicite := ReadInteger('PERIODICITE','CHOIX',0);
        GCONFIGAPP.Heure       := ReadTime('PERIODICITE','HEURE',0);
        GCONFIGAPP.Minutes     := ReadInteger('PERIODICITE','MINUTES',0);
      }
      GCONFIGAPP.dPrevAction  := ReadDateTime('PARAM','DATEDEBUT',StrToDateTime(FormatDateTime('DD/MM/YYYY 00:00:00',Now)));
      GCONFIGAPP.dNextAction  := ReadDateTime('PARAM','DATEFIN',Now);
      GCONFIGAPP.sUtilisateur := ReadString('PARAM', 'Utilisateur', 'Bureau');
      GCONFIGAPP.sMotPasse    := ReadString('PARAM', 'MotPasse', '');
    finally
      Free;
    end;

    case GCONFIGAPP.Periodicite of
      0: begin
        Periode.dDateDebut := GCONFIGAPP.dPrevAction;
        Periode.dDateFin   := GCONFIGAPP.dNextAction;
        Tim_Heure.Interval := 15 * 60 * 1000;
      end;
      1: begin
        iResult := CalculTranche(Now);
        Periode := CalculPeriode(Now,iResult);
        Periode.dDateFin := IncMinute(Periode.dDateFin,GCONFIGAPP.Minutes - 15);
        GCONFIGAPP.dNextAction := Periode.dDateFin;
        Tim_Heure.Interval := (SecondsBetween(Now,GCONFIGAPP.dNextAction) + 1) * 1000;
      end;
    end;
    Lab_Heure.Caption := FormatDateTime('DD/MM/YYYY hh:mm:ss',GCONFIGAPP.dNextAction);
    Tim_Heure.Enabled := True;

    // Paramétrage de la tâche planifiée
    if GCONFIGAPP.bDemarrageAuto then
    begin
      SupprimeTachePlanifiee();
      CreerTachePlanifiee(GCONFIGAPP.tHeureDemarrage);
    end;

    // Affichage de l'heure de fin
    if GCONFIGAPP.bArretAuto then
    begin
      Lab_HeureArret.Visible := True;
      Lab_HeureArret.Caption := Format('Arrêt du programme à %s', [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
    end;  
  end;
end;

procedure Tfrm_Main.SaveParam;
var
  iTranche : integer;
  Periode : TPeriodeTranche;
begin
  Dm_EasyComptage.SaveConfigGENPARAM(StdGinKoia.MagasinID);

  With TIniFile.Create(GAPPPATH + GINIFILE) do
  try
    case GCONFIGAPP.Periodicite of
      0: begin  // cas 1 fois par jour
        GCONFIGAPP.dNextAction := StrToDateTime(FormatDateTime('DD/MM/YYYY',Now + 1) + FormatDateTime('hh:mm:00',GCONFIGAPP.Heure));
        WriteDateTime('PARAM','DATEDEBUT',GCONFIGAPP.dNextAction);
        WriteDateTime('PARAM','DATEFIN',GCONFIGAPP.dNextAction);
        Tim_Heure.Interval := (15 * 60) * 1000; // 15 minutes
      end;
      1: begin // cas plusieurs fois par jour
        iTranche := CalculTranche(Now);
        Periode  := CalculPeriode(Now,iTranche);
        GCONFIGAPP.dPrevAction := Periode.dDateDebut;
        GCONFIGAPP.dNextAction := Periode.dDateFin;
        GCONFIGAPP.dNextAction := IncMinute(GCONFIGAPP.dNextAction,(GCONFIGAPP.Minutes - 15));

        Tim_Heure.Interval := (SecondsBetween(Now,GCONFIGAPP.dNextAction) + 1) * 1000;
        WriteDateTime('PARAM','DATEFIN',IncSecond(GCONFIGAPP.dNextAction,1));
      end;
     end;// case

     Lab_Heure.Caption := FormatDateTime('DD/MM/YYYY hh:mm:ss',GCONFIGAPP.dNextAction); 

     // Affichage de l'heure de fin
     if GCONFIGAPP.bArretAuto then
     begin
       Lab_HeureArret.Visible := True;
       Lab_HeureArret.Caption := Format('Arrêt du programme à %s', [FormatDateTime('hh:nn', GCONFIGAPP.tHeureArret)]);
     end;
   { WriteString('DIR','DIRDEST',GCONFIGAPP.DestPath);
    WriteInteger('PERIODICITE','CHOIX',GCONFIGAPP.Periodicite);
    WriteTime('PERIODICITE','HEURE',GCONFIGAPP.Heure);
    WriteInteger('PERIODICITE','MINUTES',GCONFIGAPP.Minutes);
    WriteInteger('PERIODICITE','JOURS',GCONFIGAPP.Jours); }
  finally
    Free;
  end;
end;

procedure Tfrm_Main.Tim_tmprestantTimer(Sender: TObject);
var
  iRestant : Integer;
begin
  iRestant := SecondsBetween(Now,GCONFIGAPP.dNextAction);
  Lab_tmprestant.Caption := FormatFloat('00', iRestant DIV 3600);
  iRestant := iRestant Mod 3600;
  Lab_tmprestant.Caption := Lab_tmprestant.Caption + ':' + FormatFloat('00',iRestant Div 60);
  Lab_tmprestant.Caption := Lab_tmprestant.Caption + ':' + FormatFloat('00',iRestant Mod 60);
end;

procedure Tfrm_Main.Nbt_ParametrageClick(Sender: TObject);
begin
  With TFrm_Param.Create(self) do
  try
    Tim_Heure.Enabled := False;
    if ShowModal = mrOk then
    begin
      SaveParam;
    end;
  finally
    Tim_Heure.Enabled := True;
    Release;
  end;
end;


procedure Tfrm_Main.Tim_ArretAutoTimer(Sender: TObject);
begin
  // Arrête le programme si l'heure est passée
  if GCONFIGAPP.bArretAuto
    and (Time() > GCONFIGAPP.tHeureArret)
    and not(FindCmdLineSwitch('PARAM')) then
    Close();
end;

procedure Tfrm_Main.Tim_HeureTimer(Sender: TObject);
begin
  Tim_Heure.Enabled := False;
  Nbt_Parametrage.Enabled := False;
  try
    if Dm_EasyComptage.IsDatabaseOpen then
    begin
      if  Now >= GCONFIGAPP.dNextAction then
      begin
        if DoTraitement() then
        begin
          With TIniFile.Create(GAPPPATH + GINIFILE) do
          try
            WriteDateTime('PARAM','DATEDEBUT',GCONFIGAPP.dPrevAction);
            WriteDateTime('PARAM','DATEFIN',GCONFIGAPP.dNextAction);
          finally
            Free;
          end; // Wit / try
        end;
      end; // if
    End // if
    else begin
      GCONFIGAPP.dNextAction := CalculNextDate(GCONFIGAPP.dNextAction);
      Tim_Heure.Interval := (SecondsBetween(Now,GCONFIGAPP.dNextAction) + 1) * 1000;
    end;
  finally
    Lab_Heure.Caption := FormatDateTime('DD/MM/YYYY hh:mm:ss',GCONFIGAPP.dNextAction);
    Tim_Heure.Enabled := True;
    Nbt_Parametrage.Enabled := True;
  end;
end;

function Tfrm_Main.DoTraitement(): Boolean;
var
  Periode : TPeriodeTranche;
//  tbTranche : TTranche;
  OlTranche : TTrancheObList;
  bTraitementOk : Boolean;
begin
  Result := False;
  
  OlTranche := TTrancheObList.Create;
  try
    OlTranche.OwnsObjects := True;

    // Configuration des dates pour le traitement
    case GCONFIGAPP.Periodicite of
      0: begin // Cas Une fois par jour
        Periode.dDateDebut := StrToDateTime(FormatDateTime('DD/MM/YYYY 00:00:00',GCONFIGAPP.dNextAction));
        Periode.dDateFin   := StrToDateTime(FormatDateTime('DD/MM/YYYY 23:59:59',GCONFIGAPP.dNextAction));
      end; // 0
      1: begin // cas plusieurs fois par jour
        // -15 minutes afin qu'on traite les tranches avec 15mn de décalage
        Periode.dDateDebut := IncMinute(GCONFIGAPP.dPrevAction,-15);
        Periode.dDateFin   := IncMinute(GCONFIGAPP.dNextAction,-15);
      end; // 1
    end; // case

    // Creation du tableau avec mes données de la base
//    bTraitementOk := Dm_EasyComptage.SetTbFromTranche(tbTranche,Periode.dDateDebut,Periode.dDateFin,StdGinKoia.MagasinID);
    bTraitementOk := Dm_EasyComptage.SetTbFromTrancheList(OlTranche,Periode.dDateDebut,Periode.dDateFin,StdGinKoia.MagasinID);

    // génération du fichier
    if bTraitementOk then
    begin
      Result := SetTbTrancheListToFile(OlTranche,Periode.dDateDebut,Periode.dDateFin);

      // Mise à jour des timers et prochaines actions
      case GCONFIGAPP.Periodicite of
        0: begin // Cas Une fois par jour
          if bTraitementOk then
          begin
            GCONFIGAPP.dPrevAction := GCONFIGAPP.dNextAction;
            GCONFIGAPP.dNextAction := GCONFIGAPP.dNextAction + 1;
            Tim_Heure.Interval := 15 * 60 * 1000;
          end;
        end;
        1: begin // cas plusieurs fois par jour
         // Pour faire passer l'heure de, par exemple, 10:14:59 à 10:15:00
         if bTraitementOk then
           GCONFIGAPP.dPrevAction := IncSecond(GCONFIGAPP.dNextAction,1);
           GCONFIGAPP.dNextAction := CalculNextDate(GCONFIGAPP.dNextAction);
    //     GCONFIGAPP.dNextAction := IncSecond(GCONFIGAPP.dNextAction,-1);
         Tim_Heure.Interval := (SecondsBetween(Now,GCONFIGAPP.dNextAction) + 1) * 1000;
        end;
      end;
    end;
  finally
    OlTranche.Free;
  end;
end;


END.

