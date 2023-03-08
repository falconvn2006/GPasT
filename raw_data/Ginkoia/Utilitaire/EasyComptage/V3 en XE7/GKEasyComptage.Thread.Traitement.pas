unit GKEasyComptage.Thread.Traitement;

interface

uses
  System.Classes,
  System.Types,
  System.IOUtils,
  System.SysUtils,
  System.DateUtils,
  System.Math,
  Data.DB,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Phys,
  FireDAC.Phys.IB,
  FireDAC.DApt,
  UMapping,
  ShellApi,
  GKEasyComptage.Ressources,
  GKEasyComptage.Methodes,
  IdComponent, uLog;

type
  TThreadTraitement = class(TThread)
  private
    { Déclarations privées }
    FConnexion        : TFDConnection;
//    FTrancheEnCours   : Integer;
    FParamsConnexion  : TParamsConnexion;
    FConfig           : TConfig;
//    Fichier           : TFileName;
    TraitementOk      : Boolean;
    function EcrireFichier(AList:TOblBoCaisse):boolean;
    function UploadFichier():boolean;
    procedure Status(AMessage: String);
    procedure EndUpload(ASender: TObject; AWorkMode: TWorkMode);
    procedure StartUpload(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
  protected
    { Déclarations protégées }
    procedure Execute(); override;

  public

    { Déclarations publiques }
    constructor Create(AConnexion: TFDConnection;
                       AParamsConnexion:TParamsConnexion;
                       AConfig:TConfig); reintroduce;
  end;

implementation

uses
  GKEasyComptage.Form.Main,
  IdFTP,IdFTPCommon;

{ TThreadTraitement }


constructor TThreadTraitement.Create(AConnexion: TFDConnection;AParamsConnexion:TParamsConnexion;AConfig:TConfig);
begin
   inherited Create(true);
   FConnexion:=AConnexion;
   FParamsConnexion:=AParamsConnexion;
   FConfig:=AConfig;
   FConnexion.Close();
   FConnexion.Params.Clear();
   FConnexion.Params.Add('Port=3050');
   FConnexion.Params.Add('DriverID=IB');
   FConnexion.Params.Add('User_Name=ginkoia');
   FConnexion.Params.Add('Password=ginkoia');
   FConnexion.Params.Add('Protocol=TCPIP');
   FConnexion.Params.Add(Format('Database=%s', [FParamsConnexion.BaseDonnees]));

   Log.App := 'easycomptage';
   Log.Inst := '';
   Log.Srv := '';
   Log.SendOnClose := True;
   Log.Open;
end;

procedure TThreadTraitement.Status(AMessage: String);
begin
  Synchronize(
    procedure
    begin
       FormMain.StbStatut.Panels[0].Text := AMessage;
       Journaliser(AMessage);
    end);
end;


function TThreadTraitement.EcrireFichier(AList:TOblBoCaisse):boolean;
var i:integer;
    FS: TFileStream;
    aStr: Ansistring;
    FileTmp:string;
    FileBoTxt:string;
    Succes:boolean;
    sDate:string;
    fNextAction:Integer;
begin
    result:=true;
    FormatSettings.DecimalSeparator:='.';
    FileBoTxt := FConfig.DestPath + '\Bocaisse.txt';
    FileTmp   := FConfig.DestPath + '\easycomptage.tmp';
    FS := TFileStream.Create(FileTmp, fmCreate);
    fNextAction := SecondsBetween(Now, FConfig.dNextAction) + 30;
    try
      try
        for i := 0 to AList.List.Count-1 do
          begin
              // 2 Types Possibles
              Case FConfig.iType of
                0: aStr := Format('%s;%s;%d;%d;%.2f;%d'+#13+#10, [
                        Alist.List.Items[i].sCodePDV,
                        Alist.List.Items[i].sDateJour,
                        Alist.List.Items[i].iNTranche,
                        Alist.List.Items[i].iNbTickets,
                        Alist.List.Items[i].fCa,
                        Alist.List.Items[i].iNbVendeurs
                         ]);
                1: aStr := Format('%s;%s;%d;%d;%.2f;%d;%d'+#13+#10, [
                        Alist.List.Items[i].sCodePDV,
                        Alist.List.Items[i].sDateJour,
                        Alist.List.Items[i].iNTranche,
                        Alist.List.Items[i].iNbTickets,
                        Alist.List.Items[i].fCa,
                        Alist.List.Items[i].iNbVendeurs,
                        Alist.List.Items[i].iNbArticles
                         ])
                Else
                   aStr :='';
                End;
            FS.Write(aStr[1], Length(aStr) * SizeOf(AnsiChar));
          end;
      except on E:Exception do
        begin
          result:=false;
          sDate := FormatDateTime('hh:nn:ss',Now());
          Status(Format('%s : Erreur à l''écriture du fichier %s',[sDate,FileTmp]));
          Log.Log('traitement', FConfig.GUID,'status','Erreur à l''écriture du fichier ' + FileTmp, logError, False, fNextAction, ltServer);
        end;
      end;
  finally
    // Libération du fichier
    FS.Free;
  end;
  i:=0;
  if result then
    begin
        Succes:=false;
        while (i<3) and not(Succes) do
          begin
               Try
                   TFile.Copy(PChar(FileTmp),PChar(FileBoTxt),true);
                   Succes:=true;
                   if FConfig.FtpActif = 1 then
                     UploadFichier;
               Except on E:Exception do
                  begin
                     // pas réussi, pas grave
                     sDate := FormatDateTime('hh:nn:ss',Now());
                     Status(Format('%s : Erreur à l''écriture du fichier %s',[sDate,FileBoTxt]));
                     Log.Log('traitement', FConfig.GUID,'status','Erreur à l''écriture du fichier ' + FileBoTxt, logError, False, fNextAction, ltServer);
                     result:=false;
                  end;
                End;
                inc(i);
          end;
    end;
end;

function TThreadTraitement.UploadFichier():boolean;
var
  FileFtp, FileBoTxt, FileFtpName, DossierOk, DossierEchec:string;
  sDate:string;
  vFtp:TIdFTP;
  vFileStream:TFileStream;
  fNextAction:Integer;
begin
  result:=true;
  FormatSettings.DecimalSeparator:='.';
  FileBoTxt := FConfig.DestPath + '\Bocaisse.txt';
  FileFtpName := 'Bocaisse_' + FConfig.CodeAdh + '_' + FormatDateTime('yyyymmddhhnnss', Now) + '.txt';
  FileFtp   := FConfig.DestPath + '\FTP\' + FileFtpName;
  DossierOk := FConfig.DestPath + '\FTP\OK\' + FormatDateTime('yyyy\mm\dd\', Now);
  DossierEchec := FConfig.DestPath + '\FTP\ECHEC\' + FormatDateTime('yyyy\mm\dd\', Now);
  fNextAction := SecondsBetween(Now, FConfig.dNextAction) + 30;
  Try
    ForceDirectories(ExtractFileDir(FileFtp));
    TFile.Copy(PChar(FileBoTxt),PChar(FileFtp),true);
    vFtp := TIdFTP.Create;
    try
      try
        vFtp.OnWorkBegin := StartUpload;
        vFtp.OnWorkEnd := EndUpload;

        vFtp.Host := FConfig.FtpUrl;
        vFtp.UserName := FConfig.FtpLogin;
        vFtp.Password := FConfig.FtpMdp;
        vFtp.TransferType := TIdFTPTransferType.ftBinary;
        vFtp.Passive := true;
        vFtp.Connect();
        Status('Connexion au FTP [OK]');
        if (FConfig.FtpDossier <> '/') and (FConfig.FtpDossier <> '') then
          vFtp.ChangeDir(FConfig.FtpDossier);

        vFileStream := TFileStream.Create(FileFtp, fmOpenRead);
        Status(Format('Debut upload du fichier %s', [FileFtpName]));
        Log.Log('ftp', FConfig.GUID,'status','Debut upload du fichier ' + FileFtpName, logNotice, True, fNextAction, ltServer);
        vFtp.Put(vFileStream, FileFtpName);
        vFileStream.Free;

        ForceDirectories(DossierOk);
        TFile.Copy(PChar(FileFtp),PChar(DossierOk + FileFtpName),true);
        Status(Format('Deplacement du fichier %s dans le dossier OK', [FileFtpName]));
        TFile.Delete(FileFtp);
        Log.Log('ftp', FConfig.GUID,'status','Fin upload du fichier ' + FileFtpName, logInfo, False, fNextAction, ltServer);
      except on E:Exception do
        begin
          Status(Format('Erreur d''upload %s',[E.Message]));
          Log.Log('ftp', FConfig.GUID, 'status', 'Erreur d''upload : ' + E.Message, logError, False, fNextAction, ltServer);
          ForceDirectories(DossierEchec);
          TFile.Copy(PChar(FileFtp),PChar(DossierEchec + FileFtpName),true);
          Status(Format('Deplacement du fichier dans le dossier ECHEC', [FileFtpName]));
          TFile.Delete(FileFtp);
        end;
      end;
    finally
      vFtp.Quit;
      vFtp.Free;
    end;
  Except on E:Exception do
    begin
       sDate := FormatDateTime('hh:nn:ss',Now());
       Status(Format('%s : Erreur à l''écriture du fichier %s',[sDate,FileFtp]));
       Log.Log('ftp', FConfig.GUID, 'status', 'Erreur à l''écriture du fichier : ' + FileFtp + ' - ' + E.Message, logError, False, fNextAction, ltServer);
       result:=false;
    end;
  End;
end;

procedure TThreadTraitement.EndUpload(ASender: TObject; AWorkMode: TWorkMode);
begin
  Status('Upload du fichier terminé');
end;

procedure TThreadTraitement.StartUpload(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  Status('Upload du fichier  en cours');
end;

procedure TThreadTraitement.Execute();
var
  dDate : TDate;
  i               : Integer;
//  sCodeAdh        : String;
  IbQuery         : TFDQuery;
  ListBo          : TOblBoCaisse;
  AList           : TObjList;
  ALigne          : TBoCaisse;
  Debut,Fin       : string;
//  fProchain       : integer;
  bMapping        : byte;
  fNextAction     : Integer;
begin
    Debut := FormatDateTime('hh:nn:ss',Now());
    IbQuery:= TFDQuery.Create(nil);
    ListBo := TOblBoCaisse.Create();
    AList  := TObjList.Create(True);

    FConfig.dNextAction := CalculNextAction;
    fNextAction := SecondsBetween(Now, FConfig.dNextAction) + 30;
    try
       try
          bMapping:=Mapping;
          if bMapping<>0 then
            begin
               TraitementOk := False;
               Log.Log('traitement', FConfig.GUID,'status',RS_ERR_TRAITEMENT + ErrorMapping(bMapping), logWarning, True, fNextAction, ltServer);
               raise EErreurIBTraitement.Create(RS_ERR_TRAITEMENT + ErrorMapping(bMapping));
            end;

          IbQuery.Connection := FConnexion;
          IbQuery.Close();
          IbQuery.Connection.Open();

          IbQuery.SQL.Clear;
          IbQuery.SQL.Add(' SELECT SUM(TKL_PXNN * TKL_QTE) AS CA ,');
          IbQuery.SQL.Add('        SUM(TKL_QTE) AS NBARTICLES, ');
          IbQuery.SQL.Add('        TKE_USRID, ');
          IbQuery.SQL.Add('        TKE_ID, ');
          IbQuery.SQL.Add('        TKE_DATE ');
          IbQuery.SQL.Add(' FROM CSHTICKETL ');
          IbQuery.SQL.Add('   JOIN K ON (K_ID = TKL_ID AND K_ENABLED=1) ');
          IbQuery.SQL.Add('   JOIN CSHTICKET ON (TKE_ID = TKL_TKEID)    ');
          IbQuery.SQL.Add('   JOIN K ON (K_ID = TKE_ID AND K_ENABLED=1) ');
          IbQuery.SQL.Add('   JOIN CSHSESSION ON (SES_ID = TKE_SESID)   ');
          IbQuery.SQL.Add('   JOIN GENPOSTE ON (SES_POSID = POS_ID AND POS_MAGID=:MAGID ) ');
          IbQuery.SQL.Add(' WHERE TKE_DATE BETWEEN :DATEDEBUT AND CURRENT_TIMESTAMP');
          IbQuery.SQL.Add(' AND TKL_SSTOTAL=0 ');
          IbQuery.SQL.Add(' GROUP BY TKE_USRID, TKE_ID, TKE_DATE ');
          IbQuery.SQL.Add(' ORDER BY TKE_DATE ');
          IbQuery.ParamByName('MAGID').asinteger:=FConfig.MAGID;
          IbQuery.ParamByName('DATEDEBUT').asDateTime:= Floor(Now()- FConfig.Jours + 1 );
          IbQuery.open();
          Status('Recupération des données');
          Log.Log('traitement', FConfig.GUID,'status','Recupération des données', logNotice, True, fNextAction, ltBoth);
          // Traitement séquentiel de la requete...
          // Remplissage de l'objet

          dDate:=Floor(Now()- FConfig.Jours + 1 );
          for i := 0 to (FConfig.Jours)*96 -1 do
            begin
                ALigne := TBoCaisse.Create();
                ALigne.sCodePDV := FConfig.CodeAdh;
                ALigne.sDateJour := ShortString(FormatDateTime('yyyymmdd',dDate));
                ALigne.iNTranche := i Mod 96 + 1;
                Aligne.iNbTickets:=0;
                Aligne.fCA:=0;
                Aligne.iNbArticles:=0;
                Aligne.iNbVendeurs:=0;
                SetLength(Aligne.aVendeurs,0);
                AList.Add(ALigne);
                dDate := incMinute(dDate,15);
            end;
          //
          ListBo.List:=Alist;
          IbQuery.First;
          Status('Construction...');
          i:=0;
          while not(IbQuery.eof) do
            begin
                ListBo.MAJLigne(TDataSet(IbQuery));
                IbQuery.Next;
            end;
          //***/
          If EcrireFichier(ListBo)
            then
                begin
                     Fin := FormatDateTime('hh:nn:ss',Now());
                     Status(Format('[%s - %s] Traitement terminé',[Debut,Fin]));
                     Log.Log('traitement', FConfig.GUID,'status','Traitement terminé', logInfo, False, fNextAction, ltServer);
                end
            else
                raise Exception.Create('Impossible d''écrire le fichier');
          except
            on E: Exception do
               begin
                   Fin := FormatDateTime('hh:nn:ss',Now());
                   Status(Format('%s : Erreur lors du traitement : %s',[Fin, E.Message]));
                   Log.Log('traitement', FConfig.GUID,'status','Erreur lors du traitement : ' + E.Message, logError, False, fNextAction, ltServer);
               end;
    end;
  finally
    IbQuery.Close;
    IF IbQuery.Connection.Connected
      then IbQuery.Connection.Close();
    IbQuery.Free;
    Alist.Free;
    ListBo.Free;
  end;
end;


end.
