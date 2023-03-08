unit uArchivage;

interface

uses
  Windows, SysUtils, Math, Vcl.Dialogs;

Type
  TEspaceDisque = (tedTotal, tedLibre, tedUtilise);
  TUniteOctet = (tuoOctet, tuoKoctet, tuoMoctet, tuoGoctet, tuoToctet);

  Tarchivage = class
  private
    FBasId: integer;
    FError: string;

    property Error: string read FError write FError;
  public
    function EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): integer;
    procedure checkNetworkArchivage();
  end;

implementation

uses
  uNetWorkShare, uMainForm, uLog;

function Tarchivage.EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): integer;
var
  lpFreeBytesAvailableToCaller: TLargeInteger;
  lpTotalNumberOfBytes: TLargeInteger;
  lpTotalNumberOfFreeBytes: TLargeInteger;
  taille: extended;
begin

  if GetDiskFreeSpaceEx(PChar(disque), lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    case espace of
      tedTotal:
        taille := lpTotalNumberOfBytes;
      tedLibre:
        taille := lpTotalNumberOfFreeBytes;
      tedUtilise:
        taille := lpTotalNumberOfBytes - lpTotalNumberOfFreeBytes;
    else
      taille := lpTotalNumberOfBytes;
    end;

    case unite of
      tuoOctet:
        taille := taille;
      tuoKoctet:
        taille := taille / (power(1024, 1));
      tuoMoctet:
        taille := taille / (power(1024, 2));
      tuoGoctet:
        taille := taille / (power(1024, 3));
      tuoToctet:
        taille := taille / (power(1024, 4));
    else
      taille := taille / (power(1024, 2));
    end;
  end;

  result := Floor(RoundTo(taille, -2));
end;

PROCEDURE Tarchivage.checkNetworkArchivage();
var
  network: Tnetwork;
  diskName, pathArchive, networkName: string;
  isShared: Boolean;
BEGIN
  pathArchive := Frm_Launcher.PARAM_60_1.PRMSTRING;
  networkName := Frm_Launcher.PARAM_60_3.PRMSTRING;

  // on regarde si le chemin est partagé, si NON on le partage
  if (pathArchive <> '') AND (networkName <> '') THEN
  BEGIN
    network := Tnetwork.Create;

    TRY
      isShared := network.isFolderShared(pathArchive, networkName);

      if not(isShared) then
      begin
        // on regarde déjà si le disque du chemin existe, sinon on le créé qu'il n'existe pas
        diskName := ExtractFileDrive(pathArchive);
        if (getdrivetype(PChar(diskName)) = 3) then // 3 correspond à un disque fixe
        begin
          // Si le chemin existe, on regarde si le répertoire existe
          if not(DirectoryExists(pathArchive)) then
          begin
            // on le créé s'il n'existe pas
            CreateDir(pathArchive);
          end;

          // on partage le chemin réseau avec le nom choisi
          try
            network.FolderShareDel(networkName);
            network.FolderShareAdd(pathArchive, networkName, 'Partage pour l''archivage GINKOIA');
            log.log('archivageNetwork', Frm_Launcher.BasGUID, 'Archivage', 'Partage du dossier de l''archivage sur le réseau', logTrace, true, 0, ltLocal);
          except
            on E: Exception do
              log.log('archivageNetwork', Frm_Launcher.BasGUID, 'Archivage', 'Echec du partage du dossier de l''archivage sur le réseau : ' + E.Message,
                logTrace, true, 0, ltLocal);
          end;

        end
        else
          log.log('archivageNetwork', Frm_Launcher.BasGUID, 'Archivage', 'Impossible de trouver le chemin du lecteur de l''archivage', logError, true,
            0, ltLocal);
      end;
    FINALLY
      network.Free;
    END;

  END;
END;

end.
