Function mFileToStr(Ruta: string): string;
var
sFile: HFile;
uBytes: Cardinal;
begin
sFile:= _lopen(PChar(Ruta), OF_READ);
uBytes:= GetFileSize(sFile, nil);
SetLength(Result, uBytes);
_lread(sfile, @result[1], uBytes);
_lclose(sFile);
end;

Procedure mWriteFileFromStr(Ruta,Cadena: ansistring);
var
 sFile: HFile;
 uBytes: Cardinal;
begin
 sFile := _lcreat(PansiChar(Ruta), 0);
 uBytes := Length(Cadena);
 _lwrite(sFile, @Cadena[1], uBytes);
 _lclose(sFile);
end;
