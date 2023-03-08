unit GSDataExport_DM;

interface

uses
  SysUtils, Classes, GSDataMain_DM, DB, IBODataset, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdIntercept,
  IdLogBase, IdLogFile, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, GSDataDbCfg_DM,
  GSData_TBaseExport, SBUtils, SBSimpleSftp, SBSSHKeyStorage, Windows;

type
  TDM_GSDataExport = class(TDataModule)
    Que_PreTraitement: TIBOQuery;
    Que_TriggerDiff: TIBOQuery;
    Que_Generic_RecupData: TIBOQuery;
    IdFTP: TIdFTP;
    IdLogFile: TIdLogFile;
    IdOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    Que_InfoFichier: TIBOQuery;
    ElSimpleSFTPClient: TElSimpleSFTPClient;
    Que_GenParam: TIBOQuery;
    ProcStoc_PrUpdateK: TIBOStoredProc;
    Que_GeneralId: TIBOQuery;
    procedure ElSimpleSFTPClientKeyValidate(Sender: TObject;
      ServerKey: TElSSHKey; var Validate: Boolean);
  private
    { Déclarations privées }
    function BuildPath(const AFolders: array of String): String; overload;
    function BuildPath: String; overload;
  public
    { Déclarations publiques }
    function CalculStockDiff() : boolean;
    {$REGION 'Méthodes FTP'}
    function OpenFTP() : Boolean;
    procedure CloseFTP();
    function IsOpenFTP() : boolean;
    {$REGION 'depose des fichiers sur le FTP'}
    {
      FileName : Fichier a envoyer
      AModeMag :
        0 : Répertoire Courrir
        1 : Répertoire GOSport

      AModeType :
        0 : Répertoire Envoi
        1 : Répertoire RECEPTION

      Direcory : Nom du répertoire dans lequel mettre les fichier
    }
    {$ENDREGION}
    function PutFileOnFTP(LocalPath, FileName : String; AModeMag, AModeType : Integer; Direcory : String) : Boolean;
    {$ENDREGION 'Méthodes'}
    {$REGION 'Méthodes SFTP'}
    function  OpenSFTP: Boolean;
    procedure CloseSFTP(const Silent: Boolean = False);
    function  IsOpenSFTP: Boolean;
    function  PutFileOnSFTP(const LocalPath, FileName: String; const AModeMag, AModeType: Integer; const Directory: String): Boolean;
    {$ENDREGION}

    function GetClassForExport(FileLibelle : string) : TBaseExportClass;

    function QueryToStringList(const ADataSet: TIBOQuery; const AQuery: String; const AParameters: array of String; var AStringList: TStringList; const ASeparator: String = '|'): Boolean;

    function GetParamString(const AType, ACode, AMagId: Integer): String;
    function GetParamInteger(const AType, ACode, AMagId: Integer): Integer;
    function GetParamFloat(const AType, ACode, AMagId: Integer): Double;

    function SetParamString(const AType, ACode, AMagId: Integer; const AParam: String): Boolean;
    function SetParamInteger(const AType, ACode, AMagId: Integer; const AParam: Integer): Boolean;
    function SetParamFloat(const AType, ACode, AMagId: Integer; const AParam: Double): Boolean;

    function GetCurrentVersion(): Integer;
  end;

  ESFTPDirectoryNotFound = class( Exception );

var
  DM_GSDataExport: TDM_GSDataExport;

implementation

uses
  GSData_Types, StrUtils, Variants, SBSSHConstants, uLog;

{$R *.dfm}

function TDM_GSDataExport.CalculStockDiff() : boolean;
var
  retour : integer;
begin
  Result := false;
  retour := 2;

  try
    DM_GSDataMain.IbT_MAJ.StartTransaction();
    Que_PreTraitement.ExecSQL();
    DM_GSDataMain.IbT_MAJ.Commit();
  except
    DM_GSDataMain.IbT_MAJ.Rollback();
  end;

  while retour > 0 do
  begin
    try
      DM_GSDataMain.IbT_MAJ.StartTransaction();
      Que_TriggerDiff.ParamByName('pas').AsInteger := 500;
      Que_TriggerDiff.Open();
      retour := Que_TriggerDiff.FieldByName('retour').AsInteger;
      Que_TriggerDiff.Close();
      DM_GSDataMain.IbT_MAJ.Commit();
    except
      DM_GSDataMain.IbT_MAJ.Rollback();
    end;
  end;

  Result := true;
end;

function TDM_GSDataExport.OpenFTP() : Boolean;
begin
  Result := False;
  Try
    CloseFTP();
    // configuration du FTP
    IdFTP.Host := IniStruct.FTP.Host;
    IdFTP.Username := IniStruct.FTP.UserName;
    IdFTP.Password := IniStruct.FTP.PassWord;
    IDFTP.Port := IniStruct.FTP.Port;
    IdFTP.Passive := IniStruct.FTP.Passif;
    if IniStruct.FTP.SSL then
      IdFTP.IOHandler := IdOpenSSL
    else
      IdFTP.IOHandler := nil;

    IdFTP.Connect();
    Result := True;
  Except
    on E:Exception do
      raise Exception.Create('OpenFTP -> ' + E.Message);
  End;
end;

function TDM_GSDataExport.OpenSFTP: Boolean;
begin
  Result := False;
  try
    CloseSFTP;
    // configuration du SFTP
    ElSimpleSFTPClient.Address                              := IniStruct.SFTP.Host;
    ElSimpleSFTPClient.Username                             := IniStruct.SFTP.UserName;
    ElSimpleSFTPClient.Password                             := IniStruct.SFTP.PassWord;
    ElSimpleSFTPClient.Port                                 := IniStruct.SFTP.Port;
    ElSimpleSFTPClient.CompressionAlgorithms[ SSH_CA_ZLIB ] := IniStruct.SFTP.Compression;
    ElSimpleSFTPClient.AuthenticationTypes                  := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
    ElSimpleSFTPClient.Open;
    Result := True;
  except
    on E:Exception do
      raise Exception.Create('OpenSFTP -> ' + E.Message);
  end;
end;

procedure TDM_GSDataExport.CloseFTP();
begin
  if IdFTP.Connected then
    IdFTP.Disconnect();
end;

procedure TDM_GSDataExport.CloseSFTP(const Silent: Boolean);
begin
  if ElSimpleSFTPClient.Active then
    ElSimpleSFTPClient.Close( Silent );
end;

procedure TDM_GSDataExport.ElSimpleSFTPClientKeyValidate(Sender: TObject;
  ServerKey: TElSSHKey; var Validate: Boolean);
begin
//  showmessage('Server key [' + DigestToStr(ServerKey.FingerprintMD5) + '] received');
  Validate := True;
end;

function TDM_GSDataExport.IsOpenFTP() : boolean;
begin
  Result := IdFTP.Connected;
end;

function TDM_GSDataExport.IsOpenSFTP: Boolean;
begin
  Result := ElSimpleSFTPClient.Active;
end;

function TDM_GSDataExport.PutFileOnFTP(LocalPath, FileName : String; AModeMag, AModeType : Integer; Direcory : String) : Boolean;
var
  i, j : Integer;
begin
  Result := False;
  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Envoi...', [ FileName ] ), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  try
    // Revenir au répertoire de base
    while IdFTP.RetrieveCurrentDir <> '/' do
      IdFTP.ChangeDirUp;

    // Positionnement sur le répertoire de test ou de production
    if IniStruct.FTPDir.Mode = 1 then
      IdFtp.ChangeDir(IniStruct.FTPDir.Test) // Test
    else
      IdFtp.ChangeDir(IniStruct.FTPDir.Principal); // Principal

    // Postionnement sur le répertoire courrir ou GOSport
    case AModeMag of
      1: IdFTP.ChangeDir(IniStruct.FTPDir.GoSport); // Gosport
      2: IdFTP.ChangeDir(IniStruct.FTPDir.Courir);  // courir
    end;

    // Postionnement sur le répertoire d'envoi ou de réception
    case AModeType of
      0: IdFTP.ChangeDir(IniStruct.FTPDir.Envoi);
      1: IdFTP.ChangeDir(IniStruct.FTPDir.reception);
    end;

    // Positionnement sur le réperetoire des fichiers
    if Direcory <> '' then
      IdFtp.ChangeDir(Direcory);

    // depose du fichier
    IdFTP.Put(LocalPath + FileName, FileName, False);
    Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
      DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Envoyé', [ FileName ] ), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );

    Result := True;
  Except
    on E:Exception do
    begin
      Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
        DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      raise Exception.Create('PutFileOnFTP -> ' + E.Message);
    end;
  End;
end;

function TDM_GSDataExport.PutFileOnSFTP(const LocalPath, FileName: String;
  const AModeMag, AModeType: Integer; const Directory: String): Boolean;
var
  RemotePath: String;
  iAttemptRemaining, iTimeout: Integer;
begin
  Result := False;
  Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
    DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Envoi...', [ FileName ] ), logNotice, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
  with IniStruct.SFTPDir do
    RemotePath := BuildPath([
                  IfThen(      Mode = 1, Test  , Principal ),
                  IfThen( AModeMag  = 2, Courir, GoSport   ),
                  IfThen( AModeType = 0, Envoi , Reception ),
                  Directory
                ]);

  // Récupération des paramètres (nombre de tentative & délai)
  iAttemptRemaining := IniStruct.SFTP.Attempts;
  iTimeout := IniStruct.SFTP.Timeout;
  try
    repeat
      try
        // Est-ce que le fichier distant existe ?
        if not ElSimpleSFTPClient.FileExists( RemotePath ) then
          raise ESFTPDirectoryNotFound.CreateFmt('Le repertoire "%s" est inexistant',[ RemotePath ]);
        // Tentative d'upload du fichier local
        ElSimpleSFTPClient.UploadFile( LocalPath + FileName, RemotePath + FileName );
        Result := True;
        Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
          DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', Format( '%s : Envoyé', [ FileName ] ), logInfo, True, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      except
        // Le repertoire n'existe pas.. ca ne sert à rien du tout de retenter...
        on E: ESFTPDirectoryNotFound do
          raise;
        on E: Exception do
        begin
          // ...pour toute autre erreur, on retente tant qu'on le doit.
          if IniStruct.SFTP.Attempts > 0 then
          begin
            Dec( iAttemptRemaining );
            // S'il s'agit de l'ultime tentative qui a échoué => ca ne sert plus à
            // rien de retenter...
            if iAttemptRemaining < 1 then
              raise Exception.Create( E.Message );
          end;
          // Déconnexion, délai, connexion avant une nouvelle tentative..
          try
            { TODO -oJO : logger les nouvelles tentatives ? }
            CloseSFTP;
            Sleep( iTimeout );
            OpenSFTP;
          except
            // Do not raise, and try again...
          end;
        end;
      end;
    // On sort de la boucle de tentative dès lorsque l'upload a réussi OU que
    // toutes les tentatives prévues ont échoué.
    // Attention cependant, si l'utilisateur spécifi le paramètre "ATTEMPTS"
    // avec une valeur négative ou nulle, la boucle ne peut être interrompu que
    // lorsque l'upload réussi.
    until Result
      or ( ( IniStruct.SFTP.Attempts > 0 ) and ( iAttemptRemaining < 1 ) );
  except
    on E: Exception do
    begin
      Log.Log( '', 'FTP', '', DM_GSDataMain.Que_Magasins.FieldByName( 'BAS_GUID' ).AsString,
        DM_GSDataMain.Que_Magasins.FieldByName('MAG_ID').AsString, 'Status', E.Message, logError, False, DM_GSDataMain.LogFreq, DM_GSDataMain.LogType );
      raise Exception.Create('PutFileOnSFTP -> ' + E.Message);
    end;
  end;
end;

function TDM_GSDataExport.BuildPath(const AFolders: array of String): String;
var
  i: Integer;
begin
  (*****************************************************************************
  Cette fonction concatène chacun des dossiers AFolders en intercalant entre 
  chacun d'entres eux le séparateur '\'.
  *****************************************************************************)
  Result := '/';
  for i := Low( AFolders ) to High( AFolders ) do
    if Trim(AFolders[i]) <> '' then
      Result := Result + AFolders[i] + '/';
end;

function TDM_GSDataExport.BuildPath: String;
begin                                     
  (*****************************************************************************
  Cette fonction retourne le path "de base" : '\'
  *****************************************************************************)
  Result := BuildPath( [] );
end;

function TDM_GSDataExport.QueryToStringList(const ADataSet: TIBOQuery;
  const AQuery: String; const AParameters: array of String;
  var AStringList: TStringList; const ASeparator: String): Boolean;

  function FormatField(const AField: TField): String;
  begin
  (*****************************************************************************
  Cette fonction retourne la valeur du champ AField sous forme de chaîne.
  S'il s'agit d'un float, elle remplace la virgule par un point.
  *****************************************************************************)
    Result := IfThen( VarIsFloat( AField.Value ),
                StringReplace( AField.AsString, ',', '.', []),
                AField.AsString
              );
  end;

var
  i: Integer;
  sBuffer: String;

begin
  ADataSet.Close;
  ADataSet.SQL.Clear; // Necessaire pour le recalcul du ParamCount /!\
  ADataSet.SQL.Add( AQuery );
  ADataSet.ParamCheck := True;
(*******************************************************************************
Cette procédure alimente AStringList avec les conditions suivantes :
  - Au moins 1 paramètre dans AParameters
  - Le nombre de paramètre dans AParameters correspondant au nombre attendu
    dans la requete AQuery
  - La StringList de retour AStringList doit être référencée
  - La requête AQuery ne doit pas être vide
  - Le DataSet ADataSet doit être défini
*******************************************************************************)
  Result := ( Length( AParameters ) > 0 )
        and ( Length( AParameters ) = ADataSet.ParamCount )
        and ( Assigned( AStringList ) )
        and ( AQuery <> '' )
        and ( Que_Generic_RecupData <> nil );
  if not Result then Exit;
  for i := 0 to ADataSet.ParamCount-1 do
    ADataSet.ParamByName( ADataSet.Params.Items[i].Name ).AsString := AParameters[i];

  ADataSet.Open;
  while not ADataSet.Eof do begin
    sBuffer := '';
    for i := 0 to ADataSet.Fields.Count - 1 do
      sBuffer := sBuffer + FormatField( ADataSet.Fields[i] ) + ASeparator;
    AStringList.Add( sBuffer );
    ADataSet.Next;
  end;
end;

function TDM_GSDataExport.GetClassForExport(FileLibelle : string) : TBaseExportClass;
begin
  case AnsiIndexStr(FileLibelle, ['TEST1', 'TEST2', 'XICKET', 'VOLACH', 'VOLREC']) of
    0     : Result := TExportTest1;
    1     : Result := TExportTest2;
    2     : Result := TExportXICKET;
    3, 4  : Result := TExportGoS;
    else Result := TBaseExport;
  end;
end;

function TDM_GSDataExport.GetParamString(const AType, ACode, AMagId: Integer): String;
begin
  // Récupère le paramètre
  try
    OutputDebugString(PChar(Format('Récupération du paramètre Chaîne (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
    Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
    Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
    Que_GenParam.Open();

    if not(Que_GenParam.IsEmpty) then
      Result := Que_GenParam.FieldByName('PRM_STRING').AsString
    else
      raise Exception.Create('Paramètre inexistant pour ce magasin');
  finally
    Que_GenParam.Close();
  end;
end;

function TDM_GSDataExport.GetParamInteger(const AType, ACode, AMagId: Integer): Integer;
begin
  // Récupère le paramètre
  try
    OutputDebugString(PChar(Format('Récupération du paramètre Entier (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
    Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
    Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
    Que_GenParam.Open();

    if not(Que_GenParam.IsEmpty) then
      Result := Que_GenParam.FieldByName('PRM_INTEGER').AsInteger
    else
      raise Exception.Create('Paramètre inexistant pour ce magasin');
  finally
    Que_GenParam.Close();
  end;
end;

function TDM_GSDataExport.GetParamFloat(const AType, ACode, AMagId: Integer): Double;
begin
  // Récupère le paramètre
  try
    OutputDebugString(PChar(Format('Récupération du paramètre Réel (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
    Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
    Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
    Que_GenParam.Open();

    if not(Que_GenParam.IsEmpty) then
      Result := Que_GenParam.FieldByName('PRM_FLOAT').AsFloat
    else
      raise Exception.Create('Paramètre inexistant pour ce magasin');
  finally
    Que_GenParam.Close();
  end;
end;

function TDM_GSDataExport.SetParamString(const AType, ACode, AMagId: Integer; const AParam: String): Boolean;
var
  iPrmId: Integer;
begin
  // Enregistre le paramètre
  Result := False;
  try
    OutputDebugString(PChar(Format('Enregistrement du paramètre Chaîne (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.IB_Transaction.StartTransaction();
    try
      Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
      Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
      Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
      Que_GenParam.Open();

      if not(Que_GenParam.IsEmpty) then
      begin
        iPrmId := Que_GenParam.FieldByName('PRM_ID').AsInteger;
        if iPrmId <> 0 then
        begin
          Que_GenParam.Edit();
          Que_GenParam.FieldByName('PRM_STRING').AsString         := AParam;
          Que_GenParam.Post();
          ProcStoc_PrUpdateK.ParamByName('K_ID').AsInteger        := iPrmId;
          ProcStoc_PrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
          ProcStoc_PrUpdateK.ExecProc();       
          Que_GenParam.IB_Transaction.Commit();
          Result := True;
        end;
      end;  
    except
      Que_GenParam.IB_Transaction.Rollback();
      raise;
    end;
  finally
    ProcStoc_PrUpdateK.Close();
    Que_GenParam.Close();                
    Que_GenParam.IB_Transaction.Close();
  end;
end;

function TDM_GSDataExport.SetParamInteger(const AType, ACode, AMagId: Integer; const AParam: Integer): Boolean;
var
  iPrmId: Integer;
begin
  // Enregistre le paramètre
  Result := False;
  try
    OutputDebugString(PChar(Format('Enregistrement du paramètre Entier (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.IB_Transaction.StartTransaction();
    try
      Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
      Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
      Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
      Que_GenParam.Open();

      if not(Que_GenParam.IsEmpty) then
      begin
        iPrmId := Que_GenParam.FieldByName('PRM_ID').AsInteger;
        if iPrmId <> 0 then
        begin
          Que_GenParam.Edit();
          Que_GenParam.FieldByName('PRM_INTEGER').AsInteger       := AParam;
          Que_GenParam.Post();
          ProcStoc_PrUpdateK.ParamByName('K_ID').AsInteger        := iPrmId;
          ProcStoc_PrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
          ProcStoc_PrUpdateK.ExecProc();
          Que_GenParam.IB_Transaction.Commit();
          Result := True;          
        end;
      end;
    except
      Que_GenParam.IB_Transaction.Rollback();
      raise;
    end;
  finally
    ProcStoc_PrUpdateK.Close();
    Que_GenParam.Close();
    Que_GenParam.IB_Transaction.Close();
  end;
end;

function TDM_GSDataExport.SetParamFloat(const AType, ACode, AMagId: Integer; const AParam: Double): Boolean;
var
  iPrmId: Integer;
begin
  // Enregistre le paramètre
  Result := False;
  try
    OutputDebugString(PChar(Format('Enregistrement du paramètre Réel (Type = %d Code : %d Magasin : %d)',
      [AType, ACode, AMagId])));
    Que_GenParam.IB_Transaction.StartTransaction();
    try
      Que_GenParam.ParamByName('MAGID').AsInteger   := AMagId;
      Que_GenParam.ParamByName('PRMCODE').AsInteger := ACode;
      Que_GenParam.ParamByName('PRMTYPE').AsInteger := AType;
      Que_GenParam.Open();

      if not(Que_GenParam.IsEmpty) then
      begin
        iPrmId := Que_GenParam.FieldByName('PRM_ID').AsInteger;
        if iPrmId <> 0 then
        begin
          Que_GenParam.Edit();
          Que_GenParam.FieldByName('PRM_FLOAT').AsFloat           := AParam;
          Que_GenParam.Post();
          ProcStoc_PrUpdateK.ParamByName('K_ID').AsInteger        := iPrmId;
          ProcStoc_PrUpdateK.ParamByName('SUPRESSION').AsInteger  := 0;
          ProcStoc_PrUpdateK.ExecProc();   
          Que_GenParam.IB_Transaction.Commit();
          Result := True;
        end;
      end; 
    except
      Que_GenParam.IB_Transaction.Rollback();
      raise;
    end;
  finally
    ProcStoc_PrUpdateK.Close();
    Que_GenParam.Close();     
    Que_GenParam.IB_Transaction.Close();
  end;
end; 

function TDM_GSDataExport.GetCurrentVersion(): Integer;
begin
  // Récupère le GENERAL_ID
  try
    Que_GeneralId.Open();
    Result := Que_GeneralId.FieldByName('CURRENT_VERSION').AsInteger;
  finally
    Que_GeneralId.Close();
  end;
end;

//Déclaration de la License Key SecureBlackBox
initialization
  SetLicenseKey(
    '4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' +
    'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
    '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' +
    'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
    'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' +
    'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
    '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' +
    'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F'
  );

end.
