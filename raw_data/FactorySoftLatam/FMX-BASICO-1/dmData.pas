unit dmData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Datasnap.DBClient,
  Datasnap.Provider, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Dialogs, FMX.Forms, FireDAC.FMXUI.Login, FireDAC.Comp.UI;

type
  TdmDatos = class(TDataModule)
    Connection: TFDConnection;
    RolesTable: TFDQuery;
    UsuariosTable: TFDQuery;
    DriverLink: TFDPhysSQLiteDriverLink;
    RolesTablerol_nid: TIntegerField;
    RolesTablerol_cnombre: TWideStringField;
    UsuariosTableusu_nid: TFDAutoIncField;
    UsuariosTableusu_cnombre: TWideStringField;
    UsuariosTableusu_ccargo: TWideStringField;
    UsuariosTableusu_cnum_celular: TWideStringField;
    UsuariosTableusu_cnum_tele_fijo: TWideStringField;
    UsuariosTableusu_cnum_extension: TWideStringField;
    UsuariosTableusu_nperfil: TIntegerField;
    UsuariosTableusu_cestado: TWideStringField;
    EstadosTable: TFDQuery;
    CargosTable: TFDQuery;
    EstadosTableest_nid: TIntegerField;
    EstadosTableest_cestado: TWideStringField;
    CargosTablecar_nid: TFDAutoIncField;
    CargosTablecar_cnombre: TWideStringField;
    UsuariosTableusu_cusuario: TWideStringField;
    qUsuarios: TFDQuery;
    UsuariosTableusu_cpassword: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure UsuariosTableBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDatos: TdmDatos;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmDatos.DataModuleCreate(Sender: TObject);
var
   dbFile : string;
   Path : string;
begin
  //DeleteFile( MyDBFile );
  try
    {Connection.Params.Values['DriverID'] := 'SQLite';
    Connection.Params.Values['Database'] := MyDBFile;}
    Path := ExtractFilePath(ParamStr(0));
    //Path := '..\..\Data\';
    DBFile := Path + '\Data\dbdirectorio.db';
    if not FileExists(dbFile) then
    begin
      ShowMessage('Base no encontarad');
      Application.Terminate ;
    end;
    Connection.Connected := False;
    Connection.Params.Clear;
    Connection.Params.Database := DBFile;
    Connection.ConnectionDefName:='SQLite_Demo';
    Connection.DriverName:='SQLite';
    Connection.Connected := True;

    RolesTable.Close;
    RolesTable.Open();

    CargosTable.Close;
    CargosTable.Open();

    EstadosTable.Close;
    EstadosTable.OPen();
    //DataSource1.DataSet.Close;
    //DataSource1.DataSet.Open;

  except
    on E : Exception do
    begin
        ShowMessage(e.Message);
    end;
  end;
end;

procedure TdmDatos.UsuariosTableBeforePost(DataSet: TDataSet);
var
  I : Integer;
  columna, titulo: string;
begin

  for I := 1 to DataSet.FieldCount-1 do
  begin
    columna := DataSet.Fields[I].FieldName;
    titulo  := DataSet.Fields[I].DisplayLabel;
    if pos('[', titulo) > 0 then
    begin
      if DataSet.FieldByName(columna).IsNull then
      begin
          ShowMessage('DEBE Registrar valor para '+ titulo );
          DataSet.FieldByName(columna).FocusControl;
          //Abort;
      end;
    end;
  end;

  {Se podrían utilizar expresiones regulares para validar
    Teléfono Fijo, Celular y Extensión telefónica...}


  
end;

end.
