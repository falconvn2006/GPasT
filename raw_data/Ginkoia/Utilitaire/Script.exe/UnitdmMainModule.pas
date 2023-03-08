//$Log:
// 2    Utilitaires1.1         30/05/2005 08:57:39    pascal          Ajout de
//      l'ent?te suite ? v?rification que le script fonctionne pour la MAJ
//      automatique
// 1    Utilitaires1.0         27/04/2005 10:41:32    pascal          
//$
//$NoKeywords$
//

unit UnitdmMainModule;

interface
uses
  Forms,
  SysUtils, Classes, DB, IBDatabase, IBSQL, IBCustomDataSet, IBUpdateSQL,
  IBQuery;

type
  TdmMainModule = class(TDataModule)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBSQLCreateTableVersion: TIBSQL;
    IBQueryTableExist: TIBQuery;
    IBQueryTableExistCOUNT: TIntegerField;
    IBQueryRelease: TIBQuery;
    IBSQLEngine: TIBSQL;
    IBTransactionRelease: TIBTransaction;
    IBUpdateRelease: TIBUpdateSQL;
    IBQueryReleaseVER_VERSION: TIBStringField;
    IBQueryReleaseVER_DATE: TDateTimeField;
    IBQueryGENPARAMBASE: TIBQuery;
    IBQueryGENPARAMBASEPAR_NOM: TIBStringField;
    IBQueryGENPARAMBASEPAR_STRING: TIBStringField;
    IBQueryGENPARAMBASEPAR_FLOAT: TFloatField;
    IBQue_ProcExist: TIBQuery;
    IBQue_ProcExistCOUNT: TIntegerField;
    IBQue_IndexExist: TIBQuery;
    IBQue_IndexExistCOUNT: TIntegerField;
    IBQue_Insert2: TIBQuery;
    IBSQLDivers: TIBSQL;
    IBQue_Test: TIBQuery;
    IBQue_NomChp: TIBQuery;
    IBQue_Divers: TIBQuery;
    IBTransaction2: TIBTransaction;
    IBQue_Insproc: TIBQuery;
    IBQue_GenExists: TIBQuery;
    IBQue_GenExistsCOUNT: TIntegerField;
    IBQue_TRIGGER: TIBQuery;
    QUE_LESBASES: TIBQuery;
    QUE_LESBASESREP_PLACEBASE: TIBStringField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dmMainModule: TdmMainModule;

implementation

{$R *.dfm}

end.
