unit Frm_EASYIMPORT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uThreadImport, Vcl.ComCtrls,
  Vcl.ExtCtrls,Winapi.ShellAPI,System.IOUtils ;

type
  TTraitement = record
    TABLE        : string;
    Repertoire   : string;
  end;
  TTraitements = array Of TTraitement;

  TActiveIndex = record
    TABLE   : string;
    READY   : Boolean;
    STARTED : Boolean;
  end;
  TActiveIndexs = array Of TActiveIndex;


  TForm17 = class(TForm)
    sb: TStatusBar;
    TimerTps: TTimer;
    timIMPORT: TTimer;
    TimerAnalyseDir: TTimer;
    timReactivationGENERALE: TTimer;
    TimerReactiveParrallele: TTimer;
    mLog: TMemo;
    Panel1: TPanel;
    teBASE0: TEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure StatusCallBack(Const s:String);
    Procedure Status2CallBack(Const s:String);
    procedure CallBackReActive(Sender: TObject);
    procedure CallBackFinal(Sender: TObject);

    procedure CallBackDesactive(Sender: TObject);
    procedure CallBackImport(Sender: TObject);
    procedure timIMPORTTimer(Sender: TObject);
    procedure TimerAnalyseDirTimer(Sender: TObject);
    procedure timReactivationGENERALETimer(Sender: TObject);
    procedure TimerTpsTimer(Sender: TObject);
    procedure TimerReactiveParralleleTimer(Sender: TObject);
  private
   FIBFile        : string;
   FINACTIVE_ALL  : TThreadDesactivation;
   FACTIVE_ALL    : TThreadReactivation;


   FImportEnd     : Boolean;
   FImport        : TThreadImport;
   FPosition      : integer;
   FTraitements   : TTraitements;

   FACTIVE_TBIDX  : TThreadActiveIndex;
   FIDXActive   : TActiveIndexs;

   FK_REF   : boolean;
   FK_New   : boolean;

   FStart   : Cardinal;

   procedure LanceProchainImport();
   procedure LanceProchainReactiveParrallele();
   procedure CreationListeTraitements();
   procedure CreationListeDone();
   procedure LanceReActivationGenerale();
   procedure DoLog(aMsg:string);
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form17: TForm17;

implementation

{$R *.dfm}

Uses UCommun,UWMI;

procedure TForm17.DoLog(aMsg:string);
begin
    mLOG.Lines.Add(FormatDateTime('yyyy-dd-mm hh:nn:ss : ',Now()) + aMsg);
end;



procedure TForm17.LanceReActivationGenerale();
begin
    if not(Assigned(FACTIVE_ALL))
      then
        begin
          timReactivationGENERALE.Enabled:=false;
          FACTIVE_ALL := TThreadReactivation.Create(FIBFile,StatusCallBack,CallBackFinal);
          FACTIVE_ALL.Start;
        end;
end;


Procedure TForm17.StatusCallBack(Const s:String);
begin
  sb.Panels[1].Text  := s;
  DoLog(s);
end;

Procedure TForm17.Status2CallBack(Const s:String);
begin
  sb.Panels[2].Text  := s;
  DoLog('IDX' + s);
end;

procedure TForm17.timIMPORTTimer(Sender: TObject);
begin
  TimImport.Enabled:=false;
  if FPosition>=0 then
     LanceProchainImport();
end;

procedure TForm17.timReactivationGENERALETimer(Sender: TObject);
begin
  if FImportEnd and not(Assigned(FACTIVE_TBIDX))
    then
      begin
        LanceReActivationGenerale();
        exit;
      end;
end;

procedure TForm17.LanceProchainReactiveParrallele();
var i:integer;
begin
    if not(Assigned(FACTIVE_TBIDX))
      then
        begin
            For i:=Low(FIDXActive) to High(FIDXActive) do
              begin
                 if (FIDXActive[i].READY) and not(FIDXActive[i].STARTED)
                    then
                      begin
                        // timReactivationGENERALE.Enabled:=false;
                        // On stop le Parrallèle
                        TimerReactiveParrallele.Enabled:=False;
                        FACTIVE_TBIDX := TThreadActiveIndex.Create(FIBFile,FIDXActive[i].TABLE,Status2CallBack,CallBackReactive);
                        FIDXActive[i].STARTED:=true;
                        FACTIVE_TBIDX.Start;
                        Break;
                      end;
              end;
        end;
end;

procedure TForm17.TimerAnalyseDirTimer(Sender: TObject);
var vPattern:string;
    SearchResult:TSearchRec;
    vTaille:Integer;
    vDone : TTraitements;
    i,j: Integer;
    vK_REF : Boolean;
    vK_New : Boolean;
    vHST_AGR : Boolean;
    vMVT_AGR : Boolean;
begin
    // Toutes les 30 secondes on regarde....
    TimerAnalyseDir.Enabled:=false;
    // On réactialise la TABLE des Fichiers .done
    vPattern := Format('%s\ref\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
             vTaille := Length(vDone);
             SetLength(vDone,vTaille+1);
             vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
             vDone[vTaille].Repertoire := 'ref';
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\new\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
             vTaille := Length(vDone);
             SetLength(vDone,vTaille+1);
             vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
             vDone[vTaille].Repertoire := 'new';
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\agr\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
                vTaille := Length(vDone);
                SetLength(vDone,vTaille+1);
                vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
                vDone[vTaille].Repertoire := 'agr';
          until FindNext(searchResult) <> 0;
         FindClose(searchResult);
       end;
  //----------------------------------------------------------------------------
  // Vdone a désormais tous les fichiers .done
  for I := Low(vDone) to High(vDone) do
    begin
      if (vDone[i].TABLE='K') and (vDone[i].Repertoire='ref')
        then vK_REF := true;
      if (vDone[i].TABLE='K') and (vDone[i].Repertoire='new')
        then vK_New := true;
    end;
   if vK_REF and vK_New
     then
      begin
          FIDXActive[0].READY := true;
      end;
  for I := Low(vDone) to High(vDone) do
    begin
      if (vDone[i].TABLE='K') then
        Continue;

      for j := Low(FIDXActive) to High(FIDXActive) do
        if vDone[i].TABLE=FIDXActive[j].TABLE
          then FIDXActive[j].READY := true;
    end;

   TimerAnalyseDir.Enabled:=true;
end;


procedure TForm17.TimerReactiveParralleleTimer(Sender: TObject);
begin
  // TimerReactiveParrallele.Enabled:=False;
  // il faut que la désactivation soit passé
  if (FPosition>=0) and (CheckBox1.Checked) then
    LanceProchainReactiveParrallele();
end;

procedure TForm17.TimerTpsTimer(Sender: TObject);
var vDeltaS : double;
begin
   vDeltaS  := (GetTickCount - FStart)/1000;
   sb.Panels[0].Text  := SecondToTime(vDeltaS);
   sb.Refresh;
   Application.ProcessMessages;
end;

procedure TForm17.CreationListeDone();
begin
    SetLength(FIDXActive,9);
    FIDXActive[0].TABLE   := 'K';
    FIDXActive[0].READY   := False;
    FIDXActive[0].STARTED := false;

    FIDXActive[1].TABLE   := 'AGRMOUVEMENT';
    FIDXActive[1].READY   := False;
    FIDXActive[1].STARTED := false;

    FIDXActive[2].TABLE   := 'AGRHISTOSTOCK';
    FIDXActive[2].READY   := False;
    FIDXActive[2].STARTED := false;

    FIDXActive[3].TABLE   := 'ARTCODEBARRE';
    FIDXActive[3].READY   := False;
    FIDXActive[3].STARTED := false;

    FIDXActive[4].TABLE   := 'CLTCLIENT';
    FIDXActive[4].READY   := False;
    FIDXActive[4].STARTED := false;

    FIDXActive[5].TABLE   := 'GENIMPORT';
    FIDXActive[5].READY   := False;
    FIDXActive[5].STARTED := false;

    FIDXActive[6].TABLE   := 'CSHTICKET';
    FIDXActive[6].READY   := False;
    FIDXActive[6].STARTED := false;

    // peut de chance de passer....
    FIDXActive[7].TABLE   := 'CSHTICKETL';
    FIDXActive[7].READY   := False;
    FIDXActive[7].STARTED := false;

    FIDXActive[8].TABLE   := 'RECBRL';
    FIDXActive[8].READY   := False;
    FIDXActive[8].STARTED := false;


    (*

    // On réactialise la TABLE des Fichiers .done
    vPattern := Format('%s\ref\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
             vTaille := Length(vDone);
             SetLength(vDone,vTaille+1);
             vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
             vDone[vTaille].Repertoire := 'ref';
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\new\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
             vTaille := Length(vDone);
             SetLength(vDone,vTaille+1);
             vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
             vDone[vTaille].Repertoire := 'new';
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\agr\*.done',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
                vTaille := Length(vDone);
                SetLength(vDone,vTaille+1);
                vDone[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
                vDone[vTaille].Repertoire := 'agr';
          until FindNext(searchResult) <> 0;
         FindClose(searchResult);
       end;
  //----------------------------------------------------------------------------
  // Vdone a désormais tous les fichiers .done
  for I := Low(vDone) to High(vDone) do
    begin
      if (vDone[i].TABLE='K') and (vDone[i].Repertoire='ref')
        then FK_REF := true;
      if (vDone[i].TABLE='K') and (vDone[i].Repertoire='new')
        then FK_New := true;
      if (vDone[i].TABLE='AGRHISTOSTOCK')
        then FHST_AGR := true;
      if (vDone[i].TABLE='AGRMOUVEMENT')
        then FMVT_AGR := true;
    end;
*)



end;


procedure TForm17.CallBackFinal(Sender: TObject);
var vGINKOIA_PATH:string;
begin
  StatusCallBack('Terminé !');
  TimerTps.Enabled:=false;
  FACTIVE_ALL:=nil;
  // On lance le backuprestore
  if CheckBox2.Checked then
    begin
        vGINKOIA_PATH :=  IncludeTrailingPathDelimiter(TDirectory.GetParent(ExcludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(FIBFILE)))));
        IF FileExists(vGINKOIA_PATH + 'BackRest.Exe') THEN
        BEGIN
          StatusCallBack('Lancement du BackRest Mode AUTO');
          ShellExecute(Handle, 'Open', PWideChar(vGINKOIA_PATH + 'BackRest.Exe'), PWideChar('AUTO'), Nil, SW_SHOWDEFAULT);
          // Close(); on ferme pas
        end;
    end;
end;


procedure TForm17.CallBackDesactive(Sender: TObject);
begin
  if TThreadDesActivation(Sender).NbError=0 then
    begin
        StatusCallBack('OK');
        FINACTIVE_ALL := nil;
        FPosition := 0;
        timIMPORT.Enabled:=True;
    end;
end;

procedure TForm17.CallBackReactive(Sender: TObject);
var i:integer;
begin
  Status2CallBack('');
  FACTIVE_TBIDX := nil;
  // Si on a fini l'import il faut pas Relancer les Réactive....
  (* c'est pas à lui de faire ca
  if FImportEnd
    then
       begin
          LanceReActivationGenerale();
          exit;
       end;
  *)
  if FImportEnd
    then
      begin
          // On est théoriquement déjà a False...
          TimerReactiveParrallele.Enabled:=false;
          exit;
      end;

  // * On reparcours si c'est tout Started on arrete */
  For i:=Low(FIDXActive) to High(FIDXActive) do
     begin
        if not(FIDXActive[i].STARTED)   // (FIDXActive[i].READY) and il peuvent ne pas être prets....
           then
              begin
                 TimerReactiveParrallele.Enabled:=True;
                 // timReactivationGENERALE.Enabled:=True;
              end;
     end;
end;


procedure TForm17.CallBackImport(Sender: TObject);
begin
  FImport := nil;
  inc(FPosition);
  // Si on dépasse La Position High(FTraitements) alors c'est quon a fini les IMPORT
  if FPosition>High(FTraitements)
    then
      begin
         StatusCallBack('Import Terminé, Réactivation générale...');
         // Il faut arrendre la fin du Thread
         FImportEnd := true;
      end;
  if (FPosition>=Low(FTraitements)) and (FPosition<=High(FTraitements))
    then timIMPORT.Enabled:=True;
end;


procedure TForm17.Button1Click(Sender: TObject);
begin
  Button1.Enabled:=false;
  CheckBox1.Enabled:=False;

  TimerAnalyseDir.Enabled         := CheckBox1.Checked;
  TimerReactiveParrallele.Enabled := CheckBox1.Checked;


  FStart    := GetTickCount();
  TimerTps.Enabled := true;
  // FImport := TThreadImport.Create('K','ref',nil);
  FINACTIVE_ALL := TThreadDesactivation.Create(FIBFile,StatusCallBack,CallBackDesactive);
  FINACTIVE_ALL.Start;
end;


procedure TForm17.LanceProchainImport();
begin
    if not(Assigned(FImport)) and (FPosition>=Low(FTraitements)) and (FPosition<=High(FTraitements))
      then
        begin
          FImport := TThreadImport.Create(FTraitements[FPosition].TABLE,FTraitements[FPosition].Repertoire,StatusCallBack,CallBackImport);
          FImport.Start;
        end;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
   FIBFile := VGSE.Base0;
   teBASE0.Text := FIBFile;

   FINACTIVE_ALL := nil;
   FImportEnd    := false;
   FImport       := nil;
   FPosition     := -1;


   FACTIVE_TBIDX  := nil;
   FK_REF   := false;
   FK_New   := false;

   SetLength(FIDXActive,0);
   SetLength(FTraitements,0);
   CreationListeTraitements();
   CreationListeDone();
end;

procedure TForm17.CreationListeTraitements();
var vPattern:string;
    SearchResult:TSearchRec;
    vTaille:Integer;
begin
    SetLength(FTraitements,4);
    // On passe les Grosses tables en 1er.
    FTraitements[0].TABLE:='K';
    FTraitements[0].Repertoire:='REF';
    FTraitements[1].TABLE:='K';
    FTraitements[1].Repertoire:='NEW';
    FTraitements[2].TABLE:='AGRMOUVEMENT';
    FTraitements[2].Repertoire:='AGR';
    FTraitements[3].TABLE:='AGRHISTOSTOCK';
    FTraitements[3].Repertoire:='AGR';

    vPattern := Format('%s\ref\*.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
            if UpperCase(searchResult.Name)<>'K.CSV' then
              begin
                  vTaille := Length(FTraitements);
                  SetLength(FTraitements,vTaille+1);
                  FTraitements[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
                  FTraitements[vTaille].Repertoire := 'ref';
              end;
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\new\*.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
            if UpperCase(searchResult.Name)<>'K.CSV' then
              begin
                vTaille := Length(FTraitements);
                SetLength(FTraitements,vTaille+1);
                FTraitements[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
                FTraitements[vTaille].Repertoire := 'new';
              end;
          until FindNext(searchResult) <> 0;
        FindClose(searchResult);
       end;

    vPattern := Format('%s\agr\*.csv',[ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))]);
    if findfirst(vPattern, faAnyFile, searchResult) = 0 then
       begin
          repeat
            if (UpperCase(searchResult.Name)<>'AGRHISTOSTOCK.CSV') and
               (UpperCase(searchResult.Name)<>'AGRMOUVEMENT.CSV')
            then
              begin
                vTaille := Length(FTraitements);
                SetLength(FTraitements,vTaille+1);
                FTraitements[vTaille].TABLE      :=  ExtractFileNameEX(searchResult.Name);
                FTraitements[vTaille].Repertoire := 'agr';
              end;
          until FindNext(searchResult) <> 0;
         FindClose(searchResult);
       end;
end;





end.
