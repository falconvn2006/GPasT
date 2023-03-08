unit SmiletoCt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, StrUtils,  SmilesToCt, ConTabObj, ComCtrls, DataStr, CheckStrings;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    check_smiles: TButton;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    ClearMemo: TButton;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    BitBtn2: TBitBtn;
    Button1: TButton;
    procedure check_smilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ClearMemoClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations}
  public
   TablaConect : TConTabobj;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.check_smilesClick(Sender: TObject);
var
 I: Integer;
 S: String;
begin
 SmiToCt (Edit1.Text, TablaConect, I);

// ShowMessage(IntToStr(TablaConect.AtomsCount));
 AddHid (TablaConect);

// ShowMessage(IntToStr(TablaConect.AtomsCount));
 Statusbar1.SimpleText := 'Missing '+ IntToStr(I) + ' Hidrogens';

 for I:=0 to Pred(TablaConect.AtomsCount) do
 begin
  Memo1.Lines.Add(TablaConect.Atoms[I]+'  '+TablaConect.Valencias.Strings[I]);
 end;

 for I:=0 to Pred(TablaConect.BondsCount) do
 Memo1.Lines.Add(TablaConect.Enlaces[I]);
 S:= Gformule(TablaConect);
 ShowMessage(S);
 //TablaConect.WritetoFile('D:\verquepsa');

 end;
procedure TForm1.FormCreate(Sender: TObject);
begin
 TablaConect := TConTabobj.Create;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 TablaConect.Destroy;
end;

procedure TForm1.ClearMemoClick(Sender: TObject);
begin
   Memo1.Clear;
   StatusBar1.SimpleText :='';
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
f: textfile;
S,S1,S2: String;
FData : TDataStrF;
I, J, counter: Integer;

begin
 Fdata := TDataStrF.Create(self);
 if FData.ShowModal = mrok  then
 begin
   I := FData.RadioGroup1.ItemIndex;
   FData.Free;
 end;
 counter := 0;
 if OpenDialog1.Execute then
 begin
 // ShowMessage( OpenDialog1.FileName);
  AssignFile(F, OpenDialog1.FileName);
  reset(F);
  while not Eof(F) do
  begin
   Readln(F,S);
    // S1 Smiles
   // S2 Name
   GetEntryStr (S, I, S1, S2);
   //ShowMessage(S1);
   //Showmessage(S2);
   If Length (S1) <> 0 then
   begin
    SmiToCt(S1,TablaConect,J);
    AddHid (TablaConect);
    Inc(Counter);
   end;

   Statusbar1.SimpleText := 'Missing '+ IntToStr(J) + ' Hidrogens in '+S2;
   for J:=0 to Pred(TablaConect.AtomsCount) do
   begin
    Memo1.Lines.Add(TablaConect.Atoms[J]+'  '+TablaConect.Valencias.Strings[J]);
   end;
   for J:=0 to Pred(TablaConect.BondsCount) do
    Memo1.Lines.Add(TablaConect.Enlaces[J]);
   // TablaConect.WritetoFile('D:\VErfinal\'+S2);
   //ShowMessage(S1 + 'Name: '+S2);
   Memo1.lines.Clear;

  end;

  closefile(F);
  ShowMessage(IntToStr(Counter) + ' were Processed');
 end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Lines.SaveToFile('salida.log');
end;

end.
