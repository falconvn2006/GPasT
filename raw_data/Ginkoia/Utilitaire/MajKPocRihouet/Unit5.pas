unit Unit5;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  DateUtils,
  DB,
  ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.IB, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    IbC_Ginkoia: TFDConnection;
    OD_Ginkoia: TOpenDialog;
    Edt_Base: TEdit;
    Btn_Path: TButton;
    Btn_Traite: TButton;
    Que_Ktb: TFDQuery;
    Que_Tbl: TFDQuery;
    Que_K: TFDQuery;
    Que_MajK: TFDQuery;
    ProgressBar1: TProgressBar;
    Lab_Traite: TLabel;
    Lab_InfoGeneral: TLabel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dtpFrom: TDateTimePicker;
    dtpTo: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    OptMvtAllTbl: TRadioButton;
    OptMvtAllTblAddK: TRadioButton;
    OptMvtPlage: TRadioButton;
    OptMvtOffset: TRadioButton;
    GroupBox1: TGroupBox;
    Mmo_Log: TMemo;
    Tim_TrtOffset: TTimer;
    Btn_StopTrt: TButton;
    Que_SelectK: TFDQuery;
    Lab_Progress: TLabel;
    Que_GenBase: TFDQuery;
    dtpOffset: TDateTimePicker;
    EdtMinutes: TEdit;
    Label7: TLabel;
    ChkModeTest: TCheckBox;
    Label8: TLabel;
    Que_CreateProc: TFDQuery;
    Que_DelProc: TFDQuery;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Lab_Progress2: TLabel;
    procedure Btn_TraiteClick(Sender: TObject);
    procedure Btn_PathClick(Sender: TObject);
    procedure Btn_AddKSiVideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tim_TrtOffsetTimer(Sender: TObject);
    procedure Btn_StopTrtClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Déclarations privées }
    gbCancelTraitement: boolean;
    gdtLastTimeStamp: TDateTime;
    giOffset: integer;
    gbTrtEnCours: boolean;

    function getBasePathFromRegistry: string;

  public
    procedure DoTraite(bAddK: boolean);
    procedure DoTraiteDateADate(ADateDeb: TDateTime; ADateFin: TDateTime);
    procedure DoTraiteOffset(AOffset: integer);
    { Déclarations publiques }
  end;

var
  Form5: TForm5;

implementation

uses UTools, Registry;

{$R *.dfm}

procedure TForm5.Btn_AddKSiVideClick(Sender: TObject);
begin
  if InputBox('Confirmation', 'Entrez le code pour confirmer', '') <> '1082' then
  begin
    Showmessage('Traitement annulé');
    exit;
  end;

  if MessageDlg
    ('ATTENTION, ce traitement insère des données de test dans certaines tables. Il ne doit pas être exécuté sur une base de PROD !!!',
    mtConfirmation, mbOKCancel, 0) = mrOK then
  begin
    DoTraite(True);
  end;

end;

procedure TForm5.Btn_PathClick(Sender: TObject);
begin
  OD_Ginkoia.Filter := 'Fichiers Interbase (*.ib)|*.ib|Fichiers Interbase (*.gdb)|*.gdb|Tous (*.*)|*.*';
  OD_Ginkoia.InitialDir := ExtractFilePath(Application.ExeName);
  OD_Ginkoia.FileName := Edt_Base.Text;
  IF OD_Ginkoia.Execute then
  begin
    Edt_Base.Text := OD_Ginkoia.FileName;
  end;
end;

procedure TForm5.Btn_StopTrtClick(Sender: TObject);
begin
  if gbTrtEnCours then
  begin
    gbCancelTraitement := True;
    Lab_Progress.Caption := 'Interruption demandée';
    Application.ProcessMessages;
  end
  else
  begin
    Tim_TrtOffset.Enabled := False;
    Btn_Traite.Enabled := True;
    Btn_StopTrt.Enabled := not(Btn_Traite.Enabled);
    Lab_Progress.Caption := 'Traitement interrompu';
    LogAction('Traitement interrompu');
    Application.ProcessMessages;
  end;
end;

procedure TForm5.Btn_TraiteClick(Sender: TObject);
begin
  if InputBox('Confirmation', 'Entrez le code pour confirmer', '') <> '1082' then
  begin
    Showmessage('Traitement annulé');
    exit;
  end
  Else
  begin
    Mmo_Log.Lines.Clear;
    initLogFileName(0, Application.ExeName, 'yyyy_mm_dd', Mmo_Log);
    Application.ProcessMessages;

    // Gestion du visuel
    gbCancelTraitement := False;
    Btn_Traite.Enabled := False;
    Btn_StopTrt.Enabled := not(Btn_Traite.Enabled);
    Sleep(100);
    Application.ProcessMessages;

    // Traitement d'une plage
    if OptMvtPlage.Checked = True then
    begin
      LogAction('Traitement date à date');
      Lab_Progress.Caption := 'Début du traitement';
      DoTraiteDateADate(Trunc(dtpFrom.DateTime), Trunc(dtpTo.DateTime + 1));
      Lab_Progress.Caption := 'Traitement terminé';
      Btn_StopTrt.Enabled := not(Btn_Traite.Enabled);
      Btn_Traite.Enabled := True;
    end
    else if OptMvtOffset.Checked = True then
    begin
      // Traitement d'une date antérieur à la meme heure en boucle
      LogAction('Traitement avec décalage du jour');
      giOffset := Trunc(Now()) - Trunc(dtpOffset.DateTime);
      Tim_TrtOffset.Interval := StrToInt(EdtMinutes.Text) * 60000;

      LogAction('Activation timer, interval : ' + EdtMinutes.Text + ' min');
      Application.ProcessMessages;

      LogAction('Premier traitement');
      Application.ProcessMessages;

      // init du timestampe a H - X min
      gdtLastTimeStamp := IncMilliSecond(Now() - giOffset, -Tim_TrtOffset.Interval);

      DoTraiteOffset(giOffset);

      Tim_TrtOffset.Enabled := True;
      LogAction('Prochain time : ' + FormatDateTime('dd/mm/yyyy à hh:mm:ss', IncMillisecond(Now(), Tim_TrtOffset.Interval)));
      Lab_Progress.Caption := 'Prochain time : ' + FormatDateTime('dd/mm/yyyy à hh:mm:ss', IncMillisecond(Now(), Tim_TrtOffset.Interval));

    end;
  end;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
  OptMvtPlage.Checked := True;
  dtpFrom.Date := StrToDate('29/11/2019');
  dtpTo.Date := StrToDate('29/11/2019');
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  OptMvtPlage.Checked := True;
  dtpFrom.Date := StrToDate('02/12/2019');
  dtpTo.Date := StrToDate('08/12/2019');
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
  OptMvtOffset.Checked := True;
  dtpOffset.Date := StrToDate('02/12/2019');
end;

procedure TForm5.Button4Click(Sender: TObject);
begin
  OptMvtOffset.Checked := True;
  dtpOffset.Date := StrToDate('29/11/2019');
end;

procedure TForm5.Button5Click(Sender: TObject);
begin
  OptMvtPlage.Checked := True;
  dtpFrom.Date := StrToDate('01/01/2020');
  dtpTo.Date := StrToDate('01/01/2020');
end;

procedure TForm5.DoTraite(bAddK: boolean);
var
  iKID: integer;
  iPosComma: integer;
  sTblId: string;
begin
  if Edt_Base.Text = '' then
  begin
    Showmessage('Base inexistante');
    exit;
  end;

  TRY
    initLogFileName(0, Application.ExeName, 'yyyy_mm_dd', Mmo_Log);

    // ouverture de la base
    IbC_Ginkoia.Close;
    IbC_Ginkoia.Params.Text := 'DriverID=IB' + Chr(13) + Chr(10) + 'Database=localhost:' + Edt_Base.Text + Chr(13) +
      Chr(10) + 'OSAuthent=No' + Chr(13) + Chr(10) + 'User_Name=ginkoia' + Chr(13) + Chr(10) + 'Password=ginkoia';
    IbC_Ginkoia.Open;

    if IbC_Ginkoia.Connected then
    begin
      // récup des données de KTB
      // sauf k, k2, ktb, kfld
      ProgressBar1.Min := 0;
      ProgressBar1.Position := 0;

      Que_Ktb.Close;
      Que_Ktb.SQL.Text := 'SELECT KTB_ID, KTB_NAME, KTB_DATA FROM KTB where ktb_name not like ''K%''';
      Que_Ktb.Open;
      Que_Ktb.FetchAll;

      ProgressBar1.Max := Que_Ktb.RecordCount;
      while not Que_Ktb.Eof do
      begin
        Lab_Traite.Caption := 'Traitement de ' + Que_Ktb.FieldByName('KTB_NAME').AsString;
        LogAction('Traitement de ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
        ProgressBar1.StepBy(1);
        Sleep(10);
        Application.ProcessMessages;

        // vérif si enreg
        Que_K.Close;
        Que_K.SQL.Text := 'SELECT K_ID FROM K WHERE K_ID <> 0 AND KTB_ID = ' + Que_Ktb.FieldByName('KTB_ID').AsString +
          ' ROWS 1';
        Que_K.Open;

        if Que_K.RecordCount > 0 then
        begin
          LogAction('  - UPDATEK de ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
          Que_MajK.Close;
          Que_MajK.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Que_K.FieldByName('K_ID').AsString + ',0 )';
          Que_MajK.ExecSQL;
          Que_MajK.Close;
        end
        else if bAddK then
        begin
          if (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'INVIMGSTK') AND
            (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'GENCUSTOMISE') AND
            (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'NKLSELECTION') AND
            (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'TARGROUPTAR') then
          begin
            LogAction('  - NewK de ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
            // ajoute le k
            Que_MajK.Close;
            Que_MajK.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr(Que_Ktb.FieldByName('KTB_NAME').AsString) + ')';
            Que_MajK.Open;
            iKID := Que_MajK.Fields[0].AsInteger;
            Que_MajK.Close;
            if iKID <> 0 then
            begin
              LogRollback('DELETE FROM K WHERE K_ID = ' + IntToStr(iKID) + ';');

              iPosComma := Pos(',', Que_Ktb.FieldByName('KTB_DATA').AsString);
              if iPosComma > 0 then
              begin
                sTblId := Copy(Que_Ktb.FieldByName('KTB_DATA').AsString, 1, iPosComma - 1);
              end
              else
              begin
                sTblId := Que_Ktb.FieldByName('KTB_DATA').AsString;
              end;
              try
                Que_MajK.Close;
                Que_MajK.SQL.Text := 'INSERT INTO ' + Que_Ktb.FieldByName('KTB_NAME').AsString + '(' + sTblId +
                  ') VALUES (' + IntToStr(iKID) + ')';
                Que_MajK.ExecSQL;
                Que_MajK.Close;

                LogAction('  - NewData de ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
                LogRollback('DELETE FROM ' + Que_Ktb.FieldByName('KTB_NAME').AsString + ' WHERE ' + sTblId + ' = ' +
                  IntToStr(iKID) + ';');
              except
                begin
                  LogAction('Table inexistante : ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
                  LogAction('Query : ' + 'INSERT INTO ' + Que_Ktb.FieldByName('KTB_NAME').AsString + '(' + sTblId +
                    ') VALUES (' + IntToStr(iKID) + ')', 0);
                end;
              end;
            end;
          end
          else
          begin
            LogAction('  - TableIgnorée ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
          end;
        end
        else
        begin
          LogAction('  - RAS ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);
        end;
        LogAction('Fin traitement de ' + Que_Ktb.FieldByName('KTB_NAME').AsString, 0);

        Que_K.Close;

        Que_Ktb.Next;
      end;
      Que_Ktb.Close;

      Lab_Traite.Caption := 'Traitement terminé';
      ProgressBar1.Position := ProgressBar1.Max;
      Application.ProcessMessages;
    end;
  except
    on e: exception do
    begin
      Showmessage(e.Message);
    end;
  END;
  IbC_Ginkoia.Close;

end;

procedure TForm5.DoTraiteDateADate(ADateDeb, ADateFin: TDateTime);
var
  iCurRec: integer;
  iMaxRec: integer;
  sMyKID: string;
  sCurProgress: string;
  sMaPlage: string;
  sDebPlage, sFinPlage: string;
  iDebPlage, iFinPlage: integer;
  bProcToDel: boolean;
begin
  if Edt_Base.Text = '' then
  begin
    LogAction('Base inexistante');
    exit;
  end;

  LogAction('Traitement du : ' + FormatDateTime('dd/mm/yyyy hh:nn', ADateDeb) + ' au ' +
    FormatDateTime('dd/mm/yyyy hh:nn', ADateFin));
  Application.ProcessMessages;

  gbTrtEnCours := True;
  TRY
    // ouverture de la base
    IbC_Ginkoia.Close;
    IbC_Ginkoia.Params.Text := 'DriverID=IB' + Chr(13) + Chr(10) + 'Database=localhost:' + Edt_Base.Text + Chr(13) +
      Chr(10) + 'OSAuthent=No' + Chr(13) + Chr(10) + 'User_Name=ginkoia' + Chr(13) + Chr(10) + 'Password=ginkoia';
    IbC_Ginkoia.Open;

    if IbC_Ginkoia.Connected then
    begin
      LogAction('Connexion DB OK : ' + Edt_Base.Text);
      // récup des données de KTB
      // sauf k, k2, ktb, kfld
      ProgressBar1.Min := 0;
      ProgressBar1.Position := 0;
      Que_GenBase.Close;
      Que_GenBase.Open;
      Que_GenBase.First;
      sMaPlage := Que_GenBase.Fields[0].AsString;

      sDebPlage := Copy(sMaPlage, 2, Pos('M_', sMaPlage) - 2) + '000000';
      iDebPlage := StrToInt(sDebPlage);
      sFinPlage := Copy(sMaPlage, Pos('M_', sMaPlage) + 2, Length(sMaPlage) - (Pos('M_', sMaPlage) + 3)) + '000000';
      iFinPlage := StrToInt(sFinPlage);

      LogAction('Plage KRH_ID : ' + sDebPlage + ' - ' + sFinPlage);

      // vérif si enreg
      Que_SelectK.Close;
      Que_SelectK.ParamByName('DATEDEB').AsDateTime := ADateDeb;
      Que_SelectK.ParamByName('DATEFIN').AsDateTime := ADateFin;

      if ChkModeTest.Checked then
      begin
        Que_SelectK.SQL[3] := '';
      end
      else
      begin
        Que_SelectK.SQL[3] := 'AND KRH_ID >= :KRHDEB AND KRH_ID < :KRHFIN';
        Que_SelectK.ParamByName('KRHDEB').AsInteger := iDebPlage;
        Que_SelectK.ParamByName('KRHFIN').AsInteger := iFinPlage;
      end;
      Que_SelectK.Open;
      Que_SelectK.First;
      Que_SelectK.FetchAll;
      iCurRec := 1;
      iMaxRec := Que_SelectK.RecordCount;

      ProgressBar1.Max := iMaxRec;
      LogAction('   -> Nb enreg : ' + IntToStr(Que_SelectK.RecordCount));
      LogStat(IntToStr(Que_SelectK.RecordCount));
      bProcToDel := False;
      while NOT Que_SelectK.Eof do
      begin
        if NOT bProcToDel then
        begin
          bProcToDel := True;
          LogAction('   -> Création procédure de reload');
          Application.ProcessMessages;
          Que_CreateProc.Close;
          Que_CreateProc.ExecSQL;
          Que_CreateProc.Close;
        end;

        sCurProgress := IntToStr(iCurRec) + '/' + IntToStr(iMaxRec);
        sMyKID := Que_SelectK.Fields[0].AsString;
        Lab_Progress.Caption := sCurProgress + ' - Traitement K : ' + sMyKID;
        Lab_Progress2.Caption := sCurProgress;
        Application.ProcessMessages;
        LogAction('   -> Reload de ' + sMyKID);

        try
          Que_MajK.Close;
          Que_MajK.SQL.Text := 'EXECUTE PROCEDURE EASY_MVT_MAG2LAME_POC(' + sMyKID + ')';
          Que_MajK.ExecSQL;
          Que_MajK.Close;
        except
          on e: exception do
          begin
            LogAction(e.Message);
          end;
        end;
        Que_SelectK.Next;
        Inc(iCurRec);

        ProgressBar1.StepBy(1);
        Sleep(10);
        Application.ProcessMessages;

        if gbCancelTraitement then
        begin
          Btn_Traite.Enabled := True;
          Btn_StopTrt.Enabled := not(Btn_Traite.Enabled);
          Lab_Progress.Caption := 'Traitement interrompu';
          LogAction('Traitement interrompu');
          Application.ProcessMessages;
          Break;
        end;
      end;

      if bProcToDel then
      begin
        LogAction('   -> Suppression procédure de reload');
        Application.ProcessMessages;
        Que_DelProc.Close;
        Que_DelProc.ExecSQL;
        Que_DelProc.Close;
      end;

      LogAction('   -> Fin traitement');
      Que_SelectK.Close;
    end;

  except
    on e: exception do
    begin
      LogAction(e.Message);
    end;
  END;
  IbC_Ginkoia.Close;
  gbTrtEnCours := False;

end;

procedure TForm5.DoTraiteOffset(AOffset: integer);
var
  dtCurTimeStamp: TDateTime;
  dtOffset: TDate;
begin
  dtCurTimeStamp := Now - AOffset;

  // Faire traitement en boucle
  DoTraiteDateADate(gdtLastTimeStamp, dtCurTimeStamp);

  gdtLastTimeStamp := dtCurTimeStamp;
end;

procedure TForm5.FormCreate(Sender: TObject);
var
  MaBaseRegistre: TRegistry;

begin
  gbTrtEnCours := False;
  Edt_Base.Text := getBasePathFromRegistry;
end;

procedure TForm5.Tim_TrtOffsetTimer(Sender: TObject);
begin
  Tim_TrtOffset.Enabled := False;

  DoTraiteOffset(giOffset);

  if gbCancelTraitement then
  begin
    gbCancelTraitement := False;
    Btn_Traite.Enabled := True;
    Btn_StopTrt.Enabled := not(Btn_Traite.Enabled);
    Lab_Progress.Caption := 'Traitement interrompu';
    LogAction('Traitement interrompu');
    Application.ProcessMessages;
  end
  else
  begin
    LogAction('Prochain time : ' + FormatDateTime('dd/mm/yyyy à hh:mm:ss', IncMillisecond(Now(), Tim_TrtOffset.Interval)));
    Lab_Progress.Caption := 'Prochain time : ' + FormatDateTime('dd/mm/yyyy à hh:mm:ss', IncMillisecond(Now(), Tim_TrtOffset.Interval));
    Tim_TrtOffset.Enabled := True;
  end;
end;

function TForm5.getBasePathFromRegistry: string;
var
  vReg: TRegistry;
  vPath: string;
begin
  vPath := '';

  try
    vReg := TRegistry.Create;
    try
      vReg.Access := KEY_READ;
      vReg.RootKey := HKEY_LOCAL_MACHINE;
      if vReg.OpenKey('Software\Algol\Ginkoia', False) then
      begin
        if vReg.ValueExists('Base0') then
        begin
          vPath := vReg.ReadString('Base0');
        end;
        vReg.CloseKey;
      end;
    finally
      vReg.DisposeOf;
    end;
  except

  end;

  Result := vPath;
end;

end.
