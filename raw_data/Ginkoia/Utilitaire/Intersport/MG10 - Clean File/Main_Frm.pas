unit Main_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  StrUtils,
  //Début Uses Perso
  DBClient,
  DB,
  uDefs,
  UVersion,
  MidasLib,
  //Fin Uses
  Vcl.Buttons, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ComCtrls;

type
  TFrm_Main = class(TForm)
    pc_Traitement: TPageControl;
    ts_Base: TTabSheet;
    Gb_PathDir: TGroupBox;
    Dlb_PathDir: TDirectoryListBox;
    Dcb_Drive: TDriveComboBox;
    Lbl_Etat: TLabel;
    Gb_ListeMag: TGroupBox;
    btn_AjoutMag: TSpeedButton;
    btn_SupMag: TSpeedButton;
    Lbx_CodeMag: TListBox;
    Gb_ListeFichier: TGroupBox;
    cbx_Client: TCheckBox;
    cbx_Comptes: TCheckBox;
    cbx_ConditionFournisseur: TCheckBox;
    cbx_Caisse: TCheckBox;
    cbx_Reception: TCheckBox;
    cbx_RetourFournisseur: TCheckBox;
    cbx_Commande: TCheckBox;
    cbx_Consodiv: TCheckBox;
    cbx_Prixdevente: TCheckBox;
    cbx_Prixdeventeindicatif: TCheckBox;
    cbx_Transfert: TCheckBox;
    Btn_Clean: TButton;
    ts_Fidelite: TTabSheet;
    Gb_PathDir_Fid: TGroupBox;
    Dlb_PathDir_Fid: TDirectoryListBox;
    Dcb_Drive_Fid: TDriveComboBox;
    btn_traitement: TButton;
    lbl_Etat_Fid: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Btn_CleanClick(Sender: TObject);
    procedure btn_AjoutMagClick(Sender: TObject);
    procedure btn_SupMagClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_traitementClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
    function LoadDataSet(aMsg:string;aPathFile:string;aCle:string;aCDS:TclientDataSet):Boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;
  Compteur      : Integer=0;          //Compte le nombre de matériel traité
  NbLigne       : Integer;            //Nombre de ligne à traité

implementation

{$R *.dfm}

procedure TFrm_Main.btn_AjoutMagClick(Sender: TObject);
var
  sTmp : string;
begin
  sTmp := InputBox('Ajout d''un magasin', 'Veuillez saisir le code magasin :', '');
  Lbx_CodeMag.Items.Add(sTmp);
end;

procedure TFrm_Main.Btn_CleanClick(Sender: TObject);
var
  sPath : string;
  cdsTmp,
  cdsKeep,
  cdsDel  : TStringList;

  procedure Traitement(aCSV : string);
  var
    i   : Integer;
    j   : Integer;
    bOk : Boolean;
  begin
    if FileExists(sPath + aCSV) then
    begin
      cdsTmp.Clear;
      cdsKeep.Clear;
      cdsDel.Clear;

      cdsTmp.LoadFromFile(sPath + aCSV);

      j := 0;
      while j < cdsTmp.Count do
      begin
        bOk := False;
        i := 0;
        while (i < Lbx_CodeMag.Count) and (not bOk) do
        begin
          if POS(UpperCase(';' + Lbx_CodeMag.Items.Strings[i]) + ';', UpperCase(cdsTmp.Strings[j])) <> 0 then
          begin
            cdsKeep.Add(cdsTmp.Strings[j]);
            bOk := True;
          end;
          Inc(i);
        end;

        if not bOk then
          cdsDel.Add(cdsTmp.Strings[j]);

        Inc(j);
      end;
      cdsKeep.SaveToFile(sPath + 'Keep\' + aCSV);
      cdsDel.SaveToFile(sPath + 'Del\' + aCSV);
    end;
  end;
begin
  //Partie Traitement des fichiers
  sPath := Dlb_PathDir.Directory + '\';

  //Création des dossiers
  if not System.SysUtils.DirectoryExists(sPath + 'Del') then
    CreateDir(sPath + 'Del');
  if not System.SysUtils.DirectoryExists(sPath + 'Keep') then
    CreateDir(sPath + 'Keep');

  //Construction du filtre avec la liste des Magasins.
  if Pos('GENERAL',Lbx_CodeMag.Items.Text) = 0 then
    Lbx_CodeMag.Items.Add('GENERAL');

  cdsTmp  := TStringList.Create;
  cdsKeep := TStringList.Create;
  cdsDel  := TStringList.Create;
  try
    //Client
    if cbx_Client.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Client';
      Application.ProcessMessages;
      Traitement(Clients_CSV);
    end;

    //Comptes
    if cbx_Comptes.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Comptes';
      Application.ProcessMessages;
      Traitement(Comptes_CSV);
    end;

    //Condition fournisseur
    if cbx_ConditionFournisseur.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Condition Fournisseur';
      Application.ProcessMessages;
      Traitement(FouCondition_CSV);
    end;

    //Caisse
    if cbx_Caisse.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Caisse';
      Application.ProcessMessages;
      Traitement(Caisse_CSV);
    end;

    //Réception
    if cbx_Reception.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Réception';
      Application.ProcessMessages;
      Traitement(Reception_CSV);
    end;

    //Consodiv
    if cbx_Consodiv.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Consodiv';
      Application.ProcessMessages;
      Traitement(Consodiv_CSV);
    end;

    //Commande
    if cbx_Commande.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Commande';
      Application.ProcessMessages;
      Traitement(Commandes_CSV);
    end;

    //Retour Fournisseur
    if cbx_RetourFournisseur.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Fournisseur';
      Application.ProcessMessages;
      Traitement(RetourFou_CSV);
    end;

    //Prix de vente
    if cbx_Prixdevente.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Prix de vente';
      Application.ProcessMessages;
      Traitement(Prix_Vente_CSV);
    end;

    //Prix de vente indicatif
    if cbx_Prixdeventeindicatif.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Prix de vente indicatif';
      Application.ProcessMessages;
      Traitement(Prix_Vente_Indicatif_CSV);
    end;

    //Transfert
    if cbx_Transfert.Checked then
    begin
      Lbl_Etat.Caption := 'Traitement : Transfert';
      Application.ProcessMessages;
      Traitement(Transfert_CSV);
    end;
  finally
    FreeAndNil(cdsTmp);
    FreeAndNil(cdsKeep);
    FreeAndNil(cdsDel);
  end;

  Lbl_Etat.Caption := 'Traitement :';
  Application.ProcessMessages;
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.btn_SupMagClick(Sender: TObject);
var
  i : Integer;
begin
  i := 0;
  while (i <= Lbx_CodeMag.Count - 1)  do
  begin
    if Lbx_CodeMag.Selected[i] then
      Lbx_CodeMag.Items.Delete(i);
    Inc(i);
  end;
end;

function TFrm_Main.LoadDataSet(aMsg, aPathFile, aCle: string;
  aCDS: TclientDataSet):Boolean;
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

Procedure TFrm_Main.CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
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
    InfoLigne.Delimiter := ';';
    InfoLigne.DelimitedText := Donnees.Strings[0];
    for I := 0 to InfoLigne.Count - 1 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;
    CDS.CreateDataSet;
    //CDS.AddIndex('idx', Index, []);

    //Traitement des lignes de données
    CDS.Open;

    for I := 1 to Donnees.Count - 1 do
      begin
        InfoLigne.Clear;
        InfoLigne.Delimiter := ';';
        InfoLigne.QuoteChar := '''';
        Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
        Chaine  := ReplaceStr(Chaine,';',''';''');
        Chaine  := Chaine + '''';

        InfoLigne.DelimitedText := Chaine;
        CDS.Insert;
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
End;

procedure TFrm_Main.btn_traitementClick(Sender: TObject);
var
  sPath : string;
  cdsClient,
  cdsCompte : TClientDataSet;
  cdsKeep,
  Tmp_SL  : TStringList;
  i   : Integer;
  j   : Integer;
  bOk : Boolean;

  function GetHeader(aTab:array of string):string;
  var
    i : Integer;
  begin
    Result := '';
    for i := 0 to Length(aTab) - 1 do
      if Result = '' then
        Result := aTab[i]
      else
        Result := Result + ';' + aTab[i];
  end;
begin
  //Partie Traitement des fichiers
  sPath := Dlb_PathDir_Fid.Directory + '\';

  //Création des dossiers
  if not System.SysUtils.DirectoryExists(sPath + 'Fidélité') then
    CreateDir(sPath + 'Fidélité');

  cdsClient := TClientDataSet.Create(nil);
  cdsCompte := TClientDataSet.Create(nil);
  cdsKeep   := TStringList.Create;
  try
    //Client
    Lbl_Etat_Fid.Caption := 'Traitement : Chargement des clients';
    Application.ProcessMessages;
    if FileExists(sPath + Clients_CSV) then
    begin
      Tmp_SL := TStringList.Create;
      try
        Tmp_SL.LoadFromFile(sPath + Clients_CSV);      //Chargement du fichier
        Tmp_SL.Insert(0,GetHeader(Clients_COL));          //Ajout de l'en-tête
        Tmp_SL.SaveToFile(sPath + Clients_CSV);        //Enregistrement du fichier
      finally
      FreeAndNil(Tmp_SL);
      end;
      LoadDataSet('Clients', sPath + Clients_CSV, 'CODE',cdsClient);
    end;

    //Comptes
    Lbl_Etat_Fid.Caption := 'Traitement : Chargement des comptes';
    Application.ProcessMessages;
    if FileExists(sPath + Comptes_CSV) then
    begin
      Tmp_SL := TStringList.Create;
      try
        Tmp_SL.LoadFromFile(sPath + Comptes_CSV);      //Chargement du fichier
        Tmp_SL.Insert(0,GetHeader(Comptes_COL));          //Ajout de l'en-tête
        Tmp_SL.SaveToFile(sPath + Comptes_CSV);        //Enregistrement du fichier
      finally
      FreeAndNil(Tmp_SL);
      end;
      LoadDataSet('Comptes', sPath + Comptes_CSV, 'CODE',cdsCompte);
    end;

    cdsCompte.First;
    while not cdsCompte.Eof do
    begin
      if cdsClient.Locate('CODE',cdsCompte.FieldByName('CODE').AsString,[]) then
      begin
        cdsKeep.Add(cdsCompte.FieldByName('CODE').AsString + ';' +
                    cdsCompte.FieldByName('LIBELLE').AsString + ';' +
                    cdsCompte.FieldByName('DATE').AsString + ';' +
                    cdsCompte.FieldByName('CREDIT').AsString + ';' +
                    cdsCompte.FieldByName('DEBIT').AsString + ';' +
                    cdsCompte.FieldByName('LETTRAGE').AsString + ';' +
                    cdsCompte.FieldByName('LETNUM').AsString + ';' +
                    cdsClient.FieldByName('CODE_MAG').AsString + ';' +
                    cdsCompte.FieldByName('ORIGINE').AsString + ';');
      end;
      cdsCompte.Next;
    end;
    cdsKeep.SaveToFile(sPath + 'Fidélité\' + Comptes_CSV);
  finally
    FreeAndNil(cdsClient);
    FreeAndNil(cdsCompte);
    FreeAndNil(cdsKeep);
  end;

  lbl_Etat_Fid.Caption := 'Traitement :';
  Application.ProcessMessages;
  ShowMessage('Traitement terminé.');
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Lbx_CodeMag.Items.SaveToFile(ChangeFileExt(Application.ExeName, '.lst'));
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Lbx_CodeMag.Items.Clear;
  Lbx_CodeMag.Items.LoadFromFile(ChangeFileExt(Application.ExeName, '.lst'));
  Caption := Caption +' - Version '+ GetNumVersionSoft();
  Lbl_Etat.Caption := 'Traitement : ';
  lbl_Etat_Fid.Caption := 'Traitement : ';
end;

end.
