unit ConsultaAbastecimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, FMTBcd, DB, SqlExpr;

type
  TfConsultaAbastecimento = class(TForm)
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
  fConsultaAbastecimento: TfConsultaAbastecimento;

implementation

uses uPrincipal;

{$R *.dfm}

{ TfConsultaTanque }

procedure TfConsultaAbastecimento.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TfConsultaAbastecimento.FormShow(Sender: TObject);
begin
  CarregaRegistros();
end;

procedure TfConsultaAbastecimento.CarregaRegistros;
var
  Item : TListItem;
begin
  lstRegistros.Items.Clear();

  Query.Close();
  Query.SQL.Clear();

  Query.SQL.Add('SELECT A.ID,                 ');
  Query.SQL.Add('       A.DATA,               ');
  Query.SQL.Add('       B.DESCRICAO AS BOMBA, ');
  Query.SQL.Add('       A.QUANTIDADE_LITRO,   ');
  Query.SQL.Add('       A.VALOR_ABASTECIMENTO,');
  Query.SQL.Add('       A.VALOR_IMPOSTO       ');
  Query.SQL.Add('  FROM ABASTECIMENTO A       ');
  Query.SQL.Add(' INNER JOIN BOMBA B          ');
  Query.SQL.Add('    ON A.BOMBA_ID = B.ID     ');
  Query.SQL.Add(' ORDER BY A.ID               ');

  Query.Open();

  while not Query.Eof do
  begin
    Item := lstRegistros.Items.Add();
    Item.Caption := Query.FieldByName('ID').AsString;
    Item.SubItems.Add(Query.FieldByName('DATA').AsString);
    Item.SubItems.Add(Query.FieldByName('BOMBA').AsString);
    Item.SubItems.Add(Query.FieldByName('QUANTIDADE_LITRO').AsString);
    Item.SubItems.Add(FormatFloat('0.00', Query.FieldByName('VALOR_ABASTECIMENTO').AsCurrency));
    Item.SubItems.Add(FormatFloat('0.00', Query.FieldByName('VALOR_IMPOSTO').AsCurrency));

    Query.Next();
  end;

  Query.Close();
end;

procedure TfConsultaAbastecimento.lstRegistrosDblClick(Sender: TObject);
begin
  if lstRegistros.Selected = nil then
    Exit;

  Id := lstRegistros.Selected.Caption;
  Close();
end;

end.
