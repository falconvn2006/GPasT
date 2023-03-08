unit EasyMvt_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,uDataMod, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, uEasy.Threads, Vcl.Menus, uCheckUpdate,Winapi.ShellAPI, System.Math;

Const CST_MAX_LINES   = 200000;
      CST_MAX_CONSEIL = 100000;
      CST_1_MILLION   = 1000000;
type
  TFrm_EasyMVT = class(TForm)
    Timer1: TTimer;
    sb: TStatusBar;
    dsNodes: TDataSource;
    mdNodes: TFDMemTable;
    DBGrid1: TDBGrid;
    GroupBox3: TGroupBox;
    BMVT: TButton;
    mdNodesNOEUD: TStringField;
    mdNodesGROUPE: TStringField;
    mdNodesHEARTBEAT_TIME: TDateTimeField;
    GroupBox4: TGroupBox;
    lblSens: TLabel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    lbl_KV_KR: TLabel;
    lbl_a: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    teIBFile: TEdit;
    BIBFile: TButton;
    dtDEB: TDateTimePicker;
    BEVAL: TButton;
    dtFIN: TDateTimePicker;
    edtLOCAL_NODE_ID: TEdit;
    seVKFIN: TSpinEdit;
    seVKDEBUT: TSpinEdit;
    teGENERAL_ID: TEdit;
    tePLAGE: TEdit;
    edtCOUNT: TEdit;
    Label8: TLabel;
    ProgressBar: TProgressBar;
    PageControl1: TPageControl;
    tsnodes: TTabSheet;
    tsLogs: TTabSheet;
    mLOG: TMemo;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lbl_tps: TLabel;
    lbl_tpsrestant: TLabel;
    lbl_reallignes: TLabel;
    lbl_avancement: TLabel;
    BStop: TButton;
    Panel_Stats: TPanel;
    MainMenu: TMainMenu;
    Fichier1: TMenuItem;
    N2: TMenuItem;
    Mettrejour: TMenuItem;
    Lbl_Update: TLabel;
    timeDEB: TDateTimePicker;
    Label2: TLabel;
    timeFIN: TDateTimePicker;
    mdNodesSENDER: TStringField;
    mdNodesLAST_K_VERSION: TIntegerField;
    cbNode: TComboBox;
    Label3: TLabel;
    mdNodesK_UPDATED: TDateTimeField;
    TabSheet1: TTabSheet;
    seDEBK: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    seTrancheK: TSpinEdit;
    BCALCULTRANCHE: TButton;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    mKTranche: TFDMemTable;
    dsTRANCHE: TDataSource;
    mKTrancheMIN: TIntegerField;
    mKTrancheMAX: TIntegerField;
    mKTrancheMAX_UPDATED: TDateTimeField;
    mKTrancheID: TIntegerField;
    mKTrancheMAX_INSERTED: TDateTimeField;
    mKTrancheV_DEB: TIntegerField;
    mKTrancheV_FIN: TIntegerField;
    cbUPDATED: TCheckBox;
    tmAutoCloseInX: TTimer;
    Label15: TLabel;
    Label16: TLabel;
    procedure BIBFileClick(Sender: TObject);
    procedure BEVALClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure EasyMvtEval(const ABaseDonnees: TFileName;aDEB,aFIN:TDateTIme);
//     procedure CallBackEval(Sender:TObject);
    procedure CallBackMvt(Sender:TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BMVTClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LockMvt(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure MettrejourClick(Sender: TObject);         // Const s:String;

    procedure CallBackCheckVersion(Sender:Tobject);
    procedure CallBackNewExeInstall(Sender:Tobject);
    procedure cbNodeChange(Sender: TObject);
    procedure BCALCULTRANCHEClick(Sender: TObject);
    procedure tmAutoCloseInXTimer(Sender: TObject);
  private
    { Déclarations privées }
    FCheckUpdateThread : TCheckUpdateThread;
    FExeUpdateTHread   : TExeUpdateThread;
    FLockUpdate    : Boolean;

    FAUTO    : Boolean;
    FSENDER  : string;
    FNODE    : string;
    FGUID    : string;


    FTimeClose  : integer;
    FCANMVT     : boolean;
    FNbRec      : integer;
    FEvalTime   : String;
    FCanClose   : boolean;
    FIBFile     : string;
    FStart      : Cardinal;
    FTpsRest    : integer;

    FQuery      : TFDQuery;
    FCnx        : TFDConnection;
    FDicho      : TQueryDichotomicKVersionThread;
    FEvalThread : TQueryTHread;
    FEvalDeltaThread : TQueryDeltaThread;
    FMvtThread       : TQueryMvtTHread;

    procedure DoLog(aMsg:string);

//    procedure CallBackEvalFast(Sender:TObject);
    procedure CallBackEvalDicho(Sender:TObject);

    procedure ProgressCallBack(Const value:integer);
    Procedure StatusCallBack(Const s:String);
    Procedure TpsRestantCallBack(const value:Integer);
    Procedure LinesDoneCallBack(const value:integer); // Const s:String;
    procedure SetLockUpdate(value:Boolean);
    procedure CloseInXseconds(const aSec:integer=30);

    procedure SetIBFile(Avalue:string);
    procedure DoMvtLame2MAG();
    procedure DoMvtMag2Lame();
    procedure CreateProceduresMvt();
//    procedure EasyMvt_MethodeFastReload(const ABaseDonnees: TFileName;
//         aDEBVERSION,aFINVERSION:integer;
//        aDEB,aFIN:TDateTime);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property LockUpdate : Boolean read FLockUpdate write SetLockUpdate;
  end;

var
  Frm_EasyMVT: TFrm_EasyMVT;

implementation

{$R *.dfm}


Uses  UWMI, UCommun, uEasy.Types, uLog;


procedure TFrm_EasyMVT.CallBackNewExeInstall(Sender:Tobject);
begin
    try
      If (TExeUpdateThread(Sender).ShellUpdate) then
        begin
            // Inc(FNbBoucleUpdates);
            // Save_Ini_BoucleUpdates;
            //------------------ On relance-------------------------------------
            ShellExecute(0,'OPEN', PWideChar(Application.ExeName), nil, nil, SW_SHOW);
            Application.Terminate;
        end

    finally
      LockUpdate:=false;
    end;
end;

procedure TFrm_EasyMVT.cbNodeChange(Sender: TObject);
// var vDeb, vFin: integer;
begin
{
    if (mdNodes.Locate('NOEUD',cbNode.Text,[]))
      then
          begin
            EasyDecodePlage(tePLAGE.Text,vDeb, vFin);

            seVKFIN.Value    := StrToInt(teGENERAL_ID.Text);
            //
            seVKDEBUT.Value  := Max(
                                  Max(
                                  mdNodes.FieldByName('LAST_K_VERSION').AsInteger-50000,
                                  vDeb*1000000),
                                  seVKFIN.Value-1000000
                                  );


            if Abs(Now()-mdNodes.FieldByName('REGISTRATION_TIME').AsDateTime)>365 then
              begin
                dtDEB.DateTime   := Trunc(Now()-2);
                timeDEB.DateTime := Frac(Now()-2);
                dtFIN.DateTime   := Trunc(Now());
                timeFIN.DateTime := Frac(Now());
                exit;
              end;

            if Abs(mdNodes.FieldByName('REGISTRATION_TIME').AsDateTime-mdNodes.FieldByName('K_UPDATED').AsDateTime)>5 then
              begin
                dtDEB.DateTime   := Trunc(Now()-2);
                timeDEB.DateTime := Frac(Now()-2);
                dtFIN.DateTime   := Trunc(Now());
                timeFIN.DateTime := Frac(Now());
              end
            else
              begin
                dtDEB.DateTime   := Trunc(mdNodes.FieldByName('K_UPDATED').AsDateTime-4/24);
                timeDEB.DateTime := Frac(mdNodes.FieldByName('K_UPDATED').AsDateTime-4/24);

                dtFIN.DateTime   := Trunc(mdNodes.FieldByName('REGISTRATION_TIME').AsDateTime+4/24);
                timeFIN.DateTime := Frac(mdNodes.FieldByName('REGISTRATION_TIME').AsDateTime+4/24);


              end;

          end;
    }
end;

procedure TFrm_EasyMVT.SetLockUpdate(value:Boolean);
begin
    FLockUpdate  := Value;
    Self.Enabled := not(Value);
end;

procedure TFrm_EasyMVT.CallBackCheckVersion(Sender:Tobject);
var vUrl:string;
begin
    try
       If (CompareVersion(TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion)<0)
        then
           begin
            If MessageDlg(PChar(Format('Nouvelle version disponible :  Voulez-vous faire la mise à jour ? '+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
                   mtConfirmation, [mbYes, mbNo], 0) = mrYes then
                begin
                   vUrl := TCheckUpdateThread(Sender).RemoteFile;
                   FExeUpdateThread := TExeUpdateThread.Create(Application.ExeName,vUrl,Lbl_Update,CallBackNewExeInstall);
                   FExeUpdateThread.Resume;
                   LockUpdate:=true;
                end
                else LockUpdate:=false;
           end
        else
          begin
            MessageDlg(PChar(Format('Le programme %s est à jour.'+#13+#10+#13+#10+
                                    'Votre version : %s '  +#13+#10+
                                    'Version disponible : %s '  +#13+#10
                              , [ExtractFileName(Application.ExeName),TCheckUpdateThread(Sender).LocalVersion,TCheckUpdateThread(Sender).RemoteVersion ])),
             mtInformation, [mbOK], 0);
            LockUpdate:=false;
          end;
    finally
      // LockUpdate:=false; non pas là l'autre thread peut-etre lancer...
    end;
end;



Procedure TFrm_EasyMVT.LinesDoneCallBack(const value:integer); // Const s:String;
begin
   lbl_reallignes.Caption  := IntToStr(value);
end;

procedure TFrm_EasyMVT.MettrejourClick(Sender: TObject);
begin
   FCheckUpdateThread := TCheckUpdateThread.Create(Application.ExeName,Lbl_Update,CallBackCheckVersion);
   FCheckUpdateThread.Resume;
   LockUpdate:=true;
end;

Procedure TFrm_EasyMVT.TpsRestantCallBack(const value:integer); // Const s:String;
begin
   FTpsRest                := value;
   lbl_tpsrestant.Caption  := SecondToTime(FTpsRest);
end;

Procedure TFrm_EasyMVT.StatusCallBack(Const s:String);
begin
  sb.Panels[1].Text      := s;
  lbl_avancement.Caption := s;
end;


Procedure TFrm_EasyMVT.ProgressCallBack(Const value:integer);
begin
    ProgressBar.Visible  := true;
    ProgressBar.Position := value;
end;


procedure TFrm_EasyMVT.BMVTClick(Sender: TObject);
begin
    BMVT.Enabled:=false;
    //cbNode.Enabled:=false;

    FCanClose  := False;

    cbNode.Enabled:=false;
    {
    seVKDEBUT.Enabled:=false;
    seVKFIN.Enabled:=false;
    }

    dtDEB.Enabled:=false;
    timeDEB.Enabled := False;
    dtFIN.Enabled:=false;
    timeFIN.Enabled := False;
    BIBFile.Enabled:=False;
    BEVAL.Enabled:=False;
    Mettrejour.Enabled := False;


    BCALCULTRANCHE.Enabled:=false;

    if (lblSens.Caption=LBL_LAME2MAG)
      then DoMvtLame2MAG();

    if (lblSens.Caption=LBL_MAG2LAME)
      then DoMvtMAG2LAME();
end;

procedure TFrm_EasyMVT.BStopClick(Sender: TObject);
begin
  If Assigned(FMvtThread)
     and
        (MessageBoxW(Handle, 'Voulez-vous arrêter le traitement en cours ?', 'Confirmation',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDYES )
    then
    begin
        FMvtThread.Terminate;
        DoLog('Demande d''arrêt du traitement en cours...');
    end;

end;

procedure TFrm_EasyMVT.BCALCULTRANCHEClick(Sender: TObject);
var I: Integer;
begin
  mKTranche.Close;
  mKTranche.Open;
  FCnx   := DataMod.getNewConnexion('SYSDBA@'+teIBFile.Text);
  FQuery := DataMod.getNewQuery(FCnx,nil);
  try
  for I := 0 to 20 do
    begin
        mKTranche.Append();
        mKTranche.FieldByName('ID').AsInteger := i+1;
        mKTranche.FieldByName('V_DEB').AsInteger := (seDEBK.Value div seTrancheK.Value) * seTrancheK.Value + seTrancheK.Value * (i);
        mKTranche.FieldByName('V_FIN').AsInteger := mKTranche.FieldByName('V_DEB').AsInteger + seTrancheK.Value;
        // faudrait faire un thread

        FQuery.SQL.Clear();
        FQuery.SQL.Add('SELECT MIN(K_VERSION), MAX(K_VERSION), MAX(K_UPDATED) AS MAX_KUPDATED, ');
        FQuery.SQL.Add(' MAX(K_INSERTED) FROM K WHERE K_VERSION>=:DEB AND K_VERSION<:FIN       ');
        FQuery.ParamByName('DEB').AsInteger := mKTranche.FieldByName('V_DEB').AsInteger;
        FQuery.ParamByName('FIN').AsInteger := mKTranche.FieldByName('V_FIN').AsInteger;
        FQuery.Open();
        if not(FQuery.IsEmpty) then
            begin
              mKTranche.FieldByName('MIN').Asinteger := FQuery.Fields[0].asinteger;
              mKTranche.FieldByName('MAX').Asinteger := FQuery.Fields[1].asinteger;

              mKTranche.FieldByName('MAX_UPDATED').AsDateTime  :=  FQuery.Fields[2].asDateTime;
              mKTranche.FieldByName('MAX_INSERTED').AsDateTime :=  FQuery.Fields[3].asDateTime;
            end;
        FQuery.Close;
        mKTranche.Post();
       //
    end;
  finally
    FQuery.DisposeOf;
    FCnx.DisposeOf;
  end;
end;

procedure TFrm_EasyMVT.CreateProceduresMvt();
var vSQL:TStringList;
    vResSQL : TResourceStream;
    vFileSQL : TFileName;
begin
  vSQL := TStringList.Create();
  try
    vFileSQL := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'easy_mvt.sql';
    try
      vResSQL := TResourceStream.Create(HInstance, 'easy_mvt', RT_RCDATA);
      try
        vResSQL.SaveToFile(vFileSQL);
      finally
        vResSQL.Free();
      end;
    except
       on e: Exception do
       begin
         Exit;
       end;
    end;
    if FileExists(vFileSQL) then
      begin
        vSQL.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+ 'easy_mvt.sql');
        DataMod.ExecuteScript(teIBFile.Text,vSQL);
      end;
  finally
    vSQL.DisposeOf;
  end;
end;


procedure TFrm_EasyMVT.DoMvtMag2Lame();
var i:Integer;
begin
      {

  try
    if (cbNode.Text='')
      then
        begin
            MessageDlg('Veuillez choisir un noeud.',  mtError, [mbOK], 0);
            FCanClose:=true;
            BMVT.Enabled:=true;
            cbNode.Enabled:=true;
            dtDEB.Enabled:=true;
            timeDEB.Enabled := True;
            dtFIN.Enabled:=true;
            timeFIN.Enabled := True;
            BIBFile.Enabled:=true;
            BEVAL.Enabled:=true;
            cbNode.SetFocus;
            exit;
        end;

    if Application.MessageBox(PChar(Format('Vous êtes sur le point d''envoyer ' +#13#10+
      '%s enregsitrements au noeud %s.' + #13#10 +
      'Voulez-vous continuer ?', [  edtCOUNT.text, cbNode.Text])), 'Avertissement', MB_OKCANCEL +
      MB_ICONWARNING + MB_DEFBUTTON2 + MB_TOPMOST) = IDCANCEL then
      begin
        FCanClose:=true;
        BMVT.Enabled:=true;
        cbNode.Enabled:=true;
        dtDEB.Enabled:=true;
        timeDEB.Enabled := True;
        dtFIN.Enabled:=true;
        timeFIN.Enabled := True;
        BIBFile.Enabled:=true;
        BEVAL.Enabled:=true;
        exit;
      end;



    CreateProceduresMvt();
    FCnx   := DataMod.getNewConnexion('SYSDBA@'+teIBFile.Text);
    try
      // il faut faire par bloc.... pas par
      sb.Panels[2].Text := 'Traitement en cours....';
      sb.Panels[1].Text :=  edtCOUNT.Text;
      sb.Panels[0].Text := '00:00';
      lbl_tps.Caption   := '00:00';
      FStart := GetTickCount;

      ProgressBar.Visible:=true;
      BStop.Visible:=true;
      BStop.Enabled:=true;
      Panel_Stats.Visible:=true;
      DoLog(Format('%s => %s , %s [WHERE K_VERSION>=%d AND K_VERSION<=%d AND K_UPDATED>=%s AND K_UPDATED<=%s] ',
          [ lblsens.caption,cbNode.Text,edtCount.Text,
            seVKDEBUT.Value,seVKFIN.value,
            seVKDEBUT.Value,seVKFIN.value,
            ]));

      Timer1.Enabled:=true;
      Application.ProcessMessages;

      ProgressBar.Position:=0;
      ProgressBar.Max := StrToInt(edtCOUNT.text);

      FMvtThread := TQueryMVTThread.Create(Fcnx,
          CST_MAG2LAME,
          cbNode.Text,StrToInt(teGENERAL_ID.Text),
          seVKDEBUT.Value,seVKFIN.value,
          ProgressCallBack,
          StatusCallBack,       // Avancement
          TpsRestantCallBack,   // Temps Restant
          LinesDoneCallBack,    // lignes traitées
          CallBackMvt);
      FMvtThread.Start;
    finally

    end;
  finally

  end;
  }
end;



procedure TFrm_EasyMVT.DoMvtLame2MAG();
var i:Integer;
    vDateDeb:TDateTime;
    vDateFin:TDateTime;
    vUP : string;
begin
  try
    if (cbNode.Text='')
      then
        begin
            MessageDlg('Veuillez choisir un noeud.',  mtError, [mbOK], 0);
            FCanClose:=true;
            BMVT.Enabled:=true;
            cbNode.Enabled:=true;
            dtDEB.Enabled:=true;
            timeDEB.Enabled := True;
            dtFIN.Enabled:=true;
            timeFIN.Enabled := True;
            BIBFile.Enabled:=true;
            BEVAL.Enabled:=true;
            Mettrejour.Enabled := true;
            cbNode.SetFocus;
            exit;
        end;

    // pas d'avertissement en mode "AUTO"
    if Not(FAUTO) then
      begin
          if Application.MessageBox(PChar(Format('Vous êtes sur le point d''envoyer ' +#13#10+
            '%s enregsitrements au noeud %s.' + #13#10 +
            'Voulez-vous continuer ?', [  edtCOUNT.text, cbNode.Text])), 'Avertissement', MB_OKCANCEL +
            MB_ICONWARNING + MB_DEFBUTTON2 + MB_TOPMOST) = IDCANCEL then
            begin
              FCanClose:=true;
              BMVT.Enabled:=true;
              cbNode.Enabled:=true;
              dtDEB.Enabled:=true;
              timeDEB.Enabled := True;
              dtFIN.Enabled:=true;
              timeFIN.Enabled := True;
              BIBFile.Enabled:=true;
              BEVAL.Enabled:=true;
              Mettrejour.Enabled := true;
              exit;
            end;
      end;



    CreateProceduresMvt();
    FCnx   := DataMod.getNewConnexion('SYSDBA@'+teIBFile.Text);
    FQuery := DataMod.getNewQuery(FCnx,nil);
    try
      // il faut faire par bloc.... pas par
      sb.Panels[0].Text := '00:00';
      lbl_tps.Caption   := '00:00';
      sb.Panels[2].Text := 'Traitement en cours....';
      sb.Panels[1].Text := '<'+edtCOUNT.Text;
      FStart := GetTickCount;

      ProgressBar.Visible:=true;
      BStop.Visible:=true;
      BStop.Enabled:=true;
      Panel_Stats.Visible:=true;

      vDateDeb := Trunc(dtDEB.Date) + Frac(timeDEB.Time) - 1/SecsPerDay;
      vDateFin := Trunc(dtFIN.Date) + Frac(timeFIN.Time) + 1/SecsPerDay;

      vUP := '';
      if (cbUPDATED.Checked)
        then
          begin
            vUP := Format(' AND K_UPDATED>=%s AND K_UPDATED<=%s',[
                 FormatDateTime('yyy-mm-dd hh:nn:ss',vDateDeb),
                 FormatDateTime('yyy-mm-dd hh:nn:ss',vDateFin)]);
          end;

      DoLog(Format('%s => %s , %s : [WHERE K_VERSION>=%d AND K_VERSION<=%d%s]',
          [lblsens.caption,cbNode.Text,edtCount.Text,
          seVKDEBUT.Value,seVKFIN.value,vUp]));

      Timer1.Enabled:=true;
      Application.ProcessMessages;

      ProgressBar.Position:=0;
      ProgressBar.Max := StrToInt(edtCOUNT.text);


      FMvtThread := TQueryMVTThread.Create(Fcnx,
          CST_LAME2MAG,
          cbNode.Text,
          StrToInt(teGENERAL_ID.Text),
          seVKDEBUT.Value,seVKFIN.value,
          vDateDeb,vDateFin,
          StrToInt(edtCOUNT.Text),
          cbUPDATED.Checked,
          ProgressCallBack,
          StatusCallBack,
          TpsRestantCallBack,
          LinesDoneCallBack,
          CallBackMvt);
      FMvtThread.Start;

    finally

    end;
  finally

  end;

end;

procedure TFrm_EasyMVT.LockMvt(Sender: TObject);
begin
   BMVT.Enabled       := False;
//   cbNode.Enabled := false;
end;

procedure TFrm_EasyMVT.BIBFileClick(Sender: TObject);
var vOpenDialog : TOpenDialog;
begin
    vOpenDialog := TOpenDialog.Create(Self);
    try
      if vOpenDialog.Execute()
        then
            begin
              teIBFile.Text := vOpenDialog.FileName;
              SetIBFile(teIBFile.Text);
            end;
    finally
      vOpenDialog.Free;
    end;
end;

procedure TFrm_EasyMVT.BEVALClick(Sender: TObject);
begin
    FCanClose := false;
    BMVT.Enabled := False;
    cbNode.Enabled  := False;

    BIBFile.Enabled := False;
    BEVAL.Enabled := False;
    Mettrejour.Enabled := False;

    dtDEB.Enabled := False;
    timeDEB.Enabled := False;
    dtFIN.Enabled := False;
    timeFIN.Enabled := False;

    {
    seVKDEBUT.Enabled:=False;
    seVKFIN.Enabled:=False;
    }
    cbUPDATED.Enabled:=False;

    seDEBK.Enabled:=false;
    seTrancheK.Enabled:=False;
    BCALCULTRANCHE.Enabled:=False;

    Panel_Stats.Visible:=false;
    BStop.Enabled:=false;
    BStop.Visible:=false;


    //    EasyMvtEval(teIBFile.Text,Trunc(dtDEB.Date),Trunc((dtFIN.Date)+1));
    {
    EasyMvt_MethodeFastReload(teIBFile.Text,
        seVKDEBUT.Value,seVKFIN.Value,
        Trunc(dtDEB.Date)+Frac(TimeDeb.Time),
        Trunc(dtFIN.Date)+Frac(TimeFin.Time));
    }


    FCnx   := DataMod.getNewConnexion('SYSDBA@'+teIBFile.Text);
    FDicho := TQueryDichotomicKVersionThread.Create(FCnx, tePLAGE.Text,StrToint(teGENERAL_ID.Text),
        cbUPDATED.Checked,
        Trunc(dtDEB.Date)+Frac(TimeDeb.Time),
        Trunc(dtFIN.Date)+Frac(TimeFin.Time),
        CallBackEvalDicho);
    FDicho.Start;


end;

procedure TFrm_EasyMVT.CallBackEvalDicho(Sender:TObject);
begin
   Timer1.Enabled:=false;
   seVKDEBUT.Value := FDicho.MinK.K_VERSION;
   seVKFIN.Value   := FDicho.MaxK.K_VERSION;
   Label15.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss',FDicho.MinK.DATETIME);
   Label16.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss',FDicho.MaxK.DATETIME);

   edtCount.Text   := IntToStr(FDicho.COUNT);
   sb.Panels[2].Text := Format('Evaluation terminée : %s enregistrements',[edtCOUNT.Text]);

   if (seVKDEBUT.Value=0) or (seVKFIN.Value=0) then
      begin
        DoLog('La recherche Dichotomique est très rapide, mais etant donné que nous recherchons'+#13+#10+
              ' sur un ensemble discontinu, il y a des trous et des dates qui sont fausses dans nos K.'+#13+#10+
              ' Je vous conseille de faire bouger légérement la date/heure de début ou/et fin pour trouver les bons K_VERSION.');
        BMVT.Enabled := false;
      end
   else
      begin
         if (FDicho.COUNT<CST_MAX_CONSEIL) then
           begin
              BMVT.Enabled := true;
           end
         else
            begin
               if (FDicho.COUNT<CST_MAX_LINES) then
                  begin
                     BMVT.Enabled   := true;
                     DoLog('Attention : beaucoup d''enregistrements (maximum conseillé 100 k).');
                  end
                else
                  begin
                     DoLog('Attention : beaucoup d''enregistrements (maximum 250 k).');
                  end

            end;
      end;


{
   seVKDEBUT.ReadOnly:=false;
   seVKDEBUT.Color := clWindow;
   seVKFIN.ReadOnly:=false;
   seVKFIN.Color := clWindow;
}

   FCanClose:=true;
   cbNode.Enabled := true;
   cbUPDATED.Enabled := true;
   BEVAL.Enabled := true;
   Mettrejour.Enabled := true;
   dtDEB.Enabled := True;
   timeDEB.Enabled := True;
   dtFIN.Enabled := True;
   timeFIN.Enabled := True;
   BIBFile.Enabled := True;

   seDEBK.Enabled:=true;
   seTrancheK.Enabled:=true;
   BCALCULTRANCHE.Enabled:=true;


   FCnx.DisposeOf;
end;


{
procedure TFrm_EasyMVT.CallBackEvalFast(Sender:TObject);
begin
   Timer1.Enabled:=false;
   seVKDEBUT.Value := FEvalDeltaThread.MinKVERSION;
   seVKFIN.Value   := FEvalDeltaThread.MaxKVERSION;
   edtCount.Text   := IntToStr(FEvalDeltaThread.COUNT);

   sb.Panels[2].Text := Format('Evaluation terminée : %s enregistrements',[edtCOUNT.Text]);

   if (FEvalDeltaThread.COUNT)<50000 then
     begin
        BMVT.Enabled   := true;
     end
   else
     begin
        DoLog('Blocage car trop d''enregistrements (maximum 50k).');
     end;

   FCanClose:=true;
   BEVAL.Enabled := true;
   dtDEB.Enabled := True;
   timeDEB.Enabled := True;
   dtFIN.Enabled := True;
   timeFIN.Enabled := True;
   BIBFile.Enabled := True;
   // FEvalThread := nil;
   Fquery.DisposeOf;
   FCnx.DisposeOf;
end;

}

{
procedure TFrm_EasyMVT.EasyMvt_MethodeFastReload(const ABaseDonnees: TFileName;
        aDEBVERSION,aFINVERSION:integer;
        aDEB,aFIN:TDateTime);
var vGENID: Integer;
    vBAS_IDENT : integer;
    vBAS_PLAGE : string;
    vDeb,vFin:integer;
begin
  FCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
  FQuery := DataMod.getNewQuery(FCnx,nil);
  try
    FQuery.SQL.Clear();
    FQuery.SQL.Add('SELECT * FROM GENPARAMBASE WHERE PAR_NOM=:NOM');
    FQuery.ParamByName('NOM').asstring := 'IDGENERATEUR';
    FQuery.Open();
    if not(FQuery.IsEmpty) then
      begin
        vBAS_IDENT:=FQuery.FieldByName('PAR_STRING').asinteger;
      end;
    FQuery.Close;

    FQuery.Close;
    FQuery.SQL.Clear();
    FQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
    FQuery.Open();
    If (FQuery.RecordCount=1) then
       begin
          vGENID := FQuery.Fields[0].AsInteger;
       end;

    //----------------------------------------------------------------------
    FQuery.Close;
    FQuery.SQL.Clear();
    FQuery.SQL.Add('SELECT BAS_GUID, BAS_SENDER, BAS_PLAGE ');
    FQuery.SQL.Add(' FROM   GENBASES       ');
    FQuery.SQL.Add('  JOIN K ON (K_ID = BAS_ID AND K_ENABLED = 1)');
    FQuery.SQL.Add('  WHERE BAS_IDENT=:BASIDENT ');
    FQuery.ParamByName('BASIDENT').AsString:=IntToStr(vBAS_IDENT);
    FQuery.Open();
    if not(FQuery.IsEmpty) then
      begin
        vBAS_PLAGE  := FQuery.Fields[2].AsString;
      end;

    EasyDecodePlage(vBAS_PLAGE,vDeb, vFin);


    sb.Panels[2].Text := 'Evaluation en cours....';
    sb.Panels[0].Text := '00:00';
    lbl_tps.Caption   := '00:00';
    FStart := GetTickCount;
    Timer1.Enabled:=true;
    Application.ProcessMessages;
    if (lblSens.Caption=LBL_LAME2MAG)
      then
        begin
            FQuery.Close();
            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT MIN(K_VERSION), MAX(K_VERSION), COUNT(*) FROM K WHERE K_VERSION>=:DEBVERSION ');
            // AND K_VERSION<=:FINVERSION
            FQuery.SQL.Add(' AND K_VERSION<=:NIVEAU ');
            FQuery.SQL.Add(' AND K_UPDATED>=:DEB ');
            FQuery.SQL.Add(' AND K_UPDATED<=:FIN ');
            FQuery.ParamByName('DEBVERSION').Asinteger  := aDEBVERSION;
            // FQuery.ParamByName('FINVERSION').Asinteger  := aFINVERSION;
            FQuery.ParamByName('DEB').AsDateTime        := aDeb;
            FQuery.ParamByName('FIN').AsDateTime        := aFin;
            //
            FQuery.ParamByName('NIVEAU').Asinteger      := vGENID;
            // DoLog(Format('Evaluation ',[aLAST_K_VERSION,FormatDatetime('dd/mm/yyyy hh:nn:ss',aFin)]));

            FEvalDeltaThread := TQueryDeltaThread.Create(Fcnx,Fquery,vGENID,CallBackEvalFast);
            FEvalDeltaThread.Start;

        end;


    if (lblSens.Caption=LBL_LAME2MAG)
      then
        begin
      end;
  finally

  end;
end;
}

{
procedure TFrm_EasyMVT.EasyMvtEval(const ABaseDonnees: TFileName;aDEB,aFIN:TDateTIme);
begin
  FCnx   := DataMod.getNewConnexion('SYSDBA@'+ABaseDonnees);
  FQuery := DataMod.getNewQuery(FCnx,nil);
  try
    FQuery.Close();
    FQuery.SQL.Clear;
    FQuery.SQL.Add('SELECT Count(*) AS QTE FROM K WHERE K_UPDATED>=:DEB AND K_UPDATED<=:FIN');
    FQuery.ParamByName('DEB').AsDateTime:= aDeb;
    FQuery.ParamByName('FIN').AsDateTime:= aFin;
    lbl_tps.Caption   := '00:00';
    sb.Panels[0].Text := '00:00';
    sb.Panels[1].Text := '';
    sb.Panels[2].Text := 'Evaluation en cours....';
    FStart := GetTickCount;

    Timer1.Enabled:=true;
    Application.ProcessMessages;

    FEvalThread := TQueryTHread.Create(Fcnx,Fquery,CallBackEval);
    FEvalThread.Start;

  finally

  end;
end;
}

procedure TFrm_EasyMVT.DoLog(aMsg:string);
begin
   mLOG.Lines.Add(FormatDateTime('yyyy-dd-mm hh:nn:ss : ',Now()) + aMsg);
end;


procedure TFrm_EasyMVT.CloseInXseconds(const aSec:integer=30);
begin
   FTimeClose := aSec;
   tmAutoCloseInX.Enabled := true;
end;


procedure TFrm_EasyMVT.CallBackMvt(Sender:TObject);
begin
  Timer1.Enabled:=false;
  sb.Panels[1].Text := Format('%s Lignes',[edtCount.Text]);


  if (FMvtThread.Stopped) then
  begin
    sb.Panels[2].Text := 'Traitement arrêté (bouton stop)';
    // si on est en mode auto, on log au monitoring
    Log.Log('Main', 'MajGenParam', 'Traitement de mouvement automatique en erreur', logError);
  end
  else
  begin
    sb.Panels[2].Text := 'Traitement terminé avec succès vers le noeud '+ cbNode.Text;

    if (FAUTO) and (FGUID <> '')  then
    begin
      Log.Log('Main', 'MajGenParam', 'Traitement de mouvement automatique ok ', logInfo);
      Log.Log('Main', 'MajGenParam', 'Guid :  ' + FGUID + ' ibfile : ' + FIBFile, logInfo);
      // si on est en mode auto, on log au monitoring et on met à jour le GENPARAM
      if DataMod.UpdateGenParamDelos2EasyByGUID(FIBFile, FGUID , 3000) then
        Log.Log('Main', 'MajGenParam', 'Mise à jour du GENPARAM avec la valeur 3000 réussie', logInfo)
      else
        Log.Log('Main', 'MajGenParam', 'Impossible de mettre à jour le GENPARAM avec la valeur 3000', logWarning)
    end;

  end;


  doLog(sb.Panels[2].Text);

  ProgressBar.Position := ProgressBar.Max;

  FMvtThread := nil;
   // On vient d'envoyer on peut réactiver si on veux lancer sur un autre noeud..
   // cbNode.ItemIndex:=-1; // on nettoye

  BMVT.Enabled:=true;
  cbNode.Enabled:=true;

  BStop.Enabled  := false;
  BStop.Visible  := False;

   {
   seVKDEBUT.Enabled:=true;
   seVKFIN.Enabled:=true;
   }

  dtDEB.Enabled   := true;
  timeDEB.Enabled := true;
  dtFIN.Enabled:=true;
  timeFIN.Enabled := true;

  BEVAL.Enabled:=true;
  Mettrejour.Enabled := true;
  BIBFile.Enabled:=true;
  FCanClose:=true;

  Fquery.DisposeOf;
  FCnx.DisposeOf;

  ProgressBar.Visible:=false;

  if FAuto
    then
      begin
         CloseInXseconds(30);
         // tmAutoCloseInX.Enabled:=true;
      end;
end;


(*
procedure TFrm_EasyMVT.CallBackEval(Sender:TObject);
var vVitesse_Moyenne : integer;
    vNbSecondes : integer;
begin
   Timer1.Enabled:=false;
   vVitesse_Moyenne := 65;
   FNbRec := FEvalThread.Resultat*2;
   vNbSecondes := FNbRec div vVitesse_Moyenne;
   FEvalTime := SecondToTime(vNbSecondes);
   sb.Panels[2].Text := Format('%d Enregistrements "K" à repousser donc %d au total. A la vitesse moyenne de %d lignes/s, cela va prendre %s.'
      ,[FEvalThread.Resultat,FNbRec,
      vVitesse_Moyenne, FEvalTime ]);

   if (FEvalThread.Resultat>0) and (FEvalThread.Resultat<50000)then
     begin
        BMVT.Enabled:=true;  // c'est verrouillé sur cette évalutation
        cbNode.Enabled:=true;
     end;

   FCanClose:=true;
   BEVAL.Enabled := true;
   dtDEB.Enabled := True;
   timeDEB.Enabled := true;
   dtFIN.Enabled := True;
   timeFIN.Enabled := true;
   BIBFile.Enabled := True;
   FEvalThread := nil;
   Fquery.DisposeOf;
   FCnx.DisposeOf;
end;
*)


procedure TFrm_EasyMVT.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not(FCanClose) then
    begin
        MessageDlg('Traitement en cours !' + #13#10 +
          'Impossible de fermer le programme.',  mtError, [mbOK], 0);
    end;
  CanClose := FCanClose;
end;

procedure TFrm_EasyMVT.FormCreate(Sender: TObject);
var i:integer;
    param,value:string;
    vDeb,vFin:integer;
    v: string;
begin
    LockUpdate := false;
    FCanClose  := true;
    FCANMVT    := false;
    dtDEB.Date := Now()-5;
    timeDEB.Time := 0;
    dtFin.Date := Now();
    timeFIN.Time := 0.9999999;
    Timer1.Enabled := false;
    Caption := Caption + ' - ' + FileVersion(ParamStr(0));
    FAUTO   := false;
    FSENDER := '';
    FNODE   := '';
    FGUID   := '';

    for i :=1 to ParamCount do
     begin
         if lowercase(ParamStr(i))='auto' then FAUTO:=true;
         param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
         value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
         If lowercase(param)='ib'
            then teIBFile.Text := value;

         if LowerCase(param) = 'guid' then
          FGUID := value;

         If lowercase(param)='sender'
           then FSENDER := value;

         If lowercase(param)='node'
           then FNODE := value;

         if LowerCase(param)='start'
           then seVKDEBUT.Value := StrToIntDef(value,0);

         if LowerCase(param)='stop'
           then seVKFIN.Value := StrToIntDef(value,seVKFIN.Value);

     end;

    Log.App   := 'EasyMVT';
    Log.Inst  := '' ;
    Log.Ref := FGUID;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue] ;
    Log.SendOnClose := true ;
    Log.Open ;
    Log.SendLogLevel := logTrace;
    Log.Log('EasyMVT', '', '', 'Action', 'Lancement', logInfo, True, 0, ltServer);
    //-------------------------
    if FAUTO then
      begin
          // log de tous les paramètres
          if FileExists(teIBFile.Text)
            then SetIBFile(teIBFile.Text);

          if teGENERAL_ID.Text<>'' then
             begin
               seVKFIN.Value := StrToIntDef(teGENERAL_ID.Text,0);
             end;

          if FSENDER<>'' then
            begin
              DoLog('sender : '+ FSENDER);
              DoLog('sender_to_node : '+ Sender_To_Node(FSENDER));
              cbNode.ItemIndex := cbNode.Items.IndexOf(Sender_To_Node(FSENDER));
            end;

          // On essaye de se positionne sur le "noeud"
          if FNode<>'' then
            begin
              DoLog('node : '+ Fnode);
              cbNode.ItemIndex := cbNode.Items.IndexOf(FNode);
            end;

          EasyDecodePlage(tePLAGE.text,vDeb, vFin);
          edtCount.Text   := IntToStr(seVKFIN.Value-seVKDEBUT.Value+1);

          if (seVKFIN.Value>0) and (cbNode.ItemIndex>=0)  and (seVKDEBUT.Value>0)
            and (vDeb*CST_1_MILLION<seVKDEBUT.Value) and (seVKFIN.Value<vFin*CST_1_MILLION)
            and (StrToInt(edtCount.Text)<=CST_MAX_CONSEIL)
            then
              begin
                BMVT.Visible := true;
                BMVT.Enabled := true;
              end
          else
          begin
            // Suivant les cas il faut retourner les erreurs au monitoring
            if (cbNode.ItemIndex=-1) then
              begin
                 DoLog('Noeud introuvable : '+ Trim(FSender + ' ' + Fnode));
                 Log.Log('EasyMVT', '', '', 'noeud introuvable', Trim(FSender + ' ' + Fnode), logError, True, 0, ltServer);
              end;

            if not((vDeb*CST_1_MILLION<seVKDEBUT.Value) and (seVKFIN.Value<vFin*CST_1_MILLION))
              then
                begin
                   DoLog('Hors plage : '+ Format('%d / %d',[seVKDEBUT.Value,seVKFIN.Value]));
                   Log.Log('EasyMVT', '', '', 'Hors plage',Format('%d / %d',[seVKDEBUT.Value,seVKFIN.Value]), logError, True, 0, ltServer);
                end;
            if (StrToIntDef(edtCount.Text,CST_1_MILLION)>CST_MAX_CONSEIL)
              then
                begin
                   DoLog('Trop de lignes : '+Format('%s (maxi %d)',[edtCount.Text,CST_MAX_CONSEIL]) );
                   Log.Log('EasyMVT', '', '', 'Trop de lignes',Format('%s',[edtCount.Text]), logError, True, 0, ltServer);
                end;
             // en cas d'erreur on va sur l'onglet log
             PageControl1.TabIndex := 2;
          end;

          if BMVT.Visible and BMVT.Enabled  then
          begin
            BMVT.Click();
          end
          else
          begin
            // si un paramètre n'est pas bon, on ferme quand même le programme
            CloseInXseconds(30);
          end;
      end;


end;

procedure TFrm_EasyMVT.SetIBFile(Avalue:string);
var i,j:integer;
    vNode : TNode;
    vNodes : TNodes;
    vLasts : TLastRepicDelos;

begin
     FIBFile:=AValue;
     teIBFile.text:=AValue;
     try
       try
         lblSens.Caption := '';
         vNode := DataMod.EasyMvtLocalNode(aValue);
         vNodes := DataMod.EasyMvtListeRemoteNodes(aValue);
         vLasts := DataMod.EasyLastReplicDELOS(aValue);

         edtLOCAL_NODE_ID.Text := vNode.NODE_ID + ' / '+  vNode.NODE_GROUP_ID;

         if vNode.NODE_GROUP_ID='lame'
          then
            begin
             lblSens.Caption := LBL_LAME2MAG;
             lbl_KV_KR.Caption := 'K_VERSION de :';
             lbl_KV_KR.Visible := true;
             seVKDEBUT.Visible := true;
             seVKFIN.Visible := true;
             Lbl_a.Visible := true;
             Label8.Visible := true;
             edtCOUNT.Visible := true;
           end;

         if vNode.NODE_GROUP_ID='mags'
          then
            begin
             lblSens.Caption := LBL_MAG2LAME;
             lbl_KV_KR.Caption := 'K_VERSION de :';
             lbl_KV_KR.Visible := true;
             seVKDEBUT.Visible := true;
             seVKFIN.Visible := true;
             Lbl_a.Visible := true;
             Label8.Visible := true;
             edtCOUNT.Visible := true;
           end;

         cbNode.Items.Clear;
         mdNodes.Close();
         mdNodes.Open();
         for i:=Low(vNodes) to High(vNodes) do
          begin
             mdNodes.Append;
             mdNodes.FieldByName('NOEUD').AsString               := vNodes[i].NODE_ID;
             mdNodes.FieldByName('GROUPE').AsString              := vNodes[i].NODE_GROUP_ID;
             mdNodes.FieldByName('REGISTRATION_TIME').AsDateTime := vNodes[i].REGISTRATION_TIME;
             For j:=Low(vLasts) to High(vLasts) do
              begin
                if  Sender_To_Node(vLasts[j].BAS_SENDER) = vNodes[i].NODE_ID  then
                  begin
                    mdNodes.FieldByName('SENDER').Asstring          := vLasts[j].BAS_SENDER;
                    mdNodes.FieldByName('LAST_K_VERSION').Asinteger := vLasts[j].K_VERSION;
                    mdNodes.FieldByName('K_UPDATED').AsDateTime     := vLasts[j].K_UPDATED;
                  end;
              end;

             cbNode.Items.Append(vNodes[i].NODE_ID);
             mdNodes.Post;
          end;


         teGENERAL_ID.Text := IntToStr(DataMod.GetGENERAL_ID(aValue));
         tePLAGE.TExt      := DataMod.GetPLAGE(aValue);

         BEVAL.Enabled:=true;
         Mettrejour.Enabled := true;
         BCALCULTRANCHE.Enabled:=true;



         {
         aListeBases := DataMod.EasyMvtListeBases(AValue);
         // on prend pas la base "0"
         cbNode.Items.Clear;
         mdNodes.Close();
         mdNodes.Open();
         for i:=1 to High(aListeBases) do
          begin
             aEtat := DataMod.EtatNoeud(AValue,aListeBases[i].NODE_ID);
             mdNodes.Append;
             if aListeBases[i].NODE_ID<>''
               then cbNode.Items.Add(aListeBases[i].NODE_ID);
             mdNodes.FieldByName('NOEUD').AsString   := aListeBases[i].NODE_ID;
             case aEtat.SYNC_ENABLED of
               1: mdNodes.FieldByName('ETAT').AsString    := 'Enregistré';
               0: mdNodes.FieldByName('ETAT').AsString    := 'Ouvert';
             end;
             mdNodes.FieldByName('HEARTBEAT').AsString    := aEtat.HEARTBEAT_TIME;
             mdNodes.FieldByName('SENDER').AsString       := aListeBases[i].BAS_SENDER;
             mdNodes.FieldByName('LASTREPLICDELOS').AsDatetime := aListeBases[i].LAST_REPLIC;
             mdNodes.Post;
             }

             {if (aListeBases[i].NODE_ID<>'') then
                begin
                   Item := ListView.Items.Add;
                   //----------------------
                   Item.Caption:=Format('%d',[aListeBases[i].BAS_IDENT]);
                   aEtat := DataMod.EtatNoeud(AValue,aListeBases[i].NODE_ID);

                   Item.SubItems.Add(aListeBases[i].NODE_ID);

                    1: Item.SubItems.Add('Enregistré');
                    0: Item.SubItems.Add('Ouvert');
                    else
                      Item.SubItems.Add('');
                   end;


                   Item.SubItems.Add(aEtat.HEARTBEAT_TIME);
                   // URL
                   Item.SubItems.Add(aListeBases[i].BAS_SENDER);
                   Item.SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss',aListeBases[i].LAST_REPLIC));
                end;
             }
       Except
         On E:Exception do
            begin
               MessageDlg(E.MEssage,  mtError, [mbOK], 0);
               FCANMVT := false;
            end;
       end;
     finally
//        aListeBases.Free;
     end;
end;




procedure TFrm_EasyMVT.Timer1Timer(Sender: TObject);
var vDeltaS : double;
begin
   vDeltaS  := (GetTickCount - FStart)/1000;
   sb.Panels[0].Text       := SecondToTime(vDeltaS);
   // Temps Restant
   FTpsRest := FTpsRest - 1* Round(Timer1.Interval/1000);
   if FTpsRest>=0 then
      lbl_tpsrestant.Caption  := SecondToTime(FTpsRest);
   lbl_tps.Caption         := sb.Panels[0].Text;
   sb.Refresh;
   Application.ProcessMessages;
end;

procedure TFrm_EasyMVT.tmAutoCloseInXTimer(Sender: TObject);
begin
   tmAutoCloseInX.Enabled := false;
   If (FAuto) and (FCanClose)
     then
      begin
         Dec(FTimeClose);
         sb.Panels[2].Text := Format('Fermerture de l''application dans %d secondes',[FTimeClose]);
         if (FTimeClose<=0)
            then Close;
      end;
   tmAutoCloseInX.Enabled := true;
end;

end.
