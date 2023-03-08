unit OCExport_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, AlgolDialogForms,
  Dialogs, StdCtrls, AdvGlowButton, RzLabel, ExtCtrls, RzPanel, Main_Dm, Db;

type
  Tfrm_OCExport = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_Ou: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Gbx_Top: TGroupBox;
    Lab_File: TLabel;
    edt_File: TEdit;
    Nbt_file: TAdvGlowButton;
    SD_File: TSaveDialog;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_fileClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_OCExport: Tfrm_OCExport;

implementation

{$R *.dfm}

procedure Tfrm_OCExport.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_OCExport.Nbt_fileClick(Sender: TObject);
begin
  if SD_File.Execute then
    edt_File.Text := SD_File.FileName;
end;

procedure Tfrm_OCExport.Nbt_PostClick(Sender: TObject);
var
  i : integer;
  FileStream : TFileStream;
  sLigne : String;
  Buffer : TBytes;
  Encoding : TEncoding;

begin
  if Trim(edt_File.Text) <> '' then
  begin
    With Dm_Main.QTemp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select OSM_MAGCODE, MAG_NOM, MAG_VILLE, DOS_NOM, OSO_NOM, OSM_DEBUT, OSM_FIN');
      SQL.Add('  from [DATABASE].DBO.OCSP2K');
      SQL.Add('  Join [DATABASE].DBO.OCSP2KMAG on OSM_OSOID = OSO_ID');
      SQL.Add('  Join [SP2000CATMAN].DBO.MAGASIN on MAG_CODE = OSM_MAGCODE');
      SQL.Add('  Join [SP2000CATMAN].DBO.DOSSIERS on MAG_DOSID = DOS_ID');
      SQL.Add('ORDER BY OSO_NOM, OSM_MAGCODE');
      Open;

      First;
      if  LowerCase(ExtractFileExt(edt_File.Text)) <> '.csv' then
        edt_File.Text := edt_File.Text + '.csv';


      if FileExists(edt_File.Text) then
      begin
        FileStream := TFileStream.Create(edt_File.Text,fmCreate,fmOpenReadWrite);
        FileStream.Seek(0,soFromEnd);
      end else
        FileStream := TFileStream.Create(edt_File.Text,fmCreate,fmCreate);

      try
        while not EOF do
        begin
          sLigne := '';
          for i := 0 to FieldCount -1 do
          begin
            case Fields.fields[i].DataType of
              ftDateTime, ftDate : begin
                 sLigne := sLigne + FormatDateTime('DD/MM/YYYY', Fields.Fields[i].AsDateTime) + ';';
              end;
              else begin
                sLigne := sLigne + Fields.Fields[i].AsString + ';';
              end;
            end;
          end;

          sLigne := Copy(sLigne,1,Length(sLigne) -1) + #13#10;

          Encoding := TEncoding.Default;
          Buffer := Encoding.GetBytes(sLigne);
          FileStream.Write(Buffer[0],Length(Buffer));
          Next;
        end;
      finally
        FileStream.Free;
      end;
      ShowMessage('Export terminé');
      ModalResult := mrOk;
    end;
  end
  else
    ShowMessage('Veuillez indiquer un nom de fichier');
end;

end.
