unit uWMSSuiviFile;

interface

uses
  uFTPFiles, uLog;

type
  TSuiviFileData = Record
    BLEID: integer;
    CBPNum: String;
    TRAId: integer;
    ColisNumber: integer;
  end;

  TSuiviFileDataArray = Array of TSuiviFileData;

  TWMSSuiviFile = class(TCustomFTPGetFile)
  private
    FDatas: TSuiviFileDataArray;

    function FindBLE(ABleWebId: string): integer;
    function FindTRA(ATraCode: integer): integer;
  protected
    function DoRead: TLogLevel; override;
    procedure DoUpdateBDD; override;

    function GetQueryText: string; override;
    function CheckFileEntete: boolean; override;
  public
  end;

implementation

uses
  SysUtils, uCustomFTPManager, uGenerique, classes, uGestionBDD, uFTPUtils,
  uMonitoring, uTableNegColisUtils;

{ TWMSSuiviFile }

procedure TWMSSuiviFile.DoUpdateBDD;
var
  i: integer;
  bprid: integer;
begin
  try
    for i := 0 to Length(FDatas) - 1 do
    begin
      if FDatas[i].BLEID <> -1 then
      begin
        try
          FTableNegColisUtils.FinishColis(FDatas[i].BLEID, FDatas[i].CBPNum,
            FDatas[i].ColisNumber, FDatas[i].TRAId);
        except
          On E: Exception do
          begin
            AddLog(Format('Ligne %d : Erreur lors du traitement du BLE_ID "%d"',
              [i, FDatas[i].BLEID]), ftpllError);
            AddLog(E.Message, ftpllError);

            Raise TMonitoringException.Create(
              Format('Ligne %d : Erreur lors du traitement du BLE_ID "%d"',
              [i, FDatas[i].BLEID]), logError, apptWMS, mdltImport);
          end;
        end;
      end;
    end;
  finally
    GetQuery.Close;
  end;
end;

function TWMSSuiviFile.DoRead: TLogLevel;
var
  i, index: integer;
  values: TStringList;
begin
  Result := logNone;
  SetLength(FDatas, 0);
  for i := 0 to FStringList.Count - 1 do
  begin
    try
      values := getFileLineValues(FStringList[i]);

      if not FTableNegColisUtils.CBPNumExist(values[1]) then
      begin
        index := Length(FDatas);
        SetLength(FDatas, index + 1);
        FDatas[index].BLEID := FindBLE(values[0]);
        FDatas[index].CBPNum := values[1];
        FDatas[index].TRAID := FindTRA( StrToIntDef(values[2], -1) );
        FDatas[index].ColisNumber := StrToIntDef(values[3], 0);
      end
      else
      begin
        AddLog(Format('Le numéro de colis (CBP_NUM "%s") existe déjà dans la table NEGCOLIS (%s)',
          [values[1], FileName]), ftpllError);

        Raise TMonitoringException.Create(Format('Le numéro de colis (CBP_NUM "%s") existe déjà dans la table NEGCOLIS (%s)',
          [values[1], FileName]), logError, apptWMS, mdltImport);
      end;
    except
      on E: TMonitoringException do
      begin
        Result := E.LogLevel;
      end;
    end;
  end;
end;

function TWMSSuiviFile.FindBLE(ABleWebId: string): integer;
var
  iBleId: integer;
begin
  try
    iBleId := StrToIntDef(ABleWebId, -1);
    Result := FTableNegColisUtils.FindBLE(iBleId);

    if Result = -1 then
    begin
      AddLog(Format('Impossible de trouver le Bon de livraison (BLE_IDWEB "%s") dans la table NEGBL (%s)',
        [ABleWebId, FileName]), ftpllError);

      Raise TMonitoringException.Create(Format('Impossible de trouver le Bon de livraison (BLE_ID "%s") dans la table NEGBL (%s)',
        [ABleWebId, FileName]), logError, apptWMS, mdltImport);
    end;
  finally
  end;
end;

function TWMSSuiviFile.FindTRA(ATraCode: integer): integer;
begin
  try
    Result := FTableNegColisUtils.FindTRA(ATraCode);

    if Result = -1 then
    begin
      Result := -1;
      AddLog(Format('Impossible de trouver le Transporteur (TRA_CODE "%d") dans la table NEGTRANSPORT (%s)',
        [ATraCode, FileName]), ftpllError);

      Raise TMonitoringException.Create(Format('Impossible de trouver le Transporteur (TRA_CODE "%d") dans la table NEGTRANSPORT (%s)',
        [ATraCode, FileName]), logWarning, apptWMS, mdltImport);
    End;
  finally
  end;
end;

function TWMSSuiviFile.CheckFileEntete: boolean;
//var
//  values: TStringList;
begin
  // On ne controle pas les entête du fichier SUIVI
  Result := True;
//  values := getFileLineValues(FStringList[0]);
//  Result := (values.Count = 4) and (values[0] = 'BLE_IDWEB') and (values[1] = 'CBP_NUM')
//    and (values[2] = 'TRA_CODE') and (values[3] = 'NUMEROCOLIS');
end;

function TWMSSuiviFile.GetQueryText: string;
begin
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_SUIVI', ftGet, '', '', TWMSSuiviFile);

end.
