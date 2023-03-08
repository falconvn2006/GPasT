unit FrmOptimizeDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls{, dxGDIPlusClasses},
  Vcl.ExtCtrls, Vcl.ComCtrls, uEasy.Threads,uEasy.Types,System.StrUtils, System.DateUtils,
  dxGDIPlusClasses;

type
  TOptimizeDB_Frm = class(TForm)
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Panel1: TPanel;
    sb: TStatusBar;
    Label1: TLabel;
    teIBFile: TEdit;
    BIBFile: TButton;
    mLog: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    BDETAILS: TButton;
    tim1: TTimer;
    Panel4: TPanel;
    cbSweep: TCheckBox;
    cbRecalIndex: TCheckBox;
    cbPrePurge: TCheckBox;
    cbIDXSYMDS: TCheckBox;
    timAuto: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure BIBFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tim1Timer(Sender: TObject);
    procedure BDETAILSClick(Sender: TObject);
    procedure timAutoTimer(Sender: TObject);
  private
    FAUTO      : Boolean;
    FOPTIONS   : string;
    FIB        : string;
    FAutoStart : Cardinal;

    FOptimize : TOptimizeDB;
    FLock     : boolean;
    FStart    : Cardinal;
    { Déclarations privées }
    procedure ReCenter();
    procedure ParamScreen();
    procedure CallBackOptimize(Sender:TObject);
    Procedure StatusCallBack(Const s:String);
    Procedure AddLog(Const s:String);
    procedure Lancement;
  public
    { Déclarations publiques }
  end;

var
  OptimizeDB_Frm: TOptimizeDB_Frm;

implementation

{$R *.dfm}

Uses UCommun;


Procedure TOptimizeDB_Frm.AddLog(Const s:String);
begin
  mLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss : ',Now()) + s);
end;

Procedure TOptimizeDB_Frm.StatusCallBack(Const s:String);
begin
  sb.Panels[1].Text  := s;
  AddLog(s);
end;

procedure TOptimizeDB_Frm.tim1Timer(Sender: TObject);
begin
   tim1.Enabled:=false;
   try
     sb.Panels[0].Text := SecondToTime((GetTickCount-FStart)/1000) ;
   Finally
     tim1.Enabled:=true;
   end;
end;

procedure TOptimizeDB_Frm.timAutoTimer(Sender: TObject);
var vTimeLeft:Double;
begin
   timAuto.Enabled:=false;
   vTimeLeft := ((FAutoStart-GetTickCount)/1000);
   sb.Panels[1].Text := SecondToTime(vTimeLeft);
   if (vTimeLeft<10)  then
      begin
         timAuto.Enabled:=true;
      end
   else
    begin
       Lancement();
    end;
end;

procedure TOptimizeDB_Frm.BDETAILSClick(Sender: TObject);
begin
  Panel1.Visible:=not(Panel1.Visible);
  ParamScreen;
end;

procedure TOptimizeDB_Frm.BIBFileClick(Sender: TObject);
var vOpenDialog : TOpenDialog;
begin
    vOpenDialog := TOpenDialog.Create(Self);
    try
      if vOpenDialog.Execute()
        then
          begin
            teIBFile.Text := vOpenDialog.FileName;
            if FileExists(teIBFile.Text) then
              begin
                //
                Button1.Enabled :=true;
                cbSweep.Enabled :=true;
                cbRecalIndex.Enabled:=true;
                cbPrePurge.Enabled:=true;
                //
              end;
          end;
    finally
      vOpenDialog.Free;
    end;
end;

procedure TOptimizeDB_Frm.Button1Click(Sender: TObject);
begin
  Lancement;
end;

procedure TOptimizeDB_Frm.Lancement;
var vOptions : string;
begin
  Button1.Enabled:=false;
  BIBFile.Enabled:=false;
  teIBFile.Enabled:=false;
  cbRecalIndex.Enabled:=False;
  cbSweep.Enabled:=False;
  cbPrePurge.Enabled:=False;
  cbIDXSYMDS.Enabled:=False;

  FLock:=true;
  tim1.Enabled:=true;
  FStart    := GetTickCount();
  vOptions := IfThen(cbSweep.Checked,vOptions + '1',vOptions + '0');
  vOptions := IfThen(cbRecalIndex.Checked,vOptions + '1',vOptions + '0');
  vOptions := IfThen(cbPrePurge.Checked,vOptions + '1',vOptions + '0');
  vOptions := IfThen(cbIDXSYMDS.Checked,vOptions + '1',vOptions + '0');

  FOptimize := TOptimizeDB.Create(teIBFile.Text, vOptions  , StatusCallBack, nil,CallBackOptimize);
  FOptimize.Start;
end;

procedure TOptimizeDB_Frm.ReCenter();
var
  LRect: TRect;
  X, Y: Integer;
begin
  LRect := Screen.WorkAreaRect;
  X := LRect.Left + (LRect.Right - LRect.Left - Width) div 2;
  Y := LRect.Top + (LRect.Bottom - LRect.Top - Height) div 2;
  SetBounds(X, Y, Width, Height);
end;

procedure TOptimizeDB_Frm.ParamScreen();
begin
    if not(Panel1.Visible)
      then
          begin
             Self.Height := 400;
             BDETAILS.Caption:='Voir les détails';
          end
      else
        begin
            Self.Top := 100;
            Self.Height := 700;
            BDETAILS.Caption:='Cacher les détails';
        end;
  ReCenter();
end;



procedure TOptimizeDB_Frm.CallBackOptimize(Sender:TObject);
begin
  bIBFile.Enabled:=True;
  teIBFile.Enabled:=True;
  cbRecalIndex.Enabled:=True;
  cbSweep.Enabled:=true;
  cbPrePurge.Enabled:=true;
  cbIDXSYMDS.Enabled:=True;

  FLock := false;
  tim1.Enabled:=False;
  if FOptimize.NBErrors<>0 then
    begin
      StatusCallBack('Erreur !');
    end
    else
    begin
       StatusCallBack('Terminé avec Succès');
       if FAuto
          then Close;
    end;
end;


procedure TOptimizeDB_Frm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := not(FLock);
end;

procedure TOptimizeDB_Frm.FormCreate(Sender: TObject);
var param:string;
    value:string;
    i:integer;
begin
    FLock:=false;
    ParamScreen();

    FAUTO      :=false;
    FOPTIONS   :='1111';
    FIB        :='';

    for i :=1 to ParamCount do
       begin
           if lowercase(ParamStr(i))='auto'  then FAUTO:=true;
           param:=Copy(ParamStr(i),1,Pos('=',ParamStr(i))-1);
           value:=Copy(ParamStr(i),Pos('=',ParamStr(i))+1,length(ParamStr(i)));
            If lowercase(param)='options'
              then FOPTIONS := value;
            If lowercase(param)='ib'
              then FIB := value;
       end;

    if FAUTO and FileExists(FIB)  then
      begin
        // Quelques secondes avant de lancer le traitement ---
        teIBFile.Text := FIB;
        FAutoStart := GetTickCount() + 10000;

        Button1.Enabled      :=true;

        cbSweep.Checked      := FOPTIONS[1]='1';
        cbRecalIndex.Checked := FOPTIONS[2]='1';
        cbPrePurge.Checked   := FOPTIONS[3]='1';
        cbIDXSYMDS.Checked   := FOPTIONS[4]='1';

        timAuto.Enabled:=true;
        // ---------------------------------------------------


      end;

end;

end.
