//==============================================================================
// developpez.net                                               Andnotor - 2012
//
//      TUTORIEL - Envoyer des chaînes ou des structures par PostMessage
//
// Pour plus d'info:
// http://http://andnotor.developpez.com/tutoriels/delphi/envoyer-chaines-postmessage/
//==============================================================================
unit MessagesEx;

interface

uses Classes, Windows, SysUtils;

function  PostBufferMessage(aWnd :hWnd; aMessage :cardinal; aBuffer :PByteArray; aLen :integer) :integer;
function  PostTextMessage(aWnd :hWnd; aMessage :cardinal; aText :string) :integer;
function  PostStreamMessage(aWnd :hWnd; aMessage :cardinal; aStream :TStream) :integer;

function  GetBufferMessage(aAtom :TAtom; aBuffer :PByte; aLen :integer) :integer;
function  GetTextMessage(aAtom :TAtom) :string;
function  GetStreamMessage(aAtom :TAtom; aStream :TStream) :integer;

procedure ClearPostMessageTable;

// Mettre ClearTableOnExit à FALSE si les messages doivent persister après la
// sortie du programme. Par exemple une application console qui notifie un
// résultat et quitte immédiatement
var
  ClearTableOnExit :boolean = TRUE;

implementation

//------------------------------------------------------------------------------
const
  EOD      = MAXINTATOM -1;  //End Of Data ($BFFF)
  MaxBytes = (MAXBYTE -SizeOf(TAtom) -2) div 2;
  Codes    : array[0..$F] of ansichar = '0123456789ABCDEF';

//------------------------------------------------------------------------------
type
  TData = packed record
    Next  :TAtom;
    Len   :byte;
    Bytes :string[MaxBytes *2];
    Null  :ansichar; //#0
  end;

//------------------------------------------------------------------------------
var
  GlobalAtoms :array[MAXINTATOM..$FFFF] of byte;

//------------------------------------------------------------------------------
function StrToByte(aText :string; aIndex :integer) :byte; inline;
begin
  Result := ((Pos(aText[aIndex], Codes) -1) shl 4) or
            (Pos(aText[aIndex+1], Codes) -1);
end;

function ByteToStr(aByte :byte) :string; inline;
begin
  Result := Codes[aByte shr 4]
           +Codes[aByte and $F];
end;

//------------------------------------------------------------------------------
procedure ClearPostMessageTable;
var
  i :integer;

begin
  for i := Low(GlobalAtoms) to High(GlobalAtoms) do
    while GlobalAtoms[i] > 0 do
    begin
      GlobalDeleteAtom(i);
      Dec(GlobalAtoms[i]);
    end;
end;

//------------------------------------------------------------------------------
function PostBufferMessage(aWnd :hWnd; aMessage :cardinal; aBuffer :PByteArray; aLen :integer) :integer;
var
  Data  :TData;
  Atoms :array of TAtom;
  Count :integer;
  i     :integer;
begin
  Result := -1;
  ZeroMemory(@Data, SizeOf(Data));

  //La donnée est traitée depuis la fin => Next = EOD
  Data.Next := EOD;

  try
    //S'il n'y a pas de donnée, envoie une chaîne vide
    if Assigned(aBuffer) then
    begin
      //Table d'atomes nécessaires à l'envoi de la donnée.
      //Si une erreur survient en court de traitement, permet
      //de libérer les atomes déjà créés.
      SetLength(Atoms, aLen div MaxBytes +1);
      Count := 0;

      //Traîte la donnée depuis la fin. Le faire depuis le début
      //nous obligerait à utiliser une table temporaire et de
      //renuméroter les <Next> dans une deuxième passe.
      for i := aLen -1 downto 0 do
      begin
        //Conversion byte -> caractères
        Data.Bytes := UTF8Encode(ByteToStr(aBuffer[i])) + Data.Bytes;
        
        //Taille max atteinte => Stock la chaîne
        if i mod MaxBytes = 0 then
        begin
          Data.Len  := Length(Data.Bytes) div 2;
          Data.Next := GlobalAddAtomA(@Data);

          //Si erreur, Next=0. Sinon ajoute l'atome à nos listes
          if Data.Next <> 0 then
          begin
            Atoms[Count] := Data.Next;
            inc(GlobalAtoms[Data.Next]);
            inc(Count);

            //Reset pour prochaine boucle
            Data.Bytes := '';
          end
          else
          begin
            Result := GetLastError;
            Exit;
          end;
        end;
      end;
    end
    else SetLength(Atoms, 0);

    //Envoi
    //if PostMessage(aWnd, aMessage, Data.Next, aLen) then
    if PostMessage(aWnd, aMessage, Data.Next, aLen) then
      Result := ERROR_SUCCESS
    else
      Result := GetLastError;

  finally
    //Libération des atomes déjà créés si erreur
    if Result <> ERROR_SUCCESS then
    begin
      for i := 0 to Count -1 do
      begin
        GlobalDeleteAtom(Atoms[i]);
        dec(GlobalAtoms[Atoms[i]]);
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
function PostTextMessage(aWnd :hWnd; aMessage :Cardinal; aText :string) :integer;
begin
  Result := PostBufferMessage(aWnd, aMessage, @aText[1], Length(aText) *SizeOf(Char));
end;

//------------------------------------------------------------------------------
function PostStreamMessage(aWnd :hWnd; aMessage :Cardinal; aStream :TStream) :integer;
var
  Buffer :array of byte;

begin
  SetLength(Buffer, aStream.Size);
  aStream.Position := 0;
  aStream.Read(Buffer[0], aStream.Size);

  Result := PostBufferMessage(aWnd, aMessage, @Buffer[0], aStream.Size);
end;

//------------------------------------------------------------------------------
function GetBufferMessage(aAtom :TAtom; aBuffer :PByte; aLen :integer) :integer;
var
  Data :TData;
  i    :integer;

begin
  //Result renvoit la taille de la donnée
  Result := 0;

  //Lit tant que "End Of Data" n'est pas atteint
  while aAtom <> EOD do
    if GlobalGetAtomNameA(aAtom, @Data, SizeOf(Data)) <> 0 then
    begin
      inc(Result, Data.Len);

      //Si le buffer n'est pas spécifié (nil), l'atome n'est pas supprimé
      //et la fonction sert uniquement à récupérer la taille totale de la
      //donnée en vue de l'allocation d'un buffer
      if Assigned(aBuffer) then
      begin
        //Supprime l'atome
        GlobalDeleteAtom(aAtom);
        dec(GlobalAtoms[aAtom]);

        i := 1;

        if Data.Len < aLen then
          aLen := Data.Len;

        //Converti la chaîne en octets
        while i < aLen *2 do
        begin
          aBuffer^ := StrToByte(Data.Bytes, i);
          inc(i, 2);
          inc(aBuffer);
        end;
      end;

      //Atome suivant
      aAtom := Data.Next;
    end
    else
    begin
      Result := 0;
      Break;
    end;
end;

//------------------------------------------------------------------------------
function GetTextMessage(aAtom :TAtom) :string;
var
  Len :integer;

begin
  Len := GetBufferMessage(aAtom, nil, 0);
  SetLength(Result, Len div SizeOf(Char));
  GetBufferMessage(aAtom, @Result[1], Len);
end;

//------------------------------------------------------------------------------
function GetStreamMessage(aAtom :TAtom; aStream :TStream) :integer;
var
  Buffer :array of byte;

begin
  Result := GetBufferMessage(aAtom, nil, 0);
  SetLength(Buffer, Result);
  GetBufferMessage(aAtom, @Buffer[0], Result);

  aStream.Write(Buffer[0], Result);
end;

//------------------------------------------------------------------------------
initialization
  ZeroMemory(@GlobalAtoms, SizeOf(GlobalAtoms));

finalization
  if ClearTableOnExit then
    ClearPostMessageTable;

end.
