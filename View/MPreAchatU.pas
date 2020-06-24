unit MPreAchatU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TMPreAchat = class(TFrame)
    Layout1: TLayout;
    EidPrAchat: TEdit;
    Label1: TLabel;
    EdesPrAchat: TEdit;
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
  MainU, PreAchatLocDTOU, PreAchatLocDAOU;

{$R *.fmx}

procedure TMPreAchat.Button1Click(Sender: TObject);
var opreachatlocDTO:TPreAchatLocDTO;
begin
opreachatlocDTO:=TPreAchatLocDTO.Create;
opreachatlocDTO.idpreachatloc:=StrToInt(EidPrAchat.Text);
opreachatlocDTO.despreachatloc:=EdesPrAchat.Text;
//opreachatlocDTO.date_:=now;
TPreAchatLocDAO.create.Saveloc(opreachatlocDTO);
main.TabControl1.ActiveTab:=Main.TAchat;
opreachatlocDTO.DisposeOf;
Main.oTFpreachat.AfficherEntete;
Self.DisposeOf;
end;

procedure TMPreAchat.Button2Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

procedure TMPreAchat.Button3Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

end.
