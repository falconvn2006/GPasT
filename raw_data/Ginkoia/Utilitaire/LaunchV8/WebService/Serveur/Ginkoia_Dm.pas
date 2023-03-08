unit Ginkoia_Dm;

interface

uses
  SysUtils,
  // Uses perso
  Forms,
  UTools,
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
    Que_GetVersion: TIBOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FBasID       : integer;
    FTimeOutJeton: integer;
    { Déclarations privées }
  public
    // Connexion / Déco de la base
    function ConnectDB(const ANomClient, ASender: string; var AMessage: string): integer;
    function GetVersion(): string;

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

implementation

{$R *.dfm}

uses
  XmlDoc,
  XMLIntf;

{ TDm_Ginkoia }

function TDm_Ginkoia.CanGetToken: boolean;
var
  dtTimeOut: TDateTime; // Moment avant lequel il y'a Timeout
begin
  LogAction('Appel à CanGetTOKEN', 3);
  // Ok, on vérifier si on peut prendre un token
  Que_Jetons.Open;
  if Que_Jetons.RecordCount > 0 then
  begin
    LogAction('Jeton OQP : Vérif pourquoi', 3);
    // Il y'a déjà un jeton, on vérif si c'est bien le notre
    if Que_Jetons.FieldByName('JET_BASID').AsInteger = FBasID then
    begin
      LogAction('Jeton OQP par nous : OK', 3);
      WriteToken(); // Maj du timestamp
      Result := True;
    end
    else begin
      LogAction('Jeton OQP par autre : Vérif Timeout', 3);
      // On vérifie la date, et voir s'il a expiré
      dtTimeOut := Now() - (FTimeOutJeton / SecsPerDay);
      IF Que_Jetons.FieldByName('JET_STAMP').AsDateTime <= TTimeZone.Local.ToUniversalTime(dtTimeOut) THEN
      BEGIN
        LogAction('Jeton OQP par autre, mais TIMEOUT :  OK', 3);
        // On écrase
        WriteToken();
        Result := True;
      END
      else begin
        // Jeton déjà pris, renvoyer False
        LogAction('Jeton OQP par autre :  Pas OK', 3);
        Result := False;
      end;
    end;
  end
  else
  begin
    LogAction('Jeton Pas OQP: OK', 3);
    WriteToken(); // Maj du timestamp
    Result := True;
  end;
  Que_Jetons.Close;
  LogAction('Fin Appel à CanGetTOKEN', 3);
end;

function TDm_Ginkoia.ConnectDB(const ANomClient, ASender: string; var AMessage: string): integer;

  function FindXMLNode(parent : IXmlNode; NodeName : string) : IXmlNode;
  var
    i : integer;
  begin
    Result := nil;
    for i := 0 to parent.ChildNodes.Count -1 do
    begin
      if UpperCase(parent.ChildNodes[i].NodeName) = UpperCase(NodeName) then
      begin
        Result := parent.ChildNodes[i];
        Break;
      end;
    end;
  end;

var
  sPathDatabaseXML: string;     // Chemin du fichier xml database à lire
  sPathBase       : String;     // Chemin vers la base de donnée
  sLogin          : String;     // Login BDD
  sPasswd         : String;     // Password BDD
  Found : boolean;
  XmlDoc : IXmlDocument;
  XmlNodeName, XmlNodeParams, XmlNodeParamName, XmlNodeParamValue : IXmlNode;
  i, j : integer;
begin
  Found := false;
  sPathBase := '';
  sLogin := '';
  sPasswd := '';

  // Messages d'erreur :
  // * -1 : Fichier database non trouvé
  // * -2 : Client non trouvé dans le fichier database
  // * -3 : Fichier interbase non trouvé
  // * -4 : Connexion à la base impossible

  // Ouvrir le fichier Databases.xml
  sPathDatabaseXML := GetDatabaseFile();
  LogAction('Tentative de lecture de ' + sPathDatabaseXML, 3);

  if not FileExists(sPathDatabaseXML) then
  begin
    Result   := -1;
    AMessage := 'Fichier DelosQPMAgent.DataBases.xml non trouvé dans ' + ExtractFilePath(Application.ExeName);
    LogAction('Fichier DelosQPMAgent.DataBases.xml non trouvé dans ' + ExtractFilePath(Application.ExeName), 3);
  end
  else
  begin
    LogAction('Fichier DelosQPMAgent.DataBases.xml trouvé', 3);
    XmlDoc := TXmlDocument.Create(Self);
    XmlDoc.LoadFromFile(sPathDatabaseXML);
    for i := 0 to XmlDoc.DocumentElement.ChildNodes.Count -1 do
    begin
      XmlNodeName := FindXMLNode(XmlDoc.DocumentElement.ChildNodes[i], 'Name');
      if Assigned(XmlNodeName) and (UpperCase(XmlNodeName.NodeValue) = UpperCase(ANomClient)) then
      begin
        XmlNodeParams := FindXMLNode(XmlNodeName.ParentNode, 'Params');
        if Assigned(XmlNodeParams) then
        begin
          for j := 0 to XmlNodeParams.ChildNodes.Count -1 do
          begin
            XmlNodeParamName := FindXMLNode(XmlNodeParams.ChildNodes[j], 'Name');
            XmlNodeParamValue := FindXMLNode(XmlNodeParams.ChildNodes[j], 'Value');
            if Assigned(XmlNodeParamName) and Assigned(XmlNodeParamValue) then
            begin
              if UpperCase(XmlNodeParamName.NodeValue) = 'SERVER NAME' then
                sPathBase := XmlNodeParamValue.NodeValue
              else if UpperCase(XmlNodeParamName.NodeValue) = 'USER NAME' then
                sLogin := XmlNodeParamValue.NodeValue
              else if UpperCase(XmlNodeParamName.NodeValue) = 'PASSWORD' then
                sPasswd := XmlNodeParamValue.NodeValue;
            end;
          end;
        end;
        // si trouver ??
        if (Trim(sPathBase) <> '') and (Trim(sLogin) <> '') and (Trim(sPasswd) <> '') then
        begin
          Found := true;
          Break;
        end
        else
          LogAction('Paramétrage non trouver dans le node du client "' + ANomClient + '"', 3);
      end;
    end;

    if Found then
    begin
      LogAction('Tentative de conexion à ' + sPathBase, 3);
      LogAction(sLogin + '/' + sPasswd, 3);

      // Connexion
      IbC_Ginkoia.Close;
      IbC_Ginkoia.DatabaseName := sPathBase;
      IbC_Ginkoia.Username     := sLogin;
      IbC_Ginkoia.Password     := sPasswd;

      try
        IbC_Ginkoia.Open;
        LogAction('Après database.open', 3);

        IF IbC_Ginkoia.Connected THEN
        begin
          Result := 0;

          LogAction('DB Connectée, récupération du BAS_ID, avec Sender : ' + ASender, 3);
          // Récupération du BasID en fonction du sender.
          Que_GetBasID.ParamByName('SENDER').AsString := ASender;
          Que_GetBasID.Open;
          FBasID                                      := Que_GetBasID.Fields[0].AsInteger;
          LogAction('BasID Lu : ' + IntToStr(FBasID), 3);
          Que_GetBasID.Close;

          // Temps de timeout a rendre paramétrable dans genparam ou dans ini (pr l'instant 300);
          TimeOutJeton := 300;
        end
        else
        begin
          Result   := -4;
          AMessage := 'Connexion à la base impossible';
        end;
      except
        on E: Exception do
        begin
          Result   := -4;
          AMessage := 'Connexion à la base impossible';
          LogAction(E.Message, 3);
        end;
      end;
    end
    else
    begin
      // Client non trouvé
      Result   := -2;
      AMessage := 'Client ' + ANomClient + ' non trouvé dans le fichier database';
    end;
  end;

  LogAction(AMessage, 3);
end;

procedure TDm_Ginkoia.DataModuleCreate(Sender: TObject);
begin
  LogAction('Création du DM', 3);
end;

procedure TDm_Ginkoia.DelToken;
begin
  LogAction('Appel à DelTOKEN', 3);
  IbT_Ginkoia.StartTransaction;
  try
    // Suppression de tous les jetons (permet une épuration au besoin)
    Que_DelJetons.ExecSQL;
    Que_DelJetons.Close;
    IbT_Ginkoia.Commit;
    LogAction('DelTOKEN : OK', 3);
  except
    IbT_Ginkoia.Rollback;
    LogAction('DelTOKEN : Except', 3);
  end;
  LogAction('Fin Appel à DelTOKEN', 3);
end;

procedure TDm_Ginkoia.DisconnectDB;
begin
  // Déconnexion de la base
  IF IbT_Ginkoia.InTransaction THEN
  begin
    IbT_Ginkoia.Rollback;
  end;
  IbC_Ginkoia.Close;

  LogAction('DB Déconnectée', 3);
end;

function TDm_Ginkoia.GetVersion: string;
begin
  try
    // Récupère la version dans GenVersion
    Que_GetVersion.Close;
    Que_GetVersion.Open;
    Result := Que_GetVersion.Fields[0].AsString;
  Except
    Result := '';
  end;
  Que_GetVersion.Close;
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
