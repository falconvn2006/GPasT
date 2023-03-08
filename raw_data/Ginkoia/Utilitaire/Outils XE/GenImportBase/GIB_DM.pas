unit GIB_DM;

interface

uses
  SysUtils, Classes, IB_Components, IB_Access, IBODataset, DB, Dialogs, ComCtrls, StdCtrls, Midaslib,
  DBXInterBase, SqlExpr, GIB_Type, forms, DbClient, StrUtils;

type
  TDM_GIB = class(TDataModule)
    IBODDestination: TIBODatabase;
    Que_TmpD: TIBOQuery;
    IBOTransaction: TIBOTransaction;
  private
    FLabelEtat: TLabel;
    FProgressBar: TProgressBar;
    FMemo: TMEmo;
    { Déclarations privées }
  public
    { Déclarations publiques }
    Function ConnectToDb(AIboDb : TIBODatabase; APath : String) : Boolean;

    procedure DoExecuteProcess(APath : String);

    procedure DoCsvToCds(APath, AFileName, AAddNewField : String; AObligatoire : Boolean);

    procedure DoCdsToTable(ATableName, AIdField, ACheckField : String; ADoUpdate : Boolean = False); overload;
    procedure DoCdsToTable(ATableName, AIdField, ACheckField : String; ALstParentTable : Array of String; ALstParentField : Array of String; AStartIndexParent : Integer = -1); overload;

    function GetCds(ACdsName : String) : TClientDataset;

    function FillCbo(Cbo : TComboBox) : Boolean;

    Property LabelEtat : TLabel read FLabelEtat write FLabelEtat;
    property ProgressBar : TProgressBar read FProgressBar write FProgressBar;
    property Memo        : TMEmo read FMemo write FMemo;
  end;

var
  DM_GIB: TDM_GIB;

implementation

{$R *.dfm}

{ TDM_GCB }

function TDM_GIB.ConnectToDb(AIboDb: TIBODatabase; APath: String): Boolean;
begin
  With AIboDb do
  Try
    AIboDb.Disconnect;
    AIboDb.DatabaseName := APath;
    AIboDb.Connect;
    Result := True;
  Except on E:Exception do
    begin
      Showmessage('Erreur de connexion à la base de données :' + E.Message);
      Result := False;
    end;
  End;
end;

procedure TDM_GIB.DoCdsToTable(ATableName, AIdField, ACheckField: String; ADoUpdate : Boolean);
var
  Cds : TClientDataset;
  Id, i, iIndexfield, j : Integer;
  lstField : TStringList;
  sQueryInsert, sQueryValues, sUpdateMain : String;
begin
  Cds := GetCds(ATableName);
  if Cds <> nil then
  begin
    lstField := TStringList.Create;
    try
      lstField.Text := StringReplace(ACheckField,';',#13#10,[rfReplaceAll]);

      Cds.First;
      while not Cds.Eof do
      begin
        try
          With Que_TmpD do
          begin
            // Vérification que les données n'existe pas encore
            Close;
            SQL.Clear;
            SQL.Add('Select ' + ATableName + '.* from ' + ATableName);
            SQL.Add('  join K on K_ID = ' + AIdField + ' and K_Enabled = 1');
            SQL.Add('Where ' {+ AIdField} + ' 0 = 0');
            for i := 0 to lstField.Count -1 do
            begin
              iIndexfield := cds.FieldList.IndexOf(lstField[i]);
              if iIndexfield <> -1 then
                SQL.Add(' and ' + lstField[i] + ' = :P' + lstField[i]);
            end;
            ParamCheck := True;
            for i := 0 to lstField.Count -1 do
            begin
              iIndexfield := cds.FieldList.IndexOf(lstField[i]);
              if iIndexfield <> -1 then
                ParamByName('P' + lstField[i]).Value := cds.Fields.Fields[iIndexfield].Value;
            end;
            Open;

            if RecordCount > 0 then
            begin
              // L'info existe déjà donc on enregistre les données dans le Cds
              cds.Edit;
              cds.FieldByName(AIdField + '_New').Value := FieldByName(AIdField).Value;
              cds.Post;

              if ADoUpdate then
              begin
                sUpdateMain := '';
                for i := 0 to FieldList.Count -1 do
                begin
                  iIndexfield := cds.FieldList.IndexOf(Fields.Fields[i].FieldName);
                  if iIndexfield <> -1 then
                    if CompareText(cds.Fields.Fields[iIndexfield].Value,Fields.Fields[i].Value) <> 0 then
                      sUpdateMain := sUpdateMain + ' ' + Fields.Fields[i].FieldName +
                                                   ' = :P' +Fields.Fields[i].FieldName + ',';
                end;

                if Trim(sUpdateMain) <> '' then
                begin
                  sUpdateMain := Copy(sUpdateMain,1,Length(sUpdateMain) -1);
                  Close;
                  SQL.Clear;
                  SQL.Add('UPDATE ' + ATableName + ' Set');
                  SQL.Add(sUpdateMain);
                  SQL.Add('Where ' + AIdField + ' =:P' + AIdField);
                  ParamCheck := True;

                  for i := 0 to ParamsCount -1 do
                    for j := 0 to cds.FieldCount -1 do
                      if Params.Items[i].Name = 'P' + Cds.Fields.Fields[j].FieldName then
                       Params.Items[i].Value := Cds.Fields.Fields[j].Value;

                  ParamByName('P' + AIdField).Value := cds.FieldByName(AIdField + '_New').Value;
                  IBOTransaction.StartTransaction;
                  try
                    ExecSQL;

                    Close;
                    SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:PID,0)';
                    ParamCheck := True;
                    ParamByName('PID').Value := cds.FieldByName(AIdField + '_New').Value;
                    ExecSQL;

                    IBOTransaction.Commit;
                  Except on E:Exception do
                    begin
                      IBOTransaction.Rollback;
                      raise Exception.Create(E.Message);
                    end;
                  end;


                end;
              end;
            end
            else begin
              // pas de données existante alors on va les créer
              // Construction de la requête
              sQueryInsert := 'Insert into ' + ATableName + '(' + AIdField;
              sQueryValues := 'Values(:P' + AIdField;

              for i := 0 to Fields.Count -1 do
              begin
                if (cds.FieldList.IndexOf(Fields.Fields[i].FieldName) <> -1) and
                   (UpperCase(Fields.Fields[i].FieldName) <> UpperCase(AIdField)) then
                begin
                  sQueryInsert := sQueryInsert + ',' + Fields.Fields[i].FieldName;
                  sQueryValues := sQueryValues + ',:P' + Fields.Fields[i].FieldName;
                end;
              end;
              sQueryInsert := sQueryInsert + ')';
              sQueryValues := sQueryValues + ')';

              IBOTransaction.StartTransaction;
              try
                // Récupération du nouvel ID
                Close;
                SQL.Clear;
                SQL.Add('Select ID from PR_NEWK(' + QuotedStr(ATableName) + ')');
                Open;

                ID := FieldByName('ID').AsInteger;

                // Insertion des données
                Close;
                SQL.Clear;
                SQL.Add(sQueryInsert);
                SQL.Add(sQueryValues);
                ParamCheck := True;
                ParamByName('P' + AIdField).AsInteger := ID;

                for I := 0 to cds.FieldCount -1 do
                  if (UpperCase(cds.Fields.Fields[i].FieldName) <> UpperCase(AIdField)) and
                     (Params.FindParam('P' + cds.Fields.Fields[i].FieldName) <> nil) then
                  begin
                    if  cds.Fields.Fields[i].DataType = ftString then
                      ParamByName('P' +  cds.Fields.Fields[i].FieldName).AsString :=  cds.Fields.Fields[i].AsString
                    else
                      ParamByName('P' +  cds.Fields.Fields[i].FieldName).Value :=  cds.Fields.Fields[i].Value;
                  end;
                ExecSQL;
                IBOTransaction.Commit;

                cds.Edit;
                cds.FieldByName(AIdField + '_New').Value := ID;
                cds.Post;

              Except on E:Exception do
                begin
                  IBOTransaction.Rollback;
                  raise Exception.Create(E.Message);
                end;
              end;
            end;

          end;
          Cds.Next;
        Except on E:Exception do
          raise Exception.Create('DoCdsToTable -> ' + E.Message);
        end;
      end;
    finally
      lstField.Free;
    end;
  end
  else
    raise ETABLENOTDFOUND.Create('Table non trouvée : ' + ATableName);
end;

procedure TDM_GIB.DoCdsToTable(ATableName, AIdField, ACheckField: String;
  ALstParentTable, ALstParentField: array of String;
  AStartIndexParent: Integer);
var
  cds : TClientDataSet;
  i, j, iStart, iEnd, iIndexfield, Id , icount, icountCreation: Integer;
  ACds : Array of TClientDataSet;
  ACdsTmp : TClientDataSet;
  lstField : TStringList;
  sQuerySelect, sQueryInsert, sQueryValues : String;
  bContinue : Boolean;
begin
  if High(ALstParentTable) <> High(ALstParentField)  then
    raise Exception.Create('ALstParentTable et ALstParentField doivent avoir le même nombre de paramètres');

  cds := GetCds(ATableName);
  if Cds <> nil then
  Try
    icount := 0;
    icountCreation := 0;

    lstField := TStringList.Create;
    try
      // Récupération des tables parentes
      SetLength(ACds,0);
      for i := Low(ALstParentTable) to High(ALstParentTable) do
      begin
        ACdsTmp := GetCds(ALstParentTable[i]);
        if ACdsTmp <> nil then
        begin
          SetLength(ACds,Length(ACds) + 1);
          ACds[Length(ACds) - 1] := ACdsTmp;
        end;
      end;

      // récupération des champs pour le check
      lstField.Text := StringReplace(ACheckField,';',#13#10,[rfReplaceAll]);

      cds.First;
      while not cds.Eof do
      begin
        Inc(icount);
        // Vérification que les données ne sont pas encore dans la table
        sQuerySelect := 'Select ' + ATableName + '.* from ' + ATableName +
                        ' Join K on K_ID = ' + AIdField + ' and K_Enabled = 1' +
                        ' Where ' + ' 0 = 0';

        // Récupération des paramètres de recherche
        if AStartIndexParent = -1 then
        begin
          iStart := 0;
          iEnd   := lstField.Count -1;
        end
        else begin
          iStart := 0;
          iEnd  := AStartIndexParent -1;
        end;

        for i := iStart to iEnd do
        begin
          iIndexfield := cds.FieldList.IndexOf(lstField[i]);
          if iIndexfield <> -1 then
            sQuerySelect := sQuerySelect + (' and ' + lstField[i] + ' = :P' + lstField[i]);
        end;

        bContinue := True;
        // recherche des ID dans les tables parentes
        if  AStartIndexParent <> -1  then
          for i := Low(ACds) to High(Acds) do
            if ACds[i] <> nil then
            begin
              if not ACds[i].Locate(ALstParentField[i],cds.FieldByName(lstField[i + AStartIndexParent]).AsVariant,[loCaseInsensitive]) then
              begin
                if cds.FieldByName(lstField[i + AStartIndexParent]).AsVariant <> 0 then
                begin
                  FMemo.Lines.Add(Format('Pas de valeur correspondante : %s / %s : %s',
                                            [ALstParentField[i],
                                            lstField[i + AStartIndexParent],
                                            cds.FieldByName(lstField[i + AStartIndexParent]).AsVariant]));
                  bContinue := False;
                end
                else
                  sQuerySelect := sQuerySelect + (' and ' + lstField[i + AStartIndexParent] + ' =0');
              end
              else
                sQuerySelect := sQuerySelect + (' and ' + lstField[i + AStartIndexParent] + ' =:P' + lstField[i + AStartIndexParent]);
            end;

        if bContinue then
          With TIBOQuery.Create(Self) do
          Try
            Close;
            SQL.Text := sQuerySelect;
            ParamCheck := True;

            for i := iStart to iEnd do
              ParamByName('P' + lstField[i]).Value := Cds.FieldByName( lstField[i]).AsVariant;

            if (AStartIndexParent <> -1) then
              for i := Low(ACds) to High(ACds) do
                for j := 0 to ParamCount -1 do
                  if Params.Items[j].Name = 'P' +lstField[i + AStartIndexParent] then
                    Params.Items[j].Value := ACds[i].FieldByName(ALstParentField[i] + '_New').AsVariant;
//                if FindParam('P' + lstField[i + AStartIndexParent]) <> nil then
//                  ParamByName('P' +  lstField[i + AStartIndexParent]).Value := ACds[i].FieldByName(ALstParentField[i] + '_New').AsVariant;
            Open;

//            if ATableName = 'CSHPARAMCF' then
//            begin
//              FMemo.lines.add('------------------------------------');
//              for i := 0 to ParamCount -1 do
//                FMemo.lines.add(Format('%s = %s',[Params.Items[i].Name,Params.Items[i].Value]));
//            end;

            if RecordCount > 0 then
            begin
              // Existe déjà
              Cds.Edit;
              Cds.FieldByName(AIdField + '_New').Value := FieldbyName(AIdField).AsVariant;
              cds.Post;
            end
            else begin
              // N'a pas été trouvé, donc création de la ligne
              inc(icountCreation);
              // Construction de la requête
              sQueryInsert := 'Insert into ' + ATableName + '(' + AIdField;
              sQueryValues := 'Values(:P' + AIdField;

              for i := 0 to FieldCount -1 do
                if (AIdField <> Fields.Fields[i].FieldName) and
                   (cds.FieldList.IndexOf(Fields.Fields[i].FieldName) <> -1) then
                begin
                  sQueryInsert := sQueryInsert + ',' + Fields.Fields[i].FieldName;
                  sQueryValues := sQueryValues + ',:P' + Fields.Fields[i].FieldName;
                end;
              sQueryInsert := sQueryInsert + ')';
              sQueryValues := sQueryValues + ')';

              IBOTransaction.StartTransaction;
              try
                // Récupération du nouvel ID
                Close;
                SQL.Text := 'Select ID from PR_NEWK(' + QuotedStr(ATableName) + ')';
                Open;

                Id := FieldByName('ID').AsInteger;

                Close;
                SQL.Clear;
                SQL.Add(sQueryInsert);
                SQL.Add(sQueryValues);
                ParamCheck := True;

                // Gestion des champs du Cds
                for i := 0 to cds.FieldCount -1 do
                  if (FindParam('P' + cds.Fields.Fields[i].FieldName) <> nil) and
                     (cds.Fields.Fields[i].FieldName <> AIdField) then
                  begin
                    ParamByName('P' + cds.Fields.Fields[i].FieldName).Value := cds.Fields.Fields[i].AsVariant;
                  end;

                // gestion de l'ID
                ParamByName('P' + AIdField).AsInteger := ID;

                // Gestion des champs parents
                if  AStartIndexParent <> -1  then
                  for i := Low(ACds) to High(ACds) do
                    if FindParam('P' + lstField[i + AStartIndexParent]) <> nil then
                      ParamByName('P' +  lstField[i + AStartIndexParent]).Value := ACds[i].FieldByName(ALstParentField[i] + '_New').AsVariant;
                ExecSQL;

                IBOTransaction.Commit;

                Cds.Edit;
                Cds.FieldByName(AIdField + '_New').AsVariant := Id;
                Cds.Post;
              Except on E:Exception do
                begin
                  IBOTransaction.Rollback;
                  Exit;
                end;
              end; //try
            end;
          finally
            Free;
          end; // with

        cds.Next;
      end;
    finally
      FMemo.Lines.Add(Format(ATableName + ' - Total Lignes %d - Créé %d', [icount, icountCreation]));
      lstField.Free;
    end;
  Except on E:Exception do
    raise;
  end
  else
    raise ETABLENOTDFOUND.Create('Table non trouvée ' + ATableName);
end;

procedure TDM_GIB.DoCsvToCds(APath, AFileName, AAddNewField: String;
  AObligatoire: Boolean);
var
  Cds : TClientDataSet;
  i, j, iFieldIndex : Integer;
  lstMain, lstEntete, lstLigne : TStringList;
begin
  cds := GetCds(AFileName);
  if  cds = nil then
  begin
    // Création du Cds en mémoire
    Cds := TClientDataSet.Create(Self);
    Cds.Name := 'Cds_' + AFileName;

    // Création des champs du Cds
    With Que_TmpD do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from ' + AFileName);
      SQL.Add('Where ' + AAddNewField + ' = -1');
      Open;

      for i := 0 to Fields.Count -1 do
        cds.FieldDefs.Add(Fields.Fields[i].FieldName,Fields.Fields[i].DataType, Fields.Fields[i].Size);

      // Ajout du field additionnel
      cds.FieldDefs.Add(AAddNewField + '_New', ftInteger);
      cds.CreateDataSet;
    end; // with
  end; // if

  cds.EmptyDataSet;

  if not AObligatoire then
  begin
    if not FileExists(APath + AFileName + '.csv') then
      Exit;
  end;

  lstMain := TStringList.Create;
  lstEntete := TStringList.Create;
  lstLigne := TStringList.Create;
  try
    lstMain.LoadFromFile(APath + AFileName + '.csv');

    // récupération de l'entête
    lstEntete.Text := StringReplace(lstMain[0],';',#13#10,[rfReplaceAll]);
    for i := 1 to lstMain.Count -1 do
    begin
      // traitement des lignes
      lstLigne.Text := StringReplace(lstMain[i],';',#13#10,[rfReplaceAll]);

      Cds.Append;
      for j := 0 to lstEntete.Count -1 do
      begin
        if (lstLigne.Count -1) >= j then
        begin
          iFieldIndex := cds.FieldList.IndexOf(lstEntete[j]);
          if iFieldIndex <> -1 then
            Cds.Fields.Fields[iFieldIndex].Value := lstLigne[j];
        end;
      end; // for j
      Cds.Post;
    end; // for i
  finally
    lstMain.Free;
    lstEntete.Free;
    lstLigne.Free;
  end;
end;

procedure TDM_GIB.DoExecuteProcess(APath : String);
var
  i  : Integer;
  sTable : String;
  sField : String;
  Cds : TClientDataSet;
begin
  InProgress := True;

  Memo.lines.Add('-------------------');
  Memo.lines.Add('Début du traitement');
  Memo.lines.Add('-------------------');

  try
    {$REGION '1- Récupération des Csv'}
    for i := Low(LstCsvFile) to High(LstCsvFile) do
    begin
      try
        FLabelEtat.Caption := '1- Chargement de ' + LstCsvFile[i].FileName;
        FLabelEtat.Update;

        DoCsvToCds(IncludeTrailingPathDelimiter(APath), LstCsvFile[i].FileName,LstCsvFile[i].AddField,LstCsvFile[i].Obligatoire);

        FProgressBar.Position := i * 100 Div High(LstCsvFile);
        Application.ProcessMessages;
      Except on E:Exception do
        FMemo.Lines.Add('1 - ' + E.Message)
      end;
    end;
    {$ENDREGION}

    {$REGION '2.1- Importation des données magasin'}
    for i := 1 to CMAXSOCIETE do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          CGENSOCIETE, CGENGESTIONPUMP, CGENGESTIONCLT, CTARVENTE, CGENGESTIONCLTCPT,
          CGENGESTIONCARTEFID, CGENPAYS: begin // Table commune
            DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField);
          end;
          CARTCLASSEMENT: DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,True);
          // GenVille
          CGENVILLE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENPAYS'],['PAY_ID'],2);
          // GENADRESSE
          CGENADRESSE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENVILLE'],['VIL_ID'],1);
          // GENMAGASIN
          CGENMAGASIN: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENSOCIETE','GENADRESSE','TARVENTE','GENGESTIONCLT'],['SOC_ID','ADR_ID','TVT_ID','GCL_ID'],2);
          CGENMAGGESTIONCF, CGENMAGGESTIONCLT,
          CGENMAGGESTIONCLTCPT, CGENMAGGESTIONPUMP : begin
            case AnsiIndexStr(LstCsvFile[i].FileName,['GENMAGGESTIONCF','GENMAGGESTIONCLT','GENMAGGESTIONCLTCPT','GENMAGGESTIONPUMP']) of
              0: begin
                sTable := 'GENGESTIONCARTEFID';
                sField := 'GCF_ID';
              end;
              1:begin
                sTable := 'GENGESTIONCLT';
                sField := 'GCL_ID';
              end;
              2:begin
                sTable := 'GENGESTIONCLTCPT';
                sField := 'GCC_ID';
              end;
              3:begin
                sTable := 'GENGESTIONPUMP';
                sField := 'GCP_ID';
              end;
            end;
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN',sTable],['MAG_ID', sField],0);
          end;
          // GENPOSTE
          CGENPOSTE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN'],['MAG_ID'],1);
        end; // case
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;

      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;
    end; // for

    {$ENDREGION}

    {$REGION '2.2- Importation des données Etiquettes'}
    for i := CMAXSOCIETE + 1 to CMAXETIQUETTE do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          // GENETQCHAMPS GENETQTYP
          CGENETQCHAMPS,CGENETQTYP: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField);
          // GENETQMOD
          CGENETQMOD: DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENETQTYP'],['GET_ID'],1);
          // GENETQMODC
          CGENETQMODC: DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENETQMOD'],['GEM_ID'],2);
          // GENETQMODL
          CGENETQMODL: DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENETQMOD','GENETQCHAMPS'],['GEM_ID','GEC_ID'],1);
        end;
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;
      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;
    end;
    {$ENDREGION}

    {$REGION '2.3- Importation des données Utilisateurs'}
    for i := CMAXETIQUETTE + 1 to CMAXUSR do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          // UILGROUPS UILGRPGINKOIA UILPERMISSIONS UILUSERS
          CUILGROUPS, CUILGRPGINKOIA,
          CUILPERMISSIONS, CUILUSERS: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField);
          // UILGROUPACCESS
          CUILGROUPACCESS: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['UILPERMISSIONS','UILGROUPS'],['PER_ID','GRP_ID'],1);
          // UILGROUPMEMBERSHIP
          CUILGROUPMEMBERSHIP: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['UILUSERS','UILGROUPS'],['USR_ID','GRP_ID'],2);
          // UILGRPGINKOIAL
          CUILGRPGINKOIAL: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['UILGRPGINKOIA','UILPERMISSIONS'],['UGG_ID','PER_ID'],0);
          // UILUSERACCESS
          CUILUSERACCESS: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['UILPERMISSIONS','UILUSERS'],['PER_ID','USR_ID'],0);
          // UILUSRMAG
          CUILUSRMAG: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['UILUSERS','GENMAGASIN'],['USR_ID','MAG_ID'],0);
          // UILGRPGINKOIAMAG
          CUILGRPGINKOIAMAG: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN','UILGRPGINKOIA'],['MAG_ID','UGG_ID'],1);
        end;
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;

      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;
    end;
    {$ENDREGION}

    {$REGION '2.4- Importation des données compta'}
    for i := CMAXUSR + 1 to CMAXCOMPTA do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          // ARTTYPECOMPTABLE ARTTVA
          CARTTYPECOMPTABLE,CARTTVA: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField);
          // GENMAGCOMPTA
          CGENMAGCOMPTA: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN'],['MAG_ID'],3);
          // ARTTVACOMPTA
          CARTTVACOMPTA: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['ARTTVA','GENMAGASIN'],['TVA_ID','MAG_ID'],2);
          // ARTCPTACHATVENTE
          CARTCPTACHATVENTE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['ARTTVA','ARTTYPECOMPTABLE','GENMAGASIN'],['TVA_ID','TCT_ID','MAG_ID'],0);
          // CSHCOFFRE
          CCSHCOFFRE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN'],['MAG_ID'],1);
          // CSHBANQUE
          CSHBANQUE: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENSOCIETE'],['SOC_ID'],1);
        end;
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;

      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;

    end;
    {$ENDREGION}

    {$REGION '2.5- Imporation Fidélité'}
    for i := CMAXCOMPTA + 1 to CMAXFID do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          // CSHPARAMCF
          CCSHPARAMCF: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENGESTIONCARTEFID'],['GCF_ID'],0);
          // CSHPARAMCFL
          CCSHPARAMCFL: DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['CSHPARAMCF'],['CTF_ID'],1);
        end;
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;

      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;

    end;
    {$ENDREGION}

    {$REGION '2.6- Importation Réplication'}
    for i := CMAXFID + 1 to CMAXREPLI do
    begin
      FLabelEtat.Caption := '2- Importation des données : ' + LstCsvFile[i].FileName;
      FLabelEtat.Update;
      try
        case i of
          CGENBASES :
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN'],['MAG_ID'],2);
          CGENLAUNCH :
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENBASES'],['BAS_ID'],0);
          CGENREPLICGRP, CGENMAGGRP, CGENREPREFER :
            DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField);
          CGENPROVIDERS, CGENSUBSCRIBERS :
            DoCdsToTable( LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,True);
          CGENREPLICATION, CGENCHANGELAUNCH :
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENLAUNCH'],['LAU_ID'],0);
          CGENCONNEXION :
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENLAUNCH'],['LAU_ID'],1);
          CGENREPLICGRPL, CGENMAGGRPL : begin
            case i of
              CGENREPLICGRPL: begin
                sTable := 'GENREPLICGRP';
                sField := 'RGP_ID';
              end;
              CGENMAGGRPL: begin
                sTable := 'GENMAGGRP';
                sField := 'MGP_ID';
              end;
            end; // case
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENMAGASIN',sTable],['MAG_ID', sField],0);
          end;
          CGENREPREFERLIGNE:
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,['GENREPREFER'],['RRE_ID'],0);
          CGENLIAIREPLISUB, CGENLIAIREPLIPRO: begin
            case i of
              CGENLIAIREPLISUB: begin
                sTable := 'GENPROVIDERS';
                sField := 'PRO_ID';
              end;
              CGENLIAIREPLIPRO: begin
                sTable := 'GENSUBSCRIBERS';
                sField := 'SUB_ID';
              end;
            end; // case
            DoCdsToTable(LstCsvFile[i].FileName, LstCsvFile[i].AddField, LstCsvFile[i].CheckField,[sTable,'GENREPLICATION'],[sField,'REP_ID'],0);
          end;
        end; // case
      Except
        on E:ETABLENOTDFOUND do
        begin
          if LstCsvFile[i].Obligatoire then
          begin
            FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
            Exit;
          end;
        end;
        on E:Exception do
        begin
          FMemo.Lines.Add(LstCsvFile[i].FileName + ' - Erreur : ' + E.Message);
          Exit;
        end;
      end;

      FProgressBar.Position := i * 100 Div CMAXTABLE;
      Application.ProcessMessages;

    end;
    {$ENDREGION}

    {$REGION 'Fin - Finalisation des magasins'}
    IBOTransaction.StartTransaction;
    try
      Cds := GetCds('GENMAGASIN');
      With Que_TmpD do
      begin
        Close;
        SQL.Clear;
        SQL.Add('EXECUTE PROCEDURE PR_INTITIALISEMAG(:PMAGID)');
        ParamCheck := True;

        cds.First;
        while not cds.Eof do
        begin
          FLabelEtat.Caption := '3- Initialisation des magasins : ' + cds.FieldByName('MAG_ENSEIGNE').AsString;
          FLabelEtat.Update;

          Close;
          ParamByName('PMAGID').AsInteger := cds.FieldByName('MAG_ID_New').AsInteger;
          ExecSQL;

          FProgressBar.Position := cds.RecNo * 100 Div cds.RecordCount;
          Application.ProcessMessages;

          cds.Next;
        end;
      end;

      Cds := GetCds('GENBASES');
      With Que_TmpD do
      begin
        Close;
        SQL.Clear;
        SQL.Add('EXECUTE PROCEDURE PR_INITBASE (:PBASID,'''','''')');
        ParamCheck := True;

        Cds.First;
        while not Cds.Eof do
        begin
          FLabelEtat.Caption := '4- Initialisation des bases : ' + cds.FieldByName('BAS_NOM').AsString;
          FLabelEtat.Update;

          Close;
          ParamByName('PBASID').AsInteger := cds.FieldByName('BAS_ID_New').AsInteger;
          ExecSQL;

          FProgressBar.Position := cds.RecNo * 100 Div cds.RecordCount;
          Application.ProcessMessages;

          cds.Next;
        end;
      end;

      IBOTransaction.Commit;
    Except on E:Exception do
      begin
        IBOTransaction.Rollback;
        FMemo.Lines.Add('Initialise mag erreur : ' + E.Message);
      end;
    end;
//
    {$ENDREGION}

    Memo.lines.Add('-------------------');
    Memo.lines.Add('Fin du traitement');
    Memo.lines.Add('-------------------');

  finally
    InProgress := False;
  end;
end;

function TDM_GIB.FillCbo(Cbo: TComboBox): Boolean;
var
  i : Integer;
begin
  cbo.Clear;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TClientDataSet then
      cbo.AddItem(Components[i].Name,Components[i]);
end;

function TDM_GIB.GetCds(ACdsName: String): TClientDataset;
var
  i : Integer;
  Compo : TComponent;
begin
  Result := nil;
  for I := 0 to ComponentCount -1 do
    if Components[i].Name = 'Cds_' + ACdsName then
      Result := TClientDataSet(Components[i]);
end;

end.
