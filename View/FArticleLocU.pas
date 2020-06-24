unit FArticleLocU;

interface

uses
  ArticleLocDTOU, System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts, System.Classes, System.Generics.Collections;

type
  TFArticleLoc = class(TFrame)
    Rectangle2: TRectangle;
    StringGrid1: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    EdesArticleRech: TEdit;
    BRecherche: TButton;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;
    EidArticleRech: TEdit;
    RRecherche: TRectangle;
    LayIdArticle: TLayout;
    EidArticle: TEdit;
    Label1: TLabel;
    LayPrixAchat: TLayout;
    ELastPrixAchat: TEdit;
    Label2: TLabel;
    LayPrixVente: TLayout;
    EPrixVente: TEdit;
    Label3: TLabel;
    LayDesArticle: TLayout;
    EDesArticle: TEdit;
    Label4: TLabel;
    RecButtons: TRectangle;
    BAjouter: TButton;
    BSupprimer: TButton;
    BFermer: TButton;
    LayLastQteAchat: TLayout;
    ELastQteAchat: TEdit;
    Label5: TLabel;
    LayQteStock: TLayout;
    EQteStock: TEdit;
    Label6: TLabel;
    LayUArt: TLayout;
    EUArt: TEdit;
    Label7: TLabel;
    VertScrollBox1: TVertScrollBox;
    Rectangle1: TRectangle;

//    Procedure AfficherArt;
//    Procedure AfficherArts;
    procedure BCloseClick(Sender: TObject);
    procedure BSupprimerClick(Sender: TObject);
    procedure BAjouterClick(Sender: TObject);
    procedure BRechercheClick(Sender: TObject);
    procedure BFermerClick(Sender: TObject);
    procedure StringGrid1CellClick(const Column: TColumn; const Row: Integer);
  private
  public
  selectedRowRecep,selectedRowArt:integer;


  end;

  TListArticleLocDTO=TObjectList<TArticleLocDTO>;

implementation

uses
  REST.Json,  REST.Types, StringUtilsU, System.JSON,
   MainU, APIUtilsU, ArticleLocDAOU;

{$R *.fmx}

procedure TFArticleLoc.BAjouterClick(Sender: TObject);
var oarticleDTO:TArticleLocDTO;
begin
{if EIdArticle.Text='' then
EIdArticle.Text:=TArticleLocDAO.Create.getMaxIdArticle;
oarticleDTO:=TArticleLocDTO.Create(EIdArticle.Text);
oarticleDTO.desarticleloc:=EDesArticle.Text;

if EPrixVente.Text<>'' then
oarticleDTO.prixVente:=StrToFloat(EPrixVente.Text) else
oarticleDTO.prixVente:=0;

if ELastPrixAchat.Text<>'' then
oarticleDTO.LastPrixAchat:=StrToFloat(ELastPrixAchat.Text) else
oarticleDTO.LastPrixAchat:=0;

if ELastQteAchat.Text<>'' then
oarticleDTO.lastqteachat:=StrToFloat(ELastQteAchat.Text) else
oarticleDTO.lastqteachat:=0;


if EQteStock.Text<>'' then
oarticleDTO.qtestock:=StrToFloat(EQteStock.Text) else
oarticleDTO.qtestock:=0;

oarticleDTO.uart:=EUArt.Text;
TArticleLocDAO.create.save(oarticleDTO);
oarticleDTO.DisposeOf;
Main.oTMBarCodeWeb.EidArticle.Text:=Self.EidArticle.Text;
Main.oTMBarCodeLoc.EDesArticle.Text:=Self.EDesArticle.Text;
BFermerClick(self);  }
end;

procedure TFArticleLoc.BCloseClick(Sender: TObject);
begin
  Main.TabControl1.ActiveTab:=Main.TMain;
end;

procedure TFArticleLoc.BFermerClick(Sender: TObject);
begin
Self.DisposeOf;
Main.TabControl1.ActiveTab:=Main.TAchat;
end;


procedure TFArticleLoc.BSupprimerClick(Sender: TObject);
begin
if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
begin
  TArticleLocDAO.create().delete(TArticleLocDTO.Create(StringGrid1.Cells[0,StringGrid1.Row]));
  BRechercheClick(self);
end;

end;

procedure TFArticleLoc.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
var
oArticleLocDTO:TArticleLocDTO;
//oArticleLocDAO:TArticleLocDAO;
begin
if StringGrid1.Cells[0,Row]<>'' then
begin
  oArticleLocDTO:=TArticleLocDTO.create;
  oArticleLocDTO.idarticleloc:=StringGrid1.Cells[0,Row];
  TArticleLocDAO.create.loadData(oArticleLocDTO);
  EidArticle.Text:=oArticleLocDTO.idarticleloc;
  EDesArticle.Text:=oArticleLocDTO.desarticleloc;
  EPrixVente.Text:=FloatToStr(oArticleLocDTO.prixVente);
  ELastPrixAchat.Text:=FloatToStr(oArticleLocDTO.LastPrixAchat);
  ELastQteAchat.Text:=FloatToStr(oArticleLocDTO.LastQteAchat);
  EQteStock.Text:=FloatToStr(oArticleLocDTO.qtestock);
  EUArt.Text:=oArticleLocDTO.uart;
  oArticleLocDTO.DisposeOf;
end;
end;

procedure TFArticleLoc.BRechercheClick(Sender: TObject);

var
  ArtList:TLisTArticleLocDTO;
  OArt:TArticleLocDTO;
  i:Integer;
  vNbrLike:integer;
begin
if EdesArticleRech.Text<>'' then
begin
  vNbrLike:=TArticleLocDAO.create.getNbrLike(EdesArticleRech.Text);
  StringGrid1.RowCount:=vNbrLike;
  for i := 0 to StringGrid1.RowCount-1 do
  begin
    StringGrid1.Cells[0,i]:='';
    StringGrid1.Cells[1,i]:='';
    StringGrid1.Cells[2,i]:='';
    StringGrid1.Cells[3,i]:='';
    StringGrid1.Cells[4,i]:='';
    StringGrid1.Cells[5,i]:='';
    StringGrid1.Cells[6,i]:='';
    StringGrid1.Cells[7,i]:='';
  end;
  ArtList:=TArticleLocDAO.create.getListByText(EdesArticleRech.Text);

  i:=0;
  for OArt in ArtList do
  begin
    StringGrid1.Cells[0,i]:=OArt.idarticleloc;
    StringGrid1.Cells[1,i]:=OArt.desarticleloc;
    StringGrid1.Cells[2,i]:=FloatToStr(OArt.prixVente);
    StringGrid1.Cells[3,i]:=FloatToStr(OArt.LastPrixAchat);
    StringGrid1.Cells[4,i]:=FloatToStr(OArt.LastQteAchat);
    StringGrid1.Cells[5,i]:=FloatToStr(OArt.QteStock);
    StringGrid1.Cells[6,i]:=OArt.Uart;
    inc(i);
  end;
end;

end;

end.
