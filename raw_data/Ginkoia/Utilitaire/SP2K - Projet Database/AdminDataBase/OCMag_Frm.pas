unit OCMag_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, AlgolDialogForms,
  Dialogs, StdCtrls, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP,
  AdvGlowButton, RzLabel, ExtCtrls, RzPanel, Main_Dm, ComCtrls, Boxes,
  PanBtnDbgHP, dxDBTLCl, dxGrClms, DB, DBClient;

type


  Tfrm_OCMag = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_Ou: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    DBG_ListMag: TdxDBGridHP;
    Gbx_Bottom: TGroupBox;
    Ds_lstMagOC: TDataSource;
    DBG_ListMagmag_id: TdxDBGridMaskColumn;
    DBG_ListMagmag_code: TdxDBGridMaskColumn;
    DBG_ListMagmag_nom: TdxDBGridMaskColumn;
    DBG_ListMagmag_ville: TdxDBGridMaskColumn;
    DBG_ListMagdos_nom: TdxDBGridMaskColumn;
    Pan_Mag: TPanelDbg;
    Lab_Debut: TLabel;
    Lab_Fin: TLabel;
    dtp_Debut: TDateTimePicker;
    Dtp_Fin: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    FIdOffre: Integer;
    { Déclarations privées }
  public
    { Déclarations publiques }
  published
    property IdOffre : Integer read FIdOffre write FIdOffre;
  end;

var
  frm_OCMag: Tfrm_OCMag;

implementation

{$R *.dfm}

procedure Tfrm_OCMag.FormCreate(Sender: TObject);
begin
 Dm_Main.QlistMag.Active := true;
 dtp_Debut.Date := Now;
 Dtp_Fin.Date := Now;
end;

procedure Tfrm_OCMag.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_OCMag.Nbt_PostClick(Sender: TObject);
var
  i : Integer;
  MAG_CODE : String;
begin
  if dtp_Debut.Date > Dtp_Fin.Date then
  begin
    ShowMessage('La date de début doit être inférieure à celle de fin');
    Exit;
  end;

  if DBG_ListMag.SelectedCount > 0 then
  begin
    for I := 0 to DBG_ListMag.SelectedCount -1 do
    begin
      MAG_CODE := DBG_ListMag.GetvalueByFieldName(DBG_ListMag.SelectedNodes[I], 'mag_code');

      Dm_Main.ado.BeginTrans;
      With Dm_Main.QTemp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT count(*) as Resultat from [DATABASE].Dbo.OCSP2KMAG');
        SQL.Add('Where OSM_MAGCODE = :PMAGCODE and OSM_OSOID = :POSOID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGCODE').Value := MAG_CODE;
        Parameters.ParamByName('POSOID').Value := IdOffre;
        Open;

        if FieldByName('Resultat').AsInteger = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO [DATABASE].dbo.OCSP2KMAG(OSM_OSOID, OSM_MAGCODE, OSM_DEBUT, OSM_FIN, OSM_CREER, OSM_OSMMODIF)');
          SQL.Add('  VALUES (:POSOID, :PMAGCODE, :PDEBUT, :PFIN, :PCREER, :PMODIF)');
          ParamCheck := True;
          Parameters.ParamByName('POSOID').Value   := IdOffre;
          Parameters.ParamByName('PMAGCODE').Value := MAG_CODE;
          Parameters.ParamByName('PDEBUT').Value   := dtp_Debut.Date;
          Parameters.ParamByName('PFIN').Value     := Dtp_Fin.Date;
          Parameters.ParamByName('PCREER').Value   := Now;
          Parameters.ParamByName('PMODIF').Value   := Now;
          ExecSQL;
        end;
      end;
      Dm_Main.ado.CommitTrans;
    end;

    ModalResult := mrOk;
  end;
end;

end.
