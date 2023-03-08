unit Ulame;

interface

uses
   Xml_Unit,
   IcXMLParser,
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, SysUtils;

type
  TonNotifyStr = PROCEDURE (sender:Tobject; message:String) of object;
  TonNotifyStr2 = PROCEDURE (sender:Tobject; message1,message2:String) of object;
  TOnNotifyDataBase = PROCEDURE (sender:Tobject; Machine, Centrale, client, base : string ; actu, max : integer) of object;
  TUtilLame = class(TObject)
  protected
    FOnNotifyXml : TonNotifyStr2 ;
    fOnNotifyDataBase : TOnNotifyDataBase ;
  public
    PROCEDURE ListeXml (Machine:String) ;
    property OnNotifyXml : TonNotifyStr2 read FOnNotifyXml write FOnNotifyXml ;
    PROCEDURE ListeDataBases (machine,_xml:String) ;
    Property OnNotifyDataBase : TOnNotifyDataBase read fOnNotifyDataBase write fOnNotifyDataBase ;
  end;


implementation



{ TUtilLame }

procedure TUtilLame.ListeDataBases(machine,_xml: String);
Var
   Xml: TmonXML;
   passXML: TIcXMLElement;
   passXML2: TIcXMLElement;
   max : Integer ;
   actu:Integer ;
   NomClient:String ;
   Labase : string ;
   LaMachine:String ;
   LaCentrale:String ;
begin
   IF not assigned(fOnNotifyDataBase) THEN EXIT ;
   XML := TmonXML.Create;
   xml.LoadFromFile(_xml);
   passXML := Xml.find('/DataSources');
   max := PassXML.GetNodeList.Length;
   passXML := Xml.find('/DataSources/DataSource');
   actu := 0 ;
   while (PassXML <> nil) do
   begin
      inc(actu) ;
      NomClient := Xml.ValueTag(passXml, 'Name');
      passXML2 := xml.FindTag(passxml, 'Params');
      passXML2 := xml.FindTag(passxml2, 'Param');
      while (passXML2 <> nil) and (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') do
         passXML2 := passXML2.NextSibling;
      if Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' then
      begin
         LaBase := Xml.ValueTag(passXML2, 'Value');
         if (labase <> '') then
         begin
            if pos(':', labase) < 3 then
            begin
               labase := machine + ':' + labase;
            end;
            LaMachine := copy(labase, 1, pos(':', labase) - 1);
            LaCentrale := labase;
            Delete(LaCentrale, 1, pos('\', LaCentrale));
            Delete(LaCentrale, 1, pos('\', LaCentrale));
            LaCentrale := Copy(LaCentrale, 1, pos('\', LaCentrale) - 1);
            OnNotifyDataBase (self,LaMachine, LaCentrale, NomClient, LaBase, actu, max) ;
         END ;
      end;
      PassXML := PassXML.NextSibling;
   end;
   xml.free ;
end;

procedure TUtilLame.ListeXml(Machine: String);
var
   f: tsearchrec;
   rep: string;
begin
  IF not assigned(FOnNotifyXml) THEN EXIT ;
   rep := '\\' + machine + '\d$\EAI\';
   if findfirst(rep + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
         begin
            if FileExists(rep + f.name + '\DelosQPMAgent.Databases.xml') then
            begin
               OnNotifyXml (self,machine, rep + f.name + '\DelosQPMAgent.Databases.xml');
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
end;

end.
