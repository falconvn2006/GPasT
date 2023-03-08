///ESSE É O CÓDIGO DO EDITOR SQL QUE EU FIZ NO MEU SISTEMA EM DELPHI -- KALIEL.

unit U_Editor_SQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  Tfrm_editor_sql = class(TForm)
    query_busca: TFDQuery;
    dt_busca: TDataSource;
    Timer1: TTimer;
    query_tabelas: TFDQuery;
    dt_tabelas: TDataSource;
    query_tabelasTABELA: TStringField;
    query_aux: TFDQuery;
    Panel1: TPanel;
    label_registros: TLabel;
    s: TPanel;
    bt_consultar: TSpeedButton;
    bt_executar: TSpeedButton;
    Panel3: TPanel;
    edt_consulta_tab: TEdit;
    DBGrid2: TDBGrid;
    Panel4: TPanel;
    limpa_tela: TSpeedButton;
    DBGrid3: TDBGrid;
    query_campos: TFDQuery;
    dt_campos: TDataSource;
    query_camposNOME: TStringField;
    query_camposTIPO: TStringField;
    query_camposTAMANHO: TSmallintField;
    redimensiona: TSpeedButton;
    edt_editor: TRichEdit;
    DBGrid1: TDBGrid;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    procedure Timer1Timer(Sender: TObject);
      procedure limpaQuery();
      procedure select();
      procedure executeSQL();
      procedure limpaQueryAux();
    procedure bt_consultarClick(Sender: TObject);
    procedure edt_editorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt_consulta_tabChange(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure bt_executarClick(Sender: TObject);
    procedure limpa_telaClick(Sender: TObject);
    procedure redimensionaClick(Sender: TObject);
    procedure ProcCorPalavra(Palavra: string; Cor: TColor);
    procedure ColorBox1Change(Sender: TObject);
    procedure limpaCores(var Key : Char);

  private
    var cor_editor : TColor;
  public
    { Public declarations }
  end;

var
  frm_editor_sql: Tfrm_editor_sql;

implementation

{$R *.dfm}

function validaWhere(sql : String) : Boolean;
var s : String;
var up, del, where : Integer;
begin
s := sql;
up := pos('UPDATE', UpperCase(sql));
del := pos('DELETE', UpperCase(sql));
where := pos('WHERE', UpperCase(sql));
  if ((up > 0) or (del > 0)) and
      ((where > up) and (where > del)) then
  begin
    Result := True;
    abort;
  end
  else
  Result := False;

end;

  function ContadorSubstring(Substring, S: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := 1;
  while I < Length(S) do
  begin
    I := Pos(Substring, S, I);
    if I = 0 then
      Break;
    Inc(Result);
    Inc(I, Length(Substring));
  end;
end;

procedure Tfrm_editor_sql.bt_consultarClick(Sender: TObject);
begin
select();
end;

procedure Tfrm_editor_sql.bt_executarClick(Sender: TObject);
var sql : String;
begin
sql := edt_editor.SelText;
if (sql = '') then
begin
 Application.MessageBox('Para executar um comando no editor SQL, deve-se sempre selecionar o texto', 'Editor SQL - Validação', MB_OK);
 abort;
end
else if sql <> '' then
     begin
if (pos('DROP', sql) = 0) and
(pos('CREATE', sql) = 0) then
begin
if (validaWhere(sql) = true) then
begin
executeSQL;

edt_editor.Text := '';
limpaQuery();

label_registros.Caption := 'Registros: 0'
end
else if (validaWhere(sql) = false) then
     begin
      if Application.MessageBox('Deseja rodar um comando sem where?', 'Confirmação', MB_YESNO or MB_ICONQUESTION)=IDYES then
      begin
        if Application.MessageBox('Tem certeza que deseja rodar um comando sem where?', 'Confirmação', MB_YESNO or MB_ICONQUESTION)=IDYES then
        begin
executeSQL;

edt_editor.Text := '';
limpaQuery();

label_registros.Caption := 'Registros: 0'
        end;
      end;
     end;
end
else if pos('DROP', sql) > 0 then
begin
 Application.MessageBox('Não é permitido executar o comando DROP pelo editor SQL', 'Validação de segurança', MB_OK);
end
else if pos('CREATE', sql) > 0 then
begin
 Application.MessageBox('Não é permitido executar o comando CREATE pelo editor SQL', 'Validação de segurança', MB_OK);
end;
     end;
end;

procedure Tfrm_editor_sql.ColorBox1Change(Sender: TObject);
begin
edt_editor.Color := ColorBox1.Selected;
end;

procedure Tfrm_editor_sql.DBGrid1TitleClick(Column: TColumn);
var i : Integer;
begin
for i := 0 to DBGrid1.Columns.Count -1 do
	DBGrid1.Columns[i].Title.Font.Style := [];

	TFDQuery(DBGrid1.DataSource.Dataset).indexFieldNames := Column.fieldName;

Column.Title.Font.Style := [fsBold];
end;

procedure Tfrm_editor_sql.DBGrid2DblClick(Sender: TObject);
begin
if (edt_editor.Text <> '') then
begin
edt_editor.Text := edt_editor.Text + sLineBreak + 'SELECT * FROM ' +
DBGrid2.DataSource.DataSet.Fields[DBGrid2.SelectedIndex].AsString;
end
else
edt_editor.Text := ' SELECT * FROM ' +
DBGrid2.DataSource.DataSet.Fields[DBGrid2.SelectedIndex].AsString;
end;

procedure Tfrm_editor_sql.edt_consulta_tabChange(Sender: TObject);
var i : Integer;
begin
query_tabelas.Params.Clear;
query_tabelas.SQL.Clear;
query_tabelas.SQL.Add('SELECT * FROM TABELAS ');
    if (edt_consulta_tab.Text <> '') then
    begin
    query_tabelas.SQL.Add('WHERE TABELA LIKE :TAB');
    query_tabelas.ParamByName('TAB').AsString := edt_consulta_tab.Text + '%';
    end;
query_tabelas.SQL.Add(' ORDER BY 1');
query_tabelas.Open;
end;

procedure Tfrm_editor_sql.edt_editorChange(Sender: TObject);
var i, j : Integer;
var key : Char;
begin
key := #19;
limpaCores(key);
i := ContadorSubstring('SELECT', edt_editor.Text);
j := ContadorSubstring('FROM', edt_editor.Text);
if i > 0 then
begin
  ProcCorPalavra('SELECT', clBlue);
end;
if j > 0 then
begin
  ProcCorPalavra('FROM', clBlue);
end;
end;

procedure Tfrm_editor_sql.executeSQL;
var SQL : String;
begin
SQL := edt_editor.SelText;
limpaQuery();
 if ((pos('UPDATE', UpperCase(edt_editor.Text)) > 0) and
       (pos('SET', UpperCase(edt_editor.Text)) > 0)) or
          (pos('DELETE FROM', UpperCase(edt_editor.Text)) > 0)
           then
            begin
             if (SQL <> '') then
              begin
                query_busca.SQL.Add(SQL);
              end
              else if (SQL = '') then
                   begin
                      query_busca.SQL.Add(edt_editor.Text);
                   end;
              try
              query_busca.ExecSQL;
              showMessage('Foram alterados ou excluídos: ' + (intToStr(query_busca.RowsAffected)) + ' registros.');
             except
                 Application.MessageBox('SQL Inválido para execução', 'SQL', MB_OK);
              end;
            end;
end;

procedure Tfrm_editor_sql.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var SQL : String;
begin
SQL := edt_editor.SelText;
  if Key = VK_F6 then
  begin
   bt_executarClick(Sender);
  end
  else if Key = VK_F9 then
  begin
  select;
  end;
end;

procedure Tfrm_editor_sql.FormShow(Sender: TObject);
begin
edt_editor.Text := ' ';
end;

procedure Tfrm_editor_sql.limpaCores(var Key: Char);
begin
{edt_editor.SelectAll;
edt_editor.SelAttributes.Color := ColorBox2.Selected;
if (edt_editor.SelStart >= length(edt_editor.Text)) then
begin
//edt_editor.SelStart := edt_editor.SelStart;
end;
  }
end;

procedure Tfrm_editor_sql.limpaQuery;
begin
query_busca.Close;
query_busca.Params.Clear;
query_busca.SQL.Clear;
end;

procedure Tfrm_editor_sql.limpaQueryAux;
begin
query_aux.Close;
query_aux.Params.Clear;
query_aux.SQL.Clear;
end;

procedure Tfrm_editor_sql.select;
var SQL : String;
begin
SQL := edt_editor.SelText;

limpaQuery;
             if (SQL <> '') then
              begin
                query_busca.SQL.Add(SQL);
                 if pos('ORDER BY', UpperCase(edt_editor.Text)) = 0 then
                        begin
                         query_busca.SQL.Add('ORDER BY 1');
                        end;
              end
              else if (SQL = '') then
                   begin
                      query_busca.SQL.Add(edt_editor.Text);
                        if pos('ORDER BY', UpperCase(edt_editor.Text)) = 0 then
                        begin
                         query_busca.SQL.Add('ORDER BY 1');
                        end;
                   end;
               try
              query_busca.Open;
              label_registros.Caption := 'Registros: ' + intToStr(query_busca.RecordCount);
             except
                 Application.MessageBox('SQL Inválido para consulta', 'Erro de sintaxe SQL', MB_OK);
              end;

end;

procedure Tfrm_editor_sql.limpa_telaClick(Sender: TObject);
begin
edt_editor.Text := '';
end;

procedure Tfrm_editor_sql.ProcCorPalavra(Palavra: string; Cor: TColor);
  var
    SelStartBak: integer;
    SelLengthBak: integer;
    SelStartAux: integer;
  begin
    SelStartBak := edt_editor.SelStart;
    SelLengthBak := edt_editor.SelLength;
    SelStartAux := edt_editor.FindText(Palavra, 1, Length(edt_editor.Text), [stWholeWord]);
    while SelStartAux > -1 do
      begin
        edt_editor.SelStart := SelStartAux;
        edt_editor.SelLength := Length(Palavra);
        edt_editor.SelAttributes.Color := Cor;
        Inc(SelStartAux, Length(Palavra)); // posiciona o início da próxima pesquisa após a palavra encontrada
        SelStartAux := edt_editor.FindText(Palavra, SelStartAux, Length(edt_editor.Text) - SelStartAux + 1, [stWholeWord]);
      end;
    edt_editor.SelStart := SelStartBak;
    edt_editor.SelLength := SelLengthBak;
    edt_editor.SelAttributes.Color := ColorBox2.Selected;
end;

procedure Tfrm_editor_sql.redimensionaClick(Sender: TObject);
var
  i, j, k: integer;
  w: integer;
  s, title: string;
  savePos: TBookmark;
begin
  savePos := DBGrid1.DataSource.DataSet.GetBookmark;
  try
    for i := 0 to DBGrid1.Columns.Count - 1 do
    begin
      w := 0;
      DBGrid1.DataSource.DataSet.First;
      for j := 0 to DBGrid1.DataSource.DataSet.RecordCount - 1 do
      begin
      title := DBGrid1.Columns[i].Title.Caption;
      k := DBGrid1.Canvas.TextWidth(title);
        s := DBGrid1.DataSource.DataSet.Fields[i].DisplayText;
        if DBGrid1.Canvas.TextWidth(s) > w then
          w := DBGrid1.Canvas.TextWidth(s);
        DBGrid1.DataSource.DataSet.Next;
      end;
      if w > k then
      begin
      DBGrid1.Columns[i].Width := w + 15;
      end
      else
      DBGrid1.Columns[i].Width := k + 15;
    end;
  finally
    DBGrid1.DataSource.DataSet.GotoBookmark(savePos);
  end;
end;

procedure Tfrm_editor_sql.Timer1Timer(Sender: TObject);
begin
    if (Timer1.enabled = true) then
    begin
         query_tabelas.Open;
         query_campos.Open;
         Timer1.Enabled := false;
    end;
end;

end.
