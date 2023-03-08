unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sLabel, ExtCtrls, sPanel, sEdit,
  sSpinEdit, sBevel, acPNG, acImage, jpeg, DB, ADODB, DateUtils;

type
  TAbilitiesTraining = class(TForm)
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    Timer1: TTimer;
    sLabel2: TsLabel;
    LabelTime: TsLabel;
    TipStroka: TsPanel;
    TipOperacii: TsPanel;
    TipTablica: TsPanel;
    TipMatrix5: TsPanel;
    TitleMx5: TsLabel;
    sBitBtn3: TsBitBtn;
    sLabel6: TsLabel;
    sDecimalSpinEdit1: TsDecimalSpinEdit;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sDecimalSpinEdit4: TsDecimalSpinEdit;
    sDecimalSpinEdit5: TsDecimalSpinEdit;
    sDecimalSpinEdit6: TsDecimalSpinEdit;
    sDecimalSpinEdit7: TsDecimalSpinEdit;
    sDecimalSpinEdit8: TsDecimalSpinEdit;
    sDecimalSpinEdit9: TsDecimalSpinEdit;
    sDecimalSpinEdit10: TsDecimalSpinEdit;
    sDecimalSpinEdit11: TsDecimalSpinEdit;
    sLabel11: TsLabel;
    sLabel12: TsLabel;
    sLabel13: TsLabel;
    sLabel14: TsLabel;
    sLabel15: TsLabel;
    sLabel16: TsLabel;
    sLabel17: TsLabel;
    sLabel18: TsLabel;
    sLabel19: TsLabel;
    sLabel20: TsLabel;
    sLabel21: TsLabel;
    Mx5Line1Res: TsDecimalSpinEdit;
    Mx5Line2Res: TsDecimalSpinEdit;
    Mx5Line3Res: TsDecimalSpinEdit;
    Mx5Line4Res: TsDecimalSpinEdit;
    Mx5Line5Res: TsDecimalSpinEdit;
    Mx5Col1Res: TsDecimalSpinEdit;
    Mx5Col2Res: TsDecimalSpinEdit;
    Mx5Col3Res: TsDecimalSpinEdit;
    Mx5Col4Res: TsDecimalSpinEdit;
    Mx5Col5Res: TsDecimalSpinEdit;
    Op1A: TsLabel;
    Op1z: TsLabel;
    Op1B: TsLabel;
    Op1Res: TsDecimalSpinEdit;
    Op1eq: TsLabel;
    Op2A: TsLabel;
    Op2z: TsLabel;
    Op2B: TsLabel;
    Op2Res: TsDecimalSpinEdit;
    Op2eq: TsLabel;
    Op3A: TsLabel;
    Op3z: TsLabel;
    Op3B: TsLabel;
    Op3Res: TsDecimalSpinEdit;
    Op3eq: TsLabel;
    Op4B: TsLabel;
    Op4A: TsLabel;
    Op4z: TsLabel;
    Op4Res: TsDecimalSpinEdit;
    Op4eq: TsLabel;
    Op5eq: TsLabel;
    Op5B: TsLabel;
    Op5A: TsLabel;
    Op5z: TsLabel;
    Op5Res: TsDecimalSpinEdit;
    sLabel42: TsLabel;
    sLabel43: TsLabel;
    sLabel44: TsLabel;
    sLabel45: TsLabel;
    sLabel46: TsLabel;
    sLabel47: TsLabel;
    sLabel48: TsLabel;
    Timer2: TTimer;
    Op1err: TsLabel;
    Op2err: TsLabel;
    Op4err: TsLabel;
    Op3err: TsLabel;
    Op5err: TsLabel;
    Timer3: TTimer;
    Mx5_11: TsLabel;
    Mx5_12: TsLabel;
    Mx5_13: TsLabel;
    Mx5_14: TsLabel;
    Mx5_15: TsLabel;
    Mx5_21: TsLabel;
    Mx5_22: TsLabel;
    Mx5_23: TsLabel;
    Mx5_24: TsLabel;
    Mx5_25: TsLabel;
    Mx5_31: TsLabel;
    Mx5_32: TsLabel;
    Mx5_33: TsLabel;
    Mx5_34: TsLabel;
    Mx5_35: TsLabel;
    Mx5_41: TsLabel;
    Mx5_42: TsLabel;
    Mx5_43: TsLabel;
    Mx5_44: TsLabel;
    Mx5_45: TsLabel;
    Mx5_51: TsLabel;
    Mx5_52: TsLabel;
    Mx5_53: TsLabel;
    Mx5_54: TsLabel;
    Mx5_55: TsLabel;
    Mx5Line1_1: TsLabel;
    Mx5Line1_2: TsLabel;
    Mx5Line1_3: TsLabel;
    Mx5Line1_4: TsLabel;
    Mx5Line2_1: TsLabel;
    Mx5Line2_2: TsLabel;
    Mx5Line2_3: TsLabel;
    Mx5Line2_4: TsLabel;
    Mx5Line3_1: TsLabel;
    Mx5Line3_2: TsLabel;
    Mx5Line3_3: TsLabel;
    Mx5Line3_4: TsLabel;
    Mx5Line4_1: TsLabel;
    Mx5Line4_2: TsLabel;
    Mx5Line4_3: TsLabel;
    Mx5Line4_4: TsLabel;
    Mx5Line5_1: TsLabel;
    Mx5Line5_2: TsLabel;
    Mx5Line5_3: TsLabel;
    Mx5Line5_4: TsLabel;
    Mx5Col1_1: TsLabel;
    Mx5Col2_1: TsLabel;
    Mx5Col3_1: TsLabel;
    Mx5Col4_1: TsLabel;
    Mx5Col5_1: TsLabel;
    Mx5Col1_2: TsLabel;
    Mx5Col2_2: TsLabel;
    Mx5Col3_2: TsLabel;
    Mx5Col4_2: TsLabel;
    Mx5Col5_2: TsLabel;
    Mx5Col1_3: TsLabel;
    Mx5Col2_3: TsLabel;
    Mx5Col3_3: TsLabel;
    Mx5Col4_3: TsLabel;
    Mx5Col5_3: TsLabel;
    Mx5Col1_4: TsLabel;
    Mx5Col2_4: TsLabel;
    Mx5Col3_4: TsLabel;
    Mx5Col4_4: TsLabel;
    Mx5Col5_4: TsLabel;
    Mx5Line1Eq: TsLabel;
    Mx5Line2Eq: TsLabel;
    Mx5Line3Eq: TsLabel;
    Mx5Line4Eq: TsLabel;
    Mx5Line5Eq: TsLabel;
    Mx5Col1Eq: TsLabel;
    Mx5Col2Eq: TsLabel;
    Mx5Col3Eq: TsLabel;
    Mx5Col4Eq: TsLabel;
    Mx5Col5Eq: TsLabel;
    Timer4: TTimer;
    TipMatrixRes: TsPanel;
    MatrixCorrect: TsLabel;
    CorrectAmount: TsLabel;
    TipMatrix4: TsPanel;
    TitleMx4: TsLabel;
    Mx4_11: TsLabel;
    Mx4_12: TsLabel;
    Mx4_13: TsLabel;
    Mx4_14: TsLabel;
    Mx4_21: TsLabel;
    Mx4_22: TsLabel;
    Mx4_23: TsLabel;
    Mx4_24: TsLabel;
    Mx4_31: TsLabel;
    Mx4_32: TsLabel;
    Mx4_33: TsLabel;
    Mx4_34: TsLabel;
    Mx4_41: TsLabel;
    Mx4_42: TsLabel;
    Mx4_43: TsLabel;
    Mx4_44: TsLabel;
    Mx4Line1_1: TsLabel;
    Mx4Line1_2: TsLabel;
    Mx4Line1_3: TsLabel;
    Mx4Line2_1: TsLabel;
    Mx4Line2_2: TsLabel;
    Mx4Line2_3: TsLabel;
    Mx4Line3_1: TsLabel;
    Mx4Line3_2: TsLabel;
    Mx4Line3_3: TsLabel;
    Mx4Line4_1: TsLabel;
    Mx4Line4_2: TsLabel;
    Mx4Line4_3: TsLabel;
    Mx4Col1_1: TsLabel;
    Mx4Col2_1: TsLabel;
    Mx4Col3_1: TsLabel;
    Mx4Col4_1: TsLabel;
    Mx4Col1_2: TsLabel;
    Mx4Col2_2: TsLabel;
    Mx4Col3_2: TsLabel;
    Mx4Col4_2: TsLabel;
    Mx4Col1_3: TsLabel;
    Mx4Col2_3: TsLabel;
    Mx4Col3_3: TsLabel;
    Mx4Col4_3: TsLabel;
    Mx4Line1Eq: TsLabel;
    Mx4Line2Eq: TsLabel;
    Mx4Line3Eq: TsLabel;
    Mx4Line4Eq: TsLabel;
    Mx4Col1Eq: TsLabel;
    Mx4Col2Eq: TsLabel;
    Mx4Col3Eq: TsLabel;
    Mx4Col4Eq: TsLabel;
    Mx4Line1Res: TsDecimalSpinEdit;
    Mx4Line2Res: TsDecimalSpinEdit;
    Mx4Line3Res: TsDecimalSpinEdit;
    Mx4Line4Res: TsDecimalSpinEdit;
    Mx4Col1Res: TsDecimalSpinEdit;
    Mx4Col2Res: TsDecimalSpinEdit;
    Mx4Col3Res: TsDecimalSpinEdit;
    Mx4Col4Res: TsDecimalSpinEdit;
    TipMatrix3: TsPanel;
    TitleMx3: TsLabel;
    Mx3_11: TsLabel;
    Mx3_12: TsLabel;
    Mx3_13: TsLabel;
    Mx3_21: TsLabel;
    Mx3_22: TsLabel;
    Mx3_23: TsLabel;
    Mx3_31: TsLabel;
    Mx3_32: TsLabel;
    Mx3_33: TsLabel;
    Mx3Line1_1: TsLabel;
    Mx3Line1_2: TsLabel;
    Mx3Line2_1: TsLabel;
    Mx3Line2_2: TsLabel;
    Mx3Line3_1: TsLabel;
    Mx3Line3_2: TsLabel;
    Mx3Col1_1: TsLabel;
    Mx3Col2_1: TsLabel;
    Mx3Col3_1: TsLabel;
    Mx3Col1_2: TsLabel;
    Mx3Col2_2: TsLabel;
    Mx3Col3_2: TsLabel;
    Mx3Line1Eq: TsLabel;
    Mx3Line2Eq: TsLabel;
    Mx3Line3Eq: TsLabel;
    Mx3Col1Eq: TsLabel;
    Mx3Col2Eq: TsLabel;
    Mx3Col3Eq: TsLabel;
    Mx3Line1Res: TsDecimalSpinEdit;
    Mx3Line2Res: TsDecimalSpinEdit;
    Mx3Line3Res: TsDecimalSpinEdit;
    Mx3Col1Res: TsDecimalSpinEdit;
    Mx3Col2Res: TsDecimalSpinEdit;
    Mx3Col3Res: TsDecimalSpinEdit;
    sLabel4: TsLabel;
    Op6A: TsLabel;
    Op7A: TsLabel;
    Op8A: TsLabel;
    Op6z: TsLabel;
    Op7z: TsLabel;
    Op8z: TsLabel;
    Op6B: TsLabel;
    Op7B: TsLabel;
    Op8B: TsLabel;
    Op6eq: TsLabel;
    Op7eq: TsLabel;
    Op8eq: TsLabel;
    Op6Res: TsDecimalSpinEdit;
    Op7Res: TsDecimalSpinEdit;
    Op8Res: TsDecimalSpinEdit;
    Op6err: TsLabel;
    Op7err: TsLabel;
    Op8err: TsLabel;
    TipOperaciiRes: TsPanel;
    CorrectLabel: TsLabel;
    OperaciiCorrect: TsLabel;
    HintPanel: TsPanel;
    HintA: TsLabel;
    HintZ: TsLabel;
    HintB: TsLabel;
    HintEq: TsLabel;
    ImageRulerBig: TsImage;
    ImageFlagRed: TsImage;
    Image10Big: TsImage;
    ImageRulerSmall: TsImage;
    Image10Small: TsImage;
    ImageFlagBlue: TsImage;
    ImageLineBlue: TsImage;
    ImageLineRed: TsImage;
    HintHide: TsBitBtn;
    Op1Help: TsBitBtn;
    Op2Help: TsBitBtn;
    Op3Help: TsBitBtn;
    Op4Help: TsBitBtn;
    Op5Help: TsBitBtn;
    Op6Help: TsBitBtn;
    Op7Help: TsBitBtn;
    Op8Help: TsBitBtn;
    EffectPanel: TsPanel;
    Effect1: TsLabel;
    Effect2: TsLabel;
    Effect3: TsLabel;
    EffectTime: TsLabel;
    EffectCorrect: TsLabel;
    EffectOutOf: TsLabel;
    EffectTotal: TsLabel;
    EffectCoeff: TsLabel;
    HintA1: TsLabel;
    HintZ1: TsLabel;
    HintBrkt1: TsLabel;
    HintB1: TsLabel;
    HintZ2: TsLabel;
    HintB2: TsLabel;
    HintBrkt2: TsLabel;
    EffectSuccess: TsLabel;
    EffectHigher: TsLabel;
    EffectDiffSpot: TsLabel;
    EffectLower: TsLabel;
    EffectDiff: TsLabel;
    EffectWrong: TsLabel;
    EffectTablica1: TsLabel;
    EffectTablica2: TsLabel;
    PartLabel1: TsLabel;
    PartLabel2: TsLabel;
    sLabel1: TsLabel;
    sLabel3: TsLabel;
    procedure sBitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OperaciiEnable (Enable : boolean);
    function OpCheckRepeat (i : Integer) : Boolean;
    procedure InitHintData;
    procedure LayoutMx3 (Sign, Eq : Integer);
    procedure LayoutMx4 (Sign, Eq : Integer);
    procedure LayoutMx5 (Sign, Eq : Integer);
    procedure VerticalMx3 (Flag : Boolean);
    procedure VerticalMx4 (Flag : Boolean);
    procedure VerticalMx5 (Flag : Boolean);
    procedure FillARandom;
    procedure FillAInt (Target : Integer);
    procedure FillBRandom;
    procedure FillStroka (Numbers : Integer;
                          Signs : Integer);
    function GenStrokaRandom (Numbers : Integer; NoZero : Boolean) : Integer;
    function EffCoeff (TaskType, Correct : Integer) : Real;
    procedure Op1HelpClick(Sender: TObject);
    procedure Op2HelpClick(Sender: TObject);
    procedure Op3HelpClick(Sender: TObject);
    procedure Op4HelpClick(Sender: TObject);
    procedure Op5HelpClick(Sender: TObject);
    procedure Op6HelpClick(Sender: TObject);
    procedure Op7HelpClick(Sender: TObject);
    procedure Op8HelpClick(Sender: TObject);
    procedure HintHideClick(Sender: TObject);
    procedure InitDB;
    procedure Mx5Line1ResKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Op1ResExit(Sender: TObject);
    procedure Op2ResExit(Sender: TObject);
    procedure Op3ResExit(Sender: TObject);
    procedure Op4ResExit(Sender: TObject);
    procedure Op5ResExit(Sender: TObject);
    procedure Op6ResExit(Sender: TObject);
    procedure Op7ResExit(Sender: TObject);
    procedure Op8ResExit(Sender: TObject);
    procedure Mx3Line1ResExit(Sender: TObject);
    procedure Mx3Line2ResExit(Sender: TObject);
    procedure Mx3Line3ResExit(Sender: TObject);
    procedure Mx3Col1ResExit(Sender: TObject);
    procedure Mx3Col2ResExit(Sender: TObject);
    procedure Mx3Col3ResExit(Sender: TObject);
    procedure Mx4Line1ResExit(Sender: TObject);
    procedure Mx4Line2ResExit(Sender: TObject);
    procedure Mx4Line3ResExit(Sender: TObject);
    procedure Mx4Line4ResExit(Sender: TObject);
    procedure Mx4Col1ResExit(Sender: TObject);
    procedure Mx4Col2ResExit(Sender: TObject);
    procedure Mx4Col3ResExit(Sender: TObject);
    procedure Mx4Col4ResExit(Sender: TObject);
    procedure Mx5Line1ResExit(Sender: TObject);
    procedure Mx5Line2ResExit(Sender: TObject);
    procedure Mx5Line3ResExit(Sender: TObject);
    procedure Mx5Line4ResExit(Sender: TObject);
    procedure Mx5Line5ResExit(Sender: TObject);
    procedure Mx5Col1ResExit(Sender: TObject);
    procedure Mx5Col2ResExit(Sender: TObject);
    procedure Mx5Col3ResExit(Sender: TObject);
    procedure Mx5Col4ResExit(Sender: TObject);
    procedure Mx5Col5ResExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Start: TDateTime;
    min : Integer;
    sec : Integer;
    Stroka : string;
    SO,H,SO1,SO2,AnswerO : integer;
    SOtemp,SOtemp2,Answer : integer;
    PlusCB,MinusCB,TimesCB,DivCB,TTR,RSuccess : Integer;
    A,B,OA,OB,ORES : array [1..8] of integer;
    Oz : array [1..8] of char;
    TimeBar : Integer;

    FlagLeftSmall : array [2..14] of integer;
    FlagLeftBig : array [6..18] of integer;
    LineOffset, LineDelta : integer;
    LineWidth : array [1..9] of integer;

    Stroka_result, Stroka_length : Integer;
    Stroka3 : array [1..4] of integer;
    Stroka3_znaki : array [1..3] of char;
    Stroka5 : array [1..6] of integer;
    Stroka5_znaki : array [1..5] of char;
    Stroka7 : array [1..8] of integer;
    Stroka7_znaki : array [1..7] of char;
    Stroka9 : array [1..10] of integer;
    Stroka9_znaki : array [1..9] of char;
    Stroka_counter : Integer;

    MatrixDim : Integer;
    MxResLine1, MxResLine2, MxResLine3, MxResLine4, MxResLine5 : Integer;
    MxResCol1, MxResCol2, MxResCol3, MxResCol4, MxResCol5 : Integer;
  end;

var
  AbilitiesTraining: TAbilitiesTraining;

  procedure WriteInMx5 (Plus, Minus : Integer;
                        N1, N2, N3, N4, N5 : TsLabel;
                        L1, L2, L3, L4 : TsLabel;
                        out Res : Integer);
  procedure WriteInMx4 (Plus, Minus : Integer;
                        N1, N2, N3, N4 : TsLabel;
                        L1, L2, L3 : TsLabel;
                        out Res : Integer);
  procedure WriteInMx3 (Plus, Minus : Integer;
                        N1, N2, N3 : TsLabel;
                        L1, L2 : TsLabel;
                        out Res : Integer);


implementation

uses MyDB, Unit1, MainMenu;

{$R *.dfm}

procedure TAbilitiesTraining.sBitBtn1Click(Sender: TObject);
begin  
  Close;
end;

procedure TAbilitiesTraining.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  TipOperacii.Visible:=false;
  TipStroka.Visible:=false;
  TipMatrix5.Visible:=false;
  TipMatrixRes.Visible:=false;
  TipTablica.Visible:=false;
  EffectPanel.Visible:=false;
  sBitBtn3.Visible:=true;
  sDecimalSpinEdit1.Value:=0;
  sLabel8.Visible:=false;
  sLabel7.Visible:=false;
  sLabel6.Visible:=false;
  LabelTime.Caption:='00:00';

  Timer1.Enabled:=false;
  Timer2.Enabled:=false;
  Timer3.Enabled:=false;
  Timer4.Enabled:=false;

  sLabel42.Visible:=true;
  sLabel43.Visible:=true;
  sLabel44.Visible:=true;

  sLabel45.Visible:=false;
  sLabel46.Visible:=false;
  sLabel47.Visible:=false;
  sLabel48.Visible:=false;


  sDecimalSpinEdit4.Text:='';
  sDecimalSpinEdit5.Text:='';
  sDecimalSpinEdit6.Text:='';
  sDecimalSpinEdit7.Text:='';
  sDecimalSpinEdit8.Text:='';
  sDecimalSpinEdit9.Text:='';
  sDecimalSpinEdit10.Text:='';
  sDecimalSpinEdit11.Text:='';

  Op1err.Visible:=false;
  Op2err.Visible:=false;
  Op3err.Visible:=false;
  Op4err.Visible:=false;
  Op5err.Visible:=false;
  Op6err.Visible:=false;
  Op7err.Visible:=false;
  Op8err.Visible:=false;

  Op1Res.Text:='';
  Op2Res.Text:='';
  Op3Res.Text:='';
  Op4Res.Text:='';
  Op5Res.Text:='';
  Op6Res.Text:='';
  Op7Res.Text:='';
  Op8Res.Text:='';

  OperaciiCorrect.Caption:='?/8';

  Mx3Line1Res.Text:='';
  Mx3Line2Res.Text:='';
  Mx3Line3Res.Text:='';
  Mx3Col1Res.Text:='';
  Mx3Col2Res.Text:='';
  Mx3Col3Res.Text:='';

  Mx4Line1Res.Text:='';
  Mx4Line2Res.Text:='';
  Mx4Line3Res.Text:='';
  Mx4Line4Res.Text:='';
  Mx4Col1Res.Text:='';
  Mx4Col2Res.Text:='';
  Mx4Col3Res.Text:='';
  Mx4Col4Res.Text:='';

  Mx5Line1Res.Text:='';
  Mx5Line2Res.Text:='';
  Mx5Line3Res.Text:='';
  Mx5Line4Res.Text:='';
  Mx5Line5Res.Text:='';
  Mx5Col1Res.Text:='';
  Mx5Col2Res.Text:='';
  Mx5Col3Res.Text:='';
  Mx5Col4Res.Text:='';
  Mx5Col5Res.Text:='';

  AnswerO:=0;
end;

 function NegativeMatrix (N1, N2, N3, N4, N5 : Integer ) : integer;      // Проверка на отрицательный результат в матрице (с последующей заменой)
  var Res : integer;
  begin
  Result:= N1 - N2 - N3 - N4 - N5;
  end;

procedure TAbilitiesTraining.FormShow(Sender: TObject);
var
  i, j, rng1, rng2 : integer;
  mult : boolean;
begin
  Start:=Now;
  Answer:=0;
  RSuccess:=0;
  if(MentalAbilitiesDevelopment.sCheckBox1.Checked=true) then PlusCB:=1 else PlusCB:=0;
  if(MentalAbilitiesDevelopment.sCheckBox2.Checked=true) then MinusCB:=1 else MinusCB:=0;
  if(MentalAbilitiesDevelopment.sCheckBox3.Checked=true) then TimesCB:=1 else TimesCB:=0;
  if(MentalAbilitiesDevelopment.sCheckBox4.Checked=true) then DivCB:=1 else DivCB:=0;
  randomize;
  InitHintData;
  sLabel2.Caption:=fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс';
  TipOperacii.Visible:=false;
  TipTablica.Visible:=false;
  TipStroka.Visible:=false;
  TipMatrix3.Visible:=false;
  TipMatrix4.Visible:=false;
  TipMatrix5.Visible:=false;
  TipMatrixRes.Visible:=false;
  TipOperaciiRes.Visible:=false;
  HintPanel.Visible:=false;
  HintPanel.BringToFront;
  EffectPanel.Visible:=false;
  EffectPanel.BringToFront;
  Op1Res.Text:='';
  Op2Res.Text:='';
  Op3Res.Text:='';
  Op4Res.Text:='';
  Op5Res.Text:='';
  Op6Res.Text:='';
  Op7Res.Text:='';
  Op8Res.Text:='';
  OperaciiCorrect.Caption:='?/8';
  //OperaciiCorrect.Caption:=IntToStr(fMainMenu.userId);
  Op1Help.Visible:=false;
  Op2Help.Visible:=false;
  Op3Help.Visible:=false;
  Op4Help.Visible:=false;
  Op5Help.Visible:=false;
  Op6Help.Visible:=false;
  Op7Help.Visible:=false;
  Op8Help.Visible:=false;

  EffectDiffSpot.Visible:=false;
  EffectHigher.Visible:=false;
  EffectLower.Visible:=false;
  EffectDiff.Visible:=false;
  EffectWrong.Visible:=false;
  EffectTablica1.Visible:=false;
  EffectTablica2.Visible:=false;

  Case MentalAbilitiesDevelopment.ComboClass.ItemIndex of
    -1 :
    AbilitiesTraining.Caption:='Устный счет';
     0 : 
     begin
        AbilitiesTraining.Caption:='Устный счет - Операции с числами';
        TipOperacii.Visible:=true;
        TipOperaciiRes.Visible:=false;
        Timer2.Enabled:=true;

        for i:= 1 to 8 do
        begin
          if (PlusCB=0)and(MinusCB=0)and(TimesCB=0)and(DivCB=1) then
            Oz[i]:= ':';
          if (PlusCB=0)and(MinusCB=0)and(TimesCB=1)and(DivCB=0) then
            Oz[i]:= '*';
          if (PlusCB=0)and(MinusCB=1)and(TimesCB=0)and(DivCB=0) then
            Oz[i]:= '-';
          if (PlusCB=1)and(MinusCB=0)and(TimesCB=0)and(DivCB=0) then
            Oz[i]:= '+';
        end;

        //____________Зарандомили числа по настройкам_________________
        Case MentalAbilitiesDevelopment.sRadioGroup5.ItemIndex of
                0:begin
                    for i:= 1 to 8 do
                    begin
                       if (MinusCB=0) then
                          ORES[i]:=4 + random(6)
                       else if (PlusCB=0) then
                          ORES[i]:=1 + random(6)
                       else
                          ORES[i]:=1 + random(9);
                    end;
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=1) then
                    begin
                    for i:= 1 to 8 do
                      begin
                        if (ORES[i] mod 2 = 0) then
                        begin
                           if (random(2) < 1) then
                           begin
                              if (random(2) < 1) then
                              begin
                                OA[i]:=1;
                                OB[i]:=ORES[i];
                              end
                              else
                              begin
                                OB[i]:=1;
                                OA[i]:=ORES[i];
                              end;
                           end
                           else
                           begin
                              if (random(2) < 1) then
                              begin
                                OA[i]:=2;
                                OB[i]:=ORES[i] div 2;
                              end
                              else
                              begin
                                OB[i]:=2;
                                OA[i]:=ORES[i] div 2;
                              end;
                           end;
                        end
                        else if(ORES[i]=9) then
                        begin
                           rng1:= random(4);
                           if(rng1=0) then
                           begin
                             OA[i]:=1;
                             OB[i]:=9;
                           end
                           else if(rng1=1) then
                           begin
                             OA[i]:=9;
                             OB[i]:=1;
                           end
                           else
                           begin
                             OA[i]:=3;
                             OB[i]:=3;
                           end;
                        end
                        else
                        //if(ORES[i]=5) or (ORES[i]=7) then
                        begin
                           if (random(2) < 1) then
                           begin
                              OA[i]:=1;
                              OB[i]:=ORES[i];
                           end
                           else
                           begin
                              OA[i]:=ORES[i];
                              OB[i]:=1;
                           end;
                        end;
                      end;
                    end // конец P=0, M=0, T=1
                    else
                    begin
                      for i:=1 to 3 do
                      begin
                         OB[i]:=1 + random(3);
                         if(PlusCB=1)and(MinusCB=0) then
                            OA[i]:=ORES[i]-OB[i]
                         else if(PlusCB=0)and(MinusCB=1) then
                            OA[i]:=ORES[i]+OB[i]
                         else if(ORES[i]+OB[i] > 9) then
                            OA[i]:=ORES[i]-OB[i]
                         else if(ORES[i]-OB[i] < 1) then
                            OA[i]:=ORES[i]+OB[i]
                         else
                         begin
                            if(random(2) < 1) then
                              OA[i]:=ORES[i]-OB[i]
                            else
                              OA[i]:=ORES[i]+OB[i];
                         end;
                         if(OA[i] + OB[i] = ORES[i]) then
                              Oz[i]:='+'
                         else Oz[i]:='-';
                      end;  // 1-3
                      mult:=false;
                      for i:=4 to 6 do
                      begin
                         if (ORES[i] > 3) and (ORES[i] < 7) then
                            OB[i]:=1 + random(3)
                         else
                            OB[i]:=3 + random(3);

                         if(PlusCB=1)and(MinusCB=0) then
                            OA[i]:=ORES[i]-OB[i]
                         else if(PlusCB=0)and(MinusCB=1) then
                            OA[i]:=ORES[i]+OB[i]
                         else if(ORES[i]+OB[i] > 9) then
                            OA[i]:=ORES[i]-OB[i]
                         else if(ORES[i]-OB[i] < 1) then
                            OA[i]:=ORES[i]+OB[i]
                         else
                         begin
                            if(random(2) < 1) then
                              OA[i]:=ORES[i]-OB[i]
                            else
                              OA[i]:=ORES[i]+OB[i];
                         end;

                         if(OA[i] + OB[i] = ORES[i]) then
                              Oz[i]:='+'
                         else Oz[i]:='-';

                         if (TimesCB=1) and not(mult) then
                         begin
                            if(random(2) < 1) or (i=6) then
                            begin
                              ORES[i]:=4 + random(6);
                              Oz[i]:='*';
                              if (ORES[i] mod 2 = 0) then
                              begin
                                 if (random(2) < 1) then
                                 begin
                                    if (random(2) < 1) then
                                    begin
                                      OA[i]:=1;
                                      OB[i]:=ORES[i];
                                    end
                                    else
                                    begin
                                      OB[i]:=1;
                                      OA[i]:=ORES[i];
                                    end;
                                 end
                                 else
                                 begin
                                    if (random(2) < 1) then
                                    begin
                                      OA[i]:=2;
                                      OB[i]:=ORES[i] div 2;
                                    end
                                    else
                                    begin
                                      OB[i]:=2;
                                      OA[i]:=ORES[i] div 2;
                                    end;
                                 end;
                              end
                              else if(ORES[i]=9) then
                              begin
                                 rng1:= random(4);
                                 if(rng1=0) then
                                 begin
                                   OA[i]:=1;
                                   OB[i]:=9;
                                 end
                                 else if(rng1=1) then
                                 begin
                                   OA[i]:=9;
                                   OB[i]:=1;
                                 end
                                 else
                                 begin
                                   OA[i]:=3;
                                   OB[i]:=3;
                                 end;
                              end;
                              if(ORES[i]=5) or (ORES[i]=7) then
                              begin
                                 if (random(2) < 1) then
                                 begin
                                    OA[i]:=1;
                                    OB[i]:=ORES[i];
                                 end
                                 else
                                 begin
                                    OA[i]:=ORES[i];
                                    OB[i]:=1;
                                 end;
                              end;
                              mult:=true;
                            end;
                         end;
                      end; // 4-6
                      mult:=false;
                      for i:=7 to 8 do
                      begin
                        if(PlusCB=1)and(MinusCB=0) then
                        begin
                           OA[i]:=1;
                           OB[i]:=ORES[i]-1;
                           Oz[i]:='+';
                        end
                        else if(PlusCB=0)and(MinusCB=1) then
                        begin
                           OA[i]:=9;
                           OB[i]:=9-ORES[i];
                           Oz[i]:='-';
                        end
                        else
                        begin
                           if(ORES[i] > 5) then
                           begin
                              OA[i]:=1;
                              OB[i]:=ORES[i]-1;
                              Oz[i]:='+';
                           end
                           else
                           begin
                              OA[i]:=9;
                              OB[i]:=9-ORES[i];
                              Oz[i]:='-';
                           end;
                        end;
                        if (TimesCB=1) and not(mult) then
                         begin
                            if(random(2) < 1) or (i=8) then
                            begin
                              ORES[i]:=4 + random(6);
                              Oz[i]:='*';
                              if (ORES[i] mod 2 = 0) then
                              begin
                                 if (random(2) < 1) then
                                 begin
                                    if (random(2) < 1) then
                                    begin
                                      OA[i]:=1;
                                      OB[i]:=ORES[i];
                                    end
                                    else
                                    begin
                                      OB[i]:=1;
                                      OA[i]:=ORES[i];
                                    end;
                                 end
                                 else
                                 begin
                                    if (random(2) < 1) then
                                    begin
                                      OA[i]:=2;
                                      OB[i]:=ORES[i] div 2;
                                    end
                                    else
                                    begin
                                      OB[i]:=2;
                                      OA[i]:=ORES[i] div 2;
                                    end;
                                 end;
                              end
                              else if(ORES[i]=9) then
                              begin
                                 rng1:= random(4);
                                 if(rng1=0) then
                                 begin
                                   OA[i]:=1;
                                   OB[i]:=9;
                                 end
                                 else if(rng1=1) then
                                 begin
                                   OA[i]:=9;
                                   OB[i]:=1;
                                 end
                                 else
                                 begin
                                   OA[i]:=3;
                                   OB[i]:=3;
                                 end;
                              end;
                              if(ORES[i]=5) or (ORES[i]=7) then
                              begin
                                 if (random(2) < 1) then
                                 begin
                                    OA[i]:=1;
                                    OB[i]:=ORES[i];
                                 end
                                 else
                                 begin
                                    OA[i]:=ORES[i];
                                    OB[i]:=1;
                                 end;
                              end;
                              mult:=true;
                            end;
                         end;
                      end;
                    end;
                end;
                1:begin
                    Op1Help.Visible:=true;
                    Op2Help.Visible:=true;
                    Op3Help.Visible:=true;
                    Op4Help.Visible:=true;
                    Op5Help.Visible:=true;
                    Op6Help.Visible:=true;
                    Op7Help.Visible:=true;
                    Op8Help.Visible:=true;
                    if (PlusCB=1)and(MinusCB=0) then
                    begin
                      for i:=1 to 3 do
                      repeat
                        OA[i]:= 7 + random(3);
                        ORES[i]:= 11 + random(3);
                        OB[i]:= ORES[i] - OA[i];
                      until not OpCheckRepeat(i);
                      for i:=4 to 6 do
                      repeat
                        OA[i]:= 6 + random(3);
                        OB[i]:= 5 + random(2);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        OA[i]:= 4 + random(3);
                        OB[i]:= 7 + random(3);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        OA[i]:= 7 + random(3);
                        OB[i]:= 7 + random(3);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                    if (PlusCB=0)and(MinusCB=1) then
                    begin
                      for i:=1 to 3 do
                      repeat
                        ORES[i]:= 7 + random(3);
                        OA[i]:= 11 + random(3);
                        OB[i]:= OA[i] - ORES[i];
                      until not OpCheckRepeat(i);
                      for i:=4 to 6 do
                      repeat
                        ORES[i]:= 6 + random(3);
                        OB[i]:= 5 + random(2);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        OA[i]:= 11 + random(3);
                        OB[i]:= 7 + random(3);
                        ORES[i]:= OA[i] - OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        ORES[i]:= 7 + random(3);
                        OB[i]:= 7 + random(3);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                    if (PlusCB=1)and(MinusCB=1) then
                    begin
                      i:=1;
                      Oz[i]:='+';
                      OA[i]:= 7 + random(3);
                      ORES[i]:= 11 + random(3);
                      OB[i]:= ORES[i] - OA[i];
                      i:=2;
                      Oz[i]:='-';
                      ORES[i]:= 7 + random(3);
                      OA[i]:= 11 + random(3);
                      OB[i]:= OA[i] - ORES[i];
                      repeat
                        i:=3;
                        Oz[i]:='+';
                        OA[i]:= 7 + random(3);
                        ORES[i]:= 11 + random(3);
                        OB[i]:= ORES[i] - OA[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=4;
                        Oz[i]:='-';
                        ORES[i]:= 6 + random(3);
                        OB[i]:= 5 + random(2);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=5;
                        Oz[i]:='+';
                        OA[i]:= 6 + random(3);
                        OB[i]:= 5 + random(2);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=6;
                        Oz[i]:='-';
                        ORES[i]:= 6 + random(3);
                        OB[i]:= 5 + random(2);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        Oz[i]:='+';
                        OA[i]:= 4 + random(3);
                        OB[i]:= 7 + random(3);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        Oz[i]:='-';
                        ORES[i]:= 7 + random(3);
                        OB[i]:= 7 + random(3);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                  end;
                2:begin
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=1)and(DivCB=0) then
                    begin
                      for i:= 1 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(8);
                          OA[i]:= 5 + random(45);
                          ORES[i]:= OB[i] * OA[i];
                        until (ORES[i] < 100) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=0)and(DivCB=1) then
                    begin
                      for i:= 1 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(8);
                          ORES[i]:= 5 + random(45);
                          OA[i]:= OB[i] * ORES[i];
                        until (OA[i] < 100) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=1)and(DivCB=1) then
                    begin
                      for i:= 1 to 4 do
                      begin
                        repeat
                          OB[i]:= 2 + random(8);
                          OA[i]:= 5 + random(45);
                          ORES[i]:= OB[i] * OA[i];
                          OZ[i]:='*';
                        until (ORES[i] < 100) and not OpCheckRepeat(i);
                      end;
                      for i:= 5 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(8);
                          ORES[i]:= 5 + random(45);
                          OA[i]:= OB[i] * ORES[i];
                          OZ[i]:=':';
                        until (OA[i] < 100) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    begin
                      for i:= 1 to 2 do
                      begin
                        repeat
                          OB[i]:= 10 + random(30);
                          OA[i]:= 10 + random(90);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 9) and (ORES[i] < 100);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      for i:= 3 to 4 do
                      begin
                        repeat
                          OB[i]:= 30 + random(40);
                          OA[i]:= 10 + random(90);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 9) and (ORES[i] < 100);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      for i:=5 to 8 do
                      begin
                        repeat
                          OB[i]:= 50 + random(50);
                          OA[i]:= 10 + random(90);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 9) and (ORES[i] < 100);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      if (TimesCB=1) and (DivCB=0) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:='*';
                          repeat
                            OB[i]:= 2 + random(8);
                            OA[i]:= 5 + random(45);
                            ORES[i]:= OB[i] * OA[i];
                          until ORES[i] < 100;
                        end;
                        i:=8;
                        Oz[i]:='*';
                        repeat
                          OB[i]:= 5 + random(5);
                          OA[i]:= 5 + random(15);
                          ORES[i]:= OB[i] * OA[i];
                        until ORES[i] < 100;
                      end;
                      if (TimesCB=0) and (DivCB=1) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:=':';
                          repeat
                            OB[i]:= 2 + random(8);
                            ORES[i]:= 5 + random(45);
                            OA[i]:= OB[i] * ORES[i];
                          until OA[i] < 100;
                        end;
                        i:=8;
                        Oz[i]:=':';
                        repeat
                          OB[i]:= 5 + random(5);
                          ORES[i]:= 5 + random(15);
                          OA[i]:= OB[i] * ORES[i];
                        until OA[i] < 100;
                      end;
                      if (TimesCB=1) and (DivCB=1) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:=':';
                          repeat
                            OB[i]:= 2 + random(8);
                            ORES[i]:= 5 + random(45);
                            OA[i]:= OB[i] * ORES[i];
                          until OA[i] < 100;
                        end;
                        i:=8;
                        Oz[i]:='*';
                        repeat
                          OB[i]:= 5 + random(5);
                          OA[i]:= 5 + random(15);
                          ORES[i]:= OB[i] * OA[i];
                        until ORES[i] < 100;
                      end;
                    end;
                  end;
                3:begin
                    if (PlusCB=1)and(MinusCB=0) then
                    begin
                      for i:=1 to 3 do
                      repeat
                        OA[i]:= 87 + random(13);
                        ORES[i]:= 101 + random(13);
                        OB[i]:= ORES[i] - OA[i];
                      until not OpCheckRepeat(i);
                      for i:=4 to 6 do
                      repeat
                        OA[i]:= 86 + random(13);
                        OB[i]:= 15 + random(12);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        OA[i]:= 84 + random(13);
                        OB[i]:= 17 + random(13);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        OA[i]:= 87 + random(13);
                        OB[i]:= 17 + random(13);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                    if (PlusCB=0)and(MinusCB=1) then
                    begin
                      for i:=1 to 3 do
                      repeat
                        ORES[i]:= 87 + random(13);
                        OA[i]:= 101 + random(13);
                        OB[i]:= OA[i] - ORES[i];
                      until not OpCheckRepeat(i);
                      for i:=4 to 6 do
                      repeat
                        ORES[i]:= 86 + random(13);
                        OB[i]:= 15 + random(12);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        OA[i]:= 101 + random(13);
                        OB[i]:= 17 + random(13);
                        ORES[i]:= OA[i] - OB[i];
                        until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        ORES[i]:= 87 + random(13);
                        OB[i]:= 17 + random(13);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                    if (PlusCB=1)and(MinusCB=1) then
                    begin
                      i:=1;
                      Oz[i]:='+';
                      OA[i]:= 87 + random(13);
                      ORES[i]:= 101 + random(13);
                      OB[i]:= ORES[i] - OA[i];
                      i:=2;
                      Oz[i]:='-';
                      ORES[i]:= 87 + random(13);
                      OA[i]:= 101 + random(13);
                      OB[i]:= OA[i] - ORES[i];
                      repeat
                        i:=3;
                        Oz[i]:='+';
                        OA[i]:= 87 + random(13);
                        ORES[i]:= 101 + random(13);
                        OB[i]:= ORES[i] - OA[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=4;
                        Oz[i]:='-';
                        ORES[i]:= 86 + random(13);
                        OB[i]:= 15 + random(12);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=5;
                        Oz[i]:='+';
                        OA[i]:= 86 + random(13);
                        OB[i]:= 15 + random(12);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=6;
                        Oz[i]:='-';
                        ORES[i]:= 86 + random(13);
                        OB[i]:= 15 + random(12);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=7;
                        Oz[i]:='+';
                        OA[i]:= 84 + random(13);
                        OB[i]:= 17 + random(13);
                        ORES[i]:= OA[i] + OB[i];
                      until not OpCheckRepeat(i);
                      repeat
                        i:=8;
                        Oz[i]:='-';
                        ORES[i]:= 87 + random(13);
                        OB[i]:= 17 + random(13);
                        OA[i]:= ORES[i] + OB[i];
                      until not OpCheckRepeat(i);
                    end;
                  end;
                4:begin
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=1)and(DivCB=0) then
                    begin
                      for i:= 1 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(18);
                          OA[i]:= 20 + random(480);
                          ORES[i]:= OB[i] * OA[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=0)and(DivCB=1) then
                    begin
                      for i:= 1 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(18);
                          ORES[i]:= 20 + random(480);
                          OA[i]:= OB[i] * ORES[i];
                        until (OA[i] > 99) and (OA[i] < 1000) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    if (PlusCB=0)and(MinusCB=0)and(TimesCB=1)and(DivCB=1) then
                    begin
                      for i:= 1 to 4 do
                      begin
                        repeat
                          OB[i]:= 2 + random(18);
                          OA[i]:= 20 + random(480);
                          ORES[i]:= OB[i] * OA[i];
                          OZ[i]:='*';
                        until (ORES[i] > 99) and (ORES[i] < 1000) and not OpCheckRepeat(i);
                      end;
                      for i:= 5 to 8 do
                      begin
                        repeat
                          OB[i]:= 2 + random(18);
                          ORES[i]:= 20 + random(480);
                          OA[i]:= OB[i] * ORES[i];
                          OZ[i]:=':';
                        until (OA[i] > 99) and (OA[i] < 1000) and not OpCheckRepeat(i);
                      end;
                    end
                    else
                    begin
                      for i:= 1 to 2 do
                      begin
                        repeat
                          OB[i]:= 100 + random(300);
                          OA[i]:= 100 + random(900);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      for i:= 3 to 4 do
                      begin
                        repeat
                          OB[i]:= 300 + random(400);
                          OA[i]:= 100 + random(900);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      for i:=5 to 8 do
                      begin
                        repeat
                          OB[i]:= 500 + random(500);
                          OA[i]:= 100 + random(900);
                          if(MinusCB = 0) then
                            ORES[i]:= OA[i] + OB[i]
                          else if(PlusCB = 0) then
                            ORES[i]:= OA[i] - OB[i]
                          else if(random(2) < 1) then
                            ORES[i]:= OA[i] + OB[i]
                          else
                            ORES[i]:= OA[i] - OB[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000);
                        if(OA[i] + OB[i] = ORES[i]) then
                            Oz[i]:='+'
                        else Oz[i]:='-';
                      end;
                      if (TimesCB=1)and(DivCB=0) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:='*';
                          repeat
                            OB[i]:= 2 + random(18);
                            OA[i]:= 20 + random(480);
                            ORES[i]:= OB[i] * OA[i];
                          until (ORES[i] > 99) and (ORES[i] < 1000);
                        end;
                        i:=8;
                        Oz[i]:='*';
                        repeat
                          OB[i]:= 11 + random(19);
                          OA[i]:= 20 + random(70);
                          ORES[i]:= OB[i] * OA[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000);
                      end;
                      if (TimesCB=0)and(DivCB=1) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:=':';
                          repeat
                            OB[i]:= 2 + random(18);
                            ORES[i]:= 20 + random(480);
                            OA[i]:= OB[i] * ORES[i];
                          until (OA[i] > 99) and (OA[i] < 1000);
                        end;
                        i:=8;
                        Oz[i]:=':';
                        repeat
                          OB[i]:= 11 + random(19);
                          ORES[i]:= 20 + random(70);
                          OA[i]:= OB[i] * ORES[i];
                        until (OA[i] > 99) and (OA[i] < 1000);
                      end;
                      if (TimesCB=1)and(DivCB=1) then
                      begin
                        for i:= 5 to 6 do
                        begin
                          Oz[i]:=':';
                          repeat
                            OB[i]:= 2 + random(18);
                            ORES[i]:= 20 + random(480);
                            OA[i]:= OB[i] * ORES[i];
                          until (OA[i] > 99) and (OA[i] < 1000);
                        end;
                        i:=8;
                        Oz[i]:='*';
                        repeat
                          OB[i]:= 11 + random(19);
                          OA[i]:= 20 + random(70);
                          ORES[i]:= OB[i] * OA[i];
                        until (ORES[i] > 99) and (ORES[i] < 1000);
                      end;
                    end;
                  end;
        end;
        //_______________________________________________________________
        Op1A.Caption:= IntToStr(OA[1]);
        Op2A.Caption:= IntToStr(OA[2]);
        Op3A.Caption:= IntToStr(OA[3]);
        Op4A.Caption:= IntToStr(OA[4]);
        Op5A.Caption:= IntToStr(OA[5]);
        Op6A.Caption:= IntToStr(OA[6]);
        Op7A.Caption:= IntToStr(OA[7]);
        Op8A.Caption:= IntToStr(OA[8]);
        Op1z.Caption:= Oz[1];
        Op2z.Caption:= Oz[2];
        Op3z.Caption:= Oz[3];
        Op4z.Caption:= Oz[4];
        Op5z.Caption:= Oz[5];
        Op6z.Caption:= Oz[6];
        Op7z.Caption:= Oz[7];
        Op8z.Caption:= Oz[8];
        Op1B.Caption:= IntToStr(OB[1]);
        Op2B.Caption:= IntToStr(OB[2]);
        Op3B.Caption:= IntToStr(OB[3]);
        Op4B.Caption:= IntToStr(OB[4]);
        Op5B.Caption:= IntToStr(OB[5]);
        Op6B.Caption:= IntToStr(OB[6]);
        Op7B.Caption:= IntToStr(OB[7]);
        Op8B.Caption:= IntToStr(OB[8]);
     end;
     1 :
     begin
        AbilitiesTraining.Caption:='Устный счет - Строки';
        TipStroka.Visible:=true;
        Stroka_counter:=3;
        // sLabel 42, 44 - начальные числа
        // sLabel 43 - начальный знак
        // sLabel 6 - результат (дебаг)

        Stroka_length := 2*MentalAbilitiesDevelopment.sTrackBar4.Position + 1;

        PartLabel2.Caption:='1 из '+IntToStr((Stroka_length + 1) div 2);

        FillStroka(MentalAbilitiesDevelopment.sRadioGroup3.ItemIndex,
                   MentalAbilitiesDevelopment.sRadioGroup4.ItemIndex);

        Case Stroka_length of
          3:
          begin
            sLabel42.Caption:=IntToStr(Stroka3[1]);
            sLabel43.Caption:=Stroka3_znaki[1];
            sLabel44.Caption:=IntToStr(Stroka3[2]);
          end;
          5:
          begin
            sLabel42.Caption:=IntToStr(Stroka5[1]);
            sLabel43.Caption:=Stroka5_znaki[1];
            sLabel44.Caption:=IntToStr(Stroka5[2]);
          end;
          7:
          begin
            sLabel42.Caption:=IntToStr(Stroka7[1]);
            sLabel43.Caption:=Stroka7_znaki[1];
            sLabel44.Caption:=IntToStr(Stroka7[2]);
          end;
          9:
          begin
            sLabel42.Caption:=IntToStr(Stroka9[1]);
            sLabel43.Caption:=Stroka9_znaki[1];
            sLabel44.Caption:=IntToStr(Stroka9[2]);
          end;
        end;

     end; 
     2 :
     begin
        AbilitiesTraining.Caption:='Устный счет - Таблица умножения';
        sDecimalSpinEdit4.Text:='';
        sDecimalSpinEdit5.Text:='';
        sDecimalSpinEdit6.Text:='';
        sDecimalSpinEdit7.Text:='';
        sDecimalSpinEdit8.Text:='';
        sDecimalSpinEdit9.Text:='';
        sDecimalSpinEdit10.Text:='';
        sDecimalSpinEdit11.Text:='';
        sLabel20.Caption:='?/8';
        TipOperacii.Visible:=false;
        TipMatrix5.Visible:=false;
        TipStroka.Visible:=false;
        //sBitBtn2.Enabled:=true;
        TipTablica.Visible:=true;
        Timer3.Enabled:=true;
        if(MentalAbilitiesDevelopment.sRadioGroup2.ItemIndex=0) then
          FillARandom
        else
          FillAInt(MentalAbilitiesDevelopment.sRadioGroup2.ItemIndex + 1);

        FillBRandom;

        sLabel11.Caption:=IntToStr(A[1])+'      '+'*'+'      '+IntToStr(B[1])+'   =';
        sLabel12.Caption:=IntToStr(A[2])+'      '+'*'+'      '+IntToStr(B[2])+'   =';
        sLabel13.Caption:=IntToStr(A[3])+'      '+'*'+'      '+IntToStr(B[3])+'   =';
        sLabel14.Caption:=IntToStr(A[4])+'      '+'*'+'      '+IntToStr(B[4])+'   =';
        sLabel15.Caption:=IntToStr(A[5])+'      '+'*'+'      '+IntToStr(B[5])+'   =';
        sLabel16.Caption:=IntToStr(A[6])+'      '+'*'+'      '+IntToStr(B[6])+'   =';
        sLabel17.Caption:=IntToStr(A[7])+'      '+'*'+'      '+IntToStr(B[7])+'   =';
        sLabel18.Caption:=IntToStr(A[8])+'      '+'*'+'      '+IntToStr(B[8])+'   =';
     end;
     3 :
     begin
        AbilitiesTraining.Caption:='Устный счет - Матрицы';
        TipMatrixRes.Visible:=false;

        Mx3Line1Res.Text:='';
        Mx3Line2Res.Text:='';
        Mx3Line3Res.Text:='';
        Mx3Col1Res.Text:='';
        Mx3Col2Res.Text:='';
        Mx3Col3Res.Text:='';

        Mx4Line1Res.Text:='';
        Mx4Line2Res.Text:='';
        Mx4Line3Res.Text:='';
        Mx4Line4Res.Text:='';
        Mx4Col1Res.Text:='';
        Mx4Col2Res.Text:='';
        Mx4Col3Res.Text:='';
        Mx4Col4Res.Text:='';

        Mx5Line1Res.Text:='';
        Mx5Line2Res.Text:='';
        Mx5Line3Res.Text:='';
        Mx5Line4Res.Text:='';
        Mx5Line5Res.Text:='';
        Mx5Col1Res.Text:='';
        Mx5Col2Res.Text:='';
        Mx5Col3Res.Text:='';
        Mx5Col4Res.Text:='';
        Mx5Col5Res.Text:='';

        CorrectAmount.Caption:='?/'+IntToStr(MatrixDim*2);
        Timer4.Enabled:=true;

        Case MatrixDim of
        3 :
        begin
           TipMatrix3.Visible:=true;

           //____________Выравниваем знаки_________________
           Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin
              LayoutMx3(166, 128);
            end;
            1:begin
              LayoutMx3(170, 134);
            end;
            2:begin
              LayoutMx3(174, 134);
            end;
           end;
           //____________________________________________________________
           //____________Зарандомили числа по настройкам_________________
            Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin

                //Проверка 1-ой строки на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_11.Caption), StrToInt(Mx3_12.Caption), StrToInt(Mx3_13.Caption), 0, 0) <= 0) do
                begin
                Mx3_11.Caption:=IntToStr(random(9));
                Mx3_12.Caption:=IntToStr(random(9));
                Mx3_13.Caption:=IntToStr(random(9));
                end;
                //Проверка 2-ой строки на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_21.Caption), StrToInt(Mx3_22.Caption),StrToInt(Mx3_23.Caption), 0, 0) <= 0) do
                begin
                Mx3_21.Caption:=IntToStr(random(9));
                Mx3_22.Caption:=IntToStr(random(9));
                Mx3_23.Caption:=IntToStr(random(9));
                end;
                //Проверка 3-ой строки на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_31.Caption), StrToInt(Mx3_32.Caption),StrToInt(Mx3_33.Caption), 0, 0) <= 0) do
                begin
                Mx3_31.Caption:=IntToStr(random(9));
                Mx3_32.Caption:=IntToStr(random(9));
                Mx3_33.Caption:=IntToStr(random(9));
                end;
                //Проверка 1-го столбца на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_11.Caption), StrToInt(Mx3_21.Caption),StrToInt(Mx3_31.Caption), 0, 0) <= 0) do
                begin
                Mx3_11.Caption:=IntToStr(random(9));
                Mx3_21.Caption:=IntToStr(random(9));
                Mx3_31.Caption:=IntToStr(random(9));
                end;
                //Проверка 2-го столбца на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_12.Caption), StrToInt(Mx3_22.Caption),StrToInt(Mx3_32.Caption), 0, 0) <= 0) do
                begin
                Mx3_12.Caption:=IntToStr(random(9));
                Mx3_22.Caption:=IntToStr(random(9));
                Mx3_32.Caption:=IntToStr(random(9));
                end;
                //Проверка 3-го столбца на отрицательный результат
                while (NegativeMatrix(StrToInt(Mx3_13.Caption), StrToInt(Mx3_23.Caption),StrToInt(Mx3_33.Caption), 0, 0) <= 0) do
                begin
                Mx3_13.Caption:=IntToStr(random(9));
                Mx3_23.Caption:=IntToStr(random(9));
                Mx3_33.Caption:=IntToStr(random(9));
                end;
              end;
            1:begin
                Mx3_11.Caption:=IntToStr(10 + random(89));
                Mx3_12.Caption:=IntToStr(10 + random(89));
                Mx3_13.Caption:=IntToStr(10 + random(89));

                Mx3_21.Caption:=IntToStr(10 + random(89));
                Mx3_22.Caption:=IntToStr(10 + random(89));
                Mx3_23.Caption:=IntToStr(10 + random(89));

                Mx3_31.Caption:=IntToStr(10 + random(89));
                Mx3_32.Caption:=IntToStr(10 + random(89));
                Mx3_33.Caption:=IntToStr(10 + random(89));
              end;
            2:begin
                Mx3_11.Caption:=IntToStr(100 + random(899));
                Mx3_12.Caption:=IntToStr(100 + random(899));
                Mx3_13.Caption:=IntToStr(100 + random(899));

                Mx3_21.Caption:=IntToStr(100 + random(899));
                Mx3_22.Caption:=IntToStr(100 + random(899));
                Mx3_23.Caption:=IntToStr(100 + random(899));

                Mx3_31.Caption:=IntToStr(100 + random(899));
                Mx3_32.Caption:=IntToStr(100 + random(899));
                Mx3_33.Caption:=IntToStr(100 + random(899));
              end;
            end;
        //_______________________________________________________________
        //__Зарандомили знаки по настройкам и посчитали в посл.аргумент__
            WriteInMx3(PlusCB, MinusCB,
                       Mx3_11, Mx3_12, Mx3_13,
                       Mx3Line1_1, Mx3Line1_2,
                       MxResLine1);
            WriteInMx3(PlusCB, MinusCB,
                       Mx3_21, Mx3_22, Mx3_23,
                       Mx3Line2_1, Mx3Line2_2,
                       MxResLine2);
            WriteInMx3(PlusCB, MinusCB,
                       Mx3_31, Mx3_32, Mx3_33,
                       Mx3Line3_1, Mx3Line3_2,
                       MxResLine3);

            WriteInMx3(PlusCB, MinusCB,
                       Mx3_11, Mx3_21, Mx3_31,
                       Mx3Col1_1, Mx3Col1_2,
                       MxResCol1);
            WriteInMx3(PlusCB, MinusCB,
                       Mx3_12, Mx3_22, Mx3_32,
                       Mx3Col2_1, Mx3Col2_2,
                       MxResCol2);
            WriteInMx3(PlusCB, MinusCB,
                       Mx3_13, Mx3_23, Mx3_33,
                       Mx3Col3_1, Mx3Col3_2,
                       MxResCol3);


        //_______________________________________________________________
        end; // конец 3х3
        4 :
        begin
           TipMatrix4.Visible:=true;

           //____________Выравниваем знаки_________________
           Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin
              LayoutMx4(118, 80);
            end;
            1:begin
              LayoutMx4(122, 86);
            end;
            2:begin
              LayoutMx4(126, 86);
            end;
           end;
           //______________________________________________

           //____________Зарандомили числа по настройкам_________________
            Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin
                Mx4_11.Caption:=IntToStr(random(9));
                Mx4_12.Caption:=IntToStr(random(9));
                Mx4_13.Caption:=IntToStr(random(9));
                Mx4_14.Caption:=IntToStr(random(9));

                Mx4_21.Caption:=IntToStr(random(9));
                Mx4_22.Caption:=IntToStr(random(9));
                Mx4_23.Caption:=IntToStr(random(9));
                Mx4_24.Caption:=IntToStr(random(9));

                Mx4_31.Caption:=IntToStr(random(9));
                Mx4_32.Caption:=IntToStr(random(9));
                Mx4_33.Caption:=IntToStr(random(9));
                Mx4_34.Caption:=IntToStr(random(9));

                Mx4_41.Caption:=IntToStr(random(9));
                Mx4_42.Caption:=IntToStr(random(9));
                Mx4_43.Caption:=IntToStr(random(9));
                Mx4_44.Caption:=IntToStr(random(9));
              end;
            1:begin
                Mx4_11.Caption:=IntToStr(10 + random(89));
                Mx4_12.Caption:=IntToStr(10 + random(89));
                Mx4_13.Caption:=IntToStr(10 + random(89));
                Mx4_14.Caption:=IntToStr(10 + random(89));

                Mx4_21.Caption:=IntToStr(10 + random(89));
                Mx4_22.Caption:=IntToStr(10 + random(89));
                Mx4_23.Caption:=IntToStr(10 + random(89));
                Mx4_24.Caption:=IntToStr(10 + random(89));

                Mx4_31.Caption:=IntToStr(10 + random(89));
                Mx4_32.Caption:=IntToStr(10 + random(89));
                Mx4_33.Caption:=IntToStr(10 + random(89));
                Mx4_34.Caption:=IntToStr(10 + random(89));

                Mx4_41.Caption:=IntToStr(10 + random(89));
                Mx4_42.Caption:=IntToStr(10 + random(89));
                Mx4_43.Caption:=IntToStr(10 + random(89));
                Mx4_44.Caption:=IntToStr(10 + random(89));
              end;
            2:begin
                Mx4_11.Caption:=IntToStr(100 + random(899));
                Mx4_12.Caption:=IntToStr(100 + random(899));
                Mx4_13.Caption:=IntToStr(100 + random(899));
                Mx4_14.Caption:=IntToStr(100 + random(899));

                Mx4_21.Caption:=IntToStr(100 + random(899));
                Mx4_22.Caption:=IntToStr(100 + random(899));
                Mx4_23.Caption:=IntToStr(100 + random(899));
                Mx4_24.Caption:=IntToStr(100 + random(899));

                Mx4_31.Caption:=IntToStr(100 + random(899));
                Mx4_32.Caption:=IntToStr(100 + random(899));
                Mx4_33.Caption:=IntToStr(100 + random(899));
                Mx4_34.Caption:=IntToStr(100 + random(899));

                Mx4_41.Caption:=IntToStr(100 + random(899));
                Mx4_42.Caption:=IntToStr(100 + random(899));
                Mx4_43.Caption:=IntToStr(100 + random(899));
                Mx4_44.Caption:=IntToStr(100 + random(899));
              end;
            end;
        //_______________________________________________________________
        //__Зарандомили знаки по настройкам и посчитали в посл.аргумент__
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_11, Mx4_12, Mx4_13, Mx4_14,
                       Mx4Line1_1, Mx4Line1_2, Mx4Line1_3,
                       MxResLine1);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_21, Mx4_22, Mx4_23, Mx4_24,
                       Mx4Line2_1, Mx4Line2_2, Mx4Line2_3,
                       MxResLine2);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_31, Mx4_32, Mx4_33, Mx4_34,
                       Mx4Line3_1, Mx4Line3_2, Mx4Line3_3,
                       MxResLine3);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_41, Mx4_42, Mx4_43, Mx4_44,
                       Mx4Line4_1, Mx4Line4_2, Mx4Line4_3,
                       MxResLine4);

            WriteInMx4(PlusCB, MinusCB,
                       Mx4_11, Mx4_21, Mx4_31, Mx4_41,
                       Mx4Col1_1, Mx4Col1_2, Mx4Col1_3,
                       MxResCol1);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_12, Mx4_22, Mx4_32, Mx4_42,
                       Mx4Col2_1, Mx4Col2_2, Mx4Col2_3,
                       MxResCol2);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_13, Mx4_23, Mx4_33, Mx4_43,
                       Mx4Col3_1, Mx4Col3_2, Mx4Col3_3,
                       MxResCol3);
            WriteInMx4(PlusCB, MinusCB,
                       Mx4_14, Mx4_24, Mx4_34, Mx4_44,
                       Mx4Col4_1, Mx4Col4_2, Mx4Col4_3,
                       MxResCol4);
        //_______________________________________________________________

        end; // конец 4x4
        5 :
        begin
           TipMatrix5.Visible:=true;
           //____________Выравниваем знаки_________________
           Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin
              LayoutMx5(92, 56);
            end;
            1:begin
              LayoutMx5(96, 62);
            end;
            2:begin
              LayoutMx5(102, 62);
            end;
           end;
           //______________________________________________

           //____________Зарандомили числа по настройкам_________________
            Case MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex of
            0:begin
                Mx5_11.Caption:=IntToStr(random(9));
                Mx5_12.Caption:=IntToStr(random(9));
                Mx5_13.Caption:=IntToStr(random(9));
                Mx5_14.Caption:=IntToStr(random(9));
                Mx5_15.Caption:=IntToStr(random(9));

                Mx5_21.Caption:=IntToStr(random(9));
                Mx5_22.Caption:=IntToStr(random(9));
                Mx5_23.Caption:=IntToStr(random(9));
                Mx5_24.Caption:=IntToStr(random(9));
                Mx5_25.Caption:=IntToStr(random(9));

                Mx5_31.Caption:=IntToStr(random(9));
                Mx5_32.Caption:=IntToStr(random(9));
                Mx5_33.Caption:=IntToStr(random(9));
                Mx5_34.Caption:=IntToStr(random(9));
                Mx5_35.Caption:=IntToStr(random(9));

                Mx5_41.Caption:=IntToStr(random(9));
                Mx5_42.Caption:=IntToStr(random(9));
                Mx5_43.Caption:=IntToStr(random(9));
                Mx5_44.Caption:=IntToStr(random(9));
                Mx5_45.Caption:=IntToStr(random(9));

                Mx5_51.Caption:=IntToStr(random(9));
                Mx5_52.Caption:=IntToStr(random(9));
                Mx5_53.Caption:=IntToStr(random(9));
                Mx5_54.Caption:=IntToStr(random(9));
                Mx5_55.Caption:=IntToStr(random(9));
              end;
            1:begin
                Mx5_11.Caption:=IntToStr(10 + random(89));
                Mx5_12.Caption:=IntToStr(10 + random(89));
                Mx5_13.Caption:=IntToStr(10 + random(89));
                Mx5_14.Caption:=IntToStr(10 + random(89));
                Mx5_15.Caption:=IntToStr(10 + random(89));

                Mx5_21.Caption:=IntToStr(10 + random(89));
                Mx5_22.Caption:=IntToStr(10 + random(89));
                Mx5_23.Caption:=IntToStr(10 + random(89));
                Mx5_24.Caption:=IntToStr(10 + random(89));
                Mx5_25.Caption:=IntToStr(10 + random(89));

                Mx5_31.Caption:=IntToStr(10 + random(89));
                Mx5_32.Caption:=IntToStr(10 + random(89));
                Mx5_33.Caption:=IntToStr(10 + random(89));
                Mx5_34.Caption:=IntToStr(10 + random(89));
                Mx5_35.Caption:=IntToStr(10 + random(89));

                Mx5_41.Caption:=IntToStr(10 + random(89));
                Mx5_42.Caption:=IntToStr(10 + random(89));
                Mx5_43.Caption:=IntToStr(10 + random(89));
                Mx5_44.Caption:=IntToStr(10 + random(89));
                Mx5_45.Caption:=IntToStr(10 + random(89));

                Mx5_51.Caption:=IntToStr(10 + random(89));
                Mx5_52.Caption:=IntToStr(10 + random(89));
                Mx5_53.Caption:=IntToStr(10 + random(89));
                Mx5_54.Caption:=IntToStr(10 + random(89));
                Mx5_55.Caption:=IntToStr(10 + random(89));
              end;
            2:begin
                Mx5_11.Caption:=IntToStr(100 + random(899));
                Mx5_12.Caption:=IntToStr(100 + random(899));
                Mx5_13.Caption:=IntToStr(100 + random(899));
                Mx5_14.Caption:=IntToStr(100 + random(899));
                Mx5_15.Caption:=IntToStr(100 + random(899));

                Mx5_21.Caption:=IntToStr(100 + random(899));
                Mx5_22.Caption:=IntToStr(100 + random(899));
                Mx5_23.Caption:=IntToStr(100 + random(899));
                Mx5_24.Caption:=IntToStr(100 + random(899));
                Mx5_25.Caption:=IntToStr(100 + random(899));

                Mx5_31.Caption:=IntToStr(100 + random(899));
                Mx5_32.Caption:=IntToStr(100 + random(899));
                Mx5_33.Caption:=IntToStr(100 + random(899));
                Mx5_34.Caption:=IntToStr(100 + random(899));
                Mx5_35.Caption:=IntToStr(100 + random(899));

                Mx5_41.Caption:=IntToStr(100 + random(899));
                Mx5_42.Caption:=IntToStr(100 + random(899));
                Mx5_43.Caption:=IntToStr(100 + random(899));
                Mx5_44.Caption:=IntToStr(100 + random(899));
                Mx5_45.Caption:=IntToStr(100 + random(899));

                Mx5_51.Caption:=IntToStr(100 + random(899));
                Mx5_52.Caption:=IntToStr(100 + random(899));
                Mx5_53.Caption:=IntToStr(100 + random(899));
                Mx5_54.Caption:=IntToStr(100 + random(899));
                Mx5_55.Caption:=IntToStr(100 + random(899));
              end;
            end;
        //_______________________________________________________________
        //__Зарандомили знаки по настройкам и посчитали в посл.аргумент__
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_11, Mx5_12, Mx5_13, Mx5_14, Mx5_15,
                       Mx5Line1_1, Mx5Line1_2, Mx5Line1_3, Mx5Line1_4,
                       MxResLine1);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_21, Mx5_22, Mx5_23, Mx5_24, Mx5_25,
                       Mx5Line2_1, Mx5Line2_2, Mx5Line2_3, Mx5Line2_4,
                       MxResLine2);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_31, Mx5_32, Mx5_33, Mx5_34, Mx5_35,
                       Mx5Line3_1, Mx5Line3_2, Mx5Line3_3, Mx5Line3_4,
                       MxResLine3);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_41, Mx5_42, Mx5_43, Mx5_44, Mx5_45,
                       Mx5Line4_1, Mx5Line4_2, Mx5Line4_3, Mx5Line4_4,
                       MxResLine4);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_51, Mx5_52, Mx5_53, Mx5_54, Mx5_55,
                       Mx5Line5_1, Mx5Line5_2, Mx5Line5_3, Mx5Line5_4,
                       MxResLine5);

            WriteInMx5(PlusCB, MinusCB,
                       Mx5_11, Mx5_21, Mx5_31, Mx5_41, Mx5_51,
                       Mx5Col1_1, Mx5Col1_2, Mx5Col1_3, Mx5Col1_4,
                       MxResCol1);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_12, Mx5_22, Mx5_32, Mx5_42, Mx5_52,
                       Mx5Col2_1, Mx5Col2_2, Mx5Col2_3, Mx5Col2_4,
                       MxResCol2);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_13, Mx5_23, Mx5_33, Mx5_43, Mx5_53,
                       Mx5Col3_1, Mx5Col3_2, Mx5Col3_3, Mx5Col3_4,
                       MxResCol3);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_14, Mx5_24, Mx5_34, Mx5_44, Mx5_54,
                       Mx5Col4_1, Mx5Col4_2, Mx5Col4_3, Mx5Col4_4,
                       MxResCol4);
            WriteInMx5(PlusCB, MinusCB,
                       Mx5_15, Mx5_25, Mx5_35, Mx5_45, Mx5_55,
                       Mx5Col5_1, Mx5Col5_2, Mx5Col5_3, Mx5Col5_4,
                       MxResCol5);
        //_______________________________________________________________

        end; // конец 5х5
        end; // конец перебора всех MatrixDim

     end; // конец случая с режимом матриц
   end; // конец перебора всех режимов устного счета
end;

procedure TAbilitiesTraining.LayoutMx3 (Sign, Eq : Integer);
begin
   Mx3Line1_1.Left:=Sign;
   Mx3Line2_1.Left:=Mx3Line1_1.Left;
   Mx3Line3_1.Left:=Mx3Line1_1.Left;

   Mx3Line1_2.Left:=Mx3Line1_1.Left + 80;
   Mx3Line2_2.Left:=Mx3Line1_2.Left;
   Mx3Line3_2.Left:=Mx3Line1_2.Left;

   Mx3Col1Eq.Left:=Eq;
   Mx3Col2Eq.Left:=Mx3Col1Eq.Left + 80;
   Mx3Col3Eq.Left:=Mx3Col2Eq.Left + 80;
end;

procedure TAbilitiesTraining.LayoutMx4 (Sign, Eq : Integer);
begin
   Mx4Line1_1.Left:=Sign;
   Mx4Line2_1.Left:=Mx4Line1_1.Left;
   Mx4Line3_1.Left:=Mx4Line1_1.Left;
   Mx4Line4_1.Left:=Mx4Line1_1.Left;

   Mx4Line1_2.Left:=Mx4Line1_1.Left + 80;
   Mx4Line2_2.Left:=Mx4Line1_2.Left;
   Mx4Line3_2.Left:=Mx4Line1_2.Left;
   Mx4Line4_2.Left:=Mx4Line1_2.Left;

   Mx4Line1_3.Left:=Mx4Line1_2.Left + 80;
   Mx4Line2_3.Left:=Mx4Line1_3.Left;
   Mx4Line3_3.Left:=Mx4Line1_3.Left;
   Mx4Line4_3.Left:=Mx4Line1_3.Left;

   Mx4Col1Eq.Left:=Eq;
   Mx4Col2Eq.Left:=Mx4Col1Eq.Left + 80;
   Mx4Col3Eq.Left:=Mx4Col2Eq.Left + 80;
   Mx4Col4Eq.Left:=Mx4Col3Eq.Left + 80;
end;

procedure TAbilitiesTraining.LayoutMx5 (Sign, Eq : Integer);
begin
  Mx5Line1_1.Left:=Sign;
  Mx5Line2_1.Left:=Mx5Line1_1.Left;
  Mx5Line3_1.Left:=Mx5Line1_1.Left;
  Mx5Line4_1.Left:=Mx5Line1_1.Left;
  Mx5Line5_1.Left:=Mx5Line1_1.Left;

  Mx5Line1_2.Left:=Mx5Line1_1.Left + 80;
  Mx5Line2_2.Left:=Mx5Line1_2.Left;
  Mx5Line3_2.Left:=Mx5Line1_2.Left;
  Mx5Line4_2.Left:=Mx5Line1_2.Left;
  Mx5Line5_2.Left:=Mx5Line1_2.Left;

  Mx5Line1_3.Left:=Mx5Line1_2.Left + 80;
  Mx5Line2_3.Left:=Mx5Line1_3.Left;
  Mx5Line3_3.Left:=Mx5Line1_3.Left;
  Mx5Line4_3.Left:=Mx5Line1_3.Left;
  Mx5Line5_3.Left:=Mx5Line1_3.Left;

  Mx5Line1_4.Left:=Mx5Line1_3.Left + 80;
  Mx5Line2_4.Left:=Mx5Line1_4.Left;
  Mx5Line3_4.Left:=Mx5Line1_4.Left;
  Mx5Line4_4.Left:=Mx5Line1_4.Left;
  Mx5Line5_4.Left:=Mx5Line1_4.Left;

  Mx5Col1Eq.Left:=Eq;
  Mx5Col2Eq.Left:=Mx5Col1Eq.Left + 80;
  Mx5Col3Eq.Left:=Mx5Col2Eq.Left + 80;
  Mx5Col4Eq.Left:=Mx5Col3Eq.Left + 80;
  Mx5Col5Eq.Left:=Mx5Col4Eq.Left + 80;
end;

procedure WriteInMx3 (Plus, Minus: Integer;
                      N1, N2, N3 : TsLabel;
                      L1, L2 : TsLabel;
                      out Res : Integer);
var
  x : array[1..2] of Integer;
  i : Integer;
begin
  if(Plus=1) and (Minus=0) then
  begin
     L1.Caption:= '+';
     L2.Caption:= '+';
     Res:= StrToInt(N1.Caption) + StrToInt(N2.Caption) + StrToInt(N3.Caption);
  end
  else
  if(Plus=0) and (Minus=1) then
  begin
     L1.Caption:= '-';
     L2.Caption:= '-';
     Res:= StrToInt(N1.Caption) - StrToInt(N2.Caption) - StrToInt(N3.Caption);
  end
  else
  begin
    for i:= 1 to 2 do
    begin
      x[i]:=random(2);
    end;
    if(x[1]=0) then L1.Caption:= '+' else L1.Caption:= '-';
    if(x[2]=0) then L2.Caption:= '+' else L2.Caption:= '-';
    Res:= StrToInt(N1.Caption);
    if(x[1]=0) then Res:=Res+StrToInt(N2.Caption) else Res:=Res-StrToInt(N2.Caption);
    if(x[2]=0) then Res:=Res+StrToInt(N3.Caption) else Res:=Res-StrToInt(N3.Caption);
  end;

end;

procedure WriteInMx4 (Plus, Minus: Integer;
                      N1, N2, N3, N4 : TsLabel;
                      L1, L2, L3 : TsLabel;
                      out Res : Integer);
var
  x : array[1..3] of Integer;
  i : Integer;
begin
  if(Plus=1) and (Minus=0) then
  begin
     L1.Caption:= '+';
     L2.Caption:= '+';
     L3.Caption:= '+';
     Res:= StrToInt(N1.Caption) + StrToInt(N2.Caption) + StrToInt(N3.Caption) +
           StrToInt(N4.Caption);
  end
  else
  if(Plus=0) and (Minus=1) then
  begin
     L1.Caption:= '-';
     L2.Caption:= '-';
     L3.Caption:= '-';
     Res:= StrToInt(N1.Caption) - StrToInt(N2.Caption) - StrToInt(N3.Caption) -
           StrToInt(N4.Caption);
  end
  else
  begin
    for i:= 1 to 3 do
    begin
      x[i]:=random(2);
    end;
    if(x[1]=0) then L1.Caption:= '+' else L1.Caption:= '-';
    if(x[2]=0) then L2.Caption:= '+' else L2.Caption:= '-';
    if(x[3]=0) then L3.Caption:= '+' else L3.Caption:= '-';
    Res:= StrToInt(N1.Caption);
    if(x[1]=0) then Res:=Res+StrToInt(N2.Caption) else Res:=Res-StrToInt(N2.Caption);
    if(x[2]=0) then Res:=Res+StrToInt(N3.Caption) else Res:=Res-StrToInt(N3.Caption);
    if(x[3]=0) then Res:=Res+StrToInt(N4.Caption) else Res:=Res-StrToInt(N4.Caption);
  end;

end;

procedure WriteInMx5 (Plus, Minus: Integer;
                      N1, N2, N3, N4, N5 : TsLabel;
                      L1, L2, L3, L4 : TsLabel;
                      out Res : Integer);
var
  x : array[1..4] of Integer;
  i : Integer;
begin
  if(Plus=1) and (Minus=0) then
  begin
     L1.Caption:= '+';
     L2.Caption:= '+';
     L3.Caption:= '+';
     L4.Caption:= '+';
     Res:= StrToInt(N1.Caption) + StrToInt(N2.Caption) + StrToInt(N3.Caption) +
           StrToInt(N4.Caption) + StrToInt(N5.Caption);
  end
  else
  if(Plus=0) and (Minus=1) then
  begin
     L1.Caption:= '-';
     L2.Caption:= '-';
     L3.Caption:= '-';
     L4.Caption:= '-';
     Res:= StrToInt(N1.Caption) - StrToInt(N2.Caption) - StrToInt(N3.Caption) -
           StrToInt(N4.Caption) - StrToInt(N5.Caption);
  end
  else
  begin
    for i:= 1 to 4 do
    begin
      x[i]:=random(2);
    end;
    if(x[1]=0) then L1.Caption:= '+' else L1.Caption:= '-';
    if(x[2]=0) then L2.Caption:= '+' else L2.Caption:= '-';
    if(x[3]=0) then L3.Caption:= '+' else L3.Caption:= '-';
    if(x[4]=0) then L4.Caption:= '+' else L4.Caption:= '-';
    Res:= StrToInt(N1.Caption);
    if(x[1]=0) then Res:=Res+StrToInt(N2.Caption) else Res:=Res-StrToInt(N2.Caption);
    if(x[2]=0) then Res:=Res+StrToInt(N3.Caption) else Res:=Res-StrToInt(N3.Caption);
    if(x[3]=0) then Res:=Res+StrToInt(N4.Caption) else Res:=Res-StrToInt(N4.Caption);
    if(x[4]=0) then Res:=Res+StrToInt(N5.Caption) else Res:=Res-StrToInt(N5.Caption);
  end;

end;

function TAbilitiesTraining.GenStrokaRandom (Numbers : Integer;
                                              NoZero : Boolean) : Integer;
begin
   if (NoZero) then
   Case Numbers of
   0:begin
     Result := 1 + random(9);
     end;
   1:begin
     Result := 10 + random(90);
     end;
   2:begin
     Result := 100 + random(900);
     end;
   3:begin
     Result :=1 + random(19);
     end;
   4:begin
     Result :=1 + random(29);
     end;
   5:begin
     Result :=1 + random(39);
     end;
   end
   else
   Case Numbers of
   0:begin
     Result := random(10);
     end;
   1:begin
     Result := 10 + random(90);
     end;
   2:begin
     Result := 100 + random(900);
     end;
   3:begin
     Result :=1 + random(19);
     end;
   4:begin
     Result :=1 + random(29);
     end;
   5:begin
     Result :=1 + random(39);
     end;
   end;
end;

procedure TAbilitiesTraining.FillStroka (Numbers : Integer; Signs : Integer);
var
   iter, jter, ax, bx, cx : Integer;
   cap : Integer;
begin
   if (Numbers = 0) then cap:= 10;
   if (Numbers = 1) then cap:= 100;
   if (Numbers = 2) then cap:= 1000;
   if (Numbers = 3) then cap:= 20;
   if (Numbers = 4) then cap:= 30;
   if (Numbers = 5) then cap:= 40;


   // выбрали результат
   Stroka_result := GenStrokaRandom(Numbers, true);

   // в зависимости от количества и вида операций наполняем строки
   Case Stroka_length of
   3:begin
     if(Signs = 0) then
     begin
        Stroka_result := 0;
        for iter := 1 to 3 do
        begin
            Stroka3[iter] := GenStrokaRandom(Numbers, false);
            Stroka3_znaki[iter] := '+';
            Stroka_result := Stroka_result + Stroka3[iter];
        end;
        Stroka3[4] := GenStrokaRandom(Numbers, false);
        Stroka_result := Stroka_result + Stroka3[4];
     end
     else if(Signs = 1) then // три операции, только + и -
     begin
        repeat
          for iter := 1 to 3 do
            Stroka3[iter] := GenStrokaRandom(Numbers, false);
          bx := Stroka3[1];
          for iter := 1 to 2 do
          begin
             ax := random(2);
             if (ax = 0) then
             begin
                Stroka3_znaki[iter] := '+';
                bx := bx + Stroka3[iter+1];
             end;
             if (ax = 1) then
             begin
                Stroka3_znaki[iter] := '-';
                bx := bx - Stroka3[iter+1];
             end;
          end;
        until (bx > -1) and (bx < cap);
        if(bx > Stroka_result) then
        begin
           Stroka3_znaki[3] := '-';
           Stroka3[4] := bx - Stroka_result;
        end
        else
        begin
           Stroka3_znaki[3] := '+';
           Stroka3[4] := Stroka_result - bx;
        end;
     end // три операции, только + и -
     else // три операции, любые знаки
     // (A {*} B {+-} C {/*-+} D)
     // (AA {/} B {+-} CC {/*} D)
     // (AA {/} B {+-} CC {+-} DD)
     // (AA {+-} BB {/*} C {/*} D)
     // (AA {+-} BB {/*} C {+-} DD)
     begin
        if(Numbers = 0) then  // если числа от 1 до 9
        begin
           repeat
             repeat
               Stroka3[1] := GenStrokaRandom(Numbers, true);
               Stroka3[2] := GenStrokaRandom(Numbers, true);
             until (Stroka3[1] > 1) and (Stroka3[2] > 1);
             bx := Stroka3[1];
             Stroka3_znaki[1] := '*';
             bx := bx * Stroka3[2];
             //-----//
             Stroka3[3] := GenStrokaRandom(Numbers, true);
             ax := random(2);
             if (ax = 0) then
             begin
                Stroka3_znaki[2] := '+';
                bx := bx + Stroka3[3];
             end;
             if (ax = 1) then
             begin
                Stroka3_znaki[2] := '-';
                bx := bx - Stroka3[3];
             end;
           until (bx > -1) and (bx < 2*cap);
           //-----//
           if(bx mod Stroka_result = 0) then
           begin
              Stroka3_znaki[3] := '/';
              Stroka3[4] := bx div Stroka_result;
           end
           else
           if(Stroka_result mod bx = 0) then
           begin
              Stroka3_znaki[3] := '*';
              Stroka3[4] := Stroka_result div bx;
           end
           else
           if(bx > Stroka_result) then
           begin
              Stroka3_znaki[3] := '-';
              Stroka3[4] := bx - Stroka_result;
           end
           else
           begin
              Stroka3_znaki[3] := '+';
              Stroka3[4] := Stroka_result - bx;
           end;
        end
        else  // если большие числа
        begin
           repeat
              Stroka3[1] := GenStrokaRandom(Numbers, true);
           until (Stroka3[1] > 1);
           bx := Stroka3[1];
           for iter := 9 downto 2 do
           begin
             if(bx mod iter = 0) then
             begin
                Stroka3_znaki[1] := '/';
                Stroka3[2] := iter;
                bx := bx div Stroka3[2];
                break;
             end;
             if(iter = 2) then // не делится
             begin
                 cx:= bx;
                 repeat
                   bx:= cx;
                   Stroka3[2] := GenStrokaRandom(Numbers, true);
                   ax := random(2);
                   if (ax = 0) then
                   begin
                      Stroka3_znaki[1] := '+';
                      bx := bx + Stroka3[2];
                   end;
                   if (ax = 1) then
                   begin
                      Stroka3_znaki[1] := '-';
                      bx := bx - Stroka3[2];
                   end;
                 until (bx > -1) and (bx < cap);
                 //-----//
                 for jter := 9 downto 2 do
                 begin
                   if(bx mod jter = 0) then
                   begin
                      Stroka3_znaki[2] := '/';
                      Stroka3[3] := jter;
                      bx := bx div Stroka3[3];
                      break;
                   end;
                   if(jter = 2) then // не делится
                   begin
                      Stroka3_znaki[2] := '*';
                      Stroka3[3] := 2 + random(8);
                      bx := bx * Stroka3[3];
                   end;
                 end;
                 //-----//
                 if(bx mod Stroka_result = 0) then
                 begin
                    Stroka3_znaki[3] := '/';
                    Stroka3[4] := bx div Stroka_result;
                 end
                 else
                 if(Stroka_result mod bx = 0) then
                 begin
                    Stroka3_znaki[3] := '*';
                    Stroka3[4] := Stroka_result div bx;
                 end
                 else
                 if(bx > Stroka_result) then
                 begin
                    Stroka3_znaki[3] := '-';
                    Stroka3[4] := bx - Stroka_result;
                 end
                 else
                 begin
                    Stroka3_znaki[3] := '+';
                    Stroka3[4] := Stroka_result - bx;
                 end;
             end;
             end;
             // если поделилось
             cx:=bx;
             repeat
               bx:=cx;
               Stroka3[3] := GenStrokaRandom(Numbers, true);
               ax := random(2);
               if (ax = 0) then
               begin
                  Stroka3_znaki[2] := '+';
                  bx := bx + Stroka3[3];
               end;
               if (ax = 1) then
               begin
                  Stroka3_znaki[2] := '-';
                  bx := bx - Stroka3[3];
               end;
             until (bx > -1) and (bx < cap);
             //-----//
             if(bx mod Stroka_result = 0) then
             begin
                Stroka3_znaki[3] := '/';
                Stroka3[4] := bx div Stroka_result;
             end
             else
             if(Stroka_result mod bx = 0) then
             begin
                Stroka3_znaki[3] := '*';
                Stroka3[4] := Stroka_result div bx;
             end
             else
             if(bx > Stroka_result) then
             begin
                Stroka3_znaki[3] := '-';
                Stroka3[4] := bx - Stroka_result;
             end
             else
             begin
                Stroka3_znaki[3] := '+';
                Stroka3[4] := Stroka_result - bx;
             end;
        end; // закончили перебор чисел
     end; // три операции, любые знаки
     end; // конец кейса трёх операций
   5:begin
      if(Signs = 0) then
      begin
        Stroka_result := 0;
        for iter := 1 to 5 do
        begin
            Stroka5[iter] := GenStrokaRandom(Numbers, false);
            Stroka5_znaki[iter] := '+';
            Stroka_result := Stroka_result + Stroka5[iter];
        end;
        Stroka5[6] := GenStrokaRandom(Numbers, false);
        Stroka_result := Stroka_result + Stroka5[6];
      end
     else if(Signs = 1) then // пять операций, только + и -
       begin
          repeat
            for iter := 1 to 5 do
              Stroka5[iter] := GenStrokaRandom(Numbers, false);
            bx := Stroka5[1];
            for iter := 1 to 4 do
            begin
               ax := random(2);
               if (ax = 0) then
               begin
                  Stroka5_znaki[iter] := '+';
                  bx := bx + Stroka5[iter+1];
               end;
               if (ax = 1) then
               begin
                  Stroka5_znaki[iter] := '-';
                  bx := bx - Stroka5[iter+1];
               end;
            end;
          until (bx > -1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka5_znaki[5] := '-';
             Stroka5[6] := bx - Stroka_result;
          end
          else
          begin
             Stroka5_znaki[5] := '+';
             Stroka5[6] := Stroka_result - bx;
          end;
       end // пять операций, только + и -
       else // пять операций, любые знаки
       begin
          repeat
            Stroka5[1] := GenStrokaRandom(Numbers, false);
            bx := Stroka5[1];
            for iter := 1 to 4 do
            begin
               cx := bx;
               repeat
                 bx := cx;
                 ax := random(4);
                 if (ax = 0) then
                 begin
                    Stroka5_znaki[iter] := '+';
                    Stroka5[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx + Stroka5[iter+1];
                 end;
                 if (ax = 1) then
                 begin
                    Stroka5_znaki[iter] := '-';
                    Stroka5[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx - Stroka5[iter+1];
                 end;
                 if (ax = 2) then
                 begin
                    Stroka5_znaki[iter] := '*';
                    ax := 2 + random(8);
                    if(bx*ax > 2*cap) then bx := -1;
                    Stroka5[iter+1] := ax;
                    bx := bx * ax;
                 end;
                 if (ax = 3) then
                 begin
                    Stroka5_znaki[iter] := '/';
                    for jter := 9 downto 2 do
                    begin
                       if(bx mod jter = 0) then
                       begin
                          Stroka5[iter+1] := jter;
                          bx := bx div jter;
                          break;
                       end;
                       if(jter = 2) then ax := 0;
                     end;
                     if (ax = 0) then bx := -1;
                 end;
               until (bx > 1) and (bx < 2*cap);
            end;
          until (bx > 1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka5_znaki[5] := '-';
             Stroka5[6] := bx - Stroka_result;
          end
          else
          begin
             Stroka5_znaki[5] := '+';
             Stroka5[6] := Stroka_result - bx;
          end;
       end;
     end;
   7:begin
     if(Signs = 0) then
     begin
        Stroka_result := 0;
        for iter := 1 to 7 do
        begin
            Stroka7[iter] := GenStrokaRandom(Numbers, false);
            Stroka7_znaki[iter] := '+';
            Stroka_result := Stroka_result + Stroka7[iter];
        end;
        Stroka7[8] := GenStrokaRandom(Numbers, false);
        Stroka_result := Stroka_result + Stroka7[8];
     end
     else
     if(Signs = 1) then // семь операций, только + и -
       begin
          repeat
            for iter := 1 to 7 do
              Stroka7[iter] := GenStrokaRandom(Numbers, false);
            bx := Stroka7[1];
            for iter := 1 to 6 do
            begin
               ax := random(2);
               if (ax = 0) then
               begin
                  Stroka7_znaki[iter] := '+';
                  bx := bx + Stroka7[iter+1];
               end;
               if (ax = 1) then
               begin
                  Stroka7_znaki[iter] := '-';
                  bx := bx - Stroka7[iter+1];
               end;
            end;
          until (bx > -1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka7_znaki[7] := '-';
             Stroka7[8] := bx - Stroka_result;
          end
          else
          begin
             Stroka7_znaki[7] := '+';
             Stroka7[8] := Stroka_result - bx;
          end;
       end // семь операций, только + и -
       else // семь операций, любые знаки
       begin
          repeat
            Stroka7[1] := GenStrokaRandom(Numbers, false);
            bx := Stroka7[1];
            for iter := 1 to 6 do
            begin
               cx := bx;
               repeat
                 bx := cx;
                 ax := random(4);
                 if (ax = 0) then
                 begin
                    Stroka7_znaki[iter] := '+';
                    Stroka7[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx + Stroka7[iter+1];
                 end;
                 if (ax = 1) then
                 begin
                    Stroka7_znaki[iter] := '-';
                    Stroka7[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx - Stroka7[iter+1];
                 end;
                 if (ax = 2) then
                 begin
                    Stroka7_znaki[iter] := '*';
                    ax := 2 + random(8);
                    if(bx*ax > 2*cap) then bx := -1;
                    Stroka7[iter+1] := ax;
                    bx := bx * ax;
                 end;
                 if (ax = 3) then
                 begin
                    Stroka7_znaki[iter] := '/';
                    for jter := 9 downto 2 do
                    begin
                       if(bx mod jter = 0) then
                       begin
                          Stroka7[iter+1] := jter;
                          bx := bx div jter;
                          break;
                       end;
                       if(jter = 2) then ax := 0;
                     end;
                     if (ax = 0) then bx := -1;
                 end;
               until (bx > 1) and (bx < 2*cap);
            end;
          until (bx > 1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka7_znaki[7] := '-';
             Stroka7[8] := bx - Stroka_result;
          end
          else
          begin
             Stroka7_znaki[7] := '+';
             Stroka7[8] := Stroka_result - bx;
          end;
       end;
     end;
   9:begin
     if(Signs = 0) then
     begin
        Stroka_result := 0;
        for iter := 1 to 9 do
        begin
            Stroka9[iter] := GenStrokaRandom(Numbers, false);
            Stroka9_znaki[iter] := '+';
            Stroka_result := Stroka_result + Stroka9[iter];
        end;
        Stroka9[10] := GenStrokaRandom(Numbers, false);
        Stroka_result := Stroka_result + Stroka9[10];
     end
     else
     if(Signs = 1) then // девять операций, только + и -
       begin
          repeat
            for iter := 1 to 9 do
              Stroka9[iter] := GenStrokaRandom(Numbers, false);
            bx := Stroka9[1];
            for iter := 1 to 8 do
            begin
               ax := random(2);
               if (ax = 0) then
               begin
                  Stroka9_znaki[iter] := '+';
                  bx := bx + Stroka9[iter+1];
               end;
               if (ax = 1) then
               begin
                  Stroka9_znaki[iter] := '-';
                  bx := bx - Stroka9[iter+1];
               end;
            end;
          until (bx > -1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka9_znaki[9] := '-';
             Stroka9[10] := bx - Stroka_result;
          end
          else
          begin
             Stroka9_znaki[9] := '+';
             Stroka9[10] := Stroka_result - bx;
          end;
       end // девять операций, только + и -
       else // девять операций, любые знаки
       begin
          repeat
            Stroka9[1] := GenStrokaRandom(Numbers, false);
            bx := Stroka9[1];
            for iter := 1 to 8 do
            begin
               cx := bx;
               repeat
                 bx := cx;
                 ax := random(4);
                 if (ax = 0) then
                 begin
                    Stroka9_znaki[iter] := '+';
                    Stroka9[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx + Stroka9[iter+1];
                 end;
                 if (ax = 1) then
                 begin
                    Stroka9_znaki[iter] := '-';
                    Stroka9[iter+1] := GenStrokaRandom(Numbers, false);
                    bx := bx - Stroka9[iter+1];
                 end;
                 if (ax = 2) then
                 begin
                    Stroka9_znaki[iter] := '*';
                    ax := 2 + random(8);
                    if(bx*ax > 2*cap) then bx := -1;
                    Stroka9[iter+1] := ax;
                    bx := bx * ax;
                 end;
                 if (ax = 3) then
                 begin
                    Stroka9_znaki[iter] := '/';
                    for jter := 9 downto 2 do
                    begin
                       if(bx mod jter = 0) then
                       begin
                          Stroka9[iter+1] := jter;
                          bx := bx div jter;
                          break;
                       end;
                       if(jter = 2) then ax := 0;
                     end;
                     if (ax = 0) then bx := -1;
                 end;
               until (bx > 1) and (bx < 2*cap);
            end;
          until (bx > 1) and (bx < cap);
          if(bx > Stroka_result) then
          begin
             Stroka9_znaki[9] := '-';
             Stroka9[10] := bx - Stroka_result;
          end
          else
          begin
             Stroka9_znaki[9] := '+';
             Stroka9[10] := Stroka_result - bx;
          end;
       end;
     end;
   end;
end;

procedure TAbilitiesTraining.Timer1Timer(Sender: TObject);
begin
  sec:=sec+1;
  if sec>=60 then
  begin
    sec:=0;
    min:=min+1;
  end;
 // LabelTime.Caption:=IntToStr(StrToInt(TimeToStr(LabelTime.Caption))+1);
 if (min<=10) and (sec<10) then LabelTime.Caption:='0'+IntToStr(min)+':'+'0'+IntToStr(sec);
 if (min<=10) and (sec>=10) then LabelTime.Caption:='0'+IntToStr(min)+':'+IntToStr(sec);

 if (min=10) then
 begin
 LabelTime.Caption:='10:00';
 LabelTime.Enabled:=false;
 Application.MessageBox('Прошло 10 минут, пожалуйста начните устный счет заново.','Время вышло',MB_OK);
 end;
end;

procedure TAbilitiesTraining.sBitBtn2Click(Sender: TObject);
var
  ComboParam : integer;
  rdiff : real;
begin
  Timer1.Enabled:=false;
  sBitBtn2.Enabled:=false;
  //InitDB; // РАСКОММЕНТИРОВАТЬ ДЛЯ ПЕРЕСОЗДАНИЯ ТАБЛИЦЫ "Result_Calc"


if(AbilitiesTraining.Caption='Устный счет - Операции с числами')then
  begin
    Op1Help.Visible:=false;
    Op2Help.Visible:=false;
    Op3Help.Visible:=false;
    Op4Help.Visible:=false;
    Op5Help.Visible:=false;
    Op6Help.Visible:=false;
    Op7Help.Visible:=false;
    Op8Help.Visible:=false;
    if(StrToInt(Op1Res.text)=ORES[1])then
    begin
      AnswerO:=AnswerO+1;
    end else Op1err.Visible:=true;
    if(StrToInt(Op2Res.text)=ORES[2])then
    begin
      AnswerO:=AnswerO+1;
    end else Op2err.Visible:=true;
    if(StrToInt(Op3Res.text)=ORES[3])then
    begin
      AnswerO:=AnswerO+1;
    end else Op3err.Visible:=true;
    if(StrToInt(Op4Res.text)=ORES[4])then
    begin
      AnswerO:=AnswerO+1;
    end else Op4err.Visible:=true;
    if(StrToInt(Op5Res.text)=ORES[5])then
    begin
      AnswerO:=AnswerO+1;
    end else Op5err.Visible:=true;
    if(StrToInt(Op6Res.text)=ORES[6])then
    begin
      AnswerO:=AnswerO+1;
    end else Op6err.Visible:=true;
    if(StrToInt(Op7Res.text)=ORES[7])then
    begin
      AnswerO:=AnswerO+1;
    end else Op7err.Visible:=true;
    if(StrToInt(Op8Res.text)=ORES[8])then
    begin
      AnswerO:=AnswerO+1;
    end else Op8err.Visible:=true;

    OperaciiCorrect.Caption:=IntToStr(AnswerO)+'/8';
    Timer2.Enabled:=false;
    EffectPanel.Visible:=true;
    EffectTime.Caption:=LabelTime.Caption;
    EffectCorrect.Caption:=IntToStr(AnswerO);
    EffectTotal.Caption:='8';
    EffectCoeff.Caption:=Copy(FloatToStr(EffCoeff(1, AnswerO)), 0, 5);

    ComboParam := 0;
    if(MentalAbilitiesDevelopment.sCheckBox1.Checked) then ComboParam := ComboParam + 100;
    if(MentalAbilitiesDevelopment.sCheckBox2.Checked) then ComboParam := ComboParam + 10;
    if(MentalAbilitiesDevelopment.sCheckBox3.Checked) then ComboParam := ComboParam + 1;
    if(MentalAbilitiesDevelopment.sCheckBox4.Checked) then ComboParam := ComboParam + 1000;

    if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT RC.Start_Data, RC.Effect AS Effect');
    fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
    fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data DESC');
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Parameters.ParamByName('2').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('3').Value:=MentalAbilitiesDevelopment.sRadioGroup5.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('4').Value:=ComboParam;
    fdb.ADOQuery111.Parameters.ParamByName('5').Value:=0;
    fdb.ADOQuery111.Open;

    if (fdb.ADOQuery111.IsEmpty) then
    begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
    end
    else
    begin
      fdb.ADOQuery111.First;
      if (fdb.ADOQuery111.FieldByName('Effect').AsFloat = 0) then
      begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
      end
      else
      begin
        rdiff := EffCoeff(1, AnswerO) / fdb.ADOQuery111.FieldByName('Effect').AsFloat;
        if (rdiff >= 1) then
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=true;
          EffectLower.Visible:=false;
          EffectDiff.Caption:=Copy(FloatToStr(100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
        else
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=false;
          EffectLower.Visible:=true;
          EffectDiff.Caption:=Copy(FloatToStr(-100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
      end;
    end;

    if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
    fdb.ADOQueryTEST.sql.clear;
    fdb.ADOQueryTEST.sql.add('INSERT INTO Results_Calc(User_ID, Start_Data, Finish_Time, Task_Type, Radio_Set, Combo_Set, Slider_Set, Correct, Effect) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9)');
    fdb.ADOQueryTEST.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryTEST.Parameters.ParamByName('2').Value:=Start;
    fdb.ADOQueryTEST.Parameters.ParamByName('3').Value:=SecondsBetween(Now,Start);
    fdb.ADOQueryTEST.Parameters.ParamByName('4').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('5').Value:=MentalAbilitiesDevelopment.sRadioGroup5.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('6').Value:=ComboParam;
    fdb.ADOQueryTEST.Parameters.ParamByName('7').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('8').Value:=AnswerO;
    fdb.ADOQueryTEST.Parameters.ParamByName('9').Value:=EffCoeff(1, AnswerO);
    fdb.ADOQueryTEST.ExecSQL;
  end;

if(AbilitiesTraining.Caption='Устный счет - Строки')then
  begin
      sLabel8.Visible:=true;
      sLabel6.Caption:=IntToStr(Stroka_result);
      sLabel6.Visible:=true;
    if(Stroka_result=StrToInt(sDecimalSpinEdit1.Text))then
      begin
        sLabel8.Caption:='Правильно! Ответ :';
      end
      else
      begin
        sLabel8.Caption:='Неправильно! Ответ :';
      end;
  end;

if(AbilitiesTraining.Caption='Устный счет - Таблица умножения')then
  begin
    EffectTablica2.Caption:='';
    H:=0;
    if(sDecimalSpinEdit4.Value=A[1]*B[1])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[1])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[1]);
    if(sDecimalSpinEdit5.Value=A[2]*B[2])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[2])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[2]);
    if(sDecimalSpinEdit6.Value=A[3]*B[3])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[3])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[3]);
    if(sDecimalSpinEdit7.Value=A[4]*B[4])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[4])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[4]);
    if(sDecimalSpinEdit8.Value=A[5]*B[5])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[5])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[5]);
    if(sDecimalSpinEdit9.Value=A[6]*B[6])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[6])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[6]);
    if(sDecimalSpinEdit10.Value=A[7]*B[7])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[7])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[7]);
    if(sDecimalSpinEdit11.Value=A[8]*B[8])then H:=H+1 else
    if (EffectTablica2.Caption = '') then EffectTablica2.Caption:=IntToStr(A[8])
    else EffectTablica2.Caption:=EffectTablica2.Caption+', '+IntToStr(A[8]);

    sLabel20.Caption:=IntToStr(H)+'/8';
    Timer3.Enabled:=false;
    EffectPanel.Visible:=true;
    EffectTime.Caption:=LabelTime.Caption;
    EffectCorrect.Caption:=IntToStr(H);
    EffectTotal.Caption:='8';
    EffectCoeff.Caption:=Copy(FloatToStr(EffCoeff(3, H)),0,5);

    if (MentalAbilitiesDevelopment.sRadioGroup2.ItemIndex = 0) and (H <> 8) then
    begin
      EffectWrong.Visible:=true;
      EffectTablica1.Visible:=true;
      EffectTablica2.Visible:=true;
      EffectTablica2.Font.Color:=clRed; // не работает :\
    end;

    if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT RC.Start_Data, RC.Effect AS Effect');
    fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
    fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data DESC');
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Parameters.ParamByName('2').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('3').Value:=MentalAbilitiesDevelopment.sRadioGroup2.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('4').Value:=0;
    fdb.ADOQuery111.Parameters.ParamByName('5').Value:=0;
    fdb.ADOQuery111.Open;

    if (fdb.ADOQuery111.IsEmpty) then
    begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
    end
    else
    begin
      fdb.ADOQuery111.First;
      if (fdb.ADOQuery111.FieldByName('Effect').AsFloat = 0) then
      begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
      end
      else
      begin
        rdiff := EffCoeff(3, H) / fdb.ADOQuery111.FieldByName('Effect').AsFloat;
        if (rdiff >= 1) then
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=true;
          EffectLower.Visible:=false;
          EffectDiff.Caption:=Copy(FloatToStr(100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
        else
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=false;
          EffectLower.Visible:=true;
          EffectDiff.Caption:=Copy(FloatToStr(-100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
      end;
    end;

    if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
    fdb.ADOQueryTEST.sql.clear;
    fdb.ADOQueryTEST.sql.add('INSERT INTO Results_Calc(User_ID, Start_Data, Finish_Time, Task_Type, Radio_Set, Combo_Set, Slider_Set, Correct, Effect) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9)');
    fdb.ADOQueryTEST.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryTEST.Parameters.ParamByName('2').Value:=Start;
    fdb.ADOQueryTEST.Parameters.ParamByName('3').Value:=SecondsBetween(Now,Start);
    fdb.ADOQueryTEST.Parameters.ParamByName('4').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('5').Value:=MentalAbilitiesDevelopment.sRadioGroup2.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('6').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('7').Value:=0;
    fdb.ADOQueryTEST.Parameters.ParamByName('8').Value:=H;
    fdb.ADOQueryTEST.Parameters.ParamByName('9').Value:=EffCoeff(3, H);
    fdb.ADOQueryTEST.ExecSQL;
  end;

if(AbilitiesTraining.Caption='Устный счет - Матрицы')then
  begin
  H:=0;
    Case MatrixDim of
        3 :
        begin
           if(Mx3Line1Res.Value=MxResLine1) then H:=H+1;
           if(Mx3Line2Res.Value=MxResLine2) then H:=H+1;
           if(Mx3Line3Res.Value=MxResLine3) then H:=H+1;
           if(Mx3Col1Res.Value=MxResCol1) then H:=H+1;
           if(Mx3Col2Res.Value=MxResCol2) then H:=H+1;
           if(Mx3Col3Res.Value=MxResCol3) then H:=H+1;
           CorrectAmount.Caption:=IntToStr(H)+'/6';
        end;
        4 :
        begin
           if(Mx4Line1Res.Value=MxResLine1) then H:=H+1;
           if(Mx4Line2Res.Value=MxResLine2) then H:=H+1;
           if(Mx4Line3Res.Value=MxResLine3) then H:=H+1;
           if(Mx4Line4Res.Value=MxResLine4) then H:=H+1;
           if(Mx4Col1Res.Value=MxResCol1) then H:=H+1;
           if(Mx4Col2Res.Value=MxResCol2) then H:=H+1;
           if(Mx4Col3Res.Value=MxResCol3) then H:=H+1;
           if(Mx4Col4Res.Value=MxResCol4) then H:=H+1;
           CorrectAmount.Caption:=IntToStr(H)+'/8';
        end;
        5 :
        begin
           if(Mx5Line1Res.Value=MxResLine1) then H:=H+1;
           if(Mx5Line2Res.Value=MxResLine2) then H:=H+1;
           if(Mx5Line3Res.Value=MxResLine3) then H:=H+1;
           if(Mx5Line4Res.Value=MxResLine4) then H:=H+1;
           if(Mx5Line5Res.Value=MxResLine5) then H:=H+1;
           if(Mx5Col1Res.Value=MxResCol1) then H:=H+1;
           if(Mx5Col2Res.Value=MxResCol2) then H:=H+1;
           if(Mx5Col3Res.Value=MxResCol3) then H:=H+1;
           if(Mx5Col4Res.Value=MxResCol4) then H:=H+1;
           if(Mx5Col5Res.Value=MxResCol5) then H:=H+1;
           CorrectAmount.Caption:=IntToStr(H)+'/10';
        end;
    end;
    Timer4.Enabled:=false;
    EffectPanel.Visible:=true;
    EffectTime.Caption:=LabelTime.Caption;
    EffectCorrect.Caption:=IntToStr(H);
    EffectTotal.Caption:=IntToStr(MatrixDim * 2);
    EffectCoeff.Caption:=Copy(FloatToStr(EffCoeff(4, H)),0,5);

    ComboParam := 0;
    if(MentalAbilitiesDevelopment.sCheckBox1.Checked) then ComboParam := ComboParam + 100;
    if(MentalAbilitiesDevelopment.sCheckBox2.Checked) then ComboParam := ComboParam + 10;
    if(MentalAbilitiesDevelopment.sCheckBox3.Checked) then ComboParam := ComboParam + 1;

    if not fdb.ADOQuery111.Active then
          fdb.ADOQuery111.close;
    fdb.ADOQuery111.sql.clear;
    fdb.ADOQuery111.sql.add('SELECT RC.Start_Data, RC.Effect AS Effect');
    fdb.ADOQuery111.sql.add('FROM Groups AS Gr, Results_Calc AS RC, Users AS U');
    fdb.ADOQuery111.sql.add('WHERE U.Group_id=Gr.ID AND RC.User_ID=U.ID AND RC.User_ID=:1 AND RC.Task_Type=:2 AND RC.Radio_Set=:3 AND RC.Combo_Set=:4 AND RC.Slider_Set=:5');
    fdb.ADOQuery111.sql.add('ORDER BY RC.Start_Data DESC');
    fdb.ADOQuery111.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQuery111.Parameters.ParamByName('2').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('3').Value:=MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex;
    fdb.ADOQuery111.Parameters.ParamByName('4').Value:=ComboParam;
    fdb.ADOQuery111.Parameters.ParamByName('5').Value:=MatrixDim;
    fdb.ADOQuery111.Open;

    if (fdb.ADOQuery111.IsEmpty) then
    begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
    end
    else
    begin
      fdb.ADOQuery111.First;
      if (fdb.ADOQuery111.FieldByName('Effect').AsFloat = 0) then
      begin
       EffectDiffSpot.Visible:=false;
       EffectHigher.Visible:=false;
       EffectLower.Visible:=false;
       EffectDiff.Visible:=false;
      end
      else
      begin
        rdiff := EffCoeff(4, H) / fdb.ADOQuery111.FieldByName('Effect').AsFloat;
        if (rdiff >= 1) then
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=true;
          EffectLower.Visible:=false;
          EffectDiff.Caption:=Copy(FloatToStr(100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
        else
        begin
          EffectDiffSpot.Visible:=true;
          EffectHigher.Visible:=false;
          EffectLower.Visible:=true;
          EffectDiff.Caption:=Copy(FloatToStr(-100*(rdiff - 1)), 0, 4);
          EffectDiff.Caption:=EffectDiff.Caption+' %';
          EffectDiff.Visible:=true;
        end
      end;
    end;

    if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
    fdb.ADOQueryTEST.sql.clear;
    fdb.ADOQueryTEST.sql.add('INSERT INTO Results_Calc(User_ID, Start_Data, Finish_Time, Task_Type, Radio_Set, Combo_Set, Slider_Set, Correct, Effect) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9)');
    fdb.ADOQueryTEST.Parameters.ParamByName('1').Value:=fMainMenu.userId;
    fdb.ADOQueryTEST.Parameters.ParamByName('2').Value:=Start;
    fdb.ADOQueryTEST.Parameters.ParamByName('3').Value:=SecondsBetween(Now,Start);
    fdb.ADOQueryTEST.Parameters.ParamByName('4').Value:=MentalAbilitiesDevelopment.ComboClass.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('5').Value:=MentalAbilitiesDevelopment.sRadioGroup1.ItemIndex;
    fdb.ADOQueryTEST.Parameters.ParamByName('6').Value:=ComboParam;
    fdb.ADOQueryTEST.Parameters.ParamByName('7').Value:=MatrixDim;
    fdb.ADOQueryTEST.Parameters.ParamByName('8').Value:=H;
    fdb.ADOQueryTEST.Parameters.ParamByName('9').Value:=EffCoeff(4, H);
    fdb.ADOQueryTEST.ExecSQL;

  end;


end;

// нажатие кнопки при решении строки
procedure TAbilitiesTraining.sBitBtn3Click(Sender: TObject);
var
  sc : integer;
begin
    sc := Stroka_counter;
    if (Stroka_length = sc) then
    begin
      sBitBtn3.Visible:=false;
      sLabel7.Visible:=true;
      sBitBtn2.Enabled:=true;
    end;
    sLabel42.Visible:=false;
    sLabel43.Visible:=false;
    sLabel44.Visible:=false;

    sLabel45.Visible:=true;
    sLabel46.Visible:=true;
    sLabel47.Visible:=true;
    sLabel48.Visible:=true;
        // sLabel 47, 45 - новые числа
        // sLabel 48, 46 - первый и второй знак

    PartLabel2.Caption:=IntToStr((sc + 1) div 2)+' из '+IntToStr((Stroka_length + 1) div 2);

    Case Stroka_length of
      3:
      begin
        sLabel47.Caption:=IntToStr(Stroka3[sc]);
        sLabel48.Caption:=Stroka3_znaki[sc-1];
        sLabel45.Caption:=IntToStr(Stroka3[sc+1]);
        sLabel46.Caption:=Stroka3_znaki[sc];
      end;
      5:
      begin
        sLabel47.Caption:=IntToStr(Stroka5[sc]);
        sLabel48.Caption:=Stroka5_znaki[sc-1];
        sLabel45.Caption:=IntToStr(Stroka5[sc+1]);
        sLabel46.Caption:=Stroka5_znaki[sc];
      end;
      7:
      begin
        sLabel47.Caption:=IntToStr(Stroka7[sc]);
        sLabel48.Caption:=Stroka7_znaki[sc-1];
        sLabel45.Caption:=IntToStr(Stroka7[sc+1]);
        sLabel46.Caption:=Stroka7_znaki[sc];
      end;
      9:
      begin
        sLabel47.Caption:=IntToStr(Stroka9[sc]);
        sLabel48.Caption:=Stroka9_znaki[sc-1];
        sLabel45.Caption:=IntToStr(Stroka9[sc+1]);
        sLabel46.Caption:=Stroka9_znaki[sc];
      end;
    end;

    Stroka_counter := Stroka_counter + 2;
end;


procedure TAbilitiesTraining.Timer2Timer(Sender: TObject);
begin
if(Op1Res.Text<>'')and(Op2Res.Text<>'')and(Op3Res.Text<>'')and(Op4Res.Text<>'')and
(Op5Res.Text<>'')and(Op6Res.Text<>'')and(Op7Res.Text<>'')and(Op8Res.Text<>'')and
(HintPanel.Visible=false)
then sBitBtn2.Enabled:=true
else
sBitBtn2.Enabled:=false;
end;

procedure TAbilitiesTraining.Timer3Timer(Sender: TObject);
begin
  sBitBtn2.Enabled:=(sDecimalSpinEdit4.Text<>'')and(sDecimalSpinEdit5.Text<>'')and
(sDecimalSpinEdit6.Text<>'')and(sDecimalSpinEdit7.Text<>'')and
(sDecimalSpinEdit8.Text<>'')and(sDecimalSpinEdit9.Text<>'')and
(sDecimalSpinEdit10.Text<>'')and(sDecimalSpinEdit11.Text<>'');
end;

procedure TAbilitiesTraining.FillARandom;
var
  I, N, J : Integer;
  Found : Boolean;
begin
   Randomize;
     For I:=1 To 8 Do
     Begin
          N:=Random(8)+2;
          Found:=True;
          While Found Do
          Begin
              Found:=False;
              J:=1;
              While (J<I) And (Not Found) Do
              Begin
                   If A[J]=N Then
                      Found:=True;
                   J:=J+1;
              End;
              If Found Then
                 N:=Random(8)+2;
          End;
          A[I]:=N;
     End;
end;

procedure TAbilitiesTraining.FillAInt (Target : Integer);
var
  i : Integer;
begin
   for i:= 1 to 8 do
   begin
      A[i]:= Target;
   end;
end;

procedure TAbilitiesTraining.FillBRandom;
var
  I, N, J : Integer;
  Found : Boolean;
begin
   Randomize;
     For I:=1 To 8 Do
     Begin
          N:=Random(8)+2;
          Found:=True;
          While Found Do
          Begin
              Found:=False;
              J:=1;
              While (J<I) And (Not Found) Do
              Begin
                   If B[J]=N Then
                      Found:=True;
                   J:=J+1;
              End;
              If Found Then
                 N:=Random(8)+2;
          End;
          B[I]:=N;
     End;
end;

procedure TAbilitiesTraining.VerticalMx3 (Flag : Boolean);
begin
   Mx3Col1_1.Enabled:=Flag;
   Mx3Col1_2.Enabled:=Flag;
   Mx3Col2_1.Enabled:=Flag;
   Mx3Col2_2.Enabled:=Flag;
   Mx3Col3_1.Enabled:=Flag;
   Mx3Col3_2.Enabled:=Flag;

   Mx3Col1Eq.Enabled:=Flag;
   Mx3Col2Eq.Enabled:=Flag;
   Mx3Col3Eq.Enabled:=Flag;

   Mx3Col1Res.Enabled:=Flag;
   Mx3Col2Res.Enabled:=Flag;
   Mx3Col3Res.Enabled:=Flag;
end;

procedure TAbilitiesTraining.VerticalMx4 (Flag : Boolean);
begin
   Mx4Col1_1.Enabled:=Flag;
   Mx4Col1_2.Enabled:=Flag;
   Mx4Col1_3.Enabled:=Flag;
   Mx4Col2_1.Enabled:=Flag;
   Mx4Col2_2.Enabled:=Flag;
   Mx4Col2_3.Enabled:=Flag;
   Mx4Col3_1.Enabled:=Flag;
   Mx4Col3_2.Enabled:=Flag;
   Mx4Col3_3.Enabled:=Flag;
   Mx4Col4_1.Enabled:=Flag;
   Mx4Col4_2.Enabled:=Flag;
   Mx4Col4_3.Enabled:=Flag;

   Mx4Col1Eq.Enabled:=Flag;
   Mx4Col2Eq.Enabled:=Flag;
   Mx4Col3Eq.Enabled:=Flag;
   Mx4Col4Eq.Enabled:=Flag;

   Mx4Col1Res.Enabled:=Flag;
   Mx4Col2Res.Enabled:=Flag;
   Mx4Col3Res.Enabled:=Flag;
   Mx4Col4Res.Enabled:=Flag;
end;

procedure TAbilitiesTraining.VerticalMx5 (Flag : Boolean);
begin
   Mx5Col1_1.Enabled:=Flag;
   Mx5Col1_2.Enabled:=Flag;
   Mx5Col1_3.Enabled:=Flag;
   Mx5Col1_4.Enabled:=Flag;
   Mx5Col2_1.Enabled:=Flag;
   Mx5Col2_2.Enabled:=Flag;
   Mx5Col2_3.Enabled:=Flag;
   Mx5Col2_4.Enabled:=Flag;
   Mx5Col3_1.Enabled:=Flag;
   Mx5Col3_2.Enabled:=Flag;
   Mx5Col3_3.Enabled:=Flag;
   Mx5Col3_4.Enabled:=Flag;
   Mx5Col4_1.Enabled:=Flag;
   Mx5Col4_2.Enabled:=Flag;
   Mx5Col4_3.Enabled:=Flag;
   Mx5Col4_4.Enabled:=Flag;
   Mx5Col5_1.Enabled:=Flag;
   Mx5Col5_2.Enabled:=Flag;
   Mx5Col5_3.Enabled:=Flag;
   Mx5Col5_4.Enabled:=Flag;

   Mx5Col1Eq.Enabled:=Flag;
   Mx5Col2Eq.Enabled:=Flag;
   Mx5Col3Eq.Enabled:=Flag;
   Mx5Col4Eq.Enabled:=Flag;
   Mx5Col5Eq.Enabled:=Flag;

   Mx5Col1Res.Enabled:=Flag;
   Mx5Col2Res.Enabled:=Flag;
   Mx5Col3Res.Enabled:=Flag;
   Mx5Col4Res.Enabled:=Flag;
   Mx5Col5Res.Enabled:=Flag;
end;

procedure TAbilitiesTraining.Timer4Timer(Sender: TObject);
begin
   Case MatrixDim of
        3 :
        begin
           VerticalMx3((Mx3Line1Res.Text<>'')and(Mx3Line2Res.Text<>'')and(Mx3Line3Res.Text<>''));

           sBitBtn2.Enabled:=(Mx3Line1Res.Text<>'')and(Mx3Line2Res.Text<>'')and
                             (Mx3Line3Res.Text<>'')and(Mx3Col1Res.Text<>'')and
                             (Mx3Col2Res.Text<>'')and(Mx3Col3Res.Text<>'');
        end;
        4 :
        begin
           VerticalMx4((Mx4Line1Res.Text<>'')and(Mx4Line2Res.Text<>'')and(Mx4Line3Res.Text<>'')and(Mx4Line4Res.Text<>''));

           sBitBtn2.Enabled:=(Mx4Line1Res.Text<>'')and(Mx4Line2Res.Text<>'')and
                             (Mx4Line3Res.Text<>'')and(Mx4Line4Res.Text<>'')and
                             (Mx4Col1Res.Text<>'')and(Mx4Col2Res.Text<>'')and
                             (Mx4Col3Res.Text<>'')and(Mx4Col4Res.Text<>'');
        end;
        5 :
        begin
           VerticalMx5((Mx5Line1Res.Text<>'')and(Mx5Line2Res.Text<>'')and(Mx5Line3Res.Text<>'')and(Mx5Line4Res.Text<>'')and(Mx5Line5Res.Text<>''));

           sBitBtn2.Enabled:=(Mx5Line1Res.Text<>'')and(Mx5Line2Res.Text<>'')and
                             (Mx5Line3Res.Text<>'')and(Mx5Line4Res.Text<>'')and
                             (Mx5Line5Res.Text<>'')and(Mx5Col1Res.Text<>'')and
                             (Mx5Col2Res.Text<>'')and(Mx5Col3Res.Text<>'')and
                             (Mx5Col4Res.Text<>'')and(Mx5Col5Res.Text<>'');
        end;
   end;
end;

function TAbilitiesTraining.OpCheckRepeat (i : Integer) : Boolean;
var
  j : integer;
begin
  Result:=false;
  if (i <> 1) then
    for j:= 1 to i-1 do
      if (OA[i]=OA[j]) and (Oz[i]=Oz[j]) and (OB[i]=OB[j]) then
        Result:=true;
end;

procedure TAbilitiesTraining.InitHintData; // a bunch of magic constants
var
   i : integer;
begin
   FlagLeftSmall[2]:= 27;
   FlagLeftSmall[3]:= 67;
   FlagLeftSmall[4]:= 107;
   FlagLeftSmall[5]:= 148;
   FlagLeftSmall[6]:= 189;
   FlagLeftSmall[7]:= 229;
   FlagLeftSmall[8]:= 269;
   FlagLeftSmall[9]:= 309;
   FlagLeftSmall[10]:= 350;
   FlagLeftSmall[11]:= 390;
   FlagLeftSmall[12]:= 431;
   FlagLeftSmall[13]:= 471;
   FlagLeftSmall[14]:= 511;
   for i:=6 to 18 do
      FlagLeftBig[i]:=FlagLeftSmall[i-4]+1;
   LineOffset:=27;
   LineDelta:=1;
   LineWidth[1]:= 38;
   LineWidth[2]:= 79;
   LineWidth[3]:= 119;
   LineWidth[4]:= 160;
   LineWidth[5]:= 200;
   LineWidth[6]:= 240;
   LineWidth[7]:= 281;
   LineWidth[8]:= 322;
   LineWidth[9]:= 362;
end;

procedure TAbilitiesTraining.OperaciiEnable (Enable: boolean);
begin
   Op1A.Enabled:=Enable;
   Op1B.Enabled:=Enable;
   Op1z.Enabled:=Enable;
   Op1eq.Enabled:=Enable;
   Op2A.Enabled:=Enable;
   Op2B.Enabled:=Enable;
   Op2z.Enabled:=Enable;
   Op2eq.Enabled:=Enable;
   Op3A.Enabled:=Enable;
   Op3B.Enabled:=Enable;
   Op3z.Enabled:=Enable;
   Op3eq.Enabled:=Enable;
   Op4A.Enabled:=Enable;
   Op4B.Enabled:=Enable;
   Op4z.Enabled:=Enable;
   Op4eq.Enabled:=Enable;
   Op5A.Enabled:=Enable;
   Op5B.Enabled:=Enable;
   Op5z.Enabled:=Enable;
   Op5eq.Enabled:=Enable;
   Op6A.Enabled:=Enable;
   Op6B.Enabled:=Enable;
   Op6z.Enabled:=Enable;
   Op6eq.Enabled:=Enable;
   Op7A.Enabled:=Enable;
   Op7B.Enabled:=Enable;
   Op7z.Enabled:=Enable;
   Op7eq.Enabled:=Enable;
   Op8A.Enabled:=Enable;
   Op8B.Enabled:=Enable;
   Op8z.Enabled:=Enable;
   Op8eq.Enabled:=Enable;

   Op1Res.Enabled:=Enable;
   Op2Res.Enabled:=Enable;
   Op3Res.Enabled:=Enable;
   Op4Res.Enabled:=Enable;
   Op5Res.Enabled:=Enable;
   Op6Res.Enabled:=Enable;
   Op7Res.Enabled:=Enable;
   Op8Res.Enabled:=Enable;
   Op1Help.Enabled:=Enable;
   Op2Help.Enabled:=Enable;
   Op3Help.Enabled:=Enable;
   Op4Help.Enabled:=Enable;
   Op5Help.Enabled:=Enable;
   Op6Help.Enabled:=Enable;
   Op7Help.Enabled:=Enable;
   Op8Help.Enabled:=Enable;
   sBitBtn1.Enabled:=Enable;
   sBitBtn2.Enabled:=false;
end;

procedure TAbilitiesTraining.Op1HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op1A.Caption;
   HintZ.Caption:=Op1z.Caption;
   HintB.Caption:=Op1B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[1] < 15) and (ORES[1] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[1]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[1]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[1]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[1]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[1]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[1]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[1]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[1]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[1]];
   end;
end;

procedure TAbilitiesTraining.Op2HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op2A.Caption;
   HintZ.Caption:=Op2z.Caption;
   HintB.Caption:=Op2B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[2] < 15) and (ORES[2] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[2]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[2]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[2]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[2]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[2]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[2]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[2]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[2]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[2]];
   end;
end;

procedure TAbilitiesTraining.Op3HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op3A.Caption;
   HintZ.Caption:=Op3z.Caption;
   HintB.Caption:=Op3B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[3] < 15) and (ORES[3] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[3]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[3]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[3]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[3]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[3]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[3]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[3]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[3]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[3]];
   end;
end;

procedure TAbilitiesTraining.Op4HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op4A.Caption;
   HintZ.Caption:=Op4z.Caption;
   HintB.Caption:=Op4B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[4] < 15) and (ORES[4] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[4]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[4]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[4]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[4]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[4]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[4]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[4]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[4]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[4]];
   end;
end;

procedure TAbilitiesTraining.Op5HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op5A.Caption;
   HintZ.Caption:=Op5z.Caption;
   HintB.Caption:=Op5B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[5] < 15) and (ORES[5] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[5]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[5]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[5]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[5]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[5]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[5]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[5]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[5]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[5]];
   end;
end;

procedure TAbilitiesTraining.Op6HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op6A.Caption;
   HintZ.Caption:=Op6z.Caption;
   HintB.Caption:=Op6B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[6] < 15) and (ORES[6] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[6]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[6]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[6]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[6]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[6]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[6]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[6]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[6]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[6]];
   end;
end;

procedure TAbilitiesTraining.Op7HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op7A.Caption;
   HintZ.Caption:=Op7z.Caption;
   HintB.Caption:=Op7B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[7] < 15) and (ORES[7] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[7]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[7]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[7]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[7]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[7]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[7]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[7]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[7]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[7]];
   end;
end;

procedure TAbilitiesTraining.Op8HelpClick(Sender: TObject);
var
   Big : boolean;
   valueB1, valueB2 : integer;
begin
   HintPanel.Visible:=true;
   OperaciiEnable(false);
   HintA.Caption:=Op8A.Caption;
   HintZ.Caption:=Op8z.Caption;
   HintB.Caption:=Op8B.Caption;

   HintA1.Caption:=HintA.Caption;
   HintZ1.Caption:=HintZ.Caption;
   if(HintZ.Caption = '+') then
   begin
      valueB1:= 10 - StrToInt(HintA.Caption);
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end
   else
   begin
      valueB1:= StrToInt(HintA.Caption) - 10;
      valueB2:= StrToInt(HintB.Caption) - valueB1;
   end;
   HintB1.Caption:=IntToStr(valueB1);
   HintB2.Caption:=IntToStr(valueB2);

   Big:= not ((OA[8] < 15) and (ORES[8] < 15));
   if Big then
   begin
      ImageRulerBig.Visible:=true;
      ImageRulerSmall.Visible:=false;
      Image10Big.Visible:=true;
      Image10Big.BringToFront;
      Image10Small.Visible:=false;
   end
   else
   begin
      ImageRulerBig.Visible:=false;
      ImageRulerSmall.Visible:=true;
      Image10Big.Visible:=false;
      Image10Small.Visible:=true;
      Image10Small.BringToFront;
   end;
   if (Oz[8]='+') then
   begin
      ImageFlagBlue.Visible:=false;
      ImageFlagRed.Visible:=true;
      ImageFlagRed.SendToBack;
      ImageLineBlue.Visible:=false;
      ImageLineRed.Visible:=true;

      if Big then
        ImageFlagRed.Left := FlagLeftBig[OA[8]]
      else ImageFlagRed.Left := FlagLeftSmall[OA[8]];

      ImageLineRed.Left := ImageFlagRed.Left + LineOffset;
      ImageLineRed.Width := LineWidth[OB[8]];
   end
   else
   begin
      ImageFlagBlue.Visible:=true;
      ImageFlagBlue.SendToBack;
      ImageFlagRed.Visible:=false;
      ImageLineBlue.Visible:=true;
      ImageLineRed.Visible:=false;

      if Big then
        ImageFlagBlue.Left := FlagLeftBig[OA[8]]
      else ImageFlagBlue.Left := FlagLeftSmall[OA[8]];

      if Big then
        ImageLineBlue.Left := FlagLeftBig[ORES[8]] + LineOffset - LineDelta
      else ImageLineBlue.Left := FlagLeftSmall[ORES[8]] + LineOffset - LineDelta;

      ImageLineBlue.Width := LineWidth[OB[8]];
   end;
end;

procedure TAbilitiesTraining.HintHideClick(Sender: TObject);
begin
   HintPanel.Visible:=false;
   OperaciiEnable(true);
end;

function TAbilitiesTraining.EffCoeff (TaskType, Correct: Integer) : Real;
var
  value : real;
begin
  case TaskType of
    1:  // operacii
    begin
      value:=Correct*100/8/(min*60 + sec);
      Result:=value;
    end;
    3:  // tablica
    begin
      value:=Correct*100/8/(min*60 + sec);
      Result:=value;
    end;
    4:  // matrix
    begin
      value:=Correct*100/(MatrixDim*2)/(min*60 + sec);
      Result:=value;
    end;
  end;
end;

procedure TAbilitiesTraining.InitDB;
var
  ss : string;
begin
  if not fdb.ADOQueryTEST.Active then
          fdb.ADOQueryTEST.close;
  fdb.ADOQueryTEST.sql.clear;
  fdb.ADOQueryTEST.sql.add('DROP TABLE Results_Calc');
  fdb.ADOQueryTEST.ExecSQL;

  fdb.ADOQueryTEST.sql.clear;
  fdb.ADOQueryTEST.sql.add('CREATE TABLE Results_Calc (');
  fdb.ADOQueryTEST.sql.add('ID AUTOINCREMENT PRIMARY KEY,');
  fdb.ADOQueryTEST.sql.add('User_ID int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Start_Data datetime NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Finish_Time int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Task_Type int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Radio_Set int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Combo_Set int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Slider_Set int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Correct int NOT NULL,');
  fdb.ADOQueryTEST.sql.add('Effect DOUBLE PRECISION NOT NULL,');
  fdb.ADOQueryTEST.sql.add('FOREIGN KEY (User_ID) REFERENCES Users(id) )');
  fdb.ADOQueryTEST.ExecSQL;

end;

procedure TAbilitiesTraining.Mx5Line1ResKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (key = 13)
    then FindNextControl(Sender as TWinControl, true, true, false).SetFocus;
end;

procedure TAbilitiesTraining.Op1ResExit(Sender: TObject);
begin
   if (StrToInt(Op1Res.text)<>ORES[1]) then
   begin
      Op1A.Font.Color:=clRed;
      Op1B.Font.Color:=clRed;
      Op1z.Font.Color:=clRed;
      Op1eq.Font.Color:=clRed;
      Op1Res.Font.Color:=clRed;
      Op1Res.Repaint;
   end
   else
   begin
      Op1A.Font.Color:=clBlack;
      Op1B.Font.Color:=clBlack;
      Op1z.Font.Color:=clBlack;
      Op1eq.Font.Color:=clBlack;
      Op1Res.Font.Color:=clBlack;
      Op1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op2ResExit(Sender: TObject);
begin
   if (StrToInt(Op2Res.text)<>ORES[2]) then
   begin
      Op2A.Font.Color:=clRed;
      Op2B.Font.Color:=clRed;
      Op2z.Font.Color:=clRed;
      Op2eq.Font.Color:=clRed;
      Op2Res.Font.Color:=clRed;
      Op2Res.Repaint;
   end
   else
   begin
      Op2A.Font.Color:=clBlack;
      Op2B.Font.Color:=clBlack;
      Op2z.Font.Color:=clBlack;
      Op2eq.Font.Color:=clBlack;
      Op2Res.Font.Color:=clBlack;
      Op2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op3ResExit(Sender: TObject);
begin
   if (StrToInt(Op3Res.text)<>ORES[3]) then
   begin
      Op3A.Font.Color:=clRed;
      Op3B.Font.Color:=clRed;
      Op3z.Font.Color:=clRed;
      Op3eq.Font.Color:=clRed;
      Op3Res.Font.Color:=clRed;
      Op3Res.Repaint;
   end
   else
   begin
      Op3A.Font.Color:=clBlack;
      Op3B.Font.Color:=clBlack;
      Op3z.Font.Color:=clBlack;
      Op3eq.Font.Color:=clBlack;
      Op3Res.Font.Color:=clBlack;
      Op3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op4ResExit(Sender: TObject);
begin
   if (StrToInt(Op4Res.text)<>ORES[4]) then
   begin
      Op4A.Font.Color:=clRed;
      Op4B.Font.Color:=clRed;
      Op4z.Font.Color:=clRed;
      Op4eq.Font.Color:=clRed;
      Op4Res.Font.Color:=clRed;
      Op4Res.Repaint;
   end
   else
   begin
      Op4A.Font.Color:=clBlack;
      Op4B.Font.Color:=clBlack;
      Op4z.Font.Color:=clBlack;
      Op4eq.Font.Color:=clBlack;
      Op4Res.Font.Color:=clBlack;
      Op4Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op5ResExit(Sender: TObject);
begin
   if (StrToInt(Op5Res.text)<>ORES[5]) then
   begin
      Op5A.Font.Color:=clRed;
      Op5B.Font.Color:=clRed;
      Op5z.Font.Color:=clRed;
      Op5eq.Font.Color:=clRed;
      Op5Res.Font.Color:=clRed;
      Op5Res.Repaint;
   end
   else
   begin
      Op5A.Font.Color:=clBlack;
      Op5B.Font.Color:=clBlack;
      Op5z.Font.Color:=clBlack;
      Op5eq.Font.Color:=clBlack;
      Op5Res.Font.Color:=clBlack;
      Op5Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op6ResExit(Sender: TObject);
begin
   if (StrToInt(Op6Res.text)<>ORES[6]) then
   begin
      Op6A.Font.Color:=clRed;
      Op6B.Font.Color:=clRed;
      Op6z.Font.Color:=clRed;
      Op6eq.Font.Color:=clRed;
      Op6Res.Font.Color:=clRed;
      Op6Res.Repaint;
   end
   else
   begin
      Op6A.Font.Color:=clBlack;
      Op6B.Font.Color:=clBlack;
      Op6z.Font.Color:=clBlack;
      Op6eq.Font.Color:=clBlack;
      Op6Res.Font.Color:=clBlack;
      Op6Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op7ResExit(Sender: TObject);
begin
   if (StrToInt(Op7Res.text)<>ORES[7]) then
   begin
      Op7A.Font.Color:=clRed;
      Op7B.Font.Color:=clRed;
      Op7z.Font.Color:=clRed;
      Op7eq.Font.Color:=clRed;
      Op7Res.Font.Color:=clRed;
      Op7Res.Repaint;
   end
   else
   begin
      Op7A.Font.Color:=clBlack;
      Op7B.Font.Color:=clBlack;
      Op7z.Font.Color:=clBlack;
      Op7eq.Font.Color:=clBlack;
      Op7Res.Font.Color:=clBlack;
      Op7Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Op8ResExit(Sender: TObject);
begin
   if (StrToInt(Op8Res.text)<>ORES[8]) then
   begin
      Op8A.Font.Color:=clRed;
      Op8B.Font.Color:=clRed;
      Op8z.Font.Color:=clRed;
      Op8eq.Font.Color:=clRed;
      Op8Res.Font.Color:=clRed;
      Op8Res.Repaint;
   end
   else
   begin
      Op8A.Font.Color:=clBlack;
      Op8B.Font.Color:=clBlack;
      Op8z.Font.Color:=clBlack;
      Op8eq.Font.Color:=clBlack;
      Op8Res.Font.Color:=clBlack;
      Op8Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Line1ResExit(Sender: TObject);
begin
   if(Mx3Line1Res.Value<>MxResLine1) then
   begin
      Mx3Line1_1.Font.Color:=clRed;
      Mx3Line1_2.Font.Color:=clRed;
      Mx3Line1Eq.Font.Color:=clRed;
      Mx3Line1Res.Font.Color:=clRed;
      Mx3Line1Res.Repaint;
   end
   else
   begin
      Mx3Line1_1.Font.Color:=clBlack;
      Mx3Line1_2.Font.Color:=clBlack;
      Mx3Line1Eq.Font.Color:=clBlack;
      Mx3Line1Res.Font.Color:=clBlack;
      Mx3Line1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Line2ResExit(Sender: TObject);
begin
   if(Mx3Line2Res.Value<>MxResLine2) then
   begin
      Mx3Line2_1.Font.Color:=clRed;
      Mx3Line2_2.Font.Color:=clRed;
      Mx3Line2Eq.Font.Color:=clRed;
      Mx3Line2Res.Font.Color:=clRed;
      Mx3Line2Res.Repaint;
   end
   else
   begin
      Mx3Line2_1.Font.Color:=clBlack;
      Mx3Line2_2.Font.Color:=clBlack;
      Mx3Line2Eq.Font.Color:=clBlack;
      Mx3Line2Res.Font.Color:=clBlack;
      Mx3Line2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Line3ResExit(Sender: TObject);
begin
   if(Mx3Line3Res.Value<>MxResLine3) then
   begin
      Mx3Line3_1.Font.Color:=clRed;
      Mx3Line3_2.Font.Color:=clRed;
      Mx3Line3Eq.Font.Color:=clRed;
      Mx3Line3Res.Font.Color:=clRed;
      Mx3Line3Res.Repaint;
   end
   else
   begin
      Mx3Line3_1.Font.Color:=clBlack;
      Mx3Line3_2.Font.Color:=clBlack;
      Mx3Line3Eq.Font.Color:=clBlack;
      Mx3Line3Res.Font.Color:=clBlack;
      Mx3Line3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Col1ResExit(Sender: TObject);
begin
   if(Mx3Col1Res.Value<>MxResCol1) then
   begin
      Mx3Col1_1.Font.Color:=clRed;
      Mx3Col1_2.Font.Color:=clRed;
      Mx3Col1Eq.Font.Color:=clRed;
      Mx3Col1Res.Font.Color:=clRed;
      Mx3Col1Res.Repaint;
   end
   else
   begin
      Mx3Col1_1.Font.Color:=clBlack;
      Mx3Col1_2.Font.Color:=clBlack;
      Mx3Col1Eq.Font.Color:=clBlack;
      Mx3Col1Res.Font.Color:=clBlack;
      Mx3Col1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Col2ResExit(Sender: TObject);
begin
   if(Mx3Col2Res.Value<>MxResCol2) then
   begin
      Mx3Col2_1.Font.Color:=clRed;
      Mx3Col2_2.Font.Color:=clRed;
      Mx3Col2Eq.Font.Color:=clRed;
      Mx3Col2Res.Font.Color:=clRed;
      Mx3Col2Res.Repaint;
   end
   else
   begin
      Mx3Col2_1.Font.Color:=clBlack;
      Mx3Col2_2.Font.Color:=clBlack;
      Mx3Col2Eq.Font.Color:=clBlack;
      Mx3Col2Res.Font.Color:=clBlack;
      Mx3Col2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx3Col3ResExit(Sender: TObject);
begin
   if(Mx3Col3Res.Value<>MxResCol3) then
   begin
      Mx3Col3_1.Font.Color:=clRed;
      Mx3Col3_2.Font.Color:=clRed;
      Mx3Col3Eq.Font.Color:=clRed;
      Mx3Col3Res.Font.Color:=clRed;
      Mx3Col3Res.Repaint;
   end
   else
   begin
      Mx3Col3_1.Font.Color:=clBlack;
      Mx3Col3_2.Font.Color:=clBlack;
      Mx3Col3Eq.Font.Color:=clBlack;
      Mx3Col3Res.Font.Color:=clBlack;
      Mx3Col3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Line1ResExit(Sender: TObject);
begin
   if(Mx4Line1Res.Value<>MxResLine1) then
   begin
      Mx4Line1_1.Font.Color:=clRed;
      Mx4Line1_2.Font.Color:=clRed;
      Mx4Line1_3.Font.Color:=clRed;
      Mx4Line1Eq.Font.Color:=clRed;
      Mx4Line1Res.Font.Color:=clRed;
      Mx4Line1Res.Repaint;
   end
   else
   begin
      Mx4Line1_1.Font.Color:=clBlack;
      Mx4Line1_2.Font.Color:=clBlack;
      Mx4Line1_3.Font.Color:=clBlack;
      Mx4Line1Eq.Font.Color:=clBlack;
      Mx4Line1Res.Font.Color:=clBlack;
      Mx4Line1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Line2ResExit(Sender: TObject);
begin
   if(Mx4Line2Res.Value<>MxResLine2) then
   begin
      Mx4Line2_1.Font.Color:=clRed;
      Mx4Line2_2.Font.Color:=clRed;
      Mx4Line2_3.Font.Color:=clRed;
      Mx4Line2Eq.Font.Color:=clRed;
      Mx4Line2Res.Font.Color:=clRed;
      Mx4Line2Res.Repaint;
   end
   else
   begin
      Mx4Line2_1.Font.Color:=clBlack;
      Mx4Line2_2.Font.Color:=clBlack;
      Mx4Line2_3.Font.Color:=clBlack;
      Mx4Line2Eq.Font.Color:=clBlack;
      Mx4Line2Res.Font.Color:=clBlack;
      Mx4Line2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Line3ResExit(Sender: TObject);
begin
   if(Mx4Line3Res.Value<>MxResLine3) then
   begin
      Mx4Line3_1.Font.Color:=clRed;
      Mx4Line3_2.Font.Color:=clRed;
      Mx4Line3_3.Font.Color:=clRed;
      Mx4Line3Eq.Font.Color:=clRed;
      Mx4Line3Res.Font.Color:=clRed;
      Mx4Line3Res.Repaint;
   end
   else
   begin
      Mx4Line3_1.Font.Color:=clBlack;
      Mx4Line3_2.Font.Color:=clBlack;
      Mx4Line3_3.Font.Color:=clBlack;
      Mx4Line3Eq.Font.Color:=clBlack;
      Mx4Line3Res.Font.Color:=clBlack;
      Mx4Line3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Line4ResExit(Sender: TObject);
begin
   if(Mx4Line4Res.Value<>MxResLine4) then
   begin
      Mx4Line4_1.Font.Color:=clRed;
      Mx4Line4_2.Font.Color:=clRed;
      Mx4Line4_3.Font.Color:=clRed;
      Mx4Line4Eq.Font.Color:=clRed;
      Mx4Line4Res.Font.Color:=clRed;
      Mx4Line4Res.Repaint;
   end
   else
   begin
      Mx4Line4_1.Font.Color:=clBlack;
      Mx4Line4_2.Font.Color:=clBlack;
      Mx4Line4_3.Font.Color:=clBlack;
      Mx4Line4Eq.Font.Color:=clBlack;
      Mx4Line4Res.Font.Color:=clBlack;
      Mx4Line4Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Col1ResExit(Sender: TObject);
begin
   if(Mx4Col1Res.Value<>MxResCol1) then
   begin
      Mx4Col1_1.Font.Color:=clRed;
      Mx4Col1_2.Font.Color:=clRed;
      Mx4Col1_3.Font.Color:=clRed;
      Mx4Col1Eq.Font.Color:=clRed;
      Mx4Col1Res.Font.Color:=clRed;
      Mx4Col1Res.Repaint;
   end
   else
   begin
      Mx4Col1_1.Font.Color:=clBlack;
      Mx4Col1_2.Font.Color:=clBlack;
      Mx4Col1_3.Font.Color:=clBlack;
      Mx4Col1Eq.Font.Color:=clBlack;
      Mx4Col1Res.Font.Color:=clBlack;
      Mx4Col1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Col2ResExit(Sender: TObject);
begin
   if(Mx4Col2Res.Value<>MxResCol2) then
   begin
      Mx4Col2_1.Font.Color:=clRed;
      Mx4Col2_2.Font.Color:=clRed;
      Mx4Col2_3.Font.Color:=clRed;
      Mx4Col2Eq.Font.Color:=clRed;
      Mx4Col2Res.Font.Color:=clRed;
      Mx4Col2Res.Repaint;
   end
   else
   begin
      Mx4Col2_1.Font.Color:=clBlack;
      Mx4Col2_2.Font.Color:=clBlack;
      Mx4Col2_3.Font.Color:=clBlack;
      Mx4Col2Eq.Font.Color:=clBlack;
      Mx4Col2Res.Font.Color:=clBlack;
      Mx4Col2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Col3ResExit(Sender: TObject);
begin
   if(Mx4Col3Res.Value<>MxResCol3) then
   begin
      Mx4Col3_1.Font.Color:=clRed;
      Mx4Col3_2.Font.Color:=clRed;
      Mx4Col3_3.Font.Color:=clRed;
      Mx4Col3Eq.Font.Color:=clRed;
      Mx4Col3Res.Font.Color:=clRed;
      Mx4Col3Res.Repaint;
   end
   else
   begin
      Mx4Col3_1.Font.Color:=clBlack;
      Mx4Col3_2.Font.Color:=clBlack;
      Mx4Col3_3.Font.Color:=clBlack;
      Mx4Col3Eq.Font.Color:=clBlack;
      Mx4Col3Res.Font.Color:=clBlack;
      Mx4Col3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx4Col4ResExit(Sender: TObject);
begin
   if(Mx4Col4Res.Value<>MxResCol4) then
   begin
      Mx4Col4_1.Font.Color:=clRed;
      Mx4Col4_2.Font.Color:=clRed;
      Mx4Col4_3.Font.Color:=clRed;
      Mx4Col4Eq.Font.Color:=clRed;
      Mx4Col4Res.Font.Color:=clRed;
      Mx4Col4Res.Repaint;
   end
   else
   begin
      Mx4Col4_1.Font.Color:=clBlack;
      Mx4Col4_2.Font.Color:=clBlack;
      Mx4Col4_3.Font.Color:=clBlack;
      Mx4Col4Eq.Font.Color:=clBlack;
      Mx4Col4Res.Font.Color:=clBlack;
      Mx4Col4Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Line1ResExit(Sender: TObject);
begin
   if(Mx5Line1Res.Value<>MxResLine1) then
   begin
      Mx5Line1_1.Font.Color:=clRed;
      Mx5Line1_2.Font.Color:=clRed;
      Mx5Line1_3.Font.Color:=clRed;
      Mx5Line1_4.Font.Color:=clRed;
      Mx5Line1Eq.Font.Color:=clRed;
      Mx5Line1Res.Font.Color:=clRed;
      Mx5Line1Res.Repaint;
   end
   else
   begin
      Mx5Line1_1.Font.Color:=clBlack;
      Mx5Line1_2.Font.Color:=clBlack;
      Mx5Line1_3.Font.Color:=clBlack;
      Mx5Line1_4.Font.Color:=clBlack;
      Mx5Line1Eq.Font.Color:=clBlack;
      Mx5Line1Res.Font.Color:=clBlack;
      Mx5Line1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Line2ResExit(Sender: TObject);
begin
   if(Mx5Line2Res.Value<>MxResLine2) then
   begin
      Mx5Line2_1.Font.Color:=clRed;
      Mx5Line2_2.Font.Color:=clRed;
      Mx5Line2_3.Font.Color:=clRed;
      Mx5Line2_4.Font.Color:=clRed;
      Mx5Line2Eq.Font.Color:=clRed;
      Mx5Line2Res.Font.Color:=clRed;
      Mx5Line2Res.Repaint;
   end
   else
   begin
      Mx5Line2_1.Font.Color:=clBlack;
      Mx5Line2_2.Font.Color:=clBlack;
      Mx5Line2_3.Font.Color:=clBlack;
      Mx5Line2_4.Font.Color:=clBlack;
      Mx5Line2Eq.Font.Color:=clBlack;
      Mx5Line2Res.Font.Color:=clBlack;
      Mx5Line2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Line3ResExit(Sender: TObject);
begin
   if(Mx5Line3Res.Value<>MxResLine3) then
   begin
      Mx5Line3_1.Font.Color:=clRed;
      Mx5Line3_2.Font.Color:=clRed;
      Mx5Line3_3.Font.Color:=clRed;
      Mx5Line3_4.Font.Color:=clRed;
      Mx5Line3Eq.Font.Color:=clRed;
      Mx5Line3Res.Font.Color:=clRed;
      Mx5Line3Res.Repaint;
   end
   else
   begin
      Mx5Line3_1.Font.Color:=clBlack;
      Mx5Line3_2.Font.Color:=clBlack;
      Mx5Line3_3.Font.Color:=clBlack;
      Mx5Line3_4.Font.Color:=clBlack;
      Mx5Line3Eq.Font.Color:=clBlack;
      Mx5Line3Res.Font.Color:=clBlack;
      Mx5Line3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Line4ResExit(Sender: TObject);
begin
   if(Mx5Line4Res.Value<>MxResLine4) then
   begin
      Mx5Line4_1.Font.Color:=clRed;
      Mx5Line4_2.Font.Color:=clRed;
      Mx5Line4_3.Font.Color:=clRed;
      Mx5Line4_4.Font.Color:=clRed;
      Mx5Line4Eq.Font.Color:=clRed;
      Mx5Line4Res.Font.Color:=clRed;
      Mx5Line4Res.Repaint;
   end
   else
   begin
      Mx5Line4_1.Font.Color:=clBlack;
      Mx5Line4_2.Font.Color:=clBlack;
      Mx5Line4_3.Font.Color:=clBlack;
      Mx5Line4_4.Font.Color:=clBlack;
      Mx5Line4Eq.Font.Color:=clBlack;
      Mx5Line4Res.Font.Color:=clBlack;
      Mx5Line4Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Line5ResExit(Sender: TObject);
begin
   if(Mx5Line5Res.Value<>MxResLine5) then
   begin
      Mx5Line5_1.Font.Color:=clRed;
      Mx5Line5_2.Font.Color:=clRed;
      Mx5Line5_3.Font.Color:=clRed;
      Mx5Line5_4.Font.Color:=clRed;
      Mx5Line5Eq.Font.Color:=clRed;
      Mx5Line5Res.Font.Color:=clRed;
      Mx5Line5Res.Repaint;
   end
   else
   begin
      Mx5Line5_1.Font.Color:=clBlack;
      Mx5Line5_2.Font.Color:=clBlack;
      Mx5Line5_3.Font.Color:=clBlack;
      Mx5Line5_4.Font.Color:=clBlack;
      Mx5Line5Eq.Font.Color:=clBlack;
      Mx5Line5Res.Font.Color:=clBlack;
      Mx5Line5Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Col1ResExit(Sender: TObject);
begin
   if(Mx5Col1Res.Value<>MxResCol1) then
   begin
      Mx5Col1_1.Font.Color:=clRed;
      Mx5Col1_2.Font.Color:=clRed;
      Mx5Col1_3.Font.Color:=clRed;
      Mx5Col1_4.Font.Color:=clRed;
      Mx5Col1Eq.Font.Color:=clRed;
      Mx5Col1Res.Font.Color:=clRed;
      Mx5Col1Res.Repaint;
   end
   else
   begin
      Mx5Col1_1.Font.Color:=clBlack;
      Mx5Col1_2.Font.Color:=clBlack;
      Mx5Col1_3.Font.Color:=clBlack;
      Mx5Col1_4.Font.Color:=clBlack;
      Mx5Col1Eq.Font.Color:=clBlack;
      Mx5Col1Res.Font.Color:=clBlack;
      Mx5Col1Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Col2ResExit(Sender: TObject);
begin
   if(Mx5Col2Res.Value<>MxResCol2) then
   begin
      Mx5Col2_1.Font.Color:=clRed;
      Mx5Col2_2.Font.Color:=clRed;
      Mx5Col2_3.Font.Color:=clRed;
      Mx5Col2_4.Font.Color:=clRed;
      Mx5Col2Eq.Font.Color:=clRed;
      Mx5Col2Res.Font.Color:=clRed;
      Mx5Col2Res.Repaint;
   end
   else
   begin
      Mx5Col2_1.Font.Color:=clBlack;
      Mx5Col2_2.Font.Color:=clBlack;
      Mx5Col2_3.Font.Color:=clBlack;
      Mx5Col2_4.Font.Color:=clBlack;
      Mx5Col2Eq.Font.Color:=clBlack;
      Mx5Col2Res.Font.Color:=clBlack;
      Mx5Col2Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Col3ResExit(Sender: TObject);
begin
   if(Mx5Col3Res.Value<>MxResCol3) then
   begin
      Mx5Col3_1.Font.Color:=clRed;
      Mx5Col3_2.Font.Color:=clRed;
      Mx5Col3_3.Font.Color:=clRed;
      Mx5Col3_4.Font.Color:=clRed;
      Mx5Col3Eq.Font.Color:=clRed;
      Mx5Col3Res.Font.Color:=clRed;
      Mx5Col3Res.Repaint;
   end
   else
   begin
      Mx5Col3_1.Font.Color:=clBlack;
      Mx5Col3_2.Font.Color:=clBlack;
      Mx5Col3_3.Font.Color:=clBlack;
      Mx5Col3_4.Font.Color:=clBlack;
      Mx5Col3Eq.Font.Color:=clBlack;
      Mx5Col3Res.Font.Color:=clBlack;
      Mx5Col3Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Col4ResExit(Sender: TObject);
begin
   if(Mx5Col4Res.Value<>MxResCol4) then
   begin
      Mx5Col4_1.Font.Color:=clRed;
      Mx5Col4_2.Font.Color:=clRed;
      Mx5Col4_3.Font.Color:=clRed;
      Mx5Col4_4.Font.Color:=clRed;
      Mx5Col4Eq.Font.Color:=clRed;
      Mx5Col4Res.Font.Color:=clRed;
      Mx5Col4Res.Repaint;
   end
   else
   begin
      Mx5Col4_1.Font.Color:=clBlack;
      Mx5Col4_2.Font.Color:=clBlack;
      Mx5Col4_3.Font.Color:=clBlack;
      Mx5Col4_4.Font.Color:=clBlack;
      Mx5Col4Eq.Font.Color:=clBlack;
      Mx5Col4Res.Font.Color:=clBlack;
      Mx5Col4Res.Repaint;
   end;
end;

procedure TAbilitiesTraining.Mx5Col5ResExit(Sender: TObject);
begin
   if(Mx5Col5Res.Value<>MxResCol5) then
   begin
      Mx5Col5_1.Font.Color:=clRed;
      Mx5Col5_2.Font.Color:=clRed;
      Mx5Col5_3.Font.Color:=clRed;
      Mx5Col5_4.Font.Color:=clRed;
      Mx5Col5Eq.Font.Color:=clRed;
      Mx5Col5Res.Font.Color:=clRed;
      Mx5Col5Res.Repaint;
   end
   else
   begin
      Mx5Col5_1.Font.Color:=clBlack;
      Mx5Col5_2.Font.Color:=clBlack;
      Mx5Col5_3.Font.Color:=clBlack;
      Mx5Col5_4.Font.Color:=clBlack;
      Mx5Col5Eq.Font.Color:=clBlack;
      Mx5Col5Res.Font.Color:=clBlack;
      Mx5Col5Res.Repaint;
   end;
end;

end.
