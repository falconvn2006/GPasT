unit Frm_checkBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Btn_Check: TButton;
    procedure Btn_CheckClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure verification_des_batch;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  if Uppercase(paramstr(1)) = '/AUTO' then
  begin
    verification_des_batch ;
    Application.Terminate ; 
  end;
end;

procedure TForm1.verification_des_batch;
var
  S: string;
  S1: string;
  S2, S3, S4: string;
  SS: string;
  i: integer;
  F: TSearchRec;
  tsl: tstringlist;
  prem: boolean;
begin
  Btn_Check.Caption := 'En cours ...' ;
  Btn_Check.Enabled := false ;
  try
    S := ExtractFileDrive(paramstr(0));
    S := Copy(S, 1, 1) + ':\GINKOIA\BATCH\';
    if FindFirst(S + '*.bat', faanyfile, f) = 0 then
    begin
      repeat
        if Uppercase(extractfileext(F.Name)) = '.BAT' then
        begin
          fileSetAttr(S + f.Name, 0);
          tsl := tstringlist.Create;
          tsl.LoadFromFile(S + f.Name);

          prem := true;
          SS := '';
          for i := 0 to tsl.count - 1 do
          begin
            S1 := tsl[i];
            if prem and (Pos('CMDSYNC.EXE', Uppercase(S1)) > 0) then
            begin
              prem := false;
              // découpon en 4 partie
              S2 := Copy(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
              // s2 -> \\serveur\c\ginkoia\filesync\cmdsync.exe
              delete(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
              S3 := trim(Copy(S1, 1, Pos(' ', S1)));
              // S3 -> "\\serveur\c\ginkoia\bpl"
              Delete(S1, 1, Pos(' ', S1));
              S4 := trim(Copy(S1, 1, Pos(' ', S1)));
              // S4 -> "*.*"
              Delete(S1, 1, Pos(' ', S1));
              // S1 = "d:\ginkoia\bpl" /S
              if pos('/S', S1) > 0 then
                S1 := trim(Copy(S1, 1, pos('/S', S1) - 1));
              if pos('/D', S1) > 0 then
                S1 := trim(Copy(S1, 1, pos('/D', S1) - 1));
              // S1 = "d:\ginkoia\bpl"
              SS := trim(S2) + ' ';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe
              while pos('"', S3) > 0 do
                delete(S3, pos('"', S3), 1);
              S3 := Uppercase(S3);
              S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
              S3 := S3 + '\DOCUMENTS';
              SS := SS + '"' + S3 + '" "*.*" ';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*"
              S3 := Uppercase(S1);
              while pos('"', S3) > 0 do
                delete(S3, pos('"', S3), 1);
              S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
              S3 := S3 + '\DOCUMENTS';
              SS := SS + '"' + S3 + '" /D';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*" "d:\ginkoia\images" /S
            end;
            if pos('DOCUMENTS', Uppercase(TSL[I])) > 0 then
            begin
              SS := '';
              BREAK;
            end;
          end;
          if ss <> '' then
            tsl.insert(2, SS);

          // doit on ajouter la ligne ?
          if pos('\GINKOIA" "*.DLL" ', UpperCase(tsl.text)) < 1 then
          begin
            for i := 0 to tsl.Count -1 do
            begin
              if Pos('\GINKOIA" "*.EXE" ', UpperCase(tsl[i])) > 0 then
              begin
                tsl.Insert(i +1, '');
                tsl.Insert(i +2, StringReplace(tsl[i], '"*.exe"', '"*.dll"', [rfIgnoreCase]));
                break;
              end;
            end;
          end;

          // Correction des conneries du Deploy
          for i := 0 to tsl.count - 1 do
          begin
            S1 := tsl[i];
            if (Pos('CMDSYNC.EXE', Uppercase(S1)) > 0) then
            begin
              if (Pos('\GINKOIA\DATA', Uppercase(S1)) > 0) then
              begin
                tsl[i] := StringReplace(tsl[i], '\GINKOIA\DATA', '\GINKOIA', [rfIgnoreCase]) ;
              end;
            end;
          end;

          Filesetattr(S + f.Name, 0);
          try
            tsl.SaveToFile(S + f.Name);
          except
          end;
          tsl.free;
        end;
      until findnext(f) <> 0
    end;
    findclose(f);
  except
  end;
  Btn_Check.Caption := 'Démarrer' ;
  Btn_Check.Enabled := true ;
end;


procedure TForm1.Btn_CheckClick(Sender: TObject);
begin
  verification_des_batch ;
end;

end.
