unit UPesqcad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls,DBClient, ExtCtrls, DBCtrls, FMTBcd,
  DB, SqlExpr;

type
  TFPesqcad = class(TForm)
    pnlDadoAdicional: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgpes: TDBGrid;
    lbpes: TLabel;
    edpes: TEdit;
    dblDadoAdicional: TDBText;
    pnlCodBarras: TPanel;
    Label1: TLabel;
    edCodBarras: TEdit;
    sqlcon: TSQLQuery;
    procedure edpesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbgpesDblClick(Sender: TObject);
    procedure edpesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgpesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure dbgpesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgpesTitleClick(Column: TColumn);
    procedure edCodBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure edCodBarrasExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Panel1Resize(Sender: TObject);
    procedure edpesKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    iTipoFiltro : Integer; //0 = String; 1 = Valor; 2 = Data/Hora; 3 = Outros
  public
    { Public declarations }
    bGridVazia : Boolean;
    edPesSelectAll : Boolean;
    edCodBarrasSetFocus : Boolean;
    //svalor: String;
  end;

var
  FPesqcad: TFPesqcad;

implementation

uses  umodulo, uFuncoes;

{$R *.dfm}

procedure TFPesqcad.edpesChange(Sender: TObject);
begin
     if Parametro('FPESQCAD_TIPO_PESQUISA') = 0 then
          dm.cdspesqcad.findnearest([edpes.text])
     else
     begin
          if Trim(edpes.text) = '' then
               dm.cdspesqcad.Filtered := False
          else
          begin
               try
                    case iTipoFiltro of
                         0   : dm.cdspesqcad.Filter := 'upper(' + dm.cdspesqcad.IndexFieldNames + ') like ' + QuotedStr('%' + AnsiUpperCase(edpes.Text) + '%');
                         1   : dm.cdspesqcad.Filter := dm.cdspesqcad.IndexFieldNames + ' = ' + Trocavirgula(Strftocurr(edpes.Text));
                         2,3 : dm.cdspesqcad.Filter := dm.cdspesqcad.IndexFieldNames + ' = ' + QuotedStr(edpes.Text);
                    end;

                    dm.cdspesqcad.Filtered := True;
               except
                    dm.cdspesqcad.Filter := dm.cdspesqcad.IndexFieldNames + ' = ' + QuotedStr(edpes.Text);
                    dm.cdspesqcad.Filtered := True;
               end;
          end;
     end;
end;

procedure TFPesqcad.FormActivate(Sender: TObject);
begin
     fpesqcad.tag := 0;

     if edPesSelectAll = False then
          edpes.SelStart := Length(edpes.Text);

     if edCodBarrasSetFocus = True then
          edCodBarras.SetFocus;
end;

procedure TFPesqcad.dbgpesDblClick(Sender: TObject);
begin
     //svalor := dbgpes.Columns.Items[0].Field.AsString;
     fpesqcad.tag := 1;
     close;
end;

procedure TFPesqcad.edpesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 13 then
     begin
          fpesqcad.tag := 1;
          close;
     end;
end;

procedure TFPesqcad.dbgpesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
     if not (gdselected in State) then
          if not odd((dbgpes.datasource.dataset as tclientdataset).recno) then
               begin
                    dbgpes.Canvas.Brush.Color:= clGradientInactiveCaption;//$00D7D7D7;//$00FFECEC;
                    dbgpes.Canvas.FillRect(rect);
                    dbgpes.DefaultDrawDataCell(Rect,Column.Field,State);
               end;

     TDBGrid(Sender).Canvas.Font.Color := clWindowText;

     if (gdSelected in State)
     or (Rect.Top = TStringGrid(TDBGrid(Sender)).CellRect(DataCol,TStringGrid(TDBGrid(Sender)).Row).Top)
     or (Rect.Top = TStringGrid(TDBGrid(Sender)).CellRect(0,TStringGrid(TDBGrid(Sender)).Row).Top) then
     begin
          //TDBGrid(Sender).Canvas.Brush.Color:= $00F3EBD1;
          TDBGrid(Sender).Canvas.Brush.Color:= $00A4774F;
          TDBGrid(Sender).Canvas.Font.Color := clWindow;
          TDBGrid(Sender).Canvas.FillRect(Rect);
     end;
     TDBGrid(Sender).DefaultDrawDataCell(Rect,Column.Field,State);
end;

procedure TFPesqcad.FormCreate(Sender: TObject);
begin
     iTipoFiltro         := 0;
     edPesSelectAll      := True;
     edCodBarrasSetFocus := False;
end;

procedure TFPesqcad.dbgpesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (ssCtrl in Shift) and (Key = VK_DELETE) then
     begin
          Beep;
          Key:= 0;
     end
     else if key = 13 then
     begin
          fpesqcad.tag := 1;
          Close();
     end;
end;

procedure TFPesqcad.dbgpesTitleClick(Column: TColumn);
begin
     dm.cdspesqcad.IndexFieldNames := Column.FieldName;

     if (Column.Field.DataType = ftString)
     or (Column.Field.DataType = ftBlob)
     or (Column.Field.DataType = ftMemo)
     or (Column.Field.DataType = ftWideString)
     then
          iTipoFiltro := 0
     else
     if (Column.Field.DataType = ftFloat)
     or (Column.Field.DataType = ftInteger)
     or (Column.Field.DataType = ftCurrency)
     then
          iTipoFiltro := 1
     else
     if (Column.Field.DataType = ftDate)
     or (Column.Field.DataType = ftTime)
     or (Column.Field.DataType = ftDateTime)
     or (Column.Field.DataType = ftTimeStamp)
     then
          iTipoFiltro := 2
     else
          iTipoFiltro := 3;

     lbpes.Caption := Column.Title.Caption + ':';
     edpes.Text := '';
     edpes.SetFocus;
     edpes.SelectAll;
end;

procedure TFPesqcad.edCodBarrasKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
     begin
          Key := #0;
          edpes.SetFocus;
     end;
end;

procedure TFPesqcad.edCodBarrasExit(Sender: TObject);
begin
     sqlcon.Close;
     sqlcon.SQL.Text := 'select first 1 tbprod.codigo, tbprod.descricao'+
          ' from tbprod'+
          ' where tbprod.codigo = ('+
          ' select first 1 tbunilog.produto from tbunilog'+
          ' where tbunilog.codbarra = ''' + edCodBarras.Text + ''')';
     sqlcon.Open;

     if not sqlcon.IsEmpty then
     begin
          dm.cdspesqcad.IndexFieldNames := 'descricao';
          edpes.Text := sqlcon.FieldByName('descricao').AsString;
     end;
end;

procedure TFPesqcad.FormClose(Sender: TObject; var Action: TCloseAction);
var
     sFieldsAux : String;
     sDadosAux : array of Variant;

     sFieldsStr : String;
     sDadosStr : array of Variant;
     iQtdFieldsStr : Integer;

     x : Integer;
begin
     sqlcon.Close;

     if FPesqcad.Tag = 1 then
          bGridVazia := dm.cdspesqcad.IsEmpty;

     if Parametro('FPESQCAD_TIPO_PESQUISA') = 1 then
     begin
          sFieldsStr := '';
          iQtdFieldsStr := 0;
          SetLength(sDadosStr, dm.cdspesqcad.Fields.Count);

          sFieldsAux := '';
          SetLength(sDadosAux, dm.cdspesqcad.Fields.Count);
          for x := 0 to dm.cdspesqcad.Fields.Count -1 do
          begin
               if sFieldsAux = '' then
                    sFieldsAux := dm.cdspesqcad.Fields.Fields[x].FieldName
               else
                    sFieldsAux := sFieldsAux + ';' + dm.cdspesqcad.Fields.Fields[x].FieldName;

               sDadosAux[x] := dm.cdspesqcad.Fields.Fields[x].AsVariant;

               //Inclui somente os campos que forem String caso falhe o primeiro locate com todos os campos
               if dm.cdspesqcad.FieldByName( dm.cdspesqcad.Fields.Fields[x].FieldName ) is TStringField then
               begin
                    if sFieldsStr = '' then
                         sFieldsStr := dm.cdspesqcad.Fields.Fields[x].FieldName
                    else
                         sFieldsStr := sFieldsStr + ';' + dm.cdspesqcad.Fields.Fields[x].FieldName;

                    sDadosStr[ iQtdFieldsStr ] := dm.cdspesqcad.Fields.Fields[x].AsVariant;

                    Inc( iQtdFieldsStr  );
               end;
          end;

          dm.cdspesqcad.Filter := '';
          dm.cdspesqcad.Filtered := False;

          //Tenta fazer o locate com todos os campos
          if dm.cdspesqcad.Locate( sFieldsAux, VarArrayOf(sDadosAux), []) = False then
          begin
               SetLength(sDadosStr, iQtdFieldsStr);
               //Caso falhe, tenta fazer o locate só com os campos String
               dm.cdspesqcad.Locate( sFieldsStr, VarArrayOf(sDadosStr), []);
          end;
     end;
end;

procedure TFPesqcad.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 27 then
     begin
          fpesqcad.tag := 0;
          close;
     end
     else if (key = 40) and not (ActiveControl is TDBGrid) then
     begin
          dm.cdspesqcad.next;
          fpesqcad.tag := 0;
     end
     else if (key = 38) and not (ActiveControl is TDBGrid) then
     begin
          dm.cdspesqcad.prior;
          fpesqcad.tag := 0;
     end;
end;

procedure TFPesqcad.Panel1Resize(Sender: TObject);
begin
     edPes.Width := Panel1.Width - 6;
     
end;

procedure TFPesqcad.edpesKeyPress(Sender: TObject; var Key: Char);
begin
     if ((iTipoFiltro = 1) and not (Key in ['0'..'9',',','.',#8,#13]))
     or ((iTipoFiltro = 2) and not (Key in ['0'..'9','/',':',#8,#13])) then
          Key := #0;
end;

end.
