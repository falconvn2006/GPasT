unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, I_BaseClientNationale1, StdCtrls;

type

  TThreadGOSTerminateEvent = procedure(Sender : TObject; Statut, ID : Integer) of object;

  TFrm_Main = class(TForm)
    LV_Result: TListView;
    Ed_NbThread: TEdit;
    Lb_NbThread: TLabel;
    Btn_Go: TButton;
    procedure Btn_GoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Déclarations privées }
    FListThread : TList;

    procedure ThreadGOSOnTerminate(Sender : TObject; Statut, ID : Integer);
  public
    { Déclarations publiques }
  end;

  TThreadGos = class(TThread)
  private
    FBaseClientNational : I_BaseClientNationale;
    FOnTerminateGOS : TThreadGOSTerminateEvent;
    FStatut : Integer;
    FID : Integer;

    procedure OnTerminateEvent(Sender : TObject);
    function Entrelacement(Const S1, S2: String): String;
  public
    Constructor Create(CreateSupended : Boolean);
    Destructor Destroy; Override;
  protected
    procedure Execute; Override;
  published
    property OnTerminateGOS : TThreadGOSTerminateEvent read FOnTerminateGOS write FOnTerminateGOS;
    property ID : Integer read FID write FID;
  end;

var
  Frm_Main: TFrm_Main;
  StartThread: Boolean;

implementation

{$R *.dfm}

uses
  MD5Api, ActiveX;

{ TThreadGos }

constructor TThreadGos.Create(CreateSupended: Boolean);
begin
  inherited Create(CreateSupended);
  FBaseClientNational := GetI_BaseClientNationale(False);
  FStatut := -1;
  Self.FreeOnTerminate := True;
  Self.OnTerminate := OnTerminateEvent;
end;

destructor TThreadGos.Destroy;
begin

  inherited;
end;

function TThreadGos.Entrelacement(const S1, S2: String): String;
var
  i, vPos: integer;
  Buffer: String;
begin
  Result:= '';
  Buffer:= S2;
  vPos:= 1;
  for i:= 1 to Length(S1) do
    begin
      Insert(S1[i], Buffer, vPos);
      Inc(vPos, 2);
    end;
  Result:= Buffer;
end;

procedure TThreadGos.Execute;
var
  sDate, sPassword : String;
  MyInfoClients : TInfoClients;
begin
  MyInfoClients := Nil;
  try
    CoInitialize(Nil);
    try
      inherited;

      while not StartThread do
      begin

      end;


      sDate := FBaseClientNational.GetTime;
      sPassword := MD5(Entrelacement(sDate, 'toto'));


      MyInfoClients := FBaseClientNational.InfoClientGet(sDate, sPassword, 1, '', 'CES', '', '', '', '');
    Except
      on E : Exception do
      begin
        Self.FStatut := 1;
      end;
    end;
  finally
    if MyInfoClients.iErreur = 0 then
    begin
      Self.FStatut := 0;
    end
    else
    begin
      Self.FStatut := 1;
    end;
    FreeAndNil(MyInfoClients);
    CoUninitialize;
  end;
end;

procedure TThreadGos.OnTerminateEvent(Sender: TObject);
begin
  if Assigned(Self.FOnTerminateGOS) then
    Self.FOnTerminateGOS(Sender, FStatut, FID);
end;

procedure TFrm_Main.Btn_GoClick(Sender: TObject);
var
  NbThread, i : Integer;
  myThread : TThreadGos;
  ListItem : TListItem;
begin

  if Assigned(FListThread) then
    FreeAndNil(FListThread);

  FListThread := TList.Create;
  Btn_Go.Enabled := False;
  StartThread := False;
  LV_Result.Items.Clear;
  NbThread := StrToIntDef(Trim(Ed_NbThread.Text), -1);
  if not NbThread > 0 then
    ShowMessage('Nombre de Thread invalide');

  for i := 0 to NbThread - 1 do
  begin
    myThread := TThreadGos.Create(True);
    myThread.ID := i;
    ListItem := LV_Result.Items.Add;
    ListItem.Caption := 'Thread ' + IntToStr(i);
    myThread.OnTerminateGOS := Self.ThreadGOSOnTerminate;
    FListThread.Add(myThread);
  end;

  for i  := 0 to FListThread.Count - 1 do
  begin
    TThreadGos(FListThread[i]).Suspended := False;
  end;

  StartThread := True;
  Btn_Go.Enabled := True;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FListThread) then
    FreeAndNil(FListThread);
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  StartThread := False;
end;

procedure TFrm_Main.ThreadGOSOnTerminate(Sender: TObject; Statut, ID: Integer);
var
  sStatut : String;
begin
  if Statut = 0 then
    sStatut := 'OK'
  else
    sStatut := 'NOK';

  if (ID <= LV_Result.Items.Count - 1) and(Assigned(LV_Result.Items[ID])) then
    LV_Result.Items[ID].Caption := LV_Result.Items[ID].Caption + ' ----> ' + sStatut
end;

end.

