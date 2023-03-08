unit UArticlesDisponibles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, MidasLib,
  Vcl.Dialogs, Inifiles, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, System.StrUtils;

type
  TFormArticlesDisponibles = class(TForm)
    DBGrid: TDBGrid;
    FDQueryCham3S: TFDQuery;
    DataSource: TDataSource;
    FDConnectionCham3S: TFDConnection;
    FDMemTable: TFDMemTable;
    FDMemTableCBI_CB: TStringField;
    FDMemTableARW_DETAIL: TStringField;
    FDMemTableTGF_NOM: TStringField;
    FDMemTableCOU_NOM: TStringField;
    FDMemTableADW_DISPO: TIntegerField;
    FDConnectionWeb: TFDConnection;
    FDQueryWeb: TFDQuery;
    StatusBar: TStatusBar;
    FDMemTableMagasin: TFDMemTable;
    FDMemTableMagasinCODE_EAN: TStringField;
    FDMemTableMagasinARW_WEB: TIntegerField;
    FDMemTableMagasinARW_ETATDATA: TIntegerField;
    BtnToutCocher: TBitBtn;
    BtnToutDecocher: TBitBtn;
    BtnFermer: TBitBtn;
    BtnDesactiver: TBitBtn;
    PanelChargement: TPanel;
    FDMemTableART_ID: TIntegerField;
    FDMemTableTGF_ID: TIntegerField;
    FDMemTableCOU_ID: TIntegerField;
    FDQueryMajK: TFDQuery;
    BtnRechercher: TBitBtn;
    BtnAnnulerRecherche: TBitBtn;
    FDMemTableADW_ID: TIntegerField;
    FDMemTableARW_ID: TIntegerField;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnToutCocherClick(Sender: TObject);
    procedure BtnToutDecocherClick(Sender: TObject);
    procedure BtnRechercherClick(Sender: TObject);
    procedure BtnAnnulerRechercheClick(Sender: TObject);
    procedure BtnDesactiverClick(Sender: TObject);

  private
    _sTri: String;

    procedure ChargementArticles;

  public

  end;

var
  FormArticlesDisponibles: TFormArticlesDisponibles;

implementation

{$R *.dfm}

uses UFrmMain, URechercheArticle;

procedure TFormArticlesDisponibles.FormCreate(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'IntegCHAM3S.ini');
  try
    FDConnectionCham3S.Params.Database := FichierINI.ReadString('GENERAL', 'BaseMaitre', '');
    FDConnectionWeb.Params.Database := FichierINI.ReadString('GENERAL', 'Base', '');
  finally
    FichierINI.Free;
  end;

  // Connexion Cham3S.
  try
    FDConnectionCham3S.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la connexion Cham3S a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;

  // Connexion web.
  try
    FDConnectionWeb.Open;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erreur :  la connexion web a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      Exit;
    end;
  end;
end;

procedure TFormArticlesDisponibles.FormShow(Sender: TObject);
begin
  // Chargement des articles.
  _sTri := 'ARW_DETAIL';
  ChargementArticles;
end;

procedure TFormArticlesDisponibles.FormResize(Sender: TObject);
begin
  PanelChargement.Left := (Width div 2) - (PanelChargement.Width div 2);
  PanelChargement.Top := (Height div 2) - (PanelChargement.Height div 2);
end;

procedure TFormArticlesDisponibles.ChargementArticles;
{$REGION 'ChargementArticles'}
  procedure InitChargementMemTable(MemTable: TFDMemTable);
  begin
    MemTable.LogChanges := False;
    MemTable.FetchOptions.RecsMax := 300000;
    MemTable.ResourceOptions.SilentMode := True;
    MemTable.UpdateOptions.LockMode := lmNone;
    MemTable.UpdateOptions.LockPoint := lpDeferred;
    MemTable.UpdateOptions.FetchGeneratorsPoint := gpImmediate;
  end;
{$ENDREGION}
begin
  if(not FDConnectionCham3S.Connected) or (not FDConnectionWeb.Connected) then
    Exit;

  PanelChargement.Show;
  FrmMain.pbGlobal.Position := 0;      Application.ProcessMessages;
  try
    FDMemTable.Close;
    try
      FDMemTable.Open;
      FDMemTable.EmptyDataSet;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  l''initialisation a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;

    FDMemTableMagasin.Close;
    try
      FDMemTableMagasin.Open;
      FDMemTableMagasin.EmptyDataSet;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  l''initialisation a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    FrmMain.pbGlobal.Position := 10;      Application.ProcessMessages;

    // Recherche des articles magasin disponibles.
    FDQueryWeb.Close;
    FDQueryWeb.SQL.Clear;
    FDQueryWeb.SQL.Add('select distinct ARW_CODEEAN');
    FDQueryWeb.SQL.Add('from ARTWEB');
    FDQueryWeb.SQL.Add('where ARW_WEB = 1');
    FDQueryWeb.SQL.Add('and ARW_ETATDATA = 1');
    FDQueryWeb.SQL.Add('order by ARW_CODEEAN');
    try
      FDQueryWeb.Open;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  la recherche des articles magasin disponibles a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    if not FDQueryWeb.IsEmpty then
    begin
      InitChargementMemTable(FDMemTableMagasin);
      FDMemTableMagasin.BeginBatch;
      try
        FDQueryWeb.First;
        while not FDQueryWeb.Eof do
        begin
          FDMemTableMagasin.Append;
            FDMemTableMagasin.FieldByName('CODE_EAN').AsString := FDQueryWeb.FieldByName('ARW_CODEEAN').AsString;
          FDMemTableMagasin.Post;

          FDQueryWeb.Next;
        end;
      finally
        FDMemTableMagasin.EndBatch;
      end;
    end;
    FrmMain.pbGlobal.Position := 50;      Application.ProcessMessages;

    // Recherche des articles Cham3S disponibles.
    FDQueryCham3S.Close;
    FDQueryCham3S.SQL.Clear;
    FDQueryCham3S.SQL.Add('select CBI_CB, ART_ID, ARW_DETAIL, ART_NOM, TGF_ID, TGF_NOM, COU_ID, COU_NOM, ADW_DISPO, ADW_ID, ARW_ID');
    FDQueryCham3S.SQL.Add('from ARTWEB  join K on (K_ID = ARW_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join ARTDISPOWEB on (ADW_ARTID = ARW_ARTID)  join K on (K_ID = ADW_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join ARTARTICLE on (ART_ID = ARW_ARTID)  join K on (K_ID = ART_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join ARTREFERENCE on (ARF_ARTID = ART_ID) join K on (K_ID = ARF_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join ARTCODEBARRE on (CBI_ARFID = ARF_ID and CBI_TGFID = ADW_TGFID and CBI_COUID = ADW_COUID) join K on (K_ID = CBI_ID AND K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join PLXTAILLESGF on (TGF_ID = ADW_TGFID)  join K on (K_ID = TGF_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('join PLXCOULEUR on (COU_ID = ADW_COUID)  join K on (K_ID = COU_ID and K_ENABLED = 1)');
    FDQueryCham3S.SQL.Add('where ARW_WEB = 1');
    FDQueryCham3S.SQL.Add('and ADW_DISPO = 1');
    FDQueryCham3S.SQL.Add('and CBI_TYPE = 3');
    FDQueryCham3S.SQL.Add('and CBI_PRIN = 1');
    FDQueryCham3S.SQL.Add('order by ' + _sTri);
    try
      FDQueryCham3S.Open;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erreur :  la recherche des articles Cham3S disponibles a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
        Exit;
      end;
    end;
    if not FDQueryCham3S.IsEmpty then
    begin
      FrmMain.pbGlobal.Position := 75;
      Application.ProcessMessages;

      InitChargementMemTable(FDMemTable);
      FDMemTable.DisableControls;
      FDMemTable.BeginBatch;
      try
        FDQueryCham3S.First;
        while not FDQueryCham3S.Eof do
        begin
          // Si article magasin pas actif.
          if not FDMemTableMagasin.FindKey([FDQueryCham3S.FieldByName('CBI_CB').AsString]) then
          begin
            FDMemTable.Append;
              FDMemTable.FieldByName('CBI_CB').AsString := FDQueryCham3S.FieldByName('CBI_CB').AsString;
              FDMemTable.FieldByName('ART_ID').AsInteger := FDQueryCham3S.FieldByName('ART_ID').AsInteger;
              FDMemTable.FieldByName('ARW_DETAIL').AsString := FDQueryCham3S.FieldByName('ARW_DETAIL').AsString;
              FDMemTable.FieldByName('TGF_ID').AsInteger := FDQueryCham3S.FieldByName('TGF_ID').AsInteger;
              FDMemTable.FieldByName('TGF_NOM').AsString := FDQueryCham3S.FieldByName('TGF_NOM').AsString;
              FDMemTable.FieldByName('COU_ID').AsInteger := FDQueryCham3S.FieldByName('COU_ID').AsInteger;
              FDMemTable.FieldByName('COU_NOM').AsString := FDQueryCham3S.FieldByName('COU_NOM').AsString;
              FDMemTable.FieldByName('ADW_DISPO').AsInteger := FDQueryCham3S.FieldByName('ADW_DISPO').AsInteger;
              FDMemTable.FieldByName('ADW_ID').AsInteger := FDQueryCham3S.FieldByName('ADW_ID').AsInteger;
              FDMemTable.FieldByName('ARW_ID').AsInteger := FDQueryCham3S.FieldByName('ARW_ID').AsInteger;
            FDMemTable.Post;
          end;

          FDQueryCham3S.Next;
        end;
      finally
        FDMemTable.EndBatch;
        FDMemTable.EnableControls;
      end;

      StatusBar.Panels.Items[0].Text := FormatFloat(',##0', FDMemTable.RecordCount);

      DBGrid.SelectedRows.Clear;
      BtnDesactiver.Enabled := (DBGrid.SelectedRows.Count > 0);
      StatusBar.Panels.Items[1].Text := FormatFloat(',##0', DBGrid.SelectedRows.Count);
    end;
  finally
    FrmMain.pbGlobal.Position := 0;
    PanelChargement.Hide;
  end;
end;

procedure TFormArticlesDisponibles.DBGridDrawColumnCell(Sender: TObject; const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  RectCoche: TRect;
begin
  if(gdSelected in State) then
    DBGrid.Canvas.Brush.Color := clGradientInactiveCaption;

  // Si case à cocher.
  if Column.FieldName = 'ADW_DISPO' then
  begin
    DBGrid.Canvas.FillRect(Rect);
    RectCoche.Left := Rect.Left + 2;
    RectCoche.Right := Rect.Right - 2;
    RectCoche.Top := Rect.Top + 2;
    RectCoche.Bottom := Rect.Bottom - 2;
    if Column.Field.AsInteger = 1 then
      DrawFrameControl(DBGrid.Canvas.Handle, RectCoche, DFC_BUTTON, DFCS_CHECKED)
    else
      DrawFrameControl(DBGrid.Canvas.Handle, RectCoche, DFC_BUTTON, DFCS_BUTTONCHECK);
  end
  else
    DBGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFormArticlesDisponibles.DBGridTitleClick(Column: TColumn);
begin
  if Column.FieldName <> 'ADW_DISPO' then
  begin
    _sTri := Column.FieldName;
    ChargementArticles;
  end;
end;

procedure TFormArticlesDisponibles.DBGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BtnDesactiver.Enabled := (DBGrid.SelectedRows.Count > 0);
  StatusBar.Panels.Items[1].Text := FormatFloat(',##0', DBGrid.SelectedRows.Count);
end;

procedure TFormArticlesDisponibles.BtnToutCocherClick(Sender: TObject);
begin
  // Coche toute les lignes.
  FDMemTable.DisableControls;
  try
    FDMemTable.First;
    while not FDMemTable.Eof do
    begin
      DBGrid.SelectedRows.CurrentRowSelected := True;
      FDMemTable.Next;
    end;
  finally
    FDMemTable.EnableControls;
  end;

  BtnDesactiver.Enabled := (DBGrid.SelectedRows.Count > 0);
  StatusBar.Panels.Items[1].Text := FormatFloat(',##0', DBGrid.SelectedRows.Count);
  DBGrid.SetFocus;
end;

procedure TFormArticlesDisponibles.BtnToutDecocherClick(Sender: TObject);
begin
  // Décoche toute les lignes.
  DBGrid.SelectedRows.Clear;

  BtnDesactiver.Enabled := (DBGrid.SelectedRows.Count > 0);
  StatusBar.Panels.Items[1].Text := FormatFloat(',##0', DBGrid.SelectedRows.Count);
  DBGrid.SetFocus;
end;

procedure TFormArticlesDisponibles.BtnRechercherClick(Sender: TObject);
var
  sRecherche: String;
begin
  FormRechercheArticle := TFormRechercheArticle.Create(Self);
  try
    if FormRechercheArticle.ShowModal = mrOk then
    begin
      // Recherche.
      FDMemTable.Filtered := False;
      FDMemTable.Filter := '';
      if FormRechercheArticle.EditCB.Text <> '' then
      begin
        FDMemTable.Filter := 'CBI_CB like ''%' + FormRechercheArticle.EditCB.Text + '%''';
        sRecherche := ' CB = ' + FormRechercheArticle.EditCB.Text;
      end;
      if FormRechercheArticle.EditDesignationModele.Text <> '' then
      begin
        if FDMemTable.Filter <> '' then
          FDMemTable.Filter := FDMemTable.Filter + ' and ';
        FDMemTable.Filter := FDMemTable.Filter + 'ARW_DETAIL like ''%' + FormRechercheArticle.EditDesignationModele.Text + '%''';
        sRecherche := sRecherche + IfThen(sRecherche <> '', '; ') + ' Désignation = ' + FormRechercheArticle.EditDesignationModele.Text;
      end;
      if FormRechercheArticle.EditTaille.Text <> '' then
      begin
        if FDMemTable.Filter <> '' then
          FDMemTable.Filter := FDMemTable.Filter + ' and ';
        FDMemTable.Filter := FDMemTable.Filter + 'TGF_NOM like ''%' + FormRechercheArticle.EditTaille.Text + '%''';
        sRecherche := sRecherche + IfThen(sRecherche <> '', '; ') + ' Taille = ' + FormRechercheArticle.EditTaille.Text;
      end;
      if FormRechercheArticle.EditCouleur.Text <> '' then
      begin
        if FDMemTable.Filter <> '' then
          FDMemTable.Filter := FDMemTable.Filter + ' and ';
        FDMemTable.Filter := FDMemTable.Filter + 'COU_NOM like ''%' + FormRechercheArticle.EditCouleur.Text + '%''';
        sRecherche := sRecherche + IfThen(sRecherche <> '', '; ') + ' Couleur = ' + FormRechercheArticle.EditCouleur.Text;
      end;
      FDMemTable.Filtered := True;
      StatusBar.Panels.Items[2].Text := ' Recherche  [' + sRecherche + ' ]';
    end;
  finally
    FormRechercheArticle.Free;
  end;

  DBGrid.SetFocus;
end;

procedure TFormArticlesDisponibles.BtnAnnulerRechercheClick(Sender: TObject);
begin
  // Annulation recherche.
  FDMemTable.Filtered := False;
  StatusBar.Panels.Items[2].Text := '';
  DBGrid.SetFocus;
end;

procedure TFormArticlesDisponibles.BtnDesactiverClick(Sender: TObject);
var
  i: Integer;
begin
  if DBGrid.SelectedRows.Count = 0 then
    Exit;

  // Demande de confirmation.
  if Application.MessageBox(PChar(IfThen(DBGrid.SelectedRows.Count > 1, 'Les ' + IntToStr(DBGrid.SelectedRows.Count) + ' articles sélectionnés vont être désactivés.', 'L''article sélectionné va être désactivé.') + #13#10 + 'Voulez-vous continuer ?'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_YESNO + MB_DEFBUTTON2) = ID_YES then
  begin
    FDMemTable.DisableControls;
    try
      FDConnectionCham3S.StartTransaction;

      for i:=0 to Pred(DBGrid.SelectedRows.Count) do
      begin
        FDMemTable.GotoBookmark(Pointer(DBGrid.SelectedRows.Items[i]));

        // Désactivation de l'article.
        FDQueryCham3S.Close;
        FDQueryCham3S.SQL.Clear;
        FDQueryCham3S.SQL.Add('update ARTDISPOWEB');
        FDQueryCham3S.SQL.Add('set ADW_DISPO = 0');
        FDQueryCham3S.SQL.Add('where ADW_ID = :ADWID');
        try
          FDQueryCham3S.ParamByName('ADWID').AsInteger := FDMemTable.FieldByName('ADW_ID').AsInteger;
          FDQueryCham3S.ExecSQL;
        except
          on E: Exception do
          begin
            FDConnectionCham3S.Rollback;
            Application.MessageBox(PChar('Erreur :  la désactivation de l''article [' + FDMemTable.FieldByName('ART_ID').AsString + ' - ' + FDMemTable.FieldByName('TGF_ID').AsString + ' - ' + FDMemTable.FieldByName('COU_ID').AsString + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;

        // Maj du K.
        FDQueryMajK.Close;
        FDQueryMajK.SQL.Clear;
        FDQueryMajK.SQL.Add('execute procedure PR_UPDATEK(:ADWID, 0)');
        try
          FDQueryMajK.ParamByName('ADWID').AsInteger := FDMemTable.FieldByName('ADW_ID').AsInteger;
          FDQueryMajK.ExecSQL;
        except
          on E: Exception do
          begin
            FDConnectionCham3S.Rollback;
            Application.MessageBox(PChar('Erreur :  la maj du K de l''article [' + FDMemTable.FieldByName('ART_ID').AsString + ' - ' + FDMemTable.FieldByName('TGF_ID').AsString + ' - ' + FDMemTable.FieldByName('COU_ID').AsString + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;

        // Recherche des articles du modèle encore actifs.
        FDQueryCham3S.Close;
        FDQueryCham3S.SQL.Clear;
        FDQueryCham3S.SQL.Add('select count(*)');
        FDQueryCham3S.SQL.Add('from ARTDISPOWEB');
        FDQueryCham3S.SQL.Add('join K KADW on ADW_ID = KADW.K_ID and KADW.K_ENABLED = 1');
        FDQueryCham3S.SQL.Add('where ADW_ARTID = :ARTID');
        FDQueryCham3S.SQL.Add('and ADW_DISPO = 1');
        try
          FDQueryCham3S.ParamByName('ARTID').AsInteger := FDMemTable.FieldByName('ART_ID').AsInteger;
          FDQueryCham3S.Open;
        except
          on E: Exception do
          begin
            FDConnectionCham3S.Rollback;
            Application.MessageBox(PChar('Erreur :  la recherche des articles [' + FDMemTable.FieldByName('ART_ID').AsString + '] du modèle encore actifs a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
            Exit;
          end;
        end;
        // Si plus d'articles du modèle encore actifs.
        if FDQueryCham3S.Fields[0].AsInteger = 0 then
        begin
          // Recherche des articles du modèle.
          FDQueryCham3S.Close;
          FDQueryCham3S.SQL.Clear;
          FDQueryCham3S.SQL.Add('select ADW_ID');
          FDQueryCham3S.SQL.Add('from ARTDISPOWEB');
          FDQueryCham3S.SQL.Add('join K KADW on ADW_ID = KADW.K_ID and KADW.K_ENABLED = 1');
          FDQueryCham3S.SQL.Add('where ADW_ARTID = :ARTID');
          FDQueryCham3S.SQL.Add('and ADW_DISPO = 0');
          try
            FDQueryCham3S.ParamByName('ARTID').AsInteger := FDMemTable.FieldByName('ART_ID').AsInteger;
            FDQueryCham3S.Open;
          except
            on E: Exception do
            begin
              FDConnectionCham3S.Rollback;
              Application.MessageBox(PChar('Erreur :  la recherche des articles [' + FDMemTable.FieldByName('ART_ID').AsString + '] du modèle a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;
          //on désactive les K des articles
          if not FDQueryCham3S.IsEmpty then
          begin
            FDQueryMajK.Close;
            FDQueryMajK.SQL.Clear;
            FDQueryMajK.SQL.Add('execute procedure PR_UPDATEK(:ADWID, 1)');
            FDQueryCham3S.First;
            while not FDQueryCham3S.Eof do
            begin
              try
                FDQueryMajK.ParamByName('ADWID').AsInteger := FDQueryCham3S.FieldByName('ADW_ID').AsInteger;
                FDQueryMajK.ExecSQL;
              except
                on E: Exception do
                begin
                  FDConnectionCham3S.Rollback;
                  Application.MessageBox(PChar('Erreur :  la désactivation du K de l''article [' + FDQueryCham3S.FieldByName('ADW_ID').AsString + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
                  Exit;
                end;
              end;
              FDQueryCham3S.Next;
            end;
          end;

          // Désactivation du modèle.
          FDQueryCham3S.Close;
          FDQueryCham3S.SQL.Clear;
          FDQueryCham3S.SQL.Add('update ARTWEB');
          FDQueryCham3S.SQL.Add('set ARW_WEB = 0,');
          FDQueryCham3S.SQL.Add('ARW_PREVENTE = 0');
          FDQueryCham3S.SQL.Add('where ARW_ID = :ARWID');
          try
            FDQueryCham3S.ParamByName('ARWID').AsInteger := FDMemTable.FieldByName('ARW_ID').AsInteger;
            FDQueryCham3S.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnectionCham3S.Rollback;
              Application.MessageBox(PChar('Erreur :  la désactivation du modèle [' + IntToStr(FDMemTable.FieldByName('ARW_ID').AsInteger) + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          // Désactivation du K.
          FDQueryMajK.Close;
          FDQueryMajK.SQL.Clear;
          FDQueryMajK.SQL.Add('execute procedure PR_UPDATEK(:ARWID, 1)');
          try
            FDQueryMajK.ParamByName('ARWID').AsInteger := FDMemTable.FieldByName('ARW_ID').AsInteger;
            FDQueryMajK.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnectionCham3S.Rollback;
              Application.MessageBox(PChar('Erreur :  la désactivation du K du modèle [' + IntToStr(FDMemTable.FieldByName('ARW_ID').AsInteger) + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;

          // SR - 16-08-2017 - Correction désactivation du produit
          FDQueryCham3S.Close;
          FDQueryCham3S.SQL.Clear;
          FDQueryCham3S.SQL.Add('SELECT AQS_ID FROM ARTQUELSITE WHERE AQS_ARWID = :ARWID');
          try
            FDQueryCham3S.ParamByName('ARWID').AsInteger := FDMemTable.FieldByName('ARW_ID').AsInteger;
            FDQueryCham3S.Open;
            // Désactivation du K.
            FDQueryMajK.Close;
            FDQueryMajK.SQL.Clear;
            FDQueryMajK.SQL.Add('execute procedure PR_UPDATEK(:AQSID, 1)');

            FDQueryMajK.ParamByName('AQSID').AsInteger := FDQueryCham3S.FieldByName('AQS_ID').AsInteger;
            FDQueryMajK.ExecSQL;
          except
            on E: Exception do
            begin
              FDConnectionCham3S.Rollback;
              Application.MessageBox(PChar('Erreur :  la désactivation du site [' + IntToStr(FDQueryCham3S.FieldByName('AQS_ID').AsInteger) + '] a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
              Exit;
            end;
          end;
          // SR - Fin correction
        end;
      end;

      FDConnectionCham3S.Commit;
    finally
      FDMemTable.EnableControls;
    end;

    // Rafraichissement.
    ChargementArticles;
  end;

  DBGrid.SetFocus;
end;

end.

