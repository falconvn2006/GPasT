unit GestionLog;

interface

type
  TErrorLevel = (el_Silent, el_Erreur, el_Warning, el_Info, el_Etape, el_Debug, el_Verbose);


procedure Log_Init(niv : TErrorLevel; Path : string);
procedure Log_ChangeNiv(niv : TErrorLevel);
procedure Log_Write(msg : string; niv : TErrorLevel = el_Debug);
procedure Log_WriteFmt(const msg: string; const args: array of const; const niv: TErrorLevel);

implementation

uses
  SysUtils,
  TypInfo;

var
  LogNiv : TErrorLevel = el_silent;
  LogPath : string = '';

procedure Log_Init(Niv : TErrorLevel; Path : string);
begin
  LogNiv := niv;
  LogPath := Path;
end;

procedure Log_ChangeNiv(niv : TErrorLevel);
begin
  LogNiv := niv;
end;

procedure Log_Write(msg : string; niv : TErrorLevel);
var
  FileName : string;
  Fichier : TextFile;
begin
  try
    {$I-}
    if niv <= LogNiv then
    begin
      try
        ForceDirectories(LogPath);
        FileName := LogPath + FormatDateTime('yyyy-mm-dd', Now()) +  '.log';
        AssignFile(Fichier, FileName);
        if FileExists(FileName) then
          Append(Fichier)
        else
          Rewrite(Fichier);
        Writeln(Fichier, Format('%s - %7s - %s', [FormatDateTime('hh:nn:ss.zzz', Now()), Copy(GetEnumName(TypeInfo(TErrorLevel), ord(niv)), 4, 7), msg]));
      finally
        CloseFile(Fichier);
      end;
    end;
  except
      // rien on arrive pas a ecrire c'est tout
  end;
end;

procedure Log_WriteFmt(const msg: string; const args: array of const; const niv: TErrorLevel);
begin
  Log_Write( Format( msg, args ), niv );
end;

end.
