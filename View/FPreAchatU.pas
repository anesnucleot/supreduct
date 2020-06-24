unit FPreAchatU;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Grid, FMX.Layouts, InventDTOU, InventDAOU, MInventU,
  MRInventU, RInventDTOU, FMX.Edit, FMX.Objects, MPreAchatU,
  System.Generics.Collections,PreAchatLocDTOU,RPreAchatLocDTOU, MRPreAchatU;

type
  TFPreAchat = class(TFrame)
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
    BSuppDetail: TButton;
    BModifDetail: TButton;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn7: TStringColumn;
    Bretour: TButton;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Rectangle2: TRectangle;
    ETotal: TEdit;
    Label2: TLabel;
    Bferme: TButton;
    BsuppAll: TButton;
    Rectangle3: TRectangle;
    DesColumn: TStringColumn;
    VertScrollBox1: TVertScrollBox;
    Rectangle4: TRectangle;
    PrixCartonColumn: TStringColumn;
    Rectangle5: TRectangle;
    procedure BAjoutClick(Sender: TObject);
    procedure SGEnteteCellClick(const Column: TColumn; const Row: Integer);
    procedure BAjoutDtailClick(Sender: TObject);
    procedure BModifClick(Sender: TObject);
    procedure BretourClick(Sender: TObject);
    procedure BSuppClick(Sender: TObject);
    procedure SGDetailCellClick(const Column: TColumn; const Row: Integer);
    procedure BModifDetailClick(Sender: TObject);
    procedure BfermeClick(Sender: TObject);
    procedure BSuppDetailClick(Sender: TObject);
    procedure BsuppAllClick(Sender: TObject);
  private
    { Déclarations privées }
  public

  ofpreachat:TFPreAchat;
  oMpreachat:TMPreAchat;
  oMRPreAchat:TMRPreAchat;
  oSelectedpreAchatDTO:TPreAchatLocDTO;
  oSelectedRpreAchatDTO:TRPreAchatLocDTO;
  procedure AfficherEntete;
  procedure AfficherDetail(sg:TStringGrid;vPreAchatLocDTO:TPreAchatLocDTO;etot:Tedit);
    { Déclarations publiques }
  end;

type TListPreAchatLocDTO=TObjectList<TPreAchatLocDTO>;
TListRPreAchatLocDTO=TObjectList<TRpreachatLocDTO>;
implementation

uses
  MainU, System.SysUtils, PreAchatLocDAOU, RPreAchatLocDAOU, BarCodeLocDAOU,
  ArticleLocDAOU, ArticleLocDTOU, BarCodeLocDTOU;



{$R *.fmx}

{ TFInvent }

procedure TFPreAchat.AfficherDetail(sg:TStringGrid;vPreAchatLocDTO:TPreAchatLocDTO;etot:Tedit);
var
  RpreachatList:TListRPreAchatLocDTO;
  ORPreachatlocDTO:TRPreAchatLocDTO;
  oBarCodeLocDAO: TBarCodeLocDAO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=TRPreAchatLocDAO.create.getNbrRPreAchatsByPreAchat(vPreAchatLocDTO.idpreachatloc);
  SGDetail.RowCount:=vNbr;
  for i := 0 to sg.RowCount-1 do
  begin
   sg.Cells[0,i]:='';
   sg.Cells[1,i]:='';
   sg.Cells[2,i]:='';
   sg.Cells[3,i]:='';
   {sadaoui :}
   sg.Cells[4,i]:='';
   sg.Cells[5,i]:='';

  end;
 RpreachatList:=TRPreAchatLocDAO.create.getRPreAchatsByPreAchat(Self.oSelectedpreAchatDTO.idpreachatloc);

  i:=0;
  for ORPreachatlocDTO in RpreachatList do
  begin
    sg.Cells[0,i]:=IntToStr(ORPreachatlocDTO.idrpreachatloc);
    sg.Cells[1,i]:=ORPreachatlocDTO.idbarcodeloc;
    sg.Cells[2,i]:=TBarCodeLocDAO.create.
    getArticleLocDTO(TBarCodeLocDTO.create(ORPreachatlocDTO.idbarcodeloc)).desarticleloc;
    sg.Cells[3,i]:=FloatToStr(ORPreachatlocDTO.qtepreachatloc);
    sg.Cells[4,i]:=FloatToStr(ORPreachatlocDTO.prixpreachatloc);
    {sadaoui: }
    sg.Cells[5,i]:=TArticleLocDAO.create.Prixcarton(TBarCodeLocDAO.create.getArticleLocDTO(TBarCodeLocDTO.create(ORPreachatlocDTO.idbarcodeloc))).ToString;
     {fin}
    inc(i);
  end;
  etot.Text:=FormatFloat('#,##0',TRPreAchatLocDAO.Create.totalMontants(vPreAchatLocDTO));
end;

procedure TFPreAchat.AfficherEntete;
var
  PreachatList:TListPreAchatLocDTO;
  OPreachatlocDTO:TPreAchatLocDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=TPreAchatLocDAO.create.getNbr;
  SGEntete.RowCount:=vNbr;
  for i := 0 to SGEntete.RowCount-1 do
  begin
    SGEntete.Cells[0,i]:='';
    SGEntete.Cells[1,i]:='';
    SGEntete.Cells[2,i]:='';

  end;
  PreachatList:=TPreAchatLocDAO.create.getPreAchatsLoc;
  //ShowMessage(vNbr.ToString);

  i:=0;
  for OPreachatlocDTO in PreachatList do
  begin
    SGEntete.Cells[0,i]:=IntToStr(OPreachatlocDTO.idpreachatloc);
    SGEntete.Cells[1,i]:=OPreachatlocDTO.despreachatloc;
    SGEntete.Cells[2,i]:=OPreachatlocDTO.date_;
    inc(i);
  end;
  SGEntete.Row:=0;
  SGEnteteCellClick(Self.StringColumn1,0);
end;

procedure TFPreAchat.BAjoutClick(Sender: TObject);
begin
oMpreachat:=TMPreAchat.Create(nil);
oMpreachat.Parent:=main.LayoutMAJAchat;
oMpreachat.EidPrAchat.Text:=TPreAchatLocDAO.Create.GetNewId.ToString;
Main.TabControl1.ActiveTab:=Main.TMAJAchat;

end;

procedure TFPreAchat.BAjoutDtailClick(Sender: TObject);
begin
if Assigned(oSelectedpreAchatDTO)=true then
 begin
  oMRPreAchat:=TMRPreAchat.Create(nil);
  oMRPreAchat.Parent:=main.LayoutMAJAchat;
  oMRPreAchat.oidRPreAchat:=RPreachatLocDAOU.TRPreAchatLocDAO.Create.getNewId;

  Main.TabControl1.ActiveTab:=Main.TMAJAchat;

 end else
 begin
  ShowMessage('Selectionner un Préachat');
 end;
//oMRPreAchat.ElastQteAchat.Enabled:=false;
end;


procedure TFPreAchat.BModifClick(Sender: TObject);
var oinventDTO:TInventDTO;
begin
  oMpreachat:=TMPreAchat.Create(nil);
  oMpreachat.Parent:=main.LayoutMAJAchat;
  Main.TabControl1.ActiveTab:=Main.TMAJAchat;
  oMpreachat.EidPrAchat.Text:=IntToStr(oSelectedpreAchatDTO.idpreachatloc);
  oMpreachat.EidPrAchat.Enabled:=false;
  oMpreachat.EdesPrAchat.Text:=oSelectedpreAchatDTO.despreachatloc;
end;

procedure TFPreAchat.BSuppClick(Sender: TObject);
begin
TPreAchatLocDAO.create().delete(oSelectedpreAchatDTO);
AfficherEntete;

end;

procedure TFPreAchat.BretourClick(Sender: TObject);
begin
main.TabControl1.ActiveTab:=Main.TMain;
Self.DisposeOf;
end;

procedure TFPreAchat.BsuppAllClick(Sender: TObject);
begin
if Assigned(oSelectedpreAchatDTO)=true  then
TRPreAchatLocDAO.create().deleteAll(oSelectedpreAchatDTO);
Self.AfficherDetail(SGDetail,oSelectedpreAchatDTO,ETotal);
end;

procedure TFPreAchat.BSuppDetailClick(Sender: TObject);
begin
  if Assigned(oSelectedRpreAchatDTO)=true  then
  TRPreAchatLocDAO.create().delete(oSelectedRpreAchatDTO);
  Self.AfficherDetail(SGDetail,oSelectedpreAchatDTO,ETotal);
end;

procedure TFPreAchat.BModifDetailClick(Sender: TObject);
var oarticlelocDTO: TArticleLocDTO;
obarcodelocdto: TBarCodeLocDTO;
begin
if Assigned(oSelectedRpreAchatDTO)=true then
begin
  oMRPreAchat:=TMRPreAchat.Create(nil);
  oMRPreAchat.Parent:=main.LayoutMAJAchat;
  Main.TabControl1.ActiveTab:=Main.TMAJAchat;
  oMRPreAchat.oidRPreAchat:=oSelectedRpreAchatDTO.idrpreachatloc;
  oMRPreAchat.EidBarCode.Text:=oSelectedRpreAchatDTO.idbarcodeloc;
  oMRPreAchat.EQtePreAchat.Text:=FloatToStr(oSelectedRpreAchatDTO.qtepreachatloc);
  oMRPreAchat.ELastPrixAchat.Text:=FloatToStr(oSelectedRpreAchatDTO.prixpreachatloc);
  oMRPreAchat.EidBarCode.Enabled:=false;
  oMRPreAchat.EdesArticle.Enabled:=false;
  //oarticlelocDTO:= TArticleLocDTO.create;
  obarcodelocdto:= TBarCodeLocDTO.create(oSelectedRpreAchatDTO.idbarcodeloc);
  oMRPreAchat.EdesArticle.Text:= TBarCodeLocDAO.create.getArticleLocDTO(obarcodelocdto).desarticleloc;
  {sadaoui :ajouter prix de carton}
  oMRPreAchat.Eprixcarton.Text:= TArticleLocDAO.create.Prixcarton(TBarCodeLocDAO.create.getArticleLocDTO(obarcodelocdto)).ToString;
  oMRPreAchat.ElastQteAchat.Text:= TBarCodeLocDAO.create.getArticleLocDTO(obarcodelocdto).lastqteachat.ToString;
  {fin modif sadaoui}
end else
begin
  ShowMessage('Selectionner un codeBare à modifier');
end;
end;

procedure TFPreAchat.BfermeClick(Sender: TObject);
begin
Application.Terminate;
end;

procedure TFPreAchat.SGDetailCellClick(const Column: TColumn;
  const Row: Integer);
begin

if Assigned(oSelectedRpreAchatDTO) then oSelectedRpreAchatDTO.DisposeOf;
oSelectedRpreAchatDTO:=TRPreAchatLocDTO.Create();
oSelectedRpreAchatDTO.idrpreachatloc:=strtoInt(SGDetail.Cells[0,Row]);
oSelectedRpreAchatDTO.idpreachatloc:=oSelectedpreAchatDTO.idpreachatloc;
oSelectedRpreAchatDTO.idbarcodeloc:=SGDetail.Cells[1,SGDetail.Row];
oSelectedRpreAchatDTO.qtepreachatloc:=StrToFloat(SGDetail.Cells[3,Row]);
oSelectedRpreAchatDTO.prixpreachatloc:=StrToFloat(SGDetail.Cells[4,Row]);


end;

procedure TFPreAchat.SGEnteteCellClick(const Column: TColumn; const Row: Integer);
var
oRPreAchatLocDAO:TRPreAchatLocDAO ;
begin
if Assigned(oSelectedpreAchatDTO)=true then oSelectedpreAchatDTO.DisposeOf;
oSelectedpreAchatDTO:=TPreAchatLocDTO.Create;
oSelectedpreAchatDTO.idpreachatloc:=strtoInt(SGEntete.Cells[0,Row]);
oSelectedpreAchatDTO.despreachatloc:=SGEntete.Cells[1,Row];
Self.AfficherDetail(SGDetail,oSelectedpreAchatDTO,ETotal);
if TPreAchatLocDAO.Create.hasDetail(oSelectedpreAchatDTO) then
Self.SGDetailCellClick(Self.StringColumn3,0);
end;




end.
