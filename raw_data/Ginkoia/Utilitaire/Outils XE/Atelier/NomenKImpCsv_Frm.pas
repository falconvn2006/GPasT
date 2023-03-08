unit NomenKImpCsv_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, DB, DBClient, Main_DM, Grids,
  DBGrids, uLogs, MidasLib;

type
  Tfrm_NomenkImpCsv = class(TForm)
    Pan_Top: TPanel;
    Lab_SourceFile: TLabel;
    edt_SourceFile: TEdit;
    edt_DestFile: TEdit;
    Nbt_SourceFile: TBitBtn;
    Lab_DestFile: TLabel;
    Nbt_DestFile: TBitBtn;
    Pan_client: TPanel;
    Nbt_Execute: TBitBtn;
    Pan_Bottom: TPanel;
    pb_mainbar: TProgressBar;
    Lab_Progress: TLabel;
    cds_SAVPT1: TClientDataSet;
    OD_File: TOpenDialog;
    cds_SAVPT1PT1_ORDREAFF: TIntegerField;
    cds_SAVPT1PT1_NOM: TStringField;
    cds_SAVPT2: TClientDataSet;
    cds_SAVFORFAIT: TClientDataSet;
    cds_SAVPT2PT2_ORDREAFF: TIntegerField;
    cds_SAVPT2PT2_PT1: TIntegerField;
    cds_SAVPT2PT2_NOM: TStringField;
    cds_SAVFORFAITFOR_NOM: TStringField;
    cds_SAVFORFAITFOR_PRIX: TCurrencyField;
    cds_SAVFORFAITFOR_DUREE: TFloatField;
    cds_SAVPT2PT2_FOR: TIntegerField;
    cds_ARTARTICLE: TClientDataSet;
    cds_ARTARTICLEART_ID: TIntegerField;
    cds_ARTARTICLEART_NOM: TStringField;
    cds_ARTARTICLEART_FEDAS: TStringField;
    cds_ARTARTICLEART_PRODUIT: TStringField;
    cds_ARTARTICLEART_COEFTHEO: TCurrencyField;
    cds_SAVPT2PT2_LIBELLE: TStringField;
    cds_SAVFORFAITFOR_NUM: TIntegerField;
    cds_ARTARTICLEART_FORNUM: TIntegerField;
    cds_ARTARTICLEART_CODE: TStringField;
    Pgc_Import: TPageControl;
    Tab_Logs: TTabSheet;
    memo_logs: TMemo;
    Tab_N1: TTabSheet;
    Tab_N2: TTabSheet;
    Tab_Forfait: TTabSheet;
    Tab_ARTICLE: TTabSheet;
    Ds_N1: TDataSource;
    Ds_N2: TDataSource;
    Ds_FORFAIT: TDataSource;
    Ds_ARTICLE: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    cds_SAVFORFAITFOR_ID: TIntegerField;
    cds_SAVPT1PT1_ID: TIntegerField;
    procedure Nbt_SourceFileClick(Sender: TObject);
    procedure Nbt_DestFileClick(Sender: TObject);
    procedure Nbt_ExecuteClick(Sender: TObject);
  private
    FWorkInProgress: Boolean;
    { Déclarations privées }
    function CheckData : Boolean;
  public
    { Déclarations publiques }
    procedure ExecuteProcessImport;

    function ImportCsv : Boolean;
    function ImportDataToDB : Boolean;
  published
    property WorkInProgress : Boolean read FWorkInProgress;
  end;

var
  frm_NomenkImpCsv: Tfrm_NomenkImpCsv;

implementation

{$R *.dfm}

function Tfrm_NomenkImpCsv.CheckData: Boolean;
begin
  Result := False;
  if trim(edt_SourceFile.Text) = '' then
  begin
    ShowMessage('Veuillez sélectionner un fichier source');
    edt_SourceFile.SetFocus;
    Exit;
  end;

  if not FileExists(edt_SourceFile.Text) then
  begin
    ShowMessage('Le fichier source n''existe pas');
    edt_SourceFile.SetFocus;
    Exit;
  end;

  if trim(edt_DestFile.Text) = '' then
  begin
    Showmessage('Veuillez sélectionner un fichier de destination');
    edt_DestFile.SetFocus;
    Exit;
  end;

  if not FileExists(edt_DestFile.Text) then
  begin
    ShowMessage('Le fichier destination n''existe pas');
    edt_SourceFile.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure Tfrm_NomenkImpCsv.ExecuteProcessImport;

begin
  // Vérification des paramètres
  if CheckData then
  begin
    // Traitement du fichier fichier CSV
    if ImportCsv then
    begin
      ImportDataToDB;
    end;
  end;
end;

function Tfrm_NomenkImpCsv.ImportCsv: Boolean;
var
  lstCsv, lstTmp : TStringList;
  i, j : Integer;
  iForfaitId, iForfaitLigneId : Integer;
begin
  Result := False;
  lstCsv := TStringList.Create;
  lstTmp := TStringList.Create;
  Logs.Path := GAPPLOGS + FormatDateTime('YYYY\MM\DD\',Now);
  Logs.FileName := FormatDateTime('YYYYMMDDhhmmsszzz',Now) + '.txt';
  Logs.Memo := memo_logs;
  ForceDirectories(Logs.Path);

  try
    lstCsv.LoadFromFile(trim(edt_SourceFile.Text));

    cds_SAVPT1.EmptyDataSet;
    cds_SAVPT2.EmptyDataSet;
    cds_SAVFORFAIT.EmptyDataSet;
    cds_ARTARTICLE.EmptyDataSet;

    pb_mainbar.Max := lstCsv.Count -1;
    for i := 0 to lstCsv.Count -1 do
    begin
      Lab_Progress.Caption := Format('Importation du fichier en mémoire - Ligne %d sur %d',[i + 1, lstTmp.Count]);
      Lab_Progress.Update;
      lstTmp.Text := StringReplace(lstCsv[i],';',#13#10,[rfReplaceAll]);
      Try

        for j := 0 to lstTmp.Count -1 do
        begin

          case j of
            // champs 1, 2 Niveau 1 nomenclature
            0: begin
              if not cds_SAVPT1.Locate('PT1_ORDREAFF',lstTmp[j],[loCaseInsensitive]) then
              begin
                cds_SAVPT1.Append;
                cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsString := lstTmp[j];
                cds_SAVPT1.FieldByName('PT1_ID').AsInteger := -1;
              end;
            end;
            1: begin
              if cds_SAVPT1.State in [dsInsert] then
              begin
                cds_SAVPT1.FieldByName('PT1_NOM').AsString := lstTmp[j];
                cds_SAVPT1.Post;
              end;
            end;
            // champs 3, 4, 5 Niveau 2 Nomenclature
            2: begin
                if not cds_SAVPT2.Locate('PT2_PT1;PT2_ORDREAFF',VarArrayOf([cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsInteger, lstTmp[j]]),[loCaseInsensitive]) then
                begin
                  cds_SAVPT2.Append;
                  cds_SAVPT2.FieldByName('PT2_PT1').AsInteger := cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsInteger;
                  cds_SAVPT2.FieldByName('PT2_ORDREAFF').AsString := lstTmp[j];
                end;
            end;

            3: begin
              if cds_SAVPT2.State in [dsInsert] then
                cds_SAVPT2.FieldByName('PT2_NOM').AsString := lstTmp[j];
            end;

            4: begin
              if cds_SAVPT2.State in [dsInsert] then
                cds_SAVPT2.FieldByName('PT2_LIBELLE').AsString := lstTmp[j];
            end;

            // Champs 6, 7, 8 forfait
            5: begin
              if not cds_SAVFORFAIT.Locate('FOR_NOM', lstTmp[j],[loCaseInsensitive]) then
              begin
                iForfaitId := iForfaitId + 1;
                cds_SAVFORFAIT.Append;
                cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger := iForfaitId;
                cds_SAVFORFAIT.FieldByName('FOR_NOM').AsString := lstTmp[j];
                cds_SAVFORFAIT.FieldByName('FOR_ID').AsInteger := -1;
              end;

              if cds_SAVPT2.State in [dsInsert] then
              begin
                cds_SAVPT2.FieldByName('PT2_FORNUM').AsInteger := cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger;
                cds_SAVPT2.Post;
              end;
            end;

            6: begin
               if cds_SAVFORFAIT.State in [dsInsert] then
                 cds_SAVFORFAIT.FieldByName('FOR_DUREE').AsString := lstTmp[j];
            end;

            7: begin
               if cds_SAVFORFAIT.State in [dsInsert] then
               begin
                 cds_SAVFORFAIT.FieldByName('FOR_PRIX').AsString := lstTmp[j];
                 cds_SAVFORFAIT.Post;
               end;
            end;
            // champs  9, 10, 11, 12, 13 Pseudo
            8: begin
              if Trim(lstTmp[j]) <> '' then
                if not cds_ARTARTICLE.Locate('ART_FORNUM;ART_CODE',VarArrayOf([cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger,lstTmp[j]]),[loCaseInsensitive]) then
                begin
                  cds_ARTARTICLE.Append;
                  cds_ARTARTICLE.FieldByName('ART_CODE').AsString := lstTmp[j];
                end;
            end;

            9: begin
              if Trim(cds_ARTARTICLE.FieldByName('ART_CODE').AsString) = '' then
                if not cds_ARTARTICLE.Locate('ART_FORNUM;ART_NOM',VarArrayOf([cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger,lstTmp[j]]),[loCaseInsensitive]) then
                cds_ARTARTICLE.Append;

              if cds_ARTARTICLE.State in [dsinsert] then
              begin
                cds_ARTARTICLE.FieldByName('ART_ID').AsInteger := -1;
                cds_ARTARTICLE.FieldByName('ART_NOM').AsString := lstTmp[j];
                cds_ARTARTICLE.FieldByName('ART_FORNUM').AsInteger := cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger;
              end;
            end;

            10: begin
              if cds_ARTARTICLE.State in [dsinsert] then
              begin
                if Trim(lstTmp[j]) <> '' then
                  cds_ARTARTICLE.FieldByName('ART_FEDAS').AsString := lstTmp[j]
                else
                  raise Exception.Create('Code FEDAS obligatoire');
              end;
            end;

            11: begin
              if cds_ARTARTICLE.State in [dsinsert] then
                cds_ARTARTICLE.FieldByName('ART_PRODUIT').AsString := lstTmp[j];
            end;

            12: begin
              if cds_ARTARTICLE.State in [dsinsert] then
              begin
                cds_ARTARTICLE.FieldByName('ART_COEFTHEO').AsString := lstTmp[j];
                cds_ARTARTICLE.Post;
              end;
            end;
          end; // case
        end; // for j
      except on E:Exception do
        begin
           if cds_SAVPT1.State in [dsInsert, dsEdit] then
             cds_SAVPT1.Cancel;

           if cds_SAVPT2.State in [dsInsert, dsEdit] then
             cds_SAVPT2.Cancel;

           if cds_SAVFORFAIT.State in [dsInsert, dsEdit] then
             cds_SAVFORFAIT.Cancel;

           if cds_ARTARTICLE.State in [dsInsert, dsEdit] then
             cds_ARTARTICLE.Cancel;

           Logs.AddToLogs(Format('Erreur Ligne : %d - %s', [i + 1,E.Message]));
        end;
      End;
      pb_mainbar.Position := i;
      Application.ProcessMessages;
    end; // for i
    Result := True;
  finally
    lstCsv.Free;
    lstTmp.Free;
  end;
end;

function Tfrm_NomenkImpCsv.ImportDataToDB: Boolean;
begin
  // Connexion à la base de données
  With DM_Main do
  begin
    IBOMainDatabase.Close;
    IBOMainDatabase.DatabaseName := edt_DestFile.Text;
    IBOMainDatabase.Connect;
  end;

  With dm_main.Que_Tmp do
  begin
    // Traitement de l'article
    Close;
    SQL.Clear;
    SQL.Add('SELECT * from AO_NEWPSEUDO(:PARTCODE, :PARTNOM, :PFEDAS, :PTYPEPSEUDO, :PCOEFTHEO)');
    Prepared := True;
    ParamCheck := True;

    Logs.AddToLogs('');
    Logs.AddToLogs('- Traitement des articles');
    Logs.AddToLogs('');

    cds_ARTARTICLE.First;
    pb_mainbar.Max := 100;
    while not cds_ARTARTICLE.eof do
    begin
      Lab_Progress.Caption := Format('Traitment des articles %d sur %d',[cds_ARTARTICLE.RecNo + 1, cds_ARTARTICLE.RecordCount]);
      Lab_Progress.Update;
      IB_Transaction.StartTransaction;

      Try
        Close;
        ParamByName('PARTCODE').AsString := cds_ARTARTICLE.FieldByName('ART_CODE').AsString;
        ParamByName('PARTNOM').AsString := cds_ARTARTICLE.FieldByName('ART_NOM').AsString;
        ParamByName('PFEDAS').AsString := cds_ARTARTICLE.FieldByName('ART_FEDAS').AsString;
        ParamByName('PTYPEPSEUDO').AsString := cds_ARTARTICLE.FieldByName('ART_PRODUIT').AsString;
        ParamByName('PCOEFTHEO').AsString := cds_ARTARTICLE.FieldByName('ART_COEFTHEO').AsString;
        Open;

        if RecordCount > 0 then
        begin
          cds_ARTARTICLE.edit;
          cds_ARTARTICLE.FieldByName('ART_ID').AsInteger := FieldByName('ART_ID').AsInteger;
          cds_ARTARTICLE.Post;
        end;
        IB_Transaction.Commit;
      except on E:Exception do
        begin
          IB_Transaction.Rollback;
          Logs.AddToLogs(Format('Article - Code %s - Nom %s - Erreur %s',[cds_ARTARTICLE.FieldByName('ART_CODE').AsString,cds_ARTARTICLE.FieldByName('ART_NOM').AsString,E.Message]));
        end;
      End;
      cds_ARTARTICLE.Next;
      pb_mainbar.Position := cds_ARTARTICLE.RecNo * 100 div cds_ARTARTICLE.RecordCount;
      Application.ProcessMessages;
    end;

    // forfait
    Close;
    SQL.Clear;
    SQL.Add('SELECT * from AO_FORFAIT(:PFORNOM, :PFORDUREE, :PFORPRIX)');
    Prepared := True;
    ParamCheck := True;

    Logs.AddToLogs('');
    Logs.AddToLogs('- Traitement des forfaits');
    Logs.AddToLogs('');

    cds_SAVFORFAIT.First;
    while not cds_SAVFORFAIT.Eof do
    begin
      Lab_Progress.Caption := Format('Traitment des forfait %d sur %d',[cds_ARTARTICLE.RecNo + 1, cds_ARTARTICLE.RecordCount]);
      Lab_Progress.Update;

      try
      if cds_ARTARTICLE.Locate('ART_FORNUM',cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger,[]) then
      begin
        IB_Transaction.StartTransaction;
        Close;
        ParamByName('PFORNOM').AsString := cds_SAVFORFAIT.FieldByName('FOR_NOM').AsString;
        ParamByName('PFORDUREE').AsFloat := cds_SAVFORFAIT.FieldByName('FOR_DUREE').AsFloat;
        ParamByName('PFORPRIX').AsCurrency := cds_SAVFORFAIT.FieldByName('FOR_PRIX').AsCurrency;
        Open;

        if recordcount > 0 then
        begin
          cds_SAVFORFAIT.Edit;
          cds_SAVFORFAIT.FieldByName('FOR_ID').AsInteger := FieldByName('FOR_ID').AsInteger;
          cds_SAVFORFAIT.Post;
        end;
        IB_Transaction.Commit;
      end
      else begin
        raise Exception.Create(Format('Modèle non trouvé -> For_num : %d ',[cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger]));
      end;
      Except on E:Exception do
        begin
          Logs.AddToLogs(Format('Forfait %s - Erreur : %s',[cds_SAVFORFAIT.FieldByName('FOR_NOM').AsString,E.Message]));
          if IB_Transaction.InTransaction then
            IB_Transaction.Rollback;
        end;
      end;
      cds_SAVFORFAIT.Next;
      pb_mainbar.Position := cds_SAVFORFAIT.RecNo * 100 div cds_SAVFORFAIT.RecordCount;
      Application.ProcessMessages;
    end;

    // Nomenclature
    cds_SAVPT1.First;

    Logs.AddToLogs('');
    Logs.AddToLogs('- Traitement de la nomenclature');
    Logs.AddToLogs('');

    while not cds_SAVPT1.Eof do
    begin
      Try
        IB_Transaction.StartTransaction;
        Close;
        SQL.Clear;
        SQL.Add('SELECT * from AO_NOMENCLATUREN1(:PT1NOM, :PT1ORDREAFF)');
        ParamCheck := True;
        ParamByName('PT1NOM').AsString := cds_SAVPT1.FieldByName('PT1_NOM').AsString;
        ParamByName('PT1ORDREAFF').AsInteger := cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsInteger;
        Open;

        if RecordCount > 0 then
        begin
          cds_SAVPT1.Edit;
          cds_SAVPT1.FieldByName('PT1_ID').AsInteger := FieldByName('PT1_ID').AsInteger;
          cds_SAVPT1.Post;
        end;

        cds_SAVPT2.Filtered := False;
        cds_SAVPT2.Filter := Format('PT2_PT1 = %d',[cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsInteger]);
        cds_SAVPT2.Filtered := True;
        cds_SAVPT2.First;
        while not cds_SAVPT2.Eof do
        begin
          Lab_Progress.Caption := Format('Traitment de la nomenclature N1 %d sur %d - N2 %d sur  %d',[cds_SAVPT1.RecNo, cds_SAVPT1.RecordCount,
                                                                                                      cds_SAVPT2.RecNo, cds_SAVPT2.RecordCount]);
          Lab_Progress.Update;

          Close;
          SQL.Clear;
          SQL.Add('Select * from AO_NOMENCLATUREN2(:PPT2PT1ID, :PPT2ORDREAFF, :PPT2FORID, :PPT2NOM, :PPT2LIBELLE, :PPT2ARTID)');
          ParamCheck := True;
          ParamByName('PPT2PT1ID').AsInteger := cds_SAVPT1.FieldByName('PT1_ID').AsInteger;
          ParamByName('PPT2ORDREAFF').AsInteger := cds_SAVPT2.FieldByName('PT2_ORDREAFF').AsInteger;

          if cds_SAVFORFAIT.Locate('FOR_NUM',cds_SAVPT2.FieldByName('PT2_FORNUM').AsInteger,[]) then
            ParamByName('PPT2FORID').AsInteger := cds_SAVFORFAIT.FieldByName('FOR_ID').AsInteger
          else
            raise Exception.Create(Format('Forfait non trouvé - PT2_FORNUM %d',[cds_SAVPT2.FieldByName('PT2_FORNUM').AsInteger]));

          if cds_SAVFORFAIT.FieldByName('FOR_ID').AsInteger = -1 then
            raise Exception.Create('Forfait correspondant non créé');

          if cds_ARTARTICLE.Locate('ART_FORNUM',cds_SAVFORFAIT.FieldByName('FOR_NUM').AsInteger,[]) then
          begin
            if cds_ARTARTICLE.FieldByName('ART_ID').AsInteger = -1 then
              raise Exception.Create('Modèle non créé');
          end
          else
             raise Exception.Create('Modèle non trouvé');

          ParamByName('PPT2NOM').AsString := cds_SAVPT2.FieldByName('PT2_NOM').AsString;
          ParamByName('PPT2LIBELLE').AsString := cds_SAVPT2.FieldByName('PT2_LIBELLE').AsString;
          ParamByName('PPT2ARTID').AsInteger := cds_ARTARTICLE.FieldByName('ART_ID').AsInteger;
          Open;

          cds_SAVPT2.Next;
        end;

        IB_Transaction.Commit;
      Except on E:Exception do
        begin
        Logs.AddToLogs(Format('N1: %d - N2 %d - Nom : %s - Erreur : %s',[cds_SAVPT1.FieldByName('PT1_ORDREAFF').AsInteger,cds_SAVPT2.FieldByName('PT2_ORDREAFF').AsInteger,cds_SAVPT2.FieldByName('PT2_NOM').AsString,E.Message]));
         IB_Transaction.Rollback;
        end;
      End;

      cds_SAVPT1.Next;

      pb_mainbar.Position := cds_SAVPT1.RecNo * 100 div cds_SAVPT1.RecordCount;
      Application.ProcessMessages;
    end;
  end;

  Logs.AddToLogs('--------------------');
  Logs.AddToLogs('- Traitement Terminé');
  Logs.AddToLogs('--------------------');

end;

procedure Tfrm_NomenkImpCsv.Nbt_DestFileClick(Sender: TObject);
begin
  With OD_File do
  begin
    Filter := 'Interbase|*.ib';
    Title := 'Sélectionner le fichier destination';
    if Execute then
      edt_DestFile.Text := FileName;
  end;
end;

procedure Tfrm_NomenkImpCsv.Nbt_ExecuteClick(Sender: TObject);
begin
  try
    FWorkInProgress := True;
    ExecuteProcessImport;
  finally
    FWorkInProgress := False;
  end;

end;

procedure Tfrm_NomenkImpCsv.Nbt_SourceFileClick(Sender: TObject);
begin
  With OD_File do
  begin
    Filter := 'Csv|*.csv';
    Title := 'Sélectionner le fichier à importer';
    if Execute then
      edt_SourceFile.Text := FileName;
  end;
end;

end.
