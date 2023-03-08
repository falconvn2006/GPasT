unit ConsultaTanque;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, FMTBcd, DB, SqlExpr;

type
  TfConsultaTanque = class(TForm)
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
  fConsultaTanque: TfConsultaTanque;

implementation

uses uPrincipal;

{$R *.dfm}

{ TfConsultaTanque }

procedure TfConsultaTanque.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TfConsultaTanque.FormShow(Sender: TObject);
begin
  CarregaRegistros();
end;

procedure TfConsultaTanque.CarregaRegistros;
var
  Item : TListItem;
begin
  lstRegistros.Items.Clear();

  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT ID,             ');
  Query.SQL.Add('       DESCRICAO,      ');
  Query.SQL.Add('       TIPO_COMBUSTIVEL');
  Query.SQL.Add('  FROM TANQUE          ');
  Query.SQL.Add(' ORDER BY DESCRICAO    ');

  Query.Open();

  while not Query.Eof do
  begin
    Item := lstRegistros.Items.Add();
    Item.Caption := Query.FieldByName('ID').AsString;
    Item.SubItems.Add(Query.FieldByName('DESCRICAO').AsString);

    case Query.FieldByName('TIPO_COMBUSTIVEL').AsInteger of
      0 : Item.SubItems.Add('Gasolina');
      1 : Item.SubItems.Add('Diesel');
    end;

    Query.Next();
  end;

  Query.Close();
end;

procedure TfConsultaTanque.lstRegistrosDblClick(Sender: TObject);
begin
  if lstRegistros.Selected = nil then
    Exit;

  Id := lstRegistros.Selected.Caption;
  Close();
end;

end.
