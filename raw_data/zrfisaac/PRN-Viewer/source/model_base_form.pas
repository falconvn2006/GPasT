// # [ about ]
// # - copyright
// # . - name : Isaac Caires
// # . - email : zrfisaac@gmail.com
// # . - site : https://sites.google.com/view/zrfisaac-en

// # [ lazarus ]
unit model_base_form;

{$mode objfpc}
{$H+}

interface

// # - library
uses
  // # : - lazarus
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls;

type

  { TModelBaseForm }

  TModelBaseForm = class(TForm)
    pnBack: TPanel;
  end;

var
  ModelBaseForm: TModelBaseForm;

implementation

{$R *.lfm}

end.

