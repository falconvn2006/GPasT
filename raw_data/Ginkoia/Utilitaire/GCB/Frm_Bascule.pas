unit Frm_Bascule;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,System.DateUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

Const start=2011;

type
  TForm_Bascule = class(TForm)
    grpSource: TGroupBox;
    grpDestination: TGroupBox;
    Panel1: TPanel;
    BFERMER: TBitBtn;
    BExecute: TBitBtn;
    Label1: TLabel;
    BClean: TBitBtn;
    Label2: TLabel;
    procedure BFERMERClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BExecuteClick(Sender: TObject);
    procedure BCleanClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form_Bascule: TForm_Bascule;

implementation

USes UCommun,UDataMod, Frm_Main;

{$R *.dfm}

procedure TForm_Bascule.BFERMERClick(Sender: TObject);
begin
    Close;
end;

procedure TForm_Bascule.BCleanClick(Sender: TObject);
var vQuery:TFDQuery;
    i:integer;
    AComponent:TComponent;
    vTemp        : string;
    vDestination : string;
    vDebut,vFin,VNew : string;
    vnbModif         : integer;
begin
    BExecute.Enabled:=false;
    BClean.Enabled:=false;
    vtemp        := '';
    vDestination := '';
    for i:=0 to YearOf(Now()) - start + 1  do
        begin
            vtemp:=vtemp+'_';
            AComponent := FindComponent(format('cbd_%d',[i+11])) ;
            if (AComponent<>nil)
               then
                   begin
                     if TRadioButton(AComponent).Checked
                        then vDestination := vDestination + '1'
                        else vDestination := vDestination + '_';
                   end;
        end;

    vQuery := TFDQuery.Create(nil);
    try
      // On complete avec les zéros manquants vers la droite !
      vQuery.Connection := DataMod.FDConLiteGCTRLB;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SCRCTRL ');
      vQuery.SQL.Add(' WHERE SCT_VERSION NOT LIKE '''+ vtemp +''' OR SCT_VERSION IS NULL');
      vQuery.SQL.Add(' ORDER BY SCT_ID ');
      vQuery.open;
      while not(vQuery.Eof) do
        begin
            vQuery.Edit;
            while vQuery.FieldByName('SCT_VERSION').asstring.Length<vtemp.Length
               do
                begin
                    vQuery.FieldByName('SCT_VERSION').asstring := vQuery.FieldByName('SCT_VERSION').asstring + '0';
                end;
            vQuery.Post;
            vQuery.Next;
        end;
      // -----------------------------------------------------------------------
      // Toute la table
      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SCRCTRL ');
      vQuery.SQL.Add(' ORDER BY SCT_ID ');
      vQuery.open;
      vnbModif := 0;
      while not(vQuery.Eof) do
        begin
            i:=0;
            while i<vDestination.length do
              begin
                  if vDestination[i]='1'
                    then
                       begin
                            vdebut := Copy(vQuery.FieldByName('SCT_VERSION').asstring,0,i-1);
                            vFin   := Copy(vQuery.FieldByName('SCT_VERSION').asstring,i+1,vDestination.length);
                            // On passe à zero
                            vNew := vDebut + '0' + vFin;
                            // ShowMessage(vQuery.FieldByName('SCT_VERSION').asstring + #13 + #10 + vNew);
                            if VNew<>vQuery.FieldByName('SCT_VERSION').asstring
                              then
                                  begin
                                      vQuery.Edit;
                                      vQuery.FieldByName('SCT_VERSION').asstring := vNew;
                                      vQuery.Post;
                                      Inc(vnbModif);
                                  end;
                       end;
                  Inc(i);
              end;
            vQuery.Next;
        end;
        MessageDlg(Format('%d enregistrements ont été mis à jour.',[vnbModif]),  mtInformation, [mbOK], 0);
    finally
     vQuery.Close;
     vQuery.DisposeOf;
     BExecute.Enabled:=true;
     BClean.Enabled:=true;
    end;
end;

procedure TForm_Bascule.BExecuteClick(Sender: TObject);
var vQuery:TFDQuery;
    i:integer;
    AComponent:TComponent;
    vTemp        : string;
    vSource      : string;
    vDestination : string;
    vDebut,vFin,VNew : string;
    vnbModif         : integer;
begin
    BExecute.Enabled:=false;
    BClean.Enabled:=false;
    vtemp        := '';
    vDestination := '';
    vSource      := '';
    for i:=0 to YearOf(Now()) - start + 1  do
        begin
            vtemp:=vtemp+'_';
            AComponent := FindComponent(format('cbs_%d',[i+11])) ;
            if (AComponent<>nil)
               then
                   begin
                     if TRadioButton(AComponent).Checked
                        then vSource := vSource + '1'
                        else vSource := vSource + '_';
                   end;

            AComponent := FindComponent(format('cbd_%d',[i+11])) ;
            if (AComponent<>nil)
               then
                   begin
                     if TRadioButton(AComponent).Checked
                        then vDestination := vDestination + '1'
                        else vDestination := vDestination + '_';
                   end;
        end;

    vQuery := TFDQuery.Create(nil);
    try
      // On complete avec les zéros manquants vers la droite !
      vQuery.Connection := DataMod.FDConLiteGCTRLB;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SCRCTRL ');
      vQuery.SQL.Add(' WHERE SCT_VERSION NOT LIKE '''+ vtemp +''' OR SCT_VERSION IS NULL');
      vQuery.SQL.Add(' ORDER BY SCT_ID ');
      vQuery.open;
      while not(vQuery.Eof) do
        begin
            vQuery.Edit;
            while vQuery.FieldByName('SCT_VERSION').asstring.Length<vtemp.Length
               do
                begin
                    vQuery.FieldByName('SCT_VERSION').asstring := vQuery.FieldByName('SCT_VERSION').asstring + '0';
                end;
            vQuery.Post;
            vQuery.Next;
        end;
      // -----------------------------------------------------------------------
      vQuery.Close;
      vQuery.SQL.Clear;
      vQuery.SQL.Add('SELECT * FROM SCRCTRL ');
      vQuery.SQL.Add(' WHERE SCT_VERSION LIKE '''+ vSource +'''');
      vQuery.SQL.Add(' ORDER BY SCT_ID ');
      vQuery.open;
      vnbModif := 0;
      while not(vQuery.Eof) do
        begin
            i:=0;
            while i<vDestination.length do
              begin
                  if vDestination[i]='1' // Signifie que c'est coché
                    then
                       begin
                            vdebut := Copy(vQuery.FieldByName('SCT_VERSION').asstring,0,i-1);
                            vFin   := Copy(vQuery.FieldByName('SCT_VERSION').asstring,i+1,vDestination.length);
                            // passe à 1 donc
                            vNew := vDebut + '1' + vFin;
                            // ShowMessage(vQuery.FieldByName('SCT_VERSION').asstring + #13 + #10 + vNew);
                            if VNew<>vQuery.FieldByName('SCT_VERSION').asstring
                              then
                                  begin
                                      vQuery.Edit;
                                      vQuery.FieldByName('SCT_VERSION').asstring := vNew;
                                      vQuery.Post;
                                      Inc(vnbModif);
                                  end;
                       end;
                  Inc(i);
              end;
            vQuery.Next;
        end;
        MessageDlg(Format('%d enregistrements ont été mis à jour.',[vnbModif]),  mtInformation, [mbOK], 0);
    finally
     vQuery.Close;
     vQuery.DisposeOf;
     BExecute.Enabled:=true;
     BClean.Enabled:=true;
    end;
end;

procedure TForm_Bascule.FormCreate(Sender: TObject);
var i:integer;
    ACheckBox:TRadioButton;
begin
    for i:=0 to YearOf(Now())- start + 1  do
       begin
          ACheckBox:=TRadioButton.Create(self);
          ACheckBox.Parent:=grpSource;
          ACheckBox.Top  := 14 + 23 * (i mod 3);
          ACheckBox.left := 14 + 57 * (i div 3);
          ACheckBox.Name:=format('cbs_%d',[i+11]);
          ACheckBox.Caption:=Format('V %d',[i+11]);
          ACheckBox.Enabled:=true;
       end;
    for i:=0 to YearOf(Now())- start + 1  do
       begin
          ACheckBox:=TRadioButton.Create(self);
          ACheckBox.Parent:=grpDestination;
          ACheckBox.Top  := 14 + 23 * (i mod 3);
          ACheckBox.left := 14 + 57 * (i div 3);
          ACheckBox.Name:=format('cbd_%d',[i+11]);
          ACheckBox.Caption:=Format('V %d',[i+11]);
          ACheckBox.Enabled:=true;
       end;
end;

end.
