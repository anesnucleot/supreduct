unit FInventU;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid, FMX.Layouts, System.Generics.Collections, InventDTOU, InventDAOU, MInventU,
  MRInventU, RInventDTOU;

type
  TFInvent = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    SGEntete: TStringGrid;
    SGDetail: TStringGrid;
    Layout3: TLayout;
    Layout4: TLayout;
    BAjout: TButton;
    BSupp: TButton;
    BModif: TButton;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    Layout5: TLayout;
    BAjoutDtail: TButton;
    Button2: TButton;
    Button3: TButton;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    Button1: TButton;
    procedure BAjoutClick(Sender: TObject);
    procedure SGEnteteCellClick(const Column: TColumn; const Row: Integer);
    procedure BAjoutDtailClick(Sender: TObject);
    procedure BModifClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
  oMinvent:TMInvent;
  oMRinvent:TMRInvent;
  oSelectedInventDTO:TInventDTO;
  procedure AfficherEntete;
  procedure AfficherDetail;
    { Déclarations publiques }
  end;

type TListInventDTO=TObjectList<TInventDTO>;
TListRinventDTO=TObjectList<TRinventDTO>;
implementation

uses
  MainU, System.SysUtils, RInventDAOU;



{$R *.fmx}

{ TFInvent }

procedure TFInvent.AfficherDetail;
var
  RinventList:TListRinventDTO;
  ORInventDTO:TRinventDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=TRInventDAO.create.getNbrRInventsByInvent(Self.oSelectedInventDTO.idinvent);
  SGDetail.RowCount:=vNbr;
  for i := 0 to SGDetail.RowCount-1 do
  begin
    SGDetail.Cells[0,i]:='';
    SGDetail.Cells[1,i]:='';
    SGDetail.Cells[2,i]:='';
    SGDetail.Cells[3,i]:='';

  end;
  RinventList:=TRinventDAO.create.getRInventsByInvent(Self.oSelectedInventDTO.idinvent);

  i:=0;
  for ORInventDTO in RinventList do
  begin
    SGDetail.Cells[0,i]:=IntToStr(ORInventDTO.idrinvent);
    SGDetail.Cells[1,i]:=ORInventDTO.idbarCode;
    SGDetail.Cells[2,i]:=FloatToStr(ORInventDTO.qteinvent);
    SGDetail.Cells[3,i]:=FloatToStr(ORInventDTO.prixachat);

    inc(i);
  end;


end;

procedure TFInvent.AfficherEntete;
var
  InventList:TListInventDTO;
  OInventDTO:TInventDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=TInventDAO.create.getNbr;
  SGEntete.RowCount:=vNbr;
  for i := 0 to SGEntete.RowCount-1 do
  begin
    SGEntete.Cells[0,i]:='';
    SGEntete.Cells[1,i]:='';
  end;
  InventList:=TInventDAO.create.getInvents;

  i:=0;
  for OInventDTO in InventList do
  begin
    SGEntete.Cells[0,i]:=IntToStr(OInventDTO.idInvent);
    SGEntete.Cells[1,i]:=OInventDTO.desInvent;
    SGEntete.Cells[2,i]:=OInventDTO.date_;
    inc(i);
  end;
  SGEntete.Row:=0;
  SGEnteteCellClick(Self.StringColumn1,0);
end;

procedure TFInvent.BAjoutClick(Sender: TObject);
begin
oMinvent:=TMInvent.Create(nil);
oMinvent.Parent:=main.LayoutMAJAchat;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;

end;

procedure TFInvent.BAjoutDtailClick(Sender: TObject);
begin
oMRinvent:=TMRInvent.Create(nil);
oMRinvent.Parent:=main.LayoutMAJAchat;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;
end;

procedure TFInvent.BModifClick(Sender: TObject);
var oinventDTO:TInventDTO;
begin
oMinvent:=TMInvent.Create(nil);
oMinvent.Parent:=main.LayoutMAJAchat;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;
oMinvent.EidInvent.Text:=IntToStr(oSelectedInventDTO.idinvent);
oMinvent.EidInvent.Enabled:=false;
oMinvent.EdesInvent.Text:=oSelectedInventDTO.desinvent;
end;

procedure TFInvent.Button1Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TMain;
Self.DisposeOf;
end;

procedure TFInvent.SGEnteteCellClick(const Column: TColumn; const Row: Integer);
begin
if Assigned(oSelectedInventDTO)=true then oSelectedInventDTO.DisposeOf;
oSelectedInventDTO:=TInventDTO.Create;
oSelectedInventDTO.idinvent:=strtoInt(SGEntete.Cells[0,SGEntete.Row]);
oSelectedInventDTO.desinvent:=SGEntete.Cells[1,SGEntete.Row];

Self.AfficherDetail;
end;




end.
