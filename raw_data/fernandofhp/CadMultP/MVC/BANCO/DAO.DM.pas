unit DAO.DM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, Data.DB, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Comp.UI, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TDM = class(TDataModule)
    Conexao: TFDConnection;
    Transacao: TFDTransaction;
    CursorEspera: TFDGUIxWaitCursor;
    FireBirdLink: TFDPhysFBDriverLink;
  private
    { Private declarations }
  public
    class function oDM: TDM;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TDM }

class function TDM.oDM: TDM;
begin
  try
    if (Assigned(DM)) then
    begin
      Result := DM;
    end
    else
    begin
      Result := TDM.Create(nil);
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro no Modulo de Dados!!! ');
    end;
  end;
end;

end.
