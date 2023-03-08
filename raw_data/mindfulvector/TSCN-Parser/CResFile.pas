unit CResFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  JvExExtCtrls, JvExtComponent, JvPanel,
  System.Generics.Collections, System.IniFiles, Vcl.StdCtrls;


type
  TResFile = class(TFrame)
    ress: TStaticText;
    lst1: TListBox;
  protected
  private
{ Private declarations }
    { contains all directives such as [gd_resource ...]: }
    directives: THashedStringList;
    { contains all directive hashes as keys and all attributes as key=values in
      the corresponding THashedStringList: }
    directiveAttrs: TDictionary<string, THashedStringList>;
    { contains all values for each directive in a map like so:
      <directive_hash>/<value_key>=<value>                    }
    values: THashedStringList;
  public
    { Public declarations }
    function LoadFromFile(AFile: string): boolean;
    function SaveToFile(AFile: string): boolean;
    { fetch a list of all directives, with keys like:
        .hash=<hash of entire directive>
        .name=<first word of directive>
        attr1=attr
        attr2=attr
      the .hash value can be used to fetch a list of values from the directive
      }
    function GetListOfDirectives(): TList<THashedStringList>;
    { get the attributes from a particular directive hash }
    function GetDirectiveAttributes(ADirectiveHash: string): THashedStringList;
    { get all directive hashes that match a particular name }
    function GetDirectivesHashesWithName(ADirectiveName: string): TStringList;
    { fetch all array elements from a directive, optionally filtered by a key
    suffix. for instance you could filter to only get 0/name, 1/name, ... by
    passing '/name"' as the suffix. }
    function GetListOf(ADirectiveHash, AKeySuffix: string): THashedStringList;
  end;

implementation

{$R *.dfm}

uses
 System.Hash;

{ format supported:

[a_directive_node attr1="One" attr99=attr99 attr100=100]

[directive_name attribute1="Value 1" attribute2="Value 2" attribute3=333]

simple_value_key=simple value
quoted_value_key="Quoted value"
0/array_value_key="Value for array index 0 named array_value_key"
0/another_array_key="Another value for index 0 named another_array_key"
1/array_value_key="Value for array index 1 named array_value_key"
1/another_array_key="Another value for index 1 named another_array_key"
}
function TResFile.LoadFromFile(AFile: string): boolean;
var
  baseIni: TIniFile;
  lines: TStringList;
  sections: TStringList;
  i: Integer;
  hash, sectionName: string;
begin
  directives := THashedStringList.Create;
  directiveAttrs := TDictionary<string, THashedStringList>.Create;
  values := THashedStringList.Create;

  lines := TStringList.Create;
  try
    lines.LoadFromFile(AFile);
    if lines.Count > 0 then
    begin
      sections := TStringList.Create;
      try
      // 0. Find all directive lines so we have sections to ask for
      for i := 0 to lines.Count-1 do
      begin
        lines[i] := lines[i].Trim;
        // If line starts with [ and ends with ]
        if (lines[i].Substring(0, 1).Equals('[')) and
           (lines[i].Substring(lines[i].Length-1, 1).Equals(']')) then
        begin
          // Get part inside the [square brackets]  and add it as a section name
          sections.Add(lines[i].Substring(1, lines[i].Length-2));
        end;
      end;

      // 1. Load file as INI format file
      baseIni := TIniFile.Create(AFile);
      // 2. Loop over sections to find directives
      for i := 0 to sections.Count-1 do
      begin
        // 3. Insert into directives THashedStringList in format:
        //      <hash of full section name>=<name of directive (first word)>
        hash := THashSHA2.GetHashString(sections[i]);
        sectionName := sections[i].Substring(0, sections[i].IndexOf(' '));

        directives.AddPair(hash, sectionName);
        lst1.AddItem(hash + '=' + sectionName + ':', nil);
        lst1.AddItem(sections[i], nil);
      end;

      // 4. Parse all attributes of the directive as INI file format by:
      //      1. preparse to replace spaces between attr=value or attr="value" tags
      //         with new line characters
      //      2. pass result new text to INI parser
      //      3. save key=value pairs to THashedStringList stored with hash of
      //         directive in dictionary
      // 5. Loop over values for each directive's section
      // 6. In order to allow for retreval by <directive_hash> prefix,
      //    insert values into values THashedStringList in format:
      //      <directive_hash>.<value_key>=<value>

      finally
        sections.Destroy;
        sections := nil;
      end;
    end;
  finally
    lines.Destroy;
    lines := nil;
  end;
end;

function TResFile.SaveToFile(AFile: string): boolean;
begin

end;

{ fetch a list of all directives with special keys for .hash and .name }
function TResFile.GetListOfDirectives: TList<THashedStringList>;
begin

end;

{ fetch a hash map of directive attributes for a particular hash }
function TResFile.GetDirectiveAttributes(ADirectiveHash: string): THashedStringList;
begin

end;

{ fetch a list of all directive hashes that have a particular name (e.g. the
  first word of the directive matches this value, case insensitive ) }
function TResFile.GetDirectivesHashesWithName(ADirectiveName: string): TStringList;
begin

end;

{ fetch all array elements from a directive, optionally filtered by a key suffix }
function TResFile.GetListOf(ADirectiveHash, AKeySuffix: string): THashedStringList;
begin

end;

end.
