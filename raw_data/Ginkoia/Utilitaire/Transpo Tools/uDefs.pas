unit uDefs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

var
  PA00nnn_SERVICE_COL : array[1..3] of string = ( 'CLE',              //1
                                                  'NUMERO',           //2
                                                  'LIBELLE_SERVICE'); //3

  PA00nnn_SERIE_COL : array[1..3] of string = ( 'CLE',            //1
                                                'NUMERO',         //2
                                                'LIBELLE_SERIE'); //3

  PA00nnn_SAISON_COL : array[1..5] of string = ('CLE',                    //1
                                                'NUMERO',                 //2
                                                'LIBELLE_LONG_SAISON',    //3
                                                'LIBELLE_COURT_SAISON',   //4
                                                'DOSSIER_PHOTO_SAISON');  //5

  PA00nnn_FAMILLE_COL : array[1..4] of string = ( 'CLE',            //1
                                                  'NUMERO',         //2
                                                  'LIBELLE_LONG',   //3
                                                  'LIBELLE_COURT'); //4

  PA00nnn_COULEUR_COL : array[1..3] of string = ( 'CLE',              //1
                                                  'NUMERO',           //2
                                                  'LIBELLE_COULEUR'); //3

  PA00nnn_ECHELLE_COL : array[1..64] of string = ('CLE',                    //1
                                                  'NUMERO',                 //2
                                                  'LIBELLE_ECHELLE',        //3
                                                  'CODE_TAILLE1',           //4
                                                  'CODE_TAILLE2',           //5
                                                  'CODE_TAILLE3',           //6
                                                  'CODE_TAILLE4',           //7
                                                  'CODE_TAILLE5',           //8
                                                  'CODE_TAILLE6',           //9
                                                  'CODE_TAILLE7',           //10
                                                  'CODE_TAILLE8',           //11
                                                  'CODE_TAILLE9',           //12
                                                  'CODE_TAILLE10',          //13
                                                  'CODE_TAILLE11',          //14
                                                  'CODE_TAILLE12',          //15
                                                  'CODE_TAILLE13',          //16
                                                  'CODE_TAILLE14',          //17
                                                  'CODE_TAILLE15',          //18
                                                  'CODE_TAILLE16',          //19
                                                  'CODE_TAILLE17',          //20
                                                  'CODE_TAILLE18',          //21
                                                  'CODE_TAILLE19',          //22
                                                  'CODE_TAILLE20',          //23
                                                  'LIBELLE_TAILLE_COURT1',  //24
                                                  'LIBELLE_TAILLE_COURT2',  //25
                                                  'LIBELLE_TAILLE_COURT3',  //26
                                                  'LIBELLE_TAILLE_COURT4',  //27
                                                  'LIBELLE_TAILLE_COURT5',  //28
                                                  'LIBELLE_TAILLE_COURT6',  //29
                                                  'LIBELLE_TAILLE_COURT7',  //30
                                                  'LIBELLE_TAILLE_COURT8',  //31
                                                  'LIBELLE_TAILLE_COURT9',  //32
                                                  'LIBELLE_TAILLE_COURT10', //33
                                                  'LIBELLE_TAILLE_COURT11', //34
                                                  'LIBELLE_TAILLE_COURT12', //35
                                                  'LIBELLE_TAILLE_COURT13', //36
                                                  'LIBELLE_TAILLE_COURT14', //37
                                                  'LIBELLE_TAILLE_COURT15', //38
                                                  'LIBELLE_TAILLE_COURT16', //39
                                                  'LIBELLE_TAILLE_COURT17', //40
                                                  'LIBELLE_TAILLE_COURT18', //41
                                                  'LIBELLE_TAILLE_COURT19', //42
                                                  'LIBELLE_TAILLE_COURT20', //43
                                                  'LIBELLE_TAILLE_LONG1',   //44
                                                  'LIBELLE_TAILLE_LONG2',   //45
                                                  'LIBELLE_TAILLE_LONG3',   //46
                                                  'LIBELLE_TAILLE_LONG4',   //47
                                                  'LIBELLE_TAILLE_LONG5',   //48
                                                  'LIBELLE_TAILLE_LONG6',   //49
                                                  'LIBELLE_TAILLE_LONG7',   //50
                                                  'LIBELLE_TAILLE_LONG8',   //51
                                                  'LIBELLE_TAILLE_LONG9',   //52
                                                  'LIBELLE_TAILLE_LONG10',  //53
                                                  'LIBELLE_TAILLE_LONG11',  //54
                                                  'LIBELLE_TAILLE_LONG13',  //55
                                                  'LIBELLE_TAILLE_LONG14',  //56
                                                  'LIBELLE_TAILLE_LONG15',  //57
                                                  'LIBELLE_TAILLE_LONG16',  //58
                                                  'LIBELLE_TAILLE_LONG17',  //59
                                                  'LIBELLE_TAILLE_LONG18',  //60
                                                  'LIBELLE_TAILLE_LONG19',  //61
                                                  'LIBELLE_TAILLE_LONG20',  //62
                                                  'ASSORTIMENT_DEBUT',      //63
                                                  'ASSORTIMENT_FIN');       //64

  PA00nnn_FOURNISSEUR_COL : array[1..9] of string = ('CLE',            //1
                                                     'NUMERO',         //2
                                                     'NOM',            //3
                                                     'ADRESSE',        //4
                                                     'CODE_POSTAL',    //5
                                                     'VILLE',          //6
                                                     'REPRESENTANT',   //7
                                                     'TELEPHONE',      //8
                                                     'FAX');           //9

  TM00nnn_COL : array[1..102] of string = ( 'REFERENCE',                //1     A
                                            'REF_CODEBARRE',            //2     B
                                            'SERVICE',                  //3     C
                                            'SERIE',                    //4     D
                                            'SAISON',                   //5     E
                                            'FAMILLE',                  //6     F
                                            'DESIGNATION',              //7     G
                                            'GENRE',                    //8     H
                                            'FIRME',                    //9     I
                                            'ECHELLE_DE_TAILLE',        //10    J
                                            'ASSORTIMENT_DEB',          //11    K
                                            'ASSORTIMENT_FIN',          //12    L
                                            'PA1',                      //13    M
                                            'PA2',                      //14    N
                                            'PV1',                      //15    O
                                            'PV2',                      //16    P
                                            'COEFFICIENT',              //17    Q
                                            'COULEUR',                  //18    R
                                            'COLIS',                    //19    S
                                            'NUM_COLIS',                //20    T
                                            'CODE_SUIVI_N-1',           //21    U
                                            'CODE_SUIVI_N+1',           //22    V
                                            'TYPE_SAISON',              //23    W
                                            'NATURE_ARTICLE',           //24    X
                                            'NATURE_DESSUS',            //25    Y
                                            'NATURE_SEMELLE',           //26    Z
                                            'NATURE_DOUBLURE',          //27    AA
                                            'FOURNISSEUR',              //28    AB
                                            'NB_P_COMMANDE_INIT',       //29    AC
                                            'NB_P_COMMANDE_REA',        //30    AD
                                            'NB_P_RECEPTIONNEES',       //31    AE
                                            'NB_P_DEFECTUEUSES',        //32    AF
                                            'NB_P_VOLEES',              //33    AG
                                            'NB_VENTES_HEBDO',          //34    AH
                                            'NB_VENTES_MENSUELLE',      //35    AI
                                            'NB_VENTES_CUMULEES',       //36    AJ
                                            '1ERE_DATE_RECEPTION',      //37    AK
                                            'DATE_DERNIERE_RECEPTION',  //38
                                            'DATE_1ERE_VENTE',          //39
                                            'DATE_DERNIERE_VENTE',      //40
                                            'STOKS1',                   //41
                                            'STOKS2',                   //42
                                            'STOKS3',                   //43
                                            'STOKS4',                   //44
                                            'STOKS5',                   //45
                                            'STOKS6',                   //46
                                            'STOKS7',                   //47
                                            'STOKS8',                   //48
                                            'STOKS9',                   //49
                                            'STOKS10',                  //50
                                            'STOKS11',                  //51
                                            'STOKS12',                  //52
                                            'STOKS13',                  //53
                                            'STOKS14',                  //54
                                            'STOKS15',                  //55
                                            'STOKS16',                  //56
                                            'STOKS17',                  //57
                                            'STOKS18',                  //58
                                            'STOKS19',                  //59
                                            'STOKS20',                  //60
                                            'VENTES1',                  //61
                                            'VENTES2',                  //62
                                            'VENTES3',                  //63
                                            'VENTES4',                  //64
                                            'VENTES5',                  //65
                                            'VENTES6',                  //66
                                            'VENTES7',                  //67
                                            'VENTES8',                  //68
                                            'VENTES9',                  //69
                                            'VENTES10',                 //70
                                            'VENTES11',                 //71
                                            'VENTES12',                 //72
                                            'VENTES13',                 //73
                                            'VENTES14',                 //74
                                            'VENTES15',                 //75
                                            'VENTES16',                 //76
                                            'VENTES17',                 //77
                                            'VENTES18',                 //78
                                            'VENTES19',                 //79
                                            'VENTES20',                 //80
                                            'DISPONIBLE',               //81
                                            'DATE_DISPONIBLE',          //82
                                            'RAL1',                     //83
                                            'RAL2',                     //84
                                            'RAL3',                     //85
                                            'RAL4',                     //86
                                            'RAL5',                     //87
                                            'RAL6',                     //88
                                            'RAL7',                     //89
                                            'RAL8',                     //90
                                            'RAL9',                     //91
                                            'RAL10',                    //92
                                            'RAL11',                    //93
                                            'RAL12',                    //94
                                            'RAL13',                    //95
                                            'RAL14',                    //96
                                            'RAL15',                    //97
                                            'RAL16',                    //98
                                            'RAL17',                    //99
                                            'RAL18',                    //100
                                            'RAL19',                    //101
                                            'RAL20');                   //102

  UMxxnnn_COL : array[1..65] of string = ('REFERENCE', //1
                                          'STOCK1',    //2
                                          'STOCK2',    //3
                                          'STOCK3',    //4
                                          'STOCK4',    //5
                                          'STOCK5',    //6
                                          'STOCK6',    //7
                                          'STOCK7',    //8
                                          'STOCK8',    //9
                                          'STOCK9',    //10
                                          'STOCK10',   //11
                                          'STOCK11',   //12
                                          'STOCK12',   //13
                                          'STOCK13',   //14
                                          'STOCK14',   //15
                                          'STOCK15',   //16
                                          'STOCK16',   //17
                                          'STOCK17',   //18
                                          'STOCK18',   //19
                                          'STOCK19',   //20
                                          'STOCK20',   //21
                                          'VENTE1',    //22
                                          'VENTE2',    //23
                                          'VENTE3',    //24
                                          'VENTE4',    //25
                                          'VENTE5',    //26
                                          'VENTE6',    //27
                                          'VENTE7',    //28
                                          'VENTE8',    //29
                                          'VENTE9',    //30
                                          'VENTE10',   //31
                                          'VENTE11',   //32
                                          'VENTE12',   //33
                                          'VENTE13',   //34
                                          'VENTE14',   //35
                                          'VENTE15',   //36
                                          'VENTE16',   //37
                                          'VENTE17',   //38
                                          'VENTE18',   //39
                                          'VENTE19',   //40
                                          'VENTE20',   //41
                                          'SOLDE',     //42
                                          'GUELTE',    //43
                                          'MAGASIN',   //44
                                          'COULEUR',   //45
                                          'RAL1',      //46
                                          'RAL2',      //47
                                          'RAL3',      //48
                                          'RAL4',      //49
                                          'RAL5',      //50
                                          'RAL6',      //51
                                          'RAL7',      //52
                                          'RAL8',      //53
                                          'RAL9',      //54
                                          'RAL10',     //55
                                          'RAL11',     //56
                                          'RAL12',     //57
                                          'RAL13',     //58
                                          'RAL14',     //59
                                          'RAL15',     //60
                                          'RAL16',     //61
                                          'RAL17',     //62
                                          'RAL18',     //63
                                          'RAL19',     //64
                                          'RAL20');    //65

  BP_ARTICLE_COL : array[1..6] of string = ('IDENT.',                 //1
                                            'CODE_PEDIGREE',          //2
                                            'CODE_COULEUR',           //3
                                            'REFERENCE_FOURNISSEUR',  //4
                                            'STOCK_MINIMUM',          //5
                                            'STOCK_MAXIMUM');         //6

  BP_PEDIGREE_COL : array[1..6] of string = ('CODE_PEDIGREE',                 //1
                                             'ETAT_TECHNIQUE_ENREGISTREMENT', //2
                                             'DESIGNATION_DE_L_ARTICLE',      //3
                                             'TEXTE_LIBRE',                   //4
                                             'PHOTO_DE_L_ARTICLE',            //5
                                             'TYPE_1');                       //6

  BP_PED_PRIX_COL : array[1..9] of string = ('CODE_PEDIGREE',             //1
                                             'IDENTIFIANT_DE_LIB_COLO',   //2
                                             'PX_ACHAT_HT',               //3
                                             'COEF',                      //4
                                             'PX_VENTE_TTC',              //5
                                             'COEF_PROMO',                //6
                                             'PX_VENTE_HT_PROMO',         //7
                                             'COEF_PROF',                 //8
                                             'PX_VENTE_HT_PROF');         //9



  implementation

end.
