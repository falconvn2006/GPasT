unit uWMSPrixFile;

interface

uses
  uFTPFiles, uGestionBDD;

type

  TWMSPrixFile = class(TCustomFTPSendFile)
  protected
    procedure LoadQueryParams(AQuery: TMyQuery); override;

    function getQuery: string; override;
    function getInitQuery: string; override;
  public

  end;

implementation

uses
  uCustomFTPManager, UCommon_Dm;

function TWMSPrixFile.getInitQuery: string;
begin
  Result :=
    'SELECT ' +
    '  CODE_EAN, ' +
    '  PXVTE, ' +
    '  PXVTE_N, ' +
    '  PXDESTOCK, ' +
    '  PUMP, ' +
    '  ETAT_DATA ' +
    'FROM WMS_PRIX(:MAGID, :INIT_MODE, :LAST_VERSION, :CURRENT_VERSION, ' +
    '  :LAST_VERSION_LAME, :CURRENT_VERSION_LAME, :DEBUT_PLAGE_BASE, ' +
    '  :FIN_PLAGE_BASE)';
end;

function TWMSPrixFile.getQuery: string;
begin
  Result := getInitQuery;
end;

procedure TWMSPrixFile.LoadQueryParams(AQuery: TMyQuery);
begin
  AQuery.Params.ParamByName('INIT_MODE').AsInteger := Integer(FInitMode);

  if FInitMode then
  begin
    if Assigned(AQuery.Params.FindParam('LAST_VERSION')) then
      AQuery.Params.ParamByName('LAST_VERSION').AsLargeInt := Dm_Common.PlageLame.Debut;
    if Assigned(AQuery.Params.FindParam('LAST_VERSION_LAME')) then
      AQuery.Params.ParamByName('LAST_VERSION_LAME').AsLargeInt := Dm_Common.PlageLame.Fin;
  end
  else
  begin
    if Assigned(AQuery.Params.FindParam('LAST_VERSION')) then
      AQuery.Params.ParamByName('LAST_VERSION').AsLargeInt := getTableVersion;
    if Assigned(AQuery.Params.FindParam('LAST_VERSION_LAME')) then
      AQuery.Params.ParamByName('LAST_VERSION_LAME').AsLargeInt := getLameVersion;
  end;

  if Assigned(AQuery.Params.FindParam('CURRENT_VERSION')) then
    AQuery.Params.ParamByName('CURRENT_VERSION').AsLargeInt := FCurrentVersionBase;
  if Assigned(AQuery.Params.FindParam('CURRENT_VERSION_LAME')) then
    AQuery.Params.ParamByName('CURRENT_VERSION_LAME').AsLargeInt := FCurrentVersionLame;

  if Assigned(AQuery.Params.FindParam('DEBUT_PLAGE_BASE')) then
    AQuery.Params.ParamByName('DEBUT_PLAGE_BASE').AsLargeInt := Dm_Common.PlageLame.Debut;
  if Assigned(AQuery.Params.FindParam('FIN_PLAGE_BASE')) then
    AQuery.Params.ParamByName('FIN_PLAGE_BASE').AsLargeInt := Dm_Common.PlageLame.Fin;

  AQuery.Params.ParamByName('MAGID').AsInteger := FMagId;
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_PRIX', ftSend, '', '', TWMSPrixFile);

end.
