unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Tfrm_Main = class(TForm)
    Lab_Base: TLabel;
    Ed_Base: TEdit;
    Nbt_Base: TSpeedButton;
    Lab_Fichier: TLabel;
    Ed_Fichier: TEdit;
    Nbt_Fichier: TSpeedButton;
    Btn_Integration: TButton;
    Btn_Quitter: TButton;
    procedure Ed_BaseChange(Sender: TObject);
    procedure Nbt_BaseClick(Sender: TObject);
    procedure Ed_FichierChange(Sender: TObject);
    procedure Nbt_FichierClick(Sender: TObject);
    procedure Btn_IntegrationClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  IB_Components,
  IBODataset;

{$R *.dfm}

procedure Tfrm_Main.Ed_BaseChange(Sender: TObject);
begin
  Btn_Integration.Enabled := FileExists(Ed_Base.Text) and FileExists(Ed_Fichier.Text);
end;

procedure Tfrm_Main.Nbt_BaseClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier Interbase|*.ib';
    Open.InitialDir := ExtractFileDir(Ed_Base.Text);
    Open.FileName := ExtractFileName(Ed_Base.Text);
    if Open.Execute() then
      Ed_Base.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.Ed_FichierChange(Sender: TObject);
begin
  Btn_Integration.Enabled := FileExists(Ed_Base.Text) and FileExists(Ed_Fichier.Text);
end;

procedure Tfrm_Main.Nbt_FichierClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier csv|*.csv';
    Open.InitialDir := ExtractFileDir(Ed_Fichier.Text);
    Open.FileName := ExtractFileName(Ed_Fichier.Text);
    if Open.Execute() then
      Ed_Fichier.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure Tfrm_Main.Btn_IntegrationClick(Sender: TObject);

  function ExplodeString(txt, sep : string) : TStringList;
  var
    position : integer;
    tmp : string;
  begin
    Result := TStringList.Create();
    repeat
      position := Pos(sep, txt);
      if position <= 0 then
        position := Length(txt) +1;
      tmp := Trim(Copy(txt, 1, position -1));
      if not (tmp = '') then
        Result.Add(tmp);
      txt := Trim(Copy(txt, position + length(sep), length(txt)));
    until length(txt) = 0;
  end;

var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  txtFile, InfosLigne : TStringList;
  i, j, idExercice, idCollection : integer;
begin
  idExercice := 0;
  idCollection := 0;
  try
    // Connexion
    Connexion := TIB_Connection.Create(nil);
    Connexion.DatabaseName := AnsiString(Ed_Base.Text);
    Connexion.Username := 'ginkoia';
    Connexion.Password := 'ginkoia';
    // Transaction
    Transaction := TIB_Transaction.Create(nil);
    Transaction.IB_Connection := Connexion;
    Connexion.DefaultTransaction := Transaction;
    // Query
    Query := TIBOQuery.Create(Nil);
    Query.IB_Connection := Connexion;
    Query.IB_Transaction := Transaction;
    Query.RequestLive := True;
    try
      txtFile := TStringList.Create();
      txtFile.LoadFromFile(Ed_Fichier.Text);
      try
        Transaction.StartTransaction();
        for i := 0 to txtFile.Count -1 do
        begin
          try
            // recup des infos
            InfosLigne := ExplodeString(txtFile[i], ';');
            // tritement des date
            for j := 2 to 5 do
            begin
              if Length(InfosLigne[j]) = 8 then
                InfosLigne[j] := Copy(InfosLigne[j], 1, 4) + '-' + Copy(InfosLigne[j], 5, 2) + '-' + Copy(InfosLigne[j], 7, 2);
            end;

            // recherche d'exercice
            Query.SQL.Text := 'select EXE_ID from GENEXERCICECOMMERCIAL where EXE_CODE = ' + QuotedStr(InfosLigne[0]) + ';';
            Query.Open();
            if Query.eof then
            begin
              Query.Close();
              // recup du dl'id exercice
              Query.SQL.Text := 'select ID from PR_NEWK(''GENEXERCICECOMMERCIAL'')';
              Query.Open();
              idExercice := Query.FieldByName('ID').AsInteger;
              Query.Close();
              // insert de l'exercice
              Query.SQL.Text := 'insert into GENEXERCICECOMMERCIAL '
                              + ' (EXE_ID, EXE_NOM, EXE_DEBUT, EXE_FIN, EXE_ANNEE, EXE_SOCID, EXE_ACTIVE, EXE_CODE, EXE_CENTRALE) '
                              + 'values ('
                              + IntToStr(idExercice) + ', '
                              + QuotedStr(InfosLigne[1]) + ', '
                              + QuotedStr(InfosLigne[4]) + ', '
                              + QuotedStr(InfosLigne[5]) + ', '
                              + Copy(InfosLigne[5], 1, 4) + ', '
                              + '0, '
                              + '1, '
                              + QuotedStr(InfosLigne[0]) + ', '
                              + '6);';
              Query.ExecSQL();
            end
            else
            begin
              idExercice := Query.FieldByName('EXE_ID').AsInteger;
              Query.Close();
              // mise a jour de k
              Query.SQL.Text := 'execute procedure PR_UPDATEK(' + IntToStr(idExercice) + ', 0);';
              Query.ExecSQL();
              // update de l'exercice
              Query.SQL.Text := 'update GENEXERCICECOMMERCIAL set '
                              + 'EXE_NOM = ' + QuotedStr(InfosLigne[1]) + ', '
                              + 'EXE_DEBUT = ' + QuotedStr(InfosLigne[4]) + ', '
                              + 'EXE_FIN = ' + QuotedStr(InfosLigne[5]) + ', '
                              + 'EXE_ANNEE = ' + Copy(InfosLigne[5], 1, 4) + ', '
                              + 'EXE_SOCID = 0, '
                              + 'EXE_ACTIVE = 1, '
                              + 'EXE_CENTRALE = 6'
                              + ' where EXE_ID = ' + IntToStr(idExercice)
                              + ' and EXE_CODE = ' + QuotedStr(InfosLigne[0]);
              Query.ExecSQL();
            end;

            // recherche d'exercice
            Query.SQL.Text := 'select COL_ID from ARTCOLLECTION where COL_CODE = ' + QuotedStr(InfosLigne[0]) + ';';
            Query.Open();
            if Query.eof then
            begin
              Query.Close();
              // recup du dl'id collection
              Query.SQL.Text := 'select ID from PR_NEWK(''ARTCOLLECTION'')';
              Query.Open();
              idCollection := Query.FieldByName('ID').AsInteger;
              Query.Close();
              // insert de la collection
              Query.SQL.Text := 'insert into ARTCOLLECTION '
                              + ' (COL_ID, COL_NOM, COL_NOVISIBLE, COL_REFDYNA, COL_CODE, COL_CENTRALE, COL_ACTIVE, COL_DTDEB, COL_DTFIN, COL_EXEID) '
                              + 'values ('
                              + IntToStr(idCollection) + ', '
                              + QuotedStr(InfosLigne[1]) + ', '
                              + '0, '
                              + '0, '
                              + QuotedStr(InfosLigne[0]) + ', '
                              + '6, '
                              + '1, '
                              + QuotedStr(InfosLigne[2]) + ', '
                              + QuotedStr(InfosLigne[3]) + ', '
                              + IntToStr(idExercice) + ');';
              Query.ExecSQL();
            end
            else
            begin
              idCollection := Query.FieldByName('COL_ID').AsInteger;
              Query.Close();
              // mise a jour de k
              Query.SQL.Text := 'execute procedure PR_UPDATEK(' + IntToStr(idCollection) + ', 0);';
              Query.ExecSQL();
              // update de la collection
              Query.SQL.Text := 'update ARTCOLLECTION set '
                              + 'COL_NOM = ' + QuotedStr(InfosLigne[1]) + ', '
                              + 'COL_NOVISIBLE = 0, '
                              + 'COL_REFDYNA = 0, '
                              + 'COL_CENTRALE = 6, '
                              + 'COL_ACTIVE = 1, '
                              + 'COL_DTDEB = ' + QuotedStr(InfosLigne[2]) + ', '
                              + 'COL_DTFIN = ' + QuotedStr(InfosLigne[3]) + ', '
                              + 'COL_EXEID = ' + IntToStr(idExercice)
                              + ' where COL_ID = '+ IntToStr(idCollection)
                              + ' and COL_CODE = '+ QuotedStr(InfosLigne[0]);
              Query.ExecSQL();
            end;
          finally
            FreeAndNil(InfosLigne);
          end;
        end;
        Transaction.Commit();
        MessageDlg('Traitement effectué correctement.', mtInformation, [mbOK], 0);
      except
        on e : Exception do
        begin
          Transaction.Rollback();
          MessageDlg('Erreur lors du traitement : ' + e.Message, mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(txtFile);
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

procedure Tfrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

end.
