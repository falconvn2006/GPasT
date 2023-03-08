//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ginkoiaStd;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ActionRv, BmDelay;

TYPE
    TStdGinKoia = CLASS(TDataModule)
    Delay_Main: TBmDelay;
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    PROCEDURE AffecteHintEtBmp(Panel: TWinControl);


    END;

VAR
    StdGinKoia: TStdGinKoia;
     PROCEDURE Delai(Value: Integer);
IMPLEMENTATION


procedure TStdGinKoia.AffecteHintEtBmp(Panel: TWinControl);
begin
END;

PROCEDURE Delai(Value: Integer);
begin
   // value = pause indiquée en secondes ...
   StdGinKoia.Delay_main.WaitForDelay(Value)
END;

{$R *.DFM}

END.

