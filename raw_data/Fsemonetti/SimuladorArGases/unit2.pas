unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type
  { TForm2 }
  TForm2 = class(TForm)
    Button1: TButton;
    Button11: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckGroup1: TCheckGroup;
    DisjNome1: TStaticText;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioGroup1: TRadioGroup;
    StaticText1: TStaticText;
    DisjNome: TStaticText;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
   procedure Desliga_sinc_DJ(Sender: TObject);
   procedure FormShow(Sender: TObject);
    procedure Liga_sinc_DJ(Sender: TObject);
    procedure CheckBox12Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}
     uses unit1;
{ TForm2 }
procedure TForm2.FormCreate(Sender: TObject);
begin
self.ScaleBy(3, 4);
end;

procedure TForm2.RadioButton1Change(Sender: TObject);
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
  f,conta_comando,g ,indice: integer;
  temp : valor;
 ultimo_comando ,nome,condicao: string;
 estado : boolean;
begin
For f := 0 to form2.ComponentCount -1 do if form2.Components[f] is TCheckBox then TCheckBox(Components[f]).visible :=false;

ultimo_comando:='';
 conta_comando:=1;
 g:=0;
assignfile(arquivo,'Condicoes.db');
reset(arquivo);
f:=0;
 if tradiobutton(sender).name='RadioButton1'  then condicao:=form2.RadioButton1.caption;
 if tradiobutton(sender).name='RadioButton2'  then condicao:=form2.RadioButton2.caption;
 if tradiobutton(sender).name='RadioButton3'  then condicao:=form2.RadioButton3.caption;
 if tradiobutton(sender).name='RadioButton4'  then condicao:=form2.RadioButton4.caption;
 if tradiobutton(sender).name='RadioButton5'  then condicao:=form2.RadioButton5.caption;
 if tradiobutton(sender).name='RadioButton6'  then condicao:=form2.RadioButton6.caption;
 if tradiobutton(sender).name='RadioButton7'  then condicao:=form2.RadioButton7.caption;
 if tradiobutton(sender).name='RadioButton8'  then condicao:=form2.RadioButton8.caption;
 if tradiobutton(sender).name='RadioButton9'  then condicao:=form2.RadioButton9.caption;
 if tradiobutton(sender).name='RadioButton10' then condicao:=form2.RadioButton10.caption;
 if tradiobutton(sender).name='RadioButton11' then condicao:=form2.RadioButton11.caption;
 //520/20=26
 nome:=form2.DisjNome.Caption;
while not(eof(arquivo)) do
begin
     read(arquivo,temp);

     if  ( (upcase(temp.equipamento)=upcase(nome)) and (upcase(temp.condicao)=upcase(condicao)))then

    begin
      g := g + 1;
      indice:=valores.IndexOfName(temp.tag);
      estado:=strtobool(valores.ValueFromIndex[indice]);
       if g = 1 then
      begin
        form2.CheckBox1.Visible := True;
        form2.CheckBox1.Checked :=estado;
        form2.CheckBox1.Caption := temp.descricao;
        form2.CheckBox1.Hint := temp.tag;
      end;
      if g = 2 then
      begin
        form2.CheckBox2.Visible := True;
        form2.CheckBox2.Checked := estado;
        form2.CheckBox2.Caption := temp.descricao;
        form2.CheckBox2.Hint := temp.tag;
      end;
      if g = 3 then
      begin
        form2.CheckBox3.Visible := True;
        form2.CheckBox3.Checked := estado;
        form2.CheckBox3.Caption := temp.descricao;
        form2.CheckBox3.Hint := temp.tag;
      end;
      if g = 4 then
      begin
        form2.CheckBox4.Visible := True;
        form2.CheckBox4.Checked := estado;
        form2.CheckBox4.Caption := temp.descricao;
        form2.CheckBox4.Hint := temp.tag;
      end;
      if g = 5 then
      begin
        form2.CheckBox5.Visible := True;
        form2.CheckBox5.Checked :=estado;
        form2.CheckBox5.Caption := temp.descricao;
        form2.CheckBox5.Hint := temp.tag;
      end;
      if g = 6 then
      begin
        form2.CheckBox6.Visible := True;
        form2.CheckBox6.Checked := estado;
        form2.CheckBox6.Caption := temp.descricao;
        form2.CheckBox6.Hint := temp.tag;
      end;
      if g = 7 then
      begin
        form2.CheckBox7.Visible := True;
        form2.CheckBox7.Checked := estado;
        form2.CheckBox7.Caption := temp.descricao;
        form2.CheckBox7.Hint := temp.tag;
      end;
      if g = 8 then
      begin
        form2.CheckBox8.Visible := True;
        form2.CheckBox8.Checked := estado;
        form2.CheckBox8.Caption := temp.descricao;
        form2.CheckBox8.Hint := temp.tag;
      end;
      if g = 9 then
      begin
        form2.CheckBox9.Visible := True;
        form2.CheckBox9.Checked :=estado;
        form2.CheckBox9.Caption := temp.descricao;
        form2.CheckBox9.Hint := temp.tag;
      end;
      if g = 10 then
      begin
        form2.CheckBox10.Visible := True;
        form2.CheckBox10.Checked :=estado;
        form2.CheckBox10.Caption := temp.descricao;
        form2.CheckBox10.Hint := temp.tag;
      end;
      if g = 11 then
      begin
        form2.CheckBox11.Visible := True;
        form2.CheckBox11.Checked :=estado;
        form2.CheckBox11.Caption := temp.descricao;
        form2.CheckBox11.Hint := temp.tag;
      end;
      if g = 12 then
      begin
        form2.CheckBox12.Visible := True;
        form2.CheckBox12.Checked := estado;
        form2.CheckBox12.Caption := temp.descricao;
        form2.CheckBox12.Hint := temp.tag;
      end;

      if g = 13 then
      begin
        form2.CheckBox13.Visible := True;
        form2.CheckBox13.Checked := estado;
        form2.CheckBox13.Caption := temp.descricao;
        form2.CheckBox13.Hint := temp.tag;
      end;
      if g = 14 then
      begin
        form2.CheckBox14.Visible := True;
        form2.CheckBox14.Checked := estado;
        form2.CheckBox14.Caption := temp.descricao;
        form2.CheckBox14.Hint := temp.tag;
      end;
      if g = 15 then
      begin
        form2.CheckBox15.Visible := True;
        form2.CheckBox15.Checked := estado;
        form2.CheckBox15.Caption := temp.descricao;
        form2.CheckBox15.Hint := temp.tag;
      end;
      if g = 16 then
      begin
        form2.CheckBox16.Visible := True;
        form2.CheckBox16.Checked := estado;
        form2.CheckBox16.Caption := temp.descricao;
        form2.CheckBox16.Hint := temp.tag;
      end;
      if g = 17 then
      begin
        form2.CheckBox17.Visible := True;
        form2.CheckBox17.Checked := estado;
        form2.CheckBox17.Caption := temp.descricao;
        form2.CheckBox17.Hint := temp.tag;
      end;
      if g = 18 then
      begin
        form2.CheckBox18.Visible := True;
        form2.CheckBox18.Checked :=estado;
        form2.CheckBox18.Caption := temp.descricao;
        form2.CheckBox18.Hint := temp.tag;
      end;
      if g = 19 then
      begin
        form2.CheckBox19.Visible := True;
        form2.CheckBox19.Checked :=estado;
        form2.CheckBox19.Caption := temp.descricao;
        form2.CheckBox19.Hint := temp.tag;
      end;
      if g = 20 then
      begin
        form2.CheckBox20.Visible := True;
        form2.CheckBox20.Checked :=estado;
        form2.CheckBox20.Caption := temp.descricao;
        form2.CheckBox20.Hint := temp.tag;
      end;
    end;
  end;
  closefile(arquivo);
end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;


procedure TForm2.Desliga_sinc_DJ(Sender: TObject);
var
  texto : string;
begin

end;

procedure TForm2.FormShow(Sender: TObject);
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
  f,conta_comando,g : integer;
  temp : valor;
 ultimo_comando ,nome: string;
begin
  For f := 0 to form2.ComponentCount -1 do if form2.Components[f] is TCheckBox then TCheckBox(Components[f]).visible :=false;

for f := 0 to form2.ComponentCount -1 do
if form2.Components[f] is TRadioButton then
begin
TRadioButton(Components[f]).visible :=false;
end;

    ultimo_comando:='';
 conta_comando:=1;
 g:=0;
assignfile(arquivo,'Condicoes.db');
reset(arquivo);
f:=0;
nome:=form2.DisjNome.Caption;
while not(eof(arquivo)) do
begin
read(arquivo,temp);
 if upcase(temp.equipamento)=upcase(nome) then
           Begin
             while not(eof(arquivo)) do
             begin
                if    upcase(ultimo_comando)<>upcase(temp.Condicao) then
                                    begin
                                    if conta_comando=1 then form2.RadioButton1.caption:=temp.condicao;
                                    if conta_comando=2 then form2.RadioButton2.caption:=temp.condicao;
                                    if conta_comando=3 then form2.RadioButton3.caption:=temp.condicao;
                                    if conta_comando=4 then form2.RadioButton4.caption:=temp.condicao;
                                    if conta_comando=5 then form2.RadioButton5.caption:=temp.condicao;
                                    if conta_comando=6 then form2.RadioButton6.caption:=temp.condicao;
                                    if conta_comando=7 then form2.RadioButton7.caption:=temp.condicao;
                                    if conta_comando=8 then form2.RadioButton8.caption:=temp.condicao;
                                    if conta_comando=9 then form2.RadioButton9.caption:=temp.condicao;
                                    if conta_comando=10 then form2.RadioButton10.caption:=temp.condicao;
                                    if conta_comando=11 then form2.RadioButton11.caption:=temp.condicao;
                                    if conta_comando=1 then form2.RadioButton1.visible:=true;
                                    if conta_comando=2 then form2.RadioButton2.visible:=true;
                                    if conta_comando=3 then form2.RadioButton3.visible:=true;
                                    if conta_comando=4 then form2.RadioButton4.visible:=true;
                                    if conta_comando=5 then form2.RadioButton5.visible:=true;
                                    if conta_comando=6 then form2.RadioButton6.visible:=true;
                                    if conta_comando=7 then form2.RadioButton7.visible:=true;
                                    if conta_comando=8 then form2.RadioButton8.visible:=true;
                                    if conta_comando=9 then form2.RadioButton9.visible:=true;
                                    if conta_comando=10 then form2.RadioButton10.visible:=true;
                                    if conta_comando=11 then form2.RadioButton11.visible:=true;
                                    ultimo_comando:=temp.condicao;
                                    conta_comando:=conta_comando+1;
                                    end;


                                   read(arquivo,temp);
                end;

end;



end;

closefile(arquivo);


end;


procedure TForm2.Liga_sinc_DJ(Sender: TObject);
var
  texto : string;
begin

  end;


procedure TForm2.Button1Click(Sender: TObject);
Var
  F : integer;
  Aberto,Fechado : string[15];
  begin



  end;

procedure TForm2.Button10Click(Sender: TObject);
var
  ttag : string;
begin


end;

procedure TForm2.Button11Click(Sender: TObject);
begin
  form2.Close;
end;

procedure TForm2.CheckBox12Change(Sender: TObject);
var
  texto,variavel : string;
begin

texto:=tcomponent(sender).name; // pega o nome do componente
variavel:='';
if texto='CheckBox1' then variavel:=Form2.CheckBox1.Hint;
if texto='CheckBox2' then variavel:=Form2.CheckBox2.Hint;
if texto='CheckBox3' then variavel:=Form2.CheckBox3.Hint;
if texto='CheckBox4' then variavel:=Form2.CheckBox4.Hint;
if texto='CheckBox5' then variavel:=Form2.CheckBox5.Hint;
if texto='CheckBox6' then variavel:=Form2.CheckBox6.Hint;
if texto='CheckBox7' then variavel:=Form2.CheckBox7.Hint;
if texto='CheckBox8' then variavel:=Form2.CheckBox8.Hint;
if texto='CheckBox9' then variavel:=Form2.CheckBox9.Hint;
if texto='CheckBox10' then variavel:=Form2.CheckBox10.Hint;
if texto='CheckBox11' then variavel:=Form2.CheckBox11.Hint;
if texto='CheckBox12' then variavel:=Form2.CheckBox12.Hint;


end;



end.

