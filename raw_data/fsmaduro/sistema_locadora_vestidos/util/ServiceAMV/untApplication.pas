unit untApplication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Data.DBXFirebird, Data.FMTBcd, Data.DB, Data.SqlExpr, Registry, Vcl.Menus, untClasseSync,
  Vcl.DBCtrls, Data.DBXInterbase;

type
  TfrmAplication = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SQLConnection1: TSQLConnection;
    qryConta1_1: TSQLQuery;
    TrayIcon1: TTrayIcon;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    qryConta1_2: TSQLQuery;
    qryContas: TSQLQuery;
    qryContasUSERNAME: TStringField;
    qryContasSENHA: TStringField;
    qryContasREMINDER_METODO: TIntegerField;
    qryContasREMINDER_VALOR: TIntegerField;
    qryContasREMINDER_PERIODO: TIntegerField;
    qryContasAGENDAS_SINCRONIZADAS: TIntegerField;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    lblConta1: TLabel;
    lblConta2: TLabel;
    lblConta3: TLabel;
    lblConta4: TLabel;
    lblConta5: TLabel;
    lblConta6: TLabel;
    lblConta7: TLabel;
    lblConta8: TLabel;
    lblConta9: TLabel;
    lblConta10: TLabel;
    btnIniciar1: TSpeedButton;
    btnParar1: TSpeedButton;
    lblStatus1: TLabel;
    lblStatus2: TLabel;
    btnParar2: TSpeedButton;
    btnIniciar2: TSpeedButton;
    lblStatus3: TLabel;
    btnParar3: TSpeedButton;
    btnIniciar3: TSpeedButton;
    lblStatus4: TLabel;
    btnParar4: TSpeedButton;
    btnIniciar4: TSpeedButton;
    lblStatus5: TLabel;
    btnParar5: TSpeedButton;
    btnIniciar5: TSpeedButton;
    lblStatus6: TLabel;
    btnParar6: TSpeedButton;
    btnIniciar6: TSpeedButton;
    lblStatus7: TLabel;
    btnParar7: TSpeedButton;
    btnIniciar7: TSpeedButton;
    lblStatus8: TLabel;
    btnParar8: TSpeedButton;
    btnIniciar8: TSpeedButton;
    lblStatus9: TLabel;
    btnParar9: TSpeedButton;
    btnIniciar9: TSpeedButton;
    lblStatus10: TLabel;
    btnParar10: TSpeedButton;
    btnIniciar10: TSpeedButton;
    qryConta2_1: TSQLQuery;
    qryConta2_2: TSQLQuery;
    qryConta4_1: TSQLQuery;
    qryConta4_2: TSQLQuery;
    qryConta3_2: TSQLQuery;
    qryConta3_1: TSQLQuery;
    qryConta8_1: TSQLQuery;
    qryConta8_2: TSQLQuery;
    qryConta7_2: TSQLQuery;
    qryConta7_1: TSQLQuery;
    qryConta6_2: TSQLQuery;
    qryConta6_1: TSQLQuery;
    qryConta5_1: TSQLQuery;
    qryConta5_2: TSQLQuery;
    qryConta9_2: TSQLQuery;
    qryConta9_1: TSQLQuery;
    qryConta10_1: TSQLQuery;
    qryConta10_2: TSQLQuery;
    SQLConnection2: TSQLConnection;
    SQLConnection3: TSQLConnection;
    SQLConnection4: TSQLConnection;
    SQLConnection5: TSQLConnection;
    SQLConnection6: TSQLConnection;
    SQLConnection7: TSQLConnection;
    SQLConnection8: TSQLConnection;
    SQLConnection9: TSQLConnection;
    SQLConnection10: TSQLConnection;
    procedure Abrir1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnIniciar1Click(Sender: TObject);
    procedure btnParar1Click(Sender: TObject);
    procedure lblStatus1Click(Sender: TObject);
  private
    Sync : array [0..9] of SyncAgenda;
    arrQuery1 : array [1..10] of TSQLQuery;
    arrQuery2 : array [1..10] of TSQLQuery;
    arrStatus : array [1..10] of TLabel;

    { Private declarations }
  public
    procedure apontamento;
    procedure PopularPaineis();
    { Public declarations }
  end;

var
  frmAplication: TfrmAplication;

implementation

{$R *.dfm}

procedure TfrmAplication.Abrir1Click(Sender: TObject);
begin
  WindowState := wsNormal;
end;

procedure TfrmAplication.apontamento;
Var
  Registro : TRegistry;
  Local : boolean;
  IP,
  Path_DB,
  user_name ,
  password,
  NomeComunidade,
  ChaveLiberacao,
  chLimiteDizimistas : string;
Begin

  Registro := TRegistry.Create;

  Registro.RootKey := HKEY_CURRENT_USER;

  if not Registro.KeyExists('\Software\AMVSystem') then
  begin
    Registro.OpenKey('\Software\AMVSystem\BANCO_DE_DADOS', True);
    Registro.WriteString('LOCAL'        ,'SIM');
    Registro.WriteString('IP_SERVIDOR'  ,'');
    Registro.WriteString('PATH_SERVIDOR',ExtractFilePath(Application.ExeName) +'bd\'+ 'AMVSYSTEM' +'.GDB');
    Registro.WriteString('USERNAME'     ,'SYSDBA');
    Registro.WriteString('PASSWORD'     ,'masterkey');
    Registro.WriteString('PORTA_IMPRESSORA'     ,'LPT1');
    Registro.CloseKey;

    Registro.OpenKey('\Software\AMVSystem\REGISTRO', True);
    Registro.WriteString('NOME_COMUNIDADE','SEM REGISTRO');
    Registro.WriteString('CHAVE_LIBERACAO','');
    Registro.CloseKey;
  end;

  Registro.OpenKey('\Software\AMVSystem\BANCO_DE_DADOS', False);
  Local       := Registro.ReadString('LOCAL') <> 'NAO';
  IP          := Registro.ReadString('IP_SERVIDOR');
  Path_DB     := Registro.ReadString('PATH_SERVIDOR');
  user_name   := Registro.ReadString('USERNAME');
  password    := Registro.ReadString('PASSWORD');
  Registro.CloseKey;

  Registro.Free;

  if Path_DB = '' then
    Path_DB := ExtractFilePath(Application.ExeName) +'bd\'+ 'AMVSYSTEM' +'.GDB';

  If Not Local Then
    Path_DB := IP+':'+Path_DB
  Else
  Begin
    //Testa se o banco existe
    If Not FileExists(Path_DB) Then
      TrayIcon1.BalloonHint := 'Banco de Dados não encontrato no caminho indicado na chave de registro';
  End;

  SQLConnection1.Params.Values['User_Name'] := user_name;
  SQLConnection1.Params.Values['password']  := password;
  SQLConnection1.Params.Values['Database']  := Path_DB;
  SQLConnection1.Connected := True;

  SQLConnection2.Params.Values['User_Name'] := user_name;
  SQLConnection2.Params.Values['password']  := password;
  SQLConnection2.Params.Values['Database']  := Path_DB;

  SQLConnection3.Params.Values['User_Name'] := user_name;
  SQLConnection3.Params.Values['password']  := password;
  SQLConnection3.Params.Values['Database']  := Path_DB;

  SQLConnection4.Params.Values['User_Name'] := user_name;
  SQLConnection4.Params.Values['password']  := password;
  SQLConnection4.Params.Values['Database']  := Path_DB;

  SQLConnection5.Params.Values['User_Name'] := user_name;
  SQLConnection5.Params.Values['password']  := password;
  SQLConnection5.Params.Values['Database']  := Path_DB;

  SQLConnection6.Params.Values['User_Name'] := user_name;
  SQLConnection6.Params.Values['password']  := password;
  SQLConnection6.Params.Values['Database']  := Path_DB;

  SQLConnection7.Params.Values['User_Name'] := user_name;
  SQLConnection7.Params.Values['password']  := password;
  SQLConnection7.Params.Values['Database']  := Path_DB;

  SQLConnection8.Params.Values['User_Name'] := user_name;
  SQLConnection8.Params.Values['password']  := password;
  SQLConnection8.Params.Values['Database']  := Path_DB;

  SQLConnection9.Params.Values['User_Name'] := user_name;
  SQLConnection9.Params.Values['password']  := password;
  SQLConnection9.Params.Values['Database']  := Path_DB;

  SQLConnection10.Params.Values['User_Name'] := user_name;
  SQLConnection10.Params.Values['password']  := password;
  SQLConnection10.Params.Values['Database']  := Path_DB;


//  IBDatabase.Connected := False;
//  IBTransaction.Active:= False;
//  IBDatabase.DatabaseName := Path_DB;
//  //IBDatabase.Params.Add('user_name=' + user_name);
//  //IBDatabase.Params.Add('password=' + password);
//
//  IBDatabase.Connected := true;
//  IBTransaction.Active:= true;

End;


procedure TfrmAplication.btnIniciar1Click(Sender: TObject);
var
  i: Integer;
  sConta: String;

begin

  if not (Sender as TSpeedButton).Visible then
    Exit;

  i := StrToIntDef(Copy((Sender as TSpeedButton).Name, 11, 2),0);

  (Sender as TSpeedButton).Enabled := False;

  case i of
     1 : SQLConnection1.Connected := False;
     2 : SQLConnection2.Connected := False;
     3 : SQLConnection3.Connected := False;
     4 : SQLConnection4.Connected := False;
     5 : SQLConnection5.Connected := False;
     6 : SQLConnection6.Connected := False;
     7 : SQLConnection7.Connected := False;
     8 : SQLConnection8.Connected := False;
     9 : SQLConnection9.Connected := False;
    10 : SQLConnection10.Connected := False;
  end;

  case i of
     1 : SQLConnection1.Connected := True;
     2 : SQLConnection2.Connected := True;
     3 : SQLConnection3.Connected := True;
     4 : SQLConnection4.Connected := True;
     5 : SQLConnection5.Connected := True;
     6 : SQLConnection6.Connected := True;
     7 : SQLConnection7.Connected := True;
     8 : SQLConnection8.Connected := True;
     9 : SQLConnection9.Connected := True;
    10 : SQLConnection10.Connected := True;
  end;

  case i of
     1 : arrQuery1[i]  := qryConta1_1;
     2 : arrQuery1[i]  := qryConta2_1;
     3 : arrQuery1[i]  := qryConta3_1;
     4 : arrQuery1[i]  := qryConta4_1;
     5 : arrQuery1[i]  := qryConta5_1;
     6 : arrQuery1[i]  := qryConta6_1;
     7 : arrQuery1[i]  := qryConta7_1;
     8 : arrQuery1[i]  := qryConta8_1;
     9 : arrQuery1[i]  := qryConta9_1;
    10 : arrQuery1[i]  := qryConta10_1;
  end;

  case i of
     1 : arrQuery2[i]  := qryConta1_2;
     2 : arrQuery2[i]  := qryConta2_2;
     3 : arrQuery2[i]  := qryConta3_2;
     4 : arrQuery2[i]  := qryConta4_2;
     5 : arrQuery2[i]  := qryConta5_2;
     6 : arrQuery2[i]  := qryConta6_2;
     7 : arrQuery2[i]  := qryConta7_2;
     8 : arrQuery2[i]  := qryConta8_2;
     9 : arrQuery2[i]  := qryConta9_2;
    10 : arrQuery2[i]  := qryConta10_2;
  end;

  case i of
    1 : arrStatus[i]  := lblStatus1;
    2 : arrStatus[i]  := lblStatus2;
    3 : arrStatus[i]  := lblStatus3;
    4 : arrStatus[i]  := lblStatus4;
    5 : arrStatus[i]  := lblStatus5;
    6 : arrStatus[i]  := lblStatus6;
    7 : arrStatus[i]  := lblStatus7;
    8 : arrStatus[i]  := lblStatus8;
    9 : arrStatus[i]  := lblStatus9;
    10 : arrStatus[i] := lblStatus10;
  end;

  case i of
    1 : sConta  := lblConta1.Caption;
    2 : sConta  := lblConta2.Caption;
    3 : sConta  := lblConta3.Caption;
    4 : sConta  := lblConta4.Caption;
    5 : sConta  := lblConta5.Caption;
    6 : sConta  := lblConta6.Caption;
    7 : sConta  := lblConta7.Caption;
    8 : sConta  := lblConta8.Caption;
    9 : sConta  := lblConta9.Caption;
    10 : sConta := lblConta10.Caption;
  end;

  case i of
     1 : btnParar1.Enabled := True;
     2 : btnParar2.Enabled := True;
     3 : btnParar3.Enabled := True;
     4 : btnParar4.Enabled := True;
     5 : btnParar5.Enabled := True;
     6 : btnParar6.Enabled := True;
     7 : btnParar7.Enabled := True;
     8 : btnParar8.Enabled := True;
     9 : btnParar9.Enabled := True;
    10 : btnParar10.Enabled := True;
  end;

  if not Assigned(Sync[i-1]) then
    Sync[i-1] := SyncAgenda.Create(False,frmAplication,arrStatus[i],arrQuery1[i],arrQuery2[i],sConta, i);
end;

procedure TfrmAplication.btnParar1Click(Sender: TObject);
var
  i : Integer;
begin

  if not (Sender as TSpeedButton).Visible then
    Exit;

  i := StrToIntDef(Copy((Sender as TSpeedButton).Name, 9, 2),0);

  Sync[i-1].Terminate;
  FreeAndNil(Sync[i-1]);

  (Sender as TSpeedButton).Enabled := False;

  case i of
     1 : SQLConnection1.Connected := False;
     2 : SQLConnection2.Connected := False;
     3 : SQLConnection3.Connected := False;
     4 : SQLConnection4.Connected := False;
     5 : SQLConnection5.Connected := False;
     6 : SQLConnection6.Connected := False;
     7 : SQLConnection7.Connected := False;
     8 : SQLConnection8.Connected := False;
     9 : SQLConnection9.Connected := False;
    10 : SQLConnection10.Connected := False;
  end;

  case i of
     1 : btnIniciar1.Enabled := True;
     2 : btnIniciar2.Enabled := True;
     3 : btnIniciar3.Enabled := True;
     4 : btnIniciar4.Enabled := True;
     5 : btnIniciar5.Enabled := True;
     6 : btnIniciar6.Enabled := True;
     7 : btnIniciar7.Enabled := True;
     8 : btnIniciar8.Enabled := True;
     9 : btnIniciar9.Enabled := True;
    10 : btnIniciar10.Enabled := True;
  end;

  arrStatus[i].Caption := 'Parado';

end;

procedure TfrmAplication.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := false;
  Visible := false;
  Application.Minimize;
end;

procedure TfrmAplication.PopularPaineis();
var
  i: Integer;
begin
  qryContas.Close;
  qryContas.Open;

  for I := 1 to 10 do
  begin
    case i of
      1 :begin
        lblConta1.Caption := '';
        lblStatus1.Caption := '';
        btnIniciar1.Visible := False;
        btnParar1.Visible := False;
      end;
      2 :begin
        lblConta2.Caption := '';
        lblStatus2.Caption := '';
        btnIniciar2.Visible := False;
        btnParar2.Visible := False;
      end;
      3 :begin
        lblConta3.Caption := '';
        lblStatus3.Caption := '';
        btnIniciar3.Visible := False;
        btnParar3.Visible := False;
      end;
      4 :begin
        lblConta4.Caption := '';
        lblStatus4.Caption := '';
        btnIniciar4.Visible := False;
        btnParar4.Visible := False;
      end;
      5 :begin
        lblConta5.Caption := '';
        lblStatus5.Caption := '';
        btnIniciar5.Visible := False;
        btnParar5.Visible := False;
      end;
      6 :begin
        lblConta6.Caption := '';
        lblStatus6.Caption := '';
        btnIniciar6.Visible := False;
        btnParar6.Visible := False;
      end;
      7 :begin
        lblConta7.Caption := '';
        lblStatus7.Caption := '';
        btnIniciar7.Visible := False;
        btnParar7.Visible := False;
      end;
      8 :begin
        lblConta8.Caption := '';
        lblStatus8.Caption := '';
        btnIniciar8.Visible := False;
        btnParar8.Visible := False;
      end;
      9 :begin
        lblConta9.Caption := '';
        lblStatus9.Caption := '';
        btnIniciar9.Visible := False;
        btnParar9.Visible := False;
      end;
      10 :begin
        lblConta10.Caption := '';
        lblStatus10.Caption := '';
        btnIniciar10.Visible := False;
        btnParar10.Visible := False;
      end;
    else

    end;
  end;

  i := 0;
  while not qryContas.Eof do
  begin
    i := i + 1;
    case i of
      1 :begin
      lblConta1.Caption := qryContasUSERNAME.Text;
      lblStatus1.Caption := 'Parado';
      btnIniciar1.Visible := True;
      btnParar1.Visible := True;
    end;
    2 :begin
      lblConta2.Caption := qryContasUSERNAME.Text;
      lblStatus2.Caption := 'Parado';
      btnIniciar2.Visible := True;
      btnParar2.Visible := True;
    end;
    3 :begin
      lblConta3.Caption := qryContasUSERNAME.Text;
      lblStatus3.Caption := 'Parado';
      btnIniciar3.Visible := True;
      btnParar3.Visible := True;
    end;
    4 :begin
      lblConta4.Caption := qryContasUSERNAME.Text;
      lblStatus4.Caption := 'Parado';
      btnIniciar4.Visible := True;
      btnParar4.Visible := True;
    end;
    5 :begin
      lblConta5.Caption := qryContasUSERNAME.Text;
      lblStatus5.Caption := 'Parado';
      btnIniciar5.Visible := True;
      btnParar5.Visible := True;
    end;
    6 :begin
      lblConta6.Caption := qryContasUSERNAME.Text;
      lblStatus6.Caption := 'Parado';
      btnIniciar6.Visible := True;
      btnParar6.Visible := True;
    end;
    7 :begin
      lblConta7.Caption := qryContasUSERNAME.Text;
      lblStatus7.Caption := 'Parado';
      btnIniciar7.Visible := True;
      btnParar7.Visible := True;
    end;
    8 :begin
      lblConta8.Caption := qryContasUSERNAME.Text;
      lblStatus8.Caption := 'Parado';
      btnIniciar8.Visible := True;
      btnParar8.Visible := True;
    end;
    9 :begin
      lblConta9.Caption := qryContasUSERNAME.Text;
      lblStatus9.Caption := 'Parado';
      btnIniciar9.Visible := True;
      btnParar9.Visible := True;
    end;
    10 :begin
      lblConta10.Caption := qryContasUSERNAME.Text;
      lblStatus10.Caption := 'Parado';
      btnIniciar10.Visible := True;
      btnParar10.Visible := True;
    end;
    else

    end;
    qryContas.Next;
  end;

end;

procedure TfrmAplication.lblStatus1Click(Sender: TObject);
begin
  ShowMessage((Sender as TLabel).Caption);
end;

procedure TfrmAplication.SpeedButton1Click(Sender: TObject);
var
  i : Integer;
  sTime: TDateTime;
begin
  sTime := Now;
  for I := 1 to 10 do
  begin
    case i of
       1 : btnIniciar1Click(btnIniciar1);
       2 : btnIniciar1Click(btnIniciar2);
       3 : btnIniciar1Click(btnIniciar3);
       4 : btnIniciar1Click(btnIniciar4);
       5 : btnIniciar1Click(btnIniciar5);
       6 : btnIniciar1Click(btnIniciar6);
       7 : btnIniciar1Click(btnIniciar7);
       8 : btnIniciar1Click(btnIniciar8);
       9 : btnIniciar1Click(btnIniciar9);
      10 : btnIniciar1Click(btnIniciar10);
    else

    end;

    while Now <= sTime + StrToTime('00:10:00') do
       Application.ProcessMessages;

  end;

  SpeedButton1.Enabled := False;
  SpeedButton2.Enabled := True;
end;

procedure TfrmAplication.SpeedButton2Click(Sender: TObject);
var
  i: Integer;
begin
  for I := 1 to 10 do
  begin
    case i of
       1 : btnParar1Click(btnParar1);
       2 : btnParar1Click(btnParar2);
       3 : btnParar1Click(btnParar3);
       4 : btnParar1Click(btnParar4);
       5 : btnParar1Click(btnParar5);
       6 : btnParar1Click(btnParar6);
       7 : btnParar1Click(btnParar7);
       8 : btnParar1Click(btnParar8);
       9 : btnParar1Click(btnParar9);
      10 : btnParar1Click(btnParar10);
    else

    end;
  end;
  SpeedButton1.Enabled := True;
  SpeedButton2.Enabled := False;
end;

procedure TfrmAplication.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAplication.SpeedButton4Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmAplication.TrayIcon1Click(Sender: TObject);
begin
  Show;
end;

end.
