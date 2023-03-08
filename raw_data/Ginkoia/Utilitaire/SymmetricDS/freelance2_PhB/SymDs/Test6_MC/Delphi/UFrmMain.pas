unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  Data.DB, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.StdCtrls, Vcl.Buttons, FireDAC.Phys.IBBase, FireDAC.Phys.IB,
  FireDAC.Comp.DataSet, Vcl.ExtCtrls, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TForm1 = class(TForm)
    FDLocalCnx: TFDConnection;
    FDRemoteCnx: TFDConnection;
    FDQryGetNewId: TFDQuery;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDQryGetRemoteId: TFDQuery;
    FDQrySetEquivalence: TFDQuery;
    Memo1: TMemo;
    BtnActiver: TBitBtn;
    BtnSuspendre: TBitBtn;
    Timer1: TTimer;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure BtnActiverClick(Sender: TObject);
    procedure BtnSuspendreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    FLocalHost: string;
    FLocalDbFileName: string;
    FLocalDBUser: string;
    FLocalDBPassWord: string;
    FRemoteHost: string;
    FRemoteDbFileName: string;
    FRemoteDBUser: string;
    FRemoteDBPassWord: string;
    FStopped: Boolean;
    procedure Traitement;
    procedure ConnectLocalDB;
    procedure DisconnectLocalDB;
    function ConnectRemoteDB: Boolean;
    procedure DisconnectRemoteDB;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses
  IniFiles;

{$R *.dfm}

procedure TForm1.BtnActiverClick(Sender: TObject);
begin
  BtnActiver.Enabled := False;
  Traitement;
end;

procedure TForm1.BtnSuspendreClick(Sender: TObject);
begin
  BtnSuspendre.Enabled := False;
  FStopped := True;
end;

procedure TForm1.ConnectLocalDB;
begin
  try
    FDLocalCnx.Connected := True;
  except
    on E: Exception do
    begin
      FStopped := True;
      Memo1.Lines.Add(E.Message);
    end;
  end;
  //
  if FDLocalCnx.Connected then
  begin
    Memo1.Lines.Add('Connecté à la base locale : ' + FLocalDbFileName);
    FStopped := False;
  end
  else
  begin
    Memo1.Lines.Add('Echec de connexion à la base locale : ' + FLocalDbFileName);
    FStopped := True;
  end;
end;

function TForm1.ConnectRemoteDB: Boolean;
begin
  FDRemoteCnx.Connected := True;
  Result := FDRemoteCnx.Connected;
end;

procedure TForm1.DisconnectLocalDB;
begin
  FDLocalCnx.Connected := False;
end;

procedure TForm1.DisconnectRemoteDB;
begin
  FDRemoteCnx.Connected := False;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BtnActiver.Enabled then
    Action := caFree
  else
    Action := caNone;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
  BtnSuspendre.Enabled := False;
  with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'))do
  try
    //
    FLocalHost := ReadString('LOCAL', 'HOST', 'localhost');
    FLocalDbFileName := ReadString('LOCAL', 'DATABASE', '');
    FLocalDBUser := ReadString('LOCAL', 'USER', 'SYSDBA');
    FLocalDBPassWord := ReadString('LOCAL', 'PWD', 'masterkey');
    //
    FRemoteHost := ReadString('REMOTE', 'HOST', 'localhost');
    FRemoteDbFileName := ReadString('REMOTE', 'DATABASE', '');
    FRemoteDBUser := ReadString('REMOTE', 'USER', 'SYSDBA');
    FRemoteDBPassWord := ReadString('REMOTE', 'PWD', 'masterkey');
    //
    FDLocalCnx.Params.Add('DriverID=IB');
    FDLocalCnx.Params.Add('Server=' + FLocalHost);
    FDLocalCnx.Params.Add('Protocol=TCPIP'); // PHB
    FDLocalCnx.Params.Add('Database=' + FLocalDbFileName);
    FDLocalCnx.Params.Add('User_Name=' + FLocalDBUser);
    FDLocalCnx.Params.Add('Password=' + FLocalDBPassWord);
    //
    FDRemoteCnx.Params.Add('DriverID=IB');
    FDRemoteCnx.Params.Add('Server=' + FRemoteHost);
    FDRemoteCnx.Params.Add('Protocol=TCPIP'); // PHB
    FDRemoteCnx.Params.Add('Database=' + FRemoteDbFileName);
    FDRemoteCnx.Params.Add('User_Name=' + FRemoteDBUser);
    FDRemoteCnx.Params.Add('Password=' + FRemoteDBPassWord);
    //
    Caption := 'Base surveillée : ' + ExtractFileName(FLocalDbFileName);
    Hint := 'Base surveillée : ' + FLocalDbFileName;
    ShowHint := True;
  finally
    Free;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  TableName: string;
  LocalId: Integer;
  RemoteId: Integer;
begin
  //
  // Memo1.Lines.Add('Début du traitement...');
  // Connexion à la base distante
  if not ConnectRemoteDB then
  begin
    Memo1.Lines.Add('Echec de connexion à la base distante : ' + FRemoteDbFileName);
    //Memo1.Lines.Add('Fin du traitement...');
    Exit;
  end;

  Memo1.Lines.Add('Connecté à la base distante : ' + FRemoteDbFileName);
  //
  Memo1.Lines.Add('Désactivation du timer...');
  Timer1.Enabled := False;
  try
    //
    Memo1.Lines.Add('Recherche des ID à traiter...');
    FDQryGetNewId.Open;
    try
      while not FDQryGetNewId.Eof do
      begin
        // Id local et nom de table
        LocalId := FDQryGetNewId.FieldByName('LOCALID').AsInteger;
        TableName := FDQryGetNewId.FieldByName('TABLENAME').AsString;

        // Récupération de l'Id distant
        FDQryGetRemoteId.ParamByName('TableName').AsString := TableName;
        FDQryGetRemoteId.Open;
        try
          RemoteId := FDQryGetRemoteId.FieldByName('ID').AsInteger;
          //Memo1.Lines.Add('Table : ' + TableName + ', Id = ' + IntToStr(LocalId) + ', RemoteId = ' + IntToStr(RemoteId));
        finally
          FDQryGetRemoteId.Close;
        end;

        // Actualisation de la table d'équivalence et des lignes à répliquer
        FDQrySetEquivalence.ParamByName('LocalId').AsInteger := LocalId;
        FDQrySetEquivalence.ParamByName('RemoteId').AsInteger := RemoteId;
        FDQrySetEquivalence.ExecSQL;
        Memo1.Lines.Add('Table : ' + TableName + ', Id = ' + IntToStr(LocalId) + ', RemoteId = ' + IntToStr(RemoteId));

        // Id suivant
        FDQryGetNewId.Next;
      end;
    finally
      FDQryGetNewId.Close;
    end;
  finally
    DisconnectRemoteDB;
    Memo1.Lines.Add('Réactivation du timer...');
    Memo1.Lines.Add('-------------------------');
    Timer1.Enabled := True;
    //Memo1.Lines.Add('Fin du traitement...');
  end;
end;

procedure TForm1.Traitement;
begin
  FStopped := False;
  BtnSuspendre.Enabled := True;
  //
  ConnectLocalDB;
  try
    Timer1.Enabled := True;
    while not FStopped do
    begin
      Sleep(250);
      Application.ProcessMessages;
    end;

  finally
    Timer1.Enabled := False;
    DisconnectLocalDB;
  end;
  //
  BtnSuspendre.Enabled := False;
  BtnActiver.Enabled := True;
  Memo1.Lines.Add('Arrêt de la surveillance...');
end;

end.
