unit FArticleWebU;

interface

uses
  ArticleWebDTOU, System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.Controls.Presentation,
  FMX.Objects, FMX.Layouts, System.Classes, System.Generics.Collections;

type
  TFArticleWeb = class(TFrame)
    Layout1: TLayout;
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
    StringColumn7: TStringColumn;
    StringColumn8: TStringColumn;

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

  TListArticleDTO=TObjectList<TArticleWebDTO>;

implementation

uses
  REST.Json,  REST.Types, StringUtilsU, System.JSON,
   MainU, APIUtilsU, ArticleWebDAOU;

{$R *.fmx}

procedure TFArticleWeb.BAjouterClick(Sender: TObject);
var oarticleDTO:TArticleWebDTO;
begin
if EIdArticle.Text='' then
EIdArticle.Text:=TArticleWebDAO.Create.getMaxIdArticle;
oarticleDTO:=TArticleWebDTO.Create(EIdArticle.Text);
oarticleDTO.desArticle:=EDesArticle.Text;

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
TArticleWebDAO.create(oarticleDTO).save;
oarticleDTO.DisposeOf;
Main.oTMBarCodeWeb.EidArticle.Text:=Self.EidArticle.Text;
Main.oTMBarCodeWeb.EDesArticle.Text:=Self.EDesArticle.Text;
BFermerClick(self);
end;

procedure TFArticleWeb.BCloseClick(Sender: TObject);
begin
  Main.TabControl1.ActiveTab:=Main.TMain;
end;

procedure TFArticleWeb.BFermerClick(Sender: TObject);
begin
Self.DisposeOf;
Main.TabControl1.ActiveTab:=Main.TAchat;
end;


procedure TFArticleWeb.BSupprimerClick(Sender: TObject);
begin
if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
begin
  TArticleWebDAO.create(TArticleWebDTO.Create(StringGrid1.Cells[0,StringGrid1.Row])).delete;
  BRechercheClick(self);
end;

end;

procedure TFArticleWeb.StringGrid1CellClick(const Column: TColumn;
  const Row: Integer);
var
oArticleDTO:TArticleWebDTO;
begin
if StringGrid1.Cells[0,Row]<>'' then
begin
  oArticleDTO:=TJSON.JsonToObject<TArticleWebDTO>(RestReqGet.
  create(nil,'Article/getArticleById/'+StringGrid1.Cells[0,Row]).Response.
  JSONValue.ToString);
  EidArticle.Text:=oArticleDTO.idArticle;
  EDesArticle.Text:=oArticleDTO.desArticle;
  EPrixVente.Text:=FloatToStr(oArticleDTO.prixVente);
  ELastPrixAchat.Text:=FloatToStr(oArticleDTO.LastPrixAchat);
  ELastQteAchat.Text:=FloatToStr(oArticleDTO.LastQteAchat);
  EQteStock.Text:=FloatToStr(oArticleDTO.qtestock);
  EUArt.Text:=oArticleDTO.uart;
  oArticleDTO.DisposeOf;
end;
end;

procedure TFArticleWeb.BRechercheClick(Sender: TObject);

var
  ArtList:TListArticleWebDTO;
  OArt:TArticleWebDTO;
  i:Integer;
  vNbrLike:integer;
begin
if EdesArticleRech.Text<>'' then
begin
  vNbrLike:=TArticleWebDAO.create.getNbrLike(EdesArticleRech.Text);
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
  ArtList:=TArticleWebDAO.create.getListByText(EdesArticleRech.Text);

  i:=0;
  for OArt in ArtList do
  begin
    StringGrid1.Cells[0,i]:=OArt.idArticle;
    StringGrid1.Cells[1,i]:=OArt.desArticle;
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
