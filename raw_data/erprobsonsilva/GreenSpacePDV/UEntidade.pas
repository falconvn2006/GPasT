unit UEntidade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.ExtCtrls, UDM;

type
  TFEntidade = class(TForm)
    FdqSequencia: TFDQuery;
    DsEntidade: TDataSource;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    procedure DsEntidadeStateChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEntidade: TFEntidade;

implementation

{$R *.dfm}

procedure TFEntidade.DsEntidadeStateChange(Sender: TObject);
begin
  if DsEntidade.State = dsInsert then
  begin
    FdqSequencia.Open;
    dm.DtEntidadecod_entidade.ReadOnly := False;
    DsEntidade.DataSet.FieldByName('cod_entidade').AsInteger := FdqSequencia.FieldByName('cod_entidade').AsInteger;
    dm.DtEntidadecod_entidade.ReadOnly := True;
    FdqSequencia.close;
  end;
end;

end.
