unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, ClipBrd,
  System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    SB_Beautify: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SB_PasteAndBeautify: TSpeedButton;
    procedure SB_BeautifyClick(Sender: TObject);
    procedure SB_PasteAndBeautifyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  if Clipboard.AsText <> '' then
  begin
    Memo1.Lines.Text := ClipBoard.AsText;
    SB_PasteAndBeautifyClick(SB_PasteAndBeautify);
  end;
end;

procedure TForm1.SB_BeautifyClick(Sender: TObject);
var
  s : string;
  i : integer;
begin
  i := 0;
  while i < Memo1.Lines.count  do
  begin
    if pos('.SQL.APPEND(', uppercase(Memo1.Lines[i])) > 0 then
      Memo1.Lines[i] := copy(Memo1.Lines[i], 12 + pos('.SQL.APPEND(', uppercase(Memo1.Lines[i])), length(Memo1.Lines[i]));
    inc(i);
  end;

  s := trim(Memo1.Lines.Text);
  s := StringReplace(s, ''');', '', [rfReplaceAll]);
  s := StringReplace(s, '''''', '''', [rfReplaceAll]);
  s := StringReplace(s, '''#$D#$A''', #13#10, [rfReplaceAll]);
  s := StringReplace(s, '''#$D#$A', #13#10, [rfReplaceAll]);
  s := StringReplace(s, '#$D#$A', #13#10, [rfReplaceAll]);

  s := StringReplace(s, '''SELECT ', ' SELECT ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''FROM ', ' FROM ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''LEFT JOIN ', ' LEFT JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''RIGHT JOIN ', ' RIGHT JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''INNER JOIN ', ' INNER JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''AND ', '   AND ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''WHERE ',  ' WHERE ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''GROUP BY ',  ' GROUP BY ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''ORDER BY ',  ' ORDER BY ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '''UNION', ' UNION ', [rfReplaceAll, rfIgnoreCase]);

  if s[1] = '''' then
    s[1] := ' ';
  if s[length(s)] = '''' then
    s[length(s)] := ' ';
  s := StringReplace(s, ' SELECT ', #13#10 + ' SELECT ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' FROM ', #13#10 + ' FROM ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' LEFT JOIN ', #13#10 + ' LEFT JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' RIGHT JOIN ', #13#10 + ' RIGHT JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' INNER JOIN ', #13#10 + ' INNER JOIN ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' AND ', #13#10 + '   AND ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' WHERE ', #13#10 + ' WHERE ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' GROUP BY ', #13#10 + ' GROUP BY ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' ORDER BY ', #13#10 + ' ORDER BY ', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, ' UNION ', #13#10 + ' UNION ', [rfReplaceAll, rfIgnoreCase]);

  Memo2.Lines.Text := s;
  // supprimer les lignes vides
  i := 0;
  while i < Memo2.Lines.count  do
  begin
    if trim(Memo2.Lines[i]) = '' then
      Memo2.Lines.Delete(i)
    else
      inc(i);
  end;

  Clipboard.AsText := s;

end;

procedure TForm1.SB_PasteAndBeautifyClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Text := trim(Clipboard.AsText);
  SB_BeautifyClick(SB_Beautify);
end;

end.
