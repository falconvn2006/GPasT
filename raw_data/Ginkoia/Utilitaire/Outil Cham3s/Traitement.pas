unit Traitement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

  //Procedure général
  Function GetFournisseur(ARTID : integer): string;
  Function VerifCodeBarre(CBI_CB: string) : Boolean;
  Procedure GetNomenclature(ARTID :integer);
  Function FiltreArtWeb(ARTID :integer) : Boolean;

  //procedure pour page controle analyse article web
  procedure RempliAnalyseArtWeb;
  procedure RempliAnalyseArtWebTailleCouleur(ARTID : Integer);
  Function VerifSiteOk(ARTID : integer) : Boolean;
  function VerifSynchroMarque(MRKID : integer)    : Boolean;
  function VerifNomenclatureRen(ARTID : integer)   : Boolean;
  function VerifNomenClatureSync(ARTID : integer)  : Boolean;
  function VerifCouleurStatSync(ARTID : integer; COUID : integer) : Boolean;
  Function VerifTailleCouleurCB(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;
  Function VerifCbFournUnique(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;
  Function VerifFournOk(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;

  //procedure pour page Controle pour les code-barres en doubles
  procedure RempliAnalyseArtCodeBarreDouble;
  Procedure RempliLigneArtCodeBarreDouble(ARTID : integer; TGFID : integer; COUID : integer);

  //Procedure pour la page Controle pour les articles non-dispo
  procedure RempliAnalyseArtNonDispo;

  //procedure pour la page controle qui les codes barres sur plusieurs articles
  procedure RempliListeCodeBarre;
  procedure RempliListeArtCodeBarre(CBICB : string);

implementation

uses
  Main_Frm,
  Main_Dm;

Function VerifCodeBarre(CBI_CB: string) : Boolean;
var
  CodeBarre : string;
begin
  //Procedure qui vérifie qu'un code barre fournisseur est ok
  Result    := True;
  CodeBarre := Copy(CBI_CB,0,1);

  if CodeBarre = '2' then
  begin
    Result := False;
    CodeBarre := Copy(CBI_CB,0,4);

    if CodeBarre = '20000' then
    begin
      Result := True;
    end;
  end;

end;


Function VerifSiteOk(ARTID : integer) : Boolean;
begin
  //procedure qui vérifie le site de mise en ligne
  with Dm_Main do
  begin
    Que_SiteMiseLigneOk.Close;
    Que_SiteMiseLigneOk.ParamByName('ARTID').AsInteger := ARTID;
    Que_SiteMiseLigneOk.Open;

    if Que_SiteMiseLigneOk.FieldByName('ASS_ID').AsInteger = 0 then
    begin
      Result := False;
    end else
    begin
      result := True;
    end;
  end;
end;

procedure RempliAnalyseArtWeb; //Procedure qui rempli le MemDataAnalyseArtWeb
begin
  with Dm_Main do
  begin

    //je rempli le MemData
    try
      MemD_AnalyseArtWeb.Close;
      MemD_AnalyseArtWeb.DisableControls;
      Que_AnalyseArtWeb.Close;
      Que_AnalyseArtWeb.Open;
      MemD_AnalyseArtWeb.Open;
      Que_AnalyseArtWeb.First;

      while not Que_AnalyseArtWeb.Eof do
      begin
        MemD_AnalyseArtWeb.Append;
        //je le rempli
        MemD_AnalyseArtWebARF_CHRONO.AsString := Que_AnalyseArtWeb.FieldByName('ARF_CHRONO').AsString;
        MemD_AnalyseArtWebART_NOM.AsString    := Que_AnalyseArtWeb.FieldByName('ART_NOM').AsString;
        MemD_AnalyseArtWebMRK_NOM.AsString    := Que_AnalyseArtWeb.FieldByName('MRK_NOM').AsString;
        MemD_AnalyseArtWebMRK_IDREF.AsInteger := Que_AnalyseArtWeb.FieldByName('MRK_IDREF').AsInteger;
        MemD_AnalyseArtWebART_ID.AsInteger    := Que_AnalyseArtWeb.FieldByName('ART_ID').AsInteger;
        MemD_AnalyseArtWebMRK_ID.AsInteger    := Que_AnalyseArtWeb.FieldByName('MRK_ID').AsInteger;
        MemD_AnalyseArtWeb.Post;
        Que_AnalyseArtWeb.Next;
      end;
    finally
      MemD_AnalyseArtWeb.EnableControls;
      //je me positionne sur le 1er element
      MemD_AnalyseArtWeb.First;
    end;
  end;
end;

procedure RempliAnalyseArtWebTailleCouleur(ARTID : Integer);
begin
  with Dm_Main do
  begin
    try
      //on efface le memData
      MemD_TailleCouleurAnalyseArtWeb.Close;

      MemD_TailleCouleurAnalyseArtWeb.DisableControls;
      Que_TailleCouleurArtWeb.Close;
      Que_TailleCouleurArtWeb.ParamByName('ARTID').AsInteger := ARTID;
      Que_TailleCouleurArtWeb.Open;
      MemD_TailleCouleurAnalyseArtWeb.Open;
      Que_TailleCouleurArtWeb.First;

      while not Que_TailleCouleurArtWeb.Eof do
      begin
        MemD_TailleCouleurAnalyseArtWeb.Append;
        MemD_TailleCouleurAnalyseArtWebCBI_CB.AsString  := Que_TailleCouleurArtWeb.FieldByName('CBI_CB').AsString;
        MemD_TailleCouleurAnalyseArtWebTGF_NOM.AsString := Que_TailleCouleurArtWeb.FieldByName('TGF_NOM').AsString;
        MemD_TailleCouleurAnalyseArtWebCOU_NOM.AsString := Que_TailleCouleurArtWeb.FieldByName('COU_NOM').AsString;
        MemD_TailleCouleurAnalyseArtWebGCS_NOM.AsString := Que_TailleCouleurArtWeb.FieldByName('GCS_NOM').AsString;
        MemD_TailleCouleurAnalyseArtWebCOU_ID.AsInteger := Que_TailleCouleurArtWeb.FieldByName('COU_ID').AsInteger;
        MemD_TailleCouleurAnalyseArtWebTGF_ID.AsInteger := Que_TailleCouleurArtWeb.FieldByName('TGF_ID').AsInteger;
        MemD_TailleCouleurAnalyseArtWeb.Post;
        Que_TailleCouleurArtWeb.Next;
      end;

    finally
      MemD_TailleCouleurAnalyseArtWeb.EnableControls;
    end;
  end;
end;

function VerifSynchroMarque(MRKID : integer) : Boolean;
begin
  //procedure qui verifie la synchro de la marque
  with Dm_Main do
  begin
    Que_SynchroMarque.Close;
    Que_SynchroMarque.ParamByName('MRK_ID').AsInteger := MRKID;
    Que_SynchroMarque.Open;

    Que_SynchroMarque.First;

    if Que_SynchroMarque.FieldByName('IMP_ID').AsInteger = 0 then
    begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

function VerifNomenClatureSync(ARTID : integer): Boolean;
begin
  //procedure qui verifie que la nomenclature est bien synchronisé
  with Dm_Main do
  begin
    Que_NomenclatureSync.Close;
    Que_NomenclatureSync.ParamByName('ARTID').AsInteger := ARTID;
    Que_NomenclatureSync.Open;

    if Que_NomenclatureSync.FieldByName('IMP_ID').AsInteger = 0 then
     begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

function VerifNomenclatureRen(ARTID : integer) : Boolean;
begin
  //procedure qui verifie si la nomenclature est renseigné
  with Dm_Main do
  begin
    Que_NomenclatureRen.Close;
    Que_NomenclatureRen.ParamByName('ARTID').AsInteger := ARTID;
    Que_NomenclatureRen.Open;

    if Que_NomenclatureRen.FieldByName('ARW_SSFID').AsInteger = 0 then
    begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

function VerifCouleurStatSync(ARTID : integer; COUID : integer) : Boolean;
begin
  //procedure qui vérifie que la couleur statistique soit synchrnonisé
  with Dm_Main do
  begin
    Que_CouleurStatSync.Close;
    Que_CouleurStatSync.ParamByName('ARTID').AsInteger := ARTID;
    Que_CouleurStatSync.ParamByName('COUID').AsInteger := COUID;
    Que_CouleurStatSync.Open;

    if Que_CouleurStatSync.FieldByName('IMP_ID').AsInteger = 0 then
    begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

Function VerifTailleCouleurCB(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;
begin
  //procedure qui vérifie que la taille / couleur n'a qu'un seul code-barre
  with Dm_Main do
  begin
    Que_TailleCouleurCB.Close;
    Que_TailleCouleurCB.ParamByName('ARTID').AsInteger := ARTID;
    Que_TailleCouleurCB.ParamByName('COUID').AsInteger := COUID;
    Que_TailleCouleurCB.ParamByName('TGFID').AsInteger := TGFID;
    Que_TailleCouleurCB.Open;

    if Que_TailleCouleurCB.FieldByName('CBI_NUMBER').AsInteger > 1 then
    begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

Function VerifCbFournUnique(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;
begin
  //procedure qui vérifie que pour une taille couleur qu'il y est qu'un seul code barre fournisseur
  with Dm_Main do
  begin
    Que_CbFournUnique.Close;
    Que_CbFournUnique.ParamByName('ARTID').AsInteger := ARTID;
    Que_CbFournUnique.ParamByName('COUID').AsInteger := COUID;
    Que_CbFournUnique.ParamByName('TGFID').AsInteger := TGFID;
    Que_CbFournUnique.Open;

    if Que_CbFournUnique.FieldByName('CBI_NUMBER').AsInteger > 1 then
    begin
      Result := false;
    end else
    begin
      result := True;
    end;
  end;
end;

Function VerifFournOk(ARTID : integer; COUID : integer; TGFID : integer) : Boolean;
Var
  CodeBarre : string;
begin
  //procedure qui vérifie si le code barre fournisseur est ok.
  CodeBarre := '';
  Result    := True;

  with Dm_Main do
  begin
    Que_CbFournOk.Close;
    Que_CbFournOk.ParamByName('ARTID').AsInteger := ARTID;
    Que_CbFournOk.ParamByName('COUID').AsInteger := COUID;
    Que_CbFournOk.ParamByName('TGFID').AsInteger := TGFID;
    Que_CbFournOk.Open;

    CodeBarre := Que_CbFournOk.FieldByName('CBI_CB').AsString;
    CodeBarre := Copy(CodeBarre,0,1);

    if CodeBarre = '2' then
    begin
      Result    := False;
      //je test si sa commence par 20000
      CodeBarre := Que_CbFournOk.FieldByName('CBI_CB').AsString;
      CodeBarre := Copy(CodeBarre,0,5);

      if CodeBarre = '20000' then
      begin
        Result := True;
      end;
    end;

  end;
end;

procedure RempliAnalyseArtCodeBarreDouble;
begin
  //procedure qui rempli la cxGrid qui liste les articles ayant plusieurs codes barres fournisseur sur une meme taille/couleur
  with Dm_Main do
  begin
    try
      MemD_AnalyseArtCodeBarre.Close;
      MemD_AnalyseArtCodeBarre.DisableControls;
      Que_AnalyseArtCodeBarre.Close;
      Que_AnalyseArtCodeBarre.Open;
      MemD_AnalyseArtCodeBarre.Open;
      Que_AnalyseArtCodeBarre.First;

      while not Que_AnalyseArtCodeBarre.Eof do
      begin
          MemD_AnalyseArtCodeBarre.Append;
          //je rempli le memd_data
          MemD_AnalyseArtCodeBarreART_ID.AsInteger     :=  Que_AnalyseArtCodeBarre.FieldByName('ART_ID').AsInteger;
          MemD_AnalyseArtCodeBarreARF_CHRONO.AsString  :=  Que_AnalyseArtCodeBarre.FieldByName('ARF_CHRONO').AsString;
          MemD_AnalyseArtCodeBarreART_NOM.AsString     :=  Que_AnalyseArtCodeBarre.FieldByName('ART_NOM').AsString;
          MemD_AnalyseArtCodeBarreMRK_IDREF.AsInteger  :=  Que_AnalyseArtCodeBarre.FieldByName('MRK_IDREF').AsInteger;
          MemD_AnalyseArtCodeBarreMRK_NOM.AsString     :=  Que_AnalyseArtCodeBarre.FieldByName('MRK_NOM').AsString;
          MemD_AnalyseArtCodeBarreTGF_NOM.AsString     :=  Que_AnalyseArtCodeBarre.FieldByName('TGF_NOM').AsString;
          MemD_AnalyseArtCodeBarreCOU_NOM.AsString     :=  Que_AnalyseArtCodeBarre.FieldByName('COU_NOM').AsString;
          MemD_AnalyseArtCodeBarreTGF_ID.AsInteger     :=  Que_AnalyseArtCodeBarre.FieldByName('TGF_ID').AsInteger;
          MemD_AnalyseArtCodeBarreCOU_ID.AsInteger     :=  Que_AnalyseArtCodeBarre.FieldByName('COU_ID').AsInteger;
          MemD_AnalyseArtCodeBarre.Post;
        Que_AnalyseArtCodeBarre.Next;
      end;
    finally
      MemD_AnalyseArtCodeBarre.EnableControls;
    end;
  end;
end;

Procedure RempliLigneArtCodeBarreDouble(ARTID : integer; TGFID : integer; COUID : integer);
begin
  //Procedure pour un article taille couleur renvoie les codes barres qui y sont associés
  with Dm_Main do
  begin
    MemD_LigneArtCodeBarre.Close;
    Que_LigneArtCodeBarre.Close;
    Que_LigneArtCodeBarre.ParamByName('ARTID').AsInteger := ARTID;
    Que_LigneArtCodeBarre.ParamByName('TGFID').AsInteger := TGFID;
    Que_LigneArtCodeBarre.ParamByName('COUID').AsInteger := COUID;
    Que_LigneArtCodeBarre.Open;
    MemD_LigneArtCodeBarre.Open;

    Que_LigneArtCodeBarre.First;

    while not Que_LigneArtCodeBarre.Eof do
    begin
      MemD_LigneArtCodeBarre.Append;
      MemD_LigneArtCodeBarreCBI_CB.AsString := Que_LigneArtCodeBarre.FieldByName('CBI_CB').AsString;
      MemD_LigneArtCodeBarre.Post;
      Que_LigneArtCodeBarre.Next;
    end;

  end;
end;

Function GetFournisseur(ARTID : integer): string;
begin
  //procedure qui prend en parametre un artid et renvoie le fournisseur de l'article
  with Dm_Main do
  begin
    Que_GetFournisseur.Close;
    Que_GetFournisseur.ParamByName('ARTID').AsInteger := ARTID;
    Que_GetFournisseur.Open;

    Result := Que_GetFournisseur.FieldByName('FOU_NOM').AsString;
  end;
end;

procedure RempliAnalyseArtNonDispo;
begin
  //procedure  qui rempli le memData avec les articles taille/couleur qui n'ont plus de dispo sur le web
  with Dm_Main do
  begin
    try
      MemD_AnalyseArtDispoWeb.Close;
      MemD_AnalyseArtDispoWeb.DisableControls;
      Que_AnalyseArtDispoWeb.Close;
      Que_AnalyseArtDispoWeb.Open;
      MemD_AnalyseArtDispoWeb.Open;
      Que_AnalyseArtDispoWeb.First;

      while not Que_AnalyseArtDispoWeb.Eof do
      begin
        //je rempli le memData
        MemD_AnalyseArtDispoWeb.Append;
        MemD_AnalyseArtDispoWebARF_CHRONO.AsString :=  Que_AnalyseArtDispoWeb.FieldByName('ARF_CHRONO').AsString;
        MemD_AnalyseArtDispoWebART_NOM.AsString    :=  Que_AnalyseArtDispoWeb.FieldByName('ART_NOM').AsString;
        MemD_AnalyseArtDispoWebMRK_IDREF.AsInteger :=  Que_AnalyseArtDispoWeb.FieldByName('MRK_IDREF').AsInteger;
        MemD_AnalyseArtDispoWebMRK_NOM.AsString    :=  Que_AnalyseArtDispoWeb.FieldByName('MRK_NOM').AsString;
        MemD_AnalyseArtDispoWebTGF_NOM.AsString    :=  Que_AnalyseArtDispoWeb.FieldByName('TGF_NOM').AsString;
        MemD_AnalyseArtDispoWebCOU_NOM.AsString    :=  Que_AnalyseArtDispoWeb.FieldByName('COU_NOM').AsString;
        MemD_AnalyseArtDispoWeb.Post;
        Que_AnalyseArtDispoWeb.Next;
      end;
    finally
      MemD_AnalyseArtDispoWeb.EnableControls;
    end;
  end;
end;

procedure RempliListeCodeBarre;
begin
  //Liste les codes barres
  with Dm_Main do
  begin
    try
      MemD_CodeBarreDouble.Close;
      MemD_CodeBarreDouble.DisableControls;
      Que_AnalyseCodeBarreDouble.Close;
      Que_AnalyseCodeBarreDouble.Open;
      MemD_CodeBarreDouble.Open;
      Que_AnalyseCodeBarreDouble.First;

      while not Que_AnalyseCodeBarreDouble.Eof do
      begin
        //je test le code barre est ok avant
        if VerifCodeBarre(Que_AnalyseCodeBarreDouble.FieldByName('CBI_CB').AsString) = True then
        begin
          MemD_CodeBarreDouble.Append;
          MemD_CodeBarreDoubleCBI_CB.AsString := Que_AnalyseCodeBarreDouble.FieldByName('CBI_CB').AsString;
          MemD_CodeBarreDouble.Post;
        end;
        Que_AnalyseCodeBarreDouble.Next;
      end;
    finally
      MemD_CodeBarreDouble.EnableControls;
    end;
  end;
end;

procedure RempliListeArtCodeBarre(CBICB : string);
begin
  //procedure qui liste pour un code barre la liste des articles associer si il y a plus d'une assocaition
  with Dm_Main do
  begin
    try
      MemD_AnalyseCodeBarreDoubleArt.Close;
      MemD_AnalyseCodeBarreDoubleArt.DisableControls;
      Que_AnalyseCodeBareArt.Close;
      Que_AnalyseCodeBareArt.ParamByName('CBICB').AsString := CBICB;
      Que_AnalyseCodeBareArt.Open;
      MemD_AnalyseCodeBarreDoubleArt.Open;
      Que_AnalyseCodeBareArt.First;

      while not Que_AnalyseCodeBareArt.Eof do
      begin
        MemD_AnalyseCodeBarreDoubleArt.Append;
        MemD_AnalyseCodeBarreDoubleArtARF_CHRONO.AsString := Que_AnalyseCodeBareArt.FieldByName('ARF_CHRONO').AsString;
        MemD_AnalyseCodeBarreDoubleArtART_NOM.AsString    := Que_AnalyseCodeBareArt.FieldByName('ART_NOM').AsString;
        MemD_AnalyseCodeBarreDoubleArtMRK_NOM.AsString    := Que_AnalyseCodeBareArt.FieldByName('MRK_NOm').AsString;
        MemD_AnalyseCodeBarreDoubleArtMRK_IDREF.AsInteger := Que_AnalyseCodeBareArt.FieldByName('MRK_IDREF').AsInteger;
        MemD_AnalyseCodeBarreDoubleArtTGF_NOM.AsString    := Que_AnalyseCodeBareArt.FieldByName('TGF_NOM').AsString;
        MemD_AnalyseCodeBarreDoubleArtCOU_NOM.AsString    := Que_AnalyseCodeBareArt.FieldByName('COU_NOM').AsString;
        MemD_AnalyseCodeBarreDoubleArt.Post;
        Que_AnalyseCodeBareArt.Next;
      end;
    finally
      MemD_AnalyseCodeBarreDoubleArt.EnableControls;
    end;
  end;
end;

procedure GetNomenclature(ARTID : integer);
begin
  //procedure qui renvoie la nomenclature ginkoia pour un article
  with Dm_Main do
  begin
    try
      MemD_GetNomenclature.Close;
      MemD_GetNomenclature.Open;
      Que_GetNomenclature.Close;
      Que_GetNomenclature.ParamByName('ARTID').AsInteger := ARTID;
      Que_GetNomenclature.Open;
      MemD_GetNomenclature.Append;
      MemD_GetNomenclatureSSF_NOM.AsString := Que_GetNomenclature.FieldByName('SSF_NOM').AsString;
      MemD_GetNomenclatureFAM_NOM.AsString := Que_GetNomenclature.FieldByName('FAM_NOM').AsString;
      MemD_GetNomenclatureRAY_NOM.AsString := Que_GetNomenclature.FieldByName('RAY_NOM').AsString;
      MemD_GetNomenclature.Post;
    finally

    end;
  end;
end;

Function FiltreArtWeb(ARTID :integer) : Boolean;
Var
  ValeurTest : array[0..7] of Boolean;
  i          : Integer;
  AfficheArt : Boolean;
begin
  //procedure utiliser dans le filtre des articles web pour savoir si ils doivent être afficher ou pas
  with Dm_Main do
  begin
    i          := 0;
    Result     := False;
    AfficheArt := False;

    Que_FiltreArtWeb.DisableControls;
    Que_FiltreArtWeb.Close;
    Que_FiltreArtWeb.ParamByName('ARTID').AsInteger := ARTID;
    Que_FiltreArtWeb.Open;
    Que_FiltreArtWeb.First;

    while not Que_FiltreArtWeb.Eof do
    begin

//      For i:=0 to 7 do
//      begin
//        ValeurTest[i] := false;
//      end;

      //pour un articles taille couleur je lance l'ensemble des vérifications
      ValeurTest[0] := VerifSiteOk(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger);
      ValeurTest[1] := VerifSynchroMarque(Que_FiltreArtWeb.FieldByName('MRK_ID').AsInteger);
      ValeurTest[2] := VerifNomenclatureRen(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger);
      ValeurTest[3] := VerifNomenClatureSync(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger);

      ValeurTest[4] := VerifCouleurStatSync(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger,Que_FiltreArtWeb.FieldByName('COU_ID').AsInteger);
      ValeurTest[5] := VerifTailleCouleurCB(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger,Que_FiltreArtWeb.FieldByName('COU_ID').AsInteger,Que_FiltreArtWeb.FieldByName('TGF_ID').AsInteger);
      ValeurTest[6] := VerifCbFournUnique(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger,Que_FiltreArtWeb.FieldByName('COU_ID').AsInteger,Que_FiltreArtWeb.FieldByName('TGF_ID').AsInteger);
      ValeurTest[7] := VerifFournOk(Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger,Que_FiltreArtWeb.FieldByName('COU_ID').AsInteger,Que_FiltreArtWeb.FieldByName('TGF_ID').AsInteger);

      if not (
          ValeurTest[0] and ValeurTest[1] and ValeurTest[2] and
          ValeurTest[3] and ValeurTest[4] and ValeurTest[5] and
          ValeurTest[6] and ValeurTest[7])
       then
        begin
          MemD_FiltreArtweb.Append;
          MemD_FiltreArtwebARF_CHRONO.AsString := Que_FiltreArtWeb.FieldByName('ARF_CHRONO').AsString;
          MemD_FiltreArtwebART_NOM.AsString    := Que_FiltreArtWeb.FieldByName('ART_NOM').AsString;
          MemD_FiltreArtwebMRK_NOM.AsString    := Que_FiltreArtWeb.FieldByName('MRK_NOM').AsString;
          MemD_FiltreArtwebMRK_IDREF.AsInteger := Que_FiltreArtWeb.FieldByName('MRK_IDREF').AsInteger;
          MemD_FiltreArtwebART_ID.AsInteger    := Que_FiltreArtWeb.FieldByName('ART_ID').AsInteger;
          MemD_FiltreArtwebMRK_ID.AsInteger    := Que_FiltreArtWeb.FieldByName('MRK_ID').AsInteger;
          MemD_FiltreArtweb.Post;
          Result :=  True;
          Exit;
        end;
      Que_FiltreArtWeb.Next;
    end;
    Que_FiltreArtWeb.EnableControls;

  end;
end;

end.
