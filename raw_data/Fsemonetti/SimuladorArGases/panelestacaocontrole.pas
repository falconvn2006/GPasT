unit PanelEstacaoControle;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,StdCtrls,Graphics,extctrls,dialogs;
       type

        { TPanelEstacaoMotor }

        TPanelEstacaoControle = Class(TPanel)
          private
            Fbloqueado: boolean;
            FBtLiga: tnotifyevent;
            FDesligado: boolean;
            FLigado: boolean;
            FNovoEvento    : TNotifyEvent;
            Bdesliga       : Tbutton;
            BLiga          : Tbutton;
            BCentro        : Tbutton;
            Edit           : Tedit;
            FDescriInferior: string;
            FDescriSuperior: string;
            Fdesligar      : boolean;
            Fligar: boolean;
            FTexto: string;
            LDesligado:Tshape;
            LLigado   :Tshape;
            LFalha    :Tshape;
            Pisca     : Ttimer;
            Nome      : Tlabel;
            NomeS     : Tlabel;
            procedure Setbloqueado(AValue: boolean);
            procedure SetBtLiga(AValue: tnotifyevent);
            procedure SetDescriInferior(AValue: string);
            procedure SetDescriSuperior(AValue: string);
            procedure SetDesligado(AValue: boolean);
            procedure Setdesligar(AValue: boolean);
            procedure SetLigado(AValue: boolean);
            procedure Setligar(AValue: boolean);
            procedure SetNovoEvento(AValue: tnotifyevent);
            procedure SetTexto(AValue: string);
          protected
            procedure EVNovoEvento; dynamic;
            procedure FVNovoEvento; dynamic;

          public
            constructor Create(TheOwner: TComponent); override;
            destructor Destroy; override;
            procedure Paint; override;
            Function Tamanho(Texto:String; Fonte:TFont) : integer;
            procedure ClickButton1(Sender: TObject);
            property desligar:boolean read Fdesligar write Setdesligar;
            property ligar:boolean read Fligar write Setligar;
            published
            property DescriSuperior : string read FDescriSuperior write SetDescriSuperior;
            property DescriInferior : string read FDescriInferior write SetDescriInferior;
             property BtDesliga : tnotifyevent read FNovoEvento write SetNovoEvento;
            property BtLiga : tnotifyevent read FBtLiga write SetBtLiga;
            property Ligado : boolean read FLigado write SetLigado;
            property Desligado : boolean read FDesligado write SetDesligado;
            property bloqueado :boolean read Fbloqueado write Setbloqueado;
            property Texto :string read FTexto write SetTexto;


        end;
  procedure Register;
implementation

{ TPanelEstacaoMotor }
procedure Register;
begin
  RegisterComponents('Fabricio', [TPanelEstacaoControle]);
end;
function TPanelEstacaoControle.Tamanho(Texto: String; Fonte: TFont): integer;
var
  LBmp: TBitmap;
begin
  LBmp := TBitmap.Create;
  try
   LBmp.Canvas.Font := Font;
   Result := LBmp.Canvas.TextWidth(Texto);
  finally
   LBmp.Free;
  end;
end;

procedure TPanelEstacaoControle.FVNovoEvento;
begin
  if Assigned( FBtLiga ) then
    FBtLiga( Self );
end;
procedure TPanelEstacaoControle.EVNovoEvento;
begin
  if Assigned( FNovoEvento ) then
    FNovoEvento( Self );
end;

procedure TPanelEstacaoControle.ClickButton1(Sender: TObject);
begin
 if (Bdesliga.Focused) then
 begin
 desligar:=true;
 //LDesligado.Brush.Color:=clred;
// Lligado.Brush.Color:=clgray;
// Lligado.Paint;
// Ldesligado.Paint;
 self.EVNovoEvento;

 end;
 if (Bliga.Focused) then
 begin
 ligar:=true;
 //Lligado.Brush.Color:=clred;
 //LDesligado.Brush.Color:=clgray;
 // Lligado.Paint;
 //Ldesligado.Paint;
 self.FVNovoEvento;
 end;

end;
procedure TPanelEstacaoControle.SetDescriInferior(AValue: string);

begin
  if FDescriInferior=AValue then Exit;
  FDescriInferior:=AValue;
  Nome.Left:=round((120-Tamanho(Avalue,Nome.Font))/2);
  Nome.Caption:=AValue;
end;


procedure TPanelEstacaoControle.SetBtLiga(AValue: tnotifyevent);
begin
  if FBtLiga=AValue then Exit;
  FBtLiga:=AValue;
end;

procedure TPanelEstacaoControle.Setbloqueado(AValue: boolean);
begin
  if Fbloqueado=AValue then Exit;
  Fbloqueado:=AValue;
  if  Fbloqueado=false then
  begin
   LFalha.brush.Color:=clgray;
   LFalha.repaint;
  end
  else
  begin
    LFalha.brush.Color:=clred;
    LFalha.repaint;
  end;

end;

procedure TPanelEstacaoControle.SetDescriSuperior(AValue: string);
begin
  if FDescriSuperior=AValue then Exit;
  FDescriSuperior:=AValue;
  NomeS.Caption:=AValue;
  NomeS.Left:=round((120-Tamanho(Avalue,NomeS.Font))/2);
  NomeS.Caption:=AValue;
end;

procedure TPanelEstacaoControle.SetDesligado(AValue: boolean);
begin
  if FDesligado=AValue then Exit;
  FDesligado:=AValue;
  if  FDesligado=false then
  begin
   LDesligado.brush.Color:=clgray;
   Ldesligado.repaint;
  end
  else
  begin
    LDesligado.brush.Color:=clgreen;
    Ldesligado.repaint;
  end;
end;

procedure TPanelEstacaoControle.SetLigado(AValue: boolean);
begin
  if FLigado=AValue then Exit;
  FLigado:=AValue;
    if  FLigado=false then
  begin
   LLigado.brush.Color:=clgray;
   LLigado.repaint;
  end
  else
  begin
    LLigado.brush.Color:=clgreen;
    LLigado.repaint;
  end;

end;


procedure TPanelEstacaoControle.Setdesligar(AValue: boolean);
begin
  if Fdesligar=AValue then Exit;
  Fdesligar:=AValue;
end;
procedure TPanelEstacaoControle.Setligar(AValue: boolean);
begin
  if Fligar=AValue then Exit;
  Fligar:=AValue;
end;

procedure TPanelEstacaoControle.SetNovoEvento(AValue: tnotifyevent);
begin
  if FNovoEvento=AValue then Exit;
  FNovoEvento:=AValue;
end;

procedure TPanelEstacaoControle.SetTexto(AValue: string);
begin
  if FTexto=AValue then Exit;
  FTexto:=AValue;
  self.Edit.Text:=AValue;
end;

constructor TPanelEstacaoControle.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption:='';
  Color:=$00808040;
  Width:=120;
  Height:=91;
  Top:=10;;
  Left:=50;


  Edit:= Tedit.create(nil);
  Edit.Parent:=self;
  Edit.text:='Corrente A';
  Edit.Top:=1;;
  Edit.Left:=1;
  Edit.Height:=18;
  Edit.Width:=119;
  Edit.Alignment:=taCenter;

  Bdesliga:= Tbutton.Create(nil);
  Bdesliga.parent:=self;
  Bdesliga.Color:=8;
  Bdesliga.Width:=20;
  Bdesliga.Height:=20;
  Bdesliga.Top:=70;;
  Bdesliga.Left:=0;
  Bdesliga.Caption:='';
  Bdesliga.onclick := @ClickButton1;

  BCentro:= Tbutton.Create(nil);
  BCentro.parent:=self;
  BCentro.Color:=8;
  BCentro.Width:=20;
  BCentro.Height:=20;
  BCentro.Top:=70;
  BCentro.Left:=60;
  BCentro.Caption:='';
  Bliga.onclick := @ClickButton1;


  BLiga:= Tbutton.Create(nil);
  BLiga.parent:=self;
  BLiga.Color:=8;
  BLiga.Width:=20;
  BLiga.Height:=20;
  BLiga.Top:=70;
  BLiga.Left:=99;
  Bliga.Caption:='';
  Bliga.onclick := @ClickButton1;

  Nome:= Tlabel.Create(nil);
  Nome.Parent:=self;
  Nome.Caption:='Motor';
  Nome.Top:=56;;
  Nome.Left:=4;

  NomeS:= Tlabel.Create(nil);
  NomeS.Parent:=self;
  NomeS.Caption:='Motor';
  NomeS.Top:=43;;
  NomeS.Left:=4;

  Pisca:=Ttimer.create(nil);

  LDesligado:=Tshape.create(nil);
  LDesligado.parent:=self;
  LDesligado.Color:=8;
  LDesligado.Width:=18;
  LDesligado.Height:=18;
  LDesligado.Top:=25;;
  LDesligado.Left:=2;
  LDesligado.Brush.Color:=clGray;

  LFalha:=Tshape.create(nil);
  LFalha.parent:=self;
  LFalha.Color:=8;
  LFalha.Width:=18;
  LFalha.Height:=18;
  LFalha.Top:=25;;
  LFalha.Left:=50;
  LFalha.Brush.Color:=clMenuBar;
  LFalha.Shape:=stCircle;

  LLigado:=Tshape.create(nil);
  LLigado.parent:=self;
  LLigado.Color:=8;
  LLigado.Width:=18;
  LLigado.Height:=18;
  LLigado.Top:=25;
  LLigado.Left:=101;
  LLigado.Brush.Color:=clMenuBar;

end;

destructor TPanelEstacaoControle.Destroy;
begin
  inherited Destroy;
  Bdesliga.Destroy;
  BLiga.Destroy;
  LLigado.Destroy;
  LDesligado.Destroy;
  LFalha.Destroy;
  Pisca.Destroy;
  bcentro.Destroy;
end;

procedure TPanelEstacaoControle.Paint;
begin
  inherited Paint;
end;

end.

