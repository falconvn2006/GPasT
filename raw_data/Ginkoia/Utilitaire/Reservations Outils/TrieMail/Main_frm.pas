unit Main_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Grids, DBGrids, ExtCtrls, CategoryButtons, MidasLib,
  DB, DBClient, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxCheckBox, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGrid, ActnList, uImap4, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkSide, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin, dxSkinSilver, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinscxPCPainter, ComCtrls;

type

  Tfrm_Main = class(TForm)
    CategoryButtons1: TCategoryButtons;
    GridPanel1: TGridPanel;
    Memo1: TMemo;
    Ds_MailList: TDataSource;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Boite: TcxGridDBColumn;
    cxGrid1DBTableView1Host: TcxGridDBColumn;
    cxGrid1DBTableView1UserName: TcxGridDBColumn;
    cxGrid1DBTableView1Password: TcxGridDBColumn;
    cxGrid1DBTableView1Type: TcxGridDBColumn;
    cxGrid1DBTableView1Active: TcxGridDBColumn;
    ActLst_Menu: TActionList;
    Ax_NewMailBox: TAction;
    Ax_UpdMailBox: TAction;
    Ax_DelMailBox: TAction;
    Ax_ActiveMailBox: TAction;
    Ax_DoWork: TAction;
    Pan_Bottom: TPanel;
    Lab_Status: TLabel;
    ProgressBar1: TProgressBar;
    Tim_Auto: TTimer;
    cxGrid1DBTableView1DeleteMail: TcxGridDBColumn;
    cds_MailList: TClientDataSet;
    cds_MailListBoite: TStringField;
    cds_MailListHost: TStringField;
    cds_MailListUserName: TStringField;
    cds_MailListPassword: TStringField;
    cds_MailListType: TIntegerField;
    cds_MailListActive: TIntegerField;
    cds_MailListDeleteMail: TIntegerField;
    cxGrid1DBTableView1MagsAExclure: TcxGridDBColumn;
    cds_MailListMagsAExclure: TStringField;
    procedure Ax_NewMailBoxExecute(Sender: TObject);
    procedure Ax_UpdMailBoxExecute(Sender: TObject);
    procedure Ax_DelMailBoxExecute(Sender: TObject);
    procedure Ax_ActiveMailBoxExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ax_DoWorkExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Tim_AutoTimer(Sender: TObject);
    procedure cds_MailListTypeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Déclarations privées }
    FWorkInProgress : Boolean;
    FAPPPATH : String;
    FLOGFILE : String;

    procedure DoWork();

    procedure AddToMemo(AText : String);
  public
    { Déclarations publiques }
  end;

const
  CFILESAVE = 'cfg.xml';
  CISWORDDETECTMAX = 5;
var
  frm_Main: Tfrm_Main;

  TBISWORDDETECT : Array [1..CISWORDDETECTMAX] of String =
                  (
                   'Mail CILEA de confirmation de réservation Magasin',
                   '?iso-8859-15?Q?Mail_CILEA_de_confirmation_de_r=E9servation_Magasin',
                   'Mail CILEA de confirmation de réservation Magasin SysTo',
                   '?iso-8859-15?Q?Mail_de_confirmation_de_r=E9servation_Magasin_SysTO',{,
                   'Mail de confirmation de réservation Magasin SysTO'} // Les mails avec ce format n'ont pas toutes les informations
                   'Mail SKILOU de confirmation de réservation Magasin'
                  );


implementation

uses CfgMail_frm;

{$R *.dfm}

procedure Tfrm_Main.AddToMemo(AText: String);
begin
  Memo1.Lines.Add(Formatdatetime('[DD/MM/YYYY hh:mm:ss] ',Now) + AText);
  Application.ProcessMessages;
end;

procedure Tfrm_Main.Ax_ActiveMailBoxExecute(Sender: TObject);
begin
  if FWorkInProgress then
    Exit;

  if cds_MailList.RecordCount > 0 then
  begin
    cds_MailList.Edit;
    if cds_MailList.FieldByName('Active').AsInteger = 0 then
      cds_MailList.FieldByName('Active').AsInteger := 1
    else
      cds_MailList.FieldByName('Active').AsInteger := 0;
    cds_MailList.Post;
  end;

  cds_MailList.SaveToFile(FAPPPATH + CFILESAVE,dfXML);
end;

procedure Tfrm_Main.Ax_DelMailBoxExecute(Sender: TObject);
begin
  if FWorkInProgress then
    Exit;

  if cds_MailList.RecordCount > 0 then
    if MessageDlg(Format('Etes vous sûr de vouloir supprimer cette boite : %s',[cds_MailList.FieldByName('Boite').AsString]),mtConfirmation,[mbYes,mbNo],0) = mrYes then
      cds_MailList.Delete;

  cds_MailList.SaveToFile(FAPPPATH + CFILESAVE,dfXML);
end;

procedure Tfrm_Main.Ax_DoWorkExecute(Sender: TObject);
begin
  if FWorkInProgress then
    Exit;

  FWorkInProgress := True;
  Memo1.Clear;
  try
    DoWork;
  finally
    FWorkInProgress := False;
    Memo1.Lines.SaveToFile(FLOGFILE + FormatDateTime('YYYYMMDDhhmmsszzz',Now) + '.txt');
  end;
end;

procedure Tfrm_Main.Ax_NewMailBoxExecute(Sender: TObject);
begin
  if FWorkInProgress then
    Exit;

  With Tfrm_CfgMail.Create(Self) do
  try
    if ShowModal = mrOk then
    begin
      cds_MailList.Append;
      cds_MailList.FieldByName('Boite').AsString    := Boite;
      cds_MailList.FieldByName('Host').AsString     := Host;
      cds_MailList.FieldByName('UserName').AsString := User;
      cds_MailList.fieldByName('Password').AsString := Pwd;
      cds_MailList.FieldByName('Type').AsInteger    := TypeMail;
      cds_MailList.FieldByName('Active').AsInteger  := 1;
      cds_MailList.FieldByName('DeleteMail').AsInteger := DelMail;
      cds_MailList.FieldByName('MagsAExclure').AsString := MagsAExclure;
      cds_MailList.Post;

      cds_MailList.SaveToFile(FAPPPATH + CFILESAVE,dfXML);
    end;
  finally
    Release;
  end;
end;

procedure Tfrm_Main.Ax_UpdMailBoxExecute(Sender: TObject);
begin
  if FWorkInProgress then
    Exit;

  With Tfrm_CfgMail.Create(Self) do
  try
    Boite    := cds_MailList.FieldByName('Boite').AsString;
    Host     := cds_MailList.FieldByName('Host').AsString;
    User     := cds_MailList.FieldByName('UserName').AsString;
    Pwd      := cds_MailList.fieldByName('Password').AsString;
    TypeMail := cds_MailList.FieldByName('Type').AsInteger;
    DelMail  := cds_MailList.FieldByName('DeleteMail').AsInteger;
    MagsAExclure := cds_MailList.FieldByName('MagsAExclure').AsString;

    if ShowModal = mrOk then
    begin
      cds_MailList.Edit;
      cds_MailList.FieldByName('Boite').AsString       := Boite;
      cds_MailList.FieldByName('Host').AsString        := Host;
      cds_MailList.FieldByName('UserName').AsString    := User;
      cds_MailList.fieldByName('Password').AsString    := Pwd;
      cds_MailList.FieldByName('Type').AsInteger       := TypeMail;
      cds_MailList.FieldByName('Active').AsInteger     := 1;
      cds_MailList.FieldByName('DeleteMail').AsInteger := DelMail;
      cds_MailList.FieldByName('MagsAExclure').AsString := MagsAExclure;
      cds_MailList.Post;
    end;

    cds_MailList.SaveToFile(FAPPPATH + CFILESAVE,dfXML);

  finally
    Release;
  end;
end;

procedure Tfrm_Main.cds_MailListTypeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  case Sender.AsInteger of
    0: Text := 'Générique (Skimium, SP2K, TWinner, GEN1, etc)';
    1: Text := 'Intersport';
  end;
end;

procedure Tfrm_Main.cxGrid1DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  Ax_UpdMailBoxExecute(Self);
end;

procedure Tfrm_Main.DoWork();
var
  IMAP4               : IMAP4Class;
  lstMailBox, lstTmp  : TStringList;
  i, j                : Integer;
  sDirMailBox, sTmp   : String;
  bFound              : Boolean;
  lstMagsAExclure     : TStringList;
  bMagExclu           : Boolean;
begin
  try
    cds_MailList.First();
    while not cds_MailList.Eof do
    begin
      try
        if cds_MailList.FieldByName('Active').AsInteger = 1 then
        begin
          AddToMemo(Format('Traitement de %s', [cds_MailList.FieldByName('Boite').AsString]));

          IMAP4 := IMAP4Class.Create(cds_MailList.FieldByName('Host').AsString,
                                     cds_MailList.FieldByName('UserName').AsString,
                                     cds_MailList.FieldByName('Password').AsString,
                                     993,
                                     True);
          IMAP4.LabStatus := Lab_Status;
          IMAP4.PGStatus  := ProgressBar1;

          lstMailBox := TStringList.Create();
          lstTmp := TStringList.Create();
          lstMagsAExclure := TStringList.Create();
          try
            IMAP4.Connect();
            AddToMemo('Connexion Ok');
            // Récupération de la liste des répetoires de la boite mail
            lstMailBox := IMAP4.MailboxList;

            // Récupération de la liste des mails
            IMAP4.SelectMailBox('INBOX');
            Lab_Status.Caption := 'Récupération de la liste des mails';
            AddToMemo(Format('Récupération de la liste des mails : %d', [IMAP4.CurrentMailBoxcount]));

            // Récupération de la liste des magasins a exclure
            lstMagsAExclure.Text := StringReplace(cds_MailList.FieldByName('MagsAExclure').AsString, ';', #13#10 ,[rfReplaceAll]);

            case cds_MailList.FieldByName('Type').AsInteger of
              0: begin // Générique
                // Récupération de l'entête des mails
                IMAP4.LoadAllMailBoxMsgHeader();
                AddToMemo(Format('Transfert des mails : %d à transférer', [IMAP4.MsgList.Count]));
                for i := IMAP4.MsgList.Count downto 1 do
                begin
                  bMagExclu := False;

                  if (Pos('RESERVATION GINKOIA', Trim(IMAP4.MsgList[i - 1].Subject)) = 1) or
                     (Pos('RESERVATION GENERIQUE', Trim(IMAP4.MsgList[i - 1].Subject)) = 1) then
                  begin
                    // récupération de l'identifiant du client
                    lstTmp.Text := StringReplace(Trim(IMAP4.MsgList[i - 1].Subject), ' ', #13#10 ,[rfReplaceAll]);
                    sDirMailBox := 'Reservation/' + lstTmp[2];

                    // Vérifie si l'identifiant n'est pas exclu
                    if (lstMagsAExclure.Count > 0) and (lstMagsAExclure.IndexOf(lstTmp[2]) > -1) then
                      bMagExclu := True;
                  end
                  else begin
                    // Si le mail n'est pas dans le périmettre de recherche alors on le mets dans les archives
                    sDirMailBox := 'Archive';
                  end;

                  if (not bMagExclu) then
                  begin
                    // Création du répertoire si nécessaire
                    if lstMailBox.IndexOf(sDirMailBox) = -1 then
                    begin
                      IMAP4.CreateMailBox(sDirMailBox);
                      lstMailBox.Add(sDirMailBox);
                    end;

                    // Déplacer le mail
                    case cds_MailList.FieldByName('DeleteMail').AsInteger of
                      0: IMAP4.CopyMsg(i, sDirMailBox);
                      1: IMAP4.MoveMsg(i, sDirMailBox);
                    end;

                    Lab_Status.Caption    := Format('Mail transféré %d/%d', [(IMAP4.MsgList.Count - i), (IMAP4.MsgList.Count)]);
                    ProgressBar1.Position := (IMAP4.MsgList.Count - (i + 1)) * 100 div (IMAP4.MsgList.Count);
                    Application.ProcessMessages();
                  end;
                end;
                // Permet de faire la suppression des mails d'un coups (ils ont été flaggés lors du déplacement=
                IMAP4.ValidMoveMsg();
              end;
              1: begin // Intersport
                // Récupération des mails
                IMAP4.LoadAllMailBoxMsg();
                AddToMemo(Format('Transfert des mails : %d à transférer', [IMAP4.MsgList.Count]));
                for i := IMAP4.MsgList.Count downto 1 do
                begin
                  bMagExclu := False;
                  bFound := False;
                  for j := 1 to CISWORDDETECTMAX do
                  begin
                    if (Pos(TBISWORDDETECT[j], IMAP4.MsgList[i - 1].Subject) <> 0) then
                      bFound := True;
                  end;

                  if bFound then
                  begin
                    // Récupération de l'identifiant du client
                    sTmp := StringReplace(Trim(IMAP4.MsgList[i - 1].Body.Text), #13#10, '', [rfReplaceAll]);
                    lstTmp.Text := StringReplace(sTmp, ';', #13#10, [rfReplaceAll]);
                    sDirMailBox := 'Reservation/' + lstTmp[10];

                    // Vérifie si l'identifiant n'est pas exclu
                    if (lstMagsAExclure.Count > 0) and (lstMagsAExclure.IndexOf(lstTmp[10]) > -1) then
                      bMagExclu := True;
                  end
                  else begin
                    // Si le mail n'est pas dans le périmettre de recherche alors on le mets dans les archives
                    sDirMailBox := 'Archive';
                  end;

                  if (not bMagExclu) then
                  begin
                    // Création du répertoire si nécessaire
                    if lstMailBox.IndexOf(sDirMailBox) = -1 then
                    begin
                      IMAP4.CreateMailBox(sDirMailBox);
                      lstMailBox.Add(sDirMailBox);
                    end;

                    // Déplacer le mail
                    case cds_MailList.FieldByName('DeleteMail').AsInteger of
                      0: IMAP4.CopyMsg(i, sDirMailBox);
                      1: IMAP4.MoveMsg(i, sDirMailBox);
                    end;

                    Lab_Status.Caption    := Format('Mail transféré %d/%d', [(IMAP4.MsgList.Count - i), (IMAP4.MsgList.Count)]);
                    ProgressBar1.Position := (IMAP4.MsgList.Count - (i + 1)) * 100 div (IMAP4.MsgList.Count);
                    Application.ProcessMessages();
                  end;
                end; // for
                // Permet de faire la suppression des mails d'un coups (ils ont été flaggés lors du déplacement=
                IMAP4.ValidMoveMsg();
              end;
            end;

            IMAP4.Disconnect();
            AddToMemo('Fin du traitement');
          finally
            lstMagsAExclure.Free();
            lstTmp.Free();
            lstMailBox.Free();
            IMAP4.Free();
          end;
        end;
      except on E: Exception do
        AddToMemo(Format('Erreur lors du traitement de %s.' + sLineBreak
          + ' - %s'#160': %s.',
          [cds_MailList.FieldByName('Boite').AsString, E.ClassName, E.Message]));
      end;

      cds_MailList.Next();
    end;
  except on E: Exception do
    AddToMemo(Format('%s'#160': %s.', [E.ClassName, E.Message]));
  end;
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Canclose := not FWorkInProgress;
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  FWorkInProgress := False;
  FAPPPATH := ExtractFilePath(Application.ExeName);
  FLOGFILE := FAPPPATH + FormatDateTime('YYYY\MM\DD\',Now);
  ForceDirectories(FLOGFILE);

  if Not cds_MailList.Active then
    cds_MailList.Open;

  if FileExists(FAPPPATH + CFILESAVE) then
    cds_MailList.LoadFromFile(FAPPPATH + CFILESAVE);

  if ParamCount > 0 then
    if UpperCase(ParamStr(1)) = 'AUTO' then
      Tim_Auto.Enabled := True;
end;

procedure Tfrm_Main.Tim_AutoTimer(Sender: TObject);
begin
  Tim_Auto.Enabled := False;
  Try
    Ax_DoWorkExecute(Self);
  Finally
    Application.Terminate;
  End;
end;

end.
