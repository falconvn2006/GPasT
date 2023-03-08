unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase,
  Data.DB, FireDAC.Comp.Client;

type
  TFrmPrincipal = class(TForm)
    MemoLogs: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses Horse,
     Horse.Jhonson,
     Horse.BasicAuthentication,
     Horse.CORS,
     DataSet.Serialize.Config, Controllers.Global;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  THorse.Use(Jhonson());
  THorse.Use(CORS);

  THorse.Use(HorseBasicAuthentication(
  function(const AUserName, APassword: string): boolean
  begin
    Result := AUserName.Equals('diegofolieni') and APassword.Equals('06051998');
  end));

  Controllers.Global.RegistrarRotas;

  THorse.Listen(3000, procedure(Horse: THorse)
  begin
    MemoLogs.Lines.Add('Servidor executando na porta 3000');
  end);
end;

end.
