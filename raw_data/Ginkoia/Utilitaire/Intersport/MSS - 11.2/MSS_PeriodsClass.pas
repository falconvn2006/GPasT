unit MSS_PeriodsClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type, Types;


type
  TPeriods = Class(TMainClass)
  Private
  Public
    // fonction qui retourne le EXE_ID
    function GetPeriods(ADate : TDateTime) : Integer; overload;
    function GetPeriods(CodePeriod : String; YearPeriod : Integer) : Integer;overload;

    Function SetPeriods : Integer;

    procedure Import;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;
  published
  End;

implementation

{ TPeriods }

function TPeriods.DoMajTable(ADoMaj : Boolean) : Boolean;
var
  EXE_ID : integer;
  IMP_REFSTR : String;
begin
  Inherited DoMajTable(ADoMaj);

  if not AdoMaj then
    Exit;

  while not FCds.Eof do
  begin
    try
      EXE_ID := SetPeriods;

      Fcds.Edit;
      Fcds.FieldByName('EXE_ID').AsInteger := EXE_ID;
      Fcds.Post;
    Except on E:Exception do
      FErrLogs.Add(Fcds.FieldByName('CodeMarque').AsString + ' ' + FCds.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;
    FCds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;
end;

function TPeriods.GetPeriods(ADate: TDateTime): Integer;
var
  bFound : Boolean;
begin
  try
    Result := -1;
    // recherche de la date de la période
    FCds.First;
    bFound := False;
    while not FCds.Eof and not bFound do
    begin
      {if (CompareDate(ADate,FCDs.FieldByName('Datefrom').AsDateTime) = GreaterThanValue) and
         (CompareDate(ADate,FCds.FieldByName('DateTo').AsDateTime) = LessThanValue) then}
      if (ADate>=FCDs.FieldByName('Datefrom').AsDateTime) and
         (ADate<=FCds.FieldByName('DateTo').AsDateTime) and
         {Limitation à 1 an pour la recherche des périodes}
         (YearsBetween(ADate,FCDs.FieldByName('Datefrom').AsDateTime) < 1) and
         (YearsBetween(ADate,FCDs.FieldByName('DateTo').AsDateTime) < 1)  then
         bFound := True
      else
        FCds.Next;
    end; // while

    if bFound then
    begin
      if FCds.FieldByName('EXE_ID').AsInteger <= 0 then
        Result := SetPeriods
      else
        Result := FCds.FieldByName('EXE_ID').AsInteger;
    end;

  if Result = -1 then
    raise Exception.Create('GetPeriods -> Exercice inéxistant : ' + DateTimeToStr(ADate));

  Except on E:Exception do
    raise Exception.Create('GetPeriods -> ' + E.Message);
  end;
end;

function TPeriods.GetPeriods(CodePeriod: String; YearPeriod: Integer): Integer;
begin
  Result := -1;
  if FCds.Locate('Code;Year',VarArrayOf([CodePeriod,YearPeriod]),[loCaseInsensitive]) then
  begin
    Result := FCds.FieldByName('EXE_ID').AsInteger;

  if Result = -1 then
    Result := SetPeriods;
  end
  else
    raise Exception.Create('GetPeriods -> Periode non trouvée : ' + CodePeriod + ' / ' + IntToStr(YearPeriod));
end;

procedure TPeriods.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  ePeriodeListNode,
  ePeriodNode : IXMLNode;

  Code, Year, Denotation, Datefrom, Dateto, Active,  EXEID : TFieldCFG;
begin
  // Définition du champs du Dataset
  Code.FieldName := 'Code';
  Code.FieldType := ftString;
  Year.FieldName := 'Year';
  Year.FieldType := ftInteger;
  Denotation.FieldName := 'Denotation';
  Denotation.FieldType := ftString;
  Datefrom.FieldName   := 'Datefrom';
  Datefrom.FieldType   := ftDate;
  Dateto.FieldName     := 'Dateto';
  Dateto.FieldType     := ftDate;
  Active.FieldName     := 'Active';
  Active.FieldType     := ftInteger;
  EXEID.FieldName      := 'EXE_ID';
  EXEID.FieldType      := ftInteger;
  // Création des champs
  FFieldNameID := 'EXE_ID';
  CreateField([Code, Year, Denotation, Datefrom, Dateto, Active, EXEID]);
  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      ePeriodeListNode := nXmlBase.ChildNodes.FindNode('Periodlist');
      ePeriodNode := ePeriodeListNode.ChildNodes['Period'];

      while ePeriodNode <> nil do
      begin
//        if XmlStrToInt(ePeriodNode.ChildValues['Active']) = 1 then
//        begin
          FCds.Append;
          FCds.FieldByName('Code').AsString := XmlStrToStr(ePeriodNode.ChildValues['Code']);
          FCds.FieldByName('Year').AsInteger := XmlStrToInt(ePeriodNode.ChildValues['Year']);
          FCds.FieldByName('Denotation').AsString := XmlStrToStr(ePeriodNode.ChildValues['Denotation']);
          FCds.FieldByName('Datefrom').AsDateTime := XmlStrToDate(ePeriodNode.ChildValues['Datefrom']);
          FCds.FieldByName('Dateto').AsDateTime   := XmlStrToDate(ePeriodNode.ChildValues['Dateto']);
          FCds.FieldByName('Active').AsInteger    := XmlStrToInt(ePeriodNode.ChildValues['Active']);
          FCds.FieldByName('EXE_ID').asInteger    := -1;
          Fcds.Post;
//        end;

        ePeriodNode := ePeriodNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
  end;
end;


function TPeriods.SetPeriods: Integer;
var
  IsActive : Integer;
  DateFrom, DateTo : TDateTime;
  Annee : Integer;

begin
  try
    // Vérification que l'exercice n'existe pas encore
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select EXE_ID, EXE_ACTIVE, EXE_DEBUT, EXE_FIN, EXE_ANNEE From GENEXERCICECOMMERCIAL');
      SQL.Add('  join K on K_ID = EXE_ID and K_Enabled = 1');
      SQL.Add('Where Upper(EXE_CODE) = Upper(:PEXECODE)');
      SQL.Add('  and EXE_ANNEE = :PEXEANNEE');
      SQL.Add('  and EXE_CENTRALE = 1');
      ParamCheck := True;
      ParamByName('PEXECODE').AsString := FCds.FieldByName('Code').AsString;
      ParamByName('PEXEANNEE').AsInteger  := FCds.FieldByName('Year').AsInteger;
      Open;

      Result := -1;
      if RecordCount > 0 then
      begin
        Result   := FieldByName('EXE_ID').AsInteger;
        IsActive := FieldByName('EXE_ACTIVE').AsInteger;
        DateFrom := FieldByName('EXE_DEBUT').AsDateTime;
        DateTo   := FieldByName('EXE_FIN').AsDateTime;
        Annee    := FieldByName('EXE_ANNEE').AsInteger;
      end;
    end; // with

    if (Result = -1) then
    begin
      With FIboQuery do
      begin
        Result := GetNewKID('GENEXERCICECOMMERCIAL');
        Close;
        SQL.CLear;
        SQL.add('Insert into GENEXERCICECOMMERCIAL(EXE_ID,EXE_NOM,EXE_DEBUT, EXE_FIN, EXE_ANNEE, EXE_SOCID, EXE_ACTIVE, EXE_CODE, EXE_CENTRALE)');
        SQL.Add('Values(:PEXEID,:PEXENOM,:PEXEDEBUT,:PEXEFIN,:PEXEANNE,0, :PEXEACTIVE, :PEXECODE,1)');
        ParamCheck := True;
        ParamByName('PEXEID').AsInteger := Result;
        ParamByName('PEXENOM').AsString := UpperCase(FCds.FieldByName('Denotation').AsString);
        ParamByName('PEXEDEBUT').AsDate := Fcds.FieldByName('Datefrom').AsDateTime;
        ParamByName('PEXEFIN').AsDate   := FCds.FieldByName('Dateto').AsDateTime;
        ParamByName('PEXEANNE').AsInteger   := Fcds.FieldByName('Year').AsInteger;
        ParamByName('PEXEACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
        ParamByName('PEXECODE').AsString    := FCds.FieldByName('Code').AsString;
        ExecSql;

        Inc(FInsertCount);
      end; // with
    end
    else begin
      // Vérification pour mise à jour si nécessaire
      if ((IsActive <> FCds.FieldByName('Active').AsInteger) OR
          (CompareDate(DateFrom,FCds.FieldByName('DateFrom').AsDateTime) <> EqualsValue) OR
          (CompareDate(DateTo, FCds.FieldByName('DateTo').AsDateTime) <> EqualsValue) OR
          (Annee    <> FCds.FieldByName('Year').AsInteger)) then
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update GENEXERCICECOMMERCIAL set');
          SQL.Add('  EXE_ACTIVE = :PEXEACTIVE,');
          SQL.Add('  EXE_DEBUT  = :PEXEDEBUT,');
          SQL.ADd('  EXE_FIN    = :PEXEFIN,');
          SQL.Add('  EXE_ANNEE  = :PEXEANNEE');
          SQL.Add('Where EXE_ID = :PEXEID');
          ParamCheck := True;
          ParamByName('PEXEACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
          ParamByName('PEXEDEBUT').AsDateTime := FCds.FieldByName('DateFrom').AsDateTime;
          ParamByName('PEXEFIN').AsDateTime   := FCds.FieldByName('DateTo').AsDateTime;
          ParamByName('PEXEANNEE').AsInteger  := FCds.FieldByName('Year').AsInteger;
          ParamByName('PEXEID').AsInteger := Result;
          ExecSQL;

          UpdateKId(Result);

          inc(FMajCount);
        end; // with
    end;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  end;
end;

end.
