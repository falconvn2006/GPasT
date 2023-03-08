unit Main_Frm;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, IBODataset,
  IB_Components, IB_Access;

type
  TFrm_Main = class(TForm)
    Pan_Haut: TPanel;
    Pgc_ImpExp: TPageControl;
    Tab_Import: TTabSheet;
    Tab_Export: TTabSheet;
    Label1: TLabel;
    EDataBase: TEdit;
    Nbt_OpenConn: TSpeedButton;
    Nbt_Quit: TBitBtn;
    Nbt_Conn: TSpeedButton;
    Lab_Version: TLabel;
    Panel1: TPanel;
    Ds_LstInvent: TDataSource;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    LstSelInvent: TListBox;
    Label2: TLabel;
    ERech: TEdit;
    Label3: TLabel;
    Nbt_Export: TBitBtn;
    PgBar: TProgressBar;
    Lab_EnCours: TLabel;
    Panel5: TPanel;
    DBGrid2: TDBGrid;
    Nbt_Import: TBitBtn;
    Lab_EnCours2: TLabel;
    PgBar2: TProgressBar;
    Tab_Relation: TTabSheet;
    Panel6: TPanel;
    Label4: TLabel;
    EReperID: TEdit;
    Nbt_SelRep: TSpeedButton;
    Nbt_Exec12_1: TBitBtn;
    Panel7: TPanel;
    DBGrid3: TDBGrid;
    Panel8: TPanel;
    Panel9: TPanel;
    LstSelRelation: TListBox;
    Label5: TLabel;
    ERechRelation: TEdit;
    Label6: TLabel;
    Lab_Encours3: TLabel;
    PgBar3: TProgressBar;
    Tab_Finalisation: TTabSheet;
    Panel10: TPanel;
    PgBar4: TProgressBar;
    Lab_EnCours4: TLabel;
    BitBtn1: TBitBtn;
    Label7: TLabel;
    ERechFinal: TEdit;
    Label8: TLabel;
    Panel11: TPanel;
    DBGrid4: TDBGrid;
    Panel12: TPanel;
    Panel13: TPanel;
    LstSelFinal: TListBox;
    procedure Nbt_QuitClick(Sender: TObject);
    procedure Nbt_OpenConnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_ConnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ERechKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Nbt_ExportClick(Sender: TObject);
    procedure Nbt_ImportClick(Sender: TObject);
    procedure Nbt_Exec12_1Click(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ERechRelationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure Nbt_SelRepClick(Sender: TObject);
    procedure ERechFinalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid4DblClick(Sender: TObject);
    procedure DBGrid4DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    DelaiAffiche: DWord;
    LstInvID: TStringList;
    LstRelation: TStringList;
    LstFinal: TStringList;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
    procedure PermuteSelInvent;
    procedure PermuteSelRelation;
    procedure PermuteSelFinal;
    procedure OpenDatabase;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  Main_Dm, uVersion, FileCtrl, CorrespondMag_Frm;

{$R *.dfm}

procedure WriteStreamString(AStream: TStream; ALigne: string);
var
  sLigne: AnsiString;
begin
  sLigne := AnsiString(ALigne + #13#10);
  AStream.Write(sLigne[1],Length(sLigne));
end;

procedure TFrm_Main.BitBtn1Click(Sender: TObject);
var
  iInvId: integer;
  iMagId: integer;
  iArtId: integer;
  iTgfId: integer;
  iCouId: integer;
  iStcId: integer;
  iUpdId: integer;
  Que_Det: TIBOQuery;
  Que_Stk: TIBOQuery;
  Que_Upd: TIBOQuery;
  i: integer;
  Delai: DWord;
  sInfo: string;
  nb: integer;
  sLigne: string;
  sInvId: string;
  sMagId: string;
begin
  if Lstfinal.Count=0 then
  begin
    MessageDlg('Aucun inventaire sélectionné !', mterror, [mbok], 0);
    exit;
  end;

  Lab_EnCours4.Caption := '';
  Lab_EnCours4.Visible := true;
  PgBar4.Position := 0;
  PgBar4.Visible := true;
  Delai := GetTickCount;
  Que_Det := TIBOQuery.Create(Self);
  Que_Stk := TIBOQuery.Create(Self);
  Que_Upd := TIBOQuery.Create(Self);
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Que_Det.IB_Connection := Dm_Main.Database;
    Que_Det.IB_Transaction := Dm_Main.Transaction;
    Que_Stk.IB_Connection := Dm_Main.Database;
    Que_Stk.IB_Transaction := Dm_Main.Transaction;

    Que_Upd.IB_Connection := Dm_Main.Database;
    Que_Upd.IB_Transaction := Dm_Main.TransacRel;

    with Que_Stk do
    begin
      SQL.Clear;
      SQL.Add('select STC_ID from AGRSTOCKCOUR');
      SQL.Add('where STC_ARTID=:ARTID');
      SQL.Add('  and STC_MAGID=:MAGID');
      SQL.Add('  and STC_TGFID=:TGFID');
      SQL.Add('  and STC_COUID=:COUID');
    end;

    for i := 1 to LstFinal.Count do
    begin
      Lab_EnCours4.Caption := 'Inventaire '+inttostr(i);
      Application.ProcessMessages;
      sLigne := LstFinal[i-1];
      sInvId := Copy(sLigne, 1, Pos('|', sLigne)-1);
      sMagId := Copy(sLigne, Pos('|', sLigne)+1, Length(sLigne));

      iInvId := StrToInt(sInvId);
      iMagId := StrToInt(sMagId);

      // INVENTETEL
      Nb := 0;
      sInfo := 'Inventaire '+inttostr(i)+' INVENTETEL 0';
      Lab_EnCours4.Caption := sInfo;
      Application.ProcessMessages;
      with Que_Det do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select INL_ID, INL_ARTID, INL_TGFID, INL_COUID, INL_STCID from Inventetel');
        SQL.Add('where INL_INVID='+inttostr(iInvId));
      end;
      Que_Det.Open;
      Que_Det.First;
      while not(Que_Det.Eof) do
      begin
        Inc(nb);
        sInfo := 'Inventaire '+inttostr(i)+' INVENTETEL '+inttostr(nb);
        if Que_Det.FieldByName('INL_STCID').AsInteger<>0 then
        begin
          iUpdId := Que_Det.FieldByName('INL_ID').AsInteger;
          // recherche ligne de stock
          iArtId := Que_Det.FieldByName('INL_ARTID').AsInteger;
          iTgfId := Que_Det.FieldByName('INL_TGFID').AsInteger;
          iCouId := Que_Det.FieldByName('INL_COUID').AsInteger;
          with Que_Stk do
          begin
            iStcId := 0;
            Close;
            ParamByName('ARTID').AsInteger := iArtId;
            ParamByName('MAGID').AsInteger := iMagId;
            ParamByName('TGFID').AsInteger := iTgfId;
            ParamByName('COUID').AsInteger := iCouId;
            Open;
            if RecordCount>0 then
              iStcId := FieldByName('STC_ID').AsInteger;

            Close;
          end;
          //Mise à jour
          with Que_Upd do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Update INVENTETEL SET');
            SQL.Add('  INL_STCID='+inttostr(iStcId));
            SQL.Add(' where INL_ID='+inttostr(iUpdId));
          end;
          if not(Dm_Main.TransacRel.InTransaction) then
            Dm_Main.TransacRel.StartTransaction;
          try
            Que_Upd.ExecSQL;
            Que_Upd.Close;
            Dm_Main.TransacRel.Commit;
          except
            Dm_Main.TransacRel.Rollback;
            raise;
          end;
        end;
        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours4.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Det.Next;
      end;

      // INVIMGSTK
      Nb := 0;
      sInfo := 'Inventaire '+inttostr(i)+' INVIMGSTK 0';
      Lab_EnCours4.Caption := sInfo;
      Application.ProcessMessages;
      with Que_Det do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select ISI_ARTID, ISI_TGFID, ISI_COUID from INVIMGSTK');
        SQL.Add('where ISI_INVID='+inttostr(iInvId));
      end;
      Que_Det.Open;
      Que_Det.First;
      while not(Que_Det.Eof) do
      begin
        Inc(nb);
        sInfo := 'Inventaire '+inttostr(i)+' INVIMGSTK '+inttostr(nb);
        // recherche ligne de stock
        iArtId := Que_Det.FieldByName('ISI_ARTID').AsInteger;
        iTgfId := Que_Det.FieldByName('ISI_TGFID').AsInteger;
        iCouId := Que_Det.FieldByName('ISI_COUID').AsInteger;
        with Que_Stk do
        begin
          iStcId := 0;
          Close;
          ParamByName('ARTID').AsInteger := iArtId;
          ParamByName('MAGID').AsInteger := iMagId;
          ParamByName('TGFID').AsInteger := iTgfId;
          ParamByName('COUID').AsInteger := iCouId;
          Open;
          if RecordCount>0 then
            iStcId := FieldByName('STC_ID').AsInteger;

          Close;
        end;
        //Mise à jour
        with Que_Upd do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update INVIMGSTK SET');
          SQL.Add('  ISI_STCID='+inttostr(iStcId));
          SQL.Add(' where ISI_ARTID='+inttostr(iArtId));
          SQL.Add('   and ISI_TGFID='+inttostr(iTgfId));
          SQL.Add('   and ISI_COUID='+inttostr(iCouId));
        end;
        if not(Dm_Main.TransacRel.InTransaction) then
          Dm_Main.TransacRel.StartTransaction;
        try
          Que_Upd.ExecSQL;
          Que_Upd.Close;
          Dm_Main.TransacRel.Commit;
        except
          Dm_Main.TransacRel.Rollback;
          raise;
        end;
        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours4.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Det.Next;
      end;

      // INVSESSIONL
      Nb := 0;
      sInfo := 'Inventaire '+inttostr(i)+' INVSESSIONL 0';
      Lab_EnCours4.Caption := sInfo;
      Application.ProcessMessages;
      with Que_Det do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select SAL_ID, SAL_ARTID, SAL_TGFID, SAL_COUID from INVSESSIONL');
        SQL.Add('  join Invsession on SAI_ID=SAL_SAIID');
        SQL.Add('where SAI_INVID='+inttostr(iInvId));
      end;
      Que_Det.Open;
      Que_Det.First;
      while not(Que_Det.Eof) do
      begin
        Inc(nb);
        sInfo := 'Inventaire '+inttostr(i)+' INVSESSIONL '+inttostr(nb);
        iUpdId := Que_Det.FieldByName('SAL_ID').AsInteger;
        // recherche ligne de stock
        iArtId := Que_Det.FieldByName('SAL_ARTID').AsInteger;
        iTgfId := Que_Det.FieldByName('SAL_TGFID').AsInteger;
        iCouId := Que_Det.FieldByName('SAL_COUID').AsInteger;
        with Que_Stk do
        begin
          iStcId := 0;
          Close;
          ParamByName('ARTID').AsInteger := iArtId;
          ParamByName('MAGID').AsInteger := iMagId;
          ParamByName('TGFID').AsInteger := iTgfId;
          ParamByName('COUID').AsInteger := iCouId;
          Open;
          if RecordCount>0 then
            iStcId := FieldByName('STC_ID').AsInteger;

          Close;
        end;
        //Mise à jour
        with Que_Upd do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update INVSESSIONL SET');
          SQL.Add('  SAL_INLID='+inttostr(iStcId));
          SQL.Add(' where SAL_ID='+inttostr(iUpdId));
        end;
        if not(Dm_Main.TransacRel.InTransaction) then
          Dm_Main.TransacRel.StartTransaction;
        try
          Que_Upd.ExecSQL;
          Que_Upd.Close;
          Dm_Main.TransacRel.Commit;
        except
          Dm_Main.TransacRel.Rollback;
          raise;
        end;
        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours4.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Det.Next;
      end;

    end;

    MessageDlg('Processus terminé !', mtInformation, [mbok], 0);
  finally
    Que_Upd.Close;
    FreeAndNil(Que_Upd);
    Que_Stk.Close;
    FreeAndNil(Que_Stk);
    Que_Det.Close;
    FreeAndNil(Que_Det);
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.CMDialogKey(var M: TCMDialogKey);
begin
  if (M.CharCode = VK_RETURN) and (ERech.Focused) then
  begin
    M.Result := 1;
    if (ERech.Text<>'') and Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Locate('INV_CHRONO', ERech.Text, []);
    ERech.SelectAll;
    ERech.SetFocus;
    exit;
  end;
  if (M.CharCode = VK_RETURN) and (ERechRelation.Focused) then
  begin
    M.Result := 1;
    if (ERechRelation.Text<>'') and Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Locate('INV_CHRONO', ERechRelation.Text, []);
    ERechRelation.SelectAll;
    ERechRelation.SetFocus;
    exit;
  end;
  if (M.CharCode = VK_RETURN) and (ERechFinal.Focused) then
  begin
    M.Result := 1;
    if (ERechFinal.Text<>'') and Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Locate('INV_CHRONO', ERechFinal.Text, []);
    ERechFinal.SelectAll;
    ERechFinal.SetFocus;
    exit;
  end;
  inherited;
end;

procedure TFrm_Main.PermuteSelInvent;
var
  sInvId: string;
  sChrono: string;
  LPos: integer;
begin
  if not(Dm_Main.Que_LstInvent.Active) or (Dm_Main.Que_LstInvent.RecordCount=0) then
    exit;

  sInvId  := inttostr(Dm_Main.Que_LstInvent.FieldByName('INV_ID').AsInteger);
  sChrono := Dm_Main.Que_LstInvent.FieldByName('INV_CHRONO').AsString;
  LPos := LstInvID.IndexOf(sInvId);
  if LPos>=0 then
  begin
    // deselection
    LstInvID.Delete(LPos);
    LPos := LstSelInvent.Items.IndexOf(sChrono);
    if LPos>=0 then
      LstSelInvent.Items.Delete(LPos);
  end
  else
  begin
    // selection
    LstInvID.Add(sInvId);
    LPos := LstSelInvent.Items.IndexOf(sChrono);
    if LPos<0 then
      LPos := LstSelInvent.Items.Add(sChrono);
    LstSelInvent.ItemIndex := LPos;
  end;
  DBGrid1.Refresh;
end;

procedure TFrm_Main.PermuteSelRelation;
var
  sInvId: string;
  sChrono: string;
  LPos: integer;
begin
  if not(Dm_Main.Que_LstInvent.Active) or (Dm_Main.Que_LstInvent.RecordCount=0) then
    exit;

  sInvId  := inttostr(Dm_Main.Que_LstInvent.FieldByName('INV_ID').AsInteger);
  sChrono := Dm_Main.Que_LstInvent.FieldByName('INV_CHRONO').AsString;
  LPos := LstRelation.IndexOf(sInvId);
  if LPos>=0 then
  begin
    // deselection
    LstRelation.Delete(LPos);
    LPos := LstSelRelation.Items.IndexOf(sChrono);
    if LPos>=0 then
      LstSelRelation.Items.Delete(LPos);
  end
  else
  begin
    // selection
    LstRelation.Add(sInvId);
    LPos := LstSelRelation.Items.IndexOf(sChrono);
    if LPos<0 then
      LPos := LstSelRelation.Items.Add(sChrono);
    LstSelRelation.ItemIndex := LPos;
  end;
  DBGrid3.Refresh;
end;

procedure TFrm_Main.PermuteSelFinal;
var
  sInvId: string;
  sChrono: string;
  LPos: integer;
begin
  if not(Dm_Main.Que_LstInvent.Active) or (Dm_Main.Que_LstInvent.RecordCount=0) then
    exit;

  sInvId  := inttostr(Dm_Main.Que_LstInvent.FieldByName('INV_ID').AsInteger)+'|'+
              Dm_Main.Que_LstInvent.FieldByName('INV_MAGID').AsString;
  sChrono := Dm_Main.Que_LstInvent.FieldByName('INV_CHRONO').AsString;
  LPos := LstFinal.IndexOf(sInvId);
  if LPos>=0 then
  begin
    // deselection
    LstFinal.Delete(LPos);
    LPos := LstSelFinal.Items.IndexOf(sChrono);
    if LPos>=0 then
      LstSelFinal.Items.Delete(LPos);
  end
  else
  begin
    // selection
    LstFinal.Add(sInvId);
    LPos := LstSelFinal.Items.IndexOf(sChrono);
    if LPos<0 then
      LPos := LstSelFinal.Items.Add(sChrono);
    LstSelFinal.ItemIndex := LPos;
  end;
  DBGrid4.Refresh;
end;

procedure TFrm_Main.OpenDatabase;
var
  sFile: string;
begin
  LstInvID.Clear;
  LstSelInvent.Clear;
  LstRelation.Clear;
  LstSelRelation.Clear;
  LstFinal.Clear;
  LstSelFinal.Clear;
  Lab_Version.Visible := false;
  sFile := EDataBase.Text;
  if (sFile='') or not(FileExists(sFile)) then
  begin
    MessageDlg('Fichier manquant ou introuvable !', mterror, [mbok], 0);
    exit;
  end;
  try
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.DoConnexion(sFile);
      Lab_Version.Caption := 'Ver. '+Dm_Main.GetVersion;
      Lab_Version.Visible := true;
      Dm_Main.Que_LstInvent.Open;
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message, mterror, [mbok], 0);
  end;
  Pgc_ImpExp.Visible := Dm_Main.Database.Connected;
end;

procedure TFrm_Main.DBGrid1DblClick(Sender: TObject);
begin
  PermuteSelInvent;
end;

procedure TFrm_Main.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  chBrush, chFont: TColor;
  savBrush, savFont: TColor;
begin
  with TDBGrid(Sender).Canvas do
  begin
    if (gdSelected in State) or (gdFocused in State) then
    begin
      chFont := clWhite;
      if (TDBGrid(Sender).DataSource.DataSet.Active)
        and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0)
        and (LstInvID.IndexOf(TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_ID').AsString)>=0) then
        chBrush := Rgb(0, 153, 0)   // vert
      else
        chBrush := Rgb(153, 0, 0);  // rouge
    end
    else
    begin
      ChFont := clBlack;
      if (TDBGrid(Sender).DataSource.DataSet.Active)
        and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0)
        and (LstInvID.IndexOf(TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_ID').AsString)>=0) then
        chBrush := Rgb(153, 255, 153)  // vert
      else
        chBrush := Rgb(255, 153, 153); // rouge
    end;

    savBrush := Brush.Color;
    savFont := Font.Color;
    Brush.Color := chBrush;
    Font.Color := chFont;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Brush.Color := savBrush;
    Font.Color := savFont;
  end;
end;

procedure TFrm_Main.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F9 then
  begin
    PermuteSelInvent;
    if Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Next;
  end;
end;

procedure TFrm_Main.DBGrid3DblClick(Sender: TObject);
begin
  PermuteSelRelation;
end;

procedure TFrm_Main.DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  chBrush, chFont: TColor;
  savBrush, savFont: TColor;
begin
  with TDBGrid(Sender).Canvas do
  begin
    if (gdSelected in State) or (gdFocused in State) then
    begin
      chFont := clWhite;
      if (TDBGrid(Sender).DataSource.DataSet.Active)
        and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0)
        and (LstRelation.IndexOf(TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_ID').AsString)>=0) then
        chBrush := Rgb(0, 153, 0)   // vert
      else
        chBrush := Rgb(153, 0, 0);  // rouge
    end
    else
    begin
      ChFont := clBlack;
      if (TDBGrid(Sender).DataSource.DataSet.Active)
        and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0)
        and (LstRelation.IndexOf(TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_ID').AsString)>=0) then
        chBrush := Rgb(153, 255, 153)  // vert
      else
        chBrush := Rgb(255, 153, 153); // rouge
    end;

    savBrush := Brush.Color;
    savFont := Font.Color;
    Brush.Color := chBrush;
    Font.Color := chFont;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Brush.Color := savBrush;
    Font.Color := savFont;
  end;
end;

procedure TFrm_Main.DBGrid3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F9 then
  begin
    PermuteSelRelation;
    if Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Next;
  end;
end;

procedure TFrm_Main.DBGrid4DblClick(Sender: TObject);
begin
  PermuteSelFinal;
end;

procedure TFrm_Main.DBGrid4DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  chBrush, chFont: TColor;
  savBrush, savFont: TColor;
  sCompare: string;
begin
  sCompare := '';
  if (TDBGrid(Sender).DataSource.DataSet.Active)
    and (TDBGrid(Sender).DataSource.DataSet.RecordCount>0) then
    sCompare := TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_ID').AsString+'|'+
                TDBGrid(Sender).DataSource.DataSet.FieldByName('INV_MAGID').AsString;

  with TDBGrid(Sender).Canvas do
  begin
    if (gdSelected in State) or (gdFocused in State) then
    begin
      chFont := clWhite;
      if (sCompare<>'') and (LstFinal.IndexOf(sCompare)>=0) then
        chBrush := Rgb(0, 153, 0)   // vert
      else
        chBrush := Rgb(153, 0, 0);  // rouge
    end
    else
    begin
      ChFont := clBlack;
      if (sCompare<>'') and (LstFinal.IndexOf(sCompare)>=0) then
        chBrush := Rgb(153, 255, 153)  // vert
      else
        chBrush := Rgb(255, 153, 153); // rouge
    end;

    savBrush := Brush.Color;
    savFont := Font.Color;
    Brush.Color := chBrush;
    Font.Color := chFont;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Brush.Color := savBrush;
    Font.Color := savFont;
  end;
end;

procedure TFrm_Main.DBGrid4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_F9 then
  begin
    PermuteSelFinal;
    if Dm_Main.Que_LstInvent.Active then
      Dm_Main.Que_LstInvent.Next;
  end;
end;

procedure TFrm_Main.ERechFinalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F9:
    begin
      PermuteSelfinal;
    end;
    VK_UP:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Prior;
      Key := 0;
    end;
    VK_DOWN:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Next;
      Key := 0;
    end;
  end;
end;

procedure TFrm_Main.ERechKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F9:
    begin
      PermuteSelInvent;
    end;
    VK_UP:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Prior;
      Key := 0;
    end;
    VK_DOWN:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Next;
      Key := 0;
    end;
  end;
end;

procedure TFrm_Main.ERechRelationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F9:
    begin
      PermuteSelRelation;
    end;
    VK_UP:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Prior;
      Key := 0;
    end;
    VK_DOWN:
    begin
      if Dm_Main.Que_LstInvent.Active then
        Dm_Main.Que_LstInvent.Next;
      Key := 0;
    end;
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Dm_Main := TDm_Main.Create(Self);
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  DelaiAffiche := 200;
  Lab_Version.Visible := false;
  EDataBase.Text := '';
  Caption := Caption +' - Ver '+Version;
  EReperID.Text := '';
  Application.Title := Application.Title +' - Ver '+Version;
  LstInvID := TStringList.Create;
  LstRelation := TStringList.Create;
  LstFinal := TStringList.Create;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  Dm_Main.Free;
  FreeAndNil(LstInvID);
  FreeAndNil(LstRelation);
  FreeAndNil(LstFinal);
end;

procedure TFrm_Main.Nbt_ConnClick(Sender: TObject);
begin
  OpenDatabase;
end;

procedure TFrm_Main.Nbt_Exec12_1Click(Sender: TObject);
var
  iArtId: integer;
  iTgfId: integer;
  iCouId: integer;
  Que_Lst: TIBOQuery;
  Que_Upd: TIBOQuery;
  i: integer;
  sWhere: string;
  LstErreur: TStringList;
  bStop: boolean;
  Delai: DWord;
  sInfo: string;
  nb: integer;
begin
  if LstRelation.Count=0 then
  begin
    MessageDlg('Aucun inventaire sélectionné !', mterror, [mbok], 0);
    exit;
  end;

  Dm_Main.ReperSavID := EReperID.Text;
  if (Dm_Main.ReperSavID<>'') and (Dm_Main.ReperSavID[Length(Dm_Main.ReperSavID)]<>'\') then
    Dm_Main.ReperSavID := Dm_Main.ReperSavID+'\';

  if not(SysUtils.DirectoryExists(Dm_Main.ReperSavID)) then
  begin
    MessageDlg('Répertoire manquant ou invalide !', mterror, [mbok], 0);
    exit;
  end;
  // article
  if not(FileExists(Dm_Main.ReperSavID+ArticleID)) then
  begin
    MessageDlg('Fichier "ArticleID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;
  // Taille
  if not(FileExists(Dm_Main.ReperSavID+GrTailleLigID)) then
  begin
    MessageDlg('Fichier "GrTailleLigID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;
  // couleur
  if not(FileExists(Dm_Main.ReperSavID+CouleurID)) then
  begin
    MessageDlg('Fichier "CouleurID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Lab_EnCours3.Caption := '';
  Lab_EnCours3.Visible := true;
  PgBar3.Position := 0;
  PgBar3.Visible := true;
  Que_Lst := TIBOQuery.Create(Self);
  Que_Upd := TIBOQuery.Create(Self);
  LstErreur := TStringList.Create;
  Application.ProcessMessages;
  try
    Dm_Main.LoadListeArticleID;        // article
    Dm_Main.LoadListeGrTailleLigID;    // taille
    Dm_Main.LoadListeCouleurID;        // couleur

    Que_Lst.IB_Connection := Dm_Main.Database;
    Que_Lst.IB_Transaction := Dm_Main.Transaction;
    Que_Upd.IB_Connection := Dm_Main.Database;
    Que_Upd.IB_Transaction := Dm_Main.TransacRel;

    // INVENTEL
    Delai := GetTickCount;
    sInfo := 'INVENTEL 0';
    Lab_EnCours3.Caption := sInfo;
    Application.ProcessMessages;
    with Que_Lst do
    begin
      SQL.Clear;
      SQL.Add('Select INL_ID, INL_ARTID, INL_TGFID, INL_COUID from Inventetel');
      SQL.Add(' where INL_ID<>0 and ');
      sWhere := '';
      for i := 1 to LstRelation.Count do
      begin
        if sWhere<>'' then
          sWhere := sWhere+' or ';
        sWhere := sWhere+'INL_INVID='+LstRelation[i-1];
      end;
      sWhere := '('+sWhere+')';
      SQL.Add(sWhere);
    end;
    nb := 0;
    Que_Lst.Open;
    Que_Lst.First;
    while not(Que_Lst.Eof) do
    begin
      inc(nb);
      iArtID := Dm_Main.GetArtID(Que_Lst.FieldByName('INL_ARTID').AsString);
      iTgfID := Dm_Main.GetTgfID(Que_Lst.FieldByName('INL_TGFID').AsString);
      iCouID := Dm_Main.GetCouID(Que_Lst.FieldByName('INL_COUID').AsString);
      bStop := false;
      if iArtID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVENTEL - Article non trouvé - CODE_ART = '+Que_Lst.FieldByName('INL_ARTID').AsString);
      end;
      if iTgfID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVENTEL - Taille non trouvé - CODE = '+Que_Lst.FieldByName('INL_TGFID').AsString);
      end;
      if iCouID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVENTEL - Couleur non trouvé - COU = '+Que_Lst.FieldByName('INL_COUID').AsString);
      end;
      if not(bStop) then
      begin
        if not(Dm_Main.TransacRel.InTransaction) then
          Dm_Main.TransacRel.StartTransaction;
        try
          with Que_Upd do
          begin
            SQL.Clear;
            SQL.Add('update Inventetel set');
            SQL.Add('    INL_ARTID='+inttostr(iArtId)+',');
            SQL.Add('    INL_TGFID='+inttostr(iTgfId)+',');
            SQL.Add('    INL_COUID='+inttostr(iCouId));
            SQL.Add(' where INL_ID='+inttostr(Que_Lst.FieldByName('INL_ID').AsInteger));
            ExecSQL;
            Close;
          end;
          Dm_Main.TransacRel.Commit;
        except
          Dm_Main.TransacRel.RollBack;
          raise;
        end;
      end;
      sInfo := 'INVENTEL '+inttostr(nb);
      if (GetTickCount-Delai)>=DelaiAffiche then
      begin
        Lab_EnCours3.Caption := sInfo;
        Delai := GetTickCount;
        Application.ProcessMessages;
      end;

      Que_Lst.Next;
    end;
    Que_Lst.Close;
    Lab_EnCours3.Caption := sInfo;

    // INVIMGSTK
    Delai := GetTickCount;
    sInfo := 'INVIMGSTK 0';
    Lab_EnCours3.Caption := sInfo;
    Application.ProcessMessages;
    for i := 1 to LstRelation.Count do
    begin
      with Que_Lst do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select ISI_INVID, ISI_STCID, ISI_ARTID, ISI_TGFID, ISI_COUID from INVIMGSTK');
        SQL.Add(' where ISI_INVID='+LstRelation[i-1]);
      end;
      Que_Lst.Open;
      Que_Lst.First;
      while not(Que_Lst.Eof) do
      begin
        inc(nb);
        iArtID := Dm_Main.GetArtID(Que_Lst.FieldByName('ISI_ARTID').AsString);
        iTgfID := Dm_Main.GetTgfID(Que_Lst.FieldByName('ISI_TGFID').AsString);
        iCouID := Dm_Main.GetCouID(Que_Lst.FieldByName('ISI_COUID').AsString);
        bStop := false;
        if iArtID<=0 then
        begin
          bStop := true;
          LstErreur.Add('INVIMGSTK - Article non trouvé - CODE_ART = '+Que_Lst.FieldByName('ISI_ARTID').AsString);
        end;
        if iTgfID<=0 then
        begin
          bStop := true;
          LstErreur.Add('INVIMGSTK - Taille non trouvé - CODE = '+Que_Lst.FieldByName('ISI_TGFID').AsString);
        end;
        if iCouID<=0 then
        begin
          bStop := true;
          LstErreur.Add('INVIMGSTK - Couleur non trouvé - COU = '+Que_Lst.FieldByName('ISI_COUID').AsString);
        end;
        if not(bStop) then
        begin
          if not(Dm_Main.TransacRel.InTransaction) then
            Dm_Main.TransacRel.StartTransaction;
          try
            with Que_Upd do
            begin
              SQL.Clear;
              SQL.Add('update INVIMGSTK set');
              SQL.Add('    ISI_ARTID='+inttostr(iArtId)+',');
              SQL.Add('    ISI_TGFID='+inttostr(iTgfId)+',');
              SQL.Add('    ISI_COUID='+inttostr(iCouId));
              SQL.Add(' where ISI_INVID='+inttostr(Que_Lst.FieldByName('ISI_INVID').AsInteger));
              SQL.Add('   and ISI_STCID='+inttostr(Que_Lst.FieldByName('ISI_STCID').AsInteger));
              SQL.Add('   and ISI_ARTID='+inttostr(Que_Lst.FieldByName('ISI_ARTID').AsInteger));
              SQL.Add('   and ISI_TGFID='+inttostr(Que_Lst.FieldByName('ISI_TGFID').AsInteger));
              SQL.Add('   and ISI_COUID='+inttostr(Que_Lst.FieldByName('ISI_COUID').AsInteger));
              ExecSQL;
              Close;
            end;
            Dm_Main.TransacRel.Commit;
          except
            Dm_Main.TransacRel.RollBack;
            raise;
          end;
        end;
        sInfo := 'INVIMGSTK '+inttostr(nb);
        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours3.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

        Que_Lst.Next;
      end;
    end;
    Que_Lst.Close;
    Lab_EnCours3.Caption := sInfo;

    // INVSESSIONL
    Delai := GetTickCount;
    sInfo := 'INVSESSIONL 0';
    Lab_EnCours3.Caption := sInfo;
    Application.ProcessMessages;
    with Que_Lst do
    begin
      SQL.Clear;
      SQL.Add('select SAL_ID, SAL_ARTID, SAL_TGFID, SAL_COUID from Invsessionl');
      SQL.Add('  join Invsession on SAI_ID=SAL_SAIID');
      SQL.Add(' where SAL_ID<>0 and');
      sWhere := '';
      for i := 1 to LstRelation.Count do
      begin
        if sWhere<>'' then
          sWhere := sWhere+' or ';
        sWhere := sWhere+'SAI_INVID='+LstRelation[i-1];
      end;
      sWhere := '('+sWhere+')';
      SQL.Add(sWhere);
    end;
    Que_Lst.Open;
    Que_Lst.First;
    while not(Que_Lst.Eof) do
    begin
      inc(nb);
      iArtID := Dm_Main.GetArtID(Que_Lst.FieldByName('SAL_ARTID').AsString);
      iTgfID := Dm_Main.GetTgfID(Que_Lst.FieldByName('SAL_TGFID').AsString);
      iCouID := Dm_Main.GetCouID(Que_Lst.FieldByName('SAL_COUID').AsString);
      bStop := false;
      if iArtID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVSESSIONL - Article non trouvé - CODE_ART = '+Que_Lst.FieldByName('SAL_ARTID').AsString);
      end;
      if iTgfID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVSESSIONL - Taille non trouvé - CODE = '+Que_Lst.FieldByName('SAL_TGFID').AsString);
      end;
      if iCouID<=0 then
      begin
        bStop := true;
        LstErreur.Add('INVSESSIONL - Couleur non trouvé - COU = '+Que_Lst.FieldByName('SAL_COUID').AsString);
      end;
      if not(bStop) then
      begin
        if not(Dm_Main.TransacRel.InTransaction) then
          Dm_Main.TransacRel.StartTransaction;
        try
          with Que_Upd do
          begin
            SQL.Clear;
            SQL.Add('update Invsessionl set');
            SQL.Add('    SAL_ARTID='+inttostr(iArtId)+',');
            SQL.Add('    SAL_TGFID='+inttostr(iTgfId)+',');
            SQL.Add('    SAL_COUID='+inttostr(iCouId));
            SQL.Add(' where SAL_INVID='+inttostr(Que_Lst.FieldByName('SAL_ID').AsInteger));
            ExecSQL;
            Close;
          end;
          Dm_Main.TransacRel.Commit;
        except
          Dm_Main.TransacRel.RollBack;
          raise;
        end;
      end;
      sInfo := 'INVSESSIONL '+inttostr(nb);
      if (GetTickCount-Delai)>=DelaiAffiche then
      begin
        Lab_EnCours3.Caption := sInfo;
        Delai := GetTickCount;
        Application.ProcessMessages;
      end;

      Que_Lst.Next;
    end;
    Que_Lst.Close;
    Lab_EnCours3.Caption := sInfo;

    MessageDlg('Processus terminé !', mtInformation, [mbok], 0);
  finally
    if LstErreur.Count>0 then
    begin
      LstErreur.SaveToFile(ReperBase+'Erreur Inventaire '+formatdatetime('yyyy-mm-dd hhnnss', now)+'.txt');
    end;
    FreeAndNil(LstErreur);
    Dm_Main.ListeIDGrTailleLig.Clear;
    Dm_Main.ListeIDArticle.Clear;
    Dm_Main.ListeIDCouleur.Clear;
    Lab_EnCours3.Visible := false;
    PgBar3.Visible := false;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_ExportClick(Sender: TObject);
var
  sDir: string;
  i, j: integer;
  sChamp: string;
  sLigne: string;
  sFile: string;
  sFile2: string;
  Stream: TFileStream;
  ListeMag: TStringList;
  Delai: DWord;
  Que_Div: TIBOQuery;
  Que_Mag: TIBOQuery;
  sInfo: string;
  Nb: integer;
  sMag: string;
  iMagId: integer;
  bOkEntete: boolean;
begin
  if LstInvID.Count<0 then
  begin
    MessageDlg('Aucun inventaire sélectionné !', mterror, [mbok], 0);
    exit;
  end;

  sDir := '';
  if not(SelectDirectory( 'Choix du répertoire', '', sDir, [sdNewFolder, sdNewUI])) then
    exit;

  if (sDir<>'') and (sDir[Length(sDir)]<>'\') then
    sDir := sDir+'\';

  Que_Div := TIBOQuery.Create(Self);
  Que_Mag := TIBOQuery.Create(Self);
  Lab_EnCours.Caption := '';
  Lab_EnCours.Visible := true;
  PgBar.Position := 0;
  PgBar.Visible := true;
  ListeMag := TStringList.Create;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Que_Div.IB_Connection := Dm_Main.Database;
    Que_Mag.IB_Connection := Dm_Main.Database;

    with Que_Mag do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select MAG_ID, MAG_CODEADH, MAG_NOM, MAG_ENSEIGNE from Genmagasin');
      SQL.Add('where mag_id=:MAGID');
    end;

    // entete
    iMagId := 0;
    Stream := nil;
    try
      sFile := sDir+'INVENTETE.ive';
      if FileExists(sFile) then
        DeleteFile(sFile);
      sFile2 := sDir+'INVMAGASIN.ive';
      if FileExists(sFile2) then
        DeleteFile(sFile2);
      Application.ProcessMessages;
      Stream := TFileStream.Create(sFile, fmCreate);
      sInfo := 'INVENTETE 0';
      Lab_EnCours.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from INVENTETE');
        SQL.Add(' where INV_ID<>0');
        sChamp := '';
        for i := 1 to LstInvID.Count do
        begin
          if sChamp<>'' then
            sChamp := sChamp+' or ';
          sChamp := sChamp+'INV_ID='+LstInvID[i-1];
        end;
        SQL.Add('and ('+sChamp+')');
      end;
      Application.ProcessMessages;
      Delai := GetTickCount;
      Que_Div.Open;
      sLigne := '';
      for i := 1 to Que_Div.Fields.Count do
      begin
        if sLigne<>'' then
          sLigne := sLigne+';';
        sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].FieldName);
      end;
      WriteStreamString(Stream, sLigne);

      nb := 0;
      Que_Div.First;
      while not(Que_Div.Eof) do
      begin
        inc(nb);
        sInfo := 'INVENTETE '+inttostr(nb);
        sLigne := '';
        for i := 1 to Que_Div.Fields.Count do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          if Que_Div.Fields[i-1].IsNull then
            sLigne := sLigne+QuotedStr('<NULL>')
          else
            sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].AsString);
        end;
        WriteStreamString(Stream, sLigne);

        if iMagId<>Que_Div.FieldByName('INV_MAGID').AsInteger then
        begin
          iMagId := Que_Div.FieldByName('INV_MAGID').AsInteger;
          with Que_Mag do
          begin
            Close;
            ParamByName('MAGID').AsInteger := iMagId;
            Open;
            // entete
            if ListeMag.Count=0 then
            begin
              sMag := '';
              for i := 1 to Fields.Count do
              begin
                if sMag<>'' then
                  sMag := sMag+';';
                sMag := sMag+QuotedStr(Fields[i-1].FieldName);
              end;
              ListeMag.Add(sMag);
            end;
            // lignes magasin
            sMag := '';
            for i := 1 to Fields.Count do
            begin
              if sMag<>'' then
                sMag := sMag+';';
              if Fields[i-1].IsNull then
                sMag := sMag+QuotedStr('<NULL>')
              else
                sMag := sMag+QuotedStr(Fields[i-1].AsString);
            end;
            if ListeMag.IndexOf(sMag)<0 then
              ListeMag.Add(sMag);
          end;
        end;
        ListeMag.SaveToFile(sFile2);

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Div.Next;
      end;
    finally
      Que_Div.Close;
      if Assigned(Stream) then
      begin
        FreeAndNil(Stream);
      end;
    end;

    // entetel
    Stream := nil;
    try
      sFile := sDir+'INVENTETEL.ive';
      if FileExists(sFile) then
        DeleteFile(sFile);
      Application.ProcessMessages;
      Stream := TFileStream.Create(sFile, fmCreate);
      sInfo := 'INVENTETEL 0';
      Lab_EnCours.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from INVENTETEL');
        SQL.Add(' where INL_ID<>0');
        sChamp := '';
        for i := 1 to LstInvID.Count do
        begin
          if sChamp<>'' then
            sChamp := sChamp+' or ';
          sChamp := sChamp+'INL_INVID='+LstInvID[i-1];
        end;
        SQL.Add('and ('+sChamp+')');
      end;
      Application.ProcessMessages;
      Delai := GetTickCount;
      Que_Div.Open;
      sLigne := '';
      for i := 1 to Que_Div.Fields.Count do
      begin
        if sLigne<>'' then
          sLigne := sLigne+';';
        sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].FieldName);
      end;
      WriteStreamString(Stream, sLigne);

      nb := 0;
      Que_Div.First;
      while not(Que_Div.Eof) do
      begin
        inc(nb);
        sInfo := 'INVENTETEL '+inttostr(nb);
        sLigne := '';
        for i := 1 to Que_Div.Fields.Count do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          if Que_Div.Fields[i-1].IsNull then
            sLigne := sLigne+QuotedStr('<NULL>')
          else
            sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].AsString);
        end;
        WriteStreamString(Stream, sLigne);

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Div.Next;
      end;
    finally
      Que_Div.Close;
      if Assigned(Stream) then
      begin
        FreeAndNil(Stream);
      end;
    end;

    // Invimgstk
    Stream := nil;
    try
      sFile := sDir+'INVIMGSTK.ive';
      if FileExists(sFile) then
        DeleteFile(sFile);
      Application.ProcessMessages;
      Stream := TFileStream.Create(sFile, fmCreate);
      sInfo := 'INVIMGSTK 0';
      Lab_EnCours.Caption := sInfo;

//      with Que_Div do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('select * from INVIMGSTK');
//        SQL.Add(' where ISI_INVID<>0');
//        sChamp := '';
//        for i := 1 to LstInvID.Count do
//        begin
//          if sChamp<>'' then
//            sChamp := sChamp+' or ';
//          sChamp := sChamp+'ISI_INVID='+LstInvID[i-1];
//        end;
//        SQL.Add('and ('+sChamp+')');
//      end;

      Application.ProcessMessages;
      Delai := GetTickCount;

      bOkEntete := false;
      nb := 0;
      for j := 1 to LstInvID.Count do
      begin
        with Que_Div do
        begin
          Close;
          SQL.Clear;
          SQL.Add('select * from INVIMGSTK');
          SQL.Add(' where ISI_INVID='+LstInvID[j-1]);
        end;

        Que_Div.Open;
        if not(bOkEntete) then
        begin
          sLigne := '';
          for i := 1 to Que_Div.Fields.Count do
          begin
            if sLigne<>'' then
              sLigne := sLigne+';';
            sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].FieldName);
          end;
          WriteStreamString(Stream, sLigne);
          bOkEntete := true;
        end;

        Que_Div.First;
        while not(Que_Div.Eof) do
        begin
          inc(nb);
          sInfo := 'INVIMGSTK '+inttostr(nb);
          sLigne := '';
          for i := 1 to Que_Div.Fields.Count do
          begin
            if sLigne<>'' then
              sLigne := sLigne+';';
            if Que_Div.Fields[i-1].IsNull then
              sLigne := sLigne+QuotedStr('<NULL>')
            else
              sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].AsString);
          end;
          WriteStreamString(Stream, sLigne);

          if (GetTickCount-Delai)>=DelaiAffiche then
          begin
            Lab_EnCours.Caption := sInfo;
            Delai := GetTickCount;
            Application.ProcessMessages;
          end;
          Que_Div.Next;
        end;
      end;
    finally
      Que_Div.Close;
      if Assigned(Stream) then
      begin
        FreeAndNil(Stream);
      end;
    end;

    // INVSESSION
    Stream := nil;
    try
      sFile := sDir+'INVSESSION.ive';
      if FileExists(sFile) then
        DeleteFile(sFile);
      Application.ProcessMessages;
      Stream := TFileStream.Create(sFile, fmCreate);
      sInfo := 'INVSESSION 0';
      Lab_EnCours.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from INVSESSION');
        SQL.Add(' where SAI_ID<>0');
        sChamp := '';
        for i := 1 to LstInvID.Count do
        begin
          if sChamp<>'' then
            sChamp := sChamp+' or ';
          sChamp := sChamp+'SAI_INVID='+LstInvID[i-1];
        end;
        SQL.Add('and ('+sChamp+')');
      end;
      Application.ProcessMessages;
      Delai := GetTickCount;
      Que_Div.Open;
      sLigne := '';
      for i := 1 to Que_Div.Fields.Count do
      begin
        if sLigne<>'' then
          sLigne := sLigne+';';
        sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].FieldName);
      end;
      WriteStreamString(Stream, sLigne);

      nb := 0;
      Que_Div.First;
      while not(Que_Div.Eof) do
      begin
        inc(nb);
        sInfo := 'INVSESSION '+inttostr(nb);
        sLigne := '';
        for i := 1 to Que_Div.Fields.Count do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          if Que_Div.Fields[i-1].IsNull then
            sLigne := sLigne+QuotedStr('<NULL>')
          else
            sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].AsString);
        end;
        WriteStreamString(Stream, sLigne);

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Div.Next;
      end;
    finally
      Que_Div.Close;
      if Assigned(Stream) then
      begin
        Stream.Free;
        Stream := nil;
      end;
    end;

    // INVSESSIONL
    Stream := nil;
    try
      sFile := sDir+'INVSESSIONL.ive';
      if FileExists(sFile) then
        DeleteFile(sFile);
      Application.ProcessMessages;
      Stream := TFileStream.Create(sFile, fmCreate);
      sInfo := 'INVSESSIONL 0';
      Lab_EnCours.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select s.SAI_INVID, l.* from INVSESSIONL l');
        SQL.Add('join INVSESSION s on s.SAI_ID=l.SAL_SAIID');
        SQL.Add('where SAL_ID<>0');
        sChamp := '';
        for i := 1 to LstInvID.Count do
        begin
          if sChamp<>'' then
            sChamp := sChamp+' or ';
          sChamp := sChamp+'SAI_INVID='+LstInvID[i-1];
        end;
        SQL.Add('and ('+sChamp+')');
      end;
      Application.ProcessMessages;
      Delai := GetTickCount;
      Que_Div.Open;
      sLigne := '';
      for i := 1 to Que_Div.Fields.Count do
      begin
        if sLigne<>'' then
          sLigne := sLigne+';';
        sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].FieldName);
      end;
      WriteStreamString(Stream, sLigne);

      nb := 0;
      Que_Div.First;
      while not(Que_Div.Eof) do
      begin
        inc(nb);
        sInfo := 'INVSESSIONL '+inttostr(nb);
        sLigne := '';
        for i := 1 to Que_Div.Fields.Count do
        begin
          if sLigne<>'' then
            sLigne := sLigne+';';
          if Que_Div.Fields[i-1].IsNull then
            sLigne := sLigne+QuotedStr('<NULL>')
          else
            sLigne := sLigne+QuotedStr(Que_Div.Fields[i-1].AsString);
        end;
        WriteStreamString(Stream, sLigne);

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
        Que_Div.Next;
      end;
    finally
      Que_Div.Close;
      if Assigned(Stream) then
      begin
        Stream.Free;
        Stream := nil;
      end;
    end;

    MessageDlg('Processus terminé !', mtInformation, [mbok], 0);
  finally
    PgBar.Visible := false;
    Lab_EnCours.Visible := false;
    Que_Div.Close;
    FreeAndNil(Que_Div);
    FreeAndNil(Que_Mag);
    FreeAndNil(ListeMag);
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

function GetValueLigne(ALigne: string; Position: integer): string;
var
  i: integer;
  LPos: integer;
begin
  Result := ALigne;
  for i := 1 to Position-1 do
  begin
    LPos := Pos(''';''', Result);
    if LPos>0 then
      Result := Copy(Result, LPos+2, Length(Result))
    else
      Result :=  '';
  end;
  LPos := Pos(''';''', Result);
  if (LPos>0) then
    Result := Copy(Result, 1, LPos);

  // unquoted
  if Result<>'' then
  begin
    if Result[1]='''' then
      Result := Copy(Result, 2, Length(Result));
  end;
  if Result<>'' then
  begin
    if Result[Length(Result)]='''' then
      Result := Copy(Result, 1, Length(Result)-1);
  end;
  Result := StringReplace(Result, '''''', '''', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFrm_Main.Nbt_ImportClick(Sender: TObject);
var
  odTemp: TOpenDialog;
  sDir: string;
  sFileMagasin: string;
  sFileEntete: string;
  sFileEntetel: string;
  sFileImgStk: string;
  sFileSession: string;
  sFileSessionl: string;
  bOk: boolean;
  TpListe: TStringList;
  Que_DivId: TIBOQuery;
  Que_Div: TIBOQuery;
  Delai: DWord;
  i: integer;
  sLigne: string;
  sValue: string;
  sInfo: string;
  LstIdExclus: TStringList;
  sInvID: string;
  Id: integer;
  LRet: integer;
  LstInvOri: TStringList;
  LstInvDst: TStringList;
  iInvOri: integer;
  iInvDst: integer;
  iMagOri: integer;
  iMagDst: integer;
  iMagId: integer;

  sGenerateur: string;
  iNumEntete: integer;
  iNumSession: integer;
  iNumEnteteResu: integer;
  iNumSessionResu: integer;

  sLire: String;
  Stream: TFileStream;
  StrStream: TStringStream;
  SizeLu: Int64;
  SizeALire: Int64;
  TailleMax: Int64;

  function ConvertValue(Value: string): Variant;
  begin
    if UpperCase(Value)='<NULL>' then
      Result := null
    else
      Result := Value;
  end;

  procedure TraitementLigneINVIMGSTK;
  begin
    sInvID := GetValueLigne(sLigne, 1);
    sInfo := 'INVIMGSTK '+inttostr(i-1);
    if LstIdExclus.IndexOf(sInvID)<0 then
    begin
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try
        if iInvOri<>StrToInt(sInvId) then
        begin
          iInvOri := StrToInt(sInvId);
          LRet := LstInvOri.IndexOf(inttostr(iInvOri));
          if Lret<0 then
            Raise Exception.Create('ISI_INVID non trouvé ('+inttostr(iInvOri)+')');
          iInvDst := StrToInt(LstInvDst[Lret]);
        end;
        with Que_Div do
        begin
          ParamByName('ISI_INVID').AsInteger  := iInvDst;
          ParamByName('ISI_STCID').Value      := ConvertValue(GetValueLigne(sLigne, 2));
          ParamByName('ISI_ARTID').Value      := ConvertValue(GetValueLigne(sLigne, 3));
          ParamByName('ISI_TGFID').Value      := ConvertValue(GetValueLigne(sLigne, 4));
          ParamByName('ISI_COUID').Value      := ConvertValue(GetValueLigne(sLigne, 5));
          ParamByName('ISI_QTE').Value        := ConvertValue(GetValueLigne(sLigne, 6));
          ParamByName('ISI_ECJUST').Value     := ConvertValue(GetValueLigne(sLigne, 7));
          ParamByName('ISI_ECACCEPT').Value   := ConvertValue(GetValueLigne(sLigne, 8));
          ParamByName('ISI_T1').Value         := ConvertValue(GetValueLigne(sLigne, 9));
          ParamByName('ISI_T2').Value         := ConvertValue(GetValueLigne(sLigne, 10));
          ParamByName('ISI_COMENT').Value     := ConvertValue(GetValueLigne(sLigne, 11));
          ExecSQL;
          Close;
          Dm_Main.Transaction.Commit;
        end;
      except
        on E:Exception do
        begin
          if (Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.Rollback;
          raise;
        end;
      end;
    end;

  end;

begin
  sDir := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier inventaire|*.ive';
    odTemp.Title := 'Fichiers inventaires';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sDir := odTemp.FileName;
  finally
    odTemp.Free;
  end;
  if sDir='' then
    exit;

  iMagOri := 0;
  iMagDst := 0;
  sDir := ExtractFilePath(sDir);
  if sDir[Length(sDir)]<>'\' then
    sDir := sDir+'\';
  sFileMagasin  := sDir+'INVMAGASIN.ive';
  sFileEntete  := sDir+'INVENTETE.ive';
  sFileEntetel  := sDir+'INVENTETEL.ive';
  sFileImgStk  := sDir+'INVIMGSTK.ive';
  sFileSession  := sDir+'INVSESSION.ive';
  sFileSessionl  := sDir+'INVSESSIONL.ive';
  bOk := true;
  if not(FileExists(sFileMagasin)) then
  begin
    MessageDlg('Fichier "INVMAGASIN.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(FileExists(sFileEntete)) then
  begin
    MessageDlg('Fichier "INVENTETE.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(FileExists(sFileEntetel)) then
  begin
    MessageDlg('Fichier "INVENTETEL.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(FileExists(sFileImgStk)) then
  begin
    MessageDlg('Fichier "INVIMGSTK.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(FileExists(sFileSession)) then
  begin
    MessageDlg('Fichier "INVSESSION.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(FileExists(sFileSessionl)) then
  begin
    MessageDlg('Fichier "INVSESSIONL.ive" non trouvé !', mterror,[mbok],0);
    bOk := false;
  end;
  if not(bOk) then
    exit;

  TpListe := TStringList.Create;
  Frm_CorrespondMag := TFrm_CorrespondMag.Create(Self);
  try
    Dm_Main.Cds_MagLiaison.Close;
    Dm_Main.Cds_MagLiaison.Open;
    Dm_Main.Cds_MagLiaison.EmptyDataSet;
    TPListe.LoadFromFile(sFileMagasin);
    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      with Dm_Main.Cds_MagLiaison do
      begin
        Append;
        fieldbyname('ORI_MAGID').AsString := GetValueLigne(sLigne, 1);
        fieldbyname('ORI_CODEADH').AsString := GetValueLigne(sLigne, 2);
        fieldbyname('ORI_MAGNOM').AsString := GetValueLigne(sLigne, 3);
        fieldbyname('ORI_MAGENSEIGNE').AsString := GetValueLigne(sLigne, 4);
        Post;
      end;
    end;
    Frm_CorrespondMag.InitEcr;
    if Frm_CorrespondMag.ShowModal<>mrOk then
      exit;
  finally
    FreeAndNil(Frm_CorrespondMag);
    FreeAndNil(TpListe);
  end;


  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;

  LstInvOri := TStringList.Create;
  LstInvDst := TStringList.Create;
  iInvOri := 0;;
  iInvDst := 0;
  Que_Div := TIBOQuery.Create(Self);
  Que_DivId := TIBOQuery.Create(Self);
  TpListe := TStringList.Create;
  Lab_EnCours2.Caption := '';
  Lab_EnCours2.Visible := true;
  PgBar2.Position := 0;
  PgBar2.Visible := true;
  LstIdExclus := TStringList.Create;
  Application.ProcessMessages;
  try
    Que_Div.IB_Connection := Dm_Main.Database;
    Que_Div.IB_Transaction := Dm_Main.Transaction;

    Que_DivId.IB_Connection := Dm_Main.Database;
    Que_DivId.IB_Transaction := Dm_Main.Transaction;
    with Que_DivId do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT GEN_ID(NUM_INVLIGNES, 1) as ID FROM RDB$DATABASE');
    end;

    if not(Dm_Main.Transaction.InTransaction) then
      Dm_Main.Transaction.StartTransaction;
    try
      // desactive le trigger
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Alter trigger INVSESSIONL_AI inactive');
        ExecSQL;
        Close;
      end;
      Dm_Main.Transaction.Commit;

      // Test de l'intete
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select INV_ID from INVENTETE');
        SQL.Add('  join K on K_ID=INV_ID and K_ENABLED=1');
        SQL.Add(' where INV_CHRONO=:CHRONO');
      end;
      sInfo := 'Test de l''entête';
      Lab_EnCours2.Caption := sInfo;
      Application.ProcessMessages;
      TpListe.LoadFromFile(sFileEntete);
      for i := 2 to TPListe.Count do
      begin
        sLigne := TPListe[i-1];
        Que_Div.Close;
        Que_Div.ParamByName('CHRONO').AsString := GetValueLigne(sLigne, 3);
        Que_Div.Open;
        if Que_Div.RecordCount>0 then
          LstIdExclus.Add(GetValueLigne(sLigne, 1));
        Que_Div.Close;
      end;

      // INVENTETE
      Delai := GetTickCount;
      sInfo := 'INVENTETE 0';
      Lab_EnCours2.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into INVENTETE (INV_ID, INV_MAGID, INV_CHRONO, INV_TYPE, INV_NBZONE, INV_COMENT, INV_DATEOUV, INV_FINCOMPT, '+
                'INV_DATEFIN, INV_DATEDEMARQ, INV_COMPLET, INV_CLOTURE, INV_PROCESS, INV_NBRCB)');
        SQL.Add('values (:INV_ID, :INV_MAGID, :INV_CHRONO, :INV_TYPE, :INV_NBZONE, :INV_COMENT, '+
                ':INV_DATEOUV, :INV_FINCOMPT, :INV_DATEFIN, :INV_DATEDEMARQ, :INV_COMPLET, '+
                ':INV_CLOTURE, :INV_PROCESS, :INV_NBRCB)');
      end;

      Application.ProcessMessages;
      for i := 2 to TPListe.Count do
      begin
        sLigne := TPListe[i-1];
        sInvID := GetValueLigne(sLigne, 1);
        sInfo := 'INVENTETE '+inttostr(i-1);
        if LstIdExclus.IndexOf(sInvID)<0 then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            iInvOri := StrToInt(sInvID);
            with Que_DivId do
            begin
              Open;
              iInvDst := fieldbyname('ID').AsInteger;
              Close;
            end;
            iMagId := StrToInt(GetValueLigne(sLigne, 2));
            if (iMagOri<>iMagId) then
            begin
              iMagOri := iMagId;
              Dm_Main.Cds_MagLiaison.Locate('ORI_MAGID', iMagOri, []);
              iMagDst := Dm_Main.Cds_MagLiaison.FieldByName('DST_MAGID').AsInteger;
            end;
            LstInvOri.Add(inttostr(iInvOri));
            LstInvDst.Add(inttostr(iInvDst));
            with Que_Div do
            begin
              ParamByName('INV_ID').AsInteger     := iInvDst;
              ParamByName('INV_MAGID').AsInteger  := iMagDst;
              ParamByName('INV_CHRONO').Value     := ConvertValue(GetValueLigne(sLigne, 3));
              ParamByName('INV_TYPE').Value       := ConvertValue(GetValueLigne(sLigne, 4));
              ParamByName('INV_NBZONE').Value     := ConvertValue(GetValueLigne(sLigne, 5));
              ParamByName('INV_COMENT').Value     := ConvertValue(GetValueLigne(sLigne, 6));
              ParamByName('INV_DATEOUV').Value    := ConvertValue(GetValueLigne(sLigne, 7));
              ParamByName('INV_FINCOMPT').Value   := ConvertValue(GetValueLigne(sLigne, 8));
              ParamByName('INV_DATEFIN').Value    := ConvertValue(GetValueLigne(sLigne, 9));
              ParamByName('INV_DATEDEMARQ').Value := ConvertValue(GetValueLigne(sLigne, 10));
              ParamByName('INV_COMPLET').Value    := ConvertValue(GetValueLigne(sLigne, 11));
              ParamByName('INV_CLOTURE').Value    := ConvertValue(GetValueLigne(sLigne, 12));
              ParamByName('INV_PROCESS').Value    := ConvertValue(GetValueLigne(sLigne, 13));
              ParamByName('INV_NBRCB').Value      := ConvertValue(GetValueLigne(sLigne, 14));
              ExecSQL;
              Close;
              Dm_Main.Transaction.Commit;
            end;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours2.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
      end;
      TpListe.Clear;

      // INVENTETEL
      Delai := GetTickCount;
      sInfo := 'INVENTETEL 0';
      Lab_EnCours2.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into INVENTETEL (INL_ID, INL_INVID, INL_ARTID, INL_TGFID, INL_COUID, '+
                     'INL_QTTOUV, INL_QTTECPT, INL_MVTPOS, INL_MVTNEG, INL_DEJACPT, INL_STCID)');
        SQL.Add('values (:INL_ID, :INL_INVID, :INL_ARTID, :INL_TGFID, :INL_COUID, :INL_QTTOUV, '+
                     ':INL_QTTECPT, :INL_MVTPOS, :INL_MVTNEG, :INL_DEJACPT, :INL_STCID)');

      end;
      Application.ProcessMessages;
      TpListe.LoadFromFile(sFileEntetel);
      for i := 2 to TPListe.Count do
      begin
        sLigne := TPListe[i-1];
        sInvID := GetValueLigne(sLigne, 2);
        sInfo := 'INVENTETEL '+inttostr(i-1);
        if LstIdExclus.IndexOf(sInvID)<0 then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            if iInvOri<>StrToInt(sInvId) then
            begin
              iInvOri := StrToInt(sInvId);
              LRet := LstInvOri.IndexOf(inttostr(iInvOri));
              if Lret<0 then
                Raise Exception.Create('INL_INVID non trouvé ('+inttostr(iInvOri)+')');
              iInvDst := StrToInt(LstInvDst[Lret]);
            end;
            with Que_DivId do
            begin
              Open;
              Id := fieldbyname('ID').AsInteger;
              Close;
            end;
            with Que_Div do
            begin
              ParamByName('INL_ID').AsInteger    := Id;
              ParamByName('INL_INVID').AsInteger := iInvDst;
              ParamByName('INL_ARTID').Value     := ConvertValue(GetValueLigne(sLigne, 3));
              ParamByName('INL_TGFID').Value     := ConvertValue(GetValueLigne(sLigne, 4));
              ParamByName('INL_COUID').Value     := ConvertValue(GetValueLigne(sLigne, 5));
              ParamByName('INL_QTTOUV').Value    := ConvertValue(GetValueLigne(sLigne, 6));
              ParamByName('INL_QTTECPT').Value   := ConvertValue(GetValueLigne(sLigne, 7));
              ParamByName('INL_MVTPOS').Value    := ConvertValue(GetValueLigne(sLigne, 8));
              ParamByName('INL_MVTNEG').Value    := ConvertValue(GetValueLigne(sLigne, 9));
              ParamByName('INL_DEJACPT').Value   := ConvertValue(GetValueLigne(sLigne, 10));
              ParamByName('INL_STCID').Value     := ConvertValue(GetValueLigne(sLigne, 11));
              ExecSQL;
              Close;
              Dm_Main.Transaction.Commit;
            end;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours2.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
      end;
      TpListe.Clear;

      // INVIMGSTK
      Delai := GetTickCount;
      sInfo := 'INVIMGSTK 0';
      Lab_EnCours2.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into INVIMGSTK (ISI_INVID, ISI_STCID, ISI_ARTID, ISI_TGFID, ISI_COUID, '+
                      'ISI_QTE, ISI_ECJUST, ISI_ECACCEPT, ISI_T1, ISI_T2, ISI_COMENT)');
        SQL.Add('values (:ISI_INVID, :ISI_STCID, :ISI_ARTID, :ISI_TGFID, :ISI_COUID, :ISI_QTE, '+
                      ':ISI_ECJUST, :ISI_ECACCEPT, :ISI_T1, :ISI_T2, :ISI_COMENT)');

      end;
      Application.ProcessMessages;

      sLire := '';
      TailleMax := 1024;
      Stream := TFileStream.Create(sFileImgStk, fmOpenRead);
      StrStream := TStringStream.Create('');
      try
        i := 0;
        Stream.Seek(0, soFromBeginning);
        if Stream.Size-Stream.Position>TailleMax then
          SizeALire := TailleMax
        else
          SizeALire := Stream.Size-Stream.Position;
        Sizelu := StrStream.CopyFrom(Stream, SizeALire);
        sLire := StrStream.DataString;
        while (Sizelu=TailleMax) do
        begin
          while Pos(#13#10, sLire)>0 do
          begin
            inc(i);
            sInfo := 'INVIMGSTK '+inttostr(i);
            sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
            sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
            // traitement de la ligne
            if i>1 then
              TraitementLigneINVIMGSTK;
            // fin traitement
            if (GetTickCount-Delai)>=DelaiAffiche then
            begin
              Lab_EnCours2.Caption := sInfo;
              Delai := GetTickCount;
              Application.ProcessMessages;
            end;
          end;
          if Stream.Size-Stream.Position>TailleMax then
            SizeALire := TailleMax
          else
            SizeALire := Stream.Size-Stream.Position;
          StrStream.Clear;
          Sizelu := StrStream.CopyFrom(Stream, SizeALire);
          sLire := sLire+StrStream.DataString;
        end;
        if sLire<>'' then
        begin
          while Pos(#13#10, sLire)>0 do
          begin
            inc(i);
            sInfo := 'INVIMGSTK '+inttostr(i);
            sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
            sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
            // traitement de la ligne
            if i>1 then
              TraitementLigneINVIMGSTK;
            // fin traitement
            if (GetTickCount-Delai)>=DelaiAffiche then
            begin
              Lab_EnCours2.Caption := sInfo;
              Delai := GetTickCount;
              Application.ProcessMessages;
            end;
          end;
          if sLire<>'' then
          begin
            inc(i);
            sInfo := 'INVIMGSTK '+inttostr(i);
            sLigne := sLire;
            // traitement de la ligne
            if i>1 then
              TraitementLigneINVIMGSTK;
            // fin traitement
          end;
        end;
        Lab_EnCours2.Caption := sInfo;
      finally
        FreeAndNil(Stream);
        FreeAndNil(StrStream);
      end;
      TpListe.Clear;

      // INVSESSION
      Delai := GetTickCount;
      sInfo := 'INVSESSION 0';
      Lab_EnCours2.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into INVSESSION (SAI_ID, SAI_INVID, SAI_CHRONO, SAI_DATEDEB, SAI_USRID, '+
                     'SAI_COMENT, SAI_ZONE, SAI_TYPE)');
        SQL.Add('values (:SAI_ID, :SAI_INVID, :SAI_CHRONO, :SAI_DATEDEB, :SAI_USRID, '+
                     ':SAI_COMENT, :SAI_ZONE, :SAI_TYPE)');

      end;
      Application.ProcessMessages;
      TpListe.LoadFromFile(sFileSession);
      for i := 2 to TPListe.Count do
      begin
        sLigne := TPListe[i-1];
        sInvID := GetValueLigne(sLigne, 2);
        sInfo := 'INVSESSION '+inttostr(i-1);
        if LstIdExclus.IndexOf(sInvID)<0 then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            if iInvOri<>StrToInt(sInvId) then
            begin
              iInvOri := StrToInt(sInvId);
              LRet := LstInvOri.IndexOf(inttostr(iInvOri));
              if Lret<0 then
                Raise Exception.Create('SAI_INVID non trouvé ('+inttostr(iInvOri)+')');
              iInvDst := StrToInt(LstInvDst[Lret]);
            end;
            with Que_DivId do
            begin
              Open;
              Id := fieldbyname('ID').AsInteger;
              Close;
            end;
            with Que_Div do
            begin
              ParamByName('SAI_ID').AsInteger    := Id;
              ParamByName('SAI_INVID').AsInteger := iInvDst;
              ParamByName('SAI_CHRONO').Value    := ConvertValue(GetValueLigne(sLigne, 3));
              ParamByName('SAI_DATEDEB').Value   := ConvertValue(GetValueLigne(sLigne, 4));
              ParamByName('SAI_USRID').Value     := ConvertValue(GetValueLigne(sLigne, 5));
              ParamByName('SAI_COMENT').Value    := ConvertValue(GetValueLigne(sLigne, 6));
              ParamByName('SAI_ZONE').Value      := ConvertValue(GetValueLigne(sLigne, 7));
              ParamByName('SAI_TYPE').Value      := ConvertValue(GetValueLigne(sLigne, 8));
              ExecSQL;
              Close;
              Dm_Main.Transaction.Commit;
            end;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours2.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
      end;
      TpListe.Clear;

      // INVSESSIONL
      Delai := GetTickCount;
      sInfo := 'INVSESSIONL 0';
      Lab_EnCours2.Caption := sInfo;
      with Que_Div do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into INVSESSIONL (SAL_ID, SAL_SAIID, SAL_SAISIE, SAL_ARTID, SAL_COUID, '+
                        'SAL_TGFID, SAL_QTTE, SAL_ARTOK, SAL_INLID)');
        SQL.Add('values (:SAL_ID, :SAL_SAIID, :SAL_SAISIE, :SAL_ARTID, :SAL_COUID, :SAL_TGFID, '+
                        ':SAL_QTTE, :SAL_ARTOK, :SAL_INLID)');

      end;
      Application.ProcessMessages;
      TpListe.LoadFromFile(sFileSessionl);
      for i := 2 to TPListe.Count do
      begin
        sLigne := TPListe[i-1];
        sInvID := GetValueLigne(sLigne, 1);
        sInfo := 'INVSESSIONL '+inttostr(i-1);
        if LstIdExclus.IndexOf(sInvID)<0 then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            with Que_DivId do
            begin
              Open;
              Id := fieldbyname('ID').AsInteger;
              Close;
            end;
            with Que_Div do
            begin
              ParamByName('SAL_ID').AsInteger    := Id;
              ParamByName('SAL_SAIID').Value     := ConvertValue(GetValueLigne(sLigne, 3));
              ParamByName('SAL_SAISIE').Value    := ConvertValue(GetValueLigne(sLigne, 4));
              ParamByName('SAL_ARTID').Value     := ConvertValue(GetValueLigne(sLigne, 5));
              ParamByName('SAL_COUID').Value     := ConvertValue(GetValueLigne(sLigne, 6));
              ParamByName('SAL_TGFID').Value     := ConvertValue(GetValueLigne(sLigne, 7));
              ParamByName('SAL_QTTE').Value      := ConvertValue(GetValueLigne(sLigne, 8));
              ParamByName('SAL_ARTOK').Value     := ConvertValue(GetValueLigne(sLigne, 9));
              ParamByName('SAL_INLID').Value     := ConvertValue(GetValueLigne(sLigne, 10));
              ExecSQL;
              Close;
              Dm_Main.Transaction.Commit;
            end;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours2.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;
      end;
      TpListe.Clear;

      // remise en place des générateurs
      with Que_Div do
      begin
        SQL.Clear;
        SQL.Add('select PAR_STRING from genparambase');
        SQL.Add(' where PAR_NOM='+QuotedStr('IDGENERATEUR'));
        Open;
        sGenerateur := fieldbyname('PAR_STRING').AsString;
        Close;

        SQL.Clear;
        SQL.Add('SELECT GEN_ID(NUM_INVENTETE, 0) as ID FROM RDB$DATABASE');
        Open;
        iNumEntete := fieldbyname('ID').AsInteger;
        Close;

        SQL.Clear;
        SQL.Add('Select Max( Cast(f_mid (INV_CHRONO, '+inttostr(Length(sGenerateur)+1));
        SQL.Add('   ,f_bigstringlength(INV_CHRONO)-2) as integer)) As RESU');
        SQL.Add(' from INVENTETE');
        SQL.Add( 'where INV_CHRONO Like '+QuotedStr(sGenerateur+'-%'));
        Open;
        iNumEnteteResu := fieldbyname('RESU').AsInteger;
        Close;
        if iNumEnteteResu>iNumEntete then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            SQL.Clear;
            SQL.Add('set Generator NUM_INVENTETE To '+inttostr(iNumEnteteResu));
            ExecSQL;
            Close;
            Dm_Main.Transaction.Commit;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;

        SQL.Clear;
        SQL.Add('SELECT GEN_ID(NUM_INVSESSION, 0) as ID FROM RDB$DATABASE');
        Open;
        iNumSession := fieldbyname('ID').AsInteger;
        Close;

        SQL.Clear;
        SQL.Add('Select Max( Cast(f_mid (SAI_CHRONO, '+inttostr(Length(sGenerateur)+1));
        SQL.Add('   ,f_bigstringlength(SAI_CHRONO)-2) as integer)) As RESU');
        SQL.Add(' from INVSESSION');
        SQL.Add( 'where SAI_CHRONO Like '+QuotedStr(sGenerateur+'-%'));
        Open;
        iNumSessionResu := fieldbyname('RESU').AsInteger;
        Close;
        if iNumSessionResu>iNumSession then
        begin
          if not(Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.StartTransaction;
          try
            SQL.Clear;
            SQL.Add('set Generator NUM_INVSESSION To '+inttostr(iNumSessionResu));
            ExecSQL;
            Close;
            Dm_Main.Transaction.Commit;
          except
            on E:Exception do
            begin
              if (Dm_Main.Transaction.InTransaction) then
                Dm_Main.Transaction.Rollback;
              raise;
            end;
          end;
        end;
      end;

    except
      on E: Exception do
      begin
        if (Dm_Main.Transaction.InTransaction) then
          Dm_Main.Transaction.Rollback;
        E.Message := '('+inttostr(i)+'): '+E.Message;
        raise;
      end;
    end;

    MessageDlg('Processus terminé !', mtInformation, [mbok], 0);
  finally
    // reactive le trigger
    with Que_Div do
    begin
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      Close;
      SQL.Clear;
      SQL.Add('Alter trigger INVSESSIONL_AI active');
      ExecSQL;
      Close;
      Dm_Main.Transaction.Commit;
    end;
    FreeAndNil(TpListe);
    FreeAndNil(LstIdExclus);
    FreeAndNil(LstInvOri);
    FreeAndNil(LstInvDst);
    Que_Div.Close;
    FreeAndNil(Que_Div);
    Que_DivId.Close;
    FreeAndNil(Que_DivId);
//    Lab_EnCours2.Caption := '';
//    Lab_EnCours2.Visible := false;
    PgBar2.Visible := false;
    Dm_Main.Que_LstInvent.Refresh;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_OpenConnClick(Sender: TObject);
var
  odTemp : TOpenDialog;
  sFile: string;
begin
  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sFile := odTemp.FileName;
  finally
    odTemp.Free;
  end;
  if sFile='' then
    exit;

  EDataBase.Text := sFile;
  OpenDatabase;
end;

procedure TFrm_Main.Nbt_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.Nbt_SelRepClick(Sender: TObject);
var
  sTemp: string;
begin
  sTemp := EReperID.Text;
  if (sTemp<>'') and (sTemp[Length(sTemp)]<>'\') then
    sTemp := sTemp+'\';
  if not(SysUtils.DirectoryExists(sTemp)) then
    sTemp := '';
  if SelectDirectory('Choix du répertoire', '', sTemp) then
  begin
    if (sTemp<>'') and (sTemp[Length(sTemp)]<>'\') then
      sTemp := sTemp+'\';
    EReperID.Text := sTemp;
  end;
end;

end.
