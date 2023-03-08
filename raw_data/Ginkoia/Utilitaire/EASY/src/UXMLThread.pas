unit UXMLThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UBaseThread,
  UGinkoiaThread,
  uCreateProcess;

type
  TXMLThread = class(TBaseGinkoiaThread)
  protected
    FBasePath : string;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BasePath : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    function GetErrorLibelle(ret : integer) : string; override;
  end;


implementation

uses
  Winapi.ActiveX,
  System.SysUtils,
  System.IniFiles,
  System.Math,
  Xml.XMLIntf,
  Xml.XMLDoc,
  uFileUtils,
  uGestionBDD;

{ TXMLThread }

procedure TXMLThread.Execute();

  procedure ChangeXMLValue(Tag, Valeur: string; var Text : string);
  var
    i : Integer;
  begin
    while pos('<' + Tag + '>', Text) > 0 do
    begin
      i := pos('<' + Tag + '>', Text);
      Delete(Text, i, length('<' + Tag + '>'));
      while Text[i] <> '<' do
        Delete(Text, i, 1);
      Insert('<@@>' + Valeur, Text, I);
    end;
    while pos('<@@>', Text) > 0 do
    begin
      i := pos('<@@>', Text);
      Delete(Text, i, length('<@@>'));
      Insert('<' + Tag + '>', Text, I);
    end;
  end;

// code de retour :
// 0 - reussite
// 1 - pas de repertoire/fichier
// 2 - Erreur de Téléchargement du fichier
// 3 - Erreur de récupération des information de la base
// 4 - Exception
// 5 - Autre erreur
const
  FILE_PROVIDERS = 'EAI\DelosQPMAgent.Providers.xml';
  FILE_SUBSCRIPTIONS = 'EAI\DelosQPMAgent.Subscriptions.xml';
  FILE_INITPARAMS = 'EAI\DelosQPMAgent.InitParams.xml';
  URL_BATCH = 'Batch';
  URL_EXTRACT = 'Extract';
  URL_GETCURRENTVERSION = 'GetCurrentVersion';
  URL_INSERTLOG = 'InsertLOG';
var
  DestPath : string;
  ini : TIniFile;
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Query : TMyQuery;
  Res : integer;

  PlagePantin, PlageMagasin, BasSender, NomDossier, URLReplic : string;
  GenIdMag, GenIdPantin : integer;
  XmlFile : TStringList;
  XmlText : string;
begin
  ReturnValue := 5;
  ProgressStyle(pbstMarquee);

  PlagePantin := '';
  PlageMagasin := '';
  BasSender := '';
  NomDossier := '';
  URLReplic := '';
  GenIdMag := 0;
  GenIdPantin := 0;

  try
    ProgressInit(5);

    if DirectoryExists(FBasePath) and FileExists(FBasePath + CST_EXENAME_GINKOIA) then
    begin
      try
        DestPath := GetTempDirectory();
        ForceDirectories(DestPath);

        // recup du fichier de definition !
        if DownloadHTTP(URL_SERVEUR_MAJ + '/maj/GINKOIA/recupbase.ini', IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini') then
        begin
          try
            Ini := TIniFile.Create(IncludeTrailingPathDelimiter(DestPath) + 'recupbase.ini');

            // Gestion des fichiers XML de l'installation
            try
              Connexion := GetNewConnexion(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort, false);
              Transaction := GetNewTransaction(Connexion, false);

              Connexion.Open();
              Transaction.StartTransaction();

              try
                Query := GetNewQuery(Connexion, Transaction);

                DoLog('/******************************************************************************/');
                ProgressStepLbl('Gestion des fichiers XML');
                DoLog('');

                ProgressStepLbl('Récupération du numero de base');

                // recupération du numero de base
                Query.SQL.Text := 'select cast(par_string as integer) as nummagasin from genparambase where par_nom = ''IDGENERATEUR'';';
                try
                  Query.Open();
                  if Query.Eof then
                  begin
                    ReturnValue := 3;
                    Exit;
                  end
                  else
                    FIdentBase := Query.FieldByName('nummagasin').AsInteger;
                finally
                  Query.Close();
                end;

                ProgressStepIt();
                DoLog('  -> ' + IntToStr(FIdentBase));
                ProgressStepLbl('Récupération des plages');

                // recupération des plages
                Query.SQL.Text := 'select cast(bas_ident as integer) as nummagasin, bas_plage, bas_sender, bas_nompournous, '
                                   + '       rep_urldistant '
                                   + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                                   + 'join genlaunch join k on k_id = lau_id and k_enabled = 1 on lau_basid = bas_id '
                                   + 'join genreplication join k on k_id = rep_id and k_enabled = 1 on rep_lauid = lau_id '
                                   + 'where bas_id != 0 and bas_ident in (''0'', ' + QuotedStr(IntToStr(FIdentBase)) + ');';
                try
                  Query.Open();
                  if Query.Eof then
                  begin
                    ReturnValue := 3;
                    Exit;
                  end
                  else
                  begin
                    while not Query.Eof do
                    begin
                      case Query.FieldByName('nummagasin').AsInteger of
                        0 : PlagePantin := Query.FieldByName('bas_plage').AsString;
                        else
                          begin
                            PlageMagasin := Query.FieldByName('bas_plage').AsString;
                            BasSender := Query.FieldByName('bas_sender').AsString;
                            NomDossier := Query.FieldByName('bas_nompournous').AsString;
                            URLReplic := Query.FieldByName('rep_urldistant').AsString;
                          end;
                      end;
                      Query.Next();
                    end;
                  end;
                finally
                  Query.Close();
                end;

                DoLog('  -> Lame    : ' + PlagePantin);
                DoLog('  -> Magasin : ' + PlageMagasin);

                if (Trim(PlagePantin) = '') or
                   (Trim(PlageMagasin) = '') or
                   (Trim(BasSender) = '') or
                   (Trim(NomDossier) = '') or
                   (Trim(URLReplic) = '') then
                begin
                  ReturnValue := 3;
                  Exit;
                end;

                ProgressStepIt();
                DoLog('Génération des XML');

                try
                  XmlFile := TStringList.Create();

                  // Fichier de provider
                  GenIdMag := GetGenId(Query, PlageMagasin, ini);
                  ProgressStepLbl('Fichier de provider (IdMag : ' + IntToStr(GenIdMag) + ')');
                  if FileExists(FBasePath + FILE_PROVIDERS) then
                  begin
                    XmlFile.loadfromfile(FBasePath + FILE_PROVIDERS);
                    XmlText := XmlFile.text;
                    ChangeXMLValue('LAST_VERSION', Inttostr(GenIdMag), XmlText);
                    ChangeXMLValue('MIN_ID', '0', XmlText);
                    ChangeXMLValue('MAX_ID', '1000000000', XmlText);
                    ChangeXMLValue('Sender', BasSender, XmlText);
                    ChangeXMLValue('URL', URLReplic + URL_BATCH, XmlText);
                    ChangeXMLValue('Database', NomDossier, XmlText);
                    XmlFile.text := XmlText;
                    XmlFile.SaveTofile(FBasePath + FILE_PROVIDERS);
                  end;
                  ProgressStepIt();

                  // fichier de Souscription
                  GenIdPantin := GetGenId(Query, plagePantin, ini);
                  ProgressStepLbl('Fichier de souscription (IdPantin : ' + IntToStr(GenIdPantin) + ')');
                  if FileExists(FBasePath + FILE_SUBSCRIPTIONS) then
                  begin
                    XmlFile.loadfromfile(FBasePath + FILE_SUBSCRIPTIONS);
                    XmlText := XmlFile.text;
                    ChangeXMLValue('LAST_VERSION', Inttostr(GenIdPantin), XmlText);
                    ChangeXMLValue('Sender', BasSender, XmlText);
                    ChangeXMLValue('URL', URLReplic + URL_EXTRACT, XmlText);
                    ChangeXMLValue('GetCurrentVersion', URLReplic + URL_GETCURRENTVERSION, XmlText);
                    ChangeXMLValue('Database', NomDossier, XmlText);
                    XmlFile.text := XmlText;
                    XmlFile.SaveTofile(FBasePath + FILE_SUBSCRIPTIONS);
                  end;
                  ProgressStepIt();

                  // Fichier InitParams
                  ProgressStepLbl('Fichier de paramètre');
                  if FileExists(FBasePath + FILE_INITPARAMS) then
                  begin
                    XmlFile.loadfromfile(FBasePath + FILE_INITPARAMS);
                    XmlText := XmlFile.text;
                    ChangeXMLValue('QPM_BatchException', URLReplic + URL_INSERTLOG, XmlText);
                    ChangeXMLValue('QPM_ExtractException', URLReplic + URL_INSERTLOG, XmlText);
                    ChangeXMLValue('QPM_PullDone', URLReplic + URL_INSERTLOG, XmlText);
                    ChangeXMLValue('QPM_PullException', URLReplic + URL_INSERTLOG, XmlText);
                    ChangeXMLValue('QPM_PushDone', URLReplic + URL_INSERTLOG, XmlText);
                    ChangeXMLValue('QPM_PushException', URLReplic + URL_INSERTLOG, XmlText);
                    XmlFile.text := XmlText;
                    XmlFile.SaveTofile(FBasePath + FILE_INITPARAMS);
                  end;
                  ProgressStepIt();
                finally
                  FreeAndNil(XmlFile);
                end;

                Transaction.Commit();
              except
                Transaction.Rollback();
                raise;
              end;
            finally
              FreeAndNil(Query);
              FreeAndNil(Transaction);
              Connexion.Close();
              FreeAndNil(Connexion);
            end;
          finally
            FreeAndNil(ini);
          end;

          // ici ?
          ReturnValue := 0;
          DoLog('');
          DoLog('Traitement terminé avec succès.');
        end
        else
          ReturnValue := 2;
      finally
        // suppression du repertoire !
        DelTree(DestPath);
      end;
    end
    else
      ReturnValue := 1;
  except
    on e : Exception do
    begin
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
      ReturnValue := 4;
    end;
  end;
end;

constructor TXMLThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; BasePath : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FBasePath := BasePath;
end;

function TXMLThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'pas de repertoire/fichier dans le répertoir Ginkoia.';
    2 : Result := 'Erreur lors de la récupération du fichier des règles de recalcul.';
    3 : Result := 'Erreur de récupération des information de la base.';
    4 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

end.
