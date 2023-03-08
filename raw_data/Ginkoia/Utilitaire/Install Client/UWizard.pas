//$Log:
// 2    Utilitaires1.1         04/07/2005 10:17:16    pascal         
//      correction de label de l'install de base
// 1    Utilitaires1.0         27/04/2005 15:53:36    pascal          
//$
//$NoKeywords$
//
UNIT UWizard;

INTERFACE

USES
    XMLCursor,
    StdXML_TLB,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Spin, ComCtrls, Dialogs, CheckLst;

TYPE
    TFrm_Wizard = CLASS(TForm)
        PC: TPageControl;
        Tab_Version: TTabSheet;
        edt_version: TEdit;
        Label1: TLabel;
        Button1: TButton;
        TAB_Client: TTabSheet;
        Label2: TLabel;
        Edt_Client: TEdit;
        Tab_Base: TTabSheet;
        Label3: TLabel;
        SpinEdit1: TSpinEdit;
        Label4: TLabel;
        Label5: TLabel;
        SpinEdit2: TSpinEdit;
        CheckBox1: TCheckBox;
        Label6: TLabel;
        tab_societe: TTabSheet;
        Label7: TLabel;
        Label8: TLabel;
        Tab_Mag: TTabSheet;
        Label9: TLabel;
        Label10: TLabel;
        Label11: TLabel;
        Edit3: TEdit;
        Tab_Poste: TTabSheet;
        Label12: TLabel;
        Label13: TLabel;
        Edit5: TEdit;
        Label14: TLabel;
        OD: TOpenDialog;
        SpeedButton1: TSpeedButton;
        Edit6: TEdit;
        Label15: TLabel;
        Label16: TLabel;
        SpinEdit3: TSpinEdit;
        Label17: TLabel;
        Edit7: TEdit;
        CheckBox2: TCheckBox;
        Label18: TLabel;
        Edit8: TEdit;
        Button2: TButton;
        Lb: TCheckListBox;
        edt_mag: TComboBox;
        Edit1: TComboBox;
        Edit2: TComboBox;
        Edit4: TComboBox;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE PCChange(Sender: TObject);
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE Tab_VersionShow(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE edt_magClick(Sender: TObject);
        PROCEDURE Edit2Click(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
        Document: IXMLCursor; // Cursor qui contient l'intégralité du XML
        BaseEncours: STRING;
        SocEncours: STRING;
        MAGEncours: STRING;
        NomClient: STRING;
        PROCEDURE LoadDocument(S: STRING);
    END;

VAR
    Frm_Wizard: TFrm_Wizard;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_Wizard.FormCreate(Sender: TObject);
BEGIN
    Pc.ActivePage := TAB_version;
    Document := TXMLCursor.Create;
    NomClient := '';
END;

PROCEDURE TFrm_Wizard.Button1Click(Sender: TObject);
VAR
    Pass: IXMLCursor;
    Pass2: IXMLCursor;
    S: STRING;
    i: Integer;
BEGIN
    CASE Pc.ActivePage.Tag OF
        0: // tab_version
            BEGIN
                IF trim(edt_version.text) = '' THEN
                    application.Messagebox('Saisir la version', 'Erreur', Mb_OK)
                ELSE
                BEGIN
                    S := edt_version.text;
                    IF s[1] <> 'V' THEN
                        S := 'V' + S;
                    Document.First;
                    IF Document.GetValue('VERSION') <> '' THEN
                    BEGIN
                        Pass := Document;
                        Pass.SetValue('VERSION', S);
                        Pass.SetValue('LABASE', Edit5.text);
                        Pass.SetValue('LEREP', Edit6.text);
                        Pass.SetValue('PANTIN', Inttostr(SpinEdit3.Value));
                        Pass.SetValue('VERSIONEAI', Edit7.text);
                    END
                    ELSE
                    BEGIN
                        Pass := Document.AppendChild('CLIENT', '');
                        Pass.AppendChild('VERSION', S);
                        Pass.AppendChild('LABASE', Edit5.text);
                        Pass.AppendChild('LEREP', Edit6.text);
                        Pass.AppendChild('PANTIN', Inttostr(SpinEdit3.Value));
                        Pass.AppendChild('VERSIONEAI', Edit7.text);
                    END;
                    Pc.ActivePage := tab_client;
                END;
            END;
        1: // tab_client
            BEGIN
                IF trim(Edt_Client.text) = '' THEN
                    application.Messagebox('Saisir le nom du client', 'Erreur', Mb_OK)
                ELSE
                BEGIN
                    Document.First;
                    IF Document.GetValue('NOM') <> '' THEN
                    BEGIN
                        Document.SetValue('NOM', Edt_Client.text);
                        Document.SetValue('IDCOURT', Edit8.text);
                        FOR i := 0 TO lb.items.count - 1 DO
                        BEGIN
                            S := lb.items[i];
                            WHILE pos(' ', S) > 0 DO
                                S[pos(' ', S)] := '_';
                            IF lb.Checked[i] THEN
                                Document.SetValue(S, '1')
                            ELSE
                                Document.SetValue(S, '0');
                        END;
                    END
                    ELSE
                    BEGIN
                        Document.AppendChild('NOM', Edt_Client.text);
                        Document.AppendChild('IDCOURT', Edit8.text);
                        FOR i := 0 TO lb.items.count - 1 DO
                        BEGIN
                            S := lb.items[i];
                            WHILE pos(' ', S) > 0 DO
                                S[pos(' ', S)] := '_';
                            IF lb.Checked[i] THEN
                                Document.AppendChild(S, '1')
                            ELSE
                                Document.AppendChild(S, '0');
                        END;
                    END;
                    NomClient := Edt_Client.text;
                    Pc.ActivePage := tab_base;
                END;
            END;
        2: //tab_Base
            BEGIN
                Document.First;
                Pass := Document.Select('BASES');
                IF Pass.Count = 0 THEN
                BEGIN
                  // pas de base de créé
                    IF trim(edt_mag.text) = '' THEN
                    begin
                        IF application.MessageBox('Plus de site à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            pc.activePage := tab_societe ;
                    end
                    ELSE
                    BEGIN
                        Document.First;
                        Pass := Document.AppendChild('BASES', '');
                        Pass := Pass.AppendChild('BASE', '');
                        Pass.AppendChild('NOM', edt_mag.text);
                        edt_mag.items.add(edt_mag.text);
                        BaseEncours := edt_mag.text;
                        Pass.AppendChild('JETONS', Inttostr(SpinEdit1.Value));
                        Pass.AppendChild('NOTEBOOK', Inttostr(SpinEdit2.Value));
                        IF CheckBox1.checked THEN
                            Pass.AppendChild('SECOUR', 'OUI')
                        ELSE
                            Pass.AppendChild('SECOUR', 'NON');
                        edt_mag.text := '';
                        SpinEdit1.value := 10;
                        SpinEdit2.value := 0;
                        CheckBox1.checked := false;
                    END;
                END
                ELSE
                BEGIN
                    IF trim(edt_mag.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de site à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            pc.activePage := tab_societe
                    END
                    ELSE
                    BEGIN
                        Document.First;
                        Pass2 := Document.Select('BASES');
                        Pass2 := Pass2.Select('BASE');
                        WHILE NOT pass2.EOF DO
                        BEGIN
                            IF Pass2.GetValue('NOM') = edt_mag.text THEN
                                BREAK;
                            Pass2.Next;
                        END;
                        IF Pass2.GetValue('NOM') = edt_mag.text THEN
                        BEGIN
                            Pass2.SetValue('NOM', edt_mag.text);
                            BaseEncours := edt_mag.text;
                            Pass2.SetValue('JETONS', Inttostr(SpinEdit1.Value));
                            Pass2.SetValue('NOTEBOOK', Inttostr(SpinEdit2.Value));
                            IF CheckBox1.checked THEN
                                Pass2.SetValue('SECOUR', 'OUI')
                            ELSE
                                Pass2.SetValue('SECOUR', 'NON');
                        END
                        ELSE
                        BEGIN
                            edt_mag.items.add(edt_mag.text);
                            Pass := Pass.AppendChild('BASE', '');
                            Pass.AppendChild('NOM', edt_mag.text);
                            BaseEncours := edt_mag.text;
                            Pass.AppendChild('JETONS', Inttostr(SpinEdit1.Value));
                            Pass.AppendChild('NOTEBOOK', Inttostr(SpinEdit2.Value));
                            IF CheckBox1.checked THEN
                                Pass.AppendChild('SECOUR', 'OUI')
                            ELSE
                                Pass.AppendChild('SECOUR', 'NON');
                        END;
                        edt_mag.text := '';
                        SpinEdit1.value := 10;
                        SpinEdit2.value := 0;
                        CheckBox1.checked := false;
                    END;
                END;
            END;
        3: //tab_Societe
            BEGIN
                Document.First;
                Pass2 := Document.Select('SOCIETES');
                IF Pass2.Count = 0 THEN
                BEGIN
                    // pas de base de créé
                    IF trim(Edit1.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de sociétée à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            Modalresult := MrOk
                    END
                    ELSE
                    BEGIN
                        Pass := Document.AppendChild('SOCIETES', '');
                        Pass := Pass.AppendChild('SOCIETE', '');
                        Pass.AppendChild('NOM', Edit1.text);
                        SocEncours := Edit1.text;
                        Edit1.items.Add(Edit1.text);
                        Edit1.text := '';
                        pc.ActivePage := tab_Mag;
                    END;
                END
                ELSE
                BEGIN
                    IF trim(Edit1.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de sociétée à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            Modalresult := MrOk
                    END
                    ELSE
                    BEGIN
                        Pass := Document.Select('SOCIETES');
                        Pass := Pass.Select('SOCIETE');
                        WHILE NOT Pass.eof DO
                        BEGIN
                            IF pass.getvalue('NOM') = edit1.text THEN
                                BREAK;
                            Pass.next;
                        END;
                        IF pass.getvalue('NOM') <> edit1.text THEN
                        BEGIN
                            Pass := Document.Select('SOCIETES');
                            Pass := Pass.AppendChild('SOCIETE', '');
                            Pass.AppendChild('NOM', edit1.text);
                            Edit1.items.Add(Edit1.text);
                        END;
                        SocEncours := Edit1.text;
                        Edit1.text := '';
                        pc.ActivePage := tab_Mag;
                    END;
                END;
            END;
        4: //
            BEGIN
                Document.First;
                Pass := Document.Select('SOCIETES');
                Pass := Pass.Select('SOCIETE');
                REPEAT
                    IF Pass.GetValue('NOM') = SocEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS2 := Pass.Select('MAGASINS');
                IF Pass2.count = 0 THEN
                BEGIN
                    IF trim(Edit2.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de magasins à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            pc.ActivePage := tab_societe
                    END
                    ELSE
                    BEGIN
                        Pass := Pass.AppendChild('MAGASINS', '');
                        Pass := Pass.AppendChild('MAGASIN', '');
                        Pass.AppendChild('NOM', Edit2.text);
                        Edit2.Items.add(Edit2.text);
                        MAGEncours := Edit2.text;
                        Pass.AppendChild('IDCOURT', Edit3.Text);
                        Edit2.text := '';
                        Edit3.Text := '';
                        IF CheckBox2.Checked THEN
                            Pass.AppendChild('LOCATION', 'OUI')
                        ELSE
                            Pass.AppendChild('LOCATION', 'NON');
                        CheckBox2.Checked := False;
                        pc.ActivePage := tab_Poste;
                    END;
                END
                ELSE
                BEGIN
                    IF trim(Edit2.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de magasins à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNo THEN
                            pc.ActivePage := tab_societe
                    END
                    ELSE
                    BEGIN
                        Pass := Pass.Select('MAGASINS');
                        Pass2 := Pass.Select('MAGASIN');
                        WHILE NOT Pass2.eof DO
                        BEGIN
                            IF Edit2.text = pass2.GetValue('NOM') THEN
                                BREAK;
                            pass2.next;
                        END;
                        IF Edit2.text = pass2.GetValue('NOM') THEN
                        BEGIN
                            Pass2.SetValue('IDCOURT', Edit3.Text);
                            IF CheckBox2.Checked THEN
                                Pass2.SetValue('LOCATION', 'OUI')
                            ELSE
                                Pass2.SetValue('LOCATION', 'NON');
                        END
                        ELSE
                        BEGIN
                            Pass := Pass.AppendChild('MAGASIN', '');
                            Pass.AppendChild('NOM', Edit2.text);
                            Pass.AppendChild('IDCOURT', Edit3.Text);
                            Edit2.items.add(Edit2.text);
                            IF CheckBox2.Checked THEN
                                Pass.AppendChild('LOCATION', 'OUI')
                            ELSE
                                Pass.AppendChild('LOCATION', 'NON');
                        END;
                        MAGEncours := Edit2.text;
                        Edit2.text := '';
                        Edit3.Text := '';
                        CheckBox2.Checked := False;
                        pc.ActivePage := tab_Poste;
                    END;
                END;
            END;
        5: //
            BEGIN
                Document.First;
                Pass := Document.Select('SOCIETES');
                Pass := Pass.Select('SOCIETE');
                REPEAT
                    IF Pass.GetValue('NOM') = SocEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS := Pass.Select('MAGASINS');
                PASS := Pass.Select('MAGASIN');
                REPEAT
                    IF Pass.GetValue('NOM') = MAGEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS2 := Pass.Select('POSTES');
                IF Pass2.count = 0 THEN
                BEGIN
                    IF trim(Edit4.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de Postes à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNO THEN
                            pc.ActivePage := Tab_Mag;
                    END
                    ELSE
                    BEGIN
                        Pass := Pass.AppendChild('POSTES', '');
                        Pass := Pass.AppendChild('POSTE', '');
                        Pass.AppendChild('NOM', Edit4.text);
                        Edit4.Items.add(edit4.Text);
                        Edit4.Text := '';
                        pc.ActivePage := tab_Poste;
                    END
                END
                ELSE
                BEGIN
                    IF trim(Edit4.text) = '' THEN
                    BEGIN
                        IF application.MessageBox('Plus de Postes à saisir ?', 'Attention', Mb_YesNo OR MB_DEFBUTTON1) = MrNO THEN
                            pc.ActivePage := Tab_Mag;
                    END
                    ELSE
                    BEGIN
                        Pass := Pass.Select('POSTES');
                        Pass2 := Pass.Select('POSTE');
                        WHILE NOT pass2.EOF DO
                        BEGIN
                            IF Pass2.GetValue('NOM') = Edit4.text THEN
                                break;
                            Pass2.Next;
                        END;
                        IF Pass2.GetValue('NOM') <> Edit4.text THEN
                        BEGIN
                            Pass := Pass.AppendChild('POSTE', '');
                            Pass.AppendChild('NOM', Edit4.text);
                            Edit4.Items.add(edit4.Text);
                        END;
                        Edit4.Text := '';
                        pc.ActivePage := tab_Poste;
                    END;
                END;
            END;
    END;
    IF NomClient <> '' THEN
        Document.Save('C:\' + NomClient + '.xml');
END;

PROCEDURE TFrm_Wizard.Tab_VersionShow(Sender: TObject);
VAR
    Pass: IXMLCursor;
    tsl: tstringlist;
    i: integer;
    s: STRING;
BEGIN
    CASE Ttabsheet(sender).tag OF
        0: BEGIN
                Document.First;
                Pass := Document;
                IF pass <> NIL THEN
                BEGIN
                    edt_version.text := Pass.GetValue('VERSION');
                    Edit5.text := Pass.GetValue('LABASE');
                    Edit6.text := Pass.GetValue('LEREP');
                    IF Pass.GetValue('PANTIN') <> '' THEN
                        SpinEdit3.Value := Strtoint(Pass.GetValue('PANTIN'));
                    Edit7.text := Pass.GetValue('VERSIONEAI');
                END;
                edt_version.setfocus;
            END;
        1: BEGIN
                Lb.items.clear;
                IF fileexists(changefileext(application.exename, '.GRP')) THEN
                BEGIN
                    tsl := tstringlist.create;
                    tsl.loadfromfile(changefileext(application.exename, '.GRP'));
                    FOR i := 0 TO tsl.count - 1 DO
                    BEGIN
                        s := tsl[i];
                        S := Copy(S, 1, pos(';', S) - 1);
                        lb.items.add(S);
                        s := tsl[i];
                        S := Copy(S, pos(';', S) + 1, 1);
                        IF S = '1' THEN
                            lb.Checked[i] := true;
                    END;
                    tsl.free;
                END;
                Document.First;
                IF Document.GetValue('NOM') <> '' THEN
                BEGIN
                    Edt_Client.text := Document.GetValue('NOM');
                    Edit8.text := Document.GetValue('IDCOURT');
                    FOR i := 0 TO lb.items.count - 1 DO
                    BEGIN
                        S := lb.items[i];
                        WHILE pos(' ', S) > 0 DO
                            S[pos(' ', S)] := '_';
                        S := Document.GetValue(S);
                        IF S = '1' THEN
                            lb.Checked[i] := true
                        ELSE
                            lb.Checked[i] := False;
                    END;

                END;
                Edt_Client.setfocus
            END;
        2: BEGIN
                Document.first;
                Pass := Document.Select('BASES');
                Pass := Pass.Select('BASE');
                edt_mag.items.clear;
                WHILE NOT pass.EOF DO
                BEGIN
                    edt_mag.items.Add(Pass.GetValue('NOM'));
                    Pass.Next;
                END;
                edt_mag.SetFocus
            END;
        3: BEGIN
                Document.First;
                Pass := Document.Select('SOCIETES');
                Pass := Pass.Select('SOCIETE');
                Edit1.items.clear;
                WHILE NOT pass.EOF DO
                BEGIN
                    Edit1.items.Add(Pass.GetValue('NOM'));
                    Pass.Next;
                END;
                Edit1.SetFocus;
            END;
        4: BEGIN
                Document.First;
                Pass := Document.Select('SOCIETES');
                Pass := Pass.Select('SOCIETE');
                REPEAT
                    IF Pass.GetValue('NOM') = SocEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS := Pass.Select('MAGASINS');
                PASS := Pass.Select('MAGASIN');
                Edit2.items.clear;
                WHILE NOT pass.EOF DO
                BEGIN
                    Edit2.items.Add(Pass.GetValue('NOM'));
                    Pass.Next;
                END;
                Edit2.SetFocus;
            END;
        5: BEGIN
                Document.First;
                Pass := Document.Select('SOCIETES');
                Pass := Pass.Select('SOCIETE');
                REPEAT
                    IF Pass.GetValue('NOM') = SocEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS := Pass.Select('MAGASINS');
                PASS := Pass.Select('MAGASIN');
                REPEAT
                    IF Pass.GetValue('NOM') = MAGEncours THEN
                        BREAK;
                    Pass.Next;
                UNTIL False;
                PASS := Pass.Select('POSTES');
                PASS := Pass.Select('POSTE');
                Edit4.items.clear;
                WHILE NOT pass.EOF DO
                BEGIN
                    Edit4.items.Add(Pass.GetValue('NOM'));
                    Pass.Next;
                END;
                Edit4.setfocus;
            END;
    END;
END;

PROCEDURE TFrm_Wizard.FormDestroy(Sender: TObject);
BEGIN
    Document := NIL;
END;

PROCEDURE TFrm_Wizard.PCChange(Sender: TObject);
BEGIN
    IF pc.ActivePage = Tab_Version THEN
        edt_version.setfocus
    ELSE IF pc.ActivePage = TAB_Client THEN
        Edt_Client.setfocus
    ELSE IF pc.ActivePage = Tab_Base THEN
        edt_mag.SetFocus
    ELSE IF pc.ActivePage = tab_societe THEN
        Edit1.SetFocus
    ELSE IF pc.ActivePage = Tab_Mag THEN
        Edit2.SetFocus
    ELSE IF pc.ActivePage = Tab_Poste THEN
        Edit4.setfocus;
END;

PROCEDURE TFrm_Wizard.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        Edit5.text := Od.filename;
END;

PROCEDURE TFrm_Wizard.Button2Click(Sender: TObject);
BEGIN
    CASE Pc.ActivePage.Tag OF
        1: // tab_client
            BEGIN
                Pc.ActivePage := Tab_Version;
            END;
        2: //tab_Base
            BEGIN
                Pc.ActivePage := tab_client;
            END;
        3: //tab_Societe
            BEGIN
                Pc.ActivePage := tab_Base;
            END;
        4: //
            BEGIN
                Pc.ActivePage := tab_Societe;
            END;
        5: //
            BEGIN
                Pc.ActivePage := Tab_Mag;
            END;
    END;
END;

PROCEDURE TFrm_Wizard.LoadDocument(S: STRING);
BEGIN
    Document.Load(S);
END;

PROCEDURE TFrm_Wizard.edt_magClick(Sender: TObject);
VAR
    Pass2: IXMLCursor;
BEGIN
    IF trim(edt_mag.Text) <> '' THEN
    BEGIN
        Document.First;
        Pass2 := Document.Select('BASES');
        Pass2 := Pass2.Select('BASE');
        WHILE NOT pass2.EOF DO
        BEGIN
            IF Pass2.GetValue('NOM') = edt_mag.text THEN
                BREAK;
            Pass2.Next;
        END;
        IF Pass2.GetValue('NOM') = edt_mag.text THEN
        BEGIN
            BaseEncours := edt_mag.text;
            SpinEdit1.Value := Strtoint(Pass2.GetValue('JETONS'));
            SpinEdit2.Value := Strtoint(Pass2.GetValue('NOTEBOOK'));
            IF Pass2.GetValue('SECOUR') = 'OUI' THEN
                CheckBox1.checked := true
            ELSE
                CheckBox1.checked := false;
        END
    END;
END;

PROCEDURE TFrm_Wizard.Edit2Click(Sender: TObject);
VAR
    Pass: IXMLCursor;
BEGIN
    Document.First;
    Pass := Document.Select('SOCIETES');
    Pass := Pass.Select('SOCIETE');
    REPEAT
        IF Pass.GetValue('NOM') = SocEncours THEN
            BREAK;
        Pass.Next;
    UNTIL False;
    Pass := Pass.Select('MAGASINS');
    Pass := Pass.Select('MAGASIN');
    WHILE NOT Pass.eof DO
    BEGIN
        IF Edit2.text = Pass.GetValue('NOM') THEN
            BREAK;
        Pass.next;
    END;
    IF Edit2.text = Pass.GetValue('NOM') THEN
    BEGIN
        Edit3.Text := Pass.GetValue('IDCOURT');
        CheckBox2.Checked := Pass.GetValue('LOCATION') = 'OUI';
    END;
END;

END.

