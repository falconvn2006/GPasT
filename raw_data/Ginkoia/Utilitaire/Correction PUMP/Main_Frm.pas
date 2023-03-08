unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  StrUtils, stdActns, System.Types, MidasLib,
  Vcl.Buttons, uGestionBDD,
  System.Generics.Collections, System.RegularExpressions, System.RegularExpressionsCore,
  Vcl.Grids, Vcl.DBGrids, Vcl.CheckLst, FireDAC.Phys.IBDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.DApt,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Data.DB, Datasnap.DBClient, Vcl.ComCtrls;

type
  TMain = class(TForm)
    Pn_Main: TPanel;
    Lbl_Fichier: TLabel;
    Img_List: TImageList;
    Bed_PatchCSV: TButtonedEdit;
    Lbl_BaseGinkoia: TLabel;
    Bed_BaseNosymag: TButtonedEdit;
    Btn_Process: TButton;
    GroupBox1: TGroupBox;
    Ck_PrixAchat: TCheckBox;
    Ck_PrixVente: TCheckBox;
    Lbl_Process: TLabel;
    PB_Process: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure Bed_BaseNosymagRightButtonClick(Sender: TObject);
    procedure Bed_PatchCSVRightButtonClick(Sender: TObject);
    procedure Btn_ProcessClick(Sender: TObject);
  private
    { Déclarations privées }
    function LoadDataSet(aMsg, aPathFile, aCle: string;aCDS: TclientDataSet): Boolean;
    function GetPrixVente(Query : TMyQuery; artid, tgfid, couid : integer) : string;
    function GetPrixVenteBase(Query : TMyQuery; artid : integer) : string;
    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String;const Delimiter: Char = ';');
    procedure CreateProcRecalcBRE(Query : TMyQuery);
  public
    { Déclarations publiques }
  end;

var
  Main: TMain;
  Compteur      : Integer=0;
  NbLigne       : Integer;

implementation



{$R *.dfm}

procedure TMain.Bed_BaseNosymagRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_BaseNosymag.Text := odTemp.FileName;
    end;
  finally
    odTemp.Free;
  end;
end;

procedure TMain.Bed_PatchCSVRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv|Tous|*.*';
    odTemp.Title := 'Choix du fichier CSV Correspondant';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      (Sender as TButtonedEdit).Text := odTemp.FileName;
  finally
    PB_Process.Position := 0;
    PB_Process.Min      := 0;
    odTemp.Free;
  end;
end;

procedure TMain.Btn_ProcessClick(Sender: TObject);
var
  sBreID : integer;
  sBrlID : integer;
  sArtID : integer;
  sCouID : integer;
  sTgfID : integer;
  sPos   : integer;

  sChrono  : string;
  sArtNom  : string;
  sTaille  : string;
  sCouleur : string;
  sBlaNum  : string;
  sBlaNumA : string;
  sCB      : string;
  sSKU     : string;
  sDesign  : string;

  sPrixAchat : string;
  sPrixAchatA: string;
  sPrixVente : string;
  sPrixVenteA: string;

  sAa        : string;
  sA         : string;
  sVa        : string;
  sV         : string;

  bOkAchat   : Boolean;
  bOkVente   : Boolean;
  bFoundArt  : Boolean;
  bOkProcess : Boolean;

  Cds_Modele : TClientDataSet;

  sLog       : TStringList;
  sRapportPA : TStringList;
  sRapportPV : TStringList;

  sDirectory : string;

  SavePlace  : TBookmark;

  Connexion   : TMyConnection;
  Transaction : TMyTransaction;
  sQuery      : TMyQuery;

  SMax        : integer;
  sI          : integer;
  NbligneR    : integer;

  BlaNum      : integer;
  BlaNumOld   : integer;

  sDir        : string;

  TabLRecep   : Array [1..10] of Integer;

  sPrixVenteBase  : string;
  sPrixVenteSKU   : string;
  sPvtIDNew       : integer;
  sPvtID          : integer;


begin
  //Init
  sLog       := TStringList.Create;
  sRapportPA := TStringList.Create;
  sRapportPV := TStringList.Create;

  //Init clientDataSet
  try
    Cds_Modele := TClientDataSet.Create(Nil);
    try
      //Chargement du Dataset en mémoire
      sDir := Bed_PatchCSV.Text;

      if not LoadDataSet('Fichier_modele', sDir,'N° BLAuto;Désignation', Cds_Modele) then
        sLog.Add('Impossible de charger le Dataset en mémoire');

      //Ajout des entêtes pour les rapports
      sRapportPA.Add('Chrono;Nom Modele;Taille;Couleur;Ancien prix Achat;Nouveau prix Achat');
      sRapportPV.Add('Codebarre;Chrono;Nom Modele;Taille;Couleur;Ancien prix Vente;Nouveau prix Vente;Prix base de vente;Etat');

      //Connection a la base de données
      Connexion   := GetNewConnexion(Bed_BaseNosymag.Text, 'SYSDBA', 'masterkey');
      Transaction := GetNewTransaction(Connexion);
      sQuery      := GetNewQuery(Transaction);

      //Traitement
      Cds_Modele.First;
      Lbl_Process.Caption := 'Traitement en cours ...';

      //Gestion de la progressBar
      Application.ProcessMessages;
      PB_Process.Position := 0;
      PB_Process.Min      := 0;
      PB_Process.Max      := Cds_Modele.RecordCount;
      PB_Process.Step     := 1;

      Transaction.StartTransaction();

      //Création de la procédure de recalcul
      if Ck_PrixAchat.Checked then
        CreateProcRecalcBRE(sQuery);

      sBlaNumA := '';

      while not Cds_Modele.Eof do
      begin
        bOkAchat   := true;
        bOkProcess := True;

        sBlaNum := Cds_Modele.FieldByName('N° BLAuto').AsString;

        //Comme il y a plusieurs lignes avec le même Bla numero, je filtre le Dataset
        SavePlace := Cds_Modele.GetBookmark;
        Cds_Modele.DisableControls;
        try
          Cds_Modele.Filtered  := False;
          Cds_Modele.Filter    := '[N° BLAuto] = '+ QuotedStr(sBlaNum);
          Cds_Modele.Filtered  := True;
          Cds_Modele.FindFirst;


          sQuery.SQL.Clear;
          sQuery.SQL.Add('select bre_id '+
                         'from recbr '+
                         ' join k on k_id = bre_id and k_enabled = 1 '+
                         'where bre_numfourn = '+QuotedStr(sBlaNum));
          sQuery.Open;

          sBreID := sQuery.FieldByName('bre_id').AsInteger;

          {$region 'Recherche de la réception par rapport au bl'}
          if bOkProcess then
          begin
            //Correspond bien a une réception
            sBreID := sQuery.FieldByName('bre_id').AsInteger;

            while not Cds_Modele.Eof do
            begin
              sCB     := Cds_Modele.FieldByName('CodeBarre').AsString;
              sSKU    := Cds_Modele.FieldByName('SKU').AsString;
              sDesign := Cds_Modele.FieldByName('Désignation').AsString;

              bOkAchat := true;
              bOkVente := True;
              bFoundArt:= false;

              //Recherche de l'article avec ces infos artid, taille , couleur en sortie
              sQuery.SQL.Clear;
              sQuery.SQL.Add('select arf_chrono, arf_artid, art_nom, cbi_tgfid, cbi_couid, tgf_nom, cou_nom '+
                             'from artcodebarre '+
                             ' join k on k_id = cbi_id and k_enabled = 1 '+
                             ' join artreference on arf_id = cbi_arfid '+
                             ' join artarticle on art_id = arf_artid '+
                             ' join plxtaillesgf on tgf_id = cbi_tgfid '+
                             ' join plxcouleur   on cou_id = cbi_couid '+
                             'where cbi_cb = '+QuotedStr(sCB));
              sQuery.Open;

              if sQuery.RecordCount = 1 then
                bFoundArt := True;

              //Dans le cas d'un doublon d'article
              if sQuery.RecordCount > 1 then
              begin
                sQuery.First;

                //je parcours la ligne à la recherche de la bonne je m'aide
                while not sQuery.Eof and bFoundArt = False do
                begin
                  if ContainsStr(sSKU, sQuery.FieldByName('tgf_nom').AsString) then
                  begin
                    bFoundArt := true;
                  end else
                  begin
                    sQuery.Next;
                  end;
                end;
              end;

              if bFoundArt then
              begin
                sChrono := sQuery.FieldByName('arf_chrono').AsString;
                sArtNom := sQuery.FieldByName('art_nom').AsString;
                sArtID  := sQuery.FieldByName('arf_artid').AsInteger;
                sTgfID  := sQuery.FieldByName('cbi_tgfid').AsInteger;
                sCouID  := sQuery.FieldByName('cbi_couid').AsInteger;
                sTaille := sQuery.FieldByName('tgf_nom').AsString;
                sCouleur:= sQuery.FieldByName('cou_nom').AsString;

                {$REGION 'Prix d''achat'}
                if Ck_PrixAchat.Checked and (sBreID > 0)  then
                begin

                  //Si il y a plusieurs ligne de récep
                  for sI := 1 to 10 do
                    TabLRecep[sI] := 0;

                  //avec les infos de l'article je me positionne sur la bonne ligne de réception
                  sQuery.SQL.Clear;
                  sQuery.SQL.Add('select brl_id, brl_pxachat, brl_pxvente '+
                                 'from recbrl '+
                                 'join k on k_id = brl_id and k_enabled = 1 '+
                                 'where brl_breid = '+IntToStr(sBreID)+' and brl_artid = '+IntToStr(sArtID)+' and brl_tgfid = '+IntToStr(sTgfID)+' and brl_couid = '+IntToStr(sCouID));
                  sQuery.Open;
                  sQuery.First;

                  //Récupération des prix d'ajout et vente après
                  sPrixAchatA := sQuery.FieldByName('brl_pxachat').AsString;

                  sI := 1;
                  while not sQuery.Eof do
                  begin
                    TabLRecep[sI] := sQuery.FieldByName('brl_id').AsInteger;
                    Inc(sI);
                    sQuery.Next;
                  end;

                  NbligneR := sI;

                  sI := 1;

                  while ((sI <= NbligneR) and (TabLRecep[sI] <> 0)) do
                  begin
                    //Récupération des prix d'ajout et vente avant
                    sPrixAchat  := Cds_Modele.FieldByName('P.R TAF Run').AsString;
                    sPrixAchat  := StringReplace(sPrixAchat, ' ', '', [rfReplaceAll, rfIgnoreCase]);

                    //Positionnement sur la bonne ligne de réception
  //                  sBrlID := sQuery.FieldByName('brl_id').AsInteger;
                    sBrlID := TabLRecep[sI];

                    if not ContainsText(sPrixAchatA, ',') then
                      sPrixAchatA := sPrixAchatA+',00';

                    if not ContainsText(sPrixVenteA, ',') then
                      sPrixVenteA := sPrixVenteA+',00';

                    //vérification que les valeurs ne sont pas identiques
                    sAa := '';
                    sA  := '';

                    sPos := Pos(',', sPrixAchatA);
                    sAa  := LeftStr(sPrixAchatA, sPos+1);
                    sPos := Pos(',', sPrixAchat);
                    sA   := LeftStr(sPrixAchat, sPos+1);

                    if sAa = sA then
                      bOkAchat := false;

                    if bOkAchat then
                    begin
                      sQuery.SQL.Clear;
                      sQuery.SQL.Add('update recbrl set brl_pxachat = :pxachat , brl_pxnn = :pxachat2 where brl_id = :brlid ');
                      sQuery.ParamByName('pxachat').AsFloat  := StrToFloat(sPrixAchat);
                      sQuery.ParamByName('pxachat2').AsFloat := StrToFloat(sPrixAchat);
                      sQuery.ParamByName('brlid').AsInteger  := sBrlID;
                      sQuery.ExecSQL;

                      //Ajout de la ligne dans le rapport
                      if sI = 1 then
                        sRapportPA.Add(sChrono+';'+sArtNom+';'+sTaille+';'+sCouleur+';'+sPrixAchatA+';'+sPrixAchat);
                    end;

                    Inc(sI);
                  end;

                  //mouvemente la ligne pour la réplication
                  sQuery.SQL.Clear;
                  sQuery.SQL.Add('execute procedure pr_updatek( :brlid , 0)');
                  sQuery.ParamByName('brlid').AsInteger  := sBrlID;
                  sQuery.ExecSQL;

                end;

          {$ENDREGION}

                {$REGION 'prix de vente'}
                if Ck_PrixVente.Checked and bOkProcess then
                begin
                  bOkVente    := True;
                  sPrixVente  := Cds_Modele.FieldByName('PrixVente Run').AsString;
                  sPrixVente  := StringReplace(sPrixVente, ' ', '', [rfReplaceAll, rfIgnoreCase]);

                  sPrixVenteA := GetPrixVente(sQuery, sArtID, sTgfID, sCouID);

                  //vérification que les valeurs ne sont pas identiques
                  sV  := '';
                  sVa := '';

                  sPos := Pos(',', sPrixVenteA);
                  sVa  := LeftStr(sPrixVenteA, sPos+1);
                  sPos := Pos(',', sPrixVente);
                  sV   := LeftStr(sPrixVente, sPos+1);

                  if sVa = sV then
                  begin
                    bOkVente := false;
                    sRapportPV.Add(sCB+';'+sChrono+';'+sArtNom+';'+sTaille+';'+sCouleur+';'+sPrixVenteA+';'+sPrixVente+';'+GetPrixVenteBase(sQuery,sArtID)+';Non Modifié');
                  end;

                  if bOkVente then
                  begin
                    //mise à jour du prix de vente

                    //je recherche pour la tarif general sku
                    sQuery.SQL.Clear;
                    sQuery.SQL.Add('select pvt_id, pvt_px from tarprixvente '+
                                   'join k on k_id = pvt_id and k_enabled = 1 '+
                                   'where pvt_tvtid = 0 and pvt_couid = :couid and pvt_tgfid = :tgfid and pvt_artid = :artid ');
                    sQuery.ParamByName('couid').AsInteger  := sCouID;
                    sQuery.ParamByName('tgfid').AsInteger  := sTgfID;
                    sQuery.ParamByName('artid').AsInteger  := sArtID;
                    sQuery.Open;

                    sPvtID        := sQuery.FieldByName('pvt_id').AsInteger;
                    sPrixVenteSKU := sQuery.FieldByName('pvt_px').AsString;

                    if not (sPrixVenteSKU = '') then
                      if not ContainsText(sPrixVenteSKU, ',') then
                          sPrixVenteSKU := sPrixVenteSKU+',00';

                    if sPrixVenteSKU <> '' then
                    begin
                      //Avant la mise a jour je regarde si j'ai besoin de le mettre a jour
                      if sPrixVenteSKU <> sPrixVente then
                      begin
                        //il existe un prix de vente sku on verifie et modifie le prix si besoin
                        sQuery.SQL.Clear;
                        sQuery.SQL.Add('update tarprixvente set pvt_px = :pxvente where pvt_id = :pvtid ');
                        sQuery.ParamByName('pxvente').AsFloat  := StrToFloat(sPrixVente);
                        sQuery.ParamByName('pvtid').AsInteger  := sPvtID;
                        sQuery.ExecSQL;

                        //mouvemente la ligne pour la réplication
                        sQuery.SQL.Clear;
                        sQuery.SQL.Add('execute procedure pr_updatek( :pvtid , 0)');
                        sQuery.ParamByName('pvtid').AsInteger  := sPvtID;
                        sQuery.ExecSQL;


                        //je recherche le prix au prix de base
                        sPrixVenteBase := GetPrixVenteBase(sQuery,sArtID);

                        //Ajoute dans le rapport la modig
                        sRapportPV.Add(sCB+';'+sChrono+';'+sArtNom+';'+sTaille+';'+sCouleur+';'+sPrixVenteA+';'+sPrixVente+';'+sPrixVenteBase+';Modifié');
                      end else
                      begin
                        sRapportPV.Add(sCB+';'+sChrono+';'+sArtNom+';'+sTaille+';'+sCouleur+';'+sPrixVenteA+';'+sPrixVente+';'+GetPrixVenteBase(sQuery,sArtID)+';Non Modifié');
                      end;

                    end else
                    begin
                      //Le tarif sku n'existe pas
                      //on va chercher dans le prix de base général pour l'article
                      sQuery.SQL.Clear;
                      sQuery.SQL.Add('select pvt_id, pvt_px from tarprixvente '+
                                     'join k on k_id = pvt_id and k_enabled = 1 '+
                                     'where pvt_tvtid = 0 and pvt_couid = 0 and pvt_tgfid = 0 and pvt_artid = :artid ');
                      sQuery.ParamByName('artid').AsInteger  := sArtID;
                      sQuery.Open;

                      sPrixVenteBase := sQuery.FieldByName('pvt_px').AsString;
                      sPvtID         := sQuery.FieldByName('pvt_id').AsInteger;

                      if not (sPrixVenteBase = '') then
                        if not ContainsText(sPrixVenteBase, ',') then
                          sPrixVenteBase := sPrixVenteBase+',00';

                      //Si il y a pas de prix de base j'en crais un
                      if (sPrixVenteBase = '') then
                      begin
                        //nouvelle ID
                        sQuery.SQL.Clear;
                        sQuery.SQL.Add('select id from pr_newk(''TARPRIXVENTE'')');
                        sQuery.Open;

                        sPvtIDNew := sQuery.FieldByName('id').AsInteger;

                        sQuery.SQL.Clear;
                        sQuery.SQL.Add('insert into TARPRIXVENTE (PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_PX, PVT_COUID, PVT_CENTRALE)  '+
                                       'values (:PVTID, 0, :PVTARTID, 0, :PVTPX, 0, 1) ');
                        sQuery.ParamByName('PVTID').AsInteger    := sPvtIDNew;
                        sQuery.ParamByName('PVTARTID').AsInteger := sArtID;
                        sQuery.ParamByName('PVTPX').AsFloat      := StrToFloat(sPrixVente);;
                        sQuery.ExecSQL;
                      end else
                      begin
                        //prix de base trouvé, alors mise à jours
                        if sPrixVenteBase <> sPrixVente then
                        begin
                          sQuery.SQL.Clear;
                          sQuery.SQL.Add('update tarprixvente set pvt_px = :pxvente where pvt_id = :pvtid ');
                          sQuery.ParamByName('pxvente').AsFloat  := StrToFloat(sPrixVente);
                          sQuery.ParamByName('pvtid').AsInteger  := sPvtID;
                          sQuery.ExecSQL;

                          //mouvemente la ligne pour la réplication
                          sQuery.SQL.Clear;
                          sQuery.SQL.Add('execute procedure pr_updatek( :pvtid , 0)');
                          sQuery.ParamByName('pvtid').AsInteger  := sPvtID;
                          sQuery.ExecSQL;

                          sRapportPV.Add(sCB+';'+sChrono+';'+sArtNom+';'+'0'+';'+'0'+';'+sPrixVenteA+';'+sPrixVente+';'+sPrixVenteBase+';Prix de base modifié');
                        end else
                        begin
                          sRapportPV.Add(sCB+';'+sChrono+';'+sArtNom+';'+'0'+';'+'0'+';'+sPrixVenteA+';'+sPrixVente+';'+sPrixVenteBase+';Non Modifié');
                        end;
                      end;
                    end;
                  end;
                end;
              {$ENDREGION}

              end else
              begin
                //article non trouvé essai encore
                sLog.Add('cb = '+sCB+' : Article non trouvé');
              end;

              Cds_Modele.Next;
            end;

            //Je recalcule les entêtes
            if Ck_PrixAchat.Checked then
            begin
              sQuery.SQL.Clear;
              sQuery.SQL.Add('execute procedure SJ_RECBR_RECALC_ENTETE( :breid )');
              sQuery.ParamByName('breid').AsInteger  := sBreID;
              sQuery.ExecSQL;
            end;
          end else
          begin
            sLog.Add('Bl non trouvé : '+sBlaNum);
          end;
          {$endregion}

          sBlaNumA := sBlaNum;

          Cds_Modele.Filtered := False;
        finally
          Cds_Modele.EnableControls;
          Cds_Modele.GotoBookmark(SavePlace);
          Cds_Modele.FreeBookmark(SavePlace);
        end;

        while not Cds_Modele.Eof and (sBlaNum = Cds_Modele.FieldByName('N° BLAuto').AsString) do
        begin
          Cds_Modele.Next;
        end;


        //mise a jour de la progressBar
        Application.ProcessMessages;
        PB_Process.StepIt;
        PB_Process.Update;

//        Cds_Modele.Next;
      end;

      //drop de la procedure recalcul
      if Ck_PrixAchat.Checked then
      begin
        sQuery.SQL.Clear;
        sQuery.SQL.Add('drop procedure SJ_RECBR_RECALC_ENTETE;');
        sQuery.ExecSQL;
      end;

      //Sauvegarde de la transaction
      Transaction.Commit;
    finally
      Transaction.Free;

      //Enregistrement des rapports
      sDirectory := ExtractFileDir(Bed_PatchCSV.Text);
      if not DirectoryExists(sDirectory + '\Rapport') then
      begin
        if not CreateDir(sDirectory + '\Rapport') then
        begin
          sLog.Add('Impossible de créer le dossier');
        end;
      end;

      //Sauvegarde du rapport + Log erreur
      Lbl_Process.Caption := 'Sauvegarde des rapports ...';
      sLog.SaveToFile(sDirectory + '\Rapport\Erreur.log');
      sRapportPA.SaveToFile(sDirectory + '\Rapport\Rapport_PrixAchat.csv');
      sRapportPV.SaveToFile(sDirectory + '\Rapport\Rapport_PrixVente.csv');

      Application.ProcessMessages;
      Lbl_Process.Caption := 'Traitement terminé';
      PB_Process.Position := 0;

      //Liberation de la mémoire
      FreeAndNil(Cds_Modele);
      FreeAndNil(sLog);
      FreeAndNil(sRapportPA);
      FreeAndNil(sRapportPV);
      Connexion.Close;
    end;
  except on E: Exception do
    begin
      sLog.Add(e.Message);
      sLog.SaveToFile(sDirectory + '\Rapport\Erreur.log');
    end;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
var
  exe : string;
begin
  //Init
  Ck_PrixAchat.Checked := True;
  Ck_PrixVente.Checked := True;
  Self.Caption := 'Correction PUMP V2.0.0.0';
end;

function TMain.GetPrixVente(Query: TMyQuery; artid, tgfid,
  couid: integer): string;
var
  pvtid        : integer;
  prixVenteSku : String;
  prixVenteBase: string;
begin
  Query.SQL.Clear;
  Query.SQL.Add('select pvt_px from tarprixvente '+
                 'join k on k_id = pvt_id and k_enabled = 1 '+
                 'where pvt_tvtid = 0 and pvt_couid = :couid and pvt_tgfid = :tgfid and pvt_artid = :artid ');
  Query.ParamByName('couid').AsInteger  := couid;
  Query.ParamByName('tgfid').AsInteger  := tgfid;
  Query.ParamByName('artid').AsInteger  := artid;
  Query.Open;

  prixVenteSku := Query.FieldByName('pvt_px').AsString;

  if prixVenteSku <> '' then
  begin
    if not ContainsText(prixVenteSku, ',') then
        prixVenteSku := prixVenteSku+',00';

    Result := prixVenteSku;
  end else
  begin
    Query.SQL.Clear;
    Query.SQL.Add('select pvt_px from tarprixvente '+
                   'join k on k_id = pvt_id and k_enabled = 1 '+
                   'where pvt_tvtid = 0 and pvt_couid = 0 and pvt_tgfid = 0 and pvt_artid = :artid ');
    Query.ParamByName('artid').AsInteger  := artid;
    Query.Open;
    prixVenteBase := Query.FieldByName('pvt_px').AsString;

    if prixVenteBase <> '' then
    begin
      if not ContainsText(prixVenteBase, ',') then
        prixVenteBase := prixVenteBase+',00';

      result := prixVenteBase;
    end else
    begin
      result := '';
    end;
  end;

end;

function TMain.GetPrixVenteBase(Query: TMyQuery; artid: integer): string;
var
sprix : string;
begin
  Query.SQL.Clear;
  Query.SQL.Add('select pvt_px from tarprixvente '+
                 'join k on k_id = pvt_id and k_enabled = 1 '+
                 'where pvt_tvtid = 0 and pvt_couid = 0 and pvt_tgfid = 0 and pvt_artid = :artid ');
  Query.ParamByName('artid').AsInteger  := artid;
  Query.Open;

  sprix := Query.FieldByName('pvt_px').AsString;

  if not (sprix = '') then
    if not ContainsText(sprix, ',') then
      sprix := sprix+',00';

  Result := sprix;

end;

function TMain.LoadDataSet(aMsg, aPathFile, aCle: string; aCDS: TclientDataSet): Boolean;
begin
  try
    if FileExists(aPathFile) then
    begin
      CSV_To_ClientDataSet(aPathFile,aCDS,aCle);
      Result := True
    end
    else
    begin
      Result := False;
    end;
  except
    on E:Exception do
    begin
      Result := False;
    end;
  end;
end;

procedure TMain.CreateProcRecalcBRE(Query: TMyQuery);
begin
  Query.SQL.Clear;
  Query.SQL.Add('create procedure SJ_RECBR_RECALC_ENTETE ( ');
  Query.SQL.Add('   BREID integer) ');
  Query.SQL.Add('as ');
  Query.SQL.Add('declare variable IDXTVA integer; ');
  Query.SQL.Add('declare variable TAUXTVA numeric(18,7); ');
  Query.SQL.Add('declare variable MNTHT numeric(18,7); ');
  Query.SQL.Add('declare variable MNTTVA numeric(18,7); ');
  Query.SQL.Add('declare variable BREREMISE numeric(18,7); ');
  Query.SQL.Add('declare variable TTLHT numeric(18,7); ');
  Query.SQL.Add('declare variable TTLTVA numeric(18,7); ');
  Query.SQL.Add('declare variable FOURNTTC numeric(18,7); ');
  Query.SQL.Add('declare variable PANTIN integer; ');
  Query.SQL.Add('begin ');
  Query.SQL.Add('/***********************************************************************************/ ');
  Query.SQL.Add('/* date        | nom | commentaire                                                 */ ');
  Query.SQL.Add('/* 2016-09-28  | SJ  | Recalcule un entête d''une réception à l''aide de l''ID        */ ');
  Query.SQL.Add('/***********************************************************************************/ ');
  Query.SQL.Add(' ');
  Query.SQL.Add('update RECBR ');
  Query.SQL.Add('set BRE_TVAHT1 = 0, ');
  Query.SQL.Add('    BRE_TVATAUX1 = 0, ');
  Query.SQL.Add('    BRE_TVA1 = 0, ');
  Query.SQL.Add('    BRE_TVAHT2 = 0, ');
  Query.SQL.Add('    BRE_TVATAUX2 = 0, ');
  Query.SQL.Add('    BRE_TVA2 = 0, ');
  Query.SQL.Add('    BRE_TVAHT3 = 0, ');
  Query.SQL.Add('    BRE_TVATAUX3 = 0, ');
  Query.SQL.Add('    BRE_TVA3 = 0,					 ');
  Query.SQL.Add('    BRE_TVAHT4 = 0, ');
  Query.SQL.Add('    BRE_TVATAUX4 = 0, ');
  Query.SQL.Add('    BRE_TVA4 = 0, ');
  Query.SQL.Add('    BRE_TVAHT5 = 0, ');
  Query.SQL.Add('    BRE_TVATAUX5 = 0, ');
  Query.SQL.Add('    BRE_TVA5 = 0, ');
  Query.SQL.Add('    BRE_FOURNTTC = 0 ');
  Query.SQL.Add('where bre_id = :breid; ');
  Query.SQL.Add(' ');
  Query.SQL.Add('/* recup de la remise */ ');
  Query.SQL.Add('select bre_remise from recbr where bre_id = :breid into :breremise; ');
  Query.SQL.Add(' ');
  Query.SQL.Add(' ');
  Query.SQL.Add('  /* recalcul */ ');
  Query.SQL.Add('  idxtva   = 1; ');
  Query.SQL.Add('  ttlht    = 0; ');
  Query.SQL.Add('  ttltva   = 0; ');
  Query.SQL.Add('  FOURNTTC = 0; ');
  Query.SQL.Add(' ');
  Query.SQL.Add('  for select brl_tva, ');
  Query.SQL.Add('             cast(sum((brl_qte * brl_pxachat * (100 - :breremise) / 100)) as numeric(18, 2)), ');
  Query.SQL.Add('             cast(sum((brl_qte * brl_pxachat * (100 - :breremise) / 100) * (brl_tva / 100)) as numeric(18, 2)) ');
  Query.SQL.Add('      from recbrl join k on k_id = brl_id and k_enabled = 1 ');
  Query.SQL.Add('      where brl_breid = :breid ');
  Query.SQL.Add('      group by brl_tva ');
  Query.SQL.Add('      into :tauxtva, :mntht, :mnttva do ');
  Query.SQL.Add('  begin ');
  Query.SQL.Add('    if (idxtva = 1) then ');
  Query.SQL.Add('      update recbr set bre_tvaht1 = :mntht, bre_tva1 = :mnttva, bre_tvataux1 = :tauxtva where bre_id = :breid; ');
  Query.SQL.Add('    else if (idxtva = 2) then ');
  Query.SQL.Add('      update recbr set bre_tvaht2 = :mntht, bre_tva2 = :mnttva, bre_tvataux2 = :tauxtva where bre_id = :breid; ');
  Query.SQL.Add('    else if (idxtva = 3) then ');
  Query.SQL.Add('      update recbr set bre_tvaht3 = :mntht, bre_tva3 = :mnttva, bre_tvataux3 = :tauxtva where bre_id = :breid; ');
  Query.SQL.Add('    else if (idxtva = 4) then ');
  Query.SQL.Add('      update recbr set bre_tvaht4 = :mntht, bre_tva4 = :mnttva, bre_tvataux4 = :tauxtva where bre_id = :breid; ');
  Query.SQL.Add('    else if (idxtva = 5) then ');
  Query.SQL.Add('      update recbr set bre_tvaht5 = :mntht, bre_tva5 = :mnttva, bre_tvataux5 = :tauxtva where bre_id = :breid; ');
  Query.SQL.Add('    else ');
  Query.SQL.Add('      exception ALGOL_EXCEPTION; ');
  Query.SQL.Add('    idxtva = idxtva +1; ');
  Query.SQL.Add(' ');
  Query.SQL.Add('    ttlht  = :ttlht  + :mntht; ');
  Query.SQL.Add('    ttltva = :ttltva + :mnttva; ');
  Query.SQL.Add('  end ');
  Query.SQL.Add(' ');
  Query.SQL.Add('  FOURNTTC = :ttlht + :ttltva; ');
  Query.SQL.Add(' ');
  Query.SQL.Add('  update recbr set BRE_FOURNTTC = :FOURNTTC where bre_id = :breid; ');
  Query.SQL.Add(' ');
  Query.SQL.Add('  execute procedure pr_updatek(:breid, 0); ');
  Query.SQL.Add(' ');
  Query.SQL.Add('end ');
  Query.ExecSQL;
end;

procedure TMain.CSV_To_ClientDataSet(FichCsv: String; CDS: TClientDataSet;
  Index: String; const Delimiter: Char);
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
    InfoLigne.Delimiter := Delimiter;
    InfoLigne.StrictDelimiter := True;
    InfoLigne.DelimitedText := Donnees.Strings[0];
    for I := 0 to InfoLigne.Count - 1 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;
    CDS.CreateDataSet;
    CDS.AddIndex('idx', Index, []);
    CDS.IndexName := 'idx';

    //Traitement des lignes de données
    CDS.Open;

    for I := 1 to Donnees.Count - 1 do
      begin
        InfoLigne.Clear;
        InfoLigne.Delimiter := Delimiter;
        InfoLigne.QuoteChar := '''';
        Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
        Chaine  := ReplaceStr( Chaine, Delimiter, '''' + Delimiter + '''' );
        Chaine  := Chaine + '''';

        InfoLigne.DelimitedText := Chaine;
        CDS.Append;
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
  except
    on E:Exception do
    begin
      Exit;
    end;
  end;
end;

end.
