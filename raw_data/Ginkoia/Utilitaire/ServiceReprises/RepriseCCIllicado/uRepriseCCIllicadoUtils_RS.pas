unit uRepriseCCIllicadoUtils_RS;

interface

resourcestring

RS_RepriseAvecErreur = 'La reprise de la carte cadeau Illicado %s a renvoyé l''erreur %s : ' + #13#10 + '%s' + #13#10 + #13#10 + 'Veuillez contacter Ginkoia' + #13#10
+ 'Magasin : %s' + #13#10
+ 'Session : %s' + #13#10
+ 'Ticket : %s' + #13#10 + #13#10;

RS_RepriseEchec = 'La reprise de la carte cadeau Illicado %s n''a pas pu être faite dans le délai requis. ' + #13#10
+ 'Magasin : %s' + #13#10
+ 'Session : %s' + #13#10
+ 'Ticket : %s' + #13#10 + #13#10
+ 'Veuillez la traiter manuellement dans votre back office Illicado, puis dans Ginkoia, dans la liste des cartes cadeau, veuillez indiquer que le problème est "traité". ' + #13#10
+ '(Si vous n''effectuez pas l''opération dans la liste des cartes cadeau de Ginkoia, un nouveau mail vous sera renvoyé)';

RS_RepriseKO = 'La reprise de la carte cadeau Illicado %s ne peut pas être faite car elle n''est pas liée à un ticket. ' + #13#10
+ 'Veuillez la traiter manuellement dans votre back office Illicado, puis dans Ginkoia, dans la liste des cartes cadeau, veuillez indiquer que le problème est "traité". ' + #13#10
+ '(Si vous n''effectuez pas l''opération dans la liste des cartes cadeau de Ginkoia, un nouveau mail vous sera renvoyé)';

RS_EmailSubject = 'Erreur Service de reprise des cartes cadeaux Illicado';

implementation

end.
