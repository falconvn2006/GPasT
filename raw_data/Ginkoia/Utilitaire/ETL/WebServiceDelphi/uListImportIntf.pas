{ Interface invocable IListImport }

unit uListImportIntf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  { Les interfaces invocables doivent dériver de IInvokable }
  IListImport = interface(IInvokable)
  ['{953269F3-795E-4F41-8A18-7DD7BA5AEAA9}']

    { Les méthodes de l'interface invocable ne doivent pas utiliser la valeur par défaut }
    { convention d'appel ; stdcall est recommandé }
     function importClient(ISR_CID: Integer; CID, marketing, civilite, nom, prenom, pays, adresse, codePostal, ville, email: string): Boolean; StdCall;
     function importListClient(p_ListeClient: string): Boolean; StdCall;
  end;

implementation

initialization
  { Les interfaces invocables doivent être enregistrées }
  InvRegistry.RegisterInterface(TypeInfo(IListImport));

end.
