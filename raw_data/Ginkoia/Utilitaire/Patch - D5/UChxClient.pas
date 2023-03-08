//$Log:
// 3    Utilitaires1.2         07/06/2019 14:44:47    St?phane MATHIS v2.3.0.27
//      
//      ajout numero de version
//      fenetre plus grande et redimensionnable
//      enlever les lignes vides
// 2    Utilitaires1.1         06/06/2019 17:58:51    St?phane MATHIS
//      gestionpantin - probleme liste client
// 1    Utilitaires1.0         19/09/2016 10:08:38    Ludovic MASSE   
//$
//$NoKeywords$
//
unit UChxClient;

interface

uses
   UsaisiePtch,
   filectrl,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, Db, dxmdaset, MemDataX, Dialogs;

type
   TChxClient = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      Bevel1: TBevel;
      lb: TListBox;
      DataX: TDataBaseX;
      Clients: TMemDataX;
      Clientsid: TIntegerField;
      Clientssite: TStringField;
      Clientsnom: TStringField;
      Clientsversion: TIntegerField;
      Clientspatch: TIntegerField;
      Clientsversion_max: TIntegerField;
      Clientsspe_patch: TIntegerField;
      Clientsspe_fait: TIntegerField;
      Clientsbckok: TDateTimeField;
      Clientsdernbck: TDateTimeField;
      Clientsresbck: TStringField;
      Clientsblockmaj: TIntegerField;
      Clientsnompournous: TStringField;
      Clientsdernbckok: TIntegerField;
      Clientsbasepantin: TIntegerField;
      ClientsPriseencompte: TIntegerField;
      Clientsclt_machine: TStringField;
      Clientsclt_centrale: TStringField;
      Clientsclt_GUID: TStringField;
      OD: TOpenDialog;
    spe: TMemDataX;
    spespe_id: TIntegerField;
    spespe_cltid: TIntegerField;
    spespe_fichier: TStringField;
    spespe_date: TDateTimeField;
    spespe_fait: TIntegerField;
    nbclient: TLabel;
   private
    { Private declarations }
   public
    { Public declarations }
      function execute: boolean;
      function executeFic: boolean;
   end;

var
   ChxClient: TChxClient;

implementation

{$R *.DFM}

{ TChxClient }

function TChxClient.execute: boolean;
var
   saisiePtch: TsaisiePtch;
   path: string;
   i: integer;
begin
   clients.open;
   while not Clients.eof do
   begin
      lb.items.addobject(Clientsnompournous.asString + ' | ' + Clientssite.asString + ' | ' + Clientsnom.AsString, pointer(Clientsid.AsInteger));
      clients.next;
   end;
   nbclient.Caption := inttostr(lb.Items.Count);
   result := Showmodal = MrOk;
   if result and (lb.SelCount > 0) then
   begin
      application.CreateForm(TsaisiePtch, saisiePtch);
      try
         result := saisiePtch.Showmodal = MrOk;
         if result then
         begin
            for i := 0 to lb.Items.Count - 1 do
            begin
               if lb.Selected[i] then
               begin
                  clients.trouve(clientsid, Inttostr(integer(lb.items.Objects[i])));
                  Path := IncludeTrailingBackslash(ExtractFilePath(application.exename));
                  Path := Path + 'patch\' + Clientsclt_GUID.AsString + '\';
                  forcedirectories(path);
                  Clients.edit;
                  Clientsspe_patch.AsInteger := Clientsspe_patch.AsInteger + 1;
                  Clients.Post;
                  saisiePtch.mem.Lines.SaveToFile(Path + 'Script' + Clientsspe_patch.AsString + '.sql');
                  Clients.validation;
               end
            end;
         end;
      finally
         saisiePtch.release;
      end;
   end;
   clients.close;
end;

function TChxClient.executeFic: boolean;
var
   path: string;
   i: integer;
begin
   clients.open;
   spe.open ;
   while not Clients.eof do
   begin
      lb.items.addobject(Clientsnompournous.asString + ' ' + Clientssite.asString + ' ' + Clientsnom.AsString, pointer(Clientsid.AsInteger));
      clients.next;
   end;
   result := Showmodal = MrOk;
   if result and (lb.SelCount > 0) then
   begin
      result := od.execute;
      if result then
      begin
         Path := extractfilename (od.filename);
         for i := 0 to lb.Items.Count - 1 do
         begin
            if lb.Selected[i] then
            begin
               clients.trouve(clientsid, Inttostr(integer(lb.items.Objects[i])));
               spe.Insert ;
               spespe_cltid.asinteger :=Clientsid.asinteger ;
               spespe_fichier.asstring := Path ;
               spe.post ;
               spe.validation;
            end
         end;
      end;
   end;
   clients.close;
   spe.close ;
end;

end.

