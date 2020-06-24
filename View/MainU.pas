unit MainU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
   FMX.Edit, FArticleWebU, IPPeerClient,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client
  , MBarCodeWebU, FRecetteU, FInventU, FMX.ScrollBox, FMX.Memo, MBarCodeLocU,
  UConnection, FireDAC.UI.Intf, FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, FireDAC.Comp.Client, FPreAchatU, IOUtils;

type
  TMain = class(TForm)
    TabControl1: TTabControl;
    TMain: TTabItem;
    TAchat: TTabItem;
    TMAJAchat: TTabItem;
    LayoutMAJAchat: TLayout;
    BCodeBarreWeb: TButton;
    Rectangle2: TRectangle;
    BClose: TButton;
    RESTClient1: TRESTClient;
    EIP: TEdit;
    Rectangle3: TRectangle;
    BRecette: TButton;
    Label1: TLabel;
    BInvent: TButton;
    BCodeBarreLoc: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    BpreAchat: TButton;
    LayoutAchat: TFramedVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure BCodeBarreWebClick(Sender: TObject);
    procedure BRecetteClick(Sender: TObject);
    procedure BInventClick(Sender: TObject);
    procedure BCodeBarreLocClick(Sender: TObject);
    procedure BpreAchatClick(Sender: TObject);
  private
    { Déclarations privées }
  public
  oTMBarCodeWeb:TMBarCodeWeb;
  oTMBarCodeLoc:TMBarCodeLoc;
  oTFRecette:TFRecette;
  oTFInvent:TFInvent;
  oconnection:TFDConnection;
  oTFPreAchat:TFPreAchat;
//    OMAJAchat:TMAJAchat;
//    OMAJDTL:TMAJDTL;

//    const srv='192.168.0.11';
    //const srv='192.168.43.135';
//    const srv='localhost';
  end;

var
  Main: TMain;
  OFArticle:TFArticleWeb;

implementation

uses
  REST.Types, System.JSON, BarCodeWebDAOU, BarCodeWebDTOU, ArticleLocDTOU,
  ArticleLocDAOU, FormatDateSQLiteU;

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}

procedure TMain.BCloseClick(Sender: TObject);
begin
Application.Terminate;
end;

procedure TMain.BCodeBarreLocClick(Sender: TObject);
begin
if not Assigned(oconnection) then
oconnection:=TConnection.Create(self).connection;
self.oTMBarCodeLoc:=TMBarCodeLoc.Create(nil);
self.oTMBarCodeLoc.Parent:=Main.LayoutAchat;
Main.TabControl1.ActiveTab:=Main.TAchat;
end;

procedure TMain.BCodeBarreWebClick(Sender: TObject);
begin
self.oTMBarCodeWeb:=TMBarCodeWeb.Create(nil);
self.oTMBarCodeWeb.Parent:=Main.LayoutAchat;
Main.TabControl1.ActiveTab:=Main.TAchat;
end;

procedure TMain.BInventClick(Sender: TObject);
begin
oTFInvent:=TFInvent.Create(nil);
oTFInvent.Parent:=Main.LayoutAchat;
Main.TabControl1.ActiveTab:=Main.TAchat;
oTFInvent.afficherEntete;

end;

procedure TMain.BpreAchatClick(Sender: TObject);
begin
oTFPreAchat:=TFPreAchat.Create(nil);
oTFPreAchat.Parent:=Main.LayoutAchat;
Main.TabControl1.ActiveTab:=Main.TAchat;
oTFPreAchat.afficherEntete;
oTFPreAchat.SGEntete.Row:=oTFPreAchat.SGEntete.RowCount;
end;

procedure TMain.BRecetteClick(Sender: TObject);
begin
oTFRecette:=TFRecette.Create(nil);
oTFRecette.Parent:=Main.LayoutAchat;
Main.TabControl1.ActiveTab:=Main.TAchat;
oTFRecette.afficher;

end;


procedure TMain.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab:=TMain;
  oconnection:=TConnection.Create(self).connection;

{$IFDEF MSWINDOWS}
//Self.StyleBook1.LoadFromFile(TPath.combine(ExpandFileName(GetCurrentDir),'MetropolisUIBlue.Style'));
{$ELSE}
//Self.StyleBook1.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'MetropolisUIBlue.Style'));
{$ENDIF}



end;

end.
