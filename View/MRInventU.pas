unit MRInventU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  RInventDTOU;

type
  TMRInvent = class(TFrame)
    Layout1: TLayout;
    EidBarCode: TEdit;
    Label1: TLabel;
    EdesArticle: TEdit;
    Label2: TLabel;
    Rectangle1: TRectangle;
    Button1: TButton;
    ELastPrixAchat: TEdit;
    Label3: TLabel;
    EQteInvent: TEdit;
    Label4: TLabel;
    BDisplayArticle: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure BDisplayArticleClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

uses
  RInventDAOU, BarCodeWebDTOU, BarCodeWebDAOU, MainU, ArticleWebDTOU;

{$R *.fmx}

procedure TMRInvent.BDisplayArticleClick(Sender: TObject);
var
oBarCodeWebDAO:TBarCodeWebDAO;
oBarCodeDTO:TbarCodeWebDTO;
oArticleDTO:TArticleWebDTO;

begin
oBarCodeDTO:=TbarCodeWebDTO.create(EidBarCode.Text);
oBarCodeWebDAO:=TBarCodeWebDAO.create(oBarCodeDTO);
oArticleDTO:=oBarCodeWebDAO.getArticleWebDTO;
EdesArticle.Text:=oArticleDTO.desArticle;
ELastPrixAchat.Text:=FloatToStr(oArticleDTO.lastprixachat);
oBarCodeDTO.DisposeOf;
oBarCodeWebDAO.DisposeOf;
oArticleDTO.DisposeOf;


end;

procedure TMRInvent.Button1Click(Sender: TObject);
var oRInventDTO:TRInventDTO;
oRInventDAO:TRInventDAO;
//oBarCodeDTO:TbarCodeWebDTO;
//oBarCodeDAO:BarCodeDAO;
begin
oRInventDTO:=TRInventDTO.Create;
oRInventDAO:=TRInventDAO.Create;
oRInventDTO.idrinvent:=oRInventDAO.getNewId;
oRInventDTO.idinvent:=Main.oTFInvent.oSelectedInventDTO.idinvent;
oRInventDTO.idbarCode:=EidBarCode.Text;
oRInventDTO.QteInvent:=StrToFloat(EQteInvent.Text);
oRInventDTO.PrixAchat:=StrToFloat(ELastPrixAchat.Text);
oRInventDAO.save(oRInventDTO);
oRInventDTO.DisposeOf;

main.TabControl1.ActiveTab:=Main.TAchat;

Main.oTFInvent.AfficherDetail;
Self.DisposeOf;

end;

procedure TMRInvent.Button2Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

end.
