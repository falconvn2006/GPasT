unit Jeton_Dm;

interface

uses
  SysUtils,
  Classes,
  IBDatabase,
  DB,
  IBCustomDataSet,
  IBQuery;

type
  TDm_Jeton = class(TDataModule)
    Dtb_Ginkoia: TIBDatabase;
    Tra_Ginkoia: TIBTransaction;
    IBQue_Modifk: TIBQuery;
    ds_ListeMag: TDataSource;
    Que_ListeMag: TIBQuery;
    Que_ListeMagBAS_NOM: TIBStringField;
    Que_ListeMagBAS_ID: TIntegerField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

    function MainNewK(Table: string): integer;
    procedure MainDeleteK(Clef: Integer);
    procedure MainModifK(Clef: Integer);
    procedure MainReactiveK(Clef: Integer);
  end;

var
  Dm_Jeton: TDm_Jeton;
  LaBase0      : string;
  IdBase0      : Integer;
  RepliEnCours : Boolean;


  ModeDebug    : Boolean;

implementation

{$R *.dfm}

{ TDm_LaunchMain }

//---------------------------------------------------------------
// Récupération d'un nouvel ID
//---------------------------------------------------------------
FUNCTION TDm_Jeton.MainNewK(Table: String) : integer;
BEGIN
  IBQue_Modifk.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'SELECT ID FROM PR_NEWK(''' + Table +''')';
  try
    IBQue_ModifK.Open;
    Result := IBQue_ModifK.Fields[0].AsInteger;
  except
    Result := 0;
  end;
  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// Modification du K -> réactivation d'un k_enabled = 0
//---------------------------------------------------------------
procedure TDm_Jeton.MainReactiveK(Clef: Integer);
begin
  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 2)';
  IBQue_ModifK.ExecSQL;
  IBQue_ModifK.Sql.Clear;
end;

//---------------------------------------------------------------
// Modification du K
//---------------------------------------------------------------
PROCEDURE TDm_Jeton.MainModifK(Clef: Integer);
BEGIN
  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 0)';
  IBQue_ModifK.ExecSQL;
  IBQue_ModifK.Sql.Clear;
END;

//---------------------------------------------------------------
// suppression du K
//---------------------------------------------------------------

PROCEDURE TDm_Jeton.MainDeleteK(Clef: Integer);
BEGIN
  IBQue_ModifK.Close;
  IBQue_ModifK.Sql.Clear;
  IBQue_ModifK.Sql.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 1)';
  IBQue_ModifK.ExecSql;
  IBQue_ModifK.Sql.Clear;
END;

end.
