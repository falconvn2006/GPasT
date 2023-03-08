unit Traitement_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, RzPanel, StdCtrls, DB, Buttons, ComCtrls, RzDTP;

type
  TFrm_Traitement = class(TForm)
    Pan_Haut: TRzPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Edt_ID: TEdit;
    Edt_Chrono: TEdit;
    Ds_ListeBL: TDataSource;
    Nbt_ImpID: TBitBtn;
    Nbt_ImpChrono: TBitBtn;
    OD_Import: TOpenDialog;
    Nbt_Clear: TBitBtn;
    Lab_NbEnre: TLabel;
    Rgr_Ordre: TRadioGroup;
    Nbt_Quit: TBitBtn;
    Label3: TLabel;
    Edt_DateBL: TRzDateTimePicker;
    Nbt_Appliquer: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Rgr_OrdreClick(Sender: TObject);
    procedure Nbt_ClearClick(Sender: TObject);
    procedure Nbt_ImpIDClick(Sender: TObject);
    procedure Nbt_ImpChronoClick(Sender: TObject);
    procedure Nbt_AppliquerClick(Sender: TObject);
  private
    { Déclarations privées }
    ListeID, ListeChrono: TStringList;                              
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
    procedure DoSQL(sLocateID, sLocateChrono: string);
  public
    { Déclarations publiques }
  end;

var
  Frm_Traitement: TFrm_Traitement;

implementation

uses
  Main_Dm;

{$R *.dfm}   

procedure TFrm_Traitement.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

procedure TFrm_Traitement.CMDialogKey(var M: TCMDialogKey);
var
  vID: integer;
  sChrono: string;
begin
  if (Edt_ID.Focused) and (Edt_ID.Text<>'') then
  begin 
    m.Result := 1;
    vID:=StrToIntDef(Edt_ID.Text,-1);
    if vID=-1 then
    begin
      Edt_ID.SelectAll;
      Edt_ID.SetFocus;
      MessageDlg('Valeur invalide !',mterror,[mbok],0);
    end
    else
    begin
      if (ListeID.IndexOf(inttostr(vID))>=0) and (Dm_Main.Que_ListeBL.Active) then
        Dm_Main.Que_ListeBL.locate('BLE_ID',vID,[])
      else
      begin
        ListeID.Add(inttostr(vID));
        DoSQL(inttostr(vID),'');
      end;   
      Edt_ID.Text:='';
      Edt_ID.SetFocus;
    end;
    exit;
  end;   
  if (Edt_Chrono.Focused) and (Edt_Chrono.Text<>'') then
  begin
    m.Result := 1;
    sChrono:=Edt_Chrono.Text;
    if (ListeChrono.IndexOf(sChrono)>=0) and (Dm_Main.Que_ListeBL.Active) then
      Dm_Main.Que_ListeBL.locate('BLE_NUMERO',sChrono,[])
    else
    begin
      ListeChrono.Add(sChrono);
      DoSQL('',sChrono);
    end;   
    Edt_Chrono.Text:='';
    Edt_Chrono.SetFocus;
    exit;
  end;
  inherited;
end;

procedure TFrm_Traitement.DoSQL(sLocateID, sLocateChrono: string);
var
  sWhere: string;
  i:integer;
  Nb:integer;
begin
  Nb := 0;
  if (ListeID.Count=0) and (ListeChrono.Count=0) then
  begin
    Dm_Main.Que_ListeBL.Active := False;
    Lab_NbEnre.Caption:= inttostr(Nb)+' Enre.';
    exit;
  end;

  with Dm_Main.Que_ListeBL, SQL do
  begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    DisableControls;
    try
      Active:=false;
      Clear;
      sWhere := '';
      for i:=1 to ListeID.Count do
      begin
        if sWhere<>'' then
          sWhere := sWhere+' or ';
        sWhere:=sWhere+'BLE_ID='+ListeID[i-1];
      end;          
      for i:=1 to ListeChrono.Count do
      begin
        if sWhere<>'' then
          sWhere := sWhere+' or ';
        sWhere:=sWhere+'BLE_NUMERO='+QuotedStr(ListeChrono[i-1]);
      end;
      sWhere := 'where (ble_id<>0) and ('+sWhere+')';

      with Dm_Main.Que_Div, SQL do
      begin
        Active:=false;
        Clear;
        Add('select count(*) as NBRE from negbl');
        Add(sWhere);
        Active:=true;
        Nb:=fieldbyname('NBRE').AsInteger;
        Active:=false;
      end;

      Add('select ble_id, ble_numero, clt_nom,clt_prenom,');
      Add('  (ble_tvaht1+ble_tvaht2+ble_tvaht3+ble_tvaht4+ble_tvaht5) as TTC,');
      Add('  ble_date,ble_reglement from negbl b');
      Add('join k on (k_id=ble_id and k_enabled=1)');
      Add('join CLTCLIENT c on clt_id=ble_cltid');
      Add(sWhere);
      case Rgr_Ordre.ItemIndex of
        0: Add('order by BLE_ID');
        1: Add('order by ble_numero');
        2: Add('order by clt_nom, clt_prenom');
      end;
      Active := true;  
      Lab_NbEnre.Caption:= inttostr(Nb)+' Enre.';
    finally
      if sLocateID<>'' then
        Locate('BLE_ID',sLocateID,[])
      else
      begin 
        if sLocateID<>'' then
          Locate('ble_numero',sLocateChrono,[])
      end;
      EnableControls;  
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFrm_Traitement.FormCreate(Sender: TObject);
begin
  ListeID := TStringList.Create;
  ListeChrono := TStringList.Create;
  Edt_ID.Text:='';
  Edt_Chrono.Text:='';
  DoSQL('','');
end;

procedure TFrm_Traitement.FormDestroy(Sender: TObject);
begin
  ListeID.Free;
  ListeID:=nil;
  ListeChrono.Free;
  ListeChrono:=nil;
end;

procedure TFrm_Traitement.Nbt_AppliquerClick(Sender: TObject);
var
  d1,d2,d3:tdatetime;
  vId: integer;
begin
  if not(Dm_Main.Que_ListeBL.Active) or (Dm_Main.Que_ListeBL.RecordCount=0) then
    exit;
  d1:=Edt_DateBL.Date;
  if MessageDlg('Changer la date des BL ci-dessous avec la date: '+formatdatetime('dd/mm/yyyy',d1)+' ?',
       mtconfirmation,[mbyes,mbno],0)<>mryes then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    with Dm_Main.Que_ListeBL do
    begin
      First;
      while not(Dm_Main.Que_ListeBL.Eof) do
      begin
        d2:=d1;
        d3:=Frac(fieldbyname('BLE_REGLEMENT').AsDateTime);
        d3:=Trunc(d1)+d3;
        vId := fieldbyname('BLE_ID').AsInteger;

        with Dm_Main.Que_UpdateBL do
        begin
          Close;
          ParamByName('BLEDATE').AsDate := d2;
          ParamByName('BLEREGLEMENT').AsDateTime := d3;
          ParamByName('BLEID').AsInteger := vId; 
          ExecSQL;
          Close;
        end;

        with Dm_Main.Que_UpdateK do
        begin
          Close;
          ParamByname('ID').AsInteger := vID;
          ExecSQL;
          Close;
        end;

        Next;
      end;
    end;
  finally
    DoSQL('','');
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Traitement.Nbt_ClearClick(Sender: TObject);
begin 
  ListeID.Clear;
  ListeChrono.Clear;
  DoSQL('','');
end;

procedure TFrm_Traitement.Nbt_ImpChronoClick(Sender: TObject);
var
  sChrono: string;
  TpListe:TStringList;
  i:integer;
begin
  if OD_Import.Execute then
  begin
    Application.ProcessMessages;
    TPListe := TStringList.Create;
    try
      TPListe.LoadFromFile(OD_Import.FileName);
      for i:=1 to TPListe.Count do
      begin
        sChrono := TPListe[i-1];
        if (ListeChrono.IndexOf(sChrono)<0) then
          ListeChrono.Add(sChrono);
      end;
      DoSQL('','');
    finally
      TPListe.Free;
      TPListe:=nil;
    end;
  end;
end;

procedure TFrm_Traitement.Nbt_ImpIDClick(Sender: TObject);
var
  vId: integer;
  TpListe:TStringList;
  i:integer;
begin
  if OD_Import.Execute then
  begin
    Application.ProcessMessages;
    TPListe := TStringList.Create;
    try
      TPListe.LoadFromFile(OD_Import.FileName);
      for i:=1 to TPListe.Count do
      begin
        vId := StrToIntdef(TPListe[i-1],-1);
        if (vId<>-1) and (ListeID.IndexOf(inttostr(vID))<0) then
          ListeID.Add(inttostr(vID));
      end;
      DoSQL('','');
    finally
      TPListe.Free;
      TPListe:=nil;
    end;
  end;
end;

procedure TFrm_Traitement.Rgr_OrdreClick(Sender: TObject);
begin
  if Dm_Main.Que_ListeBL.Active then
    DoSQL(Dm_Main.Que_ListeBL.fieldbyname('BLE_ID').AsString,'');
end;

end.
