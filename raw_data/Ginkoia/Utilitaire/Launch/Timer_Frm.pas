//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Timer_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, AlgolStdFrm, ExtCtrls;

type
  TFrm_Timer = class(TAlgolStdFrm)
    Tim_Ping: TTimer;
    procedure Tim_PingTimer(Sender: TObject);
    procedure AlgolStdFrmCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

var
  Frm_Timer: TFrm_Timer;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

//USES ConstStd;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TFrm_Timer.Tim_PingTimer(Sender: TObject);
var ResultBody: TStringStream;
BEGIN




//    ResultBody := TStringStream.Create ( '' ) ;
//    TRY
//        TRY
//            FHTTPPing.PostData.Clear;
//            FHTTPPing.PostData.Values['Caller'] := Application.ExeName;
//            FHTTPPing.PostData.Values['Provider'] := '';
//            FHTTPPing.Post ( URLPing, ResultBody ) ;
//            Connexion := True;
//            // Une fois connecté, Test de Ping toutes les 5 min
//            Tim_Ping.Enabled := False;
//            Tim_Ping.Interval := 300000;
//            Tim_Ping.Enabled := True;
//        EXCEPT ON E: Exception DO
//            Connexion := False;
//        // Sur une erreur on ne veut pas voir le message
//        // car l'appli se bloque en connection le nuit...
//
////                RAISE Exception.CreateFmt ( 'HTTPPost - Cannot invoke http action (URL=%s)', [URLPing] ) ;
//        END;
//    FINALLY
//        ResultBody.Free;
//    END;
end;

procedure TFrm_Timer.AlgolStdFrmCreate(Sender: TObject);
begin
     Tim_Ping.Enabled := True;
end;

end.
