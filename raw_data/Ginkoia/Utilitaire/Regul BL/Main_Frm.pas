unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrm_Main = class(TForm)
    Lab_Base: TLabel;
    Edt_Base: TEdit;
    Nbt_Conn: TBitBtn;
    Nbt_Ouvre: TBitBtn;
    OD_Base: TOpenDialog;
    Lab_OkConn: TLabel;
    Nbt_Traiter: TBitBtn;
    Nbt_Quit: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_ConnClick(Sender: TObject);
    procedure Nbt_OuvreClick(Sender: TObject);
    procedure Nbt_TraiterClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure DoConnexion(OkMess: boolean);
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  Main_Dm, Acces_Frm, Traitement_Frm;

{$R *.dfm}

procedure TFrm_Main.DoConnexion(OkMess: boolean);
begin                         
  Nbt_Traiter.Enabled := false;
  Lab_OkConn.Caption := 'Non connecté';
  Lab_OkConn.Font.Color := clMaroon;
  Dm_Main.Ginkoia.Connected := false;
  if (Edt_Base.Text='') or not(FileExists(Edt_Base.Text)) then
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
    Lab_OkConn.Caption := 'Connecté';
    Nbt_Traiter.Enabled := true;  
    Lab_OkConn.Font.Color := clGreen;
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

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Dm_Main.Ginkoia.Connected := false;
  Dm_Main.Free;
  Dm_Main:=nil;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Dm_Main := TDm_Main.Create(Self);

  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  Edt_Base.Text:='';
  Nbt_Traiter.Enabled := false;
  Lab_OkConn.Caption := 'Non connecté'; 
  Lab_OkConn.Font.Color := clMaroon;
  if FileExists(ReperBase+'Data\ginkoia.ib') then
  begin
    Edt_Base.Text := ReperBase+'Data\ginkoia.ib';
    DoConnexion(false);
  end;
end;

procedure TFrm_Main.Nbt_ConnClick(Sender: TObject);
begin 
  DoConnexion(true);
end;

procedure TFrm_Main.Nbt_OuvreClick(Sender: TObject);
begin 
  if OD_Base.Execute then
  begin
    Edt_Base.Text := OD_Base.FileName;
  end;
end;

procedure TFrm_Main.Nbt_TraiterClick(Sender: TObject);
var
  bOk: boolean;
begin
  bOk := false;
  Frm_Acces := TFrm_Acces.Create(Self);
  try
    bOk := (Frm_Acces.ShowModal=mrok);
  finally
    Frm_Acces.Free;
    Frm_Acces:=nil;
  end;
  if not(bOk) then
    exit;
  Frm_Traitement := TFrm_Traitement.Create(Self);
  try
    Frm_Traitement.ShowModal;
  finally
    Frm_Traitement.Free;
    Frm_Traitement:=nil;
  end;
end;

end.
