unit CNRMain_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, DB, IBODataset, IB_Components,
  StrUtils;

type
  Tfrm_CNRMain = class(TForm)
    Pan_Top: TPanel;
    Pan_Client: TPanel;
    Gbx_DbList: TGroupBox;
    Gbx_Logs: TGroupBox;
    pb_Sub: TProgressBar;
    pb_Main: TProgressBar;
    Pan_lstClient: TPanel;
    Pan_LogsClient: TPanel;
    Pan_lstLeft: TPanel;
    Nbt_Ajouter: TBitBtn;
    Nbt_Supprimer: TBitBtn;
    Lbx_lstDb: TListBox;
    mmLogs: TMemo;
    Nbt_Executer: TBitBtn;
    OD_DbFile: TOpenDialog;
    IBODatabase: TIBODatabase;
    Que_Tmp: TIBOQuery;
    Que_GetTypeMailList: TIBOQuery;
    Que_GetResaLignes: TIBOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_AjouterClick(Sender: TObject);
    procedure Nbt_SupprimerClick(Sender: TObject);
    procedure Nbt_ExecuterClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    APPPATH : String;
    Procedure DoTraitement;
    procedure DoByNet(MTY_ID : Integer);
    procedure DoByBrut(MTY_ID : Integer);
    procedure AddToMemo(sText : String);
  end;

var
  frm_CNRMain: Tfrm_CNRMain;

implementation

{$R *.dfm}

procedure Tfrm_CNRMain.AddToMemo(sText: String);
begin
  while mmLogs.Lines.Count > 1000 do
    mmLogs.Lines.Delete(0);

  mmLogs.Lines.Add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] -> ', Now) + sText);
end;

procedure Tfrm_CNRMain.DoByBrut(MTY_ID: Integer);
var
  iPosPrixBrut : Integer;
  iPosRemise : Integer;
  iPosSlash : Integer;
  iPosPerCent : Integer;
  sTmpVal, sTmpRem : String;
  cVal, cRem : Currency;
begin
  With Que_GetResaLignes do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PMTYID').AsInteger := MTY_ID;
    Open;
    Last;
    First;
  end; // with

  while not Que_GetResaLignes.Eof do
  begin
    try
    iPosPrixBrut := Pos(':',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString);
    iPosSlash    := PosEx('/',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString, iPosPrixBrut + 1);
    iPosRemise   := PosEx(':',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString, iPosSlash + 1);
    iPosPerCent  := PosEx('%',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString, iPosRemise + 1);
    if iPosPrixBrut > 0 then
    begin
      if iPosSlash <= 0 then
        iPosSlash := Length(Que_GetResaLignes.FieldByName('RSL_COMENT').AsString) - (iPosPrixBrut + 1)
      else
        iPosSlash := iPosSlash -1;

      sTmpVal := Trim(Copy(Que_GetResaLignes.FieldByName('RSL_COMENT').AsString,iPosPrixBrut + 1, iPosSlash - (iPosPrixBrut + 1)));
      sTmpVal := StringReplace(sTmpVal,'.',DecimalSeparator,[rfReplaceAll]);
      cVal := StrToCurr(sTmpVal);
      cRem := 0;
      if iPosRemise > iPosPrixBrut then
      begin
        sTmpRem := Trim(Copy(Que_GetResaLignes.FieldByName('RSL_COMENT').AsString,iPosRemise + 1, (iPosPerCent) - (iPosRemise + 1)));
        sTmpRem := StringReplace(sTmpRem,'.',DecimalSeparator,[rfReplaceAll]);
        cRem := cVal * StrToCurr(sTmpRem) / 100;
      end;

      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update LOCRESERVATIONLIGNE set');
        SQL.Add('  RSL_PXNET = :PPXNET');
        SQL.Add('Where RSL_ID = :PRSLID');
        ParamCheck := True;
        ParamByName('PPXNET').AsCurrency := cVal - cRem;
        ParamByName('PRSLID').AsInteger := Que_GetResaLignes.FieldByName('RSL_ID').AsInteger;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('Execute Procedure PR_UPDATEK(:PID,0)');
        ParamCheck := True;
        ParamByName('PID').AsInteger := Que_GetResaLignes.FieldByName('RSL_ID').AsInteger;
        ExecSQL;
      end;
    end; // if
    Except on E:Exception do
      AddToMemo('DoByNet -> ' + E.Message);
    end;
    Que_GetResaLignes.Next;
    pb_Sub.Position := Que_GetResaLignes.RecNo * 100 Div Que_GetResaLignes.RecordCount;
    Application.ProcessMessages;
  end; // while
end;

procedure Tfrm_CNRMain.DoByNet(MTY_ID: Integer);
var
  iPosPrixNet : Integer;
  iPosSlash : Integer;
  sTmpVal : String;
begin
  With Que_GetResaLignes do
  begin
    Close;
    ParamCheck := True;
    ParamByName('PMTYID').AsInteger := MTY_ID;
    Open;
    Last;
    First;
  end; // with

  while not Que_GetResaLignes.Eof do
  begin
    try
    iPosPrixNet := Pos(':',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString);
    iPosSlash   := Pos('/',Que_GetResaLignes.FieldByName('RSL_COMENT').AsString);

    if iPosPrixNet > 0 then
    begin
      if iPosSlash <= 0 then
        iPosSlash := Length(Que_GetResaLignes.FieldByName('RSL_COMENT').AsString) - (iPosPrixNet + 1)
      else
        iPosSlash := iPosSlash -1;

      sTmpVal := Trim(Copy(Que_GetResaLignes.FieldByName('RSL_COMENT').AsString,iPosPrixNet + 1, iPosSlash - (iPosPrixNet + 1)));
      sTmpVal := StringReplace(sTmpVal,'.',DecimalSeparator,[rfReplaceAll]);

      With Que_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Update LOCRESERVATIONLIGNE set');
        SQL.Add('  RSL_PXNET = :PPXNET');
        SQL.Add('Where RSL_ID = :PRSLID');
        ParamCheck := True;
        ParamByName('PPXNET').AsCurrency := StrToCurr(sTmpVal);
        ParamByName('PRSLID').AsInteger := Que_GetResaLignes.FieldByName('RSL_ID').AsInteger;
        ExecSQL;

        Close;
        SQL.Clear;
        SQL.Add('Execute Procedure PR_UPDATEK(:PID,0)');
        ParamCheck := True;
        ParamByName('PID').AsInteger := Que_GetResaLignes.FieldByName('RSL_ID').AsInteger;
        ExecSQL;
      end;
    end; // if
    Except on E:Exception do
      AddToMemo('DoByNet -> ' + E.Message);
    end;
    Que_GetResaLignes.Next;
    pb_Sub.Position := Que_GetResaLignes.RecNo * 100 Div Que_GetResaLignes.RecordCount;
    Application.ProcessMessages;
  end; // while
end;

procedure Tfrm_CNRMain.DoTraitement;
var
  i : Integer;
begin

  for i := 0 to Lbx_lstDb.Count - 1 do
  begin
    try
      // connection à la base de données
      AddToMemo('Connexion à : ' + Lbx_lstDb.Items[i]);
      Try
        IBODatabase.Disconnect;
        IBODatabase.DatabaseName := Lbx_lstDb.Items[i];
        IBODatabase.Connect;
      Except on E:Exception do
        raise Exception.Create('Erreur de connexion à la base de données : ' + E.Message);
      End;

      // Récupération des centrales disponible
      With Que_GetTypeMailList do
      begin
        Close;
        Open;
        First;

        AddToMemo('Centrale : ' + FieldByName('MTY_NOM').AsString);
        case AnsiIndexStr(FieldByName('MTY_NOM').AsString,['RESERVATION TWINNER','RESERVATION INTERSPORT','RESERVATION SKIMIUM',
                                             'RESERVATION SPORT 2000','RESERVATION GENERIQUE - 1',
                                             'RESERVATION GENERIQUE - 2','RESERVATION GENERIQUE - 3']) of
          0,3,4,5,6: DoByNet(FieldByName('MTY_ID').AsInteger); // Twinner, sport 2000, générique 1-3
          1,2:       DoByBrut(FieldByName('MTY_ID').AsInteger); // Intersport Skimium

        end; // case
      end; // with
    Except on E:Exception do
      AddToMemo(E.Message);
    end;
    pb_Main.Position := (i + 1) * 100 Div Lbx_lstDb.Count;
    Application.ProcessMessages;
  end; // for i
  AddToMemo('Traitement terminé');
end;

procedure Tfrm_CNRMain.FormCreate(Sender: TObject);
begin
  APPPATH := ExtractFilePath(Application.ExeName);

  if FileExists(APPPATH + 'CNRList.txt') then
    Lbx_lstDb.Items.LoadFromFile(APPPATH + 'CNRList.txt');
end;

procedure Tfrm_CNRMain.Nbt_AjouterClick(Sender: TObject);
begin
  if OD_DbFile.Execute then
  begin
    Lbx_lstDb.Items.Add(OD_DbFile.FileName);
    Lbx_lstDb.Items.SaveToFile(APPPATH + 'CNRList.txt');
  end;
end;

procedure Tfrm_CNRMain.Nbt_ExecuterClick(Sender: TObject);
begin
  if Lbx_lstDb.Count > 0 then
    DoTraitement;
end;

procedure Tfrm_CNRMain.Nbt_SupprimerClick(Sender: TObject);
begin
  if Lbx_lstDb.ItemIndex <> -1 then
    Lbx_lstDb.DeleteSelected; 
end;

end.
