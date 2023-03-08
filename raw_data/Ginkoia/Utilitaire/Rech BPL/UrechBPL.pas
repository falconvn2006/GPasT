//$Log:
// 2    Utilitaires1.1         15/06/2005 17:19:36    pascal          Oublis
//      d'ajouter l'ent?te
// 1    Utilitaires1.0         15/06/2005 16:58:53    pascal          
//$
//$NoKeywords$
//
unit UrechBPL;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls;

type
   TForm1 = class(TForm)
      Edit1: TEdit;
      Label1: TLabel;
      Button1: TButton;
      LbR: TListBox;
      Button2: TButton;
      LbT: TListBox;
      Label2: TLabel;
      Button3: TButton;
      Lab_etat: TLabel;
      pb: TProgressBar;
      procedure Button1Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
   S: string;
begin
   S := Uppercase(trim(edit1.text));
   if pos('.', s) > 0 then
      S := Copy(S, 1, pos('.', S)-1);
   if (S <> '') and (lbR.Items.IndexOf(S) < 0) then
   begin
      lbR.Items.Add(S);
   end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   lbR.Items.clear;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   i: integer;
   lesdpk: tstringlist;
   procedure Init(Path: string);
   var
      f: tsearchrec;

   begin
      if findfirst(Path + '*.*', faAnyFile, F) = 0 then
      begin
         repeat
            if Copy(f.name, 1, 1) <> '.' then
            begin
               if f.Attr and fadirectory = fadirectory then
                  init(path + f.name + '\')
               else
               begin
                  if uppercase(extractfileext(f.name)) = '.DPK' then
                     LesDpk.add(path + f.name);
               end;
            end;
         until findnext(f) <> 0;
      end;
   end;
   procedure recherche(fichier: string);
   var
      i: integer;
      j: integer;
      s: string;
      tsl: tstringlist;
   begin
      if lesdpk = nil then
      begin
         lab_etat.caption := 'Initialisation '; lab_etat.Update;
         lesdpk := Tstringlist.create;
         init('C:\Developpement\Ginkoia\Paquets standards\');
         init('C:\Developpement\Ginkoia\Source\Paquets\');
         init('C:\Developpement\Ginkoia\Source\Caisse\Paquets\');
      end;
      lab_etat.caption := 'Recherche de ' + fichier; lab_etat.Update;
      pb.position := 0; pb.max := lesdpk.Count;
      tsl := tstringlist.create;
      S := '';
      for i := 0 to lesdpk.Count - 1 do
      begin
         pb.position := i + 1;
         tsl.loadfromfile(lesdpk[i]);
         for j := 0 to tsl.count - 1 do
         begin
            S := Uppercase(tsl[j]);
            if pos(' IN ', S) > 0 then
            begin
               delete(S, 1, pos('''', S));
               S := Copy(S, 1, pos('''', S) - 1);
               S := ExtractFileName(S);
               S := Copy(S, 1, pos('.', S) - 1);
               if S = fichier then
               begin
                  LbT.items.add(lesdpk[i]);
                  BREAK;
               end;
            end;
         end;
         if S = fichier then
            BREAK;
      end;
      if S <> fichier then
         LbT.items.add('PAS TROUVE');
      tsl.free;
      pb.position := 0;
   end;
begin
   lbt.items.Clear;
   lesdpk := nil;
   for i := 0 to LbR.Items.count - 1 do
   begin
      recherche(LbR.Items[i]);
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Lab_etat.caption := '';
end;

end.

