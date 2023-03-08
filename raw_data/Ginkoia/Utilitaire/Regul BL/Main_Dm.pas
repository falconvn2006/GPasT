unit Main_Dm;

interface

uses
  SysUtils, Classes, IB_Components, DB, IBODataset;

type
  TDm_Main = class(TDataModule)
    Ginkoia: TIB_Connection;
    Que_ListeBL: TIBOQuery;
    Que_Div: TIBOQuery;
    Que_UpdateK: TIBOQuery;
    Que_UpdateBL: TIBOQuery;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Dm_Main: TDm_Main;
  ReperBase: string;

implementation

{$R *.dfm}

end.
