{***************************************************************
 *
 * Unit Name: SelectDB_Frm
 * Purpose  :
 * Author   :
 * History  :
 *
 ****************************************************************}

//------------------------------------------------------------------------------
// Nom de l'unité : Admin_Dm
// Rôle           : Form de selection de la base de données
// Auteur         : Sylvain GHEROLD
// Historique     :
//------------------------------------------------------------------------------

UNIT SelectDB_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    inifiles, IB_Components, ExtCtrls, RzPanel, RzRadGrp, RzRadioGroupRv,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit,
  StdCtrls, LMDCustomButton, LMDButton;

TYPE
    TFrm_SelectDB = CLASS( TForm )
        Btn_OK: TLMDButton;
        Btn_Cancel: TLMDButton;
        OpCmb_Gdb: TLMDFileOpenEdit;
        GRb_: TRzRadioGroupRv;
    IbC_TestConnection: TIB_Connection;
        PROCEDURE Btn_CancelClick( Sender: TObject );
        PROCEDURE Btn_OKClick( Sender: TObject );
    private
    { Déclarations privées }
        Ini: TIniFile;
    public
    { Déclarations publiques }
        FUNCTION Execute: boolean;
    END;

VAR
    Frm_SelectDB: TFrm_SelectDB;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES ConstStd;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

FUNCTION TFrm_SelectDB.Execute: boolean;
BEGIN
    Result := False;
    TRY
        Ini := TIniFile.Create(ChangeFileExt ( Application.ExeName, '.ini' ));
        Grb_.ItemIndex := Ini.ReadInteger( 'DATABASE', 'DIALECTSQL', 3 ) - 1;
        OpCmb_Gdb.Text := Ini.readString( 'DATABASE', 'PATH', '' );
        OpCmb_Gdb.InitialDir := ExtractFileDir( OpCmb_Gdb.Text );
        IF ShowModal = mrOK THEN
        BEGIN
            // Test de la connection à la base
            IbC_TestConnection.Params.Values[ 'PATH' ] := OpCmb_Gdb.Text;
            IbC_TestConnection.Params.Values[ 'USER NAME' ] := Ini.readString( 'DATABASE',
                'USERNAME', 'SYSDBA' );
            IbC_TestConnection.Params.Values[ 'PASSWORD' ] := Ini.readString( 'DATABASE',
                'PASSWORD', 'masterkey' );
            IbC_TestConnection.SQLDialect := Ini.ReadInteger( 'DATABASE', 'SQLDIALECT', 3 );
            TRY
                IbC_TestConnection.Connected := True;
                Result := True;
                IbC_TestConnection.Connected := False;
            EXCEPT
                  MessageDlg('Base de données non trouvée ...     ', mtError, [mbOK], 0);
            END;
            if Result then
            begin
               Ini.writestring( 'DATABASE', 'PATH', OpCmb_Gdb.Text );
               Ini.WriteInteger( 'DATABASE', 'DIALECTSQL', Grb_.ItemIndex + 1 );
            end;
         END;
    FINALLY
        Ini.Free;
    END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_SelectDB.Btn_CancelClick( Sender: TObject );
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE TFrm_SelectDB.Btn_OKClick( Sender: TObject );
BEGIN
    ModalResult := mrOk;
END;

END.

