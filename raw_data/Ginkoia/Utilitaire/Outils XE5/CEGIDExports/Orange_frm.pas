unit Orange_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SBSimpleSftp,
  SBUtils, SBSSHKeyStorage, SBSSHConstants, SBSftpCommon, SBTypes,
  SBSSHPubKeyClient;

Const CRLF=#13+#10;
      SQL_CEGID_ORANGE = ' SELECT ' +CRLF+
                         ' DISTINCT' +CRLF+
                         ' REPLACE(REPLACE(REPLACE(T_TELEPHONE,'' '',''''),''.'',''''), char(9), '''') AS TELEPHONE, ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''1'' ' +CRLF+
                         '   ELSE ''0'' ' +CRLF+
                         '   END ' +CRLF+
                         ' AS VIP, ' +CRLF+
                         ' T_TIERS AS CODE_TIERS, ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''VIP'' ' +CRLF+
                         '   ELSE CASE ' +CRLF+
                         '         WHEN CHARINDEX(''005'',RPR_RPRLIBMUL0) <> 0 THEN ''Location'' ' +CRLF+
                         '         ELSE ' +CRLF+
                         '            CASE ' +CRLF+
                         '               WHEN CHARINDEX(''036'',RPR_RPRLIBMUL0) <> 0 THEN ''Web'' ' +CRLF+
                         '            ELSE ''NR'' ' +CRLF+
                         '            END ' +CRLF+
                         '         END '    +CRLF+
                         ' END AS COMPETENCE,  '         +CRLF+
                         ' CASE T_FERME '                +CRLF+
                         '   WHEN ''X'' THEN ''1''     ' +CRLF+
                         '   ELSE CASE T_ETATRISQUE '    +CRLF+
                         '       WHEN ''V'' THEN ''0'' ' +CRLF+
                         '       WHEN ''O'' THEN ''1'' ' +CRLF+
                         '       WHEN ''R'' THEN ''1'' ' +CRLF+
                         '       ELSE ''0'' '            +CRLF+
                         '   END                    '    +CRLF+
                         ' END AS RETARD_FACTURATION, '  +CRLF+
                         ' CASE                       '  +CRLF+
                         '    WHEN CHARINDEX(''037'',RPR_RPRLIBMUL0) <> 0 THEN ''14413'' ' +CRLF+
                         '     ELSE ''12892''             '  +CRLF+
                         '  END AS PROJID '              +CRLF+
                         ' FROM TIERS AS TIERS '         +CRLF+
                         '  LEFT JOIN TIERSCOMPL ON (YTC_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN PROSPECTS ON (dbo.PROSPECTS.RPR_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN CHOIXEXT AS C0 ON (C0.YX_TYPE=''LT2'' AND C0.YX_CODE=YTC_TABLELIBRETIERS2) ' +CRLF+
                         '  LEFT JOIN CONTACT ON C_TIERS=T_TIERS AND C_PRINCIPAL=''X'' ' +CRLF+
                         '  LEFT JOIN COMMERCIAL ON (GCL_COMMERCIAL=T_REPRESENTANT) ' +CRLF+
                         '  JOIN CHOIXEXT AS C1 ON (C1.YX_TYPE=''LT1'' AND C1.YX_CODE=YTC_TABLELIBRETIERS1 AND C1.YX_LIBELLE<>''DIVERS'') ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C2 ON (C2.CC_TYPE=''RL3'' AND C2.CC_CODE=RPR_RPRLIBTABLE3 ) ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C3 ON (C3.CC_TYPE=''SCC'' AND C3.CC_CODE=T_SECTEUR ) '     +CRLF+
                         '  WHERE TIERS.T_NATUREAUXI=''CLI'' AND T_TELEPHONE<>'''' AND T_FERME=''-'' ' +CRLF+
                         '  AND LOWER(T_TELEPHONE) NOT LIKE ''%[a-z]%'' '  +CRLF+
                         '  ORDER BY CODE_TIERS';
      //----
      SQL_CEGID_CTC    = ' SELECT ' +CRLF+
                         ' DISTINCT' +CRLF+
                         ' ''0'' + C_CLETELEPHONE AS TELCTC , ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''1'' ' +CRLF+
                         '   ELSE ''0'' ' +CRLF+
                         '   END ' +CRLF+
                         ' AS VIP, ' +CRLF+
                         ' T_TIERS AS CODE_TIERS, ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''VIP'' ' +CRLF+
                         '   ELSE CASE ' +CRLF+
                         '         WHEN CHARINDEX(''005'',RPR_RPRLIBMUL0) <> 0 THEN ''Location'' ' +CRLF+
                         '         ELSE ' +CRLF+
                         '            CASE ' +CRLF+
                         '               WHEN CHARINDEX(''036'',RPR_RPRLIBMUL0) <> 0 THEN ''Web'' ' +CRLF+
                         '            ELSE ''NR'' ' +CRLF+
                         '            END ' +CRLF+
                         '         END '    +CRLF+
                         ' END AS COMPETENCE,  '         +CRLF+
                         ' CASE T_FERME '                +CRLF+
                         '   WHEN ''X'' THEN ''1''     ' +CRLF+
                         '   ELSE CASE T_ETATRISQUE '    +CRLF+
                         '       WHEN ''V'' THEN ''0'' ' +CRLF+
                         '       WHEN ''O'' THEN ''1'' ' +CRLF+
                         '       WHEN ''R'' THEN ''1'' ' +CRLF+
                         '       ELSE ''0'' '            +CRLF+
                         '   END                    '    +CRLF+
                         ' END AS RETARD_FACTURATION, '  +CRLF+
                         ' CASE                       '  +CRLF+
                         '    WHEN CHARINDEX(''037'',RPR_RPRLIBMUL0) <> 0 THEN ''14413'' ' +CRLF+
                         '     ELSE ''12892''             '  +CRLF+
                         '  END AS PROJID '              +CRLF+
                         ' FROM TIERS AS TIERS '         +CRLF+
                         '  LEFT JOIN TIERSCOMPL ON (YTC_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN PROSPECTS ON (dbo.PROSPECTS.RPR_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN CHOIXEXT AS C0 ON (C0.YX_TYPE=''LT2'' AND C0.YX_CODE=YTC_TABLELIBRETIERS2) ' +CRLF+
                         '  LEFT JOIN CONTACT ON C_TIERS=T_TIERS AND C_PRINCIPAL<>''X'' ' +CRLF+
                         '  LEFT JOIN COMMERCIAL ON (GCL_COMMERCIAL=T_REPRESENTANT) ' +CRLF+
                         '  JOIN CHOIXEXT AS C1 ON (C1.YX_TYPE=''LT1'' AND C1.YX_CODE=YTC_TABLELIBRETIERS1 AND C1.YX_LIBELLE<>''DIVERS'') ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C2 ON (C2.CC_TYPE=''RL3'' AND C2.CC_CODE=RPR_RPRLIBTABLE3 ) ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C3 ON (C3.CC_TYPE=''SCC'' AND C3.CC_CODE=T_SECTEUR ) ' +CRLF+
                         '  WHERE TIERS.T_NATUREAUXI=''CLI'' AND C_CLETELEPHONE<>'''' AND T_FERME=''-''   ' +CRLF+
                         '  ORDER BY CODE_TIERS';

      //----
      SQL_CEGID_MOBILE = ' SELECT ' +CRLF+
                         ' DISTINCT' +CRLF+
                         ' ''0'' + C_CLETELEX AS TELCTC , ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''1'' ' +CRLF+
                         '   ELSE ''0'' ' +CRLF+
                         '   END ' +CRLF+
                         ' AS VIP, ' +CRLF+
                         ' T_TIERS AS CODE_TIERS, ' +CRLF+
                         ' CASE YTC_BOOLLIBRE1 ' +CRLF+
                         '   WHEN ''X'' THEN ''VIP'' ' +CRLF+
                         '   ELSE CASE ' +CRLF+
                         '         WHEN CHARINDEX(''005'',RPR_RPRLIBMUL0) <> 0 THEN ''Location'' ' +CRLF+
                         '         ELSE ' +CRLF+
                         '            CASE ' +CRLF+
                         '               WHEN CHARINDEX(''036'',RPR_RPRLIBMUL0) <> 0 THEN ''Web'' ' +CRLF+
                         '            ELSE ''NR'' ' +CRLF+
                         '            END ' +CRLF+
                         '         END '    +CRLF+
                         ' END AS COMPETENCE,  '         +CRLF+
                         ' CASE T_FERME '                +CRLF+
                         '   WHEN ''X'' THEN ''1''     ' +CRLF+
                         '   ELSE CASE T_ETATRISQUE '    +CRLF+
                         '       WHEN ''V'' THEN ''0'' ' +CRLF+
                         '       WHEN ''O'' THEN ''1'' ' +CRLF+
                         '       WHEN ''R'' THEN ''1'' ' +CRLF+
                         '       ELSE ''0'' '            +CRLF+
                         '   END                    '    +CRLF+
                         ' END AS RETARD_FACTURATION, '  +CRLF+
                         ' CASE                       '  +CRLF+
                         '    WHEN CHARINDEX(''037'',RPR_RPRLIBMUL0) <> 0 THEN ''14413'' ' +CRLF+
                         '     ELSE ''12892''             '  +CRLF+
                         '  END AS PROJID '              +CRLF+
                         ' FROM TIERS AS TIERS '         +CRLF+
                         '  LEFT JOIN TIERSCOMPL ON (YTC_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN PROSPECTS ON (dbo.PROSPECTS.RPR_AUXILIAIRE=T_AUXILIAIRE) ' +CRLF+
                         '  LEFT JOIN CHOIXEXT AS C0 ON (C0.YX_TYPE=''LT2'' AND C0.YX_CODE=YTC_TABLELIBRETIERS2) ' +CRLF+
                         '  LEFT JOIN CONTACT ON C_TIERS=T_TIERS AND C_PRINCIPAL<>''X'' ' +CRLF+
                         '  LEFT JOIN COMMERCIAL ON (GCL_COMMERCIAL=T_REPRESENTANT) ' +CRLF+
                         '  JOIN CHOIXEXT AS C1 ON (C1.YX_TYPE=''LT1'' AND C1.YX_CODE=YTC_TABLELIBRETIERS1 AND C1.YX_LIBELLE<>''DIVERS'') ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C2 ON (C2.CC_TYPE=''RL3'' AND C2.CC_CODE=RPR_RPRLIBTABLE3 ) ' +CRLF+
                         '  LEFT JOIN CHOIXCOD AS C3 ON (C3.CC_TYPE=''SCC'' AND C3.CC_CODE=T_SECTEUR ) ' +CRLF+
                         '  WHERE TIERS.T_NATUREAUXI=''CLI'' AND C_CLETELEX<>'''' AND T_FERME=''-''   ' +CRLF+
                         '  ORDER BY CODE_TIERS';



type
  TFrm_CEGID2ORANGE = class(TForm)
    Image1: TImage;
    ProgressBar1: TProgressBar;
    BImporter: TBitBtn;
    QCEGID: TFDQuery;
    cbRF: TCheckBox;
    ElSSHMemoryKeyStorage1: TElSSHMemoryKeyStorage;
    mmo1: TMemo;
    ElSSHPublicKeyClient1: TElSSHPublicKeyClient;
    ElSimpleSFTPClient1: TElSimpleSFTPClient;
    label_Importation: TLabel;
    cbNOSYMAG: TCheckBox;
    GroupBox1: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    Bevel1: TBevel;
    procedure BImporterClick(Sender: TObject);
  private
    FFile2Export:TFileName;
    procedure KeyValidate(Sender:TObject;ServerKey: TElSSHKey; var Validate: Boolean);
    function Export_orange:boolean;
    function SFTP_ExportFile(Afile:string):boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_CEGID2ORANGE: TFrm_CEGID2ORANGE;

implementation

{$R *.dfm}

USes UDataMod;


procedure TFrm_CEGID2ORANGE.BImporterClick(Sender: TObject);
begin
    BImporter.Enabled:=false;
    BImporter.Visible:=false;
    Export_orange;
    sleep(10);
    if rb2.Checked then
       begin
          SFTP_ExportFile(FFile2Export);
       end;
end;

procedure TFrm_CEGID2ORANGE.KeyValidate(Sender:TObject;ServerKey: TElSSHKey; var Validate: Boolean);
begin
    // J'accepte toutes les clés du serveur....
    //  TElSimpleSFTPClient(Sender).
    mmo1.Lines.Add('key.validate');
    mmo1.Lines.Add(ServerKey.FingerprintMD5String);
    Validate:=true;
end;

function TFrm_CEGID2ORANGE.SFTP_ExportFile(Afile:string):boolean;
var FSFTPClient:TElSimpleSFTPClient;
    AKey : TElSSHKey;
    FDir:string;
    aPPKFile : TFileName;
begin
    result:=false;
    try
        AKey := TElSSHKey.Create;
        aPPKFile := ExtractFileDir(Application.ExeName) + '\GINFCC_dsa.ppk';
        mmo1.lines.Add(Format('%d',[AKey.LoadPrivateKey(aPPKFile,'')]));

        ElSSHMemoryKeyStorage1.Clear;
        ElSSHMemoryKeyStorage1.Add(aKey);

        FSFTPClient:= TElSimpleSFTPClient.Create(nil);
{       FSFTPClient.Address  := '192.168.10.74';
        FSFTPClient.Port     := 22;
        FSFTPClient.Username := 'ginkodev';
        FSFTPClient.Password := 'ly2G0MjB';

}

        FSFTPClient.Address    := 'transfert.francetelecom.com';
        FSFTPClient.Port       := 22;
        FSFTPClient.Username   := 'GINFCC';
        FSFTPClient.AuthenticationTypes := SBSSHConstants.SSH_AUTH_TYPE_PUBLICKEY;
        FSFTPClient.OnKeyValidate := KeyValidate;
        FSFTPClient.ASCIIMode     := false;
        FSFTPClient.KeyStorage    := ElSSHMemoryKeyStorage1;

        FDir:=ExtractFileDir(Application.ExeName)+'\';

        if NOT DirectoryExists(FDir) then
           begin
            ForceDirectories(FDir);
           end;
        mmo1.Lines.Add('Fichier : '+ FDir + Afile);
        mmo1.Lines.Add('On va ouvrir');

        FSFTPClient.Open;

        mmo1.Lines.Add('Open : OK');
        mmo1.Lines.Add(Format('UPLOAD %s => %s',[FDir + Afile,ExtractFileName(afile)]));
        FSFTPClient.UploadFile(FDir + Afile,'/IN/GINFCC01/'+ExtractFileName(afile));
        mmo1.Lines.Add('UPLOAD OK');
        FSFTPClient.Close;
        mmo1.Lines.Add('Close OK');
        result:=true;
        Except
            On E:Exception do
          begin
              MessageDlg(E.Message, mtWarning, [mbOK], 0);
              result:=false;
          end;
      end;
end;


function TFrm_CEGID2ORANGE.Export_orange:boolean;
var ligne:string;
    i,j:integer;
    Separateur:string;
    datas :TStringList;
    AFileName:string;
begin
   //------------------------------
   Label_Importation.Caption:='En cours...';
   datas := TStringList.Create;
   result:=false;
   try
     try
       DataMod.FDConCEGID.Open;
     // téléphone Principal
     QCEGID.Close;
     QCEGID.SQL.Clear;
     QCEGID.SQL.Text:=SQL_CEGID_ORANGE;
     QCEGID.open;
     ProgressBar1.Position:=0;
     ProgressBar1.Max:=QCEGID.RecordCount;
     ProgressBar1.Visible:=true;
     j:=1;
     while not(QCEGID.Eof) do
      begin
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          ligne:='';
          if (cbRF.Checked) then
            begin
                  if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;0;1',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring]
                           )
                    else
                        ligne := Format('%s;%s;%s;%s;0;%s',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring,
                           QCEGID.Fields[5].asstring]
                           );
            end
          else
              begin
                if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;%s;1',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring
                         ])
                    else
                        ligne := Format('%s;%s;%s;%s;%s;%s',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring,
                         QCEGID.Fields[5].asstring
                         ])
              end;

          if ligne<>'' then
            begin
                Datas.Add(format('%d;%s',[j,ligne]));
                inc(j);
            end;
          QCEGID.Next;
          ProgressBar1.Refresh;
      end;

     // téléphone Contacts
     QCEGID.Close;
     QCEGID.SQL.Clear;
     QCEGID.SQL.Text:=SQL_CEGID_CTC;
     QCEGID.open;
     ProgressBar1.Position:=0;
     ProgressBar1.Max:=QCEGID.RecordCount;
     ProgressBar1.Visible:=true;
     while not(QCEGID.Eof) do
      begin
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          ligne:='';
          if (cbRF.Checked) then
            begin
                  if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;0;1',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring]
                           )
                    else
                        ligne := Format('%s;%s;%s;%s;0;%s',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring,
                           QCEGID.Fields[5].asstring]
                           );
            end
          else
              begin
                if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;%s;1',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring
                         ])
                    else
                        ligne := Format('%s;%s;%s;%s;%s;%s',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring,
                         QCEGID.Fields[5].asstring
                         ])
              end;

          if ligne<>'' then
            begin
                Datas.Add(format('%d;%s',[j,ligne]));
                inc(j);
            end;
          QCEGID.Next;
          ProgressBar1.Refresh;
      end;

     // téléphone Portable
     QCEGID.Close;
     QCEGID.SQL.Clear;
     QCEGID.SQL.Text:=SQL_CEGID_MOBILE;
     QCEGID.open;
     ProgressBar1.Position:=0;
     ProgressBar1.Max:=QCEGID.RecordCount;
     ProgressBar1.Visible:=true;
     while not(QCEGID.Eof) do
      begin
          ProgressBar1.Position:=QCEGID.RecNo;
          Application.ProcessMessages;
          ligne:='';
          if (cbRF.Checked) then
            begin
                  if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;0;1',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring]
                           )
                    else
                        ligne := Format('%s;%s;%s;%s;0;%s',[
                           QCEGID.Fields[0].asstring,
                           QCEGID.Fields[1].asstring,
                           QCEGID.Fields[2].asstring,
                           QCEGID.Fields[3].asstring,
                           QCEGID.Fields[5].asstring]
                           );
            end
          else
              begin
                if (cbNOSYMAG.Checked)
                    then
                        ligne := Format('%s;%s;%s;%s;%s;1',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring
                         ])
                    else
                        ligne := Format('%s;%s;%s;%s;%s;%s',[
                         QCEGID.Fields[0].asstring,
                         QCEGID.Fields[1].asstring,
                         QCEGID.Fields[2].asstring,
                         QCEGID.Fields[3].asstring,
                         QCEGID.Fields[4].asstring,
                         QCEGID.Fields[5].asstring
                         ])
              end;

          if ligne<>'' then
            begin
                Datas.Add(format('%d;%s',[j,ligne]));
                inc(j);
            end;
          QCEGID.Next;
          ProgressBar1.Refresh;
      end;

      AFileName:='cegid2orange_' + FormatDateTime('yyyymmdd_hhnnsszzz',Now()) + '.txt';
      Datas.SaveToFile(AFileName);
      FFile2Export:=AFileName;
      mmo1.Lines.Add(Format('Fichier Sauvegardé : %s',[AFileName]));
      Except on E:exception
        do
          begin
            mmo1.Lines.Add('Impossible de Générer le fichier');
            result:=false;
          end;
      end;
   finally
      ProgressBar1.Visible:=false;
      datas.Free;
      DataMod.FDConCEGID.Close;
      Label_Importation.Caption:='Terminé';
   end;
end;


initialization
  SetLicenseKey('4003D46B2B8444C662FA106C95792805D3E87D27FC53D6E57C3050AEA3E7375A' +
              'E9D03CD909F3120E8E740B4510CEA0E5D3303E83DD28EFEB5862603B18E7EF46' +
              '2FA3CE11BDECA8DC271B63F7F53D6EEEA8709B45130709DC97A73B9EFD3A8D92' +
              'DF286D7B55C02D26322D76D4E0312936C177419931345AED6B3A298774A71B05' +
              'F4DE9D00FCF9DC55F907219D5AB67032F7D184F4CD069CE39F28E60AE4DA6034' +
              'B434939F74F61535C602116CFAEBF228F6477B7D20D7FC43D8502ADA45359169' +
              '3D708AFDAB7A08DD8A2D3092082466DA583EF082625E8C3820BE5EF5B48D45B2' +
              'F76D49B11FE99F2295F677A8F3BD84A4560E73C231803D74EAFE53105B38017F');



end.

