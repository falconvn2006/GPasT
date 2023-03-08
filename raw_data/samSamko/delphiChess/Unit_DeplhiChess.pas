unit Unit_DeplhiChess;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Generics.Defaults,
  Generics.Collections,
  StrUtils;

type
  TPiece = record
    name : string;
    pieceType : string;
    position : string;
    isWhite : boolean;
    alive: boolean;
    end;
  TChessboard = class(TForm)
    A8: TPanel;
    B8: TPanel;
    D8: TPanel;
    C8: TPanel;
    H8: TPanel;
    G8: TPanel;
    F8: TPanel;
    E8: TPanel;
    A7: TPanel;
    B7: TPanel;
    D7: TPanel;
    C7: TPanel;
    H7: TPanel;
    G7: TPanel;
    F7: TPanel;
    E7: TPanel;
    A6: TPanel;
    B6: TPanel;
    D6: TPanel;
    C6: TPanel;
    H6: TPanel;
    G6: TPanel;
    F6: TPanel;
    E6: TPanel;
    A5: TPanel;
    B5: TPanel;
    D5: TPanel;
    C5: TPanel;
    H5: TPanel;
    G5: TPanel;
    F5: TPanel;
    E5: TPanel;
    A4: TPanel;
    B4: TPanel;
    D4: TPanel;
    C4: TPanel;
    H4: TPanel;
    G4: TPanel;
    F4: TPanel;
    E4: TPanel;
    A3: TPanel;
    B3: TPanel;
    D3: TPanel;
    C3: TPanel;
    H3: TPanel;
    G3: TPanel;
    F3: TPanel;
    E3: TPanel;
    A2: TPanel;
    B2: TPanel;
    D2: TPanel;
    C2: TPanel;
    H2: TPanel;
    G2: TPanel;
    F2: TPanel;
    E2: TPanel;
    A1: TPanel;
    B1: TPanel;
    D1: TPanel;
    C1: TPanel;
    H1: TPanel;
    G1: TPanel;
    F1: TPanel;
    E1: TPanel;
    WPawn1: TPanel;
    WPawn2: TPanel;
    WPawn3: TPanel;
    WPawn4: TPanel;
    WPawn5: TPanel;
    WPawn6: TPanel;
    WPawn7: TPanel;
    WPawn8: TPanel;
    BPawn1: TPanel;
    BPawn2: TPanel;
    BPawn3: TPanel;
    BPawn4: TPanel;
    BPawn5: TPanel;
    BPawn6: TPanel;
    BPawn7: TPanel;
    BPawn8: TPanel;
    WTower1: TPanel;
    WTower2: TPanel;
    BTower1: TPanel;
    BTower2: TPanel;
    WKnight1: TPanel;
    WKnight2: TPanel;
    BKnight1: TPanel;
    BKnight2: TPanel;
    WBishop1: TPanel;
    WBishop2: TPanel;
    BBishop2: TPanel;
    BBishop1: TPanel;
    WQueen: TPanel;
    BQueen: TPanel;
    WKing: TPanel;
    BKing: TPanel;
    procedure squareClick(Sender: TObject);
    procedure pieceClick(Sender: TObject);
    procedure selectPiece(square:TPanel);
    procedure releasePiece;
    procedure restoreCheckboard;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Chessboard: TChessboard;
  whiteTurn : Boolean = True;
  posEnPassant : string = '00';
  canEnPassant : Boolean = False;
  killedEnPassant : Boolean = False;
  selectedPiece : integer = 0;
  selectedPanel : TPanel;
  Pieces : array[1..32] of TPiece =
  ((name:'WPawn1';pieceType:'pawn'; position:'A2'; isWhite:True; alive:true),
   (name:'WPawn2';pieceType:'pawn'; position:'B2'; isWhite:True; alive:true),
   (name:'WPawn3';pieceType:'pawn'; position:'C2'; isWhite:True; alive:true),
   (name:'WPawn4';pieceType:'pawn'; position:'D2'; isWhite:True; alive:true),
   (name:'WPawn5';pieceType:'pawn'; position:'E2'; isWhite:True; alive:true),
   (name:'WPawn6';pieceType:'pawn'; position:'F2'; isWhite:True; alive:true),
   (name:'WPawn7';pieceType:'pawn'; position:'G2'; isWhite:True; alive:true),
   (name:'WPawn8';pieceType:'pawn'; position:'H2'; isWhite:True; alive:true),
   (name:'WTower1';pieceType:'tower'; position:'A1'; isWhite:True; alive:true),
   (name:'WTower2';pieceType:'tower'; position:'H1'; isWhite:True; alive:true),
   (name:'WKnight1';pieceType:'knight'; position:'B1'; isWhite:True; alive:true),
   (name:'WKnight2';pieceType:'knight'; position:'G1'; isWhite:True; alive:true),
   (name:'WBishop1';pieceType:'bishop'; position:'C1'; isWhite:True; alive:true),
   (name:'WBishop2';pieceType:'bishop'; position:'F1'; isWhite:True; alive:true),
   (name:'WQueen';pieceType:'queen'; position:'D1'; isWhite:True; alive:true),
   (name:'WKing';pieceType:'king'; position:'E1'; isWhite:True; alive:true),

   (name:'BPawn1';pieceType:'pawn'; position:'A7'; isWhite:False; alive:true),
   (name:'BPawn2';pieceType:'pawn'; position:'B7'; isWhite:False; alive:true),
   (name:'BPawn3';pieceType:'pawn'; position:'C7'; isWhite:False; alive:true),
   (name:'BPawn4';pieceType:'pawn'; position:'D7'; isWhite:False; alive:true),
   (name:'BPawn5';pieceType:'pawn'; position:'E7'; isWhite:False; alive:true),
   (name:'BPawn6';pieceType:'pawn'; position:'F7'; isWhite:False; alive:true),
   (name:'BPawn7';pieceType:'pawn'; position:'G7'; isWhite:False; alive:true),
   (name:'BPawn8';pieceType:'pawn'; position:'H7'; isWhite:False; alive:true),
   (name:'BTower1';pieceType:'tower'; position:'A8'; isWhite:False; alive:true),
   (name:'BTower2';pieceType:'tower'; position:'H8'; isWhite:False; alive:true),
   (name:'BKnight1';pieceType:'knight'; position:'B8'; isWhite:False; alive:true),
   (name:'BKnight2';pieceType:'knight'; position:'G8'; isWhite:False; alive:true),
   (name:'BBishop1';pieceType:'bishop'; position:'C8'; isWhite:False; alive:true),
   (name:'BBishop2';pieceType:'bishop'; position:'F8'; isWhite:False; alive:true),
   (name:'BQueen';pieceType:'queen'; position:'D8'; isWhite:False; alive:true),
   (name:'BKing';pieceType:'king'; position:'E8'; isWhite:False; alive:true)
  );

const
  Board : array[1..8] of array[1..8] of string =
  (('A1','A2','A3','A4','A5','A6','A7','A8'),
   ('B1','B2','B3','B4','B5','B6','B7','B8'),
   ('C1','C2','C3','C4','C5','C6','C7','C8'),
   ('D1','D2','D3','D4','D5','D6','D7','D8'),
   ('E1','E2','E3','E4','E5','E6','E7','E8'),
   ('F1','F2','F3','F4','F5','F6','F7','F8'),
   ('G1','G2','G3','G4','G5','G6','G7','G8'),
   ('H1','H2','H3','H4','H5','H6','H7','H8'));

implementation

{$R *.dfm}

//to calculate positions
function getXPosition(pos: string): Integer;
var I,J: Integer;
begin
  for I := 1 to 8 do
    for J := 1 to 8 do
      if Board[I][J] = pos then begin Result := I; Exit end;
  //fallback
  Result := 0;
end;

function getYPosition(pos: string):integer;
var I,J: Integer;
begin
  for I := 1 to 8 do
    for J := 1 to 8 do
      if Board[I][J] = pos then begin Result := J; Exit end;
  //fallback
  Result := 0;
end;

//return position with offsets
function getPosition(position:string; xOffset:Integer; yOffset:Integer):string;
begin
  Result := Board[getXPosition(position) + xOffset, getYPosition(position) + yOffset];
end;

//get piece index for quick access to pieces array
function getPieceIndex(position:string):Integer;
begin
  Result := 0;
  for var I := Low(Pieces) to High(Pieces) do
    if Pieces[I].position = position then Result := I;
end;

//check if pieceA is same color as piece B
function sameColor(pieceA:string; pieceB:string): boolean;
begin
  Result := False;
  for var I := Low(Pieces) to High(Pieces) do
    if (Pieces[I].position = pieceA) and Pieces[I].alive then
      for var J := Low(Pieces) to High(Pieces) do
        if (Pieces[J].position = pieceB) and Pieces[J].alive then
          begin
            if Pieces[I].isWhite = Pieces[J].isWhite then
            Result := True;
            Exit;
          end
end;

//validate move types

//pawn
function validPawnMove(piece:integer; square:string): Boolean;
var J:Integer;
begin
  var piecePos : string := Pieces[piece].position;
  Result := False;

  //get color modifier then check if at border
  if Pieces[piece].isWhite then
    if getYPosition(piecePos) = 8 then Exit else J := 1
  else
    if getYPosition(piecePos) = 1 then Exit else J := -1;

  //see if within board and possible pawn move (above/below current square)
  if square = getPosition(piecePos,0,J) then Result := True;

  //look for other ALIVE pieces
  for var I := Low(Pieces) to High(Pieces) do
    if (Pieces[I].position = square) and Pieces[I].alive then
      begin
        //if piece is of diferent color
        if Pieces[I].isWhite <> Pieces[piece].isWhite then
        begin
          //see if on bottom and if valid black atack
          if not Pieces[I].isWhite and (getYPosition(square) <> 1) then
          begin
            //if can right attack, exit true
            if getXPosition(square) <> 1 then
              if piecePos = getPosition(square,-1,-1) then
                begin
                Result:=True;
                Exit
                end;
            //if can left attack, exit true
            if getXPosition(square) <> 8  then
              if piecePos = getPosition(square,1,-1) then
                begin
                Result:=True;
                Exit
                end;
          end;

          //see if on top and valid white atack
          if Pieces[I].isWhite and (getYPosition(square) <> 8) then
          begin
            //if can right attack, exit true
            if getXPosition(square) <> 1 then
              if piecePos = getPosition(square,-1,1) then
                begin
                Result:=True;
                Exit
                end;
            //if can left attack, exit true
            if getXPosition(square) <> 8  then
              if piecePos = getPosition(square,1,1) then
                begin
                Result:=True;
                Exit
                end;
          end;
        end;
        //if piece above, return false
        if square = getPosition(piecePos,0,J) then Result := False;
      end;

  //first move can be double
  if Pieces[piece].isWhite then
    begin
    if (getXPosition(square)=getXPosition(piecePos)) and ((getYPosition(square)=4)
    and (getYPosition(piecePos)=2)) and (getPieceIndex(square)=0) then
      begin Result := True;canEnPassant:=True end
    end
  else
    begin
    if (getXPosition(square)=getXPosition(piecePos)) and (getPieceIndex(square)=0)
    and ((getYPosition(square)=5) and (getYPosition(piecePos)=7)) then
      begin Result := True;canEnPassant:=True end
    end;

  //can attack en passant pos
  if square = posEnPassant then begin
    if Pieces[piece].isWhite and (getYPosition(piecePos)=5) then
    begin
      if (((getXPosition(piecePos)+1) = getXPosition(posEnPassant)) or
      ((getXPosition(piecePos)-1) = getXPosition(posEnPassant))) then
        Result := True;
    end;
    if not Pieces[piece].isWhite and (getYPosition(piecePos)=4) then
    begin
      if (((getXPosition(piecePos)+1) = getXPosition(posEnPassant)) or
      ((getXPosition(piecePos)-1) = getXPosition(posEnPassant))) then
        Result := True;
    end;
  end;



  //dont eat ally on double
  if sameColor(piecePos,square) then Result := False;

end;

//tower
function validTowerMove(piece:integer; square:string): Boolean;
begin
  var piecePos : string := Pieces[piece].position;
  Result := True;

  //Remove if not on same X & Y axis or same square
  if ((getXPosition(piecePos) <> getXPosition(square)) and
  (getYPosition(piecePos) <> getYPosition(square)) or (piecePos = square))then
    begin Result := False;Exit end;


  //check if vertical with square
  if getXPosition(square) = getXPosition(piecePos) then
  begin
    //if above or below
    if getYPosition(square) > getYPosition(piecePos) then
    begin
      //look of pieces in betwen
      for var Y := getYPosition(square)-1 downto getYPosition(piecePos)+1 do
      begin
        for var I := Low(Pieces) to High(Pieces) do
        //if y pos of piece is in between, false
          if (getXPosition(Pieces[I].position) = getXPosition(square)) and
          Pieces[I].alive and (getYPosition(Pieces[I].position) = Y) and
          (I<>selectedPiece) then
            begin Result := False;Exit end;
      end;
    end

    else if getYPosition(square) < getYPosition(piecePos) then
    begin
      //look of pieces in betwen
      for var Y := getYPosition(square)+1 to getYPosition(piecePos)-1 do
      begin
        for var I := Low(Pieces) to High(Pieces) do
        //if y pos of piece is in between, false
          if (getXPosition(Pieces[I].position) = getXPosition(square)) and
          Pieces[I].alive and (getYPosition(Pieces[I].position) = Y) and
          (I<>selectedPiece) then
            begin Result := False;Exit end;
      end;
    end;
  end;

  //check if horizontal with square
  if getYPosition(square) = getYPosition(piecePos) then
  begin
    //if left or right
    if getXPosition(square) > getXPosition(piecePos) then
    begin
      //look of pieces in betwen
      for var X := getXPosition(square)-1 downto getXPosition(piecePos)+1 do
      begin
        for var I := Low(Pieces) to High(Pieces) do
        //if y pos of piece is in between, false
          if (getYPosition(Pieces[I].position) = getYPosition(square)) and
          Pieces[I].alive and (getXPosition(Pieces[I].position) = X) and
          (I<>selectedPiece) then
            begin Result := False;Exit end;
      end;
    end

    else if getXPosition(square) < getXPosition(piecePos) then
    begin
      //look of pieces in betwen
      for var X := getXPosition(square)+1 to getXPosition(piecePos)-1 do
      begin
        for var I := Low(Pieces) to High(Pieces) do
        //if y pos of piece is in between, false
          if (getYPosition(Pieces[I].position) = getYPosition(square)) and
          Pieces[I].alive and (getXPosition(Pieces[I].position) = X) and
          (I<>selectedPiece) then
            begin Result := False;Exit end;
      end;
    end;
  end;

  //check if square is ally, false;
  //if sameColor(piecePos,square) then Result := False;
end;

//knight
function validKnightMove(piece:integer; square:string): Boolean;
begin
  Result := False;
  var piecePos:string := Pieces[piece].position;

  //easy, just look for 1y 2x vice versa
  //up
  if getYPosition(piecePos) < 7 then
  begin
    if getXPosition(piecePos) > 1 then
      if (square = getPosition(piecePos,-1,2)) then Result := True;
    if getXPosition(piecePos) < 8 then
      if (square = getPosition(piecePos,1,2)) then Result := True;
  end;
  //down
  if getYPosition(piecePos) > 2 then
  begin
    if getXPosition(piecePos) > 1 then
      if (square = getPosition(piecePos,-1,-2)) then Result := True;
    if getXPosition(piecePos) < 8 then
      if (square = getPosition(piecePos,1,-2)) then Result := True;
  end;
  //left
  if getXPosition(piecePos) > 2 then
  begin
    if getYPosition(piecePos) > 1 then
      if (square = getPosition(piecePos,-2,-1)) then Result := True;
    if getYPosition(piecePos) < 8 then
      if (square = getPosition(piecePos,-2,1)) then Result := True;
  end;
  //right
  if getXPosition(piecePos) < 7 then
  begin
    if getYPosition(piecePos) > 1 then
      if (square = getPosition(piecePos,2,-1)) then Result := True;
    if getYPosition(piecePos) < 8 then
      if (square = getPosition(piecePos,2,1)) then Result := True;
  end;

  //check if square is ally, false;
  //if sameColor(piecePos,square) then Result := False;
end;

//bishop
function validBishopMove(piece:integer; square:string): Boolean;
begin
  var piecePos:string := Pieces[piece].position;
  var posX,posY,revX,revY:integer;
  Result := False;

  //up-right
  if (getXPosition(piecePos) < 8) and (getYPosition(piecePos) < 8) then
  begin
    //starting from piecepos, check each diagonal square
    posX := getXPosition(piecePos)+1;
    posY := getYPosition(piecePos)+1;
    while (posX<9) and (posY<9) do
    begin
      //if square = Board[posX,posY] then Result := True;
      if square = Board[posX,posY] then
      begin
        revX := getXPosition(square)-1;revY := getYPosition(square)-1;
        while (revX>getXPosition(piecePos)) and (revY>getYPosition(piecePos)) do
          begin
            for var I := Low(Pieces) to High(Pieces) do
              if (Pieces[I].position = Board[revX,revY]) and (Pieces[I].alive) and
              (I<>selectedPiece) then
                begin Result := False;Exit end;
            inc(revX,-1);inc(revY,-1);
          end;
        Result := True;
      end;
      inc(posX);inc(posY)
    end;

  end;

  //up-left
  if (getXPosition(piecePos) > 1) and (getYPosition(piecePos) < 8) then
  begin
    //starting from piecepos, check each diagonal square
    posX := getXPosition(piecePos)-1;
    posY := getYPosition(piecePos)+1;
    while (posX>0) and (posY<9) do
    begin
      //if square = Board[posX,posY] then Result := True;
      if square = Board[posX,posY] then
      begin
        revX := getXPosition(square)+1;revY := getYPosition(square)-1;
        while (revX<getXPosition(piecePos)) and (revY>getYPosition(piecePos)) do
          begin
            for var I := Low(Pieces) to High(Pieces) do
              if (Pieces[I].position = Board[revX,revY]) and (Pieces[I].alive) and
              (I<>selectedPiece) then
                begin Result := False;Exit end;
            inc(revX);inc(revY,-1);
          end;
        Result := True;
      end;
      inc(posX, -1);inc(posY)
    end;

  end;

  //down-right
  if (getXPosition(piecePos) < 8) and (getYPosition(piecePos) > 1) then
  begin
    //starting from piecepos, check each diagonal square
    posX := getXPosition(piecePos)+1;
    posY := getYPosition(piecePos)-1;
    while (posX<9) and (posY>0) do
    begin
      //if square = Board[posX,posY] then Result := True;
      if square = Board[posX,posY] then
      begin
        revX := getXPosition(square)-1;revY := getYPosition(square)+1;
        while (revX>getXPosition(piecePos)) and (revY<getYPosition(piecePos)) do
          begin
            for var I := Low(Pieces) to High(Pieces) do
              if (Pieces[I].position = Board[revX,revY]) and (Pieces[I].alive) and
              (I<>selectedPiece) then
                begin Result := False;Exit end;
            inc(revX,-1);inc(revY);
          end;
        Result := True;
      end;
      inc(posX);inc(posY, -1)
    end;

  end;

  //down-left
  if (getXPosition(piecePos) > 1) and (getYPosition(piecePos) > 1) then
  begin
    //starting from piecepos, check each diagonal square
    posX:= getXPosition(piecePos)-1;
    posY:= getYPosition(piecePos)-1;
    while (posX>0) and (posY>0) do
    begin
      //if square = Board[posX,posY] then Result := True;
      //look for other pieces between square and piecepos
      if square = Board[posX,posY] then
      begin
        revX := getXPosition(square)+1;revY := getYPosition(square)+1;
        while (revX<getXPosition(piecePos)) and (revY<getYPosition(piecePos)) do
          begin
            for var I := Low(Pieces) to High(Pieces) do
              if (Pieces[I].position = Board[revX,revY]) and (Pieces[I].alive) and
              (I<>selectedPiece) then
                begin Result := False;Exit end;
            inc(revX);inc(revY);
          end;
        Result := True;
      end;
      inc(posX,-1);inc(posY, -1)
    end;

  end;

  //check if square is ally, false;
  //if sameColor(piecePos,square) then Result := False;
end;

//queen
function validQueenMove(piece:integer; square:string): Boolean;
begin
  var piecePos:string:=Pieces[piece].position;
  Result := False;
  //easy, just tower+bishop
  if validTowerMove(piece,square) or validBishopMove(piece,square) then Result := True;
end;

//king
function validKingMove(piece:integer;square:string): Boolean;
begin
  var piecePos:string := Pieces[piece].position;
  Result := False;

  //king moves in a 3x3 grid, that is defined by -1,0,1 x&y axis
  var yDif:integer := getYPosition(piecePos)-getYPosition(square);
  var xDif:integer := getXPosition(piecePos)-getXPosition(square);
  if ((yDif>=-1) and (yDif<=1) and ((xDif>=-1) and (xDif<=1))) then Result := True;
  //dont eat ally
  if sameColor(piecePos,square) then Result := False;

end;

//treat each possible piece type
function validMove(piece:integer; square:string): Boolean;
begin
  Result := False;
  var pieceType := Pieces[piece].pieceType;
  if pieceType = 'pawn' then Result := validPawnMove(piece,square) else
  if pieceType = 'tower' then Result := validTowerMove(piece,square) else
  if pieceType = 'knight' then Result := validKnightMove(piece,square) else
  if pieceType = 'bishop' then Result := validBishopMove(piece,square) else
  if pieceType = 'queen' then Result := validQueenMove(piece,square) else
  if pieceType = 'king' then Result := validKingMove(piece,square)
end;

//see if the square is targeted by other enemy pieces
function guardedBy(piece:integer;square:string):boolean;
begin
  var piecePos:string := Pieces[piece].position;
  Result := False;
    //pawn moves (pawns can only move on diagonal IF theres a piece there, this case there isnt, so manual it is)
    if (Pieces[piece].pieceType = 'pawn') and (not sameColor(Pieces[selectedPiece].position,Pieces[piece].position))
    and Pieces[piece].alive then
    begin
      //look at the attack positions of pawn and set colors
      var Y:integer;
      if Pieces[piece].isWhite then Y:=1 else Y:=-1;

      //left
      if (getXPosition(piecePos) < 8) then
      begin
        if square = getPosition(piecePos,1,Y) then
          Result := True;
      end;

      //right
      if (getXPosition(piecePos) > 1) then
      begin
        if square = getPosition(Pieces[piece].position,-1,Y) then
          Result := True;
      end;

      if getXPosition(piecePos) = getXPosition(square) then exit;

    end;

    //normal valid moves
    if validMove(piece,square) and Pieces[piece].alive and
    not sameColor(Pieces[selectedPiece].position,Pieces[piece].position)
    and (Pieces[piece].pieceType<>'pawn') then
    begin
      Result := True;
    end;
end;


//check checkmate for current turn
function checkmate:boolean;
begin
  Result := False;

  //get king pos
  for var I := Low(Pieces) to High(Pieces) do
  begin
    if (Pieces[I].pieceType='king') and (Pieces[I].isWhite=whiteTurn) then
    begin
      var kingPos := Pieces[I].position;

      //check if king is under check
      for var J := Low(Pieces) to High(Pieces) do
      begin
        if validMove(J,kingPos) and (Pieces[J].isWhite<>whiteTurn) and Pieces[J].alive and (I<>J) then
        begin

        //check if any move can put king out of check

        //get each square
        for var K := 1 to 8 do
        begin
          for var L := 1 to 8 do
          begin
          var pos := Board[K,L];

          //check all pieces for the current square
          for var M := Low(Pieces) to High(Pieces) do
          begin
            if (Pieces[M].isWhite=whiteTurn) then
            begin
              //get live piece of the
              if validMove(M,pos) and Pieces[M].alive then
              begin
              var originalPos:=Pieces[M].position;
              var pieceInPos:=getPieceIndex(pos);
              if pieceInPos<>0 then
              begin
                if not sameColor(Pieces[pieceInPos].position,originalPos) and Pieces[pieceInPos].alive then
                begin
                  Pieces[pieceInPos].alive := false;
                end;
              end;
              Pieces[M].position := pos;

              //check if still checked
              for var N := Low(Pieces) to High(Pieces) do
              begin
                if validMove(N,kingPos) and (Pieces[N].isWhite<>whiteTurn) and Pieces[N].alive and (I<>N) then continue
              end;




              end;


            end;


          end;



          end;
        end;

        end;
      end;
    end;

  end;
end;

//see each piece and if diferent black or white, set color based on tag
procedure TChessboard.restoreCheckboard;
begin
  for var X := 1 to 8 do
    for var Y := 1 to 8 do
      if ((TPanel(FindComponent(Board[X,Y])).Color <> clWhite) and
        (TPanel(FindComponent(Board[X,Y])).Color <> clBlack)) then
      begin
        if TPanel(FindComponent(Board[X,Y])).Tag = 1 then
        TPanel(FindComponent(Board[X,Y])).Color := clBlack
        //ShowMessage('Black!')
      else
        TPanel(FindComponent(Board[X,Y])).Color := clWhite;
        //ShowMessage('White!')
      end;
  for var I := Low(Pieces) to High(Pieces) do
    if Pieces[I].isWhite then
      TPanel(FindComponent(Pieces[I].name)).Color := clSilver
    else
      TPanel(FindComponent(Pieces[I].name)).Color := clBackground;
end;

//set global variables
procedure TChessboard.selectPiece(square:TPanel);
begin
  for var I := Low(Pieces) to High(Pieces) do
    //assing index of piece
    if (square.Parent.Name = Pieces[I].position) and Pieces[I].alive and
    (Pieces[I].isWhite = whiteTurn) then
    begin
      selectedPiece := I;
      selectedPanel := square;
      square.Color := clBlue;
      //FUNCITONALIZE: highlight valid moves (update: no need, will only use here)
      for var J := 1 to 8 do
        for var K := 1 to 8 do
          if validMove(selectedPiece,Board[J,K]) then
          begin
            if not sameColor(Pieces[selectedPiece].position,Board[J,K]) then
              TPanel(FindComponent(Board[J,K])).Color := clSkyBlue;
            for var L := Low(Pieces) to High(Pieces) do
            begin
              if guardedBy(L,Board[J,K]) and (L<>selectedPiece) and
              not sameColor(Pieces[L].position,Pieces[selectedPiece].position) then
                begin
                TPanel(FindComponent(Board[J,K])).Color := clRed;
                TPanel(FindComponent(Pieces[L].name)).Color := clMaroon;
                end;
            end;
          end;

      //highlight if checked cus loop above us only look at valid moves for selected
      for var M := Low(Pieces) to High(Pieces) do
      begin
        if guardedBy(M,Pieces[selectedPiece].position) and (M<>selectedPiece) and
        not sameColor(Pieces[M].position,Pieces[selectedPiece].position) then
        begin
          TPanel(FindComponent(Pieces[selectedPiece].position)).Color := clRed;
          TPanel(FindComponent(Pieces[M].name)).Color := clMaroon;
        end;
      end;
    end;
end;

//clear global variables and restore checkboard
procedure TChessboard.releasePiece;
begin
  if selectedPiece <> 0 then
  begin
    if Pieces[selectedPiece].isWhite then
      selectedPanel.Color := clSilver
    else
      selectedPanel.Color := clBackground;
    selectedPiece := 0;selectedPanel := nil;
    restoreCheckboard;
  end;
end;

procedure TChessboard.pieceClick(Sender: TObject);
begin
  //check if nothing is selected
  if selectedPiece = 0 then
  begin
    selectPiece(TPanel(Sender))
  end
  else if Pieces[selectedPiece].position = TPanel(Sender).Parent.Name then
    releasePiece
  else if sameColor(Pieces[selectedPiece].position,TPanel(Sender).Parent.Name) then
  begin
    releasePiece;
    selectPiece(TPanel(Sender));
  end
  else squareClick(TObject(TPanel(Sender).Parent));
end;

procedure TChessboard.squareClick(Sender: TObject);
begin
  var square:string := TPanel(Sender).Name;
  var killedPiece:integer := 0;

  //check if has a selected piece or clicekd on same panel
  if ((selectedPiece = 0) or (Pieces[selectedPiece].position = square)) then Exit;

  //validate ALL pice types and validate move
  if (not validMove(selectedPiece,square) or  sameColor(Pieces[selectedPiece].position,square)) then Exit;

  //kings cant go into checked moves
  if (Pieces[selectedPiece].pieceType='king') and (TPanel(Sender).Color = clRed) then Exit;

  //move the selected piece to the clicked square
  begin
    //check en passant and save its pos
    if square = posEnPassant then
    begin
      for var I := Low(Pieces) to High(Pieces) do
        if Pieces[I].alive and (Pieces[I].pieceType = 'pawn') then
          if ((getPosition(square,0,-1) = Pieces[I].position) or
          (getPosition(square,0,1) = Pieces[I].position)) then
          begin
            TPanel(FindComponent(Pieces[I].name)).Visible := False;
            Pieces[I].alive := False;
            killedPiece:= I;
          end;
    end;

    //kill piece (hide child from parent(brutal!))
    for var I := Low(Pieces) to High(Pieces) do
      if (square = Pieces[I].position) and Pieces[I].alive then
      begin
        TPanel(Sender).Controls[0].Visible := False;
        Pieces[I].alive := False;
        killedPiece := I;
      end;


    //save old pos incase king under check
    var oldPos:string := Pieces[selectedPiece].position;
    var oldPiece:integer := selectedPiece;


    //move piece and update position
    selectedPanel.SetParentComponent(TPanel(Sender));
    Pieces[selectedPiece].position := square;
    releasePiece;

    //check if king is checked then if the move would put it out of check,if yes restore
    for var J := Low(Pieces) to High(Pieces) do
    begin
      if (Pieces[J].pieceType = 'king') and (Pieces[J].isWhite = WhiteTurn) then
      begin
        for var K := Low(Pieces) to High(Pieces) do
          if Pieces[K].alive and (K<>J) and validMove(K,Pieces[J].position) and
          (Pieces[K].isWhite<>Pieces[J].isWhite) then
          //the king is checekd, warn and restore
          begin
            TPanel(FindComponent(Pieces[K].name)).Color := clRed;
            TPanel(FindComponent(Pieces[J].position)).Color := clRed;
            Pieces[oldPiece].position := oldPos;
            TPanel(FindComponent(Pieces[oldPiece].name)).SetParentComponent(FindComponent(oldPos));
            if killedPiece<>0 then
            begin
            Pieces[killedPiece].alive := True;
            TPanel(FindComponent(Pieces[killedPiece].name)).Visible := True;
            end;
            Exit;
          end;

      end;
    end;

    //update en passant
    if canEnPassant then
    begin
      if WhiteTurn then
        posEnPassant := getPosition(square,0,-1)
      else
        posEnPassant := getPosition(square,0,1);
      canEnPassant := False;
    end
    else posEnPassant := '00';

    whiteTurn := not whiteTurn;

    //check if WON(aka check all possible moves and if any would put king out of check)
    if checkmate then ShowMessage('Won!');

    end;
end;

//TODO:
//if someone checkmatted (won)
//pawn upgrades (god damn these panws)
//casteling

//AI (im fucked)
end.
