//$Log:
// 1    Utilitaires1.0         01/10/2012 16:06:37    Loic G          
//$
//$NoKeywords$
//
unit UMAJPantin;

interface

uses
   XMLCursor,
   StdXML_TLB,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Db, dxmdaset, MemDataX, StdCtrls, ComCtrls, IBCustomDataSet, IBQuery,
   IBDatabase, IpUtils, IpSock, IpHttp, IpHttpClientGinkoia, IBSQL;

type
   TForm1 = class(TForm)
      Base: TDataBaseX;
      Mem_Clt: TMemDataX;
      Mem_Cltid: TIntegerField;
      Mem_Cltsite: TStringField;
      Mem_Cltnom: TStringField;
      Mem_Cltversion: TIntegerField;
      Mem_Cltpatch: TIntegerField;
      Mem_Cltversion_max: TIntegerField;
      Mem_Cltspe_patch: TIntegerField;
      Mem_Cltspe_fait: TIntegerField;
      Mem_Cltbckok: TDateTimeField;
      Mem_Cltdernbck: TDateTimeField;
      Mem_Cltresbck: TStringField;
      Mem_Cltblockmaj: TIntegerField;
      Mem_Cltnompournous: TStringField;
      Mem_Cltdernbckok: TIntegerField;
      Mem_Cltbasepantin: TIntegerField;
      Bd: TIBDatabase;
      tran: TIBTransaction;
      Que_Version: TIBQuery;
      Que_VersionVER_VERSION: TIBStringField;
      IBQue_Base: TIBQuery;
      IBQue_BaseBAS_NOM: TIBStringField;
      IBQue_BaseBAS_IDENT: TIBStringField;
      IBQue_Soc: TIBQuery;
      IBQue_SocSOC_NOM: TIBStringField;
      PB: TProgressBar;
      Lab_etat: TLabel;
      Version: TMemDataX;
      Versionid: TIntegerField;
      Versionversion: TStringField;
      Versionnomversion: TStringField;
      VersionPatch: TIntegerField;
      Lab_etat2: TLabel;
      Http1: TIpHttpClientGinkoia;
      SQL: TIBSQL;
      Histo: TMemDataX;
      Histoid_cli: TIntegerField;
      Histoaction: TIntegerField;
      Histoactionstr: TStringField;
      Histoval1: TIntegerField;
      Histoval2: TIntegerField;
      Histoval3: TIntegerField;
      Histostr1: TStringField;
      Histostr2: TStringField;
      Histostr3: TStringField;
      Histoid: TIntegerField;
      Histoladate: TDateTimeField;
      Histofait: TIntegerField;
      Mem_CltPriseencompte: TIntegerField;
      procedure FormCreate(Sender: TObject);
      procedure FormPaint(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
   private
    { Déclarations privées }
      first: boolean;
      function traitechaine(S: string): string;
      procedure ecrit(quoi: string);
   public
    { Déclarations publiques }
      Lesbases: tstringlist;
      Log: TstringList;
      LogName: string;
      procedure initlesbases;
      procedure verif;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

{ TForm1 }

procedure TForm1.initlesbases;
var
   Document: IXMLCursor;

   procedure cherche(rep: string);
   var
      f: tsearchrec;
      LaBase: string;
      PassXML: IXMLCursor;
      PassXML2: IXMLCursor;
      Test: Boolean;
      cas :Integer;
   begin
      if findfirst(rep + '*.*', faanyfile, f) = 0 then
      begin
         repeat
            if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
            begin
               IF FileExists(rep + f.name + '\DelosQPMAgent.Databases.xml') then
               begin

                  Document.Load(rep + f.name + '\DelosQPMAgent.Databases.xml');
                  PassXML := Document.Select('DataSource');
                  while not PassXML.eof do
                  begin
                     PassXML2 := PassXML.Select('Params');
                     PassXML2 := PassXML2.Select('Param');
                     LaBase := '';
                     while not PassXML2.eof do
                     begin
                        if PassXML2.GetValue('Name') = 'SERVER NAME' then
                        begin
                           LaBase := PassXML2.GetValue('Value');
                           BREAK;
                        end;
                        PassXML2.next;
                     end;
                     if labase <> '' then
                     begin
                        {
                        if pos(':', Labase) > 2 then
                           Labase := copy(Labase, pos(':', Labase) + 1, 255);
                        if fileexists(Labase) then
                        }
                        Lesbases.add(Labase);
                     end;
                     PassXML.Next;
                  end;
               end;
            end;
         until findnext(f) <> 0;
      end;
      findclose(f);
   end;

begin
   lab_etat.caption := 'Initialisation : parcour des fichier EAI'; lab_etat.update;
   Document := TXMLCursor.Create;
   Lesbases := tstringlist.create;
   cherche('D:\EAI\');
   cherche('D:\EAI\P3\');
end;

procedure TForm1.ecrit(quoi: string);
begin
   log.add(quoi + '  ' + DateTimeToStr(now));
   log.savetofile(logname);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   MemDataX.timeout := 120000;
   lab_etat.caption := '';
   Lab_etat2.caption := '';
   first := true;
   Log := TstringList.create;
   LogName := Changefileext(application.exename, '.log');
   ecrit('debut');
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
   if first then
   begin
      first := false;
      Application.ProcessMessages;
      initlesbases;
      verif;
      close;
   end;
end;

function TForm1.traitechaine(S: string): string;
var
   kk: Integer;
begin
   while pos(' ', S) > 0 do
   begin
      kk := pos(' ', S);
      delete(S, kk, 1);
      Insert('%20', S, kk);
   end;
   result := S;
end;

procedure TForm1.verif;
var
   i: integer;
   j: integer;
   Soc: string;
   VersionEnCours: string;
   Nomrecup: string;
   S: string;
   S1: string;
   Nok: boolean;
   Erreur: string;
begin
   pb.max := Lesbases.count;
   Nok := false;
   lab_etat.caption := 'Ouverture de client de Ginkoia.yellis.net'; lab_etat.update;
   mem_clt.Open;
   lab_etat.caption := 'Ouverture de histo de Ginkoia.yellis.net'; lab_etat.update;
   histo.Open;
   lab_etat.caption := 'traitement des bases'; lab_etat.update;
   for i := 0 to Lesbases.count - 1 do
   begin
      pb.position := i + 1;
      ecrit(Lesbases[i]);
      lab_etat.caption := Lesbases[i]; lab_etat.update;
      bd.close;
      try
         bd.DatabaseName := Lesbases[i];
         bd.Open;
         try
            IBQue_Soc.open;
            Soc := IBQue_SocSOC_NOM.AsString;
            IBQue_Soc.Close;
            Que_Version.Open;
            VersionEnCours := Que_VersionVER_VERSION.AsString;
            Que_Version.Close;
            ecrit(Lesbases[i] + ' ' + VersionEnCours);
            Version.ParamByName('numero').AsString := VersionEnCours;
            Version.Open;
            if Mem_Cltversion.AsInteger <> Versionid.AsInteger then
            begin
               ecrit('Pas la bonne version modif');
               Mem_Clt.edit;
               Mem_Cltversion.AsInteger := Versionid.AsInteger;
               Mem_Clt.Post;
               Mem_Clt.Validation;
            end;
            if not version.IsEmpty then
            begin
               if mem_clt.trouve(Mem_Cltsite, soc) then
               begin
                  if Mem_Cltpatch.AsInteger < VersionPatch.AsInteger then
                  begin
                     ecrit('A scripter');
                     Lab_etat2.caption := 'Passage de script'; Lab_etat2.Update;
                     for j := Mem_Cltpatch.AsInteger + 1 to VersionPatch.AsInteger do
                     begin
                        ecrit('Passage du script ' + Inttostr(j));
                        Lab_etat2.caption := 'Passage du script ' + Inttostr(j); Lab_etat2.Update;
                        Nomrecup := traitechaine('http://nss0202514SR/maj/patch/' + Versionnomversion.AsString + '/script' + Inttostr(j) + '.SQL');
                        if Http1.GetWaitTimeOut(Nomrecup, 30000) then
                        begin
                           S := http1.AsString(Nomrecup);
                           while s <> '' do
                           begin
                              if pos('<---->', S) > 0 then
                              begin
                                 S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                                 Delete(S, 1, pos('<---->', S) + 5);
                              end
                              else
                              begin
                                 S1 := trim(S);
                                 S := '';
                              end;
                              if s1 <> '' then
                              begin
                                 try
                                    tran.Active := true;
                                    Sql.SQL.Text := S1;
                                    Sql.ExecQuery;
                                    if Sql.Transaction.InTransaction then
                                       Sql.Transaction.Commit;
                                    tran.Active := true;
                                 except
                                    on E: Exception do
                                    begin
                                       erreur := E.Message;
                                       S1 := trim(S1);
                                       if copy(S1, 1, length('CREATE PROCEDURE')) = 'CREATE PROCEDURE' then
                                       begin
                                          delete(S1, 1, 6);
                                          S1 := 'ALTER' + S1;
                                          try
                                             tran.Active := true;
                                             Sql.SQL.Text := S1;
                                             Sql.ExecQuery;
                                             if Sql.Transaction.InTransaction then
                                                Sql.Transaction.Commit;
                                             tran.Active := true;
                                          except
                                             on E: Exception do
                                             begin
                                                Application.messagebox(Pchar('Erreur sur le script' + Inttostr(j) + #10#13 + Erreur + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                                                Nok := true;
                                                BREAK;
                                             end;
                                          end;
                                       end
                                       else
                                       begin
                                          Application.messagebox(Pchar('Erreur sur le script' + Inttostr(j) + #10#13 + Erreur + #10#13 + Copy(S1, 1, 50)), ' impossible de continuer', mb_ok);
                                          Nok := true;
                                          BREAK;
                                       end;
                                    end;
                                 end
                              end;
                           end;
                           if nok then
                           begin
                              Histo.Insert;
                              Histoid_cli.AsInteger := Mem_Cltid.AsInteger;
                              Histoladate.AsDateTime := Now;
                              Histoaction.AsInteger := 5;
                              Histoactionstr.AsString := 'script' + Inttostr(j) + '.SQL';
                              Histostr1.AsString := 'A pantin';
                              Histo.Post;
                              histo.Validation;
                              BREAK;
                           end;
                           ecrit('Maj client');
                           Mem_Clt.edit;
                           Mem_Cltpatch.AsInteger := j;
                           Mem_Clt.Post;
                           Mem_Clt.validation;
                           Histo.Insert;
                           Histoid_cli.AsInteger := Mem_Cltid.AsInteger;
                           Histoladate.AsDateTime := Now;
                           Histoaction.AsInteger := 4;
                           Histoactionstr.AsString := 'script' + Inttostr(j) + '.SQL';
                           Histostr1.AsString := 'A pantin';
                           Histo.Post;
                           histo.Validation;
                        end
                        else
                        begin
                           ecrit('Pas recup');
                           BREAK;
                        end
                     end;
                     Lab_etat2.caption := ''; Lab_etat2.Update;
                  end;
               end;
            end;
         finally
            bd.close;
         end;
         if nok then BREAK;
      except
         ecrit('prob base ' + Lesbases[i]);
      end;
   end;
   histo.close;
   mem_clt.close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   ecrit('fin');
   log.free;
end;

end.

