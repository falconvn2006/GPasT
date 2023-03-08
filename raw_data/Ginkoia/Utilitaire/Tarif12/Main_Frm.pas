{***************************************************************
 *
 * Unit Name: Main_Frm
 * Purpose  :
 * Author   :
 * History  :
 *
 ****************************************************************}

//*********************************************************************************
//*                                                                               *
//*  Unit Description : Forme principale standard                                 *
//*                                                                               *
//*  Author/Developer : Hervé                                                     *
//*                                                                               *
//*  Copyright (c) Algol                                                          *
//*  All Rights reserved.                                                         *
//*                                                                               *
//*  20/08/2000 22:19:51                                                          *
//*                                                                               *
//*  Modèle de forme principale standard                                          *
//*                                                                               *
//*                                                                               *
//*                                                                               *
//*********************************************************************************

{***************************************************************
 Remarques :

   IMPORTANT
   *********
   LE DM_MAIN est déclaré dans le projet mais laissé dans la partie "Non crée"
   en automatique du projet.
   Aprés création de la base, il suffit de le basculer de l'autre côté depuis
   la boite des options de projet
   NOTA : aucune forme ne déclare le DM_Main qui est donc à rajouter dans la clause
   Uses des formes pour lesquelles c'est nécessaire...

   NE PAS HERITER DE CE MODELE car problèmes à cause des composants Système
   COPIER : Crée une copie
   UTILISER : Travaille sur les originaux mais attention toute modif
   est répercutée dans les autres programmes qui "utilisent"

   Nota : En cas de non nécessité de la ScrollBox dans la fiche de base, supprimer
   le composant et les 2 lignes des unités correspondantes en fin de la clause Uses ...

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

   ****************************************************************************
   ATTENTION : FICHIER D'AIDE
   1. Par défaut le fichier d'aide est déconnecté dans l'évènement Create de StsConst
      Il est mis à vide pour éviter les erreurs tant que le fichier d'aide nest pas
      généré. Lorsque celui-ci existe, il suffit de supprimer ou de mettre en commentaire
      cette ligne.
   2. Le fichier d'aide par défaut de l'application est "nom du projet".HLP et doit se
      trouver dans le sous répertoire Help du répertoire de l'application
   ****************************************************************}

UNIT Main_Frm;

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
    Calend,
    LMDCustomHint,
    LMDCustomShapeHint,
    LMDShapeHint,
    Wwintl,
    vgStndrt,
    LMDCustomComponent,
    LMDContainerComponent,
    LMDBaseDialog,
    LMDAboutDlg,
    ActnList,
    RxCalc,
    dxBar,
    // Ici unités corresponadant à la scrollBox
    LMDCustomScrollBox,
    LMDScrollBox,
    // *****************************************
    fcStatusBar,
    ehsHelpRouter,
    ehsBase,
    ehsWhatsThis, RzStatus, Grids, Wwdbigrd, Wwdbgrid, wwDBGridRv, Db,
  dxmdaset, IBDataset, Progbr3d, ExtCtrls, RzPanel, RzPanelRv, Digits;

TYPE
    TFrm_Main = CLASS ( TAlgolStdFrm )
        Bm_Main: TdxBarManager;
        Dxb_Quit: TdxBarButton;
        Dxb_calc: TdxBarButton;
        Dxb_Calend: TdxBarButton;
        Dxb_Help: TdxBarButton;
        Dxb_About: TdxBarButton;
        Dxb_Apropos: TdxBarSubItem;
        Dxb_Tip: TdxBarButton;
        Calc_Main: TRxCalculator;
        ActLst_Main: TActionList;
        AboutDlg_Main: TLMDAboutDlg;
        TimeSto_Main: TDateTimeStorage;
        IPLang_Main: TwwIntl;
        Hint_Main: TLMDShapeHint;
        Calend_Main: TCalend;
        SBx_Main: TLMDScrollBox;
        WIS_Main: TWhatsThis;
        HRout_Main: THelpRouter;
        Dxb_IndexHelp: TdxBarButton;
    Stat_Bar: TfcStatusBar;
    Clk_Status: TRzClockStatus;
    MemD_: TdxMemData;
    MemD_Code: TStringField;
    MemD_Tail: TStringField;
    MemD_Catal: TStringField;
    MemD_Achat: TStringField;
    MemD_Vente: TStringField;
    MemD_Vente2: TStringField;
    MemD_Vente3: TStringField;
    MemD_Fourn: TStringField;
    DataSource1: TDataSource;
    MemD_Art: TdxMemData;
    MemD_ArtCode: TStringField;
    MemD_ArtChrono: TStringField;
    MemD_ArtDesi: TStringField;
    MemD_ArtDescript: TStringField;
    MemD_ArtGt: TStringField;
    MemD_ArtDtCrea: TStringField;
    MemD_ArtTxDep: TStringField;
    MemD_ArtDtDep: TStringField;
    MemD_ArtFourn: TStringField;
    MemD_ArtRefFourn: TStringField;
    MemD_ArtArchi: TStringField;
    MemD_ArtCritere: TStringField;
    MemD_ArtTVA: TStringField;
    MemD_ArtSecteur: TStringField;
    MemD_ArtGenre: TStringField;
    MemD_ArtFidel: TStringField;
    MemD_Artcc1: TStringField;
    MemD_Artcc2: TStringField;
    MemD_Artcc3: TStringField;
    MemD_Artcc4: TStringField;
    MemD_Artcc5: TStringField;
    MemD_Artcc6: TStringField;
    MemD_Artcc7: TStringField;
    MemD_Artcc8: TStringField;
    MemD_Artcc9: TStringField;
    MemD_Artcc10: TStringField;
    MemD_Artcc11: TStringField;
    MemD_Artcc12: TStringField;
    MemD_Artcc13: TStringField;
    MemD_Artcc14: TStringField;
    MemD_Artcc15: TStringField;
    MemD_Artcc16: TStringField;
    MemD_Artcc17: TStringField;
    MemD_Artcc18: TStringField;
    MemD_Artcc19: TStringField;
    MemD_Artcc20: TStringField;
    MemD_Artcl1: TStringField;
    MemD_Artcl2: TStringField;
    MemD_Artcl3: TStringField;
    MemD_Artcl4: TStringField;
    MemD_Artcl5: TStringField;
    MemD_Artcl6: TStringField;
    MemD_Artcl7: TStringField;
    MemD_Artcl8: TStringField;
    MemD_Artcl9: TStringField;
    MemD_Artcl10: TStringField;
    MemD_Artcl11: TStringField;
    MemD_Artcl12: TStringField;
    MemD_Artcl13: TStringField;
    MemD_Artcl14: TStringField;
    MemD_Artcl15: TStringField;
    MemD_Artcl16: TStringField;
    MemD_Artcl17: TStringField;
    MemD_Artcl18: TStringField;
    MemD_Artcl19: TStringField;
    MemD_Artcl20: TStringField;
    MemD_ArtPseudo: TStringField;
    Ds_: TDataSource;
    Dbg_: TwwDBGridRv;
    Dbg_Art: TwwDBGridRv;
    Que_Tarvente: TIBOQuery;
    Que_TarPrix: TIBOQuery;
    Que_TarventeTVT_ID: TIntegerField;
    Que_TarventeTVT_NOM: TStringField;
    Que_TarPrixPVT_ID: TIntegerField;
    Que_TarPrixPVT_TVTID: TIntegerField;
    Que_TarPrixPVT_ARTID: TIntegerField;
    Que_TarPrixPVT_TGFID: TIntegerField;
    Que_TarPrixPVT_PX: TIBOFloatField;
    Que_ArtRef: TIBOQuery;
    Digits1: TDigits;
    RzPanelRv1: TRzPanelRv;
    Pg: ProgressBar3D;
        PROCEDURE AlgolStdFrmCreate ( Sender: TObject ) ;
        PROCEDURE AlgolStdFrmShow ( Sender: TObject ) ;
        PROCEDURE Dxb_QuitClick ( Sender: TObject ) ;
        PROCEDURE Dxb_HelpClick ( Sender: TObject ) ;
        PROCEDURE Dxb_calcClick ( Sender: TObject ) ;
        PROCEDURE Dxb_CalendClick ( Sender: TObject ) ;
        PROCEDURE Dxb_AboutClick ( Sender: TObject ) ;
        PROCEDURE Dxb_TipClick ( Sender: TObject ) ;
        PROCEDURE WIS_MainHelp ( Sender, HelpItem: TObject; IsMenu: Boolean;
            HContext: THelpContext; X, Y: Integer; VAR CallHelp: Boolean ) ;
        PROCEDURE Dxb_IndexHelpClick ( Sender: TObject ) ;
        PROCEDURE Bm_MainClickItem ( Sender: TdxBarManager;
            ClickedItem: TdxBarItem ) ;
        PROCEDURE AlgolStdFrmCloseQuery ( Sender: TObject;
            VAR CanClose: Boolean ) ;
    procedure AlgolStdFrmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Que_TarventeAfterPost(DataSet: TDataSet);
    procedure Que_TarventeNewRecord(DataSet: TDataSet);
    procedure Que_TarventeUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure Que_TarPrixNewRecord(DataSet: TDataSet);
    procedure Que_TarPrixUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    Private
    { Private declarations }
           ouvert : Boolean;
           kit : Boolean;
           H1, H2, Cpt : Integer;
           PROCEDURE MajTarif;
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published
    { Published declarations }
    END;

VAR
    Frm_Main: TFrm_Main;

IMPLEMENTATION

USES ConstStd, Main_Dm, stdUtils;

{$R *.DFM}

TYPE
    TmyCustomdxBarControl = CLASS ( TCustomdxBarControl ) ;


//******************* TFrm_Main.AlgolMainFrmCreate *************************

PROCEDURE TFrm_Main.AlgolStdFrmCreate ( Sender: TObject ) ;
BEGIN
    ouvert := False;
END;

//******************* TFrm_Main.AlgolStdFrmCloseQuery *************************
// Contrôle de sortie de la Forme ...

PROCEDURE TFrm_Main.AlgolStdFrmCloseQuery ( Sender: TObject;
    VAR CanClose: Boolean ) ;
BEGIN
    CanClose := Not Ouvert;
    IF NOT Canclose THEN
       Abort
    Else begin
         Memd_.Close;
         memd_art.Close;
    End;
END;

//******************* TFrm_Main.AlgolMainFrmShow *************************

PROCEDURE TFrm_Main.AlgolStdFrmShow ( Sender: TObject ) ;
BEGIN
{  Maximized mis ici pour prendre en compte corrextement les "anchors"
   CanMaximize à False pour shunter la dimension DesignTime et que la form soit
   toujours minimized ou maximized
   Nota : dsSie=zeable pour la Form car sinon recouvre la TaskBar
   Dans ce contexte c'est Bill qui prend tout en charge }

    IF NOT Init THEN
    BEGIN
        windowState := wsMaximized;
        canMaximize := False;
        IF StdConst.Tip_Main.ShowAtStartup THEN ExecTip;
    END;
END;

//--------------------------------------------------------------------------------
// Boutons du Menu
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Bm_MainClickItem *************************
// Contrôle de la disponibilité des boutons des menus ...

PROCEDURE TFrm_Main.Bm_MainClickItem ( Sender: TdxBarManager;
    ClickedItem: TdxBarItem ) ;
VAR
    Cancel: Boolean;
BEGIN
    // StdTag de la forme sert
    // de témoin pour autoriser l'accès aux boutons de menus
    // si stdTag >= 0 le boutons de menus dont le Tag est >= 0 sont inhibés

    Cancel := False;
    IF ( ClickedItem IS TdxBarButton ) THEN
        IF clickedItem.Tag >= 0 THEN
            Cancel := StdTag >= 0;

    IF cancel THEN
    BEGIN
        INFMESS ( ErrItemMenu, '' ) ;
        Abort;
    END;

END;

//******************* TFrm_Main.Dxb_QuitClick *************************
// Bouton Quitter

PROCEDURE TFrm_Main.Dxb_QuitClick ( Sender: TObject ) ;
BEGIN
    Close;
END;

//--------------------------------------------------------------------------------
//Gestion de l'aide
//--------------------------------------------------------------------------------

//******************* TFrm_Main.WhatsThis1Help *************************
// Activation de l'aide pour ExpressBar

PROCEDURE TFrm_Main.WIS_MainHelp ( Sender, HelpItem: TObject;
    IsMenu: Boolean; HContext: THelpContext; X, Y: Integer;
    VAR CallHelp: Boolean ) ;
VAR
    ABarItem: TdxBarItemControl;
    P: TPoint;
BEGIN

    IF application.Helpfile = '' THEN
        CallHelp := False
    ELSE
    BEGIN
        IF HelpItem IS TCustomdxBarControl THEN
        BEGIN
            WITH TmyCustomdxBarControl ( HelpItem ) DO
            BEGIN
                P.x := x;
                p.y := y;
                ABarItem := ItemAtPos ( ScreenToClient ( P ) ) ;
                IF NOT ( ( ABarItem = NIL ) OR ( ABarItem IS TdxBarSubItemControl ) ) THEN
                    HContext := ABarItem.Item.HelpContext;
                Application.HelpCommand ( HELP_CONTEXTPOPUP, HContext ) ;
                CallHelp := False;
            END;
        END;
    END;


END;

//******************* TFrm_Main.Dxb_HelpClick *************************

PROCEDURE TFrm_Main.Dxb_HelpClick ( Sender: TObject ) ;
BEGIN
    Wis_main.ContextHelp;
END;

//******************* TFrm_Main.Dxb_IndexHelpClick *************************
// Chaine sur l'indes de l'aide (didacticiel)

PROCEDURE TFrm_Main.Dxb_IndexHelpClick ( Sender: TObject ) ;
BEGIN
    IF application.Helpfile = '' THEN Exit;
    HRout_main.HelpContent;
END;

//--------------------------------------------------------------------------------
//Outils accessoires
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Dxb_calcClick *************************
// Calculatrice

PROCEDURE TFrm_Main.Dxb_calcClick ( Sender: TObject ) ;
var codart, lecode : string;
    pxf, px : Extended;
    err : boolean;
BEGIN
   If Ouvert Then exit;

   If Not Memd_.Active Then Exit;
   If Not Memd_Art.Active Then Exit;
   If Memd_.IsEmpty Then Exit;

   try
     ouvert := True;
     H1 := 0;
     H2 := 0;
     err := False;
     pg.Progress := 0;
     pg.Refresh;

     try
         Que_Tarvente.Open;
         If Que_Tarvente.Locate ('TVT_NOM', 'Husky 2', [] ) Then
            H1 := que_Tarvente.fieldByName ('TVT_ID').asInteger
         Else
         Begin
              que_Tarvente.Insert;
              que_Tarvente.fieldByName('TVT_NOM').asString := 'Husky 2';
              H1 := que_Tarvente.fieldByName ('TVT_ID').asInteger;
              que_Tarvente.Post;
         End;
         If Que_Tarvente.Locate ('TVT_NOM', 'Husky 3', [] ) Then
            H2 := que_Tarvente.fieldByName ('TVT_ID').asInteger
         Else
         Begin
              que_Tarvente.Insert;
              que_Tarvente.fieldByName('TVT_NOM').asString := 'Husky 3';
              H2 := que_Tarvente.fieldByName ('TVT_ID').asInteger;
              que_Tarvente.Post;
         End;
         que_Tarvente.Close;
     Except
         err := true;
     end;

     if err Then exit;

     que_TarPrix.Open;
     que_ArtRef.Open;


     Memd_.First;
     codart := '';
     cpt := 0;

     While not Memd_.Eof do
     Begin
          lecode := memd_.fieldByName ('CODE').asstring;
          if lecode <> codart Then
          Begin
              pg.Progress := Pg.progress+1;
              codart := Lecode;
              if Memd_Art.Locate ('Code', LeCode , [] ) Then
              Begin
                   if que_ArtRef.Locate ('ARF_CHRONO', Memd_Art.fieldByName ('Chrono').asstring, [] ) Then
                   begin
                       if Trim (Memd_.fieldByname ('Vente2').asstring) <> '' Then
                       begin
                           PxF := Memd_.fieldByname ('Vente2').asFloat;
                           if Pxf <> 0 Then
                           Begin
                               try
                                   Px := roundRv (( PxF / 6.55957 ), 7 ) ;
                                   Que_TarPrix.Insert;
                                   que_TarPrix.fieldByName ('PVT_TVTID').asInteger := H1;
                                   que_TarPrix.FieldByName ('PVT_ARTID').asInteger := que_ArtRef.fieldByName ('ARF_ARTID').asInteger;
                                   que_TarPrix.FieldByName ('PVT_TGFID').asInteger := 0;
                                   que_TarPrix.FieldByName ('PVT_PX').asFloat := Px;
                                   que_TarPrix.Post;
                               except
                                   err := true;
                               end;
                               inc (cpt);
                           End;
                       End;
                       if Trim (Memd_.fieldByname ('Vente3').asstring) <> '' Then
                       begin
                           PxF := Memd_.fieldByname ('Vente3').asFloat;
                           if Pxf <> 0 Then
                           Begin
                               try
                                   Px := roundRv ( (PxF / 6.55957), 7 );

                                   Que_TarPrix.Insert;
                                   que_TarPrix.fieldByName ('PVT_TVTID').asInteger := H2;
                                   que_TarPrix.FieldByName ('PVT_ARTID').asInteger := que_ArtRef.fieldByName ('ARF_ARTID').asInteger;
                                   que_TarPrix.FieldByName ('PVT_TGFID').asInteger := 0;
                                   que_TarPrix.FieldByName ('PVT_PX').asFloat := Px;
                                   que_TarPrix.Post;
                                   inc (cpt);
                               except
                                   err := true;
                               end;

                           End;
                       End;
                   End;
              End;
          End;

          if err Then
          begin
              err := False;
              if MessageDlg('Erreur en création de tarif ...Quitter le traitement ?...', mtConfirmation, [mbYES,mbNO], 0) = mrYes
              Then Break;
          end;
          application.ProcessMessages;
          if kit Then begin
              kit := false;
              if MessageDlg('Quitter le traitement ?...', mtConfirmation, [mbYES,mbNO], 0) = mrYes
              Then Break;
          End;
          if cpt >= 500 Then
          begin
             cpt := 0;
             MajTarif;
          End;
          dbg_.Refresh;
          dbg_art.Refresh;
          pg.Refresh;

          Memd_.Next;
     End;

  finally
     if que_TarPrix.UpdatesPending Then MajTarif;
     ouvert := false;
     pg.Progress := 0;
     que_TarVente.close;
     que_TarPrix.close;
     que_ArtRef.close;

  end;

END;

PROCEDURE TFrm_Main.MajTarif;
Begin
        WITH Dm_Main DO
        BEGIN
            TRY
                StartTransaction;
                IBOUpDateCache ( que_TarPrix ) ;
                Commit;
            EXcept
                MessageDlg('Problème de mise à jour du cache', mtInformation, [mbOK], 0);
                Kit := True;
                IBOCancelCache ( que_TarPrix ) ;
            End;
            IBOCommitCache ( que_TarPrix ) ;
        End;
        que_TarPrix.Close;
        que_Tarprix.Open;
End;

//******************* TFrm_Main.Dxb_TipClick *************************
// Bouton Tip du menu

PROCEDURE TFrm_Main.Dxb_TipClick ( Sender: TObject ) ;
BEGIN
    ExecTip;
END;

//******************* TFrm_Main.Dxb_AboutClick *************************
// Boite About

PROCEDURE TFrm_Main.Dxb_AboutClick ( Sender: TObject ) ;
BEGIN
    AboutDlg_Main.Execute;
END;

//******************* TFrm_Main.Dxb_CalendClick *************************
// Calendrier

PROCEDURE TFrm_Main.Dxb_CalendClick ( Sender: TObject ) ;
BEGIN
   if ouvert Then Exit;
   try
     screen.cursor := crSQLWait;
     Memd_Art.close;
     Memd_Art.DelimiterChar := ';';
     Memd_Art.Open;
     Memd_Art.LoadFromTextFile ('c:\ip_husky\Article.txt');


     Memd_.close;
     Memd_.DelimiterChar := ';';
     Memd_.Open;
     Memd_.LoadFromTextFile ('c:\ip_husky\Tarifs.txt');
   finally
     screen.cursor := crDefault;
   end;
END;

procedure TFrm_Main.AlgolStdFrmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if ( key = VK_ESCAPE ) Then Kit := True;
end;

procedure TFrm_Main.Que_TarventeAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TFrm_Main.Que_TarventeNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TFrm_Main.Que_TarventeUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

procedure TFrm_Main.Que_TarPrixNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TFrm_Main.Que_TarPrixUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;

END.

