UNIT UmakePatch;

INTERFACE
USES
  Windows,
  Classes,
  SysUtils,
  IdHashCrc;

TYPE
  TPatchNotify = PROCEDURE(T_Actu, T_Tot: Integer) OF OBJECT;

FUNCTION PatchFile(Repe, reps, Fe, Fs: STRING; Vitesse: Integer; Notify: TPatchNotify): TMemoryStream;
PROCEDURE WriteString(S: STRING; TS: TStream);
FUNCTION FileCRC32(FileName: STRING): LongWord;
function DoNewCalcCRC32 (AFileName : String) : cardinal;


IMPLEMENTATION
CONST
  Crc32Tab: ARRAY[0..$FF] OF LongWord =
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

TYPE
  MonPb = CLASS(TThread)
  PRIVATE
    { Déclarations privées }
  PROTECTED
    PROCEDURE Execute; OVERRIDE;
  PUBLIC
    Fini: Boolean;
    TmEntre: TmemoryStream;
    TmSortie: TmemoryStream;

    PtEntre: Pointer;
    PtSortie: Pointer;
    a, b: integer;
    Leresultat: ARRAY[0..62000] OF integer;
    CONSTRUCTOR Create(CreateSuspended: Boolean; LaVitesse: Byte);
  END;
  TMonEnr = CLASS
    Tipe: Integer;
    Position: integer;
    QTe: Integer;
    CONSTRUCTOR create(_T, _P, _Qte: Integer);
  END;

function DoNewCalcCRC32 (AFileName : String) : cardinal;
var
  IndyStream : TFileStream;
  Hash32 : TIdHashCRC32;
begin
  IndyStream := TFileStream.Create(AFileName,fmOpenRead);
  Hash32 := TIdHashCRC32.Create;
  Result := Hash32.HashValue(IndyStream);
  Hash32.Free;
  IndyStream.Free;
end;

FUNCTION CRC32(Buffer: Pchar; Longeur: Integer): LongWord;
VAR
  i: integer;
  Bl: Byte;
BEGIN
  result := $FFFFFFFF;
  FOR i := 0 TO Longeur - 1 DO
  BEGIN
    Bl := result AND $FF;
    Bl := BL XOR Ord(Buffer[i]);
    result := result SHR 8;
    result := result XOR Crc32Tab[BL];
  END;
END;

FUNCTION FileCRC32(FileName: STRING): LongWord;
VAR
  p: PChar;
  FSize: LongInt;
  Handle: Integer;
BEGIN
  result := 0;
  Filesetattr(filename, 0);
  Handle := FileOpen(FileName, fmOpenRead + fmShareDenyNone);
  IF Handle = -1 THEN
    Exception.Create('Problème d''ouverture de ' + FileName);
  FSize := FileSeek(Handle, 0, 2);
  IF FSize > 0 THEN
  BEGIN
    FileSeek(Handle, 0, 0);
    GetMem(p, FSize + 100);
    FileRead(Handle, P[0], FSize);
    Result := CRC32(p, FSize);
    FreeMem(p, FSize + 100);
  END;
  FileClose(Handle);
END;

CONST
  taille_Max = 3 * 4 * 20000;
VAR
  LaPos: Integer;
  Vitesse: Integer = 8;
  Minimum: Integer = 32;

FUNCTION trouvePos4(P1, P2: Pointer; TailP1, TailP2: Integer; VAR Taille, Position: Integer; VAR P3): Integer; ASSEMBLER;
VAR
  tP1, tP2: Integer;
  OldPos, Tai, Pos: Integer;
  Incr: Integer;

  LastPosOk: Integer;
  LaQteOK: Integer;

  _MaTaille: Integer;
ASM
         PUSH    ESI
         PUSH    EDI
         PUSH    EBX

         MOV     ESI,P1

         MOV     EDI,P2

         MOV     EDX,TailP1
         Sub     Edx,LaPos
         MOV     tP1,EDX

         MOV     EDX,TailP2
         MOV     tP2,EDX
         XOR     EDX,EDX
         MOV     Tai,EDX
         MOV     Pos,EDX
         Mov     Incr,EDX
         Mov     LaQteOK,EDX

         MOV     ECX,TP2
         SHR     ECX,2

         ADD     ESI,LaPos

@@BCC2:  PUSH    EDI

         MOV     _MaTaille, ECX
         CMP     _MaTaille, 16000
         JG      @@BCCL1
         MOV     _MaTaille, 16000
@@BCCL1: SUB     _MaTaille, 16000

@@BCLE:  PUSH    ESI
         LODSD

         REPNE   SCASD
         JCXZ    @@PASTROUVE

         PUSH    EDI
         PUSH    ECX

         MOV     EAX,TP2
         SHR     EAX,2
         SUB     EAX,ECX
         DEC     EAX
         MOV     EBX, Pos
         MOV     OldPos, EBX
         MOV     Pos, EAX

         MOV     EAX,tP1
         SHR     EAX,2
         CMP     EAX,ECX
         JGE     @@PASSUP
         MOV     ECX,EAX
@@PASSUP:
         PUSH    ECX
         REPE    CMPSD
         POP     EAX

         SUB     EAX,ECX
         CMP     EAX,TAI
         JNL     @@OK

         MOV     EBX, OldPos
         MOV     Pos, EBX
         MOV     EAX, TAI

@@OK:    MOV     TAI, EAX

         POP     ECX
         POP     EDI

         CMP     _MaTaille, ECX
         JG      @@PASTROUVE

         POP     ESI
         JMP     @@BCLE

@@PASTROUVE:
         Mov     EAX,Tai
         SHL     EAX,2

         CMP     EAX,Vitesse       // minimum de 16 octets
         JG      @@ONPREND

         CMP     EAX,Minimum
         JG      @@X4
         MOV     EAX,Minimum
@@X4:    CMP     LaQteOK,0
         JNE     @@X1
         Mov     EDX,LaPos
         Mov     LastPosOk,EDX
@@X1:    ADD     LaQteOK,EAX
         JMP     @@PASPROB

@@ONPREND:
         CMP     LaQteOK,0
         JE      @@X2

         MOV     EDX,P3
         ADD     EDX,INCR
         Mov     EAX,LastPosOk
         MOV     [EDX],EAX

         MOV     EAX,0ffffffffh
         MOV     [EDX+4],EAX

         Mov     EAX,LaQteOK
         MOV     [EDX+8],EAX
         ADD     INCR,12

         XOR     EAX,EAX
         Mov     LaQteOK, EAX

@@X2:    MOV     EDX,P3
         ADD     EDX,INCR
         Mov     EAX,LaPos
         MOV     [EDX],EAX

         Mov     EAX,Pos
         SHL     EAX,2
         MOV     [EDX+4],EAX

         Mov     EAX,Tai
         SHL     EAX,2
         MOV     [EDX+8],EAX
         ADD     INCR,12

@@PASPROB:
         ADD     LaPos,EAX
         POP     ESI
         CMP     EAX,TP1
         JGE     @@FIN
         CMP     INCR,taille_Max
         JGE     @@FIN

         SUB     TP1,EAX
         ADD     ESI,EAX

         XOR     EDX,EDX
         MOV     Tai,EDX
         MOV     Pos,EDX

         POP     EDI

         MOV     EAX,Pos
         CMP     EAX,64000
         JL      @@BCCL2
         SUB     EAX,64000
         ADD     EDI,EAX
         MOV     EBX,TP2
         SUB     EBX,EAX
         MOV     TP2,EBX

@@BCCL2: MOV     ECX,TP2
         SHR     ECX,2
         JMP     @@BCC2

@@FIN:   CMP     LaQteOK,0
         JE      @@FINFI

         MOV     EDX,P3
         ADD     EDX,INCR
         Mov     EAX,LastPosOk
         MOV     [EDX],EAX

         MOV     EAX,0ffffffffh
         MOV     [EDX+4],EAX

         Mov     EAX,LaQteOK
         MOV     [EDX+8],EAX
         ADD     INCR,12

         XOR     EAX,EAX
         Mov     LaQteOK, EAX

@@FINFI: POP     EDI
         POP     EBX
         POP     EDI
         POP     ESI
END;

{ MonPb }

CONSTRUCTOR MonPb.Create(CreateSuspended: Boolean; LaVitesse: Byte);
BEGIN
  INHERITED Create(CreateSuspended);
  Fini := false;
  FreeOnTerminate := false;
  Priority := tpNormal;
  IF LaVitesse = 0 THEN
  BEGIN
    Vitesse := 8;
    minimum := 8;
  END
  ELSE IF LaVitesse = 2 THEN
  BEGIN
    Vitesse := 16;
    minimum := 64;
  END
  ELSE IF LaVitesse = 3 THEN
  BEGIN
    Vitesse := 32;
    minimum := 128;
  END;
END;

PROCEDURE MonPb.Execute;
VAR
  toto: Integer;
BEGIN
  { Placez le code du thread ici}
    // Fini := false;
  toto := TmSortie.Size DIV 1024; //en Ko
  IF toto > 3000 THEN
  BEGIN
    Vitesse := Vitesse * 4;
    minimum := minimum * 4;
  END
  ELSE IF toto > 2000 THEN
  BEGIN
    Vitesse := Vitesse * 3;
    minimum := minimum * 3;
  END
  ELSE IF toto > 1000 THEN
  BEGIN
    Vitesse := Vitesse * 2;
    minimum := minimum * 2;
  END
  ELSE IF toto < 200 THEN
  BEGIN
    Vitesse := Vitesse DIV 4;
    minimum := minimum DIV 16;
  END;

  IF Vitesse < 2 THEN
    Vitesse := 2;
  IF minimum < 8 THEN
    minimum := 8;
  IF NOT fini THEN
  BEGIN
    ZeroMemory(@Leresultat, Length(Leresultat));
    trouvePos4(PtSortie, PtEntre, TmSortie.Size, TmEntre.Size, a, b, Leresultat);
    Fini := true;
  END;
END;

PROCEDURE WriteString(S: STRING; TS: TStream);
VAR
  _Byte: Byte;
BEGIN
  _Byte := Length(S);
  TS.Write(_byte, sizeof(_byte));
  IF _byte > 0 THEN
  BEGIN
    Ts.Write(Pointer(S)^, _byte);
  END;
END;

TYPE
  tUneVal = ARRAY[0..3] OF byte;

FUNCTION CodeTaille(Taille: Dword; VAR valeur: tUneVal): Integer;
BEGIN
  IF taille <= $3F THEN
  BEGIN
    result := 1;
  END
  ELSE IF taille < $3FFF THEN
  BEGIN
    taille := taille OR $4000;
    result := 2;
  END
  ELSE IF taille < $3FFFFF THEN
  BEGIN
    taille := taille OR $800000;
    result := 3;
  END
  ELSE
  BEGIN
    taille := taille OR $C0000000;
    result := 4;
  END;
  move(taille, valeur, 4);
END;

PROCEDURE writeval(ts: tstream; v: tUneVal; taille: Integer);
BEGIN
  IF taille = 1 THEN
    ts.write(V[0], 1)
  ELSE IF taille = 2 THEN
  BEGIN
    ts.write(V[1], 1);
    ts.write(V[0], 1);
  END
  ELSE IF taille = 3 THEN
  BEGIN
    ts.write(V[2], 1);
    ts.write(V[1], 1);
    ts.write(V[0], 1);
  END
  ELSE
  BEGIN
    ts.write(V[3], 1);
    ts.write(V[2], 1);
    ts.write(V[1], 1);
    ts.write(V[0], 1);
  END;
END;

PROCEDURE WriteSize(Size: Integer; TS: TStream);
VAR
  UneTaille: tUneVal;
  Le_Nbr: Integer;
BEGIN
  Le_Nbr := CodeTaille(Size, UneTaille);
  writeval(Ts, UneTaille, Le_Nbr);
END;

FUNCTION PatchFile(Repe, reps, Fe, Fs: STRING; Vitesse: Integer; Notify: TPatchNotify): TMemoryStream;
VAR
  Handle: THandle;
  LaDate: Integer;
  CRC: DWord;
  _Byte: Byte;
  TmPass: TMemoryStream;

  TmEntree: TMemoryStream;
  TmSortie: TMemoryStream;

  ok: Boolean;

  CRC1: DWord;
  CRC2: DWord;
  LaListe: TList;
  mb: MonPb;
  j: Integer;
  i: Integer;
BEGIN
  result := TMemoryStream.Create;
  IF ((fe = '') AND (fs <> '')) OR (Uppercase(Extractfilename(fs)) = 'SCRIPT.SCR') THEN
  BEGIN
    // Le fichier d'entré n'existe pas mais celui de sortie si
    // On Stock tous le fichier
    Handle := FileOpen(reps + fs, fmOpenRead);
    LaDate := FileGetDate(Handle);
    FileClose(Handle);
    CRC := FileCRC32(reps + fs);
    _Byte := 0;
    result.Write(_Byte, Sizeof(_Byte));
    WriteString(Fs, Result);
    result.Write(Ladate, Sizeof(Ladate));
    result.Write(CRC, Sizeof(CRC));
    TmPass := TMemoryStream.Create;
    TRY
      TmPass.LoadFromFile(reps + Fs);
      TmPass.Seek(soFromBeginning, 0);
      IF assigned(Notify) THEN
        Notify(TmPass.Size, TmPass.Size);
      WriteSize(TmPass.Size, result);
      Result.CopyFrom(TmPass, 0);
    FINALLY
      tmPass.free;
    END;
  END
  ELSE IF (fe <> '') AND (fs = '') THEN
  BEGIN
    // Le fichier de sortie n'existe plus on le supprime
    _Byte := 4;
    result.Write(_Byte, Sizeof(_Byte));
    WriteString(Fe, Result);
  END
  ELSE
  BEGIN
    ok := false;
    TmEntree := TMemoryStream.Create;
    TmSortie := TMemoryStream.Create;
    TRY
      TmEntree.LoadFromFile(repe + fe);
      TmSortie.LoadFromFile(reps + fs);
      TmEntree.Seek(soFromBeginning, 0);
      TmSortie.Seek(soFromBeginning, 0);
      IF TmSortie.Size = TmEntree.size THEN
      BEGIN
        IF comparemem(TmSortie.Memory, TmEntree.Memory, TmEntree.size) THEN
          ok := true;
      END;
      IF ok THEN
      BEGIN
        // Les fichiers sont similaire
        IF assigned(Notify) THEN
          Notify(TmEntree.Size, TmEntree.Size);
        Handle := FileOpen(reps + fs, fmOpenRead);
        LaDate := FileGetDate(Handle);
        FileClose(Handle);
        CRC := FileCRC32(reps + fs);
        _byte := 8;
        result.Write(_Byte, Sizeof(_Byte));
        WriteString(Fs, Result);
        Result.Write(Ladate, Sizeof(Ladate));
        Result.Write(CRC, Sizeof(CRC));
      END
      ELSE
      BEGIN
        // On patch les fichiers
        CRC1 := FileCRC32(repe + fe);
        CRC2 := FileCRC32(reps + fs);
        Handle := FileOpen(reps + fs, fmOpenRead);
        LaDate := FileGetDate(Handle);
        FileClose(Handle);
        TmEntree.Seek(soFromBeginning, 0);
        TmSortie.Seek(soFromBeginning, 0);
        LaPos := 0;
        LaListe := TList.create;
        TRY
          WHILE LaPos < TmSortie.Size DO
          BEGIN
            mb := MonPb.Create(true, Vitesse);
            TRY
              mb.TmEntre := TmEntree;
              mb.TmSortie := TmSortie;
              mb.PtEntre := TmEntree.Memory;
              mb.PtSortie := TmSortie.Memory;
              Mb.resume;
              WHILE NOT mb.fini DO
              BEGIN
                Sleep(100);
                IF assigned(Notify) THEN
                  Notify(LaPos, TmSortie.Size);
                // Faire un appel d'event avec LaPos, TmSortie.Size
              END;
              J := 0;
              WHILE mb.Leresultat[j + 2] <> 0 DO
              BEGIN
                LaListe.Add(tMonEnr.Create(mb.Leresultat[j + 1], mb.Leresultat[j + 0], mb.Leresultat[j + 2]));
                inc(j, 3);
              END;
              mb.Terminate;
            FINALLY
              mb.free;
            END;
          END;
          IF assigned(Notify) THEN
            Notify(TmSortie.Size, TmSortie.Size);
          _byte := 2; // Patch
          Result.Write(_byte, sizeof(_byte));
          WriteString(Fs, Result);
          Result.Write(Ladate, Sizeof(Ladate));
          Result.Write(CRC2, Sizeof(CRC2)); // Arrivé
          Result.Write(CRC1, Sizeof(CRC1)); // Départ
          WriteSize(TmSortie.Size, result);
          FOR i := 0 TO LaListe.count - 1 DO
          BEGIN
            IF tMonEnr(LaListe[i]).Tipe = -1 THEN
            BEGIN
              // Copier les données
              _byte := 0;
              result.Write(_byte, Sizeof(_byte));
              J := tMonEnr(LaListe[i]).QTe;
              IF i = LaListe.count - 1 THEN
              BEGIN
                J := TmSortie.Size - tMonEnr(LaListe[i]).Position;
              END;
              WriteSize(J, result);
              TmSortie.Seek(tMonEnr(LaListe[i]).Position, soFromBeginning);
              Result.CopyFrom(TmSortie, J);
            END
            ELSE
            BEGIN
              _byte := 1;
              result.Write(_byte, Sizeof(_byte));
              WriteSize(tMonEnr(LaListe[i]).QTe, result);
              WriteSize(tMonEnr(LaListe[i]).tipe, result);
            END;
          END;
        FINALLY
          FOR i := 0 TO LaListe.count - 1 DO
            tMonEnr(LaListe[i]).free;
          LaListe.free;
        END;
      END;

    FINALLY
      TmEntree.free;
      TmSortie.free;
    END;
  END;
END;

{ TMonEnr }

CONSTRUCTOR TMonEnr.create(_T, _P, _Qte: Integer);
BEGIN
  INHERITED Create;
  Tipe := _T;
  Position := _P;
  QTe := _Qte;
END;

END.

