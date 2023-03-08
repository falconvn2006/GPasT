unit UnitPrincipal;

interface

uses
//  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
//  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
//  FMX.Layouts, FMX.TabControl, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
//  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
//  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, FMX.Maps, FMX.Ani,
//  FMX.Effects, FMX.Calendar, FMX.WebBrowser, FMX.DateTimeCtrls
//
//
//  {$IFDEF ANDROID}
//  ,System.IOUtils
//  ,Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,
//  Androidapi.JNI.Net, Androidapi.Helpers, FMX.Helpers.android,
//  System.ImageList, FMX.ImgList, FMX.Objects
//  {$ENDIF}
//
//  ,FMX.Objects
//  ;

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  System.IOUtils

  {$IFDEF ANDROID}
  ,Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net, Androidapi.Helpers, FMX.Helpers.android,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Ani, FMX.Maps, FMX.WebBrowser, FMX.Edit, FMX.DateTimeCtrls, FMX.Effects,
  FMX.ListView, FMX.TabControl
  {$ENDIF}


  ;


type
  TFrmPrincipal = class(TForm)
    lytBotoes: TLayout;
    img_aba1: TImage;
    img_aba2: TImage;
    img_aba3: TImage;
    img_aba4: TImage;
    TabControl: TTabControl;
    TabAba6: TTabItem;
    TabAba1: TTabItem;
    TabAba3: TTabItem;
    TabAba4: TTabItem;
    lv_explorar: TListView;
    Line5: TLine;
    ListBox1: TListBox;
    Item01: TListBoxItem;
    lytImagem: TLayout;
    MapView1: TMapView;
    FloatAnimation1: TFloatAnimation;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Item02: TListBoxItem;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Item03: TListBoxItem;
    Label17: TLabel;
    Item04: TListBoxItem;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Item05: TListBoxItem;
    Label25: TLabel;
    Item06: TListBoxItem;
    Label29: TLabel;
    Item07: TListBoxItem;
    Label33: TLabel;
    Item08: TListBoxItem;
    Label37: TLabel;
    Item09: TListBoxItem;
    Label41: TLabel;
    Item10: TListBoxItem;
    Label45: TLabel;
    Item11: TListBoxItem;
    Label49: TLabel;
    rectHome03: TRectangle;
    ShadowEffect1: TShadowEffect;
    rectHome02: TRectangle;
    ShadowEffect2: TShadowEffect;
    rectTooBar1: TRectangle;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    rect_btn_acessar: TRectangle;
    Label2: TLabel;
    TabAba5: TTabItem;
    WebBrowser1: TWebBrowser;
    rectToolBarBrowser: TRectangle;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Rectangle5: TRectangle;
    Label53: TLabel;
    SpeedButton2: TSpeedButton;
    Rectangle6: TRectangle;
    Label54: TLabel;
    Rectangle8: TRectangle;
    Label5: TLabel;
    SpeedButton3: TSpeedButton;
    Label6: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    Label44: TLabel;
    Label46: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    SpeedButton4: TSpeedButton;
    VSTabAba03: TVertScrollBox;
    DateEdit1: TDateEdit;
    Label19: TLabel;
    lblNome: TLabel;
    Label1: TLabel;
    rectSUS: TRectangle;
    Edit1: TEdit;
    sbPesquisar: TSpeedButton;
    rectHome01: TRectangle;
    ShadowEffect3: TShadowEffect;
    VSTabAba01: TVertScrollBox;
    rect_btn_login: TRectangle;
    SpeedButton5: TSpeedButton;
    TabAba2: TTabItem;
    ListBox2: TListBox;
    ListBoxItem1: TListBoxItem;
    Label4: TLabel;
    Label22: TLabel;
    Rectangle1: TRectangle;
    Label77: TLabel;
    SpeedButton6: TSpeedButton;
    Label10: TLabel;
    SpeedButton7: TSpeedButton;
    Label14: TLabel;
    Rectangle3: TRectangle;
    ListBox3: TListBox;
    ListBoxItem3: TListBoxItem;
    Label27: TLabel;
    ListBoxItem2: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Image2: TImage;
    Image3: TImage;
    CheckBox1: TCheckBox;
    ListBox4: TListBox;
    ListBoxItem4: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    procedure img_aba1Click(Sender: TObject);
    procedure img_exp_voltarClick(Sender: TObject);
    procedure sbVoltarHomeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rect_btn_acessarClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Item01Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    procedure MudarAba(img: TImage);
    { Private declarations }
    procedure Navigate(Latitude, Longitude: Double; Name: string);
    procedure MostraMapa(Tag: integer);

    procedure VisualizarPDF(FNomeArq: string);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses uPermissions;

procedure TFrmPrincipal.VisualizarPDF(FNomeArq: string);
var
  Intent  : JIntent;
  Uri     : Jnet_Uri;
  Path   : string;
begin
  TFile.Copy(TPath.Combine(TPath.GetDocumentsPath,FNomeArq+'.pdf'),
    TPath.GetSharedDownloadsPath+PathDelim+FNomeArq+'.pdf', True);
//  Path:=TPath.GetSharedDownloadsPath+PathDelim+FNomeArq+'.pdf';
  Path:=TPath.GetDocumentsPath+PathDelim+FNomeArq+'.pdf';
  intent := TJIntent.Create;
  intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  URI := StrToJURI('content://' +Path);
  intent.setDataAndType(URI,StringToJString('application/pdf'));
  Intent.setFlags(TJIntent.JavaClass.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
  TAndroidHelper.Activity.startActivity(Intent);

end;


procedure TFrmPrincipal.Navigate(Latitude, Longitude: Double; Name: string);
var
    mapNavigate: TMapCoordinate;
    MyMarker:  TMapMarkerDescriptor;
begin
  mapNavigate := TMapCoordinate.Create(Latitude, Longitude);
  MapView1.Location := mapNavigate;

  MyMarker := TMapMarkerDescriptor.Create(mapNavigate, Name);
  MyMarker.Draggable := False;
  MyMarker.Visible := True;
  MapView1.AddMarker(MyMarker);

  MapView1.Zoom := 100;
end;

procedure TFrmPrincipal.rect_btn_acessarClick(Sender: TObject);
begin
    TabControl.ActiveTab := TabAba5;

end;

procedure TFrmPrincipal.MostraMapa(Tag: integer);
begin
//    ShowMessage(Tag.ToString);

    if Tag = 1 then begin
        Navigate(-20.59314, -47.85744, 'UBS ESF VILA DEIENNO');
    end else if Tag = 2 then begin
        Navigate(-20.59393,-47.85189, ' UBS ESF P LINO ZANGARELE');
    end else if Tag = 3 then begin
        Navigate(-20.58188,-47.85729, 'UBS ESF CS II DR JOSE RIBEIRO FORTES');
    end else if Tag = 4 then begin
        Navigate(-20.59871,-47.86162, 'UBS ESF DR JOSE OTACILIO QUARESEMIN');
    end else if Tag = 5 then begin
        Navigate(-20.5862,-47.87064, 'ESF LAPA');
    end else if Tag = 6 then begin
        Navigate(-20.60048,-47.86948, 'UBS ESF IRMA TEREZINHA GEMA DALMOLIN');
    end else if Tag = 7 then begin
        Navigate(-20.59314, -47.85744, 'UBS ESF MACIEL FRANC GARCIA');
    end else if Tag = 8 then begin
        Navigate(-20.59027,-47.87819, 'UBS ESF BAIXADA');
    end else if Tag = 9 then begin
        Navigate(-20.56742,-47.86689, 'UBS ESF ROSINHA BASSO');
    end else if Tag = 10 then begin
        Navigate(-20.59939,-47.87804, 'UBS SABINO NOGUEIRA JUNIOR');
    end else if Tag = 11 then begin
        Navigate(-20.59945,-47.8781, 'ESF VEREADOR APARECIDO FERREIRA BORGES');
    end;

    TabControl.ActiveTab := TabAba3;

end;

procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    img_aba1.Opacity := 0.4;
    img_aba2.Opacity := 0.4;
    img_aba3.Opacity := 0.4;
    img_aba4.Opacity := 0.4;

    img.Opacity := 1;
    TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);
end;

procedure TFrmPrincipal.sbVoltarHomeClick(Sender: TObject);
begin
    MudarAba(img_aba1);

end;

procedure TFrmPrincipal.SpeedButton5Click(Sender: TObject);
begin
    ShowMessage('Agendamento realizado com sucesso!');
    VisualizarPDF('Comprovante');
end;

procedure TFrmPrincipal.SpeedButton7Click(Sender: TObject);
begin
TabControl.ActiveTab := TabAba6;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

    TMyPermissions.RequestMyPermission(
    [
       TMyPermissions.Camera,
       TMyPermissions.WifiState,
       TMyPermissions.ReadExternalStorage,
       TMyPermissions.WriteExternalStorage
    ]
    );

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   Navigate(-20.59314, -47.85744, 'UBS ESF VILA DEIENNO');

end;

procedure TFrmPrincipal.img_aba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));

end;

procedure TFrmPrincipal.img_exp_voltarClick(Sender: TObject);
begin
    MudarAba(img_aba1);
end;

procedure TFrmPrincipal.Item01Click(Sender: TObject);
var
   valor: integer;
begin
    valor := (Sender as TListBoxItem).Tag;
    MostraMapa( valor );
end;

end.
