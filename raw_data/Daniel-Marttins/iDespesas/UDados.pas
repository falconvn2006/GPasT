unit UDados;

interface

uses
  System.SysUtils, System.Classes, Vcl.Menus, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, Data.Win.ADODB, FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MySQLDef, FireDAC.Comp.UI, FireDAC.Phys.MySQL;

type
  TdmDados = class(TDataModule)
    adoConexao: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UCadastro, ULogin, UPrincipal;

{$R *.dfm}

end.
