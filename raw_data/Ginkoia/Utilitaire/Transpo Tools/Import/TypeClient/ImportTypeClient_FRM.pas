unit ImportTypeClient_FRM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, Mask, RzEdit, RzBtnEdt, CategoryButtons, RzButton, RzLabel, RzShellDialogs,
  Traitement, DB, IBDatabase, IB_Components, IBSQL, IBODataset, dxmdaset, RzPrgres, RzBckgnd;

type
  TForm1 = class(TForm)
    Pan_Fenetre: TRzPanel;
    Gbx_Import: TRzGroupBox;
    Gbx_Export: TRzGroupBox;
    Chp_Import: TRzButtonEdit;
    Btn_Import: TRzButton;
    Chp_Export: TRzButtonEdit;
    Btn_Export: TRzButton;
    OpenDialog_import: TRzOpenDialog;
    OpenDialog_Export: TRzOpenDialog;
    RzLabel1: TRzLabel;
    Lab_text2: TRzLabel;
    Database: TIB_Connection;
    IbT_Transaction: TIB_Transaction;
    MemD_Export: TdxMemData;
    Que_Export: TIBOQuery;
    MemD_ExportCltNumeroPro: TStringField;
    MemD_ExportCltNumeroPart: TStringField;
    MemD_ExportDebut: TDateTimeField;
    MemD_ExportFin: TDateTimeField;
    Ds_Export: TDataSource;
    Que_ProcExport: TIBOQuery;
    Que_Tmp: TIBOQuery;
    RzProgressBar1: TRzProgressBar;
    OpenDialog_CSV: TRzOpenDialog;
    Lab_text: TRzLabel;
    Chp_ImportCSV: TRzButtonEdit;
    MemD_ImportCSV: TdxMemData;
    MemD_ImportCSVCltnumPro: TStringField;
    MemD_ImportCSVCltNumPart: TStringField;
    MemD_ImportCSVDateD: TDateTimeField;
    MemD_ImportCSVDateF: TDateTimeField;
    Que_GetCLTID: TIBOQuery;
    Gbx_Civilite: TRzGroupBox;
    Chp_Civilite: TRzButtonEdit;
    Lab_Civilite: TRzLabel;
    RzButton1: TRzButton;
    OpenDialog_Civilite: TRzOpenDialog;
    Lab_CheminBase: TRzLabel;
    Chp_CheminBaseCiv: TRzButtonEdit;
    OpenDialog_BaseCIV: TRzOpenDialog;
    Que_GetCIVID: TIBOQuery;
    Gbx_ReafMarque: TRzGroupBox;
    Chp_ChemainNosymag: TRzButtonEdit;
    Lab_ChemainNosymag: TRzLabel;
    Chp_AncienneBase: TRzButtonEdit;
    Lab_CheminAncienneBase: TRzLabel;
    RzButton2: TRzButton;
    OpenDialog_Nosymag: TRzOpenDialog;
    OpenDialog_11: TRzOpenDialog;
    Que_ProcRecupInfoMrk: TIBOQuery;
    MemD_ImportArtMrk: TdxMemData;
    MemD_ExportArt: TdxMemData;
    MemD_ExportArtChrono: TStringField;
    MemD_ExportArtArtNom: TStringField;
    MemD_ExportArtMrkNom: TStringField;
    MemD_ExportArtFouNom: TStringField;
    MemD_ImportArtMrkChrono: TStringField;
    MemD_ImportArtMrkArtNom: TStringField;
    Que_GetArtMrk: TIBOQuery;
    OpenDialog_FicInters: TRzOpenDialog;
    Gbx_ReaffectMrkArticle: TRzGroupBox;
    Chp_ImportFicInters: TRzButton;
    Chp_ImportFicIntersport: TRzButtonEdit;
    Lab_ImportFicIntersport: TRzLabel;
    Lab_ImpBaseNosy: TRzLabel;
    Chp_ImpBaseNosymag: TRzButtonEdit;
    OpenDialog_ImpNosymag: TRzOpenDialog;
    Que_GetMrk: TIBOQuery;
    Que_GetFourn: TIBOQuery;
    Que_GetArtID: TIBOQuery;
    Que_MrkBonFourn: TIBOQuery;
    Que_GetMrkArt: TIBOQuery;
    Que_GetCLTIDImpCiv: TIBOQuery;
    Que_SelectCIVID: TIBOQuery;
    Que_InsertCIV: TIBOQuery;
    Que_UpdateCIVID: TIBOQuery;
    procedure Chp_ExportButtonClick(Sender: TObject);
    procedure Chp_ImportButtonClick(Sender: TObject);
    procedure Btn_ExportClick(Sender: TObject);
    procedure Btn_ImportClick(Sender: TObject);
    procedure Chp_ImportCSVButtonClick(Sender: TObject);
    procedure Chp_CiviliteButtonClick(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
    procedure Chp_CheminBaseCivButtonClick(Sender: TObject);
    procedure Chp_ChemainNosymagButtonClick(Sender: TObject);
    procedure Chp_AncienneBaseButtonClick(Sender: TObject);
    procedure RzButton2Click(Sender: TObject);
    procedure Chp_ImportFicIntersportButtonClick(Sender: TObject);
    procedure Chp_ImportFicIntersClick(Sender: TObject);
    procedure Chp_ImpBaseNosymagButtonClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure traitementExport;
    procedure traitementImport;
    procedure InitialiseDatabase(Chemin : string);
    procedure ExportDonnee(memData : TdxMemData);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Btn_ExportClick(Sender: TObject);
begin
  if (Chp_Export.Text = '') then
  begin
    MessageDlg('Le chemin de la base de données doit être rempli', mtError,  [], 0);
    Exit;
  end;
  traitementExport;
end;

procedure TForm1.Btn_ImportClick(Sender: TObject);
var
  DossierExport : string;
  LstFichier    : TStringList;
  LstDonnee     : TStringList;
  i,j           : Integer;
  NumPro        : string;
  NumPart       : string;
  DateD         : TDateTime;
  DateF         : TDateTime;

  ProID         : Integer;
  PartID        : Integer;
  NewKID        : Integer;

  ValP1,ValP2   : Integer;
begin
  {$REGION 'Import type client'}
  //Code concernant l'import
  //Connecte la base de donnée
  InitialiseDatabase(Chp_Import.Text);

  if ((Chp_Import.Text = '') or (Chp_ImportCSV.Text = '')) then
  begin
    MessageDlg('Veuillez renseigner tous les champs d''import', mtError,  [], 0);
    Exit;
  end;

  //je charger le fichier csv
  if not FileExists(Chp_ImportCSV.Text) then
  begin
    MessageDlg('Fichier d''import inexistant', mtError,  [], 0);
    Exit;
  end;



  LstFichier := TStringList.Create;
  LstFichier.DelimitedText := ';';

  LstDonnee  := TStringList.Create;
  LstDonnee.Delimiter      := ';';

  LstFichier.LoadFromFile(Chp_ImportCSV.Text);

  //ProgressBar
  RzProgressBar1.Visible := True;
  RzProgressBar1.Percent := 0;
  ValP1                  := LstFichier.Count;

  //traitement
  for I := 1 to LstFichier.Count-1 do
  begin
    LstDonnee.DelimitedText := LstFichier[I];

    NumPro                  := LstDonnee[0];
    NumPart                 := LstDonnee[1];
    DateD                   := StrToDateTime(LstDonnee[2]);
    DateF                   := StrToDateTime(LstDonnee[3]);

    //PRO
    Que_GetCLTID.Close;
    Que_GetCLTID.ParamByName('CLTNUMERO').AsString := NumPro;
    Que_GetCLTID.Open;

    ProID := Que_GetCLTID.FieldByName('CLT_ID').AsInteger;

    //PARTICULIER
    Que_GetCLTID.Close;
    Que_GetCLTID.ParamByName('CLTNUMERO').AsString := NumPart;
    Que_GetCLTID.Open;

    PartID := Que_GetCLTID.FieldByName('CLT_ID').AsInteger;

    //NewK
    Que_Tmp.SQL.Clear;
    Que_Tmp.Close;
    Que_Tmp.SQL.Text := 'SELECT ID FROM PR_NEWK(''CLTMEMBREPRO'')';
    Que_Tmp.Open;

    NewKID := Que_Tmp.FieldByName('ID').AsInteger;

    //Insertion dans la nouvelle table
    //Vérification que la ligne à inserer n'existe pas dans la base
    Que_Tmp.SQL.Clear;
    Que_Tmp.Close;
    Que_Tmp.SQL.Text := 'SELECT PRM_ID ' +
                        'FROM CLTMEMBREPRO ' +
                        'JOIN K ON K_ID = PRM_ID AND K_ENABLED = 1' +
                        'WHERE PRM_CLTIDPRO = :IDPRO AND PRM_CLTIDPART = :IDPART ' +
                        'AND PRM_DEBUT = :DATED ';
    Que_Tmp.ParamCheck  := True;
    Que_Tmp.ParamByName('IDPRO').AsInteger  := ProID;
    Que_Tmp.ParamByName('IDPART').AsInteger := PartID;
    Que_Tmp.ParamByName('DATED').AsDateTime := DateD;
    Que_Tmp.Open;

    if (Que_Tmp.FieldByName('PRM_ID').AsInteger = 0) then
    begin
      // L'enregistrement n'existe pas , donc c'est bon
      Que_Tmp.SQL.Clear;
      Que_Tmp.Close;
      Que_Tmp.SQL.Text := 'INSERT INTO CLTMEMBREPRO (' +
                          'PRM_ID, PRM_CLTIDPRO, PRM_CLTIDPART, PRM_DEBUT, PRM_FIN)' +
                          'VALUES (:PRM_ID, :PRM_CLTIDPRO, :PRM_CLTIDPART, :PRM_DEBUT, :PRM_FIN)';
      Que_Tmp.ParamCheck  := True;
      Que_Tmp.ParamByName('PRM_ID').AsInteger         := NewKID;
      Que_Tmp.ParamByName('PRM_CLTIDPRO').AsInteger   := ProID;
      Que_Tmp.ParamByName('PRM_CLTIDPART').AsInteger  := PartID;
      Que_Tmp.ParamByName('PRM_DEBUT').AsDateTime     := DateD;
      Que_Tmp.ParamByName('PRM_FIN').AsDateTime       := DateF;
      Que_Tmp.ExecSQL;

      Que_Tmp.SQL.Clear;
      Que_Tmp.Close;
      Que_Tmp.SQL.Text                         := 'EXECUTE PROCEDURE PR_UPDATEK(:K,0);';
      Que_Tmp.ParamCheck                       := True;
      Que_Tmp.ParamByName('K').AsInteger       := NewKID;
      Que_Tmp.ExecSQL;
    end else
    begin
      //la ligne existe déjà
      raise Exception.Create('Enregistrement déjà present dans la base');
    end;
     RzProgressBar1.Percent :=  Round(((I)/(ValP1)) * 100);
     RzProgressBar1.Repaint;
     Application.ProcessMessages;
  end;
  RzProgressBar1.Visible := False;
  IbT_Transaction.Commit;
  MessageDlg('Import réussi avec succès', mtInformation,  [], 0);
  {$ENDREGION}
end;

procedure TForm1.Chp_ExportButtonClick(Sender: TObject);
begin
  //Lors du clique sélection d'une base de donnée Export
  OpenDialog_Export.InitialDir := 'C:\';
  OpenDialog_Export.Filter     := 'Interbase File|*.IB';
  if OpenDialog_Export.Execute then
  begin
    Chp_Export.Text := OpenDialog_Export.FileName;
  end;
end;

procedure TForm1.Chp_ImpBaseNosymagButtonClick(Sender: TObject);
var
  DossierExport : string;
begin
  //Lors du clique sélection d'une base de donnée Import
  DossierExport := 'C:\';
  OpenDialog_ImpNosymag.InitialDir := DossierExport;
  OpenDialog_ImpNosymag.Filter     := 'Interbase File|*.IB';
  if OpenDialog_ImpNosymag.Execute then
  begin
    Chp_ImpBaseNosymag.Text := OpenDialog_ImpNosymag.FileName;
  end;
end;

procedure TForm1.Chp_ImportButtonClick(Sender: TObject);
var
  DossierExport : string;
begin
  //Lors du clique sélection d'une base de donnée Import
  DossierExport := 'C:\';
  OpenDialog_import.InitialDir := DossierExport;
  OpenDialog_import.Filter     := 'Interbase File|*.IB';
  if OpenDialog_import.Execute then
  begin
    Chp_Import.Text := OpenDialog_import.FileName;
  end;
end;

procedure TForm1.Chp_ImportCSVButtonClick(Sender: TObject);
var
  DossierExport : string;  
begin
  //Code lancer pour selectionner et charger le csv
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'Export') then
  begin
    DossierExport := 'C:\';
  end else
  begin
    DossierExport := ExtractFilePath(Application.ExeName)+'Export';
  end;

  OpenDialog_CSV.InitialDir := DossierExport;
  OpenDialog_CSV.Filter     := 'Fichier .CSV|*.CSV';
  if OpenDialog_CSV.Execute then
  begin
    Chp_ImportCSV.Text := OpenDialog_CSV.FileName;
  end;
end;

procedure TForm1.Chp_ImportFicIntersClick(Sender: TObject);
var
  LstFichier     : TStringList;
  LstDonnee      : TStringList;
  i,j            : Integer;
  MrkNom         : string;
  MRKID          : Integer;
  FouNom         : String;
  Chrono, ArtNom : string;
  ArtID          : Integer;
  ValP1          : Integer;
begin
  {$REGION 'Reaffectation article marque'}
  if ((Chp_ImportFicIntersport.Text = '') or (Chp_ImpBaseNosymag.Text = '')) then
  begin
    MessageDlg('Fichier introuvable', mtError,  [], 0);
    Exit;
  end;

  InitialiseDatabase(Chp_ImpBaseNosymag.Text);

  LstFichier := TStringList.Create;
  LstFichier.DelimitedText := ';';

  LstDonnee  := TStringList.Create;
  LstDonnee.Delimiter      := ';';

  LstDonnee.StrictDelimiter := True;

  LstFichier.LoadFromFile(Chp_ImportFicIntersport.Text);
  ValP1 := LstFichier.Count-1;
  RzProgressBar1.Visible := True;

  for I := 1 to LstFichier.Count-1 do
  begin
    LstDonnee.DelimitedText := LstFichier[I];

    MrkNom  := LstDonnee[2];
    FouNom  := LstDonnee[3];
    Chrono  := LstDonnee[0];
    ArtNom  := LstDonnee[1];

    //je vérifie que la marque est présente dans la base
    Que_GetMrk.Close;
    Que_GetMrk.ParamByName('MRKNOM').AsString := MrkNom;
    Que_GetMrk.Open;

    MRKID := Que_GetMrk.FieldByName('MRK_ID').AsInteger;

    if MRKID <> 0 then
    BEGIN
      //la marque existe, je vérifie que l'article n'est pas déjà sur la bonne marque
      Que_GetMrkArt.Close;
      Que_GetMrkArt.ParamByName('CHRONO').AsString := Chrono;
      Que_GetMrkArt.ParamByName('ARTNOM').AsString := ArtNom;
      Que_GetMrkArt.Open;

      if (Que_GetMrkArt.FieldByName('ART_MRKID').AsInteger <> MRKID) then
      begin
        //L'article n'est pas sur la bonne marque
        Que_GetArtID.Close;
        Que_GetArtID.ParamByName('CHRONO').AsString := Chrono;
        Que_GetArtID.ParamByName('ARTNOM').AsString := ArtNom;
        Que_GetArtID.Open;

        ArtID := Que_GetArtID.FieldByName('ART_ID').AsInteger;

        //une fois que j'ai le artid je modifie le art_mrkid puis je mouvemente
        Que_Tmp.SQL.Clear;
        Que_Tmp.Close;
        Que_Tmp.SQL.Text := 'UPDATE ARTARTICLE SET ART_MRKID = :MRKID ' +
                            'WHERE ART_ID = :ARTID ';
        Que_Tmp.ParamCheck := True;
        Que_Tmp.ParamByName('MRKID').AsInteger := MRKID;
        Que_Tmp.ParamByName('ARTID').AsInteger := ArtID;
        Que_Tmp.ExecSQL;
        IbT_Transaction.Commit;

        Que_Tmp.SQL.Clear;
        Que_Tmp.Close;
        Que_Tmp.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:KID,0)';
        Que_Tmp.ParamCheck := True;
        Que_Tmp.ParamByName('KID').AsInteger := ArtID;
        Que_Tmp.ExecSQL;
        IbT_Transaction.Commit;
      end;

    END else
    begin
      //MessageDlg('Marque inexistante dans la base', mtError,  [], 0);
    end;

  RzProgressBar1.Percent :=  Round(((I)/(ValP1)) * 100);
  RzProgressBar1.Repaint;
  Application.ProcessMessages;
  end;  //Fin du FOR
  RzProgressBar1.Visible := False;
  {$ENDREGION}
end;

procedure TForm1.Chp_ImportFicIntersportButtonClick(Sender: TObject);
var
  DossierExport : string;
begin
  //Code choix de la base pour l'import du fichier intersport
  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'Export') then
  begin
    DossierExport := 'C:\';
  end else
  begin
    DossierExport := ExtractFilePath(Application.ExeName)+'Export';
  end;

  OpenDialog_FicInters.InitialDir := DossierExport;
  OpenDialog_FicInters.Filter     := 'Fichier CSV|*.CSV';
  if OpenDialog_FicInters.Execute then
  begin
    Chp_ImportFicIntersport.Text := OpenDialog_FicInters.FileName;
  end;
end;

procedure TForm1.ExportDonnee(memData: TdxMemData);
var
  CheminExe : string;
begin
  //procedure d'exportation des données en CSV
  //Dossier de sauvegarde
  CheminExe := ExtractFilePath(Application.ExeName);

  if not DirectoryExists(CheminExe+'\Export') then
  begin
    if not CreateDir(CheminExe+'\Export') then
    begin
      raise Exception.Create('Création du dossier '+CheminExe+'\Export');
    end;
  end;

  //export du memData
  memData.DelimiterChar := ';';
  try
    memData.SaveToTextFile(CheminExe+'\Export\TypeClient.csv');
    MessageDlg('Export réussi avec succès', mtInformation,  mbOKCancel, 0);
    Chp_ImportCSV.Text := CheminExe+'\Export\TypeClient.csv';
  except on e:Exception do
    begin
      MessageDlg(e.Message, mtError,  [], 0);
    end
  end;
end;

procedure TForm1.InitialiseDatabase(Chemin : string);
begin
  Database.Disconnect;
  Database.DatabaseName := Chemin;
  try
    Database.Connect;
  except on e:Exception do
    begin
      MessageDlg(e.Message,mtError, [], 0);
    end;
  end;

end;

procedure TForm1.RzButton1Click(Sender: TObject);
var
  DossierExport : string;
  LstFichier    : TStringList;
  LstDonnee     : TStringList;
  i,j           : Integer;
  Civilite      : string;
  CLINUMERO     : string;
  NOM,PRENOM    : string;
  CLTID, CIVID  : Integer;
  VALP1         : Integer;
  Sqt1,Sqt2     : string;
  FicT          : Integer;
  NewKCiv       : Integer;
begin
  {$REGION 'Import puis réaffection de la civilité client'}
  FicT := 0;
  // Code du traitement pour le traitement de la civilité
  if ((Chp_Civilite.Text = '') or (Chp_CheminBaseCiv.Text = ''))  then
  begin
    MessageDlg('Les champs ne peuvent pas être vide', mtError,  [], 0);
    Exit;
  end;

  InitialiseDatabase(Chp_CheminBaseCiv.Text);

  LstFichier := TStringList.Create;
  LstFichier.DelimitedText := ';';
  LstFichier.StrictDelimiter:= True;

  LstDonnee  := TStringList.Create;
  LstDonnee.Delimiter      := ';';
  LstDonnee.StrictDelimiter:= True;

  LstFichier.LoadFromFile(Chp_Civilite.Text);

  Que_GetCIVID.ExecSQL;
  //IbT_Transaction.Commit;
  RzProgressBar1.Visible := True;

  VALP1 := LstFichier.Count -1;

  for I := 0 to LstFichier.Count -1  do
  begin
    try
      //bout de code qui squizz une erreur qui peut avoir dans le fichier
      if (Pos('""',LstFichier[I]) <> 0) then
      begin
        LstFichier[I] := StringReplace(LstFichier[I],'"""""""""""""""""""""','""""""""""""""""""""""',[]);
      end;
      Application.ProcessMessages;

      LstDonnee.DelimitedText := LstFichier[I];

      Civilite                := LstDonnee[4];
      CLINUMERO               := LstDonnee[24];
      NOM                     := LstDonnee[2];
      PRENOM                  := LstDonnee[3];

      CIVID                   := 0;

      // Je recherche le CLT_ID avec les infos ci-dessous

      Que_GetCLTIDImpCiv.Close;
      Que_GetCLTIDImpCiv.ParamCheck                     := True;
      Que_GetCLTIDImpCiv.ParamByName('CLTNUM').AsString := CLINUMERO;
      Que_GetCLTIDImpCiv.Open;

      CLTID := Que_GetCLTIDImpCiv.FieldByName('CLT_ID').AsInteger;

      if CLTID = 0 then
      begin
        //si la recherche par le nom et prenom n'a rien donné on cherche avec le nom prénom
        Que_Tmp.SQL.Clear;
        Que_Tmp.Close;
        Que_Tmp.SQL.Text := 'SELECT CLT_ID ' +
                            'FROM CLTCLIENT ' +
                            'JOIN K ON K_ID = CLT_ID AND K_ENABLED = 1' +
                            'WHERE CLT_NOM = :NOM AND CLT_PRENOM = :PRENOM AND CLT_CIVID = 0';
        Que_Tmp.ParamCheck  := True;
        Que_Tmp.ParamByName('NOM').AsString     := NOM;
        Que_Tmp.ParamByName('PRENOM').AsString  := PRENOM;
        Que_Tmp.Open;

        CLTID := Que_Tmp.FieldByName('CLT_ID').AsInteger;
      end;

      if CLTID <> 0 then
      begin

        //if ((Civilite <> ' ') or (Length(Civilite) > 3)) then
        if Length(Civilite) > 3 then
        begin
          Que_SelectCIVID.Close;
          Que_SelectCIVID.ParamByName('CIVNOM').AsString  := UpperCase(Civilite);
          Que_SelectCIVID.Open;

          CIVID := Que_SelectCIVID.FieldByName('CIV_ID').AsInteger;

          if CIVID = 0 then
          begin
            //on crait la civilité dans la base
            Que_Tmp.SQL.Clear;
            Que_Tmp.Close;
            Que_Tmp.SQL.Text := 'SELECT ID from PR_NEWK(''GENCIVILITE'')';
            Que_Tmp.Open;

            NewKCiv := Que_Tmp.FieldByName('ID').AsInteger;

            Que_InsertCIV.Close;
            Que_InsertCIV.ParamCheck                      := True;
            Que_InsertCIV.ParamByName('CIVID').AsInteger  := NewKCiv;
            Que_InsertCIV.ParamByName('NOM').AsString     := Civilite;
            Que_InsertCIV.ParamByName('SEXE').AsInteger   := 0;
            Que_InsertCIV.ExecSQL;

            //je mouvemente la nouvelle civilité creer
            Que_Tmp.SQL.Clear;
            Que_Tmp.Close;
            Que_Tmp.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:KID,0)';
            Que_Tmp.ParamCheck                   := True;
            Que_Tmp.ParamByName('KID').AsInteger := NewKCiv;
            Que_Tmp.ExecSQL;

            CIVID := NewKCiv;
          end;
        end;

      if CIVID <> 0 then
      begin
        Que_UpdateCIVID.Close;
        Que_UpdateCIVID.ParamCheck                     := True;
        Que_UpdateCIVID.ParamByName('CIVID').AsInteger := CIVID;
        Que_UpdateCIVID.ParamByName('CLTID').AsInteger := CLTID;
        Que_UpdateCIVID.ExecSQL;

        Que_Tmp.SQL.Clear;
        Que_Tmp.Close;
        Que_Tmp.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:KID,0)';
        Que_Tmp.ParamCheck                   := True;
        Que_Tmp.ParamByName('KID').AsInteger := CLTID;
        Que_Tmp.ExecSQL;
        Inc(FicT,1);
        IbT_Transaction.PostAll;
      end;

      end;
    except on e:Exception do
        begin
          raise Exception.Create(e.Message);
        end;
    end;

      RzProgressBar1.Percent :=  Round(((I)/(ValP1)) * 100);
      RzProgressBar1.Repaint;
      Application.ProcessMessages;
  end;
  Que_Tmp.SQL.Clear;
  Que_Tmp.Close;
  Que_Tmp.SQL.Text := 'DROP PROCEDURE GETCIVID';
  Que_Tmp.ExecSQL;
  IbT_Transaction.Commit;
  RzProgressBar1.Visible := False;

  MessageDlg(IntToStr(FicT)+' client(s) traité(s)', mtInformation,  [], 0);
  {$ENDREGION}
end;

procedure TForm1.RzButton2Click(Sender: TObject);
var
  i          : Integer;
  val1       : Integer;
  CheminExe  : string;
  test       : Boolean;
begin
  {$REGION 'Export fichier pour intersport'}
  if ((Chp_ChemainNosymag.Text = '') or (Chp_AncienneBase.Text = ''))  then
  begin
    MessageDlg('Les champs ne peuvent pas être vide', mtError,  [], 0);
    Exit;
  end;

  InitialiseDatabase(Chp_ChemainNosymag.Text);

  Que_ProcRecupInfoMrk.Close;
  Que_ProcRecupInfoMrk.ExecSQL;

  Que_Tmp.Close;
  Que_Tmp.SQL.Clear;
  Que_Tmp.SQL.Text                       := 'SELECT * FROM SJ_RECUP_ARTMRK(:MRKNOM)';
  Que_Tmp.ParamCheck                     := True;
  Que_Tmp.ParamByName('MRKNOM').AsString := 'SANSMARQUE';
  Que_Tmp.Open;
  Que_Tmp.First;

  //progressBar
  RzProgressBar1.Visible := True;
  i                      := 0;
  val1                   := Que_Tmp.RecordCount;
  //ouverture du MemData
  MemD_ImportArtMrk.Close;
  MemD_ImportArtMrk.Open;


  while not (Que_Tmp.Eof) do
  begin
    MemD_ImportArtMrk.Append;
    MemD_ImportArtMrkChrono.AsString := Que_Tmp.FieldByName('Chrono').AsString;
    MemD_ImportArtMrkArtNom.AsString := Que_Tmp.FieldByName('Nom').AsString;
    MemD_ImportArtMrk.Post;
    Inc(i,1);
    RzProgressBar1.Percent :=  Round((((I)/(val1)) * 100)/2);
    Application.ProcessMessages;
    Que_Tmp.Next;
  end;

  //une fois le memData rempli je me connect à la 11.2 afin de récuper plus d'info sur les articles
  //puis sauvegarde en fichier .CSV
  InitialiseDatabase(Chp_AncienneBase.Text);
  Que_Tmp.Close;
  Que_Tmp.SQL.Clear;
  MemD_ExportArt.DelimiterChar := ';';
  MemD_ExportArt.Open;

  MemD_ImportArtMrk.First;

  Que_GetArtMrk.Close;
  Que_GetArtMrk.ParamCheck := True;
  val1                     := MemD_ImportArtMrk.RecordCount;
  while not (MemD_ImportArtMrk.Eof) do
  begin
    Que_GetArtMrk.Close;
    Que_GetArtMrk.ParamByName('Chrono').AsString := MemD_ImportArtMrkChrono.AsString;
    Que_GetArtMrk.ParamByName('ArtNom').AsString := MemD_ImportArtMrkArtNom.AsString;
    Que_GetArtMrk.Open;

    if Que_GetArtMrk.RecordCount <> 0 then
    begin
      MemD_ExportArt.Append;
      MemD_ExportArtChrono.AsString := Que_GetArtMrk.FieldByName('ARF_CHRONO').AsString;
      MemD_ExportArtArtNom.AsString := Que_GetArtMrk.FieldByName('ART_NOM').AsString;
      MemD_ExportArtMrkNom.AsString := Que_GetArtMrk.FieldByName('MRK_NOM').AsString;
      MemD_ExportArtFouNom.AsString := Que_GetArtMrk.FieldByName('FOU_NOM').AsString;
      MemD_ExportArt.Post;
    end;
    Inc(I,1);
    RzProgressBar1.Percent :=  Round((((I)/(val1)) * 100)/2);
    Application.ProcessMessages;
    MemD_ImportArtMrk.Next;
  end;

  RzProgressBar1.Visible := False;

  //dossier de sauvegarde
  CheminExe := ExtractFilePath(Application.ExeName);

  if not DirectoryExists(CheminExe+'\Export') then
  begin
    if not CreateDir(CheminExe+'\Export') then
    begin
      raise Exception.Create('Création du dossier '+CheminExe+'\Export');
    end;
  end;

  MemD_ExportArt.SaveToTextFile(CheminExe+'\Export\FicIntersport.csv');
  MessageDlg('Export réussi avec succès', mtInformation,  [], 0);
  {$ENDREGION}
end;

procedure TForm1.Chp_AncienneBaseButtonClick(Sender: TObject);
begin
  //Code choix de la base 11.2
  OpenDialog_11.InitialDir := 'C:\';
  OpenDialog_11.Filter     := 'Fichier Interbase|*.IB';
  if OpenDialog_11.Execute then
  begin
    Chp_AncienneBase.Text := OpenDialog_11.FileName;
  end;
end;

procedure TForm1.Chp_ChemainNosymagButtonClick(Sender: TObject);
begin
  //Code choix de la base nosymag
  OpenDialog_Nosymag.InitialDir := 'C:\';
  OpenDialog_Nosymag.Filter     := 'Fichier Interbase|*.IB';
  if OpenDialog_Nosymag.Execute then
  begin
    Chp_ChemainNosymag.Text := OpenDialog_Nosymag.FileName;
  end;
end;

procedure TForm1.Chp_CheminBaseCivButtonClick(Sender: TObject);
begin
  //Code choix de la base pour l'import civilite
  // Code appeller pour la civilité
  OpenDialog_BaseCIV.InitialDir := 'C:\';
  OpenDialog_BaseCIV.Filter     := 'Fichier Interbase|*.IB';
  if OpenDialog_BaseCIV.Execute then
  begin
    Chp_CheminBaseCiv.Text := OpenDialog_BaseCIV.FileName;
  end;
end;

procedure TForm1.Chp_CiviliteButtonClick(Sender: TObject);
begin
  // Code appeller pour la civilité
  OpenDialog_Civilite.InitialDir := 'C:\';
  OpenDialog_Civilite.Filter     := 'Fichier .CSV|*.CSV';
  if OpenDialog_Civilite.Execute then
  begin
    Chp_Civilite.Text := OpenDialog_Civilite.FileName;
  end;
end;

procedure TForm1.traitementExport;
var
  ValProgr1, ValProgr2 : Integer;
begin
  {$region 'Export type client'}
  //Code concernant l'export
  //Connecte la base de donnée
  InitialiseDatabase(Chp_Export.Text);

//  Que_ProcExport.SQL.Clear;
  Que_ProcExport.ExecSQL;

  Que_Tmp.SQL.Clear;
  Que_Tmp.SQL.Text := 'SELECT * FROM SJ_EXPORT_TYPECLIENT';
  Que_Tmp.Open;

  Que_Tmp.First;

  // Ouverture du memData
  MemD_Export.Open;

  RzProgressBar1.Visible := True;
  //RzProgressBar1.Percent := 1;
  ValProgr1 := Que_Tmp.RecordCount;
  ValProgr2 := 0;

  while not (Que_Tmp.Eof) do
  begin
    // je remplis mon memData
    Inc(ValProgr2,1);
    MemD_Export.Append;
    MemD_ExportCltNumeroPro.AsString  := Que_Tmp.FieldByName('CltNumPro').AsString;
    MemD_ExportCltNumeroPart.AsString := Que_Tmp.FieldByName('CltNumPart').AsString;
    MemD_ExportDebut.AsDateTime       := Que_Tmp.FieldByName('DATEDEBUT').AsDateTime;
    MemD_ExportFin.AsDateTime         := Que_Tmp.FieldByName('DATEFIN').AsDateTime;
    MemD_Export.Post;
    RzProgressBar1.Percent            := Round(((ValProgr2)/(ValProgr1)) * 100);
    RzProgressBar1.Repaint;
    Que_Tmp.Next;
  end;

  RzProgressBar1.Percent := 100;
  RzProgressBar1.Visible := False;
  ExportDonnee(MemD_Export);

  Que_Tmp.SQL.Clear;
  Que_Tmp.SQL.Text := 'DROP PROCEDURE SJ_EXPORT_TYPECLIENT';
  Que_Tmp.ExecSQL;
  {$ENDREGION}
end;

procedure TForm1.traitementImport;
begin
  //Code concernant l'import
  InitialiseDatabase(Chp_Import.Text);
end;

end.
