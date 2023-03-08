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
  LMDCustomControl,
  LMDCustomPanel,
  LMDCustomBevelPanel,
  LMDBaseEdit,
  LMDCustomEdit,
  LMDCustomBrowseEdit,
  //LMDFileOpenEdit,
  StdCtrls,
  LMDCustomButton,
  LMDButton,
  ExtCtrls,
  RzPanel,
  RzRadGrp,
  RzRadioGroupRv,
  LMDCustomFileEdit,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  Mask,
  wwdbedit,
  wwDBEditRv;

TYPE
  TFrm_SelectDB = CLASS(TForm)
    Btn_OK: TLMDButton;
    Btn_Cancel: TLMDButton;
    OpCmb_Gdb: TOpenDialog;
    GRb_: TRzRadioGroupRv;
    Chp_choixBases: TwwDBEditRv;
    Nbt_choixBase: TLMDSpeedButton;
    PROCEDURE Btn_CancelClick(Sender: TObject);
    PROCEDURE Btn_OKClick(Sender: TObject);
    PROCEDURE Nbt_choixBaseClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
  END;

  //------------------------------------------------------------------------------
  // Ressources strings
  //------------------------------------------------------------------------------
  //ResourceString

FUNCTION TFrm_SelectDBExecute: boolean;

IMPLEMENTATION
{$R *.DFM}
USES
  GinkoiaStd;

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

FUNCTION TFrm_SelectDBExecute: boolean;
VAR
  Frm_SelectDB: TFrm_SelectDB;
  ch: STRING;
BEGIN
  Result := False;
  application.createform(TFrm_SelectDB, Frm_SelectDB);
  TRY
    TRY
      Frm_SelectDB.Grb_.ItemIndex := StdGinkoia.iniCtrl.ReadInteger('DATABASE', 'DIALECTSQL', 3) - 1;
      Frm_SelectDB.chp_choixbases.text := StdGinkoia.iniCtrl.readString('DATABASE', 'PATH', '');
      Frm_SelectDB.OpCmb_Gdb.InitialDir := ExtractFileDir(Frm_SelectDB.chp_choixbases.text);
    EXCEPT
    END;
    IF Frm_SelectDB.ShowModal = mrOK THEN
    BEGIN
      // formatage du chemin en cas de réseau !
      ch := Frm_SelectDB.chp_choixbases.text;
      IF copy(ch, 1, 2) = '\\' THEN
      BEGIN
        Delete(ch, 1, 2);
        ch[pos('\', ch)] := ':';
        insert(':', ch, pos('\', ch));
      END;
      StdGinkoia.iniCtrl.writestring('DATABASE', 'PATH', ch);
      StdGinkoia.iniCtrl.WriteInteger('DATABASE', 'DIALECTSQL', Frm_SelectDB.Grb_.ItemIndex + 1);
      StdGinkoia.iniCtrl.WriteString('NOMBASES', 'ITEM', 'TOTO');
      StdGinkoia.iniCtrl.WriteString('NOMMAGS', 'MAG', 'TOTO');
      StdGinkoia.iniCtrl.WriteString('NOMPOSTE', 'POSTE', 'TOTO');
      Result := True;
    END;
  FINALLY
    Frm_SelectDB.release;
  END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_SelectDB.Btn_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

PROCEDURE TFrm_SelectDB.Btn_OKClick(Sender: TObject);
BEGIN
  ModalResult := mrOk;
END;

PROCEDURE TFrm_SelectDB.Nbt_choixBaseClick(Sender: TObject);
BEGIN
  OpCmb_Gdb.InitialDir := GetCurrentDir;
  OpCmb_Gdb.Options := [ofFileMustExist];
  IF OpCmb_Gdb.Execute THEN
  BEGIN
    Chp_choixBases.Text := OpCmb_Gdb.FileName;
  END;
END;

END.

