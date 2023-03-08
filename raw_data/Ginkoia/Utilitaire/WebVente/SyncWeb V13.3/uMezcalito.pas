unit uMezcalito;

interface

uses
  uCommon_Type;

function DoMezSend(dHeureDebut, dHeureFin: TTime; bEnd: Boolean): Boolean;

function MezFTPConnection(FTPCfg: TFTPData): Boolean;
function MezFTPUploadFile(FTPCfg: TFTPData): Boolean;
procedure MezFTPClose;


implementation


uses
  Windows,
  Types,
  Classes,
  SysUtils,
  StrUtils,
  DateUtils,
  IniFiles,
  Math,
  UCommon,
  uCommon_DM,
  uGenerique,
  MD5Api;

function MezIsTimerDone(dHeureDebut, dHeureFin: TTime; bEnd: Boolean; out LastOne : Boolean) : boolean;
var
  IniFile : TIniFile;
  dNow, dDebut, dFin : TDateTime;
begin
  Result := False;
  LastOne := False;

  // On utilisera dNow pour garder tout au long du traitement la même date/heure
  dNow := Now;
  // Calcul pour la date de traitement
  dDebut := DateOf(dNow) + dHeureDebut;
  dFin := DateOf(dNow) + dHeureFin;
  // Si l'heure de debut est plus grande que l'heure de fin
  // c'est que l'heure de fin est le lendemain
  if dDebut >= dFin then
    dFin := dFin + 1;

  if (dNow > dDebut) and (dNow < dFin) then
  begin
    Result := true;
    try
      IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      LastOne := (IncSecond(dNow, IniFile.ReadInteger('TIMER', 'INTERVAL', 300)) >= dFin);
      if bEnd then
        IniFile.WriteDateTime('MEZCALITO', 'DATETIMESTK', dNow);
    finally
      FreeAndNil(IniFile);
    end;
  end;
end;

function MezGenerateFiles(LastOne : Boolean): Boolean;
var
  IdMagasin : Integer;
  CodeAdherent : string;
  FileName, ZipName, Md5Name : string;
  Fichier : TextFile;
begin
  Result := False;

  try
    // au cas ou
    Dm_Common.Que_Tmp.Close();

    //Recherche du magasin correspond à la BdD
    IdMagasin := IdentLocalMagid;
    if IdMagasin = 0 then
      IdMagasin := Dm_Common.MySiteParams.iMagID;

    // recup du code adherent
    Dm_Common.Que_Tmp.SQL.Text := 'select mag_codeadh from genmagasin where mag_id = ' + IntToStr(IdMagasin) + ';';
    Dm_Common.Que_Tmp.Open();
    if Dm_Common.Que_Tmp.Eof or Dm_Common.Que_Tmp.FieldByName('mag_codeadh').IsNull then
      raise Exception.Create('Erreur lors de la récupération du code adhérent')
    else
      CodeAdherent := Dm_Common.Que_Tmp.FieldByName('mag_codeadh').AsString;
    Dm_Common.Que_Tmp.Close();

    // nom de fichier
    if LastOne then
      FileName := GGENPATHCSV + 'full_' + CodeAdherent + FormatDateTime('_yyyymmdd_hhnn', Now()) + '.txt'
    else
      FileName := GGENPATHCSV + 'diff_' + CodeAdherent + FormatDateTime('_yyyymmdd_hhnn', Now()) + '.txt';
    ZipName := ChangeFileExt(FileName, '.zip');
    Md5Name := ChangeFileExt(FileName, '.md5');

    if LastOne then
    begin
      Dm_Common.Que_Tmp.SQL.Text := 'delete from tmp_imgstockweb where img_magid = ' + IntToStr(IdMagasin) + ';';
      Dm_Common.Que_Tmp.ExecSQL();
    end;

    try
      // export des données
      Dm_Common.Que_Tmp.SQL.Text := 'select cbi_cb, stc_qte from webm_expdeltastock(' + IntToStr(IdMagasin) + ');';
      Dm_Common.Que_Tmp.Open();
      if not Dm_Common.Que_Tmp.Eof then
      begin
        DoCsv(Dm_Common.Que_Tmp, FileName);
        Dm_Common.Que_Tmp.Close();

        // compression du fichier
        if not ZipFile(FileName, ZipName) then
          raise Exception.Create('Erreur lors de la compression du fichier');
        DeleteFile(FileName);

        // check md5 du fichier
        try
          AssignFile(Fichier, Md5Name);
          Rewrite(Fichier);
          Writeln(Fichier, MD5FromFile(ZipName));
        finally
          CloseFile(Fichier);
        end;

        // fini !!
        Result := True;
      end
      else
        LogAction('Pas de lignes a exportées', 2)
    finally
      Dm_Common.Que_Tmp.Close();
    end;
  Except
    on e : exception do
    begin
      LogAction('Exception dans "GenerateMezCsvStkFiles" : ' + e.Message, 1)
    end;
  end;
end;

function MezGenerateTableTmp() : Boolean;
var
  IdMagasin : integer;
begin
  Result := False;

  try
    // au cas ou
    Dm_Common.Que_Tmp.Close();

    //Recherche du magasin correspond à la BdD
    IdMagasin := IdentLocalMagid;
    if IdMagasin = 0 then
      IdMagasin := Dm_Common.MySiteParams.iMagID;

    // drop du contenue de la table
    Dm_Common.Que_Tmp.SQL.Text := 'delete from tmp_imgstockweb where img_magid = ' + IntToStr(IdMagasin) + ';';
    Dm_Common.Que_Tmp.ExecSQL();

    Dm_Common.Que_Tmp.SQL.Text := 'insert into tmp_imgstockweb (img_magid, img_artid, img_tgfid, img_couid, img_qte) '
                                + 'select ' + IntToStr(IdMagasin) + ', art_id, tgf_id, cou_id, stc_qte from webm_expdeltastock(' + IntToStr(IdMagasin) + ');';
    Dm_Common.Que_Tmp.ExecSQL();

    // fini !!
    Result := True;
  Except
    on e : exception do
    begin
      LogAction('Exception dans "GenerateMezCsvStkFiles" : ' + e.Message, 1)
    end;
  end;
end;

// fonction de l'interface

function DoMezSend(dHeureDebut, dHeureFin : TTime; bEnd : Boolean): Boolean;
var
  FTPZip, FTPmd5 : TFTPData;
  IsLast : Boolean;
begin
  Result := False;
  try
    // Vérification timer
    if MezIsTimerDone(dHeureDebut, dHeureFin, bEnd, IsLast) then
    begin
      // Generation des fichiers
      LogAction('Generation des fichiers', 3);
      if MezGenerateFiles(IsLast) then
      begin
        // récupération des infos FTP
        FTPZip := Dm_Common.MySiteParams.FTPGenCSV;
        FTPZip.FileFilter := '*.zip';
        FTPZip.SourcePath := GGENPATHCSV;
        FTPZip.SavePath := '';
        FTPZip.bDeleteFile := False;
        FTPZip.bArchiveFile := True;
        FTPmd5 := Dm_Common.MySiteParams.FTPGenCSV;
        FTPmd5.FileFilter := '*.md5';
        FTPmd5.SourcePath := GGENPATHCSV;
        FTPmd5.SavePath := '';
        FTPmd5.bDeleteFile := False;
        FTPmd5.bArchiveFile := True;
        // Transfert des fichiers vers le FTP
        LogAction('Transfert des fichiers vers le FTP', 3);
        if MezFTPConnection(FTPZip) then
        begin
          try
            MezFTPUploadFile(FTPZip);
            MezFTPUploadFile(FTPmd5);
          finally
            MezFTPClose();
          end;
          // Mise a jour des tables d'historique
          if not MezGenerateTableTmp() then
            raise Exception.Create('Erreur lors de la mise a jour de la table');
          // retour
          Result := True;
        end;
      end;
    end;
  except on E: Exception do
    begin
      raise Exception.Create('DoMezSend -> ' + E.Message);
    end;
  end;
end;

function MezFTPConnection(FTPCfg: TFTPData): Boolean;
var
  i: Integer;
  lst: TStringList;
begin
  Result := False;

  try
    // On annule toute action du FTP et on coupe la connection s'il est encore connecté
    MezFTPClose;

    // configuration du FTP
    if Trim(FTPCfg.Host) = '' then
      Exit;

    Dm_Common.FTP.Host            := FTPCfg.Host;
    Dm_Common.FTP.Username        := FTPCfg.User;
    Dm_Common.FTP.Password        := FTPCfg.Psw;
    Dm_Common.FTP.Port            := FTPCfg.Port;
    Dm_Common.FTP.Passive         := True;
    Dm_Common.FTP.ConnectTimeout  := Dm_Common.MyIniParams.iConnect; // (3s)
    Dm_Common.FTP.TransferTimeout := Dm_Common.MyIniParams.iTransfer;
    Dm_Common.FTP.ReadTimeout     := Dm_Common.MyIniParams.iRead;
    Dm_Common.FTP.Connect();

    if Dm_Common.FTP.Connected then
    begin
      if Trim(FTPCfg.FTPDirectory) <> '' then
      begin
        // On va se positionner dans le répertoire de traitement du FTP
        lst := TStringList.Create;
        try
          lst.Text := StringReplace(FTPCfg.FTPDirectory, '/', #13#10,
            [rfReplaceAll]);
          for i := 0 to Lst.Count - 1 do
            if Trim(lst[i]) <> '' then
              Dm_Common.FTP.ChangeDir(Trim(lst[i]));
        finally
          lst.Free;
        end;
      end;

      Result := True;
    end;
  except on E: Exception do
    begin
      LogAction('Erreur de connection FTP -> ' + FTPCfg.Host + ' : ' + E.Message, 0);
      raise Exception.Create('GenFTPConnection -> ' + E.Message);
    end;
  end;
end;

function MezFTPUploadFile(FTPCfg: TFTPData): Boolean;
var
  Rec: TSearchRec;
  i: integer;
  sArchPath: string;
  LstFile: TStringList;
  sFile: String;
  iSize: Int64;
  bSend: Boolean;
  bDel: Boolean;
  iTry: Integer;
begin
  Result := True;  // par défaut ok;

  sArchPath := FTPCfg.SourcePath + 'Send\';
  if not DirectoryExists(sArchPath) then
    ForceDirectories(sArchPath);

  try
    LstFile := TStringList.Create;

    // Liste des fichiers d'un repertoire
    i := FindFirst(FTPCfg.SourcePath + FTPCfg.FileFilter, faAnyFile, Rec);
    while (i = 0) do
    begin
      sFile:=ExtractFileName(rec.Name);
      if (sFile <> '.') and (sFile <> '..') and ((Rec.Attr and faDirectory) <> faDirectory) then
        LstFile.Add(sFile);
      i := FindNext(Rec);
    end;
    SysUtils.FindClose(Rec);

    // transfert FTP des fichiers
    try
      for i := 1 to LstFile.Count do
      begin
        sFile := LstFile[i-1];

        // tentative d'effacer le fichier distant 3 fois de suite
        iSize := Dm_Common.FTP.Size(sFile);
        bDel := (iSize < 0);
        iTry := 0;
        while (Not bDel) and (iTry < 3) do
        begin
          try
            if iSize >= 0 then
            begin
              try
                Dm_Common.FTP.Delete(sFile);
              except
              end;
            end;
            iSize := Dm_Common.FTP.Size(sFile);
            bDel := (iSize < 0);
            if (Not bDel) then
              Sleep(500);  //attente d'1/2 seconde entre les essais
          except
          end;
          inc(iTry);
        end;
        if (Not bDel) then
        begin
          LogAction('Impossible de supprimer le fichier distant: ' + sFile,1);
        end;

        // tentative de transferer 3 fois le fichier
        bSend := False;
        iTry := 0;
        while not bSend and (iTry < 3) do
        begin
          try
            Dm_Common.FTP.Put(FTPCfg.SourcePath + sFile, sFile, True);
            bSend := True;
          except
          end; // try
          if not(bSend) then
            Sleep(500);  //attente d'1/2 seconde entre les essais
          inc(iTry);
        end;

        //archivage si ok, sinon log
        if bSend then
        begin
          if FileExists(sArchPath + sFile) then
            SysUtils.DeleteFile (sArchPath + sFile);

          if not(RenameFile(FTPCfg.SourcePath + sFile, sArchPath + sFile)) then
            LogAction('GenFTPUploadFile Problème d''archivage de ' + sFile, 1);
        end
        else begin
          LogAction('Impossible de transférer le fichier: '+sFile,0);
          result := false;
        end;

      end;
    except on E: Exception do
      begin
        Result:=false;
        LogAction('Erreur de transfert des fichiers du FTP -> ' + FTPCfg.Host + ' : ' + E.Message, 0);
        raise Exception.Create('GenFTPUploadFile -> ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(LstFile);
  end;
end;

procedure MezFTPClose();
begin
  if Dm_Common.FTP.Connected then
  begin
    Dm_Common.FTP.Abort;
    Dm_Common.FTP.Disconnect;
  end;
end;

end.

