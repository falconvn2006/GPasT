unit Delphi_Chess;

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
  Generics.Collections;

type
  TPiece = record
    pieceType : string;
    position : string;
    isWhite : boolean;
    end;
  TChessboard = class(TForm)
    A8: TPanel;
    B8: TPanel;
    D8: TPanel;
    C8: TPanel;
    H8: TPanel;
    G8: TPanel;
    F9: TPanel;
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
    PieceA: TPanel;
    PieceB: TPanel;
    procedure squareClick(Sender: TObject);
    procedure pieceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Chessboard: TChessboard;
  selectedPiece : TPanel;
  oldColor : TColor;
const
  Board : array[1..8] of array[1..8] of string =
  (
   ('A1','A2','A3','A4','A5','A6','A7','A8'),
   ('B1','B2','B3','B4','B5','B6','B7','B8'),
   ('C1','C2','C3','C4','C5','C6','C7','C8'),
   ('D1','D2','D3','D4','D5','D6','D7','D8'),
   ('E1','E2','E3','E4','E5','E6','E7','E8'),
   ('F1','F2','F3','F4','F5','F6','F7','F8'),
   ('G1','G2','G3','G4','G5','G6','G7','G8'),
   ('H1','H2','H3','H4','H5','H6','H7','H8')
  );

implementation

{$R *.dfm}

procedure TChessboard.pieceClick(Sender: TObject);
begin
  if selectedPiece = TPanel(Sender) then
    begin
    selectedPiece.Color := oldColor;
    selectedPiece := nil
    end
  else if selectedPiece = nil then
    begin
    selectedPiece := TPanel(Sender);
    oldColor := TPanel(Sender).Color;
    selectedPiece.Color := clBlue;
    end;
end;

procedure TChessboard.squareClick(Sender: TObject);
begin
  if (selectedPiece <> nil) and (TPanel(Sender).Tag = 0) then
  begin
    selectedPiece.GetParentComponent.Tag := 0;
    TPanel(Sender).Tag := 1;
    selectedPiece.SetParentComponent(TPanel(Sender));
    //for var I := 1 to 8 do
      //for var J := 1 to 8 do
        //if Board[I,J] = TPanel(Sender).Name then ShowMessage(Board[I,J]);
      //;
    //;
  end;

end;

end.
