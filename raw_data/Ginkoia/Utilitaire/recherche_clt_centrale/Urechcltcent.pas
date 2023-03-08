unit Urechcltcent;

interface

uses
   inifiles, Xml_Unit, IcXMLParser, Windows, Messages, SysUtils, Classes,
   Graphics, Controls, Forms, Dialogs, Buttons, StdCtrls, Db, IBDatabase,
   IBCustomDataSet, IBQuery, XMLDoc, ExtCtrls, XMLIntf, filectrl, uGenerique,
   uDefs, IdMessage, IdSMTP, IdSSLOpenSSL, IdGlobal,
   IdExplicitTLSClientServerBase;

type
   TForm1 = class(TForm)
    lblVersion: TLabel;
    lblCentrale: TLabel;
    lblMail: TLabel;
    edMail: TEdit;
    btnLancer: TButton;
    edVersion: TEdit;
    edCentrale1: TEdit;
    sbVersion: TSpeedButton;
    sbCentrale1: TSpeedButton;
    db: TIBDatabase;
    tran: TIBTransaction;
    ibQue_Mag: TIBQuery;
    ibQue_MagMAG_NOM: TIBStringField;
    ibQue_MagADR1: TIBStringField;
    ibQue_MagADR2: TIBStringField;
    ibQue_MagADR3: TIBStringField;
    ibQue_MagADR_TEL: TIBStringField;
    ibQue_MagADR_FAX: TIBStringField;
    ibQue_MagADR_EMAIL: TIBStringField;
    ibQue_MagVIL_NOM: TIBStringField;
    ibQue_MagVIL_CP: TIBStringField;
    ibQue_MagMAG_CODEADH: TIBStringField;
    IBQue_Fedas: TIBQuery;
    IBQue_FedasSSF_ID: TIntegerField;
    cbGroupe1: TCheckBox;
    cmbGroupe1: TComboBox;
    cbParam: TCheckBox;
    lblCode1: TLabel;
    edParamType1: TEdit;
    edParamCode1: TEdit;
    Bevel1: TBevel;
    lblType1: TLabel;
    edParamInteger1: TEdit;
    lblAlert: TLabel;
    lblEntier1: TLabel;
    edParamFloat1: TEdit;
    lblFloat1: TLabel;
    lblAlert2: TLabel;
    edParamString1: TEdit;
    IBQue_groupe: TIBQuery;
    IBQue_groupeUGG_ID: TIntegerField;
    IBQue_groupeUGG_NOM: TIBStringField;
    IbQue_AjouteGrp: TIBQuery;
    IBQue_rechparam: TIBQuery;
    IBQue_rechparamPRM_ID: TIntegerField;
    IBQue_rechparamPRM_INTEGER: TIntegerField;
    IBQue_rechparamPRM_FLOAT: TFloatField;
    IBQue_rechparamPRM_STRING: TIBStringField;
    IbQue_ModifParam: TIBQuery;
    cbGroupe2: TCheckBox;
    cmbGroupe2: TComboBox;
    edParamString2: TEdit;
    lblCode2: TLabel;
    edParamType2: TEdit;
    lblType2: TLabel;
    edParamCode2: TEdit;
    sbCentrale2: TSpeedButton;
    edCentrale2: TEdit;
    edParamInteger2: TEdit;
    lblEntier2: TLabel;
    edParamFloat2: TEdit;
    lblFloat2: TLabel;
    procedure sbVersionClick(Sender: TObject);
    procedure sbCentrale1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLancerClick(Sender: TObject);
    procedure cbGroupe1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sbCentrale2Click(Sender: TObject);
   private
    { Déclarations privées }
    iniParametre : TIni;
   public
    { Déclarations publiques }
    nom_machine: string;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.sbVersionClick(Sender: TObject);
var
  path : string;
begin
  if SelectDirectory('Choix de la version',EmptyStr,path) = True then
  begin
    while pos('\', path) > 0 do
      delete(path, 1, pos('\', path));
    edVersion.text :=  path;
  end;
end;

procedure TForm1.sbCentrale1Click(Sender: TObject);
var
  path : string;
begin
  if SelectDirectory('Choix de la centrale',EmptyStr,path) = True then
  begin
    while pos('\', path) > 0 do
      delete(path, 1, pos('\', path));
    edCentrale1.text := path
  end;
end;

procedure TForm1.sbCentrale2Click(Sender: TObject);
var
  path : string;
begin
  if SelectDirectory('Choix de la centrale',EmptyStr,path) = True then
  begin
    while pos('\', path) > 0 do
      delete(path, 1, pos('\', path));
    edCentrale2.text := path;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   ini: tinifile;
   Compt: array[0..256] of Char;
   Lasize: DWord;
begin
  Lasize := 255;
  getcomputername(@compt, Lasize);
  nom_machine := string(compt);
  ini := tinifile.create(changefileext(application.exename, '.ini'));
  try
    edVersion.text := ini.ReadString('default', 'version', 'V5_1');
    edCentrale1.text := ini.ReadString('default', 'centrale', 'Sport2000');
    edCentrale2.text := ini.ReadString('default', 'centrale2', '');
    edMail.text := ini.ReadString('default', 'mail', 'sandrine.medeiros@ginkoia.fr');
    iniParametre.defaultPath := ini.ReadString('default', 'path', 'd:\eai\');

    cmbGroupe1.Text := ini.ReadString('Groupe', 'Text', '');
    cbGroupe1.Checked := ini.ReadBool('Groupe', 'Checked', False);

    cmbGroupe2.Text := ini.ReadString('Groupe2', 'Text', '');
    cbGroupe2.Checked := ini.ReadBool('Groupe2', 'Checked', False);

    cbParam.Checked := ini.ReadBool('Param', 'Checked', False);

    edParamType1.Text     := ini.ReadString('Param', 'Type', '');
    edParamCode1.Text     := ini.ReadString('Param', 'Code', '');
    edParamInteger1.Text  := ini.ReadString('Param', 'Integer', '');
    edParamFloat1.Text    := ini.ReadString('Param', 'float', '');
    edParamString1.Text   := ini.ReadString('Param', 'String', '');

    edParamType2.Text     := ini.ReadString('Param', 'Type2', '');
    edParamCode2.Text     := ini.ReadString('Param', 'Code2', '');
    edParamInteger2.Text  := ini.ReadString('Param', 'Integer2', '');
    edParamFloat2.Text    := ini.ReadString('Param', 'float2', '');
    edParamString2.Text   := ini.ReadString('Param', 'String2', '');

    iniParametre.smtpUsername := ini.ReadString('SMTP', 'Username','');
    iniParametre.smtpPassword := ini.ReadString('SMTP', 'Password','');
    iniParametre.smtpHost := ini.ReadString('SMTP', 'Host','');
    iniParametre.smtpPort := ini.ReadInteger('SMTP', 'Port',25);
  finally
    ini.free;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ini.WriteString('default', 'version', edVersion.text);
    ini.WriteString('default', 'centrale', edCentrale1.text);
    ini.WriteString('default', 'centrale2', edCentrale2.text);
    ini.WriteString('default', 'mail', edMail.text);
    ini.WriteString('default', 'path', iniParametre.defaultPath);

    ini.WriteBool('Groupe', 'Checked', cbGroupe1.Checked);
    ini.WriteString('Groupe', 'Text', cmbGroupe1.Text);

    ini.WriteBool('Groupe2', 'Checked', cbGroupe2.Checked);
    ini.WriteString('Groupe2', 'Text', cmbGroupe2.Text);

    ini.WriteBool('Param', 'Checked', cbParam.Checked);

    ini.WriteString('Param', 'Type', edParamType1.Text);
    ini.WriteString('Param', 'Code', edParamCode1.Text);
    ini.WriteString('Param', 'Integer', edParamInteger1.Text);
    ini.WriteString('Param', 'float', edParamFloat1.Text);
    ini.WriteString('Param', 'String', edParamString1.Text);

    ini.WriteString('Param', 'Type2', edParamType2.Text);
    ini.WriteString('Param', 'Code2', edParamCode2.Text);
    ini.WriteString('Param', 'Integer2', edParamInteger2.Text);
    ini.WriteString('Param', 'float2', edParamFloat2.Text);
    ini.WriteString('Param', 'String2', edParamString2.Text);

    ini.WriteString('SMTP', 'Username', iniParametre.smtpUsername);
    ini.WriteString('SMTP', 'Password', iniParametre.smtpPassword);
    ini.WriteString('SMTP', 'Host', iniParametre.smtpHost);
    ini.WriteInteger('SMTP', 'Port', iniParametre.smtpPort);
  finally
    ini.free;
  end;
end;

procedure TForm1.cbGroupe1Click(Sender: TObject);
var
  Xml: TXMLDocument;
  Pass: IXMLNode;
  la_base: string;
  sauve: string;
  ComboGRP: TComboBox;
begin
  if (Sender as TCheckBox).Name = 'cbGroupe1' then
    ComboGRP := cmbGroupe1
  else  if (Sender as TCheckBox).Name = 'cbGroupe2' then
          ComboGRP := cmbGroupe2
        else
          EXIT;

  sauve := ComboGRP.text;
  ComboGRP.items.clear;

  if (Sender as TCheckBox).Checked then
  begin
    if fileexists(iniParametre.defaultPath + edVersion.Text + '\DelosQPMAgent.Databases.xml') then
    begin
      Xml := TXMLDocument.Create(Self);
      try
        Xml.LoadFromFile(iniParametre.defaultPath + edVersion.Text + '\DelosQPMAgent.Databases.xml');
        // Xml.find('/DataSources/DataSource');
        //Pass := xml.find('DataSource/Params/Param/Name', False);
        Pass := Xml.ChildNodes.FindNode('DataSources').ChildNodes.FindNode('DataSource').ChildNodes.FindNode('Params').ChildNodes.FindNode('Param');
        if (Pass.ChildValues['Name'] = 'SERVER NAME') then
        begin
          // Pass := xml.find('DataSource/Params/Param/Value', False);
          // la_base := Uppercase(pass.GetFirstNode.GetValue);
          La_Base := Uppercase(Pass.ChildValues['Value']);
          db.DatabaseName := la_base;
          db.Open;
          IBQue_groupe.Open;
          while not IBQue_groupe.eof do
          begin
            ComboGRP.items.add(IBQue_groupeUGG_NOM.asString);
            if (sauve <> '') and (IBQue_groupeUGG_NOM.asString = Sauve) then
              ComboGRP.itemIndex := ComboGRP.items.count - 1;
            IBQue_groupe.next;
          end;
          db.close;
        end;
      finally
        Xml.free;
      end;
    end
    else
    begin
      application.messagebox('La version n''existe pas', 'Erreur', Mb_Ok);
    end;
  end
  else
  begin
    ComboGRP.items.clear;
  end;
end;

procedure TForm1.btnLancerClick(Sender: TObject);
var
  Xml: TXMLDocument;
  Pass: IXMLNode;
  PassXml: IXMLNode;
  Nom_base: string;
  la_base: string;
  s, Body_text: string;
  tsl: tstringlist;
  Mail: TIdMessage;
  Smtp: TIdSMTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  if fileexists(iniParametre.defaultPath + edVersion.text + '\DelosQPMAgent.Databases.xml') then
  begin
    tsl := tstringlist.create;
    tsl.add('base;Code_Adh;Mag_Nom;adr1;adr2;adr3;CP;Ville;fedas');
    Body_text := 'En provenance de ' + nom_machine; // + #10#13;
    Body_text := Body_text + 'En date du ' + DateTimeToStr(now); // + #10#13;
    Body_text := Body_text + 'Clients de ' + edCentrale1.text + ' en version ' + edVersion.text;
    Xml := TXMLDocument.Create(Self);
    Xml.LoadFromFile(iniParametre.defaultPath + edVersion.text + '\DelosQPMAgent.Databases.xml');
    Pass := Xml.ChildNodes.FindNode('DataSources').ChildNodes.FindNode('DataSource');
    while pass <> nil do
    begin
      Nom_base := Pass.ChildValues['Name'];
      PassXml := Pass.ChildNodes.FindNode('Params').ChildNodes.FindNode('Param');

      while (PassXML <> nil) and (PassXml.ChildValues['Name'] <> 'SERVER NAME') do
        PassXML := passXML.NextSibling;

      if PassXML.ChildValues['Name'] = 'SERVER NAME' then
      begin
        la_base := UpperCase(PassXML.ChildValues['Value']);
        if (la_base <> '') and (PassXML.ChildValues['REFERENCER'] <> 'NON') then
        begin
          if  ((edCentrale1.Text <> '') AND (pos('\' + Uppercase(edCentrale1.Text) + '\', La_base) > 0)) or     //Centrale 1
              ((edCentrale2.Text <> '') AND (pos('\' + Uppercase(edCentrale2.Text) + '\', La_base) > 0)) then   //Ou Centrale 2
          begin
            caption := la_base ;
            // la base apartient à la centrale
            Body_text := Body_text; // +#10#13;
            db.DatabaseName := la_base;
            db.Open;
            ibQue_Mag.open;
            s := #10#13 + nom_base + ' - ' + ibQue_MagMAG_CODEADH.AsString + ' - ' + ibQue_MagMAG_NOM.asString +
                  ' - ' + ibQue_MagADR1.AsString + ' ' + ibQue_MagADR2.AsString + ' ' + ibQue_MagADR3.AsString +
                  ' - ' + ibQue_MagVIL_CP.AsString + ' ' + ibQue_MagVIL_NOM.AsString;
            IBQue_Fedas.Open;
            if (IBQue_Fedas.RecordCount >= 1) then
              s := s + ' - Fedas'
            else
              s := s + ' - PAS Fedas';
            Body_text := Body_text + S; // + #10#13;
            s := nom_base + ';' + ibQue_MagMAG_CODEADH.AsString + ';' + ibQue_MagMAG_NOM.asString +
                  ';' + ibQue_MagADR1.AsString + ';' + ibQue_MagADR2.AsString + ';' + ibQue_MagADR3.AsString +
                  ';' + ibQue_MagVIL_CP.AsString + ';' + ibQue_MagVIL_NOM.AsString;
            IBQue_Fedas.Open;
            if (IBQue_Fedas.RecordCount >= 1) then
              s := s + ';1'
            else
              s := s + ';0';
            tsl.add(s);
            if cbGroupe1.Checked and (trim(cmbGroupe1.Text) <> '') then
            begin
              IbQue_AjouteGrp.ParamByName('UGG_NOM').AsString := trim(cmbGroupe1.Text);
              IbQue_AjouteGrp.ExecSQL;
              if tran.InTransaction then
              begin
                tran.commit;
                tran.Active := true;
              end;
              S := 'Ajout du groupe ' + trim(cmbGroupe1.Text);
              Body_text := Body_text + S; // + #10#13;
            end;
            if cbGroupe2.Checked and (trim(cmbGroupe2.Text) <> '') then
            begin
              IbQue_AjouteGrp.ParamByName('UGG_NOM').AsString := trim(cmbGroupe2.Text);
              IbQue_AjouteGrp.ExecSQL;
              if tran.InTransaction then
              begin
                tran.commit;
                tran.Active := true;
              end;
              S := 'Ajout du groupe ' + trim(cmbGroupe2.Text);
              Body_text := Body_text + S; // + #10#13;
            end;
            if cbParam.Checked then
            begin
              //Action pour les premiers paramètres
              if (trim(edParamType1.text) <> '') and (trim(edParamCode1.text) <> '') then
              begin
                IBQue_rechparam.ParamByName('ptype').asstring := edParamType1.text;
                IBQue_rechparam.ParamByName('pcode').asstring := edParamCode1.text;
                IBQue_rechparam.Open;
                while not IBQue_rechparam.eof do
                begin
                  S := '';
                  if (trim(edParamInteger1.text) <> '') and (trim(edParamInteger1.text) <> IBQue_rechparamPRM_INTEGER.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_INTEGER=' + trim(edParamInteger1.text)
                    else
                      s := S + ', PRM_INTEGER=' + trim(edParamInteger1.text);
                  end;
                  if (trim(edParamFloat1.text) <> '') and (trim(edParamFloat1.text) <> IBQue_rechparamPRM_FLOAT.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_FLOAT=' + trim(edParamFloat1.text)
                    else
                      s := S + ', PRM_FLOAT=' + trim(edParamFloat1.text);
                  end;
                  if (trim(edParamString1.text) <> '') and (trim(edParamString1.text) <> IBQue_rechparamPRM_STRING.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_STRING=''' + trim(edParamString1.text) + ''''
                    else
                      s := S + ', PRM_STRING=''' + trim(edParamString1.text) + '''';
                  end;
                  if S <> '' then
                  begin
                    S := 'UPDATE GENPARAM ' + S + ' WHERE PRM_CODE = ' + edParamCode1.text + ' AND PRM_ID = ' + IBQue_rechparamPRM_ID.AsString;
                    IbQue_ModifParam.SQL.text := S;
                    IbQue_ModifParam.ExecSQL;
                    S := 'EXECUTE PROCEDURE PR_UPDATEK(' + IBQue_rechparamPRM_ID.AsString + ',0)';  //'UPDATE K SET K_Version=GEN_ID(GENERAL_ID,1) WHERE K_ID=' + IBQue_rechparamPRM_ID.AsString;
                    IbQue_ModifParam.SQL.text := S;
                    IbQue_ModifParam.ExecSQL;

                    S := 'Modification du paramètre ' + IBQue_rechparamPRM_ID.AsString;
                    Body_text := Body_text + S; // + #10#13;
                  end;
                  IBQue_rechparam.next;
                end;
                IBQue_rechparam.close;
                if tran.InTransaction then
                begin
                  tran.commit;
                  tran.Active := true;
                end;
              end;
              //Action pour les deuxièmes paramètres
              if (trim(edParamType2.Text) <> '') and (trim(edParamCode2.Text) <> '') then
              begin
                IBQue_rechparam.ParamByName('ptype').asstring := edParamType2.Text;
                IBQue_rechparam.ParamByName('pcode').asstring := edParamCode2.Text;
                IBQue_rechparam.Open;
                while not IBQue_rechparam.eof do
                begin
                  S := '';
                  if (trim(edParamInteger2.Text) <> '') and (trim(edParamInteger2.Text) <> IBQue_rechparamPRM_INTEGER.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_INTEGER=' + trim(edParamInteger2.Text)
                    else
                      s := S + ', PRM_INTEGER=' + trim(edParamInteger2.Text);
                  end;
                  if (trim(edParamFloat2.Text) <> '') and (trim(edParamFloat2.Text) <> IBQue_rechparamPRM_FLOAT.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_FLOAT=' + trim(edParamFloat2.Text)
                    else
                      s := S + ', PRM_FLOAT=' + trim(edParamFloat2.Text);
                  end;
                  if (trim(edParamString2.Text) <> '') and (trim(edParamString2.Text) <> IBQue_rechparamPRM_STRING.AsString) then
                  begin
                    if s = '' then
                      s := 'SET PRM_STRING=''' + trim(edParamString2.Text) + ''''
                    else
                      s := S + ', PRM_STRING=''' + trim(edParamString2.Text) + '''';
                  end;
                  if S <> '' then
                  begin
                    S := 'UPDATE GENPARAM ' + S + ' WHERE PRM_CODE = ' + edParamCode2.text + ' AND PRM_ID = ' + IBQue_rechparamPRM_ID.AsString;
                    IbQue_ModifParam.SQL.text := S;
                    IbQue_ModifParam.ExecSQL;
                    S := 'EXECUTE PROCEDURE PR_UPDATEK(' + IBQue_rechparamPRM_ID.AsString + ',0)'; //S := 'UPDATE K SET K_Version=GEN_ID(GENERAL_ID,1) WHERE K_ID=' + IBQue_rechparamPRM_ID.AsString;
                    IbQue_ModifParam.SQL.text := S;
                    IbQue_ModifParam.ExecSQL;

                    S := 'Modification du paramètre ' + IBQue_rechparamPRM_ID.AsString;
                    Body_text := Body_text + S; // + #10#13;
                  end;
                  IBQue_rechparam.next;
                end;
                IBQue_rechparam.close;
                if tran.InTransaction then
                begin
                  tran.commit;
                  tran.Active := true;
                end;
              end;
            end;
            db.close;
          end;
        end;
      end;
      Pass := Pass.NextSibling;
    end;
    tsl.SaveToFile(ExtractFilePath(Application.ExeName) + 'resultat.csv');
    tsl.clear;

    //Envoie du mail
    try
      Mail := TIdMessage.Create(nil);
      try
        Mail.From.Address := 'dev@ginkoia.fr';
      Mail.Recipients.EMailAddresses := edMail.Text;
      Mail.CCList.EMailAddresses := 'sylvain.rosset@ginkoi4.emea.microsoftonline.com';
      if ((edCentrale1.Text <> '') and (edCentrale2.Text <> '')) then
        Mail.Subject := 'Clients de ' + edCentrale1.Text + ' et de ' + edCentrale2.Text + ' en version ' + edVersion.Text
      else
      begin
        if (edCentrale1.Text <> '') then
          Mail.Subject := 'Clients de ' + edCentrale1.Text + ' en version ' + edVersion.Text
        else
        begin
          if (edCentrale2.Text <> '') then
            Mail.Subject := 'Clients de ' + edCentrale2.Text + ' en version ' + edVersion.Text;
        end;
      end;
      Mail.Body.Add(Body_Text);
      Smtp := TIdSMTP.Create(nil);
      try
        SSLHandler:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        try
          SSLHandler.MaxLineAction := maException;
          SSLHandler.SSLOptions.Method := sslvTLSv1;
          SSLHandler.SSLOptions.Mode := sslmUnassigned;
          SSLHandler.SSLOptions.VerifyMode := [];
          SSLHandler.SSLOptions.VerifyDepth := 0;

          Smtp.IOHandler:= SSLHandler;
          Smtp.UseTLS := utUseExplicitTLS;
          Smtp.Username := iniParametre.smtpUsername;
          Smtp.Password := iniParametre.smtpPassword;
          Smtp.Host := iniParametre.smtpHost;
          Smtp.Port := iniParametre.smtpPort;

          Smtp.Connect;
          try
            Smtp.Send(Mail);
          finally
            Smtp.Disconnect;
          end;
        finally
          SSLHandler.Free;
        end;
      finally
        Smtp.Free;
      end;
    finally
      Mail.Free;
    end;
    except
      on E : Exception do
        ShowMessage(E.ClassName+' Erreur lors de l''envoie du mail : '+E.Message);
    end;

    if not ((paramcount > 0) and (uppercase(paramstr(1)) = 'GO')) then
      application.messagebox('Traitement terminé.', 'Info', Mb_Ok);
  end
  else
  begin
    application.messagebox('La version n''existe pas', 'Erreur', Mb_Ok);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   if (paramcount > 0) and (uppercase(paramstr(1)) = 'GO') then
   begin
      btnLancerClick(nil);
      close;
   end;
end;

end.

