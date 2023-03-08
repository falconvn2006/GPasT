unit UBddDossier;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script,
  vcl.forms, System.Classes, System.Generics.Collections,System.SysUtils,
  Datasnap.DBClient, System.StrUtils, System.IOUtils,
  UBdd;

type
  tParamType = (ptNom, ptURL, ptPort, ptUser, ptPassword, ptRepertoire, ptPriorite, ptImpNum);

  TDossierInfo = record
    Nom        : string;
    ID         : integer;
    URL        : string;
    Port       : integer;
    User       : string;
    Password   : string;
    Repertoire : string;
  end;
  TListeDossierInfo = TList<TDossierInfo>;

  TBddDossier = class(TBdd)
    private
      FDossier: integer;
      FRecordCount: integer;
    public
      constructor Create(pCheminBase: string); reintroduce;
      destructor Destroy; reintroduce;
      function SetParamDossier(pID: integer; pParamType: TParamType; pValeur: String): boolean;
      function GetParamDossier(pID: integer; pParamType: TParamType): string;
      procedure GetListDossiers(var ListeDossiersInfo : TListeDossierInfo);
      procedure CreerDossier(pNom: string);
      procedure SupprDossier(pID: integer);
      procedure ClearTable;
      procedure SetEtatData(pEtat: ShortInt);
      procedure InsertLine(pDataLine: TStringList);
      procedure UpdateLine(pDataLine: TStringList);
      function LineExist(pData: TStringList): boolean;
      procedure SetTableByCSV(pCSVName: string);
      procedure LoadData(pDate: TDateTime);
      function LoadValue(pTable: string; pID: string; pIDField: string; pField: string): string;
      procedure RazLinks;
      procedure Next;
      function Field(pName: string): string;
      function FieldInt(pName: string): integer;
      function FieldDate(pName: string): TDateTime;
      function GetIdByLink(pId, pDosId: integer): integer;
      procedure SetIdByLink(pCodeMaitre, pId, pDosId: integer);
      property RecordCount: integer read FRecordCount;
      property Dossier: integer read FDossier write FDossier;
  end;

implementation

{ TGestBdd }

procedure TBddDossier.ClearTable;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  lQuery.SQL.Add('DELETE FROM '+FTable+' WHERE ');
  lQuery.SQL.Add(FTrigramme+'DOSID = '+IntToStr(FDossier));
  try
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

constructor TBddDossier.Create(pCheminBase: string);
begin
  inherited Create(pCheminBase);
end;

procedure TBddDossier.CreerDossier(pNom: string);
var
  lQuery: TFDQuery;
begin
  if pNom <> '' then
  begin
    lQuery := TFDQuery.Create(nil);
    lQuery.Connection := FConnection;
    try
      lQuery.SQL.Add('INSERT INTO DOSSIER (DOS_NOM) VALUES ('+QuotedStr(pNom)+')');
      lQuery.ExecSQL;
    except
    end;
    lQuery.Free;
  end;
end;

destructor TBddDossier.Destroy;
begin
  inherited Destroy;
end;

function TBddDossier.Field(pName: string): string;
begin
  result := FQuery.FieldByName(pName).AsString;
end;

function TBddDossier.FieldDate(pName: string): TDateTime;
begin
  result := FQuery.FieldByName(pName).AsDateTime;
end;

function TBddDossier.FieldInt(pName: string): integer;
begin
  result := FQuery.FieldByName(pName).AsInteger;
end;

function TBddDossier.GetIdByLink(pId, pDosId: integer): integer;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT LNK_MAITREID FROM LIENS WHERE LNK_ID='+IntToStr(pId));
    lQuery.SQL.Add('AND LNK_DOSID='+IntToStr(pDosId));
    lQuery.Open;
    if lQuery.RecordCount > 0 then
      Result := lQuery.FieldByName('LNK_MAITREID').AsInteger
    else
      Result := 0;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.GetListDossiers(var ListeDossiersInfo: TListeDossierInfo);
var
  lQuery: TFDQuery;
  lBclDossier: integer;
  lDossierInfo: TDossierInfo;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  lQuery.SQL.Add('SELECT DOS_ID, DOS_Nom');
  lQuery.SQL.Add('FROM DOSSIER ORDER BY DOS_PRIORITE');
  try

    lQuery.Open;
    lQuery.FetchAll;
    ListeDossiersInfo.Clear;
    for lBclDossier := 0 to lQuery.RecordCount -1 do
    begin
      lDossierInfo.ID  := lQuery.FieldByName('DOS_ID').AsInteger;
      lDossierInfo.Nom := lQuery.FieldByName('DOS_NOM').AsString;
      ListeDossiersInfo.Add(lDossierInfo);
      lQuery.Next;
    end;
  except

  end;
  lQuery.Free;
end;

function TBddDossier.GetParamDossier(pID: integer; pParamType: TParamType): String;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  lQuery.SQL.Add('SELECT * FROM DOSSIER WHERE DOS_ID = '+IntToStr(pID));
  try
    lQuery.Open();
    case pParamType of
      ptNom: Result := lQuery.FieldByName('DOS_NOM').AsString;
      ptURL: Result := lQuery.FieldByName('DOS_URL').AsString;
      ptPort: Result := IntToStr(lQuery.FieldByName('DOS_PORT').AsInteger);
      ptUser: Result := lQuery.FieldByName('DOS_USER').AsString;
      ptPassword: Result := lQuery.FieldByName('DOS_PASSWORD').AsString;
      ptRepertoire: Result := lQuery.FieldByName('DOS_REPERTOIRE').AsString;
      ptPriorite: Result := IntToStr(lQuery.FieldByName('DOS_PRIORITE').AsInteger);
    end;
  except
    result := '';
  end;
  lQuery.Free;
end;

function TBddDossier.LineExist(pData: TStringList): boolean;
var
  lQuery      : TFDQuery;
  lBclFields  : integer;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  lQuery.SQL.Add('SELECT COUNT(*) FROM '+FTable+' WHERE');
  for lBclFields := 0 to FIndexList.Count -1 do
  begin
    if Pos('DOSID',FIndexList.Names[lBclFields]) > 0 then
      lQuery.SQL.Add(FIndexList.Names[lBclFields]+'='+IntToStr(FDossier))
    else
      lQuery.SQL.Add(FIndexList.Names[lBclFields]+'='+FormatData(pData[strtoint(FIndexList.ValueFromIndex[lBclFields])],StrToInt(FFieldList.ValueFromIndex[StrToInt(FIndexList.ValueFromIndex[lBclFields])])));
    if lBclFields < FIndexList.Count -1 then
      lQuery.SQL.Add('AND');
  end;
  lQuery.Open;
  Result := (lQuery.FieldByName('COUNT').AsInteger > 0);
  lQuery.Free;
end;

procedure TBddDossier.LoadData(pDate: TDateTime);
begin
  FRecordCount := 0;
  FQuery.Close;
  FQuery.SQL.Clear;
  if FTable = 'ARTWEB' then
  begin
    FQuery.SQL.Add('SELECT ARTWEB.*, MRQ_NOM, MRQ_CODE, GRE_NOM, N1.NKL_LIB SSF, N2.NKL_LIB FAM, N3.NKL_LIB RAY, PRX_PXVTE, PRX_PUMP,');
    FQuery.SQL.Add('PRX_PXVTEN, TGF_NOMTYPE, TGF_NOMGRILLE, TGF_CODETAILLE, TGF_CODEGRILLE, DLW_LIBELLE, GCS_NOM');
    FQuery.SQL.Add('FROM ARTWEB');
    FQuery.SQL.Add('JOIN MARQUE ON ARW_MRQID = MRQ_ID AND ARW_DOSID = MRQ_DOSID');
    FQuery.SQL.Add('LEFT JOIN COULEURSTAT ON ARW_GCSID = GCS_ID AND ARW_DOSID = GCS_DOSID');
    FQuery.SQL.Add('JOIN TAILLES ON ARW_TGFID = TGF_ID AND ARW_DOSID = TGF_DOSID');
    FQuery.SQL.Add('LEFT JOIN GENRE ON ARW_GREID = GRE_ID AND ARW_DOSID = GRE_DOSID');
    FQuery.SQL.Add('JOIN PRIX ON ARW_ID = PRX_ARWID AND ARW_DOSID = PRX_DOSID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N1 on ARW_NKLID = N1.NKL_ID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N2 on N1.NKL_IDPARENT=N2.NKL_ID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N3 on N2.NKL_IDPARENT=N3.NKL_ID');
    FQuery.SQL.Add('LEFT JOIN ARTDELAISWEB on ARW_DLWID=DLW_ID AND ARW_DOSID = DLW_DOSID');
    FQuery.SQL.Add('WHERE ARW_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
    FQuery.SQL.Add('OR PRX_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
  end
  else if FTable = 'CBFOURN' then
  begin
    FQuery.SQL.Add('SELECT CBF_CBFOURN, CBF_ETATDATA, ARW_CODEEAN, CBF_DOSID, CBF_CBPRINCIPAL ');
    FQuery.SQL.Add('FROM CBFOURN');
    FQuery.SQL.Add('JOIN ARTWEB ON ARW_ID = CBF_ARWID AND CBF_DOSID = ARW_DOSID');
    FQuery.SQL.Add('WHERE CBF_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
  end
  else if FTable = 'ARTNOMENK' then
  begin
    FQuery.SQL.Add('SELECT ARW_CODEEAN, N1.NKL_LIB SSF, N2.NKL_LIB FAM, N3.NKL_LIB RAY, ANK_ETATDATA');
    FQuery.SQL.Add('FROM ARTNOMENK');
    FQuery.SQL.Add('JOIN ARTWEB ON ARW_MODID = ANK_MODID AND ANK_DOSID = ARW_DOSID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N1 on ANK_NKLID = N1.NKL_ID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N2 on N1.NKL_IDPARENT=N2.NKL_ID');
    FQuery.SQL.Add('JOIN NOMENCLATURE N3 on N2.NKL_IDPARENT=N3.NKL_ID');
    FQuery.SQL.Add('WHERE ANK_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
  end
  else if FTable = 'OC' then
  begin
    FQuery.SQL.Add('SELECT *');
    FQuery.SQL.Add('FROM OC');
    FQuery.SQL.Add('WHERE OCM_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
  end
  else if FTable = 'TRANSPORTEURS' then
  begin
    FQuery.SQL.Add('SELECT *');
    FQuery.SQL.Add('FROM TRANSPORTEURS');
    FQuery.SQL.Add('WHERE TRA_DATEUPDATE > '+FormatData(DateTimeToStr(pDate),35));
  end;
  FQuery.Open;
  FQuery.FetchAll;
  FRecordCount := FQuery.RecordCount;
end;

function TBddDossier.LoadValue(pTable: string; pID: string; pIDField: string; pField: string): string;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FConnection;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT '+pField+' FROM '+pTable+' WHERE '+pIDField+'='+FormatData(pID,37));
    lQuery.Open;
    Result := lQuery.FieldByName(pField).AsString;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.Next;
begin
  FQuery.Next;
end;

procedure TBddDossier.RazLinks;
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FConnection;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('DELETE FROM LIENS');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.InsertLine(pDataLine: TStringList);
var
  lBclFields  : integer;
  lQuery      : TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('INSERT INTO '+FTable+' (');
    //on ajoute les champs
    for lBclFields := 0 to FFieldList.Count -1 do
    begin
      lQuery.SQL.Add(FFieldList.Names[lBclFields]);
      if lBclFields <> FFieldList.Count - 1 then
        lQuery.SQL.Add(',');
    end;
    lQuery.SQL.Add(') VALUES (');
    //on ajout les données
    for lBclFields := 0 to pDataLine.Count -1 do
    begin
      lQuery.SQL.Add(FormatData(pDataLine[lBclFields],strtoint(FFieldList.ValueFromIndex[lBclFields]))+',');
    end;
    // date insert = date update, date delete = 0
    lQuery.SQL.Add(IntToStr(FDossier)+','+FormatData(DateTimeToStr(now),35)+','+FormatData(DateTimeToStr(now),35)+','+FormatData(DateTimeToStr(0),35)+');');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.UpdateLine(pDataLine: TStringList);
var
  lBclFields  : integer;
  lQuery      : TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('UPDATE '+FTable+' SET ');
    for lBclFields := 0 to pDataLine.Count -1 do
    begin
      //si c'est un index on ne met pas à jour
      if FIndexList.IndexOfName(FFieldList.Names[lBclFields]) <> -1  then
        continue;
      lQuery.SQL.Add(FFieldList.Names[lBclFields]+'='+FormatData(pDataLine[lBclFields],StrToInt(FFieldList.ValueFromIndex[lBclFields]))+', ');
    end;
    lQuery.SQL.Add(FTrigramme+'DATEUPDATE='+FormatData(DateTimeToStr(Now),35)+' WHERE ');
    //on parcours les index pour le where
    for lBclFields := 0 to FIndexList.Count -1 do
    begin
      if Pos('DOSID',FIndexList.Names[lBclFields]) > 0 then
        lQuery.SQL.Add(FIndexList.Names[lBclFields]+'='+IntToStr(FDossier))
      else
        lQuery.SQL.Add(FIndexList.Names[lBclFields]+'='+FormatData(pDataLine[strtoint(FIndexList.ValueFromIndex[lBclFields])],
                                                                      StrToInt(FFieldList.ValueFromIndex[lBclFields])));
      if lBclFields < FIndexList.Count -1 then
        lQuery.SQL.Add(' AND ');
    end;
    lQuery.SQL.Add(';');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.SetEtatData(pEtat: ShortInt);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  lQuery.SQL.Add('UPDATE '+FTable+' SET ');
  lQuery.SQL.Add(FTrigramme+'ETATDATA = '+IntToStr(pEtat)+',');
  lQuery.SQL.Add(FTrigramme+'DATEUPDATE = '+FormatData(DateTimeToStr(Now),35));
  lQuery.SQL.Add('WHERE '+FTrigramme+'ETATDATA = 1 AND ');
  lQuery.SQL.Add(FTrigramme+'DOSID = '+IntToStr(FDossier));
  try
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddDossier.SetIdByLink(pCodeMaitre, pId, pDosId: integer);
var
  lQuery: TFDQuery;
  lCodeMaitre: integer;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  if (pCodeMaitre > 0) and (pId > 0) then
  begin
    try
      lCodeMaitre := GetIdByLink(pId,pDosId);
      if (lCodeMaitre <> 0) and (lCodeMaitre <> pCodeMaitre) then
      begin
        lQuery.SQL.Clear;
        lQuery.SQL.Add('UPDATE LIENS SET LNK_MAITREID='+IntToStr(pCodeMaitre));
        lQuery.SQL.Add('WHERE LNK_ID='+IntToStr(pId)+' AND LNK_DOSID='+IntToStr(pDosId));
        lQuery.ExecSQL;
      end
      else if lCodeMaitre = 0 then
      begin
        lQuery.SQL.Clear;
        lQuery.SQL.Add('INSERT INTO LIENS (LNK_MAITREID,LNK_ID,LNK_DOSID)');
        lQuery.SQL.Add('VALUES ('+IntToStr(pCodeMaitre)+','+IntToStr(pId)+','+IntToStr(pDosId)+')');
        lQuery.ExecSQL;
      end;
    finally
      lQuery.Free;
    end;
  end;
end;

function TBddDossier.SetParamDossier(pID: integer; pParamType: TParamType;
  pValeur: String): boolean;
var
  lQuery: TFDQuery;
  lKey: string;
begin
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FConnection;
    case pParamType of
      ptNom: lKey := 'DOS_NOM';
      ptURL: lKey := 'DOS_URL';
      ptPort: lKey := 'DOS_PORT';
      ptUser: lKey := 'DOS_USER';
      ptPassword: lKey := 'DOS_PASSWORD';
      ptRepertoire: lKey := 'DOS_REPERTOIRE';
      ptPriorite: lKey := 'DOS_PRIORITE';
    end;
    lQuery.SQL.Add(Format('UPDATE DOSSIER SET %s = ''%s''', [ lKey, pValeur ] ));
    lQuery.SQL.Add(Format('WHERE DOS_ID = %d',[pID]));
    lQuery.ExecSQL;
    Result := true;
  except
    Result := false;
  end;
  lQuery.Free;
end;

procedure TBddDossier.SetTableByCSV(pCSVName: string);
var
  lNom: string;
begin
  lNom := TPath.GetFileNameWithoutExtension(pCSVName);
  //on supprime le 'INIT_'
  if LeftStr(lNom,5) = 'INIT_' then
    lNom := RightStr(lNom,Length(lNom)-5);
  // on supprime la date si elle est présente
  if Pos('-',lNom) > 0 then
    lNom := LeftStr(lNom,Pos('-',lNom)-1);
  //on supprimer la version du fichier (_x) et les '_'
  if LeftStr(RightStr(lNom,2),1) = '_' then
    lNom := LeftStr(lNom,Length(lNom)-2);
  lNom := StringReplace(lNom,'_','',[rfReplaceAll,rfIgnoreCase]);
  Table := lNom;
end;

procedure TBddDossier.SupprDossier(pID: integer);
var
  lQuery: TFDQuery;
begin
      lQuery := TFDQuery.Create(nil);
  try
    try
      lQuery.Connection := FConnection;
      lQuery.SQL.Add('DELETE FROM DOSSIER WHERE DOS_ID = '+IntToStr(pID));
      lQuery.ExecSQL;
    except
    end;
  finally
    lQuery.Free;
  end;

end;

end.
