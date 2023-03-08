
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sLabel, sComboBox, ExtCtrls,
  ComCtrls, sTrackBar, sFontCtrls, sPanel, sEdit, sCheckBox, sGroupBox,
  sSpinEdit, Vcl.Mask, sMaskEdit, sCustomComboEdit;

type
  TMentalAbilitiesDevelopment = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    ComboClass: TsComboBox;
    sLabel2: TsLabel;
    sPanel1: TsPanel;
    Timer1: TTimer;
    sLabel4: TsLabel;
    sCheckBox1: TsCheckBox;
    sLabel5: TsLabel;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sRadioGroup1: TsRadioGroup;
    sPanel4: TsPanel;
    sRadioGroup2: TsRadioGroup;
    sPanel6: TsPanel;
    sLabel10: TsLabel;
    sRadioGroup3: TsRadioGroup;
    sRadioGroup4: TsRadioGroup;
    sLabel11: TsLabel;
    sTrackBar4: TsTrackBar;
    sLabel14: TsLabel;
    sRadioGroup5: TsRadioGroup;
    TutorialBtn: TsBitBtn;
    sCheckBox4: TsCheckBox;
    sLabel333: TsLabel;
    TrainingPanel: TsPanel;
    sLabel1: TsLabel;
    sLabel3: TsLabel;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    sCheckBox7: TsCheckBox;
    sCheckBox8: TsCheckBox;
    sPanel2: TsPanel;
    sLabel6: TsLabel;
    sLabel7: TsLabel;
    TrainTimeBar: TsTrackBar;
    TutorialPanel: TsPanel;
    sLabel12: TsLabel;
    ModeLabel: TsLabel;
    sLabel13: TsLabel;
    DescLabel1: TsLabel;
    DescLabel2: TsLabel;
    sRadioGroup6: TsRadioGroup;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
    procedure ComboClassChange(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sTrackBar3Change(Sender: TObject);
    procedure sRadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sTrackBar4Change(Sender: TObject);
    procedure sRadioGroup5Click(Sender: TObject);
    procedure TrainTimeBarChange(Sender: TObject);
    procedure TutorialBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MentalAbilitiesDevelopment: TMentalAbilitiesDevelopment;

implementation

uses Unit3,Unit2;

{$R *.dfm}

procedure TMentalAbilitiesDevelopment.sBitBtn1Click(Sender: TObject);
begin
  if(TutorialPanel.Visible) then
  begin
    Hide;
    Show;
  end
  else
    Close;
end;

procedure TMentalAbilitiesDevelopment.sBitBtn3Click(Sender: TObject);
begin
    AbilitiesTest.minA:=5;
    AbilitiesTest.Diff:=1;
    AbilitiesTest.sBitBtn3.Visible:=true;
    AbilitiesTest.sBitBtn4.Visible:=true;
    AbilitiesTest.Label21.Caption:='0';
    AbilitiesTest.Label22.Caption:='1';
    AbilitiesTest.sDecimalSpinEdit1.Text:='';
    AbilitiesTest.sDecimalSpinEdit2.Text:='';
    AbilitiesTest.sDecimalSpinEdit3.Text:='';
    AbilitiesTest.sDecimalSpinEdit4.Text:='';
    AbilitiesTest.sDecimalSpinEdit5.Text:='';
    AbilitiesTest.ShowModal;
end;

procedure TMentalAbilitiesDevelopment.Timer1Timer(Sender: TObject);
begin
if (sCheckBox1.Checked = false) and (sCheckBox2.Checked = false) and (sCheckBox3.Checked = false) and (sCheckBox4.Checked = false)
and (ComboClass.ItemIndex<>2) and (ComboClass.ItemIndex<>1) and (ComboClass.ItemIndex<>4) then
  sBitBtn2.enabled:=false else sBitBtn2.enabled:=true;
if(ComboClass.ItemIndex<0) then TutorialBtn.Enabled:=false else TutorialBtn.Enabled:=true;
end;

procedure TMentalAbilitiesDevelopment.sTrackBar1Change(Sender: TObject);
begin
//sLabel7.Caption:=IntToStr(sTrackBar1.Position);
end;

procedure TMentalAbilitiesDevelopment.ComboClassChange(Sender: TObject);
begin

  if(sRadioGroup1.ItemIndex<2) then
    sCheckBox3.Enabled:=true;
  Case ComboClass.ItemIndex of
    //-1 : sPanel1.Visible:=false;
     0 : begin  // Операции с числами
           sPanel6.Visible:=false;
           sPanel1.Visible:=true;
           sRadioGroup1.Visible:=false;
           sRadioGroup5.Visible:=true;
           sRadioGroup6.Visible:=false;
           sPanel4.Visible:=false;
           TrainingPanel.Visible:=false;
           {sLabel5.top:=165;
           sCheckBox1.Top:=165;
           sCheckBox2.Top:=187;
           sCheckBox3.Top:=210;
           sPanel1.height:=243;
           sBitBtn1.top:=389;
           sBitBtn3.top:=389;}
           sCheckBox3.Visible:=true;
           sCheckBox4.Visible:=true;
           sCheckBox4.Enabled:=(sRadioGroup5.ItemIndex=2)OR(sRadioGroup5.ItemIndex=4);
           if(sCheckBox4.Enabled = false) then
              sCheckBox4.Checked:=false;
           //MentalAbilitiesDevelopment.ClientHeight:=446;
         end;
     1 : begin   // Строка
           //sPanel2.Visible:=true;
           //sTrackBar1.Max:=10;
           //sLabel7.Visible:=true;
           //sTrackBar1.Visible:=true;
           //sPanel1.Visible:=true;
           //sPanel3.Visible:=false;
           //sPanel4.Visible:=false;
           //sLabel3.Visible:=true;
           //sPanel1.height:=291;
           //sBitBtn1.top:=426;
           //sBitBtn3.top:=426;
           //sLabel6.Caption:='Количество чисел в строке:';
           //MentalAbilitiesDevelopment.ClientHeight:=480;

           sPanel1.Visible:=false;
           sPanel4.Visible:=false;
           sPanel6.Visible:=true;
           TrainingPanel.Visible:=false;
           //sBitBtn1.top:=437;
           //sBitBtn3.top:=437;
           //MentalAbilitiesDevelopment.ClientHeight:=502;
         end;
     2 : begin   // Таблица умножения
           sPanel1.Visible:=false;
           //sPanel3.Visible:=false;
           sPanel4.Visible:=true;
           sRadioGroup6.Visible:=false;
           TrainingPanel.Visible:=false;
           // sLabel3.Visible:=true;
           //sBitBtn1.top:=389;
           //sBitBtn3.top:=389;
           // sBitBtn2.Enabled:=true;
           //MentalAbilitiesDevelopment.ClientHeight:=445;
         end;
     3 : begin    // Матрица
           sPanel1.Visible:=true;
           sRadioGroup1.Visible:=true;
           sRadioGroup5.Visible:=false;
           sRadioGroup6.Visible:=true;
           sPanel4.Visible:=false;
           sPanel6.Visible:=false;
           TrainingPanel.Visible:=false;
           {sLabel5.top:=125;
           sCheckBox1.Top:=125;
           sCheckBox2.Top:=147;
           sCheckBox3.Top:=170;

           sPanel1.height:=299;
           sBitBtn1.top:=429;
           sBitBtn3.top:=429; }
           sCheckBox3.Visible:=false;
           sCheckBox3.Checked:=false;
           sCheckBox4.Visible:=false;
           sCheckBox4.Checked:=false;
           //MentalAbilitiesDevelopment.ClientHeight:=486;
         end;
     4 : begin
           TrainingPanel.Visible:=true;
           sPanel1.Visible:=false;
           sPanel4.Visible:=false;
           sPanel6.Visible:=false;
         end;
  end;
end;

procedure TMentalAbilitiesDevelopment.sBitBtn2Click(Sender: TObject);
begin
if (ComboClass.ItemIndex = -1) then
  Application.MessageBox('Выберете тему!','Ошибка',MB_OK);
  if(ComboClass.ItemIndex <> 4) then
  begin
    AbilitiesTraining.sec:=0;
    AbilitiesTraining.min:=0;
    AbilitiesTraining.SO:=0;
    AbilitiesTraining.MatrixDim:=sRadioGroup6.ItemIndex + 3;
    AbilitiesTraining.sBitBtn3.Enabled:=true;
    AbilitiesTraining.sBitBtn2.Enabled:=false;
    AbilitiesTraining.sLabel7.Visible:=false;
    AbilitiesTraining.sLabel6.Caption:='';
    AbilitiesTraining.sLabel6.Caption:='';
    AbilitiesTraining.Timer1.Enabled:=true;
    AbilitiesTraining.LabelTime.Caption:='00:00';
    AbilitiesTraining.sLabel20.Caption:='0/10';
    AbilitiesTraining.ShowModal;
  end
  else
    AbilitiesTest.ShowModal;
end;

procedure TMentalAbilitiesDevelopment.sTrackBar3Change(Sender: TObject);
begin
//sLabel13.Caption:=IntToStr(sTrackBar3.Position);
end;

procedure TMentalAbilitiesDevelopment.sRadioGroup1Click(Sender: TObject);
begin

if(sRadioGroup1.ItemIndex=2) then
  begin
    sCheckBox3.Enabled:=false;
    sCheckBox3.Checked:=false;
  end
  else
  if(ComboClass.ItemIndex=3) then
  begin
    sCheckBox3.Enabled:=false;
    sCheckBox3.Checked:=false;
  end
  else
  begin
    sCheckBox3.Enabled:=true;
  end;
end;

procedure TMentalAbilitiesDevelopment.sRadioGroup5Click(Sender: TObject);
begin
  sCheckBox4.Enabled:=(sRadioGroup5.ItemIndex=2)OR(sRadioGroup5.ItemIndex=4);
    if(sCheckBox4.Enabled = false) then
      sCheckBox4.Checked:=false;
  if(sRadioGroup5.ItemIndex=1) or (sRadioGroup5.ItemIndex=3) then
  begin
    sCheckBox3.Enabled:=false;
    sCheckBox3.Checked:=false;
  end
  else
  begin
    sCheckBox3.Enabled:=true;
  end;
end;

procedure TMentalAbilitiesDevelopment.FormShow(Sender: TObject);
begin
  {if(ComboClass.ItemIndex=-1) then
  begin
     sBitBtn1.top:=126;
     sBitBtn3.top:=126;
     MentalAbilitiesDevelopment.ClientHeight:=200;
  end; }
   //sLabel9.Caption:=IntToStr(sTrackBar2.Position)+'x'+IntToStr(sTrackBar2.Position);
   sBitBtn1.Visible:=true;
   sBitBtn2.Visible:=true;
   TutorialBtn.Visible:=true;
   ComboClass.Visible:=true;
   ComboClass.ItemIndex:=-1;
   sLabel2.Visible:=true;
   TutorialPanel.Visible:=false;
end;


procedure TMentalAbilitiesDevelopment.sTrackBar4Change(Sender: TObject);
begin
   sLabel14.Caption:=IntToStr(2*sTrackBar4.Position + 1);
end;



procedure TMentalAbilitiesDevelopment.TrainTimeBarChange(Sender: TObject);
begin
   sLabel7.Caption:=IntToStr(TrainTimeBar.Position)+' мин';
end;

procedure TMentalAbilitiesDevelopment.TutorialBtnClick(Sender: TObject);
begin
   sBitBtn2.Visible:=false;
   TutorialBtn.Visible:=false;
   ComboClass.Visible:=false;
   sLabel2.Visible:=false;
   sPanel1.Visible:=false;
   sPanel4.Visible:=false;
   sPanel6.Visible:=false;
   TrainingPanel.Visible:=false;
   TutorialPanel.Visible:=true;

   ModeLabel.Caption:= ComboClass.Items.Strings[ComboClass.ItemIndex];

   Case ComboClass.ItemIndex of
   0: begin
        DescLabel1.Caption:='Несколько простых примеров';
        DescLabel2.Caption:='в одно действие';
      end;

   1: begin
        DescLabel1.Caption:='Запоминание промежуточного';
        DescLabel2.Caption:='результата вычислений';
      end;

   2: begin
        DescLabel1.Caption:='Решение произвольных примеров';
        DescLabel2.Caption:='из таблицы умножения до 9';
      end;

   3: begin
        DescLabel1.Caption:='Вычисление сумм и разностей';
        DescLabel2.Caption:='строк и столбцов матрицы';
      end;

   4: begin
        DescLabel1.Caption:='Проверка навыков устного счета';
        DescLabel2.Caption:='за фиксированное время';
      end;
   end;
end;

end.
