unit Uhor;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, Db,
  //Uses Perso
  XMLCursor,
  StdXML_TLB,
  IniFiles,
  //Fin Uses perso
  IBDatabase, IBCustomDataSet, IBQuery;

type
  TForm1 = class(TForm)
    data: TIBDatabase;
    tran: TIBTransaction;
    Button1: TButton;
    qry: TIBQuery;
    Label1: TLabel;
    Memo1: TMemo;
    qryBAS_NOM: TIBStringField;
    qryLAU_H1: TIntegerField;
    qryLAU_HEURE1: TDateTimeField;
    qryLAU_H2: TIntegerField;
    qryLAU_HEURE2: TDateTimeField;
    Button2: TButton;
    IBQue_Loc: TIBQuery;
    IBQue_LocMAG_ENSEIGNE: TIBStringField;
    IBQue_LocPRM_INTEGER: TIntegerField;
    qryBAS_JETON: TIntegerField;
    Label2: TLabel;
    IBQue_Fedas: TIBQuery;
    IBQue_FedasSSF_ID: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure traite(tsl: tstringlist; Version, fichier: string; Lecas: integer; NomMach: String);
    { Déclarations privées }
  public
    { Déclarations publiques }
    LecteurLame: String;
  end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

// Cas ==> 1 : Horaire des bases
//     ==> 2 : Option Location pour les magasins

procedure TForm1.traite(tsl: tstringlist; Version, fichier: string; Lecas: integer; NomMach: String);
var
   Document: IXMLCursor;
   PassXML: IXMLCursor;
   PassXML2: IXMLCursor;
   nom: string;
   Base: string;
   S: string;
   Grp: string;
   Fedas: String;
begin
   Document := TXMLCursor.Create;
   Document.Load(Fichier);
   PassXML := Document.Select('DataSource');
   while not PassXML.eof do
   begin
      nom := PassXML.GetValue('Name');
      PassXML2 := PassXML.Select('Params');
      PassXML2 := PassXML2.Select('Param');
      while not PassXML2.eof do
      begin
         if PassXML2.GetValue('Name') = 'SERVER NAME' then
         begin
            base := PassXML2.GetValue('Value');
            BREAK
         end;
         PassXML2.next;
      end;
      if pos(':', base) > 2 then
         base := copy(base, pos(':', base) + 1, 255);
      memo1.lines.add(nom + '  ' + base);
      Label1.Caption := 'traitement de ' + nom; Label1.update;
      data.databasename := base;
      try
         data.open;
         case Lecas of
            1: //'VERSION;GROUPEMENT;NOM;SITE;H1;H2;H1+H2;Jeton;Fedas;Serveur'
               begin
                  qry.open;
                  qry.first;
                  IBQue_Fedas.Open;
                  IF (IBQue_Fedas.RecordCount>=1) then
                     Fedas:='1'
                  ELSE Fedas:='0';
                  while not qry.eof do
                  begin
                     Grp := copy(base, 8, 255); // 8 = 'D:\EAI\'+1
                     Grp := copy(Grp, 1, pos('\', Grp) - 1);
                     S := version + ';' + Grp + ';' + Nom + ';' + qryBAS_NOM.asstring + ';' + FormatDateTime('HH:NN', qryLAU_HEURE1.AsDateTime) +';';
                     if qryLAU_H2.asinteger = 1 then
                        S := S + FormatDateTime('HH:NN', qryLAU_HEURE2.AsDateTime);
                     S := S+';;'+qryBAS_JETON.asstring+';'+ Fedas+';'+NomMach+';' ;
                     tsl.add(S);
                     S := version + ';' + Grp + ';' + Nom + ';' + qryBAS_NOM.asstring + ';;;' + FormatDateTime('HH:NN', qryLAU_HEURE1.AsDateTime)+';'+qryBAS_JETON.asstring +';'+Fedas+';'+NomMach+ ';';
                     tsl.add(S);
                     if qryLAU_H2.asinteger = 1 then
                     begin
                        S := version + ';' + Grp + ';' + Nom + ';' + qryBAS_NOM.asstring + ';;;' + FormatDateTime('HH:NN', qryLAU_HEURE2.AsDateTime)+';'+qryBAS_JETON.asstring +';'+Fedas+';'+NomMach+ ';';
                        tsl.add(S);
                     end;
                     qry.next;
                  end;
               end;
            2: // 'NOM;GROUPEMENT;MAGASIN;LOCATION;Serveur'
               begin
                  Grp := copy(base, 8, 255); // 8 = 'D:\EAI\'+1
                  Grp := copy(Grp, 1, pos('\', Grp) - 1);
                  IBQue_Loc.open;
                  IBQue_Loc.first;
                  if IBQue_Loc.RecordCount <> 0 then
                  begin
                     while not IBQue_Loc.eof do
                     begin
                        S := Nom + ';' + Grp + ';' + IBQue_LocMAG_ENSEIGNE.asstring + ';' + IBQue_LocPRM_INTEGER.asstring +';'+NomMach + ';';
                        tsl.add(S);
                        IBQue_Loc.next;
                     end;
                  end
                  else
                  begin
                     S := Nom + ';' + Grp + ';' + IBQue_LocMAG_ENSEIGNE.asstring + ';0;'+ NomMach + ';';
                     tsl.add(S);
                  end;

               end;
         end;
      except
      end;
      qry.close;
      IBQue_Loc.close;
      IBQue_Fedas.close;
      data.close;
      PassXML.next;
   end;
   PassXML2 := nil;
   PassXML := nil;
   Document := nil;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  f: tsearchrec;
  tsl: tstringlist;
  Path: string;
begin
  Path := LecteurLame + ':\Eai\';
  if FindFirst(Path + '*.*', faanyfile, f) = 0 then
  begin
    tsl := tstringlist.create;
    tsl.add('VERSION;GROUPEMENT;NOM;SITE;H1;H2;H1+H2;Jetons;Fedas;MACHINE');
    repeat
       if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
       begin
          if FileExists(Path + f.name + '\DelosQPMAgent.Databases.xml') then
          begin
             Traite(tsl, f.name, Path + f.name + '\DelosQPMAgent.Databases.xml', 1,Label2.Caption);
          END;
       end;
    until Findnext(f) <> 0;
    tsl.SaveToFile(LecteurLame + ':\Transfert\'+changefileext(extractfilename(application.exename),'_'+Label2.Caption+'.CSV'));
    Application.messageBox('C''est fini', 'fin', mb_ok);
    tsl.free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   f: tsearchrec;
   PtLOC: tstringlist;
   Path: string;
begin
   Path := LecteurLame + ':\Eai\';
   if FindFirst(Path + '*.*', faanyfile, f) = 0 then
   begin
      PtLOC := tstringlist.create;
      PtLOC.add('SERVEUR;GROUPEMENT;MAGASIN;LOCATION;MACHINE');
      repeat
         if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
         begin
            if FileExists(Path + f.name + '\DelosQPMAgent.Databases.xml') then
            begin
               Traite(PtLOC, f.name, Path + f.name + '\DelosQPMAgent.Databases.xml', 2,Label2.Caption);
            end;
         end;
      until Findnext(f) <> 0;
      PtLOC.SaveToFile(LecteurLame + ':\Transfert\'+changefileext(extractfilename(application.exename),'_'+Label2.Caption+'_LOC.CSV'));
      Application.messageBox('C''est fini pour la LOCATION', 'fin', mb_ok);
      PtLOC.free;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Compt : array[0..256] OF Char;
  Lasize :DWord;
  FichierIni  : TIniFile;
begin
  Lasize:=255;
  getcomputername(@compt,Lasize);
  Label2.Caption := String(compt);

  try
    //Ouverture ou création du fichier ini
    FichierIni  := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
    //Lecteur de la valeur
    LecteurLame := FichierIni.ReadString('GENERAL', 'LecteurLame', 'D');
  finally
    FreeAndNil(FichierIni);
  end;
end;

end.


