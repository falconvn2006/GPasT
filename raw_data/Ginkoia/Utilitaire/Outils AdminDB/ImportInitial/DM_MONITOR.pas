unit DM_MONITOR;

{Tables originales de la base Monitor
Ordre d'importation :
1. GRP et SRV (ID réutilisé dans FOLDER)
2. FOLDER (ID réutilisé SENDER)
3. SENDER (ID réutilisé HDB)
4. HDB
}
interface

uses
  SysUtils, Classes, IB_Components, DB, IBODataset;

type
  TDMMonitor = class(TDataModule)
    IBCNX_MONITOR: TIB_Connection;
    TBL_SRV: TIBOTable;
    TBL_GRP: TIBOTable;
    TBL_FOLDER: TIBOTable;
    TBL_SENDER: TIBOTable;
    TBL_HDB: TIBOTable;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DMMonitor: TDMMonitor;

implementation

{$R *.dfm}

end.
