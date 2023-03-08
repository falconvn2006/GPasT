//$Log:
// 3    Utilitaires1.2         10/08/2018 18:14:52    Sylvain CORBELETTA
//      Modification pour pouvoir appliquer ou non une <RELEASE>... suivant le
//      type de r?plication de la base de donn?e
// 2    Utilitaires1.1         06/03/2017 10:06:41    Gilles Riand    Erreur
//      al?atoire dans Script.exe : erreur de connexion : on tente 3 fois
// 1    Utilitaires1.0         04/05/2012 12:09:44    Christophe HENRAT 
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
    IBQue_EasyDataBase: TIBQuery;
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
