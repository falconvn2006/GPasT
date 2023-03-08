unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.UI.Intf, FireDAC.FMXUI.Login, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Objects,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
 TUser = class
  UID: Integer;
  uPerfil : Integer;
  UAlias: String;
  UNombre: String;
  UClave: String;
  UState: Integer;
  UPermisos: TStrings;
  function login(user: String; clave: String): Boolean;
 end;


type
  TfLogin = class(TForm)
    edUser: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    Button2: TButton;
    Label3: TLabel;
    Line1: TLine;
    procedure Button2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

{$R *.fmx}

uses uPpal, dmData;



procedure TfLogin.btnOKClick(Sender: TObject);
var
  User: TUser;
  Perfil : string;
begin

  User := TUser.Create;

  //Hacemos el Login
  if User.login(edUser.Text,edPassword.Text) then
  begin
   fPPal.MenuItem2.Enabled := User.uPerfil=1;
   fPPal.MenuItem1.Enabled := (User.uPerfil = 1) or (User.uPerfil=2);
   if User.uPerfil=1 then
   begin
      Perfil := 'ADMINISTRADOR';
   end
   else
   begin
      Perfil := 'USUARIO';
   end;
   fPPal.Label3.Text := Perfil;
   fPPal.Label2.Text := User.UNombre;
   Close; //Si los datos son verdaderos cerramos la ventana de login
  end
  else
  begin
    edUser.SetFocus;
  end;

  User.Free;

end;

procedure TfLogin.Button2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfLogin.FormHide(Sender: TObject);
begin

end;

{ TUser }

function TUser.login(user, clave: String): Boolean;
begin
  var Login: TFDQuery; //Componentes FireDAC, puedes hacer uso de otros.
  begin
   if user.IsEmpty or clave.IsEmpty  then
   begin
      ShowMessage('Registre Usuario y Contraseña');
      Result := FALSE;
      Exit;
   end;

   Login := TFDQuery.Create(nil);

   Login.Connection := dmDatos.Connection; //Datos es el DataModule y dbDatos es un TFDConnection

   //Primero verificamos si existe el usuario (Alias)
   Login.SQL.Text := 'SELECT * FROM usuarios '+
    'WHERE usu_cusuario = :user';
   Login.ParamByName('user').AsString := User;

   try
    Login.Open;
   Except
    On E:EFDDBEngineException do
    begin
      ShowMessage(e.Message);
      Abort;
    end;
  end;

   //Si existe el usuario comparamos la clave/contraseña
   if not Login.IsEmpty then
   begin
    if (Login.FieldByName('usu_cestado').AsString = 'HABILITADO') then
    begin
      if (Login.FieldByName('usu_cpassword').AsString = Clave) then
      begin
         Result := True; //Devolvemos verdadero si concuerda
         //Cargamos algunos datos del usuario
         UID := Login.FieldByName('usu_nid').AsInteger;
         uPerfil := Login.FieldByName('usu_nperfil').AsInteger;
         UAlias := Login.FieldByName('usu_cusuario').AsString;
         UNombre := Login.FieldByName('usu_cnombre').AsString;
      end else
      begin
         Result := False; //Devolvemos Falso si no concuerda
         ShowMessage('Datos Incorrectos');
      end;
      end else
      begin
        Result := False; //Devolvemos Falso si el usuario está suspendido por el administrador
        ShowMessage('Este usuario está suspendido.'
            +' Por Favor contacte con el administrador');
        end;
   end;

   Login.Free; //Liberamos la consulta
  end;
end;

end.
