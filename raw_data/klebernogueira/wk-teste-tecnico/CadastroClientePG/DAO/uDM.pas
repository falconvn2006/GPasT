unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.Stan.Pool,
  FireDAC.VCLUI.Wait;

type
  TDataModuleBD = class(TDataModule)
    FDConexao: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
  private
    { Private declarations }
    FMensagem: string;

  public
     { Public declarations }
     property Mensagem: string read FMensagem write FMensagem;
     function Conectar(): boolean;
     procedure DesConectar();

  end;

var
  DataModuleBD: TDataModuleBD;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDataModuleBD.Conectar(): boolean;
begin
   Result := false;
   FMensagem := '';
   if (not FDConexao.Connected) then begin
      try
         FDConexao.Connected := true;
         Result := true;

      except
         on Ex:Exception do
            FMensagem :=
                  Ex.Message;

      end;

   end;


end;

procedure TDataModuleBD.DesConectar();
begin

end;

end.
