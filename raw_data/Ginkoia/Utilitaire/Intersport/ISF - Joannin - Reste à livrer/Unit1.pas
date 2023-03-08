unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, IB_Components, DB, IBODataset, IniFiles, StrUtils,
  DateUtils, Types, Generics.Collections, SBUtils, SBSimpleSftp, SBSSHKeyStorage;

const
   WM_TRAITEMENT = WM_USER + 1;

type
   TArticleCB = class
      public
         FArfID: Integer;
         FListeCB: String;

         constructor Create(const nArfID: Integer; const sListeCB: String);
   end;

  TMainForm = class(TForm)
    LabelEtape: TLabel;
    LabelNbListe: TLabel;
    IB_Connection: TIB_Connection;
    Query: TIBOQuery;
    QueryCB: TIBOQuery;
    ElSimpleSFTPClient: TElSimpleSFTPClient;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ElSimpleSFTPClientKeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
    procedure ElSimpleSFTPClientProgress(Sender: TObject; Total, Current: Int64; var Cancel: Boolean);
    procedure ElSimpleSFTPClientError(Sender: TObject; ErrorCode: Integer);
    procedure FormDestroy(Sender: TObject);

  private
    FFichierLog, FRepertoireFTP: String;
    FConserverFichierLocal: Boolean;
    FListeArticlesCB: TObjectList<TArticleCB>;

    procedure PurgeLogs;
    procedure AjoutLog(const sLigne: String);
    procedure Executer(var msg: TMessage);   message WM_TRAITEMENT;
    procedure Traitement;
    function CBFournisseurs(const nARFID: Integer): String;
    function EnvoiFTP(const sFichier: String): Boolean;

  public

  end;

var
  MainForm: TMainForm;

implementation

{ TArticleCB }

constructor TArticleCB.Create(const nArfID: Integer; const sListeCB: String);
begin
   FArfID := nArfID;
   FListeCB := sListeCB;
end;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
   FichierINI: TIniFile;
begin
   if not ForceDirectories(ExtractFilePath(Application.ExeName) + 'Logs') then
      Halt;
   if not ForceDirectories(ExtractFilePath(Application.ExeName) + 'Export\Erreurs\') then
      Halt;
   FFichierLog := ExtractFilePath(Application.ExeName) + 'Logs\' + FormatDateTime('YYYY-MM-DD', Now) + '_' + ChangeFileExt(ExtractFileName(Application.ExeName), '.log');
   PurgeLogs;
   AjoutLog(DupeString('_', 250));

   FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini'));
   try
      IB_Connection.DatabaseName := AnsiString(FichierINI.ReadString('Parametres', 'Base', ''));
      FConserverFichierLocal := (FichierINI.ReadInteger('Parametres', 'Conserver fichier local', 0) = 1);
      ElSimpleSFTPClient.Address := FichierINI.ReadString('FTP', 'Adresse', '81.252.170.218');
      ElSimpleSFTPClient.Username := FichierINI.ReadString('FTP', 'Utilisateur', 'prodtalendits');
      ElSimpleSFTPClient.Password := FichierINI.ReadString('FTP', 'Mdp', 'GY9tSpjPEAdldG5AXX80');
      FRepertoireFTP := FichierINI.ReadString('FTP', 'Chemin', '/PROD/RAL/');
      if RightStr(FRepertoireFTP, 1) <> '/' then
        FRepertoireFTP := FRepertoireFTP + '/';

      if not FichierINI.ValueExists('FTP', 'Adresse') then
        FichierINI.WriteString('FTP', 'Adresse', '81.252.170.218');
      if not FichierINI.ValueExists('FTP', 'Utilisateur') then
        FichierINI.WriteString('FTP', 'Utilisateur', 'prodtalendits');
      if not FichierINI.ValueExists('FTP', 'Mdp') then
        FichierINI.WriteString('FTP', 'Mdp', 'GY9tSpjPEAdldG5AXX80');
      if not FichierINI.ValueExists('FTP', 'Chemin') then
        FichierINI.WriteString('FTP', 'Chemin', '/PROD/RAL/');
   finally
      FichierINI.Free;
   end;

   if not FileExists(String(IB_Connection.DatabaseName)) then
   begin
      AjoutLog('# Erreur :  la base [' + String(IB_Connection.DatabaseName) + '] n''existe pas !');
      Halt;
   end;

   FListeArticlesCB := TObjectList<TArticleCB>.Create;
end;

procedure TMainForm.PurgeLogs;
var
   sr: TSearchRec;
begin
   if SysUtils.FindFirst(ExtractFilePath(Application.ExeName) + 'Logs\*.log', faAnyFile, sr) = 0 then
   begin
      repeat
         if(sr.Name <> '.') and (sr.Name <> '..') then
         begin
            if(sr.Attr and faDirectory) <> faDirectory then
            begin
               if CompareDate(sr.TimeStamp, IncMonth(Date, -1)) = LessThanValue then
                  DeleteFile(sr.Name);
            end;
         end;
      until FindNext(sr) <> 0;
      FindClose(sr);
   end;
end;

procedure TMainForm.AjoutLog(const sLigne: String);
var
   F: TextFile;
begin
   AssignFile(F, FFichierLog);
   try
      if FileExists(FFichierLog) then
         Append(F)
      else
         Rewrite(F);
      Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + sLigne);
   finally
      CloseFile(F);
   end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
   PostMessage(Handle, WM_TRAITEMENT, 0, 0);
end;

procedure TMainForm.Executer(var msg: TMessage);
begin
   // Traitement et envoi FTP.
   Traitement;
   Close;
end;

procedure TMainForm.Traitement;
var
   F: TextFile;
   sFichierRAL, sLigne: String;
   nNbLignes: Integer;
   nDebut: Cardinal;
begin
   // Connexion.
   AjoutLog('Connexion ...');
   LabelEtape.Caption := 'Connexion ...';      Application.ProcessMessages;
   IB_Connection.Close;
   try
      IB_Connection.Open;
   except
      on E: Exception do
      begin
         AjoutLog('# Erreur :  la connexion à la base a échoué !' + #13#10 + E.Message);
         Exit;
      end;
   end;
   LabelEtape.Caption := 'Recherche ...';      Application.ProcessMessages;
   AjoutLog('Début traitement.');

   // RAL.
   Query.Close;
   Query.SQL.Clear;
   Query.SQL.Add('select MAG_CODEADH, ART_REFMRK, MRK_NOM, ART_NOM, COU_NOM, TGF_NOM, CDE_DATE, CDE_NUMERO, CDE_NUMFOURN,');
   Query.SQL.Add('CDL_QTE, RAL_QTE, (RAL_QTE * CDL_PXACHAT) VAL_RAL,');
   Query.SQL.Add('(select ANL_QTE from COMANNULL join K KANL on (KANL.K_ID = ANL_ID and KANL.K_ENABLED = 1) where ANL_CDLID = COMBCDEL.CDL_ID) QTE_ANN,');
   Query.SQL.Add('CDL_LIVRAISON, ARF_ID');
   Query.SQL.Add('from AGRRAL');
   Query.SQL.Add('join COMBCDEL on (RAL_CDLID = CDL_ID)');
   Query.SQL.Add('join K KCDL on (KCDL.K_ID = CDL_ID and KCDL.K_ENABLED = 1)');
   Query.SQL.Add('join COMBCDE on (CDL_CDEID = CDE_ID)');
   Query.SQL.Add('join ARTARTICLE on (CDL_ARTID = ART_ID)');
   Query.SQL.Add('join ARTMARQUE on (ART_MRKID = MRK_ID)');
   Query.SQL.Add('join PLXCOULEUR on (CDL_COUID = COU_ID)');
   Query.SQL.Add('join PLXTAILLESGF on (CDL_TGFID = TGF_ID)');
   Query.SQL.Add('join GENMAGASIN on (CDE_MAGID = MAG_ID)');
   Query.SQL.Add('join ARTREFERENCE on (ART_ID = ARF_ARTID)');
   Query.SQL.Add('where RAL_ID <> 0');
   try
      Query.Open;
   except
      on E: Exception do
      begin
         AjoutLog('# Erreur :  la recherche du RAL a échoué !' + #13#10 + E.Message);
         Exit;
      end;
   end;
   if Query.IsEmpty then
      AjoutLog('>> Pas de RAL trouvé.')
   else
   begin
      sFichierRAL := ExtractFilePath(Application.ExeName) + 'Export\RESTE_A_LIVRER_' + FormatDateTime('YYYYMMDD', Now) + '.tmp';
      AssignFile(F, sFichierRAL);
      try
         Rewrite(F);
         Writeln(F, 'code_magasin; code_ean; ref_fournisseur; article; couleur; date_commande; num_commande; quantite_commande; quantite_ral; valeur_ral; quantite_ann; date_livraison');
         nNbLignes := 0;
         nDebut := GetTickCount;

         Query.First;
         while not Query.Eof do
         begin
            Inc(nNbLignes);
            if(nDebut + 1000) <= GetTickCount then
            begin
               LabelEtape.Caption := 'Traitement [' + FormatFloat(',##0', nNbLignes) + ' ' + IfThen(nNbLignes > 1, 'lignes', 'ligne') + ']  ARF_ID = ' + Query.FieldByName('ARF_ID').AsString + ' ...';
               LabelNbListe.Caption := FormatFloat(',##0', FListeArticlesCB.Count);
               Application.ProcessMessages;
               nDebut := GetTickCount;
            end;

            sLigne := Query.FieldByName('MAG_CODEADH').AsString;
            sLigne := sLigne + ';' + CBFournisseurs(Query.FieldByName('ARF_ID').AsInteger);
            sLigne := sLigne + ';' + Query.FieldByName('ART_REFMRK').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('ART_NOM').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('COU_NOM').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('CDE_DATE').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('CDE_NUMFOURN').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('CDL_QTE').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('RAL_QTE').AsString;
            sLigne := sLigne + ';' + Query.FieldByName('VAL_RAL').AsString;
            sLigne := sLigne + ';' + IfThen(Query.FieldByName('QTE_ANN').IsNull, '0', Query.FieldByName('QTE_ANN').AsString);
            sLigne := sLigne + ';' + Query.FieldByName('CDL_LIVRAISON').AsString;
            Writeln(F, sLigne);

            Query.Next;
         end;
      finally
         CloseFile(F);
      end;

      AjoutLog('Fin génération fichier.');
      AjoutLog('   Nb lignes :  ' + FormatFloat(',##0', nNbLignes));
      AjoutLog('   Liste :  ' + FormatFloat(',##0', FListeArticlesCB.Count));

      // Envoi FTP.
      if EnvoiFTP(sFichierRAL) then
      begin
         if not FConserverFichierLocal then
         begin
            if not DeleteFile(sFichierRAL) then
               AjoutLog('# Erreur :  la suppression du fichier local [' + sFichierRAL + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
         end;
      end
      else      // Erreur FTP.
      begin
        if MoveFile(PWideChar(sFichierRAL), PWideChar(ExtractFilePath(Application.ExeName) + 'Export\Erreurs\' + ExtractFileName(sFichierRAL))) then
           AjoutLog('>> Fichier local [' + ExtractFilePath(Application.ExeName) + 'Export\Erreurs\' + ExtractFileName(sFichierRAL) + '] conservé.')
        else
        begin
           AjoutLog('# Erreur :  le déplacement du fichier local dans le sous-répertoire [' + ExtractFilePath(Application.ExeName) + 'Export\Erreurs\] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
           AjoutLog('>> Fichier local [' + sFichierRAL + '] conservé.');
        end;
      end;
   end;

   AjoutLog('Fin traitement.');
   LabelEtape.Caption := 'Fin traitement.';      Application.ProcessMessages;
end;

function TMainForm.CBFournisseurs(const nARFID: Integer): String;
var
   i: Integer;
begin
   Result := '';

   for i:=0 to Pred(FListeArticlesCB.Count) do
   begin
      if FListeArticlesCB[i].FArfID = nARFID then
      begin
         Result := FListeArticlesCB[i].FListeCB;
         Exit;
      end;
   end;

   // Recherche CB fournisseurs.
   QueryCB.Close;
   QueryCB.SQL.Clear;
   QueryCB.SQL.Add('select CBI_CB');
   QueryCB.SQL.Add('from ARTCODEBARRE');
   QueryCB.SQL.Add('join K on (K_ID = CBI_ID and K_ENABLED = 1)');
   QueryCB.SQL.Add('where CBI_ARFID = :ARFID');
   QueryCB.SQL.Add('and CBI_TYPE = 3');
   try
      QueryCB.ParamByName('ARFID').AsInteger := nARFID;
      QueryCB.Open;
   except
      on E: Exception do
      begin
         AjoutLog('# Erreur :  la recherche des CB fournisseurs (ARFID = ' + IntToStr(nARFID) + ') a échoué !' + #13#10 + E.Message);
         Exit;
      end;
   end;
   if not QueryCB.IsEmpty then
   begin
      QueryCB.First;
      while not QueryCB.Eof do
      begin
         Result := Result + IfThen(Result <> '', '|') + QueryCB.FieldByName('CBI_CB').AsString;
         QueryCB.Next;
      end;

      FListeArticlesCB.Add(TArticleCB.Create(nARFID, Result));
   end;
end;

function TMainForm.EnvoiFTP(const sFichier: String): Boolean;
const
   SSH_AUTH_TYPE_PUBLICKEY = 2;
var
   sFichierTempFTP, sFichierCSVFTP: String;
begin
   Result := False;
   AjoutLog('Envoi FTP :');
   LabelEtape.Caption := 'Envoi FTP ...';      Application.ProcessMessages;
   if ElSimpleSFTPClient.Active then
      ElSimpleSFTPClient.Close(True);

   // Connexion SFTP.
   AjoutLog('   Connexion ...');
   ElSimpleSFTPClient.AuthenticationTypes := ElSimpleSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
   try
      ElSimpleSFTPClient.Open;
   except
      on E: Exception do
      begin
         AjoutLog('   # Échec de la connexion :  ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
         Exit;
      end;
   end;
   try
      sFichierTempFTP := FRepertoireFTP + ExtractFileName(sFichier);
      sFichierCSVFTP := FRepertoireFTP + ChangeFileExt(ExtractFileName(sFichier), '.csv');

      // Tests répertoire - fichier.
      try
         if ElSimpleSFTPClient.DirExists(FRepertoireFTP) then
         begin
            // Si fichier temporaire déjà présent.
            if ElSimpleSFTPClient.FileExists(sFichierTempFTP) then
            begin
               AjoutLog('   Fichier temporaire [' + sFichierTempFTP + '] déjà présent sur le FTP !');

               // Suppression du fichier temporaire.
               try
                  ElSimpleSFTPClient.RemoveFile(sFichierTempFTP);
               except
                  on E: Exception do
                  begin
                     AjoutLog('   # Échec de la suppression du fichier FTP [' + sFichierTempFTP + ']:  ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
                     Exit;
                  end;
               end;

               AjoutLog('   >> Fichier supprimé sur le FTP.');
            end;

            // Si fichier CSV déjà présent.
            if ElSimpleSFTPClient.FileExists(sFichierCSVFTP) then
            begin
               AjoutLog('   Fichier CSV [' + sFichierCSVFTP + '] déjà présent sur le FTP !');

               // Suppression du fichier CSV.
               try
                  ElSimpleSFTPClient.RemoveFile(sFichierCSVFTP);
               except
                  on E: Exception do
                  begin
                     AjoutLog('   # Échec de la suppression du fichier FTP [' + sFichierCSVFTP + ']:  ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
                     Exit;
                  end;
               end;

               AjoutLog('   >> Fichier supprimé sur le FTP.');
            end;

            // Transfert fichier.
            try
               AjoutLog('   Transfert fichier [' + sFichier + '] vers [' + sFichierTempFTP + '] ...');
               ElSimpleSFTPClient.UploadFile(sFichier, sFichierTempFTP);
            except
               on E: Exception do
               begin
                  AjoutLog('   # Échec du transfert :  ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
                  Exit;
               end;
            end;
            // Renommage fichier.
            try
               ElSimpleSFTPClient.RenameFile(sFichierTempFTP, sFichierCSVFTP);
            except
               on E: Exception do
               begin
                  AjoutLog('   # Échec du renommage :  ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
                  Exit;
               end;
            end;

            Result := True;
         end
         else
            AjoutLog('   # Le répertoire FTP [' + FRepertoireFTP + '] n''existe pas !');
      except
         on E: Exception do
         begin
            AjoutLog('   # Échec du test du répertoire FTP [' + FRepertoireFTP + '] ou du fichier : ' + E.Message + #13#10 + 'Code :  ' + IntToStr(ElSimpleSFTPClient.LastSyncError) + ' - Erreur :  ' + ElSimpleSFTPClient.LastSyncComment);
            Exit;
         end;
      end;
   finally
      if ElSimpleSFTPClient.Active then
      begin
         AjoutLog('   Déconnexion.');
         ElSimpleSFTPClient.Close(True);
      end;
   end;
end;

procedure TMainForm.ElSimpleSFTPClientKeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
begin
  Validate := True;
end;

procedure TMainForm.ElSimpleSFTPClientProgress(Sender: TObject; Total, Current: Int64; var Cancel: Boolean);
begin
  LabelEtape.Caption := 'Envoi FTP [' + FormatFloat(',##0', Current) + ' / ' + FormatFloat(',##0', Total) + '] ...';
  Application.ProcessMessages;
end;

procedure TMainForm.ElSimpleSFTPClientError(Sender: TObject; ErrorCode: Integer);
const
  ERROR_SSH_INVALID_IDENTIFICATION_STRING = 1;
  ERROR_SSH_INVALID_VERSION = 2;
  ERROR_SSH_INVALID_MESSAGE_CODE = 3;
  ERROR_SSH_INVALID_CRC = 4;
  ERROR_SSH_INVALID_PACKET_TYPE = 5;
  ERROR_SSH_INVALID_PACKET = 6;
  ERROR_SSH_UNSUPPORTED_CIPHER = 7;
  ERROR_SSH_UNSUPPORTED_AUTH_TYPE = 8;
  ERROR_SSH_INVALID_RSA_CHALLENGE = 9;
  ERROR_SSH_AUTHENTICATION_FAILED = 10;
  ERROR_SSH_INVALID_PACKET_SIZE = 11;
  ERROR_SSH_HOST_NOT_ALLOWED_TO_CONNECT = 101;
  ERROR_SSH_PROTOCOL_ERROR = 102;
  ERROR_SSH_KEY_EXCHANGE_FAILED = 103;
  ERROR_SSH_INVALID_MAC = 105;
  ERROR_SSH_COMPRESSION_ERROR = 106;
  ERROR_SSH_SERVICE_NOT_AVAILABLE = 107;
  ERROR_SSH_PROTOCOL_VERSION_NOT_SUPPORTED = 108;
  ERROR_SSH_HOST_KEY_NOT_VERIFIABLE = 109;
  ERROR_SSH_CONNECTION_LOST = 110;
  ERROR_SSH_APPLICATION_CLOSED = 111;
  ERROR_SSH_TOO_MANY_CONNECTIONS = 112;
  ERROR_SSH_AUTH_CANCELLED_BY_USER = 113;
  ERROR_SSH_NO_MORE_AUTH_METHODS_AVAILABLE = 114;
  ERROR_SSH_ILLEGAL_USERNAME = 115;
  ERROR_SSH_INTERNAL_ERROR = 200;
  ERROR_SSH_NOT_CONNECTED = 222;
  ERROR_SSH_CONNECTION_CANCELLED_BY_USER = 501;
  ERROR_SSH_FORWARD_DISALLOWED = 502;
  ERROR_SSH_ONKEYVALIDATE_NOT_ASSIGNED = 503;
  ERROR_SSH_GSSKEX_SERVER_ERROR_MESSAGE = 601;
  ERROR_SSH_GSSAPI_SERVER_ERROR_MESSAGE = 603;
  ERROR_SSH_TCP_CONNECTION_FAILED = 24577;
  ERROR_SSH_TCP_BIND_FAILED = 24578;
var
  sErreur: String;
begin
  sErreur := '# Erreur !';
  case ErrorCode of
    ERROR_SSH_INVALID_IDENTIFICATION_STRING:
      sErreur := 'Invalid identification string of SSH-protocol';

    ERROR_SSH_INVALID_VERSION:
      sErreur := 'Invalid or unsupported version';

    ERROR_SSH_INVALID_MESSAGE_CODE:
      sErreur := 'Unsupported message code';

    ERROR_SSH_INVALID_CRC:
      sErreur := 'Message CRC is invalid';

    ERROR_SSH_INVALID_PACKET_TYPE:
      sErreur := 'Invalid (unknown) packet type';

    ERROR_SSH_INVALID_PACKET:
      sErreur := 'Packet composed incorrectly';

    ERROR_SSH_UNSUPPORTED_CIPHER:
      sErreur := 'There is no cipher supported by both: client and server';

    ERROR_SSH_UNSUPPORTED_AUTH_TYPE:
      sErreur := 'Authentication type is unsupported';

    ERROR_SSH_INVALID_RSA_CHALLENGE:
      sErreur := 'The wrong signature during public key-authentication';

    ERROR_SSH_AUTHENTICATION_FAILED:
      sErreur := 'Authentication failed. There could be wrong password or something else';

    ERROR_SSH_INVALID_PACKET_SIZE:
      sErreur := 'The packet is too large';

    ERROR_SSH_HOST_NOT_ALLOWED_TO_CONNECT:
      sErreur := 'Connection was rejected by remote host';

    ERROR_SSH_PROTOCOL_ERROR:
      sErreur := 'Another protocol error';

    ERROR_SSH_KEY_EXCHANGE_FAILED:
      sErreur := 'Key exchange failed';

    ERROR_SSH_INVALID_MAC:
      sErreur := 'Received packet has invalid MAC';

    ERROR_SSH_COMPRESSION_ERROR:
      sErreur := 'Compression or decompression error';

    ERROR_SSH_SERVICE_NOT_AVAILABLE:
      sErreur := 'Service (sftp, shell, etc.) is not available';

    ERROR_SSH_PROTOCOL_VERSION_NOT_SUPPORTED:
      sErreur := 'Version is not supported';

    ERROR_SSH_HOST_KEY_NOT_VERIFIABLE:
      sErreur := 'Server key can not be verified';

    ERROR_SSH_CONNECTION_LOST:
      sErreur := 'Connection was lost by some reason';

    ERROR_SSH_APPLICATION_CLOSED:
      sErreur := 'User on the other side of connection closed application that led to disconnection';

    ERROR_SSH_TOO_MANY_CONNECTIONS:
      sErreur := 'The server is overladen';

    ERROR_SSH_AUTH_CANCELLED_BY_USER:
      sErreur := 'User tired of invalid password entering';

    ERROR_SSH_NO_MORE_AUTH_METHODS_AVAILABLE:
      sErreur := 'There are no more methods for user authentication';

    ERROR_SSH_ILLEGAL_USERNAME:
      sErreur := 'There is no user with specified username on the server';

    ERROR_SSH_INTERNAL_ERROR:
      sErreur := 'Internal error of implementation';

    ERROR_SSH_NOT_CONNECTED:
      sErreur := 'There is no connection but user tries to send data';

    ERROR_SSH_CONNECTION_CANCELLED_BY_USER:
      sErreur := 'The connection was cancelled by user';

    ERROR_SSH_FORWARD_DISALLOWED:
      sErreur := 'SSH forward disallowed';

    ERROR_SSH_ONKEYVALIDATE_NOT_ASSIGNED:
      sErreur := 'The event handler for OnKeyValidate event, has not been specified by the application';

    ERROR_SSH_GSSKEX_SERVER_ERROR_MESSAGE:
      sErreur := 'GSS KEX server error.';

    ERROR_SSH_GSSAPI_SERVER_ERROR_MESSAGE:
      sErreur := 'GSS API server error.';

    ERROR_SSH_TCP_CONNECTION_FAILED:
      sErreur := 'TCP connection failed. This error code defined in SBSSHForwarding unit.';

    ERROR_SSH_TCP_BIND_FAILED:
      sErreur := 'TCP bind failed. This error code defined in SBSSHForwarding unit.';
  end;

  AjoutLog('   ' + sErreur);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   FListeArticlesCB.Free;
end;

initialization
  // Déclaration de la clef de license SecureBlackBox.
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

