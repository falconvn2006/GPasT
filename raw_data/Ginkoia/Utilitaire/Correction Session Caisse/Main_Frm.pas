unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, RzPanel, ComCtrls, RzDTP, Menus, Spin;

type
  TFrm_Main = class(TForm)
    OD_Base: TOpenDialog;
    Pan_haut: TRzPanel;
    Lab_Base: TLabel;
    Edt_Base: TEdit;
    Nbt_Conn: TBitBtn;
    Lab_OkConn: TLabel;
    Nbt_Ouvre: TBitBtn;
    Pan_Client: TRzPanel;
    Nbt_Quit: TBitBtn;
    GroupBox1: TGroupBox;
    Edt_DDeb: TRzDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Edt_DFin: TRzDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    Nbt_Exec: TBitBtn;
    Label5: TLabel;
    Lbx_resu: TListBox;
    Lab_Etat: TLabel;
    Label6: TLabel;
    Edt_Session: TEdit;
    Lab_TitEtat: TLabel;
    Nbt_Analyse: TBitBtn;
    Lab_Version: TLabel;
    chkSessionFausse: TCheckBox;
    btnGLobalAction: TBitBtn;
    pmGlobalAction: TPopupMenu;
    CorrectionerreurdeventilationPxNN0opration3pour21: TMenuItem;
    CorrectiondeMENID01: TMenuItem;
    CorrectiondesproblmedeBAgnrantdespseudoremise1: TMenuItem;
    Pan_VoirUnTicket: TPanel;
    Nbt_VoirUnTicket: TBitBtn;
    Chp_VoirUnTicket: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_OuvreClick(Sender: TObject);
    procedure Nbt_ConnClick(Sender: TObject);
    procedure Nbt_ExecClick(Sender: TObject);
    procedure Nbt_AnalyseClick(Sender: TObject);
    procedure Lbx_resuClick(Sender: TObject);
    procedure Lbx_resuDblClick(Sender: TObject);
    procedure btnGLobalActionClick(Sender: TObject);

    procedure CorrectionerreurdeventilationPxNN0opration3pour21Click(Sender: TObject);
    procedure CorrectiondeMENID01Click(Sender: TObject);
    procedure CorrectiondesproblmedeBAgnrantdespseudoremise1Click(
      Sender: TObject);
    procedure Nbt_VoirUnTicketClick(Sender: TObject);
    procedure Chp_VoirUnTicketKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    NomBase: string;
    procedure DoConnexion(OkMess: boolean);
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;

    // gestion du drag and drop
    procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  IBODataset, DB,
  ShellAPI,
  Main_Dm,
  Analyse_Frm,
  Ticket_Frm;

{$R *.dfm}

function ApplicationVersion: String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  Version: string;
  d: TDateTime;
  AgeExe: string;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Version := IntTostr(dwFileVersionMS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Version := Version + '.' + IntTostr(dwFileVersionLS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end
  else
    Version:='0.0.0.0 ';

  d:=  FileDateToDateTime(FileAge(ParamStr(0)));
  AgeExe := ' du '+FormatDateTime('dd/mm/yyyy',d);
  result := Version+AgeExe;
end;

procedure TFrm_Main.btnGLobalActionClick(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pmGlobalAction.PopupComponent := TComponent(Sender);
  pmGlobalAction.Popup(pt.X,pt.y);
end;

procedure TFrm_Main.Chp_VoirUnTicketKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Nbt_VoirUnTicketClick(Sender);
    Key := 0;
  end;
end;

procedure TFrm_Main.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_RETURN) and (Edt_Session.Focused)
     and (Edt_Session.Text<>'') and (Dm_Main.Ginkoia.Connected) then
  begin
    M.Result := 1;
    Nbt_AnalyseClick(Nbt_Analyse);
    Edt_Session.SelectAll;
    Edt_Session.SetFocus;
    exit;
  end;
  inherited;
end;

procedure TFrm_Main.CorrectiondeMENID01Click(Sender: TObject);
var
  i: Integer;
  msg: string;
  MenID: integer;
  TKE_ID: TField;
  quSession: TIBOQuery;
  tslError: TStringList;
  bSessionModif: Boolean;
  nbSession, nbModif: Integer;
begin
  nbSession := 0;
  nbModif := 0;
  tslError := TStringList.Create;
  quSession  := Dm_Main.Que_Div4;
  if quSession.Active then
    quSession.Close;
  try
    quSession.SQL.Clear;
    quSession.SQL.Add('SELECT TKE_ID FROM CSHTICKET');
    quSession.SQL.Add('JOIN CSHSESSION ON SES_ID = tke_SESID');
    quSession.SQL.Add('WHERE SES_Numero = :SESNUM');

    for i := 0 to Lbx_resu.Items.Count - 1 do
    begin
      quSession.ParamByName('SESNUM').AsString := Lbx_resu.Items[i];
      try
        bSessionModif := false;
        quSession.Open;
        TKE_ID := quSession.FieldByName('TKE_ID');;
        while not quSession.Eof do
        begin
          MenID := Dm_Main.GetBonReducIDBySession(Lbx_resu.Items[i]);
          if MenID = 0 then
            tslError.Add('Mode d''encaissement Bon de réduction non trouvé')
          else if Dm_Main.CorrigeMenIDZero(TKE_ID.AsInteger, MenID, msg) then
          begin
            Inc(nbModif);
            bSessionModif := true;
          end
          else
          begin
            if msg <> '' then
              tslError.Add(Format('Session %s", ticket "%d" : %s', [Lbx_resu.Items[i], TKE_ID.AsInteger, msg]));
          end;
          quSession.Next;
        end;
        if bSessionModif then
           inc(nbSession);
      finally
        quSession.close;
      end;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else if nbSession = 1 then
      msg := format('%d tickets corrigés pour 1 session', [nbModif])
    else
      msg := format('%d tickets corrigés pour %d sessions', [nbModif, nbSession]);

    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_ExecClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_Main.CorrectiondesproblmedeBAgnrantdespseudoremise1Click(Sender: TObject);
var
  i: Integer;
  quSession: TIBOQuery;
  TKE_ID: TField;
  msg: string;
  bSessionModif: Boolean;
  nbSession, nbModif: Integer;
  tslError: TStringList;
begin
  nbSession := 0;
  nbModif := 0;
  tslError := TStringList.Create;
  quSession  := Dm_Main.Que_Div4;
  if quSession.Active then
    quSession.Close;
  try
    // attention, il faut que ca gènère des pseudo remise !
    quSession.SQL.Text := 'select distinct tke_id '
                        + 'from cshticket join k on k_id = tke_id and k_enabled = 1 '
                        + 'join cshsession join k on k_id = ses_id and k_enabled = 1 on ses_id = tke_sesid '
                        + 'join cshencaissement join k on k_id = tke_id and k_enabled = 1 on enc_tkeid = tke_id '
                        + 'join cshmodeenc join k on k_id = men_id and k_enabled = 1 on men_id = enc_menid '
                        + 'where ses_numero = :sesnum and enc_ba != 0 and men_remiseoto = 1;';

    for i := 0 to Lbx_resu.Items.Count - 1 do
    begin
      quSession.ParamByName('SESNUM').AsString := Lbx_resu.Items[i];
      try
        bSessionModif := false;
        quSession.Open;
        TKE_ID := quSession.FieldByName('TKE_ID');;
        while not quSession.Eof do
        begin
          if Dm_Main.CorrigeTicketAvecBAGenerantDesPseudoRemise(TKE_ID.AsInteger, msg) then
          begin
            Inc(nbModif);
            bSessionModif := true;
          end
          else
          begin
            if msg <> '' then
              tslError.Add(Format('Session %s", ticket "%d" : %s', [Lbx_resu.Items[i], TKE_ID.AsInteger, msg]));
          end;
          quSession.Next;
        end;
        if bSessionModif then
           inc(nbSession);
      finally
        quSession.close;
      end;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else if nbSession = 1 then
      msg := format('%d tickets corrigés pour 1 session', [nbModif])
    else
      msg := format('%d tickets corrigés pour %d sessions', [nbModif, nbSession]);

    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_ExecClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_Main.CorrectionerreurdeventilationPxNN0opration3pour21Click(Sender: TObject);
var
  i: Integer;
  quSession: TIBOQuery;
  TKE_ID: TField;
  msg: string;
  bSessionModif: Boolean;
  nbSession, nbModif: Integer;
  tslError: TStringList;
begin
  nbSession := 0;
  nbModif := 0;
  tslError := TStringList.Create;
  quSession  := Dm_Main.Que_Div4;
  if quSession.Active then
    quSession.Close;
  try
    quSession.SQL.Clear;
    quSession.SQL.Add('SELECT TKE_ID FROM CSHTICKET');
    quSession.SQL.Add('JOIN CSHSESSION ON SES_ID = tke_SESID');
    quSession.SQL.Add('WHERE SES_Numero = :SESNUM');

    for i := 0 to Lbx_resu.Items.Count - 1 do
    begin
      quSession.ParamByName('SESNUM').AsString := Lbx_resu.Items[i];
      try
        bSessionModif := false;
        quSession.Open;
        TKE_ID := quSession.FieldByName('TKE_ID');;
        while not quSession.Eof do
        begin
          if Dm_Main.CorrigeTicketAvecPxNNa0(TKE_ID.AsInteger, msg) then
          begin
            Inc(nbModif);
            bSessionModif := true;
          end
          else
          begin
            if msg <> '' then
              tslError.Add(Format('Session %s", ticket "%d" : %s', [Lbx_resu.Items[i], TKE_ID.AsInteger, msg]));
          end;
          quSession.Next;
        end;
        if bSessionModif then
           inc(nbSession);
      finally
        quSession.close;
      end;
    end;
    if nbModif = 0 then
      msg := 'Aucun ticket corrigé'
    else if nbModif = 1 then
      msg := '1 ticket corrigé'
    else if nbSession = 1 then
      msg := format('%d tickets corrigés pour 1 session', [nbModif])
    else
      msg := format('%d tickets corrigés pour %d sessions', [nbModif, nbSession]);

    if tslError.Count > 0 then
      msg := msg + #13#10#13#10+tslError.Text;
    MessageDlg(msg, mterror,[mbok],0);
  finally
    if nbModif > 0 then
      Nbt_ExecClick(sender);
    tslError.Free;
  end;
end;

procedure TFrm_Main.DoConnexion(OkMess: boolean);
var
  vVer: string;
begin
  Pan_Client.Visible := false;
  Lab_OkConn.Caption := 'Non connecté';
  Lab_OkConn.Font.Color := clMaroon;
  Dm_Main.Ginkoia.Connected := false;
  if (Edt_Base.Text='') {or not(FileExists(Edt_Base.Text))} then
  begin
    if OkMess then
      MessageDlg('Base non trouvé !',mterror,[mbok],0);
    exit;
  end;
  
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Dm_Main.Ginkoia.Database := Edt_Base.Text;
    Dm_Main.Ginkoia.Connected := true;
    vVer := '';
    with Dm_Main.Que_Div, SQL do
    begin
      Active := false;
      Clear;
      Add('select * from genversion order by ver_date');
      Active:=true;
      Last;
      vVer := fieldbyname('VER_VERSION').AsString;
      Active := false;
    end;

    Lab_OkConn.Caption := 'Connecté Ver '+vVer;
    Lab_OkConn.Font.Color := clGreen;
    Pan_Client.Visible := true;
    NomBase := ExtractFilePath(Edt_Base.Text);
    if (NomBase<>'') and (NomBase[Length(NomBase)]='\') then
      NomBase := Copy(NomBase, 1, Length(NomBase)-1);
    while pos('\',NomBase)>0 do
      NomBase := Copy(NomBase, pos('\',NomBase)+1, Length(NomBase));
  except
    on E:Exception do
    begin
      if OkMess then
        MessageDlg(E.Message, mterror,[mbok],0);
    end;
  end;  
  Application.ProcessMessages; 
  Screen.Cursor := crDefault;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin   
  // Gestion du drag ans drop
  DragAcceptFiles(Handle, True);

  Dm_Main := TDm_Main.Create(Self);

  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  Edt_Base.Text:='';
  Lab_OkConn.Caption := 'Non connecté'; 
  Lab_OkConn.Font.Color := clMaroon;
  Pan_Client.Visible := false;
  if FileExists(ReperBase+'Data\ginkoia.ib') then
  begin
    Edt_Base.Text := ReperBase+'Data\ginkoia.ib';
    DoConnexion(false);
  end;

  Edt_DDeb.Date:=Date;
  Edt_DFin.Date:=Date;
  Edt_Session.Text := '';
  Lab_Version.Caption := 'Ver. '+ApplicationVersion;
end;

procedure TFrm_Main.Lbx_resuClick(Sender: TObject);
var
  lret: integer;
begin
  lret := Lbx_Resu.ItemIndex;
  if lret < 0 then
    Edt_Session.Text := ''
  else
    Edt_Session.Text := StringReplace(lbx_Resu.Items[lret], ' [CASH]', '', []);
end;

procedure TFrm_Main.Lbx_resuDblClick(Sender: TObject);
begin
  if not (Trim(Edt_Session.Text) = '') then
    Nbt_AnalyseClick(Sender);
end;

procedure TFrm_Main.Nbt_AnalyseClick(Sender: TObject);
var
  Frm_AnalyseSession : TFrm_AnalyseSession;
begin
  Frm_AnalyseSession := TFrm_AnalyseSession.Create(Self);
  try
    if Frm_AnalyseSession.InitEcr(NomBase, Edt_Session.Text) then
      Frm_AnalyseSession.ShowModal;
  finally
    FreeAndNil(Frm_AnalyseSession);
  end;
end;

procedure TFrm_Main.Nbt_ConnClick(Sender: TObject);
begin
  DoConnexion(true);
end;

procedure TFrm_Main.Nbt_ExecClick(Sender: TObject);
var
  dDeb, DFin: TDateTime;
  nb: integer;
  n:integer;
  sValue: string;
  vValue: Double;
  sSessionText: string;
  bIsCashSession: Boolean;
begin
  dDeb:=Edt_DDeb.Date;
  dFin:=Edt_DFin.Date;
  if (Trunc(dDeb)=0) then
  begin
    MessageDlg('Date de début invalide !',mterror,[mbok],0);
    exit;
  end;
  if (Trunc(dFin)=0) then
  begin
    MessageDlg('Date de fin invalide !',mterror,[mbok],0);
    exit;
  end;       
  if (Trunc(dFin)<Trunc(dDeb)) then
  begin
    MessageDlg('Date de fin plus petit que date de début !',mterror,[mbok],0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;  
  Lab_Etat.Caption := '';
  Lab_TitEtat.Visible:=true;
  Lab_Etat.Visible := true;
  lbx_resu.Items.Clear();
  n := 0;
  Application.ProcessMessages;
  try
    with Dm_Main.Que_RechSession do
    begin
      ParamByname('DDEB').AsDate := dDeb;
      ParamByname('DFIN').AsDate := dFin;
      Active := true;
      nb := RecordCount;
      Lab_Etat.Caption := '0 / '+inttostr(nb);
      Lab_TitEtat.Visible:=true;
      Lab_Etat.Visible := true;
      Application.ProcessMessages;
      First;
      while not(Eof) do
      begin
        inc(n);
        Lab_Etat.Caption := inttostr(n)+' / '+inttostr(nb);
        Application.ProcessMessages;

        if chkSessionFausse.Checked then
        begin
          With Dm_Main.Que_VerifSession do
          begin
            ParamByname('SESID').AsInteger := Dm_Main.Que_RechSession.fieldbyname('SES_ID').AsInteger;
            Active := true;
            Last;
            sValue := fieldbyname('STR2').AsString;
            if Pos('.',sValue)>0 then
              sValue[Pos('.',sValue)] := DecimalSeparator;
            if Pos(',',sValue)>0 then
              sValue[Pos(',',sValue)] := DecimalSeparator;
            vValue := StrToFloatDef(sValue,0.0);

            bIsCashSEssion := Dm_Main.SessionIsCashSession(Dm_Main.Que_RechSession.fieldbyname('SES_ID').AsInteger);
            sSessionText := Dm_Main.Que_RechSession.fieldbyname('SES_NUMERO').AsString;
            if bIsCASHSession then
            begin
              sSessionText := sSessionText + ' [CASH]';
              vValue := vValue + dm_Main.GetCashSessionDelta(Dm_Main.Que_RechSession.fieldbyname('SES_ID').AsInteger);
            end;

            if ArrondiA2(Abs(vValue))>0 then
              lbx_resu.Items.Add(sSessionText);
            Active := false;
          end;
        end
        else
        begin
          bIsCashSEssion := Dm_Main.SessionIsCashSession(Dm_Main.Que_RechSession.fieldbyname('SES_ID').AsInteger);
          sSessionText := Dm_Main.Que_RechSession.fieldbyname('SES_NUMERO').AsString;
          if bIsCASHSession then
          begin
            sSessionText := sSessionText + ' [CASH]';
          end;

          lbx_resu.Items.Add(sSessionText);
        end;

        Next;
      end;
    end;
  finally
    Dm_Main.Que_RechSession.Active := false;
    Lab_TitEtat.Visible := false;
    Lab_Etat.Visible := false;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_OuvreClick(Sender: TObject);
begin   
  if OD_Base.Execute then
  begin
    Edt_Base.Text := OD_Base.FileName;
    Nbt_ConnClick(Nbt_Conn);
  end;
end;

procedure TFrm_Main.Nbt_VoirUnTicketClick(Sender: TObject);
var
  Query : TIBOQuery;
  Frm_Ticket : TFrm_Ticket;
begin
  if Edt_Session.Text = '' then
  begin
    MessageDlg('Vous devez fournir un numéro de session', mterror, [mbok], 0);
    Edt_Session.SetFocus();
    Exit;
  end;
  if Chp_VoirUnTicket.Value = 0 then
  begin
    MessageDlg('Vous devez fournir un numéro de ticket', mterror, [mbok], 0);
    Chp_VoirUnTicket.SetFocus();
    Exit;
  end;

  Query  := Dm_Main.Que_Div4;
  if Query.Active then
    Query.Close;
  Query.SQL.Text := 'select ses_id, ses_numero, tke_id '
                  + 'from cshticket join k on k_id = tke_id and k_enabled = 1 '
                  + 'join cshsession join k on k_id = ses_id and k_enabled = 1 on ses_id = tke_sesid '
                  + 'where ses_numero = ' + QuotedStr(Edt_Session.Text) + ' and tke_numero = ' + IntToSTr(Chp_VoirUnTicket.Value) + ';';
  try
    Query.Open();
    if not Query.Eof then
    begin
      Frm_Ticket := TFrm_Ticket.Create(Self);
      try
        Frm_Ticket.InitEcr(Query.FieldByName('ses_numero').AsString, Query.FieldByName('ses_id').AsInteger, '???', Query.FieldByName('tke_id').AsInteger);
        Frm_Ticket.ShowModal();
      finally
        FreeAndNil(Frm_Ticket);
      end;
    end
    else
      MessageDlg('Ticket non trouvé', mterror, [mbok], 0);
  finally
    Query.Close();
  end;
end;

procedure Tfrm_Main.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);
      FileExt := UpperCase(ExtractFileExt(FileName));
      if FileExt = '.IB' then
      begin
        Edt_Base.Text := FileName;
        Nbt_ConnClick(Nbt_Conn);
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

end.
