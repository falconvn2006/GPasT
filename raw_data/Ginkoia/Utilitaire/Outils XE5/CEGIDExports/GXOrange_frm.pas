unit GXOrange_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SBSimpleSftp,
  SBUtils, SBSSHKeyStorage, SBSSHConstants, SBSftpCommon, SBTypes,
  SBSSHPubKeyClient, inifiles;

Const
  // requête de selection de toutes les infos clients / contacts
  SQL_GX_ORANGE = 'SELECT DISTINCT TELEPHONE_CLIENT, TELEPHONE_CONTACT, TELEPHONE_MOBILE, VIP, CODE_TIERS, '
    +'(CASE WHEN VIP = ''1'' THEN ''VIP'' WHEN PR_RPRLIBMUL0 LIKE ''%ABN_LOCATION%'' THEN ''Location'' '
    +'WHEN PR_RPRLIBMUL0 LIKE ''%ABN_WEB_PREMIUM%'' OR PR_RPRLIBMUL0 LIKE ''%ABN_WEBPREMIUM%'' THEN ''Web'' ELSE ''NR'' END) AS COMPETENCE, '
    +'RETARD_FACTURATION, '
    +'(CASE WHEN PR_RPRLIBMUL0 LIKE ''%ISF_ABN_SIMPLE%'' THEN ''14413'' ELSE ''12892'' END) AS PROJID, '
    +'t_enseigne, '
    +'isnull(abo_fermer,''Oui'') as abo_support_actif '
    +'FROM ( '
      +'SELECT '
      +'REPLACE(REPLACE(REPLACE(REPLACE(CLIENT.Standard,'' '',''''),''.'',''''), char(9), ''''),''-'','''') AS TELEPHONE_CLIENT, '
      +'ISNULL(REPLACE(REPLACE(REPLACE(REPLACE((SELECT (STUFF((SELECT DISTINCT (CASE WHEN CONTACT.Ligne_Directe <> '''' AND CONTACT.Ligne_Directe IS NOT NULL AND RTRIM(LTRIM(CONTACT.Ligne_Directe)) <> '''' '
      +'AND LOWER(CONTACT.Ligne_Directe) NOT LIKE ''%[^0123456789 ]%'' THEN ''#''+ CONTACT.Ligne_Directe WHEN LOWER(CONTACT.Standard) NOT LIKE ''%[^0123456789 ]%'' AND RTRIM(LTRIM(CONTACT.Standard)) <> '''' THEN ''#''+ CONTACT.Standard ELSE '''' END) '
      +'FROM CONTACT where CONTACT.N_Client=CLIENT.N_Client for xml path('''')),1,1,''''))),'' '',''''),''.'',''''), char(9), ''''),''-'',''''),'''') as TELEPHONE_CONTACT, '
      +'ISNULL(REPLACE(REPLACE(REPLACE(REPLACE((SELECT (STUFF((SELECT DISTINCT ''#''+ CONTACT.Portable FROM CONTACT WHERE CONTACT.N_Client=CLIENT.N_Client AND LTRIM(RTRIM(contact.Portable)) <> '''' '
      +'AND LOWER(CONTACT.Portable) NOT LIKE ''%[^0123456789 ]%'' for xml path('''')),1,1,''''))),'' '',''''),''.'',''''), char(9), ''''),''-'',''''),'''') as TELEPHONE_MOBILE, '
      +'ISNULL(CASE WHEN LOWER(Champ8) = ''non'' THEN ''0'' WHEN LOWER(Champ8) = ''oui'' THEN ''1'' ELSE ''0'' END,0) AS VIP, '
      +'CLIENT.Champ32 AS CODE_TIERS, ''NR'' AS competence, '
      +'(SELECT (STUFF((SELECT DISTINCT '';''+LTRIM(RTRIM(ORDREF.Champ4)) FROM ORDREF WHERE ORDREF.Egxs_N_Client=CLIENT.N_Client for xml path('''')),1,1,''''))) AS PR_RPRLIBMUL0, '
      +'(CASE WHEN LOWER(client.eviter) = ''non'' THEN ''0'' ELSE ''1'' END) AS RETARD_FACTURATION '
      +',champ12 as t_enseigne '
      +',(SELECT max(actif) FROM ORDREF join EGXS_TB_OF_CONTRAT_PERIODES on EGXS_TB_OF_CONTRAT_PERIODES.N_Of=ORDREF.N_OF WHERE ORDREF.Egxs_N_Client=CLIENT.N_Client and ORDREF.Champ4 like ''%ABN_AST_TEL%'' and Annee=:YEAR and Mois=:MONTH) AS abo_fermer '
      +',CLIENT.Champ36 '
    + 'FROM CLIENT '
    + 'WHERE '
    +'LOWER(CLIENT.Standard) NOT LIKE ''%[^0123456789 ]%'' AND CLIENT.Champ32 IS NOT NULL AND '
    +'((RTRIM(LTRIM(CLIENT.Standard)) <> '''' AND CLIENT.Standard IS NOT NULL) or (CLIENT.Champ36 = ''Démarrage'')) '
    +') AS t WHERE TELEPHONE_CLIENT <> '''' or Champ36 = ''Démarrage'' ORDER by code_tiers';


type
  TFrm_GX2ORANGE = class(TForm)
    Image1: TImage;
    ProgressBar1: TProgressBar;
    BImporter: TBitBtn;
    QGX: TFDQuery;
    cbRF: TCheckBox;

    mmo1: TMemo;
    label_Importation: TLabel;
    cbNOSYMAG: TCheckBox;
    GroupBox1: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    Bevel1: TBevel;
    ElSimpleSFTPClient1: TElSimpleSFTPClient;
    ElSSHPublicKeyClient1: TElSSHPublicKeyClient;
    ElSSHMemoryKeyStorage1: TElSSHMemoryKeyStorage;
    cbnoabo: TCheckBox;
    procedure BImporterClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuto, FNoFtp : Boolean;
    FFile2Export: TFileName;
    procedure KeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
    function Export_orange: Boolean;
    function SFTP_ExportFile(Afile: string): Boolean;
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_GX2ORANGE: TFrm_GX2ORANGE;

implementation

{$R *.dfm}

USes UDataMod;

procedure TFrm_GX2ORANGE.BImporterClick(Sender: TObject);
begin
  BImporter.Enabled := false;
  BImporter.Visible := false;
  Export_orange;
  sleep(500);

  BImporter.Enabled := true;
  BImporter.Visible := true;

  if (rb2.Checked) then
  begin
     SFTP_ExportFile(FFile2Export);
  end;
end;

procedure TFrm_GX2ORANGE.KeyValidate(Sender: TObject; ServerKey: TElSSHKey; var Validate: Boolean);
begin
  // J'accepte toutes les clés du serveur....
  // TElSimpleSFTPClient(Sender).
  mmo1.Lines.Add('key.validate');
  mmo1.Lines.Add(ServerKey.FingerprintMD5String);
  Validate := true;
end;

function TFrm_GX2ORANGE.SFTP_ExportFile(Afile: string): Boolean;
var
  FSFTPClient: TElSimpleSFTPClient;
//  AKey: TElSSHKey;
  FDir: string;
//  aPPKFile: TFileName;
  inifile: TIniFile;
  ftp_address,ftp_username,ftp_directory, ftp_password: string;
  ftp_port: Integer;
begin
  result := false;
  try
//    AKey := TElSSHKey.Create;
//    aPPKFile := ExtractFileDir(Application.ExeName) + '\GINFCC_dsa.ppk';
//    mmo1.Lines.Add(Format('%d', [AKey.LoadPrivateKey(aPPKFile, '')]));
//
//    ElSSHMemoryKeyStorage1.Clear;
//    ElSSHMemoryKeyStorage1.Add(AKey);

    FSFTPClient := TElSimpleSFTPClient.Create(nil);

    try
     	inifile:= TIniFile.Create(ExtractFilePath( Application.ExeName ) + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini'));

      ftp_address := inifile.ReadString('FTP','address','');
      ftp_port := inifile.ReadInteger('FTP','port',22);
      ftp_username := inifile.ReadString('FTP','username','');
      ftp_password := inifile.ReadString('FTP','password','');
      ftp_directory := inifile.ReadString('FTP','directory','');
    finally
       inifile.Free;
    end;






    {
      FSFTPClient.Address  := '192.168.10.74';
      FSFTPClient.Port     := 22;
      FSFTPClient.Username := 'ginkodev';
      FSFTPClient.Password := 'ly2G0MjB';

    }

    FSFTPClient.Address := ftp_address;
    FSFTPClient.Port := ftp_port;
    FSFTPClient.Username := ftp_username;
    FSFTPClient.Password := ftp_password;
    FSFTPClient.ASCIIMode := false;
    FSFTPClient.AuthenticationTypes := FSFTPClient.AuthenticationTypes and not SSH_AUTH_TYPE_PUBLICKEY;
//    FSFTPClient.AuthenticationTypes := SBSSHConstants.SSH_AUTH_TYPE_PUBLICKEY;
    FSFTPClient.OnKeyValidate := KeyValidate;

//    FSFTPClient.KeyStorage := ElSSHMemoryKeyStorage1;

    FDir := ExtractFileDir(Application.ExeName) + '\';

    if NOT DirectoryExists(FDir) then
    begin
      ForceDirectories(FDir);
    end;
    mmo1.Lines.Add('Fichier : ' + FDir + Afile);
    mmo1.Lines.Add('On va ouvrir');

    FSFTPClient.Open;

    mmo1.Lines.Add('Open : OK');
    mmo1.Lines.Add(Format('UPLOAD %s => %s', [FDir + Afile, ExtractFileName(Afile)]));
    FSFTPClient.UploadFile(FDir + Afile, ftp_directory + ExtractFileName(Afile));
    mmo1.Lines.Add('UPLOAD OK');
    FSFTPClient.Close;
    mmo1.Lines.Add('Close OK');
    result := true;
  Except
    On E: Exception do
    begin
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
      result := false;
    end;
  end;
end;

function TFrm_GX2ORANGE.Export_orange: Boolean;
var
  ligne: string;
  i, j, k: integer;
  Separateur: string;
  datas, listTel, telExist, centraleList: TStringList;
  AFileName: string;
  inifile:TIniFile;
  day, month, year : Word;
  abo, centrale : Integer;
begin
  // ------------------------------
  try
    inifile:= TIniFile.Create(ExtractFilePath( Application.ExeName ) + ChangeFileExt(ExtractFileName(Application.ExeName),'.ini'));

    with DataMod.FDConGX.Params do
    begin
      Clear;
      Add('User_Name=' + inifile.ReadString('GX','user_name',''));
      Add('Password=' + inifile.ReadString('GX','password',''));
      Add('Server=' + inifile.ReadString('GX','server',''));
      Add('Database=' + inifile.ReadString('GX','database',''));
      Add('DriverID=' + inifile.ReadString('GX','driverid',''));
    end;
  finally
   inifile.Free;
  end;



  label_Importation.Caption := 'En cours...';
  datas := TStringList.Create;
  listTel := TStringList.Create;
  telExist := TStringList.Create;
  centraleList := TStringList.Create;
  centraleList.Add('Autre');
  centraleList.Add('SPORT 2000');
  centraleList.Add('INTERSPORT');
  centraleList.Add('GO SPORT');
  centraleList.Add('COURIR');
  centraleList.Add('SKIMIUM');

  result := false;
  try
    try
      DataMod.FDConGX.Open;
      // téléphone Principal

      DecodeDate(Date, year, month, day);
      QGX.Close;
      QGX.SQL.Clear;
      QGX.SQL.Text := SQL_GX_ORANGE;
      QGX.ParamByName('YEAR').AsInteger := year;
      QGX.ParamByName('MONTH').AsInteger := month;
      QGX.Open;
      ProgressBar1.Position := 0;
      ProgressBar1.Max := QGX.RecordCount;
      ProgressBar1.Visible := true;
      j := 1;
      while not(QGX.Eof) do
      begin
        ProgressBar1.Position := QGX.RecNo;
        Application.ProcessMessages;
        ligne := '';
        telExist.Clear;

        ligne := Format(';%s;%s;%s;', [QGX.Fields.FieldByName('VIP').asstring, QGX.Fields.FieldByName('CODE_TIERS').asstring,
          QGX.Fields.FieldByName('COMPETENCE').asstring]);

        if (cbRF.Checked) then
        begin
          if (cbNOSYMAG.Checked) then
          begin
            ligne := ligne + '0;1'
          end
          else
          begin
            ligne := ligne + Format('0;%s', [QGX.Fields.FieldByName('PROJID').asstring]);
          end;
        end
        else
        begin
          if (cbNOSYMAG.Checked) then
          begin
            ligne := ligne + Format('%s;1', [QGX.Fields.FieldByName('RETARD_FACTURATION').asstring])
          end
          else
          begin
            ligne := ligne + Format('%s;%s', [QGX.Fields.FieldByName('RETARD_FACTURATION').asstring, QGX.Fields.FieldByName('PROJID').asstring])
          end;
        end;

        if (LowerCase(QGX.Fields.FieldByName('abo_support_actif').asstring) = 'oui') or (QGX.Fields.FieldByName('PROJID').asstring = '14413') then
          abo := 0
        else
          abo := 1;

        if (cbnoabo.Checked) then
          abo := 0;

        centrale := centraleList.IndexOf(QGX.Fields.FieldByName('t_enseigne').asstring);
        if (centrale = -1) then
          centrale := 0;

        ligne := ligne + Format(';%s;%s;0;0;0', [inttostr(centrale), inttostr(abo)]);

        // on ajoute tous les numéros du client
        for i := 0 to 2 do
        begin
          Split('#', QGX.Fields[i].asstring, listTel);

          // pour chaque tel on fait l'ajout au fichier si il n'est pas déjà ajouté pour ce client
          for k := 0 to listTel.Count - 1 do
          begin
            // si le numéro n'a pas déjà été ajouté, on l'ajoute on on le met dans le tstringlist
            if (telExist.IndexOf(listTel[k]) = -1) then
            begin
              datas.Add(Format('%d;%s', [j, listTel[k] + ligne]));
              telExist.Add(listTel[k]);
              inc(j)
            end;

          end;

          if (i = 0) and (listTel.Count = 0) then
          begin
            datas.Add(Format('%d;%s', [j, '' + ligne]));
            inc(j)
          end;
        end;

        QGX.Next;
        ProgressBar1.Refresh;
      end;

      AFileName := 'GX2orange_' + FormatDateTime('yyyymmdd_hhnnsszzz', Now()) + '.txt';
      datas.SaveToFile(AFileName);
      FFile2Export := AFileName;
      mmo1.Lines.Add(Format('Fichier Sauvegardé : %s', [AFileName]));
    Except
      on E: Exception do
      begin
        mmo1.Lines.Add('Impossible de Générer le fichier');
        result := false;
      end;
    end;
  finally
    ProgressBar1.Visible := false;
    datas.Free;
    listTel.Free;
    telExist.Free;
    DataMod.FDConGX.Close;
    label_Importation.Caption := 'Terminé';
  end;
end;

procedure TFrm_GX2ORANGE.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := true; // Requires D2006 or newer.
  ListOfStrings.DelimitedText := Str;
end;

procedure TFrm_GX2ORANGE.FormActivate(Sender: TObject);
begin
  if FNoFtp then
  begin
    rb1.Checked := True;
    Application.ProcessMessages;
  end;

  if FAuto then
  begin
    Application.ProcessMessages;
    BImporterClick(nil);
    Application.Terminate;
  end;
end;

procedure TFrm_GX2ORANGE.FormCreate(Sender: TObject);
var i:Integer;
    param:string;
    value:string;
begin
     FAuto := false;
     FNoFtp := False;
     //-------------------------------------------------------------------------
       for i :=1 to ParamCount do
        begin
              // Debug
             If lowercase(ParamStr(i))='-auto'  then FAuto:=true;
             If lowercase(ParamStr(i))='-noftp'  then FNoFtp:=true;
             param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
             value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
        end;

      Application.ShowMainForm:=true;
      ShowWindow(Application.Handle, SW_SHOW);
end;

initialization

SetLicenseKey('4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' + 'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
  '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' + 'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
  'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' + 'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
  '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' + 'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F');

end.
