unit Unit1;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase,
  FireDAC.Comp.UI, Vcl.ComCtrls, System.Win.ComObj;

type
  TMainForm = class(TForm)
    BtnTraitement: TBitBtn;
    EditFichierExcel: TLabeledEdit;
    OpenDialogExcel: TOpenDialog;
    OpenDialogBase: TOpenDialog;
    EditBDD: TLabeledEdit;
    LabelEtape: TLabel;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysIBDriverLink: TFDPhysIBDriverLink;
    RichEdit: TRichEdit;
    FDQueryMaj: TFDQuery;
    CheckBoxCSV: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure BtnTraitementClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    _TabLignes: Array of Array[1..6] of String;

    procedure Traitement(const nUniID: Integer);

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
//
end;

procedure TMainForm.BtnTraitementClick(Sender: TObject);
var
  F: TextFile;
  sLigne: String;
  bLigneTitre: Boolean;
  Ligne: TStringList;
  Excel: Variant;
  nNumLigne, nUniID: Integer;
begin
  LabelEtape.Caption := 'Initialisations ...';
  RichEdit.Clear;
  SetLength(_TabLignes, 0);

  if EditFichierExcel.Text = '' then
  begin
    if CheckBoxCSV.Checked then
    begin
      OpenDialogExcel.DefaultExt := 'csv';
      OpenDialogExcel.FilterIndex := 2;
    end;

    // Si validation.
    if OpenDialogExcel.Execute then
      EditFichierExcel.Text := OpenDialogExcel.FileName
    else
      Exit;
  end;

  // Si fichier excel existe pas.
  if not FileExists(EditFichierExcel.Text) then
  begin
    Application.MessageBox('Erreur :  le fichier excel n''existe pas !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    Exit;
  end;

  if EditBDD.Text = '' then
  begin
    // Si validation.
    if OpenDialogBase.Execute then
      EditBDD.Text := OpenDialogBase.FileName
    else
      Exit;
  end;

  EditFichierExcel.Enabled := False;
  EditBDD.Enabled := False;
  BtnTraitement.Enabled := False;
  try
    LabelEtape.Caption := 'Connexion ...';
    Application.ProcessMessages;

    // Connexion.
    FDConnection.Close;
    FDConnection.Params.Database := EditBDD.Text;
    try
      FDConnection.Open;
    except
      on E: Exception do
      begin
        Application.MessageBox(Pchar('Erreur :  la connexion à [' + FDConnection.Params.Database + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    LabelEtape.Caption := 'Recherche de l''univers ...';
    Application.ProcessMessages;

    // Recherche de l'univers.
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('select UNI_ID');
    FDQuery.SQL.Add('from NKLUNIVERS');
    FDQuery.SQL.Add('where UNI_ID <> 0');
    FDQuery.SQL.Add('and UNI_ORIGINE = 1');
    FDQuery.SQL.Add('and lower(UNI_CODE) <> ''fedas''');
    try
      FDQuery.Open;
    except
      on E: Exception do
      begin
         Application.MessageBox(PWideChar('Erreur :  la recherche de l''univers a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
    end;
    if FDQuery.IsEmpty then
    begin
      Application.MessageBox(PWideChar('Erreur :  pas d''univers trouvé !'), PWideChar(Caption + ' - erreur'), MB_ICONEXCLAMATION + MB_OK);
      Exit;
    end
    else
      nUniID := FDQuery.FieldByName('UNI_ID').AsInteger;

    FDConnection.StartTransaction;

    // CSV.
    if CheckBoxCSV.Checked then
    begin
      Ligne := TStringList.Create;
      try
        Ligne.Delimiter := ';';
        Ligne.StrictDelimiter := True;
        bLigneTitre := True;

        AssignFile(F, EditFichierExcel.Text);
        try
          Reset(F);
          while not Eof(F) do
          begin
            Readln(F, sLigne);

            if bLigneTitre then
              bLigneTitre := False
            else
            begin
              Ligne.Clear;
              Ligne.DelimitedText := sLigne;

              if Ligne.Count >= 6 then
              begin
                SetLength(_TabLignes, Length(_TabLignes) + 1);
                _TabLignes[High(_TabLignes)][2] := Ligne[1];
                _TabLignes[High(_TabLignes)][3] := Ligne[2];
                _TabLignes[High(_TabLignes)][4] := Ligne[3];
                _TabLignes[High(_TabLignes)][5] := Ligne[4];
                _TabLignes[High(_TabLignes)][6] := Ligne[5];
              end;
            end;
          end;
        finally
          CloseFile(F);
        end;
      finally
        Ligne.Free;
      end;
    end
    else
    begin
      // Ouverture d'excel.
      try
         Excel := CreateOleObject('Excel.Application');
      except
         Application.MessageBox('Erreur :  excel ne peut pas être lancé !', PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
      try
         Excel.Visible := False;
         try
            Excel.Workbooks.Open(EditFichierExcel.Text);
         except
            on E: Exception do
            begin
               Application.MessageBox(PWideChar('Erreur :  l''ouverture du fichier [' + EditFichierExcel.Text + '] a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
               Exit;
            end;
         end;

         // Parcours des lignes.
         nNumLigne := 2;
         while(String(Excel.Cells[nNumLigne, 1].Value) <> '') do
         begin
            SetLength(_TabLignes, Length(_TabLignes) + 1);
            _TabLignes[High(_TabLignes)][2] := String(Excel.Cells[nNumLigne, 2].Value);
            _TabLignes[High(_TabLignes)][3] := String(Excel.Cells[nNumLigne, 3].Value);
            _TabLignes[High(_TabLignes)][4] := String(Excel.Cells[nNumLigne, 4].Value);
            _TabLignes[High(_TabLignes)][5] := String(Excel.Cells[nNumLigne, 5].Value);
            _TabLignes[High(_TabLignes)][6] := String(Excel.Cells[nNumLigne, 6].Value);

            Inc(nNumLigne);
         end;
      finally
         Excel.Quit;
         Excel := UnAssigned;
      end;
    end;

    // Traitement.
    Traitement(nUniID);

    FDConnection.Commit;

    LabelEtape.Caption := 'Fin.';
  finally
    EditFichierExcel.Enabled := True;
    EditBDD.Enabled := True;
    BtnTraitement.Enabled := True;
  end;
end;

procedure TMainForm.Traitement(const nUniID: Integer);
var
  i, nSsfID, nCatID, nAutreSsfID: Integer;
  sSecteur, sRayon, sFamille, sSousFamille, sSegef: String;
begin
  for i:=Low(_TabLignes) to High(_TabLignes) do
  begin
    if(sSecteur = _TabLignes[i][2]) and (sRayon = _TabLignes[i][3]) and (sFamille = _TabLignes[i][4]) and (sSousFamille = _TabLignes[i][5]) then
    begin
      RichEdit.Lines.Add('[' + FormatFloat(',##0', i) + ']  Doublon >>  ' + sSecteur + ' - ' + sRayon + ' - ' + sFamille + ' - ' + sSousFamille);
      RichEdit.Perform(WM_VSCROLL, SB_BOTTOM, 0);
      Continue;
    end;

    sSecteur := _TabLignes[i][2];
    sRayon := _TabLignes[i][3];
    sFamille := _TabLignes[i][4];
    sSousFamille := _TabLignes[i][5];
    sSegef := _TabLignes[i][6];

    LabelEtape.Caption := '[' + FormatFloat(',##0', i) + ']  ' + sSecteur + ' - ' + sRayon + ' - ' + sFamille + ' - ' + sSousFamille + ' = ' + sSegef;
    Application.ProcessMessages;

    // Recherche de la nomenclature.
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('select SSF_ID');
    FDQuery.SQL.Add('from NKLSSFAMILLE');
    FDQuery.SQL.Add('join K on (K_ID = SSF_ID and K_ENABLED = 1)');
    FDQuery.SQL.Add('where SSF_FAMID = (select FAM_ID');
    FDQuery.SQL.Add('                   from NKLFAMILLE');
    FDQuery.SQL.Add('                   join K on (K_ID = FAM_ID and K_ENABLED = 1)');
    FDQuery.SQL.Add('                   where FAM_RAYID = (select RAY_ID');
    FDQuery.SQL.Add('                                      from NKLRAYON');
    FDQuery.SQL.Add('                                      join K on (K_ID = RAY_ID and K_ENABLED = 1)');
    FDQuery.SQL.Add('                                      where RAY_SECID = (select SEC_ID');
    FDQuery.SQL.Add('                                                         from NKLSECTEUR');
    FDQuery.SQL.Add('                                                         join K on (K_ID = SEC_ID and K_ENABLED = 1)');
    FDQuery.SQL.Add('                                                         where SEC_UNIID = :UniID');
    FDQuery.SQL.Add('                                                         and upper(SEC_NOM) = upper(:NomSecteur))');
    FDQuery.SQL.Add('                                      and upper(RAY_NOM) = upper(:NomRayon))');
    FDQuery.SQL.Add('                   and upper(FAM_NOM) = upper(:NomFamille))');
    FDQuery.SQL.Add('and upper(SSF_NOM) = upper(:NomSousFamille)');
    try
      FDQuery.ParamByName('UniID').AsInteger := nUniID;
      FDQuery.ParamByName('NomSecteur').AsString := sSecteur;
      FDQuery.ParamByName('NomRayon').AsString := sRayon;
      FDQuery.ParamByName('NomFamille').AsString := sFamille;
      FDQuery.ParamByName('NomSousFamille').AsString := sSousFamille;
      FDQuery.Open;
    except
      on E: Exception do
      begin
        FDConnection.Rollback;
        Application.MessageBox(PWideChar('Erreur :  la recherche de la nomenclature [' + FormatFloat(',##0', i) + '] a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    if FDQuery.IsEmpty then
    begin
      RichEdit.Lines.Add('[' + FormatFloat(',##0', i) + ']  # nomenclature inconnue !');
      RichEdit.Perform(WM_VSCROLL, SB_BOTTOM, 0);
    end
    else
    begin
      nSsfID := FDQuery.FieldByName('SSF_ID').AsInteger;

      // Recherche de la catégorie.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('select CAT_ID');
      FDQuery.SQL.Add('from NKLCATEGORIE');
      FDQuery.SQL.Add('join K on (K_ID = CAT_ID and K_ENABLED = 1)');
      FDQuery.SQL.Add('where CAT_NOM = :NomCategorie');
      try
        FDQuery.ParamByName('NomCategorie').AsString := sSegef;
        FDQuery.Open;
      except
        on E: Exception do
        begin
          FDConnection.Rollback;
          Application.MessageBox(PWideChar('Erreur :  la recherche de la catégorie [' + sSegef + '] a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;
      if FDQuery.IsEmpty then
      begin
        // Génération d'un ID.
        FDQuery.Close;
        FDQuery.SQL.Clear;
        FDQuery.SQL.Add('select ID from PR_NEWK(''NKLCATEGORIE'')');
        try
          FDQuery.Open;
        except
          on E: Exception do
          begin
            FDConnection.Rollback;
            Application.MessageBox(PWideChar('Erreur :  la génération d''un ID a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;
        if FDQuery.IsEmpty then
        begin
          FDConnection.Rollback;
          Application.MessageBox('Erreur :  pas d''ID généré !', PWideChar(Caption + ' - erreur'), MB_ICONEXCLAMATION + MB_OK);
          Exit;
        end
        else
          nCatID := FDQuery.Fields[0].AsInteger;

        // Ajout de la catégorie.
        FDQuery.Close;
        FDQuery.SQL.Clear;
        FDQuery.SQL.Add('insert into NKLCATEGORIE');
        FDQuery.SQL.Add('values(:CatID, :NomCategorie, :UniID)');
        try
          FDQuery.ParamByName('CatID').AsInteger := nCatID;
          FDQuery.ParamByName('NomCategorie').AsString := sSegef;
          FDQuery.ParamByName('UniID').AsInteger := nUniID;
          FDQuery.ExecSQL;
        except
          on E: Exception do
          begin
            FDConnection.Rollback;
            Application.MessageBox(PWideChar('Erreur :  l''ajout de la catégorie [' + sSegef + '] a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;
      end
      else
        nCatID := FDQuery.FieldByName('CAT_ID').AsInteger;

      // Association de la sous-famille avec la catégorie.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('update NKLSSFAMILLE');
      FDQuery.SQL.Add('set SSF_CATID = :CatID');
      FDQuery.SQL.Add('where SSF_ID = :SsfID');
      try
        FDQuery.ParamByName('CatID').AsInteger := nCatID;
        FDQuery.ParamByName('SsfID').AsInteger := nSsfID;
        FDQuery.ExecSQL;
      except
        on E: Exception do
        begin
          FDConnection.Rollback;
          Application.MessageBox(PWideChar('Erreur :  l''association de la sous-famille avec la catégorie a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;

      // Maj K.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('execute procedure PR_UPDATEK(:SsfID, 0)');
      try
        FDQuery.ParamByName('SsfID').AsInteger := nSsfID;
        FDQuery.ExecSQL;
      except
        on E: Exception do
        begin
          FDConnection.Rollback;
          Application.MessageBox(PWideChar('Erreur :  la MAJ de K (NKLSSFAMILLE) a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;

      // Recherche correspondances sous-familles.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('select AXX_SSFID1, AXX_SSFID2');
      FDQuery.SQL.Add('from NKLAXEAXE');
      FDQuery.SQL.Add('join K on (K_ID = AXX_ID and K_ENABLED = 1)');
      FDQuery.SQL.Add('where AXX_SSFID1 = :SsfID or AXX_SSFID2 = :SsfID');
      try
        FDQuery.ParamByName('SsfID').AsInteger := nSsfID;
        FDQuery.Open;
      except
        on E: Exception do
        begin
          FDConnection.Rollback;
          Application.MessageBox(PWideChar('Erreur :  la recherche des correspondances entre sous-familles a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;
      if not FDQuery.IsEmpty then
      begin
        FDQuery.First;
        while not FDQuery.Eof do
        begin
          if FDQuery.FieldByName('AXX_SSFID1').AsInteger <> nSsfID then
            nAutreSsfID := FDQuery.FieldByName('AXX_SSFID1').AsInteger
          else
            nAutreSsfID := FDQuery.FieldByName('AXX_SSFID2').AsInteger;

          // Association de la sous-famille avec la catégorie.
          FDQueryMaj.Close;
          FDQueryMaj.SQL.Clear;
          FDQueryMaj.SQL.Add('update NKLSSFAMILLE');
          FDQueryMaj.SQL.Add('set SSF_CATID = :CatID');
          FDQueryMaj.SQL.Add('where SSF_ID = :SsfID');
          try
            FDQueryMaj.ParamByName('CatID').AsInteger := nCatID;
            FDQueryMaj.ParamByName('SsfID').AsInteger := nAutreSsfID;
            FDQueryMaj.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnection.Rollback;
              Application.MessageBox(PWideChar('Erreur :  l''association de la sous-famille avec la catégorie a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          // Maj K.
          FDQueryMaj.Close;
          FDQueryMaj.SQL.Clear;
          FDQueryMaj.SQL.Add('execute procedure PR_UPDATEK(:SsfID, 0)');
          try
            FDQueryMaj.ParamByName('SsfID').AsInteger := nAutreSsfID;
            FDQueryMaj.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnection.Rollback;
              Application.MessageBox(PWideChar('Erreur :  la MAJ de K (NKLSSFAMILLE) a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          FDQuery.Next;
        end;
      end;

      // Recherche des articles.
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('select ARF_ID');
      FDQuery.SQL.Add('from ARTARTICLE');
      FDQuery.SQL.Add('join K on (K_ID = ART_ID and K_ENABLED = 1)');
      FDQuery.SQL.Add('join ARTREFERENCE on (ARF_ARTID = ART_ID)');
      FDQuery.SQL.Add('join ARTRELATIONAXE on (ARX_ARTID = ART_ID)');
      FDQuery.SQL.Add('where ARX_SSFID = :SsfID');
      try
        FDQuery.ParamByName('SsfID').AsInteger := nSsfID;
        FDQuery.Open;
      except
        on E: Exception do
        begin
          FDConnection.Rollback;
          Application.MessageBox(PWideChar('Erreur :  la recherche des articles de la sous-famille a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
          Exit;
        end;
      end;
      if not FDQuery.IsEmpty then
      begin
        FDQuery.First;
        while not FDQuery.Eof do
        begin
          // Association de l'article avec la catégorie.
          FDQueryMaj.Close;
          FDQueryMaj.SQL.Clear;
          FDQueryMaj.SQL.Add('update ARTREFERENCE');
          FDQueryMaj.SQL.Add('set ARF_CATID = :CatID');
          FDQueryMaj.SQL.Add('where ARF_ID = :ArfID');
          try
            FDQueryMaj.ParamByName('CatID').AsInteger := nCatID;
            FDQueryMaj.ParamByName('ArfID').AsInteger := FDQuery.FieldByName('ARF_ID').AsInteger;
            FDQueryMaj.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnection.Rollback;
              Application.MessageBox(PWideChar('Erreur :  l''association de l''article avec la catégorie a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          // Maj K.
          FDQueryMaj.Close;
          FDQueryMaj.SQL.Clear;
          FDQueryMaj.SQL.Add('execute procedure PR_UPDATEK(:ArfID, 0)');
          try
            FDQueryMaj.ParamByName('ArfID').AsInteger := FDQuery.FieldByName('ARF_ID').AsInteger;
            FDQueryMaj.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnection.Rollback;
              Application.MessageBox(PWideChar('Erreur :  la MAJ de K (ARTREFERENCE) a échoué !' + #13#10 + E.Message), PWideChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          FDQuery.Next;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  //
end;

end.

