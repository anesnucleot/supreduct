unit MInventU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TMInvent = class(TFrame)
    Layout1: TLayout;
    EidInvent: TEdit;
    Label1: TLabel;
    EdesInvent: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Rectangle1: TRectangle;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

uses
  InventDTOU, InventDAOU, MainU;

{$R *.fmx}

procedure TMInvent.Button1Click(Sender: TObject);
var oinventDTO:TInventDTO;
begin
oinventDTO:=TinventDTO.Create;
oinventDTO.idInvent:=StrToInt(EidInvent.Text);
oinventDTO.desInvent:=EdesInvent.Text;
TInventDAO.create.save(oinventDTO);
main.TabControl1.ActiveTab:=Main.TAchat;
oinventDTO.DisposeOf;
Main.oTFInvent.AfficherEntete;
Self.DisposeOf;
end;

procedure TMInvent.Button2Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

procedure TMInvent.Button3Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

end.
