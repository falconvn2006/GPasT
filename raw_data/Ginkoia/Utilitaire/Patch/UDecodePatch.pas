//$Log:
// 2    Utilitaires1.1         08/08/2005 09:03:34    pascal          Divers
//      modifications suite aux demandes de st?phanes
// 1    Utilitaires1.0         27/04/2005 10:41:27    pascal          
//$
//$NoKeywords$
//
unit UDecodePatch;

interface
uses
   Windows,
   FileCtrl,
   Sysutils,
   Classes;

const
   CstNoErr = $0000;
   CstErrCRCDest = $0001;
   CstErrMAJDate = $0002;
   CstErrSauve = $0004;
   CstErrPatch = $0008;
   CstErrTaille = $0010;
   CstErrtot = CstErrCRCDest + CstErrMAJDate + CstErrSauve + CstErrPatch;
   CstTypeCopy = $1000;
   CstTypePareil = $2000;
   CstTypeMAJ = $4000;
   CstTypeSUP = $8000;
   CstTypeInconnue = $FFFF;

type
   TPatchNotify = procedure(T_Actu, T_Tot: Integer) of object;
   TFileNotify = procedure(Fichier: string) of object;
   TFileCopy = function(FichierS, FichierD: string): Boolean of object;

function Depatch(TS: TStream; RepSec, RepD: string; Progress: TPatchNotify; FichNot: TFileNotify; _Copy: TFileCopy; LesEai: TstringList): Integer;
function ReadString(TS: TStream): string;
function VerifieLeCRC(Ts: TStream; RepD: string; FichNot: TFileNotify): Integer;
function FileCRC32(FileName: string): LongWord;

implementation
const
   Crc32Tab: array[0..$FF] of LongWord =
      ($00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F,
      $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
      $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2,
      $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
      $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9,
      $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
      $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C,
      $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
      $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423,
      $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
      $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106,
      $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
      $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D,
      $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
      $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950,
      $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
      $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7,
      $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
      $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA,
      $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
      $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81,
      $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
      $EAD54739, $9DD277AF, $04DB2615, $73DC1683, $E3630B12, $94643B84,
      $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
      $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB,
      $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
      $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E,
      $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
      $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55,
      $316E8EEF, $4669BE79, $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
      $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28,
      $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
      $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F,
      $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
      $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242,
      $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
      $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69,
      $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
      $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
      $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
      $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693,
      $54DE5729, $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
      $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

function CRC32(Buffer: Pchar; Longeur: Integer): LongWord;
var
   i: integer;
   Bl: Byte;
begin
   result := $FFFFFFFF;
   for i := 0 to Longeur - 1 do
   begin
      Bl := result and $FF;
      Bl := BL xor Ord(Buffer[i]);
      result := result shr 8;
      result := result xor Crc32Tab[BL];
   end;
end;

function FileCRC32(FileName: string): LongWord;
var
   p: PChar;
   FSize: LongInt;
   Handle: Integer;
begin
   result := 0;
   Filesetattr(filename, 0);
   Handle := FileOpen(FileName, fmOpenRead + fmShareDenyNone);
   if Handle = -1 then
      Exception.Create('Problème d''ouverture de ' + FileName);
   FSize := FileSeek(Handle, 0, 2);
   if FSize > 0 then
   begin
      FileSeek(Handle, 0, 0);
      GetMem(p, FSize + 100);
      FileRead(Handle, P[0], FSize);
      Result := CRC32(p, FSize);
      FreeMem(p, FSize + 100);
   end;
   FileClose(Handle);
end;

function ReadString(TS: TStream): string;
var
   B: Byte;
begin
   ts.read(b, sizeof(b));
   SetLength(Result, B);
   TS.Read(Pointer(Result)^, B);
end;

type
   tUneVal = array[0..3] of byte;

function LaTaille(TS: Tstream): Dword;
var
   V: TUneVal;
   _b: Byte;
   _c: byte;
begin
   fillchar(v, sizeof(v), #00);
   ts.read(_b, sizeof(_b));
   _c := _b and $C0;
   _b := _b and $3F;
   if _c = 0 then
      v[0] := _b
   else if _c = $40 then
   begin
      v[1] := _b;
      ts.read(_b, sizeof(_b));
      v[0] := _b;
   end
   else if _c = $80 then
   begin
      v[2] := _b;
      ts.read(_b, sizeof(_b));
      v[1] := _b;
      ts.read(_b, sizeof(_b));
      v[0] := _b;
   end
   else
   begin
      v[3] := _b;
      ts.read(_b, sizeof(_b));
      v[2] := _b;
      ts.read(_b, sizeof(_b));
      v[1] := _b;
      ts.read(_b, sizeof(_b));
      v[0] := _b;
   end;
   move(V, result, 4);
end;

// Modification du fichiers avec copy de secours

function VerifieLeCRC(Ts: TStream; RepD: string; FichNot: TFileNotify): Integer;
var
   _tipe: Byte;
   LaDate: Integer;
   CRC2: DWORD;
   CRC1: DWORD;
   CRC: DWORD;
   Fichier: string;
begin
   Result := CstNoErr;
   Ts.Seek(0, soFromBeginning);
   Ts.Read(_tipe, Sizeof(_tipe));
   Fichier := ReadString(TS);
   if assigned(FichNot) then
      FichNot(Fichier);
   if _Tipe = 0 then
   begin
        //Copie directe
      Result := Result + CstTypeCopy;
   end
   else if _Tipe = 8 then // Pareil ;
   begin
      Result := Result + CstTypePareil;
      TS.Read(LaDate, Sizeof(Ladate));
      TS.Read(CRC1, Sizeof(CRC1));
      CRC := FileCRC32(RepD + Fichier);
      if CRC <> CRC1 then
         result := result + CstErrCRCDest
   end
   else if _Tipe = 2 then // MAJ ;
   begin
      Result := Result + CstTypeMAJ;
      TS.Read(LaDate, Sizeof(Ladate));
      TS.Read(CRC2, Sizeof(CRC2));
      TS.Read(CRC1, Sizeof(CRC1));
      CRC := FileCRC32(RepD + Fichier);
      if CRC1 <> CRC then
         result := result + CstErrCRCDest
   end
   else if _Tipe = 4 then // Suppression ;
   begin
      result := CstTypeSUP;
   end
   else
      result := CstTypeInconnue;
end;

function Depatch(TS: TStream; RepSec, RepD: string; Progress: TPatchNotify; FichNot: TFileNotify; _Copy: TFileCopy; LesEai: TstringList): Integer;
var
   _tipe: Byte;
   fichier: string;
   TailleFinal: Integer;
   LaDate: Integer;
   CRC2: DWORD;
   CRC1: DWORD;
   CRC: DWORD;
   TmNew: TmemoryStream;
   TmOld: TmemoryStream;

   Handle: THandle;
   _byte: Byte;
   _Dword: DWORD;
   Lad: Dword;

   I: Integer;
begin
   try
      Result := CstNoErr;
      Ts.Seek(0, soFromBeginning);
      Ts.Read(_tipe, Sizeof(_tipe));
      Fichier := ReadString(TS);
      if assigned(FichNot) then
         FichNot(Fichier);
      if _Tipe = 0 then
      begin
        //Copie directe
         Result := Result + CstTypeCopy;
         TS.Read(LaDate, Sizeof(Ladate));
         TS.Read(CRC1, Sizeof(CRC1));
         TailleFinal := LaTaille(TS);
         TmNew := Tmemorystream.Create;
         try
            TmNew.CopyFrom(Ts, TailleFinal);
            forcedirectories(extractFilePath(RepD + Fichier));
            TmNew.Savetofile(RepD + Fichier);
         finally
            TmNew.Free;
         end;
         CRC := FileCRC32(RepD + Fichier);
         if CRC <> CRC1 then
            Result := Result + CstErrCRCDest
         else
         begin
            Handle := FileOpen(RepD + Fichier, fmOpenReadWrite);
            if FileSetDate(Handle, LaDate) <> 0 then
               Result := Result + CstErrMAJDate;
            FileClose(Handle);
         end;

         if result and CstErrtot = CstNoErr then
         begin
            if Uppercase(Copy(fichier, 1, 4)) = 'EAI\' then
            begin
               for i := 0 to LesEai.count - 1 do
               begin
                  if (trim(LesEai[i]) <> '') and (uppercase(LesEai[i]) <> RepD + 'EAI\') then
                  begin
                     ForceDirectories(ExtractFilePath(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)));
                     CopyFile(Pchar(RepD + Fichier),
                        Pchar(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)),
                        False);
                  end;
               end;
            end;
         end;
      end
      else if _Tipe = 8 then // Pareil ;
      begin
         Result := Result + CstTypePareil;
         if result and CstErrSauve <> CstErrSauve then
         begin
            TS.Read(LaDate, Sizeof(Ladate));
            TS.Read(CRC1, Sizeof(CRC1));
            CRC := FileCRC32(RepD + Fichier);
            if CRC <> CRC1 then
               result := result + CstErrCRCDest
            else
            begin
               try
                  Handle := FileOpen(RepD + Fichier, fmOpenReadWrite);
                  try
                     if FileSetDate(Handle, LaDate) <> 0 then
                        result := result + CstErrMAJDate;
                  except
                  end;
                  FileClose(Handle);
               except
               end;
            end;
            if result and CstErrtot = CstNoErr then
            begin
               if result and CstErrtot = CstNoErr then
               begin
                  if Uppercase(Copy(fichier, 1, 4)) = 'EAI\' then
                  begin
                     for i := 0 to LesEai.count - 1 do
                     begin
                        if (trim(LesEai[i]) <> '') and (uppercase(LesEai[i]) <> RepD + 'EAI\') then
                        begin
                           ForceDirectories(ExtractFilePath(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)));
                           CopyFile(Pchar(RepD + Fichier),
                              Pchar(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)),
                              False);
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end
      else if _Tipe = 2 then // MAJ ;
      begin
         Result := Result + CstTypeMAJ;
         forcedirectories(extractFilePath(RepSec + Fichier));
         if (Assigned(_Copy)) then
         begin
            if not _Copy(RepD + Fichier, RepSec + Fichier) then
               result := result + CstErrSauve;
         end
         else if not CopyFile(Pchar(RepD + Fichier), Pchar(RepSec + Fichier), False) then
         begin
            result := result + CstErrSauve;
         end;

         if assigned(FichNot) then
            FichNot(Fichier);
         if result and CstErrSauve <> CstErrSauve then
         begin
            TS.Read(LaDate, Sizeof(Ladate));
            TS.Read(CRC2, Sizeof(CRC2));
            TS.Read(CRC1, Sizeof(CRC1));
            TailleFinal := LaTaille(TS);
            if Assigned(Progress) then
               Progress(0, TailleFinal);

            CRC := FileCRC32(RepD + Fichier);
            if CRC1 <> CRC then
               result := result + CstErrCRCDest
            else
            begin
               TmOld := TmemoryStream.Create;
               TmNew := Tmemorystream.Create;
               TmOld.LoadFromFile(RepD + Fichier);
               try
                  while TS.Read(_byte, sizeof(_byte)) > 0 do
                  begin
                     if Assigned(Progress) then
                        Progress(TmNew.Size, TailleFinal);
                     if _Byte = 0 then
                     begin
                            // Copier les données
                        _Dword := LaTaille(TS);
                        if _Dword = 0 then
                        begin
                           result := result + CstErrPatch;
                           BREAK;
                        end;
                        TmNew.CopyFrom(ts, _Dword);
                     end
                     else if _Byte = 1 then
                     begin
                            // on prend l'ancien
                        _Dword := LaTaille(Ts);
                        lad := LaTaille(Ts);
                        TmOld.Seek(Lad, soFromBeginning);
                        TmNew.CopyFrom(TmOld, _Dword);
                     end
                     else
                     begin
                        result := result + CstErrPatch;
                        BREAK;
                     end;
                  end;
               except
                  result := result + CstErrPatch;
               end;
               if result = CstTypeMAJ then
               begin
                  TmNew.savetofile(RepD + Fichier);
                  if tmnew.size <> TailleFinal then
                  begin
                     result := result + CstErrTaille;
                  end
                  else
                  begin
                     CRC := FileCRC32(RepD + Fichier);
                     if CRC2 <> CRC then
                        result := result + CstErrCRCDest
                     else
                     begin
                        Handle := FileOpen(RepD + Fichier, fmOpenReadWrite);
                        if FileSetDate(Handle, LaDate) <> 0 then
                           result := result + CstErrMAJDate;
                        FileClose(Handle);
                     end;
                  end;
               end;
               TmNew.Free;
               if result and CstErrtot = CstNoErr then
               begin
                  if result and CstErrtot = CstNoErr then
                  begin
                     if Uppercase(Copy(fichier, 1, 4)) = 'EAI\' then
                     begin
                        for i := 0 to LesEai.count - 1 do
                        begin
                           if (trim(LesEai[i]) <> '') and (uppercase(LesEai[i]) <> RepD + 'EAI\') then
                           begin
                              ForceDirectories(ExtractFilePath(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)));
                              CopyFile(Pchar(RepD + Fichier),
                                 Pchar(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255)),
                                 False);
                           end;
                        end;
                     end;
                  end;
               end;
            end;
         end;
      end
      else if _Tipe = 4 then // Suppression ;
      begin
         result := CstTypeSUP;
         if (Assigned(_Copy)) then
         begin
            if not _Copy(RepD + Fichier, RepSec + Fichier) then
               result := result + CstErrSauve;
         end
         else if not CopyFile(Pchar(RepD + Fichier), Pchar(RepSec + Fichier), False) then
         begin
            result := result + CstErrSauve;
         end;

         if assigned(FichNot) then
            FichNot(Fichier);
         if result and CstErrSauve <> CstErrSauve then
         begin
            deletefile(RepD + Fichier);
            if result and CstErrtot = CstNoErr then
            begin
               if Uppercase(Copy(fichier, 1, 4)) = 'EAI\' then
               begin
                  for i := 0 to LesEai.count - 1 do
                  begin
                     if (trim(LesEai[i]) <> '') and (uppercase(LesEai[i]) <> RepD + 'EAI\') then
                     begin
                        deletefile(IncludeTrailingBackslash(LesEai[i]) + Copy(Fichier, 5, 255));
                     end;
                  end;
               end;
            end;
         end;
      end
      else
         result := CstTypeInconnue;
   except
      result := CstTypeInconnue;
   end;
end;

end.

