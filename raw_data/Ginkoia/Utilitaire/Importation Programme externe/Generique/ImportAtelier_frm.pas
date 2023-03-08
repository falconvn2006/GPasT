unit ImportAtelier_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, MainImport_DM, ComCtrls, IBDatabase, IBQuery,
  IBStoredProc, ChxMag_frm, ShellApi, DB, Grids, DBGrids;

type
  Tfrm_ImportAtelier = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_AtelierCsv: TBitBtn;
    Pan_Client: TPanel;
    Chk_AtelierEntete: TCheckBox;
    Gbx_Progression: TGroupBox;
    Lab_Forfait: TLabel;
    Lab_Nomenclature: TLabel;
    Lab_FicheAtelier: TLabel;
    Lab_LigneAtelier: TLabel;
    Lab_FicheArt: TLabel;
    Lab_Materiel: TLabel;
    Chk_PointDeControle: TCheckBox;
    Lab_SavPC: TLabel;
    Ds_: TDataSource;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_AtelierCsvClick(Sender: TObject);
  private
    FFileDir: String;
    lstMainLogs : TStringList;
    FProgress: TProgressBar;
    FEditDir: TEdit;
    FBaseDir: TEdit;
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure DoImportCsvFile;
    procedure DoImportToDatabase(AMagID : Integer);

    function CsvStrToFloat(sText : String) : single;
    function CsvStrToInt(sText : String) : Integer;
    function CsvStrToDateTime(sText : String) : TDateTime;

    property FileDirEdit : TEdit read FEditDir write FEditDir;
    property BaseDirEdit : TEdit read FBaseDir write FBaseDir;
    property ProgressBar : TProgressBar read FProgress write FProgress;

  end;

var
  frm_ImportAtelier: Tfrm_ImportAtelier;

implementation

{$R *.dfm}

{ Tfrm_ImportAtelier }

function Tfrm_ImportAtelier.CsvStrToDateTime(sText: String): TDateTime;
begin
  try
    Result := 0;
    if (Trim(LowerCase(sText)) <> 'null') and (Trim(sText) <> '')  then
      Result := StrToDateTime(sText);

  Except on E:Exception do
    raise Exception.Create('CsvStrToDateTime -> ' + E.Message);
  end;
end;

function Tfrm_ImportAtelier.CsvStrToFloat(sText: String): single;
var
  sTmp : String;
  i : Integer;
begin
  sTmp := '';
  sText := StringReplace(Trim(sText),'.',DecimalSeparator,[rfReplaceAll]);
  for i := 0 to Length(sText) do
    if sText[i] in ['0'..'9','.',','] then
      sTmp := sTmp + sText[i];
  Result := StrToFloat(sTmp)
end;

function Tfrm_ImportAtelier.CsvStrToInt(sText: String): Integer;
var
  sTmp : String;
  i : Integer;
begin
  sTmp := '';
  for i := 1 to Length(sText) do
    if sText[i] in ['0'..'9'] then
      sTmp := sTmp + sText[i];

  Result := StrToInt(Trim(sTmp));
end;

Procedure Tfrm_ImportAtelier.DoImportCsvFile;
var
  lstLogs : TStringList;
  lstCsvFile, lstCsvLigne, lstTmp : TStringList;

  i : Integer;
  iStartCsv : Integer;

begin
  lstLogs := TStringList.Create;
  FFileDir := IncludeTrailingBackslash(FileDirEdit.Text);
  With DM_MainImport do
  try
    // Vérification que les fichiers existe
    if not FileExists(FFileDir + 'SavForfait.csv') then
      lstLogs.Add('Fichier SavForfait.csv inéxistant');

    if not FileExists(FFileDir + 'SavNomenclature.csv') then
      lstLogs.Add('Fichier SavNomenclature.csv inéxistant');

    if not FileExists(FFileDir + 'SavMateriel.csv') then
      lstLogs.Add('Fichier SavMateriel.csv inéxistant');

    if not FileExists(FFileDir + 'SavFicheE.csv') then
      lstLogs.Add('Fichier SavFicheE.csv inéxistant');

    if not FileExists(FFileDir + 'SavFicheL.csv') then
      lstLogs.Add('Fichier SavFicheL.csv inéxistant');

    if not FileExists(FFileDir + 'SavFicheART.csv') then
      lstLogs.Add('Fichier SavFicheART.csv inéxistant');

    if Chk_PointDeControle.Checked then
    begin
      if not FileExists(FFileDir + 'SavFichePC.csv') then
        lstLogs.Add('Fichier SavFichePC.csv inéxistant');

      if not FileExists(FFileDir + 'SavPC.csv') then
        lstLogs.Add('Fichier SavPC.csv inéxistant');

      if not FileExists(FFileDir + 'SavPCL.csv') then
        lstLogs.Add('Fichier SavPCL.csv inéxistant');
    end;

    if lstLogs.Count = 0 then
    begin
      // Avec entête ?
      if Chk_AtelierEntete.Checked then
        iStartCsv := 1
      else
        iStartCsv := 0;

      lstCsvFile := TStringList.Create;
      lstCsvLigne := TStringList.Create;
      lstTmp := TStringList.Create;
      try

      {$REGION 'Traitement du fichier SavForfait'}
        ///* Forfait + Forfait Ligne */
//        SELECT FOR_ID, FOR_NOM, FOR_PRIX, FOR_DUREE, FOL_ID, CBI_CB, FOL_QTE
//        From SAVFORFAIT
//        join K on K_ID = FOR_ID and K_Enabled = 1
//        Left Join SAVFORFAITL on FOL_FORID = FOR_ID
//        Left Join ARTREFERENCE on ARF_ARTID = FOL_ARTID
//        Left join ARTCODEBARRE on ARF_ID = CBI_ARFID and CBI_TGFID = FOL_TGFID and CBI_COUID = FOL_COUID
//        Where FOR_ID <> 0
        Lab_Forfait.Caption := 'Forfait : Traitement du fichier SavForfait.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavForfait.csv');

        cds_Forfait.EmptyDataSet;
        cds_ForfaitLigne.EmptyDataSet;

        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          try
            lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);

            if not cds_Forfait.Locate('FOR_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
            begin
              cds_Forfait.Append;
              cds_Forfait.FieldByName('FOR_ID').AsInteger    := CsvStrToInt(lstCsvLigne[0]);
              cds_Forfait.FieldByName('FOR_NOM').AsString    := Trim(lstCsvLigne[1]);
              cds_Forfait.FieldByName('FOR_PRIX').AsCurrency := CsvStrToFloat(lstCsvLigne[2]);
              cds_Forfait.FieldByName('FOR_DUREE').AsFloat   := CsvStrToFloat(lstCsvLigne[3]);
              cds_Forfait.FieldByName('NEW_FORID').AsInteger := -1;
              cds_Forfait.Post;
            end;

            if (Trim(lstCsvLigne[4]) <> '') and (LowerCase(Trim(lstCsvLigne[4])) <> 'null') then
              if not cds_ForfaitLigne.Locate('FOL_ID;FOL_FORID',VarArrayOf([CsvStrToInt(lstCsvLigne[4]),CsvStrToInt(lstCsvLigne[0])]),[]) then
              begin
                cds_ForfaitLigne.Append;
                cds_ForfaitLigne.FieldByName('FOL_ID').AsInteger    := CsvStrToInt(lstCsvLigne[4]);
                cds_ForfaitLigne.FieldByName('CBI_CB').AsString     := Trim(lstCsvLigne[5]);
                cds_ForfaitLigne.FieldByName('FOL_QTE').AsInteger   := CsvStrToInt(lstCsvLigne[6]);
                cds_ForfaitLigne.FieldByName('FOL_FORID').AsInteger := cds_Forfait.FieldByName('FOR_ID').AsInteger;
                cds_ForfaitLigne.FieldByName('NEW_FOLID').AsInteger := -1;
                cds_ForfaitLigne.Post;
              end;
          Except on E:Exception do
            begin
              lstLogs.Add('SavForfait - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
              cds_Forfait.Cancel;
              cds_ForfaitLigne.Cancel;
            end;
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end; // for
        Lab_Forfait.Caption := 'Forfait : FINI';

      {$ENDREGION}

      {$REGION 'Traitement du fichier SavNomenclature'}
        ///* Nomenclature */
//        SELECT PT1_ID, PT1_PICTO, PT1_ORDREAFF, PT1_NOM,
//               PT2_ID, PT2_NOM, PT2_FORFAIT, PT2_FORID, PT2_DUREE, PT2_PICTO,
//               PT2_ORDREAFF, PT2_LIBELLE,
//               TXH_ID, TXH_NOM, TXH_PRIX,
//               Min(CBI_CB)
//        From SAVPT2
//        join K on K_ID = PT2_ID and K_Enabled = 1
//        Join SAVPT1 on PT2_PT1ID = PT1_ID
//        join SAVTAUXH on PT2_TXHID = TXH_ID
//        Join ARTREFERENCE on PT2_ARTID = ARF_ARTID
//        join ARTCODEBARRE on (ARF_ID = CBI_ARFID and CBI_TYPE = 1)
//        Group By PT1_ID, PT1_PICTO, PT1_ORDREAFF, PT1_NOM, PT2_ID, PT2_NOM, PT2_FORFAIT,
//                 PT2_FORID, PT2_DUREE, PT2_PICTO, PT2_ORDREAFF, PT2_LIBELLE,
//                 TXH_ID, TXH_NOM, TXH_PRIX

        Lab_Nomenclature.Caption := 'Nomenclature : Traitement du fichier SavNomenclature.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavNomenclature.csv');

        cds_PT1.EmptyDataSet;
        cds_PT2.EmptyDataSet;
        cds_TauxH.EmptyDataSet;

        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          try
            lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);

            if not cds_PT1.Locate('PT1_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
            begin
              cds_PT1.Append;
              cds_PT1.FieldByName('PT1_ID').AsInteger := CsvStrToInt(lstCsvLigne[0]);
              cds_PT1.FieldByName('PT1_PICTO').AsString := Trim(lstCsvLigne[1]);
              cds_PT1.FieldByName('PT1_ORDREAFF').AsInteger := CsvStrToInt(lstCsvLigne[2]);
              cds_PT1.FieldByName('PT1_NOM').AsString := Trim(lstCsvLigne[3]);
              cds_PT1.FieldByName('NEW_PT1ID').AsInteger := -1;
              cds_PT1.Post;
            end;

            if not cds_PT2.Locate('PT2_ID;PT2_PT1ID',VarArrayOf([CsvStrToInt(lstCsvLigne[4]),CsvStrToInt(lstCsvLigne[0])]),[]) then
            begin
              cds_PT2.Append;
              cds_PT2.FieldByName('PT2_ID').AsInteger := CsvStrToInt(lstCsvLigne[4]);
              cds_PT2.FieldByName('PT2_PT1ID').AsInteger := cds_PT1.FieldByName('PT1_ID').AsInteger;
              cds_PT2.FieldByName('PT2_NOM').AsString := Trim(lstCsvLigne[5]);
              cds_PT2.FieldByName('PT2_FORFAIT').AsInteger := CsvStrToInt(lstCsvLigne[6]);
              cds_PT2.FieldByName('PT2_FORID').AsInteger := CsvStrToInt(lstCsvLigne[7]);
              cds_PT2.FieldByName('PT2_DUREE').AsFloat := CsvStrToFloat(lstCsvLigne[8]);
              cds_PT2.FieldByName('PT2_PICTO').AsString := Trim(lstCsvLigne[9]);
              cds_PT2.FieldByName('PT2_ORDREAFF').AsInteger := CsvStrToInt(lstCsvLigne[10]);
              cds_PT2.FieldByName('PT2_LIBELLE').AsString := Trim(lstCsvLigne[11]);
              cds_PT2.FieldByName('CBI_CB').AsString := Trim(lstCsvLigne[15]);
              cds_PT2.FieldByName('NEW_PT2ID').AsInteger := -1;
              cds_PT2.FieldByName('PT2_TXHID').AsInteger := CsvStrToInt(lstCsvLigne[12]);
              cds_PT2.Post;
            end;

            if not cds_TauxH.Locate('TXH_ID',CsvStrToInt(lstCsvLigne[12]),[]) then
            begin
              cds_TauxH.Append;
              cds_TauxH.FieldByName('TXH_ID').AsInteger := CsvStrToInt(lstCsvLigne[12]);
              cds_TauxH.FieldByName('TXH_NOM').AsString := Trim(lstCsvLigne[13]);
              cds_TauxH.FieldByName('TXH_PRIX').AsCurrency := CsvStrToFloat(lstCsvLigne[14]);
              cds_TauxH.FieldByName('NEW_TXHID').AsInteger := -1;
              cds_TauxH.Post;
            end;
          Except on E:Exception do
            begin
              lstLogs.Add('SavNomenclature -> Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
              cds_PT1.Cancel;
              cds_PT2.Cancel;
              cds_TauxH.Cancel;
            end;
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end;  // for
        Lab_Nomenclature.Caption := 'Nomenclature : FINI';

      {$ENDREGION}

      {$REGION 'Traitement du fichier SavMateriel'}
        ///* Matériel + Type Matériel */
        //SELECT MAT_ID, MAT_CLTID, MAT_MRKID,  Min(CBI_CB),
        //       MAT_NOM, MAT_SERIE, MAT_COULEUR, MAT_COMMENT, MAT_DATEACHAT,
        //       MAT_ARCHIVER, MAT_REFMRK, MAT_CHRONO,
        //       TYM_ID, TYM_NOM
        //From SAVMAT
        //Join K on K_ID = MAT_ID and K_Enabled = 1
        //Join SAVTYPMAT on MAT_TYMID = TYM_ID
        //Left Join ARTREFERENCE on MAT_ARTID = ARF_ARTID
        //Left join ARTCODEBARRE on (ARF_ID = CBI_ARFID and CBI_TYPE = 1)
        //Where MAT_ID <> 0
        //Group by MAT_ID, MAT_CLTID, MAT_MRKID, MAT_NOM, MAT_SERIE, MAT_COULEUR,
        //         MAT_COMMENT, MAT_DATEACHAT, MAT_ARCHIVER, MAT_REFMRK, MAT_CHRONO,
        //         TYM_ID, TYM_NOM

        Lab_Materiel.Caption := 'Materiel : Traitement du fichier SavMateriel.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavMateriel.csv');

        cds_SavMat.EmptyDataSet;
        cds_SavTypMat.EmptyDataSet;
        lstCsvLigne.Text := '';
        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          lstCsvLigne.Text := lstCsvLigne.Text + lstCsvFile[i];

          lstTmp.Text := StringReplace(lstCsvLigne.Text,#13#10,#32,[rfReplaceAll]);
          lstTmp.Text := StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);

          if lstTmp.Count > 13 then
          begin
            lstCsvLigne.Text := lstTmp.Text; //StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);
            try
              if not cds_SavMat.Locate('MAT_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
              begin
                cds_SavMat.Append;
                cds_SavMat.FieldByName('MAT_ID').AsInteger := CsvStrToInt(lstCsvLigne[0]);
                cds_SavMat.FieldByName('MAT_CLTID').AsInteger := CsvStrToInt(lstCsvLigne[1]);
                cds_SavMat.FieldByName('MAT_MRKID').AsInteger := CsvStrToInt(lstCsvLigne[2]);
                cds_SavMat.FieldByName('CBI_CB').AsString := Trim(lstCsvLigne[3]);
                cds_SavMat.FieldByName('MAT_NOM').AsString    := Trim(lstCsvLigne[4]);
                cds_SavMat.FieldByName('MAT_SERIE').AsString  := Trim(lstCsvLigne[5]);
                cds_SavMat.FieldByName('MAT_COULEUR').AsString := Trim(lstCsvLigne[6]);
                cds_SavMat.FieldByName('MAT_COMMENT').AsString := Trim(lstCsvLigne[7]);
                cds_SavMat.FieldByName('MAT_DATEACHAT').AsDateTime := CsvStrToDateTime(Trim(lstCsvLigne[8]));
                cds_SavMat.FieldByName('MAT_ARCHIVER').AsInteger := CsvStrToInt(lstCsvLigne[9]);
                cds_SavMat.FieldByName('MAT_REFMRK').AsString    := Trim(lstCsvLigne[10]);
                cds_SavMat.FieldByName('MAT_CHRONO').AsString    := Trim(lstCsvLigne[11]);
                cds_SavMat.FieldByName('MAT_TYMID').AsInteger    := CsvStrToInt(lstCsvLigne[12]);
                if lstCsvLigne.Count >= 15 then
                  cds_SavMat.FieldByName('MRK_NOM').AsString       := Trim(lstCsvLigne[14])
                else
                  cds_SavMat.FieldByName('MRK_NOM').AsString       := '';
                cds_SavMat.FieldByName('NEW_MATID').AsInteger := -1;
                cds_SavMat.Post;
              end;

              if not cds_SavTypMat.Locate('TYM_ID',CsvStrToInt(lstCsvLigne[12]),[]) then
              begin
                cds_SavTypMat.Append;
                cds_SavTypMat.FieldByName('TYM_ID').AsInteger := CsvStrToInt(lstCsvLigne[12]);
                if lstCsvLigne.Count >= 14  then
                  cds_SavTypMat.FieldByName('TYM_NOM').AsString := Trim(lstCsvLigne[13])
                else
                  cds_SavTypMat.FieldByName('TYM_NOM').AsString := '';
                cds_SavTypMat.FieldByName('NEW_TYMID').AsInteger := -1;
                cds_SavTypMat.Post;
              end;
            Except on E:Exception do
              begin
                lstLogs.Add('SavMateriel - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavMat.Cancel;
                cds_SavTypMat.Cancel;
              end;
            end;
          lstCsvLigne.Text := '';
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end;  // for
        Lab_Materiel.Caption := 'Materiel : FINI';

      {$ENDREGION}

      {$REGION 'Traitement du fichier SavFicheE'}

        ///* Fiche Atelier + Type + Taux */
        //SELECT SAV_ID, SAV_CLTID, SAV_MATID, SAV_CHRONO, SAV_DTCREATION, SAV_DEBUT, SAV_FIN,
        //       SAV_REMMO, SAV_REMART, SAV_REM, SAV_IDENT, SAV_USRID, SAV_LIMITE,
        //       SAV_MAGID, SAV_ETAT, SAV_DATEREPRISE, SAV_DATEPLANNING,
        //       SAV_COMMENT, SAV_ORDREAFF, SAV_DUREEGLOB, SAV_DUREE, SAV_TXHID, SAV_PXTAUX,
        //       SAV_USRIDENCHARGE, SAV_PLACE,
        //       STY_ID, STY_NOM
        //From SAVFICHEE
        //Join K on K_ID = SAV_ID and K_Enabled = 1
        //Join SAVTYPE on SAV_STYID = STY_ID

        Lab_FicheAtelier.Caption := 'Fiches atelier : Traitement du fichier SavFicheE.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavFicheE.csv');

        cds_SavFicheE.EmptyDataSet;
        cds_SavType.EmptyDataSet;
        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          lstCsvLigne.Text := lstCsvLigne.Text + lstCsvFile[i];

          lstTmp.Text := StringReplace(lstCsvLigne.Text,#13#10,#32,[rfReplaceAll]);
          lstTmp.Text := StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);

          if lstTmp.Count > 25 then
          begin
            lstCsvLigne.Text := lstTmp.Text; //StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);
            try
//              if not cds_SavFicheE.Locate('SAV_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
              begin
                cds_SavFicheE.Append;
                cds_SavFicheE.FieldByName('SAV_ID').AsInteger            := CsvStrToInt(lstCsvLigne[0]);
                cds_SavFicheE.FieldByName('SAV_CLTID').AsInteger         := CsvStrToInt(lstCsvLigne[1]);
                cds_SavFicheE.FieldByName('SAV_MATID').AsInteger         := CsvStrToInt(lstCsvLigne[2]);
                cds_SavFicheE.FieldByName('SAV_CHRONO').AsString         := Trim(lstCsvLigne[3]);
                cds_SavFicheE.FieldByName('SAV_DTCREATION').AsDateTime   := CsvStrToDateTime(lstCsvLigne[4]);
                cds_SavFicheE.FieldByName('SAV_DEBUT').AsDateTime        := CsvStrToDateTime(lstCsvLigne[5]);
                cds_SavFicheE.FieldByName('SAV_FIN').AsDateTime          := CsvStrToDateTime(lstCsvLigne[6]);
                cds_SavFicheE.FieldByName('SAV_REMMO').AsFloat           := CsvStrToFloat(lstCsvLigne[7]);
                cds_SavFicheE.FieldByName('SAV_REMART').AsFloat          := CsvStrToFloat(lstCsvLigne[8]);
                cds_SavFicheE.FieldByName('SAV_REM').AsFloat             := CsvStrToFloat(lstCsvLigne[9]);
                cds_SavFicheE.FieldByName('SAV_IDENT').AsString          := Trim(lstCsvLigne[10]);
                cds_SavFicheE.FieldByName('SAV_USRID').AsInteger         := CsvStrToInt(lstCsvLigne[11]);
                cds_SavFicheE.FieldByName('SAV_LIMITE').AsDateTime       := CsvStrToDateTime(lstCsvLigne[12]);
                cds_SavFicheE.FieldByName('SAV_MAGID').AsInteger         := CsvStrToInt(lstCsvLigne[13]);
                cds_SavFicheE.FieldByName('SAV_ETAT').AsInteger          := CsvStrToInt(lstCsvLigne[14]);
                cds_SavFicheE.FieldByName('SAV_DATEREPRISE').AsDateTime  := CsvStrToDateTime(lstCsvLigne[15]);
                cds_SavFicheE.FieldByName('SAV_DATEPLANNING').AsDateTime := CsvStrToDateTime(lstCsvLigne[16]);
                cds_SavFicheE.FieldByName('SAV_COMMENT').AsString        := Trim(lstCsvLigne[17]);
                cds_SavFicheE.FieldByName('SAV_ORDREAFF').AsInteger      := CsvStrToInt(lstCsvLigne[18]);
                cds_SavFicheE.FieldByName('SAV_DUREEGLOB').AsInteger     := CsvStrToInt(lstCsvLigne[19]);
                cds_SavFicheE.FieldByName('SAV_DUREE').AsFloat           := CsvStrToFloat(lstCsvLigne[20]);
                cds_SavFicheE.FieldByName('SAV_TXHID').AsInteger         := CsvStrToInt(lstCsvLigne[21]);
                cds_SavFicheE.FieldByName('SAV_PXTAUX').AsFloat          := CsvStrToFloat(lstCsvLigne[22]);
                cds_SavFicheE.FieldByName('SAV_USRIDENCHARGE').AsInteger := CsvStrToInt(lstCsvLigne[23]);
                cds_SavFicheE.FieldByName('SAV_PLACE').AsString          := Trim(lstCsvLigne[24]);
                cds_SavFicheE.FieldByName('SAV_STYID').AsInteger         := CsvStrToInt(lstCsvLigne[25]);
                cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger         := -1;
                cds_SavFicheE.Post;
              end;

              if (Trim(lstCsvLigne[25]) <> '') and (LowerCase(Trim(lstCsvLigne[25])) <> 'null') then
                if not cds_SavType.Locate('STY_ID',CsvStrToInt(lstCsvLigne[25]),[]) then
                begin
                  cds_SavType.Append;
                  cds_SavType.FieldByName('STY_ID').AsInteger := CsvStrToInt(lstCsvLigne[25]);
                  if lstCsvLigne.Count > 26 then
                    cds_SavType.FieldByName('STY_NOM').AsString := Trim(lstCsvLigne[26])
                  else
                    cds_SavType.FieldByName('STY_NOM').AsString := '';
                  cds_SavType.FieldByName('NEW_STYID').AsInteger := -1;
                  cds_SavType.Post;
                end;
            Except on E:Exception do
              begin
                lstLogs.Add('SavFicheE - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavFicheE.Cancel;
                cds_SavType.Cancel;
              end;
            end;
            lstCsvLigne.Text := '';
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end;

        Lab_FicheAtelier.Caption := 'Fiches atelier : FINI';
      {$ENDREGION}

      {$REGION 'Traitement du fichier SavFicheL'}
        ///* Ligne fiche Atelier */
        //Select SAL_ID, SAL_SAVID, SAL_PT2ID, SAL_FORID, SAL_NOM, SAL_COMMENT, SAL_DUREE, SAL_TXHID,
        //       SAL_REMISE, SAL_PXTOT, SAL_USRID, SAL_TERMINE, SAL_PXBRUT
        //From SAVFICHEL
        //join K on K_ID = SAL_ID and K_Enabled = 1

        Lab_LigneAtelier.Caption := 'Lignes fiches atelier : Traitement du fichier SavFicheL.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavFicheL.csv');

        cds_SavFicheL.EmptyDataSet;
        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          lstCsvLigne.Text := lstCsvLigne.Text + lstCsvFile[i];

          lstTmp.Text := StringReplace(lstCsvLigne.Text,#13#10,#32,[rfReplaceAll]);
          lstTmp.Text := StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);

          if lstTmp.Count > 12 then
          begin
            lstCsvLigne.Text := lstTmp.Text; //StringReplace(lstTmp.Text,';',#13#10,[rfReplaceAll]);
            try
       //       if not cds_SavFicheL.Locate('SAL_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
              begin
                cds_SavFicheL.Append;
                cds_SavFicheL.FieldByName('SAL_ID').AsInteger      := CsvStrToInt(lstCsvLigne[0]);
                cds_SavFicheL.FieldByName('SAL_SAVID').AsInteger   := CsvStrToInt(lstCsvLigne[1]);
                cds_SavFicheL.FieldByName('SAL_PT2ID').AsInteger   := CsvStrToInt(lstCsvLigne[2]);
                cds_SavFicheL.FieldByName('SAL_FORID').AsInteger   := CsvStrToInt(lstCsvLigne[3]);
                cds_SavFicheL.FieldByName('SAL_NOM').AsString      := Trim(lstCsvLigne[4]);
                cds_SavFicheL.FieldByName('SAL_COMMENT').AsString  := Trim(lstCsvLigne[5]);
                cds_SavFicheL.FieldByName('SAL_DUREE').AsFloat     := CsvStrToFloat(lstCsvLigne[6]);
                cds_SavFicheL.FieldByName('SAL_TXHID').AsInteger   := CsvStrToInt(lstCsvLigne[7]);
                cds_SavFicheL.FieldByName('SAL_REMISE').AsFloat    := CsvStrToFloat(lstCsvLigne[8]);
                cds_SavFicheL.FieldByName('SAL_PXTOT').AsFloat     := CsvStrToFloat(lstCsvLigne[9]);
                cds_SavFicheL.FieldByName('SAL_USRID').AsInteger   := CsvStrToInt(lstCsvLigne[10]);
                cds_SavFicheL.FieldByName('SAL_TERMINE').AsInteger := CsvStrToInt(lstCsvLigne[11]);
                cds_SavFicheL.FieldByName('SAL_PXBRUT').AsFloat    := CsvStrToFloat(lstCsvLigne[12]);
                cds_SavFicheL.FieldByName('NEW_SALID').AsInteger   := -1;
                cds_SavFicheL.Post;
              end;
            Except on E:Exception do
              begin
                lstLogs.Add('SavFicheL - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavFicheL.Cancel;
              end;
            end;
            lstCsvLigne.Text := '';
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end;
        Lab_LigneAtelier.Caption := 'Lignes fiches atelier : FINI';
      {$ENDREGION}

      {$REGION 'Traitement du ficheir SavFicheART'}
        ///* SavFicheARt */
        //Select SAA_ID, CBI_CB, SAA_PU, SAA_REMISE, SAA_QTE, SAA_SAVID, SAA_PXTOT, SAA_SALID, SAA_TYPID
        //from SAVFICHEART
        //join K on K_ID = SAA_ID and K_Enabled = 1
        //join ARTREFERENCE on ARF_ARTID = SAA_ARTID
        //join ARTCODEBARRE on ARF_ID = CBI_ARFID and CBI_TGFID = SAA_TGFID and CBI_COUID = SAA_COUID

        Lab_FicheArt.Caption := 'Articles fiches atelier : Traitement du fichier SavFicheART.csv en cours ...';
        lstCsvFile.LoadFromFile(FFileDir + 'SavFicheART.csv');

        cds_SavFicheART.EmptyDataSet;

        for i := iStartCsv to lstCsvFile.Count - 1 do
        begin
          try
            lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);

            if not cds_SavFicheART.Locate('SAA_ID',CsvStrToInt(lstCsvLigne[0]),[]) then
            begin
              cds_SavFicheART.Append;
              cds_SavFicheART.FieldByName('SAA_ID').AsInteger := CsvStrToInt(lstCsvLigne[0]);
              cds_SavFicheART.FieldByName('CBI_CB').AsString  := Trim(lstCsvLigne[1]);
              cds_SavFicheART.FieldByName('SAA_PU').AsFloat   := CsvStrToFloat(lstCsvLigne[2]);
              cds_SavFicheART.FieldByName('SAA_REMISE').AsFloat := CsvStrToFloat(lstCsvLigne[3]);
              cds_SavFicheART.FieldByName('SAA_QTE').AsInteger := CsvStrToInt(lstCsvLigne[4]);
              cds_SavFicheART.FieldByName('SAA_SAVID').AsInteger := CsvStrToInt(lstCsvLigne[5]);
              cds_SavFicheART.FieldByName('SAA_PXTOT').AsFloat := CsvStrToFloat(lstCsvLigne[6]);
              cds_SavFicheART.FieldByName('SAA_SALID').AsInteger := CsvStrToInt(lstCsvLigne[7]);
              cds_SavFicheART.FieldByName('SAA_TYPID').AsInteger := CsvStrToInt(lstCsvLigne[8]);
              cds_SavFicheART.FieldByName('NEW_SAAID').AsInteger := -1;
              cds_SavFicheART.Post;
            end;
          Except on E:Exception do
            begin
              lstLogs.Add('SavFicheART - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
              cds_SavFicheArt.Cancel;
            end;
          end;
          ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
          Application.ProcessMessages;
        end;
        Lab_FicheArt.Caption := 'Articles fiches atelier : FINI';

      {$ENDREGION}

      {$REGION 'Traitement des fichiers PC'}
        if Chk_PointDeControle.Checked then
        begin
          Lab_SavPC.Caption := 'Point de controle : (Etape 1 sur 3) Traitement du fichier SavFichePC.csv en cours ...';
          lstCsvFile.LoadFromFile(FFileDir + 'SavFichePC.csv');

          cds_SavFichePC.EmptyDataSet;

          for i := iStartCsv to lstCsvFile.Count - 1 do
          begin
            try
              lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);
            Except on E:Exception do
              begin
                lstLogs.Add('SavFichePC - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavFichePC.Cancel;
              end;
            end;
            ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
            Application.ProcessMessages;
          end;

          Lab_SavPC.Caption := 'Point de controle : (Etape 2 sur 3) Traitement du fichier SavPC.csv en cours ...';
          lstCsvFile.LoadFromFile(FFileDir + 'SavPC.csv');

          cds_SavPC.EmptyDataSet;

          for i := iStartCsv to lstCsvFile.Count - 1 do
          begin
            try
              lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);
            Except on E:Exception do
              begin
                lstLogs.Add('SavPC - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavPC.Cancel;
              end;
            end;
            ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
            Application.ProcessMessages;
          end;

          Lab_SavPC.Caption := 'Point de controle : (Etape 3 sur 3) Traitement du fichier SavPCL.csv en cours ...';
          lstCsvFile.LoadFromFile(FFileDir + 'SavPCL.csv');

          cds_SavPCL.EmptyDataSet;

          for i := iStartCsv to lstCsvFile.Count - 1 do
          begin
            try
              lstCsvLigne.Text := StringReplace(lstCsvFile[i],';',#13#10,[rfReplaceAll]);
            Except on E:Exception do
              begin
                lstLogs.Add('SavPCL - Ligne : ' + IntToStr(i + 1) + ' -> ' + E.Message);
                cds_SavPCL.Cancel;
              end;
            end;
            ProgressBar.Position := (i + 1) * 100 Div lstCsvFile.Count;
            Application.ProcessMessages;
          end;
        end;
      {$ENDREGION}

      if lstLogs.Count > 0 then
      begin
        lstLogs.Insert(0,'--------------------------');
        lstLogs.Insert(0,'Chargement des fichier CSV');
        lstLogs.Insert(0,'--------------------------');

        lstMainLogs.AddStrings(lstLogs);
      end;

      finally
        lstCsvFile.Free;
        lstCsvLigne.Free;
        lstTmp.Free;
      end;
    end;

  finally
    lstLogs.Free;
  end;
end;

procedure Tfrm_ImportAtelier.DoImportToDatabase(AMagID : Integer);
var
  lstlogs : TStringList;
  iNEW_FORID, iNEW_FOLID : Integer;
  iNEW_TXHID, iNEW_PT1ID, iNEW_PT2ID : Integer;
  iNEW_TYMID, iNEW_MATID, iNEW_MRKID : Integer;
  iNEW_STYID, iNEW_SAVID : Integer;
  iNEW_SALID : Integer;
  iNEW_SAAID : Integer;
  CBInfo : TCBIdent;
  iNEW_CLTID : Integer;
  iNEW_USRID, iNEW_USRIDENCHARGE : Integer;
begin
  lstlogs := TStringList.Create;
  With DM_MainImport do
  try
    if not Database.Connected then
      Database.Open;

    IBQue_Tmp.Close;
    IBQue_Tmp.Database := Database;

    {$REGION 'Génération des forfaits'}
      cds_Forfait.First;
      cds_ForfaitLigne.First;
      Lab_Forfait.Caption := 'Forfait : Importation des données en cours ...';
      Lab_Forfait.Update;

      while not cds_Forfait.Eof do
      begin
        Transaction.StartTransaction;
        try
          // Vérifier que le forfait n'existe pas déja
          With IBQue_Tmp do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Select FOR_ID from SAVFORFAIT');
            SQL.Add('  join K on K_ID = FOR_ID and K_Enabled = 1');
            SQL.Add('Where Upper(FOR_NOM) = :PFORNOM');
            ParamCheck := True;
            ParamByName('PFORNOM').AsString := UpperCase(cds_Forfait.FieldByName('FOR_NOM').AsString);
            Open;

            if RecordCount > 0 then
              iNEW_FORID := FieldByName('FOR_ID').AsInteger
            else
              iNEW_FORID := -1;
          end; // with

          if iNEW_FORID = -1 then
          begin
            // Création du forfait car il n'existe pas déja
            iNEW_FORID := GetNewKID('SAVFORFAIT');
            With IBQue_Tmp do
            try
              Close;
              SQL.Clear;
              SQL.Add('Insert into SAVFORFAIT(FOR_ID, FOR_NOM, FOR_PRIX, FOR_DUREE)');
              SQL.Add('Values(:PFORID, :PFORNOM, :PFORPRIX, :PFORDUREE)');
              ParamCheck := True;
              ParamByName('PFORID').AsInteger := iNEW_FORID;
              ParamByName('PFORNOM').AsString := cds_Forfait.FieldByName('FOR_NOM').AsString;
              ParamByName('PFORPRIX').AsCurrency := cds_Forfait.FieldByName('FOR_PRIX').AsCurrency;
              ParamByName('PFORDUREE').AsFloat := cds_Forfait.FieldByName('FOR_DUREE').AsFloat;
              ExecSQL;
            Except on E:Exception do
              raise Exception.Create('SavForfait -> ' + E.Message);
            end;
          end;

          // Création de la ligne de forfait
          if cds_ForfaitLigne.Locate('FOL_FORID',cds_Forfait.FieldByName('FOR_ID').AsInteger,[]) then
          begin
            while (not cds_ForfaitLigne.Eof) do
            begin
              if (cds_Forfait.FieldByName('FOR_ID').AsInteger = cds_ForfaitLigne.FieldByName('FOL_FORID').AsInteger) then
              try
                // Récupération des informations sur le CB via la Tb temporaire
                CBInfo := GetCbInfo(cds_ForfaitLigne.FieldByName('CBI_CB').AsString);

                // Vérifier qu'il n'y a pas déjà une ligne avec ces informations pour le forfait
                With IBQue_Tmp do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('Select count(*) as Resultat from SAVFORFAIT');
                  SQL.Add('Where FOL_FORID = :PFOLFORID');
                  SQL.Add('  and FOL_ARTID = :PFOLARTID');
                  SQL.Add('  and FOL_TGFID = :PFOLTGFID');
                  SQL.Add('  and FOL_COUID = :PFOLCOUID');
                  ParamCheck := True;
                  ParamByName('PFOLARTID').AsInteger := CBInfo.ART_ID;
                  ParamByName('PFOLTGFID').AsInteger := CBInfo.TGF_ID;
                  ParamByName('PFOLCOUID').AsInteger := CBInfo.COU_ID;
                  ParamByName('PFOLFORID').AsInteger := iNEW_FORID;
                  Open;

                  if FieldByName('Resultat').AsInteger = 0 then
                  begin
                    // Création de la ligne de forfait
                    iNEW_FOLID := GetNewKID('SAVFORFAITL');
                    Close;
                    SQL.Clear;
                    SQL.Add('Insert into SAVFORFAITL(FOL_ID, FOL_ARTID, FOL_TGFID, FOL_COUID,FOL_QTE, FOL_FORID)');
                    SQL.Add('Values(:PFOLID, :PFOLARTID, :PFOLTGFID, :PFOLCOUID, :PFOLQTE, :PFOLFORID)');
                    ParamCheck := True;
                    ParamByName('PFOLID').AsInteger := iNEW_FOLID;
                    ParamByName('PFOLARTID').AsInteger := CBInfo.ART_ID;
                    ParamByName('PFOLTGFID').AsInteger := CBInfo.TGF_ID;
                    ParamByName('PFOLCOUID').AsInteger := CBInfo.COU_ID;
                    ParamByName('PFOLQTE').AsInteger := cds_ForfaitLigne.FieldByName('FOR_QTE').AsInteger;
                    ParamByName('PFOLFORID').AsInteger := iNEW_FORID;
                    ExecSQL;

                    cds_ForfaitLigne.Edit;
                    cds_ForfaitLigne.FieldByName('NEW_FOLID').AsInteger := iNEW_FOLID;
                    cds_ForfaitLigne.Post;
                  end;
                end; // with
              Except on E:Exception do
                lstlogs.Add('SavForfait Ligne -> ' + E.MEssage);
              end;
              cds_ForfaitLigne.Next;
            end; // While
          end; // if

          Transaction.Commit;

          cds_Forfait.Edit;
          cds_Forfait.FieldByName('NEW_FORID').AsInteger := iNEW_FORID;
          cds_Forfait.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
            Transaction.Rollback;
          end;
        end;
        cds_Forfait.Next;
        ProgressBar.Position := cds_Forfait.RecNo * 100 Div cds_Forfait.RecordCount;
        Application.ProcessMessages;
      end; // while
      Lab_Forfait.Caption := 'Forfait : FINI';
    {$ENDREGION}

    {$REGION 'Génération de la nomenclature'}
      cds_PT1.First;
      cds_TauxH.First;
      Lab_Nomenclature.Caption := 'Nomenclature : Importation des données en cours ...';
      Lab_Nomenclature.Update;
      // Création des taux
      Transaction.StartTransaction;
      while not cds_TauxH.Eof do
      begin
        try
          With IBQue_Tmp do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Select TXH_ID from SAVTAUXH');
            SQL.Add('  join K on K_Id = TXH_ID and K_Enabled = 1');
            SQL.Add('Where Upper(TXH_NOM) = :PTXHNOM');
            ParamCheck := True;
            ParamByName('PTXHNOM').AsString := UpperCase(cds_TauxH.FieldByName('TXH_NOM').AsString);
            Open;

            if RecordCount > 0 then
              iNEW_TXHID := FieldByName('TXH_ID').AsInteger
            else
              iNEW_TXHID := -1;

            if iNEW_TXHID = -1 then
            begin
              try
                iNEW_TXHID := GetNewKID('SAVTAUXH');
                Close;
                SQL.Clear;
                SQL.Add('Insert into SAVTAUXH(TXH_ID, TXH_NOM, TXH_PRIX)');
                SQL.Add('Values(:PTXHID, :PTXHNOM, :PTXHPRIX)');
                ParamCheck := True;
                ParamByName('PTXHID').AsInteger := iNEW_TXHID;
                ParamByName('PTXHNOM').AsString := cds_TauxH.FieldByName('TXH_NOM').AsString;
                ParamByName('PTXHPRIX').AsCurrency := cds_TauxH.FieldByName('TXH_PRIX').AsCurrency;
                ExecSQL;
              Except on E:Exception do
                raise Exception.Create('SAVTAUXH -> ' + E.Message);
              end;
            end;
          end; // with


          cds_TauxH.Edit;
          cds_TauxH.FieldByName('NEW_TXHID').AsInteger := iNEW_TXHID;
          cds_TauxH.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
//            Transaction.Rollback;
          end;
        end; // try

        cds_TauxH.Next;
      end; // while
      Transaction.Commit;

      // Création de la nomenclature Atelier
      Transaction.StartTransaction;
      while not cds_PT1.Eof do
      begin
        try
          With IBQue_Tmp do
          begin
            // Vérification que le PT1 n'existe pas déjà
            Close;
            SQL.Clear;
            SQL.Add('Select PT1_ID from SAVPT1');
            SQL.Add('  join K on K_ID = PT1_ID and K_Enabled = 1');
            SQL.Add('Where Upper(PT1_NOM) = :PPT1NOM');
            ParamCheck := True;
            ParamByName('PPT1NOM').AsString := UpperCase(cds_PT1.FieldByName('PT1_NOM').AsString);
            Open;

            if Recordcount > 0 then
              iNEW_PT1ID := FieldByName('PT1_ID').AsInteger
            else
              iNEW_PT1ID := -1;

            if iNEW_PT1ID = -1 then
            begin
              // Création d'un nouveau PT1
              iNEW_PT1ID := GetNewKID('SAVPT1');
              try
                Close;
                SQL.Clear;
                SQL.Add('Insert into SAVPT1(PT1_ID, PT1_PICTO, PT1_ORDREAFF, PT1_NOM)');
                SQL.Add('Values(:PPT1ID, :PPT1PICTO, :PPT1ORDREAFF, :PPT1NOM)');
                ParamCheck := True;
                ParamByName('PPT1ID').AsInteger := iNEW_PT1ID;
                ParamByName('PPT1PICTO').AsString := cds_PT1.FieldByName('PT1_PICTO').AsString;
                ParamByName('PPT1ORDREAFF').AsInteger := cds_PT1.FieldByName('PT1_ORDREAFF').AsInteger;
                ParamByName('PPT1NOM').AsString       := cds_PT1.FieldByName('PT1_NOM').AsString;
                ExecSQL;
              Except on E:Exception do
                raise Exception.Create('SavPT1 -> ' + E.Message);
              end;
            end;

            // Gestion de PT2
            cds_PT2.First;
            if cds_PT2.Locate('PT2_PT1ID', cds_PT1.FieldByName('PT1_ID').AsInteger,[]) then
            begin
              while not cds_PT2.Eof do
              begin
                if cds_PT2.FieldByName('PT2_PT1ID').AsInteger = cds_PT1.FieldByName('PT1_ID').AsInteger then
                try
                  // Récupération des infos CB
                  CBInfo := GetCbInfo(cds_PT2.FieldByName('CBI_CB').AsString);

                  // vérifie que PT2 n'existe pas déjà
                  Close;
                  SQL.Clear;
                  SQL.Add('Select PT2_ID from SAVPT2');
                  SQL.Add('  join K on K_ID = PT2_ID and K_Enabled = 1');
                  SQL.Add('Where Upper(PT2_NOM) = :PPT2NOM');
                  SQL.Add('  and PT2_PT1ID = :PPT2PT1ID');
                  ParamCheck := True;
                  ParamByName('PPT2NOM').AsString := UpperCase(cds_PT2.FieldByName('PT2_NOM').AsString);
                  ParamByName('PPT2PT1ID').AsInteger := iNEW_PT1ID;
                  Open;

                  if RecordCount > 0 then
                    iNEW_PT2ID := FieldByName('PT2_ID').AsInteger
                  else
                    iNEW_PT2ID := -1;

                  if iNEW_PT2ID = -1 then
                  begin
                    // Positionnement pour le forfait
                    if cds_PT2.FieldByName('PT2_FORID').AsInteger <> 0 then
                    begin
                      if not cds_Forfait.Locate('FOR_ID',cds_PT2.FieldByName('PT2_FORID').AsInteger,[]) then
                        raise Exception.Create('Forfait non trouvé ' + cds_PT2.FieldByName('PT2_FORID').AsString);

                      if (cds_Forfait.FieldByName('NEW_FORID').AsInteger = -1) and (cds_PT2.FieldByName('PT2_FORID').AsInteger <> 0) then
                        raise Exception.Create('Forfait non créé ' + cds_PT2.FieldByName('PT2_FORID').AsString);
                    end;

                    // Positionnement sur le Taux
                    if Not cds_TauxH.Locate('TXH_ID',cds_PT2.FieldByName('PT2_TXHID').AsInteger,[]) then
                      raise Exception.Create('TauxH non trouvé ' + cds_PT2.FieldByName('PT2_TXHID').AsString);

                    if cds_TauxH.FieldByName('NEW_TXHID').AsInteger = -1 then
                      raise Exception.Create('TauxH non créé ' + cds_PT2.FieldByName('PT2_TXHID').AsString);

                    // création du PT2
                    iNEW_PT2ID := GetNewKID('SAVPT2');
                    try
                      Close;
                      SQL.Clear;
                      SQL.Add('Insert into SAVPT2(PT2_ID, PT2_PT1ID, PT2_NOM, PT2_FORFAIT, PT2_FORID,');
                      SQL.Add(' PT2_DUREE, PT2_PICTO, PT2_TXHID, PT2_ARTID, PT2_ORDREAFF, PT2_LIBELLE)');
                      SQL.Add('Values(:PPT2ID, :PPT2PT1ID, :PPT2NOM, :PPT2FORFAIT, :PPT2FORID,');
                      SQL.Add(' :PPT2DUREE, :PPT2PICTO, :PPT2TXHID, :PPT2ARTID, :PPT2ORDREAFF, :PPT2LIBELLE)');
                      ParamCheck := True;
                      ParamByName('PPT2ID').AsInteger := iNEW_PT2ID;
                      ParamByName('PPT2PT1ID').AsInteger := iNEW_PT1ID;
                      ParamByName('PPT2NOM').AsString    := cds_PT2.FieldByName('PT2_NOM').AsString;
                      ParamByName('PPT2FORFAIT').AsInteger := cds_PT2.FieldByName('PT2_FORFAIT').AsInteger;
                      if cds_PT2.FieldByName('PT2_FORID').AsInteger = 0 then
                        ParamByName('PPT2FORID').AsInteger   := 0
                      else
                        ParamByName('PPT2FORID').AsInteger   := cds_Forfait.FieldByName('NEW_FORID').AsInteger;
                      ParamByName('PPT2DUREE').AsFloat     := cds_PT2.FieldByName('PT2_DUREE').AsFloat;
                      ParamByName('PPT2PICTO').AsString    := cds_PT2.FieldByName('PT2_PICTO').AsString;
                      ParamByName('PPT2TXHID').AsInteger   := cds_TauxH.FieldByName('NEW_TXHID').AsInteger;
                      ParamByName('PPT2ARTID').AsInteger   := CBInfo.ART_ID;
                      ParamByName('PPT2ORDREAFF').AsInteger := cds_PT2.FieldByName('PT2_ORDREAFF').AsInteger;
                      ParamByName('PPT2LIBELLE').AsString   := cds_PT2.FieldByName('PT2_LIBELLE').AsString;
                      ExecSQL;
                    Except on E:Exception do
                      raise Exception.Create(E.Message);
                    end;
                  end; // if

                  cds_PT2.Edit;
                  cds_PT2.FieldByName('NEW_PT2ID').AsInteger := iNEW_PT2ID;
                  cds_PT2.Post;

                Except on E:Exception do
                  begin
                    raise Exception.Create('SAVPT2 -> ' + E.Message);
                  end;
                end;

                cds_PT2.Next;
              end;
            end; // if
          end; // with

          cds_PT1.Edit;
          cds_PT1.FieldByName('NEW_PT1ID').AsInteger := iNEW_PT1ID;
          cds_PT1.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
//            Transaction.Rollback;
          end;
        end; // try

        cds_PT1.Next;
        ProgressBar.Position := cds_PT1.RecNo * 100 Div cds_PT1.RecordCount;
        Application.ProcessMessages;

      end;
      Transaction.Commit;
      Lab_Nomenclature.Caption := 'Nomenclature : FINI';
    {$ENDREGION}

    {$REGION 'Génération de matériel/ type matériel'}
       cds_SavMat.First;
       cds_SavTypMat.First;
       Lab_Materiel.Caption := 'Materiel : Importation en cours ...';
       // Traitement des types de matériel
       while not cds_SavTypMat.Eof do
       begin
         if not Transaction.InTransaction then
           Transaction.StartTransaction;
         With IBQue_Tmp do
         try
           // vérifier que le TYpMat n'existe pas déjà
           Close;
           SQL.Clear;
           SQL.Add('Select TYM_ID from SAVTYPMAT');
           SQL.Add('  join K on K_ID = TYM_ID and K_Enabled = 1');
           SQL.Add('Where Upper(TYM_NOM) = :PTYMNOM');
           ParamCheck := True;
           ParamByName('PTYMNOM').AsString := UpperCase(cds_SavTypMat.FieldByName('TYM_NOM').AsString);
           Open;

           if RecordCount > 0 then
             iNEW_TYMID := FieldByName('TYM_ID').AsInteger
           else
             iNEW_TYMID := -1;

           if iNEW_TYMID = -1 then
           begin
             // création du type matériel
             iNEW_TYMID := GetNewKID('SAVTYPMAT');
             try
               Close;
               SQL.Clear;
               SQL.Add('Insert into SAVTYPMAT(TYM_ID, TYM_NOM)');
               SQL.Add('Values(:PTYMID, :PTYMNOM)');
               ParamCheck := True;
               ParamByName('PTYMID').AsInteger := iNEW_TYMID;
               ParamByName('PTYMNOM').AsString := cds_SavTypMat.FieldByName('TYM_NOM').AsString;
               ExecSQL;
             Except on E:Exception do
               raise Exception.Create('SAVTYPEMAT -> ' + E.Message);
             end;
           end;

           Transaction.Commit;

           cds_SavTypMat.Edit;
           cds_SavTypMat.FieldByName('NEW_TYMID').AsInteger := iNEW_TYMID;
           cds_SavTypMat.Post;

         Except on E:Exception do
           begin
             lstlogs.Add(E.Message);
             Transaction.Rollback;
           end;
         end; // try

         cds_SavTypMat.Next;
       end; // while

       // Traitement des matériels
       while not cds_SavMat.Eof do
       begin
         if not Transaction.InTransaction then
           Transaction.StartTransaction;
         try
           // Récupération des information CB
           //CBInfo := GetCbInfo(cds_SavMat.FieldByName('CBI_CB').AsString);

           // Récupération dans table tmp du nouvel id client
           iNEW_CLTID := GetNewClientId(cds_SavMat.FieldByName('MAT_CLTID').AsInteger);
           // vérifie que le matériel n'existe pas déjà
           With IBQue_Tmp do
           begin
             Close;
             SQL.Clear;
             SQL.add('Select MAT_ID from SAVMAT');
             SQL.Add('  join K on K_ID = MAT_ID and K_Enabled = 1');
             SQL.add('Where Upper(MAT_NOM) = :PMATNOM');
             SQL.Add('  and MAT_CLTID = :PMATCLTID');
             SQL.Add('  and MAT_ARTID = :PMATARTID');
             ParamCheck := True;
             ParamByName('PMATNOM').AsString    := UpperCase(cds_SavMat.FieldByName('MAT_NOM').AsString);
             ParamByName('PMATCLTID').AsInteger := iNEW_CLTID;
             ParamByName('PMATARTID').AsInteger := CBInfo.ART_ID;
             Open;

             if RecordCount > 0 then
               iNEW_MATID := FieldByName('MAT_ID').AsInteger
             else
               iNEW_MATID := -1;

             if iNEW_MATID = -1 then
             begin
               try
                 if not cds_SavTypMat.Locate('TYM_ID',cds_SavMat.FieldByName('MAT_TYMID').AsInteger,[]) then
                   raise Exception.Create('Type matériel non trouvé ' + cds_SavMat.FieldByName('MAT_TYMID').AsString);

                 if cds_SavTypMat.FieldByName('NEW_TYMID').AsInteger = -1 then
                   raise Exception.Create('Type métériel non créé ' + cds_SavMat.FieldByName('MAT_TYMID').AsString);

                 iNEW_MRKID := GetMrkID(cds_SavMat.FieldByName('MRK_NOM').AsString);
                 if iNEW_MRKID = -1 then
                 begin
                   lstLogs.add('Materiel : ' + cds_SavMat.FieldByName('MAT_ID').AsString + '/' +
                                               cds_SavMat.FieldByName('MAT_CHRONO').AsString +
                                              ' -> Marque non trouvée : ' +  cds_SavMat.FieldByName('MRK_NOM').AsString);
                   iNEW_MRKID := 0;
                 end;

                 iNEW_MATID := GetNewKID('SAVMAT');
                 // Création du  matériel
                 Close;
                 SQL.Clear;
                 SQL.Add('Insert into SAVMAT(MAT_ID, MAT_CLTID, MAT_TYMID, MAT_MRKID, MAT_ARTID,');
                 SQL.Add(' MAT_TKLID, MAT_NOM, MAT_SERIE, MAT_COULEUR, MAT_COMMENT, MAT_DATEACHAT,');
                 SQL.Add(' MAT_ARCHIVER, MAT_REFMRK, MAT_CHRONO)');
                 SQL.Add('Values(:PMATID, :PMATCLTID, :PMATTYMID, :PMATMRKID, :PMATARTID,');
                 SQL.Add(' :PMATTKLID, :PMATNOM, :PMATSERIE, :PMATCOULEUR, :PMATCOMMENT, :PMATDATEACHAT,');
                 SQL.Add(' :PMATARCHIVER, :PMATREFMRK, :PMATCHRONO)');
                 ParamCheck := True;
                 ParamByName('PMATID').AsInteger         := iNEW_MATID;
                 ParamByName('PMATCLTID').AsInteger      := iNEW_CLTID;
                 ParamByName('PMATTYMID').AsInteger      := cds_SavTypMat.FieldByName('NEW_TYMID').AsInteger;
                 ParamByName('PMATMRKID').AsInteger      := iNEW_MRKID;
                 ParamByName('PMATARTID').AsInteger      := 0; //CBInfo.ART_ID;
                 ParamByName('PMATTKLID').AsInteger      := 0;
                 ParamByName('PMATNOM').AsString         := cds_SavMat.FieldByName('MAT_NOM').AsString;
                 ParamByName('PMATSERIE').AsString       := cds_SavMat.FieldByName('MAT_SERIE').AsString;
                 ParamByName('PMATCOULEUR').AsString     := cds_SavMat.FieldByName('MAT_COULEUR').AsString;
                 ParamByName('PMATCOMMENT').AsString     := cds_SavMat.FieldByName('MAT_COMMENT').AsString;
                 ParamByName('PMATDATEACHAT').AsDateTime := cds_SavMat.FieldByName('MAT_DATEACHAT').AsDateTime;
                 ParamByName('PMATARCHIVER').AsInteger   := cds_SavMat.FieldByName('MAT_ARCHIVER').AsInteger;
                 ParamByName('PMATREFMRK').AsString      := cds_SavMat.FieldByName('MAT_REFMRK').AsString;
                 ParamByName('PMATCHRONO').AsString      := cds_SavMat.FieldByName('MAT_CHRONO').AsString;
                 ExecSQL;
               Except on E:Exception do
                 raise Exception.Create('SAVMAT -> ' + E.Message);
               end;
             end;

           end;  //with

           Transaction.Commit;

           cds_SavMat.Edit;
           cds_SavMat.FieldByName('NEW_MATID').AsInteger := iNEW_MATID;
           cds_SavMat.Post;

         Except on E:Exception do
           begin
             lstlogs.Add('Materiel : ' + cds_SavMat.FieldByName('MAT_ID').AsString + ' -> ' + E.Message);
             Transaction.Rollback;
           end;
         end; // try

         cds_SavMat.Next;
         ProgressBar.Position := cds_SavMat.RecNo * 100 Div cds_SavMat.RecordCount;
         Application.ProcessMessages;
       end; // while
       Lab_Materiel.Caption := 'Materiel : FINI';
    {$ENDREGION}

    {$REGION 'Génération Fiche SAV'}
      cds_SavFicheE.First;
      cds_SavType.First;
      Lab_FicheAtelier.Caption := 'Fiches atelier : Importation en cours ...';
      // génération des types
      While not cds_SavType.Eof do
      begin
        Transaction.StartTransaction;
        Try
          With IBQue_Tmp do
          Try

            // Recherche si le Type n'existe pas déjà
            Close;
            SQL.Clear;
            SQL.Add('Select STY_ID from SAVTYPE');
            SQL.Add('  join K on K_Id = STY_ID and K_Enabled = 1');
            SQL.Add('Where Upper(STY_NOM) = :PSTYNOM');
            ParamCheck := True;
            ParamByName('PSTYNOM').AsString := UpperCase(cds_SavType.FieldByName('STY_NOM').AsString);
            Open;

            if Recordcount > 0 then
              iNEW_STYID := FieldByName('STY_ID').AsInteger
            else
             iNEW_STYID := -1;

            if iNEW_STYID = -1 then
            begin
              // Création du type
              iNEW_STYID := GetNewKID('SAVTYPE');
              Close;
              SQL.Clear;
              SQL.Add('Insert into SAVTYPE(STY_ID, STY_NOM)');
              SQL.Add('Values(:PSTYID, :PSTYNOM)');
              ParamCheck := True;
              ParamByName('PSTYID').AsInteger := iNEW_STYID;
              ParamByName('PSTYNOM').AsString := cds_SavType.FieldByName('STY_NOM').AsString;
              ExecSQL;
            end; // with

          Except on E:Exception do
            raise Exception.Create('SavType -> ' + E.Message);
          end;

          Transaction.Commit;

          cds_SavType.Edit;
          cds_SavType.FieldByName('NEW_STYID').AsInteger := iNEW_STYID;
          cds_SavType.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
            Transaction.Rollback;
          end;
        end; // try

        cds_SavType.Next;
      end; // while

      // Génération des fiches ateliers
      while not cds_SavFicheE.Eof do
      begin
        Transaction.StartTransaction;
        try
          With IBQue_Tmp do
          try
            // récupétation du matériel
            if not cds_SavMat.Locate('MAT_ID', cds_SavFicheE.FieldByName('SAV_MATID').AsInteger,[]) then
              raise Exception.Create('Matériel non trouvé ' + cds_SavFicheE.FieldByName('SAV_MATID').AsString);

            if cds_SavMat.FieldByName('NEW_MATID').AsInteger = -1 then
              raise Exception.Create('Matériel non créer ' + cds_SavFicheE.FieldByName('SAV_MATID').AsString);

            // récupération du TauxH
            if not cds_TauxH.Locate('TXH_ID',cds_SavFicheE.FieldByName('SAV_TXHID').AsInteger,[]) then
              raise Exception.Create('TauxH non trouvé ' + cds_SavFicheE.FieldByName('SAV_TXHID').AsString);

            if cds_TauxH.FieldByName('NEW_TXHID').AsInteger = -1 then
              raise Exception.Create('TauxH non créé ' + cds_SavFicheE.FieldByName('SAV_TXHID').AsString);

            // Récupétation dans la table temporaire du nouvel Id client
            iNEW_CLTID := GetNewClientId(cds_SavFicheE.FieldByName('SAV_CLTID').AsInteger);
            // récupération des nouveau ID des USR
            iNEW_USRID := GetNewUsrId(cds_SavFicheE.FieldByName('SAV_USRID').AsInteger);
            iNEW_USRIDENCHARGE := GetNewUsrId(cds_SavFicheE.FieldByName('SAV_USRIDENCHARGE').AsInteger);


            // Vérification que la fiche n'existe pas déjà
            Close;
            SQL.Clear;
            SQL.add('Select SAV_ID from SAVFICHEE');
            SQL.Add('  join K on K_ID = SAV_Id and K_Enabled = 1');
            SQL.Add('Where SAV_CLTID = :PSAVCLTID');
            SQL.Add('  and SAV_MATID = :PSAVMATID');
            SQL.Add('  and SAV_CHRONO = :PSAVCHRONO');
            ParamCheck := True;
            ParamByName('PSAVCLTID').AsInteger := iNEW_CLTID;
            ParamByName('PSAVMATID').AsInteger := cds_SavMat.FieldByName('NEW_MATID').AsInteger;
            ParamByName('PSAVCHRONO').AsString := cds_SavFicheE.FieldByName('SAV_CHRONO').AsString;
            Open;

            if RecordCount > 0 then
              iNEW_SAVID := FieldByName('SAV_ID').AsInteger
            else
              iNEW_SAVID := -1;

            if iNEW_SAVID = -1 then
            begin
              // création d'une nouvelle fiche atelier
              iNEW_SAVID := GetNewKID('SAVFICHEE');
              Close;
              SQL.Clear;
              SQL.Add('Insert into SAVFICHEE(SAV_ID, SAV_CLTID, SAV_MATID, SAV_CHRONO, SAV_DTCREATION,');
              SQL.Add('SAV_DEBUT, SAV_FIN, SAV_REMMO, SAV_REMART, SAV_REM, SAV_IDENT, SAV_USRID, SAV_LIMITE,');
              SQL.Add('SAV_MAGID, SAV_ETAT, SAV_DATEREPRISE, SAV_DATEPLANNING, SAV_COMMENT,');
              SQL.Add('SAV_ORDREAFF, SAV_DUREEGLOB, SAV_DUREE, SAV_TXHID, SAV_PXTAUX,');
              SQL.Add('SAV_USRIDENCHARGE, SAV_PLACE)');
              SQL.Add('Values(:PSAVID, :PSAVCLTID, :PSAVMATID, :PSAVCHRONO, :PSAVDTCREATION,');
              SQL.Add(':PSAVDEBUT, :PSAVFIN, :PSAVREMMO, :PSAVREMART, :PSAVREM, :PSAVIDENT, :PSAVUSRID, :PSAVLIMITE,');
              SQL.Add(':PSAVMAGID, :PSAVETAT, :PSAVDATEREPRISE, :PSAVDATEPLANNING, :PSAVCOMMENT,');
              SQL.Add(':PSAVORDREAFF, :PSAVDUREEGLOB, :PSAVDUREE, :PSAVTXHID, :PSAVPXTAUX,');
              SQL.Add(':PSAVUSRIDENCHARGE, :PSAVPLACE)');
              ParamCheck := True;
              ParamByName('PSAVID').AsInteger := iNEW_SAVID;
              ParamByName('PSAVCLTID').AsInteger := iNEW_CLTID;
              ParamByName('PSAVMATID').AsInteger := cds_SavMat.FieldByName('NEW_MATID').AsInteger;
              ParamByName('PSAVCHRONO').AsString := cds_SavFicheE.FieldByName('SAV_CHRONO').AsString;
              ParamByName('PSAVDTCREATION').AsDateTime := cds_SavFicheE.FieldByName('SAV_DTCREATION').AsDateTime;
              ParamByName('PSAVDEBUT').AsDateTime := cds_SavFicheE.FieldByName('SAV_DEBUT').AsDateTime;
              ParamByName('PSAVFIN').AsDateTime := cds_SavFicheE.FieldByName('SAV_FIN').AsDateTime;
              ParamByName('PSAVREMMO').AsFloat := cds_SavFicheE.FieldByName('SAV_REMMO').AsFloat;
              ParamByName('PSAVREMART').AsFloat := cds_SavFicheE.FieldByName('SAV_REMART').AsFloat;
              ParamByName('PSAVREM').AsFloat := cds_SavFicheE.FieldByName('SAV_REM').AsFloat;
              ParamByName('PSAVIDENT').AsString := cds_SavFicheE.FieldByName('SAV_IDENT').AsString;
              ParamByName('PSAVUSRID').AsInteger := iNEW_USRID;
              ParamByName('PSAVLIMITE').AsDateTime := cds_SavFicheE.FieldByName('SAV_LIMITE').AsDateTime;
              ParamByName('PSAVMAGID').AsInteger := AMagID;
              ParamByName('PSAVETAT').AsInteger := cds_SavFicheE.FieldByName('SAV_ETAT').AsInteger;
              ParamByName('PSAVDATEREPRISE').AsDateTime := cds_SavFicheE.FieldByName('SAV_DATEREPRISE').AsDateTime;
              ParamByName('PSAVDATEPLANNING').AsDateTime := cds_SavFicheE.FieldByName('SAV_DATEPLANNING').AsDateTime;
              ParamByName('PSAVCOMMENT').AsString := cds_SavFicheE.FieldByName('SAV_COMMENT').AsString;
              ParamByName('PSAVORDREAFF').AsInteger := cds_SavFicheE.FieldByName('SAV_ORDREAFF').AsInteger;
              ParamByName('PSAVDUREEGLOB').AsInteger := cds_SavFicheE.FieldByName('SAV_DUREEGLOB').AsInteger;
              ParamByName('PSAVDUREE').AsFloat := cds_SavFicheE.FieldByName('SAV_DUREE').AsFloat;
              ParamByName('PSAVTXHID').AsInteger := cds_TauxH.FieldByName('NEW_TXHID').AsInteger;
              ParamByName('PSAVPXTAUX').AsCurrency := cds_SavFicheE.FieldByName('SAV_PXTAUX').AsCurrency;
              ParamByName('PSAVUSRIDENCHARGE').AsInteger := iNEW_USRIDENCHARGE;
              ParamByName('PSAVPLACE').AsString := cds_SavFicheE.FieldByName('SAV_PLACE').AsString;
              ExecSQL;
            end;

          Except on E:Exception do
            raise Exception.Create('SAVFICHEE -> Fiche : ' + cds_SavFicheE.FieldByName('SAV_ID').AsString + ' -> ' + E.Message);
          end;

          Transaction.Commit;

          cds_SavFicheE.Edit;
          cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger := iNEW_SAVID;
          cds_SavFicheE.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
            Transaction.Rollback;
          end;
        end;

        cds_SavFicheE.Next;
        ProgressBar.Position := cds_SavFicheE.RecNo * 100 Div cds_SavFicheE.RecordCount;
        Application.ProcessMessages;

      end; // while
      Lab_FicheAtelier.Caption := 'Fiches atelier : FINI';
    {$ENDREGION}

    {$REGION 'Génération des lignes des fiches'}
       cds_SavFicheL.First;
       Lab_LigneAtelier.Caption := 'Lignes fiches atelier : Importation en cours ...';
       while not cds_SavFicheL.Eof do
       begin
         Transaction.StartTransaction;
         try
          With IBQue_Tmp do
          try
            // Récupération de SAVID de la ligne
            if not cds_SavFicheE.locate('SAV_ID',cds_SavFicheL.FieldByName('SAL_SAVID').AsInteger,[]) then
              raise Exception.Create('SavFicheE non trouvé ' + cds_SavFicheL.FieldByName('SAL_SAVID').AsString);

            if cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger = -1 then
              raise Exception.Create('SavFicheE non créé ' + cds_SavFicheL.FieldByName('SAL_SAVID').AsString);

            // récupération de PT2ID
            if not cds_PT2.locate('PT2_ID',cds_SavFicheL.FieldByName('SAL_PT2ID').AsInteger,[]) then
              raise Exception.Create('SAVPT2 non trouvé ' + cds_SavFicheL.FieldByName('SAL_PT2ID').AsString);

            if cds_PT2.FieldByName('NEW_PT2ID').AsInteger = -1 then
              raise Exception.Create('SavPT2 non créé ' + cds_SavFicheL.FieldByName('SAL_PT2ID').AsString);

            // Récupération du forfait
            if cds_SavFicheL.FieldByName('SAL_FORID').AsInteger <> 0 then
            begin
              if not cds_Forfait.locate('FOR_ID',cds_SavFicheL.FieldByName('SAL_FORID').AsInteger,[]) then
                raise Exception.Create('SAVFORFAIT non trouvé ' + cds_SavFicheL.FieldByName('SAL_FORID').AsString);

              if cds_Forfait.FieldByName('NEW_FORID').AsInteger = -1 then
                raise Exception.Create('SavFORFAIT non créé ' + cds_SavFicheL.FieldByName('SAL_FORID').AsString);
            end;

            // récupération des tauxh
            if not cds_TauxH.Locate('TXH_ID',cds_SavFicheL.FieldByName('SAL_TXHID').AsInteger,[]) then
              raise Exception.Create('TAUXH non trouvé ' + cds_SavFicheL.FieldByName('SAL_TXHID').AsString);

            if cds_TauxH.FieldByName('NEW_TXHID').AsInteger = -1 then
              raise Exception.Create('TAUXH non créé ' + cds_SavFicheL.FieldByName('SAL_TXHID').AsString);

            // récupération de l'ID du USR
            iNEW_USRID := GetNewUsrId(cds_SavFicheL.FieldByName('SAL_USRID').AsInteger);

            // vérification que la ligne n'existe pas déjà
            Close;
            SQL.Clear;
            SQL.Add('Select SAL_ID from SAVFICHEL');
            SQL.Add('  join K on K_ID = SAL_ID and K_Enabled = 1');
            SQL.Add('Where SAL_SAVID = :PSALSAVID');
            SQL.Add('  and SAL_PT2ID = :PSALPT2ID');
            SQL.Add('  and SAL_FORID = :PSALFORID');
            SQL.Add('  and Upper(SAL_NOM) = :PSALNOM');
            ParamCheck := True;
            ParamByName('PSALSAVID').AsInteger := cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger;
            ParamByName('PSALPT2ID').AsInteger := cds_PT2.FieldByName('NEW_PT2ID').AsInteger;
            ParamByName('PSALFORID').AsInteger := cds_Forfait.FieldByName('NEW_FORID').AsInteger;
            ParamByName('PSALNOM').AsString := UpperCase(cds_SavFicheL.FieldByName('SAL_NOM').AsString);
            Open;

            if RecordCount > 0 then
              iNEW_SALID := FieldByName('SAL_ID').AsInteger
            else
              iNEW_SALID := -1;

            if iNEW_SALID = -1 then
            begin
              // Création de l'article
              iNEW_SALID := GetNewKID('SAVFICHEL');
              Close;
              SQL.Clear;
              SQL.Add('Insert into SAVFICHEL(SAL_ID, SAL_SAVID, SAL_PT2ID, SAL_FORID,');
              SQL.Add('SAL_NOM, SAL_COMMENT, SAL_DUREE, SAL_TXHID, SAL_REMISE, SAL_PXTOT,');
              SQL.Add('SAL_USRID, SAL_TERMINE, SAL_PXBRUT)');
              SQL.Add('Values(:PSALID, :PSALSAVID, :PSALPT2ID, :PSALFORID,');
              SQL.Add(':PSALNOM, :PSALCOMMENT, :PSALDUREE, :PSALTXHID, :PSALREMISE, :PSALPXTOT,');
              SQL.Add(':PSALUSRID, :PSALTERMINE, :PSALPXBRUT)');
              ParamCheck := True;
              ParamByName('PSALID').AsInteger := iNEW_SALID;
              ParamByName('PSALSAVID').AsInteger := cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger;
              ParamByName('PSALPT2ID').AsInteger := cds_PT2.FieldByName('NEW_PT2ID').AsInteger;
              if cds_SavFicheL.FieldByName('SAL_FORID').AsInteger = 0 then
                ParamByName('PSALFORID').AsInteger := 0
              else
                ParamByName('PSALFORID').AsInteger := cds_Forfait.FieldByName('NEW_FORID').AsInteger;
              ParamByName('PSALNOM').AsString    := cds_SavFicheL.FieldByName('SAL_NOM').AsString;
              ParamByName('PSALCOMMENT').AsString   := cds_SavFicheL.FieldByName('SAL_COMMENT').AsString;
              ParamByName('PSALDUREE').AsFloat := cds_SavFicheL.FieldByName('SAL_DUREE').AsFloat;
              ParamByName('PSALTXHID').AsInteger  := cds_TauxH.FieldByName('NEW_TXHID').AsInteger;
              ParamByName('PSALREMISE').AsFloat   := cds_SavFicheL.FieldByName('SAL_REMISE').AsFloat;
              ParamByName('PSALPXTOT').AsFloat    := cds_SavFicheL.FieldByName('SAL_PXTOT').AsFloat;
              ParamByName('PSALUSRID').AsInteger  := iNEW_USRID;
              ParamByName('PSALTERMINE').AsInteger   := cds_SavFicheL.FieldByName('SAL_TERMINE').AsInteger;
              ParamByName('PSALPXBRUT').AsFloat      := cds_SavFicheL.FieldByName('SAL_PXBRUT').AsFloat;
              ExecSQL;
            end;
          Except on E:Exception do
            raise Exception.Create('SavFicheL -> Ligne Fiche : ' + cds_SavFicheL.FieldByName('SAL_ID').AsString + ' -> ' + E.Message);
          end;

          Transaction.Commit;

          cds_SavFicheL.Edit;
          cds_SavFicheL.FieldByName('NEW_SALID').AsInteger := iNEW_SALID;
          cds_SavFicheL.Post;

        Except on E:Exception do
          begin
            lstlogs.Add(E.Message);
            Transaction.Rollback;
          end;
        end; // try

        cds_SavFicheL.Next;
        ProgressBar.Position := cds_SavFicheL.RecNo * 100 Div cds_SavFicheL.RecordCount;
        Application.ProcessMessages;
       end;
       Lab_LigneAtelier.Caption := 'Lignes fiches atelier : FINI';
    {$ENDREGION}

    {$REGION 'Génération des fiches ART'}
      cds_SavFicheArt.First;
      Lab_FicheArt.Caption := 'Articles fiches atelier : Importation en cours ...';

      while not cds_SavFicheArt.Eof do
      begin
        Transaction.StartTransaction;
        try
          With IBQue_Tmp do
          try
            // Récupération des informations du CB
            if (cds_SavFicheArt.FieldByName('CBI_CB').AsString <> '') and (cds_SavFicheArt.FieldByName('CBI_CB').AsString <> 'null') then
              CBInfo := GetCbInfo(cds_SavFicheArt.FieldByName('CBI_CB').AsString)
            else
            begin
              CBInfo.ART_ID := 0;
              CBInfo.TGF_ID := 0;
              CBInfo.COU_ID := 0;
            end;

            // Récupération de la fiche
            if not cds_SavFicheE.Locate('SAV_ID',cds_SavFicheArt.FieldByName('SAA_SAVID').AsInteger,[]) then
              raise Exception.Create('SAVFICHEE non trouvé ' + cds_SavFicheArt.FieldByName('SAA_SAVID').AsString);

            if cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger = -1 then
              raise Exception.Create('SAVFICHEE non créé ' + cds_SavFicheArt.FieldByName('SAA_SAVID').AsString);

            // Récupération de la ligne de fiche
            if cds_SavFicheArt.FieldByName('SAA_SALID').AsInteger <> 0 then
            begin
              if not cds_SavFicheL.Locate('SAL_ID', cds_SavFicheArt.FieldByName('SAA_SALID').AsInteger,[]) then
                raise Exception.Create('SAVFICHEL non trouvé ' + cds_SavFicheArt.FieldByName('SAA_SALID').AsString);

              if (cds_SavFicheL.FieldByName('NEW_SALID').AsInteger = -1) then
                raise Exception.Create('SAVFICHEL non créé ' + cds_SavFicheArt.FieldByName('SAA_SALID').AsString);
            end;

            // Vérification que l'article n'existe pas déjà
            Close;
            SQL.Clear;
            SQL.Add('Select SAA_ID from SAVFICHEART');
            SQL.Add('  join K on K_ID = SAA_ID and K_Enabled = 1');
            SQL.Add('Where SAA_ARTID = :PSAAARTID');
            SQL.Add('  and SAA_TGFID = :PSAATGFID');
            SQL.Add('  and SAA_COUID = :PSAACOUID');
            SQL.Add('  and SAA_SAVID = :PSAASAVID');
            SQL.Add('  and SAA_SALID = :PSAASALID');
            ParamCheck := True;
            ParamByName('PSAAARTID').AsInteger := CBInfo.ART_ID;
            ParamByName('PSAATGFID').AsInteger := CBInfo.TGF_ID;
            ParamByName('PSAACOUID').AsInteger := CBInfo.COU_ID;
            ParamByName('PSAASAVID').AsInteger := cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger;
            if cds_SavFicheArt.FieldByName('SAA_SALID').AsInteger = 0 then
              ParamByName('PSAASALID').AsInteger := 0
            else
              ParamByName('PSAASALID').AsInteger := cds_SavFicheL.FieldByName('NEW_SALID').AsInteger;
            Open;

            if RecordCount > 0 then
              iNEW_SAAID := FieldByName('SAA_ID').AsInteger
            else
              iNEW_SAAID := -1;

            if iNEW_SAAID = -1 then
            begin
              // création de savficheart
              iNEW_SAAID := GetNewKID('SAVFICHEART');
              Close;
              SQL.Clear;
              SQL.Add('Insert into SAVFICHEART(SAA_ID , SAA_ARTID, SAA_TGFID, SAA_COUID,');
              SQL.Add(' SAA_PU, SAA_REMISE, SAA_QTE, SAA_SAVID, SAA_PXTOT, SAA_SALID, SAA_TYPID)');
              SQL.Add('Values(:PSAAID , :PSAAARTID, :PSAATGFID, :PSAACOUID,');
              SQL.Add(':PSAAPU, :PSAAREMISE, :PSAAQTE, :PSAASAVID, :PSAAPXTOT, :PSAASALID, :PSAATYPID)');
              ParamCheck := True;
              ParamByName('PSAAID').AsInteger := iNEW_SAAID;
              ParamByName('PSAAARTID').AsInteger := CBInfo.ART_ID;
              ParamByName('PSAATGFID').AsInteger := CBInfo.TGF_ID;
              ParamByName('PSAACOUID').AsInteger := CBInfo.COU_ID;
              ParamByName('PSAAPU').AsFloat := cds_SavFicheArt.FieldByName('SAA_PU').AsFloat;
              ParamByName('PSAAREMISE').AsFloat := cds_SavFicheArt.FieldByName('SAA_REMISE').AsFloat;
              ParamByName('PSAAQTE').AsInteger  := cds_SavFicheArt.FieldByName('SAA_QTE').AsInteger;
              ParamByName('PSAASAVID').AsInteger   := cds_SavFicheE.FieldByName('NEW_SAVID').AsInteger;
              ParamByName('PSAAPXTOT').AsFloat     := cds_SavFicheArt.FieldByName('SAA_PXTOT').AsFloat;
              ParamByName('PSAASALID').AsInteger   := cds_SavFicheL.FieldByName('NEW_SALID').AsInteger;
              ParamByName('PSAATYPID').AsInteger   := cds_SavFicheArt.FieldByName('SAA_TYPID').AsInteger;
              ExecSQL;
            end;

          Except on E:Exception do
            raise Exception.Create('SavFicheART -> Fiche Art : ' + cds_SavFicheArt.FieldByName('SAA_ID').AsString + ' -> ' + E.Message);
          end;

           Transaction.Commit;

           cds_SavFicheArt.Edit;
           cds_SavFicheArt.FieldByName('NEW_SAAID').AsInteger := iNEW_SAAID;
           cds_SavFicheArt.Post;

         Except on E:Exception do
           begin
             lstlogs.Add(E.Message);
             Transaction.Rollback;
           end;
         end; // try

         cds_SavFicheArt.Next;
         ProgressBar.Position := cds_SavFicheArt.RecNo * 100 Div cds_SavFicheArt.RecordCount;
        Application.ProcessMessages;
      end;
      Lab_FicheArt.Caption := 'Articles fiches atelier : FINI';
    {$ENDREGION}

    if lstLogs.Count > 0 then
    begin
      lstLogs.Insert(0,'--------------------------');
      lstLogs.Insert(0,'Traitement des fichiers');
      lstLogs.Insert(0,'--------------------------');

      lstMainLogs.AddStrings(lstLogs);
    end;


  finally
    lstLogs.Free;
  end;
end;

procedure Tfrm_ImportAtelier.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lstMainLogs.Free;
end;

procedure Tfrm_ImportAtelier.FormCreate(Sender: TObject);
begin
  lstMainLogs := TStringList.Create;
end;

procedure Tfrm_ImportAtelier.Nbt_AtelierCsvClick(Sender: TObject);
var
  MagId, LeMagidRef, i : Integer;
  S : String;
begin
  With DM_MainImport do
  begin
    Database.Close;
    Database.DatabaseName := FBaseDir.Text;
    Database.Open;

    IBQue_Tmp.Database := Database;
    With IBQue_Tmp do
    begin
        // choisir le magasin d'importation
        Close;
        sql.text := 'select MAG_ID, MAG_NOM from genmagasin join k on (k_id=mag_id and k_enabled=1) where mag_id<>0';
        Open;
        application.createform(Tfrm_ChxMag, frm_ChxMag);
        frm_ChxMag.Parent := Self;
        frm_ChxMag.FormStyle := fsStayOnTop;

        try
          frm_ChxMag.Lb_Mag.items.AddObject(' Tous les mags', pointer(0));
          WHILE NOT Eof DO
          BEGIN
            frm_ChxMag.Lb_Mag.items.AddObject(fields[1].AsString, pointer(fields[0].asInteger));
            Next;
          END;
          close;
          frm_ChxMag.caption := ' Choix du magasin d''affectation des données atelier';
          frm_ChxMag.Lb_Mag.ItemIndex := 0;
          if not frm_ChxMag.ShowModal = mrOk then
          begin
            frm_ChxMag.release;
            Exit;
          end;
          MagId := Integer(frm_ChxMag.Lb_Mag.items.Objects[frm_ChxMag.Lb_Mag.ItemIndex]);
          IF frm_ChxMag.Lb_Mag.ItemIndex = 0 THEN
            LeMagidRef := Integer(frm_ChxMag.Lb_Mag.items.Objects[1])
          ELSE
            LeMagidRef := MagId;
        finally
          frm_ChxMag.release;
        end;
        Gbx_Progression.Caption := 'Progression (Etape 1 sur 2)';
        DoImportCsvFile;
        Gbx_Progression.Caption := 'Progression (Etape 2 sur 2)';
        DoImportToDatabase(LeMagidRef);
        Gbx_Progression.Caption := 'Progression';

        if lstMainLogs.Count > 0 then
          With lstMainLogs do
          begin
            Insert(0,'<HTML>');
            Insert(1,'<head>');
            Insert(2,'<title>' + 'Importation ' + Datetostr(Date) + '</title>');
            Insert(3,'</head>');
            Insert(4,'<body>');
            Insert(5,'<FONT SIZE="-2">');
            Insert(6,'Ce document est sauvegardé dans le répertoire de votre importation, il peut être imprimé par le menu fichier imprimer ou par la combinaison de touches CTRL-P<BR>');
            Insert(7,'</FONT>');
            Insert(8,'Importation des clients du ' + Datetostr(Date) + ' sur la base ' + FEditDir.Text + '<BR>');
            Insert(9,'<P>');

            for i := 10 to lstMainLogs.Count - 1 do
              lstMainLogs[i] := lstMainLogs[i] + '<br>';

            Add('</body>');
            add('</HTML>');
            S := IncludeTrailingBackslash(extractfilepath(FEditDir.Text)) + 'ATR_' + FormatDateTime('YYYY"-"MM"-"DD" "HH"H"NN', now) + '.HTML';
            Savetofile(S);
            ShellExecute(Application.handle, 'open', Pchar(s), NIL, '', SW_SHOWDEFAULT);
            Application.messagebox('importation terminée, consultez le rapport.', ' Fin ', mb_ok);
          end
        else
          application.MessageBox('C''est fini', 'Fin', mb_ok);
    end;
  end;

end;

end.

