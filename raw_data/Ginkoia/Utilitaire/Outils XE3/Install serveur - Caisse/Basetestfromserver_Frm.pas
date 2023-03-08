unit Basetestfromserver_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.shlobj,
  System.SysUtils, System.Variants, System.Classes, System.Windows.neighbors,
  System.IOUtils,
  //Début Uses Perso
  uBasetest,
  ufunctions,
  uRessourcestr,
  System.IniFiles,
  //Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ImgList,
  Data.DB, Datasnap.DBClient;


type
  TFrm_Basetestfromserver = class(TForm)
    btnInstall: TButton;
    GActions: TGroupBox;
    Chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chk6: TCheckBox;
    Label1: TLabel;
    edtBasetest: TButtonedEdit;
    DSParam: TClientDataSet;
    procedure FormShow(Sender: TObject);
    procedure GetPathForBaseTest(sBase: string);
    procedure SetBase(sB : string) ;
    procedure edtBasetestRightButtonClick(Sender: TObject);
    procedure edtBasetestExit(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure edtBasetestChange(Sender: TObject); // à exécuter dans l'appelant entre le formcreate et le formshow
  private
    { Private declarations }
    sPathTest, sBase, sEntete : string ;
  public
    { Public declarations }
    //procedure SetBase(aBase:string);
  end;

var
  Frm_Basetestfromserver: TFrm_Basetestfromserver;

implementation

Uses
  Main_Dm,
  Main_Frm;

{$R *.dfm}

procedure TFrm_Basetestfromserver.btnInstallClick(Sender: TObject);
var bOk : boolean ;
 procedure Clear;
  begin
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
    if Tfile.Exists(sBase) = false then
     begin
       Showmessage(RST_FILENOTFOUND ) ;
       exit ;
     end ;
    sSource := sBase;
    if btnInstall.Tag = 1 then
      exit;
    bok := true ;
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
      modalResult := mrCancel ;
      Close
    end;

    if TBasetest.Deperso = False then
    begin
      bok := false ;
      Showmessage(TBasetest.error);
      Clear;
      modalResult := mrCancel ;
      Close ;
    end;

    if TBasetest.RenamePwd = False then
    begin
      bok := false ;
      Showmessage(TBasetest.error);
      Clear;
      modalResult := mrCancel ;
      Close ;      
    end;

    if TBasetest.RenameUtil = False then
    begin
      bok := false ;
      Showmessage(TBasetest.error);
      Clear;
      modalResult := mrCancel ;
      Close ;
    end;

    if TBasetest.ModifyTicket(sEntete) = False then
    begin
      bok := false ;
      Showmessage(TBasetest.error);
      Clear;
      modalResult := mrCancel;
      Close ;
    end;

  Finally
    // ici pas de mise à jour des fichiers ini ceux ci sont mis à jour dans la phase de finalisation
    Clear;
    screen.Cursor := crDefault;
    if bok = true then 
     begin
      ModalResult := mrOk ;
      //close ;
     end ; 
  End;
end;

procedure TFrm_Basetestfromserver.edtBasetestChange(Sender: TObject);
begin
   Gactions.Visible := (edtBasetest.Text <> '' )  ;
   btnInstall.Visible := Gactions.Visible ; 
end;

procedure TFrm_Basetestfromserver.edtBasetestExit(Sender: TObject);
begin
   Gactions.Visible := (edtBasetest.Text <> '' )  ;
   btnInstall.Visible := Gactions.Visible ;
end;

procedure TFrm_Basetestfromserver.edtBasetestRightButtonClick(Sender: TObject);
var sDir: string ;
    iFlag : integer ;
begin
 iFlag :=  BIF_BROWSEFORCOMPUTER and BIF_RETURNONLYFSDIRS;
 sDir := BrowseForFolders('Dossiers', iFlag , handle)  ;
 if sDir.IsEmpty = false then edtBasetest.Text :=  sDir ;
end;

procedure TFrm_Basetestfromserver.FormShow(Sender: TObject);
var
  sFile: string;
  iniParam  : TIniFile;
begin
  try
    IniParam := TIniFile.Create(PChar(ExtractFilePath(ParamStr(0))+NameFileParam));
    sEntete   := IniParam.ReadString('TICKET', 'Ticket', '');
    sPathTest := IniParam.ReadString('BASE_TEST', 'BaseTest', '');
  finally

    IniParam.Free;
  end;
end;


procedure TFrm_Basetestfromserver.SetBase(sB: string);
begin
  sBase := sB ;
  if sB <> '' then
    edtBasetest.Text := sB[1]+':\Ginkoia\Test';
end;

procedure TFrm_Basetestfromserver.GetPathForBaseTest(sBase: string);
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
