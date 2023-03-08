unit Maintenance_DM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IB_Components, DB, IBODataset, IB_Access, DBClient, Constante_CBR,
  Main_Frm;

type
  TFMaintenance_DM = class(TForm)
    IbC_Maintenance: TIB_Connection;
    Que_Emetteur: TIBOQuery;
    IbT_Select: TIB_Transaction;
    IbT_Maj: TIB_Transaction;
    stp_NewId: TIBOStoredProc;
    que_Maj: TIB_Cursor;
    Que_Fichiers: TIBOQuery;
    Que_Version: TIBOQuery;
    Que_Histo: TIBOQuery;
    Que_PlageMAJ: TIBOQuery;
    Que_Specifique: TIBOQuery;
    Que_HDB: TIBOQuery;
    Que_SRV: TIBOQuery;
    Que_GRP: TIBOQuery;
    Que_Dossier: TIBOQuery;
    Que_Raison: TIBOQuery;
    QryGen: TIBOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
    procedure RafraichirBaseMaintenance;
    procedure ViderBaseMaintenance;

    function GetNewQry(Const AOwner: TComponent = nil): TIBOQuery;
  end;

var
  FMaintenance_DM: TFMaintenance_DM;

implementation

uses CopierTable;

{$R *.dfm}

procedure TFMaintenance_DM.FormCreate(Sender: TObject);
begin
  if FileExists(FMain.PathMaintenanceBDD) then
  begin
    IbC_Maintenance.DatabaseName  := FMain.PathMaintenanceBDD;
    IbC_Maintenance.Connect;
  end;
  //Que_Emetteur.Open;
end;

function TFMaintenance_DM.GetNewQry(const AOwner: TComponent): TIBOQuery;
begin
  Result:= TIBOQuery.Create(AOwner);
  Result.IB_Connection:= IbC_Maintenance;
  Result.IB_Transaction:= IbC_Maintenance.DefaultTransaction;
end;

procedure TFMaintenance_DM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CaFree;
end;

//------------------------------------------------------------------------------
//                                                             +---------------+
//                                                             |     ACTION    |
//                                                             +---------------+
//------------------------------------------------------------------------------

//-----------------------------------------------> RafraichirBaseMaintenance

procedure TFMaintenance_DM.RafraichirBaseMaintenance;
begin
  if not IbC_Maintenance.Connected then
    Exit;

  Que_GRP.Close;
  Que_GRP.Open;

  Que_SRV.Close;
  Que_SRV.Open;

  Que_Dossier.Close;
  Que_Dossier.Open;

  Que_Raison.Close;
  Que_Raison.Open;

  Que_Version.Close;
  Que_Version.Open;

  Que_Fichiers.Close;
  Que_Fichiers.Open;

  Que_Emetteur.Close;
  Que_Emetteur.Open;

  Que_PlageMAJ.Close;
  Que_PlageMAJ.Open;

  Que_HDB.Close;
  Que_HDB.Open;

  Que_Specifique.Close;
  Que_Specifique.Open;

  Que_Histo.Close;
  Que_Histo.Open;
end;

//----------------------------------------------------> ViderBaseMaintenance

procedure TFMaintenance_DM.ViderBaseMaintenance;
begin
  ViderTable(FMaintenance_DM.que_Maj, tpEmetteur);
  ViderTable(FMaintenance_DM.que_Maj, tpPlageMaj);
  ViderTable(FMaintenance_DM.que_Maj, tpHDB);
  ViderTable(FMaintenance_DM.que_Maj, tpRaison);
  ViderTable(FMaintenance_DM.que_Maj, tpDossier);
  ViderTable(FMaintenance_DM.que_Maj, tpFichiers);
  ViderTable(FMaintenance_DM.que_Maj, tpVersion);
  ViderTable(FMaintenance_DM.que_Maj, tpHisto);
  ViderTable(FMaintenance_DM.que_Maj, tpSpecifique);
  ViderTable(FMaintenance_DM.que_Maj, tpGRP);
  ViderTable(FMaintenance_DM.que_Maj, tpSRV);

  ViderTable()
end;

end.
