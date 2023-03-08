unit Cria.Schema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Imaging.pngimage,Base.Dados, Midaslib;

type
  TTelaPrincipal = class(TForm)
    Timer1: TTimer;
    TrayIcon: TTrayIcon;
    PopupMenu1: TPopupMenu;
    AbrirRecebeDfe1: TMenuItem;
    N1: TMenuItem;
    Encerrar1: TMenuItem;
    Panel1: TPanel;
    Memo1: TMemo;
    Image1: TImage;
    TimerCriaBanco: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure AbrirRecebeDfe1Click(Sender: TObject);
    procedure Encerrar1Click(Sender: TObject);
    procedure TimerCriaBancoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    procedure OcultarEmTrayIcon;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TelaPrincipal: TTelaPrincipal;

implementation

{$R *.dfm}

procedure TTelaPrincipal.AbrirRecebeDfe1Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  Self.Show;
  TrayIcon.Visible := False;
  ShowWindow(Application.Handle, SW_SHOW);
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TTelaPrincipal.Encerrar1Click(Sender: TObject);
begin
  if Application.MessageBox('Deseja fechar a verificação de novos clientes? Caso algum cliente entre em nosso site e realize o cadastro o novo banco de dados não será criado, CUIDADO!', 'Sair', mb_iconquestion + mb_yesno) = idYes then
  begin
    Application.Terminate;
  end;
end;

procedure TTelaPrincipal.FormClose(Sender: TObject;
                                   var Action: TCloseAction);
begin
   // Bloqueia formulário para não ser fechado
  Action:=caNone;
  // Minimiza
  Timer1.Enabled := True;
end;

procedure TTelaPrincipal.FormShow(Sender: TObject);
var
  BaseDados: TBaseDados;
begin
    BaseDados := TBaseDados.Create(nil);
  // Tenta conectar ao banco de dados
  if BaseDados.ConectarUsuario('localhost:1521/xe',
                              'usuario',
                              'Ralios3105') then
  begin
    TimerCriaBanco.Enabled := True;
  end
  else
  begin
   // ShowMessage('Erro ao realizar conexão com banco');
    exit;
  end;
end;

procedure TTelaPrincipal.Timer1Timer(Sender: TObject);
begin
  OcultarEmTrayIcon();
end;

procedure TTelaPrincipal.TimerCriaBancoTimer(Sender: TObject);
var
  TemNovo : boolean;
  I: integer;
  BaseDados: TBaseDados;
begin
  TimerCriaBanco.Enabled := False;

    Try
    BaseDados := TBaseDados.Create(nil);

  With BaseDados do
  begin
    if Cdsax1.Active = False then
    begin
      CdsAx1.Close;
      QryAx1.close;
      QryAx1.SQL.Clear;
      QryAx1.SQL.Add('SELECT schema_criado,');
      QryAx1.SQL.Add('       schema');
      QryAx1.SQL.Add('  FROM usuario');
      QryAx1.SQL.Add(' WHERE schema_criado = ''N''');
      CdsAx1.Open;
    end
    else
    begin
      CdsAx1.Refresh;
    end;

    CdsAx1.First;
    if CdsAx1.RecordCount > 0 then
    begin
      if Copy(Cdsax1.FieldByName('schema').AsString,1,8) = 'CONTROLE'  then
      begin
        Memo1.Clear;
        Memo1.Lines.Add('cd C:\oraclexe\app\oracle\product\11.2.0\server\bin');
        Memo1.Lines.Add('impdp system/oracle4U@localhost:1521/xe dumpfile=TI9G30.DAMP remap_schema=TI9G30:'+ Cdsax1.FieldByName('schema').AsString);
        Memo1.Lines.SaveToFile('C:\oraclexe\app\oracle\admin\XE\dpdump\IMP_TI9G30.bat');

        //cria schema com base no dump que está localmente no servidor.
        winexec('C:\oraclexe\app\oracle\admin\XE\dpdump\IMP_TI9G30.bat',sw_normal);
      end
      else if Copy(Cdsax1.FieldByName('schema').AsString,1,7) = 'CLINICA'  then
      begin
        Memo1.Clear;
        Memo1.Lines.Add('cd C:\oraclexe\app\oracle\product\11.2.0\server\bin');
        Memo1.Lines.Add('impdp system/oracle4U@localhost:1521/xe dumpfile=TI9C30.DAMP remap_schema=TI9C30:'+ Cdsax1.FieldByName('schema').AsString);
        Memo1.Lines.SaveToFile('C:\oraclexe\app\oracle\admin\XE\dpdump\IMP_TI9C30.bat');

        //cria schema com base no dump que está localmente no servidor.
        winexec('C:\oraclexe\app\oracle\admin\XE\dpdump\IMP_TI9C30.bat',sw_normal);
      end;

      for I := 1 to 30 do
      begin
        Sleep(1000);
        //testa conexão com novo banco de dados
        if BaseDados.ConectarNovoSchema('localhost:1521/xe',
                                        BaseDados.Cdsax1.FieldByName('schema').AsString,
                                        'Ralios3105') then

        begin
          //volta conexão com banco usuario para atualizar tabela
          With BaseDados do
          begin
            ADOConnectionUsuario.BeginTrans;

            Try
              QryAx3.close;
              QryAx3.SQL.Clear;
              QryAx3.SQL.Add('UPDATE usuario SET');
              QryAx3.SQL.Add('       schema_criado  = ''S''');
              QryAx3.SQL.Add(' WHERE schema = ' + QuotedStr(BaseDados.Cdsax1.FieldByName('schema').AsString));
              QryAx3.ExecSQL;

              ADOConnectionUsuario.CommitTrans;
            Except
              on e:exception do
              begin
                ADOConnectionUsuario.RollbackTrans;
              end;
            End;
          end;
          break;
        end;
      end;
    end;
  end;
    Finally
    BaseDados.Free;
    BaseDados := nil;
  End;
  TimerCriaBanco.Enabled := True;
end;

procedure TTelaPrincipal.OcultarEmTrayIcon();
begin
  // Minimiza
  Self.WindowState := wsMinimized;
  ShowWindow(Application.Handle, SW_HIDE);
  TrayIcon.Visible := True;
  TrayIcon.Animate := True;
  //TrayIcon.ShowBalloonHint;
  Self.Hide;
end;


end.
