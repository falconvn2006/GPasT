unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Unit22, Unit23;

type
  TForm4 = class(TForm)
    VEdit1: TEdit;
    VEdit2: TEdit;
    VEdit3: TEdit;
    VEdit4: TEdit;
    VEdit5: TEdit;
    HEdit1: TEdit;
    HEdit2: TEdit;
    HEdit3: TEdit;
    HEdit4: TEdit;
    HEdit5: TEdit;
    Button1: TButton;
    l11: TLabel;
    l31: TLabel;
    l51: TLabel;
    l71: TLabel;
    l91: TLabel;
    l13: TLabel;
    l33: TLabel;
    l53: TLabel;
    l73: TLabel;
    l93: TLabel;
    l15: TLabel;
    l35: TLabel;
    l55: TLabel;
    l75: TLabel;
    l95: TLabel;
    l17: TLabel;
    l37: TLabel;
    l57: TLabel;
    l77: TLabel;
    l97: TLabel;
    l19: TLabel;
    l39: TLabel;
    l59: TLabel;
    l79: TLabel;
    l99: TLabel;
    HEqu1: TLabel;
    HEqu2: TLabel;
    HEqu3: TLabel;
    HEqu4: TLabel;
    HEqu5: TLabel;
    VEqu1: TLabel;
    VEqu2: TLabel;
    VEqu3: TLabel;
    VEqu4: TLabel;
    VEqu5: TLabel;
    l12: TLabel;
    l22: TLabel;
    l32: TLabel;
    l42: TLabel;
    l52: TLabel;
    l14: TLabel;
    l24: TLabel;
    l34: TLabel;
    l44: TLabel;
    l54: TLabel;
    l16: TLabel;
    l26: TLabel;
    l36: TLabel;
    l46: TLabel;
    l56: TLabel;
    l18: TLabel;
    l28: TLabel;
    l38: TLabel;
    l48: TLabel;
    l58: TLabel;
    l21: TLabel;
    l41: TLabel;
    l61: TLabel;
    l81: TLabel;
    l23: TLabel;
    l43: TLabel;
    l63: TLabel;
    l83: TLabel;
    l25: TLabel;
    l45: TLabel;
    l65: TLabel;
    l85: TLabel;
    l27: TLabel;
    l47: TLabel;
    l67: TLabel;
    l87: TLabel;
    l29: TLabel;
    l49: TLabel;
    l69: TLabel;
    l89: TLabel;
    VCheck1: TLabel;
    VCheck2: TLabel;
    VCheck3: TLabel;
    VCheck4: TLabel;
    VCheck5: TLabel;
    HCheck1: TLabel;
    HCheck2: TLabel;
    HCheck3: TLabel;
    HCheck4: TLabel;
    HCheck5: TLabel;
    Image1: TImage;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure VEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure VEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    HW: Byte;
    { Public declarations }
  end;

var
  Form4: TForm4;
  DGT: Byte;
implementation

uses Unit5, DateUtils, unit13;

//uses DateUtils, unit2, unit3, unit1, unit5, unit6, unit7, unit8, unit9, unit10, unit11, unit12, unit13, unit14, bd;
Var TR: Byte;
    TmStart, TmEnd: TDateTime;

{$R *.dfm}

Function GetVal(Iw, Jw: Byte; StrCol: Boolean): Integer;
Var I, Sm: Integer;
  Sth, Sg: TLabel;
Begin
  If StrCol=True Then
    Sth:=TLabel(Form4.FindComponent('l'+IntToStr((1*2)-1)+IntToStr((Jw*2)-1)))
  Else
    Sth:=TLabel(Form4.FindComponent('l'+IntToStr((Iw*2)-1)+IntToStr((1*2)-1)));
  Sm:=StrToInt(Sth.Caption);
  If Not((Iw=1) And (Jw=1)) Then
    Begin
      If StrCol=True Then {string}
        Begin
          For I:=2 To Iw Do
            Begin
              Sth:=TLabel(Form4.FindComponent('l'+IntToStr((I*2)-1)+IntToStr((Jw*2)-1)));
              Sg:=TLabel(Form4.FindComponent('l'+IntToStr((I-1)*2)+IntToStr((Jw*2)-1)));
              If Sg.Caption='+' Then Sm:=Sm+StrToInt(Sth.Caption)
              Else Sm:=Sm-StrToInt(Sth.Caption);
            End;
        End
      Else {column}
        Begin
          For I:=2 To Jw Do
            Begin
              Sth:=TLabel(Form4.FindComponent('l'+IntToStr((Iw*2)-1)+IntToStr((I*2)-1)));
              Sg:=TLabel(Form4.FindComponent('l'+IntToStr(Iw)+IntToStr((I-1)*2)));
              If Sg.Caption='+' Then Sm:=Sm+StrToInt(Sth.Caption)
              Else Sm:=Sm-StrToInt(Sth.Caption);
            End;
        End;
    End;
  GetVal:=Sm;
End;

Procedure CheckResult(WHR: Integer; HV: Boolean);
Var TL: TLabel;
    TE: TEdit;
Begin
  If HV=False Then
    Begin
      TE:=TEdit(Form4.FindComponent('VEdit'+IntToStr(WHR)));
      TL:=TLabel(Form4.FindComponent('VCheck'+IntToStr(WHR)));
      If StrToInt(TE.Text)=GetVal(Form4.HW, WHR, True) Then
        Begin
          {Form22.ShowModal;    }
            MessageDlg('правильно :)', mtWarning, [mbok], 0)   ;
          TL.Caption:='Верно';
          TR:=TR+1;
          TL.Font.Color:=RGB(0,128,0);
        End
      Else
        Begin
         { Form23.ShowModal;    }
           MessageDlg('не правильно :(', mtWarning, [mbok], 0) ;
          TL.Caption:='Ошибка';
          TL.Font.Color:=RGB(128,0,0);
        End;
    End
  Else
    Begin
      TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(WHR)));
      TL:=TLabel(Form4.FindComponent('HCheck'+IntToStr(WHR)));
      If StrToInt(TE.Text)=GetVal(WHR, Form4.HW, False) Then
        Begin
          TL.Caption:='В'#10'е'#10'р'#10'н'#10'о';
          TR:=TR+1;
          TL.Font.Color:=RGB(0,128,0);
        End
      Else
        Begin
          TL.Caption:='О'#10'ш'#10'и'#10'б'#10'к'#10'а';
          TL.Font.Color:=RGB(128,0,0);
        End;
    End;
End;

Procedure TForm4.Button1Click(Sender: TObject);
Var MS, RS: String;
Begin
  MS:=IntToStr(HW*2);
  RS:=IntToStr(TR);
  If Length(MS)<2 Then MS:='0'+MS;
  If Length(RS)<2 Then RS:='0'+RS;
  Form5.TRight:=RS+MS;
  TmStart:=TmEnd-TmStart;
  MS:=IntToStr(MinuteOf(TmStart));
  RS:=IntToStr(SecondOf(tmStart));
  If Length(MS)<2 Then MS:='0'+MS;
  If Length(RS)<2 Then RS:='0'+RS;
  Form5.TRight:=Form5.TRight+MS+RS;
  unit13.me_quit:=true;
  Close;
End;

procedure TForm4.FormActivate(Sender: TObject);
Var I, J, K: Byte;
     TL, Sg: TLabel;
   L, S, Sm: Integer;
         TE: TEdit;
Begin
  TmStart:=GetTime;
  Button1.Enabled:=False;
  TR:=0;
  Randomize;
  If Form5.FirstTen=True Then DGT:=10
  Else DGT:=100;

(*  HW:=5; {Hw:=Form2.Name;}*)

(**)
  For L:=0 To Form4.ControlCount-1 Do
    Form4.Controls[L].Show;
(**)
  For I:=Hw To 5 Do
    Begin
      TL:=TLabel(Form4.FindComponent('VEqu'+IntToStr(I)));
      If I>Hw Then TL.Hide;
      TL:=TLabel(Form4.FindComponent('HEqu'+IntToStr(I)));
      If I>Hw Then TL.Hide;
      TL:=TLabel(Form4.FindComponent('VCheck'+IntToStr(I)));
      If I>Hw Then TL.Hide;
      TL:=TLabel(Form4.FindComponent('HCheck'+IntToStr(I)));
      If I>Hw Then TL.Hide;
      {}
      TE:=TEdit(Form4.FindComponent('VEdit'+IntToStr(I)));
      If I>Hw Then TE.Hide;
      TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(I)));
      If I>Hw Then TE.Hide;
    End;

{***************************************************}
  For K:=Hw To 5 Do
    Begin
      For I:=1 To 5 Do
        Begin
          TL:=TLabel(Form4.FindComponent('l'+IntToStr(I*2-1)+IntToStr(K*2-1)));
          If K>Hw Then TL.Hide;
          TL:=TLabel(Form4.FindComponent('l'+IntToStr(K*2-1)+IntToStr(I*2-1)));
          If K>Hw Then TL.Hide;
          If I>1 Then
            Begin
              Sg:=TLabel(Form4.FindComponent('l'+IntToStr((I-1)*2)+IntToStr((K*2)-1)));
              If K>Hw Then Sg.Hide;
            End;
          If K>1 Then
            Begin
              Sg:=TLabel(Form4.FindComponent('l'+IntToStr((K-1)*2)+IntToStr((I*2)-1)));
              If K>Hw Then Sg.Hide;
            End;
          Sg:=TLabel(Form4.FindComponent('l'+IntToStr(I)+IntToStr((K-1)*2)));
          If K>Hw Then Sg.Hide;
          If I>1 Then
            Begin
              Sg:=TLabel(Form4.FindComponent('l'+IntToStr(K)+IntToStr((I-1)*2)));
              If K>Hw Then Sg.Hide;
            End;
        End;
    End;
{***************************************************}
 {стираем надписи в Label'ах}
  For I:=1 To 5 Do
    Begin
      TL:=TLabel(Form4.FindComponent('VCheck'+IntToStr(I)));
      TL.Caption:='';
      TL:=TLabel(Form4.FindComponent('HCheck'+IntToStr(I)));
      TL.Caption:='';
    End;
  {Делаем невидимыми знаки в столбцах, символы равно, и Edit'ы:}
  For K:=1 To Hw Do
    Begin
      TL:=TLabel(Form4.FindComponent('HEqu'+IntToStr(K)));
      TL.Hide;
      TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(K)));
      TE.Hide;
      For I:=1 To Hw Do
        Begin
          If K>1 Then
            Begin
              TL:=TLabel(Form4.FindComponent('l'+IntToStr(I)+IntToStr((K-1)*2)));
              TL.Hide;
            End;
        End;
    End;
  {запрещаем вводить больше символов, чем есть в числе-ответе:}
  For I:=1 To Hw Do
    Begin
      TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(I)));
      TE.MaxLength:=Length(IntToStr(DGT-1));
      TE.Text:='';
      TE.Enabled:=True;
      TE:=TEdit(Form4.FindComponent('VEdit'+IntToStr(I)));
      TE.MaxLength:=Length(IntToStr(DGT-1));
      TE.Text:='';
      TE.Enabled:=True;
      If I=1 Then TE.SetFocus;
    End;
  {***************************************************}
  TL:=TLabel(Form4.FindComponent('l'+IntToStr(Hw*2-1)+IntToStr(Hw*2-1)));
  L:=TL.Top;
  S:=TL.Left;
  For I:=1 To Hw Do
    Begin
      TL:=TLabel(Form4.FindComponent('HEqu'+IntToStr(I)));
      TL.Top:=L+30;
      TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(I)));
      TE.Enabled:=False;
      TE.Top:=L+72;
      TL:=TLabel(Form4.FindComponent('HCheck'+IntToStr(I)));
      TL.Top:=L+104;
      {hor - 32; 64; 102}
      TL:=TLabel(Form4.FindComponent('VEqu'+IntToStr(I)));
      TL.Show;
      TL.Left:=S+32;
      TE:=TEdit(Form4.FindComponent('VEdit'+IntToStr(I)));
      If I<>1 Then TE.Enabled:=False;
      TE.Left:=S+64;
      TL:=TLabel(Form4.FindComponent('VCheck'+IntToStr(I)));
      TL.Left:=S+102;
    End;
  Button1.Top:=L+136+115;
  Form4.Height:=Button1.Top+Button1.Height+16+30;
  Form4.Position:=poScreenCenter;

{***************************************************}

  {Sign - 1}
  For J:=1 To Hw Do
    For I:=1 To Hw-1 Do
      Begin
        TL:=TLabel(Form4.FindComponent('l'+IntToStr((I*2))+IntToStr((J*2)-1)));
        TL.Show;
        TL.Caption:='+';
        If Form5.PlusOnly=False Then
          If Random(2)=1 Then TL.Caption:='-';
{        If Random(2)=0 Then TL.Caption:='+'
        Else TL.Caption:='-';}
      End;
  {Sign - 2}
  For J:=1 To Hw-1 Do
    For I:=1 To Hw Do
      Begin
        TL:=TLabel(Form4.FindComponent('l'+IntToStr(I)+IntToStr(J*2)));
        TL.Caption:='+';        
        If Form5.PlusOnly=False Then
          If Random(2)=1 Then TL.Caption:='-';
{        If Random(2)=0 Then TL.Caption:='+'
        Else TL.Caption:='-';}
      End;
  {Values}

  {Начальные значения строки}
  For K:=1 To Hw Do
    Begin
      TL:=TLabel(Form4.FindComponent('l'+IntToStr(K*2-1)+'1'));
      If K>1 Then
        Begin
          Sg:=TLabel(Form4.FindComponent('l'+IntToStr((K-1)*2)+'1'));
          If K>1 Then Sm:=GetVal(K-1,1,True)
          Else Sm:=0;
          If Form5.PlusOnly=False Then {!Plus!}
            If Sm=DGT-1 Then Sg.Caption:='-';
          If Sm=0 Then Sg.Caption:='+';
          Repeat
            S:=Sm;
            If Form5.PlusOnly=False Then {!Plus!}
              L:=Random(DGT-1)+1
            Else
              L:=Random(DGT);
            If Sg.Caption='+' Then S:=S+L
            Else S:=S-L;
          Until (S>=0) And (S<DGT);
          TL.Caption:=IntToStr(L);
        End
      Else
        Begin
          L:=Random(DGT-1)+1;
          TL.Caption:=IntToStr(L);
         End;
    End;

  {Начальные значения столбца}
  For K:=2 To Hw Do
    Begin
      TL:=TLabel(Form4.FindComponent('l1'+IntToStr(K*2-1)));
      Sg:=TLabel(Form4.FindComponent('l'+IntToStr(1)+IntToStr((K-1)*2)));
      Sm:=GetVal(1,K-1,False);
      If Form5.PlusOnly=False Then {!Plus!}
        Begin
          If (Sm=DGT-1) And (K=2) Then Sg.Caption:='-';
          If Sm=DGT-1 Then Sg.Caption:='-';
        End;  
      If Sm=0 Then Sg.Caption:='+';
      Repeat
        S:=Sm;
        If Form5.PlusOnly=False Then {!Plus!}
          L:=Random(DGT-1)+1
        Else
          L:=Random(DGT);  
        If Sg.Caption='+' Then S:=S+L
        Else S:=S-L;
      Until (S>=0) And (S<DGT); {(S>=0)!lower!}
      TL.Caption:=IntToStr(L);
    End;

    
  For K:=2 To Hw Do
    Begin
      For I:=2 To Hw Do
        Begin
          TL:=TLabel(Form4.FindComponent('l'+IntToStr(I*2-1)+IntToStr(K*2-1)));
          {знак строки}
          Sg:=TLabel(Form4.FindComponent('l'+IntToStr((I-1)*2)+IntToStr((K*2)-1)));
          {сумма строки}
          Sm:=GetVal(I-1, K, True);
          If Sg.Caption='+' Then Sm:=DGT-Sm
          Else Sm:=Sm+1;
          {знак столбца}
          Sg:=TLabel(Form4.FindComponent('l'+IntToStr(I)+IntToStr((K-1)*2)));
          {сумма столбца}
          S:=GetVal(I, K-1, False);
          If Sg.Caption='+' Then S:=DGT-S
          Else S:=S+1;
          If S<=Sm Then L:=S
          Else L:=Sm;
          L:=Random(L);
          TL.Caption:=IntToStr(L);
        End;
    End;
End;

Procedure TForm4.VEdit1KeyPress(Sender: TObject; var Key: Char);
Begin
  If ((Key<'0') Or (Key>'9')) And (Key<>#8) Then Key:=#0;
End;

Procedure TForm4.VEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var TE: TEdit;
     S: String;
  K, I: Integer;
    TL: TLabel;
Begin
  If Key=27 Then Close;
  If (TEdit(Sender).Text<>'') And (Key=13) Then
    Begin
      TE:=TEdit(Sender);
      TE.Enabled:=False;
      S:=TE.Name;      
      CheckResult(StrToInt(Copy(S, 6, 1)), False);{}
      S:=Copy(S, 6, 1);
      If StrToInt(S)<Hw Then
        Begin
          If Length(TE.Text)>0 Then
            Begin
              S:=Copy(TE.Name, 1, 5)+IntToStr(StrToInt(S)+1);
              TE:=TEdit(Form4.FindComponent(S));
              TE.Enabled:=True;
              TE.SetFocus;
            End;
        End
      Else
        Begin
          If Length(TE.Text)>0 Then
            Begin
              For I:=Hw DownTo 1 Do
                Begin
                  TE:=TEdit(Form4.FindComponent('VEdit'+IntToStr(I)));
                  TE.Enabled:=False;
                  TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(I)));
                  If I=1 Then TE.Enabled:=True;{}                  
                  TE.Show;
                  If I=1 Then TE.SetFocus;
                End;
              For I:=1 To Hw Do {включаем символы равно}
                Begin
                  TL:=TLabel(Form4.FindComponent('HEqu'+IntToStr(I)));
                  TL.Show;
                  TL:=TLabel(Form4.FindComponent('VEqu'+IntToStr(I)));
                  TL.Hide;
                End;
              For K:=1 To Hw Do
                Begin
                  For I:=1 To Hw Do
                    Begin
                      If I<Hw Then
                        Begin
                          TL:=TLabel(Form4.FindComponent('l'+IntToStr(I*2)+IntToStr((K*2)-1)));
                          TL.Hide;
                        End;
                      If K>1 Then
                        Begin
                          TL:=TLabel(Form4.FindComponent('l'+IntToStr(I)+IntToStr((K-1)*2)));
                          TL.Show;
                        End;
                    End;
                End;
            End;
        End;
    End;
End;

Procedure TForm4.HEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var S: String;
   TE: TEdit;
    I: Integer;
Begin
  If Key=27 Then Close;
  If (TEdit(Sender).Text<>'') And (Key=13) Then
    Begin
      TE:=TEdit(Sender);
      TE.Enabled:=False;
      S:=TE.Name;
      CheckResult(StrToInt(Copy(S, 6, 1)), True);
      S:=Copy(S, 6, 1);
      If StrToInt(S)<Hw Then
        Begin
          If Length(TE.Text)>0 Then
            Begin
              S:=Copy(TE.Name, 1, 5)+IntToStr(StrToInt(S)+1);
              TE:=TEdit(Form4.FindComponent(S));
              TE.Enabled:=True;
              TE.SetFocus;
            End;
        End
      Else
        Begin
          If Length(TE.Text)>0 Then
            Begin
              For I:=Hw DownTo 1 Do
                Begin
                  TE:=TEdit(Form4.FindComponent('HEdit'+IntToStr(I)));
                  TE.Enabled:=False;
                End;
              Button1.Enabled:=True;                
              Button1.SetFocus;
              TmEnd:=GetTime;
            End;
        End;
    End;
End;

procedure TForm4.Button2Click(Sender: TObject);
begin
close;
end;

End.
