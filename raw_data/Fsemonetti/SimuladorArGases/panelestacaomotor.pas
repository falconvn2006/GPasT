 unit PanelEstacaoMotor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,StdCtrls,Graphics,extctrls,dialogs, LCLIntf, LCLType;
       type

        { TPanelEstacaoMotor }

        TPanelEstacaoMotor = Class(TPanel)
          private
            Fbloqueado: boolean;
            FBManAut: tnotifyevent;
            FBtLiga: tnotifyevent;
            Fcomutar: boolean;
            FCorFundo: Tcolor;
            FCorTexto: tcolor;
            FDesligado: boolean;
            Fdeslocamento: integer;
            FLigado: boolean;
            FNovoEvento    : TNotifyEvent;
            Bdesliga       : Tbutton;
            BLiga          : Tbutton;
            Bcentro        : Tbutton;
            Edit           : Tedit;
            FDescriInferior: string;
            FDescriSuperior: string;
            Fdesligar      : boolean;
            Fligar: boolean;
            FOffCentro: boolean;
            FoffDesliga: boolean;
            FoffEdit: boolean;
            FoffLiga: boolean;
            FTexto: string;
            LDesligado:Tshape;
            LLigado   :Tshape;
            LFalha    :Tshape;
            Pisca     : Ttimer;
            Nome      : Tlabel;
            NomeS     : Tlabel;
            procedure Setbloqueado(AValue: boolean);
            procedure SetBManAut(AValue: tnotifyevent);
            procedure SetBtLiga(AValue: tnotifyevent);
            procedure Setcomutar(AValue: boolean);
            procedure SetCorFundo(AValue: Tcolor);
            procedure SetCorTexto(AValue: tcolor);
            procedure SetDescriInferior(AValue: string);
            procedure SetDescriSuperior(AValue: string);
            procedure SetDesligado(AValue: boolean);
            procedure Setdesligar(AValue: boolean);
            procedure Setdeslocamento(AValue: integer);
            procedure SetLigado(AValue: boolean);
            procedure Setligar(AValue: boolean);
            procedure SetNovoEvento(AValue: tnotifyevent);
            procedure SetOffCentro(AValue: boolean);
            procedure SetoffDesliga(AValue: boolean);
            procedure SetoffEdit(AValue: boolean);
            procedure SetoffLiga(AValue: boolean);
            procedure SetTexto(AValue: string);
          protected
            procedure EVNovoEvento; dynamic;
            procedure FVNovoEvento; dynamic;
            procedure FMANovoEvento; dynamic;
            procedure Ajuda;dynamic;
            public
            constructor Create(TheOwner: TComponent); override;
            destructor Destroy; override;
            procedure Paint; override;
            Function Tamanho(Texto:String; Fonte:TFont) : integer;
            procedure ClickButton1(Sender: TObject);
            property desligar:boolean read Fdesligar write Setdesligar;
            property ligar:boolean read Fligar write Setligar;
            property comutar:boolean read Fcomutar write Setcomutar;
            property deslocamento : integer read Fdeslocamento write Setdeslocamento;
            published
            property DescriSuperior : string read FDescriSuperior write SetDescriSuperior;
            property DescriInferior : string read FDescriInferior write SetDescriInferior;
            property BtDesliga : tnotifyevent read FNovoEvento write SetNovoEvento;
            property BtLiga    : tnotifyevent read FBtLiga write SetBtLiga;
            property BManAut   : tnotifyevent read FBManAut write SetBManAut;
            property BtAjuda    : tnotifyevent read FNovoEvento write SetNovoEvento;
            property Ligado : boolean read FLigado write SetLigado;
            property Desligado : boolean read FDesligado write SetDesligado;
            property bloqueado :boolean read Fbloqueado write Setbloqueado;
            property Texto :string read FTexto write SetTexto;
            property OffCentro : boolean read FOffCentro write SetOffCentro;
            property offEdit : boolean read FoffEdit write SetoffEdit;
            property CorFundo: Tcolor read FCorFundo write SetCorFundo;
            property offDesliga : boolean read FoffDesliga write SetoffDesliga;
            property offLiga    : boolean read FoffLiga write SetoffLiga;
            property CorTexto : tcolor read FCorTexto write SetCorTexto;

        end;
  procedure Register;
implementation

{ TPanelEstacaoMotor }
procedure Register;
begin
  RegisterComponents('Fabricio', [TPanelEstacaoMotor]);
end;
function TPanelEstacaoMotor.Tamanho(Texto: String; Fonte: TFont): integer;
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

procedure TPanelEstacaoMotor.FMANovoEvento;
begin
  if Assigned( BManAut ) then
    BManAut( Self );
end;

procedure TPanelEstacaoMotor.Ajuda;
begin

end;


procedure TPanelEstacaoMotor.FVNovoEvento;
begin
  if Assigned( FBtLiga ) then
    FBtLiga( Self );
end;
procedure TPanelEstacaoMotor.EVNovoEvento;
begin
  if Assigned( FNovoEvento ) then
    FNovoEvento( Self );
end;

procedure TPanelEstacaoMotor.ClickButton1(Sender: TObject);
//var
 // apertada : integer;
//  currentShiftState: TShiftState;
begin
   //  currentShiftState:=GetKeyShiftState;
 if (Bdesliga.Focused) then
 begin
 desligar:=true;
 self.EVNovoEvento;

 //apertada:=GetKeyState(VK_SHIFT);   if apertada<0 then    showmessage(inttostr(apertada));
// if ssShift in currentShiftState then self.Ajuda;
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
     if (Bcentro.Focused) then
 begin
 Comutar:=true;
 //Lligado.Brush.Color:=clred;
 //LDesligado.Brush.Color:=clgray;
 // Lligado.Paint;
 //Ldesligado.Paint;
 self.FMANovoEvento;
 end;
end;
procedure TPanelEstacaoMotor.SetDescriInferior(AValue: string);

begin
  if FDescriInferior=AValue then Exit;
  FDescriInferior:=AValue;
  Nome.Left:=round((120-Tamanho(Avalue,Nome.Font))/2);
  Nome.Caption:=AValue;
end;


procedure TPanelEstacaoMotor.SetBtLiga(AValue: tnotifyevent);
begin
  if FBtLiga=AValue then Exit;
  FBtLiga:=AValue;
end;

procedure TPanelEstacaoMotor.Setcomutar(AValue: boolean);
begin
  if Fcomutar=AValue then Exit;
  Fcomutar:=AValue;
end;

procedure TPanelEstacaoMotor.SetCorFundo(AValue: Tcolor);
begin
  if FCorFundo=AValue then Exit;
  FCorFundo:=AValue;
  self.color:=Avalue;
end;

procedure TPanelEstacaoMotor.SetCorTexto(AValue: tcolor);
begin
  if FCorTexto=AValue then Exit;
  FCorTexto:=AValue;
  nome.Font.Color:=Avalue;
  nomes.Font.Color:=Avalue;

end;

procedure TPanelEstacaoMotor.Setbloqueado(AValue: boolean);
begin
  if Fbloqueado=AValue then Exit;
  Fbloqueado:=AValue;
  if  Fbloqueado=false then
  begin
   LFalha.brush.Color:=clSilver;
   LFalha.repaint;
  end
  else
  begin
    LFalha.brush.Color:=clred;
    LFalha.repaint;
  end;

end;

procedure TPanelEstacaoMotor.SetBManAut(AValue: tnotifyevent);
begin
  if FBManAut=AValue then Exit;
  FBManAut:=AValue;
end;

procedure TPanelEstacaoMotor.SetDescriSuperior(AValue: string);
begin
  if FDescriSuperior=AValue then Exit;
  FDescriSuperior:=AValue;
  NomeS.Caption:=AValue;
  NomeS.Left:=round((120-Tamanho(Avalue,NomeS.Font))/2);
  NomeS.Caption:=AValue;
end;

procedure TPanelEstacaoMotor.SetDesligado(AValue: boolean);
begin
  if FDesligado=AValue then Exit;
  FDesligado:=AValue;
  if  FDesligado=false then
  begin
   LDesligado.brush.Color:=clSilver;
   Ldesligado.repaint;
  end
  else
  begin
    LDesligado.brush.Color:=$0062B0FF;
    Ldesligado.repaint;
  end;
end;

procedure TPanelEstacaoMotor.SetLigado(AValue: boolean);
begin
  if FLigado=AValue then Exit;
  FLigado:=AValue;
    if  FLigado=false then
  begin
   LLigado.brush.Color:=clSilver;
   LLigado.repaint;
  end
  else
  begin
    LLigado.brush.Color:=clgreen;
    LLigado.repaint;
  end;

end;


procedure TPanelEstacaoMotor.Setdesligar(AValue: boolean);
begin
  if Fdesligar=AValue then Exit;
  Fdesligar:=AValue;
end;

procedure TPanelEstacaoMotor.Setdeslocamento(AValue: integer);
begin
  if Fdeslocamento=AValue then Exit;
  Fdeslocamento:=AValue;
end;

procedure TPanelEstacaoMotor.Setligar(AValue: boolean);
begin
  if Fligar=AValue then Exit;
  Fligar:=AValue;
end;

procedure TPanelEstacaoMotor.SetNovoEvento(AValue: tnotifyevent);
begin
  if FNovoEvento=AValue then Exit;
  FNovoEvento:=AValue;
end;

procedure TPanelEstacaoMotor.SetOffCentro(AValue: boolean);
begin
  if FOffCentro=AValue then Exit;
  FOffCentro:=AValue;
  self.Bcentro.Visible:= not   self.Bcentro.Visible;

  if Bcentro.visible=true then
  begin
   LDesligado.Left:=20;
   LLigado.Left:=81;
   repaint;

  end
  else
  begin
     LDesligado.Left:=2;
   LLigado.Left:=101;
   repaint;
  end;

end;

procedure TPanelEstacaoMotor.SetoffDesliga(AValue: boolean);
begin
  if FoffDesliga=AValue then Exit;
  FoffDesliga:=AValue;
  self.Bdesliga.Visible:=not self.Bdesliga.Visible;
end;

procedure TPanelEstacaoMotor.SetoffEdit(AValue: boolean);
begin
  if FoffEdit=AValue then Exit;
  FoffEdit:=AValue;
  if offedit=true then deslocamento:=-20 else deslocamento:=0;
  if offedit=true then edit.Visible:=false else edit.Visible:=true;

  Height:=91+deslocamento;
  Edit.Top:=1+deslocamento;;
  Bdesliga.Top:=70+deslocamento;;
  BCentro.Top:=70+deslocamento;
  BLiga.Top:=70+deslocamento;
  Nome.Top:=56+deslocamento;;
  NomeS.Top:=43+deslocamento;;
  LDesligado.Top:=25+deslocamento;;
  LFalha.Top:=25+deslocamento;;
  LLigado.Top:=25+deslocamento;
  self.Repaint;
end;

procedure TPanelEstacaoMotor.SetoffLiga(AValue: boolean);
begin
  if FoffLiga=AValue then Exit;
  FoffLiga:=AValue;
  self.BLiga.Visible:=not self.BLiga.Visible;
end;



procedure TPanelEstacaoMotor.SetTexto(AValue: string);
begin
  if FTexto=AValue then Exit;
  FTexto:=AValue;
  self.Edit.Text:=AValue;
end;

constructor TPanelEstacaoMotor.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption:='';
  Color:=$00808040;
  Width:=120;
  Height:=91+deslocamento;
  Top:=10;;
  Left:=50;


  Edit:= Tedit.create(nil);
  Edit.Parent:=self;
  Edit.text:='Corrente A';
  Edit.Top:=1+deslocamento;;
  Edit.Left:=1;
  Edit.Height:=18;
  Edit.Width:=119;
  Edit.Alignment:=taCenter;
  Edit.Enabled:=false;

  Bdesliga:= Tbutton.Create(nil);
  Bdesliga.parent:=self;
  Bdesliga.Color:=$000080FF;
  Bdesliga.Width:=20;
  Bdesliga.Height:=20;
  Bdesliga.Top:=70+deslocamento;;
  Bdesliga.Left:=0;
  Bdesliga.Caption:='';
  Bdesliga.onclick := @ClickButton1;


  BCentro:= Tbutton.Create(nil);
  BCentro.parent:=self;
  BCentro.Color:=8;
  BCentro.Width:=20;
  BCentro.Height:=20;
  BCentro.Top:=70+deslocamento;
  BCentro.Left:=50;
  BCentro.Caption:='';
  BCentro.onclick := @ClickButton1;






  BLiga:= Tbutton.Create(nil);
  BLiga.parent:=self;
  BLiga.Color:=8;
  BLiga.Width:=20;
  BLiga.Height:=20;
  BLiga.Top:=70+deslocamento;
  BLiga.Left:=99;
  Bliga.Caption:='';
  Bliga.onclick := @ClickButton1;

  Nome:= Tlabel.Create(nil);
  Nome.Parent:=self;
  Nome.Caption:='Motor';
  Nome.Top:=56+deslocamento;;
  Nome.Left:=4;

  NomeS:= Tlabel.Create(nil);
  NomeS.Parent:=self;
  NomeS.Caption:='Motor';
  NomeS.Top:=43+deslocamento;;
  NomeS.Left:=4;

  Pisca:=Ttimer.create(nil);

  LDesligado:=Tshape.create(nil);
  LDesligado.parent:=self;
  LDesligado.Color:=8;
  LDesligado.Width:=18;
  LDesligado.Height:=18;
  LDesligado.Top:=25+deslocamento;;
  LDesligado.Left:=20;
  LDesligado.Brush.Color:=clSilver;

  LFalha:=Tshape.create(nil);
  LFalha.parent:=self;
  LFalha.Color:=8;
  LFalha.Width:=18;
  LFalha.Height:=18;
  LFalha.Top:=25+deslocamento;;
  LFalha.Left:=50;
  LFalha.Brush.Color:=clSilver;
  LFalha.Shape:=stCircle;

  LLigado:=Tshape.create(nil);
  LLigado.parent:=self;
  LLigado.Color:=8;
  LLigado.Width:=18;
  LLigado.Height:=18;
  LLigado.Top:=25+deslocamento;
  LLigado.Left:=81;
  LLigado.Brush.Color:=clSilver;

end;

destructor TPanelEstacaoMotor.Destroy;
begin
  inherited Destroy;
  Bdesliga.Destroy;
  BLiga.Destroy;
  LLigado.Destroy;
  LDesligado.Destroy;
  LFalha.Destroy;
  Pisca.Destroy;
  Edit.Destroy;
  Bcentro.Destroy;

end;

procedure TPanelEstacaoMotor.Paint;
begin
  inherited Paint;

end;

end.

