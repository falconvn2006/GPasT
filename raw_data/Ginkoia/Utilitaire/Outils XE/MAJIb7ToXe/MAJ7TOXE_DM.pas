unit MAJ7TOXE_DM;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBDatabase, ImgList, Controls,MAJ7TOXE_Defs,
  IBServices;

type
  TDM_MajIb7ToXE = class(TDataModule)
    IBServerProperties: TIBServerProperties;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function GetInfoBase(ADatabase : string): TInfoBase;
  end;

var
  DM_MajIb7ToXE: TDM_MajIb7ToXE;

implementation

{$R *.dfm}

{ TDM_MajIb7ToXE }

function TDM_MajIb7ToXE.GetInfoBase(ADatabase : string): TInfoBase;
var
  IbConnect : TIBDatabase;
  TransSac : TIBTransaction;
  QueTmp : TIBQuery;

begin
  Try
    IbConnect := TIBDatabase.Create(nil);
    TransSac := TIBTransaction.Create(IbConnect);
    // connexion à la base de données
    try
      IbConnect.DefaultTransaction := TransSac;
      IbConnect.DatabaseName := ADatabase;
      IbConnect.LoginPrompt := False;
      IbConnect.Params.Add('user_name=sysdba');
      IbConnect.Params.Add('password=masterkey');
      IbConnect.Connected := true;

      QueTmp := TIBQuery.Create(IbConnect);
      With QueTmp do
      Try
        // récupération de la liste des tables
        Database := IbConnect;
        Close;
        SQL.Clear;
        SQL.Add('Select BAS_NOM, BAS_CODETIERS, MAG_NOM, ADR_LIGNE, VIL_CP, VIL_NOM, ADR_TEL');
        SQL.Add('From GENBASES');
        SQL.Add('Join GENPARAMBASE on PAR_STRING = BAS_IDENT');
        SQL.Add('Join GENMAGASIN on BAS_MAGID = MAG_ID');
        SQL.Add('join GENADRESSE on ADR_ID = MAG_ADRID');
        SQL.Add('Join GENVILLE on VIL_ID = ADR_VILID');
        SQL.Add('Where PAR_NOM = ''IDGENERATEUR''');
        Open;

        Result.NomBase          := FieldByName('BAS_NOM').AsString;
        Result.CodeTiers        := FieldByName('BAS_CODETIERS').AsString;
        Result.Magasin          := FieldByName('MAG_NOM').AsString;
        Result.Infos.Adresse    := FieldByName('ADR_LIGNE').AsString;
        Result.Infos.CodePostal := FieldByName('VIL_CP').AsString;
        Result.Infos.Ville      := FieldByName('VIL_NOM').AsString;
        Result.Infos.Telephone  := FieldByName('ADR_TEL').AsString;
      finally
        FreeAndNil(QueTmp);
      End;
    finally
      FreeAndNil(TransSac);
      FreeAndNil(IbConnect);
    end;
  Except on E:Exception do
    raise Exception.Create('CheckDataDb -> ' + E.Message);
  End;
end;

end.
