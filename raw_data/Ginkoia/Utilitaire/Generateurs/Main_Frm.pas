unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  //debut uses
  //fin uses
  Dialogs, IB_Components, Db, IBODataset;

type
  TFrm_Main = class(TForm)
    Que_ExportGenerator: TIBOQuery;
    Que_NomGenerateur: TIBOQuery;
    Que_NomGenerateurRDBGENERATOR_NAME: TStringField;
    Que_NomGenerateurRDBGENERATOR_ID: TSmallintField;
    Que_NomGenerateurRDBSYSTEM_FLAG: TSmallintField;
    Database: TIB_Connection;
    Que_ImportGenerators: TIB_DSQL;
    Que_BaseIdent: TIBOQuery;
    Que_BaseIdentPAR_STRING: TStringField;
    Que_ExportLDF: TIBOQuery;
    function recupererGenerateurs(strPathBase: string): Boolean;
    function configBase(strPathBaseNb: string): boolean;
    procedure FormCreate(Sender: TObject);
    procedure analyseVariable();
  private
    { Déclarations privées }
    strPathBase: string; //chemin de la base à traiter
    intType: Integer; //le type de travail a effectuer   '0' erreur, '1' Export des générateurs, '2' Import
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.DFM}

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  WriteLn('Generateur Version 3.1.0');
  //enlever le chemin par défaut par précaution
  Database.DatabaseName := '';
  //vérifier les paramètres de la ligne de commandes
  analyseVariable();
  //tester l'existence de la base
  if FileExists(strPathBase) then
  begin
    // se connecter à la base de donnée
    try
      Database.Params.Values['USER NAME'] := 'ginkoia';
      Database.Params.Values['PASSWORD'] := 'ginkoia';
      Database.SQLDialect := 3;
      Database.DatabaseName := strPathBase;
      Database.Open;
    except on e: exception do
      begin
        Application.Terminate;
        WriteLn('Erreur :' + e.message);
      end
    end;
  end
  else //tester s'il faut afficher l'aide
  begin
    if not (intType = -1) then
    BEGIN
      intType := 0; // c'est une erreur
    END;
  end;
  //travailler en fonction du type de tache demandé :
  case intType of
    -1:
      begin
        //menu d'aide
        WriteLn('Manipule les generateurs d''une base Interbase');
        WriteLn(#13#10);
        WriteLn('[] sans parametre     : declenche une exportation pour la base specifie');
        WriteLn('[-E] ou [-e][chemin]  : declenche une exportation pour la base specifie');
        WriteLn('    Genere un fichier ''generateur.sql'' a cote de la base.');
        WriteLn('[-I] ou [-i][chemin]  : declenche une importation pour la base specifie');
        WriteLn('    Le fichier ''generateur.sql'' a importer doit etre situe a cote de la base.');
        WriteLn('[-G] ou [-g] : declenche un export pour la base specifie (gengenerateur du bas_ident seulement)');
      end;
    0: //erreur rencontrée
      begin
        Database.close;
        WriteLn('Erreur !' + #13#10 + 'Generateur.exe ne peut pas executer votre commande' + #13#10 + 'Le fichier ''generateur.sql'' n''a pas ete genere');
      end;
    1: //export
      begin
        if not recupererGenerateurs(strPathBase) then
        begin
          WriteLn('Erreur !' + #13#10 + 'Generateur.exe ne peut pas recuperer les generateurs');
        end
        else
        begin
          WriteLn('Exportation des generateurs dans ''generateur.sql'' pour la base : ' + #13#10 + strPathBase);
        end;
      end;
    2: //import
      begin
        if not configBase(strPathBase) then
        begin
          WriteLn('Erreur !' + #13#10 + 'Generateur.exe ne peut pas importer les generateurs');
        end
        else
        begin
          WriteLn('Importation des generateurs dans la base : ' + #13#10 + strPathBase);
        end;
      end;
    3: //export specifique pour synchro easy
      begin
        if not recupererGenerateurs(strPathBase) then
        begin
          WriteLn('Erreur !' + #13#10 + 'Generateur.exe ne peut pas recuperer les generateurs');
        end
        else
        begin
          WriteLn('Exportation des generateurs du baseID dans ''generateur.sql'' pour la base : ' + #13#10 + strPathBase);
        end;
      end;
  end;
  Application.Terminate;
end;

function TFrm_Main.recupererGenerateurs(strPathBase: string): Boolean;
var
  tsExportSql, DeleteData, DeleteK, InsertK, InsertData, UpdateK: TStringList;
  basId : Integer;
begin
  // Fonction qui récupère les générateurs de la base strPathBase et les stockent dans un fichier sql enregistré à coté de la base
  // retourne vrai si le fichier sql est bien créé.
  result := false;
  //créer le mémo pour stocker les lignes des générateurs
  tsExportSql := TStringList.create;
  DeleteData := TStringList.Create;
  DeleteK := TStringList.Create;
  InsertK := TStringList.Create;
  InsertData := TStringList.Create;
  UpdateK := TStringList.Create;
  try
    //commencer par le numéro de la base
    Que_BaseIdent.close;
    Que_BaseIdent.Open;
    tsExportSql.Add('update genparambase set par_string=''' + Que_BaseIdentPAR_String.asString + ''' where Par_nom=''IDGENERATEUR'';');

    // recuperation du bas_id
    Que_ExportGenerator.SQL.Text := 'select bas_id from genparambase join genbases on bas_ident=par_string where par_nom=''IDGENERATEUR''';
    Que_ExportGenerator.Open;
    basId := Que_ExportGenerator.FieldByName('bas_id').AsInteger;
    Que_ExportGenerator.Close;

    //récupèrer le nom de chaque générateur
    Que_NomGenerateur.open;
    Que_NomGenerateur.first;
    //pour chaque générateur non system récupérer sa valeur sous la forme d'une ligne d'exportation set generator to 'val'
    while not Que_NomGenerateur.eof do
    begin
      if Que_NomGenerateurRDBSYSTEM_FLAG.asinteger <> 1 then
      begin
        Que_ExportGenerator.sql.text := 'select ''set generator ''|| F_RTRIM(RDB$GENERATOR_NAME) ||'' to ''||GEN_ID(' + Que_NomGenerateurRDBGENERATOR_NAME.asString + ',0)  from rdb$Generators where RDB$GENERATOR_NAME=UPPER(''' + Que_NomGenerateurRDBGENERATOR_NAME.asString + ''')';
        Que_ExportGenerator.Open;
        tsExportSql.Add(Que_ExportGenerator.fields[0].asString + ';');
      end;
      Que_NomGenerateur.next;
    end;

    // partie loi de finance
    if(intType = 3) then
    begin
      Que_ExportLDF.SQL.Text := Que_ExportLDF.SQL.Text + ' and grt_basid=' + IntToStr(basId);
    end;

    Que_ExportLDF.Open;
    Que_ExportLDF.First;
    while not Que_ExportLDF.Eof do
    begin
      DeleteData.Add('DELETE FROM GENGENERATEUR WHERE GRT_ID=' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ';');
      DeleteK.Add('DELETE FROM K WHERE K_ID=' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ';');
      if(Que_ExportLDF.FieldByName('GRT_TYPE').AsInteger <> 3) then
      begin
        InsertK.Add('INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID) VALUES (' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ', ' + Que_ExportLDF.FieldByName('KRH_ID').AsString + ', -11111709, ' + Que_ExportLDF.FieldByName('K_VERSION').AsString + ', 1, -1, -1, ''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Que_ExportLDF.FieldByName('K_INSERTED').AsDateTime) + ''', 0, ''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Que_ExportLDF.FieldByName('K_UPDATED').AsDateTime) + ''', ' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ', ' + Que_ExportLDF.FieldByName('K_LID').AsString + ');');
        InsertData.Add('INSERT INTO GENGENERATEUR (GRT_ID, GRT_TYPE, GRT_BASID, GRT_MAGID, GRT_POSID, GRT_SESID, GRT_COMPTEUR) VALUES (' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_TYPE').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_BASID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_MAGID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_POSID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_SESID').AsString + ', ' + Que_ExportLDF.FieldByName('GRT_COMPTEUR').AsString + ');');
        if((intType = 1) and (Que_ExportLDF.FieldByName('GRT_BASID').AsInteger = basId)) then
          UpdateK.Add('EXECUTE PROCEDURE PR_UPDATEK(' + Que_ExportLDF.FieldByName('GRT_ID').AsString + ', 0);');
      end;

      Que_ExportLDF.Next;
    end;

    if(DeleteData.Count > 0) then
      tsExportSql.AddStrings(DeleteData);

    if(DeleteK.Count > 0) then
      tsExportSql.AddStrings(DeleteK);

    if(InsertK.Count > 0) then
      tsExportSql.AddStrings(InsertK);

    if(InsertData.Count > 0) then
      tsExportSql.AddStrings(InsertData);

    if(UpdateK.Count > 0) then
      tsExportSql.AddStrings(UpdateK);

    //sauver le résultat
    tsExportSql.SaveToFile(ExtractFilePath(strPathbase) + 'generateur.sql');
    result := true;
  finally
    DeleteData.Free;
    DeleteK.Free;
    InsertK.Free;
    InsertData.Free;
    UpdateK.Free;
    tsExportSql.free;
    Que_BaseIdent.close;
    Que_NomGenerateur.close;
    Que_ExportGenerator.close;
    Que_ExportLDF.Close;
  end;
end;

function TFrm_Main.configBase(strPathBaseNb: string): boolean;
var
  tsl: Tstringlist;
  i: integer;
begin
  //fonction qui executer le script de mise à jour des generateurs pour le base strPathBase grace au fichier generateur.sql
  //situé à coté de la base strPathBase
  //retourne vrai si la requete de mise à jour a bien été exécutée
  Result := false;
  i := 0;
  tsl := TStringList.create();
  try
    tsl.loadfromFile(ExtractFilePath(strPathBaseNb) + 'generateur.sql');
    //charger les générateurs ligne par ligne
    while (i <= tsl.count - 1) do
    begin
      //initialiser le requete
      Que_ImportGenerators.sql.clear;
      //passer le script des générateurs
      Que_ImportGenerators.SQL.Text := tsl.Strings[i];
      Que_ImportGenerators.ExecSQL;
      //augmenter le compteur
      inc(i);
    end;
    Result := true;
  finally
    tsl.free;
  end;
end;


procedure TFrm_Main.analyseVariable();
var
  param1, param2: string;
begin
  //procédure qui analyse les paramétres de la ligne de commande et détermine le type d'opération à executer
  // si 0 param, fonctionnement par défault de l'ancien 'generateur' : il s'agit d'un export depuis la base GINKOIA à coté de l'exe
  // si 1 param c'est un export depuis la base décrite par le paramétre (chemin complet)
  // si 2 paramétres l'un est le type (EXPORT ou IMPORT) l'autre décrit le chemin vers la base

  //si aucun, s'executer pour la base ginkoia contenu dans le même dossier
  if (ParamCount = 0) then
  begin
    strPathBase := ExtractFilePath(Application.exename) + 'GINKOIA.IB';
    if fileExists(strPathBase) then
    begin
      intType := 1;
    end
    else
    begin
      intType := 0;
    end;
  end // 1Paramètre
  else if (ParamCount = 1) then
  begin
    if (trim(paramstr(1)) = 'HELP') or (trim(paramstr(1)) = 'help') or (trim(paramstr(1)) = '-h') or (trim(paramstr(1)) = '/?') then
    begin
      intType := -1;
    end
    else if (LowerCase(trim(paramstr(1))) = '-g') then
    begin
      strPathBase := ExtractFilePath(Application.exename) + 'GINKOIA.IB';
      if fileExists(strPathBase) then
      begin
        intType := 3;
      end
      else
      begin
        intType := 0;
      end;
    end
    else
    begin
      try
        strPathBase := trim(paramstr(1));
        intType := 1;
      except on e: Exception do
        begin
          intType := 0;
          WriteLn('Erreur :' + e.message);
        end;
      end;
    end;
  end
  else if (ParamCount = 2) then // 2paramètres
  begin
    try
      //récupèrer les parametres
      param1 := trim(paramstr(1));
      param2 := trim(paramstr(2));
      //verifier l'ordre
      //si export demandé
      if (LowerCase(param1) = '-e') or (LowerCase(param2) = '-e') then
      begin
        intType := 1;
      end
        //si import demandé
      else if (LowerCase(param1) = '-i') or (LowerCase(param2) = '-i') then
      begin
        intType := 2;
      end
      else if (LowerCase(param1) = '-g') or (LowerCase(param2) = '-g') then
      begin
        intType := 3;
      end;
      //récupèrer le chemin
      if (length(param1) > 2) then
      begin
        strPathBase := param1;
      end
      else
      begin
        strPathBase := param2;
      end;
      //dernier test au cas ou...
      if strPathBase = '' then
      begin
        intType := 0;
      end;
    except on e: Exception do
      begin
        intType := 0;
        WriteLn('Erreur :' + e.message);
      end;
    end;
  end;
end;

end.

