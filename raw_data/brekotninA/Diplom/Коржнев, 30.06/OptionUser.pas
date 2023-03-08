unit OptionUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, sRichEdit, sListBox, sFontCtrls, sComboBox,
  sLabel, Buttons, sSpeedButton, sColorSelect, sDialogs, sUpDown, ExtCtrls,
  sPanel, sGroupBox, sTrackBar, sBitBtn, IniFiles,Registry, sCheckBox;

type
  TfOptionUser = class(TForm)
    sPanel1: TsPanel;
    sRichEdit1: TsRichEdit;
    sColorSelect1: TsColorSelect;
    sLabelFX1: TsLabelFX;
    sFontComboBox1: TsFontComboBox;
    sColorSelect2: TsColorSelect;
    sLabelFX2: TsLabelFX;
    sTrackBar1: TsTrackBar;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sPanel3: TsPanel;
    sComboBox1: TsComboBox;
    sLabel2: TsLabel;
    sPanel2: TsPanel;
    sLabel1: TsLabel;
    LabelCountQuest: TsLabelFX;
    sTrackBar2: TsTrackBar;
    sLabel3: TsLabel;
    sCheckBox1: TsCheckBox;
    procedure sColorSelect1Change(Sender: TObject);
    procedure sColorSelect2Change(Sender: TObject);
    procedure sFontComboBox1Change(Sender: TObject);
    procedure sComboBox1Change(Sender: TObject);
    procedure sTrackBar1Change(Sender: TObject);
    procedure sTrackBar2Change(Sender: TObject);
    procedure LoadSettings;
    procedure SaveSettings;
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    flag_option:string;
  end;

var
  fOptionUser: TfOptionUser;
  Reg:TRegistry;


implementation

uses Entry, MainMenu, sSkinManager, Misc;

{$R *.dfm}

procedure TfOptionUser.LoadSettings;
begin
  try
    Reg := TRegistry.Create;
    Reg.OpenKey(GetBaseKey + '\Users\'+fMainMenu.userName+' '+fMainMenu.userFirstName, true);
    if Reg.ValueExists('Theme') then
      begin
        if (Reg.ReadString('Theme')<>'') then
          begin
            sComboBox1.ItemIndex:=sComboBox1.Items.IndexOf(Reg.ReadString('Theme'));
            fEntry.sSkinManager1.SkinName:=sComboBox1.Text;
          end
        else
          begin
            fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
            Reg.WriteString('Theme','XPSilver (internal)');
            sComboBox1.ItemIndex:=sComboBox1.Items.IndexOf('XPSilver (internal)');
          end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteString('Theme','XPSilver (internal)');
        sComboBox1.ItemIndex:=sComboBox1.Items.IndexOf('XPSilver (internal)');
      end;
    if Reg.ValueExists('BgColor') then
      begin
        if (Reg.ReadInteger('BgColor')>=0) and (Reg.ReadInteger('BgColor')<=16777215)  then
          sColorSelect1.ColorValue:=Reg.ReadInteger('BgColor')
        else
          begin
            fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
            Reg.WriteInteger('BgColor',16777215);
            sColorSelect1.ColorValue:=16777215;
          end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteInteger('BgColor',16777215);
        sColorSelect1.ColorValue:=16777215;
      end;
    if Reg.ValueExists('FontColor') then
      begin
        if (Reg.ReadInteger('FontColor')>=0) and (Reg.ReadInteger('FontColor')<=16777215) then
          sColorSelect2.ColorValue:=Reg.ReadInteger('FontColor')
        else
          begin
            fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
            Reg.WriteInteger('FontColor',0);
            sColorSelect2.ColorValue:=0;
          end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteInteger('FontColor',0);
        sColorSelect2.ColorValue:=0;
      end;
    if Reg.ValueExists('FontStyle') then
      begin
        if (Reg.ReadString('FontStyle')<>'') then
          sFontComboBox1.Text:=Reg.ReadString('FontStyle')
      else
        begin
          fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
          Reg.WriteString('FontStyle','Tahoma');
          sFontComboBox1.Text:='Tahoma';
        end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteString('FontStyle','Tahoma');
        sFontComboBox1.Text:='Tahoma';
      end;
    if Reg.ValueExists('FontSize') then
      begin
        if (Reg.ReadInteger('FontSize')>0) and (Reg.ReadInteger('FontSize')<=72) then
          sTrackBar1.Position:=Reg.ReadInteger('FontSize')
        else
          begin
            fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
            Reg.WriteInteger('FontSize',24);
            sTrackBar1.Position:=24;
          end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteInteger('FontSize',24);
        sTrackBar1.Position:=24;
      end;
    if Reg.ValueExists('CountQuest') then
      begin
        if (Reg.ReadInteger('CountQuest')>0) or ((Reg.ReadInteger('CountQuest')<=50)) then
          sTrackBar2.Position:=Reg.ReadInteger('CountQuest')
        else
          begin
            fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
            Reg.WriteInteger('CountQuest',5);
            sTrackBar2.Position:=5;
          end;
      end
    else
      begin
        fEntry.Sskinmanager1.SkinName:='XPSilver (internal)';
        Reg.WriteInteger('CountQuest',5);
        sTrackBar2.Position:=5;
      end;
    Reg.CloseKey;
    Reg.Free;
  except
    on E:Exception do;
  end;
end;

procedure TfOptionUser.SaveSettings;
begin
  try
    Reg := TRegistry.Create;
    Reg.OpenKey(GetBaseKey + '\Users\'+fMainMenu.userName+' '+fMainMenu.userFirstName, true);
    Reg.WriteInteger('BgColor', sColorSelect1.ColorValue);
    Reg.WriteInteger('FontColor', sColorSelect2.ColorValue);
    Reg.WriteString('FontStyle', sFontComboBox1.Text);
    Reg.WriteInteger('FontSize', sTrackBar1.Position);
    Reg.WriteInteger('CountQuest', sTrackBar2.Position);
    Reg.WriteString('Theme', sComboBox1.Text);
    Reg.CloseKey;
    Reg.Free;
    fEntry.Sskinmanager1.SkinName:=sComboBox1.Text;
  except
    on E:Exception do;
  end;
end;

procedure TfOptionUser.sBitBtn1Click(Sender: TObject);
begin
  SaveSettings;
  Close;
end;

procedure TfOptionUser.sBitBtn2Click(Sender: TObject);
begin
  LoadSettings;
  Close;
end;
   
procedure TfOptionUser.sBitBtn3Click(Sender: TObject);
begin
  if Application.MessageBox('Вы хотите сбросить настройки на стандартные?' ,'Сброс настроек',MB_YESNO)=IDYES then
    begin
      scombobox1.ItemIndex:=21;
      sColorSelect1.ColorValue:=16777215;
      sColorSelect2.ColorValue:=0;
      sFontComboBox1.Text:='Tahoma';
      sTrackBar1.Position:=24;
      sTrackBar2.Position:=5;
      sComboBox1.ItemIndex:=76;
      fEntry.sSkinManager1.SkinName:='XPSilver (internal)';
    end;
end;

procedure TfOptionUser.sColorSelect1Change(Sender: TObject);
begin
  sRichEdit1.Color:=sColorSelect1.ColorValue;
end;

procedure TfOptionUser.sColorSelect2Change(Sender: TObject);
begin
  sRichEdit1.Font.Color:=sColorSelect2.ColorValue;
end;

procedure TfOptionUser.sComboBox1Change(Sender: TObject);
begin
  fEntry.sskinmanager1.SkinName:=scombobox1.Text;
end;

procedure TfOptionUser.sFontComboBox1Change(Sender: TObject);
begin
  sRichEdit1.Font.Name:=sFontComboBox1.Text;
end;

procedure TfOptionUser.sTrackBar1Change(Sender: TObject);
begin
  sRichEdit1.Font.Size:=sTrackBar1.Position;
  sLabel3.Caption:=inttostr(sTrackBar1.Position);
end;

procedure TfOptionUser.sTrackBar2Change(Sender: TObject);
begin
  LabelCountQuest.Caption:=IntToStr(sTrackBar2.Position);
end;                         

procedure TfOptionUser.FormCreate(Sender: TObject);
var
  i:integer;  
begin
  sComboBox1.Items.Clear;
  for i:=0 to fEntry.sSkinManager1.InternalSkins.Count-1 do
    sComboBox1.Items.Add(fEntry.sSkinManager1.InternalSkins.Items[i].Name);
end;

procedure TfOptionUser.FormShow(Sender: TObject);
begin
  sLabel3.Caption:=inttostr(sTrackBar1.Position);
  LoadSettings;
end;

end.
