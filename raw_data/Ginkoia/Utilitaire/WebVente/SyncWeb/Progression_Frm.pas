unit Progression_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxProgressBar, StdCtrls, RzLabel;

type
  TFrm_Progression = class(TForm)
    Prg_Fic: TcxProgressBar;
    Lab_Fichier: TRzLabel;
    Lab_Ligne: TLabel;
    Prg_Lig: TcxProgressBar;
    Lab_NomFic: TRzLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    PosFichier:integer;
    NbFichier:integer;
    PosLigne:integer;
    NbLigne:integer;
    function MaxCent(Value:Double):Double;
  public
    { Déclarations publiques }
    procedure Init(ANomFic:string;ANbFichier:integer);
    procedure SetFichier(ANomFic:string;ANbLigne:integer);
    procedure IncLigne(const Nb:integer=1);
  end;

var
  Frm_Progression: TFrm_Progression;

implementation

{$R *.dfm} 

function TFrm_Progression.MaxCent(Value:Double):Double;
begin
  if Value>100 then
    Result:=100.0
  else
    Result:=Value;
end;

procedure TFrm_Progression.FormCreate(Sender: TObject);
begin
  Lab_NomFic.Caption:='';
  Prg_Fic.Position:=0;
  Prg_Lig.Position:=0;
end; 

procedure TFrm_Progression.Init(ANomFic:string;ANbFichier:integer);
begin
  Lab_NomFic.Caption:=ANomFic;
  NbFichier:=ANbFichier;
  PosFichier:=0;
  Prg_Fic.Position:=0;
  Prg_Lig.Position:=0;
  Show;
  Update;
  Application.ProcessMessages;
  BringToFront;
  Application.ProcessMessages;
end;

procedure TFrm_Progression.SetFichier(ANomFic:string;ANbLigne:integer);
begin   
  Lab_NomFic.Caption:=ANomFic;
  inc(PosFichier);
  Prg_Fic.Position:=MaxCent((PosFichier/NbFichier)*100);
  Prg_Lig.Position:=0;
  PosLigne:=0;
  NbLigne:=ANbLigne;
  BringToFront;
  Application.ProcessMessages;
end;

procedure TFrm_Progression.IncLigne(const Nb:integer=1);
begin
  inc(PosLigne,Nb);
  Prg_Lig.Position:=MaxCent((PosLigne/NbLigne)*100);   
  BringToFront;
  Application.ProcessMessages;
end;

end.
