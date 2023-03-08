unit MSS_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, IB_Components, IB_Access, IBODataset, StdCtrls,
  //Start Uses Perso
  GestionJetonLaunch,
  //End Uses Perso
  MSS_Type, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StrUtils,
  IdExplicitTLSClientServerBase, IdFTP, xmldom, XMLIntf, msxmldom, XMLDoc, Variants,
  MSS_MainClass, MSS_BrandsClass, MSS_SuppliersClass, MSS_SizesClass, MSS_CollectionsClass,
  MSS_PeriodsClass, MSS_UniversCriteriaClass, MSS_FedasClass, MSS_CommandeClass, MSS_OrdDeleteClass,
  MSS_OpCommsClass, MSS_CorrespsizesClass, MSS_SDUpdateClass,
  ZipMstr19, ComCtrls, forms, wwDialog, wwidlg, IdMessage, IdMessageClient,
  IdSMTPBase, IdSMTP, HttpApp, IdText, IdAttachmentFile, MSS_DMDbMag, DateUtils, Types, Windows,
  DBClient, psApi, MidasLib, MSS_ReceptionClass, IdReplyRFC, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdIntercept,
  IdLogBase, IdLogFile, MSS_FedasUniversClass, MSS_SDUpdateCommunClass,
  uLog;

type
  TDM_MSS = class(TDataModule)
    GinkoiaIBDB: TIBODatabase;
    IdFTP: TIdFTP;
    XMLDoc: TXMLDocument;
    ZipMaster191: TZipMaster19;
    Que_MasterData: TIBOQuery;
    IBOTransaction: TIBOTransaction;
    stp_MasterData: TIBOStoredProc;
    Que_GroupData: TIBOQuery;
    stp_GroupData: TIBOStoredProc;
    Que_GenMagasin: TIBOQuery;
    lku_GenMagasin: TwwLookupDialog;
    IdMessage: TIdMessage;
    Que_Tmp: TIBOQuery;
    IbStProc_SetLoop: TIB_StoredProc;
    stp_ModifData: TIBOStoredProc;
    Que_ModifData: TIBOQuery;
    Que_UpdateDB: TIBOQuery;
    Que_TVAList: TIBOQuery;
    Que_MarqueList: TIBOQuery;
    Que_FournList: TIBOQuery;
    IdLogFile1: TIdLogFile;
    IdSMTP1: TIdSMTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    cds_Magasin: TClientDataSet;
    cds_MagasinMAG_ID: TIntegerField;
    cds_MagasinMAG_ENSEIGNE: TStringField;
    cds_MagasinNUMERO: TStringField;
    cds_MagasinMAG_TVTID: TIntegerField;
    cds_MagasinBAS_GUID: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FMemo: TMemo;
    FProgressBar : TProgressBar;
    FLabelProgress : TLabel;
    FFile : TFileStream;
    { Déclarations privées }
  public
    { Déclarations publiques }
    // Fonction principale de traitement
    function ExecuteProcess(DataBasePath : String = '';
      const Manual: Boolean = False) : Integer;

    // Ouverture de la base de données IB
    function OpenIBDatabase(ABasePath : String) : Boolean;
    // Ajout au Memo de logs et dans le fichier de logs
    procedure AddToMemo(AText : String);
    // fonction d'ouverture d'un FTP
    function OpenFTP (AFTPCFG : TFTPCFG) : Boolean;
    // fonction de vérification du masterdata + récupération du fichier masterdata
    function CheckMasterData : Boolean;
    // fonction de traitement du masterdata
    function DoMasterDataFile : Boolean;
    // Permet de récupérer les fichiers listés dans le master data
    function GetMasterDataFiles (ALocalMode : Boolean = False) : Boolean;
    // fonction de récupération des fichiers groupe
    function CheckGroupFile(AGroupDir : String) : Boolean;
    // function qui permet de récupérer le MAG_ID par son code adhérent ou par son nom de magasin(MAG_ENSEIGNE)
    function GetMagID(DOS_CODE, DOS_MAGNOM : String) : integer;
    // fonction qui permet de récupérer le PRM_INFO dans GenParam pour un magasin
    function GetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer) : String;
    // fonction qui permet d'envoyé un mail de listing des nouveautés
    function SendMailList(ALst : TStrings; AGRP, AMAG, AMAGNOM, ASENDTO : String) : Boolean;
    // fonction qui active le loop
    PROCEDURE LoopAutoActive(iNbNew : Integer);

    // Charge les fichiers locaux du groupe
    procedure LoadFTPLocalFiles(const Group: String);

    property Memo : TMemo read FMemo write FMemo;
    property ProgressLabel : TLabel read FLabelProgress write FLabelProgress;
    property ProgressBar : TProgressbar read FProgressBar write FProgressBar;
  private
    FLogFreq: Integer;
    FLogType: TLogType;
    FLogRef: String; // GUID Lame pour les imports
    procedure OnLog( Sender: TObject; LogItem: TLogItem);
    procedure InitializeLog;
    procedure FillLogRefWithLameGUID;
    procedure LogCodeGroup(const CodeGroup: String);
  public
    property LogFreq: Integer read FLogFreq;
    property LogType: TLogType read FLogType;
    property LogRef: String read FLogRef;
  end;

var
  DM_MSS: TDM_MSS;

implementation

{$R *.dfm}

{ TDM_MSS }

procedure TDM_MSS.AddToMemo(AText: String);
var
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;
begin
  With FMemo do
  begin
    sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText;
    if Assigned(FMemo) then
    begin
      FMemo.Lines.Add(sLigne);
    end;

    // Ajoute un retour à la ligne pour le fichier text
    sLigne := sLigne + #13#10;

    Encoding := TEncoding.Default;
    Buffer := Encoding.GetBytes(sLigne);
    FFile.Write(Buffer[0],Length(Buffer));
  end;
end;

function TDM_MSS.CheckGroupFile(AGroupDir : String): Boolean;
var
  lstTmp : TStringList;
  i, j, iPos : Integer;
  sText : String;
begin
  Result := False;
  Log.Log( 'FTP', AGroupDir, '', 'Status', 'Téléchargement des fichiers...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

  try
    try
      {$REGION 'Récupération des fichiers de commande'}
      // Revenir au répertoire de base
      while IdFTP.RetrieveCurrentDir <> '/' do
        IdFTP.ChangeDirUp;

      // On vide la mémoire de ce qui a été traité dans les groupData précédents
      if Length(GroupData) > 0 then
        for i := 0 to Length(GroupData) -1 do
            GroupData[i].MainData.Free;

      SetLength(GroupData,0);

      // se positionne sur le groupe GroupDirCommande
      IdFtp.ChangeDir(AGroupDir + '/' + IniStruct.FTP.MasterDataFTP.GroupDirCommande);
      lstTmp := TStringList.Create;
      try

        IdFTP.List(lstTmp, '*.*',False);
        for i := 0 to lstTmp.Count -1 do
        begin
          for j := 0 to Length(lstTmp[i]) do
          begin
            if lstTmp[i][j] in ['a'..'z'] then
            begin
              IdFTP.Rename(lstTmp[i],UpperCase(lstTmp[i]));
              Break;
            end;
          end;
        end;
        lstTmp.Clear;

        IdFTP.List(lstTmp, '*.SYNC',False);

        for i := 0 to lstTmp.Count -1 do
        begin
          Try
            // Vérification que le fichier correspondant existe
            iPos := Pos('_ORD.XML',UpperCase(lstTmp[i]));
            if iPos > 0 then
            begin
              if (IdFTP.Size(StringReplace(lstTmp[i],'ORD.XML.SYNC','SD.XML.SYNC',[])) <> -1) then
              begin
                // Chargement fichier ORD
                sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                FLabelProgress.Caption := 'Récupération du fichier : ' + sText;
                FLabelProgress.Update;

                Log.Log( 'FTP', AGroupDir, '', 'ORD', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                try
                  idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkCOMMANDE, sText ),True);
                  Log.Log( 'FTP', AGroupDir, '', 'ORD', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                except
                  on E: Exception do
                  begin
                    Log.Log( 'FTP', AGroupDir, '', 'ORD', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                    raise;
                  end;
                end;

                Log.Log( 'FTP', AGroupDir, '', 'SD', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                try
                  // Chargement fichier SD
                  sText := StringReplace(UpperCase(sText),'ORD.XML','SD.XML',[]);
                  idFtp.Get(sText, GetFTPLocalPath( AGroupDir, fkCOMMANDE, sText ),True);
                  Log.Log( 'FTP', AGroupDir, '', 'SD', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                except
                  on E: Exception do
                  begin
                    Log.Log( 'FTP', AGroupDir, '', 'SD', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                    raise;
                  end;
                end;

                // Fichier Commande
                (*
                SetLength(GroupData,Length(GroupData) + 1);
                With GroupData[Length(GroupData) -1] do
                begin
                  MainData := TCommandeClass.Create;
                  TCommandeClass(MainData).TVATable := Que_TVAList;
                  TCommandeClass(MainData).MarqueTable := Que_MarqueList;
                  TCommandeClass(MainData).FournTable := Que_FournList;

                  MainData.IboQuery := Que_GroupData;
                  MainData.StpQuery := stp_GroupData;
                  Title := Copy(lstTmp[i],1,iPos -1);
                  MainData.Title := Title;
                  MainData.FileName := Title;
                  Path := GXMLSCPATH;
                  MainData.Path := Path;
                  MainData.KTB_ID := CKTBID_COMBCDE;
                end;
                *)

                if IniStruct.RenameFtpFile then
                begin
                  // Fichier ORD
                  idFtp.Rename(lstTmp[i],'T' + lstTmp[i]);
                  sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                  idFtp.Rename(sText,'T' + sText);
                  // Fichier SD
                  sText := StringReplace(UpperCase(sText),'ORD.XML','SD.XML',[]);
                  idFtp.Rename(sText,'T' + sText);
                  sText := sText + '.SYNC';
                  idFtp.Rename(sText,'T' + sText);
                end else
                 if IniStruct.DeleteFtpfile then
                 begin
                    // Suppression du ORD
                    idFtp.Delete(lstTmp[i]);
                    sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                    idFtp.Delete(sText);
                    // Suppression du SD
                    sText := StringReplace(UpperCase(sText),'ORD.XML','SD.XML',[]);
                    idFtp.Delete(sText);
                    sText := sText + '.SYNC';
                    idFtp.Delete(sText);
                 end;

              end;
            end;
             FProgressBar.Position := (i + 1) * 100 Div lstTmp.Count;
             Application.ProcessMessages;
          Except on E:Exception do
            AddToMemo('Erreur FTP Commande : ' + E.Message);
          End;
        end; // For
      Except
        on E:EIdReplyRFCError do
          AddToMemo('Commande : Pas de fichier à traiter');
        on E:Exception do
          AddToMemo('Erreur Commande : ' + E.Message);
      end;
      {$ENDREGION}

      {$REGION 'Récupération des ORDDELETE'}
       try
          for i := 0 to lstTmp.Count -1 do
          begin
            Try
              // Vérification que le fichier correspondant existe

                // fichier de suppression de commande
                iPos := Pos('_ORDDELETE.XML.SYNC',UpperCase(lstTmp[i]));
                if iPos > 0 then
                begin
                  sText := LeftStr(UpperCase(lstTmp[i]),Pos('.SYNC',UpperCase(lstTmp[i])) -1);  //SR Ajout UpperCase()
                  FLabelProgress.Caption := 'Récupération du fichier : ' + sText;
                  FLabelProgress.Update;

                  Log.Log( 'FTP', AGroupDir, '', 'ORDDELETE', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  try
                    idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkORD_DELETE, sText ),True);
                    Log.Log( 'FTP', AGroupDir, '', 'ORDDELETE', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  except
                    on E: Exception do
                    begin
                      Log.Log( 'FTP', AGroupDir, '', 'ORDDELETE', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                      raise;
                    end;
                  end;
                  (*
                  SetLength(GroupData,Length(GroupData) + 1);
                  With GroupData[Length(GroupData) -1] do
                  begin
                    MainData := TOrdDeleteClass.Create;
                    MainData.IboQuery := Que_GroupData;
                    MainData.StpQuery := stp_GroupData;
                    Title := Copy(lstTmp[i],1,iPos -1);
                    MainData.Title := Title;
                    MainData.FileName := Title;
                    Path := GXMLSCPATH;
                    MainData.Path := Path;
                    MainData.KTB_ID := CKTBID_COMBCDE;
                  end;
                  *)

                  if IniStruct.RenameFtpFile then
                  begin
                    idFtp.Rename(lstTmp[i],'T' + lstTmp[i]);
                    sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                    idFtp.Rename(sText,'T' + sText);
                  end else
                   if IniStruct.DeleteFtpfile then
                   begin
                      idFtp.Delete(lstTmp[i]);
                      sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                      idFtp.Delete(sText);
                   end;
                end;
  //            if iPos > 0 then
  //            begin
  //              With GroupData[Length(GroupData) -1] do
  //              begin
  //              end;
  //            end;
               FProgressBar.Position := (i + 1) * 100 Div lstTmp.Count;
               Application.ProcessMessages;
            Except on E:Exception do
              AddToMemo('Erreur FTP ORDELETE : ' + E.Message);
            End;
          end;
        Except
          on E:EIdReplyRFCError do
            AddToMemo('ORDDELETE : Pas de fichier à traiter');
          on E:Exception do
            AddToMemo('Erreur ORDELETE : ' + E.Message);
        end;
      {$ENDREGION}

      {$REGION 'Récupération des fichiers de modification d''articles'}
      try
        // revenir à la base du ftp
        while IdFTP.RetrieveCurrentDir <> '/' do
          IdFTP.ChangeDirUp;
        if Length(ModifData) > 0 then
          for i := 0 to Length(ModifData) - 1 do
            ModifData[i].MainData.Free;
        SetLength(ModifData,0);

        // se positionne dans le groupe sur 'MODIF_ARTICLE/' +
        IdFtp.ChangeDir(AGroupDir + '/' + IniStruct.FTP.MasterDataFTP.GroupDirModif);

        lstTmp.Clear;
        IdFTP.List(lstTmp, '*.*',False);
        for i := 0 to lstTmp.Count -1 do
        begin
          for j := 0 to Length(lstTmp[i]) do
          begin
            if lstTmp[i][j] in ['a'..'z'] then
            begin
              IdFTP.Rename(lstTmp[i],UpperCase(lstTmp[i]));
              Break;
            end;
          end;
        end;
        lstTmp.Clear;

        // récupération des fichiers
        IdFTP.List(lstTmp,'*.SYNC',False);
        for i := 0 to lstTmp.Count -1 do
        begin
          Try
            // Vérification que le fichier Sync correspondant existe
            sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);

            Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
            try
              idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkMODIF_ARTICLE, sText ),True);
              Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
            except
              on E: Exception do
              begin
                Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                raise;
              end;
            end;

            if IdFTP.Size(sText + '.SYNC') <> -1 then
            begin
              FLabelProgress.Caption := 'Récupération du fichier : ' + sText;
              FLabelProgress.Update;

              Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
              try
                idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkMODIF_ARTICLE, sText ),True);
                Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
              except
                on E: Exception do
                begin
                  Log.Log( 'FTP', AGroupDir, '', 'SDUPDATE', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                  raise;
                end;
              end;
              (*
              SetLength(ModifData,Length(ModifData) + 1);
              With ModifData[Length(ModifData) -1] do
              begin
                MainData := TSDUpdate.Create;
                TSDUpdate(MainData).TVATable := Que_TVAList;
                TSDUpdate(MainData).MarqueTable := Que_MarqueList;
                TSDUpdate(MainData).FournTable := Que_FournList;
                MainData.IboQuery := Que_GroupData;
                MainData.StpQuery := stp_GroupData;
                Title := ChangeFileExt(sText,'');
                MainData.Title := Title;
                MainData.FileName := sText;
                Path := GXMLSCPATH;
                MainData.Path := Path;
              end;
              *)
            end;

            if IniStruct.RenameFtpFile then
            begin
              idFtp.Rename(lstTmp[i],'T' + lstTmp[i]);
              sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
              idFtp.Rename(sText,'T' + sText);
            end else
             if IniStruct.DeleteFtpfile then
             begin
                idFtp.Delete(lstTmp[i]);
                sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                idFtp.Delete(sText);
             end;

          Except on E:exception do
            AddToMemo('Erreur FTP Modif Article : ' + E.Message);
          End;
          FProgressBar.Position := (i + 1) * 100 Div lstTmp.Count;
          Application.ProcessMessages;
        end; // for
      Except
        on E:EIdReplyRFCError do
            AddToMemo('Modif Article : Pas de fichier à traiter');
        on E:Exception do
          AddToMemo('Erreur Modif Article : ' + E.Message);
      end;
      {$ENDREGION}

      {$REGION 'Récupération des fichiers de réception'}
      try
        // Revenir au répertoire de base
        while IdFTP.RetrieveCurrentDir <> '/' do
          IdFTP.ChangeDirUp;

        if Length(RecepData) > 0 then
          for i := 0 to Length(RecepData) - 1 do
            RecepData[i].MainData.Free;
        SetLength(RecepData,0);

        // se positionne dans le groupe sur 'BL/' +
        IdFtp.ChangeDir(AGroupDir + '/' + IniStruct.FTP.MasterDataFTP.GroupDirRecept);

        lstTmp.Clear;
        IdFTP.List(lstTmp, '*.*',False);
        for i := 0 to lstTmp.Count -1 do
        begin
          for j := 0 to Length(lstTmp[i]) do
          begin
            if lstTmp[i][j] in ['a'..'z'] then
            begin
              IdFTP.Rename(lstTmp[i],UpperCase(lstTmp[i]));
              Break;
            end;
          end;
        end;
        lstTmp.Clear;

        // Récupération des fichiers
        IdFTP.List(lstTmp,'*.SYNC',False);
        for i := 0 to lstTmp.Count -1 do
        begin
          Try
            // Vérification que le fichier Sync correspondant existe
            sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);


            Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
            try
              idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkBL, sText ),True);
              Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
            except
              on E: Exception do
              begin
                Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                raise;
              end;
            end;

            if IdFTP.Size(sText + '.SYNC') <> -1 then
            begin
              FLabelProgress.Caption := 'Récupération du fichier : ' + sText;
              FLabelProgress.Update;

              Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : Téléchargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
              try
                idFTP.Get(sText, GetFTPLocalPath( AGroupDir, fkBL, sText ),True);
                Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : Téléchargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
              except
                on E: Exception do
                begin
                  Log.Log( 'FTP', AGroupDir, '', 'DESADV', sText + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                  raise;
                end;
              end;
              (*
              SetLength(RecepData,Length(RecepData) + 1);
              With RecepData[Length(RecepData) -1] do
              begin
                MainData := TReceptionClass.Create;
                TReceptionClass(MainData).MarqueTable := Que_MarqueList;
                TReceptionClass(MainData).FournTable := Que_FournList;
                TReceptionClass(MainData).TVATable   := Que_TVAList;
                MainData.IboQuery := Que_GroupData;
                MainData.StpQuery := stp_GroupData;
                Title := ChangeFileExt(sText,'');
                MainData.Title := Title;
                MainData.FileName := sText;
                Path := GXMLSCPATH;
                MainData.Path := Path;
              end;
              *)
            end;

            if IniStruct.RenameFtpFile then
            begin
              idFtp.Rename(lstTmp[i],'T' + lstTmp[i]);
              sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
              idFtp.Rename(sText,'T' + sText);
            end else
             if IniStruct.DeleteFtpfile then
             begin
                idFtp.Delete(lstTmp[i]);
                sText := LeftStr(lstTmp[i],Pos('.SYNC',lstTmp[i]) -1);
                idFtp.Delete(sText);
             end;

          Except on E:Exception do
            AddToMemo('Erreur FTP Réception : ' + E.Message);
          End;
           FProgressBar.Position := (i + 1) * 100 Div lstTmp.Count;
           Application.ProcessMessages;
        end; // for
      Except
        on E:EIdReplyRFCError do
          AddToMemo('Réception : Pas de fichier à traiter');
        on E:Exception do
          AddToMemo('Erreur Réception : ' + E.Message);
      end;
      {$ENDREGION}

      Log.Log( 'FTP', AGroupDir, '', 'Status', 'Fichiers téléchargés', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
    except
      on E: Exception do
      begin
        Log.Log( 'FTP', AGroupDir, '', 'Status', E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
        raise;
      end;
    end;
  finally
    lstTmp.Free;
    Try
      IdFtp.Disconnect;
    Except on E:Exception do
      AddToMemo('Erreur Disconnect FTP Group : ' + E.Message);
    End;
  end;
  Result := True;
end;

function TDM_MSS.CheckMasterData: Boolean;
var
  bMasterSyncExist,
  bMasterExist : Boolean;
begin
  Result := False;
  try
    Log.Log( 'MasterDatas', '', '', 'MasterData', 'Recherche d''une mise à jour...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
//    // Revenir au répertoire de base
//    while IdFTP.RetrieveCurrentDir <> IniStruct.FTP.MasterDataFTP.Basedir do
//      IdFTP.ChangeDirUp;

    // Se positionner dans le répertoire pour récupérer la version
    IdFtp.ChangeDir( IniStruct.FTP.MasterDataFTP.MasterDataVersion);

    // Vérification que le fichier sync existe
    bMasterSyncExist := (IdFtp.Size('Masterdata.xml.SYNC') <> -1);
    bMasterExist     := (IdFtp.Size('Masterdata.xml') <> -1);

    Result := (bMasterSyncExist and bMasterExist);

    // récupération du fichier masterdata
    if not Result then
      Log.Log( 'MasterDatas', '', '', 'MasterData', 'Mise à jour non détectée', logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType )
    else
    begin
      Log.Log( 'MasterDatas', '', '', 'MasterData', 'Mise à jour détectée, téléchargement...', logNotice, False, DM_MSS.LogFreq, DM_MSS.LogType );
      IdFTP.Get('Masterdata.xml',GXMLMDPATH + 'Masterdata.xml',True,False);
      Log.Log( 'MasterDatas', '', '', 'MasterData', 'Mise à jour téléchargée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
    end;

  Except on E:Exception do
    begin
      Log.Log( 'MasterDatas', '', '', 'MasterData', E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
      raise Exception.Create('CheckMasterData -> ' + E.Message);
    end;
  end;
end;

procedure TDM_MSS.DataModuleCreate(Sender: TObject);
begin
  // Gestion monitoring
  InitializeLog; // Définition du LogFreq et du LogType par défaut pour l'app
  Log.App := 'MDC';
  Log.Inst := IniStruct.IDMDC;
  Log.Open;
  Log.saveIni;
end;

procedure TDM_MSS.DataModuleDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(MasterData) to High(MasterData) do
    MasterData[i].MainData.Free;
  SetLength(MasterData,0);

  for i := Low(GroupData) to High(GroupData) do
    GroupData[i].MainData.Free;
  SetLength(GroupData,0);

  for i := Low(ModifData) to High(ModifData) do
    ModifData[i].MainData.Free;
  SetLength(ModifData,0);
end;

function TDM_MSS.DoMasterDataFile: Boolean;
var
  nXmlBase ,
  eXmlNode : IXmlNode;
  i : Integer;
begin
  Result := False;
  try
    Log.Log( 'MasterDatas', '', '', 'MasterData', 'Analyse du fichier...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
    for i := Low(MasterData) to High(MasterData) do
      MasterData[i].MainData.Free;

    SetLength(MasterData,0);
    // ouverture du fichier  master data
    if not XMLDoc.Active then
      XMLDoc.Active := True;

    XMLDoc.LoadFromFile(GXMLMDPATH + 'MasterData.xml');
    nXmlBase := XmlDoc.DocumentElement;
    for i := 0 to nXmlBase.ChildNodes.Count -1 do
    begin
      eXmlNode := nXmlBase.ChildNodes.Get(i);
      if UpperCase(eXmlNode.NodeName) = 'TYPE' then
      begin
        SetLength(MasterData,Length(MasterData) + 1);

        MasterData[Length(MasterData) - 1].Title := eXmlNode.ChildValues['Title'];
        MasterData[Length(MasterData) - 1].Path  := eXmlNode.ChildValues['Path'];
        Result := True; // Au moins un a été trouvée
      end;
    end;
    XMLDoc.Active := False;
    Log.Log( 'MasterDatas', '', '', 'MasterData', Format( '%d type(s) trouvé(s)', [ Length( MasterData ) ] ), logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType )
  Except on E:Exception do
    begin
      Log.Log( 'MasterDatas', '', '', 'MasterData', E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
      raise Exception.Create('DoMasterDataFile -> ' + E.Message);
    end;
  end;
end;

function TDM_MSS.ExecuteProcess(DataBasePath : String;
  const Manual: Boolean) : Integer;
var
  i, j, iTentative : integer;
  bOneBase, bBaseOpen, bDoMaj, bDoMajCmd, bSendMail : Boolean;
  iMagID : Integer;
  MagNom : String;
  OldBase : String;
  CodeGroup : String;
  lst, lstCumulArt, lstCumulCmd, lstRejectCmd, lstCumulRecep : TStringList;
  iCumulNew : Integer;
  sPeriode : String;
  sTmp : String;

  MemSize : Cardinal;
  pPMC : PPROCESS_MEMORY_COUNTERS;
  nProcID, TmpHandle : HWND;

  tpJeton : TTokenParams;   //Record avec les paramètres pour les Jetons
  TokenManager : TTokenManager;
  sAdresse : String;
  bJeton  : Boolean;        //Vrai si on a le jeton sinon faux

  OpComms : TOpComms;

  Log_ActionLog: string;
  Log_LogLevel: TLogLevel;
begin
  try
    // Rafraichissement des chemins au debut de chaque exécution
    GLOGSPATH   := GAPPPATH + 'Logs\' + FormatDateTime('YY\MM\',Now);
    GLOGSNAME   := FormatDateTime('YYYYMMDDhhmmss',Now) + '.txt';
    GAPPRAPPORT := GAPPPATH + 'Rapports\' + FormatDateTime('YY\MM\DD\',Now);

    GARCHPATHOK := GARCHMAINPATH + 'ACCEPTES\%s\' + FormatDateTime('YY\MM\DD\',Now);
    GARCHPATHKO := GARCHMAINPATH + 'REJETES\' + FormatDateTime('YY\MM\DD\',Now) + '%s\';
    GARCHPATHMASTER := GARCHMAINPATH + 'MASTERDATA\' + FormatDateTime('YY\MM\DD\',Now);
//    GARCHPATH   := GAPPPATH + 'Archive\' + FormatDateTime('YY\MM\DD\',Now);
//    DoDir(GARCHPATH);
    DoDir(GLOGSPATH);
    DoDir(GAPPRAPPORT);
    DoDir(GARCHPATHMASTER);

    OldBase := '';
    iCumulNew := 0;
    bOneBase := Trim(DataBasePath) <> '';

    Log.Log( '', 'Main', '', '', '', 'Status', Format( 'Traitement %s...', [ IfThen( Manual, 'manuel', 'automatique' ) ] ), logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

    if FileExists(GLOGSPATH + GLOGSNAME) then
    begin
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd);
    end else
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmCreate);

    if (CompareTime(IniStruct.Periode.HDebut, Now) = LessThanValue) and
       (CompareTime(IniStruct.Periode.HFin, Now) = GreaterThanValue) then
    begin
      try
        // Ouverture du FTP master & récupération des fichiers
        if OpenFTP(IniStruct.FTP.MasterDataFTP) then
        begin
          // Vérification et récupération du fichier masterdata
          if CheckMasterData then
            // traitement du fichier masterdata et récupération des nouveaux fichier si nécessaire
            if DoMasterDataFile then
              GetMasterDataFiles;
          if IdFTP.Connected then
             Try
              IdFTP.Disconnect;
             Except on E:Exception do
               AddToMemo('Erreur Disconnect FTP : ' + E.Message);
             End;

          If not DM_DbMAG.Que_DOSSIERS.Active then
            DM_DbMAG.Que_DOSSIERS.Open
          else
            DM_DbMAG.Que_DOSSIERS.Refresh;

          DM_DbMAG.Que_DOSSIERS.Filtered := False;
          DM_DbMAG.Que_DOSSIERS.Filter := Format('DOS_IDMDC = ''%s'' and DOS_ACTIF = 1',[IniStruct.IDMDC]);
          DM_DbMAG.Que_DOSSIERS.Filtered := True;

          DM_DbMAG.Que_DOSSIERS.First;
          while (not DM_DbMAG.Que_DOSSIERS.Eof) and not GSTOPCYCLE {or bOneBase} do
          begin
            Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Traitement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
            AddToMemo('DOSSIER EN COURS : ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString);
            try
              try
                if OldBase <> DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString then
                begin
                  if not IniStruct.NoJeton then
                  begin
                    Try
                      tpJeton := GetParamsToken(DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString,'ginkoia','ginkoia');    //Prise en compte des Jetons

                      sAdresse := StringReplace(tpJeton.sURLDelos, '/DelosQPMAgent.dll', tpJeton.sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                      TokenManager :=  TTokenManager.Create;
                      bJeton := TokenManager.tryGetToken(sAdresse,tpJeton.sDatabaseWS,tpJeton.sSenderWS,20,30000);

                      if bJeton then
                        AddToMemo('Jeton Acquis !!')
                      else
                        raise Exception.Create('Problème lors de l''obtention du jeton');
                    Except
                      on E:Exception do
                        raise Exception.Create('Jeton -> ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString + ' - ' + E.Message);
                    End;
                  end;
                end;

                // Ouverture de la base de données ginkoia
                if OldBase <> DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString then
                begin
    //              FMemo.Clear;
                  // Vidage des tables des données de bases
                  for i := low(MasterData) to High(MasterData) do
                    MasterData[i].MainData.ClearIdField;

                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Ouverture de la base de données: ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString, logNotice, True, DM_MSS.LogFreq, ltLocal );
                  AddToMemo('Ouverture de la base de données : ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString);
                  bBaseOpen := OpenIBDatabase(DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString);
                  OldBase := DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString;

                  // Récupération de la liste des magasins + Code magasin
                  FillLogRefWithLameGUID; { Monitoring des imports }
                  Que_GenMagasin.Close;
                  Que_GenMagasin.Open;
                  cds_Magasin.EmptyDataSet;
                  while not Que_GenMagasin.Eof do
                  begin
                    With cds_Magasin do
                    begin
                      Append;
                      FieldByName('MAG_ID').AsInteger := Que_GenMagasin.FieldByName('MAG_ID').AsInteger;
                      FieldByName('MAG_ENSEIGNE').AsString := Que_GenMagasin.FieldByName('MAG_ENSEIGNE').AsString;
                      FieldByName('NUMERO').AsString := GetGenParamInfo(12,10,Que_GenMagasin.FieldByName('MAG_ID').AsInteger);
                      FieldByName('MAG_TVTID').AsInteger := Que_GenMagasin.FieldByName('MAG_TVTID').AsInteger;
                      FieldByName('BAS_GUID').AsString := Que_GenMagasin.FieldByName('BAS_GUID').AsString; // Monitoring
                      Post;
                    end;

                    Que_GenMagasin.Next;
                  end;
                  CodeGroup := GetGenParamInfo(12,18,0);
                  LogCodeGroup(CodeGroup);

                  {$REGION 'Intégration des données de base (Sauf OPComm)'}
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Intégration des données de base (sauf OPComm)...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Intégration des données de base (sauf OPComm)...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  try
                    for i := Low(MasterData) to High(MasterData) do
                    begin
                      if  MasterData[i].MainData.PRM_CODE <> 0 then
                      begin
                        bDoMaj := MasterData[i].MainData.CheckFileMaj;
                        if bDoMaj then
                        try
                          if not MasterData[i].MainData.InheritsFrom(TOpComms) then
                          begin
                            Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, 'Intégration des données...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                            AddToMemo('Mise à jour de : ' + MasterData[i].MainData.Title);
                            FLabelProgress.Caption :=  'Intégration des données de ' + MasterData[i].Title;
                            MasterData[i].MainData.ProgressBar := FProgressBar;

                            if MasterData[i].MainData.AutoCommit then
                              IBOTransaction.StartTransaction;
                            MasterData[i].MainData.DoMajTable(bDoMaj);
                            if MasterData[i].MainData.AutoCommit then
                              IBOTransaction.Commit;
                            Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, Format( 'Intégration : Ajout = %d, Mise à jour = %d', [ MasterData[ i ].MainData.Insertcount, MasterData[ i ].MainData.Majcount ] ), logTrace, False, DM_MSS.LogFreq, ltLocal );
                            AddToMemo('Ajout : ' + IntToStr(MasterData[i].MainData.Insertcount) + ' ' +
                                      'Maj : ' + IntToStr(MasterData[i].MainData.Majcount));
                            iCumulNew := iCumulNew + MasterData[i].MainData.Insertcount;
                            if MasterData[i].MainData.UpdateGenParam then
                            begin
                              Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, 'Intégration : Mise à jour GENPARAM', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                              AddToMemo('Mise à jour GenParam Ok');
                            end;
                            Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, 'Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                          end;
                        Except on E:Exception do
                          begin
                            Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                            AddToMemo('Erreur MAJ : ' + E.Message);
                            if MasterData[i].MainData.AutoCommit then
                              IBOTransaction.Rollback;
                          end;
                        end;

                        for j := 0 to MasterData[i].MainData.ErrLogs.Count -1 do
                        begin
                          Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, MasterData[ i ].MainData.ErrLogs[ j ], logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          AddToMemo(MasterData[i].Title + ' - ' + MasterData[i].MainData.ErrLogs.Strings[j]);
                        end;
                        MasterData[i].MainData.ErrLogs.Clear;

                      end;
                    end; //for i
                    Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Données de base (sauf OPComm) intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                    Log.Log( '', 'Import', '', '', '', 'Status', 'Données de base (sauf OPComm) intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  except
                    on E: Exception do
                    begin
                      Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Erreur lors de l''intégration des données de base (sauf OPComm) : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                      Log.Log( '', 'Import', '', '', '', 'Status', E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                    end;
                  end;
                  {$ENDREGION}

                  // Ouverture des tables communes
                  Que_MarqueList.Open;
                  Que_MarqueList.First;

                  Que_FournList.Open;
                  Que_FournList.First;

                  Que_TVAList.Open;
                  Que_TVAList.First;
                end;

                if bBaseOpen then
                begin
      //            AddToMemo('Magasin : ----' + MagNom + ' ----');
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Création de l''arborescence du groupe : ' + CodeGroup, logTrace, False, DM_MSS.LogFreq, ltLocal );
                  DoMakeXmlGroup( CodeGroup );

                  // Récupération des commandes
                  if OpenFTP(IniStruct.FTP.MasterDataFTP) then
                    CheckGroupFile( CodeGroup );

                  AddToMemo( 'Récupération des fichiers locaux du groupe: ' + CodeGroup );
                  // Charger les fichiers dans les GroupData/ModifData/RecepData
                  LoadFTPLocalFiles( CodeGroup );

                  {$REGION 'Intégration des mises à jour'}
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Intégration des mises à jours...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Intégration des mises à jours...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  for i := 0 to Length(ModifData) -1 do
                  begin
                    FLabelProgress.Caption := 'Traitement du fichier : ' + ModifData[i].MainData.Title;
                    Application.ProcessMessages;

                    Try
                      Log.Log( '', 'Import', '', DM_MSS.LogRef, '', ModifData[ i ].MainData.Title, 'Intégration des données...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                      AddToMemo('Traitement du fichier : ' + ModifData[i].MainData.Title);

                      ModifData[i].MainData.MAG_ID := iMagId;
                      ModifData[i].MainData.Import;
                      IBOTransaction.StartTransaction;
                      ModifData[i].MainData.DoMajTable(True);
                      IBOTransaction.Commit;
                      Log.Log( '', 'Import', '', DM_MSS.LogRef, '', ModifData[ i ].MainData.Title, 'Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                      Log.Log( '', 'Import', '', DM_MSS.LogRef, '', ModifData[ i ].MainData.Title, Format( 'Intégration : Ajout = %d, Mise à jour = %d', [ ModifData[ i ].MainData.Insertcount, ModifData[ i ].MainData.Majcount ] ), logTrace, False, DM_MSS.LogFreq, ltLocal );
                      iCumulNew := iCumulNew + ModifData[i].MainData.Insertcount
                                             + ModifData[i].MainData.Majcount;
            //          AddToMemo(Format('Ajout %d / Mise à jour %d',[ModifData[i].MainData.Insertcount,ModifData[i].MainData.Majcount]));
                    Except on E:Exception do
                      begin
                        IBOTransaction.Rollback;
                        Log.Log( '', 'Import', '', DM_MSS.LogRef, '', ModifData[ i ].MainData.Title, E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                        AddToMemo(E.Message);
                        // Déplace les fichiers dans le répertoire rejetés
                        sTmp :=  Format(GARCHPATHKO + 'MODIF_ARTICLE\', [StringReplace(CodeGroup,'/','\',[rfReplaceAll])]); // GARCHPATH + StringReplace(CodeGroup,'/','\',[rfReplaceAll]) + '\MODIF_REJETEES\';
                        DoDir(sTmp);
                        sTmp := sTmp + ModifData[i].MainData.Title + '.XML';
                        MoveFile(PWideChar(ModifData[i].MainData.Path + ExtractFileName(sTmp)),PWideChar(sTmp));
                        // Génére les fichiers sync
                        CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '.SYNC'),False);
                      end;
                    End;

                    if ModifData[i].MainData.ErrLogs.Count > 0 then
                      for j := 0 to ModifData[i].MainData.ErrLogs.Count -1 do
                      begin
                        Log.Log( '', 'MasterDatas', DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString, '', '', ModifData[ i ].MainData.Title, ModifData[ i ].MainData.ErrLogs[ j ], logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                        AddToMemo('Erreur : ' + ModifData[i].MainData.ErrLogs[j]);
                      end;

                    if Assigned(FProgressBar) then
                      FProgressBar.Position := (i + 1) * 100 Div Length(ModifData);
                    Application.ProcessMessages;
                  end; // for i
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Mises à jour intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Mises à jour intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  {$ENDREGION}

                  {$REGION 'intégration des commandes'}
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Intégration des commandes...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Intégration des commandes...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  for i := 0 to Length(GroupData) -1 do
                  begin
                    FLabelProgress.Caption := 'Traitement du fichier : ' + GroupData[i].MainData.Title;
                    Application.ProcessMessages;

                    Try
    //                      GroupData[i].MainData.MAG_ID := iMagId;
                      GroupData[i].MainData.Import;

                      {$REGION 'gestion de l''initialisation d''une base'}
                      bDoMajCmd := True;
                      sPeriode := '';
                      if DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_PERIODEINIT').AsInteger = 1 then
                      begin
                        sPeriode := ' - ' + (FormatDatetime('DD/MM/YYYY',TCommandeClass(GroupData[i].MainData).OrderDate) + ' - ' +
                                  FormatDateTime('DD/MM/YYYY',TCommandeClass(GroupData[i].MainData).MaxDeliveryDate));

                        if (CompareDate(TCommandeClass(GroupData[i].MainData).OrderDate,DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_PERIODEDEBUT').AsDateTime) = LessThanValue) Or
                           (CompareDate(TCommandeClass(GroupData[i].MainData).OrderDate,DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_PERIODEFIN').AsDateTime) = GreaterThanValue)
                        then
                          bDoMajCmd := False;

                        if (CompareDate(TCommandeClass(GroupData[i].MainData).MaxDeliveryDate,DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_PERIODELIVRAISON').AsDateTime) = LessThanValue) then
                          bDoMajCmd := False;
                      end;
                      {$ENDREGION}

                      case AnsiIndexStr(GroupData[i].MainData.ClassName,[TCommandeClass.ClassName,TOrdDeleteClass.ClassName]) of
                        0: begin // TCommandeClass
                          if bDoMajCmd then
                          begin
                            try
                              cds_Magasin.Filtered := False;
                              cds_Magasin.Filter := Format('NUMERO = %s',[QuotedStr(TCommandeClass(GroupData[i].MainData).CodeMag)]);
                              cds_Magasin.Filtered := True;

                              Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', GroupData[ i ].MainData.Title + ' : Intégration de la commande...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                              Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', GroupData[ i ].MainData.Title + ' : Intégration de la commande...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                              AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title + sPeriode);


                              if (cds_Magasin.RecordCount <= 0) then
                                raise Exception.Create('Code magasin non trouvé : ' + TCommandeClass(GroupData[i].MainData).CodeMag);
                              If (cds_Magasin.RecordCount > 1) then
                                raise Exception.Create(Format('Le code magasin %s existe dans plusieurs magasin',[TCommandeClass(GroupData[i].MainData).CodeMag]));

                              TCommandeClass(GroupData[i].MainData).MAG_ID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
                              TCommandeClass(GroupData[i].MainData).TVT_ID := cds_Magasin.FieldByName('MAG_TVTID').AsInteger;

                              IBOTransaction.StartTransaction;
                              GroupData[i].MainData.DoMajTable(True);
                              if GroupData[i].MainData.IsOnError then
                                raise Exception.Create('Commande en erreur')
                              else
                                IBOTransaction.Commit;
                              Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', GroupData[ i ].MainData.Title + ' : Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                              Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', GroupData[ i ].MainData.Title + ' : Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
    //                        Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, GroupData[ i ].MainData.Title, Format( 'Intégration : Nouveaux articles = %d, Mise à jour d''articles = %d, Nombre de lignes = %d, Nombre de lignes modifiées = %d', [ TCommandeClass(GroupData[ i ].MainData).ArtInsCount, TCommandeClass(GroupData[ i ].MainData).ArtMajCount, TCommandeClass(GroupData[ i ].MainData).CmdInsCount, TCommandeClass(GroupData[ i ].MainData).CmdMajCount ] ), logTrace, False, DM_MSS.LogFreq, ltLocal );
                              iCumulNew := iCumulNew + TCommandeClass(GroupData[i].MainData).ArtInsCount +
                                                       TCommandeClass(GroupData[i].MainData).CmdInsCount;
    //                          AddToMemo('Nouveaux Articles : ' + IntToStr(TCommandeClass(GroupData[i].MainData).ArtInsCount));
    //                          AddToMemo('Mise à jour d''articles : ' + IntToStr(TCommandeClass(GroupData[i].MainData).ArtMajCount));
    //                          AddToMemo('Nombre de lignes : ' + IntToStr(TCommandeClass(GroupData[i].MainData).CmdInsCount));
    //                          AddToMemo('Nombre de lignes modifiées : ' + IntToStr(TCommandeClass(GroupData[i].MainData).CmdMajCount));
                            except
                              on E: Exception do
                              begin
                                Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', GroupData[ i ].MainData.Title + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                                Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', GroupData[ i ].MainData.Title + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                                raise;
                              end;
                            end;
                          end
                          else begin
                            Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', GroupData[ i ].MainData.Title + ' : Commande Hors Période Init', logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                            Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', GroupData[ i ].MainData.Title + ' : Commande Hors Période Init', logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                            AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title + ' -> Commande Hors Période Init' + sPeriode);
                          end;
                        end;

                        1: begin // TOrdDeleteClass
                          Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORDDELETE', GroupData[ i ].MainData.Title + ' : Intégration de l''ORDDELETE...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                          AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title);
                          try
                            IBOTransaction.StartTransaction;
                            GroupData[i].MainData.DoMajTable(True);
                            IBOTransaction.Commit;
                            Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORDDELETE', GroupData[ i ].MainData.Title + ' : Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                          except
                            on E: Exception do
                            begin
                              Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORDDELETE', GroupData[ i ].MainData.Title + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                              raise;
                            end;
                          end;
                        end;
                      end; // case
                    Except on E:Exception do
                      begin
                        IBOTransaction.Rollback;
                        AddToMemo(E.Message);
                        // Déplace les fichiers dans le répertoire rejetés
                        sTmp := format(GARCHPATHKO + 'COMMANDE\', [StringReplace(CodeGroup,'/','\',[rfReplaceAll])]); //  GARCHPATH + StringReplace(CodeGroup,'/','\',[rfReplaceAll]) + {'\' + GroupData[i].MainData.CodeMag +} '\REJETEES\';
                        DoDir(sTmp);
  //                      sTmp := sTmp + GroupData[i].MainData.Title;
                        MoveFileOrRename(GroupData[i].MainData.Path, sTmp, GroupData[i].MainData.Title + '_ORD', '.XML');
                        MoveFileOrRename(GroupData[i].MainData.Path, sTmp, GroupData[i].MainData.Title + '_SD', '.XML');
  //                      MoveFileEx(PWideChar(GroupData[i].MainData.Path + ExtractFileName(sTmp) + '_ORD.XML'),PWideChar(sTmp + '_ORD.XML'),MOVEFILE_REPLACE_EXISTING);
  //                      MoveFileEx(PWideChar(GroupData[i].MainData.Path + ExtractFileName(sTmp) + '_SD.XML'),PWideChar(sTmp + '_SD.XML'),MOVEFILE_REPLACE_EXISTING);
                        // Génére les fichiers sync
  //                      CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '_ORD.XML.SYNC'),False);
  //                      CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '_SD.XML.SYNC'),False);
                      end;
                    End;

                    // Gestion des logs
                    if GroupData[i].MainData.ActionLogs.Count > 0 then
                      for j := 0 to GroupData[i].MainData.ActionLogs.Count -1 do
                      begin
                        // Récupération du action log..
                        Log_ActionLog := GroupData[ i ].MainData.ActionLogs[ j ];
                        // S'agit-il d'un warning (message commencant par un "!")...
                        if ( Length(Log_ActionLog) > 0 ) and (Log_ActionLog[1] = '!') then
                        begin
                          Log_LogLevel := logWarning;
                          Delete(Log_ActionLog, 1, 1); // Suppression du "!"
                        end
                        else
                          Log_LogLevel := logInfo;

                        case AnsiIndexStr(GroupData[i].MainData.ClassName,[TCommandeClass.ClassName,TOrdDeleteClass.ClassName]) of
                          0: begin // Commande (ORD+SD)
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', Log_ActionLog, Log_LogLevel, False, DM_MSS.LogFreq, DM_MSS.LogType );
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', Log_ActionLog, Log_LogLevel, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          end;
                          1: begin // Orddelete (ORDELETE)
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORDDELETE', Log_ActionLog, Log_LogLevel, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          end;
                        end;
                        AddToMemo(GroupData[i].MainData.ActionLogs[j]);
                      end;

                    if GroupData[i].MainData.ErrLogs.Count > 0 then
                      for j := 0 to GroupData[i].MainData.ErrLogs.Count -1 do
                      begin
                        case AnsiIndexStr(GroupData[i].MainData.ClassName,[TCommandeClass.ClassName,TOrdDeleteClass.ClassName]) of
                          0: begin // Commande (ORD+SD)
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORD', GroupData[ i ].MainData.ErrLogs[ j ], logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'SD', GroupData[ i ].MainData.ErrLogs[ j ], logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          end;
                          1: begin // Orddelete (ORDELETE)
                             Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'ORDDELETE', GroupData[ i ].MainData.ErrLogs[ j ], logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          end;
                        end;
                        AddToMemo('Erreur : ' + GroupData[i].MainData.ErrLogs[j]);
                      end;

                    if Assigned(FProgressBar) then
                      FProgressBar.Position := (i + 1) * 100 Div Length(GroupData);
                    Application.ProcessMessages;
                  end; // for i
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Commandes intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Commandes intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  {$ENDREGION}

                  {$REGION 'Intégration des réception'}
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Intégration des réceptions...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Intégration des réceptions...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  for i := 0 to Length(RecepData) -1 do
                  begin
                    FLabelProgress.Caption := 'Traitement du fichier : ' + RecepData[i].MainData.Title;
                    Application.ProcessMessages;

                    Try
    //                  Log.Log( '', 'Import', '', DM_MSS.LogRef, '', 'DESADV', RecepData[ i ].MainData.Title + ' : Intégration de la réception...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                      AddToMemo('Traitement du fichier : ' + RecepData[i].MainData.Title);

                      RecepData[i].MainData.Import;

                      cds_Magasin.Filtered := False;
                      cds_Magasin.Filter := Format('NUMERO = %s',[QuotedStr(RecepData[i].MainData.CodeMag)]);
                      cds_Magasin.Filtered := True;

                      Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'DESADV', RecepData[ i ].MainData.Title + ' : Intégration de la réception...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

                      if (cds_Magasin.RecordCount <= 0) then
                        raise Exception.Create('Code magasin non trouvé : ' + RecepData[i].MainData.CodeMag);
                      If (cds_Magasin.RecordCount > 1) then
                        raise Exception.Create(Format('Le code magasin %s existe dans plusieurs magasin',[RecepData[i].MainData.CodeMag]));

                      RecepData[i].MainData.MAG_ID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

                      IBOTransaction.StartTransaction;
                      RecepData[i].MainData.DoMajTable(True);
                      IBOTransaction.Commit;
                      Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'DESADV', RecepData[ i ].MainData.Title + ' : Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                      Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'DESADV', Format( '%s : Intégration : Ajout = %d, Mise à jour = %d', [ RecepData[ i ].MainData.Title, RecepData[i].MainData.Insertcount, RecepData[i].MainData.Majcount ] ), logTrace, False, DM_MSS.LogFreq, ltLocal );

                      iCumulNew := iCumulNew + RecepData[i].MainData.Insertcount
                                             + RecepData[i].MainData.Majcount;
                    Except on E:Exception do
                      begin
                        IBOTransaction.Rollback;
                        Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'DESADV', RecepData[ i ].MainData.Title + ' : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                        AddToMemo(E.Message);
                        // Déplace les fichiers dans le répertoire rejetés
                        sTmp := Format(GARCHPATHKO + 'BL\',[StringReplace(CodeGroup,'/','\',[rfReplaceAll])]); // GARCHPATH + StringReplace(CodeGroup,'/','\',[rfReplaceAll]) + '\BL_REJETEES\';
                        DoDir(sTmp);
  //                      sTmp := sTmp + RecepData[i].MainData.Title + '.XML';
  //                      MoveFile(PWideChar(RecepData[i].MainData.Path + ExtractFileName(sTmp)),PWideChar(sTmp));
                        // Génére les fichiers sync
  //                      CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '.SYNC'),False);

                        MoveFileOrRename(RecepData[i].MainData.Path, sTmp, RecepData[i].MainData.Title, '.XML');

                      end;
                    End;

                    if RecepData[i].MainData.ErrLogs.Count > 0 then
                      for j := 0 to RecepData[i].MainData.ErrLogs.Count -1 do
                      begin
                        Log.Log( '', 'Import', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString, 'DESADV', RecepData[ i ].MainData.ErrLogs[ j ], logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                        AddToMemo('Erreur : ' + RecepData[i].MainData.ErrLogs[j]);
                      end;

                    if Assigned(FProgressBar) then
                      FProgressBar.Position := (i + 1) * 100 Div Length(RecepData);
                    Application.ProcessMessages;
                  end; // for i
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Réceptions intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Réceptions intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  {$ENDREGION}

                  {$REGION 'Intégration des données de base (OPComm Seulement)'}
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Intégration des données de base (OPComm seulement)...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Intégration des données de base (OPComm seulement)...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  for i := Low(MasterData) to High(MasterData) do
                  begin
                    if  MasterData[i].MainData.PRM_CODE <> 0 then
                    begin
                      bDoMaj := MasterData[i].MainData.CheckFileMaj;
                      if bDoMaj then
                      try
                        if MasterData[i].MainData.InheritsFrom(TOpComms) then
                        begin
                          OpComms := TOpcomms(MasterData[i].MainData);
                          Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, 'Intégration des données...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
                          AddToMemo('Mise à jour de : ' + MasterData[i].MainData.Title);
                          FLabelProgress.Caption :=  'Intégration des données de ' + MasterData[i].Title;
                          MasterData[i].MainData.ProgressBar := FProgressBar;

                          IBOTransaction.StartTransaction;
                          MasterData[i].MainData.DoMajTable(bDoMaj);
                          IBOTransaction.Commit;
                          Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, Format( 'Intégration : Ajout = %d, Mise à jour = %d', [ MasterData[ i ].MainData.Insertcount, MasterData[ i ].MainData.Majcount ] ), logTrace, False, DM_MSS.LogFreq, ltLocal );
                          AddToMemo('Ajout : ' + IntToStr(MasterData[i].MainData.Insertcount) + ' ' +
                                    'Maj : ' + IntToStr(MasterData[i].MainData.Majcount));
                          iCumulNew := iCumulNew + MasterData[i].MainData.Insertcount;
                          if MasterData[i].MainData.UpdateGenParam then
                            AddToMemo('Mise à jour GenParam Ok');
                          Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, 'Intégration effectuée', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                        end;
                      Except on E:Exception do
                        begin
                          Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                          AddToMemo('Erreur MAJ : ' + E.Message);
                          IBOTransaction.Rollback;
                        end;
                      end;

                      for j := 0 to MasterData[i].MainData.ErrLogs.Count -1 do
                      begin
                        Log.Log( '', 'Import', '', DM_MSS.LogRef, '', MasterData[ i ].Title, MasterData[ i ].MainData.ErrLogs[ j ], logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
                        AddToMemo('Logs : ' + MasterData[i].Title + ' - ' + MasterData[i].MainData.ErrLogs.Strings[j]);
                      end;
                      MasterData[i].MainData.ErrLogs.Clear;

                    end;
                  end; //for i
                  Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Données de base (OPComm seulement) intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  Log.Log( '', 'Import', '', '', '', 'Status', 'Données de base (OPComm seulement) intégrées', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                  {$ENDREGION}

                  {$REGION 'Génération du mail'}
                  lst := TStringList.Create;
                  lstCumulArt := TStringList.Create;
                  lstCumulCmd := TStringList.Create;
                  lstRejectCmd := TStringList.Create;
                  lstCumulRecep := TStringList.Create;

                  lst.LoadFromFile(GFILESDIR + 'mail.html');

                  lst.Text := StringReplace(lst.Text,'@DATE@',FormatDateTime('DD/MM/YYYY',Now),[rfReplaceAll]);
                  lst.Text := StringReplace(lst.Text,'@HEURE@',FormatDateTime('hh:mm:ss',Now),[rfReplaceAll]);
                  lst.Text := StringReplace(lst.Text,'@MAGASIN@',MagNom,[rfReplaceAll]);
                  try
                    // récupération des informations des fichiers ORD/SD
                    for i := 0 to Length(GroupData) -1 do
                    begin
                      if GroupData[i].MainData.InheritsFrom(TCommandeClass) then
                      begin
                        if not TCommandeClass(GroupData[i].MainData).IsOnError then
                          if TCommandeClass(GroupData[i].MainData).NewArtList.Count > 0 then
                            lstCumulArt.Add(TCommandeClass(GroupData[i].MainData).NewArtList.Text);

                        if TCommandeClass(GroupData[i].MainData).NewCmdList.Count > 0 then
                          lstCumulCmd.Add(TCommandeClass(GroupData[i].MainData).NewCmdList.Text);
                      end;
                    end;
                    // Récupération des informations des fichiers SDUPDATE
                    for i := 0 to Length(ModifData) - 1 do
                    begin
                      if TSDUpdate(ModifData[i].MainData).NewArtList.Count > 0 then
                        lstCumulArt.Add(TSDUpdate(ModifData[i].MainData).NewArtList.Text);
                    end;

                    // BL
                    for i := 0 to Length(RecepData) -1 do
                    begin
                      if not TReceptionClass(RecepData[i].MainData).IsOnError then
                        if TReceptionClass(RecepData[i].MainData).NewArtList.Count > 0 then
                          lstCumulArt.Add(TReceptionClass(RecepData[i].MainData).NewArtList.Text);

                      if TReceptionClass(RecepData[i].MainData).RecepList.Count > 0 then
                        lstCumulRecep.Add(TReceptionClass(RecepData[i].MainData).RecepList.Text);
                    end;

                    // Transfert des informations dans le mail
                    bSendMail := False;

                    // Article
                    if lstCumulArt.Count > 0 then
                    begin
                      lst.Text := StringReplace(lst.Text,'@NEWARTICLES@', lstCumulArt.Text,[rfReplaceAll]);
                      bSendMail := True;
                    end
                    else
                      lst.Text := StringReplace(lst.Text,'@NEWARTICLES@','<tr><td class="ARTNOM-LG">Pas de nouveaux articles</td></tr>',[rfReplaceAll]);

                    // commande
                    if lstCumulCmd.Count > 0 then
                    begin
                      lst.Text := StringReplace(lst.Text,'@NEWCOMMANDES@',lstCumulCmd.Text,[rfReplaceAll]);
                      bSendMail := True;
                    end
                    else
                      lst.Text := StringReplace(lst.Text,'@NEWCOMMANDES@','<tr><td class="NUMIF-LG">Pas de nouvelles commandes</td></tr>',[rfReplaceAll]);

                    // Offres commerciales
                    if Assigned(OpComms) then
                    begin
                      if OpComms.NewOC.Count > 0 then
                      begin
                        lst.Text := StringReplace(lst.Text,'@NEWOFFCOM@',OpComms.NewOC.Text,[rfReplaceAll]);
                        bSendMail := True;
                      end
                      else
                        lst.Text := StringReplace(lst.Text,'@NEWOFFCOM@','<tr><td class="OC-LG">Pas de nouvelles offres commerciales</td></tr>',[rfReplaceAll]);
                    end
                    else
                      lst.Text := StringReplace(lst.Text,'@NEWOFFCOM@','<tr><td class="OC-LG">Pas de nouvelles offres commerciales</td></tr>',[rfReplaceAll]);

                    // BL
                    if lstCumulRecep.Count > 0 then
                    begin
                      lst.Text := StringReplace(lst.Text,'@NEWBORDEREAUX@',lstCumulRecep.Text,[rfReplaceAll]);
                      bSendMail := True;
                    end
                    else
                      lst.Text := StringReplace(lst.Text,'@NEWBORDEREAUX@','<tr><td class="NUMBL-LG">Pas de nouveau bordereau</td></tr>',[rfReplaceAll]);


                    // Envoi du mail
                    if bSendMail then
                    begin
                      // sauvegarde du rapport
                      lst.SaveToFile(GAPPRAPPORT + StringReplace(CodeGroup,'/','-',[rfReplaceAll]) + '-' + FormatDateTime('YYYYMMDDhhmmssnnn-',Now) + 'Mail.html');

                      if DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILMODE').AsInteger = 1 then
                        if Trim(DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILSENDTO').AsString) <> '' then
                          SendMailList(lst,CodeGroup, '',MagNom, DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILSENDTO').AsString);
                    end;

                    {$REGION 'Remise à zéro de l''initialisation après traitement'}
    //                  With DM_DbMAG,Que_DbMTmp do
    //                    if not bOneBase and (Que_DOSSIERS.FieldByName('DOS_PERIODEINIT').AsInteger = 1) then
    //                    begin
    //                      AddToMemo(' -> Remise à zéro de l''initialisation');
    //                      DM_DbMAG.IBOTransDbM.StartTransaction;
    //
    //                      Close;
    //                      SQL.Clear;
    //                      SQL.Add('Update Dossiers set');
    //                      SQL.Add(' DOS_PERIODEINIT = :PDOSPERIODEINIT,');
    //                      SQL.Add(' DOS_PERIODEDEBUT = :PDOSPERIODEDEBUT,');
    //                      SQL.Add(' DOS_PERIODEFIN = :PDOSPERIODEFIN,');
    //                      SQL.Add(' DOS_PERIODELIVRAISON = :PDOSPERIODELIVRAISON');
    //                      SQL.Add('Where DOS_ID = :PDOSID');
    //                      ParamCheck := True;
    //                      ParamByName('PDOSPERIODEINIT').AsInteger := 0;
    //                      ParamByName('PDOSPERIODEDEBUT').Clear;
    //                      ParamByName('PDOSPERIODEFIN').Clear;
    //                      ParamByName('PDOSPERIODELIVRAISON').Clear;
    //                      ParamByName('PDOSID').AsInteger := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
    //                      ExecSQL;
    //                      DM_DbMAG.IBOTransDbM.Commit;
    //                    end;
                    {$ENDREGION}

                  finally
                    lst.Free;
                    lstCumulArt.Free;
                    lstCumulCmd.Free;
                    lstRejectCmd.Free;
                    lstCumulRecep.Free;
                  end;
                  {$ENDREGION}
                end;

              Except on E:Exception do
                begin
                  AddToMemo('ExecuteProcess/OpenDataBase -> ' + E.Message);
                  if bJeton then            //En cas de plantage on relache le jeton
                  begin
                    if Assigned(TokenManager) then
                    begin
                      TokenManager.releaseToken;
                      FreeAndNil(TokenManager);
                    end;
    //                StopTokenEnBoucle;      //Relache le jeton
                    bJeton := False;
                  end;
                end;
              end;

              // On ne met à jour que si on a eu un jeton
              if bJeton then
              begin
                // Met la date de dernier traitement à jour
                DM_DbMAG.IboDbMag.StartTransaction;
                Try
                  DM_DbMAG.IboDbMag.ExecSQL('Update DOSSIERS Set DOS_LAST = ' +
                                               QuotedStr(FormatDateTime('YYYY-MM-DD hh:mm:ss',Now)) +
                                            ' Where DOS_ID = ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_ID').AsString);
                DM_DBMag.IboDbMag.Commit;
                Except on E:Exception do
                  begin
                    DM_DBMag.IboDbMag.Rollback;
                    AddToMemo('Mise à jour Dossier : ' + E.Message);
                  end;
                End;
              end;

              // Activation du loop si nécessaire
              LoopAutoActive(iCumulNew);

              if bOneBase then
              begin
                Log.Log( '', 'Main', '', '', '', 'Status', 'Ok', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
                AddToMemo('Traitement terminé');
                Exit;
              end;
              AddToMemo('---------------------------------------------------');
              DoArchiveGroupList(GroupData, CodeGroup);
              DoArchiveGroupList(ModifData, CodeGroup);
              DoArchiveGroupList(RecepData, CodeGroup);
              Log.Log( '', 'Main', '', '', '', 'Status', UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ) + ' : Nettoyage de l''arborescence du groupe : ' + CodeGroup, logTrace, False, DM_MSS.LogFreq, ltLocal );
              DoDeleteXmlGroup( CodeGroup );

              DM_DbMAG.Que_DOSSIERS.Next;

            finally
              //On ne relache le jeton que si bJeton est vrai et si nous sommes en fin de liste ou si la base est différente.
              if (bJeton and (DM_DbMAG.Que_DOSSIERS.Eof or (OldBase <> DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString)))then
              begin
                Try
                  if Assigned(TokenManager) then
                  begin
                    TokenManager.releaseToken;
                    FreeAndNil(TokenManager);
                  end;
    //              StopTokenEnBoucle;      //Relache le jeton
                  bJeton := False;
                Except on E:Exception do
                  AddToMemo('Jeton Liberation -> ' + E.Message);
                End;
              end;
            end;
          end; // while

          // Archivage des fichiers Zip
          DoArchiveFileList(MasterData);

          Log.Log( 'Main', '', '', 'Status', 'Ok', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
          AddToMemo('Traitement terminé');
        end
        else
        begin
          Log.Log( 'FTP', '', '', 'Status', 'FTP non ouvert', logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
          AddToMemo('FTP non ouvert');
        end;
      Except
        on E:Exception do
        begin
          Log.Log( 'Main', '', '', 'Status', 'Erreur : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
          AddToMemo('ExecuteProcess -> ' + E.Message);
        end;
      end;
    end
    else begin
      AddToMemo('Cycle non traité car hors période');
    end;
  finally
    FFile.Free;
  end;
  DM_DbMAG.Que_DOSSIERS.Filtered := False;
  GinkoiaIBDB.Disconnect;

  // Vidage mémoire
  for i := Low(MasterData) to High(MasterData) do
    MasterData[i].MainData.Free;
  SetLength(MasterData,0);

  for i := Low(GroupData) to High(GroupData) do
    GroupData[i].MainData.Free;
  SetLength(GroupData,0);

  for i := Low(ModifData) to High(ModifData) do
    ModifData[i].MainData.Free;
  SetLength(ModifData,0);

  for i := Low(RecepData) to High(RecepData) do
    RecepData[i].MainData.Free;
  SetLength(RecepData,0);
end;

function TDM_MSS.GetGenParamInfo(PRM_TYPE, PRM_CODE, PRM_MAGID : Integer): String;
begin
  With Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select PRM_INFO From GenParam');
    SQL.Add('  join K on K_ID = PRM_ID and K_Enabled = 1');
    SQL.Add('Where PRM_TYPE = :PPRMTYPE');
    SQL.Add('  and PRM_CODE = :PPRMCODE');
    SQL.Add('  and PRM_MAGID = :PPRMMAGID');
    ParamCheck := True;
    ParamByName('PPRMTYPE').AsInteger := PRM_TYPE;
    ParamByName('PPRMCODE').AsInteger := PRM_CODE;
    ParamByName('PPRMMAGID').AsInteger := PRM_MAGID;
    Open;

    if RecordCount > 0 then
      Result := FieldByName('PRM_INFO').AsString
    else
      raise Exception.Create(Format('Paramètre inéxistant : (%d/%d/%d)',[PRM_TYPE,PRM_CODE,PRM_MAGID]));
  end;
end;

procedure TDM_MSS.FillLogRefWithLameGUID;
begin
  try
    try
      Que_Tmp.Close;
      Que_Tmp.SQL.Text := 'select genbases.bas_guid ' +
                          'from genbases ' +
                          'join k kbas on kbas.k_id = genbases.bas_id and kbas.k_enabled = 1 ' +
                          'where genbases.bas_ident = ''0'' ';
      case Que_Tmp.RecordCount of
        1: FLogRef := Que_Tmp.FieldByName( 'bas_guid' ).AsString;
        else FLogRef := '';
      end;
    finally
      Que_Tmp.Close;
      Que_Tmp.SQL.Clear;
    end;
  except
    // Au pires on l'a pas récupéré ^^
  end;
end;

function TDM_MSS.GetMagID(DOS_CODE, DOS_MAGNOM: String): integer;
begin
  With Que_MasterData do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select MAG_ID from GENMAGASIN');
    SQL.Add('  join K on K_ID = MAG_ID and K_Enabled = 1');
    SQL.Add('Where MAG_CODEADH = :PCODEADH');
    SQL.Add('  and MAG_ENSEIGNE = :PMAGNOM');
    ParamCheck := True;
    ParamByName('PCODEADH').AsString := DOS_CODE;
    ParamByName('PMAGNOM').AsString  := DOS_MAGNOM;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('MAG_ID').AsInteger
    else
      Result := -1;
  Except on E:Exception do
    raise Exception.Create('GetMagID -> ' + E.Message);
  end;
end;

function TDM_MSS.GetMasterDataFiles (ALocalMode : Boolean = False): Boolean;
var
  i, j: Integer;
  bFound : Boolean;
begin
  try
    if not AlocalMode then
    begin
      try
        // Revenir au répertoire de base
        while IdFTP.RetrieveCurrentDir <> '/' do
          IdFTP.ChangeDirUp;

        Log.Log( 'MasterDatas', '', '', 'MasterData', 'Téléchargement des fichiers...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

        // Positionnement dans le répertoire des fichiers datas
        IdFTP.ChangeDir(IniStruct.FTP.MasterDataFTP.MasterDataDatas);
        // téléchargement des fichiers
        for i := Low(MasterData) to High(MasterData) do
        begin
          DeleteFileIfExist(GXMLMDPATH + MasterData[i].Path);
          if IdFTP.Size(MasterData[i].Path) <> -1 then
          begin
            FLabelProgress.Caption := 'Récupération du fichier : ' + MasterData[i].Path;
            FLabelProgress.Update;
            Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Téléchargement en cours...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
            try
              IdFTP.Get(MasterData[i].Path,GXMLMDPATH + MasterData[i].Path,True,True);
              Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Téléchargés avec succès', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
            except
              on E: Exception do
              begin
                Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Erreur lors du téléchargement du fichier : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
                raise;
              end;
            end;
          end;
        end;
        Log.Log( 'MasterDatas', '', '', 'MasterData', 'Téléchargement réalisé avec succès', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
      except
        on E: Exception do
        begin
          Log.Log( 'MasterDatas', '', '', 'MasterData', 'Erreur lors du téléchargement des fichiers : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
          raise;
        end;
      end;
    end;

    Log.Log( 'MasterDatas', '', '', 'MasterData', 'Traitement des fichiers...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
    try
      // traitement des fichiers
      for i := Low(MasterData) to High(MasterData) do
      begin
        Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Recherche d''un traitement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
        bFound := False;
        // Si PRM_CODE = 0 alors on ne traitera pas les mises à jours des tables
        case AnsiIndexStr(UpperCase(MasterData[i].Title),['BRANDS','FEDAS','SIZES','SUPPLIERS','UNIVERSCRITERIAS',
                                                          'COLLECTIONS','OPCOMMS', 'PERIODS', 'CORRESPSIZES', 'FEDASUNIVERS', 'SDUPDATE']) of
          0: begin // BRANDS
            MasterData[i].MainData := TBrands.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_BRANDS;
            MasterData[i].MainData.KTB_ID   := CKTBID_MARQUE;
            bFound := True;
          end; // 0 BRANDS
          1: begin // FEDAS
            MasterData[i].MainData := TFedas.Create;
            MasterData[i].MainData.PRM_CODE := CPMCODE_FEDAS;
            bFound := True;
          end; // 1 FEDAS
          2: begin // SIZES
            MasterData[i].MainData := TSizes.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_SIZES;
            bFound := True;
          end; // 2 SIZES
          3: begin // SUPPLIERS
            MasterData[i].MainData := TSuppliers.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_SUPPLIERS;
            MasterData[i].MainData.KTB_ID   := CKTBID_SUPPLIERS;
            bFound := True;
          end; // 3 SUPPLIERS
          4: begin // UNIVERSCRITERIAS
            MasterData[i].MainData := TUniversCriteria.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_UNIVERSCRITERIAS;
            bFound := True;
          end; // 4 UNIVERSCRITERIAS
          5: begin // COLLECTIONS
            MasterData[i].MainData := TCollections.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_COLLECTIONS;
            MasterData[i].MainData.KTB_ID   := CKTBID_COLLECTIONS;
            bFound := True;
          end; // 5 COLLECTIONS
          6: begin // Opcomms
            MasterData[i].MainData := TOpComms.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_OPCOMMS;
            MasterData[i].MainData.KTB_ID   := CKTBID_OCTETE;
            bFound := True;
          end; // 6 OpComms
          7: begin // PERIODS
            MasterData[i].MainData := TPeriods.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_PERIODS;
            bFound := True;
          end; // 7 PERIODS
          8: begin // CORRESPSIZES
            MasterData[i].MainData := TCorrespSizes.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_CORRESP;
            bfound := True;
          end; // 8 CORRESPSIZES
          9: begin // FEDASUNIVERS
            MasterData[i].MainData := TFedasUnivers.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_FEDASUNIVERS;
            bfound := True;
          end; // 9 FEDASUNIVERS
          10: begin // 10 SDUPDATE
            MasterData[i].MainData := TSDUpdateCommun.Create;
            MasterData[i].MainData.PRM_CODE := CPRMCODE_SDUPDATECOMMUN;
            bfound := True;
            MasterData[i].MainData.AutoCommit := False;
            MasterData[i].MainData.CanUpdateGenParam := IniStruct.SdUpdateActif;
          end; // 10 SDUPDATE
          else begin
            MasterData[i].MainData := TMainClass.Create;
            MasterData[i].MainData.PRM_CODE := 0;
            MasterData[i].MainData.KTB_ID   := 0;
          end;
        end; // case

        if not bFound then
        begin
          Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Traitement non trouvé', logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
        end
        else
        begin
          Log.Log( 'MasterDatas', '', '', MasterData[ i ].Title, 'Traitement trouvé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
          AddToMemo(MasterData[i].Title + ' : Traitement du fichier : ' + MasterData[i].Path);
          MasterData[i].MainData.PRM_TYPE := CPRMTYPE;
          MasterData[i].MainData.IboQuery := Que_MasterData;
          MasterData[i].MainData.StpQuery := stp_MasterData;
          MasterData[i].MainData.Title    := MasterData[i].Title;
          MasterData[i].MainData.Path     := GXMLMDPATH;
          MasterData[i].MainData.Filename := MasterData[i].Path;
          Log.Log( 'MasterDatas', '', '', MasterData[i].Title, 'Dezippage & chargement...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

          if MasterData[i].MainData.UnZipFile then
          begin
            AddToMemo(MasterData[i].Title + ' : Dezippage effectué');
            MasterData[i].MainData.Import;
            AddtoMemo(MasterData[i].Title + ' : Chargement Ok');

            for j := 0 to MasterData[i].MainData.ErrLogs.Count -1 do
            begin
              Log.Log('', 'MasterDatas', '', DM_MSS.LogRef, '', MasterData[ i ].Title, MasterData[ i ].MainData.ErrLogs[ j ], logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );
              AddToMemo(MasterData[i].Title + ' - ' + MasterData[i].MainData.ErrLogs.Strings[j]);
            end;
            MasterData[i].MainData.ErrLogs.Clear;

            if MasterData[i].MainData.ErrLogs.Count = 0 then
              Log.Log( 'MasterDatas', '', '', MasterData[i].Title, 'Chargé', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType )
            else
              Log.Log( 'MasterDatas', '', '', MasterData[i].Title, 'Chargé', logWarning, False, DM_MSS.LogFreq, DM_MSS.LogType );

          end
          else begin
            AddToMemo(MasterData[i].Title + ' : Echec Dezippage');
            Log.Log( 'MasterDatas', '', '', MasterData[i].Title, 'Echec Dézippage', logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
          end;
        end;
      end; // for
      Log.Log( 'MasterDatas', '', '', 'MasterData', 'Fichiers traités', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
    except
      on E: Exception do
      begin
        Log.Log( 'MasterDatas', '', '', 'MasterData', E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
        raise;
      end;
    end;

  Except on E:Exception do
    raise Exception.Create('GetMasterDataFiles -> ' + E.Message);
  end;
end;

procedure TDM_MSS.InitializeLog;
begin
  FLogFreq := IniStruct.Time * 2;
  {$IFDEF DEBUG}
  FLogType := uLog.TLogType.ltBoth;  // ltLocal
//  Log.OnLog := OnLog;
  {$ELSE}
  FLogType := uLog.TLogType.ltBoth;
  {$ENDIF}
end;

procedure TDM_MSS.LoadFTPLocalFiles(const Group: String);
var
  FileKind: TFileKind;
  FTPFilePath, BaseName: TFileName;
  SearchRec : TSearchRec;
  i: Integer;
  Files: TStringList;
  GroupDataLength, ModifDataLength, RecepDataLength: Integer;
begin
  try
    Log.Log( '', 'Main', '', '', '', 'Status', Format( '%s (%s) : Chargement des fichiers...', [ UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ), Group ] ), logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );

    Files := TStringList.Create;
    try
      GroupDataLength := Length( GroupData );
      ModifDataLength := Length( ModifData );
      RecepDataLength := Length( RecepData );

      for FileKind := Low( TFileKind ) to High( TFileKind ) do
      begin
        Files.Clear;
        case FileKind of
          fkCOMMANDE: begin
            FTPFilePath := GetFTPLocalPath( Group, FileKind );
            {$REGION 'Génération de la liste des fichiers' }
            if SysUtils.FindFirst( FTPFilePath + '*.*', faAnyFile, SearchRec ) = 0 then
            begin
              repeat
                if SameText( SearchRec.Name, '.' )
                or SameText( SearchRec.Name, '..' )
                or ( SearchRec.Size = 0 ) then
                  Continue;
                Files.Add( UpperCase( SearchRec.Name ) );
              until SysUtils.FindNext( SearchRec ) <> 0;
              SysUtils.FindClose( SearchRec );
            end;
            {$ENDREGION}
            {$REGION 'Alimentation du GroupData avec les fichiers qui match'}
            for i := 0 to Pred( Files.Count ) do
            begin
              // Récupération du BaseName (exploitable dans le cas d'un fichier "_ORD.XML")
              BaseName := LeftStr( Files[ i ], Pred( Pos( '_ORD.XML', Files[ i ] ) ) );

              // Vérification que le fichier actuel est un fichier ORD et qu'il existe un fichier SD associé
              if ContainsText( Files[ i ], '_ORD.XML' )
              and ( Files.IndexOf( BaseName + '_SD.XML' ) > -1 ) then
              begin
                SetLength( GroupData, Succ( GroupDataLength ) );
                GroupData[ GroupDataLength ].MainData := TCommandeClass.Create;
                TCommandeClass( GroupData[ GroupDataLength ].MainData ).TVATable := Que_TVAList;
                TCommandeClass( GroupData[ GroupDataLength ].MainData ).MarqueTable := Que_MarqueList;
                TCommandeClass( GroupData[ GroupDataLength ].MainData ).FournTable := Que_FournList;
                GroupData[ GroupDataLength ].MainData.IboQuery := Que_GroupData;
                GroupData[ GroupDataLength ].MainData.StpQuery := stp_GroupData;
                GroupData[ GroupDataLength ].Title := BaseName;
                GroupData[ GroupDataLength ].MainData.Title := GroupData[ GroupDataLength ].Title;
                GroupData[ GroupDataLength ].MainData.Filename := GroupData[ GroupDataLength ].Title;
                GroupData[ GroupDataLength ].Path := FTPFilePath;
                GroupData[ GroupDataLength ].MainData.Path := GroupData[ GroupDataLength ].Path;
                GroupData[ GroupDataLength ].MainData.KTB_ID := CKTBID_COMBCDE;
                Inc( GroupDataLength );
              end;
            end;
            {$ENDREGION}
          end;
          fkORD_DELETE: begin
            FTPFilePath := GetFTPLocalPath( Group, FileKind );
            {$REGION 'Génération de la liste des fichiers' }
            if SysUtils.FindFirst( FTPFilePath + '*.*', faAnyFile, SearchRec ) = 0 then
            begin
              repeat
                if SameText( SearchRec.Name, '.' )
                or SameText( SearchRec.Name, '..' )
                or ( SearchRec.Size = 0 ) then
                  Continue;
                Files.Add( UpperCase( SearchRec.Name ) );
              until SysUtils.FindNext( SearchRec ) <> 0;
              SysUtils.FindClose( SearchRec );
            end;
            {$ENDREGION}
            {$REGION 'Alimentation du GroupData avec les fichiers qui match'}
            for i := 0 to Pred( Files.Count ) do
            begin
              // Récupération du BaseName (exploitable dans le cas d'un fichier "_ORDDELETE.XML")
              BaseName := LeftStr( Files[ i ], Pred( Pos( '_ORDDELETE.XML', Files[ i ] ) ) );

              // Vérification que le fichier actuel est un fichier ORDDELETE
              if ContainsText( Files[ i ], '_ORDDELETE.XML' ) then
              begin
                SetLength( GroupData, Succ( GroupDataLength ) );
                GroupData[ GroupDataLength ].MainData := TOrdDeleteClass.Create;
                GroupData[ GroupDataLength ].MainData.IboQuery := Que_GroupData;
                GroupData[ GroupDataLength ].MainData.StpQuery := stp_GroupData;
                GroupData[ GroupDataLength ].Title := BaseName;
                GroupData[ GroupDataLength ].MainData.Title := GroupData[ GroupDataLength ].Title;
                GroupData[ GroupDataLength ].MainData.Filename := GroupData[ GroupDataLength ].Title;
                GroupData[ GroupDataLength ].Path := FTPFilePath;
                GroupData[ GroupDataLength ].MainData.Path := GroupData[ GroupDataLength ].Path;
                GroupData[ GroupDataLength ].MainData.KTB_ID := CKTBID_COMBCDE;
                Inc( GroupDataLength );
              end;
            end;
            {$ENDREGION}
          end;
          fkMODIF_ARTICLE: begin
            FTPFilePath := GetFTPLocalPath( Group, FileKind );
            {$REGION 'Génération de la liste des fichiers' }
            if SysUtils.FindFirst( FTPFilePath + '*.*', faAnyFile, SearchRec ) = 0 then
            begin
              repeat
                if SameText( SearchRec.Name, '.' )
                or SameText( SearchRec.Name, '..' )
                or ( SearchRec.Size = 0 ) then
                  Continue;
                Files.Add( UpperCase( SearchRec.Name ) );
              until SysUtils.FindNext( SearchRec ) <> 0;
              SysUtils.FindClose( SearchRec );
            end;
            {$ENDREGION}
            {$REGION 'Alimentation du GroupData avec les fichiers qui match'}
            for i := 0 to Pred( Files.Count ) do
            begin
              // Récupération du BaseName
              BaseName := ChangeFileExt( Files[ i ], '' );

              SetLength( ModifData, Succ( ModifDataLength ) );
              ModifData[ ModifDataLength ].MainData := TSDUpdate.Create;
              TSDUpdate( ModifData[ ModifDataLength ].MainData ).TVATable := Que_TVAList;
              TSDUpdate( ModifData[ ModifDataLength ].MainData ).MarqueTable := Que_MarqueList;
              TSDUpdate( ModifData[ ModifDataLength ].MainData ).FournTable := Que_FournList;
              ModifData[ ModifDataLength ].MainData.IboQuery := Que_GroupData;
              ModifData[ ModifDataLength ].MainData.StpQuery := stp_GroupData;
              ModifData[ ModifDataLength ].Title := BaseName;
              ModifData[ ModifDataLength ].MainData.Title := ModifData[ ModifDataLength ].Title;
              ModifData[ ModifDataLength ].MainData.Filename := Files[ i ];
              ModifData[ ModifDataLength ].Path := FTPFilePath;
              ModifData[ ModifDataLength ].MainData.Path := ModifData[ ModifDataLength ].Path;
              Inc( ModifDataLength );
            end;
            {$ENDREGION}
          end;
          fkBL: begin
            FTPFilePath := GetFTPLocalPath( Group, FileKind );
            {$REGION 'Génération de la liste des fichiers' }
            if SysUtils.FindFirst( FTPFilePath + '*.*', faAnyFile, SearchRec ) = 0 then
            begin
              repeat
                if SameText( SearchRec.Name, '.' )
                or SameText( SearchRec.Name, '..' )
                or ( SearchRec.Size = 0 ) then
                  Continue;
                Files.Add( UpperCase( SearchRec.Name ) );
              until SysUtils.FindNext( SearchRec ) <> 0;
              SysUtils.FindClose( SearchRec );
            end;
            {$ENDREGION}
            {$REGION 'Alimentation du GroupData avec les fichiers qui match'}
            for i := 0 to Pred( Files.Count ) do
            begin
              // Récupération du BaseName
              BaseName := ChangeFileExt( Files[ i ], '' );

              SetLength( RecepData, Succ( RecepDataLength ) );
              RecepData[ RecepDataLength ].MainData := TReceptionClass.Create;
              TReceptionClass( RecepData[ RecepDataLength ].MainData ).MarqueTable := Que_MarqueList;
              TReceptionClass( RecepData[ RecepDataLength ].MainData ).FournTable := Que_FournList;
              TReceptionClass( RecepData[ RecepDataLength ].MainData ).TVATable := Que_TVAList;
              RecepData[ RecepDataLength ].MainData.IboQuery := Que_GroupData;
              RecepData[ RecepDataLength ].MainData.StpQuery := stp_GroupData;
              RecepData[ RecepDataLength ].Title := BaseName;
              RecepData[ RecepDataLength ].MainData.Title := RecepData[ RecepDataLength ].Title;
              RecepData[ RecepDataLength ].MainData.Filename := Files[ i ];
              RecepData[ RecepDataLength ].Path := FTPFilePath;
              RecepData[ RecepDataLength ].MainData.Path := RecepData[ RecepDataLength ].Path;
              Inc( RecepDataLength );
            end;
            {$ENDREGION}
          end;
        end;
      end;
      Log.Log( '', 'Main', '', '', '', 'Status', Format( '%s (%s) : Fichiers chargés', [ UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ), Group ] ), logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
    finally
      Files.Free;
    end;
  except
    on E: Exception do
    begin
      Log.Log( '', 'Main', '', '', '', 'Status', Format( '%s (%s) : %s', [ UpperCase( DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_NOM').AsString ), Group, E.Message ] ), logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
      raise Exception.CreateFmt( 'LoadFTPLocalFiles(%s) -> %s', [ Group, E.Message ] );
    end;
  end;
end;

procedure TDM_MSS.LogCodeGroup(const CodeGroup: String);
var
  Bookmark: TBookmark;
begin
  try
    Bookmark := cds_Magasin.GetBookmark;
    try
      cds_Magasin.First;
      while not cds_Magasin.Eof do
      begin
        try
          Log.Log('', 'Main', '', cds_Magasin.FieldByName('BAS_GUID').AsString, cds_Magasin.FieldByName('MAG_ID').AsString,
            'GRP', CodeGroup, logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
        finally
          cds_Magasin.Next;
        end;
      end;
    finally
      cds_Magasin.GotoBookmark( Bookmark );
      cds_Magasin.FreeBookmark( Bookmark );
    end;
  except
    // Au pires on n'a pas récupéré les guids ^^'
  end;
end;

procedure TDM_MSS.LoopAutoActive(iNbNew: Integer);
begin
  if iNbNew >= IniStruct.LoopMax then
  begin
    TRY
      // Activation du loop Article
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'ARTICLE_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;

    TRY
      // Activation du loop Dimension
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'DIMENSION_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;

    TRY
      // Activation du loop Commande
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := '';
      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'COMMANDE_';
      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
      IbStProc_SetLoop.Prepare;
      IbStProc_SetLoop.Execute;
      IbStProc_SetLoop.Unprepare;
      IbStProc_SetLoop.IB_Transaction.Commit;
    EXCEPT
      ON E: Exception DO
      BEGIN
        IbStProc_SetLoop.IB_Transaction.Rollback;
        raise Exception.Create('LoopAutoActive ->' + E.Message);
      END;
    END;

//    TRY
//      // Activation du loop Tarif
//      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := 'TARIF_C';
//      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'TARIF_';
//      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
//      IbStProc_SetLoop.Prepare;
//      IbStProc_SetLoop.Execute;
//      IbStProc_SetLoop.Unprepare;
//      IbStProc_SetLoop.IB_Transaction.Commit;
//    EXCEPT
//      ON E: Exception DO
//      BEGIN
//        IbStProc_SetLoop.IB_Transaction.Rollback;
//        raise Exception.Create('LoopAutoActive ->' + E.Message);
//      END;
//    END;
//
//    TRY
//      // Activation du loop Tarif OC
//      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := 'TARIFOC_C';
//      IbStProc_SetLoop.ParamByName('NOM_SUBSCRIBER').AsString := 'TARIFOC_';
//      IbStProc_SetLoop.ParamByName('FLAGACTIVE').AsInteger := 1;
//      IbStProc_SetLoop.Prepare;
//      IbStProc_SetLoop.Execute;
//      IbStProc_SetLoop.Unprepare;
//      IbStProc_SetLoop.IB_Transaction.Commit;
//    EXCEPT
//      ON E: Exception DO
//      BEGIN
//        IbStProc_SetLoop.IB_Transaction.Rollback;
//        raise Exception.Create('LoopAutoActive ->' + E.Message);
//      END;
//    END;
  end;
end;

procedure TDM_MSS.OnLog(Sender: TObject; LogItem: TLogItem);
begin
  FMemo.Lines.Add( Log.ItemToJSON( LogItem ) );
end;

function TDM_MSS.OpenFTP(AFTPCFG: TFTPCFG): Boolean;
begin
  Result := False;
  Log.Log( 'FTP', '', '', 'Status', 'Connexion au FTP...', logNotice, True, DM_MSS.LogFreq, DM_MSS.LogType );
  With IdFTP do
  try
    if Connected then
      Disconnect;
    Host := AFTPCFG.Host;
    Username := AFTPCFG.UserName;
    Password := AFTPCFG.Password;
    Port     := AFTPCFG.Port;
    Passive  := True;
    Connect;
//    AFTPCFG.BaseDir  := IniStruct.FTP.MasterDataFTP.Dossier;
    Result := True;
    Log.Log( 'FTP', '', '', 'Status', 'Connexion au FTP établie avec succès', logInfo, True, DM_MSS.LogFreq, DM_MSS.LogType );
  Except on E:Exception do
    begin
      Log.Log( 'FTP', '', '', 'Status', 'Erreur lors de la connexion au FTP : ' + E.Message, logError, False, DM_MSS.LogFreq, DM_MSS.LogType );
      AddToMemo('Erreur OpenFTP -> ' + E.Message);
      if Pos('#100',E.Message) > 0 then
         bDoRestart := True;
    end;
  end;
end;

function TDM_MSS.OpenIBDatabase(ABasePath: String): Boolean;
begin
  AddToMemo('Connexion à la base de données : ' + ABasePath);
  Result := False;
  // Ouverture de la base GINKOIA
  with GinkoiaIBDB do
  begin
    Close;
    DatabaseName := ABasePath;
    try
      Open;
      Result := True;
    Except on E:Exception do
      raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
    end;
  end;

end;

function TDM_MSS.SendMailList(ALst: TStrings; AGRP, AMAG, AMAGNOM, ASENDTO : String): Boolean;
begin
  Result := False;
  IdLogFile1.Filename := GAPPRAPPORT + AGRP + '-' + FormatDateTime('YYYYMMDDhhmmssnn',Now) + '.txt';
  IdLogFile1.Active := true;
  With IdSMTP1 do
  Try
    Try
      IdMessage.Clear;
      IdMessage.ContentType := 'multipart/mixed';
      IdMessage.Subject := Format('%s - Rapport d''intégration du %s ',[AGRP, FormatDateTime('DD/MM/YYYY à hh:mm:ss',Now)]);
      IdMessage.Body.Text := ALst.Text;

      With  TIdText.Create(IdMessage.MessageParts) do
      begin
        ContentType := 'text/html';
        CharSet := 'ISO-8859-1';
        Body.Text := IdMessage.Body.Text;
      end;

      With TIdAttachmentFile.Create(IdMessage.MessageParts, GFILESDIR + 'logo-IF.gif') do
      begin
        ContentType := 'image/gif';
        FileIsTempFile := false;
        ContentDisposition := 'inline';
        ExtraHeaders.Values['content-id'] := 'logo-IF.gif';
        DisplayName := 'logo-IF.gif';
      end;

//      With TIdAttachmentFile.Create(IdMessage.MessageParts, GFILESDIR + 'logo-GK.png') do
//      begin
//        ContentType := 'image/png';
//        FileIsTempFile := false;
//        ContentDisposition := 'inline';
//        ExtraHeaders.Values['content-id'] := 'logo-GK.png';
//        DisplayName := 'logo-GK.png';
//      end;

      IdMessage.From.Text := 'Admin@ginkoia.fr';
      IdMessage.Recipients.EMailAddresses := ASENDTO;
  //    IdMessage.BccList.EMailAddresses := 'thierry.fleisch@ginkoia.fr';


      Host     := 'pod51015.outlook.com';
      Username := 'Admin@ginkoia.fr';
      Password := 'Duda7196741';

      Try
        Port := 587;
        Connect;
      Except on E:Exception do
        begin
          try
          Port := 25;
          Connect;
          Except on E:Exception do
            raise Exception.Create('SendMailList Connexion -> ' + E.Message);
          end;
        end;
      End;

      Send(IdMessage);
      Result := True;
    Except on E:Exception do
      begin
        raise Exception.Create('SendMailList Envoi -> ' + E.Message);
      end;
    end;
  finally
    IdLogFile1.Active := False;
    if Connected then
      Disconnect(True);
  End; // with
end;

end.