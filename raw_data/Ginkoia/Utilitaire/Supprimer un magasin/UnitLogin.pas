unit UnitLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormLogin = class(TForm)
    Panel: TPanel;
    BtnOk: TBitBtn;
    BtnAnnuler: TBitBtn;
    EditLogin: TLabeledEdit;
    EditMotDePasse: TLabeledEdit;
    FDQuery: TFDQuery;

    procedure FormShow(Sender: TObject);
    procedure EditLoginKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditMotDePasseKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnOkClick(Sender: TObject);

  private
    function EstSuperUtilisateur: Boolean;
    function EstUtilisateurHotline: Boolean;
    function Connexion: Boolean;

  public
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}

uses Unit1;

procedure TFormLogin.FormShow(Sender: TObject);
begin
   EditLogin.Text := '';
   EditMotDePasse.Text := '';
   EditLogin.SetFocus;
end;

procedure TFormLogin.EditLoginKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = 13 then
      EditMotDePasse.SetFocus;
end;

procedure TFormLogin.EditMotDePasseKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = 13 then
      BtnOkClick(Sender);
end;

function TFormLogin.EstSuperUtilisateur: Boolean;
begin
   Result := False;

   // Recherche si utilisateur 'algol'.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select count(*)');
   FDQuery.SQL.Add('from UILUSERS');
   FDQuery.SQL.Add('join K on (K_ID = USR_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('join UILUSERACCESS  join K on (K_ID = USA_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('join UILPERMISSIONS  join k on (K_ID = PER_ID and K_ENABLED = 1) on (PER_ID = USA_PERID) on (USA_USRID = USR_ID)');
   FDQuery.SQL.Add('where USR_USERNAME = :USERNAME');
   FDQuery.SQL.Add('and PER_PERMISSION = ''SUPER''');
   try
      FDQuery.ParamByName('USERNAME').AsString := EditLogin.Text;
      FDQuery.Open;
   except
      on E: Exception do
      begin
         Application.MessageBox(PChar('Erreur :  la recherche si l''utilisateur [' + EditLogin.Text + '] est ''algol'' a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
   end;
   Result := (FDQuery.Fields[0].AsInteger > 0);
end;

function TFormLogin.EstUtilisateurHotline: Boolean;
begin
   Result := False;

   // Recherche si utilisateur 'hotline'.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select count(*)');
   FDQuery.SQL.Add('from UILUSERS');
   FDQuery.SQL.Add('join K on (K_ID = USR_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('where USR_HOTLINE = 1');
   FDQuery.SQL.Add('and USR_USERNAME = :USERNAME');
   try
      FDQuery.ParamByName('USERNAME').AsString := EditLogin.Text;
      FDQuery.Open;
   except
      on E: Exception do
      begin
         Application.MessageBox(PChar('Erreur :  la recherche si l''utilisateur [' + EditLogin.Text + '] est ''hotline'' a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
   end;
   Result := (FDQuery.Fields[0].AsInteger > 0);
end;

function TFormLogin.Connexion: Boolean;
begin
   Result := False;

   // Recherche de l'utilisateur.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select count(*)');
   FDQuery.SQL.Add('from UILUSERS');
   FDQuery.SQL.Add('join K on (K_ID = USR_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('where USR_USERNAME = :USERNAME');
   FDQuery.SQL.Add('and USR_PASSWORD = :PASSWORD');
   try
      FDQuery.ParamByName('USERNAME').AsString := EditLogin.Text;
      FDQuery.ParamByName('PASSWORD').AsString := EditMotDePasse.Text;
      FDQuery.Open;
   except
      on E: Exception do
      begin
         Application.MessageBox(PChar('Erreur :  la recherche de l''utilisateur a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
   end;
   Result := (FDQuery.Fields[0].AsInteger > 0);
end;

procedure TFormLogin.BtnOkClick(Sender: TObject);
begin
   // Si pas d'utilisateur.
   if EditLogin.Text = '' then
   begin
      Application.MessageBox('Attention :  il faut saisir un utilisateur !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
      EditLogin.SetFocus;
   end
   else
   begin
      // Si utilisateur 'algol' ou 'hotline'.
      if EstSuperUtilisateur or EstUtilisateurHotline then
      begin
         if Connexion then
            ModalResult := mrOk
         else
         begin
            Application.MessageBox('Attention :  le mot de passe est incorrect !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
            EditMotDePasse.SetFocus;
         end;
      end
      else
      begin
         Application.MessageBox('Attention :  cet utilisateur n''a pas les droits requis !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
         EditLogin.SetFocus;
      end;
   end;
end;

end.
