unit MBarCodeLocU;

interface

uses
  ArticleLocDTOU, System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts, System.Classes, System.Generics.Collections,
  DataPak.Android.BarcodeScanner, FArticleLocU;

type
  TMBarCodeLoc = class(TFrame)
    BAjouter: TButton;
    BSupprimer: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    EIdBarCode: TEdit;
    ok: TButton;
    BAfficherArticle: TButton;
    LayIdBarCode: TLayout;
    labIdBarCode: TLabel;
    LayArticle: TLayout;
    EidArticle: TEdit;
    EDesArticle: TEdit;
    LaySymbole: TLayout;
    ESymbole: TEdit;
    Label1: TLabel;
    BScanner: TButton;
    BarcodeScanner1: TBarcodeScanner;
    BFermer: TButton;
    BImport: TButton;
    VertScrollBox1: TVertScrollBox;
    Rectangle1: TRectangle;
    RecButtons: TRectangle;

//    Procedure AfficherArt;
//    Procedure AfficherArts;
    procedure BCloseClick(Sender: TObject);
    procedure BSupprimerClick(Sender: TObject);
    procedure BAjouterClick(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure BAfficherArticleClick(Sender: TObject);
    procedure BarcodeScanner1ScanResult(Sender: TObject; AResult: string);
    procedure BScannerClick(Sender: TObject);
    procedure BFermerClick(Sender: TObject);
    procedure BImportClick(Sender: TObject);
  private

  public
  oFArticleLoc:TFArticleLoc;
  selectedRowRecep,selectedRowArt:integer;
  function GetNbr:integer;

  end;

  TLisTArticleLocDTO=TObjectList<TArticleLocDTO>;

implementation

uses
  REST.Json,  REST.Types, StringUtilsU, System.JSON,
   MainU, APIUtilsU, ArticleLocDAOU, BarCodeLocDAOU, BarCodeLocDTOU;

{$R *.fmx}



procedure TMBarCodeLoc.BAfficherArticleClick(Sender: TObject);

begin
oFArticleLoc:=TFArticleLoc.Create(nil);
oFArticleLoc.Parent:=Main.LayoutMAJAchat;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;
oFArticleLoc.EidArticleRech.Text:=Self.EidArticle.Text;
oFArticleLoc.EdesArticleRech.text:=EDesArticle.Text;
oFArticleLoc.BRechercheClick(self);
oFArticleLoc.StringGrid1CellClick(oFArticleLoc.StringColumn1,0);
end;



procedure TMBarCodeLoc.BAjouterClick(Sender: TObject);
var obarCodeDTO:TbarCodeLocDTO;
begin
obarCodeDTO:=TbarCodeLocDTO.Create();
obarCodeDTO.idbarcodeloc:=EIdBarCode.Text;
obarCodeDTO.idarticleloc:=EidArticle.Text;
obarCodeDTO.symbole:=ESymbole.Text;
//TBarCodeLocDAO.create.saveLoc(obarCodeDTO);
obarCodeDTO.DisposeOf;
end;

procedure TMBarCodeLoc.BarcodeScanner1ScanResult(Sender: TObject;
  AResult: string);
begin
EIdBarCode.Text:=AResult;
end;

procedure TMBarCodeLoc.BCloseClick(Sender: TObject);
begin
  Main.TabControl1.ActiveTab:=Main.TMain;
end;

procedure TMBarCodeLoc.BScannerClick(Sender: TObject);
begin
BarcodeScanner1.Scan;
end;

procedure TMBarCodeLoc.BSupprimerClick(Sender: TObject);
var obarCodeDTO:TbarCodeLocDTO;
begin
{obarCodeDTO:=TbarCodeLocDTO.Create(EIdBarCode.Text);
obarCodeDTO.idarticle:=EidArticle.Text;
obarCodeDTO.symbole:=ESymbole.Text;
TBarCodeLocDAO.create(obarCodeDTO).deleteLoc;
obarCodeDTO.DisposeOf;}
end;

procedure TMBarCodeLoc.BFermerClick(Sender: TObject);
begin
Self.DisposeOf;
Main.TabControl1.ActiveTab:=Main.TMain;
end;

procedure TMBarCodeLoc.BImportClick(Sender: TObject);
begin
TArticleLocDAO.create.importDataFromWebToLocal;
TBarCodeLocDAO.create.importDataFromWebToLocal;
end;

function TMBarCodeLoc.GetNbr: integer;
begin
Result:=TArticleLocDAO.create.getNbrArticle;
end;

procedure TMBarCodeLoc.okClick(Sender: TObject);
var oArticleLocDTO:TArticleLocDTO;
oBarCodeLocDTO:TbarCodeLocDTO;
begin
oBarCodeLocDTO:=TbarCodeLocDTO.create();
oBarCodeLocDTO.idbarcodeloc:=EIdBarCode.Text;
if not TBarCodeLocDAO.create.isExistLoc(oBarCodeLocDTO) then
begin
  EidArticle.Text:='';
  EDesArticle.Text:='';
  BAfficherArticleClick(Self);
end
else
begin
  oArticleLocDTO:=TBarCodeLocDAO.create.getArticleLocDTO(oBarCodeLocDTO);
  EidArticle.Text:=oArticleLocDTO.idarticleloc;
  EDesArticle.Text:=oArticleLocDTO.desarticleloc;
  TBarCodeLocDAO.create.loadData(oBarCodeLocDTO);
  ESymbole.Text:=oBarCodeLocDTO.symbole;
  BAfficherArticleClick(Self);
  oArticleLocDTO.DisposeOf;
  oBarCodeLocDTO.DisposeOf;
end;
end;

end.
