unit SplittageDossierLame_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.ComCtrls, UWMI, uSplit, Winapi.ShellAPI;

type
  TFrm_SplittageDossierLame = class(TForm)
    Panel1: TPanel;
    BOK: TBitBtn;
    Label4: TLabel;
    lbclient: TLabel;
    Label5: TLabel;
    teIBFile: TEdit;
    teNOM: TEdit;
    StatusBar: TStatusBar;
    ListView: TListView;
    teINSTANCE: TEdit;
    cbForceRecreate: TCheckBox;
    Panel2: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    rbMiniSplit: TRadioButton;
    rbsplitcomplet: TRadioButton;
    cbDEPOTFTP: TCheckBox;
    cbType: TComboBox;
    Label1: TLabel;
    procedure BOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FListBases  : TStringList;
    Flock       : Boolean;
    FRunning    : Boolean;
    FMonThread  : TSplitThread;
    FTmpFile    : string;
    FIBFile     : string;
    FSYMDSInfos : TSYMDSInfos;
    procedure SETSYMDSInfos(Value:TSYMDSInfos);
    procedure SetIBFile(Avalue:string);
    { Déclarations privées }
  public
    property IBFile   :string  read FIBFile write SetIBFile;
    property TMPFile  :string  read FTmpFile write FTMPFile;
    property SYMDSInfos:TSYMDSInfos read FSYMDSInfos Write SetSYMDSInfos;
    property ListBases :TStringList read FListBases;
    { Déclarations publiques }
  end;

var
  Frm_SplittageDossierLame: TFrm_SplittageDossierLame;

implementation

{$R *.dfm}

Uses uCommun,uDataMod;

procedure TFrm_SplittageDossierLame.SETSYMDSInfos(Value:TSYMDSInfos);
begin
    FSYMDSInfos:=Value;
    teINSTANCE.Text:=Value.ServiceName;
end;

procedure TFrm_SplittageDossierLame.BCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TFrm_SplittageDossierLame.BOKClick(Sender: TObject);
var ResInstallateur : TResourceStream;
    i:Integer;
    bNeedForce:boolean;
begin
  Flock:=true;
  BOK.Enabled:=false;
  BOK.Visible:=false;
  FTmpFile := CreateUniqueGUIDFileName(GetTmpDir,'','.tmp');
  FListBases.Clear;
  bNeedForce:=false;
  FRunning:=false;
  try
  for i:=0 to ListView.Items.Count-1 do
    begin
        if ListView.Items.Item[i].Checked then
          begin
              // On ajoute les SENDER
              FListBases.add(ListView.Items.Item[i].SubItems[5]);
              If (ListView.Items.Item[i].SubItems.Strings[1]<>'')
                then bNeedForce:=true;
          end;
    end;
  if (FListBases.Count=0)
    then
      begin
          MessageDlg('Veuillez choisir au moins une base.',  mtError, [mbOK], 0);
          Flock:=false;
          exit;
      end;

  if (bNeedForce and not(cbForceRecreate.Checked))
    then
      begin
          MessageDlg('Vous devez forcer la recréation des Noeuds.',  mtError, [mbOK], 0);
          Flock:=false;
          exit;
      end;

  ModalResult := mrOk;

  {
  FMonThread:=TSplitThread.Create(true,MyCallBack);
  FMonThread.sORIGINE_IB    := teIBFile.text;
  FMonThread.sCOPY_IB       := Format('%s\%s.ib.sav.tmp',[ExcludeTrailingPathDelimiter(ExtractFilePath(teIBFile.text)), teNOM.text]);
  FMonThread.sScriptFile    := FTmpFile;
  FMonThread.sBases         := FListBases.Text;
  FMonThread.SYMDSInfos     := FSYMDSInfos;
  FMonThread.Engine         := teNOM.text;
  FMonThread.bStopService   := true;
  FMonThread.bForceReCreate := cbForceRecreate.Checked;
  FMonThread.bSplit         := cbSplittage.Checked;
  FMonThread.bTriggerDiff   := false;  // False signifie qu'on ne calcul pas en différé (donc on calcul tout de suite)
  FMonThread.bDeleteSplitIBFile := cbDeleteIBAfterSplit.Checked;
  FMonThread.TypeArchive    := GetTypeArchive(cbTypeArchive.ItemIndex);
  FMonThread.ilevel         := GetLevelCompression(cbLevel.ItemIndex);
  try
     ResInstallateur := TResourceStream.Create(HInstance, 'cleanmaster2mags', RT_RCDATA);
     try
       ResInstallateur.SaveToFile(FTmpFile);
       finally
       ResInstallateur.Free();
     end;
     FMonThread.Start;
     FRunning:=true;
  except
    on e: Exception do
    begin
      Exit;
      FRunning:=false;
    end;
  end;
  }
  finally
    //
  end;
end;

procedure TFrm_SplittageDossierLame.Button1Click(Sender: TObject);
begin
      ShellExecute(0, nil, 'explorer.exe', PChar(ExcludeTrailingPathDelimiter(ExtractFilePath(teIBFile.text))), nil, SW_SHOWNORMAL)
end;

procedure TFrm_SplittageDossierLame.FormCreate(Sender: TObject);
begin
   FListBases := TStringList.Create;
end;

procedure TFrm_SplittageDossierLame.FormDestroy(Sender: TObject);
begin
    FListBases.Free;
//    DeleteFile(FTmpFile);
end;

procedure TFrm_SplittageDossierLame.SetIBFile(Avalue:string);
var aListeBases:TBases;
    i:integer;
    Item: TListItem;
    aEtat : TEtatNoeud;
begin
     FIBFile:=AValue;
     teIBFile.text:=AValue;
//     aListeBases:=TStringList.Create;
     try
       teNom.Text  := DataMod.GetNomPourNous(Avalue);
       aListeBases := DataMod.ListeBases(AValue);
       ListView.Clear;
       // on prend pas la base "0"
       for i:=1 to High(aListeBases) do
        begin
           Item := ListView.Items.Add;
           //----------------------
           Item.Caption:=Format('%d',[aListeBases[i].BAS_IDENT]);
           aEtat := DataMod.EtatNoeud(AValue,aListeBases[i].SYM_NODE);

           Item.SubItems.Add(aListeBases[i].SYM_NODE);

           case aEtat.SYNC_ENABLED of
            1: Item.SubItems.Add('Enregistré');
            0: Item.SubItems.Add('Ouvert');
            else
              Item.SubItems.Add('');
           end;

           {
           case aEtat.SYNC_MOD  of
            1: Item.SubItems.Add('Online/Serveur');
            2: Item.SubItems.Add('Offline');
            else
               Item.SubItems.Add('');
           end;
           }

           Item.SubItems.Add(aEtat.NODE_GROUP_ID);

           Item.SubItems.Add(aEtat.HEARTBEAT_TIME);
           // URL

           Item.SubItems.Add(aEtat.SYNC_URL);

           Item.SubItems.Add(aListeBases[i].BAS_SENDER);
//           Item.SubItems.Add(aListeBases[i]);
           Item.SubItems.Add(aListeBases[i].BAS_GUID);
        end;
     finally
//        aListeBases.Free;
     end;
end;








end.
