unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  //début des uses
  ucommon, uImportExport,
  //fin des uses
  Dialogs, Db, IBCustomDataSet, IBSQL, IBQuery, IBDatabase, StdCtrls, Mask,
  wwdbedit, wwDBEditRv, Grids, Wwdbigrd, Wwdbgrid, wwDBGridRv, LMDControl,
  LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, Buttons, RzLabel, ExtCtrls, RzPanel, RzPanelRv,
  IB_Components, LMDCustomComponent, LMDBrowseDlg, LMDCustomButton,
  LMDButton, LMDBaseGraphicControl, dxmdaset, DBClient;
type
  Tfrm_main = class(TForm)
    OD_Path: TOpenDialog;
    RzPanelRv1: TRzPanelRv;
    Ds_Inv: TDataSource;
    Dbg_Inv: TwwDBGridRv;
    Lab_Inventaire: TRzLabel;
    RzPanelRv2: TRzPanelRv;
    memLog: TMemo;
    Lab_Log: TRzLabel;
    Lab_CheminInv: TRzLabel;
    Chp_BaseInv: TwwDBEditRv;
    Nbt_ODInv: TSpeedButton;
    Nbt_ConnectionInv: TLMDSpeedButton;
    Lab_CheminDest: TRzLabel;
    Chp_BaseDest: TwwDBEditRv;
    Nbt_ODDest: TSpeedButton;
    RzPanelRv3: TRzPanelRv;
    Nbt_EXP_IMP: TLMDSpeedButton;
    IBC_BaseInv: TIBDatabase;
    IBT_TransInv: TIBTransaction;
    Que_Export: TIBQuery;
    IBSQL_Export: TIBSQL;
    Que_Inv: TIBQuery;
    IBC_BaseDest: TIBDatabase;
    IbC_Generateur: TIBQuery;
    IBT_TransQue_Inv: TIBTransaction;
    IBT_TransDest: TIBTransaction;
    OD_Folder: TLMDBrowseDlg;
    IBSQL_Import: TIBSQL;
    RzPanelRv4: TRzPanelRv;
    Lab_FicExp: TRzLabel;
    Chp_FicExp: TwwDBEditRv;
    Chk_ExportImgStock: TCheckBox;
    Nbt_Export: TLMDSpeedButton;
    Nbt_ODFicExp: TSpeedButton;
    RzPanelRv5: TRzPanelRv;
    Lab_FicImp: TRzLabel;
    Chp_FicImp: TwwDBEditRv;
    Chk_ImportImgStock: TCheckBox;
    Nbt_ODFicImp: TSpeedButton;
    Nbt_Import: TLMDSpeedButton;
    IbC_Recalc: TIBQuery;
    dxMemData1: TdxMemData;
    Que_InvINV_ID: TIntegerField;
    Que_InvINV_MAGID: TIntegerField;
    Que_InvINV_CHRONO: TIBStringField;
    Que_InvINV_COMENT: TIBStringField;
    Que_InvINV_DATEOUV: TDateField;
    Que_InvINV_FINCOMPT: TDateField;
    Que_InvINV_DATEFIN: TDateField;
    Que_InvINV_DATEDEMARQ: TDateField;
    Que_InvINV_COMPLET: TIntegerField;
    Que_InvINV_CLOTURE: TIntegerField;
    Que_InvINV_TYPE: TIBStringField;
    dxMemData1INV_ID: TIntegerField;
    dxMemData1INV_MAGID: TIntegerField;
    dxMemData1INV_CHRONO: TWideStringField;
    dxMemData1INV_COMENT: TWideStringField;
    dxMemData1INV_DATEOUV: TDateField;
    dxMemData1INV_FINCOMPT: TDateField;
    dxMemData1INV_DATEFIN: TDateField;
    dxMemData1INV_DATEDEMARQ: TDateField;
    dxMemData1INV_TYPE: TWideStringField;
    dxMemData1INV_COMPLET: TStringField;
    dxMemData1INV_CLOTURE: TStringField;
    Que_invloc: TIBQuery;
    Chk_VideInvLoc: TCheckBox;
    procedure Nbt_ODInvClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_ODDestClick(Sender: TObject);
    procedure boutons();
    function initialiserConnexion(base: TIBDatabase; DatabaseName: string): boolean;
    procedure Nbt_ConnectionInvClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Nbt_ExportClick(Sender: TObject);
    procedure Chp_BaseDestChange(Sender: TObject);
    function plageDisponible(AInv_ID: integer): boolean;
    procedure Que_InvINV_COMPLETGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure Que_InvINV_CLOTUREGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure Dbg_InvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Nbt_ODFicExpClick(Sender: TObject);
    procedure Nbt_ODFicImpClick(Sender: TObject);
    procedure Nbt_EXP_IMPClick(Sender: TObject);
    function exporter(): boolean;
    function exporterSelection(): boolean;
    function importer(AInventaire: string): boolean;
    function importerSelection(): boolean;
    procedure Nbt_ImportClick(Sender: TObject);
    procedure initialiserParam(base: TIBDatabase);
    function recupererInv_Id(AFilePath: string): Integer;
    procedure getPlageDer();
    procedure listerInventaires(ts: TStringList);
    function testerInv_id(ts: TStringList; inv_id: Integer): boolean;
  private
    { Déclarations privées }
    plageDebut, plageFin, plageDer, inv_id: Integer;

  public
    { Déclarations publiques }
  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.DFM}

uses
  lmdfilegrep;

procedure Tfrm_main.Nbt_ODInvClick(Sender: TObject);
begin
  //si un fichier est sélectionné
  if OD_Path.Execute then
  begin
    //recopier son nom
    Chp_BaseInv.Text := OD_Path.FileName;
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  //Todo pour test a virer apres
//  Chp_BaseInv.Text := 'C:\Ginkoia\Data\bret\GINKOIA.IB';
//  Chp_BaseDest.Text := 'C:\Developpement\Ginkoia\Data\Morat\GINKOIA.IB';
  plageder := -1;
  //initialiser les paramètres de connexion
  initialiserParam(IBC_BaseInv);
  initialiserParam(IBC_BaseDest);
  //initialiser la boite de dialogue fichier
  //repertoire par défaut
  OD_Path.InitialDir := GetCurrentDir;
  //options
  OD_Path.Options := [ofFileMustExist];
  //filtre
  OD_Path.Filter := 'Fichiers ib (*.ib)|*.ib';
  OD_Path.FilterIndex := 1;
  //initialiser la boite de dialogue dossier
  OD_Folder.SelectedFolder := GetCurrentDir;
  //initialiser fichier log
  InitLogFileName(memLog);
  //initiliser le chemin par défaut de l'export et de l'import
  Chp_FicExp.Text := 'C:\Ginkoia\Data\Export\';
  chp_FicImp.Text := Chp_FicExp.Text;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.Nbt_ODDestClick(Sender: TObject);
begin
  //si fichier sélectionné
  if OD_Path.Execute then
  begin
    //recopier son nom
    Chp_BaseDest.Text := OD_Path.FileName;
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.boutons();
begin
  //export
  Nbt_Export.Enabled := IBC_BaseInv.Connected;
  //import
  Nbt_Import.enabled := Length(Chp_BaseDest.Text) > 0;
  //import et export
  Nbt_EXP_IMP.Enabled := IBC_BaseInv.Connected and (Length(Chp_BaseDest.Text) > 0);
  //connection base Export
  Nbt_ConnectionInv.Enabled := (Length(Chp_BaseInv.Text) > 0);
end;

procedure Tfrm_main.Nbt_ConnectionInvClick(Sender: TObject);
  procedure Rempli_memdata();
  var
    vComplet, vCloture : string;
  begin
    if not dxMemData1.Active then
      dxMemData1.Active := True;
    dxMemData1.Close;
    dxMemData1.Open;
    while not Que_Inv.Eof do
    begin
      case Que_Inv.FieldByName('inv_complet').AsInteger of
        0:
          vComplet := 'Partiel';
        1:
          vComplet := 'Complet';
        2:
          vComplet := 'Réserve';
      end;

      case Que_Inv.FieldByName('inv_cloture').AsInteger of
        0:
          vCloture := 'NON';
        1:
          vCloture := 'OUI';
      end;
      dxMemData1.Append;
      dxMemData1.FieldByName('inv_coment').AsString := Que_Inv.FieldByName('inv_coment').AsString;
      dxMemData1.FieldByName('inv_id').AsInteger := Que_Inv.FieldByName('inv_id').AsInteger;
      dxMemData1.FieldByName('inv_magid').AsInteger := Que_Inv.FieldByName('inv_magid').AsInteger;
      dxMemData1.FieldByName('inv_chrono').AsString := Que_Inv.FieldByName('inv_chrono').AsString;
      dxMemData1.FieldByName('inv_dateouv').AsString := Que_Inv.FieldByName('inv_dateouv').AsString;
      dxMemData1.FieldByName('inv_datefin').AsString := Que_Inv.FieldByName('inv_datefin').AsString;
      dxMemData1.FieldByName('inv_complet').AsString := vComplet;
      dxMemData1.FieldByName('inv_cloture').AsString := vCloture;
      dxMemData1.FieldByName('inv_fincompt').AsString := Que_Inv.FieldByName('inv_fincompt').AsString;
      dxMemData1.FieldByName('inv_datedemarq').AsString := Que_Inv.FieldByName('inv_datedemarq').AsString;
      dxMemData1.FieldByName('inv_type').AsString := Que_Inv.FieldByName('inv_type').AsString;
      dxMemData1.Post;

      Que_Inv.Next;
    end;

    if not Que_invloc.Eof then
    begin
      dxMemData1.Append;
      dxMemData1.FieldByName('inv_coment').AsString := 'Inventaire de location (' + Que_invloc.FieldByName('nb_ligne').AsString + ' lignes)';
      dxMemData1.FieldByName('inv_dateouv').AsString := Que_invloc.FieldByName('date_ouverture').AsString;
      dxMemData1.FieldByName('inv_type').AsString := 'Location';
      dxMemData1.Post;
    end;
  end;
begin
  //tester le chemin
  if FileExists(Chp_BaseInv.text) then
  begin
    //tester la connexion
    if initialiserConnexion(Ibc_BaseInv, Chp_BaseInv.text) then
    begin
      //remplir tableau avec liste inventaire
      Que_Inv.Open();
      Que_invloc.Open();
      Rempli_memdata();
      Que_invloc.Close();
      Que_Inv.Close();
      //selectionner le premier enregistrement dans le grid
      dxMemData1.First;
      Dbg_Inv.SelectRecord;
    end;
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.FormDestroy(Sender: TObject);
begin
  //vérifier l'état de la connection à la base
  if IbC_BaseInv.Connected then
  begin
    //se déconnecter
    IbC_BaseInv.Close();
  end;
end;

procedure Tfrm_main.Nbt_ExportClick(Sender: TObject);
begin
  //lancer l'export
  exporterSelection();
end;

procedure Tfrm_main.Chp_BaseDestChange(Sender: TObject);
begin
  //gestions des boutons
  boutons();
end;

function Tfrm_main.plageDisponible(AInv_ID: integer): boolean;
var
  disponible: boolean;
begin
  //initialiser les plages
  plageDebut := -1;
  plageFin := -1;
  plageDer := -1;

  //initialiser la reponse
  disponible := false;
  //obtenir la plage utilisée par l'inventaire
  GetPlage(Que_Export, IBSQL_Export, Ainv_id, plageDebut, plageFin);
  //obtenir le dernier id utilisé dans la base destination de l'import
  getPlageDer();
  //tester la valeur récupèrée
  if plageDer >= 0 then
  begin
    //comparer
    if (plageDer < plageDebut) then
    begin
      //disponible
      disponible := true;
    end;
  end;
  //retour
  result := disponible;
end;


procedure Tfrm_main.Que_InvINV_COMPLETGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  //convertir la valeur du champ
  try
    //Test selon les cas
    case Sender.AsInteger of
      0:
        Text := 'Partiel';
      1:
        Text := 'Complet';
      2:
        Text := 'Réserve';
    end;
  except

  end;
end;

procedure Tfrm_main.Que_InvINV_CLOTUREGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  //convertir la valeur du champ
  try
    //Test selon les cas
    case Sender.AsInteger of
      0:
        Text := 'NON';
      1:
        Text := 'OUI';
    end;
  except
    //
  end;
end;

procedure Tfrm_main.Dbg_InvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //Par sécurité vérifier qu'on est placé sur une ligne du grid (et non un header une autre partie...)
  if (X <> -1) and (Y <> -1) then
  begin
    //sélection la ligne
    Dbg_Inv.SelectRecord;
  end;
end;



procedure Tfrm_main.Nbt_ODFicExpClick(Sender: TObject);
begin
  //si fichier sélectionné
  if OD_Folder.Execute then
  begin
    //recopier son nom dans le champs export
    Chp_FicExp.Text := IncludeTrailingPathDelimiter(OD_Folder.SelectedFolder);
    //recopier son nom dans le champs import
    Chp_FicImp.Text := IncludeTrailingPathDelimiter(OD_Folder.SelectedFolder);
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.Nbt_ODFicImpClick(Sender: TObject);
begin
  //si fichier sélectionné
  if OD_Folder.Execute then
  begin
    //recopier son nom
    Chp_FicImp.Text := IncludeTrailingPathDelimiter(OD_Folder.SelectedFolder);
  end;
  //gestion des boutons
  boutons();
end;

procedure Tfrm_main.Nbt_EXP_IMPClick(Sender: TObject);
begin
  //initialiser le mémo
  memlog.Clear();
  //tester le contenu des deux champs
  if (Chp_BaseInv.text = Chp_BaseDest.text) then
  begin
    //message d'info
    ShowMessage('Chemins des bases identiques !');
  end
  //sinon commencer l'export
  else
  begin
    //tester l'existence des la base
    if (FileExists(Chp_BaseInv.text)) and (FileExists(Chp_BaseDest.text)) then
    begin
      //etat du cursor
      Screen.Cursor := crHourGlass;
      try
        //si l'export
        if exporterSelection() then
        begin
          //lancer l'import
          importerSelection();
        end;
      finally
        //etat du cursor
        Screen.Cursor := crDefault;
      end;
    end
    //si fichier inexistant
    else
    begin
    //log
      LogAction('** Base(s) de donnée inexistante(s) **');
    end;
  end;
end;

function Tfrm_main.Exporter(): boolean;
var
  bRetour, vLocation: boolean;
  exportPath, vLocationDate: string;
  i: integer;
begin
  //initialiser le retour
  bRetour := false;
  //initialiser l'inv_id
  inv_id := 0;
  //message
  LogAction('***** Début de l''exportation *****');
  //avec la dataset lié à la grille
  with Dbg_Inv.datasource.dataset do
  begin
    //parcourir la liste des inventaires sélectionnés
    for i := 0 to Dbg_Inv.SelectedList.Count - 1 do
    begin
      //se placer sur l'enregistrement
      GotoBookmark(Dbg_Inv.SelectedList.items[i]);
      //récupèrer l'id de l'inventaire
      inv_id := FieldByName('Inv_id').AsInteger;

      vLocation := (UpperCase(FieldByName('inv_type').AsString) = 'LOCATION');

      //renseigner le mémo
      if vLocation then
      begin
        LogAction('** Inventaire de location **');
        vLocationDate := FieldByName('inv_dateouv').AsString;
        //créer le chemin
        exportPath := IncludeTrailingPathDelimiter(Chp_FicExp.text) + '~~Inventaire~~-7777';
      end
      else
      begin
        LogAction('** Inventaire ' + Trim(FieldByName('Inv_Coment').asString) + ', Id : ' + Trim(FieldByName('Inv_id').asString) + ' **');
        vLocationDate := '';
        //créer le chemin
        exportPath := IncludeTrailingPathDelimiter(Chp_FicExp.text) + '~~Inventaire~~' + format('%.14d', [inv_id]);
      end;

      //si export réussi
      if ExportInventaire(Que_Export, inv_id, exportPath, vLocation, vLocationDate, Chk_ExportImgStock.Checked) then
      begin
        //confirmer le bon déroulement
        bRetour := true;
      end
    end;
  end;
  //retour
  result := bRetour;
end;

function Tfrm_main.importer(AInventaire: string): boolean;
var
  retour: boolean;
begin
  //initialiser le retour
  retour := false;

  // Executer l'import :
  if ImportInventaire(IBSQL_Import, AInventaire, Chk_ImportImgStock.Checked) then
  begin
    if (inv_id = -7777) then
      retour := True
    else
    //mettre le générateur à jour
    retour := SetGenerators(IbC_Generateur, IBSQL_Import, inv_id);
  end;
  //retour
  result := retour;
end;


function Tfrm_main.initialiserConnexion(base: TIBDatabase; DatabaseName: string): boolean;
var
  retour: boolean;
begin
  //initialiser le booléen
  retour := false;
  try
    // tester si déjà connecté sur une base
    if base.Connected then
    begin
    //se déconnecter
      base.Close;
    end;
    //initialiser le chemin de connection vers la base destinataire
    base.DatabaseName := DatabaseName;
    //connecter
    base.Open();
    //tester si connection réussie
    if base.Connected then
    begin
    //signaler le succès
      retour := true;
    end;
  except
    on E: Exception do
    begin
      LogAction('Erreur lors de l''initialisation de la connexion' + E.Message);
    end;
  end;
  result := retour;
end;

procedure Tfrm_main.initialiserParam(base: TIBDatabase);
begin
  //Iniatiliser les paramètres de connection
  base.Params.clear;
  base.Params.Add('user_name=sysdba');
  base.Params.Add('password=masterkey');
end;

function Tfrm_main.recupererInv_Id(AFilePath: string): Integer;
var
  i: Integer;
  chemin: string;
begin
  //initialiser i
  i := 0;
  //récupèrer l'inv_id dans le nom du dossier
  chemin := ExtractFileDir(AFilePath);
  //indice de position de '~~Inventaire~~'
  i := Pos('~~Inventaire~~', chemin);
  //si trouvé la chaine après '~'dans le chemin découper
  if i <> 0 then
  begin
    chemin := copy(chemin, i + length('~~Inventaire~~'), (length(chemin) - i + length('~~Inventaire~~')));
  end;
  //retourner le valeur
  if chemin <> '' then
  begin
    try
      //convertir
      i := StrToInt(chemin);
    except
      i := -1
    end;
  end;
  //retour
  result := i;
end;

procedure Tfrm_Main.getPlageDer();
begin
  try
    //remplir la requete
    IbC_Generateur.SQL.Text := 'select GEN_ID(num_invlignes,0) from rdb$database';
    //ouvrir la requete
    IbC_Generateur.open();
     //obtenir la plage de la base destinataire
     //tester le résultat
    if (IbC_Generateur.RecordCount > 0) then
    begin
      //récupèrer le dernier numéro utilisé
      plageDer := IbC_Generateur.Fields[0].asinteger;
    end;
  finally
    //fermer la requete
    IbC_Generateur.Close();
  end;
end;

function Tfrm_main.exporterSelection(): boolean;
var
  retour: Boolean;
begin
  //initialiser le retour
  retour := false;
  //vérifier si aucun inventaire n'est sélectionné
  if Dbg_Inv.SelectedList.count = 0 then
  begin
    ShowMessage('Veuillez sélectionner un inventaire !');
  end
  //sinon commencer l'export
  else
  begin
    //tester l'existence de la base
    if FileExists(Chp_BaseInv.text) then
    begin
      //etat du cursor
      Screen.Cursor := crHourGlass;
      try
        //si l'export se passe bien
        if exporter() then
        begin
          LogAction('**** Export terminé avec succès ****');
          retour := True;
        end
        else
        begin
          LogAction('**** Echec de l''exportation ****');
        end;
      finally
        //etat du cursor
        Screen.Cursor := crDefault;
      end;
    end;
  end;
  //retour
  result := retour;
end;

function Tfrm_main.importerSelection(): boolean;
var
  i, mag_id: Integer;
  ts: TStringList;
  retour: Boolean;
begin
  //initialiser la réponse
  retour := false;
  //initialiser inv_id et i
  inv_id := -1;
  //initialiser l'id
  mag_id := 0;
  //initialiser la plage der
  plageder := -1;
  //création de la liste
  ts := TStringlist.Create();
  LogAction('');
  LogAction('**** Début de l''importation ****');
  //parcourir le dossier à la recherche d'importation ou de dossiers d'importation
  listerInventaires(ts);
  //si des dossiers d'inventaire trouvés
  if ts.Count <> 0 then
  begin
    //tester la connexion
    if initialiserConnexion(IbC_BaseDest, Chp_BaseDest.text) then
    begin

      // on testera si on doit faire l'import avec bFaireImport
      if testerInv_id(ts, inv_id) then
      begin

        ScriptExecute(IBSQL_Import, 'Scripts\01-Verif\04_DESACTIVE_TRIGGER.sql');

        if (Chk_VideInvLoc.Checked) then
        begin
          try
            LogAction('** Vidage de l''inventaire de LOCATION **');
            IBSQL_Import.Transaction.StartTransaction;
            IBSQL_Import.SQL.Text := 'delete from locinventaire;';
            IBSQL_Import.ExecQuery;
            IBSQL_Import.Transaction.Commit;
            LogAction('**   --> : OK **');
          except
            on E: exception do
            begin
              LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
              IBSQL_Import.Transaction.rollback;
            end;
          end;
        end;

       //pour chaque dossier d'inventaire
        for i := 0 to ts.Count - 1 do
        begin
          //récupèrer l'inv_id du premier import
          inv_id := recupererInv_Id(ts[i]);
          //tester la récupèration de l'inv_id
          if (inv_id <> -1) then
          begin
            //log : indiquer le dossier importé
            LogAction('** Dossier d''import : ' + ts[i] + ' **');
            //etat du cursor
            Screen.Cursor := crHourGlass;
            try
              //si bon déroulement de l'importation lancer le recalcul des stock_id
              if importer(ts[i]) then
              begin
                //lancer le recalcul des stock_id
                LogAction('**** Importation terminée avec succès ****');
                if (inv_id <> -7777) then
                begin
                  LogAction('');
                  LogAction('**** Recalcul des stc_id ****');
                  //remplir le texte de la requete sql
                  IbC_Recalc.sql.text := 'select inv_magid from inventete where inv_id=' + IntToStr(inv_id);
                  try
                    //ouvrir la requete
                    IbC_Recalc.open();
                    // récupèrer la valeur
                    IbC_Recalc.First();
                    mag_id := IbC_Recalc.Fields[0].asInteger;
                  except
                    on E: exception do
                    begin
                      //erreur
                      mag_id := 0;
                      //log
                      LogAction('**   --> : Exception : ' + StringReplace(E.Message, #13#10, ' | ', [rfReplaceAll]) + ' **');
                    end;
                  end;
                  // On ferme la query
                  IbC_Recalc.Close;
                  //vérifier que le magasin existe
                  if mag_id <> 0 then
                  begin
                    if RecalcSTC_ID(IbC_Recalc, Ibsql_Import, mag_id) then
                    begin //rien
                      retour := true;
                      LogAction('****  Recalcul terminé ****');
                    end
                    else
                    begin //log
                      LogAction('****  Recalcul Echec ****');
                      retour := false;
                    end;
                  end
                  else //sinon message
                  begin
                    //log
                    retour := false;
                    LogAction('****  Recalcul Echec ****');
                  end;
                end;
              end
              else
              begin
                retour := false;
                LogAction('**** Echec de l''importation ****');
              end;
            finally
              //etat du cursor
              Screen.Cursor := crDefault;
            end;
          end
          else
          begin
            LogAction('** Le dossier d''importation n''est pas valide **');
          end;
        end; {end for}

        ScriptExecute(IBSQL_Import, 'Scripts\01-Verif\05_ACTIVE_TRIGGER.sql');

        LogAction('**** Fin du traitement ****');
      end;
    end
    else
    begin
      LogAction('** Impossible d''initialiser la connexion à la base de donnée **');
    end; {if initialiserConnexion(IbC_BaseDest, Chp_BaseDest.text) then}
  end
  //si aucun dossier d'import trouvé
  else
  begin
    LogAction('** Le dossier d''importation n''est pas valide **');
  end; {if ts.Count <> 0 then}
  //libérer la liste
  ts.free();
  //retour
  result := retour;
end;

procedure Tfrm_main.Nbt_ImportClick(Sender: TObject);
begin
  //demander à l'utilisateur s'il veut continuer l'importation malgré cela
  if MessageDlg('Attention, la base doit avoir été préparée avant cette opération :'
    + #13#10 + '(identifiants activés et générateurs importés)' + IntToStr(plageDer)
    + #13#10 + 'Voulez-vous lancer l''importation ?', mtWarning, [MbYes, MbNo], 0) = mrYes then
  begin
      //lancer l'importation
  importerSelection();
  end
  else
  begin // Log
    LogAction('** Arrêt de l''importation demandé par l''utilisateur **');
  end;

end;


procedure Tfrm_main.listerInventaires(ts: TStringList);
var
  FGrep_Import: TLMDFileGrep;
  i: Integer;
begin
   //Créer le grep
  FGrep_Import := TLMDFileGrep.Create(self);
  if (Pos('~~Inventaire~~', Chp_FicImp.text) = 0) then
  begin
    // On recherche tous les fichiers .SQL du dossier voulu
    FGrep_Import.FileMasks := '~~Inventaire~~*.';
    FGrep_Import.RecurseSubDirs := false;
    FGrep_Import.ReturnDelimiter := ';';
    FGrep_Import.ThreadedSearch := False;
    FGrep_Import.ThreadPriority := tpHighest;
    FGrep_Import.Dirs := IncludeTrailingPathDelimiter(Chp_FicImp.text);
    FGrep_Import.ReturnValues := [rvDir, rvFileName];
    //rechercher les dossiers
    FGrep_Import.Grep;

    // On trie le résultat par nom de fichier
    QuickSort(FGrep_Import.Files);
    //pour chaque dossier trouvé
    for i := 0 to (FGrep_Import.Files.Count - 1) do
    begin
      //ajouter le dossier à la liste des inventaires à traiter
      ts.Add(IncludeTrailingPathDelimiter(StringReplace(FGrep_Import.Files[i], ';', '', [rfReplaceAll])));
    end
  end
  //si le dossier contient des inventaires
  else
  begin
    //l'ajouter à la liste
    ts.Add(Chp_FicImp.text);
  end;
  //libérer le grep
  FGrep_Import.free();
end;

function Tfrm_main.testerInv_id(ts: TStringList; inv_id: Integer): boolean;
var
  bFaireImport: boolean;
begin
  //initialiser la réponse
  bFaireImport := false;
  //récupèrer l'inv_id du premier import
  inv_id := recupererInv_Id(ts[0]);
  if (inv_id <> -1) then
  begin
    // si c'est un inventaire de location alors ne pas faire de controle
    if(inv_id = -7777) then
      bFaireImport := True
    else
    begin
      //obtenir la dernière valeur du générateur d'id de la base destination
      getplageDer();
      //si la valeur est supérieure à -1 ( base vide )
      if plageDer >= 0 then
      begin
        //si le numéro de l'inventaire est supérieur au dernier id attribué lancer l'import
        //sinon prévenir l'utilisateur et lui demander s'il faut poursuivre
        if (inv_id > plageDer) then
        begin
          bFaireImport := true;
        end
        else
        begin
          //demander à l'utilisateur s'il veut continuer l'importation malgré cela
          if MessageDlg('Numéro d''inventaire :' + IntToStr(inv_id)
            + #13#10 + 'inférieur à la valeur du générateur de la base destination :' + IntToStr(plageDer)
            + #13#10 + 'Voulez-vous forcer l''importation ?', mtWarning, [MbYes, MbNo], 0) = mrYes then
          begin
            bFaireImport := true;
          end
          else
          begin // Log
            LogAction('** Arrêt de l''importation demandé par l''utilisateur **');
          end;
        end;
      end
      else
      begin // Log
        LogAction('** Erreur de récupèration de la valeur du générateur **');
      end;
    end;
  end
  else
  begin // Log
    LogAction('** Le dossier d''importation n''est pas valide **');
  end;
  //retour
  result := bFaireImport;
end;

end.

