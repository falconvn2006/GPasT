unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, SpinEx, PanelEstacaoMotor, mgauge, Valve, gridparaprogresscur,
  AMAdvLed,unit2,unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Mgauge1: TMgauge;
    Mgauge2: TMgauge;
    Mgauge3: TMgauge;
    Mgauge4: TMgauge;
    Mgauge5: TMgauge;
    Mgauge6: TMgauge;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    I723EMT1101: TPanelEstacaoMotor;
    PanelEstacaoMotor10: TPanelEstacaoMotor;
    PanelEstacaoMotor11: TPanelEstacaoMotor;
    PanelEstacaoMotor12: TPanelEstacaoMotor;
    PanelEstacaoMotor13: TPanelEstacaoMotor;
    PanelEstacaoMotor14: TPanelEstacaoMotor;
    PanelEstacaoMotor15: TPanelEstacaoMotor;
    PanelEstacaoMotor16: TPanelEstacaoMotor;
    PanelEstacaoMotor17: TPanelEstacaoMotor;
    PanelEstacaoMotor18: TPanelEstacaoMotor;
    PanelEstacaoMotor19: TPanelEstacaoMotor;
    PanelEstacaoMotor2: TPanelEstacaoMotor;
    PanelEstacaoMotor20: TPanelEstacaoMotor;
    PanelEstacaoMotor21: TPanelEstacaoMotor;
    PanelEstacaoMotor22: TPanelEstacaoMotor;
    PanelEstacaoMotor23: TPanelEstacaoMotor;
    PanelEstacaoMotor24: TPanelEstacaoMotor;
    PanelEstacaoMotor25: TPanelEstacaoMotor;
    PanelEstacaoMotor26: TPanelEstacaoMotor;
    PanelEstacaoMotor27: TPanelEstacaoMotor;
    PanelEstacaoMotor28: TPanelEstacaoMotor;
    PanelEstacaoMotor29: TPanelEstacaoMotor;
    PanelEstacaoMotor3: TPanelEstacaoMotor;
    PanelEstacaoMotor30: TPanelEstacaoMotor;
    PanelEstacaoMotor31: TPanelEstacaoMotor;
    PanelEstacaoMotor32: TPanelEstacaoMotor;
    PanelEstacaoMotor33: TPanelEstacaoMotor;
    PanelEstacaoMotor34: TPanelEstacaoMotor;
    PanelEstacaoMotor35: TPanelEstacaoMotor;
    PanelEstacaoMotor36: TPanelEstacaoMotor;
    PanelEstacaoMotor37: TPanelEstacaoMotor;
    PanelEstacaoMotor38: TPanelEstacaoMotor;
    PanelEstacaoMotor39: TPanelEstacaoMotor;
    PanelEstacaoMotor4: TPanelEstacaoMotor;
    PanelEstacaoMotor40: TPanelEstacaoMotor;
    PanelEstacaoMotor41: TPanelEstacaoMotor;
    PanelEstacaoMotor42: TPanelEstacaoMotor;
    PanelEstacaoMotor43: TPanelEstacaoMotor;
    PanelEstacaoMotor44: TPanelEstacaoMotor;
    PanelEstacaoMotor45: TPanelEstacaoMotor;
    PanelEstacaoMotor46: TPanelEstacaoMotor;
    PanelEstacaoMotor47: TPanelEstacaoMotor;
    PanelEstacaoMotor48: TPanelEstacaoMotor;
    PanelEstacaoMotor49: TPanelEstacaoMotor;
    PanelEstacaoMotor5: TPanelEstacaoMotor;
    PanelEstacaoMotor50: TPanelEstacaoMotor;
    PanelEstacaoMotor51: TPanelEstacaoMotor;
    PanelEstacaoMotor52: TPanelEstacaoMotor;
    PanelEstacaoMotor53: TPanelEstacaoMotor;
    PanelEstacaoMotor55: TPanelEstacaoMotor;
    PanelEstacaoMotor56: TPanelEstacaoMotor;
    PanelEstacaoMotor57: TPanelEstacaoMotor;
    PanelEstacaoMotor6: TPanelEstacaoMotor;
    PanelEstacaoMotor7: TPanelEstacaoMotor;
    PanelEstacaoMotor8: TPanelEstacaoMotor;
    PanelEstacaoMotor9: TPanelEstacaoMotor;
    SpinEditEx1: TSpinEditEx;
    SpinEditEx2: TSpinEditEx;
    SpinEditEx4: TSpinEditEx;
    SpinEditEx5: TSpinEditEx;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure I723EMT1101BtDesliga(Sender: TObject);
    procedure I723EMT1101BtLiga(Sender: TObject);
    procedure I723EMT1101Click(Sender: TObject);
    procedure Panel5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure I723EMT1101BtAjuda(Sender: TObject);
    procedure PanelEstacaoMotor25BtAjuda(Sender: TObject);
    procedure PanelEstacaoMotor25BtDesliga(Sender: TObject);
    procedure PanelEstacaoMotor25Click(Sender: TObject);
    procedure PanelEstacaoMotor27BtAjuda(Sender: TObject);
    procedure PanelEstacaoMotor3Click(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  valores  : tstringlist;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  valores:=tstringlist.Create;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     valores.LoadFromFile('valores.db');
end;

procedure TForm1.I723EMT1101BtDesliga(Sender: TObject);
begin
  form2.Caption:=I723EMT1101.Name;
  form2.DisjNome.Caption:=I723EMT1101.Name;
  form2.StaticText1.caption:='Desligado';
  form2.Button1.caption:='Ligar';
  form2.Button2.Caption:='Desligar';
  form2.DisjNome1.caption:='Motor do ventilador induzido 1';
  form2.showmodal;
end;

procedure TForm1.I723EMT1101BtLiga(Sender: TObject);
begin

end;

procedure TForm1.I723EMT1101Click(Sender: TObject);
begin

end;

procedure TForm1.Panel5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.I723EMT1101BtAjuda(Sender: TObject);
begin
  form2.Caption:=I723EMT1101.Name;
  form2.DisjNome.Caption:=I723EMT1101.Name;
  form2.StaticText1.caption:='Desligado';
  form2.Button1.caption:='Ligar';
  form2.Button2.Caption:='Desligar';
  form2.DisjNome1.caption:='Motor do ventilador induzido 1';
  form2.showmodal;
end;

procedure TForm1.PanelEstacaoMotor25BtAjuda(Sender: TObject);
begin

end;

procedure TForm1.PanelEstacaoMotor25BtDesliga(Sender: TObject);
begin

end;

procedure TForm1.PanelEstacaoMotor25Click(Sender: TObject);
begin

end;

procedure TForm1.PanelEstacaoMotor27BtAjuda(Sender: TObject);
begin

end;

procedure TForm1.PanelEstacaoMotor3Click(Sender: TObject);
begin

end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
  //edit1.text:='ok';
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  mgauge1.posicao:=trackbar1.Position;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
    mgauge1.erro:=trackbar2.position;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
    PanelEstacaoMotor8.desLigado:=not PanelEstacaoMotor8.desLigado;



end;

procedure TForm1.Button1Click(Sender: TObject);
begin

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     form3.show;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  valores.Destroy;
end;

end.

