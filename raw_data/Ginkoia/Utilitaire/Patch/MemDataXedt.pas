unit MemDataXedt;

interface

uses
   IpUtils, IpSock, IpHttp,
   MemDataX,
   Db, dxmdaset,
   IpHttpClientGinkoia,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, ComCtrls, CheckLst,DesignEditors, DesignIntf;

type
   TDial_Memedt = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      Bevel1: TBevel;
      PageControl1: TPageControl;
      req: TTabSheet;
      mem: TMemo;
      chp: TTabSheet;
      Button1: TButton;
      TabSheet1: TTabSheet;
      Memo1: TMemo;
      Lb: TCheckListBox;
      TabSheet2: TTabSheet;
      Label1: TLabel;
      Label2: TLabel;
      ed_table: TEdit;
      ed_id: TEdit;
      Edit1: TEdit;
      procedure Button1Click(Sender: TObject);
      procedure OKBtnClick(Sender: TObject);
      procedure CancelBtnClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
   private
    { Private declarations }
      MemX: TMemDataX;
      FormDesigner: IDesigner;
      HTTP: TIpHttpClientGinkoia;
   public
    { Public declarations }
      procedure init(MemX: TMemDataX; Form: IDesigner);
   end;

var
   Dial_Memedt: TDial_Memedt;

implementation

{$R *.DFM}

procedure TDial_Memedt.Button1Click(Sender: TObject);
var
   S: string;
   i: Integer;
   nbchamps: Integer;
   tpe: string;
   AField: Tfield;
   List: TParams;
begin
   Memo1.lines.clear;

   List := TParams.Create(Self);
   S := List.ParseSQL(mem.lines.Text, true);
   List.Free;
   if pos(#0, S) > 0 then
      S := Copy(S, 1, pos(#0, S) - 1);
   while Pos('?', S) > 0 do
   begin
      i := Pos('?', S);
      delete(S, i, 1);
      insert('NULL', S, i);
   end;
   if pos('LIMIT', Uppercase(S)) = 0 then
      S := S + ' LIMIT 1';
   S := Memx.Traitechaine(S);
   if Http.OldGetWaitTimeOut(MemX.Lapage + 'Query=' + S, 30000) then
   begin
      Memo1.lines.text := Http.AsString(MemX.Lapage + 'Query=' + S);
      if Copy(Memo1.lines[0], 1, 6) <> 'ERREUR' then
      begin
         nbchamps := Strtoint(Memo1.lines[0]);
         for i := 1 to nbchamps do
         begin
            S := Memo1.lines[i];
            tpe := Copy(S, pos(';', S) + 1, 255);
            tpe := Copy(tpe, 1, pos(';', tpe) - 1);
            if lb.Items.IndexOf(tpe) < 0 then
            begin
               tpe := Copy(S, pos(';', S) + 1, 255);
               system.delete(tpe, 1, pos(';', tpe));
               if copy(tpe, 1, 3) = 'int' then
               begin
                  AField := memX.GetFieldClass(ftinteger).Create(nil);
               end
               else if copy(tpe, 1, 8) = 'datetime' then
               begin
                  AField := memX.GetFieldClass(ftdatetime).Create(Self);
               end
               else if copy(tpe, 1, 8) = 'tinytext' then
               begin
                  AField := memX.GetFieldClass(ftString).Create(Self);
                  AField.Size := 1024;
               end
               else if copy(tpe, 1, 7) = 'varchar' then
               begin
                  AField := memX.GetFieldClass(ftString).Create(nil);
                  system.delete(tpe, 1, pos('(', tpe));
                  tpe := copy(tpe, 1, pos(')', tpe) - 1);
                  AField.Size := strtoint(tpe);
               end
               else if copy(tpe, 1, 7) = 'decimal' then
               begin
                  AField := memX.GetFieldClass(ftFloat).Create(nil);
               end
               else if copy(tpe, 1, 6) = 'double' then
               begin
                  AField := memX.GetFieldClass(ftFloat).Create(nil);
               end
               else
               begin
                  AField := memX.GetFieldClass(ftString).Create(nil);
                  AField.Size := 255;
               end;
               with AField do
               begin
                  tpe := Copy(S, pos(';', S) + 1, 255);
                  tpe := Copy(tpe, 1, pos(';', tpe) - 1);
                  FieldName := tpe;
                  DataSet := nil;
                  Name := Name + tpe;
                  Calculated := False;
               end;
               lb.Items.AddObject(AField.FieldName, Afield);
               lb.checked[lb.Items.Count - 1] := true;
            end;
         end;
      end
      else
      begin
         Application.messagebox('Erreur sur la requête', 'Erreur', Mb_Ok);
      end;
   end
   else
   begin
      Memo1.lines.add('ERREUR connexion au serveur');
      Memo1.lines.add(MemX.Lapage + 'Query=' + S);
      Application.messagebox('Erreur de connexion au serveur', 'Erreur', Mb_Ok);
   end;
end;

procedure TDial_Memedt.init(MemX: TMemDataX; Form: IDesigner);
var
   i: integer;
begin
   HTTP := TIpHttpClientGinkoia.create(nil);
   Self.memX := MemX;
   FormDesigner := Form;
   mem.Lines.assign(MemX.sql);
   for i := 0 to MemX.FieldCount - 1 do
   begin
      lb.items.addObject(MemX.Fields[i].fieldname, MemX.Fields[i]);
      lb.checked[i] := true;
   end;
   ed_table.Text := Memx.TableMaitre;
   ed_id.Text := Memx.IndexMaitre;
   Edit1.text := Memx.LaPage;
end;

procedure TDial_Memedt.OKBtnClick(Sender: TObject);
var
   i: integer;
   AField: Tfield;
begin
   memX.Sql := mem.Lines;
   for i := 3 to lb.items.count - 1 do
   begin
      if lb.Checked[i] then
      begin
         if Tfield(lb.Items.Objects[i]).DataSet = nil then // création
         begin
            Afield := memX.GetFieldClass(Tfield(lb.Items.Objects[i]).DataType).Create(Memx.Owner);
            Afield.Size := Tfield(lb.Items.Objects[i]).size;
            Afield.FieldName := Tfield(lb.Items.Objects[i]).FieldName;
            Afield.DataSet := Memx;
            Afield.Name := Memx.Name + Tfield(lb.Items.Objects[i]).FieldName;
            Afield.Calculated := Tfield(lb.Items.Objects[i]).Calculated;
         end;
      end;
   end;
   for i := lb.items.count - 1 downto 3 do
   begin
      if not (lb.Checked[i]) then
      begin
         if Tfield(lb.Items.Objects[i]).DataSet <> nil then // destruction
         begin
            memX.Fields[i].free;
         end;
      end;
   end;
   memx.TableMaitre := ed_table.Text;
   memx.IndexMaitre := ed_id.Text;
   FormDesigner.Modified;
   for i := 3 to lb.items.count - 1 do
   begin
      if Tfield(lb.Items.Objects[i]).DataSet = nil then
         Tfield(lb.Items.Objects[i]).free;
   end;
end;

procedure TDial_Memedt.CancelBtnClick(Sender: TObject);
var
   i: integer;
begin
   for i := 1 to lb.items.count - 1 do
   begin
      if Tfield(lb.Items.Objects[i]).DataSet = nil then
         Tfield(lb.Items.Objects[i]).free;
   end;
end;

procedure TDial_Memedt.FormDestroy(Sender: TObject);
begin
   HTTP.free;
end;

end.

