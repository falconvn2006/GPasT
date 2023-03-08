unit uTelaJogo01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls,  FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.Layouts, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Media
  ,System.StrUtils

//  ,System.IOUtils
  ,FMX.Forms
  ,System.Math.Vectors, FMX.Controls3D, FMX.Layers3D
  ,FMX.Objects

  {$IFDEF ANDROID}
  ,Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net, Androidapi.Helpers, FMX.Helpers.android,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Ani, FMX.Maps, FMX.WebBrowser, FMX.Edit, FMX.DateTimeCtrls, FMX.Effects,
  FMX.ListView, FMX.TabControl
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  ,DateUtils
  {$ENDIF}

  ;



type
  TF_TelaJogo = class(TForm)
    ActionList1: TActionList;
    pth1: TPath;
    pth2: TPath;
    pth3: TPath;
    pth4: TPath;
    pth5: TPath;
    actSair: TAction;
    Timer1: TTimer;
    lblPontos: TLabel;
    lblTempo: TLabel;
    lyt04: TLayout;
    Layout3D4: TLayout3D;
    MediaPlayerfundo: TMediaPlayer;
    MediaPlayerAplausos: TMediaPlayer;
    lytParabens: TLayout;
    Image1: TImage;
    ImageGeral: TImage;
    circle1: TCircle;
    lytHeader: TLayout;
    rectHeader: TRectangle;
    lytGeral: TLayout;
    Circle2: TCircle;
    Circle3: TCircle;
    Circle4: TCircle;
    Circle5: TCircle;
    MediaPlayerAcerto: TMediaPlayer;
    lytFooter: TLayout;
    rectFooter: TRectangle;
    lblCursor: TLabel;
    MediaPlayerErro: TMediaPlayer;
    Timer2: TTimer;
    TimerClock: TTimer;
    Image2: TImage;
    imgErro: TImage;
    procedure actSairExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure circle1Click(Sender: TObject);
    procedure ImageGeralClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image2Click(Sender: TObject);
    procedure ImageGeralMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    pontoIni: integer;
    Segundo: integer;
    Minuto: integer;
//    procedure CalcularAcerto(tag: integer);
//    procedure CalcularAcerto(Sender: TObject);
    procedure CalcularAcerto(Sender: TObject; tag: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_TelaJogo: TF_TelaJogo;

implementation

{$R *.fmx}

uses
System.iOUtils, Globais;

//procedure TF_TelaJogo.CalcularAcerto(Sender: TObject);
procedure TF_TelaJogo.CalcularAcerto(Sender: TObject; tag: Integer);
var
    Componente: TComponent;
    oCircle : TCircle;
    oImage  : TImage;
begin
    oCircle := TCircle(Sender);
    oImage  := TImage(Sender);
    imgErro.Visible := false;

    if tag = 99 then
    begin
       {$IFDEF MSWINDOWS}
       MediaPlayerErro.Stop;
       MediaPlayerErro.FileName     := 'C:\univesp\PI II\Jogos\Delphi\Meus\Teste 01\audios\erro.mp3';
       MediaPlayerErro.Play;
       {$ENDIF}

       lblCursor.Text := '(: Tente novamente!';
    end;

    if (tag > 0) and (tag < 99) then
    begin
       pontoIni := pontoIni + 1;
       lblPontos.Text := pontoIni.ToString;

       if pontoIni = 1 then begin
            pth1.Fill.Color := $FF1FC647;
       end else if pontoIni = 2 then begin
            pth2.Fill.Color := $FF1FC647;
       end else if pontoIni = 3 then begin
            pth3.Fill.Color := $FF1FC647;
       end else if pontoIni = 4 then begin
            pth4.Fill.Color := $FF1FC647;
       end else if pontoIni = 5 then begin
            pth5.Fill.Color := $FF1FC647;
       end;

       {$IFDEF MSWINDOWS}
        MediaPlayerAcerto.Stop;
        MediaPlayerAcerto.FileName   := 'C:\univesp\PI II\Jogos\Delphi\Meus\Teste 01\audios\acerto.mp3';
        MediaPlayerAcerto.Play;
       {$ENDIF}

       {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
       MediaPlayerAcerto.Stop;
       MediaPlayerAcerto.FileName := TPath.GetDocumentsPath + PathDelim + 'acerto.mp3';
       MediaPlayerAcerto.Play;
       {$ENDIF}


       oCircle.Stroke.Thickness := 3;
       lblCursor.Text := ':( Parabéns, você acertou. Faltam ' + ( 5 - pontoIni).ToString + ' pontos'  ;
    end;


    if pontoIni = 5 then
    begin
        {$IFDEF MSWINDOWS}
        MediaPlayerAplausos.Play;
        {$ENDIF}

       {$IFDEF ANDROID}
        MediaPlayerAplausos.Stop;
        MediaPlayerAplausos.FileName := TPath.GetDocumentsPath + PathDelim + 'aplausos.mp3';
        MediaPlayerAplausos.Play;
       {$ENDIF}

        pth1.Fill.Color    := $FFD8DBD7;
        pth1.Stroke.Color  := $FF959595;
        pth2.Fill.Color    := $FFD8DBD7;
        pth2.Stroke.Color  := $FF959595;
        pth3.Fill.Color    := $FFD8DBD7;
        pth3.Stroke.Color  := $FF959595;
        pth4.Fill.Color    := $FFD8DBD7;
        pth4.Stroke.Color  := $FF959595;
        pth5.Fill.Color    := $FFD8DBD7;
        pth5.Stroke.Color  := $FF959595;

        lytParabens.Visible := true;
        lblCursor.Text := 'Parabéns! Você completou o desafio';
        sleep(3000);
        MediaPlayerAplausos.Stop;
        MediaPlayerfundo.Stop;
        Timer1.Enabled := false;


    end;


end;


procedure TF_TelaJogo.circle1Click(Sender: TObject);
begin
    CalcularAcerto(Sender, (Sender as TCircle).Tag );

end;

procedure TF_TelaJogo.actSairExecute(Sender: TObject);
begin
    Timer1.Enabled := false;
    close;
end;

procedure TF_TelaJogo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    MediaPlayerfundo.Stop;
    MediaPlayerAplausos.Stop;
    lytParabens.Visible := false;
    Timer1.Enabled := false;

end;

procedure TF_TelaJogo.FormCreate(Sender: TObject);
begin
    pontoIni := 0;
    Segundo  := 0;
    Minuto   := 0;
    Timer1.Enabled := true;
    lytParabens.Visible := false;
    lblTempo.Text := '00:00';

    pth1.Fill.Color := $FFD8DBD7;
    pth2.Fill.Color := $FFD8DBD7;
    pth3.Fill.Color := $FFD8DBD7;
    pth4.Fill.Color := $FFD8DBD7;
    pth5.Fill.Color := $FFD8DBD7;

    {$IFDEF ANDROID}
//        if DesabilitaAudio = false then
//        begin
            MediaPlayerfundo.Stop;
            MediaPlayerfundo.FileName := TPath.GetDocumentsPath + PathDelim + 'trilha.mp3';
            MediaPlayerfundo.Play;
//        end;
     {$ENDIF}

    {$IFDEF MSWINDOWS}
     MediaPlayerfundo.FileName    := System.SysUtils.GetCurrentDir + 'audios\trilha.mp3';
     MediaPlayerAplausos.FileName := System.SysUtils.GetCurrentDir + 'audios\aplausos.mp3';
     MediaPlayerAcerto.FileName   := System.SysUtils.GetCurrentDir + 'audios\acerto.mp3';
     MediaPlayerErro.FileName     := System.SysUtils.GetCurrentDir + 'audios\erro.mp3';
     if DesabilitaAudio = false then
     begin
         MediaPlayerfundo.Stop;
         MediaPlayerfundo.Play;
     end;
    {$ENDIF}







end;

procedure TF_TelaJogo.Image2Click(Sender: TObject);
begin
    close;
end;

procedure TF_TelaJogo.ImageGeralClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
//  CalcularAcerto(Sender);
//    MediaPlayerErro.Stop;
//    CalcularAcerto(Sender, (Sender as TImage).Tag );
  {$ENDIF}

  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  CalcularAcerto(Sender);
//  lblCursor.Text := 'Posição:    X: ' + IntToStr(ImageGeral.Position.X) + '   Y: ' + IntToStr(ImageGeral.Position.Y);
//    MediaPlayerErro.Stop;
//    CalcularAcerto(Sender, (Sender as TImage).Tag );
  {$ENDIF}

end;

procedure TF_TelaJogo.ImageGeralMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    imgErro.Position.X := X;
    imgErro.Position.Y := Y;
    imgErro.Visible := true;

   {$IFDEF ANDROID}
   MediaPlayerErro.Stop;
   MediaPlayerErro.FileName := TPath.GetDocumentsPath + PathDelim + 'erro.mp3';
   MediaPlayerErro.Play;
   {$ENDIF}



end;

procedure TF_TelaJogo.Timer1Timer(Sender: TObject);
var
    HoraStr, MinStr, SegStr : string ;
    Thread: TThread;

begin

    Thread := TThread.CreateAnonymousThread(procedure
    begin
        try
          TThread.Synchronize(nil, procedure
          begin
//                lblTempo.Text := '00:00';
          end);

            Segundo := Segundo + 1 ;

            if Segundo >= 59 then begin
                Segundo := 0 ;
                Minuto := Minuto + 1;
            end ;


          TThread.Synchronize(nil, procedure
          begin
              lblTempo.Text := Format('%2.2d',[Minuto]) + ':' + Format('%2.2d',[Segundo]) ;
          end);

        finally

          if not TThread.CheckTerminated then
            TThread.Synchronize(nil, procedure
            begin
           end);

        end;
    end);
    Thread.Start;

end;

procedure TF_TelaJogo.Timer2Timer(Sender: TObject);
var
 pt: TPoint;
begin
  {$IFDEF MSWINDOWS}
//  GetCursorPos(pt); // Pega a posição atual do mouse;
//Mostra os valores das coordenadas do mouse
//  lblCursor.caption := IntToStr(pt.x) + ',' + IntToStr(pt.y);
//  lblCursor.Text := 'Posição:    X: ' + IntToStr(FMX.Controls.TMouse.CursorPos.X) + '   Y: ' + IntToStr(Mouse.CursorPos.Y);
  {$ENDIF}

  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  lblCursor.Text := 'Posição:    X: ' + IntToStr(F_TelaJogo.Position.X) + '   Y: ' + IntToStr(F_TelaJogo.Position.Y);
  {$ENDIF}
end;

end.
