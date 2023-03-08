unit MSS_DMDbMag;

interface

uses
  SysUtils, Classes, IB_Components, IBODataset, IB_Access, DB, Dialogs, ComCtrls, Forms,
  DBClient, Provider, MSS_Type, ShellApi, windows, Mss_CFGParams, Controls,
  IBServices;

type
  TDM_DbMAG = class(TDataModule)
    IboDbMag: TIBODatabase;
    IBOTransDbM: TIBOTransaction;
    Que_DOSSIERS: TIBOQuery;
    Que_DbMTmp: TIBOQuery;
    IBServerProperties: TIBServerProperties;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Function ConnectToDbMag(APath : String) : Boolean;

    function GetDbMagParam_Data(APRM_TYPE : Integer) : String;
    function SetDbMagParam_Data(APRM_TYPE : Integer;APRM_DATA : String) : Boolean;

    function ShowModalCFG: Integer;

    Procedure WaitService;

  end;

var
  DM_DbMAG: TDM_DbMAG;

implementation

{$R *.dfm}

{ TDM_DbMAG }

function TDM_DbMAG.ConnectToDbMag(APath: String): Boolean;
begin
  Result := False;

//  WaitService;

  if Trim(APath) = '' then
  begin
    raise Exception.Create( 'Veuillez configurer la base de données de configuration' );
    if ShowModalCFG = mrOk then
    begin
      Result := ConnectToDbMag(IniStruct.Database);
    end;
    Exit;
  end;

  With IboDbMag do
  begin
    // Disconnect;
    Try
      If not(Connected)
        then
          begin
              DatabaseName := APath;
              Connect;
          end;
      Result := Connected;

      Que_DOSSIERS.Close;
      Que_DOSSIERS.Open;
    Except on E:Exception do
      raise Exception.Create( 'Erreur de connexion à la base de données Dossiers :' + E.Message );
    End;
  end;
end;

function TDM_DbMAG.GetDbMagParam_Data(APRM_TYPE: Integer): String;
begin
  With Que_DbMTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select PRM_DATA from PARAMS');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('PRM_DATA').AsString
    else
      raise Exception.Create(Format('Paramètre inéxistant %d',[APRM_TYPE]));
  end;
end;

function TDM_DbMAG.SetDbMagParam_Data(APRM_TYPE: Integer;
  APRM_DATA: String): Boolean;
begin
  Result := False;
  With Que_DbMTmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('UPDATE PARAMS Set');
    SQL.Add('  PRM_DATA = :PPRMDATA');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    ParamCheck := True;
    ParamByName('PPRMDATA').AsString := APRM_DATA;
    ParamByName('PPRMTYPE').AsInteger := APRM_TYPE;
    ExecSQL;

    Result := True;
  Except on E:Exception do
    raise Exception.Create(Format('Enregistrement paramètre %d : %s',[APRM_TYPE, E.Message]));
  end;
end;

function TDM_DbMAG.ShowModalCFG: Integer;
begin
  With Tfrm_CFGParams.Create(nil) do
  try
    BorderStyle := bsSingle;
    Parent := nil;
    Result := ShowModal;
  finally
    Release;
  end;
end;

procedure TDM_DbMAG.WaitService;
var
  bConnexion : Boolean;
begin
  bConnexion := False;
  With IBServerProperties do
    while not bConnexion do
    begin
      try
        Active := True;
        bConnexion := True;
      except on E: Exception do
        begin
          Sleep(5000);
        end;
      end;
    end;
end;

end.
