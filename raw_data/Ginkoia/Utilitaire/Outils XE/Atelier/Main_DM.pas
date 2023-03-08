unit Main_DM;

interface

uses
  SysUtils, Classes, IB_Components, IBODataset, IB_Access, DB;

var
  GAPPPATH,
  GAPPLOGS : String;


type
  TDM_Main = class(TDataModule)
    IBOMainDatabase: TIBODatabase;
    IBOMainTrans: TIBOTransaction;
    Que_Tmp: TIBOQuery;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DM_Main: TDM_Main;

implementation

{$R *.dfm}

end.
