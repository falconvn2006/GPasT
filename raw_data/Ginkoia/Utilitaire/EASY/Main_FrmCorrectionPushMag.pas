unit Main_FrmCorrectionPushMag;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  {dxGDIPlusClasses,} Vcl.ExtCtrls;

type
  TFrm_CorrectionPushMag = class(TForm)
    Panel3: TPanel;
    Image2: TImage;
    Label9: TLabel;
    Panel4: TPanel;
    Label1: TLabel;
    BIBFile: TButton;
    teIBFile: TEdit;
    Panel2: TPanel;
    Button1: TButton;
    BDETAILS: TButton;
    sb: TStatusBar;
    Panel1: TPanel;
    mLog: TMemo;
    gb_MVTKENABLED: TGroupBox;
    cbUPDATE: TCheckBox;
    cbINSERT: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BDETAILSClick(Sender: TObject);
    procedure BIBFileClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure ReCenter();
    procedure ParamScreen();
    Procedure AddLog(Const s:String);
  public
    { Déclarations publiques }
  end;

var
  Frm_CorrectionPushMag: TFrm_CorrectionPushMag;

implementation

{$R *.dfm}
Uses UCommun,uDataMod,SymmetricDS.Commun;

Procedure TFrm_CorrectionPushMag.AddLog(Const s:String);
begin
  mLog.Lines.Add(FormatDateTime('dd/mm/yyyy hh:nn:ss : ',Now()) + s);
end;



procedure TFrm_CorrectionPushMag.BDETAILSClick(Sender: TObject);
begin
  Panel1.Visible:=not(Panel1.Visible);
  ParamScreen;
end;

procedure TFrm_CorrectionPushMag.BIBFileClick(Sender: TObject);
var vOpenDialog : TOpenDialog;
begin
    vOpenDialog := TOpenDialog.Create(Self);
    try
      if FileExists(teIBFile.Text) then
        begin
            vOpenDialog.InitialDir := ExtractFileDir(teIBFile.Text);
        end;
      if vOpenDialog.Execute()
        then
          begin
            teIBFile.Text := vOpenDialog.FileName;
            if FileExists(teIBFile.Text) then
              begin
                //
                Button1.Enabled :=true;
                //
              end;
          end;
    finally
      vOpenDialog.Free;
    end;
end;

procedure TFrm_CorrectionPushMag.Button1Click(Sender: TObject);
var vResultInsert:string;
    vResultUpdate:string;
begin
  Button1.Enabled := False;
  AddLog(Format('Anaylse du fichier %s',[teIBFile.Text]));
  // Peut etre long ?  aucune idée
  if cbINSERT.Checked
     then
      begin
          vResultInsert := DataMod.EasyMvtKenabled_INSERT(teIBFile.Text);
          AddLog('Correction Insert : '+ vResultInsert);
      end;

  if cbUPDATE.Checked
    then
      begin
          vResultUpdate := DataMod.EasyMvtKenabled(teIBFile.Text,50);
          AddLog('Correction Update : ' + vResultUpdate);
      end;
   AddLog('Terminé');
end;

procedure TFrm_CorrectionPushMag.FormCreate(Sender: TObject);
begin
   teIBFile.Text := ReadBase0;
   if FileExists(teIBFile.Text) then
    begin
       Button1.Enabled :=true;
    end;

    ParamScreen();
end;


procedure TFrm_CorrectionPushMag.ReCenter();
var
  LRect: TRect;
  X, Y: Integer;
begin
  LRect := Screen.WorkAreaRect;
  X := LRect.Left + (LRect.Right - LRect.Left - Width) div 2;
  Y := LRect.Top + (LRect.Bottom - LRect.Top - Height) div 2;
  SetBounds(X, Y, Width, Height);
end;

procedure TFrm_CorrectionPushMag.ParamScreen();
begin
    if not(Panel1.Visible)
      then
          begin
             Self.Height := 395;
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

end.
