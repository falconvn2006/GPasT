unit Main_Unit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  // Debut Uses

  // Fin uses
  Dialogs,
  Db, dxmdaset, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, ExtCtrls, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, dxDBGridRv, StdCtrls, RzLabel, LMDCustomComponent, LMDFileCtrl,
  CustomEditEnh, EditEnhRv, ApFolderDlg, Grids, DBGrids, IBDataset,
  DBTables, ApSaveDlg, CheckLst, ActionRv;

type
  TFrm_Main = class(TForm)
    MemD_ChargeFichier: TdxMemData;
    MemD_ChargeFichierCode: TStringField;
    MemD_ChargeFichierCode_Mrq: TStringField;
    MemD_ChargeFichierCode_GT: TStringField;
    MemD_ChargeFichierCode_Fourn: TStringField;
    MemD_ChargeFichierNom: TStringField;
    MemD_ChargeFichierDescription: TStringField;
    MemD_ChargeFichierRayon: TStringField;
    MemD_ChargeFichierFamille: TStringField;
    MemD_ChargeFichierGenre: TStringField;
    MemD_ChargeFichierClass1: TStringField;
    MemD_ChargeFichierClass2: TStringField;
    MemD_ChargeFichierClass3: TStringField;
    MemD_ChargeFichierClass4: TStringField;
    MemD_ChargeFichierClass5: TStringField;
    MemD_ChargeFichiernotused_code_couleur: TStringField;
    MemD_ChargeFichierCoul: TStringField;
    Ds_ChargeFichier: TDataSource;
    Ds_Result: TDataSource;
    MemD_Result: TdxMemData;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    StringField15: TStringField;
    MemD_ResultIDREF_SSFAM: TStringField;
    MemD_ResultCOUL1: TStringField;
    MemD_ResultCOUL2: TStringField;
    MemD_ResultCOUL3: TStringField;
    MemD_ResultCOUL4: TStringField;
    MemD_ResultCOUL5: TStringField;
    MemD_ResultCOUL6: TStringField;
    MemD_ResultCOUL7: TStringField;
    MemD_ResultCOUL8: TStringField;
    MemD_ResultCOUL9: TStringField;
    MemD_ResultCOUL10: TStringField;
    MemD_ResultCOUL11: TStringField;
    MemD_ResultCOUL12: TStringField;
    MemD_ResultCOUL13: TStringField;
    MemD_ResultCOUL14: TStringField;
    MemD_ResultCOUL15: TStringField;
    MemD_ResultCOUL16: TStringField;
    MemD_ResultCOUL17: TStringField;
    MemD_ResultCOUL18: TStringField;
    MemD_ResultCOUL19: TStringField;
    MemD_ResultCOUL20: TStringField;
    MemD_ChargeFichierss_fam: TStringField;
    MemD_ResultSS_FAM: TStringField;
    RepDlg_SelectFolder: TApFolderDialog;
    Ed_ExportFile: TEditEnhRv;
    OD_Export: TSaveDialog;
    Dbg_Articles: TdxDBGridRv;
    Dbg_ArticlesRecId: TdxDBGridColumn;
    Dbg_ArticlesCode: TdxDBGridMaskColumn;
    Dbg_ArticlesCode_Mrq: TdxDBGridMaskColumn;
    Dbg_ArticlesCode_GT: TdxDBGridMaskColumn;
    Dbg_ArticlesCode_Fourn: TdxDBGridMaskColumn;
    Dbg_ArticlesNom: TdxDBGridMaskColumn;
    Dbg_ArticlesDescription: TdxDBGridMaskColumn;
    Dbg_ArticlesRayon: TdxDBGridMaskColumn;
    Dbg_ArticlesFamille: TdxDBGridMaskColumn;
    Dbg_ArticlesSS_FAM: TdxDBGridMaskColumn;
    Dbg_ArticlesGenre: TdxDBGridMaskColumn;
    Dbg_ArticlesClass1: TdxDBGridMaskColumn;
    Dbg_ArticlesClass2: TdxDBGridMaskColumn;
    Dbg_ArticlesClass3: TdxDBGridMaskColumn;
    Dbg_ArticlesClass4: TdxDBGridMaskColumn;
    Dbg_ArticlesClass5: TdxDBGridMaskColumn;
    Dbg_ArticlesIDREF_SSFAM: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL1: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL2: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL3: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL4: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL5: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL6: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL7: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL8: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL9: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL10: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL11: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL12: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL13: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL14: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL15: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL16: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL17: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL18: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL19: TdxDBGridMaskColumn;
    Dbg_ArticlesCOUL20: TdxDBGridMaskColumn;
    Dbg_Fichier: TdxDBGridRv;
    Dbg_FichierRecId: TdxDBGridColumn;
    Dbg_FichierCode: TdxDBGridMaskColumn;
    Dbg_FichierCode_Mrq: TdxDBGridMaskColumn;
    Dbg_FichierCode_GT: TdxDBGridMaskColumn;
    Dbg_FichierCode_Fourn: TdxDBGridMaskColumn;
    Dbg_FichierNom: TdxDBGridMaskColumn;
    Dbg_FichierDescription: TdxDBGridMaskColumn;
    Dbg_FichierRayon: TdxDBGridMaskColumn;
    Dbg_FichierFamille: TdxDBGridMaskColumn;
    Dbg_Fichierss_fam: TdxDBGridMaskColumn;
    Dbg_FichierGenre: TdxDBGridMaskColumn;
    Dbg_FichierClass1: TdxDBGridMaskColumn;
    Dbg_FichierClass2: TdxDBGridMaskColumn;
    Dbg_FichierClass3: TdxDBGridMaskColumn;
    Dbg_FichierClass4: TdxDBGridMaskColumn;
    Dbg_FichierClass5: TdxDBGridMaskColumn;
    Dbg_Fichiernotused_code_couleur: TdxDBGridMaskColumn;
    Dbg_FichierCoul: TdxDBGridMaskColumn;
    Memo_ConcatFiles: TMemo;
    RzLabel3: TRzLabel;
    Ed_SelectFolder: TEditEnhRv;
    Nbt_SelectFolder: TLMDSpeedButton;
    Lab_ListeFichiers: TRzLabel;
    Lbx_Files: TCheckListBox;
    RzLabel5: TRzLabel;
    Nbt_Export: TLMDSpeedButton;
    Pan_PasAPas: TPanel;
    Nbt_ConcatFiles: TLMDSpeedButton;
    Nbt_LoadFiles: TLMDSpeedButton;
    Nbt_RemplitMemDRes: TLMDSpeedButton;
    RzLabel2: TRzLabel;
    Pan_TraiteAuto: TPanel;
    RzLabel4: TRzLabel;
    LMDSpeedButton1: TLMDSpeedButton;
    Lab_NbEnreg: TRzLabel;
    Lab_ResultArticles: TRzLabel;
    CheckBox1: TCheckBox;
    zLbx_Files : TListBox;
    MemD_NK: TdxMemData;
    MemD_NKUNI_NOM: TStringField;
    MemD_NKSECTEUR: TStringField;
    MemD_NKSEC_REF: TStringField;
    MemD_NKRAYON: TStringField;
    MemD_NKRAY_REF: TStringField;
    MemD_NKCATEGORIE: TStringField;
    MemD_NKCAT_REF: TStringField;
    MemD_NKFAMILLE: TStringField;
    MemD_NKFAM_N: TStringField;
    MemD_NKFAM_REF: TStringField;
    MemD_NKSOUS_FAMILLE: TStringField;
    MemD_NKSSF_N: TStringField;
    MemD_NKSSF_REF: TStringField;
    MemD_ResultFidelite: TStringField;
    Dbg_ArticlesFidelite: TdxDBGridMaskColumn;
    MemD_ChargeFichierDate_Recp: TStringField;
    MemD_ChargeFichierC_DOUAN: TStringField;
    MemD_ChargeFichierPAYS_ORIG: TStringField;
    MemD_ChargeFichierPOIDS: TStringField;
    MemD_ChargeFichierCOLLECTION: TStringField;
    MemD_ResultDate_Creat: TStringField;
    MemD_ResultCOLLECTION: TStringField;
    MemD_ResultCOMENT1: TStringField;
    MemD_ResultCOMENT2: TStringField;
    Dbg_FichierDate_Recp: TdxDBGridMaskColumn;
    Dbg_FichierC_DOUAN: TdxDBGridMaskColumn;
    Dbg_FichierPAYS_ORIG: TdxDBGridMaskColumn;
    Dbg_FichierPOIDS: TdxDBGridMaskColumn;
    Dbg_FichierCOLLECTION: TdxDBGridMaskColumn;
    Dbg_ArticlesDate_Creat: TdxDBGridMaskColumn;
    Dbg_ArticlesCOLLECTION: TdxDBGridMaskColumn;
    Dbg_ArticlesCOMENT1: TdxDBGridMaskColumn;
    Dbg_ArticlesCOMENT2: TdxDBGridMaskColumn;
    MemD_ChargeFichierTAUX_TVA: TStringField;
    Dbg_FichierTAUX_TVA: TdxDBGridMaskColumn;
    MemD_ResultTAUX_TVA: TStringField;
    Nbt_CheckAll: TLMDSpeedButton;
    Gax_Files: TActionGroupRv;
    procedure Nbt_LoadFilesClick(Sender: TObject);
    procedure Nbt_SelectFolderClick(Sender: TObject);
    procedure Nbt_ConcatFilesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_RemplitMemDResClick(Sender: TObject);
    procedure Ed_SelectFolderChange(Sender: TObject);
    procedure Nbt_ExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ed_ExportFileChange(Sender: TObject);
    procedure LMDSpeedButton1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Nbt_CheckAllClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure FileToMemo(sFileName: string; MyMemo: TMemo; DeleteFirstLine: boolean);
    procedure ConcatFiles();
    procedure LoadFileToMemData();
    procedure MemDataToResult();
    procedure sablier(b: boolean);
    procedure ListerFichier();
    procedure AffBoutons();
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation
var
  gsFileTemp: string = 'c:\temp.csv';
{$R *.DFM}

procedure TFrm_Main.Nbt_LoadFilesClick(Sender: TObject);
begin
  Sablier(True);

    // Charge le MemData avec le gros fichier (et le trie)
  LoadFileToMemData();

  Sablier(False);
end;

procedure TFrm_Main.FileToMemo(sFileName: string; MyMemo: TMemo; DeleteFirstLine: boolean);
var
  MyStringCharge: TStringList;

begin
  // On charge la stringlist avec le fichier
  MyStringCharge := TStringList.Create;
  try
    MyStringCharge.LoadFromFile(sFileName);

  // On supprime la ligne d'entete (si demandé)
    if DeleteFirstLine then MyStringCharge.Delete(0);

  // On ajoute le texte chargé à la zone mémo ( = Append)
    MyMemo.Lines.Append(MyStringCharge.Text);
  finally
    MyStringCharge.free;
  end;
end;

procedure TFrm_Main.Nbt_SelectFolderClick(Sender: TObject);
begin
  with RepDlg_SelectFolder do
  begin
    if Execute then
    begin
      Ed_SelectFolder.Text := FolderName;
    end;
  end;

end;

procedure TFrm_Main.Nbt_ConcatFilesClick(Sender: TObject);

begin
  Sablier(True);
  ConcatFiles();
  Sablier(False);
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MemD_ChargeFichier.Close;
  MemD_Result.Close;
  if OD_Export <> nil then OD_Export.free;
  if RepDlg_SelectFolder <> nil then RepDlg_SelectFolder.free;
  if fileexists(gsFileTemp) then
  begin
    DeleteFile(gsFileTemp);
  end;
end;

procedure TFrm_Main.Nbt_RemplitMemDResClick(Sender: TObject);
begin
  Sablier(True);

  MemDataToResult();

  Sablier(False);
end;

procedure TFrm_Main.LoadFileToMemData;
begin
  with MemD_ChargeFichier do
  begin
    DisableControls;
    // Chargement du fichier dans la liste
    DelimiterChar := ';';
    LoadFromTextFile(gsFileTemp);
    // On note le nombre de lignes
    Lab_NbEnreg.caption := 'Lignes dans le fichier source : ' + inttostr(Recordcount);
    EnableControls;
  end;
end;

procedure TFrm_Main.sablier(b: boolean);
begin
  // Affiche, désaffiche le sablier
  if b then Screen.Cursor := crHourGlass else Screen.Cursor := crDefault;
end;

procedure TFrm_Main.ConcatFiles;
var
  i: integer;

  DelFirstLine: boolean;
  FirstRecord: boolean;
  sFileSrc: string;

begin

  // On vide le memo, et on interdit l'affichage
  Memo_ConcatFiles.Clear;
  Memo_ConcatFiles.Lines.BeginUpdate;

  FirstRecord := true;
  for i := 0 to (Lbx_Files.Items.Count - 1) do
  begin
    if Lbx_Files.Checked[i] then
    begin
    // On ne suprimera la premiere ligne que sur les fichiers autres que le premier
      if FirstRecord then
      begin
        DelFirstLine := False;
        FirstRecord := False;
      end
      else
      begin
        DelFirstLine := True;
      end;

    // On transfert chaque fichier de la liste dans un mémo
      sFileSrc := IncludeTrailingBackSlash(Ed_SelectFolder.text) + Lbx_Files.Items.Strings[i];
      FileToMemo(sFileSrc, Memo_ConcatFiles, DelFirstLine);
    end;
  end;

  // Sauvegarde du memo sous forme de fichier dans l'emplacement tempo
  Memo_ConcatFiles.Lines.SaveToFile(gsFileTemp);

  // On re-vide le mémo, histoire d'etre surs !
  Memo_ConcatFiles.Clear;
  // On autorise l'affichage
  Memo_ConcatFiles.Lines.EndUpdate;
end;


procedure TFrm_Main.MemDataToResult;
var
  CurCode: string;
  MyGenre: string;
  MyString: string;
  SSfamille: string;
  i, j, nb: integer;
  bExists: boolean;
  eTempo : Extended;
  MyStringSSF, MyStringFam, MyStringRay: TStringList;
begin
  // Spécifie le séparateur décimal
  DecimalSeparator := '.';

  // Article en cours a vide
  CurCode := '';

  IF (FileExists(Ed_SelectFolder.Text + '\NK_EspaceMontagne.txt')) then
  begin

      MemD_NK.DelimiterChar := ';';
      MemD_NK.LoadFromTextFile(Ed_SelectFolder.Text + '\NK_EspaceMontagne.txt');
      MemD_NK.SaveToTextFile(Ed_SelectFolder.Text + '\test.txt');
      MemD_NK.LoadFromTextFile(Ed_SelectFolder.Text + '\test.txt');

      // On charge la stringlist avec le fichier
      MyStringSSF := TStringList.Create;
      MyStringFam := TStringList.Create;
      MyStringRay := TStringList.Create;
      try
        MemD_NK.First;
        while not MemD_NK.Eof do
        begin
          MyStringSSF.Add(MemD_NKSOUS_FAMILLE.asstring);
          MyStringFam.Add(MemD_NKFAMILLE.asstring);
          MyStringRay.Add(MemD_NKRAYON.asstring);
          MemD_NK.Next;
        end;
        MemD_NK.close;

        MemD_Result.open;
        with MemD_ChargeFichier do
        begin
          DisableControls;
          MemD_Result.DisableControls;

          Memo_ConcatFiles.clear;
          MyString := '';
          for j := 1 to 17 do
          begin
            MyString := MyString + ';' + Fields[j].FieldName;
          end;
          System.Delete(MyString, 1, 1);
          Memo_ConcatFiles.Lines.Add(MyString);

        // Debut parcours
          First;

        // On parcous la liste des articles
          while not eof do
          begin
          // On vérifie si on a changé de code article.
            if FieldByName('Code').asstring <> '' then
            begin
              if FieldByName('Code').asstring <> CurCode then
              begin
              // Dans ce cas, on crée la ligne avec comme couleur1 la couleur actuelle
              // On sauvegarde notre article en cours
                CurCode := MemD_ChargeFichierCode.asstring;

              // On remplace le Genre : J devient JUNIOR, H devient HOMME, F devient FEMME, le reste devient UNISEXE
                if FieldByName('Genre').asstring = 'J' then MyGenre := 'JUNIOR'
                else if FieldByName('Genre').asstring = 'H' then MyGenre := 'HOMME'
                else if FieldByName('Genre').asstring = 'F' then MyGenre := 'FEMME'
                else if FieldByName('Genre').asstring = 'H+F' then MyGenre := 'UNISEXE'
                else MyGenre := 'UNISEXE';

              // On entre en insertion dans la MemD résultat.
                MemD_Result.Append();

                // Modification tx de TVA (suppr du % et remplacement des , par des .)
                MemD_Result.FieldByName('TAUX_TVA').asstring := StringReplace(StringReplace(FieldByName('TAUX_TVA').asstring,'%','',[rfReplaceAll]),',','.',[rfReplaceAll]);
                TRY
                  eTempo := StrToFloat(MemD_Result.FieldByName('TAUX_TVA').asstring);
                EXCEPT
                  MemD_Result.FieldByName('TAUX_TVA').asstring := '';
                END;




              // Copie tous les champs 1 par 1 (17 au total)
                for i := 1 to 17 do
                begin
                  MemD_Result.Fields[i] := Fields[i];
                end;

              // mettre à jour la NK
                SSfamille := MemD_Result.FieldByName('SS_Fam').asstring;
                SSfamille := copy(SSfamille, 1, length(SSfamille) - 2);
                SSfamille := TRIM(SSfamille);
                SSfamille := SSfamille + '))';
                MemD_Result.FieldByName('SS_Fam').asstring := SSfamille;

              // SI  Rayon et Famille VIDE
                if MemD_Result.FieldByName('Rayon').asstring = '' then
                begin
                  nb := MyStringSSF.IndexOf(SSfamille);
                  if (nb <> -1) then
                  begin
                    MemD_Result.FieldByName('Famille').asstring := MyStringFam.Strings[nb];
                    MemD_Result.FieldByName('Rayon').asstring := MyStringRay.Strings[nb];
                  end;
                end;

              // Mettre à jour la colonne Fidelité de l'article
                MemD_Result.FieldByName('Fidelite').asstring := MemD_Result.FieldByName('Class2').asstring;
                MemD_Result.FieldByName('Class2').asstring := '';

              // On force le Code_GT comme le code article
                MemD_Result.FieldByName('Code_GT').asstring := FieldByName('Code').asstring;
              // Et le genre
                MemD_Result.FieldByName('Genre').asstring := MyGenre;

              // Nv pb : le champs description = la ref marque !!!
                MemD_Result.FieldByName('Code_Fourn').asstring := MemD_Result.FieldByName('Description').asstring ;
                MemD_Result.FieldByName('Description').asstring := '';
              // Nv champs à géréer
                MemD_Result.FieldByName('Date_Creat').asstring := FieldByName('Date_Recp').asstring;
                MemD_Result.FieldByName('COLLECTION').asstring := FieldByName('COLLECTION').asstring;
                MemD_Result.FieldByName('COMENT1').asstring := 'Code RETAIL = '+FieldByName('Code').asstring;
                MemD_Result.FieldByName('COMENT2').asstring := 'Code DOUANIER ='+ FieldByName('C_DOUAN').asstring +'/PAYS orig. ='+ FieldByName('PAYS_ORIG').asstring +'/Poids ='+FieldByName('POIDS').asstring;
              end
              else
              begin
              // Sinon, on est dans le cas ou l'article existe deja
              // on recherche si la couleur n'est pas encore dans la liste des couleurs de cet article
                i := 17;

              // bExists permet de savoir si la couleur existe deja dans la liste des couleurs
                bExists := False;
                while MemD_Result.Fields[i].asstring <> '' do
                begin
                  if MemD_Result.Fields[i].asstring = FieldByName('COUL').asstring then
                  begin
                  // On l'a trouvée, on sort
                    bExists := True;
                    BREAK;
                  end;

                // Colonne (et donc couleur) suivante
                  i := i + 1;

                // Sort de la boucle si on a dépassé le nombre de couleurs (tant pis, elles seront droppées)
                // 38 car 20 + 17
                  if i = 37 then
                  begin
                  // Comme il n'y a plus de place, on considère que la couleur a deja ete traitée
                    bExists := True;
    //              showmessage('Paf, plus de 20 couleurs');

                  // Sauver dans un fichier texte la liste des articles qui merdent....
                    MyString := '';
                    for j := 1 to 17 do
                    begin
                      MyString := MyString + ';' + Fields[j].asstring;
                    end;
                    System.Delete(MyString, 1, 1);
                    Memo_ConcatFiles.Lines.Add(MyString);

                    BREAK;
                  end;
                end;

              // Si bExists est faux, cela veut dire qu'on est sorti parce que la colonne etait vide
              // et que la couleur n'a pas ete trouvée, et que l'on est pas dans le cas I = 21.
              // Dans ce cas, et uniquement dans ce cas, on l'ajoute
                if not bExists then
                begin
                // On met la couleur sur la colonne i (i = derniere couleur + 1)
                  MemD_Result.Fields[i].asstring := FieldByName('COUL').asstring;
                end;

              end;
            end;

          // On passe au suivant
            Next;

          end;

          Memo_ConcatFiles.Lines.SaveToFile(ChangeFileExt(Ed_ExportFile.text, '_coul_error.csv'));

          EnableControls;
          MemD_Result.EnableControls;

          Lab_ResultArticles.Caption := 'Articles exportés : ' + inttostr(MemD_Result.RecordCount + 1);
          MemD_Result.DelimiterChar := ';';
          MemD_Result.SaveToTextFile(Ed_ExportFile.Text);

        end;
      finally
        MyStringSSF.free;
        MyStringFam.free;
        MyStringRay.free;
      end;
    end
    else
    begin
      Lab_ListeFichiers.Caption := 'ERREUR :: Il manque le fichier : NK_EspaceMontagne.txt';
      Gax_Files.Visible := False;
    end
end;

procedure TFrm_Main.Ed_SelectFolderChange(Sender: TObject);
begin
  ListerFichier();
  AffBoutons();

end;

procedure TFrm_Main.ListerFichier;
var
  MyFile: TSearchRec;
  ErrCode: Integer;
begin
  Lbx_Files.clear;
  if Ed_SelectFolder.Text <> '' then
  begin
  // On cherche le premier fichier texte
    ErrCode := FindFirst(IncludeTrailingBackSlash(Ed_SelectFolder.text) + '*.*', faAnyFile, MyFile);

    while ErrCode = 0 do
    begin
      if (MyFile.Name <> '.') and (MyFile.Name <> '..') then
      begin
        // On utilise le resultat
        Lbx_Files.Items.Add(MyFile.Name);
        Lbx_Files.Checked[Lbx_Files.items.count - 1] := False;

//        CheckListBox1.Items.Add(MyFile.Name);

      end;
      // On passe au fichier suivant
      ErrCode := FindNext(MyFile);

    end;

    if Lbx_Files.Items.Count > 0 then
    begin
    // On affiche la liste
      Lab_ListeFichiers.Caption := 'Liste des fichiers : ';
      Gax_Files.Visible := true;
    end
    else
    begin
      Lab_ListeFichiers.Caption := 'Aucun fichier dans ce dossier (' + Ed_SelectFolder.Text + ')';
      Gax_Files.Visible := False;
    end;
  end
  else
  begin
    Lab_ListeFichiers.Caption := 'Aucun fichier dans ce dossier (' + Ed_SelectFolder.Text + ')';
    Gax_Files.Visible := False;
  end;
end;


procedure TFrm_Main.Nbt_ExportClick(Sender: TObject);
begin
  with OD_Export do
  begin
    if Execute then
    begin
      Ed_ExportFile.Text := FileName;
    end;
  end;
end;

procedure TFrm_Main.AffBoutons;
var
  i: integer;
begin
  Lab_ResultArticles.caption := '';
  IF Gax_Files.visible = True then
  begin
    IF (FileExists(Ed_SelectFolder.Text + '\NK_EspaceMontagne.txt')) then
    begin
      Lab_NbEnreg.Caption := 'Dans la liste ci-dessus, choisir les fichiers articles à traiter';
    end
    else begin
      Lab_NbEnreg.Caption := 'ERREUR : Il manque le fichier : NK_EspaceMontagne.txt';
    END;
    if Ed_ExportFile.text <> '' then
    begin
      Pan_PasAPas.Enabled := True;
      Pan_TraiteAuto.Enabled := True;
    end
    else
    begin
      Pan_PasAPas.Enabled := False;
      Pan_TraiteAuto.Enabled := False;
    end;
  end
  else
  begin
    Pan_PasAPas.Enabled := False;
    Pan_TraiteAuto.Enabled := False;
    Lab_NbEnreg.Caption := '';
  end;

  with Pan_PasAPas do
  begin

    for i := 0 to ControlCount - 1 do
    begin
      if not (Controls[i] is TRzLabel) then
      begin
        Controls[i].Enabled := Enabled
      end;
    end;
  end;

  with Pan_TraiteAuto do
  begin

    for i := 0 to ControlCount - 1 do
    begin
      if not (Controls[i] is TRzLabel) then
      begin
        Controls[i].Enabled := Enabled
      end;
    end;
  end;


end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin

  ListerFichier();
  AffBoutons();
  CheckBox1Click(Sender);

end;

procedure TFrm_Main.Ed_ExportFileChange(Sender: TObject);
begin
  AffBoutons();
end;

procedure TFrm_Main.LMDSpeedButton1Click(Sender: TObject);
begin
  Sablier(True);

  // Concatene les fichiers
  ConcatFiles();

  // Charge le MemData avec le gros fichier (et le trie)
  LoadFileToMemData();


  // Traite les données et sauvegarde le résultat
  MemDataToResult();

  Sablier(False);

end;

procedure TFrm_Main.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.State = cbChecked then
  begin
    Frm_Main.Height := 844;
    Frm_Main.Width := 1384;
    Dbg_Articles.visible := true;
    Dbg_Fichier.visible := true;
  end
  else
  begin
    Frm_Main.Height := 300;
    Frm_Main.Width := 1086;
    Dbg_Articles.visible := false;
    Dbg_Fichier.visible := false;
  end;
end;

procedure TFrm_Main.Nbt_CheckAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to (Lbx_Files.Items.Count - 1) do
  begin
    Lbx_Files.Checked[i] := True;
  END;
end;

end.

