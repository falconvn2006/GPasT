unit URechProbPantin;

interface

uses
   UBase, Ulame, UTraitement,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
   TFrm_RechProbLame = class(TForm)
      BitBtn1: TBitBtn;
      Pb: TProgressBar;
      Lab_Base: TLabel;
      Timer1: TTimer;
      Lab_Etat: TLabel;
      Pb2: TProgressBar;
      procedure BitBtn1Click(Sender: TObject);
      procedure Timer1Timer(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      tsl: tstringlist;
      arret: boolean;
      lame: TUtilLame;
      Traitement: TTraitement;
      procedure OnNotifyXml(sender: Tobject; message1, message2: string);
      procedure OnNotifyDatabase(sender: Tobject; Machine, Centrale, client, base: string; actu, max: integer);
      function OnTraitement(Sender: TObject; Action: string; actu, max: Integer): boolean;
   end;

var
   Frm_RechProbLame: TFrm_RechProbLame;

implementation

{$R *.DFM}

procedure TFrm_RechProbLame.BitBtn1Click(Sender: TObject);
begin
   lab_etat.Caption := 'Arret en cours'; lab_etat.Update;
   arret := true;
end;

procedure TFrm_RechProbLame.OnNotifyDatabase(sender: Tobject; Machine,
   Centrale, client, base: string; actu, max: integer);
begin
   // Application.MessageBox (pchar('traitement '+client),'un',mb_ok) ;
   Lab_Base.Caption := 'traitement de ' + client;
   if actu > pb.max then
      pb.max := max;
   pb.position := actu; pb.max := max;
   Application.processmessages;
   if arret then EXIT;
   //Application.MessageBox (pchar('Vérif '+client),'un',mb_ok) ;
   if tsl.IndexOf(base) = -1 then
   begin
      //Application.MessageBox (pchar('connexion '+client),'un',mb_ok) ;
      Traitement.Connexion(base, TRUE);
      //Application.MessageBox (pchar('Netoyage '+client),'un',mb_ok) ;
      Traitement.Netoi_HistoEvt;
      //Application.MessageBox (pchar('Corrige date '+client),'un',mb_ok) ;
      Traitement.PR_CORRIGE_DATE;
      //Application.MessageBox (pchar('Recalc stock '+client),'un',mb_ok) ;
      Traitement.PR_RECALCULESTOCK(client);
      Traitement.Ferme;
      // Application.MessageBox(pchar('Fin ' + client), 'un', mb_ok);
      if not arret then
      begin
         tsl.add(base);
         tsl.SaveToFile(changefileext(application.exename, '.lst'));
      end;
   end;
end;

procedure TFrm_RechProbLame.OnNotifyXml(sender: Tobject; message1, message2: string);
begin
   Application.processmessages;
   if arret then EXIT;
   lame.ListeDataBases(message1, message2);
end;

function TFrm_RechProbLame.OnTraitement(Sender: TObject; Action: string;
   actu, max: Integer): boolean;
begin
   if arret then
      result := false
   else
   begin
      Lab_Etat.Caption := action;
      if actu > pb2.max then
         pb2.max := max;
      pb2.position := actu;
      pb2.max := max;
      application.processmessages;
      result := True;
   end;
end;

procedure TFrm_RechProbLame.Timer1Timer(Sender: TObject);
begin
   arret := false;
   timer1.enabled := false;
   // on lit le fichier des bases traitées
   tsl := tstringlist.create;
   if fileexists(changefileext(application.exename, '.lst')) then
      tsl.LoadFromFile(changefileext(application.exename, '.lst'));
   Traitement := TTraitement.Create(self);
   traitement.OnNetoi_HistoEvt := OnTraitement;
   lame := TUtilLame.create;
   lame.OnNotifyDataBase := OnNotifyDatabase;
   lame.OnNotifyXml := OnNotifyXml;
   lame.ListeXml('GSA-LAME3');
   lame.free;
   Traitement.free;
   tsl.free;
   close;
end;

end.

