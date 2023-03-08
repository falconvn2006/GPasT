//------------------------------------------------------------------------------
// Nom de l'unité : Admin_Dm
// Rôle           : Form de selection du type de réplication
// Auteur         : Sylvain GHEROLD
// Historique     :
//------------------------------------------------------------------------------

UNIT SelectRepl_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, StdCtrls, Mask, wwdbedit,
  wwDBEditRv, LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel,
  LMDBaseEdit, LMDCustomEdit, LMDEdit, LMDEditRv, LMDCustomButton,
  LMDButton, RzLabel;

TYPE
    TFrm_SelectRepl = CLASS( TForm )
        Btn_OK: TLMDButton;
        Btn_Cancel: TLMDButton;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        Ed_TableName: TLMDEditRv;
        Ed_KTBID: TwwDBEditRv;
        Cmb_ReplType: TwwDBComboBoxRv;
        PROCEDURE Btn_CancelClick( Sender: TObject );
        PROCEDURE Btn_OKClick( Sender: TObject );
        PROCEDURE Cmb_ReplTypeChange( Sender: TObject );
        PROCEDURE FormCloseQuery( Sender: TObject; VAR CanClose: Boolean );
        PROCEDURE FormShow( Sender: TObject );
    private
    { Déclarations privées }
    public
    { Déclarations publiques }
        FUNCTION Execute( TableName: STRING ): integer;
    END;

VAR
    Frm_SelectRepl: TFrm_SelectRepl;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES ConstStd,
    Admin_Dm;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

FUNCTION TFrm_SelectRepl.Execute( TableName: STRING ): integer;
BEGIN
    Result := 0;
    WITH TFrm_SelectRepl.Create( Application ) DO
    BEGIN
        TRY
            Ed_TableName.Text := TableName;
            Cmb_ReplType.Text := Cmb_ReplType.Items[ 0 ];
            IF ShowModal = mrOK THEN
            BEGIN
                Result := StrToInt( Ed_KTBID.Text );
            END;
        FINALLY
            Free;
        END;
    END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_SelectRepl.Btn_CancelClick( Sender: TObject );
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE TFrm_SelectRepl.Btn_OKClick( Sender: TObject );
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_SelectRepl.Cmb_ReplTypeChange( Sender: TObject );
BEGIN
    Ed_KTBID.Text := Dm_Admin.GetNewKTBID( Cmb_ReplType.Text );
END;

PROCEDURE TFrm_SelectRepl.FormCloseQuery( Sender: TObject;
    VAR CanClose: Boolean );
BEGIN
    IF ModalResult = mrOk THEN
        CanClose := Dm_Admin.ValidKTBID( StrToInt( Ed_KTBID.Text ) );
    IF NOT CanClose THEN Ed_KTBID.SetFocus;
END;

PROCEDURE TFrm_SelectRepl.FormShow( Sender: TObject );
BEGIN
    Cmb_ReplType.SetFocus;
END;

END.

