unit Gin.Srv.DM_Main;

interface

uses System.SysUtils, System.Classes, System.IniFiles, System.Rtti, System.TypInfo,
  IdHashMessageDigest,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Comp.Client, Data.DB,
  Gin.Com.Log ;

type
//==============================================================================
  TGinKAction = (gkaUpdate, gkaDelete, gkaRestore) ;
//------------------------------------------------------------------------------
  TDBParams = record
    Host      : string ;
    Protocol  : string ;
    Database  : string ;
    Username  : string ;
    Password  : string ;
  end;
//------------------------------------------------------------------------------
  TDM_Main = class(TDataModule)
    DSServer: TDSServer;
    DSServerClass_Fidelite: TDSServerClass;
    FDManager: TFDManager;
    procedure DSServerClass_FideliteGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    DBParams : TDBParams ;

    procedure readIni ;
    procedure saveIni ;

    function strLastchar(aStr : string) : Char ;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function getNewConnexion : TFDConnection ;
    function getNewTransaction(aConnection : TFDConnection) : TFDTransaction ;
    function getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction = nil) : TFDQuery ;

    function getNewK(aTable : string ; aConnection : TFDConnection = nil ; aTrans : TFDTransaction = nil) : Int64 ;
    procedure updateK(aId : Int64 ; aAction : TGinKAction ; aConnection : TFDConnection = nil ; aTrans : TFDTransaction = nil) ;

    procedure fillObjectWithQuery(aObject : TObject ; aQuery : TFDQuery ; aTrigram: string) ;

    function MD5(aString : String) : string ;
  end;
//==============================================================================

function DSServer: TDSServer;

var
  DM_Main: TDM_Main ;


implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses Winapi.Windows, Gin.Srv.SM_Fidelite ;

var
  FDSServer: TDSServer;

//==============================================================================
function DSServer: TDSServer;
begin
  Result := FDSServer;
end;
//------------------------------------------------------------------------------
constructor TDM_Main.Create(AOwner: TComponent);
begin
  inherited;

  Log.App  := 'WebVente Fidelite' ;
  Log.Inst := '1' ;
  Log.Open ;

  FDSServer := DSServer ;

  Log.Log('Application', '', 'Log', 'Démarrrage de l''application', logInfo);
end;
//------------------------------------------------------------------------------
procedure TDM_Main.DataModuleCreate(Sender: TObject);
var
  vParams : TStringList ;
begin
  readIni ;

  vParams := TStringList.Create ;
  vParams.Add('DriverID=IB') ;
  vParams.Add('Server=' + DBParams.Host) ;
  vParams.Add('Protocol=' + DBParams.Protocol) ;
  vParams.Add('Database=' + DBParams.Database) ;
  vParams.Add('User_Name=' + DBParams.Username) ;
  vParams.Add('Password=' + DBParams.Password) ;

  FDManager.AddConnectionDef('Ginkoia', 'IB', vParams) ;

  FDManager.Active := true ;
end;

procedure TDM_Main.DataModuleDestroy(Sender: TObject);
begin
  saveIni ;
end;

destructor TDM_Main.Destroy;
begin
  inherited;
  FDSServer := nil;

  Log.Log('Application', '', 'Log', 'Arret de l''application', logInfo);
  Log.Close ;
  Log.saveIni ;
end;
//------------------------------------------------------------------------------
procedure TDM_Main.readIni;
var
  iniFile : TIniFile ;
begin
  Log.Log('Application', '', 'Log', 'Reading configuration file', logInfo);

  iniFile := TIniFile.Create(ChangeFileExt(getApplicationFileName, '.ini')) ;
  DBParams.Host       := iniFile.ReadString('DB', 'Host', 'localhost/3050') ;
  DBParams.Protocol   := iniFile.ReadString('DB', 'Protocol', 'TCP') ;
  DBParams.Database   := iniFile.ReadString('DB', 'Database', 'D:\Bases\13.3\RIHOUET.IB') ;
  DBParams.Username   := iniFile.ReadString('DB', 'Username', 'SYSDBA') ;
  DBParams.Password   := iniFile.ReadString('DB', 'Password', 'masterkey') ;
  iniFile.Free ;
end;
//------------------------------------------------------------------------------
procedure TDM_Main.saveIni;
var
  iniFile : TIniFile ;
begin
  Log.Log('Application', '', 'Log', 'Saving configuration file', logInfo);

  iniFile := TIniFile.Create(ChangeFileExt(getApplicationFileName, '.ini')) ;
  iniFile.WriteString('DB', 'Host', DBParams.Host) ;
  iniFile.WriteString('DB', 'Protocol', DBParams.Protocol) ;
  iniFile.WriteString('DB', 'Database', DBParams.Database) ;
  iniFile.WriteString('DB', 'Username', DBParams.Username) ;
  iniFile.WriteString('DB', 'Password', DBParams.Password) ;
  iniFile.Free ;
end;
//------------------------------------------------------------------------------
function TDM_Main.getNewConnexion: TFDConnection;
begin
  try
    Result := TFDConnection.Create(Self);
    Result.ConnectionDefName := 'Ginkoia' ;
    Result.Connected := true ;
  except
    Log.Log('DM_Main','GetNewConnection','TFDConnection','Creation de connexion impossible', logError);
    raise Exception.Create('Connexion à la base de donnée impossible.') ;
  end;
end;
//------------------------------------------------------------------------------
function TDM_Main.getNewQuery(aConnection : TFDConnection ;  aTrans: TFDTransaction): TFDQuery;
begin
  try
    Result := TFDQuery.Create(Self) ;
    Result.Connection := aConnection ;
    if Assigned(aTrans)
      then Result.Transaction := aTrans ;
  except
    Log.Log('DM_Main','GetNewQuery','TFDQuery','Creation de Query impossible', logError);
    raise ;
  end;
end;
//------------------------------------------------------------------------------
function TDM_Main.getNewTransaction(aConnection : TFDConnection) : TFDTransaction;
begin
  try
  Result := TFDTransaction.Create(Self) ;
  Result.Connection := aConnection ;
  except
    Log.Log('DM_Main','GetNewTransaction','TFDTransaction','Creation de transaction impossible', logError);
    raise ;
  end;
end;
//------------------------------------------------------------------------------
function TDM_Main.getNewK(aTable: string; aConnection : TFDConnection ; aTrans: TFDTransaction): Int64;
var
  vConnection : TFDCOnnection ;
  aQuery : TFDQuery ;
begin
  vConnection := aConnection ;

  if not Assigned(vConnection)
    then vConnection := getNewConnexion ;
  try
    aQuery := getNewQuery(vConnection, aTrans) ;
    try
      try
        aQuery.SQL.Text := 'SELECT ID FROM PR_NEWK(:TABLE)' ;
        aQuery.ParamByName('TABLE').AsString := aTable ;
        aQuery.Open;

        if aQuery.IsEmpty
          then raise Exception.Create('GetNewK : Creation de K impossible');

        Result := aQuery.FieldByName('ID').AsLargeInt ;
      except
        on E:Exception do
        begin
          Log.Log('DM_Main','getNewK', 'aQuery', E.ClassName + ' : ' + E.Message, logError);
          raise ;
        end;
      end;
    finally
      aQuery.Close ;
      aQuery.Free ;
    end;
  finally
    if not Assigned(aConnection)
      then vConnection.Free ;
  end;
end;
//------------------------------------------------------------------------------
procedure TDM_Main.updateK(aId: Int64; aAction: TGinKAction;
  aConnection : TFDConnection ; aTrans: TFDTransaction);
var
  vConnection : TFDCOnnection ;
  aQuery : TFDQuery ;
begin
  vConnection := aConnection ;

  if not Assigned(vConnection)
    then vConnection := getNewConnexion ;

  try
    try
      try
        aQuery := getNewQuery(vConnection, aTrans) ;
        aQuery.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:ID, :ACTION)' ;
        aQuery.ParamByName('ID').AsLargeInt := aId ;
        aQuery.ParamByName('ACTION').AsInteger := Ord(aAction) ;
        aQuery.ExecSQL;
      except
        on E:Exception do
        begin
          Log.Log('DM_Main','UpdateK', 'aQuery', E.ClassName + ' : ' + E.Message, logError);
          raise ;
        end;
      end;
    finally
      aQuery.Free;
    end;
  finally
    if not Assigned(aConnection)
      then vConnection.Free ;
  end;
end;
//------------------------------------------------------------------------------
procedure TDM_Main.fillObjectWithQuery(aObject : TObject ; aQuery : TFDQuery ; aTrigram: string) ;
var
  RTTI : Pointer ;
  PropList  : PPropList ;
  PropInfo  : PPropInfo ;
  nbProp    : integer ;
  ia        : integer ;
  sFieldName : string ;
  vField    : TField ;
const
  tkVars = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkWChar, tkLString, tkWString, tkInt64,tkUString] ;
begin
  if not Assigned(aObject)
    then Exit ;

  RTTI := aObject.ClassInfo ;
  try
    GetMem(PropList, GetTypeData(RTTI)^.PropCount * SizeOf(Pointer)) ;
    nbProp := GetProplist(RTTI, tkVars, PropList) ;
    for ia := 0 to nbProp - 1 do
    begin
      PropInfo := PropList^[ia] ;

      sFieldName := UpperCase(PropInfo^.Name) ;
      if strLastchar(sFieldName) = '_'
        then sFieldName := copy(sFieldName, 1 , Length(sFieldName) - 1 ) ;

      if aTrigram <> '' then
        sFieldName := aTrigram + '_' + sFieldName ;

      vField := aQuery.FindField(sFieldName) ;

      if Assigned(vField) then
      begin
        try
          SetPropValue(aObject, PropInfo^.Name, vField.AsVariant) ;
        except
        end;
      end;
    end;
  finally
    FreeMem(PropList) ;
  end;
end;
//------------------------------------------------------------------------------
function TDM_Main.MD5(aString: String): string;
var
  IdMD5 : TIdHashMessageDigest5;
begin
  IdMD5 := TIdHashMessageDigest5.Create ;
  Result := IdMD5.HashStringAsHex(aString) ;
end;
//------------------------------------------------------------------------------
procedure TDM_Main.DSServerClass_FideliteGetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := Gin.Srv.SM_Fidelite.TSM_Fidelite ;
end;
//------------------------------------------------------------------------------
function TDM_Main.strLastchar(aStr : string) : Char ;
begin
  if aStr = ''
    then Result := #0
    else Result := aStr[Length(aStr)] ;
end;
//==============================================================================

initialization
  DM_Main := TDM_Main.Create(nil);
finalization
  DM_Main.Free;
end.

