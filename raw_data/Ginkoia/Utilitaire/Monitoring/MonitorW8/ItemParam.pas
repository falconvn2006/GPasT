unit ItemParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, System.Actions, Vcl.ActnList, Vcl.Touch.GestureMgr,UWeb, GroupedItems1,
  Vcl.Samples.Spin;

type
  TItemParamForm = class(TForm)
    Panel1: TPanel;
    eTitle: TEdit;
    Panel2: TPanel;
    Label1: TLabel;
    eHost: TEdit;
    Label2: TLabel;
    eapp: TEdit;
    Label3: TLabel;
    einst: TEdit;
    Label4: TLabel;
    emdl: TEdit;
    Label5: TLabel;
    eref: TEdit;
    ekey: TEdit;
    Label7: TLabel;
    Label6: TLabel;
    eFreq: TSpinEdit;
    Image2: TImage;
    Edit1: TEdit;
    Label8: TLabel;
    Edit2: TEdit;
    Label9: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Déclarations privées }
    FAction : string;
    Fid     : integer;
  public
    { Déclarations publiques }
    procedure Init(ATuile:TTuile);
    property Action : string read Faction write Faction;
    property id: integer read Fid write Fid;
  end;

var
  ItemParamForm: TItemParamForm;

implementation

{$R *.dfm}

const
  AppBarHeight = 75;

procedure TItemParamForm.CloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TItemParamForm.Init(ATuile:TTuile);
begin
     if ATuile=nil then
        begin
           Faction     := 'insert';
           Fid         :=  0;
           eTitle.Text := 'Titre';
           eHost.Text  := '%';
           eapp.Text   := '%';
           einst.Text  := '%';
           emdl.Text   := '%';
           eref.Text   := '%';
           ekey.Text   := '%';
        end
     else
        begin
           Faction     := 'update';
           Fid         := ATuile.id;
           eTitle.Text := ATuile.titre;
           eHost.Text  := ATuile.host;
           eapp.Text   := ATuile.app;
           einst.Text  := ATuile.inst;
           emdl.Text   := ATuile.mdl;
           eref.Text   := ATuile.ref;
           ekey.Text   := ATuile.key;
        end;
end;

procedure TItemParamForm.Image1Click(Sender: TObject);
var ATuile:TTuile;
begin
     If Action = 'insert' then
        begin
           ATuile:=TTuile.Create('Tuile');
           ATuile.Titre := eTitle.Text;
           ATuile.host  := eHost.Text;
           ATuile.app   := eapp.Text;
           ATuile.inst  := einst.Text;
           ATuile.mdl   := emdl.Text;
           ATuile.ref   := eref.Text;
           ATuile.key   := ekey.Text;
           ATuile.Tag   := Format('tuile_%d',[GridForm.Tuiles.Count]);
           Atuile.Freq  := efreq.Value;
           ATuile.Value := '';
           GridForm.Tuiles.Add(ATuile);
        end;
     If Action = 'update'
        then
          begin
              GridForm.Tuiles.Items[id].Titre := eTitle.Text;
              GridForm.Tuiles.Items[id].host  := eHost.Text;
              GridForm.Tuiles.Items[id].app   := eapp.Text;
              GridForm.Tuiles.Items[id].inst  := einst.Text;
              GridForm.Tuiles.Items[id].mdl   := emdl.Text;
              GridForm.Tuiles.Items[id].ref   := eref.Text;
              GridForm.Tuiles.Items[id].key   := ekey.Text;
              GridForm.Tuiles.Items[id].Tag   := Format('tuile_%d',[Fid]);
              GridForm.Tuiles.Items[id].Freq  := efreq.Value;
              GridForm.Tuiles.Items[id].Value := '';
          end;
     Hide;
     GridForm.Show;
     GridForm.CreationTuiles;
     // GridForm.FlowPanel.Refresh;
     // Application.ProcessMessages;
end;

end.
