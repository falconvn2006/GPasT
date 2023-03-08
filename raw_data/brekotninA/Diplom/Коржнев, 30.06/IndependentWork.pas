unit IndependentWork;

interface

uses
  ShellAPI, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, sRichEdit, sTreeView, sGroupBox, sLabel, Buttons,
  sBitBtn, ImgList, acAlphaImageList, MPlayer, sEdit, Mask, sMaskEdit,
  sCustomComboEdit, sTooledit, sDBDateEdit, ExtCtrls, sSpinEdit, sStatusBar,
  sBevel, sPanel, sMemo, sTrackBar, sDialogs, sRadioButton, sCheckBox, DB, ADODB,
  Math, Jpeg, acPNG, System.ImageList;

type
  TfIndependentWork = class(TForm)
    sTreeView1: TsTreeView;
    sGroupBox1: TsGroupBox;
    bNext: TsBitBtn;
    sAlphaImageList1: TsAlphaImageList;
    sGroupBox2: TsGroupBox;
    sEdit1: TsEdit;
    Timer1: TTimer;
    LabelTime: TsLabel;
    sBevel2: TsBevel;
    sBitBtn1: TsBitBtn;
    sBitBtn16: TsBitBtn;
    sBitBtn14: TsBitBtn;
    Label8: TLabel;
    sBitBtn19: TsBitBtn;
    sBitBtn6: TsBitBtn;
    sBitBtn18: TsBitBtn;
    Label11: TLabel;
    sGroupBox6: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sCheckBox6: TsCheckBox;
    Image1: TImage;
    sRadioButton2: TsRadioButton;
    sRadioButton3: TsRadioButton;
    sRadioButton4: TsRadioButton;
    sRadioButton5: TsRadioButton;
    sRadioButton6: TsRadioButton;
    Image2: TImage;
    Image14: TImage;
    sRadioButton1: TsRadioButton;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Timer2 : TTimer;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sRichEdit1: TsMemo;
    Image15: TImage;
    sBevel1: TsBevel;
    sLabel3: TsLabel;
    procedure MyRadioClick(Sender: TObject);
    procedure MyCheckClick(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure NextClassQuestion;
    procedure NextIndQuestion;
    procedure NextDiagQuestion;
    procedure Timer1Timer(Sender: TObject);
    procedure bTheoryClick(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn6Click(Sender: TObject);
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn12Click(Sender: TObject);
    procedure sBitBtn13Click(Sender: TObject);
    procedure sBitBtn14Click(Sender: TObject);
    procedure sBitBtn18Click(Sender: TObject);
    procedure sBitBtn19Click(Sender: TObject);
    procedure sBitBtn21Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sEdit1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NextRadio;
    procedure NextText;
    procedure NextCheck;
    procedure ShowSolve;
    procedure FormShow(Sender: TObject);
    procedure ImageShow(Number:integer);
    procedure PictureRightImage;
    procedure ShowMult;
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image14MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image8MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image10MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image11MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image12MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image13MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RightAnswerRadio:Integer;
    RightAnswerRadioImage:string;
    RightAnswerString:String;
    RightAnswerStringImage:String;
    RightAnswerCheck:array [1..6] of boolean;
    RightAnswerCheckImage:array [1..6] of String;
    RightAnswerCount:Integer;
    Start: TDateTime;
    Table, strRight, strWrong: String;
    NodeCount:Integer;
    result:TStringList;
    ID_Traj:Integer;
    Slog:String;
    Tip:String;
    Mark:Boolean;
    Text_Wopr:String;
    normal_exit:Boolean;
    Str:string;
    sum:integer;
    QuestionIDs:array of integer;
    CountRecordInd:integer;
    time:integer;
  end;

var
  fIndependentWork: TfIndependentWork;
  i: Integer;
  Answer,str: String;
  num_task: TStringList;
  Theory : String;
  fullFileName : string;
implementation

uses MyDB, Choose, OptionUser, ResultToChild, MainMenu, Entry, SelectLesson,
  QuestionType,QuestionEditor, ShowAudio, ShowVideo, ShowPicture, Edit, ShowAnswerPicture,
  Image, Misc;

{$R *.dfm}

procedure TfIndependentWork.NextRadio;
var
  i: integer;
  flag: boolean;
  ResStream:TResourceStream;
begin
      flag := false;
      for i:=1 to 6 do
        begin
          if TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Checked and (i = RightAnswerRadio) then
            begin
              flag := true;
              break;
            end;
        end;
      if flag then
        begin
          sTreeView1.Selected.ImageIndex:=2;
          if fMainMenu.work='Diag' then
            TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Font.Color:=clBlack
          else
            TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Font.Color:=clGreen;
          if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png')
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image1', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              {Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png');}
              Image1.Visible:=true;
            end;
          ShowMessage('Правильно!');
          sum:=sum+1;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Font.Color:=clBlack;
          Image1.Visible:=false;
          if fMainMenu.work='Diag' then
            begin
            for i:=0 to length(fDB.Results)-1 do
                begin
                  if fdb.Question_IDs[i]=integer(sTreeView1.Selected.Data) then
                    begin
                      fdb.Results[i]:=True;
                      Break;
                    end;
                end;
            end;
          inc(RightAnswerCount);
        end
      else
        begin
          sTreeView1.Selected.ImageIndex:=3;
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(RightAnswerRadio))).Font.Color:=clRed;
          if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png')
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image2', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              //Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png');
              Image1.Visible:=true;
            end;
          ShowMessage('Неправильно!');
          TsRadioButton(FindComponent('sRadioButton' + IntToStr(RightAnswerRadio))).Font.Color:=clBlack;
          Image1.Visible:=false;
        end;
end;

procedure TfIndependentWork.NextText;
var
  i:integer;
  ResStream:TResourceStream;
begin
      if AnsiLowerCase(sEdit1.Text)=AnsiLowerCase(RightAnswerString) then
        begin
          sTreeView1.Selected.ImageIndex:=2;
          if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png')
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image2', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              //Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png');
              Image1.Visible:=true;
            end;
          showmessage('Правильно!');
          if fMainMenu.work='Diag' then
            begin
            for i:=0 to length(fDB.Results)-1 do
                begin
                  if fdb.Question_IDs[i]=integer(sTreeView1.Selected.Data) then
                    begin
                      fdb.Results[i]:=True;
                      Break;
                    end;
                end;
            end;
          Inc(RightAnswerCount);
        end
      else
        begin
          sTreeView1.Selected.ImageIndex:=3;
          if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png')
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image1', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              //Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png');
              Image1.Visible:=true;
            end;
          showmessage('Неправильно!');
        end;
end;

procedure TfIndependentWork.NextCheck;
var
  i:integer;
  count, right: integer;
  ResStream:TResourceStream;
begin
      count:=0;
      for i := 1 to 6 do
        begin
          if (TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).State = cbChecked) and RightAnswerCheck[i] then
            count:=count+1;
        end;
      right:=0;
      for i:=1 to 6 do
        begin
          if RightAnswerCheck[i] then
            right:=right+1;
        end;
      if right=count then
        begin
          sTreeView1.Selected.ImageIndex:=2;
          if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png') 
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image1', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              //Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-1.png');
              Image1.Visible:=true;
            end;
          ShowMessage('Правильно!');
          if fMainMenu.work='Diag' then
            begin
            for i:=0 to length(fDB.Results)-1 do
                begin
                  if fdb.Question_IDs[i]=integer(sTreeView1.Selected.Data) then
                    begin
                      fdb.Results[i]:=True;
                      Break;
                    end;
                end;
            end;
          inc(RightAnswerCount);
        end
      else
        begin
        if fOptionUser.sCheckBox1.Checked then //and FileExists(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png') 
            begin
              ResStream:=TResourceStream.Create(HInstance, 'Image2', RT_RCDATA);
              Image1.Picture.Bitmap.LoadFromStream(ResStream);
              ResStream.Free;
              //Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\img\Smile-2.png');
              Image1.Visible:=true;
            end;
          ShowMessage('Неправильно!');
          sTreeView1.Selected.ImageIndex:=3;
        end;
end;

procedure TfIndependentWork.bNextClick(Sender: TObject);
var
  i:integer;
  ShowAnswers:boolean;
begin
  if sTreeView1.Selected.Index+1=sTreeView1.Items.count then
    else
      sLabel1.Caption:='Текущий вопрос: '+inttostr(sTreeView1.Selected.Index+2)+'/'+inttostr(sTreeView1.Items.count);
  if sTreeView1.Selected <> nil then
    begin
      if fMainMenu.work='Class' then
        begin
          ShowAnswers:=false;
          if fDB.ADOInsertQuestion.Fields[4].AsInteger=1 then
            begin
              NextRadio;
              if RightAnswerRadioImage<>'' then
                ShowAnswers:=true;
            end;
          if fDB.ADOInsertQuestion.Fields[4].AsInteger=2 then
            begin
              NextText;
              if RightAnswerStringImage<>'' then
                ShowAnswers:=true;
            end;
          if fDB.ADOInsertQuestion.Fields[4].AsInteger=3 then
            begin
              NextCheck;
              for i:=1 to 6 do
                begin
                  if RightAnswerCheck[i] and (RightAnswerCheckImage[i]<>'') then
                    begin
                      ShowAnswers:=true;
                      break;
                    end;
                end;
            end;
          if (sTreeView1.Selected.ImageIndex=3) and ShowAnswers then
            begin
              if Application.MessageBox('Хотите посмотреть решение?','Решение',MB_YESNO)=IDYES then
                begin
                  if fDB.ADOInsertQuestion.Fields[4].AsInteger=1 then
                    begin
                      TsRadioButton(FindComponent('sRadioButton' + IntToStr(RightAnswerRadio))).Font.Color:=clRed;
                      for i:=1 to 6 do
                        TsRadioButton(FindComponent('sRadioButton' + IntToStr(i))).Enabled:=false;
                     PictureRightImage;
                     exit;
                    end;
                  if fDB.ADOInsertQuestion.Fields[4].AsInteger=2 then
                    begin
                      sEdit1.Enabled:=false;
                      PictureRightImage;
                      exit;
                    end;
                  if fDB.ADOInsertQuestion.Fields[4].AsInteger=3 then
                    begin
                      for i:=1 to 6 do
                        begin
                          if RightAnswerCheck[i] then
                            TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Font.Color:=clRed;
                          TsCheckBox(FindComponent('sCheckBox' + IntToStr(i))).Enabled:=false;
                        end;
                      PictureRightImage;
                      exit;
                    end;  
                end;
            end;
          fDB.ADOInsertQuestion.Next;
          if sTreeView1.Selected.Index < sTreeView1.Items.Count-1 then
            begin
              sTreeView1.Selected:=sTreeView1.Items[sTreeView1.Selected.Index+1];
              sRichEdit1.Align:=alNone;
              NextClassQuestion;
              bNext.Enabled:=false;
            end
          else
            begin
              hide;
              close;
              fResultToChild :=TfResultToChild.Create(nil);
              try
                Timer2.Enabled:=false;
                fResultToChild.RightAnswerCount:=RightAnswerCount;
                fResultToChild.sBitBtn4.visible:=true;
                fResultToChild.ShowModal;
              finally
                FreeAndNil(fResultToChild);
              end;
            end;
        end;
      if fMainMenu.work='Ind' then
        begin
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 1 then
            NextRadio;
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 2 then
            NextText;
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 3 then
            NextCheck;
          fDB.ADOInsertQuestion.Next;
          if sTreeView1.Selected.Index < sTreeView1.Items.Count-1 then
            begin
              sTreeView1.Selected:=sTreeView1.Items[sTreeView1.Selected.Index+1];
              sRichEdit1.Align:= alNone;
              NextIndQuestion;
              bNext.Enabled:=false;
            end
          else
            begin
              hide;
              close;
              fResultToChild :=TfResultToChild.Create(nil);
              try
                fResultToChild.RightAnswerCount:=RightAnswerCount;
                fResultToChild.ShowModal;
              finally
                FreeAndNil(fResultToChild);
              end;
            end;
        end;
      if fMainMenu.work='Diag' then
        begin
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 1 then
            NextRadio;
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 2 then
            NextText;
          if fDB.ADOInsertQuestion.Fields[3].AsInteger = 3 then
            NextCheck;
          fDB.ADOInsertQuestion.Next;
          if sTreeView1.Selected.Index < sTreeView1.Items.Count-1 then
            begin
              sTreeView1.Selected:=sTreeView1.Items[sTreeView1.Selected.Index+1];
              sRichEdit1.Align:= alNone;
              NextDiagQuestion;
              bNext.Enabled:=false;
            end
          else
            begin
              hide;
              close;
              fResultToChild :=TfResultToChild.Create(nil);
              try
                fResultToChild.RightAnswerCount:=RightAnswerCount;
                fResultToChild.ShowModal;
              finally
                FreeAndNil(fResultToChild);
              end;
            end;
        end;
    end;
end;


procedure TfIndependentWork.MyRadioClick(Sender: TObject);
begin
  bNext.Enabled:=True;
end;

procedure TfIndependentWork.MyCheckClick(Sender: TObject);
begin
  bNext.Enabled:=True;
end;

procedure TfIndependentWork.NextIndQuestion;
var
  i,j,count:integer;
  TittleTemp:string;
begin
  bNext.Enabled:=False;
  sRichEdit1.Lines.Clear;
  sRichEdit1.Lines.add(sTreeView1.Selected.Text);
  if fdb.ADOInsertQuestion.FieldByName('AnswerType').AsInteger=1 then
    begin
      sGroupBox2.Visible:=False;
      sGroupBox6.Visible:=False;
      sGroupBox1.Visible:=True;
      sGroupBox1.Enabled:=True;
      RightAnswerRadio:=-1;
      RightAnswerRadioImage:='';
      for i:=1 to 6 do
        begin
          (FindComponent('sRadioButton' + IntToStr(i)) As TsRadioButton).Checked := false;
          (FindComponent('Image' + IntToStr(i+1)) As TImage).Picture:=Nil;
        end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
      fdb.ADOQueryAnswers.sql.Clear;
      fdb.ADOQueryAnswers.sql.add('SELECT TOP 6 Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
      fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
      fdb.ADOQueryAnswers.Open;
      fdb.ADOQueryAnswers.First;
      j:=0;
      for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
        begin
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=True;
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=True;
          TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
          if Length(TittleTemp)>10 then
            begin
             TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
             TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Hint:=TittleTemp;
            end
          else
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
          j:=j+1;
          if j > 6 then
            break;
          if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
            begin
              if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                RightAnswerRadioImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
              RightAnswerRadio:= i+1;
            end;
          fdb.ADOQueryAnswers.Next;
        end;
      if RightAnswerRadio=-1 then
        begin
          ShowMessage('База повреждена, вопрос: '+IntToStr(Integer(sTreeView1.Selected.data)));
          close;
          exit;
        end;
      for i:=j to 5 do
        begin
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=false;
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=false;
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:='';

          TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=false;
          TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=false;    
        end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
    end;
    if fdb.ADOInsertQuestion.Fields[3].AsInteger=2 then
      begin
        sGroupBox2.Visible:=True;
        sGroupBox2.Enabled:=True;
        sGroupBox6.Visible:=False;
        sGroupBox1.Visible:=False;
        sEdit1.Clear;
        RightAnswerString:='';
        RightAnswerStringImage:='';
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT TOP 1 Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1 AND Righted');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
          end
        else
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=False;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=False;
          end;
        if fdb.ADOQueryAnswers.RecordCount<>0 then
          begin
            ShowMessage('База повреждена, вопрос: '+IntToStr(Integer(sTreeView1.Selected.data)));
            close;
            exit;
          end;
          RightAnswerString:=fDB.ADOQueryAnswers.Fields[0].AsString;
          if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
            RightAnswerStringImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
      end;
    if fdb.ADOInsertQuestion.Fields[3].AsInteger=3 then
      begin
        sGroupBox2.Visible:=False;
        sGroupBox1.Visible:=false;
        sGroupBox6.Visible:=True;
        sGroupBox6.Enabled:=True;
        for i:=1 to 6 do
          begin
            RightAnswerCheck[i] := false;
            RightAnswerCheckImage[i]:='';
            (FindComponent('sCheckBox' + IntToStr(i)) As TsCheckBox).Checked := false;
            (FindComponent('Image' + IntToStr(i+7)) As TImage).Picture:=Nil;
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT TOP 6 Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        j:=0;
        for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=True;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=True;
            TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
            if Length(TittleTemp)>10 then
              begin
                TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
                TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Hint:=TittleTemp;
              end
            else
              TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
            j:=j+1;
            if j > 6 then
              break;
            if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
              begin
                RightAnswerCheck[j] := true;
                if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                  RightAnswerCheckImage[j]:=fDB.ADOQueryAnswers.Fields[2].AsString;
              end;    
            fdb.ADOQueryAnswers.Next;
          end;
        for i:=j to 5 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:='';

            TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=false;
          end;
        count:=0;
        for j:=0 to 5 do
          begin
            if RightAnswerCheck[j] then
              count:=count+1;
          end;
        if count=0 then
          begin
            ShowMessage('База повреждена, вопрос: '+IntToStr(Integer(sTreeView1.Selected.data)));
            close;
            exit;
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        end;
      ShowMult;
      Showsolve;
end;

procedure TfIndependentWork.ShowMult;
begin
  if not fdb.ADOInsertQuestion.FieldByName('ConditionAudio_ID').IsNull then
    begin
      sBitBtn1.Enabled:=true;
      sBitBtn1.Visible:=true;
    end
  else
    begin
      sBitBtn1.Enabled:=false;
      sBitBtn1.Visible:=False;
    end;
  if not fdb.ADOInsertQuestion.FieldByName('ConditionVideo_ID').IsNull then
    begin
      sBitBtn14.Enabled:=true;
      sBitBtn14.Visible:=true;
    end
  else
    begin
      sBitBtn14.Enabled:=false;
      sBitBtn14.Visible:=False;
    end;
  if not fdb.ADOInsertQuestion.FieldByName('ConditionPhoto_Id').IsNull then
    begin
      sBitBtn6.Enabled:=true;
      sBitBtn6.Visible:=true;
    end
  else
    begin
      sBitBtn6.Enabled:=false;
      sBitBtn6.Visible:=false;
    end;
  if not fdb.ADOInsertQuestion.FieldByName('Theory_ID').IsNull then
    begin
      sBitBtn19.Enabled:=true;
      sBitBtn19.Visible:=true;
    end
  else
    begin
      sBitBtn19.Enabled:=false;
      sBitBtn19.Visible:=False;
    end;
end;

procedure TfIndependentWork.NextClassQuestion;
var
  i,j:integer;
  TittleTemp:string;
begin
  bNext.Enabled:=False;
  sRichEdit1.Lines.Clear;
  sRichEdit1.Lines.add(sTreeView1.Selected.Text);
  if fdb.ADOInsertQuestion.Fields[4].AsInteger=1 then
    begin
      sGroupBox2.Visible:=False;
      sGroupBox6.Visible:=False;
      sGroupBox1.Visible:=True;
      sGroupBox1.Enabled:=True;
      RightAnswerRadio:=-1;
      RightAnswerRadioImage:='';
      for i:=1 to 6 do
        begin
          (FindComponent('sRadioButton' + IntToStr(i)) As TsRadioButton).Checked := false;
          (FindComponent('Image' + IntToStr(i+1)) As TImage).Picture:=Nil;
        end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
      fdb.ADOQueryAnswers.sql.Clear;
      fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
      fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
      fdb.ADOQueryAnswers.Open;
      fdb.ADOQueryAnswers.First;
      j:=0;
      for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
        begin
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=True;
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=True;
          TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
          if Length(TittleTemp)>10 then
            begin
              TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
              TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Hint:=TittleTemp;
            end
          else
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
          j:=j+1;
          if j > 6 then
            break;
          if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
            begin
              if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                RightAnswerRadioImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
              RightAnswerRadio := i+1;
            end;
          fdb.ADOQueryAnswers.Next;
        end;
        for i:=j to 5 do
          begin
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=false;
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=false;
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:='';

            TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=false;   
          end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
    end;
    if fdb.ADOInsertQuestion.Fields[4].AsInteger=2 then
      begin
        sGroupBox2.Visible:=True;
        sGroupBox2.Enabled:=True;
        sGroupBox6.Visible:=False;
        sGroupBox1.Visible:=False;
        sEdit1.Clear;
        RightAnswerString:='';
        RightAnswerStringImage:='';
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE (Question_id=:1) AND Righted');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
          end
        else
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=False;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=False;
          end;
        RightAnswerString:=fDB.ADOQueryAnswers.Fields[0].AsString;
        if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
          RightAnswerStringImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
      end;
    if fdb.ADOInsertQuestion.Fields[4].AsInteger=3 then
      begin
        sGroupBox2.Visible:=False;
        sGroupBox1.Visible:=false;
        sGroupBox6.Visible:=True;
        sGroupBox6.Enabled:=True;
        for i:=1 to 6 do
          begin
            RightAnswerCheck[i] := false;
            RightAnswerCheckImage[i]:='';
            (FindComponent('sCheckBox' + IntToStr(i)) As TsCheckBox).Checked:=false;
            (FindComponent('Image' + IntToStr(i+7)) As TImage).Picture:=Nil;
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        j:=0;
        for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=True;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=True;
            TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
            if Length(TittleTemp)>10 then
              begin
                 TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
                 TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Hint:=TittleTemp;
              end
            else
              TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
            j:=j+1;
            if j > 6 then
              break;
            if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
              begin
                RightAnswerCheck[j] := true;
                if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                  RightAnswerCheckImage[j]:=fDB.ADOQueryAnswers.Fields[2].AsString;
              end;
            fdb.ADOQueryAnswers.Next;
          end;
        for i:=j to 5 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:='';

            TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=false;     
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        end;
    ShowMult;
    Showsolve;
end;

procedure TfIndependentWork.NextDiagQuestion;
var
  i,j:integer;
  TittleTemp:string;
begin
  bNext.Enabled:=False;
  sRichEdit1.Lines.Clear;
  sRichEdit1.Lines.add(sTreeView1.Selected.Text);
  if fdb.ADOInsertQuestion.Fields[3].AsInteger=1 then
    begin
      sGroupBox2.Visible:=False;
      sGroupBox6.Visible:=False;
      sGroupBox1.Visible:=True;
      sGroupBox1.Enabled:=True;
      RightAnswerRadio:=-1;
      RightAnswerRadioImage:='';
      for i:=1 to 6 do
        begin
          (FindComponent('sRadioButton' + IntToStr(i)) As TsRadioButton).Checked := false;
          (FindComponent('Image' + IntToStr(i+1)) As TImage).Picture:=Nil;
        end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
      fdb.ADOQueryAnswers.sql.Clear;
      fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
      fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
      fdb.ADOQueryAnswers.Open;
      fdb.ADOQueryAnswers.First;
      j:=0;
      for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
        begin
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=True;
          TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=True;
          TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
          if Length(TittleTemp)>10 then
            begin
              TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
              TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Hint:=TittleTemp;
            end
          else
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+2))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
          j:=j+1;
          if j > 6 then
            break;
          if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
            begin
              if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                RightAnswerRadioImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
              RightAnswerRadio := i+1;
            end;
          fdb.ADOQueryAnswers.Next;
        end;
        for i:=j to 5 do
          begin
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Visible:=false;
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Enabled:=false;
            TsGroupBox(FindComponent('sRadioButton' + IntToStr(i+1))).Caption:='';

            TImage(FindComponent('Image' + IntToStr(i+2))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(i+2))).Visible:=false;
          end;
      if fdb.ADOQueryAnswers.Active then
        fdb.adoqueryAnswers.close;
    end;
    if fdb.ADOInsertQuestion.Fields[3].AsInteger=2 then
      begin
        sGroupBox2.Visible:=True;
        sGroupBox2.Enabled:=True;
        sGroupBox6.Visible:=False;
        sGroupBox1.Visible:=False;
        sEdit1.Clear;
        RightAnswerString:='';
        RightAnswerStringImage:='';
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE (Question_id=:1) AND Righted');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=True;
            TImage(FindComponent('Image' + IntToStr(14))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
          end
        else
          begin
            TImage(FindComponent('Image' + IntToStr(14))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(14))).Visible:=false;
          end;                                        
        RightAnswerString:=fDB.ADOQueryAnswers.Fields[0].AsString;
        if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
          RightAnswerStringImage:=fDB.ADOQueryAnswers.Fields[2].AsString;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
      end;
    if fdb.ADOInsertQuestion.Fields[3].AsInteger=3 then
      begin
        sGroupBox2.Visible:=False;
        sGroupBox1.Visible:=false;
        sGroupBox6.Visible:=True;
        sGroupBox6.Enabled:=True;
        for i:=1 to 6 do
          begin
            RightAnswerCheck[i] := false;
            RightAnswerCheckImage[i]:='';
            (FindComponent('sCheckBox' + IntToStr(i)) As TsCheckBox).Checked := false;
            (FindComponent('Image' + IntToStr(i+7)) As TImage).Picture:=Nil;
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Nazvanie, Righted, Picture FROM Answers WHERE Question_id=:1');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
        j:=0;
        for i:=0 To fDB.ADOQueryAnswers.RecordCount-1 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=True;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=True;
            TittleTemp:=fDB.ADOQueryAnswers.Fields[0].AsString;
            if Length(TittleTemp)>10 then
              begin
                TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=copy(TittleTemp,1,10)+'...';
                TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Hint:=TittleTemp;
              end
            else
              TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:=TittleTemp;
          if fdb.ADOQueryAnswers.FieldByName('Picture').AsString<>'' then
            begin
              TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=True;
              TImage(FindComponent('Image' + IntToStr(i+8))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fDB.ADOQueryAnswers.Fields[2].AsString);
            end;
            j:=j+1;
            if j > 6 then
              break;
            if fDB.ADOQueryAnswers.Fields[1].AsBoolean then
              begin
                RightAnswerCheck[j] := true;
                if fDB.ADOQueryAnswers.Fields[2].AsString<>'' then
                  RightAnswerCheckImage[j]:=fDB.ADOQueryAnswers.Fields[2].AsString;
              end;
            fdb.ADOQueryAnswers.Next;
          end;
        for i:=j to 5 do
          begin
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Visible:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Enabled:=false;
            TsGroupBox(FindComponent('sCheckBox' + IntToStr(i+1))).Caption:='';

            TImage(FindComponent('Image' + IntToStr(i+8))).Enabled:=false;
            TImage(FindComponent('Image' + IntToStr(i+8))).Visible:=false;
          end;
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        end;
    ShowMult;
    Showsolve;
    fdb.CurrentQuestion:=fdb.CurrentQuestion+1;
end;



procedure TfIndependentWork.bTheoryClick(Sender: TObject);
begin
  if Theory<>'' then
    ShowMessage(Theory)
  else ShowMessage('К этому уроку нет теории');
end;



procedure TfIndependentWork.Timer1Timer(Sender: TObject);
var
  Temp:String;
begin
  if fMainMenu.work='Class' then
    begin
      if fSelectLesson.Continue='yes' then
        begin
          fdb.ADOQueryContinue.Close;
          fdb.ADOQueryContinue.SQL.Clear;
          fdb.ADOQueryContinue.SQL.Add('SELECT CW.Timer AS Timer, CW.Question_Selected AS Question_Selected FROM Continue_Class AS CW, Traject AS T, Lessons AS L, Users AS U, Questions AS Q');
          fdb.ADOQueryContinue.SQL.Add('WHERE CW.Id_Traject=T.ID AND CW.Id_Lessons=L.ID AND CW.User_ID=U.ID AND CW.ID_Question=Q.ID ORDER BY CW.ID desc');
          fdb.ADOQueryContinue.Open;
          if not fdb.ADOQueryContinue.FieldByName('Timer').IsNull then
            LabelTime.Caption:=TimeToStr(Start-Now-(fdb.ADOQueryContinue.FieldByName('Timer').AsVariant))
          else
            LabelTime.Caption:=TimeToStr(Start-Now);
        end
    else
      if fSelectLesson.Continue='no' then
        begin
          Temp:=TimeToStr(Now-Start);
          if Temp='0:00:00'  then
            Temp:='0:00:01';
          LabelTime.caption:=Temp;
        end;
    end;
    Temp:=TimeToStr(Now-Start);
  if (fmainmenu.work='Ind') or (fmainmenu.work='Diag') then
    begin
      if Temp='0:00:00'  then
        Temp:='0:00:01';
      LabelTime.caption:=Temp;
    end;
end;

procedure TfIndependentWork.Timer2Timer(Sender: TObject);
var
  Temp:String;
begin
  if fMainMenu.work='Class' then
    begin
      if fSelectLesson.Continue='yes' then
        begin
          //
        end
    else
      if fSelectLesson.Continue='no' then
        begin
          Time:=Time-1;
          sLabel2.Caption:=IntToStr(Time div 60)+':'+IntToStr(Time mod 60);
          if Time<=0 then
            begin
              Timer2.Enabled:=false;
              hide;
              close;
              fResultToChild :=TfResultToChild.Create(nil);
              try
                ShowMessage('Время истекло!');
                fResultToChild.RightAnswerCount:=RightAnswerCount;
                fResultToChild.sBitBtn4.visible:=true;
                fResultToChild.ShowModal;
              finally
                FreeAndNil(fResultToChild);
              end;
            end;
        end;
    end;
  if (fmainmenu.work='Ind') or (fmainmenu.work='Diag') then
    begin
       Time:=Time-1;
          sLabel2.Caption:=IntToStr(Time);
          if Time=0 then
            begin
              Timer2.Enabled:=false;
              hide;
              close;
              fResultToChild :=TfResultToChild.Create(nil);
              try
                ShowMessage('Время истекло!');
                fResultToChild.RightAnswerCount:=RightAnswerCount;
                fResultToChild.sBitBtn4.visible:=true;
                fResultToChild.ShowModal;
              finally
                FreeAndNil(fResultToChild);
              end;
            end; 
    end;
end;

procedure TfIndependentWork.sBitBtn1Click(Sender: TObject);
Var
  s:String;
  Audio_ID: integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Audio_ID:=fdb.ADOInsertQuestion.FieldByName('ConditionAudio_ID').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=1');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Audio_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowAudioForm := TShowAudioForm.Create(nil);
    try
      ShowAudioForm.Mode:=1;
      ShowAudioForm.FileName:=s;
      try
        ShowAudioForm.MediaPlayer1.FileName:=ShowAudioForm.FileName;
        ShowAudioForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowAudioForm.ShowModal;
        if ShowAudioForm.MediaPlayer1.Mode=mpPlaying then
          ShowAudioForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowAudioForm);
      end;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TfIndependentWork.sBitBtn6Click(Sender: TObject);
Var
  s:String;
  Photo_ID: integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Photo_ID:=fdb.ADOInsertQuestion.FieldByName('ConditionPhoto_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=3');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Photo_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowPictureForm:=TShowPictureForm.Create(nil);
    try
      ShowPictureForm.Mode:=1;
      ShowPictureForm.FileName:=s;
      try
        ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowPictureForm.ShowModal;
      finally
        FreeAndNil(ShowPictureForm);
      end;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TfIndependentWork.sBitBtn5Click(Sender: TObject);
Var
  s:String;
  Video_ID:integer;
begin
  try
    Video_ID := fdb.ADOInsertQuestion.FieldByName('SolveVideo_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=2');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Video_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowVideoForm := TShowVideoForm.Create(nil);
    try
      ShowVideoForm.Mode:=1;
      ShowVideoForm.FileName:=s;
      try
        ShowVideoForm.MediaPlayer1.FileName:=ShowVideoForm.FileName;
        ShowVideoForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowVideoForm.ShowModal;;
        if ShowVideoForm.MediaPlayer1.Mode=mpPlaying then
          ShowVideoForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowVideoForm);
      end;
    except
      on E:Exception do
        ShowMessage(E.Message);
    end;
end;


procedure TfIndependentWork.sEdit1Change(Sender: TObject);
begin  
   if (sEdit1.Text='') or (sEdit1.Text=' ')  then
      bNext.Enabled:=false
   else
      bNext.Enabled:=True;
end;

procedure TfIndependentWork.sBitBtn12Click(Sender: TObject);
Var
  s:String;
  Photo_ID: integer;
begin
  try
    Photo_ID := fdb.ADOInsertQuestion.FieldByName('SolvePhoto_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=3');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Photo_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowPictureForm := TShowPictureForm.Create(nil);
    try
      ShowPictureForm.Mode:=1;
      ShowPictureForm.FileName:=s;
      try
        ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowPictureForm.ShowModal;
      finally
        FreeAndNil(ShowAudioForm);
      end;
    except
      on E:Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfIndependentWork.sBitBtn13Click(Sender: TObject);
Var
  s:String;
  Audio_ID: integer;
begin
  try
    Audio_ID := fdb.ADOInsertQuestion.FieldByName('SolveAudio_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=1');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Audio_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowAudioForm := TShowAudioForm.Create(nil);
    try
      ShowAudioForm.Mode:=1;
      ShowAudioForm.FileName:=s;
      try
        ShowAudioForm.MediaPlayer1.FileName:=ShowAudioForm.FileName;
        ShowAudioForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowAudioForm.ShowModal;;
        if ShowAudioForm.MediaPlayer1.Mode=mpPlaying then
          ShowAudioForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowAudioForm);
      end;
    except
      on E:Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfIndependentWork.sBitBtn14Click(Sender: TObject);
Var
  s:String;
  Video_ID: integer;
begin
try
  Screen.Cursor:=crAppStart;
  Video_ID:=fdb.ADOInsertQuestion.FieldByName('ConditionVideo_ID').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=2');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Video_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowVideoForm := TShowVideoForm.Create(nil);
    try
      ShowVideoForm.Mode:=1;
      ShowVideoForm.FileName:=s;
      try
        ShowVideoForm.MediaPlayer1.FileName:=ShowVideoForm.FileName;
        ShowVideoForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        ShowVideoForm.ShowModal;
        if ShowVideoForm.MediaPlayer1.Mode=mpPlaying then
          ShowVideoForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowVideoForm);
      end;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TfIndependentWork.sBitBtn18Click(Sender: TObject);
begin
  Hide;
  try
    EditForm:= TEditForm.Create(nil);
    EditForm.WindowState:=wsMaximized;
    EditForm.ShowModal;
  finally
    FreeAndNil(EditForm);
  end;
  Show;
end;

procedure TfIndependentWork.sBitBtn19Click(Sender: TObject);
var
  s:String;
  Theory_ID:integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Theory_ID:=fdb.ADOInsertQuestion.FieldByName('Theory_ID').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=4');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Theory_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    if s<>'' then
      ShellExecute(fIndependentWork.Handle, 'open', PWideChar(s), nil, nil, SW_RESTORE)
    else
      ShowMessage('Файл с теорией не найден!');
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;


procedure TfIndependentWork.sBitBtn21Click(Sender: TObject);
begin
  sRichEdit1.Align:=alNone;
  sRichEdit1.Width:=673;
  sRichEdit1.Left:=256;
  sRichEdit1.Height:=330;
  sTreeView1.Visible:=true;
  if fMainMenu.work='Class' then
    begin
      if fDB.ADOInsertQuestion.Fields[4].AsString='1' then
        sGroupBox1.Visible:=True;
      if fDB.ADOInsertQuestion.Fields[4].AsString='2' then
        sGroupBox2.Visible:=True;
      if fDB.ADOInsertQuestion.Fields[4].AsString='3' then
        sGroupBox6.Visible:=True;
    end
    else
    begin
      if fDB.ADOInsertQuestion.Fields[3].AsString='1' then
        sGroupBox1.Visible:=True;
      if fDB.ADOInsertQuestion.Fields[3].AsString='2' then
        sGroupBox2.Visible:=True;
      if fDB.ADOInsertQuestion.Fields[3].AsString='3' then
        sGroupBox6.Visible:=True;
    end;
  bNext.Visible:=True;
  sBitBtn16.Visible:=True;
end;

procedure TfIndependentWork.ShowSolve;
begin
  {if fdb.ADOInsertQuestion.FieldByName('SolveAudio_ID').IsNull and
    fdb.ADOInsertQuestion.FieldByName('SolveVideo_ID').IsNull and
    fdb.ADOInsertQuestion.FieldByName('SolvePhoto_ID').IsNull then
    begin
      sGroupBox3.Enabled:=false;
      sGroupBox3.Visible:=false;
    end
  else
    begin
      sGroupBox3.Enabled:=true;
      sGroupBox3.Visible:=true;
    end;}
end;

procedure TfIndependentWork.FormCreate(Sender: TObject);
var
  Node : TTreeNode;
  i,j,count, Max_Questions, tttemp:Integer;
  Questions: array of Integer;
  temp,TittleTemp :string;
begin
  SetLength(QuestionIDs,0);
  normal_exit:=false;
  Mark:=False;
  num_task:=TStringList.Create;
  randomize;
  Start:=Now;
if fMainMenu.work='Class' then
  begin
    Label8.Caption:=fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс';
    TittleTemp:=' '+fSelectLesson.NameTraj+' '+fSelectLesson.NameLes;
    if fDB.ADOQuery3z.Active then
    fDB.ADOQuery17.Close;
    fDB.ADOQuery17.SQL.Clear;
    fDB.ADOQuery17.SQL.ADD('SELECT Count(*) FROM Results_Class');
    fDB.ADOQuery17.SQL.ADD('WHERE [Results_Class].[User_ID] = ' + IntToStr(fMainMenu.userId) + ' ');//+ '" and [Users].[User_Login] = "' + fMainMenu.userName + '" ');
    fDB.ADOQuery17.Open;
    tttemp := fDB.ADOQuery17.Fields[0].AsInteger;
    sLabel3.Caption := sLabel3.Caption + IntToStr(tttemp+1) + ' ' + IntToStr(fMainMenu.userId);


    fDB.ADOQuery17.Close;
    fDB.ADOQuery3z.Close;
    fDB.ADOQuery3z.SQL.Clear;
    fDB.ADOQuery3z.SQL.ADD('SELECT L.TimeLeft AS TimeLeft FROM Lessons AS L, Traject AS T, TrajectLessons AS TL');
    fDB.ADOQuery3z.SQL.ADD('WHERE T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND T.ID=:1 AND L.ID=:2');
    fDB.ADOQuery3z.Parameters.ParamByName('1').Value:=fSelectLesson.Id_Traj;
    fDB.ADOQuery3z.Parameters.ParamByName('2').Value:=fSelectLesson.Id_Lesson;
    fDB.ADOQuery3z.Open;
    sLabel2.Caption:='';
    sLabel2.Visible:=true;
    Time:=fDB.ADOQuery3z.FieldByName('TimeLeft').AsInteger*60;
    Timer2.Enabled:=true;
    if Length(TittleTemp)>50 then
      begin
        Label11.Caption:=copy(TittleTemp,1,50)+'...';
        Label11.Hint:=TittleTemp;
      end
    else
      Label11.Caption:=TittleTemp;
    fDB.ADOInsertQuestion.Close;
    fDB.ADOInsertQuestion.SQL.Clear;
    fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT L.Lesson_id, Q.ID AS Q_ID, Q.Nazvanie, Q.QuestionType_ID, Q.AnswerType,  Q.ConditionAudio_ID AS ConditionAudio_ID , Q.ConditionVideo_ID AS ConditionVideo_ID, Q.ConditionPhoto_ID AS ConditionPhoto_ID,');
    fDB.ADOInsertQuestion.SQL.ADD('Q.SolveAudio_ID AS SolveAudio_ID, Q.SolveVideo_ID AS SolveVideo_ID, Q.SolvePhoto_ID AS SolvePhoto_ID, Q.Theory_ID AS Theory_ID, Q.TheoryHelp_ID AS TheoryHelp_ID FROM LessonsQuestions L, Questions Q');
    fDB.ADOInsertQuestion.SQL.ADD('WHERE L.Lesson_id=:1 AND L.Question_ID=Q.ID AND Q.WorkType=0');
    fDB.ADOInsertQuestion.parameters.ParamByName('1').value:=fSelectLesson.Id_Lesson;
    fDB.ADOInsertQuestion.Open;
    fDB.ADOInsertQuestion.First;
    for i:=0 to fDB.ADOInsertQuestion.RecordCount-1 do
      begin
        node:=sTreeView1.Items.Add(nil,fDB.ADOInsertQuestion.Fields[2].AsString);
        Node.Data:= Pointer(fDB.ADOInsertQuestion.Fields[1].AsInteger);
        fDB.ADOInsertQuestion.Next;
      end;
    if sTreeView1.Items.Count>0 then
      begin
        NodeCount := sTreeView1.Items.Count;
        fDB.ADOInsertQuestion.First;
        if fSelectLesson.Continue='yes' then
          begin
            fdb.ADOQueryContinue.Close;
            fdb.ADOQueryContinue.SQL.Clear;
            fdb.ADOQueryContinue.SQL.Add('SELECT CW.ID, CW.Id_Traject AS Id_Traject, CW.Id_Lessons AS Id_Lesson, CW.ID_Question AS ID_Question, CW.Question_Selected AS Question_Selected FROM Continue_Class AS CW, Traject AS T, Lessons AS L, Users AS U, Questions AS Q');
            fdb.ADOQueryContinue.SQL.Add('WHERE CW.Id_Traject=T.ID AND CW.Id_Lessons=L.ID AND CW.User_ID=U.ID AND U.ID=:1 AND CW.ID_Question=Q.ID ORDER BY CW.ID desc');
            fdb.ADOQueryContinue.Parameters.ParamByName('1').Value:=fMainMenu.userId;
            fdb.ADOQueryContinue.Open;
            sTreeView1.Selected:=sTreeView1.Items[fdb.ADOQueryContinue.FieldByName('Question_Selected').AsInteger];
            while not fDB.ADOInsertQuestion.Eof do
              begin
                if fDB.ADOInsertQuestion.Fields[1].AsInteger=fdb.ADOQueryContinue.FieldByName('ID_Question').AsInteger then
                  begin
                    break;
                  end;
                fdb.ADOInsertQuestion.Next;
              end;
            fdb.ADOQuery2z.Close;
            fdb.ADOQuery2z.SQL.Clear;
            fdb.ADOQuery2z.SQL.Add('DELETE FROM Continue_Class');
            fdb.ADOQuery2z.SQL.Add('WHERE User_ID=:1 AND Id_Traject=:2 AND Id_Lessons=:3');
            fdb.ADOQuery2z.Parameters.ParamByName('1').Value:=fMainMenu.userId;
            fdb.ADOQuery2z.Parameters.ParamByName('2').Value:=fdb.ADOQueryContinue.FieldByName('Id_Traject').AsInteger;
            fdb.ADOQuery2z.Parameters.ParamByName('3').Value:=fdb.ADOQueryContinue.FieldByName('Id_Lesson').AsInteger;
            fdb.ADOQuery2z.ExecSQL;
          end
        else
          sTreeView1.Selected:=sTreeView1.Items[0];
        NextClassQuestion;
      end;
  end;
if fMainMenu.work='Ind' then
  begin
  Label8.Caption:=fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс';
  TittleTemp:=' '+QuestionTypeForm.sListView1.Selected.Caption+' '+fChoose.sListView1.Selected.Caption;
  if Length(TittleTemp)>50 then
    begin
      Label11.Caption:=copy(TittleTemp,1,50)+'...';
      Label11.Hint:=TittleTemp;
    end
  else
    Label11.Caption:=TittleTemp;
  fDB.ADOInsertQuestion.Close;
  fDB.ADOInsertQuestion.SQL.Clear;
  fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID AS Q_ID');
  fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q, TrajectLessons AS TL, Lessons AS L, LessonsQuestions AS LQ, CompleXity AS CX, Traject AS T, QuestionTypes AS QT');
  fDB.ADOInsertQuestion.SQL.ADD('WHERE CX.ID=:1 AND T.ID=TL.Traject_ID AND TL.Lessons_ID=L.ID AND LQ.Lesson_ID=L.ID AND CX.ID=Q.CompleXity_ID AND Q.ID=LQ.Question_ID AND QT.ID=:2 AND QT.ID=Q.QuestionType_ID AND Q.WorkType=1');
  fDB.ADOInsertQuestion.parameters.ParamByName('1').value:=fDB.CompleXity_ID;
  fDB.ADOInsertQuestion.parameters.ParamByName('2').value:=fDB.QuestionTypes_ID;
  fDB.ADOInsertQuestion.Open;
  if fOptionUser.sTrackBar2.Position>fDB.ADOInsertQuestion.RecordCount then
    Max_Questions:=fDB.ADOInsertQuestion.RecordCount
  else
    Max_Questions:=fOptionUser.sTrackBar2.Position;
  SetLength(Questions,Max_Questions);
  for j:=0 to Max_Questions-1 do
    Questions[j]:=-1;
  i:=0;
  repeat
    count:=Random(Max_Questions);
    for j:=0 to Max_Questions-1 do
      begin
        if (count=Questions[j]) and (Questions[j]<>-1) then
          break;
        Questions[i]:=count;
        i:=i+1;
        break;
      end;
  until(i>=Max_Questions);
  temp:='';
  fDB.ADOInsertQuestion.First;
  if fDB.ADOInsertQuestion.RecordCount<>0 then
    begin
      for i:=0 to fDB.ADOInsertQuestion.RecordCount-1 do
        begin
          for j:=0 to Max_Questions-1 do
            begin
              if i=Questions[j] then
                temp:=temp+IntToStr(fDB.ADOInsertQuestion.Fields[0].AsInteger)+',';
            end;
          fDB.ADOInsertQuestion.Next;
        end;
  Delete(temp,length(temp),1);
  fDB.ADOInsertQuestion.Close();
  fDB.ADOInsertQuestion.SQL.Clear;
  fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID, Q.Nazvanie, Q.QuestionType_ID, Q.AnswerType, Q.ConditionAudio_ID, Q.ConditionVideo_ID, Q.ConditionPhoto_ID,Q.SolveAudio_ID, Q.SolveVideo_ID, Q.SolvePhoto_ID, Q.Theory_ID AS Theory_ID, Q.TheoryHelp_ID AS TheoryHelp_ID');
  fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q');
  fDB.ADOInsertQuestion.SQL.ADD('WHERE ID IN ('+temp+') AND Q.WorkType=1');
  fDB.ADOInsertQuestion.Open;
  fDB.ADOInsertQuestion.First;
  for i:=0 to fDB.ADOInsertQuestion.RecordCount-1 do
    begin
      node:=sTreeView1.Items.Add(nil,fDB.ADOInsertQuestion.Fields[1].AsString);
      Node.Data:= Pointer(fDB.ADOInsertQuestion.Fields[0].AsInteger);
      fDB.ADOInsertQuestion.Next;
    end;
    if sTreeView1.Items.Count>0 then
      begin
        NodeCount := sTreeView1.Items.Count;
        fDB.ADOInsertQuestion.First;
        sTreeView1.Selected:=sTreeView1.Items[0];
        NextIndQuestion;
      end;
    end;
end;
if fMainMenu.work='Diag' then
  begin
    Label8.Caption:=fMainMenu.userName+' '+fMainMenu.userFirstName+' '+IntToStr(fMainMenu.userOld)+' лет'+' '+(fMainMenu.userclass)+' класс';
    TittleTemp:=' '+QuestionTypeForm.sListView1.Selected.Caption;
    if Length(TittleTemp)>50 then
      begin
        Label11.Caption:=Copy(TittleTemp,1,50)+'...';
        Label11.Hint:=TittleTemp;
      end
    else
      Label11.Caption:=TittleTemp;
    temp:='';
    for i:=0 to length(fdb.Question_IDs)-1 do
      temp:=temp+IntToStr(fdb.Question_IDs[i])+',';
    Delete(temp,length(temp),1);
    fDB.ADOInsertQuestion.Close;
    fDB.ADOInsertQuestion.SQL.Clear;
    fDB.ADOInsertQuestion.SQL.ADD('SELECT DISTINCT Q.ID AS Q_ID, Q.Nazvanie, Q.QuestionType_ID, Q.AnswerType,  Q.ConditionAudio_ID, Q.ConditionVideo_ID, Q.ConditionPhoto_ID,Q.SolveAudio_ID, Q.SolveVideo_ID, Q.SolvePhoto_ID, Q.Theory_ID, Q.TheoryHelp_ID AS TheoryHelp_ID');
    fDB.ADOInsertQuestion.SQL.ADD('FROM Questions AS Q WHERE Q.ID IN ('+temp+') AND Q.WorkType=2');
    fDB.ADOInsertQuestion.Open;
    fDB.ADOInsertQuestion.First;
    for i:=0 to length(fdb.Question_IDs)-1 do
      begin
        fDB.ADOInsertQuestion.First;
        for j:=0 to fDB.ADOInsertQuestion.RecordCount-1 do
          begin
            if fDB.ADOInsertQuestion.Fields[0].AsInteger=fdb.Question_IDs[i] then
              begin
                node:=sTreeView1.Items.Add(nil,fDB.ADOInsertQuestion.Fields[1].AsString);
                Node.Data:= Pointer(fDB.ADOInsertQuestion.Fields[0].AsInteger);
              end;
            fDB.ADOInsertQuestion.Next;
          end;
      end;
    if sTreeView1.Items.Count>0 then
      begin
        NodeCount := sTreeView1.Items.Count;
        fDB.ADOInsertQuestion.First;
        sTreeView1.Selected:=sTreeView1.Items[0];
        NextDiagQuestion;
      end;
  end;
  SetLength(QuestionIDs,sTreeView1.Items.Count);
  for i:=0 to sTreeView1.Items.Count-1 do
    QuestionIDs[i]:=integer(sTreeView1.Items.Item[i].Data);
  ShowSolve;
  RightAnswerCount:=0;
  bNext.Enabled:=False;
  strRight:='';
  strWrong:='';
end;

procedure TfIndependentWork.FormDestroy(Sender: TObject);
begin
  if fDB.ADOInsertQuestion.Active then
    fdb.ADOInsertQuestion.Close;
end;

procedure TfIndependentWork.FormShow(Sender: TObject);
begin
  sLabel1.Caption:='Текущий вопрос: '+inttostr(sTreeView1.Selected.Index+1)+'/'+inttostr(sTreeView1.Items.count);
  if fMainMenu.work='Ind' then
    Caption:=GetBaseCaption + ' (Самостоятельная работа)';
  if fMainMenu.work='Class' then
    Caption:=GetBaseCaption + ' (Классная работа)';
  if fMainMenu.work='Diag' then
    Caption:=GetBaseCaption + ' (Диагностика)';  
  sRichEdit1.Color:=fOptionUser.sColorSelect1.ColorValue;
  sRichEdit1.Font.Color:=fOptionUser.sColorSelect2.ColorValue;
  sRichEdit1.Font.Size:=fOptionUser.sTrackBar1.Position;
  sRichEdit1.Font.Name:=fOptionUser.sFontComboBox1.Text;
  sRichEdit1.Update;
end;

procedure TfIndependentWork.PictureRightImage;
var
  AnswerType,i:Integer;
begin
  try
    ShowAnswerPictureForm:=TShowAnswerPictureForm.Create(nil);
    AnswerType:=1;
  if fMainMenu.work='Class' then
    begin
      if fDB.ADOInsertQuestion.Fields[4].AsInteger = 1 then
        AnswerType:=1;
      if fDB.ADOInsertQuestion.Fields[4].AsInteger = 2 then
        AnswerType:=2;
      if fDB.ADOInsertQuestion.Fields[4].AsInteger = 3 then
        AnswerType:=3;
    end;
  if (fMainMenu.work='Ind') or (fMainMenu.work='Diag') then
    begin
      if fDB.ADOInsertQuestion.Fields[3].AsInteger = 1 then
        AnswerType:=1;
      if fDB.ADOInsertQuestion.Fields[3].AsInteger = 2 then
        AnswerType:=2;
      if fDB.ADOInsertQuestion.Fields[3].AsInteger = 3 then  
        AnswerType:=3;
    end;
  case AnswerType of
    1:
      begin
        if RightAnswerRadioImage<>'' then
          begin
            ShowAnswerPictureForm.Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+RightAnswerRadioImage);
            ShowAnswerPictureForm.sBitBtn1.Enabled:=true;
            ShowAnswerPictureForm.sBitBtn1.Visible:=true;
            ShowAnswerPictureForm.ShowModal;
          end;
      end;
    2:
      begin
        if RightAnswerStringImage<>'' then
          begin
            ShowAnswerPictureForm.Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+RightAnswerStringImage);
            ShowAnswerPictureForm.ShowModal;
          end;
      end;
    3:
      begin
        for i:=1 to 6 do
          begin
            if RightAnswerCheck[i] and (RightAnswerCheckImage[i]<>'') then
              begin
                TImage(ShowAnswerPictureForm.FindComponent('Image' + IntToStr(i))).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+RightAnswerCheckImage[i]);
              end;
          end;
        ShowAnswerPictureForm.ShowModal;
      end;
  end;
  finally
    FreeAndNil(ShowAnswerPictureForm);
  end;
end;


procedure TfIndependentWork.ImageShow(Number:integer);
begin
  try
    ShowAnswerPictureForm:= TShowAnswerPictureForm.Create(nil);
if fMainMenu.work='Class' then
  begin
    if fDB.ADOInsertQuestion.Fields[4].AsInteger = 1 then
      begin  
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=TsRadioButton(FindComponent('sRadioButton' + IntToStr(Number))).Caption;
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
    if fDB.ADOInsertQuestion.Fields[4].AsInteger = 2 then
      begin
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
    if fDB.ADOInsertQuestion.Fields[4].AsInteger = 3 then
      begin
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=TsCheckBox(FindComponent('sCheckBox' + IntToStr(Number))).Caption;
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
  end;
  if (fMainMenu.work='Ind') or (fMainMenu.work='Diag') then
    begin
    if fDB.ADOInsertQuestion.Fields[3].AsInteger = 1 then
      begin
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=TsRadioButton(FindComponent('sRadioButton' + IntToStr(Number))).Caption;
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
    if fDB.ADOInsertQuestion.Fields[3].AsInteger = 2 then
      begin
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
    if fDB.ADOInsertQuestion.Fields[3].AsInteger = 3 then
      begin
        if fdb.ADOQueryAnswers.Active then
          fdb.adoqueryAnswers.close;
        fdb.ADOQueryAnswers.sql.Clear;
        fdb.ADOQueryAnswers.sql.add('SELECT Picture FROM Answers WHERE Question_ID=:1 AND Nazvanie=:2');
        fdb.ADOQueryAnswers.Parameters.ParamByName('1').Value:=Integer(sTreeView1.Selected.data);
        fdb.ADOQueryAnswers.Parameters.ParamByName('2').Value:=TsCheckBox(FindComponent('sCheckBox' + IntToStr(Number))).Caption;
        fdb.ADOQueryAnswers.Open;
        fdb.ADOQueryAnswers.First;
      end;
    end;
    if fdb.ADOQueryAnswers.FieldByName('Picture').AsString='' then
    else
      begin
        //ShowAnswerPictureForm.Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.ADOQueryAnswers.FieldByName('Picture').AsString);
        //ShowAnswerPictureForm.ShowModal;
        try
          ShowPictureForm:= TShowPictureForm.Create(nil);
          ShowPictureForm.Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+fdb.ADOQueryAnswers.FieldByName('Picture').AsString);
          ShowPictureForm.ShowModal;
        finally
          FreeAndNil(ShowPictureForm);
        end;
      end;
  finally
    FreeAndNil(ShowAnswerPictureForm);
  end;
end;

procedure TfIndependentWork.Image10MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageShow(3);
end;

procedure TfIndependentWork.Image11MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageShow(4);
end;

procedure TfIndependentWork.Image12MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageShow(5);
end;

procedure TfIndependentWork.Image13MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageShow(6);
end;

procedure TfIndependentWork.Image14MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ImageShow(14);
end;

procedure TfIndependentWork.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(1);
end;

procedure TfIndependentWork.Image3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(2);
end;

procedure TfIndependentWork.Image4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(3);
end;

procedure TfIndependentWork.Image5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(4);
end;

procedure TfIndependentWork.Image6MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(5);
end;

procedure TfIndependentWork.Image7MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(6);
end;

procedure TfIndependentWork.Image8MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(1);
end;

procedure TfIndependentWork.Image9MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ImageShow(2);
end;

procedure TfIndependentWork.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  if fMainMenu.work='Class' then
    begin
      fdb.ADOQueryContinue.Close;
      fdb.ADOQueryContinue.SQL.Clear;
      fdb.ADOQueryContinue.SQL.Add('INSERT INTO Continue_Class(Id_Traject, Id_Lessons, Question_Selected, Timer, User_ID, RightAnswer, ID_Question) VALUES (:1,:2,:3,:4,:5,:6,:7)');
      fdb.ADOQueryContinue.Parameters.ParamByName('1').Value:=fSelectLesson.Id_Traj;
      fdb.ADOQueryContinue.Parameters.ParamByName('2').Value:=fSelectLesson.Id_Lesson;
      fdb.ADOQueryContinue.Parameters.ParamByName('3').Value:=sTreeView1.Selected.Index;
      fdb.ADOQueryContinue.Parameters.ParamByName('4').Value:=LabelTime.Caption;
      fdb.ADOQueryContinue.Parameters.ParamByName('5').Value:=fMainMenu.userId;
      fdb.ADOQueryContinue.Parameters.ParamByName('6').Value:=sum;
      fdb.ADOQueryContinue.Parameters.ParamByName('7').Value:=fdb.ADOInsertQuestion.FieldByName('Q_ID').AsInteger;
      fdb.ADOQueryContinue.ExecSQL;
    end
end;



end.
