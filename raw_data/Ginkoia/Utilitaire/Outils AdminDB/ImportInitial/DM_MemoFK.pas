unit DM_MemoFK;

{
Met en correspondance les identifiants Yellis et Monitor avec les nouveaux
identifiants de Maintenance, afin de reconstruire les clefs étrangères
}

interface

uses
  SysUtils, Classes, DB, DBClient;

type
  TDMMemoFK = class(TDataModule)
    MONITOR_GRP: TClientDataSet;
    MONITOR_GRPID: TIntegerField;
    MONITOR_GRPMAI_ID: TIntegerField;
    MONITOR_SENDER: TClientDataSet;
    IntegerField6: TIntegerField;
    IntegerField7: TIntegerField;
    MONITOR_FOLDER: TClientDataSet;
    IntegerField8: TIntegerField;
    IntegerField9: TIntegerField;
    MONITOR_SRV: TClientDataSet;
    IntegerField10: TIntegerField;
    IntegerField11: TIntegerField;
    YELLIS_CLIENT: TClientDataSet;
    IntegerField12: TIntegerField;
    IntegerField13: TIntegerField;
    YELLIS_VERSION: TClientDataSet;
    IntegerField14: TIntegerField;
    IntegerField15: TIntegerField;
    CDS_NULL: TClientDataSet;
    CDS_NULLID: TIntegerField;
    GINKOIA_GENMAGASIN: TClientDataSet;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    GINKOIA_UILGRPGINKOIA: TClientDataSet;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
  private
    { Déclarations privées }
  public
    procedure InitialiserCDSNULL;
    procedure ViderFKGinkoia;
  end;

var
  DMMemoFK: TDMMemoFK;

implementation

{$R *.dfm}

procedure TDMMemoFK.InitialiserCDSNULL;
begin
  with CDS_NULL do
       begin
       Append;
       Fields[0].Value := 0;
       Post;
       end;
end;

procedure TDMMemoFK.ViderFKGinkoia;
begin
   GINKOIA_GENMAGASIN.EmptyDataSet;
   GINKOIA_UILGRPGINKOIA.EmptyDataSet;
end;

end.
