unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,shellapi, StrUtils, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
  Vcl.StdCtrls,IOUtils, Vcl.ComCtrls, Vcl.FileCtrl, FlCtrlEx;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    TrackBar1: TTrackBar;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    TrackBar2: TTrackBar;
    Button2: TButton;
    Chart1: TChart;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);

  private
    { Private declarations }
  public
     procedure AcceptFiles( var msg : TMessage );
      message WM_DROPFILES;
  end;

var
  Form1: TForm1;
  ImportNummer:integer;
  FilePath: TStringList;
  DirInfo: TSearchRec;
  r : Integer;
implementation

{$R *.dfm}



//procedure countdates();
//var
//i:integer;
//regel,datum:string;
//begin
//form1.Memo2.Clear;
//form1.combobox1.clear;
//form3.ComboBox1.Clear;
//;
//for I := 1 to form1.memo1.lines.count-1 do
//  begin
//
//   regel := form1.memo1.lines[i];
//   delete(regel,11,14);
//
//   if (Occurrences(regel,form1.Memo2.Text) = 0 )  then
//   begin
//      form1.memo2.lines.add(regel);
//      form1.ComboBox1.Items.Add(regel);
//
//      form3.ComboBox1.Items.Add(regel);
//   end;
//
//
//  end;
//
//
//form1.Label6.Caption := IntToStr(form1.memo2.lines.count);
//end;




procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;


function correctDateTime(DatumTijd:String):TDateTime;
var
correctedatum: TDateTime;

OutputTijd:TStringList;
Datum : TstringList;
jaar,dag,maand,uur,minuut,seconde:TDateTime;
begin
 OutputTijd := TStringList.Create;
 Datum      := TStringList.Create;
 Split('-',DatumTijd,OutputTijd);
 Split('/',OutputTijd[0],Datum);

 correctedatum:= StrToDateTime(datum[2]+'-'+datum[1]+'-'+datum[0]+' '+OutputTijd[1]);

 result :=  correctedatum;

 OutputTijd.Free;
 Datum.Free;
end;


function writenewday(datefile,datetime,value:string):Boolean;
begin

  TFile.AppendAllText('splitdays/'+datefile+'_Q-Strip.txt', datetime+';'+value);
end;



function GetRandomColour: TColor;
begin
  Result := RGB(Random(255), Random(255), Random(255));
end;


function createseries(id:integer;timestamp:string;value:integer;LegendTitle:String):Boolean;
begin
  id := id-1;

  form1.Chart1[id].Add(value, timestamp);
  form1.Chart1[id].Marks.Style := smsValue;
  form1.Chart1[id].LegendTitle := LegendTitle;
end;



function cleardir(folder:string):Boolean;
var
 DirInfo: TSearchRec;
 r : Integer;
begin
  r := FindFirst(Folder+'\*.txt', FaAnyfile, DirInfo);
  while r = 0 do  begin
    if ((DirInfo.Attr and FaDirectory <> FaDirectory) and
        (DirInfo.Attr and FaVolumeId <> FaVolumeID)) then
      if DeleteFile(pChar(folder +'\'+ DirInfo.Name))
         = false then
       ShowMessage('Unable to delete :' +
                   folder + DirInfo.Name);
    r := FindNext(DirInfo);
  end;
 FindClose(DirInfo);

end;




function loadCsv(bestandsnaam:string;bestandsnummer:integer):boolean;
var
  csvdata: TStringList;
  OutPutList: TstringList;
  jaar,dag,maand,uur,minuut,seconde: TstringList;
  i,j:integer;
  sweatrate: integer;
  tijdstip:string;
  correctedatum: TDateTime;
  OutputTijd: TStringList;
  Datum : TstringList;

  DatumTijd,lastdate:String;
  series : TBarSeries;
  LegendTitle : String;
begin

  csvdata:= TStringList.Create;
  OutPutList := TStringList.Create;
  OutputTijd := TStringList.Create;
  Datum      := TStringList.Create;
  uur        := TStringList.Create;

  csvdata.Delimiter:=';';
  csvdata.LoadFromFile(bestandsnaam);

  form1.Chart1.AddSeries(TLineSeries.Create(form1));
  form1.Chart1.Shadow.Smooth:= true;
  form1.Chart1.Shadow.BlurSize:= 80;
  if (form1.checkbox2.checked) then
    begin
      cleardir('splitdays');
    end;

  for i := 1 to csvdata.Count-1 do
    begin
      Split(';', csvdata[i], OutPutList) ;
      Split('-',csvdata[i],OutputTijd);
      Split('/',OutputTijd[0],Datum);
      Split(':',OutputTijd[1],uur);

      correctedatum:= StrToDateTime(datum[2]+'-'+datum[1]+'-'+datum[0]+' '+OutputTijd[1]);   ///DD-MM-YYYY HH:MM:SS
      LegendTitle :=  datum[2]+'-'+datum[1]+'-'+datum[0];

    if(datum[2] = lastdate) AND (form1.checkbox2.checked = true)then
      begin
       writenewday(datum[2]+'-'+datum[1]+'-'+datum[0],OutPutList[0],OutPutList[1]+Char(#13));
      end;

      lastdate := datum[2];
      tijdstip := OutPutList[0];
      sweatrate:= OutPutList[1].ToInteger();

      createseries(bestandsnummer,DateTimeToStr(correctedatum),sweatrate,LegendTitle);
  end;

  csvdata.Free;
  Outputlist.Free;
  OutputTijd.Free;
  Datum.free;

  if(form1.checkbox2.checked = true)then
    begin
      ShellExecute(Application.Handle,PChar('explore'),PChar('splitdays'),nil,nil,SW_SHOWNORMAL);
      form1.checkbox2.Checked:= false;
    end;
end;



procedure TForm1.AcceptFiles( var msg : TMessage );
const
  cnMaxFileNameLen = 255;
var
  i,
  nCount     : integer;
  acFileName : array [0..cnMaxFileNameLen] of char;
begin
  nCount := DragQueryFile( msg.WParam,
                           $FFFFFFFF,
                           acFileName,
                           cnMaxFileNameLen );
  for i := 0 to nCount-1 do
  begin
    DragQueryFile( msg.WParam, i,
                   acFileName, cnMaxFileNameLen );

    //MessageBox( Handle, acFileName, '', MB_OK );
    importnummer := importnummer+1;
    loadCsv(acFileName,importnummer);
  end;
  DragFinish( msg.WParam );

 form1.Caption:= 'Files Loaded '+ IntToStr(ImportNummer);

end;




function Occurrences(const Substring, Text: string): integer;
var
  offset: integer;
begin
  result := 0;
  offset := PosEx(Substring, Text, 1);
  while offset <> 0 do
  begin
    inc(result);
    offset := PosEx(Substring, Text, offset + length(Substring));
  end;
end;




procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
begin
 for I := 0 to chart1.SeriesCount-1 do
  begin
    chart1.series[0].Destroy;
  end;
 importnummer:= 0;
end;




procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if (checkbox1.checked) then
    begin
      chart1.View3D:= true;
    end else
    begin
      chart1.View3D:= false;
    end;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
 if (checkbox3.Checked) then
 begin
   chart1.Legend.Visible:= false;
 end else
     begin
       chart1.Legend.Visible:= true;
     end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
i: integer;
begin
 importnummer:= 0;
 DragAcceptFiles(Self.Handle, True);


end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
chart1.View3DOptions.Rotation := trackbar1.Position;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
 chart1.View3DOptions.Perspective := trackbar2.Position;
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
  chart1.View3DOptions.Elevation := trackbar3.Position;
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
    chart1.View3DOptions.Zoom := trackbar4.Position;
end;

end.
