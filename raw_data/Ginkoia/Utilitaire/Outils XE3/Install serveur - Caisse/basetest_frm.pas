unit Basetest_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.shlobj,
  System.SysUtils, System.Variants, System.Classes, System.Ioutils,
  System.Windows.neighbors,
  //Début Uses Perso
  uRessourcestr,
  ufunctions,
  uBasetest,
  System.IniFiles,
  //Fin Uses Perso
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Graphics, Vcl.ImgList, Vcl.filectrl,
  FireDAC.Comp.Client, Data.DB, Datasnap.DBClient;

type
  TFrm_Basetest = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    ItemSubtitle: TLabel;
    btnparam: TButton;
    Panel2: TPanel;
    edtLocalfile: TButtonedEdit;
    Label4: TLabel;
    OpenFileXP: TOpenDialog;
    Openfile: TFileOpenDialog;
    GActions: TGroupBox;
    Chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chk6: TCheckBox;
    btnInstall: TButton;
    DSParam: TClientDataSet;
    edtBasetest: TButtonedEdit;
    Label1: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnparamClick(Sender: TObject);
    procedure edtLocalfileRightButtonClick(Sender: TObject);
    function IsFileValid: boolean;
    procedure edtLocalfileExit(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure Chk1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure GetPathForBaseTest(sBase: string);
    procedure edtBasetestRightButtonClick(Sender: TObject);
  private
    { Private declarations }
    sFiletoCopy, sEntete, sPathTest: string;
  public
    { Public declarations }
  end;

var
  Frm_Basetest: TFrm_Basetest;

implementation

Uses
  Main_Frm,
  Main_Dm,
  Codeuser_Frm,
  Paramlame_Frm;

{$R *.dfm}

procedure TFrm_Basetest.btnInstallClick(Sender: TObject);
  procedure Clear;
  begin
    edtLocalfile.Text := '';
    Chk1.visible := False;
    chk2.visible := False;
    chk3.visible := False;
    chk4.visible := False;
    chk5.visible := False;
    chk6.visible := False;
    GActions.visible := False;
    btnInstall.Tag := 0;
    btnInstall.visible := False;
  end;

var
  sTest, sSource: string;
  BeforeAction: TBeforeAction;
  AfterAction: TAfterAction;
begin
  Try

    if btnInstall.Tag = 1 then
      exit;

    edtLocalfile.Enabled := False;
    BeforeAction := procedure(Action: Integer)
      begin
        Try
          screen.Cursor := crHourglass;
          case Action of
            1:
              begin
                Chk1.visible := true;
                Chk1.Update;
              end;
            2:
              begin
                chk2.visible := true;
                chk2.Update;
              end;
            3:
              begin
                chk3.visible := true;
                chk3.Update;
              end;
            4:
              begin
                chk4.visible := true;
                chk4.Update;
              end;
            5:
              begin
                chk5.visible := true;
                chk5.Update;
              end;
            6:
              begin
                chk6.visible := true;
                chk6.Update;
              end;
          end;
        Except
        End;
      end;

    AfterAction := procedure(Action: Integer)
      begin
        Try
          screen.Cursor := crDefault;
          case Action of
            1:
              begin
                Chk1.Checked := true;
                Chk1.Update;
              end;
            2:
              begin
                chk2.Checked := true;
                chk2.Update;
              end;
            3:
              begin
                chk3.Checked := true;
                chk3.Update;
              end;
            4:
              begin
                chk4.Checked := true;
                chk4.Update;
              end;
            5:
              begin
                chk5.Checked := true;
                chk5.Update;
              end;
            6:
              begin
                chk6.Checked := true;
                chk6.Update;
              end;

          end;
        Except
        End;
      end;

    GActions.visible := true;
    application.ProcessMessages;
    btnInstall.Tag := 1;
    sSource := edtLocalfile.Text;
    if edtBasetest.Text <> '' then
    begin
      sTest := IncludeTrailingBackslash(edtBasetest.Text);
    end
    else
    begin
      sTest := Tpath.GetDirectoryName(sSource);
      sTest := Tdirectory.GetParent(sTest);
      sTest := IncludeTrailingBackslash(sTest) + 'TEST\';
    end;
    ForceDirectories(sTest);
    sTest := sTest + 'TEST.IB';
    TBasetest.Source := sSource;
    TBasetest.Destination := sTest;
    TBasetest.BeforeAction := BeforeAction;
    TBasetest.AfterAction := AfterAction;
    if TBasetest.Copy = False then
    begin
      if TBasetest.error.IsEmpty = False then
        Showmessage(TBasetest.error);
      Clear;
      exit;
    end;

    if TBasetest.Deperso = False then
    begin
      Showmessage(TBasetest.error);
      Clear;
      exit;
    end;

    if TBasetest.RenamePwd = False then
    begin
      Showmessage(TBasetest.error);
      Clear;
      exit;
    end;

    if TBasetest.RenameUtil = False then
    begin
      Showmessage(TBasetest.error);
      Clear;
      exit;
    end;

    if TBasetest.ModifyTicket(sEntete) = False then
    begin
      Showmessage(TBasetest.error);
      Clear;
      exit;
    end;

  Finally
    Tbasetest.UpdateIni ;    // mise à jour des fichiers ini (caisse et ginkoia en path1, item1
    Clear;
    screen.Cursor := crDefault;
    edtLocalfile.Enabled := true;
  End;
end;

procedure TFrm_Basetest.btnparamClick(Sender: TObject);
var
  k: Integer;
begin
  Try
    k := 0;
    application.CreateForm(TFcodeuser, Fcodeuser);
    Repeat
      inc(k);
      if Fcodeuser.ShowModal = mrOk then
      begin
        if IsAuthorized(Fcodeuser.edtUser.Text, Fcodeuser.edtpwd.Text) then
        begin
          // saisie des params
          k := 3;
          Try
            Application.CreateForm(TFrm_Paramlame, Frm_Paramlame);
            Frm_Paramlame.ShowModal;
          Finally
            Frm_Paramlame.Release;
            Frm_Paramlame := nil;
          End;
        end;
      end
      else
        break;
    Until k = 3;
  Finally
    Fcodeuser.Release;
    Fcodeuser := nil;
  End;
end;

procedure TFrm_Basetest.Chk1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  System.SysUtils.abort;
end;

function TFrm_Basetest.IsFileValid: boolean;
var
  sT, ext: string;
begin
  sT := edtLocalfile.Text;
  result := False;
  if sT.IsEmpty = False then
  begin
    result := true;
    ext := lowercase(Tpath.GetExtension(sT));
    if ext <> '.ib' then
    begin
      // pad d'extension IB
      Showmessage(RST_BADEXTENSION);
      exit(False);
    end;
    if Tfile.Exists(sT) = False then
    begin
      // le fichier n'existe pas
      Showmessage(RST_NOBASE);
      exit(False);
    end;
  end;
end;

procedure TFrm_Basetest.edtBasetestRightButtonClick(Sender: TObject);
var sDir: string ;
    iFlag : integer ;
begin
 iFlag :=  BIF_BROWSEFORCOMPUTER and BIF_RETURNONLYFSDIRS;
 sDir := BrowseForFolders('Dossiers', iFlag , handle)  ;
 if sDir.IsEmpty = false then edtBasetest.Text :=  sDir ;
end;


procedure TFrm_Basetest.edtLocalfileExit(Sender: TObject);
begin
  btnInstall.visible := IsFileValid;
  if btnInstall.visible then
    sFiletoCopy := edtLocalfile.Text;

end;

procedure TFrm_Basetest.edtLocalfileRightButtonClick(Sender: TObject);
begin
  btnInstall.visible := False;
  if IsVistaOrHigher then
  begin
    Openfile.DefaultFolder := IncludeTrailingBackslash(GetGinkoiaPath) + 'Data';
    if Openfile.Execute then
    begin
      sFiletoCopy := Openfile.FileName;
    end;
  end
  else
  begin
    // xp
    OpenFileXP.InitialDir := IncludeTrailingBackslash(GetGinkoiaPath) + 'Data';
    if OpenFileXP.Execute then
      sFiletoCopy := OpenFileXP.FileName;
  end;
  if sFiletoCopy.IsEmpty = False then
  begin
    edtLocalfile.Text := sFiletoCopy;
    if IsFileValid then
    begin
      GetPathForBaseTest(sFiletoCopy);
      btnInstall.visible := true;
      btnInstall.Update;
    end;
  end;
end;

procedure TFrm_Basetest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Main.Tag := 0; // pour permettre la fermeture de la fenêtre principale.
  Action := caFree;
end;

procedure TFrm_Basetest.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := (btnInstall.Tag = 0);
end;

procedure TFrm_Basetest.FormShow(Sender: TObject);
var
  sFile: string;
  iniParam  : TIniFile;
begin
  try
    IniParam  := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0))+NameFileParam));
    sEntete   := IniParam.ReadString('TICKET', 'Ticket', '');
    sPathTest := IniParam.ReadString('BASE_TEST', 'BaseTest', '');
  finally
    if sPathTest <> '' then
    edtBasetest.Text := sPathTest;

    IniParam.Free;
  end;
end;

procedure TFrm_Basetest.Image1Click(Sender: TObject);
begin
  // on ferme la fenêtre
  Postmessage(handle, WM_CLOSE, 0, 0);
end;

procedure TFrm_Basetest.GetPathForBaseTest(sBase: string);
var
  s: string;
  d, p, f, e: string; // pour extraction des Unc path
begin
  if sBase = '' then
    exit;
  if sPathTest <> '' then
  begin
    s := Copy(sPathTest, pos('\', sPathTest), 1024);
    If Tpath.IsUNCPath(sBase) = False then
    begin
      s := Extractfiledrive(sBase) + s;
      ForceDirectories(s);
      edtBasetest.Text := s;
    end
    else
    begin
      ufunctions.PathextractElements(sBase, d, p, f, e);
      s := d + s;
      edtBasetest.Text := s;
    end;

  end;
end;



end.
