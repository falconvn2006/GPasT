unit MSS_DM;

interface

uses
  SysUtils, Classes, DB, ADODB, IB_Components, IB_Access, IBODataset, StdCtrls,
  MSS_Type, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StrUtils,
  IdExplicitTLSClientServerBase, IdFTP, xmldom, XMLIntf, msxmldom, XMLDoc, Variants,
  MSS_MainClass, MSS_BrandsClass, MSS_SuppliersClass, MSS_SizesClass, MSS_CollectionsClass,
  MSS_PeriodsClass, MSS_UniversCriteriaClass, MSS_FedasClass, MSS_CommandeClass, MSS_OrdDeleteClass,
  MSS_OpCommsClass, MSS_CorrespsizesClass,
  ZipMstr19, ComCtrls, forms, wwDialog, wwidlg, IdMessage, IdMessageClient,
  IdSMTPBase, IdSMTP, HttpApp, IdText, IdAttachmentFile, MSS_DMDbMag, DateUtils, Types, Windows,
  DBClient;

type
  TDM_MSS = class(TDataModule)
    GinkoiaIBDB: TIBODatabase;
    ADOConnection: TADOConnection;
    IdFTP: TIdFTP;
    XMLDoc: TXMLDocument;
    ZipMaster191: TZipMaster19;
    Que_MasterData: TIBOQuery;
    IBOTransaction: TIBOTransaction;
    aQue_ListMagIS: TADOQuery;
    stp_MasterData: TIBOStoredProc;
    Que_GroupData: TIBOQuery;
    stp_GroupData: TIBOStoredProc;
    Que_GenMagasin: TIBOQuery;
    lku_GenMagasin: TwwLookupDialog;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    Que_Tmp: TIBOQuery;
    IbStProc_SetLoop: TIB_StoredProc;
    stp_ModifData: TIBOStoredProc;
    Que_ModifData: TIBOQuery;
    Que_UpdateDB: TIBOQuery;
    Que_TVAList: TIBOQuery;
    Que_MarqueList: TIBOQuery;
    Que_FournList: TIBOQuery;
    cds_Magasin: TClientDataSet;
    cds_MagasinMAG_ID: TIntegerField;
    cds_MagasinMAG_ENSEIGNE: TStringField;
    cds_MagasinNUMERO: TStringField;
  private
    FMemo: TMemo;
    FProgressBar : TProgressBar;
    FLabelProgress : TLabel;
    { Déclarations privées }
  public
    { Déclarations publiques }
    // Fonction principale de traitement
    function ExecuteProcess(DataBasePath : String = '') : Integer;

    // Ouverture de la base de données SQL Serveur
    function OpenSQL2KDatabase : Boolean;
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

    property Memo : TMemo read FMemo write FMemo;
    property ProgressLabel : TLabel read FLabelProgress write FLabelProgress;
    property ProgressBar : TProgressbar read FProgressBar write FProgressBar;
  end;

var
  DM_MSS: TDM_MSS;

implementation

{$R *.dfm}

{ TDM_MSS }

procedure TDM_MSS.AddToMemo(AText: String);
var
  FFile : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;
begin
  With FMemo do
  begin
    sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText;
    if Assigned(FMemo) then
      FMemo.Lines.Add(sLigne);

    if FileExists(GLOGSPATH + GLOGSNAME) then
    begin
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmOpenReadWrite);
      FFile.Seek(0,soFromEnd);
    end else
      FFile := TFileStream.Create(GLOGSPATH + GLOGSNAME,fmCreate);
    try
      // Ajoute un retour à la ligne pour le fichier text
      sLigne := sLigne + #13#10;

      Encoding := TEncoding.Default;
      Buffer := Encoding.GetBytes(sLigne);
      FFile.Write(Buffer[0],Length(Buffer));
    finally
      FFile.Free;
    end;
  end;
end;

function TDM_MSS.CheckGroupFile(AGroupDir: String): Boolean;
var
  lstTmp: TStringList;
  i, j,iPos: Integer;
  sText:  String;
begin
  Result := False;

  {$REGION 'Récupération des fichiers de commande'}
  // Revenir au répertoire de base
  while IdFTP.RetrieveCurrentDir <> '/' do
    IdFTP.ChangeDirUp;

  // se positionne sur le groupe GroupDirCommande
  try
    // On vide la mémoire de ce qui a été traité dans les groupData précédents
    if Length(GroupData) > 0 then
      for i := 0 to Length(GroupData) - 1 do
        GroupData[i].MainData.Free;

    SetLength(GroupData, 0);

    IdFtp.ChangeDir(AGroupDir + '/' + IniStruct.FTP.MasterDataFTP.GroupDirCommande);
    lstTmp := TStringList.Create;
    try

      IdFTP.List(lstTmp, '*.*', False);
      for i := 0 to lstTmp.Count - 1 do
        for j := 0 to Length(lstTmp[i]) do
          if lstTmp[i][j] in ['a'..'z'] then
          begin
            IdFTP.Rename(lstTmp[i], UpperCase(lstTmp[i]));
            Break;
          end;
      lstTmp.Clear;

      IdFTP.List(lstTmp, '*.SYNC', False);

      for i := 0 to lstTmp.Count - 1 do
        try
          // Vérification que le fichier Sync correspondant existe
          iPos := Pos('_ORD.XML', UpperCase(lstTmp[i]));
          if iPos > 0 then
            if (IdFTP.Size(StringReplace(lstTmp[i], 'ORD.XML.SYNC', 'SD.XML.SYNC', [])) <> -1) then
            begin
              // Chargement fichier ORD
              sText := LeftStr(lstTmp[i], Pos('.SYNC', lstTmp[i]) - 1);
              FLabelProgress.Caption := 'Récupération du fichier : ' + sText;
              FLabelProgress.Update;

              idFtp.Get(sText, GXMLSCPATH + sText, True);
              // Chargement fichier SD
              sText := StringReplace(sText, 'ORD.XML', 'SD.XML', []);
              idFtp.Get(sText, GXMLSCPATH + sText, True);

              // Fichier Commande
              SetLength(GroupData, Length(GroupData) + 1);
              with GroupData[Length(GroupData) - 1] do
              begin
                MainData := TCommandeClass.Create;
                TCommandeClass(MainData).TVATable := Que_TVAList;
                TCommandeClass(MainData).MarqueTable := Que_MarqueList;
                TCommandeClass(MainData).FournTable := Que_FournList;

                MainData.IboQuery := Que_GroupData;
                MainData.StpQuery := stp_GroupData;
                Title := Copy(lstTmp[i], 1, iPos - 1);
                MainData.Title := Title;
                MainData.FileName := Title;
                Path  := GXMLSCPATH;
                MainData.Path := Path;
                MainData.KTB_ID := CKTBID_COMBCDE;
              end;

              if IniStruct.RenameFtpFile then
              begin
                // Fichier ORD
                idFtp.Rename(lstTmp[i], 'T' + lstTmp[i]);
                sText := LeftStr(lstTmp[i], Pos('.SYNC', lstTmp[i]) - 1);
                idFtp.Rename(sText, 'T' + sText);
                // Fichier SD
                sText := StringReplace(UpperCase(sText), 'ORD.XML', 'SD.XML', []);
                idFtp.Rename(sText, 'T' + sText);
                sText := sText + '.SYNC';
                idFtp.Rename(sText, 'T' + sText);
              end
              else
                if IniStruct.DeleteFtpfile then
                begin
                  // Suppression du ORD
                  idFtp.Delete(lstTmp[i]);
                  sText := LeftStr(lstTmp[i], Pos('.SYNC', lstTmp[i]) - 1);
                  idFtp.Delete(sText);
                  // Suppression du SD
                  sText := StringReplace(UpperCase(sText), 'ORD.XML', 'SD.XML', []);
                  idFtp.Delete(sText);
                  sText := sText + '.SYNC';
                  idFtp.Delete(sText);
                end;
            end;

          FProgressBar.Position := (i + 1) * 100 div lstTmp.Count;
          Application.ProcessMessages;
        except
          on E: Exception do
            AddToMemo('Erreur FTP Commande : ' + E.Message);
        end;
    except
      on E: Exception do
        AddToMemo('Erreur Commande : ' + E.Message);
    end;
    {$ENDREGION}
  finally
    lstTmp.Free;
    IdFtp.Disconnect;
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
    if Result then
      IdFTP.Get('Masterdata.xml',GXMLMDPATH + 'Masterdata.xml',True,False);

  Except on E:Exception do
    begin
      raise Exception.Create('CheckMasterData -> ' + E.Message);
    end;
  end;
end;

function TDM_MSS.DoMasterDataFile: Boolean;
var
  nXmlBase ,
  eXmlNode : IXmlNode;
  i : Integer;
begin
  Result := False;
  try
    SetLength(MasterData,0);
    // ouverture du fichier  master data
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
  Except on E:Exception do
    begin
      raise Exception.Create('DoMasterDataFile -> ' + E.Message);
    end;
  end;
end;

function TDM_MSS.ExecuteProcess(DataBasePath : String) : Integer;
var
  i, j : integer;
  bOneBase, bBaseOpen, bDoMaj, bDoMajCmd : Boolean;
  iMagID : Integer;
  MagNom : String;
  OldBase : String;
  CodeGroup : String;
  lst, lstCumulArt, lstCumulCmd, lstRejectCmd : TStringList;
  iCumulNew : Integer;
  sPeriode : String;
  sTmp : String;
begin
  try
    OldBase := '';
    iCumulNew := 0;
    bOneBase := Trim(DataBasePath) <> '';
    // Ouverture du FTP master & récupération des fichiers
    if IdFTP.Connected then
      IdFTP.Disconnect;
    if OpenFTP(IniStruct.FTP.MasterDataFTP) then
    begin
      // Vérification et récupération du fichier masterdata
      if CheckMasterData then
        // traitement du fichier masterdata et récupération des nouveaux fichier si nécessaire
        if DoMasterDataFile then
          GetMasterDataFiles;
      if IdFTP.Connected then
        IdFTP.Disconnect;

      If not DM_DbMAG.Que_DOSSIERS.Active then
        DM_DbMAG.Que_DOSSIERS.Open;

      DM_DbMAG.Que_DOSSIERS.Filtered := False;
      DM_DbMAG.Que_DOSSIERS.Filter := 'DOS_ACTIF = 1';
      DM_DbMAG.Que_DOSSIERS.Filtered := True;

      DM_DbMAG.Que_DOSSIERS.First;

      while not DM_DbMAG.Que_DOSSIERS.Eof {or bOneBase} do
      begin
        try
          // Ouverture de la base de données ginkoia
          if OldBase <> DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString then
          begin
            // Vidage des tables des données de bases
            for i := low(MasterData) to High(MasterData) do
              MasterData[i].MainData.ClearIdField;

            AddToMemo('Ouverture de la base de données : ' + DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString);
            bBaseOpen := OpenIBDatabase(DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString);
            OldBase := DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_BASEPATH').AsString;

            // Récupération de la liste des magasins + Code magasin
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
                Post;
              end;

              Que_GenMagasin.Next;
            end;
            CodeGroup := GetGenParamInfo(12,18,0);

            {$REGION 'Intégration des données de base'}
            for i := Low(MasterData) to High(MasterData) do
            begin
              if  MasterData[i].MainData.PRM_CODE <> 0 then
              begin
                bDoMaj := MasterData[i].MainData.CheckFileMaj;
                if bDoMaj then
                begin
                  AddToMemo('Mise à jour de : ' + MasterData[i].MainData.Title);
                  FLabelProgress.Caption :=  'Intégration des données de ' + MasterData[i].Title;
                  MasterData[i].MainData.ProgressBar := FProgressBar;
                  try
                    IBOTransaction.StartTransaction;
                    MasterData[i].MainData.DoMajTable(bDoMaj);
                    IBOTransaction.Commit;
                    AddToMemo('Ajout : ' + IntToStr(MasterData[i].MainData.Insertcount) + ' ' +
                              'Maj : ' + IntToStr(MasterData[i].MainData.Majcount));
                    iCumulNew := iCumulNew + MasterData[i].MainData.Insertcount;
                    if MasterData[i].MainData.UpdateGenParam then
                      AddToMemo('Mise à jour GenParam Ok');
                  Except on E:Exception do
                    begin
                      AddToMemo('Erreur MAJ : ' + E.Message);
                      IBOTransaction.Rollback;
                    end;
                  end;
                end;

                for j := 0 to MasterData[i].MainData.ErrLogs.Count -1 do
                  AddToMemo('Logs : ' + MasterData[i].Title + ' - ' + MasterData[i].MainData.ErrLogs.Strings[j]);
                MasterData[i].MainData.ErrLogs.Clear;

              end;
            end; //for i
            {$ENDREGION}

            // Ouverture des tables communes
            if not Que_MarqueList.Active then
              Que_MarqueList.Open;
            if not Que_FournList.Active then
              Que_FournList.Open;
            if not Que_TVAList.Active then
              Que_TVAList.Open;
          end;


          if bBaseOpen then
          begin
//            AddToMemo('Magasin : ----' + MagNom + ' ----');
            // Récupération des commandes
            AddToMemo('Récupération des fichiers sur le FTP');
            {$REGION 'intégration des commandes'}
            if OpenFTP(IniStruct.FTP.MasterDataFTP) then
              if CheckGroupFile({'GRP_' + } CodeGroup) then
              begin
                for i := 0 to Length(GroupData) -1 do
                begin
                  FLabelProgress.Caption := 'Traitement du fichier : ' + GroupData[i].MainData.Title;
                  Application.ProcessMessages;

                  Try
                    GroupData[i].MainData.MAG_ID := iMagId;
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
                          AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title + sPeriode);
                          cds_Magasin.Filtered := False;
                          cds_Magasin.Filter := Format('NUMERO = %s',[QuotedStr(TCommandeClass(GroupData[i].MainData).CodeMag)]);
                          cds_Magasin.Filtered := True;

                          if (cds_Magasin.RecordCount <= 0) then
                            raise Exception.Create('Code magasin non trouvé : ' + TCommandeClass(GroupData[i].MainData).CodeMag);
                          If (cds_Magasin.RecordCount > 1) then
                            raise Exception.Create(Format('Le code magasin %s existe dans plusieurs magasin',[TCommandeClass(GroupData[i].MainData).CodeMag]));

                          TCommandeClass(GroupData[i].MainData).MAG_ID := cds_Magasin.FieldByName('MAG_ID').AsInteger;

                          IBOTransaction.StartTransaction;
                          GroupData[i].MainData.DoMajTable(True);
                          IBOTransaction.Commit;

                          iCumulNew := iCumulNew + TCommandeClass(GroupData[i].MainData).ArtInsCount +
                                                   TCommandeClass(GroupData[i].MainData).CmdInsCount;
                          AddToMemo('Nouveaux Articles : ' + IntToStr(TCommandeClass(GroupData[i].MainData).ArtInsCount));
                          AddToMemo('Mise à jour d''articles : ' + IntToStr(TCommandeClass(GroupData[i].MainData).ArtMajCount));
                          AddToMemo('Nombre de lignes : ' + IntToStr(TCommandeClass(GroupData[i].MainData).CmdInsCount));
                          AddToMemo('Nombre de lignes modifiées : ' + IntToStr(TCommandeClass(GroupData[i].MainData).CmdMajCount));
                        end
                        else begin
                          AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title + ' -> Commande Hors Période Init' + sPeriode);
                        end;
                      end;

                      1: begin // TOrdDeleteClass
                         AddToMemo('Traitement du fichier : ' + GroupData[i].MainData.Title);
                        IBOTransaction.StartTransaction;
                        GroupData[i].MainData.DoMajTable(True);
                        IBOTransaction.Commit;
                      end;
                    end; // case
                  Except on E:Exception do
                    begin
                      IBOTransaction.Rollback;
                      AddToMemo(E.Message);
                      // Déplace les fichiers dans le répertoire rejetés
                      sTmp := GARCHPATH + CodeGroup + '\' + GroupData[i].MainData.CodeMag + '\REJETEES\';
                      DoDir(sTmp);
                      sTmp := sTmp + GroupData[i].MainData.Title;
                      MoveFile(PWideChar(GroupData[i].MainData.Path + ExtractFileName(sTmp) + '_ORD.XML'),PWideChar(sTmp + '_ORD.XML'));
                      MoveFile(PWideChar(GroupData[i].MainData.Path + ExtractFileName(sTmp) + '_SD.XML'),PWideChar(sTmp + '_SD.XML'));
                      // Génére les fichiers sync
                      CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '_ORD.XML.SYNC'),False);
                      CopyFile(PWideChar(GFILESDIR + 'emptyfile.txt'),PWideChar(sTmp + '_SD.XML.SYNC'),False);
                    end;
                  End;

                  // Gestion des logs
                  if GroupData[i].MainData.ActionLogs.Count > 0 then
                    for j := 0 to GroupData[i].MainData.ActionLogs.Count -1 do
                      AddToMemo(GroupData[i].MainData.ActionLogs[j]);

                  if GroupData[i].MainData.ErrLogs.Count > 0 then
                    for j := 0 to GroupData[i].MainData.ErrLogs.Count -1 do
                      AddToMemo('Erreur : ' + GroupData[i].MainData.ErrLogs[j]);

                  if Assigned(FProgressBar) then
                    FProgressBar.Position := (i + 1) * 100 Div Length(GroupData);
                  Application.ProcessMessages;
                end; // for
              end;

                {$ENDREGION}

                {$REGION 'Génération du mail'}
                lst := TStringList.Create;
                lstCumulArt := TStringList.Create;
                lstCumulCmd := TStringList.Create;
                lstRejectCmd := TStringList.Create;

                lst.LoadFromFile(GFILESDIR + 'mail.html');

                lst.Text := StringReplace(lst.Text,'@DATEJOUR@',FormatDateTime('DD/MM/YYYY',Now),[rfReplaceAll]);
                lst.Text := StringReplace(lst.Text,'@MAGASIN@',MagNom,[rfReplaceAll]);
                try
                  for i := 0 to Length(GroupData) -1 do
                  begin
                    if GroupData[i].MainData.InheritsFrom(TCommandeClass) then
                    begin
                      if TCommandeClass(GroupData[i].MainData).NewArtList.Count > 0 then
                        lstCumulArt.Add(TCommandeClass(GroupData[i].MainData).NewArtList.Text);

                      if TCommandeClass(GroupData[i].MainData).NewCmdList.Count > 0 then
                        lstCumulCmd.Add(TCommandeClass(GroupData[i].MainData).NewCmdList.Text);

                      if TCommandeClass(GroupData[i].MainData).RejectCmdList.Count > 0 then
                        lstRejectCmd.Add(TCommandeClass(GroupData[i].MainData).RejectCmdList.Text);
                    end;
                  end;
                  if lstCumulArt.Count > 0 then
                    lst.Text := StringReplace(lst.Text,'@NEWARTICLES@', lstCumulArt.Text,[rfReplaceAll])
                  else
                    lst.Text := StringReplace(lst.Text,'@NEWARTICLES@','<tr><td id="LgnVide">Pas de nouveaux articles</td></tr>',[rfReplaceAll]);

                  if lstCumulCmd.Count > 0 then
                    lst.Text := StringReplace(lst.Text,'@NEWCOMMANDES@',lstCumulCmd.Text,[rfReplaceAll])
                  else                                                   // </table><table cellspacing="0" cellpadding="1" border="0">
                    lst.Text := StringReplace(lst.Text,'@NEWCOMMANDES@','<tr><td id="LgnVide900">Pas de nouvelles commandes</td></tr>',[rfReplaceAll]);

                  if lstRejectCmd.Count > 0 then
                    lst.Text := StringReplace(lst.Text,'@REJECTCOMMANDES@', lstRejectCmd.Text,[rfReplaceAll])
                  else
                    lst.Text := StringReplace(lst.Text,'@REJECTCOMMANDES@','<tr><td id="LgnVide">Pas de commandes modifiées</td></tr>',[rfReplaceAll]);

                  lst.Text := StringReplace(lst.Text,'@NEWOFFCOM@','<tr><td id="LgnVide">Pas de nouvelles offres commerciales</td></tr>',[rfReplaceAll]);
      //            lst.SaveToFile(GLOGSPATH + FormatDateTime('YYYYMMDD-',Now) + IntToStr(iMagID) + ' - Mail.html');
//                  if (lstCumulArt.Count > 0) or (lstCumulCmd.Count > 0) or (lstRejectCmd.Count > 0) then
//                  begin
//                    if DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILMODE').AsInteger = 1 then
//                      if Trim(DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILSENDTO').AsString) <> '' then
//                        SendMailList(lst,CodeGroup, GroupData[i].MainData.CodeMag,MagNom, DM_DbMAG.Que_DOSSIERS.FieldByName('DOS_MAILSENDTO').AsString);
//                  end;
                  lst.SaveToFile(GAPPRAPPORT + CodeGroup + {'-' + GroupData[i].MainData.CodeMag +} '-' + FormatDateTime('YYYYMMDDhhmmssnnn-',Now) + 'Mail.html');

                  // Remise à zéro de l'initialisation après traitement
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

                finally
                  lst.Free;
                  lstCumulArt.Free;
                  lstCumulCmd.Free;
                  lstRejectCmd.Free;
                end;
                {$ENDREGION}

          end;
        Except on E:Exception do
          AddToMemo('ExecuteProcess/OpenDataBase -> ' + E.Message);
        end;

        // Activation du loop si nécessaire
        LoopAutoActive(iCumulNew);

        if bOneBase then
        begin
          AddToMemo('Traitement terminé');
          Exit;
        end;
        AddToMemo('---------------------------------------------------');
        DoArchiveGroupList(GroupData, CodeGroup);
        DM_DbMAG.Que_DOSSIERS.Next;
      end; // while

      // Archivage des fichiers Zip
      DoArchiveFileList(MasterData);

      AddToMemo('Traitement terminé');
    end else
      AddToMemo('FTP non ouvert');
  Except on E:Exception do
    AddToMemo('ExecuteProcess -> ' + E.Message);
  end;
  DM_DbMAG.Que_DOSSIERS.Filtered := False;

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
  i: Integer;
  bFound : Boolean;
begin
  try
    if not AlocalMode then
    begin
      // Revenir au répertoire de base
      while IdFTP.RetrieveCurrentDir <> '/' do
        IdFTP.ChangeDirUp;

      // Positionnement dans le répertoire des fichiers datas
      IdFTP.ChangeDir(IniStruct.FTP.MasterDataFTP.MasterDataDatas);
      // téléchargement des fichiers
      for i := Low(MasterData) to High(MasterData) do
      begin
        DeleteFileIfExist(GXMLMDPATH + MasterData[i].Path);
        if IdFTP.Size(MasterData[i].Path) <> -1 then
          IdFTP.Get(MasterData[i].Path,GXMLMDPATH + MasterData[i].Path,True,True);
      end;
    end;

     // traitement des fichiers
    for i := Low(MasterData) to High(MasterData) do
    begin
      bFound := False;

      // Si PRM_CODE = 0 alors on ne traitera pas les mises à jours des tables
      case AnsiIndexStr(UpperCase(MasterData[i].Title),['BRANDS','FEDAS','SIZES','SUPPLIERS','UNIVERSCRITERIAS',
                                                        'COLLECTIONS','OPCOMMS', 'PERIODS', 'CORRESPSIZES']) of
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
        else begin
          MasterData[i].MainData := TMainClass.Create;
          MasterData[i].MainData.PRM_CODE := 0;
          MasterData[i].MainData.KTB_ID   := 0;
        end;
      end; // case

      if bFound then
      begin
        AddToMemo(MasterData[i].Title + ' : Traitement du fichier : ' + MasterData[i].Path);
        MasterData[i].MainData.PRM_TYPE := CPRMTYPE;
        MasterData[i].MainData.IboQuery := Que_MasterData;
        MasterData[i].MainData.StpQuery := stp_MasterData;
        MasterData[i].MainData.Title    := MasterData[i].Title;
        MasterData[i].MainData.Path     := GXMLMDPATH;
        MasterData[i].MainData.Filename := MasterData[i].Path;
        if MasterData[i].MainData.UnZipFile then
        begin
          AddToMemo(MasterData[i].Title + ' : Dezippage effectué');
          MasterData[i].MainData.Import;
          AddtoMemo(MasterData[i].Title + ' : Chargement Ok');
        end;
      end;
    end; // for

  Except on E:Exception do
    raise Exception.Create('GetMasterDataFiles -> ' + E.Message);
  end;
end;

procedure TDM_MSS.LoopAutoActive(iNbNew: Integer);
begin
  if iNbNew >= IniStruct.LoopMax then
  begin
    TRY
      // Activation du loop Article
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := 'ARTICLE_C';
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
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := 'DIMENSION_C';
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
      IbStProc_SetLoop.ParamByName('NOM_PROVIDER').AsString := 'COMMANDE_C';
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

function TDM_MSS.OpenFTP(AFTPCFG: TFTPCFG): Boolean;
begin
  Result := False;
  With IdFTP do
  try
    Host := AFTPCFG.Host;
    Username := AFTPCFG.UserName;
    Password := AFTPCFG.Password;
    Port     := AFTPCFG.Port;
    Passive  := True;
    Connect;
//    AFTPCFG.BaseDir  := IniStruct.FTP.MasterDataFTP.Dossier;
    Result := True;
  Except on E:Exception do
    AddToMemo('Erreur OpenFTP -> ' + E.Message);
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

function TDM_MSS.OpenSQL2KDatabase: Boolean;
begin
//  Result := False;
//  With ADOConnection do
//  Try
//    Connected := False;
//
//    if IniStruct.IsDebugMode then
//    begin
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.pwDebugMode + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.lgDebugMode + ';' +
//                          'Initial Catalog='+ IniStruct.cgDebugMode + ';' +
//                          'Data Source=' + IniStruct.dbDebugMode ; // + ';'
//    end else
////    Provider=SQLOLEDB.1;Password=ch@mon1x;Persist Security Info=True;User ID=DA_GINKOIA;Data Source=lame5.no-ip.com
//      ConnectionString := 'Provider=SQLOLEDB.1;' +
//                          'Password=' + IniStruct.PasswordDb + ';' +
//                          'Persist Security Info=True;' +
//                          'User ID=' + IniStruct.LoginDb + ';' +
//                          'Initial Catalog='+ IniStruct.CatalogueDb + ';' +
//                          'Data Source=' + IniStruct.Database; // + ';'
//
//    Connected := True;
//
//    Result := True;
//
//    aQue_ListMagIS.Close;
//    aQue_ListMagIS.Open;
//  Except on E:Exception do
//    raise Exception.Create('Open2kDatabase -> ' + E.Message);
//  end;
end;

function TDM_MSS.SendMailList(ALst: TStrings; AGRP, AMAG, AMAGNOM, ASENDTO : String): Boolean;
begin
  Result := False;
  With IdSMTP do
  Try
    if Connected then
      Disconnect;

    Host     := 'smtp.fr.oleane.com';
    Username := 'admin@ginkoia.fr';
    Password := 'ch@mon1x';
    Try
      Port := 25;
      Connect;
    Except on E:Exception do
      begin
        try
        Port := 587;
        Connect;
        Except on E:Exception do
          raise Exception.Create('SendMailList Connexion -> ' + E.Message);
        end;
      end;
    End;
    IdMessage.Clear;
    IdMessage.ContentType := 'multipart/mixed';
    IdMessage.Subject := Format('%s %s - Rapport d''intégration du %s - %s',[AGRP, AMAG, FormatDateTime('DD/MM/YYYY',Now), AMAGNOM]);
    IdMessage.Body.Text := ALst.Text;

    With  TIdText.Create(IdMessage.MessageParts) do
    begin
      ContentType := 'text/html';
      CharSet := 'ISO-8859-1';
      Body.Text := IdMessage.Body.Text;
    end;

    With TIdAttachmentFile.Create(IdMessage.MessageParts, GFILESDIR + 'logo-IS.gif') do
    begin
      ContentType := 'image/gif';
      FileIsTempFile := false;
      ContentDisposition := 'inline';
      ExtraHeaders.Values['content-id'] := 'logo-IS.gif';
      DisplayName := 'logo-IS.gif';
    end;

    With TIdAttachmentFile.Create(IdMessage.MessageParts, GFILESDIR + 'logo-GK.png') do
    begin
      ContentType := 'image/png';
      FileIsTempFile := false;
      ContentDisposition := 'inline';
      ExtraHeaders.Values['content-id'] := 'logo-GK.png';
      DisplayName := 'logo-GK.png';
    end;

    IdMessage.From.Text := 'Admin@ginkoia.fr';
    IdMessage.Recipients.EMailAddresses := ASENDTO;
    IdMessage.BccList.EMailAddresses := 'thierry.fleisch@ginkoia.fr';
    Send(IdMessage);
    Result := True;
  Except on E:Exception do
    raise Exception.Create('SendMailList Envoi -> ' + E.Message);
  end; // with
end;

end.
