unit DM_Atualiza;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Datasnap.Provider, Data.DB,
  Datasnap.DBClient;

type
  TDM_DATASET = class(TDataModule)
    Local: TADOConnection;
    ado_nuvens: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_DATASET: TDM_DATASET;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
