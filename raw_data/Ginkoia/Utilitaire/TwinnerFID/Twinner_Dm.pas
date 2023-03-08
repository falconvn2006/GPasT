unit Twinner_Dm;

interface

uses
  SysUtils, Classes, ADODB, DB, IBCustomDataSet, IBQuery, IBDatabase, dxmdaset,
  IniFiles, Dialogs, IniCfg_Frm, Forms;

const
  ProcExtractFileName: string = 'TwinnerFID_ProcExtract.sql';

type
  TFtpExtraction = record
    Host: string;
    User: string;
    Pass: string;
    Port: integer;
    RepFtp: string;
  end;

  TDm_Twinner = class(TDataModule)
    ado: TADOConnection;
    que_dos: TADOTable;
    que_dosDOS_ID: TAutoIncField;
    que_dosDOS_NOM: TStringField;
    que_dosDOS_CHEMIN: TStringField;
    que_dosDOS_DATEACTIV: TDateTimeField;
    que_dosDOS_lastversion: TIntegerField;
    que_dosDOS_actif: TSmallintField;
    que_dosDOS_GUID: TStringField;
    que_mag: TADOQuery;
    que_magmag_id: TAutoIncField;
    que_magmag_dosid: TIntegerField;
    que_magmag_nom: TStringField;
    que_magmag_enseigne: TStringField;
    que_magmag_ville: TStringField;
    que_magmag_idfid: TIntegerField;
    que_magmag_codeadh: TStringField;
    que_magmag_actif: TIntegerField;
    que_magmag_dateactiv: TDateTimeField;
    que_magmag_magid: TIntegerField;
    Que_ListeAdherents: TADOQuery;
    que_maxid: TADOQuery;
    que_maxidid: TIntegerField;
    adoRefresh: TADOConnection;
    GINKOIA: TIBDatabase;
    TB: TIBTransaction;
    Que_GUID: TIBQuery;
    Que_InitMags: TIBQuery;
    Que_InitMagsMAG_NOM: TIBStringField;
    Que_InitMagsMAG_ENSEIGNE: TIBStringField;
    Que_InitMagsVIL_NOM: TIBStringField;
    Que_InitMagsMAG_CODEADH: TIBStringField;
    Que_InitMagsMAG_ID: TIntegerField;
    que_LV: TIBQuery;
    que_cli: TIBQuery;
    que_IM: TIBQuery;
    Que_P1: TIBQuery;
    QUE_P2: TIBQuery;
    que_p3: TIBQuery;
    Que_DosMag: TADOQuery;
    Que_DosMagmag_id: TAutoIncField;
    Que_DosMagdos_nom: TStringField;
    Que_DosMagmag_codeadh: TStringField;
    Que_DosMagmag_nom: TStringField;
    Que_DosMagmag_ville: TStringField;
    Que_DosMagCanSelect: TIntegerField;
    Que_DosMagOkSelect: TIntegerField;
    ADOConnection1: TADOConnection;
    MemD_ErrSelAuto: TdxMemData;
    MemD_ErrSelAutoNo: TIntegerField;
    MemD_ErrSelAutoCodeAd: TStringField;
    MemD_ErrSelAutoInfoErr: TStringField;
    Que_DosMagdos_chemin: TStringField;
    Que_DosMagmag_magid: TIntegerField;
    Que_DosMagsCodeSur6: TStringField;
    Que_Client: TIBQuery;
    Que_FidNatTwin: TIBQuery;
    Que_ClientFidNatTwin: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure que_magBeforePost(DataSet: TDataSet);
    procedure que_dosBeforePost(DataSet: TDataSet);
    procedure que_dosAfterScroll(DataSet: TDataSet);
    procedure que_dosDOS_DATEACTIVGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure que_dosAfterPost(DataSet: TDataSet);
    procedure que_magNewRecord(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Que_DosMagCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
    flagAS: integer;
    AdoMSConnextion: string;
  public
    { Déclarations publiques }
    NomProcStockExtract: string;
    FtpExtraction: TFtpExtraction;
    ListeSelExtract: TStringList;
    flagScroll: boolean;


    procedure Init;
  end;

var
  Dm_Twinner: TDm_Twinner;
  // repertoire de base ou se trouve l'exe
  ReperBase: string;
  // repertoire des extract pour My Twinner
  ReperMyTwinner: string;
  // repertoire des extraction avant envoi ftp
  ReperExtract: string;


implementation

{$R *.dfm}

uses
  Twinner_Frm;

procedure TDm_Twinner.DataModuleCreate(Sender: TObject);
var
  sFicIni: String;
  LstIni: TInifile;
  LstTmp: TStringList;
  i: integer;
begin
  // liste des magasins sélectionnés pour l'extraction
  ListeSelExtract := TStringList.Create;

  flagAS := 0;

  // repertoire de base ou se trouve l'exe
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  // repertoire des extract pour My Twinner
  ReperMyTwinner := ReperBase+'EXTRACT\';
  if not(DirectoryExists(ReperMyTwinner)) then
    ForceDirectories(ReperMyTwinner);

  // repertoire des extraction avant envoi ftp
  ReperExtract := ReperBase+'ENVOI\';
  if not(DirectoryExists(ReperExtract)) then
    ForceDirectories(ReperExtract);

  // Chaine de connexion du composant ado
  AdoMSConnextion := '';

  // Parametre Ftp envoi des extractions
  FtpExtraction.Host := '';
  FtpExtraction.User := '';
  FtpExtraction.Pass := '';
  FtpExtraction.Port := 21;
  FtpExtraction.RepFtp := '';

  // nom de la procédure stockée pour l'extraction
    NomProcStockExtract :='';

  // Initialisation
  Init;

  // fichier ini
//  sFicIni := ReperBase+'TwinnerFID.ini';
//  if fileExists(sFicIni) then
//  begin
//    IniCfg.LoadIni;
//
//    // nom de la procédure stockée pour l'extraction
//    NomProcStockExtract := IniCfg.ProcStockee;
//
//    // Parametre Ftp envoi des extractions
//    FtpExtraction.Host := IniCfg.FTPHost;
//    FtpExtraction.User := IniCfg.FTPUser;
//    FtpExtraction.Pass := IniCfg.FTPPass;
//    FtpExtraction.Port := IniCfg.FTPPort;
//    FtpExtraction.RepFtp := IniCfg.FTPDir;
//
//    //déactiver le scroll du tableau des dossiers
//    flagScroll := false;
//    try
//      ado.ConnectionString := IniCfg.MsSqlConnectionString;
//      ado.connected := true;
//      que_dos.open;
//      Que_DosMag.Open;
//    except on Stan: Exception do
//      begin
//        MessageDlg('Erreur lors de connexion : ' + stan.message, mterror,[mbok], 0);
//      end;
//    end;

//    LstIni := TIniFile.Create(sFicIni);
//    try
//      // Chaine de connexion du composant ado
//      LstTmp := TStringList.Create;
//      try
//        if LstIni.SectionExists('AdoSQLServer') then
//        begin
//          LstIni.ReadSection('AdoSQLServer',LstTmp);
//          AdoMSConnextion := '';
//          for i := 1 to LstTmp.Count do
//          begin
//            if AdoMSConnextion<>'' then
//              AdoMSConnextion := AdoMSConnextion+';';
//            AdoMSConnextion := AdoMSConnextion+LstTmp[i-1]+'='+LstIni.ReadString('AdoSQLServer', LstTmp[i-1],'');
//          end;
//        end;
//      finally
//        FreeAndNil(LstTmp);
//      end;

//      // nom de la procédure stockée pour l'extraction
//      NomProcStockExtract := LstIni.ReadString('Extraction', 'ProcStockee', '');
//
//      // Parametre Ftp envoi des extractions
//      FtpExtraction.Host := LstIni.ReadString('FtpExtraction', 'Host', '');
//      FtpExtraction.User := LstIni.ReadString('FtpExtraction', 'User', '');
//      FtpExtraction.Pass := LstIni.ReadString('FtpExtraction', 'Pass', '');
//      FtpExtraction.Port := LstIni.ReadInteger('FtpExtraction', 'Port', 21);
//      FtpExtraction.RepFtp := LstIni.ReadString('FtpExtraction', 'ReperFTP', '');
//
//    finally
//      FreeAndNil(LstIni);
//    end;
//  end;
//  //déactiver le scroll du tableau des dossiers
//  flagScroll := false;
//  try
//    ado.ConnectionString := AdoMSConnextion;
//    ado.connected := true;
//    que_dos.open;
//    Que_DosMag.Open;
//  except on Stan: Exception do
//    begin
//      MessageDlg('Erreur lors de connexion : ' + stan.message, mterror,[mbok], 0);
//    end;
//  end;

end;

procedure TDm_Twinner.DataModuleDestroy(Sender: TObject);
begin
  ado.close;
  ginkoia.close;
  FreeAndNil(ListeSelExtract);
end;

procedure TDm_Twinner.Init;
var
  sFicIni : String;
begin
  // fichier ini
  sFicIni := ChangeFileExt(Application.ExeName,'.ini');
  if FileExists(sFicIni) then
  begin
    IniCfg.LoadIni;
    IniCfg.AdoConnection := ado;

    // nom de la procédure stockée pour l'extraction
    NomProcStockExtract := IniCfg.ProcStockee;

    // Parametre Ftp envoi des extractions
    FtpExtraction.Host := IniCfg.FTPHost;
    FtpExtraction.User := IniCfg.FTPUser;
    FtpExtraction.Pass := IniCfg.FTPPass;
    FtpExtraction.Port := IniCfg.FTPPort;
    FtpExtraction.RepFtp := IniCfg.FTPDir;

    //déactiver le scroll du tableau des dossiers
    flagScroll := false;
    try
      ado.Connected := False;
      ado.ConnectionString := IniCfg.MsSqlConnectionString;
      ado.connected := true;
      que_dos.open;
      Que_DosMag.Open;
    except on Stan: Exception do
      begin
        MessageDlg('Erreur lors de connexion : ' + stan.message, mterror,[mbok], 0);
      end;
    end;
  end
  else
    Showmessage('Pas de fichier de configuration'#13#10' veuillez paramétrer le logiciel');
end;

procedure TDm_Twinner.que_dosAfterPost(DataSet: TDataSet);
//var
  //doneInitialise : boolean;
begin
  //doneInitialise := false;
  if flagas = 1 then
  begin
//      que_mag.insert;
//      que_magmag_dosid.asinteger := que_dosDOS_ID.asinteger;
//      que_magmag_nom.asstring := 'MAGASIN XXXX';
//      que_magmag_ville.asstring := '';
//      que_magmag_idfid.asinteger := 0;
//      que_magmag_codeadh.asstring := '';
//      que_mag.post;
//      que_mag.close;
//    flagas := 0;
    que_dosAfterScroll(nil);
  end;
  flagas := 0;
  //Création automatique des magasins en creation du dossier ou raffraichir les données en édition du dossier
  //si le chemin vers la base est renseigné
  Frm_Twinner.RefreshMag();
end;

procedure TDm_Twinner.que_dosAfterScroll(DataSet: TDataSet);
begin
  if flagAS <> 0 then
    EXIT;

  //try
    //si scroll actif recharger la liste des magasins
  if flagScroll then
  begin
    que_mag.close;
    que_mag.sql[que_mag.tag] := 'or (mag_id=0)';
    que_mag.parameters[0].value := que_dosDOS_ID.asinteger;
    que_mag.open;
        //MessageDlg(inttostr(que_mag.recordcount), mtWarning, [], 0);
      //lab si plus d'un enregistrement, masquer le mag 0
    if que_mag.recordcount > 1 then
    begin
      que_mag.close;
      que_mag.sql[que_mag.tag] := '';
      que_mag.open;
    end;
  end;
  //except

  //end
end;

procedure TDm_Twinner.que_dosBeforePost(DataSet: TDataSet);
begin
  if (que_dosDOS_actif.asinteger = 1) and (que_dosDOS_DATEACTIV.asstring = '') then que_dosDOS_actif.asinteger := 0;
  flagas := 2;
  if que_dos.state in [dsinsert] then
  begin
    flagas := 1;
  end;
    //lab ajouter le Guid
  if que_dos.state in [dsinsert, dsEdit] then
  begin
    try
        //si un chemin vers la base est renseigné
      if trim(que_dosDos_chemin.asString) <> '' then
      begin
          //récupèrer le guid de la base 0
        ginkoia.close;
        ginkoia.databasename := que_dosDOS_CHEMIN.asstring;
        que_guid.close;
        ginkoia.open;
        que_guid.open;
        if (que_guid.recordCount = 1) then
        begin
          Que_dosDos_GUID.asstring := que_guid.FieldbyName('bas_guid').asString;
        end;
      end;
    except on Stan: exception do
      begin
        que_guid.close;
        ginkoia.close;
        MessageDlg(Stan.MEssage, mterror, [mbok], 0);
      end;
    end;
  end;
end;

procedure TDm_Twinner.que_dosDOS_DATEACTIVGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if copy(sender.asstring, 1, 10) = '01/01/1900' then
    text := ''
  else
    text := copy(sender.asstring, 1, 10);
end;

procedure TDm_Twinner.Que_DosMagCalcFields(DataSet: TDataSet);
var
  sCode6: string;  // code adhérent mis en longueur 6 complèté pas 0 à gauche
begin
  // ce magasin peut t'il être sélectionné
  if Trim(Que_DosMag.FieldByName('mag_codeadh').AsString)='' then
    Que_DosMag.FieldByName('CanSelect').AsInteger := 0
  else
    Que_DosMag.FieldByName('CanSelect').AsInteger := 1;

  // code adhérent sur 6 carac complèté par de 0 à gauche
  sCode6 := Trim(Que_DosMag.FieldByName('mag_codeadh').AsString);
  if sCode6<>'' then
  begin
    while Length(sCode6)<6 do
      sCode6 := '0'+sCode6;
    Que_DosMag.FieldByName('sCodeSur6').AsString := sCode6;
  end;

  // ce magasin est-il sélectionné
  if (Que_DosMag.RecordCount>0)
       and (sCode6<>'')
       and (ListeSelExtract.IndexOf(sCode6)>=0) then
    Que_DosMag.FieldByName('OkSelect').AsInteger := 1
  else
    Que_DosMag.FieldByName('OkSelect').AsInteger := 0;
end;

procedure TDm_Twinner.que_magBeforePost(DataSet: TDataSet);
begin
  que_magMAG_DOSID.asinteger := que_dosDOS_ID.asinteger;
end;

procedure TDm_Twinner.que_magNewRecord(DataSet: TDataSet);
begin
  que_magmag_dosid.asinteger := que_dosDOS_ID.asinteger;
  que_magmag_magid.asinteger := 0;
end;

end.
