unit OCImport_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, AlgolDialogForms,
  Dialogs, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, DB, DBClient, Main_Dm, DateUtils, Types;

type
  Tfrm_OCImport = class(TAlgolDialogForm)
    Gbx_Top: TGroupBox;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_Ou: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Gbx_Client: TGroupBox;
    Lab_File: TLabel;
    edt_File: TEdit;
    Nbt_file: TAdvGlowButton;
    cds_Import: TClientDataSet;
    cds_ImportCodeMag: TStringField;
    cds_ImportNomOC: TStringField;
    cds_ImportDateDebut: TDateField;
    cds_ImportDateFin: TDateField;
    cds_ImportSupprimer: TIntegerField;
    mmLogs: TMemo;
    OD_File: TOpenDialog;
    procedure Nbt_fileClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_OCImport: Tfrm_OCImport;

implementation

{$R *.dfm}

procedure Tfrm_OCImport.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_OCImport.Nbt_fileClick(Sender: TObject);
var
  lst, lstLignes : TStringList;
  i, j : integer;
begin
  if OD_File.Execute then
  begin
    edt_File.Text := OD_File.FileName;

    mmLogs.Lines.Clear;
    mmLogs.Lines.Add('Chargement du fichier en mémoire : ' + OD_File.FileName);
    lst := TStringList.Create;
    lstLignes := TStringList.Create;
    try
      lst.LoadFromFile(OD_File.FileName);

      cds_Import.EmptyDataSet;

      for i := 0 to lst.count -1 do
      begin
        lstLignes.Text := StringReplace(lst[i],';',#13#10,[rfReplaceAll]);
        cds_Import.Append;
        Try
          for j := 0 to lstLignes.Count -1 do
            case j of
              // Code mag
              0: cds_Import.FieldByName('CodeMag').AsString := Trim(lstLignes[j]);
              1: cds_Import.FieldByName('NomOc').AsString := Trim(lstLignes[j]);
              2: cds_Import.FieldByName('DateDebut').AsDateTime := StrToDate(Trim(lstLignes[j]));
              3: cds_Import.FieldByName('DateFin').AsDateTime := StrToDate(Trim(lstLignes[j]));
              4: cds_Import.FieldByName('Supprimer').AsInteger := StrToInt(Trim(lstLignes[j]));
            end;
          cds_Import.Post;
        except on E:Exception do
          begin
            cds_Import.Cancel;
            mmLogs.Lines.Add(Format('Erreur sur la ligne %d : %s',[i,E.Message]));
          end;
        End;
      end;
    finally
      lst.Free;
      lstLignes.Free;
    end;
  end;
end;

procedure Tfrm_OCImport.Nbt_PostClick(Sender: TObject);
var
  OSO_ID, OSM_ID : integer;
  bCreate : Boolean;
  sNomOffre : String;
begin
  if cds_Import.RecordCount > 0 then
  begin
    cds_Import.First;

    sNomOffre := '';
    while not cds_Import.Eof do
    begin
      With Dm_Main.QTemp do
      begin
        // On ne traite pas les offres sans nom
        if Trim(cds_Import.FieldByName('NomOC').AsString) = '' then
        begin
          cds_Import.Next;
          Continue;
        end;

        if sNomOffre <> cds_Import.FieldByName('NomOC').AsString then
        begin
          sNomOffre := cds_Import.FieldByName('NomOC').AsString;
          bCreate := False;

          // Est ce que l'offre existe ?
          Close;
          SQL.Clear;
          SQL.Add('Select OSO_ID FROM [DATABASE].Dbo.OCSP2K');
          SQL.Add('Where OSO_NOM = :POSONOM and OSO_SUPP = 0');
          ParamCheck := True;
          Parameters.ParamByName('POSONOM').Value := cds_Import.FieldByName('NomOC').AsString;
          Open;

          if RecordCount = 0 then
          begin
            // Création de l'offre
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO [DATABASE].Dbo.OCSP2K(OSO_NOM,OSO_SUPP)');
            SQL.Add('VALUES (:POSONOM, 0)');
            ParamCheck := True;
            Parameters.ParamByName('POSONOM').Value := cds_Import.FieldByName('NomOC').AsString;
            ExecSQL;

            Close;
            SQL.Clear;
            SQL.Add('SELECT @@IDENTITY AS ''Identity'';');
            Open;

            OSO_ID := FieldByName('Identity').AsInteger;

            bCreate := True;
          end
          else
            OSO_ID := FieldByName('OSO_ID').AsInteger;
        end;

        // Est ce que le magasin est déjà (Recherche seulement si on a pas créé l'offre avant)
        if not bCreate then
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT OSM_ID, OSM_DEBUT, OSM_FIN from [DATABASE].Dbo.OCSP2KMAG');
          SQL.Add('Where OSM_OSOID = :POSOID and OSM_MAGCODE = :PMAGCODE');
          ParamCheck := True;
          Parameters.ParamByName('POSOID').Value := OSO_ID;
          Parameters.ParamByName('PMAGCODE').Value := cds_Import.FieldByName('CodeMag').AsString;
          Open;
        end;

        case cds_Import.FieldByName('Supprimer').AsInteger of
          0: begin
            if (RecordCount = 0) or bCreate then
            begin
              // Création de la ligne
              Close;
              SQL.Clear;
              SQL.Add('INSERT INTO [DATABASE].Dbo.OCSP2KMAG(OSM_OSOID, OSM_MAGCODE, OSM_DEBUT, OSM_FIN, OSM_CREER, OSM_OSMMODIF)');
              SQL.Add('VALUES(:POSOID, :PMAGCODE, :PDEBUT, :PFIN, :PCREER, :PMODIF)');
              ParamCheck := True;
              Parameters.ParamByName('POSOID').Value := OSO_ID;
              Parameters.ParamByName('PMAGCODE').Value := cds_Import.FieldByName('CodeMag').AsString;
              Parameters.ParamByName('PDEBUT').Value := cds_Import.FieldByName('DateDebut').AsDateTime;
              Parameters.ParamByName('PFIN').Value := cds_Import.FieldByName('DateFin').AsDateTime;
              Parameters.ParamByName('PCREER').Value := Now;
              Parameters.ParamByName('PMODIF').Value := Now;
              ExecSQL;
            end
            else begin
              OSM_ID := FieldbyName('OSM_ID').AsInteger;

              if (CompareDateTime(cds_Import.FieldByName('DateDebut').AsDateTime, FieldbyName('OSM_DEBUT').AsDateTime) <> EqualsValue) or
                 (CompareDateTime(cds_Import.FieldByName('DateFin').AsDateTime, FieldbyName('OSM_Fin').AsDateTime) <> EqualsValue) then
              begin
                Close;
                SQL.Clear;
                SQL.Add('UPDATE [DATABASE].Dbo.OCSP2KMAG SET');
                SQL.Add('  OSM_DEBUT = :PDEBUT, OSM_FIN = :FIN');
                SQL.Add('Where OSM_ID = :POSMID');
                ParamCheck := True;
                Parameters.ParamByName('PDEBUT').Value := cds_Import.FieldByName('DateDebut').AsDateTime;
                Parameters.ParamByName('PFIN').Value := cds_Import.FieldByName('DateFin').AsDateTime;
                Parameters.ParamByName('POSMID').Value := OSM_ID;
                ExecSQL;
              end;
            end;
          end; // 0
          1: begin
              Close;
              SQL.Clear;
              SQL.Add('DELETE FROM  [DATABASE].Dbo.OCSP2KMAG');
              SQL.Add('Where OSM_OSOID = :POSOID and OSM_MAGCODE = :PMAGCODE');
              ParamCheck := True;
              Parameters.ParamByName('POSOID').Value := OSO_ID;
              Parameters.ParamByName('PMAGCODE').Value := cds_Import.FieldByName('CodeMag').AsString;
              ExecSQL;
            end; // 1
          end; // case
        end;  // with
        cds_Import.Next;
      end; // while

      ModalResult := mrOk;
  end
  else
    ShowMessage('Pas de données à traiter.');
end;

end.
