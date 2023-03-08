unit MainEasyRecupBase_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uEasy.Threads,
  Vcl.ComCtrls, Vcl.ExtCtrls, dxGDIPlusClasses{, dxGDIPlusClasses};


type
  TFrmMainEasyRecupBase = class(TForm)
    teTOTOFile: TEdit;
    BTOTO: TButton;
    sb: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    teIBBASE0: TEdit;
    mLog: TMemo;
    edtGENERAL_ID: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtPLAGE: TEdit;
    Label5: TLabel;
    teSENDER: TEdit;
    Label6: TLabel;
    teBAS_IDENT: TEdit;
    Label7: TLabel;
    teSERVERTOTOFILE: TEdit;
    tim1: TTimer;
    teFreeSpace: TEdit;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    BDETAILS: TButton;
    Image2: TImage;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure BTOTOClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tim1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BDETAILSClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMODE        : string;
    FLock        : Boolean;  // traitement en cours
    FIBVersion   : string;
    FIBPath      : string;
    FIBService   : Boolean;
    FIBStarted   : Boolean;
    FEASYService : Boolean;
    FGENID       : integer;
    FEasyClean   : TScriptCleanSYMDS;
    FStart       : Cardinal;
    procedure FormOpening();
    procedure ParamScreen();
    procedure ReCenter();
    Procedure AddLog(Const s:String);
    procedure CallBackClean(Sender:TObject);
    Procedure StatusCallBack(Const s:String);
    Procedure SetMODE(avalue:string);
    { Déclarations privées }
  public
    property mode : string read FMODE write SetMODE;
    { Déclarations publiques }
  end;

var
  FrmMainEasyRecupBase: TFrmMainEasyRecupBase;

implementation

{$R *.dfm}

Uses LaunchProcess, UCommun, SymmetricDS.Commun, uDataMod,ServiceControler,uEasy.Types;


Procedure TFrmMainEasyRecupBase.AddLog(Const s:String);
begin
  mLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss : ',Now()) + s);
end;

Procedure TFrmMainEasyRecupBase.StatusCallBack(Const s:String);
begin
  sb.Panels[1].Text  := s;
  AddLog(s);
end;

procedure TFrmMainEasyRecupBase.tim1Timer(Sender: TObject);
begin
   tim1.Enabled:=false;
   try
     sb.Panels[0].Text := SecondToTime((GetTickCount-FStart)/1000) ;
   Finally
     tim1.Enabled:=true;
   end;

end;

procedure TFrmMainEasyRecupBase.CallBackClean(Sender:TObject);
begin
  FLock := false;
  tim1.Enabled:=False;
  if FEasyClean.NBError<>0 then
    begin
      StatusCallBack('Erreur !');
    end
    else
    begin
       if mode=CST_DEJAEASY
        then
          begin
              StatusCallBack('Terminé avec Succès... ');
              StatusCallBack('Veuillez aller dans le control Center de la lame');
              StatusCallBack(' 1-(Unregsitred) Supprimer  l''ancien noeud.');
              StatusCallBack(' 2-(Allow) Autoriser le nouveau noeud qui se présente à la place.');
              StatusCallBack(' 3-Attendre quelques minutes pour que la config se mette en place sur le nouveau noeud.');
          end;

       if mode=CST_DELOS2EASY
        then StatusCallBack('Terminé avec Succès : Vous pouvez lancer DELOS2EASY');
    end;

end;

procedure TFrmMainEasyRecupBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action:=caFree;
end;

procedure TFrmMainEasyRecupBase.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := not(FLock);
    if FLock then
      begin
        MessageDlg('Traitement en cours... ' + #13#10 +
          'Impossible de fermer le programme.',  mtError, [mbOK], 0);
      end;

end;


procedure TFrmMainEasyRecupBase.ReCenter();
var
  LRect: TRect;
  X, Y: Integer;
begin
  LRect := Screen.WorkAreaRect;
  X := LRect.Left + (LRect.Right - LRect.Left - Width) div 2;
  Y := LRect.Top + (LRect.Bottom - LRect.Top - Height) div 2;
  SetBounds(X, Y, Width, Height);
end;

procedure TFrmMainEasyRecupBase.ParamScreen();
begin
    if not(Panel1.Visible)
      then
          begin
             Self.Height := 275;
             BDETAILS.Caption:='Voir les détails';
          end
      else
        begin
            Self.Top := 100;
            Self.Height := 620;
            BDETAILS.Caption:='Cacher les détails';
        end;
  ReCenter();
end;

Procedure TFrmMainEasyRecupBase.SetMODE(avalue:string);
begin
  FMode := aValue;
  FormOpening();
end;

procedure TFrmMainEasyRecupBase.FormCreate(Sender: TObject);
begin
  FMODE := '';
end;

procedure TFrmMainEasyRecupBase.FormOpening();
var vBase0 : string;
    vInfos : TInfosDelosEASY;
    i:Integer;
    vTempStr:string;
    vEASYDir:string;
    vDELOS2EASy : string;
    vGENPARAMS : TGENParams;

    vRemoteTOTO : string;
    vFreeAvailable, vTotalSpace: Int64;
    vDrive : string;
    vIDrive : Integer;

begin
    FLock := false;
    ParamScreen();
    vBase0 := ReadBase0;

    if mode=CST_DEJAEASY
      then
        begin
          Label9.Caption := 'RecupBase avec EASY déjà présent';
          FEASYService  :=  ServiceExist('','EASY');
          If not(FEASYService)
              then
                begin
                  MessageDlg(PChar('Le service EASY existe déjà sur cette machine'),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
                end;

            vEASYDir := ExtractFilePath(vBase0)+'..\EASY';
            if not(DirectoryExists(vEASYDir)) then
              begin
                  MessageDlg(PChar('Le Répertoire d''EASY n''existe pas !'),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
              end;


            teIBBASE0.Text      := vBase0;
            FGENID              := DataMod.GetGENERAL_ID(vBase0);
            edtGENERAL_ID.Text  := FormatFloat(',0',FGENID);
            edtPLAGE.Text       := DataMod.GetPLAGE(teIBBASE0.Text);

            vInfos           := DataMod.Get_Infos_Passage_DELOS2EASY(teIBBASE0.Text);
            teSENDER.Text    := vInfos.SENDER;
            teBAS_IDENT.Text := vInfos.BAS_IDENT;


            if AnsiPos('-SEC',UpperCase(vInfos.SENDER))>1 then
              begin
                 // Ca peut etre une caisse de secours...
                 vGENParams := DataMod.Get_GENPARAMS(teIBBASE0.Text,Format('PRM_CODE=50 AND PRM_TYPE=11 AND PRM_POS=%s',[vInfos.BAS_IDENT]));
              end
             else
              begin
                  vGENParams := DataMod.Get_GENPARAMS(teIBBASE0.Text,Format('PRM_CODE=33 AND PRM_TYPE=3 AND PRM_POS=%s',[vInfos.BAS_IDENT]));
              end;

            if  (Length(vGENParams)=1) and (vGENParams[0].PRM_STRING<>'')
              then
               begin
                  vRemoteTOTO := StringReplace(UpperCase(vGENParams[0].PRM_STRING),'\SYNCHRO\GINKCOPY.IB','\BACKUP\GINKOIA.TOTO',[rfIgnoreCase,rfReplaceAll]);
                  teSERVERTOTOFILE.Text := vRemoteTOTO;
                  BTOTO.Enabled:=false;
                  BTOTO.Visible  :=false;
                  teTOTOFile.Color := clBtnFace;
                  teTOTOFile.Text := ExtractFilePath(vBase0) + FormatDateTime('yyyymmdd_hhnnsszzz',Now)+'.sav';
               end
              else
               begin
                   // il faut recup le TOTO
                   teSERVERTOTOFILE.Text := '';
                   BTOTO.Enabled:=true;
                   BTOTO.Visible:=true;
                   teTOTOFile.Color := clWindow;
               end;


        end;
    if mode=CST_DELOS2EASY
      then
        begin
            FEASYService  :=  ServiceExist('','EASY');
            If FEASYService
              then
                begin
                  MessageDlg(PChar('Le service EASY existe déjà sur cette machine'),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
                end;

            FIBService   := ServiceExist('','IBS_gds_db') and ServiceExist('','IBG_gds_db');
            FIBStarted   := (ServiceGetStatus('','IBS_gds_db')=4) and (ServiceGetStatus('','IBG_gds_db')=4);
            vTempStr:=InfoService('IBS_gds_db');
            i:=Pos('\bin\ibserver.exe',vTempStr,1);
            if i>0 then
              begin
                vTempStr:=Copy(vTempStr,0,i+16);
              end;
            FIBVersion := GetFileVersion(vTempStr);
            FIBPath    := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(vTempStr)));


            If not(PoseUDF(FIBPath))
              then
                begin
                  MessageDlg(PChar(Format('Fichier %s absent !', ['sym_udf.dll'])),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
                end;

            if not(FileExists(vBase0)) then
              begin
                  MessageDlg(PChar(Format('Fichier %s absent !', [vBase0])),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
              end;

            vEASYDir := ExtractFilePath(vBase0)+'..\EASY';

            if DirectoryExists(vEASYDir) then
              begin
                  MessageDlg(PChar('Le Répertoire d''EASY existe déjà !'),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
              end;

            vDELOS2EASy := ExtractFilePath(vBase0)+ 'DELOS2EASY.IB';

            if FileExists(vDELOS2EASy) then
              begin
                  MessageDlg(PChar('Le fichier DELOS2EASY.IB existe déjà !'),  mtError,
                    [mbOK], 0);
                  Application.Terminate;
                  exit;
              end;


            teIBBASE0.Text      := vBase0;
            FGENID              := DataMod.GetGENERAL_ID(vBase0);
            edtGENERAL_ID.Text  := FormatFloat(',0',FGENID);
            edtPLAGE.Text       := DataMod.GetPLAGE(teIBBASE0.Text);

            vInfos           := DataMod.Get_Infos_Passage_DELOS2EASY(teIBBASE0.Text);
            teSENDER.Text    := vInfos.SENDER;
            teBAS_IDENT.Text := vInfos.BAS_IDENT;
            // --- Recup de quelques GENPARAM...
            vGENParams := DataMod.Get_GENPARAMS(teIBBASE0.Text,Format('PRM_CODE=33 AND PRM_TYPE=3 AND PRM_POS=%s',[vInfos.BAS_IDENT]));


            if (Length(vGENParams)=1) and (vGENParams[0].PRM_STRING<>'')
              then
               begin
                  vRemoteTOTO := StringReplace(UpperCase(vGENParams[0].PRM_STRING),'\SYNCHRO\GINKCOPY.IB','\BACKUP\GINKOIA.TOTO',[rfIgnoreCase,rfReplaceAll]);
                  teSERVERTOTOFILE.Text := vRemoteTOTO;
                  BTOTO.Enabled:=false;
                  BTOTO.Visible  :=false;
                  teTOTOFile.Color := clBtnFace;
                  teTOTOFile.Text := ExtractFilePath(vBase0) + FormatDateTime('yyyymmdd_hhnnsszzz',Now)+'.sav';
               end
              else
                begin
                  // il faut recup le TOTO
                   teSERVERTOTOFILE.Text := '';
                   BTOTO.Enabled:=true;
                   BTOTO.Visible:=true;
                   teTOTOFile.Color := clWindow;
               end;
        end;
   // place dispo sur la lettre
   //lettre de "BASE0"
   vDrive := Uppercase(ExtractFileDrive(vBase0));  // ca doit etre C: ou D:
   Label8.Caption := Format('Espace sur %s',[vDrive]);

   vIDrive := Ord(vDrive[1])-64; // car en ASCII A=65


   vFreeAvailable   := DiskFree(vIDrive); // 0 c'est current, 1=A etc....
   teFreeSpace.Text := FormatFloat(',0 Mo',(vFreeAvailable div 1024) div 1024);
end;

procedure TFrmMainEasyRecupBase.Button1Click(Sender: TObject);
begin
   Button1.Enabled:=False;
   // 2 Modes possibles
   if (mode=CST_DEJAEASY)
     then
       begin
         If FileExists(teIBBASE0.Text) then
            begin
               FLock := true;
               FStart := GetTickCount;
               tim1.Enabled:=true;
               sb.Panels[1].Text:='Traitement en cours...';
               FEasyClean := TScriptCleanSYMDS.Create(mode,teSERVERTOTOFILE.Text, teTOTOFile.Text, FGENID ,StatusCallBack ,CallBackClean);
               FEasyClean.Start;
            end
       end;
   if (mode=CST_DELOS2EASY)
     then
       begin
         // MANUEL ou auto
         If FileExists(teIBBASE0.Text) then
            begin
               FLock := true;
               FStart := GetTickCount;
               tim1.Enabled:=true;
               sb.Panels[1].Text:='Traitement en cours...';
               FEasyClean := TScriptCleanSYMDS.Create(mode,teSERVERTOTOFILE.Text, teTOTOFile.Text, FGENID ,StatusCallBack ,CallBackClean);
               FEasyClean.Start;
            end
          else
            begin
               Button1.Enabled:=true;
               if not(FileExists(teIBBASE0.Text))
                then
                  begin
                    MessageDlg(PChar(Format('Fichier %s absent !', [teIBBASE0.Text])),  mtError,
                    [mbOK], 0);
                    exit;
                  end;
               if not(FileExists(teTOTOFile.Text))
                then
                  begin
                    MessageDlg(PChar(Format('Fichier %s absent !', [teTOTOFile.Text])),  mtError,
                    [mbOK], 0);
                    exit;
                  end;
            end;
       end;
end;

procedure TFrmMainEasyRecupBase.BDETAILSClick(Sender: TObject);
begin
  Panel1.Visible:=not(Panel1.Visible);
  ParamScreen;
end;

procedure TFrmMainEasyRecupBase.BTOTOClick(Sender: TObject);
var vOpenDialog : TOpenDialog;
begin
    vOpenDialog := TOpenDialog.Create(Self);
    try
      if vOpenDialog.Execute()
        then
            begin
              if UpperCase(vOpenDialog.FileName)=UpperCase(teIBBASE0.Text)
                then
                  begin
                      MessageDlg('Ca ne peut pas être la "base0"',  mtError,
                        [mbOK], 0);
                      Exit;
                  end
                else
                  begin
                      teTOTOFile.Text := vOpenDialog.FileName;
                  end;
            end;
    finally
      vOpenDialog.Free;
    end;
end;

end.
