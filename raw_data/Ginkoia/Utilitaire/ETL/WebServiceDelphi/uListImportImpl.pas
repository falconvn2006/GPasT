{ Fichier d'implémentation invocable pour TListImport implémentant IListImport }

unit uListImportImpl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, uListImportIntf;

type

  { TListImport }
  TListImport = class(TInvokableClass, IListImport)
  public
     function importClient(ISR_CID: Integer; CID, marketing, civilite, nom, prenom, pays, adresse, codePostal, ville, email: string): Boolean; StdCall;
     function importListClient(p_ListeClient: string): Boolean; StdCall;
  end;

implementation

uses
  SysUtils,
  uTestVisu;

{ TListImport }

function TListImport.importClient(ISR_CID: Integer; CID, marketing, civilite, nom, prenom, pays, adresse, codePostal, ville, email: string): Boolean;
begin
  if Assigned(FrmVisu) then
    FrmVisu.AddRow(IntToStr(ISR_CID), CID, marketing, civilite, nom, prenom, pays, adresse, codePostal, ville, email);
  Result := True;
end;

function TListImport.importListClient(p_ListeClient: string): Boolean;
begin
  Result := False;
end;

initialization
{ Les classes invocables doivent être enregistrées }
   InvRegistry.RegisterInvokableClass(TListImport);
end.

