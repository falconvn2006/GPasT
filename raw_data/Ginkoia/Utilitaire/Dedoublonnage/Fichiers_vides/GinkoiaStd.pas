//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT GinkoiaStd;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

// L'outil de dédoublonnage n'a pas besoin de ramener tout le monde (Ginkoia, Caisse, Cash, etc...).
// Cette fiche est vide pour pouvoir compiler le projet et limiter les dépendances inutiles.   
TYPE
    TStdGinkoia = CLASS(TDataModule)
    PRIVATE
    { Déclarations privées }
    PUBLIC
      procedure SaveOrLoadDBGGrilleConfiguration(A: Boolean; B: TObject; C: Boolean);
    { Déclarations publiques }
    END;

VAR
    StdGinkoia: TStdGinkoia;

IMPLEMENTATION

{$R *.DFM}

{ TStdGinkoia }

procedure TStdGinkoia.SaveOrLoadDBGGrilleConfiguration(A: Boolean; B: TObject;
  C: Boolean);
begin
  // Ne rien faire.
end;

END.

