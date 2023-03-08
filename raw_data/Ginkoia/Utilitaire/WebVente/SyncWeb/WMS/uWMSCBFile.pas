unit uWMSCBFile;

interface

uses
  uFTPFiles, uGestionBDD;

type

  TWMSCBFile = class(TCustomFTPSendFile)
  protected
    procedure LoadQueryParams(AQuery: TMyQuery); override;

    function getQuery: string; override;
    function getInitQuery: string; override;
  public

  end;

implementation

uses
  uCustomFTPManager, uCommon_dm;

{ TWMSCBFile }

function TWMSCBFile.getInitQuery: string;
begin
  Result :=
    'SELECT ' +
    '  F_LEFT(CBEAN.CBI_CB, 30), ' +
    '  F_LEFT(CBITYPE3.CBI_CB, 30), ' +
    '  CBITYPE3.CBI_PRIN, ' +
    '  KCB3.K_ENABLED AS ETAT_DATA ' +
    'FROM ' +
    '  ARTARTICLE JOIN K KART ON KART.K_ID = ARTARTICLE.ART_ID AND KART.K_ENABLED = 1 ' +
    '  JOIN ARTREFERENCE ON ARF_ARTID = ART_ID AND ARF_ARCHIVER = 0 ' +
    '  JOIN ARTCODEBARRE CBEAN ON CBEAN.CBI_ARFID = ARF_ID and CBEAN.CBI_TYPE = 1 ' +
    '    JOIN K KCBEAN ON KCBEAN.K_ID = CBEAN.CBI_ID AND KCBEAN.K_ENABLED = 1 ' +
    '  JOIN ARTCODEBARRE CBITYPE3 ON CBITYPE3.CBI_ARFID = CBEAN.CBI_ARFID ' +
    '    AND CBITYPE3.CBI_TGFID = CBEAN.CBI_TGFID ' +
    '    AND CBITYPE3.CBI_COUID = CBEAN.CBI_COUID ' +
    '    AND CBITYPE3.CBI_TYPE = 3 ' +
    '    JOIN K KCB3 ON KCB3.K_ID = CBITYPE3.CBI_ID AND KCB3.K_ENABLED = 1 ' +
    'WHERE ' +
    '  ARF_ARCHIVER = 0 ' +
    'ORDER BY CBEAN.CBI_CB, CBITYPE3.CBI_PRIN ';
end;

function TWMSCBFile.getQuery: string;
begin
  Result :=
    'SELECT ' +
    '  F_LEFT(CBEAN.CBI_CB, 30), ' +
    '  F_LEFT(CBITYPE3.CBI_CB, 30), ' +
    '  CBITYPE3.CBI_PRIN, ' +
    '  KCB3.K_ENABLED AS ETAT_DATA ' +
    'FROM ' +
    '  ARTARTICLE JOIN K KART ON KART.K_ID = ARTARTICLE.ART_ID AND KART.K_ENABLED = 1 ' +
    '  JOIN ARTREFERENCE ON ARF_ARTID = ART_ID AND ARF_ARCHIVER = 0 ' +
    '  JOIN ARTCODEBARRE CBEAN ON CBEAN.CBI_ARFID = ARF_ID and CBEAN.CBI_TYPE = 1 ' +
    '    JOIN K KCBEAN ON KCBEAN.K_ID = CBEAN.CBI_ID AND KCBEAN.K_ENABLED = 1 ' +
    '  JOIN ARTCODEBARRE CBITYPE3 ON CBITYPE3.CBI_ARFID = CBEAN.CBI_ARFID ' +
    '    AND CBITYPE3.CBI_TGFID = CBEAN.CBI_TGFID ' +
    '    AND CBITYPE3.CBI_COUID = CBEAN.CBI_COUID ' +
    '    AND CBITYPE3.CBI_TYPE = 3 ' +
    '    JOIN K KCB3 ON KCB3.K_ID = CBITYPE3.CBI_ID ' +
    'WHERE ' +
    '  ARF_ARCHIVER = 0 ' +
    '  AND (KCB3.KRH_ID > :LAST_VERSION AND KCB3.KRH_ID <= :CURRENT_VERSION) ' +
    '    OR (KCB3.K_VERSION > :LAST_VERSION_LAME AND KCB3.K_VERSION <= :CURRENT_VERSION_LAME ' +
    '    AND NOT(KCB3.KRH_ID > :DEBUT_PLAGE_BASE AND KCB3.KRH_ID <= :FIN_PLAGE_BASE)) ' +
    'ORDER BY CBEAN.CBI_CB, CBITYPE3.CBI_PRIN ';
end;

procedure TWMSCBFile.LoadQueryParams(AQuery: TMyQuery);
begin
  inherited LoadQueryParams(AQuery);
end;

initialization

  TCustomFTPManager.RegisterKnownFile('WMS_CB', ftSend, '', '', TWMSCBFile);

end.
