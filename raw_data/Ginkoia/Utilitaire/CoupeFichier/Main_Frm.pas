unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.ImgList, Vcl.ComCtrls;

type
  TFrm_Main = class(TForm)
    Btn_Couper: TButton;
    Ed_NbLigne: TEdit;
    Bed_PathFile: TButtonedEdit;
    Lab_NbLigne: TLabel;
    Lab_PathFile: TLabel;
    Img_List: TImageList;
    Cb_Entete: TCheckBox;
    Pb_Etat: TProgressBar;
    Btn_Close: TButton;
    procedure Bed_PathFileRightButtonClick(Sender: TObject);
    procedure Btn_CouperClick(Sender: TObject);
    procedure Ed_NbLigneKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_CloseClick(Sender: TObject);
  private
    { Déclarations privées }
    List_Tmp : TStringList;
    sFile : string;
    iNumFichier : Integer;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

procedure TFrm_Main.Bed_PathFileRightButtonClick(Sender: TObject);
var
  odTemp : TOpenDialog;
begin
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier Texte|*.txt;*.csv;*.sql|Tous|*.*';
    odTemp.Title := 'Choix Gros Fichier';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
    begin
      Bed_PathFile.Text := odTemp.FileName;
      sFile := Bed_PathFile.Text;
    end;
  finally
    odTemp.Free;
  end;
end;

procedure TFrm_Main.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.Btn_CouperClick(Sender: TObject);
var
  Delai: DWord;

  iMaxProgress: Int64;
  iProgress: Int64;

  Nb_Ligne : Integer;

  i: Integer;
  sLigne: string;
  sLire: String;
  Stream: TFileStream;
  StrStream: TStringStream;
  SizeLu: Int64;
  SizeALire: Int64;
  TailleMax: Int64;

  procedure TraitementDeLaLigne(ALigne: string);
  begin
    if Nb_Ligne < StrToInt(Ed_NbLigne.Text) then
    begin
      List_Tmp.Add(ALigne);
      Inc(Nb_Ligne);
    end
    else
    begin
      List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                          ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                          ExtractFileExt(sFile));
      List_Tmp.Clear;
      Inc(iNumFichier);
      List_Tmp.Add(ALigne);
      Nb_Ligne := 1;
    end;
  end;

begin
  if sFile='' then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    //On désactive la saisie
    Ed_NbLigne.Enabled    := False;
    Btn_Couper.Enabled    := False;
    Btn_Close.Enabled     := False;
    Bed_PathFile.Enabled  := False;
    Cb_Entete.Enabled     := False;

    //On vide la string list et initialise le nb de ligne à zéro
    Nb_Ligne := 0;
    iNumFichier := 0;
    List_Tmp.Clear;

    Delai := 0;
    sLire := '';
    TailleMax := 1024;
    Stream := TFileStream.Create(sFile, fmOpenRead);
    iMaxProgress := Stream.Size;
    Pb_Etat.Max := iMaxProgress;
    StrStream := TStringStream.Create('');
    try
      i := 0;
      Stream.Seek(0, soFromBeginning);
      if Stream.Size-Stream.Position>TailleMax then
        SizeALire := TailleMax
      else
        SizeALire := Stream.Size-Stream.Position;
      Sizelu := StrStream.CopyFrom(Stream, SizeALire);
      sLire := StrStream.DataString;
      iProgress := Sizelu;
      while (Sizelu=TailleMax) do
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if ((i>1) and (Cb_Entete.Checked)) or ((i>=1) and (Cb_Entete.Checked = False))  then
          begin
            TraitementDeLaLigne(sLigne);
          end;

        end;
        if Stream.Size-Stream.Position>TailleMax then
          SizeALire := TailleMax
        else
          SizeALire := Stream.Size-Stream.Position;

        // progression
        iProgress := iProgress+SizeALire;
        if (GetTickCount-Delai)>=250 then
        begin
          Pb_Etat.Position := iProgress;
          Pb_Etat.Update;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

        StrStream.Clear;
        Sizelu := StrStream.CopyFrom(Stream, SizeALire);
        sLire := sLire+StrStream.DataString;
      end;
      if sLire<>'' then
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne);
          end;
          // fin traitement
          if (GetTickCount-Delai)>=250 then
          begin
            Pb_Etat.Position := iProgress;
            Pb_Etat.Update;
            Delai := GetTickCount;
            Application.ProcessMessages;
          end;
        end;
        if sLire<>'' then
        begin
          inc(i);
          sLigne := sLire;
          // traitement de la ligne
          if i>1 then
          begin
            TraitementDeLaLigne(sLigne);
          end;
        end;
      end;
      Pb_Etat.Position := iProgress;
      Pb_Etat.Update;
    finally
      FreeAndNil(Stream);
      FreeAndNil(StrStream);
    end;
  finally
    List_Tmp.SaveToFile(ExtractFilePath(sFile) +
                        ChangeFileExt(ExtractFileName(sFile),'') + IntToStr(iNumFichier) +
                        ExtractFileExt(sFile));
    List_Tmp.Clear;
    Ed_NbLigne.Enabled    := True;
    Btn_Couper.Enabled    := True;
    Btn_Close.Enabled     := True;
    Bed_PathFile.Enabled  := True;
    Cb_Entete.Enabled     := True;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
    ShowMessage('Traitement terminé.');
  end;
end;

procedure TFrm_Main.Ed_NbLigneKeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(key, ['1','2','3','4','5','6','7','8','9','0']) then
    key := #0;
end;

procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(List_Tmp);
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  List_Tmp := TStringList.Create;
  sFile := '';
end;

end.
