unit TRenderEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, dataTypes,BCLabel, bgraControls,BCTypes, BCPanel, SysUtils;

type

  { RendeEngine }

  { RenderEngine }

  RenderEngine = Class
    public
     margins       : Array of Integer;

     constructor Create();
     procedure RenderMargin(Sender : TObject);

  end;




implementation

{ RenderEngine }

constructor RenderEngine.Create;
begin

end;

procedure RenderEngine.RenderMargin(Sender: TObject);
var
  targetPanel : TBCPanel;
  x1          : Integer;
  y1          : Integer;
  x2          : Integer;
  y2          : Integer;
begin
  targetPanel := (Sender as TBCPanel);
  targetPanel.Canvas.Pen.Color := clGrayText;

  // TOP

  x1          := margins[1];
  x2          := targetPanel.Width- margins[3];
  y1          := margins[0];
  y2          := margins[0];

  targetPanel.Canvas.Line(x1,y1,x2,y2);


  // Left

  x1          := margins[1];
  x2          := margins[1];
  y1          := margins[0];
  y2          := targetPanel.Height - margins[2];

  targetPanel.Canvas.Line(x1,y1,x2,y2);

  // Bottom

  x1          := margins[1];
  x2          := targetPanel.Width- margins[3];
  y1          := targetPanel.Height - margins[2];
  y2          := targetPanel.Height - margins[2];

  targetPanel.Canvas.Line(x1,y1,x2,y2);

  // right

  x1          := targetPanel.Width- margins[3];
  x2          := targetPanel.Width- margins[3];
  y1          := targetPanel.Height - margins[2];
  y2          := margins[0];

  targetPanel.Canvas.Line(x1,y1,x2,y2);

end;


{ RendeEngine }



end.

