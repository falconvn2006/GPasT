//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Ping_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, AlgolStdFrm, SimpHTTP, ExtCtrls, LMDCustomComponent,
  LMDIniCtrl, StdCtrls, RzLabel;       // Pour Push - Pull  Cogisoft

type
  TFrmBase = class(TAlgolStdFrm)
    Tim_Ping: TTimer;
    IniCtrl: TLMDIniCtrl;
    RzLabel1: TRzLabel;
    procedure Tim_PingTimer(Sender: TObject);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure AlgolStdFrmClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
        URLPing: String;
        URLConnect,Pass:Boolean;

  protected
    { Protected declarations }
        FHTTPPing: TSimpleHTTP;
  public
    { Public declarations }
    CONSTRUCTOR Create ( AOwner: TComponent ) ; Override; // Pour Push - Pull  Cogisoft
  published
    { Published declarations }
  end;

var
  FrmBase: TFrmBase;
  nb_tour: Integer;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

USES UMapping;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------
CONSTRUCTOR TFrmBase.Create ( AOwner: TComponent ) ;
BEGIN
    INHERITED;
    FHTTPPing  := TSimpleHTTP.Create ( Application ) ;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------


procedure TFrmBase.Tim_PingTimer(Sender: TObject);
var ResultBody: TStringStream;
BEGIN
 inc(nb_tour);
 if not MapGinkoia.PingStop then
 begin
    if Pass then exit;
    IF (nb_tour > 15) then   // Timer toutes les 10s mais envoie d'URL que toutes les 2,5 min
    begin
        TRY
        nb_tour := 0;
        ResultBody := TStringStream.Create ( '' ) ;
        Pass := True;
            TRY
                FHTTPPing.PostData.Clear;
                FHTTPPing.PostData.Values['Caller'] := Application.ExeName;
                FHTTPPing.PostData.Values['Provider'] := '';
                FHTTPPing.Post ( URLPing, ResultBody ) ;
                Pass:= False;
                if (not URLConnect) and (ResultBody.DataString = 'PONG') then
                begin
                    // Une fois connecté, Test de Ping toutes les 30 s
                    Tim_Ping.Enabled := False;
                    Tim_Ping.Interval := 10000;
                    Tim_Ping.Enabled := True;
                    if not URLConnect then
                    begin
                         URLConnect := True;
                         MapGinkoia.Ping := URLConnect;
                    end;
                end;
            EXCEPT ON E: Exception DO
                begin
                     URLConnect := False;
                     MapGinkoia.Ping := URLConnect;
                end;
            // Sur une erreur on ne veut pas voir le message
            // car l'appli se bloque en connection le nuit...

    //                RAISE Exception.CreateFmt ( 'HTTPPost - Cannot invoke http action (URL=%s)', [URLPing] ) ;
            END;

        FINALLY
            ResultBody.Free;
        END;
    END;
 end
 else
 begin
      Tim_Ping.Enabled := False;
      MapGinkoia.Ping := False;
      MapGinkoia.PingStop := False;

      application.Terminate;
 end;
end;

procedure TFrmBase.AlgolStdFrmCreate(Sender: TObject);
begin

     IniCtrl.IniFile := ExtractFilePath (application.ExeName)+'Ginkoia.ini';
     URLPing := iniCtrl.readString ( 'PING', 'URL', '' ) ;
     MapGinkoia.PingStop := False;
     URLConnect := False;
     MapGinkoia.Ping := URLConnect;
     nb_tour := 10;
     Tim_Ping.Enabled := True;
     Pass := False;
end;

procedure TFrmBase.AlgolStdFrmClose(Sender: TObject;
  var Action: TCloseAction);
begin
     MapGinkoia.Ping := False;
     MapGinkoia.PingStop := False;
end;

end.
