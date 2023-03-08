unit UnitRapport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, DateUtils;

type
  TFrm_Rapport = class(TForm)
    Pan_bas: TRzPanel;
    Btn_close: TButton;
    Memo_Rapport: TMemo;
    procedure Btn_closeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Rapport: TFrm_Rapport;

implementation

{$R *.dfm}

procedure TFrm_Rapport.Btn_closeClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Rapport.FormShow(Sender: TObject);
Var
  Chemin        : String;     //Chemin du fichier de log
  FileLogName   : String;     //Nom du fichier de log
Begin

  //Init de fichier log à charger
  Chemin      := IncludeTrailingPathDelimiter(ExtractFilePath(application.exename))+'Log\';
  FileLogName := Chemin+'Log_'+IntToStr(yearof(now))+'-'+IntToStr(monthof(now))+'-'+IntToStr(dayof(now))+'.log';

  //Chargement du log
  Memo_Rapport.Clear;
  Memo_Rapport.Lines.LoadFromFile(FileLogName);
end;

end.
