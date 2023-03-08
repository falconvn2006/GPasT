unit Unit5;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  IB_Components,
  DB,
  IBODataset,
  ComCtrls;

type
  TForm5 = class(TForm)
    IbC_Ginkoia: TIB_Connection;
    OD_Ginkoia: TOpenDialog;
    Edit1: TEdit;
    Btn_Path: TButton;
    Btn_Traite: TButton;
    Que_Ktb: TIBOQuery;
    Que_Tbl: TIBOQuery;
    Que_K: TIBOQuery;
    Que_MajK: TIBOQuery;
    ProgressBar1: TProgressBar;
    Lab_Traite: TLabel;
    Btn_AddKSiVide: TButton;
    Lab_Info: TLabel;
    Lab_InfoGeneral: TLabel;
    procedure Btn_TraiteClick(Sender: TObject);
    procedure Btn_PathClick(Sender: TObject);
    procedure Btn_AddKSiVideClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure DoTraite(bAddK: boolean);
    { Déclarations publiques }
  end;

var
  Form5: TForm5;

implementation

uses UTools;

{$R *.dfm}

procedure TForm5.Btn_AddKSiVideClick(Sender: TObject);
begin
  if InputBox('Confirmation', 'Entrez le code pour confirmer', '') <> '1082' then
  begin
    Showmessage('Traitement annulé');
    exit;
  end;

  if MessageDlg('ATTENTION, ce traitement insère des données de test dans certaines tables. Il ne doit pas être exécuté sur une base de PROD !!!', mtConfirmation, mbOKCancel, 0) = mrOK then
  begin
    DoTraite(True);
  end;

end;

procedure TForm5.Btn_PathClick(Sender: TObject);
begin
  OD_Ginkoia.Filter     := 'Fichiers Interbase (*.ib)|*.ib|Fichiers Interbase (*.gdb)|*.gdb|Tous (*.*)|*.*';
  OD_Ginkoia.InitialDir := ExtractFilePath(Application.ExeName);
  OD_Ginkoia.FileName   := Edit1.Text;
  IF OD_Ginkoia.Execute then
  begin
    Edit1.Text := OD_Ginkoia.FileName;
  end;
end;

procedure TForm5.Btn_TraiteClick(Sender: TObject);
begin
  if InputBox('Confirmation', 'Entrez le code pour confirmer', '') <> '1082' then
  begin
    Showmessage('Traitement annulé');
    exit;
  end;

  DoTraite(False);
end;

procedure TForm5.DoTraite(bAddK: boolean);
var
  iKID     : integer;
  iPosComma: integer;
  sTblId   : string;
begin
  if Edit1.Text = '' then
  begin
    Showmessage('Base inexistante');
    Exit;
  end;


  TRY
    initLogFileName(0, Application.ExeName);

    // ouverture de la base
    IbC_Ginkoia.Close;
    IbC_Ginkoia.DatabaseName := Edit1.Text;
    IbC_Ginkoia.UserName     := 'ginkoia';
    IbC_Ginkoia.Password     := 'ginkoia';
    IbC_Ginkoia.Open;

    if IbC_Ginkoia.Connected then
    begin
      // récup des données de KTB
      // sauf k, k2, ktb, kfld
      ProgressBar1.Min      := 0;
      ProgressBar1.Position := 0;

      Que_Ktb.Close;
      Que_Ktb.SQL.Text := 'SELECT KTB_ID, KTB_NAME, KTB_DATA FROM KTB where ktb_name not like ''K%''';
      Que_Ktb.Open;

      ProgressBar1.Max := Que_Ktb.RecordCount;
      while not Que_Ktb.Eof do
      begin
        Lab_Traite.Caption := 'Traitement de ' + Que_Ktb.FieldByName('KTB_NAME').AsString;
        ProgressBar1.StepBy(1);
        Sleep(10);
        Application.ProcessMessages;

        // vérif si enreg
        Que_K.Close;
        Que_K.SQL.Text := 'SELECT K_ID FROM K WHERE K_ID <> 0 AND KTB_ID = ' + Que_Ktb.FieldByName('KTB_ID').AsString;
        Que_K.Open;

        if Que_K.RecordCount > 0 then
        begin
          Que_MajK.Close;
          Que_MajK.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + Que_K.FieldByName('K_ID').AsString + ',0 )';
          Que_MajK.ExecSQL;
          Que_MajK.Close;
        end
        else if bAddK then
        begin
          if (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'INVIMGSTK') AND
             (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'GENCUSTOMISE') AND
             (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'NKLSELECTION') AND
             (Que_Ktb.FieldByName('KTB_NAME').AsString <> 'TARGROUPTAR') then
          begin
            // ajoute le k
            Que_MajK.Close;
            Que_MajK.SQL.Text := 'SELECT ID FROM PR_NEWK(' + QuotedStr(Que_Ktb.FieldByName('KTB_NAME').AsString) + ')';
            Que_MajK.Open;
            iKID              := Que_MajK.Fields[0].AsInteger;
            Que_MajK.Close;
            if iKID <> 0 then
            begin
              LogAction('DELETE FROM K WHERE K_ID = ' + IntToStr(iKID) + ';');

              iPosComma := Pos(',', Que_Ktb.FieldByName('KTB_DATA').AsString);
              if iPosComma > 0 then
              begin
                sTblId := Copy(Que_Ktb.FieldByName('KTB_DATA').AsString, 1, iPosComma - 1);
              end
              else begin
                sTblId := Que_Ktb.FieldByName('KTB_DATA').AsString;
              end;
              try
                Que_MajK.Close;
                Que_MajK.SQL.Text := 'INSERT INTO ' + Que_Ktb.FieldByName('KTB_NAME').AsString + '(' + sTblId + ') VALUES (' + IntToStr(iKID) + ')';
                Que_MajK.ExecSQL;
                Que_MajK.Close;

                LogAction('DELETE FROM ' + Que_Ktb.FieldByName('KTB_NAME').AsString + ' WHERE ' + sTblId + ' = ' + IntToStr(iKID) + ';');
              except
                Showmessage('Table inexistante : ' + Que_Ktb.FieldByName('KTB_NAME').AsString);
              end;
            end;
          end;
        end;

        Que_K.Close;

        Que_Ktb.Next;
      end;
      Que_Ktb.Close;

      Lab_Traite.Caption    := 'Traitement terminé';
      ProgressBar1.Position := ProgressBar1.Max;
      Application.ProcessMessages;
    end;
  except
    on e: exception do
    begin
      Showmessage(e.Message);
    end;
  END;
  IbC_Ginkoia.Close;

end;

end.
