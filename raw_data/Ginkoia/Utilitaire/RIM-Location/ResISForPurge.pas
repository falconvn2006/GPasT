unit ResISForPurge;

interface

uses Windows, Sysutils, Classes ;

type TFichierIS = Record
  Client : Record
    Nom        : String;
    Prenom     : String;
    Adresse    : String;
    CodePostal : String;
    Ville      : String;
    Pays       : String;
    Telephone  : String;
    Fax        : String;
    Email      : String;
  end;

  Reservation : record
    LangueResa   : String;
    IdPointVente : String;
    DebutResa    : TDateTime;
    FinResa      : TDateTime;
    TypeResa     : String;
    NomTO        : String;
    Acompte      : single;
    RemiseMag    : single;
    RemisePart   : single;
    TotalCmd     : single;
    NumCmd       : String;
  end;

  Participant :  array of record
    Prenom     : String;
    Poids      : String;
    Taille     : String;
    Age        : String;
    Pointure   : String;
    Sexe       : String;
    IdProduit  : String;
    NomProduit : String;
    Chaussures : String;
    Prix       : Single;
    Casque     : String;
    Duree      : String;
  end;
  bTraiter     : Boolean;
end ;  


  // Permet d'extraire les données du fichier et de les mettre dans la structure TFichierIS
  // bArchiv permet d'eviter d'avoir un message d'erreur sur le traitement des fichiers en cas d'erreur sur ceux ci
 // function ExtractDataFromFile(MaCentrale : TGENTYPEMAIL;sFileName :String;bArchiv : Boolean = False) : TFichierIS;


implementation


(*
  function ExtractDataFromFile(MaCentrale : TGENTYPEMAIL;sFileName :String;bArchiv : Boolean) : TFichierIS;
  var
    lst : TStringList;
    i : integer;
  begin
    lst := TStringList.Create;
    try
      // Récupération du fichier
      lst.LoadFromFile(GPATHMAILTMP + sFileName);
      // suppression des caractères spéciaux et blanc devant et derriere le texte
      lst.Text := Trim(lst.Text);
      // Découpage des données
      lst.Text := StringReplace(lst.Text, ';', #13#10,[rfReplaceAll]);
      try
        With Result.Client do
        begin
          Nom        := lst[0];
          Prenom     := lst[1];
          Adresse    := lst[2];
          CodePostal := lst[3];
          Ville      := lst[4];
          Pays       := lst[5];
          Telephone  := lst[6];
          Fax        := lst[7];
          Email      := lst[8];
        end;
  
        With Result.Reservation do
        begin
          NumCmd       := lst[19]; // mis en premier au cas ou les convertions se passe mal pour avoir le numéro de la réservation
          LangueResa   := lst[9];
          IdPointVente := lst[10];
          DebutResa    := StrToDate(lst[11]);
          FinResa      := StrToDate(lst[12]);
          TypeResa     := lst[13];
          NomTO        := lst[14];
          Acompte      := StrToFloatDef(lst[15],StrToFloat(StringReplace(lst[15],',','.',[rfReplaceAll])));
          RemiseMag    := StrToFloatDef(lst[16],StrToFloat(StringReplace(lst[16],',','.',[rfReplaceAll])));
          RemisePart   := StrToFloatDef(lst[17],StrToFloat(StringReplace(lst[17],',','.',[rfReplaceAll])));
          TotalCmd     := StrToFloatDef(lst[18],StrToFloat(StringReplace(lst[18],',','.',[rfReplaceAll])));
        end;
  
  (*     ne sert pas pour l'archivage
          i := 20;
          // remise à 0 de la taille du tableau.
          SetLength(Result.Participant,0);
          while (i + 12) < lst.Count do
          begin
            if StrToIntDef(lst[i+6],10000) < 10000 then
            begin
              // Augmentation de la taille du tableau
              SetLength(Result.Participant,Length(Result.Participant) + 1);
              With Result.Participant[Length(Result.Participant) -1] do
              begin
                Prenom     := lst[i];
                Poids      := lst[i+1];
                Taille     := lst[i+2];
                Age        := lst[i+3];
                Pointure   := lst[i+4];
                Sexe       := lst[i+5];
                IdProduit  := lst[i+6];
                NomProduit := lst[i+7];
                Chaussures := lst[i+8];
                Prix       := StrToFloatDef(lst[i+9],StrToFloat(StringReplace(lst[i+9],',','.',[rfReplaceAll])));;
                Casque     := lst[i+10];
                Duree      := lst[i+11];
              end; // with
            end;// if
            i := i + 12;
          end; // while
          Result.bTraiter := True;
      
  *)
   (*   Except on E:Exception do
        begin
          Result.bTraiter := False;                    
        end;
      end;
    finally
      lst.Free;
    end;
  end;
    
*)
end.
