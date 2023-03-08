//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT EAI_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    AlgolStdFrm,
    SimpHTTP,       // Pour Push - Pull  Cogisoft
    Launch_Frm,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzPanel,
    fcStatusBar,
    RzBorder,
    LMDCustomComponent,
    LMDWndProcComponent,
    LMDFormShadow, StdCtrls, RzLabel, vgStndrt, RzLaunch, Db, dxmdaset,
  vgTools;

TYPE
    TFrm_EAI = CLASS ( TAlgolStdFrm )
    Bev_Dlg: TRzBorder;
    Pan_Btn: TRzPanel;
    SBtn_Cancel: TLMDSpeedButton;
    SBtn_Ok: TLMDSpeedButton;
    Lab_: TRzLabel;
    Exec_: TRzLauncher;
    MemD_Rapport: TdxMemData;
    MemD_Rapportdate: TDateField;
    MemD_RapportHeure: TTimeField;
    MemD_RapportType: TStringField;
    MemD_RapportModule: TStringField;
    Tim_Launch: TTimer;
    SBtn_Journal: TLMDSpeedButton;
    MemD_RapportidDate: TDateTimeField;
    Trd_: TvgThread;
    procedure AlgolStdFrmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SBtn_OkClick(Sender: TObject);
    procedure SBtn_CancelClick(Sender: TObject);
    procedure AlgolStdFrmCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure Tim_LaunchTimer(Sender: TObject);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure SBtn_JournalClick(Sender: TObject);
    procedure Trd_Execute(Sender: TObject);
    Private
    { Private declarations }
      LaDate, LHeure: TDateTime;
      Replic, Connexion: Boolean;
      Procedure Memo(LeType, LeModule: String);
    Protected
    { Protected declarations }
        FHTTPAgent: TSimpleHTTP;
        FHTTPPing: TSimpleHTTP;
        FUNCTION HTTPPost ( CONST URL, UserName, Password: STRING; Provider: STRING ) : STRING;
        // Pour Push - Pull  Cogisoft
    Public
    { Public declarations }
        CONSTRUCTOR Create ( AOwner: TComponent ) ; Override; // Pour Push - Pull  Cogisoft
        Function Push: integer;
        Function Pull: integer;
        Procedure Launch;
    Published

    END;

VAR
    Frm_EAI: TFrm_EAI;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
ResourceString
ErrEAI =  'Une erreur à eu lieu lors de la réplication de vos données!';
ErrPush= 'Erreur lors de ENVOI du module : ';
ErrPull= 'Erreur lors de la RECEPTION du module : ';
Donnee= ' - Données "';
DonneeEnvFin= '" envoyées !';
DonneeRecFin= '" reçues !';
Fin1='Envoi terminé avec succés';
Fin ='Récéption terminé avec succés';
ErrFin1='Echec lors de l'+#39+'envoi de vos données';
ErrFin='Echec lors de la récéption de vos données';
TitreLaunch='Lancement automatique de votre réplication !';

IMPLEMENTATION
{$R *.DFM}

USES StdUtils, VCLUtils, Rapport_Frm;
//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

CONSTRUCTOR TFrm_EAI.Create ( AOwner: TComponent ) ;
BEGIN
    INHERITED;
    FHTTPAgent := TSimpleHTTP.Create ( Self ) ;
    FHTTPPing  := TSimpleHTTP.Create ( Application ) ;
END;

FUNCTION TFrm_EAI.HTTPPost ( CONST URL, UserName, Password: STRING; Provider: STRING ) : STRING;
VAR
    ResultBody: TStringStream;
BEGIN
    ResultBody := TStringStream.Create ( '' ) ;
    TRY
        TRY
            FHTTPAgent.UserName := UserName;
            FHTTPAgent.Password := Password;
            FHTTPAgent.PostData.Clear;
      // requires at least one parameter

            FHTTPAgent.PostData.Values['Caller'] := Application.ExeName;
            FHTTPAgent.PostData.Values['Provider'] := Provider;
            FHTTPAgent.Post ( URL, ResultBody ) ;
        EXCEPT
//        ON E: Exception DO
//                RAISE Exception.CreateFmt ( 'HTTPPost - Cannot invoke http action (URL=%s)', [URL] ) ;
        END;
        Result := ResultBody.DataString;
{
    try
      Result := TXMLCursor.Create;
      if ResultBody.DataString = '' then
        Exit;
      Result.LoadXML(ResultBody.DataString);
    except on E: Exception do
      raise Exception.CreateFmt('HTTPPost - Cannot load result from http action (URL=%s)'#13#10'%s', [URL, ResultBody.DataString]);
    end;
}
    FINALLY
        ResultBody.Free;
    END;
END;

Function TFrm_EAI.Push: integer;
var str: String;
    nb, i, cpt :Integer;
BEGIN
  Result := 1;
 try
   str := ' ';
   //Push
   nb := PushPROV.Count;
   if ( nb <> 0) then
   begin
      // Lancer EAI si c'est pas en ligne
      Exec_.FileName := ExeEAI;
      Exec_.StartDir := PathEAI;
      Exec_.Launch;

      Replic := true;
      Lab_.Visible := True;
      delay(1000);
      for i:=0 to nb-1 do
      begin
           str := '';
           str := HTTPPost(PushURL,PushUSER,PushPASS,PushPROV.Strings[i]); //Remplacer les params de la fonction par les valeurs du fichier INI
           if (PosNext( str, 'error', 1) <> 0) then
           begin
                Memo('Envoi', ErrPush+PushPROV.Strings[i]);
                Result := -2;
                Replic := false;
                exit;
           end
           else
           begin
                Lab_.Caption := IntToStr(i+1)+Donnee+copy(PushPROV.Strings[i],0,PosNext ( PushPROV.Strings[i], '[', 0 )-1)+DonneeEnvFin;
                delay(1000);
                Memo('Envoi', copy(PushPROV.Strings[i],0,PosNext ( PushPROV.Strings[i], '[', 0 )-1));
           end;
      end;
      Result := 0;
   end;
   Lab_.Caption := Fin1;
  except
        Result := -3;
        Memo('Envoi',ErrEAI);
  end;
  Replic := False;
END;

Function TFrm_EAI.Pull: integer;
var str: String;
    nb, i :Integer;
BEGIN
  Result := 1;
  try
   str := ' ';
   //Pull
   nb := PullPROV.Count;
   if ( nb <> 0) then
   begin
      // Lancer EAI si c'est pas en ligne
      Exec_.FileName := ExeEAI;
      Exec_.StartDir := PathEAI;
      Exec_.Launch;
      Replic := True;
      Lab_.Visible := True;
      delay(1000);
      for i:=0 to nb-1 do
      begin
           str := '';
           str := HTTPPost(PullURL,PullUSER,PullPASS,PullPROV.Strings[i]); //Remplacer les params de la fonction par les valeurs du fichier INI
           if (PosNext( str, 'error', 1) <> 0) then
           begin
                Memo('Reception', ErrPull+PullPROV.Strings[i]);
                Result := -2;
                Replic := false;
                exit;
           end
           else
           begin
                Lab_.Caption := IntToStr(i+1)+Donnee+copy(PushPROV.Strings[i],0,PosNext ( PushPROV.Strings[i], '[', 0 )-1)+DonneeRecFin;
                delay(1000);
                Memo('Reception', copy(PullPROV.Strings[i],0,PosNext ( PullPROV.Strings[i], '[', 0 )-1));
           end;
      end;
      Result := 0;
   end;
   Lab_.Caption := Fin;
  except
        Result := -3;
        Memo('Reception',ErrEAI);
  end;
  Replic := false;
END;

Procedure TFrm_EAI.Memo(LeType, LeModule: String);
begin
     MemD_Rapport.Insert;
     MemD_Rapport.FieldByName('IdDate').AsDateTime := Now;
     MemD_Rapport.FieldByName('Date').AsDateTime := Date;
     MemD_Rapport.FieldByName('Heure').AsDateTime := Time;
     MemD_Rapport.FieldByName('Type').AsString := LeType;
     MemD_Rapport.FieldByName('Module').AsString := LeModule;
     MemD_Rapport.Post;
end;

Procedure TFrm_EAI.Launch;
begin
     Lab_.Caption := TitreLaunch;
     Tim_Launch.Enabled := true;
     if not Frm_EAI.visible then
        ShowModal;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TFrm_EAI.AlgolStdFrmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender );
        VK_F12: SBtn_OkClick ( Sender );
    END;
end;

procedure TFrm_EAI.SBtn_OkClick(Sender: TObject);
var res, Cpt: Integer;
begin
     // Inhiber les boutons
     SBtn_Cancel.Enabled := False;
     SBtn_Ok.Enabled := False;
     SBtn_Journal.Enabled := False;

     // Charger le rapport
     MemD_Rapport.Close;
     MemD_Rapport.LoadFromTextFile(PathEAI+'Rapport.txt');
     MemD_Rapport.Open;

     Connexion := False;
     if (URLPing='') then
     begin
         Memo('Envoi', 'Erreur : le Ping est vide');
         Lab_.Caption := ErrFin;
         SBtn_Journal.Enabled := True;
         // Sauve le Rapport
         MemD_Rapport.Filtered := True;
         MemD_Rapport.SaveToTextFile(PathEAI+'Rapport.txt');
         exit;
     end;

     Trd_.Suspended := False;
     Cpt := 1;
     While not Connexion do
     begin
          if (Cpt > 5) then Break;
          inc(Cpt);
          Delay(60000);
     end;
     // 5 min d'attente max pour verifier que le ping se lance et que la connexion est Ok

     if  Connexion then
     begin
         res := Push;      // lance le Push
         if res >= 0 then
         begin
            res := Pull;  // lance le Pull
            if res <> 0 then
               Lab_.Caption := ErrFin;
         end
         else Lab_.Caption := ErrFin1;

         // tue l'application DelosQPMAgent
         KillApp_Classe ('TfmDelosHTTPServer');
         Delay(5000);
     end
     else
     begin
         Memo('Envoi', 'Erreur : Pas de connexion');
         Lab_.Caption := ErrFin;
     end;

    // Termine le Ping
//    Tim_Ping.Enabled := False;
    Trd_.Suspended := True;

     // Sauve le Rapport
     MemD_Rapport.Filtered := True;
     MemD_Rapport.SaveToTextFile(PathEAI+'Rapport.txt');

     // Re active les boutons
     SBtn_Cancel.Enabled := True;
     SBtn_Ok.Enabled := True;
     SBtn_Journal.Enabled := True;
end;

procedure TFrm_EAI.SBtn_CancelClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

procedure TFrm_EAI.AlgolStdFrmCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
     CanClose := not Replic;
end;

procedure TFrm_EAI.Tim_LaunchTimer(Sender: TObject);
begin
     Tim_Launch.Enabled := False;
     SBtn_Ok.Click;
end;

procedure TFrm_EAI.AlgolStdFrmCreate(Sender: TObject);
begin
     Replic := false;
end;

procedure TFrm_EAI.SBtn_JournalClick(Sender: TObject);
begin
     Frm_Rapport.Execute;
end;

procedure TFrm_EAI.Trd_Execute(Sender: TObject);
begin
     // créer la Frm_Timer
//     Frm_Timer := TFrm_Timer.create(Application);
//     Frm_Timer.Tim_PingTimer(Sender);
end;

END.

