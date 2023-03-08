unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IB_Components, DB, IBODataset;

type
  TFrm_Main = class(TForm)
    Lab_Base: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    Edt_Base: TEdit;
    Nbt_Ouvre: TBitBtn;
    Nbt_Conn: TBitBtn;
    Ginkoia: TIB_Connection;
    IbT_Trans: TIB_Transaction;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    Cbt_ChoixMag: TComboBox;
    Nbt_Selec: TBitBtn;
    Label4: TLabel;
    Bevel3: TBevel;
    Que_Mag: TIBOQuery;
    OD_Base: TOpenDialog;
    IbC_BecolDesactive: TIB_Cursor;
    Lab_TitEtat: TLabel;
    Lab_Etat: TLabel;
    Lab_Choix: TLabel;
    Cbt_Choix: TComboBox;
    Nbt_Appliquer: TBitBtn;
    Nbt_Quit: TBitBtn;
    Que_Div: TIBOQuery;
    Lab_Version: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_ConnClick(Sender: TObject);
    procedure Cbt_ChoixMagDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Nbt_OuvreClick(Sender: TObject);
    procedure Nbt_SelecClick(Sender: TObject);
    procedure Nbt_AppliquerClick(Sender: TObject);
  private
    { Déclarations privées }
    PrmID: integer;
    MagID: integer;
    FEtape: integer;
    procedure GetEtat;
    procedure SetEtape(Value: integer);
    property Etape: integer read FEtape write SetEtape;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

procedure TFrm_Main.GetEtat;
var
  sEtat: string;
begin
  PrmID := 0;
  sEtat := 'Pas de ligne: Be Collector Activé';
  IbC_BecolDesactive.Close;
  IbC_BecolDesactive.ParamByName('magid').AsInteger := MagID;
  IbC_BecolDesactive.Open;
  if not(IbC_BecolDesactive.Eof) then
  begin
    PrmID := IbC_BecolDesactive.FieldByName('PRM_ID').AsInteger;
    if (IbC_BecolDesactive.FieldByName('PRM_INTEGER').AsInteger=0) then
      sEtat := 'Be Collector Désactivé'
    else
      sEtat := 'Be Collector Activé';
  end;
  IbC_BecolDesactive.Close;
  Lab_Etat.Caption := sEtat;
end;

procedure TFrm_Main.SetEtape(Value: integer);
begin
  if FEtape<>Value then
  begin
    FEtape:=Value;
    case FEtape of
      0:
      begin
        Nbt_Appliquer.Enabled:=false;
        Lab_Choix.Enabled:=false;
        Cbt_Choix.Enabled:=false;
        Cbt_Choix.ItemIndex:=-1;
        Lab_TitEtat.Visible:=false;
        Lab_Etat.Caption:='';
        Lab_Etat.Visible:=false;
        Cbt_ChoixMag.Clear;
        Label2.Enabled := false;
        Label3.Enabled := false;
        Cbt_ChoixMag.Enabled := false;
        Nbt_Selec.Enabled := false; 
        Label4.Enabled := false;
      end;
      1:
      begin                   
        Nbt_Appliquer.Enabled:=false;
        Lab_Choix.Enabled:=false;
        Cbt_Choix.Enabled:=false;
        Cbt_Choix.ItemIndex:=-1;
        Lab_TitEtat.Visible:=false;
        Label2.Enabled := true;
        Label3.Enabled := true;
        Cbt_ChoixMag.Enabled := true;
        Nbt_Selec.Enabled := true;  
        Label4.Enabled := false;
      end;
      2:
      begin                
        Nbt_Appliquer.Enabled:=true;
        Lab_Choix.Enabled:=true;
        Cbt_Choix.Enabled:=true;
        Lab_TitEtat.Visible:=true;
        Lab_Etat.Visible:=true;
        Label2.Enabled := true;
        Label3.Enabled := true;
        Cbt_ChoixMag.Enabled := true;
        Nbt_Selec.Enabled := true;
        Label4.Enabled := true;
      end;
    end;
  end;
end;

procedure TFrm_Main.Cbt_ChoixMagDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s1:string;
begin
  with TCombobox(Control).Canvas do
  begin
    s1:=TCombobox(Control).Items[Index];
    if Pos('|',s1)>0 then
      s1:=Copy(s1,Pos('|',s1)+1,Length(s1));
    FillRect(Rect);
    TextOut(Rect.Left+2,Rect.Top+1,s1);
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Edt_Base.Text := '';
  Ginkoia.Connected := false;
  FEtape := -1;
  Etape := 0;
  MagID := 0;
end;

procedure TFrm_Main.Nbt_AppliquerClick(Sender: TObject);
var
  lret: integer;
  Actif: integer;
begin
  lret:=Cbt_Choix.ItemIndex;
  if lret<0 then
  begin
    MessageDlg('Sélection invalide !',mterror,[mbok],0);
    exit;
  end;
  if lret=0 then
    Actif:=1
  else
    Actif:=0;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  IbT_Trans.StartTransaction;
  try
    try
      if PrmID=0 then
      begin
        with Que_Div, SQL do
        begin
          Close;
          Clear;
          Add('select ID from PR_NEWK(''GENPARAM'')');
          Open;
          PrmID:=fieldbyname('ID').AsInteger;
          Close;

          Clear;
          Add('insert into GENPARAM '+
              '(PRM_ID,PRM_CODE,PRM_INTEGER,PRM_FLOAT,PRM_STRING,PRM_TYPE,PRM_MAGID,PRM_INFO,PRM_POS) values');
          Add('('+inttostr(PrmID)+',');
          Add('20013,');
          Add(inttostr(Actif)+',');
          Add('0,');
          Add(QuotedStr('PRM_INTEGER = 0 ==> le magasin est desactivé')+',');
          Add('0,');
          Add(inttostr(MagID)+',');
          Add(QuotedStr('Carte Fid. Centrale DESACTIVATION')+',');
          Add('0)');
          ExecSQL;
          Close;
        end;
      end
      else
      begin
        with Que_Div, SQL do
        begin
          Close;
          Clear;
          Add('execute procedure PR_UPDATEK('+inttostr(PrmID)+',0)');
          ExecSQL;
          Close;

          Clear;
          Add('update GENPARAM set');
          Add('PRM_INTEGER='+inttostr(Actif));
          Add('where PRM_ID='+inttostr(PrmID));
          ExecSQL;
          Close;
        end;
      end;

      IbT_Trans.Commit;  
      GetEtat;
    except
      on E:Exception do
      begin
        IbT_Trans.Rollback;
        MessageDlg(E.Message,mterror,[mbok],0);
      end;
    end;
  finally                        
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

end;

procedure TFrm_Main.Nbt_ConnClick(Sender: TObject);
begin
  Etape := 0;
  Ginkoia.Connected := false;
  if (Edt_Base.Text='') or not(FileExists(Edt_Base.Text)) then
  begin
    MessageDlg('Base non trouvé !',mterror,[mbok],0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    Ginkoia.Database := Edt_Base.Text;
    Ginkoia.Connected := true;
    with Que_Mag do
    begin
      Active := true;
      First;
      while not(Eof) do
      begin
        Cbt_ChoixMag.Items.Add(fieldbyname('MAG_ID').AsString+'|'+
                               fieldbyname('MAG_ENSEIGNE').AsString);
        Next;
      end;
      Active:=false;
    end;
    Etape := 1;
  except
    on E:Exception do
      MessageDlg(E.Message, mterror,[mbok],0);
  end;  
  Application.ProcessMessages; 
  Screen.Cursor := crDefault;
end;

procedure TFrm_Main.Nbt_OuvreClick(Sender: TObject);
begin
  if OD_Base.Execute then
  begin
    Edt_Base.Text := OD_Base.FileName;
    Etape := 0;
  end;
end;

procedure TFrm_Main.Nbt_SelecClick(Sender: TObject);
var
  LRet: integer;
  s:string;
begin
  Lret:=Cbt_ChoixMag.ItemIndex;
  if lret<0 then
  begin
    MessageDlg('Sélection invalide !',mterror,[mbok],0);
    exit;
  end;
  s:=Cbt_ChoixMag.Items[lret];
  s:=Copy(s,1,pos('|',s)-1);
  MagID := StrToIntdef(s, -1);
  if MagID<0 then
  begin
    MessageDlg('Sélection invalide !',mterror,[mbok],0);
    exit;
  end;
  Etape := 2;
  GetEtat;
end;

end.
