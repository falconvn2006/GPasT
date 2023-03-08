UNIT Main_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  ExtCtrls,
  RzPanel,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  StdCtrls,
  LMDCustomButton,
  LMDButton,
  dxTL,
  dxDBCtrl,
  dxDBGrid,
  dxCntner,
  dxDBGridHP,
  RzLabel,
  DB,
  dxDBTLCl,
  dxGrClms,
  AppEvnts,
  Grids,
  DBGrids,
  MidasLib, Buttons;

CONST
  WM_DEMARRE = WM_USER + 100;

TYPE
  TFrm_Main = CLASS(TForm)
    Pan_Top: TRzPanel;
    Nbt_Param: TLMDSpeedButton;
    Nbt_Quit: TLMDSpeedButton;
    Pan_Centre: TRzPanel;
    Pan_Bottom: TRzPanel;
    Pan_Base: TRzPanel;
    RzLabel1: TRzLabel;
    DBG_SiteVtePriv: TdxDBGridHP;
    Nbt_Ajout: TLMDButton;
    Nbt_Modif: TLMDButton;
    Nbt_Supprim: TLMDButton;
    Ds_Base: TDataSource;
    DBG_SiteVtePrivInd: TdxDBGridMaskColumn;
    DBG_SiteVtePrivNom: TdxDBGridMaskColumn;
    DBG_SiteVtePrivBase: TdxDBGridMaskColumn;
    Pan_droite: TRzPanel;
    RzLabel2: TRzLabel;
    Lab_CheminBase: TRzLabel;
    Nbt_RechArt: TLMDButton;
    Nbt_RecalStk: TLMDButton;
    Pan_Rapp: TRzPanel;
    Lab_Trait: TRzLabel;
    Pan_BasRapp: TRzPanel;
    Nbt_voirArt: TLMDButton;
    Ds_Rapp: TDataSource;
    Nbt_SuppRapp: TLMDButton;
    Tim_Rapport: TTimer;
    DBG_Rapp: TdxDBGridHP;
    DBG_RappInd: TdxDBGridMaskColumn;
    DBG_RappStrType: TdxDBGridColumn;
    DBG_RappType: TdxDBGridMaskColumn;
    DBG_RappComment: TdxDBGridMaskColumn;
    DBG_RappFichier: TdxDBGridMaskColumn;
    DBG_RappRDate: TdxDBGridMaskColumn;
    DBG_RappRHeure: TdxDBGridMaskColumn;
    AppEvnt: TApplicationEvents;
    Nbt_Analyse: TLMDButton;
    Nbt_TraitAuto: TLMDSpeedButton;
    BitBtn1: TBitBtn;
    Lab_Version: TLabel;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE FormActivate(Sender: TObject);
    PROCEDURE Nbt_QuitClick(Sender: TObject);
    PROCEDURE Nbt_AjoutClick(Sender: TObject);
    PROCEDURE Nbt_ModifClick(Sender: TObject);
    PROCEDURE Nbt_SupprimClick(Sender: TObject);
    PROCEDURE Ds_BaseDataChange(Sender: TObject; Field: TField);
    PROCEDURE Nbt_ParamClick(Sender: TObject);
    PROCEDURE Nbt_RechArtClick(Sender: TObject);
    PROCEDURE Nbt_RecalStkClick(Sender: TObject);
    PROCEDURE Ds_RappDataChange(Sender: TObject; Field: TField);
    PROCEDURE Tim_RapportTimer(Sender: TObject);
    PROCEDURE Nbt_SuppRappClick(Sender: TObject);
    PROCEDURE Nbt_voirArtClick(Sender: TObject);
    PROCEDURE AppEvntActivate(Sender: TObject);
    PROCEDURE AppEvntMinimize(Sender: TObject);
    PROCEDURE AppEvntRestore(Sender: TObject);
    procedure Nbt_AnalyseClick(Sender: TObject);
    procedure Nbt_TraitAutoClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
    bOkAppliMinimise: boolean;
    bEncoursRapport: boolean;
    bAuto: boolean;
    EtatFiche: boolean;
    OkFermer: boolean; // sert à ne pas fermer l'application pendant la recherche ou le recalcul
    PROCEDURE WmDemarre(VAR m: TMessage); MESSAGE WM_DEMARRE;
    PROCEDURE DoRapport;
    FUNCTION DoRecherche(ANom: STRING): boolean;
    PROCEDURE DoRecalculStock(ANom: STRING);
    function DoAnalyse(ANom: STRING; var NErreur: integer; var sErreur: string): string;
    PROCEDURE CtrlButton;
    PROCEDURE CtrlButtonRapp;
    PROCEDURE DoBaseDataChange;
  PUBLIC
    { Déclarations publiques }
    PROCEDURE Traiter;
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

USES Main_Dm,
  Acces_Frm,
  AjoutModifBase_Frm,
  Parametre_Frm,
  Confirmation_Frm,
  Progression_Frm,
  ListArtTrouve_Frm, Analyse_Frm, ConfirmAnalyse_Frm, TraiteAuto_Frm, clipbrd;

{$R *.dfm} 

function ApplicationVersion: String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  Version: string;
  d: TDateTime;
  AgeExe: string;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Version := IntTostr(dwFileVersionMS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Version := Version + '.' + IntTostr(dwFileVersionLS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end
  else
    Version:='0.0.0.0 ';

  d:=  FileDateToDateTime(FileAge(ParamStr(0)));
  AgeExe := ' du '+FormatDateTime('dd/mm/yyyy',d);
  result := Version+AgeExe;
end;

PROCEDURE TFrm_Main.WmDemarre(VAR m: TMessage);
BEGIN
  Traiter;
END;

PROCEDURE TFrm_Main.Traiter;
VAR
  i: integer;
  sPar: STRING;
  sNomBase: STRING;
  bAnalyse: integer;
  bRech: integer;
  bCalc: integer;
  sError: STRING;
  iErreur: integer;
  sErreur: string;
BEGIN
  Application.Minimize;
  TRY
    bAuto := true;
    sNomBase := '';
    bAnalyse := -1;
    bRech := -1;
    bCalc := -1;
    FOR i := 1 TO ParamCount DO
    BEGIN
      sPar := UpperCase(ParamStr(i));
      IF Pos('/BASE=', sPar) > 0 THEN
        sNomBase := Copy(sPar, Pos('=', sPar) + 1, Length(sPar));
      IF Pos('/ANALYSE=', sPar) > 0 THEN
        bAnalyse := StrToIntDef(Copy(sPar, Pos('=', sPar) + 1, Length(sPar)), -1);
      IF Pos('/RECH=', sPar) > 0 THEN
        bRech := StrToIntDef(Copy(sPar, Pos('=', sPar) + 1, Length(sPar)), -1);
      IF Pos('/RECALC=', sPar) > 0 THEN
        bCalc := StrToIntDef(Copy(sPar, Pos('=', sPar) + 1, Length(sPar)), -1);
    END;
    IF (bRech > 1) THEN
      bRech := -1;
    IF (bRech > 1) THEN
      bCalc := -1;

    // Recherche des paramètres
    sError := '';
    IF (sNomBase = '') AND (sError = '') THEN
      sError := 'Le paramètre « /BASE= » est non renseigné ou invalide !';
    IF (bAnalyse <= -1) AND (sError = '') THEN
      sError := 'Le paramètre « /ANALYSE= » est non renseigné ou invalide !';
    IF (bRech <= -1) AND (sError = '') THEN
      sError := 'Le paramètre « /RECH= » est non renseigné ou invalide !';
    IF (bCalc <= -1) AND (sError = '') THEN
      sError := 'Le paramètre « /RECALC= » est non renseigné ou invalide !';
    IF sError <> '' THEN
    BEGIN
      sError := sError + #13#10 + #13#10 + 'Les paramètres pour fonctionner en mode' + #13#10 +
        'automatique doivent être comme ci-dessous:' + #13#10 + #13#10 +
        '/BASE=<Nom de la base> /ANALYSE=<0 ou 1> /RECH=<0 ou 1> /RECALC=<0 ou 1>' + #13#10;
      Application.Restore;
      Application.BringToFront;
      MessageDlg(sError, mterror, [mbok], 0);
      exit;
    END;

    // Recherche de la base
    IF NOT (Dm_Main.Cds_Base.Locate('Nom', sNomBase, [])) THEN
    BEGIN
      Application.Restore;
      Application.BringToFront;
      MessageDlg('La base avec le nom « ' + sNomBase + ' » n''a pas été trouvé !', mterror, [mbok], 0);
      exit;
    END;

    // connexion à la base
    IF NOT (Dm_Main.TestConnexion(Dm_Main.Cds_Base.FieldByName('Base').AsString, true)) THEN
    BEGIN
      Application.Restore;
      Application.BringToFront;
      MessageDlg('Connexion avec la base dont le nom est « ' + sNomBase + ' » impossible !', mterror, [mbok], 0);
      exit;
    END; 

    // Analyse article
    IF bAnalyse = 1 THEN
      DoAnalyse(sNomBase, iErreur, sErreur);

    // recherche article
    IF bRech = 1 THEN
    BEGIN
      IF NOT (DoRecherche(sNomBase)) THEN
        bCalc := 0; // pas de recalcul stock si GENTRIGGER pas vide
    END;

    // recalcul stock
    IF bCalc = 1 THEN
      DoRecalculStock(sNomBase);

    // information que la connexion est ok si bRech et bCalc sont à 0
    IF (bRech = 0) AND (bCalc = 0) and (bAnalyse=0) THEN
    BEGIN
      Application.Restore;
      Application.BringToFront;
      MessageDlg('Connexion avec la base dont le nom est « ' + sNomBase + ' » réussie !', mtInformation, [mbok], 0);
      exit;
    END;

  FINALLY
    Dm_Main.Ginkoia.Connected := false;
    Close;
  END;
END;

PROCEDURE TFrm_Main.DoRapport;
VAR
  sNom: STRING;
  sFic: STRING;
  sReper: STRING;
  TpListe: TStringList;
  resu, Ind: integer;
  Searchrec: TSearchrec;
  d: TDateTime;
  Tipe: integer;
  sComment: STRING;
BEGIN
  IF bEncoursRapport THEN BEGIN
    Tim_Rapport.Enabled := true;
    exit;
  END;
  IF bAuto THEN // pas d'affichage en mode auto
    exit;
  bEncoursRapport := true;
  Dm_Main.Cds_Rapp.DisableControls;
  Dm_Main.Cds_Rapp.IndexName := '';
  TpListe := TStringList.Create;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TRY
    WITH Dm_Main DO
    BEGIN
      Cds_Rapp.EmptyDataSet;
      //  Cds_Rapp.IndexFieldNames := '';

      IF NOT (Cds_Base.Active) OR (Cds_Base.RecordCount = 0) THEN
        exit;
      sNom := Cds_Base.fieldbyname('Nom').AsString;

      sReper := ReperRapport + sNom + '\';
      Ind := 1;
      // Rapp_Rech_ pour la recherche article, Rapp_Calc_ pour le recalcule stock, Rapp_Art_ pour la liste des articles
      resu := FindFirst(sReper + 'Rapp_*.txt', faAnyFile, SearchRec);
      WHILE Resu = 0 DO
      BEGIN
        sFic := ExtractFileName(SearchRec.Name);
        IF (sFic <> '.') AND (sFic <> '..')
          AND ((SearchRec.Attr AND faDirectory) <> faDirectory)
          AND (Pos('_Art_', sFic) = 0) THEN
        BEGIN
          d := FileDateToDateTime(SearchRec.Time);
          Tipe := 0;
          IF Pos('_Rech_', sFic) > 0 THEN
            Tipe := 1;
          IF Pos('_Calc_', sFic) > 0 THEN
            Tipe := 2;
          sComment := '';
          TRY
            TPListe.Clear;
            TPListe.LoadFromFile(sReper + sFic);
            IF TPListe.Count > 0 THEN
              sComment := TpListe[0];
          EXCEPT
          END;
          Cds_Rapp.Append;
          Cds_Rapp.FieldByName('Ind').AsInteger := Ind;
          Cds_Rapp.FieldByName('RDate').AsDateTime := Trunc(d);
          Cds_Rapp.FieldByName('RHeure').AsDateTime := Frac(d);
          Cds_Rapp.FieldByName('Fichier').AsString := sReper + sFic;
          Cds_Rapp.FieldByName('Type').AsInteger := Tipe;
          Cds_Rapp.FieldByName('Comment').AsString := sComment;
          Cds_Rapp.Post;
          Inc(Ind);
        END;
        Resu := FindNext(SearchRec);
      END;
      FindClose(SearchRec);
    END;
  FINALLY
    TPListe.Free;
    Dm_Main.Cds_Rapp.IndexName := 'OrderDATEDesc';
    Dm_Main.Cds_Rapp.First;
    Dm_Main.Cds_Rapp.EnableControls;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
    bEncoursRapport := false;
  END;
END;
                                                     
function TFrm_Main.DoAnalyse(ANom: STRING; var NErreur: integer; var sErreur: string): string;
Type
  TItemNbArtParMag = record
    Magasin: string;
    NbArt: integer;
  end;
  PItemNbArtParMag=^TItemNbArtParMag;
var
  Nbre: integer;  // nombre d'enregistrement
  NbreInteg: integer;
  ArtID    : integer;
  MagID    : integer;
  QteCour  : integer;
  QteHisto : integer;
  QteMvt   : Integer;

  sTmp    : string;
  sMag    : string;
  sChrono : string;
  sArtNom : string;
  sLibArt : string;

  LRet          : integer;
  itNrArtParMag : PItemNbArtParMag;
  i             : integer;
  lstArt        : TStringList;
  lstArtParMag  : TList;
  sReper        : string;
  sFic          : string;
begin
  result  := '';
  NErreur := 0;  // 0: tout ok ; 1: Pas d'article ; 2: erreur
  sErreur := '';
  with Dm_Main do
  begin

    MemD_DetailArt.Close;
    MemD_DetailArt.Open;

    TRY
      OkFermer := false;
      VeuillezPatienter('Analyse de tous les articles dont le ' + #13#10 +
        'stock courant est différent de l''histo stock '+ #13#10 +
        'ou différent du stock dans AGRMOUVEMENT', 0);
        
      IF NOT (bOkAppliMinimise) THEN
        AffichePatienter;
      LstArt       := TStringList.Create;
      lstArtParMag := TList.Create;
      Application.ProcessMessages;
      TRY
        WITH Que_Div1, SQL DO
        BEGIN
          Close;
          Clear;
          Add('select STC_ARTID, STC_MAGID, ARF_CHRONO, ART_NOM, MAG_ENSEIGNE, sum(STC_QTE) qte ');
          Add('   from AGRSTOCKCOUR ');
          Add('   join artreference on arf_artid=stc_artid and arf_virtuel=0 ');
          Add('   join ARTARTICLE ');
          Add('        join k on (k_id=art_id and k_enabled=1) ');
          Add('        on (art_id=arf_artid) ');
          Add('   JOIN GENMAGASIN ON (MAG_ID=STC_MAGID) ');
          Add('where STC_COUID<>0');
          Add('group by stc_magid,stc_artid, ARF_CHRONO, ART_NOM, MAG_ENSEIGNE ');
          Open;
          Nbre := recordcount;
          if Nbre=0 then
          begin
            Close;
            NErreur := 1;
            sErreur := 'Aucun article à contrôler';
            exit;
          end;
          
          NbreInteg := 0;
          SetMaxProgress(Nbre);
          First;
          while not(Eof) do
          begin
            Application.ProcessMessages;
            // Affectation paramètre
            ArtID   := fieldbyname('STC_ARTID').AsInteger;
            MagID   := fieldbyname('STC_MAGID').AsInteger;
            QteCour := fieldbyname('QTE').AsInteger;

            // recherche diff. Stk courant, Stk Histo  et Stk Mvt
            //Vérification dans AGRMOUVEMENT
            with Que_Div4, SQL do
            begin
              Close;
              Clear;
              Add('SELECT SUM(MVT_QTE * MVT_SENS * MVT_AVECSTOCK) AS QTE_MVT ');
              Add('FROM AGRMOUVEMENT ');
              Add('WHERE MVT_ARTID = '+inttostr(ArtID)+' AND MVT_MAGID = '+inttostr(MagID)+'');
              Open;
              QteMvt := FieldByName('QTE_MVT').AsInteger;
              Close;
            end;

            // vérifier les mvt de stock
            WITH Que_Div2, SQL DO
            BEGIN
              Close;
              Clear;
              Add('SELECT *');
              Add(' FROM RV_EXECARTHISTOMVT (' + inttostr(ArtID) +
                ', ''%|' + inttostr(MagID) + '|%'')');
              Open;
              Last;
              QteHisto := fieldbyname('RSTOCKFIN').AsInteger;
            end;

            if ((QteCour<>QteHisto) or (QteCour <> QteMvt) or (QteHisto <> QteMvt)) then
            begin

              sMag    := fieldbyname('MAG_ENSEIGNE').AsString;
              sChrono := fieldbyname('ARF_CHRONO').AsString;
              sArtNom := fieldbyname('ART_NOM').AsString;


              if LstArt.IndexOf(inttostr(ArtID))<0 then
                LstArt.Add(inttostr(ArtID));

              lret := -1;
              i:=1;
              while (lret=-1) and (i<=lstArtParMag.Count) do
              begin
                if PItemNbArtParMag(lstArtParMag[i-1])^.Magasin = sMag then
                  lret:=i-1;

                inc(i);
              end;
              if lret=-1 then
              begin
                new(itNrArtParMag);
                itNrArtParMag^.Magasin := sMag;
                itNrArtParMag^.NbArt := 1;
                lstArtParMag.Add(itNrArtParMag);
              end
              else
                Inc(PItemNbArtParMag(lstArtParMag[lret])^.NbArt);

              sLibArt := sChrono;
              while Length(sLibArt)<9 do
                sLibArt := sLibArt+' ';

              sTmp := sArtNom;
              while Length(sTmp)<25 do
                sTmp := sTmp+' ';
              sTmp := Copy(sTmp,1,25);
              sLibArt := sLibArt+' '+sTmp;

              if (QteCour <> QteHisto) then
              begin
                 sLibArt := sLibArt+'  '+'Stk Cour.: '+inttostr(QteCour)+'  Stk Histo: '+inttostr(QteHisto)+
                                 '  Stk Mvt: '+inttostr(QteMvt)+ ' || Ecart StkC-StkH: '+ inttostr(QteCour - QteHisto);

                 if (QteHisto <> QteMvt) then
                    sLibArt := sLibArt + ' / Ecart StkH-StkM: ' + inttostr(QteHisto - QteMvt);
              end;

//              if (QteCour <> QteMvt) then
//                 sLibArt := sLibArt+'  '+'Stk Cour.: '+inttostr(QteCour)+'  Stk Histo: '+inttostr(QteHisto)+
//                                 '  Stk Mvt: '+inttostr(QteMvt)+ '  Ecart: ' + inttostr(QteCour-QteMvt);
//              if (QteHisto <> QteMvt) then
//              begin
//                 sLibArt := sLibArt+'  '+'Stk Cour.: '+inttostr(QteCour)+'  Stk Histo: '+inttostr(QteHisto)+
//                                 '  Stk Mvt: '+inttostr(QteMvt)+ '  Ecart StkH - StkM : ' + inttostr(QteHisto-QteMvt);
//              end;

              WITH Que_Div2 do
              begin
                First;
                while not(Eof) do
                begin
                  if fieldbyname('TIPLINE').AsInteger=0 then
                  begin
                    MemD_DetailArt.Append;

                    MemD_DetailArt.fieldbyname('MAGID').AsInteger      := MagID;
                    MemD_DetailArt.fieldbyname('ARTID').AsInteger      := ArtID;
                    MemD_DetailArt.fieldbyname('MAGENSEIGNE').AsString := sMag;
                    MemD_DetailArt.fieldbyname('ARF_CHRONO').AsString  := sChrono;
                    MemD_DetailArt.fieldbyname('ARTNOM').AsString      := sArtNom;
                    MemD_DetailArt.fieldbyname('LibArt').AsString      := sLibArt;

                    MemD_DetailArt.FieldByName('RDIM').AsInteger       := FieldByName('RDIM').AsInteger;
                    MemD_DetailArt.FieldByName('RDATE').Value          := FieldByName('RDATE').Value;
                    MemD_DetailArt.FieldByName('RQTE').Value           := FieldByName('RQTE').Value;
                    MemD_DetailArt.FieldByName('RSTOCKFIN').Value      := FieldByName('RSTOCKFIN').Value;
                    MemD_DetailArt.FieldByName('RTYPE').AsInteger      := FieldByName('RTYPE').AsInteger;
                    MemD_DetailArt.FieldByName('RNUMERO').Value        := FieldByName('RNUMERO').Value;
                    MemD_DetailArt.FieldByName('RCATEG').Value         := FieldByName('RCATEG').Value;

                    MemD_DetailArt.Post;
                  end;
                  Next;
                end;
              end;

            end;
            Que_Div2.Close;

            //fait avancer la progress bar
            AvanceProgress;

            Next;
          end;

          if MemD_DetailArt.RecordCount=0 then
          begin
            NErreur := 1;
            sErreur := 'Aucun article avec le stock courant différent de histo stock ou différent du stock dans AGRMOUVEMENT';
            MemD_DetailArt.Append;
            MemD_DetailArt.fieldbyname('MAGID').AsInteger      := -1;
            MemD_DetailArt.fieldbyname('ARTID').AsInteger      := -1;
            MemD_DetailArt.fieldbyname('MAGENSEIGNE').AsString := ' RAPPORT Analyse';
            MemD_DetailArt.fieldbyname('LibArt').AsString      := 'Aucun article Stk Cour. <> Stk Histo <> Stk Mvt';
            MemD_DetailArt.Post;
          end
          else
          begin

            for i:=lstArtParMag.Count downto 1 do
            begin
              itNrArtParMag:=PItemNbArtParMag(lstArtParMag[i-1]);
              MemD_DetailArt.First; 
              MemD_DetailArt.Insert;
              MemD_DetailArt.fieldbyname('MAGID').AsInteger      := -1;
              MemD_DetailArt.fieldbyname('ARTID').AsInteger      := -1;
              MemD_DetailArt.fieldbyname('MAGENSEIGNE').AsString := ' RAPPORT Analyse';
              MemD_DetailArt.fieldbyname('LibArt').AsString      := 'Nombre d''articles pour le Magasin '+
                                                                    itNrArtParMag^.Magasin+': '+
                                                                    inttostr(itNrArtParMag^.NbArt);
              MemD_DetailArt.Post;
            end;

            MemD_DetailArt.First;
            MemD_DetailArt.Insert;
            MemD_DetailArt.fieldbyname('MAGID').AsInteger      := -1;
            MemD_DetailArt.fieldbyname('ARTID').AsInteger      := -1;
            MemD_DetailArt.fieldbyname('MAGENSEIGNE').AsString := ' RAPPORT Analyse';
            MemD_DetailArt.fieldbyname('LibArt').AsString      := 'Nombre distinct d''articles concernés: '+inttostr(lstArt.Count);
            MemD_DetailArt.Post;

          end;   
          MemD_DetailArt.First;

          if MemD_DetailArt.RecordCount>0 then
          begin
            sReper := ReperRapport + ANom + '\';
            IF NOT (DirectoryExists(sReper)) THEN
              ForceDirectories(sReper);
            sFic := 'Analyse_Art_' + FormatDateTime('yyyy-mm-dd hhnnss zzz', Now) + '.csv';
            MemD_DetailArt.SaveToTextFile(sReper+sFic);
            Result := sFic;
          end;
        end;

      FINALLY
        for i:=lstArtParMag.Count downto 1 do
        begin
          itNrArtParMag:=PItemNbArtParMag(lstArtParMag[i-1]);
          Dispose(itNrArtParMag);
          lstArtParMag.Delete(i-1);
        end;
        lstArtParMag.Clear;
        lstArtParMag.Free;
        LstArt.Free;
        Dm_Main.Que_Div1.Close;
        Dm_Main.Que_Div2.Close;
        FermerPatienter;
        OkFermer := true;
      END;
    except
      on E:Exception do
      begin
        NErreur := 2;
        sErreur := 'Base: ' + ANom + #13#10#13#10 + E.Message;
      end;
    end;
  end;
end;

FUNCTION TFrm_Main.DoRecherche(ANom: STRING): boolean;
VAR
  Nbre: integer;
  NbreInteg: integer;
  sError: STRING;
  TpListeRech, TpListeArt: TStringList;
  sEntete: STRING;
  sReper: STRING;
  sFicRech: STRING;
  sFicArt: STRING;
  bOk: boolean;
  SavArtID, ArtID, TgfID, CouID, MagID: integer; // tout est dans le nom
  RecalculID: integer; // ID pour la table recalcul
  QteCour, QteHisto, QteMvt : integer; // stk courant ; Stk histo
  ArtNom: STRING;
  ArtChrono: STRING;
  ArtMark: STRING;
  TempD: TDatetime;
  i: integer;
  EtatTrigger: integer;
  bPbHistoStk: boolean;
  vPbHistoStk: integer;
BEGIN
  result := false;
  WITH Dm_Main DO
  BEGIN
    TpListeRech := TStringList.Create;
    TpListeArt := TStringList.Create;
    sReper := ReperRapport + ANom + '\';
    IF NOT (DirectoryExists(sReper)) THEN
      ForceDirectories(sReper);

    // Sauvegarde etat de l'activation du trigger (lecture du Gen_ID)
    TRY
      WITH Que_Div1, SQL DO
      BEGIN
        Close;
        Clear;
        Add('SELECT GEN_ID(GENTRIGGER,0) as ETAT FROM RDB$DATABASE');
        Open;
        EtatTrigger := fieldbyname('ETAT').AsInteger;
        Close;
      END;
    EXCEPT
    END;

    IbT_Trans.StartTransaction;
    TRY
      OkFermer := false;
      VeuillezPatienter('Recherche de tous les articles dont le ' + #13#10 +
        'stock courant est différent de l''histo stock '+ #13#10 +
        'ou différent du stock dans AGRMOUVEMENT', 0);
      IF NOT (bOkAppliMinimise) THEN
        AffichePatienter;
      Application.ProcessMessages;
      TRY

        // Recherche si GENTRIGGERDIFF est vide
        WITH Que_Div1, SQL DO
        BEGIN
          Close;
          Clear;
          Add('select count(*) as NBRE from GENTRIGGERDIFF where TRI_ID <> 0');
          Open;
          Nbre := fieldbyname('NBRE').AsInteger;
          Close;
        END;
        IF Nbre > 0 THEN
        BEGIN
          IF bOkAppliMinimise THEN
          BEGIN
            Application.Restore;
            Application.BringToFront;
          END;
          RAISE Exception.Create('La table GENTRIGGERDIFF n''est pas vide.' + #13#10 + 'Impossible de continuer !');
        END;

        result := true;

        WITH Que_Div1, SQL DO
        BEGIN
          // Desactive le trigger
          Clear;
          Add('execute procedure BN_ACTIVETRIGGER(1)');
          ExecSQL;
          Close;
        END;

        // recherche nombre d'enregistrement dans AGRSTOCKCOUR  pour la progression
        // de la procedure Stockée SM_PB_STOCK
        (*WITH Que_Div1, SQL DO
        BEGIN
          Close;
          Clear;
          Add('select count(distinct STC_ARTID) as NBRE from AGRSTOCKCOUR');
          Add(' join artreference on arf_artid=stc_artid and arf_virtuel=0');
          Add(' where STC_COUID<>0');
          Open;
          Nbre := fieldbyname('NBRE').AsInteger;
          Close;
        END;   *)
              
        WITH Que_Div1, SQL DO
        BEGIN
          SavArtID := 0;
          Close;
          Clear;
          Add('select STC_ARTID, STC_MAGID, SUM(STC_QTE) QTE');
          Add('  from AGRSTOCKCOUR');
          Add('  join artreference on arf_artid=stc_artid and arf_virtuel=0');
          Add(' where STC_COUID<>0');
          Add(' group by STC_ARTID, STC_MAGID');
          Open;
          Nbre := RecordCount;
          IF Nbre = 0 THEN
            TpListeRech.Add('Aucun article à contrôler')
          ELSE
          BEGIN
            NbreInteg := 0;
            SetMaxProgress(Nbre);

            First;
            WHILE NOT (Eof) DO
            BEGIN
              bOk := true;
              Application.ProcessMessages;

              // Affectation paramètre
              ArtID := fieldbyname('STC_ARTID').AsInteger;
              //              TgfID := fieldbyname('STC_TGFID').AsInteger;
              //              CouID := fieldbyname('STC_COUID').AsInteger;
              MagID := fieldbyname('STC_MAGID').AsInteger;
              QteCour := fieldbyname('QTE').AsInteger;

              // recherche diff. Stk courant et Stk Histo
              IF (SavArtID <> ArtID) THEN
              BEGIN
                //Verifie si il n'y a pas de pb avec histo stock
                bPbHistoStk := false;
                WITH Que_Div2, SQL DO
                BEGIN
                  Close;
                  Clear;
                  Add('select * from AGRHISTOSTOCK');
                  Add('where HST_ARTID='+inttostr(ArtID)+
                       ' and (HST_TGFID=0 or HST_COUID=0)');
                  Open;
                  First;
                  bPbHistoStk := not(Eof);
                  Close;
                end;
                if bPbHistoStk then
                  vPbHistoStk := 1
                else
                  vPbHistoStk := 0;

                // vérifier les mvt de stock
                WITH Que_Div2, SQL DO
                BEGIN
                  Close;
                  Clear;
                  Add('SELECT RSTOCKFIN');
                  Add(' FROM RV_EXECARTHISTOMVT (' + inttostr(ArtID) +
                    ', ''%|' + inttostr(MagID) + '|%'')');
                  Open;
                  Last;
                  QteHisto := fieldbyname('RSTOCKFIN').AsInteger;
                END;

                // Vérification des mouvements avec la table AGRMOUVEMENT
                with Que_Div4, SQL do
                begin
                  QteMvt := 0;
                  Close;
                  Clear;
                  SQL.Add('SELECT SUM(MVT_QTE * MVT_SENS * MVT_AVECSTOCK) AS QTE_COURANT');
                  SQL.Add('FROM AGRMOUVEMENT');
                  SQL.Add('WHERE MVT_ARTID = :ARTID AND MVT_MAGID = :MAGID');
                  ParamCheck := True;
                  ParamByName('ARTID').AsInteger := ArtID;
                  ParamByName('MAGID').AsInteger := MagID;
                  Open;
                  QteMvt := FieldByName('QTE_COURANT').AsInteger;
                end;

                IF bOk AND (SavArtID <> ArtID) AND ((QteCour <> QteHisto) or (QteCour <> QteMvt) or (QteHisto <> QteMvt) or bPbHistoStk) THEN
                BEGIN
                  // insertion dans table recalcul
                  bOk      := false;
                  SavArtID := ArtID; // noter l'article à recalculer
                  inc(NbreInteg);

                  WITH Que_Div3, SQL DO
                  BEGIN
                    // ID
                    Close;
                    Clear;
                    Add('Select ID from PR_NEWK(''ARTRECALCULE'')');
                    Open;
                    RecalculID := fieldbyname('ID').AsInteger;
                    Close;

                    // insertion dans ARTRECALCULE
                    Close;
                    Clear;
                    Add('insert into ARTRECALCULE (REC_ID, REC_ARTID, REC_MAGID, REC_QUOI) Values');
                    Add('(' + inttostr(RecalculID) + ',' + inttostr(ArtID) + ', 0, 0)');
                    ExecSQL;
                    Close;
                  END;

                  // note l'article inséré
                  WITH Que_InfoArt DO
                  BEGIN
                    ArtNom    := '';
                    ArtChrono := '';
                    ArtMark   := '';
                    Close;
                    ParamByName('ARTID').AsInteger := ArtID;
                    Open;
                    First;
                    IF NOT (Eof) THEN
                    BEGIN
                      ArtNom    := fieldbyname('ART_NOM').AsString;
                      ArtChrono := fieldbyname('ARF_CHRONO').AsString;
                      ArtMark   := fieldbyname('MRK_NOM').AsString;
                    END;
                    IF TpListeArt.Count = 0 THEN // entête du csv
                    BEGIN
                      sEntete := '';
                      FOR i := 1 TO Cds_LstArt.FieldCount DO
                      BEGIN
                        IF sEntete <> '' THEN
                          sEntete := sEntete + ';';
                        sEntete := sEntete + Cds_LstArt.Fields[i - 1].FieldName;
                      END;
                      TpListeArt.Add('ArtID;Chrono;Nom;Marque;StkCourant;StkHisto;StkMvt;PbSckHisto');
                    END;
                    TpListeArt.Add(inttostr(ArtID) + ';' +
                      ArtChrono + ';' +
                      StringReplace(ArtNom, ';', '_', []) + ';' +
                      StringReplace(ArtMark, ';', '_', []) + ';' +
                      inttostr(QteCour) + ';' +
                      inttostr(QteHisto) + ';' +
                      IntToStr(QteMvt) + ';' +
                      inttostr(vPbHistoStk));
                  END;

                END // insertion dans table recalcul
              END; //if (SavArtID<>ArtID) then

              //fait avancer la progress bar
              AvanceProgress;
              Next;
            END; // while not(Eof) do


            TpListeRech.Add(inttostr(NbreInteg) + ' articles à traiter');
          END; // else begin
          Active := false;
        END; // with Que_Div1, SQL do

        WITH Que_Div1, SQL DO
        BEGIN
          // Active le Trigger s'il ne l'était pas à l'origine
          IF EtatTrigger = 0 THEN
          BEGIN
            Clear;
            Add('execute procedure BN_ACTIVETRIGGER(0)');
            ExecSQL;
            Close;
            EtatTrigger := 1;
          END;
        END;

        IbT_Trans.Commit;

      FINALLY
        FermerPatienter;
        OkFermer := true;
      END;

    EXCEPT
      ON E: Exception DO
      BEGIN
        IbT_Trans.Rollback;
        sError := StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]);
        IF Length(sError) > 255 THEN
          sError := Copy(sError, 1, 255);
        TpListeRech.Add(sError);
        IF bOkAppliMinimise THEN
        BEGIN
          Application.Restore;
          Application.BringToFront;
        END;
        IF Pos('La table GENTRIGGER', E.Message) > 0 THEN
          MessageDlg('Base: ' + ANom + #13#10#13#10 + E.Message, mtWarning, [mbok], 0)
        ELSE
          MessageDlg('Base: ' + ANom + #13#10#13#10 + E.Message, mterror, [mbok], 0);
      END;
    END;
    WITH Que_Div1, SQL DO
    BEGIN
      // Active le Trigger s'il ne l'était pas à l'origine
      IF EtatTrigger = 0 THEN
      BEGIN
        Clear;
        Add('execute procedure BN_ACTIVETRIGGER(1)');
        ExecSQL;
        Close;
        EtatTrigger := 1;
      END;
    END;
    TempD := now;
    IF TpListeRech.Count > 0 THEN
    BEGIN
      sFicRech := 'Rapp_Rech_' + FormatDateTime('yyyy-mm-dd hhnnss zzz', TempD) + '.txt';
      TRY
        TpListeRech.SaveToFile(sReper + sFicRech);
      EXCEPT
      END;
    END;
    IF TpListeArt.Count > 0 THEN
    BEGIN
      sFicArt := 'Rapp_Art_' + FormatDateTime('yyyy-mm-dd hhnnss zzz', TempD) + '.csv';
      TRY
        TpListeArt.SaveToFile(sReper + sFicArt);
      EXCEPT
      END;
    END;
    TpListeRech.Free;
    TpListeRech := NIL;
    TpListeArt.Free;
    TpListeArt := NIL;

  END;

END;

PROCEDURE TFrm_Main.DoRecalculStock(ANom: STRING);
VAR
  Nbre: integer;
  sError: STRING;
  TpListeRecalc: TStringList;
  sReper: STRING;
  sFicRecalc: STRING;
  EtatTrigger: integer;
  NBasID: integer;
BEGIN
  WITH Dm_Main DO
  BEGIN
    TpListeRecalc := TStringList.Create;
    sReper := ReperRapport + ANom + '\';
    IF NOT (DirectoryExists(sReper)) THEN
      ForceDirectories(sReper);

    // Sauvegarde etat de l'activation du trigger (lecture du Gen_ID)
    TRY
      WITH Que_Div1, SQL DO
      BEGIN
        Close;
        Clear;
        Add('SELECT GEN_ID(GENTRIGGER,0) as ETAT FROM RDB$DATABASE');
        Open;
        EtatTrigger := fieldbyname('ETAT').AsInteger;
        Close;
      END;
    EXCEPT
    END;

    IbT_Trans.StartTransaction;
    TRY

      OkFermer := false;
      VeuillezPatienter('Recalcul du stock', 0);
      IF NOT (bOkAppliMinimise) THEN
        AffichePatienter;
      Application.ProcessMessages;
      TRY

        WITH Que_Div1, SQL DO
        BEGIN
          // Active le trigger
          Clear;
          Add('execute procedure BN_ACTIVETRIGGER(1)');
          ExecSQL;
          Close;

          // nombre d'article à traiter
          // 1: la table GENTRIGGERDIFF
          Clear;
          Add('select count(*) as NBRE from GENTRIGGERDIFF where tri_artid<>0');
          Open;
          Nbre := fieldbyname('NBRE').AsInteger;
          Close;

          // 2: la table ARTRECALCULE
          NBasID := -1;
  
          Clear;
          Add('SELECT MIN(BAS_ID) as BASID');
          Add('FROM GENBASES JOIN K ON (K_ID=BAS_ID AND K_ENABLED =1)');
          Add('WHERE BAS_IDENT=(SELECT PAR_STRING FROM GENPARAMBASE WHERE PAR_NOM='+QuotedStr('IDGENERATEUR')+')');
          Open;
          NBasID := Fieldbyname('BASID').AsInteger;
          if NBasID=0 then
            NBasID := -1;
          Close;

          Clear;
          Add('select count(distinct(rec_artid)) as NBRE  from ARTRECALCULE');
          Add('where (REC_ID<>0) and ((REC_QUOI=0) OR (REC_QUOI<> '+inttostr(NBasID)+'))');
          Open;
          Nbre := Nbre + fieldbyname('NBRE').AsInteger;
          Close;

          SetMaxProgress(Nbre);
        END;

        // recalcul tous les 500
        REPEAT
          Que_CalculeTrigger.Close;
          Que_CalculeTrigger.ParamCheck := True;
          Que_CalculeTrigger.ParamByName('PAS').AsInteger := 500;
          Que_CalculeTrigger.Open;
          AvanceProgress(20);
          IbT_Trans.Commit;
          IbT_Trans.StartTransaction;
        UNTIL Que_CalculeTrigger.fieldbyname('RETOUR').AsInteger = 0;

        WITH Que_Div1, SQL DO
        BEGIN
          // desactive le Trigger s'il ne l'était pas à l'origine
          IF EtatTrigger = 1 THEN
          BEGIN
            Clear;
            Add('execute procedure BN_ACTIVETRIGGER(0)');
            ExecSQL;
            Close;
            EtatTrigger := 0;
          END;
        END;

        // rapport
        IF Nbre = 0 THEN
          TpListeRecalc.Add('Aucun article à recalculer')
        ELSE
          TpListeRecalc.Add(inttostr(Nbre) + ' articles ont été recalculer');

        IbT_Trans.Commit;

      FINALLY
        FermerPatienter;
        OkFermer := true;
      END;

    EXCEPT
      ON E: Exception DO
      BEGIN
        IbT_Trans.Rollback;
        sError := StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]);
        IF Length(sError) > 255 THEN
          sError := Copy(sError, 1, 255);
        TpListeRecalc.Add(sError);
        IF bOkAppliMinimise THEN
        BEGIN
          Application.Restore;
          Application.BringToFront;
        END;
        MessageDlg('Base: ' + ANom + #13#10#13#10 + E.Message, mterror, [mbok], 0);
      END;
    END;

    WITH Que_Div1, SQL DO
    BEGIN
      // desactive le Trigger s'il ne l'était pas à l'origine de nouveau par sécurité
      IF EtatTrigger = 1 THEN
      BEGIN
        Clear;
        Add('execute procedure BN_ACTIVETRIGGER(0)');
        TRY
          ExecSQL;
        EXCEPT
        END;
        Close;
        EtatTrigger := 0;
      END;
    END;

    IF TpListeRecalc.Count > 0 THEN
    BEGIN
      sFicRecalc := 'Rapp_Calc_' + FormatDateTime('yyyy-mm-dd hhnnss zzz', now) + '.txt';
      TRY
        TpListeRecalc.SaveToFile(sReper + sFicRecalc);
      EXCEPT
      END;
    END;
    TpListeRecalc.Free;
    TpListeRecalc := NIL;

  END;

END;

PROCEDURE TFrm_Main.AppEvntActivate(Sender: TObject);
BEGIN
  bOkAppliMinimise := false;
  AffichePatienter;
END;

PROCEDURE TFrm_Main.AppEvntMinimize(Sender: TObject);
BEGIN
  bOkAppliMinimise := true;
END;

PROCEDURE TFrm_Main.AppEvntRestore(Sender: TObject);
BEGIN
  bOkAppliMinimise := false;
  AffichePatienter;
END;

PROCEDURE TFrm_Main.CtrlButton;
BEGIN
  Nbt_Ajout.Enabled := Pan_Centre.Visible AND Dm_Main.Cds_Base.Active;
  Nbt_Modif.Enabled := Pan_Centre.Visible AND Dm_Main.Cds_Base.Active AND (Dm_Main.Cds_Base.RecordCount > 0);
  Nbt_Supprim.Enabled := Pan_Centre.Visible AND Dm_Main.Cds_Base.Active AND (Dm_Main.Cds_Base.RecordCount > 0);
END;

PROCEDURE TFrm_Main.CtrlButtonRapp;
VAR
  sRep: STRING;
  sFic: STRING;
BEGIN
  IF NOT (Assigned(Dm_Main)) THEN
    exit;
  Nbt_SuppRapp.Enabled := Pan_Centre.Visible AND Dm_Main.Cds_Rapp.Active AND (Dm_Main.Cds_Rapp.RecordCount > 0);
  IF Nbt_SuppRapp.Enabled AND (Dm_Main.Cds_Rapp.FieldByName('Type').AsInteger = 1) THEN
  BEGIN
    sFic := Dm_Main.Cds_Rapp.FieldByName('Fichier').AsString;
    sRep := ExtractfilePath(sFic);
    IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
      sRep := sRep + '\';
    sFic := ExtractFileName(sFic);
    IF Pos('_Rech_', sFic) > 0 THEN
    BEGIN
      sFic := StringReplace(sFic, '_Rech_', '_Art_', [rfReplaceAll]);
      sFic := Copy(sFic, 1, Length(sFic) - Length(ExtractFileExt(sFic))) + '.csv';
      Nbt_voirArt.Enabled := FileExists(sRep + sFic);
    END
    ELSE
      Nbt_voirArt.Enabled := false;
  END
  ELSE
    Nbt_voirArt.Enabled := false;
END;

PROCEDURE TFrm_Main.DoBaseDataChange;
BEGIN
  IF NOT (Assigned(Dm_Main)) THEN
    exit;
  IF Dm_Main.Cds_Base.Active AND (Dm_Main.Cds_Base.RecordCount > 0) THEN
    Lab_CheminBase.Caption := Dm_Main.Cds_Base.fieldbyname('Base').AsString
  ELSE
    Lab_CheminBase.Caption := '';
  DoRapport;
END;

PROCEDURE TFrm_Main.Ds_BaseDataChange(Sender: TObject; Field: TField);
BEGIN
  DoBaseDataChange;
END;

PROCEDURE TFrm_Main.Ds_RappDataChange(Sender: TObject; Field: TField);
BEGIN
  CtrlButtonRapp;
END;

PROCEDURE TFrm_Main.FormActivate(Sender: TObject);
VAR
  bOk: boolean;
BEGIN
  IF EtatFiche THEN
    exit;
  EtatFiche := true;
  Application.ProcessMessages;
  IF ParamCount > 0 THEN
  BEGIN
    PostMessage(Handle, WM_DEMARRE, 0, 0);
    exit;
  END;
  Frm_Acces := TFrm_Acces.Create(Self);
  TRY
    bOk := (Frm_Acces.ShowModal = mrok);
  FINALLY
    Frm_Acces.Free;
  END;
  IF NOT (bOk) THEN
  BEGIN
    PostMessage(Handle, WM_CLOSE, 0, 0);
    exit;
  END;
  Nbt_Param.Visible := true;
  Nbt_TraitAuto.Visible := true;
  Pan_Centre.Visible := true;
  Pan_Bottom.Visible := true;
  CtrlButton;
  CtrlButtonRapp;
END;

PROCEDURE TFrm_Main.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  CanClose := OkFermer;
  IF NOT (CanClose) THEN
    exit;
  Dm_Main.Free;
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  Lab_CheminBase.Caption := '';
  Nbt_Param.Visible := false;
  Nbt_TraitAuto.Visible := false;  
  Lab_Version.Caption := 'Ver. '+ApplicationVersion;
  Dm_Main := TDm_Main.Create(Self);
  EtatFiche := false;
  bAuto := false;
  bEncoursRapport := false;
  bOkAppliMinimise := false;
  CtrlButton;
  CtrlButtonRapp;
  DoBaseDataChange;
  OkFermer := true;
END;

PROCEDURE TFrm_Main.Nbt_AjoutClick(Sender: TObject);
VAR
  book: TBookmark;
  vInd: integer;
BEGIN
  WITH Dm_Main DO
  BEGIN
    IF NOT (Cds_Base.Active) THEN
      exit;
    Frm_AjoutModifBase := TFrm_AjoutModifBase.Create(Self);
    TRY
      IF Frm_AjoutModifBase.ShowModal = mrok THEN
      BEGIN
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;
        Book := Cds_Base.GetBookmark;
        Cds_Base.DisableControls;
        vInd := 0;
        TRY
          Cds_Base.First;
          WHILE NOT (Cds_Base.Eof) DO
          BEGIN
            IF vInd < Cds_Base.FieldByName('Ind').AsInteger THEN
              vInd := Cds_Base.fieldbyname('Ind').AsInteger;
            Cds_Base.Next;
          END;
        FINALLY
          Cds_Base.GotoBookmark(Book);
          Cds_Base.FreeBookmark(Book);
          Cds_Base.EnableControls;
        END;
        inc(vInd);
        TRY
          Cds_Base.Append;
          Cds_Base.FieldByName('Ind').AsInteger := vInd;
          Cds_Base.FieldByName('Nom').AsString := Frm_AjoutModifBase.ENom.Text;
          Cds_Base.FieldByName('Base').AsString := Frm_AjoutModifBase.EBase.Text;
          Cds_Base.Post;
          SauveConfig;
        FINALLY
          CtrlButton;
          Screen.Cursor := crDefault;
          Application.ProcessMessages;
        END;
      END;
    FINALLY
      Frm_AjoutModifBase.Free;
      Frm_AjoutModifBase := NIL;
    END;
  END;
END;

procedure TFrm_Main.Nbt_AnalyseClick(Sender: TObject);
VAR
  bOk: boolean;
  OkMinimise: boolean;
  iErreur: integer;
  sErreur: string;
  bNew: boolean;
  sFic: string;
  sReper: string;
BEGIN
  IF NOT (Dm_Main.Cds_Base.Active) OR (Dm_Main.Cds_Base.RecordCount = 0) THEN
    exit;
  bOk := false;
  OkMinimise := false;
  Frm_ConfirmAnalyse := TFrm_ConfirmAnalyse.Create(Self);
  TRY
    Frm_ConfirmAnalyse.InitEcr(Dm_Main.Cds_Base.FieldByName('Nom').AsString);
    bOk := (Frm_ConfirmAnalyse.ShowModal = mrok);
    bNew := Frm_ConfirmAnalyse.Rad_Analyse.Checked;
    sFic := Frm_ConfirmAnalyse.RetFic;
    if bNew then
      OkMinimise := Frm_ConfirmAnalyse.Chk_Minimize.Checked
    else
      OkMinimise := false;
  FINALLY
    Frm_ConfirmAnalyse.Free;
  END;

  IF NOT (bOk) THEN
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  IF OkMinimise THEN
    Application.Minimize;
  TRY
    iErreur :=0;
    sErreur := '';
    if bNew then
    begin
      // connexion à la base
      IF NOT (Dm_Main.TestConnexion(Dm_Main.Cds_Base.FieldByName('Base').AsString, true)) THEN
      BEGIN
        IF bOkAppliMinimise THEN
        BEGIN
          Application.Restore;
          Application.BringToFront;
        END;
        MessageDlg('Connexion impossible avec la base  !', mterror, [mbok], 0);
        exit;
      END;

      // recherche
      sFic := DoAnalyse(Dm_Main.Cds_Base.FieldByName('Nom').AsString, iErreur, sErreur);

      IF bOkAppliMinimise THEN
      BEGIN
        Application.Restore;
        Application.BringToFront;
      END;
    end;

    case iErreur of
      0:  // pas d'erreur
      begin
        Frm_Analyse := TFrm_Analyse.Create(Self);
        try                                     
          sFic := ReperRapport + Dm_Main.Cds_Base.FieldByName('Nom').AsString + '\'+sFic;


          Frm_Analyse.InitEcr(sFic,Dm_Main.Cds_Base.FieldByName('Nom').AsString);
          Frm_Analyse.ShowModal;
        finally
          FreeAndNil(Frm_Analyse);
        end;
      end;

      1:  // pas d'article ou pas d'article avec Stk courant<>stk histo
      begin
        MessageDlg(sErreur, mtWarning, [mbok],0);
      end;

      2:  // erreur générale
      begin
        MessageDlg(sErreur, mtError, [mbok],0);
      end;
    end;

    with Dm_Main do
    begin
      MemD_DetailArt.Close;
    end;

  FINALLY
    DoRapport;
    Dm_Main.Ginkoia.Connected := false;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  END;
end;

PROCEDURE TFrm_Main.Nbt_ModifClick(Sender: TObject);
BEGIN
  WITH Dm_Main DO
  BEGIN
    IF NOT (Cds_Base.Active) OR (Cds_Base.RecordCount = 0) THEN
      exit;
    Frm_AjoutModifBase := TFrm_AjoutModifBase.Create(Self);
    TRY
      Frm_AjoutModifBase.SetModif(Cds_Base.FieldByName('Ind').AsInteger,
        Cds_Base.FieldByName('Nom').AsString,
        Cds_Base.FieldByName('Base').AsString);
      IF Frm_AjoutModifBase.ShowModal = mrok THEN
      BEGIN
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;
        TRY
          Cds_Base.Edit;
          Cds_Base.FieldByName('Nom').AsString := Frm_AjoutModifBase.ENom.Text;
          Cds_Base.FieldByName('Base').AsString := Frm_AjoutModifBase.EBase.Text;
          Cds_Base.Post;
          SauveConfig;
        FINALLY
          CtrlButton;
          Screen.Cursor := crDefault;
          Application.ProcessMessages;
        END;
      END;
    FINALLY
      Frm_AjoutModifBase.Free;
      Frm_AjoutModifBase := NIL;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ParamClick(Sender: TObject);
BEGIN
  Frm_Parametre := TFrm_Parametre.Create(Self);
  TRY
    IF Frm_Parametre.ShowModal = mrok THEN
    BEGIN
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      TRY
        Dm_Main.SauveConfig;
      FINALLY
        CtrlButton;
        Screen.Cursor := crDefault;
        Application.ProcessMessages;
      END;
    END;
  FINALLY
    Frm_Parametre.Free;
    Frm_Parametre := NIL;
  END;
END;

PROCEDURE TFrm_Main.Nbt_SuppRappClick(Sender: TObject);
VAR
  sRep: STRING;
  sFic: STRING;
BEGIN
  WITH Dm_Main DO
  BEGIN
    IF NOT (Cds_Rapp.Active) OR (Cds_Rapp.RecordCount = 0) THEN
      exit;
    IF MessageDlg('Etes-vous sûr de vouloir supprimer le rapport ?',
      mtconfirmation, [mbyes, mbno], 0, mbno) <> mryes THEN
      exit;
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    TRY
      sFic := Cds_Rapp.FieldByName('Fichier').AsString;
      sRep := ExtractfilePath(sFic);
      IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
        sRep := sRep + '\';
      sFic := ExtractFileName(sFic);
      IF FileExists(sRep + sFic) THEN
        DeleteFile(sRep + sFic);
      IF Pos('_Rech_', sFic) > 0 THEN
      BEGIN
        sFic := StringReplace(sFic, '_Rech_', '_Art_', [rfReplaceAll]);
        sFic := Copy(sFic, 1, Length(sFic) - Length(ExtractFileExt(sFic))) + '.csv';
        IF FileExists(sRep + sFic) THEN
          DeleteFile(sRep + sFic);
      END;
      Cds_Rapp.Delete;
    FINALLY
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_SupprimClick(Sender: TObject);
BEGIN
  WITH Dm_Main DO
  BEGIN
    IF NOT (Cds_Base.Active) OR (Cds_Base.RecordCount = 0) THEN
      exit;
    IF MessageDlg('Supprimez ?', mtconfirmation, [mbyes, mbno], 0, mbno) <> mryes THEN
      exit;
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    TRY
      Cds_Base.Delete;
      SauveConfig;
    FINALLY
      CtrlButton;
      Screen.Cursor := crDefault;
      Application.ProcessMessages;
    END;
  END;
END;

procedure TFrm_Main.Nbt_TraitAutoClick(Sender: TObject);
begin   
  Frm_TraiteAuto := TFrm_TraiteAuto.Create(Self);
  try
    Frm_TraiteAuto.ShowModal;
  finally
    FreeAndNil(Frm_TraiteAuto);
  end;
end;

PROCEDURE TFrm_Main.Nbt_voirArtClick(Sender: TObject);
VAR
  sRep: STRING;
  sFic: STRING;
  sFicArt: STRING;
BEGIN
  WITH Dm_Main DO
  BEGIN
    IF NOT (Cds_Rapp.Active) OR (Cds_Rapp.RecordCount = 0) THEN
      exit;
    sFicArt := '';
    sFic := Cds_Rapp.FieldByName('Fichier').AsString;
    sRep := ExtractfilePath(sFic);
    IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
      sRep := sRep + '\';
    sFic := ExtractFileName(sFic);
    IF Pos('_Rech_', sFic) > 0 THEN
    BEGIN
      sFicArt := StringReplace(sFic, '_Rech_', '_Art_', [rfReplaceAll]);
      sFicArt := Copy(sFicArt, 1, Length(sFicArt) - Length(ExtractFileExt(sFicArt))) + '.csv';
    END;
    IF (sFicArt = '') OR NOT (FileExists(sRep + sFicArt)) THEN
      exit;

    Frm_ListArtTrouve := TFrm_ListArtTrouve.Create(Self);
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    TRY
      Frm_ListArtTrouve.SetLstArt(sRep + sFicArt);
    FINALLY
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    END;
    Frm_ListArtTrouve.ShowModal;

  END;
END;

PROCEDURE TFrm_Main.Tim_RapportTimer(Sender: TObject);
BEGIN
  IF bEncoursRapport THEN
    exit;
  Tim_Rapport.Enabled := false;
  DoRapport;
END;

PROCEDURE TFrm_Main.Nbt_QuitClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.Nbt_RecalStkClick(Sender: TObject);
VAR
  bOk: boolean;
  OkMinimise: boolean;
  OkRestore: boolean;
BEGIN
  IF NOT (Dm_Main.Cds_Base.Active) OR (Dm_Main.Cds_Base.RecordCount = 0) THEN
    exit;
  bOk := false;
  OkMinimise := false;
  OkRestore := false;
  Frm_Confirmation := TFrm_Confirmation.Create(Self);
  TRY
    Frm_Confirmation.SetInfo(2);
    bOk := (Frm_Confirmation.ShowModal = mrok);
    OkMinimise := Frm_Confirmation.Chk_Minimize.Checked;
    OkRestore := Frm_Confirmation.Chk_Restore.Checked;
  FINALLY
    Frm_Confirmation.Free;
  END;
  IF NOT (bOk) THEN
    exit;
  IF OkMinimise THEN
    Application.Minimize;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TRY
    // Connexion à la base
    IF NOT (Dm_Main.TestConnexion(Dm_Main.Cds_Base.FieldByName('Base').AsString, true)) THEN
    BEGIN
      IF bOkAppliMinimise THEN
      BEGIN
        Application.Restore;
        Application.BringToFront;
      END;
      MessageDlg('Connexion impossible avec la base  !', mterror, [mbok], 0);
      exit;
    END;

    // recalcul
    DoRecalculStock(Dm_Main.Cds_Base.FieldByName('Nom').AsString);

  FINALLY
    DoRapport;
    IF OkMinimise AND OkRestore THEN
    BEGIN
      Application.Restore;
      Application.BringToFront;
    END;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  END;
END;

PROCEDURE TFrm_Main.Nbt_RechArtClick(Sender: TObject);
VAR
  bOk: boolean;
  OkMinimise: boolean;
  OkRestore: boolean;
BEGIN
  IF NOT (Dm_Main.Cds_Base.Active) OR (Dm_Main.Cds_Base.RecordCount = 0) THEN
    exit;
  bOk := false;
  OkMinimise := false;
  OkRestore := false;
  Frm_Confirmation := TFrm_Confirmation.Create(Self);
  TRY
    Frm_Confirmation.SetInfo(1);
    bOk := (Frm_Confirmation.ShowModal = mrok);
    OkMinimise := Frm_Confirmation.Chk_Minimize.Checked;
    OkRestore := Frm_Confirmation.Chk_Restore.Checked;
  FINALLY
    Frm_Confirmation.Free;
  END;
  IF NOT (bOk) THEN
    exit;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  IF OkMinimise THEN
    Application.Minimize;
  TRY
    // connexion à la base
    IF NOT (Dm_Main.TestConnexion(Dm_Main.Cds_Base.FieldByName('Base').AsString, true)) THEN
    BEGIN
      IF bOkAppliMinimise THEN
      BEGIN
        Application.Restore;
        Application.BringToFront;
      END;
      MessageDlg('Connexion impossible avec la base  !', mterror, [mbok], 0);
      exit;
    END;

    // recherche
    DoRecherche(Dm_Main.Cds_Base.FieldByName('Nom').AsString);

  FINALLY
    DoRapport;
    Dm_Main.Ginkoia.Connected := false;
    IF OkMinimise AND OkRestore THEN
    BEGIN
      Application.Restore;
      Application.BringToFront;
    END;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  END;
END;

END.

