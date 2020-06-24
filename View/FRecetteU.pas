unit FRecetteU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  ReqRecetteDTOU, System.Generics.Collections;

type
  TFRecette = class(TFrame)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    Button1: TButton;
    Layout3: TLayout;
    StringGrid1: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
  procedure afficher;
    { Déclarations publiques }
  end;
Type TListReqRecetteDTO=TObjectList<CReqRecetteDTO>;

implementation

{$R *.fmx}

uses APIUtilsU, ReqRecetteDAOU;

{ TFRecette }

procedure TFRecette.afficher;
var
  RecList:TListReqRecetteDTO;
  OReqRecette:CReqRecetteDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=TReqRecetteDAO.create.getNbr;
  StringGrid1.RowCount:=vNbr;
  for i := 0 to StringGrid1.RowCount-1 do
  begin
    StringGrid1.Cells[0,i]:='';
    StringGrid1.Cells[1,i]:='';
  end;
  RecList:=TReqRecetteDAO.create.getRecette;

  i:=0;
  for OReqRecette in RecList do
  begin
    StringGrid1.Cells[0,i]:=OReqRecette.Date_;
    StringGrid1.Cells[1,i]:=FloatToStr(OReqRecette.recette);
    inc(i);
  end;
end;

procedure TFRecette.Button1Click(Sender: TObject);
begin
Self.DisposeOf;
end;

end.
