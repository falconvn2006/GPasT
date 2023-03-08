unit ODLOMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IB_Components, cxLookAndFeelPainters, dxSkinsCore, cxControls,
  cxContainer, cxEdit, cxGroupBox, ExtCtrls, StdCtrls, Mask, RzEdit, RzBtnEdt,
  RzCommon, RzDBLook, Buttons, ComCtrls, ToolWin, ImgList, DB, IBODataset, IniFiles,
  Referencement_DM, ReferencementType, DBCtrls, RzDBCmbo, cxGraphics,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, StrUtils,
  Grids, DBGrids,cxGridExportLink, cxRadioGroup, ReferencementResStr;


const
  CVERSION = '1.0';

var
  GAPPPATH : String;
  GPATHDB : String;
type
  TDataPath = class
    public
      Path : String;
      Filename : String;
      CompletePathFile : String;
  end;

  Tfrm_OdloMain = class(TForm)
    DatabaseODLO: TIB_Database;
    IbT_Maj: TIB_Transaction;
    Pan_Top: TPanel;
    Pan_Client: TPanel;
    gb_Rapport: TcxGroupBox;
    Pan_TopLeft: TPanel;
    gb_DB: TcxGroupBox;
    Pan_Topclient: TPanel;
    OD_DB: TOpenDialog;
    Edt_DBPath: TEdit;
    Lab_DB: TLabel;
    Nbt_SelectDB: TBitBtn;
    Lim_Main: TImageList;
    Pan_Rapportclient: TPanel;
    Pan_RapportBottom: TPanel;
    gb_Param: TcxGroupBox;
    Lab_SelectFourn: TLabel;
    Lab_SelectMarque: TLabel;
    Lab_SelectTVA: TLabel;
    gb_Actions: TcxGroupBox;
    Nbt_DoTraitement: TBitBtn;
    Pan_LeftBottom: TPanel;
    gb_liste: TcxGroupBox;
    Pan_Lstclient: TPanel;
    Lbx_FileList: TListBox;
    Pan_lstTop: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Nbt_ConnexionDB: TBitBtn;
    Que_FournList: TIBOQuery;
    Que_MarqueList: TIBOQuery;
    Que_TVAList: TIBOQuery;
    OD_File: TOpenDialog;
    Ds_FournList: TDataSource;
    dblu_Fournisseur: TDBLookupComboBox;
    dblu_Marque: TDBLookupComboBox;
    dblu_TVA: TDBLookupComboBox;
    Ds_MarqueList: TDataSource;
    Ds_TVAList: TDataSource;
    Que_TVAListTVA_ID: TIntegerField;
    Que_TVAListTVA_TAUX: TIBOFloatField;
    Lab_Etat: TLabel;
    Lab_EtatAffiche: TLabel;
    Lab_Progression: TLabel;
    pb_Etat: TProgressBar;
    ToolButton4: TToolButton;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxEditStyleController1: TcxEditStyleController;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    Ds_Rapport: TDataSource;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
    ToolButton5: TToolButton;
    ToolBar2: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    SD_File: TSaveDialog;
    Pan_Algol: TPanel;
    cxrg_Algol: TcxRadioGroup;
    Que_TypeComptableList: TIBOQuery;
    Ds_TypeComptableList: TDataSource;
    Lab_TypeComptable: TLabel;
    dblu_Typecomptable: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_SelectDBClick(Sender: TObject);
    procedure dblu_FournisseurCloseUp(Sender: TObject);
    procedure dblu_MarqueCloseUp(Sender: TObject);
    procedure Nbt_ConnexionDBClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure Nbt_DoTraitementClick(Sender: TObject);
    procedure cxGrid1DBTableView1CustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure ToolButton5Click(Sender: TObject);
    procedure Lbx_FileListDblClick(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
  private
    { Déclarations privées }
    function OpenDatabase(sPath : String) : Boolean;
    Procedure EnableGroupBox(bEnabled : Boolean);
    procedure OpenTable;
    procedure ReloadMarque(iFOUID : Integer);
    function CheckData : Boolean;
  public
    { Déclarations publiques }
    function StrTextToFloat(sText : String;Separator : Char) : Extended;

    function CheckField(sText : String;iLengthMax : Integer;sExceptionText :String;bObligatoire : Boolean = False) : String;
  end;

  procedure ProgressInfos(State : TProgressState;Progress : Integer = 0; sText : String = '');

var
  frm_OdloMain: Tfrm_OdloMain;

implementation

{$R *.dfm}

procedure ProgressInfos(State: TProgressState; Progress: Integer;
  sText: String);
begin
  With frm_OdloMain do
    case State of
      stStart: begin
        Lab_EtatAffiche.Caption := sText;
        pb_Etat.Position := 0;
      end;
      stProgress: begin
        Lab_EtatAffiche.Caption := 'Traitement en cours : ' + sText;
        pb_Etat.Position := Progress;
      end;
      stEnd: begin
        Lab_EtatAffiche.Caption := sText;
        pb_Etat.Position := 0;
      end;
    end;
    Application.ProcessMessages;
end;


function Tfrm_OdloMain.CheckData: Boolean;
begin
  Result := False;
  if Trim(dblu_Fournisseur.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner un fournisseur');
    Exit;
  end;

  if Trim(dblu_Marque.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner une marque');
    Exit;
  end;

  if Trim(dblu_TVA.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionenr une TVA');
    Exit;
  end;

  if Trim(dblu_Typecomptable.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionne un type comptable');
    Exit;
  end;

  if lbx_FileList.Count = 0 then
  begin
    Showmessage('Aucun fichier à traiter');
    Exit;
  end;
  
  Result := True;
end;

function Tfrm_OdloMain.CheckField(sText: String; iLengthMax: Integer;
  sExceptionText: String; bObligatoire: Boolean) : String;
var
  bExcept : Boolean;
begin
  Result := '';
  bExcept := False;
  if bObligatoire then
    if Length(Trim(sText)) <= 0 then
      bExcept := True;

  if Length(Trim(sText)) > iLengthMax then
    bExcept := True;

  if bExcept then
    raise Exception.Create(sExceptionText);
  Result := EnleveAccentsConversion(Trim(sText));
end;

procedure Tfrm_OdloMain.cxGrid1DBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  aValue : Variant;
begin
  aValue := (Sender as TcxGridDBTableView).DataController.GetItemByFieldName('iEtat').EditValue;
  if not VarIsNull(aValue) then
  begin
    if aValue = reErreur then
    begin
      ACanvas.Brush.Color := clRed;
      ACanvas.Font.Color := clWhite;
    end;
  end;
end;

procedure Tfrm_OdloMain.dblu_FournisseurCloseUp(Sender: TObject);
begin
 DM_Referencement.FOU_ID := Que_FournList.FieldByName('FOU_ID').AsInteger;
 ReloadMarque(DM_Referencement.FOU_ID);
end;

procedure Tfrm_OdloMain.dblu_MarqueCloseUp(Sender: TObject);
begin
  DM_Referencement.MRK_ID := Que_MarqueList.FieldByName('MRK_ID').AsInteger;
end;

procedure Tfrm_OdloMain.EnableGroupBox(bEnabled: Boolean);
begin
  gb_Param.Enabled := bEnabled;
  gb_liste.Enabled := bEnabled;
  gb_Actions.Enabled := bEnabled;
  gb_Rapport.Enabled := bEnabled;
  cxrg_Algol.Enabled := bEnabled;
end;

procedure Tfrm_OdloMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Try
    DM_Referencement.Free;
  Except
  End;
end;

procedure Tfrm_OdloMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Sauvegarde des données
  if gb_Param.Enabled then
    With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      WriteString('DB','PATH',GPATHDB);
      With DM_Referencement do
      begin
        WriteInteger('PARAM','FOUID',Que_FournList.FieldByName('FOU_ID').AsInteger);
        WriteInteger('PARAM','MRKID',Que_MarqueList.FieldByName('MRK_ID').AsInteger);
        WriteInteger('PARAM','TVAID',Que_TVAList.FieldByName('TVA_ID').AsInteger);
        WriteInteger('PARAM','TCTID',Que_TypeComptableList.FieldByName('TCT_ID').AsInteger);
      end;
    finally
      Free;
    end;
  CanClose := not bInProgress;
end;

procedure Tfrm_OdloMain.FormCreate(Sender: TObject);
begin
  Caption := 'ImportODLO v' + CVERSION;
  GAPPPATH := ExtractFilePath(Application.ExeName);

  DM_Referencement := TDM_Referencement.Create(self);
  With DM_Referencement do
  begin
    IBConnect := DatabaseODLO;
    IbTransaction := IbT_Maj;
  end;
  // Chargement des données
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    GPATHDB := ReadString('DB','PATH','');
    With DM_Referencement do
    begin
      FOU_ID := ReadInteger('PARAM','FOUID',0);
      MRK_ID := ReadInteger('PARAM','MRKID',0);
      TVA_ID := ReadInteger('PARAM','TVAID',0);
      EXE_ID := ReadInteger('PARAM','EXEID',0);
      TCT_ID := ReadInteger('PARAM','TCTID',0);
    end;
  finally
    Free;
  end;

  if Trim(GPATHDB) <> ''  then
  begin
    Edt_DBPath.Text := GPATHDB;
    Nbt_ConnexionDB.Click;
  end;

  // N'affiche le panneau Algol que si on le passe en paramètre
  if ParamCount > 0 then
    Pan_Algol.Visible := (ParamStr(1) = 'ALGOL');
end;

procedure Tfrm_OdloMain.Lbx_FileListDblClick(Sender: TObject);
begin
  Showmessage(TDataPath(Lbx_FileList.Items.Objects[Lbx_FileList.ItemIndex]).Path);
end;

procedure Tfrm_OdloMain.Nbt_ConnexionDBClick(Sender: TObject);
begin
  Try
    if OpenDatabase(GPATHDB) then
    begin
      EnableGroupBox(True);
      OpenTable;
    end;
  Except on E:Exception do
    Showmessage(E.Message);
  End;
end;

procedure Tfrm_OdloMain.Nbt_DoTraitementClick(Sender: TObject);
var
  i, j : Integer;
  iError : Integer;
  lstFile, lstDecoupe : TStringList;
  TabRefFile : TTabRefFile;
  MAG_ID, USR_ID : Integer;
  sFileName : String;
begin
  // Vérification avant traitement
  if not CheckData then
    Exit;

  // traitement des fichiers
  lstFile := TStringList.Create;
  lstDecoupe := TStringList.Create;
  With DM_Referencement do
  try
    // Initialisation
    MemD_RapportReferencement.Close;
    MemD_RapportReferencement.Open;
    MemD_EtqArt.Close;
    MemD_EtqArt.Open;

    bInProgress := True;
    EnableGroupBox(False);
    gb_DB.Enabled := False;

    IMP_NUM_MODELE  := CIMPNUM_ODLOMODELE;
    IMP_NUM_GRILLE  := CIMPNUM_ODLOGRILLE;
    IMP_NUM_COULEUR := CIMPNUM_ODLOCOULEUR;
    IMP_NUM_TAILLE  := CIMPNUM_ODLOTAILLE;

    for i := 0 to Lbx_FileList.Count - 1 do
    begin
      Lbx_FileList.ItemIndex := i;
      sFileName := ExtractFileName(Lbx_FileList.Items[i]);
      iError := 0;
      // Chargement du fichier en mémoire
      Lab_EtatAffiche.Caption := 'Chargement du fichier : ' + sFileName;
      Application.ProcessMessages;
      lstFile.LoadFromFile(TDataPath(Lbx_FileList.Items.Objects[i]).CompletePathFile);
      // convertion des lignes du fichiers pour la structure du tableau
      ProgressInfos(stStart,0,'Conversions des données du fichier : ' + sFileName);
      // Initialise le tableau
      SetLength(TabRefFile,0);
      DataInProgress := sFileName;
      // Démarre à 1 pour ne pas traiter la ligne d'entête
      for j := 1 to lstFile.Count - 1 do
      begin
        SetLength(TabRefFile,Length(TabRefFile) + 1);
        // Remplace les ;
        lstDecoupe.Text := StringReplace(lstFile[j],';',#13#10,[rfReplaceAll]);
        // remplace les tabulations
        lstDecoupe.Text := StringReplace(lstDecoupe.Text,#9,#13#10,[rfReplaceAll]);
        { 0: Saison Article -> collection;
          1: Ref -> RefFournisseur;
          2: Col -> Code couleur;
          3: Taille -> Libelle taille;
          4: Coloris -> Nom couleur;
          5: Designation -> Nom du modèle;
          6: Division -> Rayon;
          7: SubGroup -> Famille;
          8: Segment -> sous famille;
          9: Composition -> ...;
          10: Sexe -> Genre;
          11: PR -> Prix Achat ;
          12: PP -> Prix Vente;
          13: Taille_Ordre -> Ordre Taille;
          14: Code EAN -> CB;
          15: FEDAS -> ...;
          16: MatGrpTXT -> ...;
          17: Origin -> ...}
        try
          With TabRefFile[High(TabRefFile)] do
          begin
            IdentifiantMag           := '';
            NumBonReception          := '';
            Saison                   := 0;

            NomCollection            := CheckField(Uppercase(lstDecoupe[0]),32,RS_ERR_REFTYP_COLLECTION);

            FraisPortHT              := 0;
            FraisPortTVA             := 0;
            // Pour odlo RefFournisseur // + Code Couleur car ils ont des tarifs à la couleur
            IdentifiantUnique        := CheckField(Uppercase(lstDecoupe[1]),32,RS_ERR_REFTYP_IDENTIFIANT,True); // + Trim(lstDecoupe[2]);

            RefFournisseur           := CheckField(Uppercase(lstDecoupe[1]),64,RS_ERR_REFTYP_REFFOURN,True);
            // Pour Odlo Nom du modèle //+ Nom de la couleur afin de différencier les articles
            NomModele                := CheckField(Uppercase(lstDecoupe[5]),64,RS_ERR_REFTYP_MODELE,True); //  + ' / ' + Trim(lstDecoupe[4]);
            Rayon                    := CheckField(Uppercase(lstDecoupe[6]),64,RS_ERR_REFTYP_RAYON);
            Famille                  := CheckField(Uppercase(lstDecoupe[7]),64,RS_ERR_REFTYP_FAMILLE);
            SousFamille              := CheckField(Uppercase(lstDecoupe[8]),64,RS_ERR_REFTYP_SSFAMILLE);
            NomMarque                := dblu_Marque.Text;
            NomFournisseur           := dblu_Fournisseur.Text;
            Genre                    := CheckField(Uppercase(lstDecoupe[10]),32,RS_ERR_REFTYP_GENRE);
            TVA                      := 0;
            PrixAchatCatalogue       := ConvertFieldToCurr(Trim(lstDecoupe[11]));
            PrixAchatNet             := ConvertFieldToCurr(Trim(lstDecoupe[11]));
            PrixVente                := ConvertFieldToCurr(Trim(lstDecoupe[12]));
            IdGrilleTaille           := 'ODLO'; // Trim(lstDecoupe[1]);
            NomGrilleTaille          := 'ODLO'; // 'ODLO:' + Trim(lstDecoupe[5]); // Odlo: + Nom modèle
            IdTaille                 := '';
            NomTaille                := CheckField(Uppercase(lstDecoupe[3]),64,RS_ERR_REFTYP_NOMTAILLE,True);
            Odlo.TailleOrdre         := StrToInt(Trim(lstDecoupe[13]));
            IdCouleur                := CheckField(Uppercase(lstDecoupe[2]),32,RS_ERR_REFTYP_IDCOULEUR);
            NomCouleur               := CheckField(Uppercase(lstDecoupe[4]),64,RS_ERR_REFTYP_NOMCOULEUR,True);
            CodeCouleur              := CheckField(Uppercase(lstDecoupe[2]),64,RS_ERR_REFTYP_CODECOLEUR,True);
            CodeBarre                := CheckField(Uppercase(lstDecoupe[14]),64,RS_ERR_REFTYP_CODEBARRES);
            PrixAchatCatalogueTaille := PrixAchatCatalogue;
            PrixAchatNetTaille       := PrixAchatNet;
            PrixVenteTaille          := PrixVente;
            QteReceptionnee          := 0;
          end;
        Except on E:Exception do
          begin
            AddToRapport(sFileName,'',reErreur,'Ligne ' + IntToStr(j + 1) + ' : ' + E.Message);
            Application.ProcessMessages;
            SetLength(TabRefFile,Length(TabRefFile) - 1); // annule la ligne qui a été créée
            Inc(iError);
          end;
        end;
        ProgressInfos(stProgress,j,'Conversions des données du fichier : ' + sFileName);
      end; // for j

      // Traitement du tableau
      Try
        Referencement := 'ODLO';
        Mode := mtOdlo;
        IBConnect := DatabaseODLO;
        IbTransaction := IbT_Maj;
        // gestion du mode de création
        case cxrg_Algol.ItemIndex of
          0: ModeIntegration := miGenImportArtNormalMode;
          1: ModeIntegration := miGenImpotArtUpdateMode;
          2: ModeIntegration := miRefArtNormalMode;
          3: ModeIntegration := miRefArtUpdateMode;
          4: ModeIntegration := miCreateAll;
        end;

        FOU_ID := Que_FournList.FieldByName('FOU_ID').AsInteger;
        MRK_ID := Que_MarqueList.FieldByName('MRK_ID').AsInteger;
        TVA_ID := Que_TVAList.FieldByName('TVA_ID').AsInteger;
        TCT_ID := Que_TypeComptableList.FieldByName('TCT_ID').AsInteger;

        if DoTraitement(MAG_ID, USR_ID ,TabRefFile,False,True,@ProgressInfos) then
        begin
          if CountCreate >= 2000 then
            DoActiveLoop;

          With MemD_NewModele do
            if RecordCount > 0 then
            begin
              First;
              ProgressInfos(stStart,0,'Génération du rapport');
              for j := 0 to RecordCount - 1 do
              begin
                case FieldByName('Type').AsInteger of
                  0: AddToRapport(sFileName,FieldByName('ARF_NUMERO').AsString,reCustom,'Nouveau modèle créé');
                  1: begin
                    if not MemD_RapportReferencement.Locate('Mail;ChronoRecep',VarArrayOf([DataInProgress,FieldByName('ARF_NUMERO').AsString]),[]) then
                      AddToRapport(sFileName,FieldByName('ARF_NUMERO').AsString,reCustom,RS_TXT_REFSDM_MAJTARIFACH);
                  end;
                  2: begin
                    if not MemD_RapportReferencement.Locate('Mail;ChronoRecep',VarArrayOf([DataInProgress,FieldByName('ARF_NUMERO').AsString]),[]) then
                      AddToRapport(sFileName,FieldByName('ARF_NUMERO').AsString,reCustom,RS_TXT_REFSDM_MAJTARIFVTE);
                  end;
                end;
                Next;
                ProgressInfos(stProgress,j * 100 Div RecordCount, 'Génération du rapport');
              end;
            end;
          AddToRapport(sFileName,'',reCustom,'Traitement terminé - Nombre de lignes en erreur : ' + IntToStr(iError));
        end;
      Except on E:Exception do
        AddToRapport(sFileName,'',reErreur,'traitement du fichier Annulé : ' + E.Message);
      End;
    end; // for i
    ProgressInfos(stEnd,0, 'Traitement terminé');
  finally
    lstFile.Free;
    lstDecoupe.Free;
    bInProgress := False;
    EnableGroupBox(True);
    gb_DB.Enabled := True;

  end;
end;

procedure Tfrm_OdloMain.Nbt_SelectDBClick(Sender: TObject);
begin
  if OD_DB.Execute then
  begin
    GPATHDB := OD_DB.FileName;
    EnableGroupBox(False);
    DatabaseODLO.Disconnect;
  end;
  Edt_DBPath.Text := GPATHDB;
end;

function Tfrm_OdloMain.OpenDatabase(sPath: String): Boolean;
begin
  Result := False;
  With DatabaseODLO do
  begin
    Disconnect;
    Database := sPath;
    Try
      Connect;
    Except on E:Exception do
      raise Exception.Create('Echec de connexion à la base de données : ' + E.Message);
    End;
  end;
  Result := True;
end;

procedure Tfrm_OdloMain.OpenTable;
begin
  With DM_Referencement do
  begin
    With Que_FournList do
    begin
      Close;
      Open;

      if FOU_ID <> 0 then
        if Locate('FOU_ID',FOU_ID,[]) then
          dblu_Fournisseur.KeyValue := FOU_ID;
    end;

    ReloadMarque(FOU_ID);

    With Que_TVAList do
    begin
      Close;
      Open;

      if TVA_ID <> 0 then
        If Locate('TVA_ID',TVA_ID,[]) then
          dblu_TVA.KeyValue := TVA_ID;
    end;

    With Que_TypeComptableList do
    begin
      Close;
      Open;
      if TCT_ID <> 0 then
        if Locate('TCT_ID',TCT_ID,[]) then
          dblu_Typecomptable.KeyValue := TCT_ID;
    end;
  end;
end;

procedure Tfrm_OdloMain.ReloadMarque(iFOUID: Integer);
begin
  With Que_MarqueList do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger := iFOUID;
    Open;

    With DM_Referencement do
      if MRK_ID <> 0 then
        if Locate('MRK_ID',MRK_ID,[]) then
          dblu_Marque.KeyValue := MRK_ID;
  end;
end;

function Tfrm_OdloMain.StrTextToFloat(sText: String; Separator: Char): Extended;
begin
  try
    case Separator of
     '.' : Result := StrToFloat(StringReplace(sText,',',Separator,[]));
     ',' : Result := StrToFloat(StringReplace(sText,'.',Separator,[]));
    end;
  Except on E:Exception do
    raise Exception.Create('StrTextToFloat -> ' + E.Message);
  end;
end;

procedure Tfrm_OdloMain.ToolButton2Click(Sender: TObject);
var
  Data : TDataPath;
begin
  if OD_File.Execute then
  begin
    if Lbx_FileList.Items.IndexOf(ExtractFileName(OD_File.FileName)) = -1 then
    begin
      Data := TDataPath.Create;
      Data.Path := ExtractFilePath(OD_File.FileName);
      Data.Filename := ExtractFileName(OD_File.FileName);
      Data.CompletePathFile := OD_File.FileName;
      Lbx_FileList.Items.AddObject(Data.Filename,Data);
    end
    else
      Showmessage('Fichier déjà présent dans la liste');
  end;
end;

procedure Tfrm_OdloMain.ToolButton3Click(Sender: TObject);
begin
  if Lbx_FileList.Count > 0 then
  begin
    TDataPath(Lbx_FileList.Items.Objects[Lbx_FileList.ItemIndex]).Free;
    Lbx_FileList.DeleteSelected;
  end;
end;

procedure Tfrm_OdloMain.ToolButton5Click(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to Lbx_FileList.Count - 1 do
  begin
    if Assigned(Lbx_FileList.Items.Objects[i]) then
      TDataPath(Lbx_FileList.Items.Objects[i]).Free;
  end;
  Lbx_FileList.Clear;
end;

procedure Tfrm_OdloMain.ToolButton7Click(Sender: TObject);
begin
  if SD_File.Execute then
    ExportGridToExcel(SD_File.FileName,cxGrid1);
end;

end.
