unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, csvdataset, DB, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, DBGrids, DBCtrls, Menus, ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    acao: TComboBox;
    descricao: TEdit;
    equipamento: TEdit;
    condicao: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioGroup1: TRadioGroup;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    ttag: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SistemasChange(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure jvCSVBase1CursorChanged(Sender: Tobject; NameValues: TstringList;
      Fieldcount: integer);
    procedure MenuItem7Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid2Click(Sender: TObject);
    procedure gravarBanco;

  private

  public

  end;

var
  Form3: TForm3;

implementation
 uses unit1;
{$R *.lfm}

{ TForm3 }
procedure TForm3.gravarBanco;
type
   registro = record
     tag : string[20];
     descricao : string[60];
     entrada : string[15];
     saida : string[15];
     severidade : string[15];
     alarme     : string[15];
     invertido :string[15];
   end;

   var
     temp1,temp2 : registro;
     arquivo : file of registro;
     f : integer;
begin

{$i-}
assignfile(arquivo,'pontos.db');
rewrite(arquivo);
{$i+}
if ioresult <> 0 then begin
                      showmessage('Erro');
                      exit;
                      end;

for f:=0 to stringgrid1.rowcount -1 do
begin
if stringgrid1.cells[0,f]<>'' then
      begin
     temp1.tag:=stringgrid1.cells[0,f];
     temp1.descricao:=stringgrid1.cells[1,f];;
     temp1.entrada:=stringgrid1.cells[2,f];;
     temp1.saida:=stringgrid1.cells[3,f];;
     temp1.severidade:=stringgrid1.cells[4,f];;
     temp1.alarme:=stringgrid1.cells[5,f];;
     temp1.invertido:=stringgrid1.cells[6,f];;
     write(arquivo,temp1);
end;

end;
closefile(arquivo);
showmessage('Concluido');
end;
procedure TForm3.Button1Click(Sender: TObject);
var
  f : integer;
begin
  stringgrid1.LoadFromCSVFile('Digitais.csv',',',true,0,true);
// stringgrid2.LoadFromCSVFile('logica.csv',',',true,0,true);
//for f:=0 to 2126 do Sistemas.AddItem(stringgrid1.Cells[0,f],nil);
  stringgrid1.rowcount:=  stringgrid1.rowcount+2;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
exit;
stringgrid1.SaveToCSVFile('Digitais.csv');
end;

procedure TForm3.Button3Click(Sender: TObject);

type
  valor = record
    Equipamento : string[15];
    acao :  string[20];
    Condicao    : string[50];
    tag : string[20];
    descricao : string[60];
  end;

var
  arquivo : file of valor;
  f : integer;
  temp : valor;

begin
assignfile(arquivo,'Condicoes.db');
rewrite(arquivo);
for f:=0 to stringgrid2.RowCount-1 do
begin
temp.Equipamento :=stringgrid2.Cells[0,f];
temp.acao :=stringgrid2.Cells[1,f];
temp.Condicao :=stringgrid2.Cells[2,f];
temp.tag :=stringgrid2.Cells[3,f];
temp.descricao :=stringgrid2.Cells[4,f];
if temp.equipamento<>'' then write(arquivo,temp);
end;
 showmessage('Arquivo gerado com sucesso');
closefile(arquivo);
end;

procedure TForm3.Button4Click(Sender: TObject);
type
  valor = record
    Equipamento : string[15];
    acao :  string[20];
    Condicao    : string[50];
    tag : string[20];
    descricao : string[60];
  end;

var
  arquivo : file of valor;
  f : integer;
  temp : valor;

begin
stringgrid2.RowCount:=2;
stringgrid2.Clean;
assignfile(arquivo,'Condicoes.db');
reset(arquivo);
f:=0;
while not(eof(arquivo)) do
begin
read(arquivo,temp);
stringgrid2.Cells[0,f]:=temp.Equipamento;
stringgrid2.Cells[1,f]:=temp.acao;
stringgrid2.Cells[2,f]:=temp.Condicao;
stringgrid2.Cells[3,f]:=temp.tag;
stringgrid2.Cells[4,f]:=temp.descricao;
inc(f);
stringgrid2.RowCount:=f+2;
end;

 showmessage('Arquivo carregado com sucesso');
 closefile(arquivo);
end;

procedure TForm3.Button5Click(Sender: TObject);
type
   registro = record
     tag : string[20];
     descricao : string[60];
     entrada : string[15];
     saida : string[15];
     severidade : string[15];
     alarme     : string[15];
     invertido :string[15];
   end;

   var
     temp1,temp2 : registro;
     arquivo : file of registro;
     f : integer;
begin
exit;
assignfile(arquivo,'pontos.db');
rewrite(arquivo);
for f:=0 to stringgrid1.rowcount -1 do
begin
if stringgrid1.cells[0,f]<>'' then
      begin
     temp1.tag:=stringgrid1.cells[0,f];
     temp1.descricao:=stringgrid1.cells[1,f];;
     temp1.entrada:=stringgrid1.cells[2,f];;
     temp1.saida:=stringgrid1.cells[3,f];;
     temp1.severidade:=stringgrid1.cells[4,f];;
     temp1.alarme:=stringgrid1.cells[5,f];;
     temp1.invertido:=stringgrid1.cells[6,f];;
     write(arquivo,temp1);
    if pos('EMT',stringgrid1.cells[0,f])>0 then
           begin
            temp1.tag:=stringgrid1.cells[0,f]+'_LI';
            temp1.entrada:='LIGAR';
            write(arquivo,temp1);
            temp1.tag:=stringgrid1.cells[0,f]+'_DE';
            temp1.entrada:='DESLIGAR';
            write(arquivo,temp1);
           end;
    if pos('ESM',stringgrid1.cells[0,f])>0 then
           begin
            temp1.tag:=stringgrid1.cells[0,f]+'_AB';
            temp1.entrada:='ABRIR';
            write(arquivo,temp1);
            temp1.tag:=stringgrid1.cells[0,f]+'_FE';
            temp1.entrada:='FECHAR';
            write(arquivo,temp1);
           end;
       end;


end;
closefile(arquivo);
showmessage('Concluido');
end;

procedure TForm3.Button6Click(Sender: TObject);
type
   registro = record
     tag : string[20];
     descricao : string[60];
     entrada : string[15];
     saida : string[15];
     severidade : string[15];
     alarme     : string[15];
     invertido :string[15];
   end;

   var
     temp1,temp2 : registro;
     arquivo : file of registro;
     f : integer;
begin
assignfile(arquivo,'pontos.db');
reset(arquivo);
f:=0;
stringgrid1.Clean;
while not(eof(arquivo))  do
begin
read(arquivo,temp1);

if form3.RadioButton1.Checked=true then
       begin
stringgrid1.cells[0,f]:=temp1.tag;;
stringgrid1.cells[1,f]:=temp1.descricao;
stringgrid1.cells[2,f]:=temp1.entrada;
stringgrid1.cells[3,f]:=temp1.saida;
stringgrid1.cells[4,f]:=temp1.severidade;
stringgrid1.cells[5,f]:=temp1.alarme;
stringgrid1.cells[6,f]:=temp1.invertido;
inc(f);
stringgrid1.RowCount:=f+2;

       end;
 if form3.RadioButton2.Checked=true then
        begin
        if (pos('EMT',temp1.tag)>0) or (pos('ESM',temp1.tag)>0) then
           begin
stringgrid1.cells[0,f]:=temp1.tag;;
stringgrid1.cells[1,f]:=temp1.descricao;
stringgrid1.cells[2,f]:=temp1.entrada;
stringgrid1.cells[3,f]:=temp1.saida;
stringgrid1.cells[4,f]:=temp1.severidade;
stringgrid1.cells[5,f]:=temp1.alarme;
stringgrid1.cells[6,f]:=temp1.invertido;
inc(f);
stringgrid1.RowCount:=f+2;

       end;


        end;

 if form3.RadioButton3.Checked=true then
        begin
        if (pos(combobox1.text,temp1.tag)>0) then
           begin
stringgrid1.cells[0,f]:=temp1.tag;;
stringgrid1.cells[1,f]:=temp1.descricao;
stringgrid1.cells[2,f]:=temp1.entrada;
stringgrid1.cells[3,f]:=temp1.saida;
stringgrid1.cells[4,f]:=temp1.severidade;
stringgrid1.cells[5,f]:=temp1.alarme;
stringgrid1.cells[6,f]:=temp1.invertido;
inc(f);
stringgrid1.RowCount:=f+2;

       end;


        end;




end;
closefile(arquivo);
showmessage('Concluido');
end;

procedure TForm3.Button7Click(Sender: TObject);
var
  f : integer;
begin
  for f:=0 to stringgrid1.RowCount-1 do
  begin
  if stringgrid1.Cells[0,f]<>'' then
         begin
  valores.Add(stringgrid1.Cells[0,f]);
  valores.Values[stringgrid1.Cells[0,f]]:='0';;

         end;
  end;
  valores.SaveToFile('Valores.db');
  showmessage('valores gerados');
end;


procedure TForm3.SistemasChange(Sender: TObject);
var
  f : integer;
begin
    for f:=0 to 2126 do
      begin
  //    if stringgrid1.Cells[0,f]=Sistemas.Caption  then stringgrid1.TopRow:=f;
      end;

end;

procedure TForm3.ComboBox2Change(Sender: TObject);
begin

end;

procedure TForm3.FormCreate(Sender: TObject);
type
  valor = record
    Equipamento : string[15];
    acao :  string[20];
    Condicao    : string[50];
    tag : string[20];
    descricao : string[60];
  end;

var
  arquivo : file of valor;
  indice : integer;
  temp : valor;
  lista : tstringlist;
begin
lista:=tstringlist.create;
assignfile(arquivo,'Condicoes.db');
reset(arquivo);
lista.Sorted:=true;
lista.Duplicates:=dupIgnore;
while not(eof(arquivo)) do
begin
read(arquivo,temp);
lista.Add(temp.Equipamento);
end;
for indice:=0 to lista.Count-1 do combobox2.Items.Add(lista[indice]);

lista.Destroy;
closefile(arquivo);






end;

procedure TForm3.jvCSVBase1CursorChanged(Sender: Tobject;
  NameValues: TstringList; Fieldcount: integer);
begin

end;

procedure TForm3.MenuItem7Click(Sender: TObject);
   begin
     gravarbanco;
   end;

procedure TForm3.StringGrid1Click(Sender: TObject);
begin
  ttag.Text:=stringgrid1.Cells[0,stringgrid1.row];
  descricao.Text:=stringgrid1.Cells[1,stringgrid1.row];
end;

procedure TForm3.StringGrid2Click(Sender: TObject);
   var
     f : integer;
     texto : string;
   begin
   if stringgrid2.Col=3 then
         begin
          texto:=stringgrid2.Cells[3,stringgrid2.Row];
       for f:=0 to stringgrid1.RowCount-1 do
         begin
         if stringgrid1.Cells[0,f]=texto  then stringgrid1.TopRow:=f;
         end;

         end;

   end;

end.


