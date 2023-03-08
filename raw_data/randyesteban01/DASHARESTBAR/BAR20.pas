unit BAR20;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls, DIMime;

type
  TfrmActUsuario = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    QUsuarios: TADOQuery;
    dsUsuarios: TDataSource;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    QUsuariosUsuarioID: TAutoIncField;
    QUsuariosNombre: TWideStringField;
    QUsuariosClave: TWideStringField;
    QUsuariosEstatus: TWideStringField;
    QUsuariosSupervisor: TBooleanField;
    QUsuariosCajero: TBooleanField;
    QUsuariosCamarero: TBooleanField;
    QUsuariostarjetaUsuarioID: TWideStringField;
    QUsuariostarjetaSupervisorID: TWideStringField;
    Label3: TLabel;
    Label4: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    QTarjetaUsu: TADOQuery;
    QTarjetaUsuTarjetaID: TWideStringField;
    dsTarjetaUsu: TDataSource;
    QTarjetaSuper: TADOQuery;
    QTarjetaSuperTarjetaID: TWideStringField;
    dsTarjetaSuper: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QUsuariosNewRecord(DataSet: TDataSet);
    procedure QUsuariosBeforePost(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActUsuario: TfrmActUsuario;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActUsuario.btcloseClick(Sender: TObject);
begin
  QUsuarios.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActUsuario.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActUsuario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActUsuario.btpostClick(Sender: TObject);
begin
  QUsuarios.Post;
  QUsuarios.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActUsuario.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';
end;

procedure TfrmActUsuario.QUsuariosNewRecord(DataSet: TDataSet);
begin
  QUsuariosSupervisor.Value := False;
  QUsuariosCajero.Value := False;
  QUsuariosCamarero.Value := False;
  QUsuariosEstatus.Value := 'ACT';
end;

procedure TfrmActUsuario.QUsuariosBeforePost(DataSet: TDataSet);
begin
  if QUsuarios.State in[dsInsert,dsEdit] then
    QUsuariosClave.Value := MimeEncodeString(QUsuariosClave.Value);
end;

procedure TfrmActUsuario.SpeedButton1Click(Sender: TObject);
begin
  QUsuariostarjetaUsuarioID.Clear;
end;

procedure TfrmActUsuario.SpeedButton2Click(Sender: TObject);
begin
  QUsuariostarjetaSupervisorID.Clear;
end;

end.
