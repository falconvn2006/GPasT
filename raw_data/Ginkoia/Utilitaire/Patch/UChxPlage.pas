//$Log:
// 2    Utilitaires1.1         08/08/2005 09:03:34    pascal          Divers
//      modifications suite aux demandes de st?phanes
// 1    Utilitaires1.0         04/07/2005 10:18:53    pascal          
//$
//$NoKeywords$
//
unit UChxPlage;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, wwdbdatetimepicker, wwDBDateTimePickerRv;

type
  Tfrm_chxplage = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Chp_Datedeb: TwwDBDateTimePickerRv;
    Chp_Datefin: TwwDBDateTimePickerRv;
    Cb_Version: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_chxplage: Tfrm_chxplage;

implementation

{$R *.DFM}

procedure Tfrm_chxplage.FormCreate(Sender: TObject);
begin
   Chp_Datedeb.Date := Date ;
   Chp_Datefin.Date := Date ;
end;

procedure Tfrm_chxplage.OKBtnClick(Sender: TObject);
begin
  IF (trim(Chp_Datedeb.text)='') or
     (trim(Chp_Datefin.text)='') or
     (trim(Cb_Version.text)='') then
    application.messagebox ('Vous avez oubliez de saisir un champ','impossible de valider',Mb_Ok)
  else
    modalresult := MrOk ;
end;

end.
