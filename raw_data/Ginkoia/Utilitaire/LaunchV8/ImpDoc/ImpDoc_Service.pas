unit ImpDoc_Service;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IdContext, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, ImpDoc_Types, Registry,
  ExtCtrls, uLogs, Main_DM, DB, IBODataset, GinkoiaResStr, ConvertorRv, EuGen,
  impDocFacture_DM, RapRv_Frm;

type
  TImpDoc_SRC = class(TService)
    IdTCPServer: TIdTCPServer;
    Tim_StartImp: TTimer;
    Que_ROTmp: TIBOQuery;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure IdTCPServerExecute(AContext: TIdContext);
    procedure Tim_StartImpTimer(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FListImp : TStringList;
    function GetPdfDirectory : String;

  public
    function GetServiceController: TServiceController; override;
    { Déclarations publiques }
  end;

var
  ImpDoc_SRC: TImpDoc_SRC;

implementation

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ImpDoc_SRC.Controller(CtrlCode);
end;


function TImpDoc_SRC.GetPdfDirectory: String;
begin
  With Que_ROTmp do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_STRING from GENPARAM');
    SQL.Add('  Join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = 9 and PRM_CODE = 302');
    Open;

    Result := FieldByName('PRM_STRING').AsString;
  Except on E:Exception do
    raise Exception.Create('GetPdfDirectory -> ' + E.Message);
  end;
end;

function TImpDoc_SRC.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TImpDoc_SRC.IdTCPServerExecute(AContext: TIdContext);
var
  sTmp : String;
begin
  Try
    // Ajout de l'action à la liste des traitements à faire
    sTmp := AContext.Connection.IOHandler.ReadLn;
    FListImp.Add(sTmp);
    if not WorkinProgress then
      Tim_StartImp.Enabled := True;
  Except on E:Exception do
    begin
      Logs.Path := GGKLOGS + FormatDatetime('YYYY\MM\',Now);
      if not DirectoryExists(Logs.Path) then
        ForceDirectories(Logs.Path);

      Logs.AddToLogs('TCP-Execute -> ' + E.Message);
    end;
  End;
end;

procedure TImpDoc_SRC.ServiceCreate(Sender: TObject);
begin
  Frm_RapRV := TFrm_RapRV.Create(Self);
  DM_ImpDocFacture := TDM_ImpDocFacture.Create(Self);
end;

procedure TImpDoc_SRC.ServiceDestroy(Sender: TObject);
begin
  Frm_RapRV.Free;
  DM_ImpDocFacture.Free;
end;

procedure TImpDoc_SRC.ServiceStart(Sender: TService; var Started: Boolean);
var
  Reg : TRegistry;
begin
  Try
    // Initialisation des répertoires
    Reg := TRegistry.Create(KEY_READ);
    try
       reg.RootKey    := HKEY_LOCAL_MACHINE;
       if reg.OpenKey('SOFTWARE\Algol\Ginkoia', False) then
       begin
        // Chemin de la base de données
        GIBPATH := Reg.ReadString('Base0'); // Ex: c:\ginkoia\data\ginkoia.ib
        // Chemin de ginkoia
        GGKPATH := ExtractFilePath(GIBPATH); // Ex: c:\ginkoia\data\
        GGKPATH := ExcludeTrailingPathDelimiter(GGKPATH); // ex: c:\ginkoia\data
        GGKPATH := ExtractFilePath(GGKPATH); // ex: c:\ginkoia\
       end
       else begin
         GIBPATH := 'c:\ginkoia\data\ginkoia.ib';
         GGKPATH := 'c:\ginkoia\';
       end;
    finally
      Reg.Free;
    end;
    GFACPATH := GGKPATH + 'BPL\';
    GGKLOGS := GGKPATH + 'Logs_Impdoc\';
    if not DirectoryExists(GGKLOGS) then
      ForceDirectories(GGKLOGS);

    FListImp := TStringList.Create;

    // Démarrage du Serveur TCP
    if not IdTCPServer.Active then
      IdTCPServer.Active := True;
    IdTCPServer.StartListening;

    // Initialisation des variables
    WorkInProgress := False;

    Logs.Path := GGKLOGS;
    Logs.FileName := 'ImpDoc-StartStopService' + FormatDateTime('YYYYMM',Now) + '.txt';
    Logs.AddToLogs('-----------------------------------------------------------');
    Logs.AddToLogs('Démarrage du service');
    Logs.AddToLogs('Répertoire Ginkoia : ' + GGKPATH);
    Logs.AddToLogs('Répertoire IB : ' + GIBPATH);
    Logs.AddToLogs('Répertoire Logs : ' + GGKLOGS);


    if FileExists(GGKLOGS + 'Temporary.lst') then
    begin
      Logs.AddToLogs('Chargement de la liste en attente');
      FListImp.LoadFromFile(GGKLOGS + 'Temporary.lst');
      Deletefile(GGKLOGS + 'Temporary.lst');
      Tim_StartImp.Enabled := True;
    end;

  Except on E:Exception do
    begin
      if not DirectoryExists('c:\GkServiceError\') then
        ForceDirectories('c:\GkServiceError\');

      Logs.Path := 'c:\GkServiceError\';
      Logs.FileName := 'StartService-ImpDoc' + FormatDateTime('YYYYMM',Now) + '.txt';
      Logs.AddToLogs('-------------------------------------');
      Logs.AddToLogs('Erreur lors du démarrage du service : ' + E.Message);
      Logs.AddToLogs('-------------------------------------');
    end;
  End;
end;

procedure TImpDoc_SRC.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  if FListImp.Count > 0 then
  begin
    Logs.AddToLogs('Sauvegader de la liste d''attente');
    FListImp.SaveToFile(GGKLOGS + 'Temporary.lst');
  end;

  Logs.Path := GGKLOGS;
  Logs.FileName := 'ImpDoc-StartStopService' + FormatDateTime('YYYYMM',Now) + '.txt';
  Logs.AddToLogs('Arrêt du service');
  Logs.AddToLogs('-----------------------------------------------------------');

  FListImp.Free;

  if IdTCPServer.Active then
    IdTCPServer.StopListening;
end;


procedure TImpDoc_SRC.Tim_StartImpTimer(Sender: TObject);
var
  PDFDir : String;
  FactureNum : String;
  SiteNom : String;
  PDFDirComplet : String;
begin
  Tim_StartImp.Enabled := False;

  Logs.Path := GGKLOGS + FormatDatetime('YYYY\MM\',Now);
  if not DirectoryExists(Logs.Path) then
    ForceDirectories(Logs.Path);
  Logs.FileName := 'ImpDoc-' + FormatDateTime('YYYYMMDD',Now) + '.txt';
  Logs.AddToLogs('<----------------------------------------------------->');
  Logs.AddToLogs('Tentative de connexion à la base de données');
  Try
    try
      dm_main.InitDatabase(GIBPATH, 'ginkoia','ginkoia');

      PDFDir := GetPdfDirectory;
      Logs.AddToLogs(' Chemin de dépôt des PDF : ' + PDFDir);
      Logs.AddToLogs('');

      if Trim(PDFDir) = '' then
        raise Exception.Create('Pas de chemin de dépôt paramétré');
      PDFDir := IncludeTrailingPathDelimiter(PDFDir);
      if not DirectoryExists(PDFDir) then
        raise Exception.Create('Le chemin n''existe pas ou le poste n''a pas accès au répertoire');

      Logs.AddToLogs('Début du traitement des impressions');
      Logs.AddToLogs('');
      while FListImp.Count > 0 do
      begin
        try
          case FListImp[0][1] of
            'F': begin // traitement des factures
              // Format FXXXXX;YYYYY
              // XXXXX = Id de la facture
              // YYYYY = Nom du site
              Logs.AddToLogs('Traitement de : ' + FListImp[0]);
              // Extraction de l'id de la facture
              FactureNum := Copy(FListImp[0],2,Pos(';', FListImp[0]) - 2);
              // Extraction du site de la facture
              SiteNom := Copy(FListImp[0],Pos(';',FListImp[0]) + 1, Length(FListImp[0]));
              // Génération du chemin de dépot de la facture
              PDFDirComplet := PDFDir + SiteNom + '\';
              if not DirectoryExists(PDFDirComplet) then
                ForceDirectories(PDFDirComplet);
              // Création de la facture
              DM_ImpDocFacture.ImprimeFactureKour(StrToInt(FactureNum), PDFDirComplet);
            end;
          end;
        Except on E:exception do
          Logs.AddToLogs('  -> Erreur : ' + FListImp[0] + ' - ' + E.Message);
        end;
        FListImp.Delete(0);
      end;
    finally
      dm_main.database.Close;
    end;
  Except on E:Exception do
    Logs.AddToLogs('TimSart -> ' + E.Message);
  End;
  Logs.AddToLogs('<----------------------------------------------------->');
end;

end.
