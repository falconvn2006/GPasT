unit ChxBase;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia;

type
   TChoixBase = class(TForm)
      Label1: TLabel;
      Label2: TLabel;
      lb: TListBox;
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
      Http: TIpHttpClientGinkoia;
      Lab_Rep: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Ed_Rech: TComboBox;
    cb: TListBox;
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure lbDblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ed_RechKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbDblClick(Sender: TObject);
   private
    { Déclarations privées }
      procedure recup(_quoi: string);
      procedure clear;
   public
    { Déclarations publiques }
      Base : String ;
   end;

   Treel = class
      value: string;
      constructor CREATE(value: string);
   end;

var
   ChoixBase: TChoixBase;

implementation
Uses
  UCst ;
{$R *.DFM}

procedure TChoixBase.clear;
var
   i: integer;
begin
   for i := 0 to cb.Items.count - 1 do
      Treel(cb.Items.objects[i]).free;
   for i := 0 to lb.Items.count - 1 do
      Treel(lb.Items.objects[i]).free;
   cb.items.clear;
   lb.items.clear;
end;

procedure TChoixBase.FormCreate(Sender: TObject);
VAR
  sListFilePath : String;
begin
  sListFilePath := ExtractFilePath(ParamStr(0)) + 'ListeLame.lst';
  if FileExists(ExtractFilePath(ParamStr(0)) + 'ListeLame.lst') then
    Ed_Rech.Items.LoadFromFile(sListFilePath);

  recup('')
end;

{ Treel }

constructor Treel.CREATE(value: string);
begin
   self.value := value;
end;

procedure TChoixBase.FormDestroy(Sender: TObject);
begin
   clear;
end;

procedure TChoixBase.recup(_quoi: string);
var
   tsl: tstringlist;
   s: string;
   i: integer;
   reel, quoi, fichier: string;
begin
   s := URL+'ChxBase';
   if _quoi <> '' then
      s := s + '?PATH=' + _quoi;
   s := traitechaine(s) ;
   if Http.OldGetWaitTimeOut(s, 30000) then
   begin
      tsl := tstringlist.create;
      tsl.Text := Http.AsString(s);
      s := tsl.Text;
      s := tsl[0];
      s := copy(s, 1, pos(';', s) - 1);
      Lab_Rep.caption := s;
      if length(s) > 3 then
      begin
         delete(s, length(s), 1);
         while (length(s) > 0) and (s[length(s)] <> '\') do
            delete(s, length(s), 1);
         cb.Items.AddObject('<< précédent >>', Treel.create(s))
      end;
      for i := 1 to tsl.count - 1 do
      begin
         s := tsl[i];
         reel := copy(s, 1, pos(';', s) - 1); delete(s, 1, pos(';', s));
         quoi := copy(s, 1, pos(';', s) - 1); delete(s, 1, pos(';', s));
         fichier := s;
         if quoi = 'DIR' then
            cb.Items.AddObject(fichier, Treel.create(reel))
         else
            lb.items.AddObject(fichier, Treel.create(reel));
      end;
      tsl.free;
   END ;
end;

procedure TChoixBase.BitBtn1Click(Sender: TObject);
begin
  IF lb.ItemIndex>-1 then
    lbDblClick(sender)
end;

procedure TChoixBase.lbDblClick(Sender: TObject);
begin
  IF lb.ItemIndex>-1 then
  begin
    base := Treel(lb.items.objects[lb.ItemIndex]).value;
    base := copy(base,1,length(base)-1) ;
    Modalresult := Mrok ;
  END ;
end;

procedure TChoixBase.SpeedButton1Click(Sender: TObject);
begin
     clear ;
     recup(ed_Rech.text) ;
end;

procedure TChoixBase.ed_RechKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  IF key=vk_return then
     SpeedButton1Click(nil) ;
end;

procedure TChoixBase.cbDblClick(Sender: TObject);
var
   S: string;
begin
   if cb.ItemIndex > -1 then
   begin
      s := Treel(cb.items.objects[cb.ItemIndex]).value;
      clear;
      recup(s);
   end;
end;

end.

