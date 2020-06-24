unit MBarCodeWebU;

interface

uses
  ArticleWebDTOU, System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts, System.Classes, System.Generics.Collections,
  DataPak.Android.BarcodeScanner;

type
  TMBarCodeWeb = class(TFrame)
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
    VertScrollBox1: TVertScrollBox;
    RecEdits: TRectangle;
    RecButtons: TRectangle;
    LayEdits: TLayout;
    LayScan: TLayout;

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
  private

  public
  selectedRowRecep,selectedRowArt:integer;
  function GetNbr:integer;

  end;

  TLisTArticleWebDTO=TObjectList<TArticleWebDTO>;

implementation

uses
  REST.Json,  REST.Types, StringUtilsU, System.JSON,
   MainU, APIUtilsU, ArticleWebDAOU, BarCodeWebDAOU, BarCodeWebDTOU, FArticleWebU;

{$R *.fmx}



procedure TMBarCodeWeb.BAfficherArticleClick(Sender: TObject);
var oFArticle:TFArticleWeb;
begin
oFArticle:=TFArticleWeb.Create(nil);
oFArticle.Parent:=Main.LayoutMAJAchat;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;
oFArticle.EidArticleRech.Text:=Self.EidArticle.Text;
oFArticle.EdesArticleRech.text:=EDesArticle.Text;
oFArticle.BRechercheClick(self);
oFArticle.StringGrid1CellClick(oFArticle.StringColumn1,0);
end;



procedure TMBarCodeWeb.BAjouterClick(Sender: TObject);
var obarCodeDTO:TbarCodeWebDTO;
begin
obarCodeDTO:=TbarCodeWebDTO.Create(EIdBarCode.Text);
obarCodeDTO.idarticle:=EidArticle.Text;
obarCodeDTO.symbole:=ESymbole.Text;
TBarCodeWebDAO.create(obarCodeDTO).saveWeb;
obarCodeDTO.DisposeOf;
end;

procedure TMBarCodeWeb.BarcodeScanner1ScanResult(Sender: TObject;
  AResult: string);
begin
EIdBarCode.Text:=AResult;
end;

procedure TMBarCodeWeb.BCloseClick(Sender: TObject);
begin
  Main.TabControl1.ActiveTab:=Main.TMain;
end;

procedure TMBarCodeWeb.BScannerClick(Sender: TObject);
begin
BarcodeScanner1.Scan;
end;

procedure TMBarCodeWeb.BSupprimerClick(Sender: TObject);
var obarCodeDTO:TbarCodeWebDTO;
begin
if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
begin
  obarCodeDTO:=TbarCodeWebDTO.Create(EIdBarCode.Text);
  obarCodeDTO.idarticle:=EidArticle.Text;
  obarCodeDTO.symbole:=ESymbole.Text;
  TBarCodeWebDAO.create(obarCodeDTO).deleteWeb;
  obarCodeDTO.DisposeOf;
end;
end;

procedure TMBarCodeWeb.BFermerClick(Sender: TObject);
begin
Self.DisposeOf;
Main.TabControl1.ActiveTab:=Main.TMain;
end;

function TMBarCodeWeb.GetNbr: integer;
begin
Result:=TArticleWebDAO.create.getNbrArticle;
end;

procedure TMBarCodeWeb.okClick(Sender: TObject);
var oArticleDTO:TArticleWebDTO;
oBarCodeDTO:TbarCodeWebDTO;
begin
if not TBarCodeWebDAO.create(TbarCodeWebDTO.create(EIdBarCode.Text)).isExistWeb then
begin
  EidArticle.Text:='';
  EDesArticle.Text:='';
  BAfficherArticleClick(Self);
end
else
begin
  oArticleDTO:=TJSON.JsonToObject<TArticleWebDTO>(RestReqGet.
  create(nil,'BarCode/getArticle/'+EIdBarCode.Text).Response.JSONValue.ToString);
  EidArticle.Text:=oArticleDTO.idArticle;
  EDesArticle.Text:=oArticleDTO.desArticle;
  oBarCodeDTO:=TJSON.JsonToObject<TbarCodeWebDTO>(RestReqGet.
  create(nil,'BarCode/getBarCodeById/'+EIdBarCode.Text).Response.JSONValue.ToString);
  ESymbole.Text:=oBarCodeDTO.symbole;
  BAfficherArticleClick(Self);
  oArticleDTO.DisposeOf;
  oBarCodeDTO.DisposeOf;
end;
end;

end.
