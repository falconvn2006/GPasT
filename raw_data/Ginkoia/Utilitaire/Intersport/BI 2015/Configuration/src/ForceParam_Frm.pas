unit ForceParam_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin;

type
  Tfrm_ForceParam = class(TForm)
    grp_Generaux: TGroupBox;
    lbl_Intervalle: TLabel;
    lbl_ResetStock: TLabel;
    lbl_NiveauLog: TLabel;
    lbl_PlageStop: TLabel;
    sed_Intervalle: TSpinEdit;
    dtp_ResetStock: TDateTimePicker;
    cbx_NiveauLog: TComboBox;
    GridPanel1: TGridPanel;
    dtp_PlageStopFin: TDateTimePicker;
    dtp_PlageStopDeb: TDateTimePicker;
    btn_Valider: TButton;
    btn_Annuler: TButton;
    btn_Default: TButton;

    procedure ValuesChange(Sender: TObject);
    procedure btn_DefaultClick(Sender: TObject);
    procedure btn_ValiderClick(Sender: TObject);
    procedure btn_AnnulerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure SaveForceParam(Serveur, Fichier : string);
    function MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
  end;

implementation

uses
  uGestionBDD;

{$R *.dfm}

{ Tfrm_ForceParam }

procedure Tfrm_ForceParam.ValuesChange(Sender: TObject);
begin
  btn_Default.Enabled := true;
end;

procedure Tfrm_ForceParam.btn_DefaultClick(Sender: TObject);
begin
  sed_Intervalle.Value := 15;
  dtp_ResetStock.DateTime := EncodeDate(1899, 12, 30) + EncodeTime(20, 30, 0, 0);
  cbx_NiveauLog.ItemIndex := 1;
  dtp_PlageStopDeb.DateTime := EncodeDate(1899, 12, 30) + EncodeTime(21, 30, 0, 0);
  dtp_PlageStopFin.DateTime := EncodeDate(1899, 12, 30) + EncodeTime(7, 0, 0, 0);
  btn_Default.Enabled := false;
end;

procedure Tfrm_ForceParam.btn_ValiderClick(Sender: TObject);
begin
  // eurf
end;

procedure Tfrm_ForceParam.btn_AnnulerClick(Sender: TObject);
begin
  // eurf
end;

procedure Tfrm_ForceParam.SaveForceParam(Serveur, Fichier : string);
var
  Connexion : TMyConnection;
  Transaction : TMyTransaction;
  Querylst, QueryMaj : TMyQuery;
  PrmId : integer;
begin
  PrmId := 0;

  Connexion := GetNewConnexion(Serveur, Fichier, CST_BASE_LOGIN, CST_BASE_PASSWORD, false);
  try
    Transaction := GetNewTransaction(Connexion, false);
    try
      Connexion.Open();
      Transaction.StartTransaction();
      try
        PrmId := 0;
        QueryMaj := GetNewQuery(Connexion, Transaction);
        Querylst := GetNewQuery(Connexion, Transaction);
        try
          Querylst.SQL.Text := 'select prm_id, prm_magid, prm_code, prm_integer, prm_float, prm_string '
                             + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                             + 'where prm_type = 25 and prm_code in (3, 4, 7);';
          try
            // liste des paramètre
            Querylst.Open();
            while not Querylst.Eof do
            begin
              // ID
              PrmId := Querylst.FieldByName('prm_id').AsInteger;
              // paramètre généraux
              case Querylst.FieldByName('prm_code').AsInteger of
                3 : // Intervalle de temps entre deux export + heure d'export de stock
                  if not ((sed_Intervalle.Value = Querylst.FieldByName('prm_integer').AsInteger) and (dtp_ResetStock.DateTime = TDateTime(Querylst.FieldByName('prm_code').AsFloat))) then
                  begin
                    QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(sed_Intervalle.Value) + ', prm_float = ' + StringReplace(FloatToStr(Double(dtp_ResetStock.Time)), FormatSettings.DecimalSeparator, '.', []) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                    QueryMaj.ExecSQL();
                    QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                    QueryMaj.ExecSQL();
                  end;
                4 : // Niveau de log
                  if not (cbx_NiveauLog.ItemIndex = Querylst.FieldByName('prm_integer').AsInteger) then
                  begin
                    QueryMaj.SQL.Text := 'update genparam set prm_integer = ' + IntToStr(cbx_NiveauLog.ItemIndex) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                    QueryMaj.ExecSQL();
                    QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                    QueryMaj.ExecSQL();
                  end;
                7 : // plage d'arret
                  begin
                    QueryMaj.SQL.Text := 'update genparam set prm_string = ' + QuotedStr(FormatDateTime('hh:nn', dtp_PlageStopDeb.Time) + '|' + FormatDateTime('hh:nn', dtp_PlageStopFin.Time)) + ' where prm_id = ' + IntToStr(PrmId) + ';';
                    QueryMaj.ExecSQL();
                    QueryMaj.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(PrmId) + ', 0);';
                    QueryMaj.ExecSQL();
                  end;
              end;
              Querylst.Next();
            end;
          finally
            Querylst.Close();
          end;
        finally
          FreeAndNil(Querylst);
          FreeAndNil(QueryMaj);
        end;
        // ici ? commit !
        Transaction.Commit();
      except
        on e : Exception do
        begin
          Transaction.Rollback();
          MessageDlg('Erreur lors de l''enregistrement des paramètre (prm_id = ' + IntToStr(PrmId) + ') : ' + #13#10 + e.ClassName + ' - ' + e.Message, mtError, [mbOK]);
          Exit;
        end;
      end;
    finally
      FreeAndNil(Transaction);
    end;
  finally
    FreeAndNil(Connexion);
  end;
end;

// dialogue

function Tfrm_ForceParam.MessageDlg(const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons): Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
    try
      Position := poOwnerFormCenter;
      Result := ShowModal();
    finally
      Free;
    end;
end;

end.
