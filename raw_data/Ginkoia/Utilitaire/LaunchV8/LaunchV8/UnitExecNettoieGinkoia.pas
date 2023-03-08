unit UnitExecNettoieGinkoia;

interface

uses
  SysUtils, StrUtils, uLog, LaunchProcess;

function ExecNettoieGinkoia(const nDureeMax: Integer; const sRepertoireDestination, sBasDossier, sBasGuid: string): Boolean;

const
  TIMEOUT = -1;
  DERNIERE_EXECUTION_MEME_JOUR = -2;
  ERREUR_REPERTOIRE_INEXISTANT = -3;
  ERREUR_COMPRESSION_REPERTOIRE = -4;
  ERREUR_SUPPRESSION_REPERTOIRE = -5;
  ERREUR_SUPPRESSION_FICHIER_COMPRESSE = -6;
  ERREUR_NOM_REPERTOIRE_JOUR = -7;
  ERREUR_SUPPRESSION_FICHIER_LOGS = -8;
  ERREUR_SUPPRESSION_FICHIER = -9;
  ERREUR_CREATION_SOUS_REPERTOIRES = -10;
  ERREUR_DEPLACEMENT_FICHIER_COMPRESSE = -11;
  ERREUR_SYSTEME = -99;

implementation

uses
   ShellAPI, Controls, Windows;



function ExecNettoieGinkoia (const nDureeMax: Integer; const sRepertoireDestination, sBasDossier, sBasGuid: string): Boolean;
var
  vExeName: String;
begin
  vExeName := ExtractFilePath(ParamStr(0)) + 'NettoieGinkoia.exe';

  if FileExists(vExeName) then
    ShellExecute(0, 'Open', PWideChar(vExeName), PWideChar('/AUTO' + IfThen(sRepertoireDestination <> '', ' /MV"' + sRepertoireDestination + '"')) , Nil, SW_SHOWDEFAULT);

  Result := True;
end;

//function ExecNettoieGinkoia (const nDureeMax: Integer; const sRepertoireDestination, sBasDossier, sBasGuid: string): Boolean;
//{$REGION 'ExecNettoieGinkoia'}
//
//  function GetLibelleErreur(const nCodeRetour: Integer): string;
//  begin
//    case nCodeRetour of
//      TIMEOUT:
//        Result := 'Time out';
//      DERNIERE_EXECUTION_MEME_JOUR:
//        Result := 'Dernière exécution le même jour';
//      ERREUR_REPERTOIRE_INEXISTANT:
//        Result := 'Erreur répertoire inexistant';
//      ERREUR_COMPRESSION_REPERTOIRE:
//        Result := 'Erreur lors de la compression d''un répertoire';
//      ERREUR_SUPPRESSION_REPERTOIRE:
//        Result := 'Erreur lors de la suppression d''un répertoire';
//      ERREUR_SUPPRESSION_FICHIER_COMPRESSE:
//        Result := 'Erreur lors de la suppression d''un fichier compressé';
//      ERREUR_NOM_REPERTOIRE_JOUR:
//        Result := 'Erreur de nom de répertoire jour';
//      ERREUR_SUPPRESSION_FICHIER_LOGS:
//        Result := 'Erreur lors de la suppression d''un fichier LOGS';
//      ERREUR_SUPPRESSION_FICHIER:
//        Result := 'Erreur lors de la suppression d''un fichier';
//      ERREUR_CREATION_SOUS_REPERTOIRES:
//        Result := 'Erreur lors de la suppression d''un sous-répertoire';
//      ERREUR_DEPLACEMENT_FICHIER_COMPRESSE:
//        Result := 'Erreur lors du déplacement d''un fichier compressé';
//      ERREUR_SYSTEME:
//        Result := 'Erreur lors de l''execution de la commande';
//    else
//      Result := SysErrorMessage(nCodeRetour);
//    end;
//  end;
//
//
//{$ENDREGION}
//
//var
//  nCodeRetour: Integer;
//  sErreur: string;
//begin
//  Result := True;
//  Log.App := 'Launcher';
//  Log.Open;
//
//  if FileExists(ExtractFilePath(ParamStr(0)) + 'NettoieGinkoia.exe') then
//  begin
//    // Exécution de NettoieGinkoia (durée maximum = nDureeMax).
////    nCodeRetour := ExecAndWaitProcessTimeout(sErreur, ExtractFilePath(ParamStr(0)) + 'NettoieGinkoia.exe', '/AUTO' + IfThen(sRepertoireDestination <> '', ' /MV"' + sRepertoireDestination + '"'), nDureeMax);
////    if nCodeRetour = 0 then
////      Log.Log(getMachineName, 'NettoieGinkoia', sBasDossier, sBasGuid, Log.Mag, 'Status', '', logInfo, True, 86400)
////    else
////      Log.Log(getMachineName, 'NettoieGinkoia', sBasDossier, sBasGuid, Log.Mag, 'Status', GetLibelleErreur(nCodeRetour), logError, True, 86400);
////
////    if nCodeRetour = TIMEOUT then
////      Result := False;
//
//     // Exécution de NettoieGinkoia (durée maximum = nDureeMax).
//
//
//    nCodeRetour := ShellExecuteAndWait(ExtractFilePath(ParamStr(0)) + 'NettoieGinkoia.exe', '/AUTO' + IfThen(sRepertoireDestination <> '', ' /MV"' + sRepertoireDestination + '"'), nDureeMax);
//    if nCodeRetour = 0 then
//      Log.Log(getMachineName, 'NettoieGinkoia', sBasDossier, sBasGuid, Log.Mag, 'Status', '', logInfo, True, 86400)
//    else
//      Log.Log(getMachineName, 'NettoieGinkoia', sBasDossier, sBasGuid, Log.Mag, 'Status', GetLibelleErreur(nCodeRetour), logError, True, 86400);
//
//    sErreur := GetLibelleErreur(nCodeRetour);
//
//    if nCodeRetour = 258 then // 258 = code d'erreur du timeout
//      Result := False;
//  end;
//end;

end.

