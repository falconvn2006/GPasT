unit Model.Banco;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, Data.DB, FireDAC.Comp.Client, Vcl.Forms, System.IniFiles,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TdmBanco = class(TDataModule)
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    SqlAux: TFDQuery;
    Banco: TFDConnection;
    MemTable: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmBanco: TdmBanco;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmBanco.DataModuleCreate(Sender: TObject);
var
  ArqIni: TIniFile;
  Caminho, sParametros: string;
begin
  Caminho := ExtractFilePath(Application.ExeName);

  ArqIni := TIniFile.Create(Caminho+'Server.ini');

  try
    Banco.Params.Clear;
    Banco.Params.Add('Database='+ArqIni.ReadString('Banco', 'Database', ''));
    Banco.Params.Add('User_Name='+ArqIni.ReadString('Banco', 'UserName', ''));
    Banco.Params.Add('Password='+ArqIni.ReadString('Banco', 'Password', ''));
    Banco.Params.Add('Server='+ArqIni.ReadString('Banco', 'Server', ''));
    Banco.Params.Add('DriverID=PG');
  finally
    ArqIni.Free;
  end;
end;

end.
