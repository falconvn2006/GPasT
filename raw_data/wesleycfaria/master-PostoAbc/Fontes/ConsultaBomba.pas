unit ConsultaBomba;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, FMTBcd, DB, SqlExpr;

type
  TfConsultaBomba = class(TForm)
    lstRegistros: TListView;
    Query: TSQLQuery;
    procedure FormShow(Sender: TObject);
    procedure lstRegistrosDblClick(Sender: TObject);
  private
    FId: string;
    procedure SetId(const Value: string);
    procedure CarregaRegistros;
  public
    property Id : string read FId write SetId;
  end;

var
  fConsultaBomba: TfConsultaBomba;

implementation

uses uPrincipal;

{$R *.dfm}

{ TfConsultaTanque }

procedure TfConsultaBomba.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TfConsultaBomba.FormShow(Sender: TObject);
begin
  CarregaRegistros();
end;

procedure TfConsultaBomba.CarregaRegistros;
var
  Item : TListItem;
begin
  lstRegistros.Items.Clear();

  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT B.ID,                ');
  Query.SQL.Add('       B.DESCRICAO,         ');
  Query.SQL.Add('       T.DESCRICAO AS TANQUE');
  Query.SQL.Add('  FROM BOMBA B              ');
  Query.SQL.Add(' INNER JOIN TANQUE T        ');
  Query.SQL.Add('    ON B.TANQUE_ID = T.ID   ');
  Query.SQL.Add(' ORDER BY B.DESCRICAO       ');

  Query.Open();

  while not Query.Eof do
  begin
    Item := lstRegistros.Items.Add();
    Item.Caption := Query.FieldByName('ID').AsString;
    Item.SubItems.Add(Query.FieldByName('DESCRICAO').AsString);
    Item.SubItems.Add(Query.FieldByName('TANQUE').AsString);

    Query.Next();
  end;

  Query.Close();
end;

procedure TfConsultaBomba.lstRegistrosDblClick(Sender: TObject);
begin
  if lstRegistros.Selected = nil then
    Exit;

  Id := lstRegistros.Selected.Caption;
  Close();
end;

end.
