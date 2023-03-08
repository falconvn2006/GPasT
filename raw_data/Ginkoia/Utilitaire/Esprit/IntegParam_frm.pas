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

unit IntegParam_frm;

interface

uses
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
    RzLabel,
    RzStatus,
    fcStatusBar,
    Db,
    Grids,
    DBGrids,
    IBDataset,
    dxmdaset,
    Mask,
    DBCtrls,
    RzDBEdit,
    RzDBBnEd,
    RzDBButtonEditRv, ActionRv, IB_Components;

type
    TFrm_IntegParam = class(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        MemD_NK: TdxMemData;
        MemD_NKNUMRAYON: TStringField;
        MemD_NKRAYON: TStringField;
        MemD_NKNUMFAMILLE: TStringField;
        MemD_NKFAMILLE: TStringField;
        MemD_NKSOUSFAMILLE: TStringField;
        MemD_NKUTIL: TStringField;
        DataSource2: TDataSource;
        Que_Requete: TIBOQuery;
        Que_Secteur: TIBOQuery;
        Que_TauxTva: TIBOQuery;
        Que_TCOMPT: TIBOQuery;
        Que_Rayon: TIBOQuery;
        Que_Famille: TIBOQuery;
        Que_SSFamille: TIBOQuery;
        Que_TYGEST: TIBOQuery;
        Que_Collection: TIBOQuery;
        MemD_Taille: TdxMemData;
        DataSource8: TDataSource;
        MemD_TailleT1: TStringField;
        MemD_TailleGRILLE: TStringField;
        MemD_TailleT2: TStringField;
        MemD_TailleT3: TStringField;
        MemD_TailleT4: TStringField;
        MemD_TailleT5: TStringField;
        MemD_TailleT6: TStringField;
        MemD_TailleT7: TStringField;
        MemD_TailleT8: TStringField;
        MemD_TailleT9: TStringField;
        MemD_TailleT10: TStringField;
        MemD_TailleT11: TStringField;
        MemD_TailleT12: TStringField;
        MemD_TailleT13: TStringField;
        MemD_TailleT14: TStringField;
        MemD_TailleT15: TStringField;
        MemD_TailleT16: TStringField;
        MemD_TailleT17: TStringField;
        MemD_TailleT19: TStringField;
        MemD_TailleT20: TStringField;
        MemD_TailleT21: TStringField;
        MemD_TailleT22: TStringField;
        MemD_TailleT23: TStringField;
        MemD_TailleT24: TStringField;
        MemD_TailleT25: TStringField;
        MemD_TailleT26: TStringField;
        MemD_TailleT27: TStringField;
        MemD_TailleT28: TStringField;
        MemD_TailleT29: TStringField;
        Que_MaxTYGEST: TIBOQuery;
        Que_MaxPLXGTF: TIBOQuery;
        Que_PLXGTF: TIBOQuery;
        Que_PLXTAILLESGF: TIBOQuery;
        Que_PLXTAILLESGFTGF_ID: TIntegerField;
        Que_PLXTAILLESGFTGF_GTFID: TIntegerField;
        Que_PLXTAILLESGFTGF_IDREF: TIntegerField;
        Que_PLXTAILLESGFTGF_TGFID: TIntegerField;
        Que_PLXTAILLESGFTGF_NOM: TStringField;
        Que_PLXTAILLESGFTGF_CORRES: TStringField;
        Que_PLXTAILLESGFTGF_ORDREAFF: TIBOFloatField;
        Que_PLXTAILLESGFTGF_STAT: TIntegerField;
        Chp_Taille: TRzDBButtonEditRv;
        Chp_DataBase: TRzDBButtonEditRv;
        OpenDialog1: TOpenDialog;
        OpenDialog2: TOpenDialog;
        OpenDialog3: TOpenDialog;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel4: TRzLabel;
        LMDButton1: TLMDButton;
        Chp_Nomenclature: TRzDBButtonEditRv;
        MemD_TailleT18: TStringField;
        MemD_Chp: TdxMemData;
        Ds_Chp: TDataSource;
        MemD_Chpch1: TStringField;
        MemD_Chpch2: TStringField;
        MemD_Chpch3: TStringField;
        closeQ: TGroupDataRv;
        Que_Test: TIBOQuery;
        Que_TestPRM_ID: TIntegerField;
        Que_TestPRM_CODE: TIntegerField;
        Que_TestPRM_INTEGER: TIntegerField;
        Que_TestPRM_FLOAT: TIBOFloatField;
        Que_TestPRM_STRING: TStringField;
        Que_TestPRM_TYPE: TIntegerField;
        Que_TestPRM_MAGID: TIntegerField;
        Que_TestPRM_INFO: TStringField;
        Que_TestPRM_POS: TIntegerField;
        LMDSpeedButton1: TLMDSpeedButton;
        Que_Cat: TIBOQuery;
        Que_CatCTF_ID: TIntegerField;
        Que_CatCTF_NOM: TStringField;
        Que_CatCTF_UNIID: TIntegerField;
    Que_Sf: TIBOQuery;
    Que_SfFAM_CTFID: TIntegerField;
    Que_SfFAM_ID: TIntegerField;
    IbC_Uni: TIB_Cursor;
    LMDSpeedButton2: TLMDSpeedButton;
        procedure Nbt_QuitClick(Sender: TObject);
        procedure AlgolStdFrmShow(Sender: TObject);
        procedure AlgolStdFrmCreate(Sender: TObject);
        procedure GenerikAfterCancel(DataSet: TDataSet);
        procedure GenerikAfterPost(DataSet: TDataSet);
        procedure GenerikBeforeDelete(DataSet: TDataSet);
        procedure GenerikNewRecord(DataSet: TDataSet);
        procedure GenerikUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel2(DataSet: TDataSet);
        procedure GenerikAfterPost2(DataSet: TDataSet);
        procedure GenerikBeforeDelete2(DataSet: TDataSet);
        procedure GenerikNewRecord2(DataSet: TDataSet);
        procedure GenerikUpdateRecord2(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel3(DataSet: TDataSet);
        procedure GenerikAfterPost3(DataSet: TDataSet);
        procedure GenerikBeforeDelete3(DataSet: TDataSet);
        procedure GenerikNewRecord3(DataSet: TDataSet);
        procedure GenerikUpdateRecord3(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);

        procedure GenerikAfterCancel4(DataSet: TDataSet);
        procedure GenerikAfterPost4(DataSet: TDataSet);
        procedure GenerikBeforeDelete4(DataSet: TDataSet);
        procedure GenerikNewRecord4(DataSet: TDataSet);
        procedure GenerikUpdateRecord4(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel6(DataSet: TDataSet);
        procedure GenerikAfterPost6(DataSet: TDataSet);
        procedure GenerikBeforeDelete6(DataSet: TDataSet);
        procedure GenerikNewRecord6(DataSet: TDataSet);
        procedure GenerikUpdateRecord6(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel7(DataSet: TDataSet);
        procedure GenerikAfterPost7(DataSet: TDataSet);
        procedure GenerikBeforeDelete7(DataSet: TDataSet);
        procedure GenerikNewRecord7(DataSet: TDataSet);
        procedure GenerikUpdateRecord7(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel8(DataSet: TDataSet);
        procedure GenerikAfterPost8(DataSet: TDataSet);
        procedure GenerikBeforeDelete8(DataSet: TDataSet);
        procedure GenerikNewRecord8(DataSet: TDataSet);
        procedure GenerikUpdateRecord8(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel9(DataSet: TDataSet);
        procedure GenerikAfterPost9(DataSet: TDataSet);
        procedure GenerikBeforeDelete9(DataSet: TDataSet);
        procedure GenerikNewRecord9(DataSet: TDataSet);
        procedure GenerikUpdateRecord9(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel10(DataSet: TDataSet);
        procedure GenerikAfterPost10(DataSet: TDataSet);
        procedure GenerikBeforeDelete10(DataSet: TDataSet);
        procedure GenerikNewRecord10(DataSet: TDataSet);
        procedure GenerikUpdateRecord10(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel11(DataSet: TDataSet);
        procedure GenerikAfterPost11(DataSet: TDataSet);
        procedure GenerikBeforeDelete11(DataSet: TDataSet);
        procedure GenerikNewRecord11(DataSet: TDataSet);
        procedure GenerikUpdateRecord11(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel12(DataSet: TDataSet);
        procedure GenerikAfterPost12(DataSet: TDataSet);
        procedure GenerikBeforeDelete12(DataSet: TDataSet);
        procedure GenerikNewRecord12(DataSet: TDataSet);
        procedure GenerikUpdateRecord12(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);

        procedure GenerikAfterCancel13(DataSet: TDataSet);
        procedure GenerikAfterPost13(DataSet: TDataSet);
        procedure GenerikBeforeDelete13(DataSet: TDataSet);
        procedure GenerikNewRecord13(DataSet: TDataSet);
        procedure GenerikUpdateRecord13(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure GenerikAfterCancel14(DataSet: TDataSet);
        procedure GenerikAfterPost14(DataSet: TDataSet);
        procedure GenerikBeforeDelete14(DataSet: TDataSet);
        procedure GenerikNewRecord14(DataSet: TDataSet);
        procedure GenerikUpdateRecord14(DataSet: TDataSet;
            UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
        procedure RzDBButtonEditRv1ButtonClick(Sender: TObject);
        procedure Chp_TailleButtonClick(Sender: TObject);
        procedure Chp_DataBaseButtonClick(Sender: TObject);
        procedure LMDButton1Click(Sender: TObject);
        procedure AlgolStdFrmCloseQuery(Sender: TObject;
            var CanClose: Boolean);

        procedure LMDSpeedButton1Click(Sender: TObject);
    procedure LMDSpeedButton2Click(Sender: TObject);
   


    private
        UserCanModify, UserVisuMags: Boolean;
        { Private declarations }
    protected
        { Protected declarations }
    public
          PROCEDURE famille(cod:string;cat:integer);
    published
        { Published declarations }
    end;

var
    Frm_IntegParam: TFrm_IntegParam;
implementation

uses
    GinkoiaResStr,
    DlgStd_Frm,
    GinKoiaStd,
    Main_Dm,
ComObj;

{$R *.DFM}

procedure TFrm_IntegParam.AlgolStdFrmCreate(Sender: TObject);
begin

    try
        screen.Cursor := crSQLWait;
        // pour si des fois qu'init longue car ouverture de tables ...etc

        //CurCtrl := xxx;
        // contôle qui doit avoir le focus en entrée

        Hint := Caption;
        StdGinkoia.AffecteHintEtBmp(self);
        UserVisuMags := StdGinkoia.UserVisuMags;
        UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
        memd_chp.open;
        memd_chp.append;
    finally
        screen.Cursor := crDefault;
    end;
end;

procedure TFrm_IntegParam.Nbt_QuitClick(Sender: TObject);
var
    CanClose: Boolean;
begin
    //    CanClose := True;
    //    AlgolStdFrmCloseQuery(Sender, CanClose);
    //    IF CanClose THEN KillAction.Execute;
end;

procedure TFrm_IntegParam.AlgolStdFrmShow(Sender: TObject);
begin

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

    if Init then
    begin
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

    end;

end;

procedure TFrm_IntegParam.GenerikAfterPost(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel2(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost2(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete2(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord2(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord2(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel3(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost3(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete3(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord3(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord3(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

//----------------------------------------------------------------------------//
// Ouverture du fichier CSV 1 - nomenclature en CSV

procedure TFrm_IntegParam.RzDBButtonEditRv1ButtonClick(Sender: TObject);
var
    F1: TextFile;
begin
    if not OpenDialog1.execute then EXIT;
    //Lire le contenu du fichier
    MemD_NK.close;
    MemD_NK.open;
    MemD_NK.DelimiterChar := ';';
    MemD_NK.LoadFromTextFile(OpenDialog1.FileName);
    Chp_Nomenclature.Text := OpenDialog1.FileName;
end;

//----------------------------------------------------------------------------//
// Ouverture du fichier CSV 2

procedure TFrm_IntegParam.Chp_TailleButtonClick(Sender: TObject);
var
    F2: TextFile;
begin
    if not OpenDialog2.execute then EXIT;
    //Lire le contenu du fichier
    MemD_Taille.close;
    MemD_Taille.open;
    MemD_Taille.DelimiterChar := ';';
    MemD_Taille.LoadFromTextFile(OpenDialog2.FileName);
    Chp_Taille.Text := OpenDialog2.FileName;
end;

//----------------------------------------------------------------------------//
// Ouverture du fichier Data Base
//----------------------------------------------------------------------------//

procedure TFrm_IntegParam.Chp_DataBaseButtonClick(Sender: TObject);
begin
    if not OpenDialog3.execute then EXIT;
    // Nouvelle Data Base
    DM_Main.Database.Close;
    Main_DM.Dm_Main.Database.Connected := false;
    DM_Main.Database.DatabaseName := OpenDialog3.FileName;
    DM_Main.Database.path := OpenDialog3.FileName;
    DM_Main.Database.Open;
    DM_Main.Database.Connected := true;
    Chp_DataBase.Text := OpenDialog3.FileName;
    // Association des requetes a la Data Base
//    Que_Requete.DatabaseName := OpenDialog3.FileName;
//    Que_Secteur.DatabaseName := OpenDialog3.FileName;
//    Que_TauxTva.DatabaseName := OpenDialog3.FileName;
//    Que_TCOMPT.DatabaseName := OpenDialog3.FileName;
//    Que_Rayon.DatabaseName := OpenDialog3.FileName;
//    Que_Famille.DatabaseName := OpenDialog3.FileName;
//    Que_SSFamille.DatabaseName := OpenDialog3.FileName;
//    Que_TYGEST.DatabaseName := OpenDialog3.FileName;
//    Que_Collection.DatabaseName := OpenDialog3.FileName;
//    Que_MaxTYGEST.DatabaseName := OpenDialog3.FileName;
//    Que_MaxPLXGTF.DatabaseName := OpenDialog3.FileName;
//    Que_PLXGTF.DatabaseName := OpenDialog3.FileName;
//    Que_PLXTAILLESGF.DatabaseName := OpenDialog3.FileName;

    // Activation des Requetes
    Que_Requete.active := True;
    Que_Secteur.active := True;
    Que_TauxTva.active := True;
    Que_TCOMPT.active := True;
    Que_Rayon.active := True;
    Que_Famille.active := True;
    Que_SSFamille.active := True;
    Que_TYGEST.active := True;
    Que_Collection.active := True;
    Que_MaxTYGEST.active := True;
    Que_MaxPLXGTF.active := True;
    Que_PLXGTF.active := True;
    Que_PLXTAILLESGF.active := True;
end;




procedure TFrm_IntegParam.GenerikAfterCancel4(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost4(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete4(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord4(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord4(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;




procedure TFrm_IntegParam.GenerikAfterCancel6(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost6(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete6(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord6(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord6(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel7(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost7(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete7(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord7(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord7(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel8(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost8(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete8(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord8(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord8(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel9(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost9(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete9(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord9(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord9(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel10(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost10(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete10(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord10(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord10(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel11(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost11(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete11(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord11(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord11(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel12(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost12(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete12(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord12(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord12(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;



procedure TFrm_IntegParam.GenerikAfterCancel13(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost13(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete13(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord13(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord13(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

procedure TFrm_IntegParam.GenerikAfterCancel14(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikAfterPost14(DataSet: TDataSet);
begin
    Dm_Main.IBOUpDateCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.GenerikBeforeDelete14(DataSet: TDataSet);
begin
    { A achever ...
        IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
        BEGIN
            StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
            ABORT;
        END;
    }
end;

procedure TFrm_IntegParam.GenerikNewRecord14(DataSet: TDataSet);
begin
    if not Dm_Main.IBOMajPkKey((DataSet as TIBODataSet),
        (DataSet as TIBODataSet).KeyLinks.IndexNames[0]) then Abort;
end;

procedure TFrm_IntegParam.GenerikUpdateRecord14(DataSet: TDataSet;
    UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
    Dm_Main.IBOUpdateRecord((DataSet as TIBODataSet).KeyRelation,
        (DataSet as TIBODataSet), UpdateKind, UpdateAction);
end;

//------------------------------------------------------------------------------//
//  Traitement principal
//
// - creation d'un enomenclature
// - creation d'une grille de taille
//------------------------------------------------------------------------------//

procedure TFrm_IntegParam.LMDButton1Click(Sender: TObject);
var
    UNI_ID, SEC_ID, TVA_ID, TCT_ID: string;
    IndiceR1, IndiceR2, IndiceF, IndiceSSF: string;
    Recup_IDRAY, Recup_IDFAM, Recup_IDSSFAM: integer;
    Recup_IDGTF: string;
    maxPLXTYPEGT, maxPLXGTF: integer;
    ID_TYPEGT: integer;

    TextTemp: string;
    IntTemp: integer;
    StrQuery: string;
    inc, inc2: integer;
    lettre: Char;
begin
    if (chp_database.text = '') or (chp_nomenclature.text = '') or (chp_taille.text = '') then
    begin
        InfoMessHP('Champs non renseignées, traitement impossible...', false, 0, 0, 'Traitement');
        EXIT;
    end;


    que_test.Open;
    if not que_test.eof then
    begin
        InfoMessHP('Le traiement a déjà été réalisé sur cette base...', false, 0, 0, 'Traitement');
        EXIT;
    end;



    // Message d'attente
        //aitMessHP('Traitement en cours', 5, false, 300, 200, 'Traitement');
    ShowMessHPAvi('Traitement en cours...', false, 0, 0, '');

    //---------------------------------------
    // --- CREATION DE LA NOMENCLATURE --- //
    // Recuperation (ou creation) de l'univers Textiles
     //   StrQuery := 'SELECT UNI_ID, UNI_NOM FROM NKLUNIVERS join k on k_id=UNI_ID where K_ENABLED=1 and UNI_NOM = ''SPORTLINK''';
    //    que_requete.sql.clear;
    //    que_requete.sql.Add(StrQuery);
        //que_requete.ExecSql;
    UNI_ID := que_requete.FieldByName('UNI_ID').AsString;
    if UNI_ID = '' then
    begin
        que_requete.insert;
        que_requete.fieldbyname('UNI_NOM').asstring := 'TEXTILES';
        que_requete.post;
        UNI_ID := que_requete.FieldByName('UNI_ID').AsString;
    end;
    // Recuperation (ou creation) du Secteur ESPRIT
    StrQuery := 'SELECT SEC_ID, SEC_NOM, SEC_IDREF, SEC_UNIID FROM NKLSECTEUR join k on k_id=SEC_ID where K_ENABLED=1 and SEC_NOM = ''ESPRIT''';
    Que_Secteur.sql.clear;
    Que_Secteur.sql.Add(StrQuery);
    Que_Secteur.ExecSql;
    SEC_ID := Que_Secteur.FieldByName('SEC_ID').AsString;
    if SEC_ID = '' then
    begin
        Que_Secteur.Active := true;
        Que_Secteur.insert;
        Que_Secteur.fieldbyname('SEC_NOM').asstring := 'ESPRIT';
        Que_Secteur.fieldbyname('SEC_IDREF').AsInteger := 0;
        Que_Secteur.fieldbyname('SEC_UNIID').AsString := UNI_ID;
        Que_Secteur.post;
        SEC_ID := Que_Secteur.FieldByName('SEC_ID').AsString;
    end;
    // Recuperation de l'ID TVA pour 19,6 (Table ARTTVA)
    Que_TauxTVA.Open;
    TVA_ID := Que_TauxTVA.fieldbyname('TVA_ID').asstring;

    // Recuperation du Correspondant TCT =0 (Table ARTTYPECOMPTABLE)
    Que_TCOMPT.Open;
    TCT_ID := Que_TCOMPT.fieldbyname('TCT_ID').asstring;

    inc := 0;
    IndiceR1 := '';
    IndiceR1 := '*';
    Recup_IDRAY := 0;
    Recup_IDFAM := 0;
    Recup_IDSSFAM := 0;
    MemD_NK.first;
    while inc < MemD_NK.RecordCount do
    begin
        TextTemp := MemD_NK.fieldbyname('RAYON').asstring;
        if IndiceR1 <> IndiceR2 then
        begin
            // insertion d'un nouveau rayon
            Que_Rayon.Active := true;
            Que_Rayon.insert;
            Que_Rayon.fieldbyname('ray_uniid').asstring := UNI_ID;
            Que_Rayon.fieldbyname('ray_nom').asstring := MemD_NK.fieldbyname('NUMRAYON').asstring + ' - ' + MemD_NK.fieldbyname('RAYON').asstring;
            Que_Rayon.fieldbyname('ray_ordreaff').AsInteger := MemD_NK.fieldbyname('NUMRAYON').AsInteger;
            Que_Rayon.fieldbyname('ray_visible').AsInteger := 1;
            Que_Rayon.fieldbyname('ray_idref').AsInteger := 0;
            Que_Rayon.fieldbyname('ray_secid').asstring := SEC_ID;
            Que_Rayon.post;
            // Recuperation de ID du rayon créé
            Recup_IDRAY := Que_Rayon.FieldByName('RAY_ID').AsInteger;
        end;
        // Insertion d'une famille
        Que_Famille.Active := true;
        Que_Famille.insert;
        Que_Famille.fieldbyname('FAM_RAYID').AsInteger := Recup_IDRAY;
        Que_Famille.fieldbyname('FAM_IDREF').AsInteger := 0;
        Que_Famille.fieldbyname('FAM_NOM').asstring := MemD_NK.fieldbyname('NUMFAMILLE').asstring + ' - ' + MemD_NK.fieldbyname('FAMILLE').asstring;
        Que_Famille.fieldbyname('FAM_ORDREAFF').AsInteger := inc;
        Que_Famille.fieldbyname('FAM_visible').AsInteger := 1;
        Que_Famille.fieldbyname('FAM_CTFID').AsInteger := 0;
        Que_Famille.post;
        Recup_IDFAM := Que_Famille.FieldByName('FAM_ID').AsInteger;
        // Insertion d'une Sous Famille
        Que_SSFamille.Active := true;
        Que_SSFamille.insert;
        Que_SSFamille.fieldbyname('SSF_FAMID').AsInteger := Recup_IDFAM;
        Que_SSFamille.fieldbyname('SSF_IDREF').AsInteger := 0;
        Que_SSFamille.fieldbyname('SSF_NOM').asstring := MemD_NK.fieldbyname('SOUSFAMILLE').asstring;
        Que_SSFamille.fieldbyname('SSF_ORDREAFF').AsInteger := inc;
        Que_SSFamille.fieldbyname('SSF_visible').AsInteger := 1;
        Que_SSFamille.fieldbyname('SSF_CATID').AsInteger := 0;
        Que_SSFamille.fieldbyname('SSF_TVAID').asstring := TVA_ID;
        Que_SSFamille.fieldbyname('SSF_TCTID').asstring := TCT_ID;
        Que_SSFamille.post;

        // incrementation
        IndiceR1 := MemD_NK.fieldbyname('RAYON').asstring;
        MemD_NK.next;
        IndiceR2 := MemD_NK.fieldbyname('RAYON').asstring;
        inc := inc + 1;
    end;
    // Message d'attente
     //   WaitMessHP('Fin de creation de nomenclature', 3, false, 300, 200, 'Traitement');

    //---------------------------------------------------------
    //--- CREATION DES GRILLES DE TAILLES --- //
    // -- Nouvelle collection Esprit : (Table ARTCOLLECTION) -- //
    for lettre := 'A' to 'Z' do
    begin
        Que_Collection.insert;
        Que_Collection.fieldbyname('Col_NOM').asstring := lettre;
        Que_Collection.fieldbyname('Col_NoVisible').AsInteger := 0;
        Que_Collection.fieldbyname('Col_REFDYNA').AsInteger := 0;
        Que_Collection.post;
    end;

    // -- Nouvelle categorie Esprit : (Table PLXTYPEGT) -- //
    // Recuperation du max Ordreaff dans la table PLXTYPEPEGT et incrementation
    Que_MaxTYGEST.Open;
    maxPLXTYPEGT := Que_MaxTYGEST.fieldbyname('MaxT').AsInteger;
    maxPLXTYPEGT := maxPLXTYPEGT + 10;
    // Creation d'un nouvel enregistrement nom=ESPRIT (table PLXTYPEPEGT)
    Que_TYGEST.insert;
    Que_TYGEST.fieldbyname('TGT_NOM').asstring := 'ESPRIT';
    Que_TYGEST.fieldbyname('TGT_OrdreAff').AsInteger := maxPLXTYPEGT;
    Que_TYGEST.post;
    ID_TYPEGT := Que_TYGEST.FieldByName('TGT_ID').AsInteger;
    // Recuperation du max Ordreaff dans la table PLXGTF
    Que_MaxPLXGTF.Open;
    maxPLXGTF := Que_MaxPLXGTF.fieldbyname('MaxT2').AsInteger;

    inc := 0;
    MemD_Taille.first;
    while inc < MemD_Taille.RecordCount do
    begin
        maxPLXGTF := maxPLXGTF + 10;
        // insertion d'un nouvel entete
        Que_PLXGTF.insert;
        Que_PLXGTF.fieldbyname('GTF_idref').asstring := MemD_TAILLE.fieldbyname('GRILLE').asstring;
        Que_PLXGTF.fieldbyname('GTF_nom').asstring := 'ESPRIT ' + MemD_TAILLE.fieldbyname('GRILLE').asstring;
        Que_PLXGTF.fieldbyname('GTF_TGTID').AsInteger := ID_TYPEGT;
        Que_PLXGTF.fieldbyname('GTF_ORDREAFF').AsInteger := maxPLXGTF;
        Que_PLXGTF.fieldbyname('GTF_IMPORT').AsInteger := 0;
        Que_PLXGTF.post;
        // Recuperation de ID du rayon créé
        Recup_IDGTF := Que_PLXGTF.FieldByName('GTF_ID').asstring;

        // insertion des Tailles (Table PLXTAILLESGF)
        inc2 := 1;
        TextTemp := 'T' + IntToStr(inc2);
        while inc2 < 30 do
        begin
            TextTemp := 'T' + IntToStr(inc2);
            if (MemD_TAILLE.fieldbyname(TextTemp).asstring <> '') then
            begin
                if (MemD_TAILLE.fieldbyname(TextTemp).asstring <> ' ') then
                begin
                    Que_PLXTAILLESGF.insert;
                    Que_PLXTAILLESGF.fieldbyname('TGF_GTFID').asstring := Recup_IDGTF;
                    Que_PLXTAILLESGF.fieldbyname('TGF_IDREF').AsInteger := 0;
                    Que_PLXTAILLESGF.fieldbyname('TGF_TGFID').AsInteger := Que_PLXTAILLESGF.fieldbyname('TGF_ID').AsInteger;
                    Que_PLXTAILLESGF.fieldbyname('TGF_NOM').asstring := MemD_TAILLE.fieldbyname(TextTemp).asstring;
                    Que_PLXTAILLESGF.fieldbyname('TGF_CORRES').asstring := '';
                    Que_PLXTAILLESGF.fieldbyname('TGF_ORDREAFF').AsInteger := inc2;
                    Que_PLXTAILLESGF.fieldbyname('TGF_STAT').AsInteger := 0;
                    Que_PLXTAILLESGF.post;
                end;
            end;
            inc2 := inc2 + 1;
        end;
        // incrementation
        MemD_Taille.next;
        inc := inc + 1;

    end;

    //"Marquage dans Genparam que opération realisé
    que_test.insert;
    que_test.fieldbyname('prm_code').asinteger := 0;
    que_test.fieldbyname('prm_integer').asinteger := 1;
    que_test.fieldbyname('prm_float').asfloat := 0;
    que_test.fieldbyname('prm_type').asinteger := 12;
    que_test.post;

    // Message d'attente


    //Catégories de familles
    LMDSpeedButton1Click(nil);


    ShowCloseHP;
    // Message de Fin de traitement
    InfoMessHP('Traitement terminé', false, 0, 0, 'Traitement');

    // Fermeture de l'executable
    frm_IntegParam.Close;

end;

procedure TFrm_IntegParam.GenerikAfterCancel(DataSet: TDataSet);
begin
    Dm_Main.IBOCancelCache(DataSet as TIBOQuery);
end;

procedure TFrm_IntegParam.AlgolStdFrmCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    closeQ.close;
end;






procedure TFrm_IntegParam.LMDSpeedButton1Click(Sender: TObject);
begin
    que_cat.open;
    ibc_uni.open;


    que_cat.insert;
    Que_CatCTF_NOM.asstring := '21 CASUAL FEMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('21', Que_CatCTF_ID.asinteger);
    Famille('22', Que_CatCTF_ID.asinteger);
    Famille('27', Que_CatCTF_ID.asinteger);
    Famille('29', Que_CatCTF_ID.asinteger);
    Famille('44', Que_CatCTF_ID.asinteger);
    Famille('51', Que_CatCTF_ID.asinteger);
    Famille('94', Que_CatCTF_ID.asinteger);



    que_cat.insert;
    Que_CatCTF_NOM.asstring := '23 COLLECTION FEMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('23', Que_CatCTF_ID.asinteger);
    Famille('24', Que_CatCTF_ID.asinteger);
    Famille('28', Que_CatCTF_ID.asinteger);
    Famille('58', Que_CatCTF_ID.asinteger);
    Famille('92', Que_CatCTF_ID.asinteger);

    que_cat.insert;
    Que_CatCTF_NOM.asstring := '40 EDC FEMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('40', Que_CatCTF_ID.asinteger);
    Famille('41', Que_CatCTF_ID.asinteger);
    Famille('42', Que_CatCTF_ID.asinteger);
    Famille('57', Que_CatCTF_ID.asinteger);
    Famille('44', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := '30 CASUAL HOMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('30', Que_CatCTF_ID.asinteger);
    Famille('31', Que_CatCTF_ID.asinteger);
    Famille('32', Que_CatCTF_ID.asinteger);
    Famille('43', Que_CatCTF_ID.asinteger);
    Famille('90', Que_CatCTF_ID.asinteger);
    Famille('52', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := '33 COLLECTION HOMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('33', Que_CatCTF_ID.asinteger);
    Famille('34', Que_CatCTF_ID.asinteger);
    Famille('39', Que_CatCTF_ID.asinteger);
    Famille('78', Que_CatCTF_ID.asinteger);
    Famille('55', Que_CatCTF_ID.asinteger);
    Famille('61', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := '35 EDC HOMME';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;

    Famille('35', Que_CatCTF_ID.asinteger);
    Famille('36', Que_CatCTF_ID.asinteger);
    Famille('37', Que_CatCTF_ID.asinteger);
    Famille('59', Que_CatCTF_ID.asinteger);
    Famille('98', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := 'ACCESSOIRES';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;

    Famille('15', Que_CatCTF_ID.asinteger);
    Famille('26', Que_CatCTF_ID.asinteger);
    Famille('45', Que_CatCTF_ID.asinteger);
    Famille('47', Que_CatCTF_ID.asinteger);
    Famille('85', Que_CatCTF_ID.asinteger);
    Famille('53', Que_CatCTF_ID.asinteger);

    que_cat.insert;
    Que_CatCTF_NOM.asstring := 'CHAUSSURES';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('10', Que_CatCTF_ID.asinteger);
    Famille('11', Que_CatCTF_ID.asinteger);
    Famille('12', Que_CatCTF_ID.asinteger);
    Famille('13', Que_CatCTF_ID.asinteger);
    Famille('14', Que_CatCTF_ID.asinteger);
    Famille('54', Que_CatCTF_ID.asinteger);
    Famille('49', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := 'EDC ACCESSOIRES';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('48', Que_CatCTF_ID.asinteger);


    que_cat.insert;
    Que_CatCTF_NOM.asstring := '01 DE CORP';
    Que_CatCTF_UNIID.asinteger := ibc_uni.fieldbyname('uni_id').asinteger;
    que_cat.post;
    Famille('01', Que_CatCTF_ID.asinteger);
    Famille('60', Que_CatCTF_ID.asinteger);

   

end;


PROCEDURE TFrm_IntegParam.famille(cod:string;cat:integer);
begin

     que_sf.close;
     que_sf.parambyname('cod').asstring:=cod;
     que_sf.open;
     que_sf.first;
     WHILE not que_sf.eof do
     begin
         que_sf.edit;
         Que_SfFAM_CTFID.asinteger:=cat;
         que_sf.post;
         que_sf.next;
     END;
     que_sf.close;









end;

procedure TFrm_IntegParam.LMDSpeedButton2Click(Sender: TObject);


  VAR my_ole_application,OleWorkBook : Variant;
begin





  my_ole_application:= CreateOleObject('Excel.Application');
  my_ole_application.Visible:= True;
  OleWorkBook:=my_ole_application.Workbooks.open('c:\ca.csv');


end;

end.

