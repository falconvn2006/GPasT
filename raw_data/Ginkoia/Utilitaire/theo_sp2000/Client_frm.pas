//$Log:
// 1    Utilitaires1.0         19/12/2006 08:48:55    pascal          
//$
//$NoKeywords$
//
unit Client_frm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, Dialogs, Db, IBCustomDataSet, IBQuery, IBDatabase;

type
   Tfrm_client = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      Bevel1: TBevel;
      Label1: TLabel;
      ed_base: TEdit;
      SpeedButton1: TSpeedButton;
      Od: TOpenDialog;
      Label2: TLabel;
      ed_clt: TEdit;
      Label3: TLabel;
      Button1: TButton;
      data: TIBDatabase;
      tran: TIBTransaction;
      qry: TIBQuery;
      ed_adh: TComboBox;
      procedure SpeedButton1Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure OKBtnClick(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
   end;

var
   frm_client: Tfrm_client;

implementation

{$R *.DFM}

procedure Tfrm_client.SpeedButton1Click(Sender: TObject);
begin
   if od.execute then
      ed_base.text := od.filename;
end;

procedure Tfrm_client.Button1Click(Sender: TObject);
begin
   ed_adh.Items.Clear;
   data.databasename := ed_base.Text;
   data.open;
   qry.open;
   while not qry.eof do
   begin
      ed_adh.Items.add(qry.fields[0].asString);
      qry.next;
   end;
   qry.close;
   data.close ;
end;

procedure Tfrm_client.OKBtnClick(Sender: TObject);
begin
   if ed_base.Text = '' then
   begin
      application.MessageBox('la base est obligatoire', 'erreur', mb_ok);
      ed_base.setfocus;
   end else if ed_clt.Text = '' then
   begin
      application.MessageBox('le nom du client est obligatoire', 'erreur', mb_ok);
      ed_clt.setfocus;
   end else if ed_adh.Text = '' then
   begin
      application.MessageBox('le code adhérent est obligatoire', 'erreur', mb_ok);
      ed_adh.setfocus;
   end
   else
      modalresult := mrok;
end;

end.

