unit MonitorStat_Dm;

interface

uses
  SysUtils,
  Classes,
  DB,
  dxmdaset,
  IBCustomDataSet,
  IBQuery,
  IBDatabase;

type
  TDm_MonitorStat = class(TDataModule)
    MemD_GestDossier: TdxMemData;
    MemD_GestDossierClient: TStringField;
    MemD_GestDossierCheminMonitor: TStringField;
    MemD_GestDossierCheminGinkoia: TStringField;
    MemD_ReplicEchec: TdxMemData;
    IBDB_ConnetionStat: TIBDatabase;
    IBT_Stat: TIBTransaction;
    MemD_ReplicEchecLOG_SENDER: TStringField;
    MemD_BilanReplicJournee: TdxMemData;
    MemD_ExportComplet: TdxMemData;
    MemD_Jetons: TdxMemData;
    MemD_BilanReplicJourneeLOG_SENDER: TStringField;
    MemD_BilanReplicJourneeDER_TENTE: TStringField;
    MemD_BilanReplicJourneeDER_OK: TStringField;
    MemD_BilanReplicJourneeLAMOY: TStringField;
    MemD_ReplicEchecLOG_OK: TStringField;
    MemD_ReplicEchecDOSSIER: TStringField;
    MemD_BilanReplicJourneeDOSSIER: TStringField;
    MemD_ExportCompletDOSSIER: TStringField;
    MemD_ExportCompletLOG_DONE: TStringField;
    MemD_ExportCompletLOG_SENDER: TStringField;
    MemD_ExportCompletLOG_PROVIDER: TStringField;
    MemD_ExportCompletCOUNT: TStringField;
    MemD_JetonsDOSSIER: TStringField;
    MemD_JetonsDERNIER_LECTURE: TStringField;
    MemD_JetonsHEURE_JETONS: TStringField;
    MemD_JetonsDERNIER_REFRESH: TStringField;
    MemD_JetonsCheminGinkoia: TStringField;
    MemD_ReplicEchecCheminMonitor: TStringField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Dm_MonitorStat: TDm_MonitorStat;

implementation

{$R *.dfm}

end.

