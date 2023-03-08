UNIT Replic_frm;

INTERFACE

USES
    CstLaunch,
    idHTTP,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Dialogs;

TYPE
    Tfrm_replic = CLASS(TForm)
        OKBtn: TButton;
        Bevel1: TBevel;
        Lb_Repli: TListBox;
        Ed_Ping: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Ed_Push: TEdit;
        Ed_Pull: TEdit;
        Ed_Util: TEdit;
        Label4: TLabel;
        Ed_PWD: TEdit;
        Label5: TLabel;
        Bt_Ajout: TButton;
        Button1: TButton;
        Sb_Up: TSpeedButton;
        SB_Down: TSpeedButton;
        Button2: TButton;
        Label6: TLabel;
        Ed_Local: TEdit;
        Label7: TLabel;
        Ed_Distant: TEdit;
        Label8: TLabel;
        Label9: TLabel;
        Ed_EAI: TEdit;
        Ed_Base: TEdit;
        SpeedButton1: TSpeedButton;
        Od: TOpenDialog;
        Button3: TButton;
        PROCEDURE Lb_RepliClick(Sender: TObject);
        PROCEDURE Ed_PingChange(Sender: TObject);
        PROCEDURE Ed_PushChange(Sender: TObject);
        PROCEDURE Ed_PullChange(Sender: TObject);
        PROCEDURE Ed_UtilChange(Sender: TObject);
        PROCEDURE Ed_PWDChange(Sender: TObject);
        PROCEDURE Bt_AjoutClick(Sender: TObject);
        PROCEDURE Lb_RepliKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Sb_UpClick(Sender: TObject);
        PROCEDURE SB_DownClick(Sender: TObject);
        PROCEDURE Ed_EditExit(Sender: TObject);
        PROCEDURE Ed_LocalChange(Sender: TObject);
        PROCEDURE Ed_DistantChange(Sender: TObject);
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE Ed_EAIChange(Sender: TObject);
        PROCEDURE Ed_BaseChange(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
    PRIVATE
        PROCEDURE Met_Enabled(Valeur: Boolean);
        { Private declarations }
    PUBLIC
        { Public declarations }
        LaList: Tlist;
        PROCEDURE execute(List: Tlist);
    END;

    {
    VAR
        frm_replic: Tfrm_replic;
    }

IMPLEMENTATION

{$R *.DFM}

{ Tfrm_replic }

PROCEDURE Tfrm_replic.execute(List: Tlist);
VAR
    i: Integer;
BEGIN
    LaList := List;
    FOR i := 0 TO LaList.Count - 1 DO
    BEGIN
      IF TLesreplication(LaList[i]).Ordre >= 0 THEN
      BEGIN
        Lb_Repli.items.Add(TLesreplication(LaList[i]).URLDISTANT);
      END
      ELSE
      BEGIN
        Lb_Repli.items.Add(TLesreplication(LaList[i]).URLDISTANT);
      END;
    END;
    IF Lb_Repli.items.Count > 0 THEN
    BEGIN
        Lb_Repli.itemIndex := 0;
    END;
    Lb_RepliClick(NIL);
    ShowModal;
END;

PROCEDURE Tfrm_replic.Met_Enabled(Valeur: Boolean);
BEGIN
    ed_ping.Enabled := Valeur;
    Ed_Push.Enabled := Valeur;
    Ed_Pull.Enabled := Valeur;
    Ed_Util.Enabled := Valeur;
    Ed_PWD.Enabled := Valeur;
    Ed_Local.Enabled := Valeur;
    Ed_Distant.Enabled := Valeur;
    Ed_eai.Enabled := Valeur;
    Ed_Base.Enabled := Valeur;
    Button3.Enabled := Valeur;
    Button2.Enabled := Valeur;
    SpeedButton1.Enabled := Valeur;
    Button1.Enabled := Valeur;
END;

PROCEDURE Tfrm_replic.Lb_RepliClick(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        Met_Enabled(true);
        ed_ping.text := TLesreplication(LaList[Lb_Repli.itemIndex]).Ping;
        Ed_Push.text := TLesreplication(LaList[Lb_Repli.itemIndex]).Push;
        Ed_Pull.text := TLesreplication(LaList[Lb_Repli.itemIndex]).Pull;
        Ed_Util.text := TLesreplication(LaList[Lb_Repli.itemIndex]).User;
        Ed_PWD.text := TLesreplication(LaList[Lb_Repli.itemIndex]).Pwd;
        Ed_Local.text := TLesreplication(LaList[Lb_Repli.itemIndex]).URLLocal;
        Ed_Distant.text := TLesreplication(LaList[Lb_Repli.itemIndex]).URLDISTANT;
        Ed_eai.text := TLesreplication(LaList[Lb_Repli.itemIndex]).PlaceEai;
        Ed_Base.text := TLesreplication(LaList[Lb_Repli.itemIndex]).PlaceBase;
    END
    ELSE
    BEGIN
        Met_Enabled(False);
    END;
END;

PROCEDURE Tfrm_replic.Ed_PingChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).Ping := ed_ping.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_PushChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).Push := ed_Push.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_PullChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).Pull := ed_Pull.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_UtilChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).User := ed_Util.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_PWDChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).PWD := ed_PWD.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Bt_AjoutClick(Sender: TObject);
VAR
    repli: TLesreplication;
BEGIN
    repli := TLesreplication.Create;
    repli.id := -1;
    IF Lalist.count = 0 THEN
        repli.Ordre := 1
    ELSE
        repli.Ordre := TLesreplication(Lalist[Lalist.Count - 1]).Ordre + 1;
    repli.Change := true;
    Lalist.Add(repli);
    Lb_Repli.items.Add(repli.Ping);
    Lb_Repli.ItemIndex := Lb_Repli.items.count - 1;
    Lb_RepliClick(NIL);
    Ed_Ping.Text := 'Ping';
    Ed_Push.Text := 'Push';
    Ed_Pull.Text := 'PullSubscription';
    Ed_Local.Text := 'http://localhost:668/DelosEaiBin/DelosQPMAgent.dll/';
    Ed_Local.SetFocus;
END;

PROCEDURE Tfrm_replic.Lb_RepliKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    IF key = VK_DELETE THEN
    BEGIN
        IF Lb_Repli.itemIndex >= 0 THEN
        BEGIN
            Lb_Repli.items[Lb_Repli.itemIndex] := '(Supprimé) ' + TLesreplication(Lalist[Lalist.Count - 1]).URLDISTANT;
            TLesreplication(Lalist[Lalist.Count - 1]).Supp := true;
        END;
        Key := 0;
    END;
END;

PROCEDURE Tfrm_replic.Button1Click(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(Lalist[Lalist.Count - 1]).Supp := False;
        Lb_Repli.items[Lb_Repli.itemIndex] := TLesreplication(Lalist[Lalist.Count - 1]).Ping;
    END;
END;

PROCEDURE Tfrm_replic.Sb_UpClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lb_Repli.ItemIndex > 0 THEN
    BEGIN
        i := Lb_Repli.ItemIndex;
        Lb_Repli.items.Exchange(I, i - 1);
        Lalist.Exchange(i, I - 1);
        TLesreplication(Lalist[i]).Change := true;
        TLesreplication(Lalist[i - 1]).Change := true;
        OldOrdre := TLesreplication(Lalist[i]).Ordre;
        TLesreplication(Lalist[i]).Ordre := TLesreplication(Lalist[i - 1]).Ordre;
        TLesreplication(Lalist[i - 1]).Ordre := OldOrdre;
        Lb_Repli.ItemIndex := i - 1;
    END;
END;

PROCEDURE Tfrm_replic.SB_DownClick(Sender: TObject);
VAR
    i: integer;
    OldOrdre: Integer;
BEGIN
    IF Lb_Repli.ItemIndex < Lb_Repli.Items.Count - 1 THEN
    BEGIN
        i := Lb_Repli.ItemIndex;
        Lb_Repli.items.Exchange(I, i + 1);
        Lalist.Exchange(i, I + 1);
        TLesreplication(Lalist[i]).Change := true;
        TLesreplication(Lalist[i + 1]).Change := true;
        OldOrdre := TLesreplication(Lalist[i]).Ordre;
        TLesreplication(Lalist[i]).Ordre := TLesreplication(Lalist[i + 1]).Ordre;
        TLesreplication(Lalist[i + 1]).Ordre := OldOrdre;
        Lb_Repli.ItemIndex := i + 1;
    END;
END;

PROCEDURE Tfrm_replic.Ed_EditExit(Sender: TObject);
VAR
    S: STRING;
BEGIN
    S := Tedit(Sender).Text;
    IF pos('\', S) > 0 THEN
    BEGIN
        WHILE pos('\', S) > 0 DO
            S[pos('\', S)] := '/';
        Tedit(Sender).Text := S;
    END;
    IF (length(S) > 0) AND (S[length(S)] <> '/') THEN
    BEGIN
        S := S + '/';
        Tedit(Sender).Text := S;
    END;
END;

PROCEDURE Tfrm_replic.Ed_LocalChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).URLLocal := Ed_Local.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_DistantChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).URLDISTANT := Ed_Distant.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;

        IF TLesreplication(LaList[Lb_Repli.itemIndex]).Supp THEN
            Lb_Repli.items[Lb_Repli.itemIndex] := '(Supprimé) ' + Ed_Distant.text
        ELSE
            Lb_Repli.items[Lb_Repli.itemIndex] := Ed_Distant.text;
    END
END;

PROCEDURE Tfrm_replic.SpeedButton1Click(Sender: TObject);
VAR
    S: STRING;
    tsl: tstringList;
    S1: STRING;
    i: Integer;
BEGIN
    IF Od.execute THEN
    BEGIN
        S := extractFilePath(Od.filename);
        IF S[length(S)] <> '\' THEN
            S := S + '\';
        IF fileexists(S + 'Delos_QpmAgent.exe') THEN
        BEGIN
            tsl := tstringList.create;
            TRY
                tsl.LoadFromFile(Od.filename);
                S1 := Uppercase(trim(tsl.Text));
                i := Pos('<NAME>SERVER NAME</NAME>', S1);
                IF i > 0 THEN
                BEGIN
                    i := I + length('<NAME>SERVER NAME</NAME>') - 1;
                    delete(S1, 1, i);
                    S1 := trim(S1);
                    I := Pos('<VALUE>', S1);
                    IF I > 0 THEN
                    BEGIN
                        I := I + Length('<VALUE>') - 1;
                        delete(S1, 1, i);
                        I := Pos('<', S1) - 1;
                        IF I > 0 THEN
                        BEGIN
                            S1 := Copy(S1, 1, i);
                            IF Pos('LOCALHOST:', Uppercase(S1)) = 1 THEN
                                Delete(S1, 1, Length('LOCALHOST:'));
                            ed_Base.Text := S1;
                            ed_eai.text := S;
                        END;
                    END;
                END;
            EXCEPT
            END;
            tsl.free;
        END;
    END;
END;

PROCEDURE Tfrm_replic.Ed_EAIChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).PlaceEai := Ed_eai.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Ed_BaseChange(Sender: TObject);
BEGIN
    IF Lb_Repli.itemIndex >= 0 THEN
    BEGIN
        TLesreplication(LaList[Lb_Repli.itemIndex]).PlaceBase := Ed_Base.text;
        TLesreplication(LaList[Lb_Repli.itemIndex]).Change := true;
    END
END;

PROCEDURE Tfrm_replic.Button3Click(Sender: TObject);
BEGIN
    IF Winexec(PAnsiChar(Ed_eai.text + 'Delos_QpmAgent.exe'), 0) < 32 THEN
        Application.MessageBox('Impossible de lancer Delos_QpmAgent.exe', 'Attention', Mb_Ok)
    ELSE
    BEGIN
        Sleep(1000);
        IF UnPing(Ed_Local.Text + Ed_Ping.text) THEN
            Application.MessageBox('Ping réussi', 'Ping', Mb_Ok)
        ELSE
            Application.MessageBox('Ping raté', 'Ping', Mb_Ok);
        ArretDelos;
    END;
END;

PROCEDURE Tfrm_replic.Button2Click(Sender: TObject);
BEGIN
    IF UnPing(Ed_Distant.Text + Ed_Ping.text) THEN
        Application.MessageBox('Ping réussi', 'Ping', Mb_Ok)
    ELSE
        Application.MessageBox('Ping raté', 'Ping', Mb_Ok);
END;

END.
