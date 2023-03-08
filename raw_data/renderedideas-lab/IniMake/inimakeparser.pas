unit IniMakeParser;

{$mode ObjFPC}{$H+}

interface

procedure StartParse(const FileName, StartEntry: String);

implementation

uses IniFiles, Process, SysUtils, Classes;

const
  Section_Rules = '&Rules';
  Section_Include = '&Include';

  KeyBeginning_Command = '@';
  KeyBeginning_Rule = '$';
  KeyBeginning_Include = '!';

function GetRule(Rule: String; I: TIniFile): String;
var counter, number: integer; SectionStrings: TStringList; Tempi: TIniFile;
begin
  Result:=Rule;

  if I.ValueExists(Section_Rules,Rule) then
  begin
    Result:=I.ReadString(Section_Rules,Rule,'');
    exit;
  end else
  begin
    if I.SectionExists(Section_Include) then
    begin
      SectionStrings:=TStringList.Create;
      try
        I.ReadSection(Section_Include,SectionStrings);
        number:=1;
        for counter:=0 to SectionStrings.Count-1 do
        begin

          if I.ValueExists(Section_Include,KeyBeginning_Include+Inttostr(number)) then
          begin
            if FileExists(I.ReadString(Section_Include,KeyBeginning_Include+Inttostr(number),'')) then
            begin
              TempI:=TIniFile.Create(I.ReadString(Section_Include,KeyBeginning_Include+Inttostr(number),''));
              try
                Result:=GetRule(Rule,TempI);
              finally
                TempI.Free;
              end;
            end;
          end;

          inc(number);
        end;
      finally
        SectionStrings.Free;
      end;
    end;
  end;
end;

function ParseExternalExecutionString(Input: String; I: TIniFile): String;
var position: integer;
begin
  Result:=Input;

  Input:=Input+' ';
  position:=1;

  while position<=length(input) do
  begin
    if input[position]=KeyBeginning_Rule then
    begin
      input:=StringReplace(input,input[position..Pos(' ',input,position)-1],GetRule(input[position..Pos(' ',input,position)-1],I),[rfReplaceAll]);
    end;
    inc(position);
  end;

  Result:=Input;
end;

procedure ParseEntry(const Entry: String; I: TIniFile);
var counter, number: Integer; SectionStrings: TStringList; P: TProcess;
begin
  if I.SectionExists(Entry) then
  begin
    SectionStrings:=TStringList.Create;
    try
      I.ReadSection(Entry,SectionStrings);
      number:=1;
      for counter:=0 to SectionStrings.Count-1 do
      begin

        // Command Stuff
        if I.ValueExists(Entry,KeyBeginning_Command+Inttostr(number)) then
        begin
          // if command is another block
          if I.SectionExists(I.ReadString(Entry,KeyBeginning_Command+Inttostr(number),'')) then
          begin
            // Recursive Execution
            ParseEntry(I.ReadString(Entry,KeyBeginning_Command+Inttostr(number),''),I);
          end else
          // Command is an Executable String
          begin
            P:=TProcess.Create(nil);
            try
              P.CommandLine:=ParseExternalExecutionString(I.ReadString(Entry,KeyBeginning_Command+Inttostr(number),''),I);
              P.Options:=P.Options + [poWaitOnExit];
              P.Execute;
            finally
              P.Free;
            end;
          end;

          inc(number);
        end else
        begin
          raise Exception.Create('Error ['+Entry+']: Command '+Inttostr(number)+' not found.');
        end;

      end;
    finally
      SectionStrings.Free;
    end;
  end else
  begin
    raise Exception.Create('Error ['+Entry+']: Does not exist.');
  end;
end;

procedure StartParse(const FileName, StartEntry: String);
var I: TIniFile;
begin
  I:=TIniFile.Create(FileName);
  try
    ParseEntry(StartEntry,I);
  finally
    I.Free;
  end;
end;

end.

