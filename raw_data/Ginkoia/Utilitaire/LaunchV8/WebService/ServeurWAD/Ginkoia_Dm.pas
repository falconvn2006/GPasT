unit Ginkoia_Dm;

interface

uses
  SysUtils,
  // Uses perso
  Forms,
  DateUtils,
  // Fin uses perso
  Classes,
  DB,
  IBODataset,
  IB_Components;

type
  TDm_Ginkoia = class(TDataModule)
    IbT_Ginkoia: TIB_Transaction;
    IbC_Ginkoia: TIB_Connection;
    Que_Jetons: TIBOQuery;
    Que_JetonsJET_BASID: TIntegerField;
    Que_JetonsJET_STAMP: TDateTimeField;
    Que_DelJetons: TIBOQuery;
    Que_GetBasID: TIBOQuery;
    Que_GetBasIDBAS_ID: TIntegerField;
    Que_WriteJeton: TIBOQuery;
  private
    FBasID       : integer;
    FTimeOutJeton: integer;
    { Déclarations privées }
  public
    // Connexion / Déco de la base
    function ConnectDB(const ANomClient, ASender: string; var AMessage: string): integer;
    procedure DisconnectDB;

    // Vérifie la disponibilité d'un token et l'écrit au besoin
    function CanGetToken(): boolean;

    // Ecrit ou écrase un token
    Procedure WriteToken();
    procedure DelToken();

    // Id de la base
    property BasID: integer Read FBasID Write FBasID;

    // Délai de time out (en secondes)
    property TimeOutJeton: integer Read FTimeOutJeton Write FTimeOutJeton;
  end;

var
  Dm_Ginkoia: TDm_Ginkoia;

implementation

{$R *.dfm}

uses StdXML_TLB,
  XMLCursor;

{ TDm_Ginkoia }

function TDm_Ginkoia.CanGetToken: boolean;
var
  dtTimeOut: TDateTime; // Moment avant lequel il y'a Timeout

begin
  // Ok, on vérifier si on peut prendre un token
  Que_Jetons.Open;
  if Que_Jetons.RecordCount > 0 then
  begin
    // Il y'a déjà un jeton, on vérif si c'est bien le notre
    if Que_Jetons.FieldByName('JET_BASID').AsInteger = FBasID then
    begin
      WriteToken(); // Maj du timestamp
      Result := True;
    end
    else begin
      // On vérifie la date, et voir s'il a expiré
      dtTimeOut := Now() - (FTimeOutJeton / SecsPerDay);
      IF Que_Jetons.FieldByName('').AsDateTime <= TTimeZone.Local.ToUniversalTime(dtTimeOut) THEN
      BEGIN
        // On écrase
        WriteToken();
        Result := True;
      END
      else begin
        // Jeton déjà pris, renvoyer False
        Result := False;
      end;
    end;
  end
  else begin
    WriteToken(); // Maj du timestamp
    Result := True;
  end;
  Que_Jetons.Close;
end;

function TDm_Ginkoia.ConnectDB(const ANomClient, ASender: string; var AMessage: string): integer;
var
  sPathDatabaseXML: string;     // Chemin du fichier xml database à lire
  MyDoc           : IXMLCursor; // document XML complet
  MyDatasource    : IXMLCursor; // Noeud datasource
  MyParam         : IXMLCursor; // Noeud param
  sPathBase       : string;     // Chemin vers la base de donnée
  sLogin          : string;     // Login BDD
  sPasswd         : string;     // Password BDD

begin
  // Messages d'erreur :
  // * -1 : Fichier database non trouvé
  // * -2 : Client non trouvé dans le fichier database
  // * -3 : Fichier interbase non trouvé
  // * -4 : Connexion à la base impossible

  // Ouvrir le fichier Databases.xml
  sPathDatabaseXML := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  sPathDatabaseXML := sPathDatabaseXML + 'DelosQPMAgent.DataBases.xml';

  if not FileExists(sPathDatabaseXML) then
  begin
    Result   := -1;
    AMessage := 'Fichier DelosQPMAgent.DataBases.xml non trouvé dans ' + ExtractFilePath(Application.ExeName);
  end
  else begin
    // Charger la base du client
    MyDoc        := TXMLCursor.Create;
    MyDatasource := TXMLCursor.Create;
    MyParam      := TXMLCursor.Create;

    MyDoc.Load(sPathDatabaseXML);

    MyDatasource := MyDoc.Select('/DataSources/DataSource');
    while (not MyDatasource.EOF) and (SysUtils.Uppercase(MyDatasource.GetValue('Name')) <> SysUtils.Uppercase(ANomClient)) do
    begin
      MyDatasource.Next;
    end;

    if MyDatasource.EOF then
    begin
      // Client non trouvé
      Result   := -2;
      AMessage := 'Client ' + ANomClient + ' non trouvé dans le fichier database';
    end
    else begin
      // Trouvé
      // On cherche le chemin vers la base et le login/password.
      MyParam := MyDatasource.Select('Params/Param');
      MyParam.First;
      while not MyParam.EOF do
      begin
        if Uppercase(MyParam.GetValue('Name')) = 'SERVER NAME' then
        begin
          sPathBase := MyParam.GetValue('Value');
        end;
        if Uppercase(MyParam.GetValue('Name')) = 'USER NAME' then
        begin
          sLogin := MyParam.GetValue('Value');
        end;
        if Uppercase(MyParam.GetValue('Name')) = 'PASSWORD' then
        begin
          sPasswd := MyParam.GetValue('Value');
        end;
        MyParam.Next;
      end;

      if not(FileExists(sPathBase) and (sLogin <> '')) then
      begin
        // Erreur
        Result   := -3;
        AMessage := 'Fichier interbase non trouvé';
      end
      else begin
        // Connexion
        IbC_Ginkoia.DatabaseName := sPathBase;
        IbC_Ginkoia.Username     := sLogin;
        IbC_Ginkoia.Password     := sPasswd;

        try
          IbC_Ginkoia.Open;

          IF IbC_Ginkoia.Connected THEN
          begin
            Result := 0;

            // Récupération du BasID en fonction du sender.
            Que_GetBasID.ParamByName('SENDER').AsString := ASender;
            Que_GetBasID.Open;
            FBasID                                      := Que_GetBasID.Fields[0].AsInteger;
            Que_GetBasID.Close;

            // Temps de timeout a rendre paramétrable dans genparam ou dans ini (pr l'instant 300);
            TimeOutJeton := 300;
          end
          else begin
            Result   := -4;
            AMessage := 'Connexion à la base impossible';
          end;
        except
          on E: Exception do
          begin
            Result   := -4;
            AMessage := 'Connexion à la base impossible';
          end;
        end;
      end;
    end;
  end;
end;

procedure TDm_Ginkoia.DelToken;
begin
  IbT_Ginkoia.StartTransaction;
  try
    // Suppression de tous les jetons (permet une épuration au besoin)
    Que_DelJetons.ExecSQL;
    Que_DelJetons.Close;
    IbT_Ginkoia.Commit;
  except
    IbT_Ginkoia.Rollback;
  end;
end;

procedure TDm_Ginkoia.DisconnectDB;
begin
  // Déconnexion de la base
  IF IbT_Ginkoia.InTransaction THEN
  begin
    IbT_Ginkoia.Rollback;
  end;

  IbC_Ginkoia.Close;
end;

procedure TDm_Ginkoia.WriteToken;
begin
  // On écrit le token
  IbT_Ginkoia.StartTransaction;
  try
    // Suppression de tous les jetons (permet une épuration au besoin)
    Que_DelJetons.ExecSQL;
    Que_DelJetons.Close;

    // Création du jeton
    Que_WriteJeton.ParamByName('BASID').AsInteger  := FBasID;
    Que_WriteJeton.ParamByName('STAMP').AsDateTime := TTimeZone.Local.ToUniversalTime(Now());
    Que_WriteJeton.ExecSQL;
    Que_WriteJeton.Close;

    IbT_Ginkoia.Commit;
  except
    on E: Exception do
    begin
      IbT_Ginkoia.RollBack;
    end;
  end;

end;

end.
