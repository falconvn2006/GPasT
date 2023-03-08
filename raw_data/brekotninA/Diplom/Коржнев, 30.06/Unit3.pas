unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, sBitBtn, sEdit, sSpinEdit, DB, ADODB, DateUtils;

type
  TAbilitiesTest = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    sBitBtn3: TsBitBtn;
    Label6: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label7: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label8: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    sBitBtn4: TsBitBtn;
    sDecimalSpinEdit1: TsDecimalSpinEdit;
    sDecimalSpinEdit2: TsDecimalSpinEdit;
    sDecimalSpinEdit3: TsDecimalSpinEdit;
    sDecimalSpinEdit4: TsDecimalSpinEdit;
    sDecimalSpinEdit5: TsDecimalSpinEdit;
    Timer2: TTimer;
    Label5: TLabel;
    Label23: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sDecimalSpinEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    Start: TDateTime;
    minA: Integer;
    secA : Integer;
    secpast : Integer;
    Diff : Integer;
    UCorrect : Integer;
    UTotal : Integer;
    Effect : Real;
  end;

var
  AbilitiesTest: TAbilitiesTest;

implementation

uses MyDB, Unit1, MainMenu;

{$R *.dfm}


procedure TAbilitiesTest.Timer1Timer(Sender: TObject);
var
  a, perc : integer;
  MarkText : String;
  EncText : String;
begin
  if secA<=0 then
  begin
    secA:=60;
    minA:=minA-1;
  end;
  secA:=secA-1;
  secpast:=secpast+1;


 if (minA<10) and (secA<10) then Label2.Caption:='0'+IntToStr(minA)+':'+'0'+IntToStr(secA) else Label2.Caption:='0'+IntToStr(minA)+':'+IntToStr(secA);
 if (minA=0) and (secA=0) then
 begin
    Timer1.Enabled:=false;
    Timer2.Enabled:=false;
    sBitBtn1.Visible:=false;
    sBitBtn2.Enabled:=false;
    sBitBtn3.Visible:=true;
    sBitBtn4.Enabled:=true;

    sDecimalSpinEdit1.Enabled:=false;
    sDecimalSpinEdit2.Enabled:=false;
    sDecimalSpinEdit3.Enabled:=false;
    sDecimalSpinEdit4.Enabled:=false;
    sDecimalSpinEdit5.Enabled:=false;

    if(sDecimalSpinEdit1.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit1.Text)=StrToInt(Label6.Caption)+StrToInt(Label16.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+1;
      end;
      UTotal:=UTotal+1;
    end;
    if(sDecimalSpinEdit2.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit2.Text)=StrToInt(Label7.Caption)+StrToInt(Label19.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+1;
      end;
      UTotal:=UTotal+1;
    end;
    if(sDecimalSpinEdit3.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit3.Text)=StrToInt(Label26.Caption)+StrToInt(Label31.Caption)+StrToInt(Label28.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+3;
      end;
      UTotal:=UTotal+3;
    end;
    if(sDecimalSpinEdit4.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit4.Text)=StrToInt(Label37.Caption)+StrToInt(Label32.Caption)+StrToInt(Label36.Caption)-StrToInt(Label34.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+4;
      end;
      UTotal:=UTotal+4;
    end;
    if(sDecimalSpinEdit5.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit5.Text)=StrToInt(Label40.Caption)*StrToInt(Label14.Caption)+StrToInt(Label13.Caption)+StrToInt(Label9.Caption)-StrToInt(Label11.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+6;
      end;
      UTotal:=UTotal+6;
    end;

    Effect := UCorrect*100/UTotal/secpast;

    //Label23.Caption:=Copy(FloatToStr(Effect), 0, 5);
    perc:=StrToInt(Label21.Caption) * 100 div (5 * Diff);
    Label23.Caption:=IntToStr(perc)+' %';

    if (perc >= 95) then
      MarkText:='Ваша оценка: 5'#13#10
    else if (perc >= 80) then
      MarkText:='Ваша оценка: 4'#13#10
    else if (perc >= 45) then
      MarkText:='Ваша оценка: 3'#13#10
    else
      MarkText:='Ваша оценка: 2'#13#10;

    if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
    if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;

    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT RC.Start_Data, RC.Correct AS Correct');
    fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
    fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data DESC');
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Parameters.ParamByName('2').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('3').Value:=0;
    fdb.ADOQuery111.Parameters.ParamByName('4').Value:=0;
    fdb.ADOQuery111.Parameters.ParamByName('5').Value:=MentalAbilitiesDevelopment.TrainTimeBar.Position;
    fdb.ADOQuery111.Open;

    if (fdb.ADOQuery111.IsEmpty) then
      EncText:=''
    else
    begin
      fdb.ADOQuery111.First;
      a := StrToInt(Label21.Caption) - fdb.ADOQuery111.FieldByName('Correct').AsInteger;
      if (a = 0) then
        EncText:= 'Вы справились так же хорошо, как в прошлый раз!'#13#10'Так держать!'
      else if (a > 0) then
        EncText:= 'Вы дали правильных ответов больше на '+IntToStr(a)+', чем в прошлый раз!'#13#10'Очень хорошо!'
      else
        EncText:= 'Вы дали правильных ответов меньше на '+IntToStr(-a)+', чем в прошлый раз!'#13#10'Старайтесь лучше!';
    end;

    fdb.ADOQueryTEST.sql.clear;
    fdb.ADOQueryTEST.sql.add('INSERT INTO Results_Calc(User_ID, Start_Data, Finish_Time, Task_Type, Radio_Set, Combo_Set, Slider_Set, Correct, Effect) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9)');
    fdb.ADOQueryTEST.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryTEST.Parameters.ParamByName('2').Value:=Start;
    fdb.ADOQueryTEST.Parameters.ParamByName('3').Value:=SecondsBetween(Now,Start);
    fdb.ADOQueryTEST.Parameters.ParamByName('4').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('5').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('6').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('7').Value:=MentalAbilitiesDevelopment.TrainTimeBar.Position;
    fdb.ADOQueryTEST.Parameters.ParamByName('8').Value:=StrToInt(Label21.Caption);
    fdb.ADOQueryTEST.Parameters.ParamByName('9').Value:=Effect;
    fdb.ADOQueryTEST.ExecSQL;

    Application.MessageBox(PChar('Тест был успешно пройден!'#13#10+MarkText+EncText),'Окончание теста',MB_OK);
 end;
end;

procedure TAbilitiesTest.sBitBtn2Click(Sender: TObject);
var
  perc : integer;
begin
  Diff:=Diff+1;
  Label22.Caption:=IntToStr(Diff);
  sBitBtn2.Enabled:=false;

  if(StrToInt(sDecimalSpinEdit1.Text)=StrToInt(Label6.Caption)+StrToInt(Label16.Caption))then
  begin
    Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
    UCorrect:=UCorrect+1;
  end;
  if(StrToInt(sDecimalSpinEdit2.Text)=StrToInt(Label7.Caption)+StrToInt(Label19.Caption))then
  begin
    Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
    UCorrect:=UCorrect+1;
  end;
  if(StrToInt(sDecimalSpinEdit3.Text)=StrToInt(Label26.Caption)+StrToInt(Label31.Caption)+StrToInt(Label28.Caption))then
  begin
    Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
    UCorrect:=UCorrect+3;
  end;
  if(StrToInt(sDecimalSpinEdit4.Text)=StrToInt(Label37.Caption)+StrToInt(Label32.Caption)+StrToInt(Label36.Caption)-StrToInt(Label34.Caption))then
  begin
    Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
    UCorrect:=UCorrect+4;
  end;
  if(StrToInt(sDecimalSpinEdit5.Text)=StrToInt(Label40.Caption)*StrToInt(Label14.Caption)+StrToInt(Label13.Caption)+StrToInt(Label9.Caption)-StrToInt(Label11.Caption))then
  begin
    Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
    UCorrect:=UCorrect+6;
  end;
    UTotal:=UTotal+15;

    Effect := UCorrect*100/UTotal/secpast;

    //Label23.Caption:=Copy(FloatToStr(Effect), 0, 5);
    perc:= StrToInt(Label21.Caption) * 100 div (5 * (Diff - 1));
    Label23.Caption:=IntToStr(perc)+' %';


  sDecimalSpinEdit1.Text:='';
  sDecimalSpinEdit2.Text:='';
  sDecimalSpinEdit3.Text:='';
  sDecimalSpinEdit4.Text:='';
  sDecimalSpinEdit5.Text:='';

    Label6.Caption:=IntToStr(Random(9*Diff));
    Label16.Caption:=IntToStr(Random(9*Diff));
    Label7.Caption:=IntToStr(Random(9*Diff));
    Label19.Caption:=IntToStr(Random(9*Diff));
    Label26.Caption:=IntToStr(Random(9*Diff));
    Label31.Caption:=IntToStr(Random(9*Diff));
    Label28.Caption:=IntToStr(Random(9*Diff));

    Label37.Caption:=IntToStr(Random(9*Diff));
    Label32.Caption:=IntToStr(Random(9*Diff));
    Label36.Caption:=IntToStr(Random(9*Diff));
    Label34.Caption:=IntToStr(Random(9*Diff));

    Label40.Caption:=IntToStr(Random(9*Diff));
    Label14.Caption:=IntToStr(Random(9));
    Label9.Caption:=IntToStr(Random(9*Diff));
    Label13.Caption:=IntToStr(Random(9*Diff));
    Label11.Caption:=IntToStr(Random(9*Diff));

end;

procedure TAbilitiesTest.sBitBtn1Click(Sender: TObject);
begin
    Timer1.Enabled:=false;
    sBitBtn1.Visible:=false;
    sBitBtn2.Enabled:=false;
    sBitBtn2.Hint:='Чтобы начать тест заново, перезайдите на форму, ваши данные будут отправлены в базу.';
    sBitBtn3.Visible:=true;

    sDecimalSpinEdit1.Enabled:=false;
    sDecimalSpinEdit2.Enabled:=false;
    sDecimalSpinEdit3.Enabled:=false;
    sDecimalSpinEdit4.Enabled:=false;
    sDecimalSpinEdit5.Enabled:=false;

    {

    if(sDecimalSpinEdit1.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit1.Text)=StrToInt(Label6.Caption)+StrToInt(Label16.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+1;
      end;
      UTotal:=UTotal+1;
    end;
    if(sDecimalSpinEdit2.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit2.Text)=StrToInt(Label7.Caption)+StrToInt(Label19.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+1;
      end;
      UTotal:=UTotal+1;
    end;
    if(sDecimalSpinEdit3.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit3.Text)=StrToInt(Label26.Caption)+StrToInt(Label31.Caption)+StrToInt(Label28.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+3;
      end;
      UTotal:=UTotal+3;
    end;
    if(sDecimalSpinEdit4.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit4.Text)=StrToInt(Label37.Caption)+StrToInt(Label32.Caption)+StrToInt(Label36.Caption)-StrToInt(Label34.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+4;
      end;
      UTotal:=UTotal+4;
    end;
    if(sDecimalSpinEdit5.Text <> '') then
    begin
      if(StrToInt(sDecimalSpinEdit5.Text)=StrToInt(Label40.Caption)*StrToInt(Label14.Caption)+StrToInt(Label13.Caption)+StrToInt(Label9.Caption)-StrToInt(Label11.Caption))then
      begin
        Label21.Caption:=IntToStr(StrToInt(Label21.Caption)+1);
        UCorrect:=UCorrect+6;
      end;
      UTotal:=UTotal+6;
    end;

    if (UTotal=0) or (secpast=0) then Effect := 0
    else
      Effect := UCorrect*100/UTotal/secpast;

    Label23.Caption:=Copy(FloatToStr(Effect), 0, 5);

    if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
    fdb.ADOQueryTEST.sql.clear;
    fdb.ADOQueryTEST.sql.add('INSERT INTO Results_Calc(User_ID, Start_Data, Finish_Time, Task_Type, Radio_Set, Combo_Set, Slider_Set, Correct, Effect) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9)');
    fdb.ADOQueryTEST.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryTEST.Parameters.ParamByName('2').Value:=Start;
    fdb.ADOQueryTEST.Parameters.ParamByName('3').Value:=SecondsBetween(Now,Start);
    fdb.ADOQueryTEST.Parameters.ParamByName('4').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('5').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('6').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('7').Value:=MentalAbilitiesDevelopment.TrainTimeBar.Position;
    fdb.ADOQueryTEST.Parameters.ParamByName('8').Value:=StrToInt(Label21.Caption);
    fdb.ADOQueryTEST.Parameters.ParamByName('9').Value:=Effect;
    fdb.ADOQueryTEST.ExecSQL;
    Application.MessageBox('Тест был остановлен пользователем!','Окончание теста',MB_OK);

    }
end;

procedure TAbilitiesTest.sBitBtn3Click(Sender: TObject);
begin
  Close;
end;


procedure TAbilitiesTest.sBitBtn4Click(Sender: TObject);
begin
    randomize;
    Start:=Now;
    Timer1.Enabled:=true;
    sBitBtn1.Visible:=true;
    sBitBtn2.Visible:=true;
    sBitBtn3.Visible:=false;
    sBitBtn4.Visible:=false;
    Diff:=1;

    Label6.Caption:=IntToStr(Random(9*Diff));
    Label16.Caption:=IntToStr(Random(9*Diff));
    Label7.Caption:=IntToStr(Random(9*Diff));
    Label19.Caption:=IntToStr(Random(9*Diff));
    Label26.Caption:=IntToStr(Random(9*Diff));
    Label31.Caption:=IntToStr(Random(9*Diff));
    Label28.Caption:=IntToStr(Random(9*Diff));

    Label37.Caption:=IntToStr(Random(9*Diff));
    Label32.Caption:=IntToStr(Random(9*Diff));
    Label36.Caption:=IntToStr(Random(9*Diff));
    Label34.Caption:=IntToStr(Random(9*Diff));

    Label40.Caption:=IntToStr(Random(9*Diff));
    Label14.Caption:=IntToStr(Random(9*Diff));
    Label9.Caption:=IntToStr(Random(9*Diff));
    Label13.Caption:=IntToStr(Random(9*Diff));
    Label11.Caption:=IntToStr(Random(9*Diff));

    Label6.Visible:=true;
    Label16.Visible:=true;
    Label7.Visible:=true;
    Label19.Visible:=true;
    Label26.Visible:=true;
    Label31.Visible:=true;
    Label28.Visible:=true;

    Label37.Visible:=true;
    Label32.Visible:=true;
    Label36.Visible:=true;
    Label34.Visible:=true;

    Label40.Visible:=true;
    Label14.Visible:=true;
    Label9.Visible:=true;
    Label13.Visible:=true;
    Label11.Visible:=true;

    Label17.Visible:=true;
    Label20.Visible:=true;
    Label27.Visible:=true;
    Label30.Visible:=true;
    Label33.Visible:=true;
    Label35.Visible:=true;
    Label38.Visible:=true;
    Label10.Visible:=true;
    Label15.Visible:=true;
    Label41.Visible:=true;
    Label12.Visible:=true;
    Label8.Visible:=true;
    Label18.Visible:=true;
    Label29.Visible:=true;
    Label39.Visible:=true;
    Label42.Visible:=true;
    sDecimalSpinEdit1.Visible:=true;
    sDecimalSpinEdit2.Visible:=true;
    sDecimalSpinEdit3.Visible:=true;
    sDecimalSpinEdit4.Visible:=true;
    sDecimalSpinEdit5.Visible:=true;
end;


procedure TAbilitiesTest.Timer2Timer(Sender: TObject);
begin
if(sDecimalSpinEdit1.Text<>'')and(sDecimalSpinEdit2.Text<>'')and(sDecimalSpinEdit3.Text<>'')
and(sDecimalSpinEdit4.Text<>'')and(sDecimalSpinEdit5.Text<>'') then sBitBtn2.Enabled:=true else sBitBtn2.Enabled:=false;
end;

procedure TAbilitiesTest.FormShow(Sender: TObject);
begin
    Label6.Visible:=false;
    Label16.Visible:=false;
    Label7.Visible:=false;
    Label19.Visible:=false;
    Label26.Visible:=false;
    Label31.Visible:=false;
    Label28.Visible:=false;

    Label37.Visible:=false;
    Label32.Visible:=false;
    Label36.Visible:=false;
    Label34.Visible:=false;

    Label40.Visible:=false;
    Label14.Visible:=false;
    Label9.Visible:=false;
    Label13.Visible:=false;
    Label11.Visible:=false;

    Label17.Visible:=false;
    Label20.Visible:=false;
    Label27.Visible:=false;
    Label30.Visible:=false;
    Label33.Visible:=false;
    Label35.Visible:=false;
    Label38.Visible:=false;
    Label10.Visible:=false;
    Label15.Visible:=false;
    Label41.Visible:=false;
    Label12.Visible:=false;
    Label8.Visible:=false;
    Label18.Visible:=false;
    Label29.Visible:=false;
    Label39.Visible:=false;
    Label42.Visible:=false;
    sDecimalSpinEdit1.Visible:=false;
    sDecimalSpinEdit2.Visible:=false;
    sDecimalSpinEdit3.Visible:=false;
    sDecimalSpinEdit4.Visible:=false;
    sDecimalSpinEdit5.Visible:=false;

    sDecimalSpinEdit1.Enabled:=true;
    sDecimalSpinEdit2.Enabled:=true;
    sDecimalSpinEdit3.Enabled:=true;
    sDecimalSpinEdit4.Enabled:=true;
    sDecimalSpinEdit5.Enabled:=true;

    sDecimalSpinEdit1.Text:='';
    sDecimalSpinEdit2.Text:='';
    sDecimalSpinEdit3.Text:='';
    sDecimalSpinEdit4.Text:='';
    sDecimalSpinEdit5.Text:='';



    sBitBtn1.Visible:=false;
    sBitBtn2.Visible:=false;
    sBitBtn3.Visible:=true;
    sBitBtn4.Visible:=true;

    minA:=MentalAbilitiesDevelopment.TrainTimeBar.Position;
    if (minA=10) then Label2.Caption:='10:00'
    else Label2.Caption:= '0'+IntToStr(minA)+':00';

    Label22.Caption:='1';
    Label21.Caption:='0';
    Label23.Caption:='0';
    secA:=0;
    secpast:=0;
    UCorrect:=0;
    UTotal:=0;
    Timer1.Enabled:=false;
    Timer2.Enabled:=true;
    Effect:=0;

end;

procedure TAbilitiesTest.sDecimalSpinEdit1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (key = 13)
    then FindNextControl(Sender as TWinControl, true, true, false).SetFocus;
end;

end.
