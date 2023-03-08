{$REGION 'Documentation'}
///	<summary>
///	  Unité de sélection des fichiers zip sur la lame.
///	</summary>
///	<remarks>
///	  Utilisée uniquement si plus d'un fichier zip pour le même client
///	</remarks>
{$ENDREGION}
unit SelectFile_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  //Début Uses Perso
  uLamefileparser,
  //Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrm_SelectFile = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    lstFiles: TListBox;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  A la créaion de la forme la liste est remplie à partir de classe
    ///	  Tlamefileparser, qui a prééalablement recherché les fichiers pour le
    ///	  client concerné.
    ///	</summary>
    {$ENDREGION}
    procedure FormCreate(Sender: TObject);

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  Le fichier sélectionné est placé dans la propriété FileToDownload de
    ///	  la classe TlameFileParser
    ///	</summary>
    {$ENDREGION}
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_SelectFile: TFrm_SelectFile;

implementation

{$R *.dfm}

procedure TFrm_SelectFile.btnCancelClick(Sender: TObject);
begin
 modalResult := mrCancel ;
 TLamefileParser.FiletoDownload := '';
end;

procedure TFrm_SelectFile.btnOkClick(Sender: TObject);
var i : integer ;
begin
 for i := 0 to lstFiles.Count-1 do
  begin
    if lstfiles.Selected[i] = True then
     begin
       Tlamefileparser.FiletoDownload := lstfiles.Items[i] ;
       break ;
     end;
  end;
 if Tlamefileparser.FiletoDownload <> '' then 
    modalResult := mrOK else
     begin
       Beep ;
     end;
 
end;

procedure TFrm_SelectFile.FormCreate(Sender: TObject);
var fs : string ;
begin
 for fs in TLameFileParser.TClientFiles do
  begin 
    lstfiles.Items.Add(fs)     ;
    
  end;
end;

end.
