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

UNIT Param_frm;

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
    ExtCtrls,
    RzPanel,
    StdCtrls,
    RzLabel,  Mask,uDefs,
  rxToolEdit, Buttons, RzRadGrp, RzEdit, RzButton, RzRadChk;

TYPE
    TFrm_Param = CLASS(TAlgolStdFrm)
    Lab_DestDir: TRzLabel;
    RepCmb_DestDir: TDirectoryEdit;
    Lab_heure: TRzLabel;
    Lab_ttles: TRzLabel;
    Lab_minutes: TRzLabel;
    Lab_suppinfo: TRzLabel;
    Lab_jours: TRzLabel;
    rze_minutes: TRzEdit;
    rze_jours: TRzEdit;
    GRb_Periodicite: TRzRadioGroup;
    Rzdt_heure: TRzDateTimeEdit;
    Pan_Page: TRzPanel;
    Nbt_Valider: TBitBtn;
    Nbt_Annuler: TBitBtn;
    Gbx_ArretDemarageAuto: TRzGroupBox;
    Bevel1: TBevel;
    Rzdt_Demarrage: TRzDateTimeEdit;
    Rzdt_Arret: TRzDateTimeEdit;
    Chk_Demarrage: TRzCheckBox;
    Chk_Arret: TRzCheckBox;
    Nbt_DemarrageAuto: TBitBtn;
        PROCEDURE Nbt_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
    procedure Nbt_ValiderClick(Sender: TObject);
    procedure rze_minutesKeyPress(Sender: TObject; var Key: Char);
    procedure GRb_PeriodiciteChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure Chk_DemarrageClick(Sender: TObject);
    procedure Chk_ArretClick(Sender: TObject);
    procedure Nbt_DemarrageAutoClick(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;

        FUNCTION VerifParam : Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;


     VAR Frm_Param: TFrm_Param;
IMPLEMENTATION

USES
    GinkoiaResStr,
    DlgStd_Frm, GinKoiaStd;

{$R *.DFM}

PROCEDURE TFrm_Param.AlgolStdFrmCreate(Sender: TObject);
var
  bAllow : Boolean;
BEGIN
  With GCONFIGAPP do
  begin
    RepCmb_DestDir.Text := GCONFIGAPP.DestPath;
    GRb_Periodicite.ItemIndex := Periodicite;
    rzdt_heure.Time   := Heure;
    rze_minutes.Text := IntToStr(Minutes);
    rze_jours.Text   := IntToStr(Jours);

    bAllow := True;
    GRb_PeriodiciteChanging(GRb_Periodicite,Periodicite,bAllow);

    Chk_Demarrage.Checked := bDemarrageAuto;
    Rzdt_Demarrage.Time   := tHeureDemarrage;
    Chk_Arret.Checked     := bArretAuto;
    Rzdt_Arret.Time       := tHeureArret;
  end;

  TRY
      // pour si des fois qu'init longue car ouverture de tables ...etc
      screen.Cursor := crSQLWait;

      // contôle qui doit avoir le focus en entrée
      CurCtrl := RepCmb_DestDir;

      Hint := Caption;
      StdGinkoia.AffecteHintEtBmp(self);
      UserVisuMags := StdGinkoia.UserVisuMags;
      UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
  FINALLY
      screen.Cursor := crDefault;
  END;
END;

procedure TFrm_Param.Nbt_DemarrageAutoClick(Sender: TObject);
begin
  CreerDemarrageAuto();
end;

PROCEDURE TFrm_Param.Nbt_QuitClick(Sender: TObject);
VAR
    CanClose: Boolean;
BEGIN
    CanClose := True;
    AlgolStdFrmCloseQuery(Sender, CanClose);
    IF CanClose THEN KillAction.Execute;
END;

PROCEDURE TFrm_Param.AlgolStdFrmCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
//
END;

PROCEDURE TFrm_Param.AlgolStdFrmShow(Sender: TObject);
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

procedure TFrm_Param.Chk_ArretClick(Sender: TObject);
begin
  Rzdt_Arret.Enabled      := Chk_Arret.Checked;
end;

procedure TFrm_Param.Chk_DemarrageClick(Sender: TObject);
begin
  Rzdt_Demarrage.Enabled  := Chk_Demarrage.Checked;
end;

procedure TFrm_Param.Nbt_ValiderClick(Sender: TObject);
begin
  if VerifParam then
  begin
    // Enregistre la tâche planifiée
    if Chk_Demarrage.Checked then
    begin
      SupprimeTachePlanifiee();
      CreerTachePlanifiee(Rzdt_Demarrage.Time);
    end
    else
      SupprimeTachePlanifiee();

    With GCONFIGAPP do
    begin
      DestPath         := IncludeTrailingBackslash(RepCmb_DestDir.Text);
      Periodicite      := GRb_Periodicite.ItemIndex;
      Heure            := Rzdt_heure.Time;
      Minutes          := StrToInt(rze_minutes.Text);
      Jours            := StrToInt(rze_jours.Text);
      bDemarrageAuto   := Chk_Demarrage.Checked;
      tHeureDemarrage  := Rzdt_Demarrage.Time;
      bArretAuto       := Chk_Arret.Checked;
      tHeureArret      := Rzdt_Arret.Time;
    end;
    ModalResult := mrOk;
  end;
end;

procedure TFrm_Param.rze_minutesKeyPress(Sender: TObject; var Key: Char);
begin
  VerNumAll(TEdit(Sender),Key,False,False);
end;

function TFrm_Param.VerifParam: Boolean;
begin
  Result := False;

  // vérification du directory
  if RepCmb_DestDir.Text = '' then
  begin
    InfoMessHP('Veuillez choisir un répertoire de destination du fichier d''export',True,0,0,'Erreur');
    RepCmb_DestDir.SetFocus;
    Exit;
  end;

  // Vérification des données de la périodicité
  case GRb_Periodicite.ItemIndex of
    0: begin
      if Rzdt_heure.Text = '' then
      begin
       InfoMessHP('Veuillez saisir l''heure de génération du fichier d''export',True,0,0,'Erreur');
       Rzdt_heure.SetFocus;
       Exit;
      end;
    end; // 0
    1: begin
      if rze_minutes.Text = '' then
      begin
        InfoMessHP('Veuillez saisir le nombre de minutes entre deux générations du fichier d''export',True,0,0,'Erreur');
        rze_minutes.SetFocus;
        Exit;
      end
      else begin
        if (StrToInt(rze_Minutes.text) Mod 15) <> 0 then
        begin
          InfoMessHP('Le nombre de minutes doit être un multiple de 15' + #13#10 + '(Ex : 15/30/60/90/ etc ...)',True,0,0,'Erreur');
          rze_minutes.SetFocus;
          Exit;
        end;
      end; // else

    end; // 1
  end; // case

  // Vérification de la saisie du nombre de jour
  if rze_jours.Text = '' then
  begin
    InfoMessHP('Veuillez indiquer le nombre de jours pour la suppression',True,0,0,'Erreur');
    rze_jours.SetFocus;
    Exit;
  end;

  Result := True;
end;


procedure TFrm_Param.GRb_PeriodiciteChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  Rzdt_heure.Enabled := (NewIndex = 0);
  rze_minutes.Enabled := (NewIndex = 1);

end;

END.

