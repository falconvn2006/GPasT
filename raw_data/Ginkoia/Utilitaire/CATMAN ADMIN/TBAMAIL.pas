unit TBAMAIL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ADODB, dxmdaset, Psock, NMsmtp, LMDControl,
  LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, ExtCtrls, StdCtrls, RzLabel;

type
  TForm1 = class(TForm)
    ADO: TADOConnection;
    QTBA: TADOQuery;
    DataSource1: TDataSource;
    mail: TdxMemData;
    NMSMTP1: TNMSMTP;
    lab: TRzLabel;
    tt: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ttTimer(Sender: TObject);
  private
  PROCEDURE trait;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin

//    ShowMessHPAvi('Connexion au serveur CATMAN en cours ...', false, 0, 0, 'Administration CATMAN');
    TRY
        ado.connected := true;
    EXCEPT
        //ShowCloseHP;
        //InfoMessHP('Problème de connection avec le serveur CATMAN,' + #10 + #13 +
        //    'Réessayez ultérieurement...', true, 0, 0);
        application.terminate;
    END;

 //   ShowCloseHP;

 //   ShowMessHPAvi('Traitement en cours...', false, 0, 0, 'Administration CATMAN');

    tt.enabled:=true;

end;
PROCEDURE tform1.trait;
begin

      lab.caption:='Traitement 1 en cours...';
      application.ProcessMessages;

    qtba.close;
    qtba.parameters[0].value:=1;
    qtba.parameters[1].value:=1;
    qtba.parameters[2].value:=1;
    qtba.open;
    mail.close;
    mail.LoadFromDataSet(qtba);
    mail.DelimiterChar:=';';
    mail.SaveToTextFile('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN ADIDAS MULTISPORT.csv');

    lab.caption:='Traitement 2 en cours...';
      application.ProcessMessages;
    qtba.active:=false;
    qtba.parameters[0].value:=1;
    qtba.parameters[1].value:=2;
    qtba.parameters[2].value:=1;
    qtba.open;
    mail.close;
    mail.LoadFromDataSet(qtba);
    mail.DelimiterChar:=';';
    mail.SaveToTextFile('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN ADIDAS CHAUSSURE.csv');

    lab.caption:='Traitement 3 en cours...';
      application.ProcessMessages;
     qtba.active:=false;
    qtba.parameters[0].value:=1;
    qtba.parameters[1].value:=3;
    qtba.parameters[2].value:=2;
    qtba.open;
    mail.close;
    mail.LoadFromDataSet(qtba);
    mail.DelimiterChar:=';';
    mail.SaveToTextFile('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN OXBOW SURFWEAR.csv');





    //Envoi du mail...
    lab.caption:='Envoi du mail...';
    application.ProcessMessages;
    NMSMTP1.Host := 'smtp.fr.oleane.com';
    NMSMTP1.UserID := 'mp1304-10';
    NMSMTP1.PostMessage.Subject := 'Analyses fournisseur CATMAN';
    NMSMTP1.PostMessage.FromAddress := 'bruno.nicolafrancesco@ginkoia.fr';
    NMSMTP1.PostMessage.FromName := 'SUPER-GINKOIA';

    NMSMTP1.PostMessage.ToAddress.Add('M.SOLDINI@sport2000.fr');
    NMSMTP1.PostMessage.ToAddress.Add('B.LEGOFF@sport2000.fr');
    NMSMTP1.PostMessage.ToAddress.Add('M.AIMONINO@sport2000.fr');
    NMSMTP1.PostMessage.ToAddress.Add('A.ROSSET@sport2000.fr');

    NMSMTP1.PostMessage.attachments.add('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN ADIDAS MULTISPORT.csv');
    NMSMTP1.PostMessage.attachments.add('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN ADIDAS CHAUSSURE.csv');
    NMSMTP1.PostMessage.attachments.add('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\Extract\CATMAN OXBOW SURFWEAR.csv');



    NMSMTP1.PostMessage.Body.add('Ci-joint les analyses fournisseur CATMAN');
    NMSMTP1.Connect;
    NMSMTP1.SendMail;
    NMSMTP1.Disconnect;

    lab.caption:='Terminé...';
    application.ProcessMessages;
END;
procedure TForm1.FormActivate(Sender: TObject);
begin
trait;

end;

procedure TForm1.ttTimer(Sender: TObject);
begin
tt.enabled:=false;
trait;
end;

end.
