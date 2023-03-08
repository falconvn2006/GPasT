unit GEB_DM;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components, IB_Access, ComCtrls, StdCtrls, Dialogs, MidasLib,
  DBClient, uCreateCsv, GEB_Type, forms, StrUtils;

type
  TDM_GEB = class(TDataModule)
    IBODbSource: TIBODatabase;
    Que_TmpS: TIBOQuery;
    Que_LstSociete: TIBOQuery;
    Que_LstMag: TIBOQuery;
    Que_LstAdr: TIBOQuery;
    Que_GenETQTyp: TIBOQuery;
    Que_GENETQCHAMPS: TIBOQuery;
    Que_GENETQMOD: TIBOQuery;
    Que_UILUSERS: TIBOQuery;
    Que_UILGRPGINKOIA: TIBOQuery;
    Que_UILPERMISSIONS: TIBOQuery;
    Que_UILGROUPS: TIBOQuery;
    Que_ARTTVA: TIBOQuery;
    Que_ARTTYPECOMPTABLE: TIBOQuery;
    Que_GENGESTIONCARTEFID: TIBOQuery;
    Que_CSHPARAMCF: TIBOQuery;
    Que_GENBASES: TIBOQuery;
    Que_GENREPLICGRP: TIBOQuery;
    Que_GENMAGGRP: TIBOQuery;
    Que_GENLAUNCH: TIBOQuery;
    Que_GENREPREFER: TIBOQuery;
    Que_GENMAGASIN: TIBOQuery;
  private
    FProgress: TprogressBar;
    FLabelEtat: TLabel;
    FMemo: TMemo;
    FListeIdMag: String;

    { Déclarations privées }
  public
    { Déclarations publiques }
    Function ConnectToDb(AIboDb : TIBODatabase; APath : String) : Boolean;

    function ConvertTableToCsv(APath, ATableName, ATableField : String; bGetZero : Boolean = False;
      AChampFiltree : String = ''; AListeValeursFiltrees : String = '') : Boolean;overload;
    function ConvertTableToCsv(APath, ATableName, ATableField : String;
      AFieldsParent : Array of String; AFieldsId : Array of Integer; bGetZero : Boolean = False;
      AChampFiltree : String = ''; AListeValeursFiltrees : String = '') : Boolean;overload;

    Procedure DoExecuteProcess(APathDest : String);

    function ListeMagasins(var slMagasins: TStringList): Boolean;

    property LabelEtat : TLabel read FLabelEtat write FLabelEtat;
    property Memo : TMemo read FMemo write FMemo;
    property Progress : TprogressBar read FProgress write FProgress;
    property ListeIdMag : String read FListeIdMag write FListeIdMag;
  end;

var
  DM_GEB: TDM_GEB;

implementation

{$R *.dfm}

{ TDM_GEB }

function TDM_GEB.ConnectToDb(AIboDb: TIBODatabase; APath: String): Boolean;
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

function TDM_GEB.ConvertTableToCsv(APath, ATableName, ATableField: String; bGetZero : Boolean = False;
  AChampFiltree : String = ''; AListeValeursFiltrees : String = ''): Boolean;
var
  Csv : TExportHeaderOL;
  i : Integer;
begin
  Csv := TExportHeaderOL.Create;
  try
    With Que_TmpS do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select ' + ATableName + '.* from ' + ATableName);
      SQL.Add('  join K on K_ID = ' + ATableField + ' and K_Enabled = 1');
      if not bGetZero then
        SQL.Add('Where ' + ATableField + ' <> 0');

      if AChampFiltree <> '' then
        SQL.Add(Format('  and %s in (%s)', [AChampFiltree, AListeValeursFiltrees]));

      Open;

      for i := 0 to FieldList.Count -1 do
        case FieldList.Fields[i].DataType of
          ftString   ,
          ftUnknown  : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmNone);
          ftSmallint,
          ftInteger,
          ftWord     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmInteger);
          ftFloat    ,
          ftCurrency ,
          ftBCD      : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmFloat,'0.00',DecimalSeparator);
          ftDate     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'DD/MM/YYYY');
          ftTime     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'hh:mm:ss');
          ftDateTime : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'DD/MM/YYYY hh:mm:ss');
          else
            Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmNone);
        end;
      Csv.bWriteHeader := True;
      Csv.bAlign := False;
      Csv.Separator := ';';
      Csv.ConvertToCsv(Que_TmpS,IncludeTrailingBackslash(APath) + ATableName + '.csv');
    end;
  finally
    Csv.Free;
  end;
end;

function TDM_GEB.ConvertTableToCsv(APath, ATableName, ATableField : String;
  AFieldsParent : Array of String; AFieldsId : Array of Integer; bGetZero : Boolean = False;
  AChampFiltree : String = ''; AListeValeursFiltrees : String = '') : Boolean;
var
  Csv : TExportHeaderOL;
  i : Integer;
begin
  if High(AFieldsParent) <> High(AFieldsId) then
    raise Exception.Create('Nombre de paramètres incorrecte');

  Csv := TExportHeaderOL.Create;
  try
    With Que_TmpS do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select ' + ATableName + '.* from ' + ATableName);
      SQL.Add('  join K on K_ID = ' + ATableField + ' and K_Enabled = 1');
      if not bGetZero then
        SQL.Add('Where ' + ATableField + ' <> 0')
      else
        SQL.Add('Where 0=0');

      for i := Low(AFieldsParent) to High(AFieldsParent) do
        SQL.Add('  and ' + AFieldsParent[i] + ' = ' + IntToStr(AFieldsId[i]));

      if AChampFiltree <> '' then
        SQL.Add(Format('  and %s in (%s)', [AChampFiltree, AListeValeursFiltrees]));

      Open;

      for i := 0 to FieldList.Count -1 do
        case FieldList.Fields[i].DataType of
          ftString   ,
          ftUnknown  : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmNone);
          ftSmallint,
          ftInteger,
          ftWord     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmInteger);
          ftFloat    ,
          ftCurrency ,
          ftBCD      : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmFloat,'0.00',DecimalSeparator);
          ftDate     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'DD/MM/YYYY');
          ftTime     : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'hh:mm:ss');
          ftDateTime : Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmDate, 'DD/MM/YYYY hh:mm:ss');
          else
            Csv.Add( FieldList.Fields[i].FieldName,FieldList.Fields[i].DataSize,alLeft, fmNone);
        end;
      Csv.bWriteHeader := True;
      Csv.bAlign := False;
      Csv.Separator := ';';
      Csv.ConvertToCsv(Que_TmpS,IncludeTrailingBackslash(APath) + ATableName + '.csv');
    end;
  finally
    Csv.Free;
  end;

end;

procedure TDM_GEB.DoExecuteProcess(APathDest : String);
var
  lstField : TStringList;
  i, iTotalProgress, iTotalInter : Integer;
begin
  InProgress := True;
  try
    iTotalProgress := High(TableSocieteList) + High(TableEtiquetteList) +
                      High(TableUILList) + High(TableComptaList) +
                      High(TableRepliList);

    Memo.lines.Add('-------------------');
    Memo.lines.Add('Début du traitement');
    Memo.lines.Add('-------------------');
    Que_LstSociete.Close;
    Que_LstSociete.Open;

    {$REGION '1- Récupération des données de la société'}
    for i := 1 to High(TableSocieteList) do
    begin
      LabelEtat.Caption := 'Exportation de ' + TableSocieteList[i].Table;
      LabelEtat.Update;
      try
        case i  of
          // Copie standard des 7 premières table du tableau
          1..7 : ConvertTableToCsv(APathDest, TableSocieteList[i].Table, TableSocieteList[i].Field);
          8: ConvertTableToCsv(APathDest, TableSocieteList[i].Table, TableSocieteList[i].Field, True);
          9: begin // GENMAGASIN
            With Que_LstSociete do
            begin
              First;
              while not EOF do
              begin
                ConvertTableToCsv(APathDest,TableSocieteList[i].Table, TableSocieteList[i].Field,
                  [TableSocieteList[i].ParentField],[FieldbyName('SOC_ID').AsInteger],
                  False, 'MAG_ID', ListeIdMag);
                Next;
              end;
            end;
          end; // 8
          10..15: begin // Gestion des tables ayant une dépendance avec MAG_ID
             Que_LstSociete.First;
             while not Que_LstSociete.EOF do
             begin
               With Que_LstMag do
               begin
                 Close;
                 ParamCheck := True;
                 ParamByName('PSOCID').AsInteger := Que_LstSociete.FieldByName('SOC_ID').AsInteger;
                 Open;

                 while not EOF do
                 begin
                   if TableSocieteList[i].Table = 'GENADRESSE' then
                     ConvertTableToCsv(APathDest,TableSocieteList[i].Table,
                      TableSocieteList[i].Field,[TableSocieteList[i].ParentField],[FieldbyName('MAG_ADRID').AsInteger])
                   else begin
                    if ListeIdMag = '' then
                      ConvertTableToCsv(APathDest,TableSocieteList[i].Table,
                        TableSocieteList[i].Field,[TableSocieteList[i].ParentField],[FieldbyName('MAG_ID').AsInteger])
                    else
                      ConvertTableToCsv(APathDest,TableSocieteList[i].Table,
                        TableSocieteList[i].Field,[TableSocieteList[i].ParentField],[FieldbyName('MAG_ID').AsInteger],
                        False, TableSocieteList[i].ParentField, ListeIdMag);
                   end;
                   Next;
                 end;
               end;

               Que_LstSociete.Next;
             end;
          end;  // 9..13
          16..17: begin // Gestion Ville et Pays
             Que_LstSociete.First;
             while not Que_LstSociete.EOF do
             begin
               Que_LstMag.Close;
               Que_LstMag.ParamCheck := True;
               Que_LstMag.ParamByName('PSOCID').AsInteger := Que_LstSociete.FieldByName('SOC_ID').AsInteger;
               Que_LstMag.Open;

               while not Que_LstMag.EOF do
               begin
                 With Que_LstAdr do
                 begin
                   Close;
                   ParamCheck := True;
                   ParamByName('PADRID').AsInteger := Que_LstMag.FieldByName('MAG_ADRID').AsInteger;
                   Open;

                   while not EOF do
                   begin
                     if TableSocieteList[i].Table = 'GENPAYS' then
                       ConvertTableToCsv(APathDest,TableSocieteList[i].Table, TableSocieteList[i].Field,[TableSocieteList[i].ParentField],[FieldbyName('VIL_PAYID').AsInteger])
                     else
                       ConvertTableToCsv(APathDest,TableSocieteList[i].Table, TableSocieteList[i].Field,[TableSocieteList[i].ParentField],[FieldbyName('ADR_VILID').AsInteger]);
                     Next;
                   end;
                 end;

                 Que_LstMag.Next;
               end;
               Que_LstSociete.Next;
             end;

          end;
        end; // case
      Except on E:Exception do
        Memo.Lines.Add('[Erreur] ' + TableSocieteList[i].Table + ' -> ' + E.Message);
      end;

      Progress.Position := i * 100 Div iTotalProgress;
      Application.ProcessMessages;
    end; // for
    {$ENDREGION}
    iTotalInter := High(TableSocieteList);

    {$REGION '2- Extraction des tables étiquettes'}
    for i := 1 to High(TableEtiquetteList) do
    begin
      LabelEtat.Caption := 'Exportation de ' + TableEtiquetteList[i].Table;
      LabelEtat.Update;
      try
        case i of
          1..2: ConvertTableToCsv(APathDest, TableEtiquetteList[i].Table, TableEtiquetteList[i].Field);
          3: begin // Gestion des tables parentes à GENETQTYP
            With Que_GenETQTyp do
            begin
              Close;
              Open;

              while not EOF do
              begin
                ConvertTableToCsv(APathDest,TableEtiquetteList[i].Table, TableEtiquetteList[i].Field,[TableEtiquetteList[i].ParentField],[FieldbyName('GET_ID').AsInteger]);

                Next;
              end;
            end;
          end; // Gestion des tables Parentes à GENETQMOD et/ou GENETQCHAMPS
          4..5: begin
            Que_GenETQTyp.Close;
            Que_GenETQTyp.Open;

            while not Que_GenETQTyp.EOF do
            begin
              With Que_GENETQMOD do
              begin
                Close;
                ParamCheck := True;
                ParamByName('PGETID').AsInteger := Que_GenETQTyp.FieldByName('GET_ID').AsInteger;
                Open;

                while not EOF do
                begin
                  ConvertTableToCsv(APathDest,TableEtiquetteList[i].Table, TableEtiquetteList[i].Field,[TableEtiquetteList[i].ParentField],[FieldbyName('GEM_ID').AsInteger]);
                  Next;
                end;
              end;

              Que_GenETQTyp.NExt;
            end;
          end;
        end;
      Except on E:Exception do
        Memo.Lines.Add('[Erreur] ' + TableSocieteList[i].Table + ' -> ' + E.Message);
      end;
      Progress.Position := (i + iTotalInter) * 100 Div iTotalProgress;
      Application.ProcessMessages;
    end; // for
    {$ENDREGION}
    iTotalInter := iTotalInter + High(TableEtiquetteList);

    Que_UILUSERS.Close;
    Que_UILUSERS.Open;

    Que_UILGRPGINKOIA.Close;
    Que_UILGRPGINKOIA.Open;

    Que_UILPERMISSIONS.Close;
    Que_UILPERMISSIONS.Open;

    Que_UILGROUPS.Close;
    Que_UILGROUPS.Open;
    {$REGION '3- Traitement des utilisateurs'}
    lstField := TStringList.Create;
    try
      for i := Low(TableUILList) to High(TableUILList) do
      begin
        LabelEtat.Caption := 'Exportation de ' + TableUILList[i].Table;
        LabelEtat.Update;
        try
          case i of
            1..4: ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field);
            5..6: begin
              lstField.Text := TableUilList[i].ParentField;
              lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

              Que_LstSociete.First;
              while not Que_LstSociete.EOF do
              begin
                Que_LstMag.Close;
                Que_LstMag.ParamCheck := True;
                Que_LstMag.ParamByName('PSOCID').AsInteger := Que_LstSociete.FieldByName('SOC_ID').AsInteger;
                Que_LstMag.Open;

                while not Que_LstMag.EOF do
                begin
                  case AnsiIndexStr(TableUilList[i].Table,['UILUSRMAG','UILGRPGINKOIAMAG']) of
                    0: begin // UILUSRMAG
                      Que_UILUSERS.First;
                      while not Que_UILUSERS.EOF do
                      begin
                        if Que_UILUSERS.FieldByName('USR_USERNAME').AsString <> 'algol' then
                          ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                           [lstField[0],lstField[1]],
                                           [Que_LstMag.FieldbyName('MAG_ID').AsInteger,Que_UILUSERS.FieldByName('USR_ID').AsInteger],
                                           False, 'UMA_MAGID', ListeIdMag);

                        Que_UILUSERS.Next;
                      end;
                    end; // 0
                    1: begin // UILGRPGINKOIAMAG
                      Que_UILGRPGINKOIA.First;
                      while not Que_UILGRPGINKOIA.Eof do
                      begin
                        ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                          [lstField[0],lstField[1]],
                                          [Que_LstMag.FieldbyName('MAG_ID').AsInteger,Que_UILGRPGINKOIA.FieldByName('UGG_ID').AsInteger],
                                           False, 'UGM_MAGID', ListeIdMag);
                        Que_UILGRPGINKOIA.Next;
                      end;
                    end; // 1
                  end; // case

                  Que_LstMag.Next;
                end; // while mag

                Que_LstSociete.Next;
              end; // while societe

            end; // 5..6
            7: begin
              lstField.Text := TableUilList[i].ParentField;
              lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

              Que_UILUSERS.First;
              while not Que_UILUSERS.EOF do
              begin
                Que_UILGROUPS.First;
                while not Que_UILGROUPS.Eof do
                begin
                  ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                    [lstField[0],lstField[1]],
                                    [Que_UILUSERS.FieldbyName('USR_ID').AsInteger,Que_UILGROUPS.FieldByName('GRP_ID').AsInteger]);

                  Que_UILGROUPS.Next;
                end;
                Que_UILUSERS.Next;
              end; // 7
            end;
            8..10: begin
              lstField.Text := TableUilList[i].ParentField;
              lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

              Que_UILPERMISSIONS.First;
              while not Que_UILPERMISSIONS.EOF do
              begin
                case AnsiIndexStr(TableUilList[i].Table,['UILUSERACCESS','UILGROUPACCESS', 'UILGRPGINKOIAL']) of
                  0: begin // UILUSERACCESS
                    Que_UILUSERS.First;
                    while not Que_UILUSERS.EOF do
                    begin
                      ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                        [lstField[0],lstField[1]],
                                        [Que_UILPERMISSIONS.FieldbyName('PER_ID').AsInteger,Que_UILUSERS.FieldByName('USR_ID').AsInteger]);

                      Que_UILUSERS.Next;
                    end; // while
                  end; // 0
                  1: begin // UILGROUPACCESS
                    Que_UILGROUPS.First;
                    while not Que_UILGROUPS.Eof do
                    begin
                      ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                        [lstField[0],lstField[1]],
                                        [Que_UILPERMISSIONS.FieldbyName('PER_ID').AsInteger,Que_UILGROUPS.FieldByName('GRP_ID').AsInteger]);

                      Que_UILGROUPS.Next;
                    end;
                  end; // 1
                  2: begin // UILGRPGINKOIAL
                    Que_UILGRPGINKOIA.First;
                    while not Que_UILGRPGINKOIA.Eof do
                    begin
                      ConvertTableToCsv(APathDest, TableUILList[i].Table, TableUILList[i].Field,
                                        [lstField[0],lstField[1]],
                                        [Que_UILPERMISSIONS.FieldbyName('PER_ID').AsInteger,Que_UILGRPGINKOIA.FieldByName('UGG_ID').AsInteger]);
                      Que_UILGRPGINKOIA.Next;
                    end;
                  end; // 2
                end; //case

                Que_UILPERMISSIONS.Next;
              end; // while
            end; // 8..10
          end; //case
        Except on E:Exception do
          Memo.Lines.Add('[Erreur] ' + TableSocieteList[i].Table + ' -> ' + E.Message);
        end;

        Progress.Position := (i + iTotalInter) * 100 Div iTotalProgress;
        Application.ProcessMessages;
      end; // for
    finally
      lstField.Free;
    end;
    {$ENDREGION}
    iTotalInter := iTotalInter + High(TableUILList);

    Que_ARTTVA.Close;
    Que_ARTTVA.Open;

    Que_ARTTYPECOMPTABLE.Close;
    Que_ARTTYPECOMPTABLE.Open;
    {$REGION '4- Paramétrage export comptable'}
     lstField := TStringList.Create;
    try
      for i := 1 to High(TableComptaList) do
      begin
        LabelEtat.Caption := 'Exportation de ' + TableUILList[i].Table;
        LabelEtat.Update;

        case i of
          // ARTTYPECOMPTABLE
          1: ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field);
          // ARTTVA
          2: ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field,True);
          3..6: begin // GENMAGCOMPTA ARTTVACOMPTA , ARTCPTACHATVENTE
            Que_LstSociete.First;
            while not Que_LstSociete.Eof do
            begin
                Que_LstMag.Close;
                Que_LstMag.ParamCheck := True;
                Que_LstMag.ParamByName('PSOCID').AsInteger := Que_LstSociete.FieldByName('SOC_ID').AsInteger;
                Que_LstMag.Open;

                while not Que_LstMag.EOF do
                begin
                  case AnsiIndexStr(TableComptaList[i].Table,['GENMAGCOMPTA','ARTTVACOMPTA','ARTCPTACHATVENTE','CSHCOFFRE']) of
                    // GENMAGCOMPTA , CSHCOFFRE
                    0,3: ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field,
                                     [TableComptaList[i].ParentField],
                                     [Que_LstMag.FieldbyName('MAG_ID').AsInteger],
                                     False, TableComptaList[i].ParentField, ListeIdMag);
                    1: begin // ARTTVACOMPTA
                      lstField.Text := TableComptaList[i].ParentField;
                      lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

                      With Que_ARTTVA do
                      begin
                        First;
                        while not Eof do
                        begin
                          ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field,
                                     [lstField[0],lstField[1]],
                                     [FieldByName('TVA_ID').AsInteger, Que_LstMag.FieldbyName('MAG_ID').AsInteger],
                                     False, 'TVC_MAGID', ListeIdMag);
                          Next;
                        end;
                      end;
                    end; // 1
                    2: begin // ARTCPTACHATVENTE
                      lstField.Text := TableComptaList[i].ParentField;
                      lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

                      Que_ARTTVA.First;
                      while not Que_ARTTVA.EOF  do
                      begin
                        With Que_ARTTYPECOMPTABLE do
                        begin
                          First;
                          while not eof do
                          begin
                            ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field,
                                       [lstField[0],lstField[1],lstField[2]],
                                       [Que_ARTTVA.FieldByName('TVA_ID').AsInteger,
                                        FieldbyName('TCT_ID').AsInteger,
                                        Que_LstMag.FieldByName('MAG_ID').AsInteger],
                                        False, 'CVA_MAGID', ListeIdMag);
                            Next;
                          end;
                        end;

                        Que_ARTTVA.Next;
                      end;

                    end; // 2
                  end; // case
                  Que_LstMag.Next;
                end;

              Que_LstSociete.Next;
            end;
          end; // 3..6
          7: begin // CSHBANQUE
            With Que_LstSociete do
            begin
              First;
              while not EOF do
              begin
                ConvertTableToCsv(APathDest, TableComptaList[i].Table, TableComptaList[i].Field,
                                 [TableComptaList[i].ParentField],
                                 [FieldbyName('SOC_ID').AsInteger]);
                Next;
              end;
            end;
          end; // 7
        end;

        Progress.Position := (iTotalInter + i) * 100 Div iTotalProgress;
        Application.ProcessMessages;
      end;
    finally
      lstField.Free;
    end;
    {$ENDREGION}
    iTotalInter := iTotalInter + High(TableComptaList);

    Que_GENGESTIONCARTEFID.Close;
    Que_GENGESTIONCARTEFID.Open;
    {$REGION '5- Fidélité'}
    for i := 1 to High(TableFidList) do
    begin
      LabelEtat.Caption := 'Exportation de ' + TableFidList[i].Table;
      LabelEtat.Update;

      case i of
        1..2: begin
          Que_GENGESTIONCARTEFID.First;
          while not Que_GENGESTIONCARTEFID.Eof do
          begin
            case AnsiIndexStr(TableFidList[i].Table,['CSHPARAMCF','CSHPARAMCFL']) of
              0:  ConvertTableToCsv(APathDest, TableFidList[i].Table, TableFidList[i].Field,
                                 [TableFidList[i].ParentField],
                                 [Que_GENGESTIONCARTEFID.FieldByName('GCF_ID').AsInteger]);
              1: begin
                With Que_CSHPARAMCF do
                begin
                  Close;
                  ParamCheck := True;
                  ParamByName('PGCFID').AsInteger := Que_GENGESTIONCARTEFID.FieldByName('GCF_ID').AsInteger;
                  Open;

                  while not EOF do
                  begin
                    ConvertTableToCsv(APathDest, TableFidList[i].Table, TableFidList[i].Field,
                                 [TableFidList[i].ParentField],
                                 [FieldByName('CTF_ID').AsInteger]);
                    Next;
                  end;
                end;
              end;
            end;

            Que_GENGESTIONCARTEFID.Next;
          end;
        end;
      end;

      Progress.Position := (iTotalInter + i) * 100 Div iTotalProgress;
      Application.ProcessMessages;
    end;
    {$ENDREGION}
    iTotalInter := iTotalInter + High(TableFidList);

    Que_GENBASES.Close;
    Que_GENBASES.Open;

    Que_GENREPLICGRP.Close;
    Que_GENREPLICGRP.Open;

    Que_GENMAGGRP.Close;
    Que_GENMAGGRP.Open;

    Que_GENREPREFER.Close;
    Que_GENREPREFER.Open;
    {$REGION '6- Réplication'}
    lstField := TStringList.Create;
    try
      for i := 1 to High(TableRepliList) do
      begin
        LabelEtat.Caption := 'Exportation de ' + TableUILList[i].Table;
        LabelEtat.Update;

        case i of
          // GENPROVIDERS, GENSUBSCRIBERS, GENLIAIREPLI, GENREPLICGRP, GENMAGGRP, GENREPREFER, GENBASE
          1..7: ConvertTableToCsv(APathDest, TableRepliList[i].Table, TableRepliList[i].Field);
          8: begin // GENLAUNCH
            With Que_GENBASES do
            begin
              First;
              while not EOF do
              begin
                ConvertTableToCsv(APathDest, TableRepliList[i].Table, TableRepliList[i].Field,
                                   [TableRepliList[i].ParentField],
                                   [FieldByName('BAS_ID').AsInteger]);
                Next;
              end;
            end;
          end; // 8
          9..10: begin  // GENREPLICGRPL, GENMAGGRPL

            Que_LstSociete.First;
            while not Que_LstSociete.EOF do
            begin
              lstField.Text := TableRepliList[i].ParentField;
              lstField.Text := StringReplace(lstField.Text,';',#13#10,[rfReplaceAll]);

              Que_LstMag.Close;
              Que_LstMag.ParamCheck := True;
              Que_LstMag.ParamByName('PSOCID').AsInteger := Que_LstSociete.FieldByName('SOC_ID').AsInteger;
              Que_LstMag.Open;

              while not Que_LstMag.EOF do
              begin
                case i of
                  9: begin
                    With Que_GENREPLICGRP do
                    begin
                      First;
                      while not EOF do
                      begin
                        ConvertTableToCsv(APathDest,TableRepliList[i].Table, TableRepliList[i].Field,
                        [lstField[0],lstField[1]],
                        [Que_LstMag.FieldByName('MAG_ID').AsInteger,FieldByName('RGP_ID').AsInteger],
                        False, 'RGL_MAGID', ListeIdMag);
                        Next;
                      end;
                    end;
                  end; // 9
                  10: begin
                    With Que_GENMAGGRP do
                    begin
                      First;
                      while not EOF do
                      begin
                        ConvertTableToCsv(APathDest,TableRepliList[i].Table, TableRepliList[i].Field,
                        [lstField[0],lstField[1]],
                        [Que_LstMag.FieldByName('MAG_ID').AsInteger,FieldByName('MGP_ID').AsInteger],
                        False, 'MGL_MAGID', ListeIdMag);
                        Next;
                      end;
                    end;
                  end; // 10
                end; // case

                Que_LstMag.Next;
              end;

              Que_LstSociete.Next;
            end;
          end; // 9..10
          11..13: begin // GENCHANGELAUNCH, GENCONNEXION, GENREPLICATION
            Que_GENBASES.First;
            while not Que_GENBASES.Eof do
            begin
              With Que_GENLAUNCH do
              begin
                Close;
                ParamCheck := True;
                ParamByName('PBASID').AsInteger := Que_GENBASES.FieldByName('BAS_ID').AsInteger;
                Open;

                while not EOF do
                begin
                  ConvertTableToCsv(APathDest, TableRepliList[i].Table, TableRepliList[i].Field,
                                   [TableRepliList[i].ParentField],
                                   [FieldByName('LAU_ID').AsInteger]);

                  Next;
                end;
              end;
              Que_GENBASES.Next;
            end;
          end; // 11.13
          14: begin // GENREPREFERLIGNE
            With Que_GENREPREFER do
            begin
              First;
              while not EOF do
              begin
                ConvertTableToCsv(APathDest, TableRepliList[i].Table, TableRepliList[i].Field,
                                 [TableRepliList[i].ParentField],
                                 [FieldByName('RRE_ID').AsInteger]);

                Next;
              end;
            end;
          end; // 14
        end; // case

        Progress.Position := (iTotalInter + i) * 100 Div iTotalProgress;
        Application.ProcessMessages;
      end; // for i
    finally
      lstField.Free;
    end;
    {$ENDREGION}

    Memo.lines.Add('-------------------');
    Memo.lines.Add('Fin du traitement');
    Memo.lines.Add('-------------------');

  finally
    InProgress := false;
  end;
end;

function TDM_GEB.ListeMagasins(var slMagasins: TStringList): Boolean;
begin
  Result := False;
  slMagasins.Clear();

  try
    Que_GENMAGASIN.Close();
    Que_GENMAGASIN.Open();

    while not(Que_GENMAGASIN.Eof) do
    begin
      slMagasins.Add(Format('%s - %s=%d',
        [Que_GENMAGASIN.FieldByName('MAG_IDENT').AsString,
          Que_GENMAGASIN.FieldByName('MAG_NOM').AsString,
          Que_GENMAGASIN.FieldByName('MAG_ID').AsInteger]));

      Que_GENMAGASIN.Next();
    end;

    Result := True;
  except
    on E: Exception do
      MessageDlg(Format('%s : %s.', [E.ClassName, E.Message]), mtError, [mbOk], 0);
  end;

end;

end.
