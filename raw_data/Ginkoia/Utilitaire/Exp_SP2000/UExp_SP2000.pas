unit UExp_SP2000;

interface

uses
   UExport, 
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, ExtCtrls, StdCtrls, dxDBTLCl, dxGrClms, dxTL, dxDBCtrl,
   dxDBGrid, dxCntner, Db, IBCustomDataSet, IBQuery, IBDatabase,
   ComCtrls, Mask, DBCtrls, IBUpdateSQL, dxDBGridHP, vgCtrls, vgPageControlRv,
   FtpThread;

   //dxDBGridHP, vgCtrls, vgPageControlRv
type
  TParamExp2000 = record
    FtpHost: string;
    FtpUser: string;
    FtpPass: string;
    BlqEnvoie: boolean;
  end;

   TdxCheckBoxState = (cbsUnchecked, cbsChecked, cbsGrayed, cbsGrayedChecked);
   TFrm_Exp_SP2000 = class(TForm)
      Pgc_Prin: TvgPageControlRv;
      TabSheet1: TTabSheet;
      TabSheet2: TTabSheet;
      TabSheet3: TTabSheet;
      Label1: TLabel;
      Data: TIBDatabase;
      Tran: TIBTransaction;
      IBQue_Bases: TIBQuery;
      IBQue_BasesBAS_ID: TIntegerField;
      IBQue_BasesBAS_NOM: TIBStringField;
      IBQue_BasesBAS_PATH: TIBStringField;
      Ds_Bases: TDataSource;
      DBG_Bases: TdxDBGridHP;
      DBG_BasesBAS_ID: TdxDBGridMaskColumn;
      DBG_BasesBAS_NOM: TdxDBGridMaskColumn;
      DBG_BasesBAS_PATH: TdxDBGridMaskColumn;
      IBQue_Magasins: TIBQuery;
      IBQue_MagasinsMAG_ID: TIntegerField;
      IBQue_MagasinsMAG_BASID: TIntegerField;
      IBQue_MagasinsMAG_EXPOR: TIntegerField;
      IBQue_MagasinsMAG_ENSEIGNE: TIBStringField;
      IBQue_MagasinsMAG_VILLE: TIBStringField;
      IBQue_MagasinsMAG_CODEADH: TIBStringField;
      IBQue_MagasinsMAG_VRAIID: TIntegerField;
      DBG_Magasins: TdxDBGridHP;
      Ds_Magasins: TDataSource;
      DBG_MagasinsMAG_ID: TdxDBGridMaskColumn;
      DBG_MagasinsMAG_BASID: TdxDBGridMaskColumn;
      DBG_MagasinsMAG_EXPOR: TdxDBGridCheckColumn;
      DBG_MagasinsMAG_CODEADH: TdxDBGridMaskColumn;
      DBG_MagasinsMAG_ENSEIGNE: TdxDBGridMaskColumn;
      DBG_MagasinsMAG_VILLE: TdxDBGridMaskColumn;
      DBG_MagasinsMAG_VRAIID: TdxDBGridMaskColumn;
      Label2: TLabel;
      Label3: TLabel;
      BBtn_Synchron: TBitBtn;
      Panel1: TPanel;
      Nbt_AddBases: TSpeedButton;
      Nbt_SUPBases: TSpeedButton;
      OD_Bases: TOpenDialog;
      Qry: TIBQuery;
      DataDist: TIBDatabase;
      TranDist: TIBTransaction;
      DBEdit1: TDBEdit;
      DBEdit2: TDBEdit;
      QryDistMag: TIBQuery;
      QryDistMagVIL_NOM: TIBStringField;
      QryDistMagMAG_ID: TIntegerField;
      QryDistMagMAG_CODEADH: TIBStringField;
      QryDistMagMAG_ENSEIGNE: TIBStringField;
      IBUpd_Magasins: TIBUpdateSQL;
      Panel2: TPanel;
      Panel3: TPanel;
      SpeedButton1: TSpeedButton;
      SpeedButton2: TSpeedButton;
      SpeedButton3: TSpeedButton;
      DBG_Export: TdxDBGridHP;
      IBQue_Export: TIBQuery;
      Ds_Export: TDataSource;
      IBQue_ExportEXP_ID: TIntegerField;
      IBQue_ExportEXP_DATE: TDateTimeField;
      IBQue_ExportEXP_NOM: TIBStringField;
      IBQue_ExportEXP_TYPE: TIntegerField;
      IBQue_ExportEXP_DEBUT: TDateTimeField;
      IBQue_ExportEXP_FIN: TDateTimeField;
      IBQue_ExportEXP_VALIDE: TIntegerField;
      DBG_ExportEXP_ID: TdxDBGridMaskColumn;
      DBG_ExportEXP_DATE: TdxDBGridDateColumn;
      DBG_ExportEXP_NOM: TdxDBGridMaskColumn;
      DBG_ExportEXP_DEBUT: TdxDBGridDateColumn;
      DBG_ExportEXP_FIN: TdxDBGridDateColumn;
      DBG_ExportEXP_VALIDE: TdxDBGridCheckColumn;
      IBQue_ExportTypeStr: TStringField;
      DBG_ExportEXP_TYPE: TdxDBGridMaskColumn;
      IBQue_EXPMAG: TIBQuery;
      IBUpd_EXPMAG: TIBUpdateSQL;
      IBQue_EXPMAGMXP_ID: TIntegerField;
      IBQue_EXPMAGMXP_MAGID: TIntegerField;
      IBQue_EXPMAGMXP_EXPID: TIntegerField;
      IBQue_EXPMAGMXP_DATE: TDateTimeField;
      IBQue_EXPMAGEXP_ID: TIntegerField;
      IBQue_EXPMAGEXP_DATE: TDateTimeField;
      IBQue_EXPMAGEXP_NOM: TIBStringField;
      IBQue_EXPMAGEXP_TYPE: TIntegerField;
      IBQue_EXPMAGEXP_DEBUT: TDateTimeField;
      IBQue_EXPMAGEXP_FIN: TDateTimeField;
      IBQue_EXPMAGEXP_VALIDE: TIntegerField;
      Ds_EXPMAG: TDataSource;
      DBG_EXPMAG: TdxDBGridHP;
      DBG_EXPMAGMXP_ID: TdxDBGridMaskColumn;
      DBG_EXPMAGMXP_MAGID: TdxDBGridMaskColumn;
      DBG_EXPMAGMXP_EXPID: TdxDBGridMaskColumn;
      DBG_EXPMAGMXP_DATE: TdxDBGridDateColumn;
      DBG_EXPMAGEXP_ID: TdxDBGridMaskColumn;
      DBG_EXPMAGEXP_DATE: TdxDBGridDateColumn;
      DBG_EXPMAGEXP_NOM: TdxDBGridMaskColumn;
      DBG_EXPMAGEXP_TYPE: TdxDBGridMaskColumn;
      DBG_EXPMAGEXP_DEBUT: TdxDBGridDateColumn;
      DBG_EXPMAGEXP_FIN: TdxDBGridDateColumn;
      DBG_EXPMAGEXP_VALIDE: TdxDBGridMaskColumn;
      IBQue_EXPMAGTYPEStr: TStringField;
      DBG_EXPMAGTYPEStr: TdxDBGridColumn;
      Panel4: TPanel;
      SpeedButton5: TSpeedButton;
      BitBtn1: TBitBtn;
      IBQue_Histo: TIBQuery;
      Ds_Histo: TDataSource;
      Panel5: TPanel;
      IBQue_HistoMXP_DATE: TDateTimeField;
      IBQue_HistoEXP_NOM: TIBStringField;
      IBQue_HistoEXP_TYPE: TIntegerField;
      IBQue_HistoMAG_ENSEIGNE: TIBStringField;
      IBQue_HistoMAG_CODEADH: TIBStringField;
      IBQue_HistoBAS_NOM: TIBStringField;
      IBQue_HistoTypestr: TStringField;
      DBG_Histo: TdxDBGridHP;
      IBQue_HistoMXP_ID: TIntegerField;
      DBG_HistoMXP_DATE: TdxDBGridDateColumn;
      DBG_HistoEXP_NOM: TdxDBGridMaskColumn;
      DBG_HistoEXP_TYPE: TdxDBGridMaskColumn;
      DBG_HistoMAG_ENSEIGNE: TdxDBGridMaskColumn;
      DBG_HistoMAG_CODEADH: TdxDBGridMaskColumn;
      DBG_HistoBAS_NOM: TdxDBGridMaskColumn;
      DBG_HistoTypestr: TdxDBGridColumn;
      DBG_HistoMXP_ID: TdxDBGridMaskColumn;
      BitBtn2: TBitBtn;
      TranLect: TIBTransaction;
      QryLect: TIBQuery;
      QryDist: TIBQuery;
      BitBtn3: TBitBtn;
    IBQue_Collection: TIBQuery;
    IBQue_CollectionCOL_NOM: TIBStringField;
    Nbt_CtrlExport: TBitBtn;
    SaveCsv: TSaveDialog;
    IBQue_MagExporter: TIBQuery;
    Nbt_Bloq: TBitBtn;
    Lab_InfoBloq: TLabel;
    Lab_InfoBloq2: TLabel;
      procedure Nbt_AddBasesClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure BBtn_SynchronClick(Sender: TObject);
      procedure IBQue_MagasinsAfterOpen(DataSet: TDataSet);
      procedure Nbt_SUPBasesClick(Sender: TObject);
      procedure IBQue_ExportCalcFields(DataSet: TDataSet);
      procedure SpeedButton1Click(Sender: TObject);
      procedure SpeedButton2Click(Sender: TObject);
      procedure SpeedButton3Click(Sender: TObject);
      procedure IBQue_EXPMAGCalcFields(DataSet: TDataSet);
      procedure SpeedButton5Click(Sender: TObject);
      procedure IBQue_HistoCalcFields(DataSet: TDataSet);
      procedure BitBtn2Click(Sender: TObject);
      procedure BitBtn3Click(Sender: TObject);
      procedure DBG_ExportDblClick(Sender: TObject);
      procedure BitBtn1Click(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_CtrlExportClick(Sender: TObject);
    procedure Nbt_BloqClick(Sender: TObject);
   private
    { Déclarations privées }
      ReperBase     : string;
      ReperExport   : string;
      ReperExportOk : string;
      ReperExportErr: string;
      ParamExp2000: TParamExp2000;

      procedure DoInfoBloq;
      procedure LoadParamExp2000;
      procedure SaveParamExp2000;
      procedure ReEnvoie;
      procedure EnvoieFtp(AFilename: string);
      procedure Commit;
      procedure Synchro_Mag;
      function Export_CMD(Nom, Base, Adh: string; MAGID: Integer; DDeb,
         DFin: TdateTime): Boolean;
      function Export_VTE(Nom, Base, Adh: string; MAGID: Integer; DDeb,
         DFin: TdateTime): Boolean;
   public
    { Déclarations publiques }
      ftp: TFtpThread;
   end;

var
   Frm_Exp_SP2000: TFrm_Exp_SP2000;

implementation

{$R *.DFM}

procedure TFrm_Exp_SP2000.EnvoieFtp(AFilename: string);
var
  SearchRec: TSearchRec;
  Resu: integer;
  bOk: boolean;
begin
  if ParamExp2000.BlqEnvoie then
    exit;
    
  bOk := false;
  Resu := FindFirst(AFileName, faAnyFile, SearchRec);
  if resu=0 then
    bOk := (SearchRec.Size>1024);
  FindClose(SearchRec);
  if bOk then
    ftp.ajoute(AFilename, ExtractFileName(AFilename))
  else
    RenameFile(AFileName, ReperExportErr+ExtractFileName(AFileName));
end;

procedure TFrm_Exp_SP2000.Commit;
var
   basid: integer;
begin
   basid := IBQue_BasesBAS_ID.Asinteger;
   if tran.Active and (tran.InTransaction) then
      tran.commit;
   tran.Active := true;
   IBQue_Bases.Open;
   while not IBQue_Bases.Eof do
      IBQue_Bases.Next;
   while not IBQue_Bases.BOF and (IBQue_BasesBAS_ID.Asinteger <> basid) do
      IBQue_Bases.Prior;
   IBQue_Magasins.Open;
   DBG_MagasinsMAG_EXPOR.ReadOnly := False;
   IBQue_Export.Open;
   IBQue_EXPMAG.Open;
   IBQue_Histo.Open;
end;

procedure TFrm_Exp_SP2000.Nbt_AddBasesClick(Sender: TObject);
var
   S: string;
   i: integer;
   Base: string;
   Nom: string;
begin
   if OD_Bases.execute then
   begin
    // Découpage de la base
      S := Uppercase(OD_Bases.FileName);
      if s[1] = '\' then
      begin
      // Distant
         delete(s, 1, 2);
         if pos('$', s) > 0 then
         begin
            s[pos('$', s)] := ':';
            s[pos('\', s)] := ':';
         end
         else
         begin
            i := pos('\', s);
            insert(':D:', s, i);
         end;
         Base := S;
      end
      else
      begin
         // local
         Base := S;
      end;
      Qry.close;
      Qry.Sql.clear;
      Qry.Sql.Add('Select * from BASES where BAS_PATH = ' + QuotedStr(Base));
      Qry.Open;
      if not Qry.IsEmpty then
      begin
         Application.MessageBox('La Base est déjà référencée', '  Erreur', Mb_OK);
         EXIT;
      end;
      Nom := Base;
      while Nom[length(Nom)] <> '\' do
         delete(nom, length(Nom), 1);
      delete(nom, length(Nom), 1);
      while Nom[length(Nom)] <> '\' do
         delete(nom, length(Nom), 1);
      delete(nom, length(Nom), 1);
      while pos('\', Nom) > 0 do
         delete(Nom, 1, pos('\', Nom));
      qry.close;
      qry.SQL.text := 'INSERT INTO BASES (BAS_NOM,BAS_PATH) VALUES (' +
         QuotedStr(Nom) + ',' + QuotedStr(Base) + ')';
      qry.ExecSQL;
      commit;
      while not IBQue_Bases.Bof do
         IBQue_Bases.Prior;
      while IBQue_BasesBAS_PATH.asString <> base do
         IBQue_Bases.next;
      Synchro_Mag;
   end;
end;

procedure TFrm_Exp_SP2000.Nbt_BloqClick(Sender: TObject);
begin
  if ParamExp2000.BlqEnvoie then
  begin
    if MessageDlg('Tous les fichiers présents dans le répertoire EXPORT vont être envoyés par FTP.'+#13#10+#13#10+
               'Continuez ?', mtconfirmation, [mbyes, mbno], 0, mbno)<>mryes then
      exit;

    LoadParamExp2000;
    ParamExp2000.BlqEnvoie := false;
    SaveParamExp2000;
    DoInfoBloq;
    ReEnvoie;
  end
  else begin
    if MessageDlg('Etes-vous sûr de vouloir bloquer l''envoi FTP ?', mtConfirmation, [mbyes,mbno], 0, mbno)<>mryes then
      exit;
           
    LoadParamExp2000;
    ParamExp2000.BlqEnvoie := true;
    SaveParamExp2000;
    DoInfoBloq;
  end;
end;

procedure TFrm_Exp_SP2000.Nbt_CtrlExportClick(Sender: TObject);
var
  TPListe:TStringList;
begin
  if SaveCsv.Execute then
  begin
    Screen.Cursor := CrHourGlass;
    Application.ProcessMessages;
    TPListe:=TStringList.Create;
    IBQue_MagExporter.Open;
    try
      TPListe.Add('NomBase;Magasin;CodeAdherent;Ville');
      IBQue_MagExporter.First;
      while not(IBQue_MagExporter.Eof) do
      begin
        TPListe.Add(IBQue_MagExporter.fieldbyname('bas_nom').AsString+';'+
                    IBQue_MagExporter.fieldbyname('mag_enseigne').AsString+';'+
                    IBQue_MagExporter.fieldbyname('mag_codeadh').AsString+';'+
                    IBQue_MagExporter.fieldbyname('mag_ville').AsString);
        IBQue_MagExporter.Next;
      end;
      TPListe.SaveToFile(SaveCsv.FileName);
    finally
      IBQue_MagExporter.Close;
      FreeAndNil(TPListe);
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFrm_Exp_SP2000.FormCreate(Sender: TObject);
var
  f: tsearchrec;
  Resu: integer;
  sTmp: string;
begin
  // initialisation des répertoires
  ReperBase     := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'';
  ReperExport    := ReperBase+'EXPORT\';
  ReperExportOk  := ReperBase+'EXPORT\OK\';
  ReperExportErr := ReperBase+'EXPORT\ERREUR\';
  ForceDirectories(ReperExport);
  ForceDirectories(ReperExportOk);
  ForceDirectories(ReperExportErr);

  LoadParamExp2000;
  DoInfoBloq;

   ftp := TFtpThread.create(self, ParamExp2000.FtpHost, ParamExp2000.FtpUser, ParamExp2000.FtpPass);

   ReEnvoie;

   data.Connected := false;
   data.DatabaseName := ReperBase + 'EXP_SP2000.IB';
   data.Open;
   tran.Active := true;
   TranLect.Active := true;
   IBQue_Bases.Open;
   IBQue_Magasins.Open;
   IBQue_Export.Open;
   IBQue_EXPMAG.Open;
   IBQue_Histo.Open;
end;

procedure TFrm_Exp_SP2000.Synchro_Mag;
begin
   try
      DataDist.Connected := false;
      DataDist.DatabaseName := IBQue_BasesBAS_PATH.AsString;
      DataDist.Open;
      TranDist.Active := true;
      QryDistMag.Open;
      QryDistMag.First;
      IBQue_Magasins.DisableControls;
      while not QryDistMag.Eof do
      begin
         IBQue_Magasins.First;
         while (not IBQue_Magasins.eof) and (IBQue_MagasinsMAG_VRAIID.AsInteger <> QryDistMagMAG_ID.AsInteger) do
            IBQue_Magasins.Next;
         if IBQue_MagasinsMAG_VRAIID.AsInteger <> QryDistMagMAG_ID.AsInteger then
         begin
            qry.close;
            qry.sql.Clear;
            qry.sql.Add(Format('INSERT INTO MAGASINS ' +
               '(MAG_BASID,MAG_EXPOR,MAG_ENSEIGNE,MAG_VILLE,MAG_CODEADH,MAG_VRAIID) ' +
               'VALUES (%d, %d, %s, %s, %s, %d)',
               [IBQue_BasesBAS_ID.asInteger, 1, Quotedstr(QryDistMagMAG_ENSEIGNE.AsString),
               Quotedstr(trim(QryDistMagVIL_NOM.AsString) + ' '), Quotedstr(QryDistMagMAG_CODEADH.AsString),
                  QryDistMagMAG_ID.AsInteger]));
            qry.ExecSQL;
          //
         end
         else
         begin
            qry.close;
            qry.sql.Clear;
            qry.sql.Add('UPDATE MAGASINS');
            qry.sql.Add('SET MAG_ENSEIGNE=' + QuotedStr(QryDistMagMAG_ENSEIGNE.AsString));
            qry.sql.Add('  , MAG_VILLE=' + QuotedStr(trim(QryDistMagVIL_NOM.AsString) + ' '));
            qry.sql.Add('  , MAG_CODEADH=' + QuotedStr(QryDistMagMAG_CODEADH.AsString));
            qry.sql.Add('WHERE MAG_ID=' + IBQue_MagasinsMAG_ID.AsString);
            qry.ExecSQL;
         end;
         QryDistMag.Next;
      end;
      IBQue_Magasins.EnableControls;
      QryDistMag.Close;
      Commit;
   except
      on E: Exception do
         Application.messagebox(pchar(E.Message), 'erreur', mb_ok);
   end;
   DataDist.Connected := false;
end;

procedure TFrm_Exp_SP2000.BBtn_SynchronClick(Sender: TObject);
begin
   Synchro_Mag;
end;

procedure TFrm_Exp_SP2000.IBQue_MagasinsAfterOpen(DataSet: TDataSet);
begin
   DBG_MagasinsMAG_EXPOR.ReadOnly := False;
end;

procedure TFrm_Exp_SP2000.LoadParamExp2000;
var
  sFic: string;
  Lst: TStringList;
begin
  sFic := ReperBase+'Exp_SP2000.ini';
  
  ParamExp2000.FtpHost := '194.250.124.9';
  ParamExp2000.FtpUser := 'be-ginkoia';
  ParamExp2000.FtpPass := 'gk58mlpo';
  ParamExp2000.BlqEnvoie := false;

  if FileExists(sFic) then
  begin
    Lst := TStringList.Create;
    try
      Lst.LoadFromFile(sFic);
      if Lst.IndexOfName('HostFTP')>=0 then
        ParamExp2000.FtpHost := Lst.Values['HostFTP'];
      if Lst.IndexOfName('UserFTP')>=0 then
        ParamExp2000.FtpUser := Lst.Values['UserFTP'];
      if Lst.IndexOfName('PassFTP')>=0 then
        ParamExp2000.FtpPass := Lst.Values['PassFTP'];
      if Lst.IndexOfName('BloqFTP')>=0 then
        ParamExp2000.BlqEnvoie := (UpperCase(Lst.Values['BloqFTP'])='O');
    finally
      FreeAndNil(Lst);
    end;
  end;
end;   

procedure TFrm_Exp_SP2000.SaveParamExp2000;
var
  sFic: string;
  Lst: TStringList;
begin
  sFic := ReperBase+'Exp_SP2000.ini';

  Lst := TStringList.Create;
  try
    Lst.Add('HostFTP='+ParamExp2000.FtpHost);
    Lst.Add('UserFTP='+ParamExp2000.FtpUser);
    Lst.Add('PassFTP='+ParamExp2000.FtpPass);
    if ParamExp2000.BlqEnvoie then
      Lst.Add('BloqFTP=O')
    else
      Lst.Add('BloqFTP=N');

    Lst.SaveToFile(sFic);
  finally
    FreeAndNil(Lst);
  end;
end;

procedure TFrm_Exp_SP2000.Nbt_SUPBasesClick(Sender: TObject);
begin
   if Application.MessageBox('ATTENTION la suppression est irréversible et complète, Continuer ?', ' ATTENTION', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = MrYES then
   begin
      qry.Close;
      qry.sql.clear;
      qry.sql.add('DELETE FROM BASES WHERE BAS_ID = ' + IBQue_BasesBAS_ID.AsString);
      qry.ExecSQL;
      commit;
   end;
end;

procedure TFrm_Exp_SP2000.ReEnvoie;
var
  F: TSearchRec;
  resu: integer;
  sTmp: string;
begin
   resu := FindFirst(ReperExport+'*.CSV', faAnyFile, F);
   while resu=0 do
   begin
     sTmp := ExtractFileName(f.Name);
     if (sTmp<>'.') and (sTmp<>'..') and ((f.Attr and faDirectory)<>faDirectory) then
       EnvoieFtp(ReperExport+f.name);
     resu := FindNext(f);
   end;
   FindClose(f);
end;

procedure TFrm_Exp_SP2000.IBQue_ExportCalcFields(DataSet: TDataSet);
begin
   if IBQue_ExportEXP_TYPE.asinteger = 0 then
      IBQue_ExportTypeStr.AsString := 'CDE'
   else
      IBQue_ExportTypeStr.AsString := 'VTE';
end;

procedure TFrm_Exp_SP2000.SpeedButton1Click(Sender: TObject);
var
   frm_Export: Tfrm_Export;
begin
   Application.CreateForm(Tfrm_Export, frm_Export);
   repeat
      if frm_Export.ShowModal = MrOk then
      begin
         if trim(frm_Export.ed_Nom.Text) = '' then
            application.messagebox('Veuillez indiquer un nom', 'erreur', mb_ok)
         else
         begin
            qry.close;
            qry.sql.clear;
            qry.sql.Add('Select * from EXPORT where EXP_NOM = ' + QuotedStr(frm_Export.ed_Nom.Text));
            qry.Open;
            if not qry.IsEmpty then
            begin
               application.messagebox('Ce nom existe déjà', 'erreur', mb_ok)
            end
            else
            begin
               qry.close;
               qry.Sql.clear;
               qry.Sql.Add('INSERT INTO EXPORT (EXP_DATE, EXP_NOM, EXP_TYPE, EXP_DEBUT, EXP_FIN, EXP_VALIDE) VALUES (');
               qry.Sql.Add('CURRENT_TIMESTAMP,' + QuotedStr(frm_Export.ed_Nom.Text) + ',');
               if frm_Export.Chk_Commande.Checked then
                  qry.Sql.Add('0,')
               else
                  qry.Sql.Add('1,');
               qry.Sql.Add(QuotedStr(FormatDateTime('MM/DD/YYYY', frm_Export.Dte_Debut.Date)) + ',' + QuotedStr(FormatDateTime('MM/DD/YYYY', frm_Export.Dte_Fin.Date)) + ',');
               if frm_Export.Chk_Oui.Checked then
                  qry.Sql.Add('1)')
               else
                  qry.Sql.Add('0)');
               qry.ExecSQL;
               commit;
               while not IBQue_Export.BOF do
                  IBQue_Export.Prior;
               BREAK;
            end;
         end;
      end
      else
         BREAK;
   until false;
   frm_Export.release;
end;

procedure TFrm_Exp_SP2000.SpeedButton2Click(Sender: TObject);
begin
   if Application.MessageBox('ATTENTION la suppression est irréversible et complète, Continuer ?', ' ATTENTION', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = MrYES then
   begin
      qry.Close;
      qry.sql.clear;
      qry.sql.add('DELETE FROM EXPORT WHERE EXP_ID = ' + IBQue_ExportEXP_ID.AsString);
      qry.ExecSQL;
      commit;
   end;
end;

procedure TFrm_Exp_SP2000.SpeedButton3Click(Sender: TObject);
var
   frm_Export: Tfrm_Export;
   expid: integer;
begin
   Application.CreateForm(Tfrm_Export, frm_Export);
   frm_Export.Chk_Commande.Checked := IBQue_ExportEXP_TYPE.AsInteger = 0;
   frm_Export.Chk_vente.Checked := IBQue_ExportEXP_TYPE.AsInteger = 1;
   frm_Export.Chk_Oui.Checked := IBQue_ExportEXP_VALIDE.AsInteger = 1;
   frm_Export.Chk_Non.Checked := IBQue_ExportEXP_VALIDE.AsInteger = 0;
   frm_Export.ed_Nom.Text := IBQue_ExportEXP_NOM.AsString;
   frm_Export.Dte_Debut.Date := IBQue_ExportEXP_DEBUT.AsDateTime;
   frm_Export.Dte_Fin.Date := IBQue_ExportEXP_FIN.AsDateTime;
   if frm_Export.ShowModal = MrOk then
   begin
      expid := IBQue_ExportEXP_ID.AsInteger;
      qry.close;
      qry.Sql.clear;
      qry.Sql.Add('UPDATE EXPORT');
      qry.Sql.Add('SET EXP_NOM = ' + Quotedstr(frm_Export.ed_Nom.Text));
      if frm_Export.Chk_Commande.Checked then
         qry.Sql.Add(', EXP_TYPE=0')
      else
         qry.Sql.Add(', EXP_TYPE=1');
      if frm_Export.Chk_Oui.Checked then
         qry.Sql.Add(', EXP_VALIDE=1')
      else
         qry.Sql.Add(', EXP_VALIDE=0');
      qry.Sql.Add(', EXP_DEBUT=' + QuotedStr(FormatDateTime('MM/DD/YYYY', frm_Export.Dte_Debut.Date)) + ', EXP_FIN=' + QuotedStr(FormatDateTime('MM/DD/YYYY', frm_Export.Dte_Fin.Date)));
      qry.Sql.Add('WHERE EXP_ID=' + IBQue_ExportEXP_ID.AsString);
      qry.ExecSQL;
      commit;
      while not IBQue_Export.BOF and (IBQue_ExportEXP_ID.AsInteger <> expid) do
         IBQue_Export.Prior;
      while (IBQue_ExportEXP_ID.AsInteger <> expid) do
         IBQue_Export.Next;
   end;
   frm_Export.Release;
end;

procedure TFrm_Exp_SP2000.IBQue_EXPMAGCalcFields(DataSet: TDataSet);
begin
   if IBQue_EXPMAGEXP_TYPE.asinteger = 0 then
      IBQue_EXPMAGTYPEStr.AsString := 'CDE'
   else
      IBQue_EXPMAGTYPEStr.AsString := 'VTE';
end;

procedure TFrm_Exp_SP2000.SpeedButton5Click(Sender: TObject);
begin
   if Application.MessageBox('ATTENTION la suppression est irréversible et complète, Continuer ?', ' ATTENTION', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = MrYES then
   begin
      IBQue_EXPMAG.Delete;
      commit;
   end;
end;

procedure TFrm_Exp_SP2000.IBQue_HistoCalcFields(DataSet: TDataSet);
begin
   if IBQue_HistoEXP_TYPE.asinteger = 0 then
      IBQue_HistoTYPEStr.AsString := 'CDE'
   else
      IBQue_HistoTYPEStr.AsString := 'VTE';
end;

procedure TFrm_Exp_SP2000.BitBtn2Click(Sender: TObject);
begin
   Screen.Cursor := CrHourGlass;
   try
      if TranLect.InTransaction then
         TranLect.rollback;
      TranLect.Active := true;
      QryLect.close;
      QryLect.sql.clear;
      QryLect.sql.Add('select EXP_TYPE, EXP_ID, MAG_ID, EXP_NOM, BAS_PATH, MAG_CODEADH, MAG_VRAIID, EXP_DEBUT, EXP_FIN');
      QryLect.sql.Add('from export, magasins join Bases on (bas_id=mag_basid)');
      QryLect.sql.Add('where exp_valide=1');
      QryLect.sql.Add('  and mag_expor = 1');
      QryLect.sql.Add('  and not exists (');
      QryLect.sql.Add('  select MXP_ID');
      QryLect.sql.Add('    from MagExport');
      QryLect.sql.Add('   where MXP_MAGID = magasins.MAG_ID');
      QryLect.sql.Add('     and MXP_EXPID = export.EXP_ID)');
      QryLect.sql.Add('AND BAS_ID=' + IBQue_BasesBAS_ID.AsString);
      QryLect.Open;
      QryLect.First;
      while not QryLect.Eof do
      begin
         if QryLect.FieldByName('EXP_TYPE').AsInteger = 0 then
         begin
            if Export_CMD(QryLect.FieldByName('EXP_NOM').AsString,
               QryLect.FieldByName('BAS_PATH').AsString,
               QryLect.FieldByName('MAG_CODEADH').AsString,
               QryLect.FieldByName('MAG_VRAIID').AsInteger,
               QryLect.FieldByName('EXP_DEBUT').AsDateTime,
               QryLect.FieldByName('EXP_FIN').AsDateTime) then
            begin
               qry.close;
               qry.SQL.Clear;
               qry.SQL.Add('INSERT INTO MAGEXPORT (MXP_MAGID, MXP_EXPID) VALUES (');
               qry.SQL.Add(QryLect.FieldByName('MAG_ID').AsString + ',' + QryLect.FieldByName('EXP_ID').AsString + ')');
               qry.ExecSQL;
               commit;
            end;
         end
         else
         begin
            if Export_VTE(QryLect.FieldByName('EXP_NOM').AsString,
               QryLect.FieldByName('BAS_PATH').AsString,
               QryLect.FieldByName('MAG_CODEADH').AsString,
               QryLect.FieldByName('MAG_VRAIID').AsInteger,
               QryLect.FieldByName('EXP_DEBUT').AsDateTime,
               QryLect.FieldByName('EXP_FIN').AsDateTime) then
            begin
               qry.close;
               qry.SQL.Clear;
               qry.SQL.Add('INSERT INTO MAGEXPORT (MXP_MAGID, MXP_EXPID) VALUES (');
               qry.SQL.Add(QryLect.FieldByName('MAG_ID').AsString + ',' + QryLect.FieldByName('EXP_ID').AsString + ')');
               qry.ExecSQL;
               commit;
            end;
         end;
         QryLect.Next;
      end;
      QryLect.Close;
   finally
      Screen.Cursor := CrDefault;
      Application.MessageBox('Export terminé', ' Exportation', Mb_Ok);
   end;
end;

function TFrm_Exp_SP2000.Export_VTE(Nom, Base: string; Adh: string; MAGID: Integer; DDeb, DFin: TdateTime): Boolean;
var
   s: string;
   i: integer;
   d: double;
   F: TextFile;
begin
   try
      DataDist.Connected := false;
      DataDist.DatabaseName := Base;
      DataDist.Open;
      TranDist.Active := true;
      QryDist.Sql.Clear;
      QryDist.Sql.Add('Delete from tmpstat where tmp_id=-1');
      QryDist.ExecSQL;
      if TranDist.InTransaction then
         TranDist.Commit;
      TranDist.Active := True;
      QryDist.Sql.Clear;
      QryDist.Sql.Add('Insert into TMPSTAT (TMP_ID, TMP_MAGID, TMP_ARTID)');
      QryDist.Sql.Add('select distinct -1, HST_MAGID, HST_ARTID');
      QryDist.Sql.Add('from agrhistostock');
      QryDist.Sql.Add('where hst_date between ' + quotedStr(FormatDateTime('MM/DD/YYYY', DDeb)) + ' and ' + quotedStr(FormatDateTime('MM/DD/YYYY', DFin)));
      QryDist.Sql.Add('  and HST_MAGID=' + Inttostr(MAGID));
      QryDist.ExecSQL;
      if TranDist.InTransaction then
         TranDist.Commit;
      TranDist.Active := True;
      QryDist.Sql.Clear;
      QryDist.Sql.Add('Select *');
      QryDist.Sql.Add('from PR_SELECTARTANALYSESYNTH (' + quotedStr(FormatDateTime('MM/DD/YYYY', DDeb)) + ', ' + quotedStr(FormatDateTime('MM/DD/YYYY', DFin)) + ', -1)');
      QryDist.Open;
      while not QryDist.eof do
         QryDist.Next;
      QryDist.close;
      if TranDist.InTransaction then
         TranDist.Commit;
      TranDist.Active := True;
      QryDist.Sql.Clear;
      QryDist.Sql.Add('Select L_VTETVA, RAY_NOM, FAM_NOM, SSF_NOM, CTF_NOM, GRE_NOM, ART_NOM, MRK_NOM,');
      QryDist.Sql.Add('ART_REFMRK, L_STKDEBVAL, L_STKDEB, L_STKFIN, L_ACHNBR, L_STKFINVAL, L_ACHVAL,');
      QryDist.Sql.Add('L_CONSONBR, L_CONSOVAL, L_RETNBR, L_RETVAL, L_VTENBR, L_VTECANET, ');
      QryDist.Sql.Add('L_QTVTENORM, L_VTENORM, L_QTVTESOLDE, L_VTESOLDE, L_QTVTEPROMO, L_VTEPROMO,');
      QryDist.Sql.Add('L_QTVTEPROF, L_VTEPROF, L_PXVTEGEN, L_PXVTE, L_VTECAMV, L_PMD, L_PCENTVTE,');
      QryDist.Sql.Add('L_PCENTVTEVAL, L_VTECANET-L_VTECAMV-L_VTETVA, L_STKMOY, L_TXROT, L_ROT, L_ARTID');
      QryDist.Sql.Add('From pr_anasynthetique (' + quotedStr(FormatDateTime('MM/DD/YYYY', DDeb)) + ', ' + quotedStr(FormatDateTime('MM/DD/YYYY', DFin)) + ', -1,1)');
      assignfile(f, ReperExport + ADH + '_VTE_' + Nom + '.csv');
      rewrite(f);
      writeln(f, 'Magasin;Rayon;Famille;S/Famille;Categorie;Genre;Article;Marque;Ref;Mt StkDeb;Stk Deb;' +
         'Stk Fin;Qt Recu;Mt StkFin;Mt Recu;Qt Dem;Mt Dem;Qt Ret;Mt Ret;Qt Vte;CA Net;Vte Norm;Mt Norm;Vte Solde;Mt Solde;Vte Promo;Mt Promo;Vte Prof;Mt Prof;Pvte Gen;Pvte Mag;CAMV;Px MD;% Vte;% Vte Val;Mt Mrge;Stk Moy;Tx Rot;Jr Rot;% Mrge;Cf;Collection');
      QryDist.Open;
      while not QryDist.Eof do
      begin
         S := Adh;
         for i := 1 to QryDist.FieldCount - 2 do   // -2 car ne pas stocker L_ARTID
            if QryDist.Fields[i].DataType = ftString then
               S := S + ';' + QuotedStr(QryDist.Fields[i].AsString)
            else
               S := S + ';' + QryDist.Fields[i].AsString;
      // % Mrge
         d := QryDist.FieldByName('L_VTECANET').AsFloat - QryDist.FieldByName('L_VTETVA').AsFloat;
         if abs(d) > 0.001 then
         begin
            d := (QryDist.FieldByName('L_VTECANET').AsFloat - QryDist.FieldByName('L_VTECAMV').AsFloat - QryDist.FieldByName('L_VTETVA').AsFloat) / d;
            s := s + ';' + format('%.4f', [d]);
         end
         else
            S := S + ';0.0000';
      // Cf
         d := QryDist.FieldByName('L_VTECAMV').AsFloat;
         if abs(d) > 0.001 then
         begin
            d := QryDist.FieldByName('L_VTECANET').AsFloat / d;
            if d > 1000 then d := 0;
            s := s + ';' + format('%.4f', [d]);
         end
         else
            S := S + ';0.0000';
       // La collection
         IBQue_Collection.Close;
         IBQue_Collection.ParamByName('ARTID').asInteger := QryDist.FieldByName('L_ARTID').AsInteger;
         IBQue_Collection.Open;
				 IF IBQue_Collection.IsEmpty then
         	S := S + ';'
         ELSE
         begin
         	IBQue_Collection.First;
          S := S + ';'+ IBQue_CollectionCOL_NOM.asString;
         END;
         IBQue_Collection.Close;
         writeln(f, s);
         QryDist.Next;
      end;
      Closefile(f);
      EnvoieFtp(ReperExport + ADH + '_VTE_' + Nom + '.csv');
      QryDist.close;
      DataDist.Connected := false;
      result := true;
   except
      on E: Exception do
         Application.messagebox(pchar(E.Message+' '+Nom+' '+Base+' '+Adh), 'erreur', mb_ok);
   end;
end;

function TFrm_Exp_SP2000.Export_CMD(Nom, Base: string; Adh: string; MAGID: Integer; DDeb, DFin: TdateTime): Boolean;
var
   s: string;
   i: integer;
   F: TextFile;
begin
   DataDist.Connected := false;
   DataDist.DatabaseName := Base;
   DataDist.Open;
   TranDist.Active := true;
   QryDist.Sql.Clear;
   QryDist.Sql.Add('Select ray_nom Rayon, fam_nom Famille, ssf_nom Sous_Famille, CTF_NOM Secteur, gre_nom Genre, art_nom Article, mrk_nom Marque, art_refmrk Reference,');
   QryDist.Sql.Add('       sum(cdl_qte) QTE, sum(cdl_qte*cdl_pxctlg) PXbrut, sum(cdl_qte*cdl_pxachat) PxNet');
   QryDist.Sql.Add('from combcde');
   QryDist.Sql.Add('     join combcdel join k on (k_id=cdl_id and k_enabled=1)');
   QryDist.Sql.Add('     on (cdl_cdeid=cde_id)');
   QryDist.Sql.Add('  Join ArtArticle');
   QryDist.Sql.Add('       Join nklssfamille');
   QryDist.Sql.Add('         Join nklfamille');
   QryDist.Sql.Add('           Join nklrayon');
   QryDist.Sql.Add('             join nklsecteur');
   QryDist.Sql.Add('             on (sec_id=ray_secid)');
   QryDist.Sql.Add('           on (ray_id=fam_rayid)');
   QryDist.Sql.Add('           Join NKLCATFAMILLE');
   QryDist.Sql.Add('           on (CTF_ID=fam_CTFid)');
   QryDist.Sql.Add('         on (fam_id=ssf_famid)');
   QryDist.Sql.Add('       on (ssf_id=art_ssfid)');
   QryDist.Sql.Add('       Join artgenre');
   QryDist.Sql.Add('       on (gre_id=art_greid)');
   QryDist.Sql.Add('       Join artmarque');
   QryDist.Sql.Add('       on (mrk_id=art_mrkid)');
   QryDist.Sql.Add('  on (art_id = cdl_artid)');
   QryDist.Sql.Add('where cde_date between ' + quotedstr(formatdatetime('MM/DD/YYYY', DDeb)) + ' and ' + quotedstr(formatdatetime('MM/DD/YYYY', DFin)));
   QryDist.Sql.Add('  And cde_magid=' + Inttostr(magid));
   QryDist.Sql.Add('group by ray_nom, fam_nom, ssf_nom, CTF_NOM, gre_nom, art_nom, mrk_nom, art_refmrk');
   QryDist.Open;
   QryDist.First;
   assignfile(f, ReperExport + ADH + '_CDE_' + Nom + '.csv');
   rewrite(f);
   writeln(f, 'Magasin;Rayon;Famille;S/Famille;Categorie;Genre;Article;Marque;Ref;Qt Achat;Px Brut;Px Net');
   while not QryDist.eof do
   begin
      S := Adh;
      for i := 0 to QryDist.FieldCount - 1 do
         if QryDist.Fields[i].DataType = ftString then
            S := S + ';' + QuotedStr(QryDist.Fields[i].AsString)
         else
            S := S + ';' + QryDist.Fields[i].AsString;
      writeln(f, s);
      QryDist.Next;
   end;
   Closefile(f);
   EnvoieFtp(ReperExport + ADH + '_CDE_' + Nom + '.csv');
   QryDist.close;
   DataDist.Connected := false;
   result := true;
end;

procedure TFrm_Exp_SP2000.BitBtn3Click(Sender: TObject);
var
   Tsl: Tstringlist;
begin
   Tsl := Tstringlist.Create;
   try
     tsl.add('Export;Type Str;Type Int;Dossier;Cd Adh;Magasin;Date');
     IBQue_Histo.DisableControls;
     IBQue_Histo.First;
     while not IBQue_Histo.Eof do
     begin
        tsl.add(IBQue_HistoEXP_NOM.AsString + ';' + IBQue_HistoTypestr.AsString + ';' + IBQue_HistoEXP_TYPE.AsString + ';' +
           IBQue_HistoBAS_NOM.AsString + ';' + IBQue_HistoMAG_CODEADH.AsString + ';' + IBQue_HistoMAG_ENSEIGNE.AsString + ';' +
           IBQue_HistoMXP_DATE.AsString);
        IBQue_Histo.Next;
     end;
     tsl.SaveToFile(ReperBase + 'HISTORIQUE.CSV');
     IBQue_Histo.EnableControls;
     Application.MessageBox('Exportation faite', 'Msg', Mb_Ok);
   finally
     FreeAndNil(Tsl);
   end;
end;

procedure TFrm_Exp_SP2000.DBG_ExportDblClick(Sender: TObject);
begin
   SpeedButton3Click(nil);
end;

procedure TFrm_Exp_SP2000.DoInfoBloq;
begin
  Lab_InfoBloq.Visible := ParamExp2000.BlqEnvoie;
  Lab_InfoBloq2.Visible := ParamExp2000.BlqEnvoie;
  if ParamExp2000.BlqEnvoie then
    Nbt_Bloq.Caption := 'Débloquer'+#13#10+'l''envoi FTP'
  else
    Nbt_Bloq.Caption := 'Bloquer'+#13#10+'l''envoi FTP';
end;

procedure TFrm_Exp_SP2000.BitBtn1Click(Sender: TObject);
begin
   Screen.Cursor := CrHourGlass;
   try
      if TranLect.InTransaction then
         TranLect.rollback;
      TranLect.Active := true;
      QryLect.close;
      QryLect.sql.clear;
      QryLect.sql.Add('select EXP_TYPE, EXP_ID, MAG_ID, EXP_NOM, BAS_PATH, MAG_CODEADH, MAG_VRAIID, EXP_DEBUT, EXP_FIN');
      QryLect.sql.Add('from export, magasins join Bases on (bas_id=mag_basid)');
      QryLect.sql.Add('where exp_valide=1');
      QryLect.sql.Add('  and mag_expor = 1');
      QryLect.sql.Add('  and not exists (');
      QryLect.sql.Add('  select MXP_ID');
      QryLect.sql.Add('    from MagExport');
      QryLect.sql.Add('   where MXP_MAGID = magasins.MAG_ID');
      QryLect.sql.Add('     and MXP_EXPID = export.EXP_ID)');
      QryLect.Open;
      QryLect.First;
      while not QryLect.Eof do
      begin
         if QryLect.FieldByName('EXP_TYPE').AsInteger = 0 then
         begin
            if Export_CMD(QryLect.FieldByName('EXP_NOM').AsString,
               QryLect.FieldByName('BAS_PATH').AsString,
               QryLect.FieldByName('MAG_CODEADH').AsString,
               QryLect.FieldByName('MAG_VRAIID').AsInteger,
               QryLect.FieldByName('EXP_DEBUT').AsDateTime,
               QryLect.FieldByName('EXP_FIN').AsDateTime) then
            begin
               qry.close;
               qry.SQL.Clear;
               qry.SQL.Add('INSERT INTO MAGEXPORT (MXP_MAGID, MXP_EXPID) VALUES (');
               qry.SQL.Add(QryLect.FieldByName('MAG_ID').AsString + ',' + QryLect.FieldByName('EXP_ID').AsString + ')');
               qry.ExecSQL;
               commit;
            end;
         end
         else
         begin
            if Export_VTE(QryLect.FieldByName('EXP_NOM').AsString,
               QryLect.FieldByName('BAS_PATH').AsString,
               QryLect.FieldByName('MAG_CODEADH').AsString,
               QryLect.FieldByName('MAG_VRAIID').AsInteger,
               QryLect.FieldByName('EXP_DEBUT').AsDateTime,
               QryLect.FieldByName('EXP_FIN').AsDateTime) then
            begin
               qry.close;
               qry.SQL.Clear;
               qry.SQL.Add('INSERT INTO MAGEXPORT (MXP_MAGID, MXP_EXPID) VALUES (');
               qry.SQL.Add(QryLect.FieldByName('MAG_ID').AsString + ',' + QryLect.FieldByName('EXP_ID').AsString + ')');
               qry.ExecSQL;
               commit;
            end;
         end;
         QryLect.Next;
      end;
      QryLect.Close;
   finally
      Screen.Cursor := CrDefault;
      Application.MessageBox('Export terminé', ' Exportation', Mb_Ok);
   end;
end;

procedure TFrm_Exp_SP2000.FormCloseQuery(Sender: TObject;
   var CanClose: Boolean);
begin
   if not ftp.vide then
   begin
      canclose := False;
      Application.MessageBox('La liste des envois n''est pas vide, patienter', ' Impossible de fermer', MB_OK);
   end
   else   
      canclose := true;
end;

initialization
   DecimalSeparator := '.';
end.

