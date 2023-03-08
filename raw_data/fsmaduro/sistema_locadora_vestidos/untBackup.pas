unit untBackup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, Mask, wwdbedit, Wwdotdot, Wwdbcomb, wwcheckbox, Grids, Wwdbigrd,
  Wwdbgrid, FileCtrl, Gauges, backup, ExtCtrls, Funcao;

type
  TfrmBackup = class(TForm)
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    Label1: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    lblDiretorio: TLabel;
    BackupFile1: TBackupFile;
    rgOpcao: TRadioGroup;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    FormChamado : Tform;
    { Public declarations }
  end;

var
  frmBackup: TfrmBackup;

implementation

uses untDados;


{$R *.dfm}

procedure TfrmBackup.btn_okClick(Sender: TObject);
var
  Arquivo, NomeBanco: String;
  List: TStringList;
begin
  if rgOpcao.ItemIndex = 0 then
  begin
    List := TStringList.Create;

    if application.MessageBox('Deseja Realmente Fazer Backup do Banco de Dados?', 'Backup', MB_YESNO + MB_ICONQUESTION) = idno then
      Abort;

    dados.IBDatabase.Connected := False;

    if (Uppercase(Copy(DirectoryListBox1.Directory,1,1)) = 'A') or
       (Uppercase(Copy(DirectoryListBox1.Directory,1,1)) = 'B') then
      BackupFile1.MaxSize := 1400000
    else
      BackupFile1.MaxSize := 0;

    NomeBanco := dados.IBDatabase.DatabaseName;

    List.Add(NomeBanco);

    Arquivo := DirectoryListBox1.Directory+'\AMVSystem.bck';

    if BackupFile1.Backup(List, Arquivo) then
    begin
      Application.MessageBox(Pchar('Terminado!'+#13+
                                   'Compressão: ' +IntToStr(BackupFile1.CompressionRate)+'%'+#13+
                                   'Tamanho: '+IntToStr(BackupFile1.SizeTotal)),'Backup', MB_OK+MB_ICONINFORMATION);
      BackupFile1.Stop;
    end
    else
      Application.MessageBox('Backup não Realizado!','Backup', MB_OK+MB_ICONINFORMATION);

    dados.IBDatabase.Connected := True;
    dados.IBTransaction.Active := True;

    List.Destroy;
  end
  else
  begin

    if application.MessageBox('Deseja Realmente Fazer Restauração do Banco de Dados?', 'Backup', MB_YESNO + MB_ICONQUESTION) = idno then
      Abort;

    dados.IBDatabase.Connected := False;

    NomeBanco := copy(Uppercase(dados.IBDatabase.DatabaseName),1,Pos('AMVSYSTEM.GDB',Uppercase(dados.IBDatabase.DatabaseName))-1);

    NomeBanco := NomeBanco; //+ 'RESTAURADO\';

   {if not DirectoryExists(NomeBanco) then
      CreateDir(NomeBanco); }

    Arquivo := DirectoryListBox1.Directory+'\AMVSystem.bck';

    if BackupFile1.Restore(Arquivo, NomeBanco) then
    begin
      Application.MessageBox('Terminado!','Backup', MB_OK+MB_ICONINFORMATION);
      BackupFile1.Stop;
    end
    else
      Application.MessageBox('Restauração não Realizada!','Backup', MB_OK+MB_ICONINFORMATION);

    dados.IBDatabase.Connected := True;
    dados.IBTransaction.Active := True;
  end;
end;

procedure TfrmBackup.btn_sairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmBackup.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
end;

end.
