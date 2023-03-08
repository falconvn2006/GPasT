unit GroupedItems1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.ImgList, System.Actions,
  Vcl.ActnList, Vcl.Touch.GestureMgr, Vcl.ComCtrls, IdBaseComponent, UajaxThread,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, UWeb,System.Generics.Collections, System.JSON, inifiles;

type
  TGridForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    GroupPanel1: TPanel;
    ScrollBox2: TScrollBox;
    AppBar: TPanel;
    Image11: TImage;
    FlowPanel: TFlowPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Timer1: TTimer;
    Image6: TImage;
    procedure GroupPanel1_1Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Detail_Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure MyTimer;
    procedure MyEvent(Sender:Tobject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FTuiles : TObjectList<TTuile>;
    FNbTuiles : integer;
    FUrl      : string;
    FUser     : string;
    FPassword : string;
    Fuid      : string;
    procedure Creation_abonnement;
    procedure AppBarResize;
    procedure AppBarShow(mode: integer);
    procedure TuileClick(Sender: TObject);
    procedure LoadIni;
    procedure SaveIni;
    procedure ItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Creation_Session;
  public  // chaîne de groupe depuis
    procedure CreationTuiles;
    procedure RefreshTuiles;
    property Tuiles : TObjectList<TTuile> read FTuiles write FTuiles;
    property Url      : string read FUrl      write FUrl;
    property User     : string read FUser     write Fuser;
    property Password : string read Fpassword write Fpassword;
  end;

var
  GridForm: TGridForm;

implementation

{$R *.dfm}

uses ItemDetail1, ItemParam, MasterParam;

const
  AppBarHeight = 75;

procedure TGridForm.AppBarResize;
begin
//  AppBar.SetBounds(0, AppBar.Parent.Height - AppBarHeight,
//    AppBar.Parent.Width, AppBarHeight);
end;

procedure TGridForm.AppBarShow(mode: integer);
begin
{  if mode = -1 then // Basculer
    mode := integer(not AppBar.Visible );

  if mode = 0 then
    AppBar.Visible := False
  else
  begin
    AppBar.Visible := True;
    AppBar.BringToFront;
  end;
  }
end;

procedure TGridForm.Action1Execute(Sender: TObject);
begin
//  AppBarShow(-1);
end;

procedure TGridForm.SaveIni;
var Atuile:TTuile;
    iniFile:TIniFile;
    i:integer;
begin
     IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
     Try
        IniFile.WriteInteger('GENERAL','nbtuiles',Tuiles.Count) ;
        IniFile.WriteString('GENERAL','url',Url);
        IniFile.WriteString('GENERAL','user',User) ;
        IniFile.Writestring('GENERAL','password',Password) ;
        for i := 0 to Tuiles.Count-1 do
          begin
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'Nom' ,  Tuiles.Items[i].Nom);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'host',  Tuiles.Items[i].host);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'app' ,  Tuiles.Items[i].App);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'mdl' ,  Tuiles.Items[i].Mdl);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'inst',  Tuiles.Items[i].inst);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'ref' ,  Tuiles.Items[i].Ref);
              IniFile.Writestring(Format('TUILE_%d',[i+1]),'key' ,  Tuiles.Items[i].key);
              IniFile.Writeinteger(Format('TUILE_%d',[i+1]),'freq', Tuiles.Items[i].freq);
          end;
     Finally
        IniFile.Free;
     End;
end;

procedure TGridForm.LoadIni;
var Atuile:TTuile;
    iniFile:TIniFile;
    i:integer;
begin
     IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
     Tuiles:=TObjectList<TTuile>.Create();
     Try
        FNbTuiles := IniFile.ReadInteger('GENERAL','nbtuiles',0) ;
        Url      := IniFile.ReadString('GENERAL','url','') ;
        User     := IniFile.ReadString('GENERAL','user','') ;
        Password := IniFile.ReadString('GENERAL','password','') ;
        for i := 0 to FNbTuiles-1 do
          begin
              ATuile:=TTuile.Create(Format('TUILE_%d',[i+1]));
              ATuile.Titre := IniFile.Readstring(Format('TUILE_%d',[i+1]),'Nom','');
              ATuile.Host  := IniFile.Readstring(Format('TUILE_%d',[i+1]),'host','');
              ATuile.App   := IniFile.Readstring(Format('TUILE_%d',[i+1]),'app','');
              ATuile.Mdl   := IniFile.Readstring(Format('TUILE_%d',[i+1]),'mdl','');
              ATuile.inst  := IniFile.Readstring(Format('TUILE_%d',[i+1]),'inst','');
              ATuile.Ref   := IniFile.Readstring(Format('TUILE_%d',[i+1]),'ref','');
              ATuile.Key   := IniFile.Readstring(Format('TUILE_%d',[i+1]),'key','');
              ATuile.freq  := IniFile.Readinteger(Format('TUILE_%d',[i+1]),'freq',5);
              ATuile.Cur   := ATuile.freq;
              ATuile.Tag   := format('tuile_%d',[i]);
             // ATuile.Color:=ClMonitor_Blue;
              ATuile.Value:='0';
              Tuiles.Add(ATuile);
          end;
     Finally
        IniFile.Free;
     End;
end;


procedure TGridForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    SaveIni;
    CanClose:=true;
end;

procedure TGridForm.FormCreate(Sender: TObject);

begin
    FUid:='';
    LoadIni;
    CreationTuiles;
    Creation_Session;
end;

procedure TGridForm.FormDestroy(Sender: TObject);
begin
    FTuiles.Free;
end;

procedure TGridForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  AppBarShow(0);
end;

procedure TGridForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    AppBarShow(-1)
  else
    AppBarShow(0);
end;

procedure TGridForm.FormResize(Sender: TObject);
begin
  AppBarResize;
end;

procedure TGridForm.FormShow(Sender: TObject);
begin
  AppBarShow(0);
end;

procedure TGridForm.GroupPanel1_1Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
  if not Assigned(DetailForm) then
    DetailForm := TDetailForm.Create(Self);
  DetailForm.Show;
  DetailForm.BringToFront;
end;

procedure TGridForm.Detail_Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
  if not Assigned(DetailForm) then
    DetailForm := TDetailForm.Create(Self);
  DetailForm.Show;
  DetailForm.BringToFront;
end;


procedure TGridForm.Image11Click(Sender: TObject);
begin
  Close;
end;

procedure TGridForm.Image1Click(Sender: TObject);
begin
  //
end;

procedure TGridForm.Creation_Session;
var StrJson  : string;
    LJsonObj : TJSONObject;
begin
    StrJson := GetURLAsString(Format('%s/login.php',[Url]),format('{"login":"%s","password":"%s"}',[user,password]));
    LJsonObj    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(StrJson),0) as TJSONObject;
    try
       FUid:=(LJsonObj.Get('uid').JsonValue).Value;
       Image1.Hint:=FUid;
       Creation_abonnement;
    finally
       LJsonObj.Free;
    end;
end;

procedure TGridForm.Image2Click(Sender: TObject);
begin
  if not Assigned(MasterParamForm) then
    MasterParamForm := TMasterParamForm.Create(Self);
  MasterParamForm.eurl.text:=Url;
  MasterParamForm.euser.Text:=user;
  MasterParamForm.epassword.Text:=Password;
  MasterParamForm.Show;
  MasterParamForm.BringToFront;
end;

procedure TGridForm.Creation_abonnement;
var i:integer;
    StrJson:string;
    strresult:string;
begin
  if FUid<>'' then
    begin
       For i:=0 to Tuiles.Count-1 do
          begin
              StrJson := format('{"uid":"%s","nom":"%s","host":"%s","app":"%s","inst":"%s","mdl":"%s","ref":"%s","key":"%s","tag":"%s"}',
                  [FUid,Tuiles.Items[i].Nom,Tuiles.Items[i].host,Tuiles.Items[i].app,
                  Tuiles.Items[i].inst,Tuiles.Items[i].mdl,Tuiles.Items[i].ref,Tuiles.Items[i].key,
                  Tuiles.Items[i].Tag]);
               Strresult:= GetURLAsString(Format('%s/abonnement.php',[Url]),StrJson);
          end;
    end;
end;



procedure TGridForm.Image3Click(Sender: TObject);
begin
    Timer1.Enabled:=true;
end;

procedure TGridForm.Image4Click(Sender: TObject);
begin
    Timer1.Enabled:=false;
end;

procedure TGridForm.Image6Click(Sender: TObject);
begin
  if not Assigned(ItemParamForm) then
    ItemParamForm := TItemParamForm.Create(Self);
  ItemParamForm.Init(nil);
  ItemParamForm.Show;
end;

procedure TGridForm.MyTimer;
var FAjax:TAjaxThread;
    i:integer;
begin
     if Fuid<>'' then
       begin
           For i:=0 to tuiles.Count-1 do
            begin
               dec(TTuile(Tuiles.Items[i]).Cur);
               if ((TTuile(Tuiles.Items[i]).Cur)<=0) then
                  begin
                       FAjax:=TAjaxThread.Create(Format('%s/index.php',[Url]),Format('{"uid":"%s","tag":"%s"}',[Fuid,tuiles.items[i].tag]),MyEvent);
                       FAjax.Resume;
                       TTuile(Tuiles.Items[i]).Cur:=TTuile(Tuiles.Items[i]).Freq;
                  end;
            end;
      end;
End;


procedure TGridForm.MyEvent(Sender:Tobject);
var i:integer;
    json:string;
    LJsonObj : TJSONObject;
    tag,value,color:string;
begin
     json:=TAjaxThread(Sender).Datas;
     // Il faut parser maintenant
     LJsonObj    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(json),0) as TJSONObject;
     try
       tag   := (LJsonObj.Get('tag').JsonValue).Value;
       value := (LJsonObj.Get('value').JsonValue).Value;
       color := (LJsonObj.Get('color').JsonValue).Value;
       For i:=0 to Tuiles.Count-1 do
          begin
            if TTuile(Tuiles.items[i]).Tag=tag
                then
                    begin
                        Tuiles.items[i].Value:=value;
                        Tuiles.items[i].Need_Refresh:=true;
                        Tuiles.items[i].Color:=HexToTColor(color);
                    end;
          end;
    finally
       LJsonObj.Free;
    end;
     // refresh desd tuilles;
end;

procedure TGridForm.RefreshTuiles;
var i:integer;
    AComponent : TComponent;
begin
     For i:=0 to Tuiles.Count-1 do
        begin
            if Tuiles.items[i].Need_Refresh then
              begin
                  AComponent := FindComponent(format('tuile_%d_value',[i]));
                  TLabel(AComponent).Caption:=FTuiles.Items[i].Value;
                  TPanel(TLabel(AComponent).Parent).Color:=FTuiles.Items[i].Color;
                  Tuiles.items[i].Need_Refresh:=false;
              end;
        end;
end;

procedure TGridForm.CreationTuiles();
var APanel:TPanel;
    ALabel_Title:TLabel;
    ALabel_Value:TLabel;
    i:integer;
begin
    for i:=FlowPanel.ControlCount-1 downto 0 do
        FlowPanel.Controls[i].Destroy;
    For i:=0 to Tuiles.Count-1 do
      begin
        APanel:=TPanel.Create(self);
        APanel.Parent:=FlowPanel;
        APanel.Align:=AlLeft;
        APanel.Color:=TTuile(Tuiles.items[i]).Color;
        APanel.Width:=230;
        APanel.Height:=240;
        APanel.AlignWithMargins:=true;
        APanel.BevelOuter:=bvNone;

        ALabel_Title:=TLabel.Create(Self);
        ALabel_Title.Parent:=APanel;
        ALabel_Title.Align:=AlTop;
        ALabel_Title.Alignment:=taCenter;
        ALabel_Title.Caption:=TTuile(Tuiles.items[i]).Titre;
        ALabel_Title.Font.Color:=ClWhite;
        ALabel_Title.Font.Height:=30;

        ALabel_Value:=TLabel.Create(Self);
        ALabel_Value.Name:=Format('tuile_%d_value',[i]);
        ALabel_Value.Parent:=APanel;
        ALabel_Value.Align:=AlClient;
        ALabel_Value.Alignment:=taCenter;
        ALabel_Value.Caption:=TTuile(Tuiles.items[i]).Value;
        ALabel_Value.Font.Color:=ClWhite;
        ALabel_Value.Font.Height:=150;
        ALabel_Value.OnClick:=TuileClick;
        ALabel_Value.Tag:=1000+i;
        ALabel_Value.OnMouseDown:=ItemMouseDown;
      end;
end;

procedure TGridForm.Timer1Timer(Sender: TObject);
begin
    if Visible then
      begin
         MyTimer;
         RefreshTuiles;
      end;
end;

procedure TGridForm.TuileClick(Sender: TObject);
begin
     Detail_Click(Sender);
end;

procedure TGridForm.ItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
  if Button = mbRight then
    begin
        if not Assigned(ItemParamForm) then
          ItemParamForm := TItemParamForm.Create(Self);
        //----------------------------------------------------------------------
        i:=TLabel(Sender).tag - 1000;
        ItemParamForm.Init(Tuiles.items[i]);
        ItemParamForm.id:=i;
        Hide;
        ItemParamForm.Show;
        // ItemParamForm.BringToFront;
    end;
    //
end;


procedure TGridForm.Label1Click(Sender: TObject);
var a:string;
begin
//     Label1.Caption:=GetURLAsString('http://192.168.10.74/monitor/index.php','{"login":"toto",password:"titi"}');
end;

end.
