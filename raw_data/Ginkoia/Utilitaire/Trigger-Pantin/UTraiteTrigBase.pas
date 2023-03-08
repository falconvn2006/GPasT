unit UTraiteTrigBase;

interface

uses
   UTraiteBase,
   forms,
   windows,
   sysutils,
   Classes;

type
   TraiteTrigBase = class(TThread)
   private
    { Déclarations privées }
      Dm: TDm_Module;
      Fonagit: TNotifyEvent;
      fini: Boolean;
      Ok: boolean;

      procedure Setonagit(const Value: TNotifyEvent);
    procedure affiche_erreur;
   protected
      procedure initialisation;
      procedure Finalisation;
      procedure Execute; override;
      procedure passage;
      procedure startTransaction;
      procedure rollback;
      procedure Commit;
      procedure traitementerreur;
      procedure traitement;
   public
      erreur: boolean;
      Lemessage: string;
      LaBase: string;
      NbPacket: Integer;
      PacketTraite: Integer;
      Debut: TDateTime;
      lerreur:String ;
      constructor Create(Base: string);
      property onagit: TNotifyEvent read Fonagit write Setonagit;
   end;

implementation

{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure TraiteTrigBase.UpdateCaption;
    begin
      Form1.Caption := 'Mis à jour dans un thread';
    end; }

{ TraiteTrigBase }

procedure TraiteTrigBase.initialisation;
begin
   PacketTraite := 0;
   erreur := False;
   dm := TDm_Module.Create(nil);
   erreur := not (dm.initialise(LaBase));
   if erreur then
      Lemessage := dm.erreur;
   NbPacket := dm.nbpack;
end;

procedure TraiteTrigBase.affiche_erreur ;
begin
  application.messageBox (Pchar(LaBase+' à une erreur '+lerreur),'ERREUR',Mb_OK) ;
end ;

procedure TraiteTrigBase.Execute;
begin
  { Placez le code du thread ici}
   Synchronize(initialisation);
   if not erreur then
   begin
      try
         while not Terminated do
         begin
            startTransaction;

            Synchronize(passage);
            traitement;
            if ok then
               Commit
            else
            begin
               rollback;
               traitementerreur;
            end;

            if not ok then
            begin
               erreur := true;
               Lemessage := dm.erreur;
               Terminate;
            end;
            if fini then
            begin
               Terminate;
            end;
            inc(PacketTraite);
         end;
      except
        on E: Exception do
        begin
          lerreur := E.Message ;
          Synchronize(affiche_erreur) ;
          erreur := true ;
        END ;
      end;
   end;
   Synchronize(Finalisation);
end;

procedure TraiteTrigBase.Finalisation;
begin
   dm.finalise;
   dm.free;
end;

constructor TraiteTrigBase.Create(Base: string);
begin
   inherited create(true);
   LaBase := Base;
   FreeOnTerminate := true;
   Debut := Now;
end;

procedure TraiteTrigBase.passage;
begin
   if Assigned(Fonagit) then
   begin
      Fonagit(self);
   end;
end;

procedure TraiteTrigBase.Setonagit(const Value: TNotifyEvent);
begin
   Fonagit := Value;
end;

procedure TraiteTrigBase.Commit;
begin
   dm.commit;
end;

procedure TraiteTrigBase.rollback;
begin
   dm.rollback;

end;

procedure TraiteTrigBase.startTransaction;
begin
   dm.startTransaction;
end;

procedure TraiteTrigBase.traitementerreur;
begin
   dm.traitementerreur;
end;

procedure TraiteTrigBase.traitement;
begin
   ok := dm.traitement(fini);
end;

end.

