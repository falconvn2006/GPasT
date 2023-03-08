unit uWMSRALFile;

interface

uses
  uFTPFiles, uGestionBDD;

type

  TWMSRALFile = class(TCustomFTPSendFile)
  protected
    procedure RefreshFileName; override;

    function getQuery: string; override;
    function getInitQuery: string; override;
  public

  end;

implementation

uses
  uCustomFTPManager;

{ TWMSRALFile }

function TWMSRALFile.getInitQuery: string;
begin
  Result :=
    'SELECT ' +
    '  CBI1.CBI_CB CODE_ARTICLE, ' +
    '  CDL_LIVRAISON DATE_LIVRAISON, ' +
    '  RAL_QTE QUANTITE, ' +
    '  COMBCDE.CDE_NUMERO CDE_NUMERO, ' +
    '  COMBCDE.CDE_MAGID MAG_ID, ' +
    '  MAG_ENSEIGNE MAG_ENSEIGNE ' +
    'FROM ' +
    '  AGRRAL ' +
    '  JOIN COMBCDEL JOIN K KCDL ON (KCDL.K_ID = CDL_ID AND KCDL.K_ENABLED = 1) ON (CDL_ID = RAL_CDLID) ' +
    '  JOIN COMBCDE JOIN K KCDE ON (KCDE.K_ID = CDE_ID AND KCDE.K_ENABLED = 1) ON (CDE_ID = CDL_CDEID) ' +
    '  JOIN GENMAGASIN JOIN K KMAG ON (KMAG.K_ID = MAG_ID AND KMAG.K_ENABLED = 1) ON (MAG_ID = CDE_MAGID) ' +
    '  JOIN ARTREFERENCE ON (ARF_ARTID = CDL_ARTID) ' +
    '  JOIN ARTCODEBARRE CBI1 ON (CBI1.CBI_ARFID = ARF_ID AND CBI1.CBI_TGFID = CDL_TGFID AND CBI1.CBI_COUID = CDL_COUID AND CBI1.CBI_TYPE = 1) ' +
    '  JOIN K KCBI ON (KCBI.K_ID = CBI_ID AND KCBI.K_ENABLED = 1) ';
end;

function TWMSRALFile.getQuery: string;
begin
  Result := getInitQuery;
end;

procedure TWMSRALFile.RefreshFileName;
begin
  FCurrentFileName := DefaultFileName + '.TXT';
  if FInitMode then
    FCurrentFileName := 'INIT_' + FCurrentFileName;
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_RAL', ftSend, '', '', TWMSRALFile);

end.
