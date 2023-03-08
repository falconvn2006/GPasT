unit uWMSMagasinFile;

interface

uses
  uFTPFiles, uGestionBDD;

type
  TWMSMagasinFile = class(TCustomFTPSendFile)
  protected
    procedure RefreshFileName; override;

    function getQuery: string; override;
    function getInitQuery: string; override;
  public
  end;

implementation

uses
  uCustomFTPManager;

{ TWMSMagasinFile }

function TWMSMagasinFile.getInitQuery: string;
begin
  Result :=
    'SELECT ' +
    '  MAG_ID, MAG_ENSEIGNE, VIL_NOM, SOC_NOM ' +
    'FROM ' +
    '  GENMAGASIN JOIN k on k_id = mag_id and k_enabled = 1 ' +
    '  JOIN genadresse on adr_id = mag_adrid ' +
    '  JOIN genville on vil_id = adr_vilid ' +
    '  JOIN gensociete on soc_id = mag_socid ' +
    'WHERE MAG_ID <> 0 ' +
    'ORDER BY MAG_ID ';
end;

function TWMSMagasinFile.getQuery: string;
begin
  Result := getInitQuery;
end;

procedure TWMSMagasinFile.RefreshFileName;
begin
  FCurrentFileName := DefaultFileName + '.TXT';
  if FInitMode then
    FCurrentFileName := 'INIT_' + FCurrentFileName;
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_MAGASIN', ftSend, '', '', TWMSMagasinFile);

end.
