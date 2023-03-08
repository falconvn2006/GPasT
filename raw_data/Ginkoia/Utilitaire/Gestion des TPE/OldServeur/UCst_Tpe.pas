//*****************************************************************************
//$Archive:   P:/Projets/Paquets/ComposantsV8/UCst_Tpe.pas  $
//$Revision: 1$
//*****************************************************************************
{//$Log:
{// 1    Utilitaires1.0         02/03/2012 16:22:37    Christophe HENRAT 
{//$
 * 
 *    Rev 1.0   01 Mar 2001 17:23:40   RICHARD
 * Modification sur le TPE
//*****************************************************************************
}
unit UCst_Tpe;

interface

Type
  TPaymentStyle  = ( psLocal  , psEuro );                 // TPE Local , TPE Compatible Euro
  TPaymentDevise = ( pmFrancs , pmEuro );                 // pour le TPE Compatible Euro => Paiement en Francs ou Euro
  TPaymentMode   = ( pmCard   , pmCardOrCheck , pmCheck); // Paiement par Carte,Chèque ou autres

implementation

end.
