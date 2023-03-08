unit DM_GINKOIA;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components, dxmdaset, UPost;

type
  TDMGinkoia = class(TDataModule)
    IBCNX_GINKOIA: TIB_Connection;
    QR_GENLAUNCH: TIBOQuery;
    TR_GINKOIA: TIB_Transaction;
    TBL_GENMAGASIN: TIBOTable;
    TBL_UILGRPGINKOIA: TIBOTable;
    TBL_UILGRPGINKOIAMAG: TIBOTable;
  private
  public
  end;

var
  DMGinkoia: TDMGinkoia;

implementation

{$R *.dfm}

{ TDMGinkoia }

end.
