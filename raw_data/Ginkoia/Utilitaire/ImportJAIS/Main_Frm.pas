unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, rxToolEdit, IniFiles, uDefs, Main_DM, Buttons,
  ExtCtrls, uTypes, ComCtrls, DB, DBCtrls, DateUtils, Grids, DBGrids;

type
  Tfrm_Main = class(TForm)
    Pan_Directory: TPanel;
    Gbx_Directory: TGroupBox;
    Lab_Source: TLabel;
    Lab_Destination: TLabel;
    RepCmb_Source: TDirectoryEdit;
    fe_dirDest: TFilenameEdit;
    Pan_client: TPanel;
    Pan_Action: TPanel;
    Gbx_Action: TGroupBox;
    Pan_Memoclient: TPanel;
    Gbx_Memo: TGroupBox;
    Pan_Memo: TPanel;
    mmLogs: TMemo;
    Nbt_Execute: TBitBtn;
    Pan_Middle: TPanel;
    Gbx_CFG: TGroupBox;
    dblTVA: TDBLookupComboBox;
    dblGarantie: TDBLookupComboBox;
    Lab_TVA: TLabel;
    Lab_Garantie: TLabel;
    Ds_TVA: TDataSource;
    Ds_Garantie: TDataSource;
    Ds_Typecomptable: TDataSource;
    Lab_TypeComptable: TLabel;
    dblTypC: TDBLookupComboBox;
    ProgressBar1: TProgressBar;
    Lab_Progress: TLabel;
    lab_nomenclature: TLabel;
    dblNomencalture: TDBLookupComboBox;
    Ds_Nomenclature: TDataSource;
    Ds_fedas: TDataSource;
    DBGrid1: TDBGrid;
    Lab_ExercCom: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    Ds_ExerCom: TDataSource;
    Lab_ArtCollection: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Ds_ArtCollection: TDataSource;
    Ds_LstUSR: TDataSource;
    Lab_LstUSR: TLabel;
    DBLookupComboBox3: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_ExecuteClick(Sender: TObject);
    procedure fe_dirDestAfterDialog(Sender: TObject; var Name: string;
      var Action: Boolean);
  private
    { Déclarations privées }
    function CheckParam : Boolean;
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

function Tfrm_Main.CheckParam: Boolean;
begin
  Result := False;
  if RepCmb_Source.Text = '' then
  begin
    ShowMessage('Veuillez sélectionner un répertoire source');
    Exit;
  end;

  if not DirectoryExists(RepCmb_Source.Text) then
  begin
    ShowMessage('Le répertoire source n''existe pas');
    Exit;
  end;

  if fe_dirDest.Text = '' then
  begin
    ShowMessage('Veuillez sélectionner la base de données ginkoia');
    Exit;
  end;

  if Not FileExists(fe_dirDest.Text) then
  begin
    ShowMessage('Impossible de trouver la base de données ginkoia, veuillez vérifier la configuration');
    Exit;
  end;

  if dblNomencalture.Text = '' then
  begin
    Showmessage('Veuillez sélectionner une nomenclature par défaut');
    Exit;
  end;

  Result := True;
end;

procedure Tfrm_Main.fe_dirDestAfterDialog(Sender: TObject; var Name: string;
  var Action: Boolean);
begin
  if Action then
    DM_Main.OpenDataBase(TFilenameEdit(Sender).Dialog.FileName);
end;

procedure Tfrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  With TIniFile.Create(GAPPPATH + GINIFILE) do
  try
    WriteString('DIRECTORY','SOURCE',RepCmb_Source.Text);
    WriteString('DIRECTORY','DEST',fe_dirDest.Text);
  finally
    Free;
  end;

  DM_Main.Free;
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  // Initialisation des répertoires
  GAPPPATH        := ExtractFilePath(Application.ExeName);
  GINIFILE        := ExtractFileName(ChangeFileExt(Application.ExeName,'.ini'));
  GPATHFILETMP    := GAPPPATH + 'TmpFile\';
  GPATHDATA       := GAPPPATH + 'Data\';
  GPATHDATASTRUCT := GPATHDATA + 'tablestruct\';
  GFILEHFTOXML    := GAPPPATH + 'Outils\hyperfile2xml\hyperfile2xml.exe';
  GFILEFEDAS      := GPATHDATA + 'FedasIntersport.csv';

  if not DirectoryExists(GPATHFILETMP) then
    ForceDirectories(GPATHFILETMP);

  With TIniFile.Create(GAPPPATH + GINIFILE) do
  try
    RepCmb_Source.Text := ReadString('DIRECTORY','SOURCE','C:\Program Files\JA');
    fe_dirDest.Text    := ReadString('DIRECTORY','DEST','');
  finally
    free;
  end;

  DM_Main := TDM_Main.Create(self);

  if fe_dirDest.Text <> '' then
  begin
     DM_Main.OpenDataBase(fe_dirDest.Text);
  end;
end;

procedure Tfrm_Main.Nbt_ExecuteClick(Sender: TObject);
var
  TableList : TListTableHF;
  dDateDebut : TDateTime;
  dDateFin : TDateTime;
  iTemps : integer;
  sText : String;
begin
  With DM_Main do
  Try
    mmLogs.Clear;
    // Vérification que les paramètres sont corrects
    if CheckParam then
    begin
      dDateDebut := now;

      GPATHSOURCE := IncludeTrailingBackslash(AnsiDequotedStr(RepCmb_Source.Text,'"'));
      GFILEDEST   := AnsiDequotedStr(fe_dirDest.Text,'"');

      AddToMemo(mmLogs,'--- Début du Traitement des données ---');
      //Ouverture de la base de données Ginkoia
      AddToMemo(mmLogs,'1- Ouverture de la base de données');
      if OpenDataBase(GFILEDEST) then
      begin
        // 1- Récupération de la liste des tables à traiter
        AddToMemo(mmLogs,'2- Récupération de la liste des tables à traiter');
        TableList := GetTableList;

        //  Récupération du type GT Taille
        TableList.IdTypeGT := GetTailleTypeGT('REFERENCEMENT INTERSPORT',0);

        // Paramètrage de la liste et valeur par défaut
        TableList.Lab := Lab_Progress;
        TableList.Memo := mmLogs;
        TableList.Progress := ProgressBar1;

        if dblGarantie.Text = '' then
           TableList.IdGarID := 0
        else
           TableList.IdGarID := Que_ListGarantie.FieldByName('GAR_ID').AsInteger;

        if dblTVA.Text = '' then
          TableList.idTVAID := 0
        else
          TableList.idTVAID := Que_ListTVA.FieldByName('TVA_ID').AsInteger;

        if dblTypC.Text = '' then
          TableList.IdTCTID := 0
        else
          TableList.IdTCTID := Que_ListTypeComptable.FieldByName('TCT_ID').AsInteger;

        TableList.IdUNIID := Que_ListUnivers.FieldByName('UNI_ID').AsInteger;

        // Ouverture du fichier FEDAS
        AddToMemo(mmLogs,' - Ouverture du fichier FEDAS');
        if LoadFedasData(TableList) then
        begin

          // 2- Convertion des tables
          AddToMemo(mmLogs,'3- Convertion des tables');
          if ConvertTbHF(TableList) then
          begin
            AddToMemo(mmLogs,'4- Vérification de la structure');
            // 3- Vérification de la structure et que les champs attendus existent
            if CheckFieldList(TableList) then
            begin
              // 4- transfert/création, dans la base de données, des articles
              AddToMemo(mmLogs,'5- Traitement des données');
              DoTraitement(TableList);
            end;
            AddToMemo(mmLogs,'--- Fin du Traitement des données ---');
          end; // if
        end;
      end; // if

      dDateFin := Now;
      iTemps := SecondsBetween(dDateDebut,dDateFin);
      sText := FormatFloat('00',iTemps Div 3600);
      iTemps := iTemps Mod 3600;
      sText := sText + FormatFloat(':00',iTemps Div 60) + FormatFloat(':00',iTemps Mod 60);
      AddToMemo(mmLogs,'Temps de traitement : ' + sText);
      AddToMemo(mmLogs,'---------------------------------');
      AddToMemo(mmLogs,'Nombre de fournisseurs traités : ' + IntToStr(TableList.iCptFournisseur));
      AddToMemo(mmLogs,'Nombre de marques traitées : ' + IntToStr(TableList.iCptMarque));
      AddToMemo(mmLogs,'Nombre d''articles traités : ' + IntToStr(TableList.iCptArticle));
      AddToMemo(mmLogs,'Nombre de couleurs traitées : ' + IntToStr(TableList.iCptCouleur));
      AddToMemo(mmLogs,'Nombre de tailles traités : ' + IntToStr(TableList.iCptTaille));
      AddToMemo(mmLogs,'---------------------------------');

      TableList.Free;
    end; // if
  Except on E:Exception do
    begin
      AddToMemo(mmLogs,E.Message);
    end;
  end; // with
end;

end.
