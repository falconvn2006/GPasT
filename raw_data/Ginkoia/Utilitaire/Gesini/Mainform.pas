unit Mainform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IniFiles, Vcl.ExtCtrls,
  Data.DB, FireDAC.Comp.DataSet,FireDAC.Comp.Client, Vcl.ComCtrls,
  Vcl.ButtonGroup, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.IBBase, FireDAC.Phys.IB,  FireDAC.Phys.IBWrapper;

type
  TFormMain = class(TForm)
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButtonClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private
    ItemNumber: Integer;
    procedure GetExistingItems;
    procedure GetMags;
    procedure GetPostes(MAGNOM:string);
    procedure GetItems;
    procedure ChangeItem();
  public
  end;

var
  FormMain: TFormMain;
  fic : TForm;

implementation

uses Datamod, Jetons;

{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
begin
  if openDialog1.execute then
  ListBox3.Items.Add(openDialog1.filename);
  ListBox3.ItemIndex:=0;
  ListBox3Click(Sender);
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  if openDialog2.execute then
  begin
    Edit3.Text := 'PATH'+IntToStr(ItemNumber)+'='+openDialog2.FileName;
  end;
end;

procedure TFormMain.Button3Click(Sender: TObject);
var
  I, L, inc, confirm: Integer;
  F: TextFile;
  Stg:String;
begin
  if (ListBox3.ItemIndex >= 0) then
  begin
  confirm := MessageDlg('Voulez vous Sauvegarder les modifications?',mtConfirmation, mbOkCancel, 0);
  if confirm = mrOK then
  begin
  I:= Pos('PATH'+IntToStr(ItemNumber), Memo1.Text);
  inc := 0;
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Memo1.Lines[L] := Edit3.Text;
  end
  else
  begin
    while (Pos('PATH'+IntToStr(ItemNumber - inc), Memo1.Text) < 1) do
    begin
     inc := inc + 1;
    end;
    I := Pos('PATH'+IntToStr(ItemNumber - inc), Memo1.Text);
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I, 0);
    Memo1.Lines.Insert(L + 1, Edit3.Text);
  end;
  I:= Pos('MAG'+IntToStr(ItemNumber), Memo1.Text);
  inc := 0;
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Memo1.Lines[L] := Edit4.Text;
  end
  else
  begin
    while (Pos('MAG'+IntToStr(ItemNumber - inc), Memo1.Text) < 1) do
    begin
     inc := inc + 1;
    end;
    I := Pos('MAG'+IntToStr(ItemNumber - inc), Memo1.Text);
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I, 0);
    Memo1.Lines.Insert(L + 1, Edit4.Text);
  end;
  I:= Pos('POSTE'+IntToStr(ItemNumber), Memo1.Text);
  inc := 0;
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Memo1.Lines[L] := Edit5.Text;
  end
  else
  begin
    while (Pos('POSTE'+IntToStr(ItemNumber - inc), Memo1.Text) < 1) do
    begin
     inc := inc + 1;
    end;
    I := Pos('POSTE'+IntToStr(ItemNumber - inc), Memo1.Text);
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I, 0);
    Memo1.Lines.Insert(L + 1, Edit5.Text);
  end;
  I:= Pos('ITEM'+IntToStr(ItemNumber), Memo1.Text);
  inc := 0;
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Memo1.Lines[L] := Edit6.Text;
  end
  else
  begin
    while (Pos('ITEM'+IntToStr(ItemNumber - inc), Memo1.Text) < 1) do
    begin
     inc := inc + 1;
    end;
    I := Pos('ITEM'+IntToStr(ItemNumber - inc), Memo1.Text);
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I, 0);
    Memo1.Lines.Insert(L + 1, Edit6.Text);
  end;
  I:= Pos('ITEM0', Memo1.Text);
  if I < 1 then
  begin
    I:= pos('[NOMBASES]', Memo1.Text);
    L:= SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I-1, 0);
    Memo1.Lines[L+1] := 'ITEM0=';
  end;
  Stg:=Memo1.Text;
  Assignfile(F, ListBox3.Items[ListBox3.ItemIndex]);
  Rewrite(F);
  Write(F,Stg);
  CloseFile(F);
  end;
end;
end;

procedure TFormMain.Button4Click(Sender: TObject);
var
  I, L, inc, confirm: Integer;
  F: TextFile;
  Stg:String;
begin
 if (ListBox3.ItemIndex >= 0) then
 begin
  if (ItemNumber = 0) then
  begin
    ShowMessage('Impossible de supprimer l''item 0');
  end
  else
  begin
    confirm := MessageDlg('Voulez vous vraiment supprimer Item'+IntToStr(ItemNumber)+'?',mtConfirmation, mbOkCancel, 0);
    if confirm = mrOK then
    begin
      Edit3.Clear;
      Edit4.Clear;
      Edit5.Clear;
      Edit6.Clear;
      ListBox1.Clear;
      ListBox2.Clear;
      I:= Pos('PATH'+IntToStr(ItemNumber), Memo1.Text);
      inc := 0;
      if I > 0 then
      begin
        L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
        Memo1.Lines.Delete(L);
      end;
      I:= Pos('MAG'+IntToStr(ItemNumber), Memo1.Text);
      inc := 0;
      if I > 0 then
      begin
        L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
        Memo1.Lines.Delete(L);
      end;
      I:= Pos('POSTE'+IntToStr(ItemNumber), Memo1.Text);
      inc := 0;
      if I > 0 then
      begin
        L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
        Memo1.Lines.Delete(L);
      end;
      I:= Pos('ITEM'+IntToStr(ItemNumber), Memo1.Text);
      inc := 0;
      if I > 0 then
      begin
        L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
        Memo1.Lines.Delete(L);
      end;
      Stg:=Memo1.Text;
      Assignfile(F, ListBox3.Items[ListBox3.ItemIndex]);
      Rewrite(F);
      Write(F,Stg);
      CloseFile(F);
      end;
    end
  end;
end;

procedure TFormMain.Button5Click(Sender: TObject);
begin
    application.CreateForm(TJeton,Jeton);
    Jeton.showmodal;
end;

procedure TFormMain.GetExistingItems;
var
  I, L: Integer;
begin
  I:= Pos('PATH'+IntToStr(ItemNumber)+'', Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit3.Text := Memo1.Lines[L];
  end;
  Edit4.Clear;
  I:= Pos('MAG'+IntToStr(ItemNumber)+'', Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit4.Text := Memo1.Lines[L];
  end;
  Edit5.Clear;
  I:= Pos('POSTE'+IntToStr(ItemNumber)+'', Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit5.Text := Memo1.Lines[L];
  end;
  Edit6.Clear;
  I:= Pos('ITEM'+IntToStr(ItemNumber)+'', Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit6.Text := Memo1.Lines[L];
  end;
end;

procedure TFormMain.GetMags;
var MyQuery:TFDQuery;
begin
    MyQuery:=TFDQuery.Create(nil);
    try
       MyQuery.Connection:=DMMain.FDConnection1;
       MyQuery.SQL.Text:='select MAG_ID, MAG_NOM, MAG_ENSEIGNE  ' + #13+#10 +
          ' FROM GENMAGASIN JOIN K ON K_ID=MAG_ID AND K_ENABLED=1 ' + #13+#10 +
          ' where MAG_ID<>0 ';
       MyQuery.Open();
       ListBox1.Items.Clear;
       while not(MyQuery.eof) do
        begin
           ListBox1.Items.Add(MyQuery.FieldByName('MAG_NOM').asstring);
           MyQuery.Next;
        end;
    finally
      MyQuery.Close;
      MyQuery.Free;
    end;
end;

procedure TFormMain.GetPostes(MAGNOM:string);
var MyQuery:TFDQuery;
begin
    MyQuery:=TFDQuery.Create(nil);
    try
       MyQuery.Connection:=DMMain.FDConnection1;
       MyQuery.SQL.Text:='select * FROM GENPOSTE      ' + #13+#10 +
          ' JOIN K ON K_ID=POS_ID AND K_ENABLED=1     ' + #13+#10 +
          ' JOIN GENMAGASIN ON POS_MAGID=MAG_ID AND MAG_NOM=:MAGNOM ' + #13+#10 +
          ' JOIN K ON K_ID=MAG_ID AND K_ENABLED=1     ' + #13+#10 +
          ' where POS_ID<>0 ';
       MyQuery.ParamByName('MAGNOM').asstring:=MAGNOM;
       MyQuery.Open();
       ListBox2.Items.Clear;
       while not(MyQuery.eof) do
        begin
           ListBox2.Items.Add(MyQuery.FieldByName('POS_NOM').asstring);
           MyQuery.Next;
        end;
    finally
      MyQuery.Close;
      MyQuery.Free;
    end;
end;

procedure TFormMain.GetItems;
var MyQuery:TFDQuery;
begin
    MyQuery:=TFDQuery.Create(nil);
    try
       MyQuery.Connection:=DMMain.FDConnection1;
       MyQuery.SQL.Text:='select BAS_NOMPOURNOUS  ' + #13+#10 +
          ' FROM GENBASES JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ' + #13+#10 +
          ' where BAS_ID<>0 GROUP BY BAS_NOMPOURNOUS';
       MyQuery.Open();
       ListBox1.Items.Clear;
       while not(MyQuery.eof) do
        begin
           Edit6.Text := 'ITEM'+IntToStr(ItemNumber)+'='+MyQuery.FieldByName('BAS_NOMPOURNOUS').asstring;
           MyQuery.Next;
        end;
    finally
      MyQuery.Close;
      MyQuery.Free;
    end;
end;

procedure TFormMain.ListBox1Click(Sender: TObject);
begin
    if (ListBox1.ItemIndex >= 0) then
    begin
      GetPostes(ListBox1.Items[ListBox1.ItemIndex]);
      Edit4.Text := 'MAG'+IntToStr(ItemNumber)+'='+ListBox1.Items[ListBox1.ItemIndex];
    end;
end;

procedure TFormMain.ListBox2Click(Sender: TObject);
begin
  if (ListBox2.Itemindex >= 0) then
  begin
    Edit5.Text := 'POSTE'+IntToStr(ItemNumber)+'='+ListBox2.Items[ListBox2.ItemIndex];
  end;
end;

procedure TFormMain.ListBox3Click(Sender: TObject);
Var
 F: TextFile;
 lig: string;
begin
  if (ListBox3.ItemIndex >= 0) then
  begin
  assignfile(F, ListBox3.Items[ListBox3.ItemIndex]);
  Reset(F);
  Memo1.Clear;
  while not EOF(F) do
  begin
    Readln(F,lig);
    Memo1.Lines.Add(lig);
  end;
  closefile(F);
  GetExistingItems;
  end;
end;


procedure TFormMain.ChangeItem();
var
  I, L: Integer;
begin
  Edit3.Clear;
  ListBox2.Clear;
  ListBox1.Clear;
  Label1.Caption:='';
  ListBox1.ItemIndex:=-1;
  ListBox2.ItemIndex:=-1;
  I:= Pos('PATH'+IntToStr(ItemNumber), Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit3.Text := Memo1.Lines[L];
  end;
  Edit4.Clear;
  I:= Pos('MAG'+IntToStr(ItemNumber), Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit4.Text := Memo1.Lines[L];
  end;
  Edit5.Clear;
  I:= Pos('POSTE'+IntToStr(ItemNumber), Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit5.Text := Memo1.Lines[L];
  end;
  Edit6.Clear;
  I:= Pos('ITEM'+IntToStr(ItemNumber), Memo1.Text);
  if I > 0 then
  begin
    L := SendMessage(Memo1.Handle, EM_LINEFROMCHAR, I - 1, 0);
    Edit6.Text := Memo1.Lines[L];
  end;
end;

procedure TFormMain.Edit3Change(Sender: TObject);
var
  base: String;
begin
  base:=Edit3.Text;
  Delete(base,1,6);
  if length(edit3.text) <> 0 then
  begin
    DMMain.FDConnection1.Close();
    DMMain.FDConnection1.Params.Clear;
    DMMain.FDConnection1.Params.Add('Database='+base);
    DMMain.FDConnection1.Params.Add('User_Name=GINKOIA');
    DMMain.FDConnection1.Params.Add('Password=ginkoia');
    DMMain.FDConnection1.Params.Add('Protocol=TCPIP');
    DMMain.FDConnection1.Params.Add('DriverID=IB');
    try
      DMMain.FDConnection1.Open();
      if (DMMain.FDConnection1.Connected) then
      begin
        Button5.Visible := True;
        Label1.Font.Color:=clGreen;
        label1.Caption:='Base valide';
        GetItems;
        GetMags;
      end;
    except On E:EIBNativeException
      do
        begin
         Button5.Visible := false;
          Label1.Font.Color:=clRed;
          label1.Caption:='La Base : '+base+' n''existe pas : ' + IntToStr(E.ErrorCode);
        end;
    end;
  end;
end;

procedure TFormMain.SpeedButtonClick(Sender: TObject);
begin
  ItemNumber:=TSpeedButton(Sender).Tag;
  ChangeItem();
end;

end.
