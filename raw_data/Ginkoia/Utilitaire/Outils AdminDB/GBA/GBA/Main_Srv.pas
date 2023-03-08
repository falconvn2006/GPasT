unit Main_Srv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr,
  //Début Uses Perso
  Constante_CBR,
  ShellAPI,
  Yellis_DM,
  //Fin Uses Perso
  Dialogs;

type

  TTache = class(TThread)
  private
    procedure RappatrierBaseYellis;
  public
    procedure Execute; override;
  end;

  TGBA_Service = class(TService)
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
  private
    { Private declarations }
    Log: TStringList;
    procedure AddLog(aText: string);
    procedure UpdateYellisToEmetteur;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  GBA_Service: TGBA_Service;
  Tache:TTache;

implementation

{$R *.DFM}

const
  Fichier_Log = 'GBA_Srv.Log';

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  GBA_Service.Controller(CtrlCode);
end;

procedure TGBA_Service.AddLog(aText: string);
begin
  try
    Log.Add(DateTimeToStr(Now) + '  ' + aText);
    Log.SaveToFile(vgRepertoire + Fichier_Log);
  except
  end;
end;

function TGBA_Service.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TGBA_Service.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  Tache.Resume;
  Continued := True;
end;

procedure TGBA_Service.ServiceCreate(Sender: TObject);
begin
  vgRepertoire := ExtractFilePath(ParamStr(0));
  Log := TstringList.Create;

  // Init du log
  try
    if FileExists(vgRepertoire + Fichier_Log) then
      Log.LoadFromFile(vgRepertoire + Fichier_Log);
  except on E: exception do
    begin
      AddLog('-----------------------------------------------------------------');
      AddLog('ServiceCreate()         Exception récup du fichier : ' + E.message);
    end;
  end;

  while Log.Count > 500 do // Augmente le nombre d'historique de log
  begin
    Log.Delete(0);
  end;

  AddLog('-----------------------------------------------------------------');
  // Fin Init log
end;

procedure TGBA_Service.ServiceDestroy(Sender: TObject);
begin
  if Log <> nil then
  begin
    AddLog('-----------------------------------------------------------------');
    FreeAndNil(Log);
  end;
end;

procedure TGBA_Service.ServicePause(Sender: TService; var Paused: Boolean);
begin
  Tache.Suspend;
  Paused := True;
end;

procedure TGBA_Service.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Tache := TTache.Create(False);
  Started := True;
end;

procedure TGBA_Service.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Tache.Terminate;
  Stopped := True;
end;


procedure TGBA_Service.UpdateYellisToEmetteur;
//Permet la mise à jour des données de Yellis vers Emetteur (Maintenance)
var
  vNewId      : Integer;
  vSenderName : string;
  vOldIdFOLDER, vNewIdFOLDER   : Integer;
  vOldIdVERSION, vNewIdVERSION : Integer;
begin

//  Result        := 0;
//  vNewId        := 0;
//  vNewIdFOLDER  := 0;
//  vNewIdVERSION := 0;
//
//  vSenderName   := vpCDS.FieldByName('SENDER_NAME').AsString;
//
//  // si on ne trouve pas le nom dans la base yellis, on n'enregistre pas en base.
//  // Par contre, on le note comme étant "Orphelin" pour un contrôle ultérieur
//  if not FYellis_DM.cds_Clients.Locate('nom', vSenderName, [loCaseInsensitive]) then
//  begin
//    vpCDS.Edit;
//    vpCDS.FieldByName('EstOrphelin').AsBoolean := True;
//    vpCDS.Post;
//
//    Exit;
//  end;
//
//  // on stocke les anciennes valeurs de clés étrangères
//  vOldIdFOLDER  := vpCDS.FieldByName('FLD_ID').AsInteger;
//  vOldIdVERSION := FYellis_DM.cds_Clients.FieldByName('version').AsInteger;
//
//  // On recupérè les Id nouvellement crées
//  if FMonitorConsolide_DM.cds_FOLDER.Locate('FLD_ID', vOldIdFOLDER, []) then
//    vNewIdFOLDER := FMonitorConsolide_DM.cds_FOLDER.FieldByName('NewId').AsInteger;
//
//  // On recupérè les Id nouvellement crées
//  if FYellis_DM.cds_Version.Locate('id', vOldIdVERSION, []) then
//    vNewIdVERSION := FYellis_DM.cds_Version.FieldByName('NewId').AsInteger;
//
//  // si la clé étrangère n'existe pas, c'est que l'enregistrement n'a
//  // plus de ligne associée. Il ne faut donc pas l'enregister en base
//  if (vNewIdVERSION = 0) or (vNewIdFOLDER = 0) then
//    Exit;
//
//
//  // Si on trouve les mêmes noms dans ConsoMonitor et Yellis, on copie vers Maintenance
//  with vpQueryDestination do
//  begin
//    SQL.Clear;
//
//    vNewId := GenID('EMETTEUR');
//
//    if vNewId <> 0 then
//    begin
//      SQL.Add(' INSERT INTO EMETTEUR ');
//      SQL.Add(' (EMET_ID, EMET_NOM, EMET_DONNEES, DOS_ID, EMET_INSTALL, EMET_MAGID, ');
//      SQL.Add('  EMET_GUID, VER_ID, EMET_PATCH, EMET_VERSION_MAX, EMET_SPE_PATCH, ');
//      SQL.Add('  EMET_SPE_FAIT, EMET_BCKOK, EMET_DERNBCK, EMET_RESBCK) ');
//      SQL.Add(' VALUES ');
//      SQL.Add(' (:PID, :PNOM, :PDONNEES, :PDOS_ID, :PINSTALL, :PMAGID, ');
//      SQL.Add('  :PGUID, :PVER_ID, :PPATCH, :PVERSION_MAX, :PSPE_PATCH, ');
//      SQL.Add('  :PSPE_FAIT, :PBCKOK, :PDERNBCK, :PRESBCK) ');
//
//      ParamCheck := True;
//      // Champs ConsoMonitor
//      ParamByName('PID').AsInteger          := vNewId;
//      ParamByName('PNOM').AsString          := vSenderName;
//      ParamByName('PDONNEES').AsString      := vpCDS.FieldByName('SENDER_DATA').AsString;
//      ParamByName('PDOS_ID').AsInteger      := vNewIdFOLDER;
//      ParamByName('PINSTALL').AsDateTime    := vpCDS.FieldByName('SENDER_INSTALL').AsDateTime;
//      ParamByName('PMAGID').AsInteger       := vpCDS.FieldByName('SENDER_MAGID').AsInteger;
//
//      // Champs Yellis
//      ParamByName('PGUID').AsString         := FYellis_DM.cds_Clients.FieldByName('clt_guid').AsString;
//      ParamByName('PVER_ID').AsInteger      := vNewIdVERSION;
//      ParamByName('PPATCH').AsInteger       := FYellis_DM.cds_Clients.FieldByName('patch').AsInteger;
//      ParamByName('PVERSION_MAX').AsInteger := FYellis_DM.cds_Clients.FieldByName('version_max').AsInteger;
//      ParamByName('PSPE_PATCH').AsInteger   := FYellis_DM.cds_Clients.FieldByName('spe_patch').AsInteger;
//      ParamByName('PSPE_FAIT').AsInteger    := FYellis_DM.cds_Clients.FieldByName('spe_fait').AsInteger;
//      ParamByName('PBCKOK').AsDateTime      := FYellis_DM.cds_Clients.FieldByName('bckok').AsDateTime;
//      ParamByName('PDERNBCK').AsDateTime    := FYellis_DM.cds_Clients.FieldByName('dernbck').AsDateTime;
//      ParamByName('PRESBCK').AsString       := FYellis_DM.cds_Clients.FieldByName('resbck').AsString;
//
//      // on copie aussi le nouvel Id dans le CDS_clients de la base Yellis
//      FYellis_DM.cds_Clients.Edit;
//      FYellis_DM.cds_Clients.FieldByName('NewId').AsInteger := vNewId;
//      FYellis_DM.cds_Clients.Post;
//
//    end;
//  end;
//
//  Result := vNewId;
end;

{ TTache }

procedure TTache.Execute;
begin
  inherited;
  while not Terminated do
  begin
    //Code à faire à intervalle régulier

    //Rappartriement complet de la base
    RappatrierBaseYellis;






    Sleep(1000);    //Tps d'attente entre les mise à jour
  end;
end;

procedure TTache.RappatrierBaseYellis;
var
  vIdx, vNbRec        : Integer;
  vMaTable            : TTypeMaTable;
  vRepertoire         : String;
  vTimeDeb, vTimeFin  : TTime;

  function ViderDirXML(vpDossier: String): Boolean;
  var
    fos : TSHFileOpStruct;
  begin
    FillChar(fos, SizeOf(fos),0);

    with fos do
    begin
      wFunc  := FO_DELETE;
      pFrom  := PChar(vpDossier + '\*.*' + #0);
      fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
    end;

    result := (0 = ShFileOperation(fos));
  end;

begin
  try
    // on indique le dossier de destination en local pour les fichiers XML

    vRepertoire := vgRepertoire + 'XML';

    // on verifie si le chemin existe
    if DirectoryExists(vRepertoire) then
    begin
      if not ViderDirXML(vgRepertoire) then
      begin
        ShowMessage('Le répertoire : ' + chr(13) +
                     vRepertoire       + chr(13) +
                    'existe déjà. Veuillez recommencer.');
        Exit;
      end;
    end
    else
    begin
      // Si la création a échoué, on arrête le rappatriement
      if not CreateDir(vRepertoire) then
      begin
        ShowMessage('Erreur lors de la création du dossier XML : ' + chr(13) +
                     vRepertoire                                   + chr(13) +
                    'Veuillez recommencer.');
        Exit;
      end;
    end;

    // si le repertoire n'existe pas, on sort
    if vRepertoire = '' then
      Exit;

    vTimeDeb := Time;

    TGBA_Service.Addlog('Début du rappatriement des paquets XML');
    TGBA_Service.AddLog('-> ' + FormatDateTime('DD/MM/YYYY', Now) + ' - ' + TimeToStr(vTimeDeb));

    // on boucle sur toutes les tables du fichier provenant de la base Yellis
    // ATTENTION !!! on ne ramène que les tables et les lignes en fonction du fichier .ini
    for vIdx := 0 to vgObjlTable.Count - 1 do
    begin
      vMaTable := TTypeMaTable(vgObjlTable.Items[vIdx]);
      vNbRec   := 0;

      if vMaTable.TableOrigine = 'YELLIS' then
      begin
        if vMaTable.ATraiter then
        begin
          TGBA_Service.AddLog('');
          TGBA_Service.AddLog('Début d''import de la table : ' + vMaTable.Libelle);

          vNbRec := FYellis_DM.RecuperationXML(vRepertoire, vMaTable);

          TGBA_Service.AddLog('Import de la table ' + vMaTable.Libelle + ' effectué. '
                           + '(' + IntToStr(vNbRec) + ' lignes ramenées)');
        end
        else
        begin
          TGBA_Service.AddLog('');
          TGBA_Service.AddLog('>> Table : ' + vMaTable.Libelle + ' non traitée. <<');
        end;
      end;
    end;

    TGBA_Service.AddLog('');
    TGBA_Service.AddLog('Fin du rappatriement des paquets XML');

    vTimeFin := Time;
    vTimeFin := vTimeFin - vTimeDeb;

    TGBA_Service.AddLog('-> Durée : ' + TimeToStr(vTimeFin));
  finally

  end;
end;

end.
