unit uDefs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  cRC = #13#10;

  //TImportProvenance
  Error_ProvenanceIsEmpty = 'La liste de provenance des imports est vide';
  Error_ProvenanceUncompleted = 'TImportProvenance n''est pas compatible. Il faut ajouter "ip%s".';

  //Niveau Mail
  NotMail     = 0;
  ErreurMail  = 1;
  CliArtHistBonRAtelier  = 2;
  AllMail     = 3;

  //Clients
  Clients_CSV = 'CLIENT.CSV';
  LienClients_CSV = 'LIENCLIENT.CSV';
  Comptes_CSV = 'COMPTES.CSV';

  //Fidelité
  Fidelite_CSV  = 'FIDELITE.CSV';
  BonAchats_CSV = 'BONACHATS.CSV';

  //Référentiel article
  Fourn_CSV                 = 'FOURN.CSV';
  Marque_CSV                = 'MARQUE.CSV';
  Foumarque_CSV             = 'FOUMARQUE.CSV';
  GrTaille_CSV              = 'GR_TAILLE.CSV';
  GrTailleLig_CSV           = 'GR_TAILLE_LIG.CSV';
  DomaineCommercial_CSV     = 'Domaine_Commercial.CSV';
  Axe_CSV                   = 'AXE.CSV';
  AxeNiveau1_CSV            = 'AXE_NIVEAU1.CSV';
  AxeNiveau2_CSV            = 'AXE_NIVEAU2.CSV';
  AxeNiveau3_CSV            = 'AXE_NIVEAU3.CSV';
  AxeNiveau4_CSV            = 'AXE_NIVEAU4.CSV';
  Collection_CSV            = 'Collection.CSV';
  Genre_CSV                 = 'GENRE.CSV';
  Article_CSV               = 'ARTICLE.CSV';
  ArticleAxe_CSV            = 'ARTICLE_AXE.CSV';
  ArticleCollection_CSV     = 'ARTICLE_COLLECTION.CSV';
  Couleur_CSV               = 'COULEUR.CSV';
  CodeBarre_CSV             = 'CODE_BARRE.CSV';
  Prix_Achat_CSV            = 'PRIX_ACHAT.CSV';
  Prix_Vente_CSV            = 'PRIX_VENTE.CSV';
  Prix_Vente_Indicatif_CSV  = 'PRIX_VENTE_INDICATIF.CSV';
  ModeleDeprecie_CSV        = 'MODELEDEPRECIE.CSV';
  FouContact_CSV            = 'FOUCONTACT.CSV';
  FouCondition_CSV          = 'FOUCONDITION.CSV';
  ArtIdeal_CSV              = 'ARTIDEAL.CSV';
  OcTete_CSV                = 'OCTETE.CSV';
  OcMag_CSV                 = 'OCMAG.CSV';
  OcLignes_CSV              = 'OCLIGNES.CSV';
  OcDetail_CSV              = 'OCDETAIL.CSV';
  AllCB_CSV                 = 'All_CB.csv';

  //Historique
  Caisse_CSV    = 'CAISSE.CSV';
  Reception_CSV = 'RECEPTION.CSV';
  Consodiv_CSV  = 'CONSODIV.CSV';
  Transfert_CSV = 'TRANSFERT.CSV';
  Commandes_CSV = 'COMMANDES.CSV';
  RetourFou_CSV = 'RETOURFOU.CSV';
  Avoir_CSV = 'AVOIR.CSV';
  BonLivraison_CSV = 'BONLIVRAISON.CSV';
  BonLivraisonL_CSV = 'BONLIVRAISONL.CSV';
  BonLivraisonHisto_CSV = 'BONLIVRAISONHISTO.CSV';

  //Reprise
  RepriseClients_CSV            = 'CLIENT_REPRISE.CSV';
  RepriseComptes_CSV            = 'COMPTE_REPRISE.CSV';
  RepriseCaisse_CSV             = 'CAISSE_REPRISE.CSV';
  RepriseAvoir_CSV              = 'AVOIR_REPRISE.CSV';
  RepriseBonLivraison_CSV       = 'BONLIVRAISON_REPRISE.CSV';
  RepriseBonLivraisonL_CSV      = 'BONLIVRAISONL_REPRISE.CSV';
  RepriseBonLivraisonHisto_CSV  = 'BONLIVRAISONHISTO_REPRISE.CSV';

  // Bon de rapprochement.
  BonRapprochement_CSV = 'BonRapprochement.csv';
  BonRapprochementLien_CSV = 'BonRapprochementLien.csv';
  BonRapprochementTVA_CSV = 'BonRapprochementTVA.csv';
  BonRapprochementLigneReception_CSV = 'BonRapprochementLigneReception.csv';
  BonRapprochementLigneRetour_CSV = 'BonRapprochementLigneRetour.csv';

  SavTauxH_CSV = 'SavTauxH.csv';
  SavForfait_CSV = 'SavForfait.csv';
  SavForfaitL_CSV = 'SavForfaitL.csv';
  SavPt1_CSV = 'SavPt1.csv';
  SavPt2_CSV = 'SavPt2.csv';
  SavTypMat_CSV = 'SavTypMat.csv';
  SavType_CSV = 'SavType.csv';
  SavMat_CSV = 'SavMat.csv';
  SavCb_CSV = 'SavCb.csv';
  SavFichee_CSV = 'SavFichee.csv';
  SavFicheL_CSV = 'SavFicheL.csv';
  SavFicheArt_CSV = 'SavFicheArt.csv';

  //Chrono
  ListeChrono_CSV = 'ListeChrono.CSV';

  //Requête utilisé dans le programme
  //SQL pour les clients
  cSql_MG10_CLIENT = 'SELECT CLTID FROM MG10_CLIENT(:IMPREFSTR,'    + cRC +
                                                   ':CLTTYPE,'      + cRC +
                                                   ':CLTNOM,'       + cRC +
                                                   ':CLTPRENOM,'    + cRC +
                                                   ':CIVNOM,'       + cRC +
                                                   ':ADRLIGNE,'     + cRC +
                                                   ':VILCP,'        + cRC +
                                                   ':VILNOM,'       + cRC +
                                                   ':PAYNOM,'       + cRC +
                                                   ':CLTCOMPTA,'    + cRC +
                                                   ':CLTCOMMENT,'   + cRC +
                                                   ':ADRTEL,'       + cRC +
                                                   ':ADRFAX,'       + cRC +
                                                   ':ADRGSM,'       + cRC +
                                                   ':ADREMAIL,'     + cRC +
                                                   ':CB_NATIONAL,'  + cRC +
                                                   ':ICLNOM1,'      + cRC +
                                                   ':ICLNOM2,'      + cRC +
                                                   ':ICLNOM3,'      + cRC +
                                                   ':ICLNOM4,'      + cRC +
                                                   ':ICLNOM5,'      + cRC +
                                                   ':CLTMAGID,'     + cRC +
                                                   ':CB_INTERNE,'   + cRC +
                                                   ':CLI_NUMERO)';

  cSql_MG10_LIEN_CLIENT = 'SELECT PRMID FROM MG10_LIEN_CLIENT(:CLTIDPRO,' + cRC +
                                                             ':CLTIDPART,' + cRC +
                                                             ':DATEDEBUT,' + cRC +
                                                             ':DATEFIN)';

  cSql_MG10_COMPTE = 'SELECT CTEID FROM MG10_COMPTE(:CLTID,'          + cRC +
                                                   ':CTEMAGID,'       + cRC +
                                                   ':CTELIBELLE,'     + cRC +
                                                   ':CTEDATE,'        + cRC +
                                                   ':CTEDEBIT,'       + cRC +
                                                   ':CTECREDIT,'      + cRC +
                                                   ':CTELETTRAGE,'    + cRC +
                                                   ':CTELETTRAGENUM,' + cRC +
                                                   ':CTEORIGINE)';

  cSql_MG10_FIDELITE = 'SELECT FIDID FROM MG10_FIDELITE(:TKEID,'        + cRC +
                                                       ':CODE_POSTE,'   + cRC +
                                                       ':CODE_SESSION,' + cRC +
                                                       ':NUM_TICKET,'   + cRC +
                                                       ':POINT,'        + cRC +
                                                       ':FIDDATE,'      + cRC +
                                                       ':MAGID,'        + cRC +
                                                       ':BACID,'        + cRC +
                                                       ':CLTID,'        + cRC +
                                                       ':MANUEL)';

  cSql_MG10_BONACHATS = 'SELECT BACID FROM MG10_BONACHATS(:CLTID,'        + cRC +
                                                         ':MONTANT,'      + cRC +
                                                         ':TKEID,'        + cRC +
                                                         ':CODE_POSTE,'   + cRC +
                                                         ':CODE_SESSION,' + cRC +
                                                         ':NUM_TICKET,'   + cRC +
                                                         ':MAGID)';
//                                                         ':FIDID)';

  cSql_MG10_CORRECTION_AVOIR = 'SELECT CTEID_2 FROM MG10_CORRECTION_AVOIR(:CTEID,'    + cRC +
                                                                         ':CTEMAGID,' + cRC +
                                                                         ':CTEDEBIT,' + cRC +
                                                                         ':CTECREDIT)';

  cSql_MG10_CORRECTION_FID_BA = 'SELECT TKEID FROM MG10_CORRECTION_FID_BA(:FIDID,'        + cRC +
                                                                         ':BACID,'        + cRC +
                                                                         ':CODE_SESSION,' + cRC +
                                                                         ':NUM_TICKET)';
  //SQL pour les RefArticles
  cSql_MG10_FOURN = 'SELECT FOUID from MG10_FOURN(:CODEIS,'     + cRC +
                                                 ':FOUNOM,'     + cRC +
                                                 ':ADRESSE,'    + cRC +
                                                 ':CP,'         + cRC +
                                                 ':VILLE,'      + cRC +
                                                 ':PAYS,'       + cRC +
                                                 ':TEL,'        + cRC +
                                                 ':FAX,'        + cRC +
                                                 ':PORTABLE,'   + cRC +
                                                 ':EMAIL,'      + cRC +
                                                 ':COMMENT,'    + cRC +
                                                 ':NUMCLT,'     + cRC +
                                                 ':NUMCOMPTA,'  + cRC +
                                                 ':ACTIF,'      + cRC +
                                                 ':CENTRALE,'   + cRC +
                                                 ':FOUILN)';

  cSql_MG10_FOURN_2 = 'SELECT FOUID from MG10_FOURN(:CODEIS,'     + cRC +
                                                   ':FOUNOM,'     + cRC +
                                                   ':ADRESSE,'    + cRC +
                                                   ':CP,'         + cRC +
                                                   ':VILLE,'      + cRC +
                                                   ':PAYS,'       + cRC +
                                                   ':TEL,'        + cRC +
                                                   ':FAX,'        + cRC +
                                                   ':PORTABLE,'   + cRC +
                                                   ':EMAIL,'      + cRC +
                                                   ':COMMENT,'    + cRC +
                                                   ':NUMCLT,'     + cRC +
                                                   ':NUMCOMPTA,'  + cRC +
                                                   ':ACTIF,'      + cRC +
                                                   ':CENTRALE,'   + cRC +
                                                   ':FOUILN,'     + cRC +
                                                   ':FOUERPNO)';

  cSql_MG10_MARQUE = 'SELECT MRKID FROM MG10_MARQUE(:MRKCODEIS,'    + cRC +
                                                   ':MRKNOM,'       + cRC +
                                                   ':MRKACTIVE,'    + cRC +
                                                   ':MRKPROPRE,'    + cRC +
                                                   ':MRKCENTRALE)';

  cSql_MG10_FOUMARQUE = 'SELECT FMKID, ERREUR FROM MG10_FOUMARQUE(:FOUID,'      + cRC +
                                                                 ':MRKID,'      + cRC +
                                                                 ':PRINCIPAL)';

  cSql_MG10_GR_TAILLE = 'SELECT TGTID, GTFID from MG10_GR_TAILLE(:GTFCODEIS,'     + cRC +
                                                                ':GTFNOM,'        + cRC +
                                                                ':GTFCENTRALE,'   + cRC +
                                                                ':TGTCODEIS,'     + cRC +
                                                                ':TGTNOM,'        + cRC +
                                                                ':TGTCENTRALE)';

  cSql_MG10_GR_TAILLE_LIG = 'SELECT TGFID, TGSID from MG10_GR_TAILLE_LIG(:GTFID,'       + cRC +
                                                                        ':TGFNOM,'      + cRC +
                                                                        ':TGFCODEIS,'   + cRC +
                                                                        ':TGFCENTRALE,' + cRC +
                                                                        ':CORRESPOND,'  + cRC +
                                                                        ':TGFORDREAFF,' + cRC +
                                                                        ':TGFACTIVE)';

  //SQL pour l'historique
  cSql_MG10_CAISSE_POSTE = 'SELECT POSID FROM MG10_CAISSE_POSTE(:MAGID,'        + cRC +
                                                               ':CODE_POSTE)';

  cSql_MG10_CAISSE_SESSION = 'SELECT SESID, NTICK FROM MG10_CAISSE_SESSION(:POSID,'         + cRC +
                                                                          ':DATEVTE,'       + cRC +
                                                                          ':CODESESSION)';

  cSql_MG10_CAISSE_ENTETE = 'SELECT TKEID FROM MG10_CAISSE_ENTETE(:SESID,'      + cRC +
                                                                 ':DATEVTE,'    + cRC +
                                                                 ':TIMEVTE,'    + cRC +
                                                                 ':NUMTICKET,'  + cRC +
                                                                 ':CLTID)';

  cSql_MG10_CAISSE_ENTETE_2 = 'SELECT TKEID FROM MG10_CAISSE_ENTETE(:SESID,'      + cRC +
                                                                   ':DATEVTE,'    + cRC +
                                                                   ':TIMEVTE,'    + cRC +
                                                                   ':NUMTICKET,'  + cRC +
                                                                   ':CLTID,'      + cRC +
                                                                   ':OLDTKEID)';

  cSql_MG10_CAISSE_LIGNE = 'SELECT TKLID FROM MG10_CAISSE_LIGNE(:TKEID,'   + cRC +
                                                               ':ARTID,'   + cRC +
                                                               ':TGFID,'   + cRC +
                                                               ':COUID,'   + cRC +
                                                               ':PXBRUT,'  + cRC +
                                                               ':REMISE,'  + cRC +
                                                               ':PXNET,'   + cRC +
                                                               ':PXNN,'    + cRC +
                                                               ':TVA,'     + cRC +
                                                               ':QTE,'     + cRC +
                                                               ':TYPID,'   + cRc +
                                                               ':ECOPART,' + cRc +
                                                               ':ECOMOB)';

  cSql_INIT_BI = 'EXECUTE PROCEDURE ISFBI_ADDMVT (:MAGID,'  + cRC +
                                                 ':ARTID,'  + cRC +
                                                 ':TGFID,'  + cRC +
                                                 ':COUID,'  + cRC +
                                                 ':DATE)';

  cSql_MG10_RECEPTION_ENTETE = 'SELECT BREID FROM MG10_RECEPTION_ENTETE(:NUMBON,'         + cRC +
                                                                       ':NUMFOURN,'       + cRC +
                                                                       ':BREDATE,'        + cRC +
                                                                       ':FOUID,'          + cRC +
                                                                       ':MAGID,'          + cRC +
                                                                       ':MRGLIB,'         + cRC +
                                                                       ':CPAID,'          + cRC +
                                                                       ':COLID,'          + cRC +
                                                                       ':DATEREGLEMENT,'  + cRC +
                                                                       ':CLOTURE,'        + cRC +
                                                                       ':TOTTVA1,'        + cRC +
                                                                       ':TVA1,'           + cRC +
                                                                       ':TOTTVA2,'        + cRC +
                                                                       ':TVA2,'           + cRC +
                                                                       ':TOTTVA3,'        + cRC +
                                                                       ':TVA3,'           + cRC +
                                                                       ':TOTTVA4,'        + cRC +
                                                                       ':TVA4,'           + cRC +
                                                                       ':TOTTVA5,'        + cRC +
                                                                       ':TVA5,'           + cRC +
                                                                       ':ARCHIVER,'       + cRC +
                                                                       ':NUMFACT)';

  cSql_MG10_RECEPTION_LIGNE = 'SELECT BRLID, MRKID FROM MG10_RECEPTION_LIGNE(:BREID,'   + cRC +
                                                                            ':ARTID,'   + cRC +
                                                                            ':TGFID,'   + cRC +
                                                                            ':COUID,'   + cRC +
                                                                            ':COLID,'   + cRC +
                                                                            ':PXBRUT,'  + cRC +
                                                                            ':REMISE,'  + cRC +
                                                                            ':PXNET,'   + cRC +
                                                                            ':PXVTE,'   + cRC +
                                                                            ':QTE,'     + cRC +
                                                                            ':CDLLIV,'  + cRC +
                                                                            ':TVA)';



  cSql_MG10_CONSODIV = 'SELECT CDVID FROM MG10_CONSODIV(:MAGID,'     + cRC +
                                                       ':ARTID,'     + cRC +
                                                       ':TGFID,'     + cRC +
                                                       ':COUID,'     + cRC +
                                                       ':CDVDATE,'   + cRC +
                                                       ':TYPID,'     + cRC +
                                                       ':CDVQTE,'    + cRC +
                                                       ':CDVCOMENT)';

  cSql_MG10_TRANSFERT = 'SELECT IMAID FROM MG10_TRANSFERT(:NUMBON,'       + cRC +
                                                         ':MAGID_IMPORT,' + cRC +
                                                         ':TYPID,'        + cRC +
                                                         ':ARTID,'        + cRC +
                                                         ':TGFID,'        + cRC +
                                                         ':COUID,'        + cRC +
                                                         ':CODEEAN,'      + cRC +
                                                         ':CODEMAGO,'     + cRC +
                                                         ':CODEMAGD,'     + cRC +
                                                         ':IMADATE,'      + cRC +
                                                         ':IMLQTE,'       + cRC +
                                                         ':IMLPXN,'       + cRC +
                                                         ':IMLTAUX,'      + cRC +
                                                         ':IMLTVA)';

  cSql_MG10_COMMANDE_ENTETE = 'SELECT CDEID FROM MG10_COMMANDE_ENTETE(:NUMBON,'   + cRC +
                                                                     ':NUMFOURN,' + cRC +
                                                                     ':FOUID,'    + cRC +
                                                                     ':MAGID,'    + cRC +
                                                                     ':CDEDATE,'  + cRC +
                                                                     ':TYPID,'    + cRC +
                                                                     ':CPAID,'    + cRC +
                                                                     ':COLID,'    + cRC +
                                                                     ':DATELIV,'  + cRC +
                                                                     ':RETARD,'   + cRC +
                                                                     ':DATEREG)';

  cSql_MG10_COMMANDE_LIGNE = 'SELECT CDLID, MRKID FROM MG10_COMMANDE_LIGNE(:CDEID,'    + cRC +
                                                                          ':ARTID,'    + cRC +
                                                                          ':TGFID,'    + cRC +
                                                                          ':COUID,'    + cRC +
                                                                          ':COLID,'    + cRC +
                                                                          ':QTE,'      + cRC +
                                                                          ':PXACHAT,'  + cRC +
                                                                          ':PXBRUT,'   + cRC +
                                                                          ':REM1,'     + cRC +
                                                                          ':REM2,'     + cRC +
                                                                          ':REM3,'     + cRC +
                                                                          ':PXVTE,'    + cRC +
                                                                          ':DATELIV,'  + cRC +
                                                                          ':TVA)';

  cSql_MG10_RETOURFOU_ENTETE = 'SELECT RETID FROM MG10_RETOURFOU_ENTETE(:NUMBON,'         + cRC +
                                                                       ':NUMFOURN,'       + cRC +
                                                                       ':RETDATE,'        + cRC +
                                                                       ':FOUID,'          + cRC +
                                                                       ':MAGID,'          + cRC +
                                                                       ':MRGLIB,'         + cRC +
                                                                       ':DATEREGLEMENT,'  + cRC +
                                                                       ':COMMENT_E,'      + cRC +
                                                                       ':CLOTURE,'        + cRC +
                                                                       ':TOTTVA1,'        + cRC +
                                                                       ':TVA1,'           + cRC +
                                                                       ':TOTTVA2,'        + cRC +
                                                                       ':TVA2,'           + cRC +
                                                                       ':TOTTVA3,'        + cRC +
                                                                       ':TVA3,'           + cRC +
                                                                       ':TOTTVA4,'        + cRC +
                                                                       ':TVA4,'           + cRC +
                                                                       ':TOTTVA5,'        + cRC +
                                                                       ':TVA5,'           + cRC +
                                                                       ':ARCHIVER)';

  cSql_MG10_RETOURFOU_LIGNE = 'SELECT RELID FROM MG10_RETOURFOU_LIGNE(:RETID,'      + cRC +
                                                                     ':ARTID,'      + cRC +
                                                                     ':TGFID,'      + cRC +
                                                                     ':COUID,'      + cRC +
                                                                     ':PXNET,'      + cRC +
                                                                     ':QTE,'        + cRC +
                                                                     ':COMMENT_L,'  + cRC +
                                                                     ':TXTVA,'      + cRC +
                                                                     ':CODELIGNE)';

  cSql_MG10_Avoir = 'SELECT AVRID FROM MG10_AVOIR(:CLTID,'              + cRC +
                                                 ':CHRONO,'             + cRC +
                                                 ':TKEID,'              + cRC +
                                                 ':CODE_POSTE,'         + cRC +
                                                 ':CODE_SESSION,'       + cRC +
                                                 ':NUM_TICKET,'         + cRC +
                                                 ':MAGID,'              + cRC +
                                                 ':DATEEMI,'            + cRC +
                                                 ':DATEVAL,'            + cRC +
                                                 ':VALEUR,'             + cRC +
                                                 ':UTIL,'               + cRC +
                                                 ':CODE_POSTE_UTIL,'    + cRC +
                                                 ':CODE_SESSION_UTIL,'  + cRC +
                                                 ':NUM_TICKET_UTIL,'    + cRC +
                                                 ':SUPPR,'              + cRC +
                                                 ':REPRISE)';

  cSql_MG10_BONLIVRAISON_ENTETE = 'SELECT BLEID FROM MG10_BONLIVRAISON_ENTETE(:MAGID,'          + cRC +
                                                                             ':CLTID,'          + cRC +
                                                                             ':TYPBL,'          + cRC +
                                                                             ':NUMERO,'         + cRC +
                                                                             ':DATEBL,'         + cRC +
                                                                             ':REMISE,'         + cRC +
                                                                             ':DETAXE,'         + cRC +
                                                                             ':TOTTVA1,'        + cRC +
                                                                             ':TVA1,'           + cRC +
                                                                             ':TOTTVA2,'        + cRC +
                                                                             ':TVA2,'           + cRC +
                                                                             ':TOTTVA3,'        + cRC +
                                                                             ':TVA3,'           + cRC +
                                                                             ':TOTTVA4,'        + cRC +
                                                                             ':TVA4,'           + cRC +
                                                                             ':TOTTVA5,'        + cRC +
                                                                             ':TVA5,'           + cRC +
                                                                             ':CLOTURE,'        + cRC +
                                                                             ':ARCHIVER,'       + cRC +
                                                                             ':CLIENT_NOM,'     + cRC +
                                                                             ':CLIENT_PRENOM,'  + cRC +
                                                                             ':CIVILITE,'       + cRC +
                                                                             ':VILLE,'          + cRC +
                                                                             ':CP,'             + cRC +
                                                                             ':PAYS,'           + cRC +
                                                                             ':ADRLIGNE,'       + cRC +
                                                                             ':COMENT,'         + cRC +
                                                                             ':MARGE,'          + cRC +
                                                                             ':TYPID,'          + cRC +
                                                                             ':BLSID,'          + cRC +
                                                                             ':BLMID,'          + cRC +
                                                                             ':DTLIMRETRAIT,'   + cRC +
                                                                             ':NUMCARTEFID,'    + cRC +
                                                                             ':REPRISE)';

  cSql_MG10_BONLIVRAISON_LIGNE = 'SELECT BLLID FROM MG10_BONLIVRAISON_LIGNE(:BLEID,'     + cRC +
                                                                           ':ARTID,'     + cRC +
                                                                           ':TGFID,'     + cRC +
                                                                           ':COUID,'     + cRC +
                                                                           ':NOM,'       + cRC +
                                                                           ':TYPVTE,'    + cRC +
                                                                           ':QTE,'       + cRC +
                                                                           ':PXBRUT,'    + cRC +
                                                                           ':PXNET,'     + cRC +
                                                                           ':PXNN,'      + cRC +
                                                                           ':TVA,'       + cRC +
                                                                           ':COMENT,'    + cRC +
                                                                           ':QTECMD,'    + cRC +
                                                                           ':QTEPREP,'   + cRC +
                                                                           ':QTERETIRE,' + cRC +
                                                                           ':QTERETOUR,' + cRC +
                                                                           ':TYPID,'     + cRC +
                                                                           ':BLMID,'     + cRC +
                                                                           ':REPRISE)';

  cSql_MG10_BONLIVRAISON_HISTO = 'SELECT BLHID FROM MG10_BONLIVRAISON_HISTO(:BLEID,'        + cRC +
                                                                           ':DATEHISTO,'    + cRC +
                                                                           ':BLSCODE,'      + cRC +
                                                                           ':BLSLIB,'       + cRC +
                                                                           ':BLMCODE,'      + cRC +
                                                                           ':BLMLIB,'       + cRC +
                                                                           ':NUMCARTEFIS,'  + cRC +
                                                                           ':DTLIMRETRAIT,'  + cRC +
                                                                           ':BLHETAT)';

  // SQL pour les bons de rapprochement.
  cSql_MG10_BON_RAPPROCHEMENT = 'select RPEID from MG10_BON_RAPPROCHEMENT(:DATE_CREATION,' + cRC +
                                                                         ':DATE_FACTURE,' + cRC +
                                                                         ':DATE_ECHEANCE,' + cRC +
                                                                         ':MONTANT_FACTURE,' + cRC +
                                                                         ':FRAIS_PORT,' + cRC +
                                                                         ':FRAIS_ANNEXES,' + cRC +
                                                                         ':CHRONO,' + cRC +
                                                                         ':NUM_FOURN_FACTURE,' + cRC +
                                                                         ':ID_FOURN,' + cRC +
                                                                         ':REMISE_GLOBALE,' + cRC +
                                                                         ':MONTANT_TVA_REMISE_GLOBALE,' + cRC +
                                                                         ':MONTANT_TVA_FRAIS_PORT,' + cRC +
                                                                         ':MONTANT_TVA_FRAIS_ANNEXES,' + cRC +
                                                                         ':CLOTURE,' + cRC +
                                                                         ':EXPORTE,' + cRC +
                                                                         ':CODE_MAG,' + cRC +
                                                                         ':DATE_EXPORT_COMPTABLE,' + cRC +
                                                                         ':COMMENTAIRE,' + cRC +
                                                                         ':ARCHIVE,' + cRC +
                                                                         ':CENTRALE)';

  cSql_MG10_BON_RAPPROCHEMENT_LIEN = 'select RPRID from MG10_BON_RAPPROCHEMENT_LIEN(:ID_BON,' + cRC +
                                                                                   ':ID_RECEPTION,' + cRC +
                                                                                   ':ID_RETOUR)';

  cSql_MG10_BON_RAPPROCHEMENT_TVA = 'select RPTID from MG10_BON_RAPPROCHEMENT_TVA(:ID_BON,' + cRC +
                                                                                 ':TVAID,' + cRC +
                                                                                 ':TAUX_TVA,' + cRC +
                                                                                 ':MONTANT_TTC,' + cRC +
                                                                                 ':MONTANT_HT,' + cRC +
                                                                                 ':MONTANT_BRUT_HT,' + cRC +
                                                                                 ':MONTANT_REMISE,' + cRC +
                                                                                 ':MONTANT_NET_TTC,' + cRC +
                                                                                 ':MONTANT_TVA_FRAIS_PORT,' + cRC +
                                                                                 ':MONTANT_TVA_FRAIS_ANNEXES,' + cRC +
                                                                                 ':MONTANT_TVA)';

  cSql_MG10_BON_RAPPROCHEMENT_LIGNE_RECEPTION = 'execute procedure MG10_BON_RAPPROCHEMENT_LIGNE_RECEPTION(:ID_LIGNE,' + cRC +
                                                                                                         ':ID_BON)';

  cSql_MG10_BON_RAPPROCHEMENT_LIGNE_RETOUR = 'execute procedure MG10_BON_RAPPROCHEMENT_LIGNE_RETOUR(:ID_LIGNE,' + cRC +
                                                                                                   ':ID_BON)';

  // SQL pour l'atelier
  cSql_MG10_SavTauxH = 'select id from MG10_SAVTAUX(:NOM,' + cRC +
                                                   ':PRIX,' + cRC +
                                                   ':CENTRALE)';

  cSql_MG10_SavForfait = 'select id from MG10_SAVFORFAIT(:NOM,' + cRc +
                                                        ':PRIX,' + cRc +
                                                        ':DUREE,' + cRc +
                                                        ':CENTRALE)';

  cSql_MG10_SavForfaitL = 'select id from MG10_SAVFORFAITL(:FORID,' + cRC +
                                                          ':ARTID,' + cRC +
                                                          ':TGFID,' + cRC +
                                                          ':COUID,' + cRC +
                                                          ':QTE)';

  cSql_MG10_SavPt1 = 'select id from MG10_SAVPT1(:PICTO,' + cRC +
                                                ':ORDREAFF,' + cRC +
                                                ':NOM,' + cRC +
                                                ':CENTRALE)';

  cSql_MG10_SavPt2 = 'select id from MG10_SAVPT2(:PT1ID,' + cRC +
                                                ':NOM,' + cRC +
                                                ':FORFAIT,' + cRC +
                                                ':FORID,' + cRC +
                                                ':DUREE,' + cRC +
                                                ':PICTO,' + cRC +
                                                ':TXHID,' + cRC +
                                                ':ARTID,' + cRC +
                                                ':ORDREAFF,' + cRC +
                                                ':LIBELLE,' + cRC +
                                                ':CENTRALE)';

  cSql_MG10_SavTypMat = 'select id from MG10_SAVTYPMAT(:NOM)';

  cSql_MG10_SavType = 'select id from MG10_SAVTYPE(:NOM)';

  cSql_MG10_SavMat = 'select id from MG10_SAVMAT(:CLTID,' + cRC +
                                                ':TYMID,' + cRC +
                                                ':MRKID,' + cRC +
                                                ':ARTID,' + cRC +
                                                ':NOM,' + cRC +
                                                ':SERIE,' + cRC +
                                                ':COULEUR,' + cRC +
                                                ':COMMENT,' + cRC +
                                                ':DATEACHAT,' + cRC +
                                                ':REFMRK,' + cRC +
                                                ':ASSUR,' + cRC +
                                                ':CHRONO,' + cRC +
                                                ':ARLID)';

  cSql_MG10_SavCb = 'select id from MG10_SAVCB(:MATID,' + cRC +
                                              ':CB)';

  cSql_MG10_SavFichee = 'select id from MG10_SAVFICHEE(:CLTID,' + cRC +
                                                      ':MATID,' + cRC +
                                                      ':CHRONO,' + cRC +
                                                      ':DTCREATION,' + cRC +
                                                      ':DEBUT,' + cRC +
                                                      ':FIN,' + cRC +
                                                      ':REMMO,' + cRC +
                                                      ':REMART,' + cRC +
                                                      ':REM,' + cRC +
                                                      ':IDENT,' + cRC +
                                                      ':USRID,' + cRC +
                                                      ':LIMITE,' + cRC +
                                                      ':MAGID,' + cRC +
                                                      ':ETAT,' + cRC +
                                                      ':DATEREPRISE,' + cRC +
                                                      ':STYID,' + cRC +
                                                      ':DATEPLANNING,' + cRC +
                                                      ':COMMENT,' + cRC +
                                                      ':ORDREAFF,' + cRC +
                                                      ':DUREEGLOB,' + cRC +
                                                      ':DUREE,' + cRC +
                                                      ':TXHID,' + cRC +
                                                      ':PXTAUX,' + cRC +
                                                      ':TKEID,' + cRC +
                                                      ':NEUF,' + cRC +
                                                      ':PLACE)';

  cSql_MG10_SavFicheL = 'select id from MG10_SAVFICHEL(:SAVID,' + cRC +
                                                      ':PT2ID,' + cRC +
                                                      ':FORID,' + cRC +
                                                      ':NOM,' + cRC +
                                                      ':COMMENT,' + cRC +
                                                      ':DUREE,' + cRC +
                                                      ':TXHID,' + cRC +
                                                      ':REMISE,' + cRC +
                                                      ':PXTOT,' + cRC +
                                                      ':TERMINE,' + cRC +
                                                      ':PXBRUT)';

  cSql_MG10_SavFicheArt = 'select id from MG10_SAVFICHEART(:ARTID,' + cRC +
                                                          ':TGFID,' + cRC +
                                                          ':COUID,' + cRC +
                                                          ':SAVID,' + cRC +
                                                          ':SALID,' + cRC +
                                                          ':PU,' + cRC +
                                                          ':REMISE,' + cRC +
                                                          ':QTE,' + cRC +
                                                          ':PXTOT,' + cRC +
                                                          ':TYPID)';

var
  //Clients
  Clients_COL : array[1..26] of string = ('CODE',           //1
                                          'TYPE',           //2
                                          'NOM_RS1',        //3
                                          'PREN_RS2',       //4
                                          'CIV',            //5
                                          'ADR1',           //6
                                          'ADR2',           //7
                                          'ADR3',           //8
                                          'CP',             //9
                                          'VILLE',          //10
                                          'PAYS',           //11
                                          'CODE_COMPTABLE', //12
                                          'COM',            //13
                                          'TEL',            //14
                                          'FAX_TTRAV',      //15
                                          'PORTABLE',       //16
                                          'EMAIL',          //17
                                          'CB_NATIONAL',    //18
                                          'CLASS1',         //19
                                          'CLASS2',         //20
                                          'CLASS3',         //21
                                          'CLASS4',         //22
                                          'CLASS5',         //23
                                          'CB_INTERNE',     //24
                                          'CLI_NUMERO',     //25
                                          'CODE_MAG');      //26

  LienClients_COL : array[1..4] of string = ('CODEPRO',     //1
                                             'CODEPART',    //2
                                             'DATEDEBUT',   //3
                                             'DATEFIN');    //4

  Comptes_COL : array[1..9] of string = ('CODE',      //1
                                         'LIBELLE',   //2
                                         'DATE',      //3
                                         'CREDIT',    //4
                                         'DEBIT',     //5
                                         'LETTRAGE',  //6
                                         'LETNUM',    //7
                                         'CODE_MAG',  //8
                                         'ORIGINE');  //9

  //Fidélité Ginkoia
  Fidelite_COL : array[1..10] of string = ('CODE',        //1
                                          'CODE_POSTE',   //2
	                                        'CODE_SESSION', //3
	                                        'NUM_TICKET',   //4
                                          'POINT',        //5
                                          'DATE',         //6
                                          'CODE_MAG',     //7
                                          'CODE_BA',      //8
                                          'CODE_CLIENT',  //9
                                          'MANUEL');      //10

  BonAchats_COL : array[1..7] of string = ('CODE',          //1
                                           'CODE_CLIENT',   //2
                                           'MONTANT',       //3
                                           'CODE_POSTE',    //4
	                                         'CODE_SESSION',  //5
	                                         'NUM_TICKET',    //6
                                           'CODE_MAG');     //7
                                           //'CODE_FID');     //7

  //Référentiel article
  Fourn_COL : array [1..19] of string = ('Code',        //1
                                         'Nom',         //2
                                         'CodeIS',      //3
                                         'Adr1',        //4
                                         'Adr2',        //5
                                         'Adr3',        //6
                                         'CP',          //7
                                         'Ville',       //8
                                         'Pays',        //9
                                         'Tel',         //10
                                         'Fax',         //11
                                         'Portable',    //12
                                         'email',       //13
                                         'Commentaire', //14
                                         'Num_Clt',     //15
                                         'Num_compta',  //16
                                         'ACTIF',       //17
                                         'CENTRALE',    //18
                                         'ILN');        //19

  Fourn_2_COL : array [1..20] of string = ('Code',        //1
                                           'Nom',         //2
                                           'CodeIS',      //3
                                           'Adr1',        //4
                                           'Adr2',        //5
                                           'Adr3',        //6
                                           'CP',          //7
                                           'Ville',       //8
                                           'Pays',        //9
                                           'Tel',         //10
                                           'Fax',         //11
                                           'Portable',    //12
                                           'email',       //13
                                           'Commentaire', //14
                                           'Num_Clt',     //15
                                           'Num_compta',  //16
                                           'ACTIF',       //17
                                           'CENTRALE',    //18
                                           'ILN',         //19
                                           'ERPNO');      //20

  Marque_COL : array [1..6] of string = ('CODE',      //1
                                         'NOM',       //2
                                         'CODEIS',    //3
                                         'ACTIF',     //4
                                         'PROPRE',    //5
                                         'CENTRALE'); //6

  Foumarque_COL : array [1..3] of string = ('CODE_MARQUE',  //1
                                            'CODE_FOU',     //2
                                            'FOU_PRINC' );  //3

  GrTaille_COL : array [1..8] of string = ('CODE',            //1
                                           'NOM',             //2
                                           'CodeIS',          //3
                                           'TYPE_GRILLE',     //4
                                           'CODE_TYPEGT',     //5
                                           'CODEIS_TYPEGT',   //6
                                           'CENTRALE_TYPEGT', //7
                                           'CENTRALE');       //8

  GrTailleLig_COL : array [1..8] of string = ('CODE_GT',  //1
                                              'NOM',      //2
                                              'CODEIS',   //3
                                              'CODE',     //4
                                              'CENTRALE', //5
                                              'CORRES',   //6
                                              'ORDREAFF', //7
                                              'ACTIF');   //8

  DomaineCommercial_COL : array [1..2] of string = ('CODE',   //1
                                                    'NOM');   //2

  Axe_COL : array [1..10] of string = ('CODE',       //1
                                       'NIVEAU',     //2
                                       'NOM',        //3
                                       'CODEIS',     //4
                                       'CENTRALE',   //5
                                       'LIBN1',      //6
                                       'LIBN2',      //7
                                       'LIBN3',      //8
                                       'LIBN4',      //9
                                       'ACTIVITE');  //10

  AxeNiveau1_COL : array [1..8] of string = ('CODEAXE',   //1
                                             'CODE',      //2
                                             'NOM',       //3
                                             'CODEIS',    //4
                                             'VISIBLE',   //5
                                             'CENTRALE',  //6
                                             'ORDREAFF',  //7
                                             'CODENIV');  //8

  AxeNiveau2_COL : array [1..8] of string = ('CODEN1',    //1
                                             'CODE',      //2
                                             'NOM',       //3
                                             'CODEIS',    //4
                                             'VISIBLE',   //5
                                             'CENTRALE',  //6
                                             'ORDREAFF',  //7
                                             'CODENIV');  //8

  AxeNiveau3_COL : array [1..8] of string = ('CODEN2',    //1
                                             'CODE',      //2
                                             'NOM',       //3
                                             'CODEIS',    //4
                                             'VISIBLE',   //5
                                             'CENTRALE',  //6
                                             'ORDREAFF',  //7
                                             'CODENIV');  //8

  AxeNiveau4_COL : array [1..11] of string = ('CODEN3',          //1
                                              'CODE',            //2
                                              'NOM',             //3
                                              'CODEIS',          //4
                                              'VISIBLE',         //5
                                              'CENTRALE',        //6
                                              'ORDREAFF',        //7
                                              'CODENIV',         //8
                                              'CODEFINAL',       //9
                                              'TVA',             //10
                                              'TYPECOMPTABLE');  //11

  Collection_COL : array [1..7] of string = ('CODE',      //1
                                             'NOM',       //2
                                             'CODEIS',    //3
                                             'ACTIF',     //4
                                             'CENTRALE',  //5
                                             'DTDEB',     //6
                                             'DTFIN');    //7

  Genre_COL : array [1..3] of string = ('CODE',       //1
                                        'NOM',        //2
                                        'CODESEXE');  //3

  Article_COL : array [1..29] of string = ('CODE',          //1
                                           'CODE_MRQ',      //2
                                           'CODE_GT',       //3
                                           'CODE_FOURN',    //4
                                           'NOM',           //5
                                           'CODEIS',        //6
                                           'CODEFEDAS',     //7
                                           'DESCRIPTION',   //8
                                           'CLASS1',        //9
                                           'CLASS2',        //10
                                           'CLASS3',        //11
                                           'CLASS4',        //12
                                           'CLASS5',        //13
                                           'CLASS6',        //14
                                           'FIDELITE',      //15
                                           'DATECREATION',  //16
                                           'COMENT1',       //17
                                           'COMENT2',       //18
                                           'TVA',           //19
                                           'PSEUDO',        //20
                                           'ARCHIVER',      //21
                                           'CODE_GENRE',    //22
                                           'CODE_DOMAINE',  //23
                                           'CENTRALE',      //24
                                           'TYPECOMPTABLE', //25
                                           'FLAGMODELE',    //26
                                           'STKIDEAL',      //27
                                           'ECOPART',       //28
                                           'ECOMOB');       //29

  Article_2_COL : array [1..32] of string = ('CODE',        //1
                                           'CODE_MRQ',      //2
                                           'CODE_GT',       //3
                                           'CODE_FOURN',    //4
                                           'NOM',           //5
                                           'CODEIS',        //6
                                           'CODEFEDAS',     //7
                                           'CODEEXFEDAS',   //8
                                           'CODEUNI',       //9
                                           'CODEEXUNI',     //10
                                           'DESCRIPTION',   //11
                                           'CLASS1',        //12
                                           'CLASS2',        //13
                                           'CLASS3',        //14
                                           'CLASS4',        //15
                                           'CLASS5',        //16
                                           'CLASS6',        //17
                                           'FIDELITE',      //18
                                           'DATECREATION',  //19
                                           'COMENT1',       //20
                                           'COMENT2',       //21
                                           'TVA',           //22
                                           'PSEUDO',        //23
                                           'ARCHIVER',      //24
                                           'CODE_GENRE',    //25
                                           'CODE_DOMAINE',  //26
                                           'CENTRALE',      //27
                                           'TYPECOMPTABLE', //28
                                           'FLAGMODELE',    //29
                                           'STKIDEAL',      //30
                                           'ECOPART',       //31
                                           'ECOMOB');       //32

  ArticleAxe_COL : array [1..3] of string = ('CODE_ART',  //1
                                             'CODE_N4',   //2
                                             'CODE_AXE'); //3

  ArticleCollection_COL : array [1..2] of string = ('CODE_ART',     //1
                                                    'CODE_COLLEC'); //2


  Couleur_COL : array [1..7] of string = ('CODE_ART',    //1
                                          'COU_NOM',     //2
                                          'COU_CODE',    //3
                                          'CODEIS',      //4
                                          'COU_CENT',    //5
                                          'COU_SMU',     //6
                                          'COU_TDSC');   //7

  CodeBarre_COL : array [1..6] of string = ('CODE_ART',     //1
                                            'CODE_TAILLE',  //2
                                            'CODE_COUL',    //3
                                            'EAN',          //4
                                            'TYPE',         //5
                                            'PRIN');        //6

  Prix_Achat_COL : array [1..8] of string = ('CODE_ART',        //1
                                             'CODE_TAILLE',     //2
                                             'CODE_COUL',       //3
                                             'CODE_FOU',        //4
                                             'PXCATALOGUE',     //5
                                             'PX_ACHAT',        //6
                                             'FOU_PRINCIPAL',   //7
                                             'PXDEBASE');       //8

  Prix_Vente_COL : array [1..6] of string = ('CODE_ART',        //1
                                              'CODE_TAILLE',    //2
                                              'CODE_COUL',      //3
                                              'NOMTAR',         //4
                                              'PX_VENTE',       //5
                                              'PXDEBASE');      //6

  Prix_Vente_Indicatif_COL : array [1..9] of string = ('CODE_ART',            //1
                                                       'CODE_TAILLE',         //2
                                                       'CODE_COUL',           //3
                                                       'NOMTAR',              //4
                                                       'PX_VTE_INDIC',        //5
                                                       'PX_VTE_INDIC_DATE',   //6
                                                       'PX_VTE_AVENIR',       //7
                                                       'PX_VTE_AVENIR_DATE',  //8
                                                       'PXDEBASE');           //9

  ModeleDeprecie_COL : array [1..5] of string = ('CODE_ART',  //1
                                                 'DATE',      //2
                                                 'TAUX',      //3
                                                 'MOTIF',     //4
                                                 'DIVERS');   //5

  FouContact_COL : array [1..8] of string = ('CODE_FOU',      //1
                                             'NOM',           //2
                                             'PRENOM',        //3
                                             'FONCTION',      //4
                                             'TELEPHONE',     //5
                                             'TELPORTABLE',   //6
                                             'EMAIL',         //7
                                             'COMMENT');      //8

  FouCondition_COL : array [1..9] of string = ('CODE_FOU',    //1
                                               'CODE_MAG',    //2
                                               'NUMCLIENT',   //3
                                               'COMMENT',     //4
                                               'ENCOURS',     //5
                                               'NUMCOMPTA',   //6
                                               'FRANCOPORT',  //7
                                               'MODEREG',     //8
                                               'CONDREG');    //9

  ArtIdeal_COL : array [1..5] of string = ('CODE_MAG',        //1
                                           'CODE_ART',        //2
                                           'CODE_TAILLE',     //3
                                           'CODE_COUL',       //4
                                           'QTE');            //5

  OcTete_COL : array [1..9] of string = ('TOC_CODE',          //1
                                         'TOC_NOM',           //2
                                         'TOC_COMMENT',       //3
                                         'TOC_DEBUT',         //4
                                         'TOC_FIN',           //5
                                         'TOC_TYPID',         //6
                                         'TOC_WEB',           //7
                                         'TOC_CENTRALE',      //8
                                         'TOC_INFOCODE');     //9

  OcMag_COL : array [1..4] of string = ('TOC_CODE',           //1
                                        'CODE_MAG',           //2
                                        'CODE_CLI',           //3
                                        'CODE_CLIPRO');       //4

  OcLignes_COL : array [1..5] of string = ('TOC_CODE',        //1
                                           'TOC_CODELIG',     //2
                                           'CODE_ART',        //3
                                           'PVTE',            //4
                                           'OCL_LOTID');      //5

  OcDetail_COL : array [1..8] of string = ('TOC_CODE',        //1
                                           'TOC_CODELIG',     //2
                                           'CODE_ART',        //3
                                           'CODE_TAILLE',     //4
                                           'CODE_COUL',       //5
                                           'OCDET_PRIX',      //6
                                           'OCDET_ACTIVE',    //7
                                           'OCDET_CENTRALE'); //8

  AllCB_COL : array [1..5] of string = ('CODE_ART',     //1
                                        'CODE_TAILLE',  //2
                                        'CODE_COUL',    //3
                                        'EAN',          //4
                                        'TYPE');        //5

  //Historique
  Caisse_COL : array [1..17] of string = ('CODE_ART',     //1
                                          'CODE_TAILLE',  //2
                                          'CODE_COUL',    //3
                                          'EAN',          //4
                                          'CODE_MAG',     //5
                                          'CODE_POSTE',   //6
                                          'CODE_SESSION', //7
                                          'DATE',         //8
                                          'HEURE',        //9
                                          'NUM_TICKET',   //10
                                          'PXBRUT',       //11
                                          'PXNN',         //12
                                          'TVA',          //13
                                          'QTE',          //14
                                          'TYPEVTE',      //15
                                          'CODE_CLIENT',  //16
                                          'PUMP');        //17

  Caisse_2_COL : array [1..20] of string = ('CODE_ART',   //1
                                          'CODE_TAILLE',  //2
                                          'CODE_COUL',    //3
                                          'EAN',          //4
                                          'CODE_MAG',     //5
                                          'CODE_POSTE',   //6
                                          'CODE_SESSION', //7
                                          'DATE',         //8
                                          'HEURE',        //9
                                          'NUM_TICKET',   //10
                                          'PXBRUT',       //11
                                          'PXNN',         //12
                                          'TVA',          //13
                                          'QTE',          //14
                                          'TYPEVTE',      //15
                                          'CODE_CLIENT',  //16
                                          'PUMP',         //17
                                          'TKEID',        //18
                                          'ECOPART',      //19
                                          'ECOMOB');      //20

  Reception_COL : array [1..32] of string = ('CODE_ART',     //1
                                             'CODE_TAILLE',  //2
                                             'CODE_COUL',    //3
                                             'EAN',          //4
                                             'CODE_MAG',     //5
                                             'CODE_FOURN',   //6
                                             'NUMBON',       //7
                                             'DATE',         //8
                                             'CODE_COLLEC',  //9
                                             'PXBRUT',       //10
                                             'PXNET',        //11
                                             'QTE',          //12
                                             'MODEREG',      //13
                                             'CONDREG',      //14
                                             'DATEREG',      //15
                                             'CLOTURE',      //16
                                             'TOTTVA1',      //17
                                             'TVA1',         //18
                                             'TOTTVA2',      //19
                                             'TVA2',         //20
                                             'TOTTVA3',      //21
                                             'TVA3',         //22
                                             'TOTTVA4',      //23
                                             'TVA4',         //24
                                             'TOTTVA5',      //25
                                             'TVA5',         //26
                                             'PUMP',         //27
                                             'PXVTE',        //28
                                             'ARCHIVER',     //29
                                             'NUMFACT',      //30
                                             'TVA',          //31
                                             'ID_LIGNE');    //32

  Consodiv_COL : array [1..11] of string = ('CODE_ART',    //1
                                           'CODE_TAILLE', //2
                                           'CODE_COUL',   //3
                                           'EAN',         //4
                                           'CODE_MAG',    //5
                                           'DATE',        //6
                                           'TYPE',        //7
                                           'TYPEGINKOIA', //8
                                           'QTE',         //9
                                           'MOTIF',       //10
                                           'PUMP');       //11

  Transfert_COL : array [1..13] of string = ('CODE_ART',    //1
                                             'CODE_TAILLE', //2
                                             'CODE_COUL',   //3
                                             'EAN',         //4
                                             'CODE_MAGO',   //5
                                             'CODE_MAGD',   //6
                                             'DATE',        //7
                                             'QTE',         //8
                                             'PXBRUT',      //9
                                             'TAUX',        //10
                                             'TVA',         //11
                                             'PUMP',        //12
                                             'NUMBON');     //13

  Commandes_COL : array [1..22] of string = ('CODE_ART',    //1
                                             'CODE_TAILLE', //2
                                             'CODE_COUL',   //3
                                             'EAN',         //4
                                             'CODE_MAG',    //5
                                             'CODE_FOURN',  //6
                                             'NUMBON',      //7
                                             'DATE',        //8
                                             'CODE_COLLEC', //9
                                             'TYPE',        //10
                                             'PXBRUT',      //11
                                             'REM1',        //12
                                             'REM2',        //13
                                             'REM3',        //14
                                             'PXNET',       //15
                                             'QTE',         //16
                                             'DATELIV',     //17
                                             'RETARD',      //18
                                             'CONDREG',     //19
                                             'DATEREG',     //20
                                             'PXVTE',       //21
                                             'TVA');        //22

  RetourFou_COL : array [1..29] of string = ('CODE_ART',     //1
                                             'CODE_TAILLE',  //2
                                             'CODE_COUL',    //3
                                             'EAN',          //4
                                             'CODE_MAG',     //5
                                             'CODE_FOURN',   //6
                                             'NUMBON',       //7
                                             'NUMCHRONO',    //8
                                             'DATE_RET',     //9
                                             'PXNET',        //10
                                             'QTE',          //11
                                             'COMMENT_E',    //12
                                             'COMMENT_L',    //13
                                             'TXTVA',        //14
                                             'CODELIGNE',    //15
                                             'MODEREG',      //16
                                             'DATEREG',      //17
                                             'CLOTURE',      //18
                                             'TOTTVA1',      //19
                                             'TVA1',         //20
                                             'TOTTVA2',      //21
                                             'TVA2',         //22
                                             'TOTTVA3',      //23
                                             'TVA3',         //24
                                             'TOTTVA4',      //25
                                             'TVA4',         //26
                                             'TOTTVA5',      //27
                                             'TVA5',         //28
                                             'ARCHIVER');    //29

  Avoir_COL : array [1..15] of string = ('CODE',              //1
                                         'CHRONO',            //2
                                         'CODE_MAG',          //3
                                         'CODE_POSTE',        //4
                                         'CODE_SESSION',      //5
                                         'NUM_TICKET',        //6
                                         'DATEEMI',           //7
                                         'DATEVAL',           //8
                                         'CODE_CLIENT',       //9
                                         'VALEUR',            //10
                                         'UTIL',              //11
                                         'CODE_POSTE_UTIL',   //12
                                         'CODE_SESSION_UTIL', //13
                                         'NUM_TICKET_UTIL',   //14
                                         'SUPPR');            //15

  ListeChrono_COL : array [1..5] of string = ('NUMTABLE',       //1
                                             'NOMTABLE',        //2
                                             'NOMGENERATEUR',   //3
                                             'NUMBASE',         //4
                                             'NUMGENE');        //5

  BonLivraison_COL : array [1..35] of string = ('CODE_BL',        //1
                                                'CODE_MAG',       //2
                                                'CODE_CLIENT',    //3
                                                'NUMERO',         //4
                                                'TYPBL',          //5
                                                'TYPCODBL',       //6
                                                'TYPCATEG',       //7
                                                'DATEBL',         //8
                                                'REMISE',         //9
                                                'DETAXE',         //10
                                                'TOTTVA1',        //11
                                                'TVA1',           //12
                                                'TOTTVA2',        //13
                                                'TVA2',           //14
                                                'TOTTVA3',        //15
                                                'TVA3',           //16
                                                'TOTTVA4',        //17
                                                'TVA4',           //18
                                                'TOTTVA5',        //19
                                                'TVA5',           //20
                                                'CLOTURE',        //21
                                                'ARCHIVER',       //22
                                                'CLIENT_NOM',     //23
                                                'CLIENT_PRENOM',  //24
                                                'CIVILITE',       //25
                                                'VILLE',          //26
                                                'CP',             //27
                                                'PAYS',           //28
                                                'ADRLIGNE',       //29
                                                'COMENT',         //30
                                                'MARGE',          //31
                                                'BLSCODE',        //32
                                                'BLMCODE',        //33
                                                'DTLIMRETRAIT',   //34
                                                'NUMCARTEFID');   //35

  BonLivraisonL_COL : array [1..20] of string = ('CODE_BLL',     //1
                                                 'CODE_BL',      //2
                                                 'CODE_ART',     //3
                                                 'CODE_TAILLE',  //4
                                                 'CODE_COUL',    //5
                                                 'NOM',          //6
                                                 'TYPVTE',       //7
                                                 'TYPCODBL',     //8
                                                 'TYPCATEG',     //9
                                                 'QTE',          //10
                                                 'PXBRUT',       //11
                                                 'PXNET',        //12
                                                 'PXNN',         //13
                                                 'TVA',          //14
                                                 'COMENT',       //15
                                                 'QTECMD',       //16
                                                 'QTEPREP',      //17
                                                 'QTERETIRE',    //18
                                                 'QTERETOUR',    //19
                                                 'BLMCODE');     //20

  BonLivraisonHisto_COL : array [1..10] of string = ('CODE_HISTO',     //1
                                                     'CODE_BL',        //2
                                                     'DATEHISTO',      //3
                                                     'BLSCODE',        //4
                                                     'BLSLIB',         //5
                                                     'BLMCODE',        //6
                                                     'BLMLIB',         //7
                                                     'NUMCARTEFIS',    //8
                                                     'DTLIMRETRAIT',   //9
                                                     'BLHETAT');       //10

  BonRapprochement_COL: Array[1..21] of String = ('ID',                           // 1
                                                  'DATE_CREATION',                // 2
                                                  'DATE_FACTURE',                 // 3
                                                  'DATE_ECHEANCE',                // 4
                                                  'MONTANT_FACTURE',              // 5
                                                  'FRAIS_PORT',                   // 6
                                                  'FRAIS_ANNEXES',                // 7
                                                  'CHRONO',                       // 8
                                                  'NUM_FOURN_FACTURE',            // 9
                                                  'ID_FOURN',                     // 10
                                                  'REMISE_GLOBALE',               // 11
                                                  'MONTANT_TVA_REMISE_GLOBALE',   // 12
                                                  'MONTANT_TVA_FRAIS_PORT',       // 13
                                                  'MONTANT_TVA_FRAIS_ANNEXES',    // 14
                                                  'CLOTURE',                      // 15
                                                  'EXPORTE',                      // 16
                                                  'CODE_MAG',                     // 17
                                                  'DATE_EXPORT_COMPTABLE',        // 18
                                                  'COMMENTAIRE',                  // 19
                                                  'ARCHIVE',                      // 20
                                                  'CENTRALE');                    // 21

  BonRapprochementLien_COL: Array[1..3] of String = ('ID_BON',         // 1
                                                     'ID_RECEPTION',   // 2
                                                     'ID_RETOUR');     // 3

  BonRapprochementTVA_COL: Array[1..10] of String = ('ID_BON',                      // 1
                                                     'TAUX_TVA',                    // 2
                                                     'MONTANT_TTC',                 // 3
                                                     'MONTANT_HT',                  // 4
                                                     'MONTANT_BRUT_HT',             // 5
                                                     'MONTANT_REMISE',              // 6
                                                     'MONTANT_NET_TTC',             // 7
                                                     'MONTANT_TVA_FRAIS_PORT',      // 8
                                                     'MONTANT_TVA_FRAIS_ANNEXES',   // 9
                                                     'MONTANT_TVA');                // 10

  BonRapprochementLigneReception_COL: Array[1..5] of String = ('ID_LIGNE_RECEPTION',  // 1
                                                               'CODE_ART',            // 2
                                                               'CODE_TAILLE',         // 3
                                                               'CODE_COUL',           // 4
                                                               'ID_BON');             // 5

  BonRapprochementLigneRetour_COL: Array[1..5] of String = ('NUM_BON_RETOUR',   // 1
                                                            'CODE_ART',         // 2
                                                            'CODE_TAILLE',      // 3
                                                            'CODE_COUL',        // 4
                                                            'ID_BON');          // 5

  SavTauxH_COL: Array[1..4] of String =  ('ID',           // 1
                                          'NOM',          // 2
                                          'PRIX',         // 3
                                          'CENTRALE');    // 4

  SavForfait_COL: Array[1..5] of String =    ('ID',           // 1
                                              'NOM',          // 2
                                              'PRIX',         // 3
                                              'DUREE',        // 4
                                              'CENTRALE');    // 5

  SavForfaitL_COL: Array[1..6] of String =   ('ID',       // 1
                                              'FORID',    // 2
                                              'ARTID',    // 3
                                              'TGFID',    // 4
                                              'COUID',    // 5
                                              'QTE');     // 6

  SavPt1_COL: Array[1..5] of String =    ('ID',           // 1
                                          'PICTO',        // 2
                                          'ORDREAFF',     // 3
                                          'NOM',          // 4
                                          'CENTRALE');    // 5

  SavPt2_COL: Array[1..12] of String =   ('ID',           // 1
                                          'PT1ID',        // 2
                                          'NOM',          // 3
                                          'FORFAIT',      // 4
                                          'FORID',        // 5
                                          'DUREE',        // 6
                                          'PICTO',        // 7
                                          'TXHID',        // 8
                                          'ARTID',        // 9
                                          'ORDREAFF',     // 10
                                          'LIBELLE',      // 11
                                          'CENTRALE');    // 12

  SavTypMat_COL: Array[1..2] of String = ('ID',       // 1
                                          'NOM');     // 2

  SavType_COL: Array[1..2] of String =   ('ID',       // 1
                                          'NOM');     // 2

  SavMat_COL: Array[1..15] of String =   ('ID',           // 1
                                          'CLTID',        // 2
                                          'TYMID',        // 3
                                          'MRKID',        // 4
                                          'ARTID',        // 5
                                          'NOM',          // 6
                                          'SERIE',        // 7
                                          'COULEUR',      // 8
                                          'COMMENT',      // 9
                                          'DATEACHAT',    // 10
                                          'REFMRK',       // 11
                                          'ASSUR',        // 12
                                          'CHRONO',       // 13
                                          'OLDCHRONO',    // 14
                                          'ARLID');       // 15

  SavCb_COL: Array[1..3] of String = ('ID',       // 1
                                      'MATID',    // 2
                                      'CB');      // 3

  SavFichee_COL: Array[1..27] of String =    ('ID',               // 1
                                              'CLTID',            // 2
                                              'MATID',            // 3
                                              'CHRONO',           // 4
                                              'DTCREATION',       // 5
                                              'DEBUT',            // 6
                                              'FIN',              // 7
                                              'REMMO',            // 8
                                              'REMART',           // 9
                                              'REM',              // 10
                                              'IDENT',            // 11
                                              'USRID',            // 12
                                              'LIMITE',           // 13
                                              'CODE_MAG',         // 14
                                              'ETAT',             // 15
                                              'DATEREPRISE',      // 16
                                              'STYID',            // 17
                                              'DATEPLANNING',     // 18
                                              'COMMENT',          // 19
                                              'ORDREAFF',         // 20
                                              'DUREEGLOB',        // 21
                                              'DUREE',            // 22
                                              'TXHID',            // 23
                                              'PXTAUX',           // 24
                                              'TKEID',            // 25
                                              'NEUF',             // 26
                                              'PLACE');           // 27

  SavFicheL_COL: Array[1..12] of String =    ('ID',           // 1
                                              'SAVID',        // 2
                                              'PT2ID',        // 3
                                              'FORID',        // 4
                                              'NOM',          // 5
                                              'COMMENT',      // 6
                                              'DUREE',        // 7
                                              'TXHID',        // 8
                                              'REMISE',       // 9
                                              'PXTOT',        // 10
                                              'TERMINE',      // 11
                                              'PXBRUT');      // 12

  SavFicheArt_COL: Array[1..11] of String =  ('ID',       // 1
                                              'ARTID',    // 2
                                              'TGFID',    // 3
                                              'COUID',    // 4
                                              'SAVID',    // 5
                                              'SALID',    // 6
                                              'PU',       // 7
                                              'REMISE',   // 8
                                              'QTE',      // 9
                                              'PXTOT',    // 10
                                              'TYPID');   // 11
implementation

end.

