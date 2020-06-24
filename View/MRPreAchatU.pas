unit MRPreAchatU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts,
  RInventDTOU, DataPak.Android.BarcodeScanner;

type
  TMRPreAchat = class(TFrame)
    Layout1: TLayout;
    EidBarCode: TEdit;
    EdesArticle: TEdit;
    Rectangle1: TRectangle;
    BValid: TButton;
    ELastPrixAchat: TEdit;
    ElastQteAchat: TEdit;
    BDisplayArticle: TButton;
    Button2: TButton;
    EQtePreAchat: TEdit;
    BScan: TButton;
    Eprixcarton: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BarcodeScanner1: TBarcodeScanner;
    procedure BValidClick(Sender: TObject);
    procedure BDisplayArticleClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BScanClick(Sender: TObject);
    procedure BarcodeScanner1ScanResult(Sender: TObject; AResult: string);

  private
    { Déclarations privées }
  public
    oidRPreAchat:integer;
    { Déclarations publiques }
  end;

implementation

uses
  RInventDAOU, BarCodeLocDTOU, BarCodeLocDAOU, MainU,
  ArticleLocDTOU, RPreAchatLocDTOU, RPreAchatLocDAOU, FPreAchatU,
  ArticleLocDAOU;

{$R *.fmx}

procedure TMRPreAchat.BarcodeScanner1ScanResult(Sender: TObject;
  AResult: string);
begin
EidBarCode.Text:=AResult;
end;

procedure TMRPreAchat.BDisplayArticleClick(Sender: TObject);
var
oBarCodeLocDAO:TBarCodeLocDAO;
oBarCodeLocDTO:TbarCodeLocDTO;
oArticleDTO:TArticleLocDTO;

begin
oBarCodeLocDTO:=TbarCodeLocDTO.create(EidBarCode.text);
oBarCodeLocDAO:=TBarCodeLocDAO.create(oBarCodeLocDTO);
oArticleDTO:=oBarCodeLocDAO.getArticleLocDTO(oBarCodeLocDTO);
EdesArticle.Text:=oArticleDTO.desarticleloc;
ELastPrixAchat.Text:=FloatToStr(oArticleDTO.lastprixachat);
ElastQteAchat.Text:=FloatToStr(oArticleDTO.lastqteachat);
{Sadaoui: afficher le prix par carton}
Eprixcarton.Text:= TArticleLocDAO.create.Prixcarton(oArticleDTO).ToString;
{fin}
oBarCodeLocDTO.DisposeOf;
oBarCodeLocDAO.DisposeOf;
oArticleDTO.DisposeOf;


end;

procedure TMRPreAchat.BValidClick(Sender: TObject);
var oRPreachatDTO:TRPreAchatLocDTO;
oRPreachatDAO:TRPreAchatLocDAO;
oArticleLocDTO:TArticleLocDTO;
begin
oRPreachatDTO:=TRPreAchatLocDTO.Create;
oRPreachatDAO:=TRPreAchatLocDAO.Create;
oRPreachatDTO.idrpreachatloc:=Self.oidRPreAchat;
oRPreachatDTO.idpreachatloc:=Main.oTFPreAchat.oSelectedpreAchatDTO.idpreachatloc;
oRPreachatDTO.idbarcodeloc:=EidBarCode.Text;
oRPreachatDTO.qtepreachatloc:=StrToFloat(EQtePreAchat.Text);
oRPreachatDTO.prixpreachatloc:=StrToFloat(ELastPrixAchat.Text);
oRPreachatDAO.saveLoc(oRPreachatDTO);

try
  oArticleLocDTO:=TBarCodeLocDAO.create.
  getArticleLocDTO(TBarCodeLocDTO.create(EidBarCode.Text));
  oArticleLocDTO.lastqteachat:=StrToFloat(ElastQteAchat.Text);
  TArticleLocDAO.create.save(oArticleLocDTO);
finally
  oArticleLocDTO.DisposeOf;
end;


oRPreachatDTO.DisposeOf;
main.TabControl1.ActiveTab:=Main.TAchat;
Main.oTFPreAchat.AfficherDetail(Main.oTFPreAchat.SGDetail,Main.oTFPreAchat.oSelectedpreAchatDTO,Main.oTFPreAchat.ETotal);
Self.DisposeOf;

end;
{Sadaoui: afficher le prix par carton }





{fin}
procedure TMRPreAchat.BScanClick(Sender: TObject);
begin
BarcodeScanner1.Scan;
end;

procedure TMRPreAchat.Button2Click(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TAchat;
Self.DisposeOf;
end;

end.
