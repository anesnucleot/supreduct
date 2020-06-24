unit UConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.UI.Intf, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Comp.Client, IOUtils;

type
    TConnection = class(TDataModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
  private
    { Déclarations privées }
  public

  function connection: TFDConnection;
  end;

var
  Connection: TConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TConnection.connection: TFDConnection;
const DBFILE='schemapos.db';
var dbpath:string;
fdc:TFDConnection;
begin
{$IFDEF MSWINDOWS}
dbpath:=TPath.combine(ExpandFileName(GetCurrentDir),DBFILE);
{$ELSE}
dbpath:=TPath.Combine(TPath.GetDocumentsPath,DBFILE);
{$ENDIF}
fdc:=TFDConnection.Create(self);
fdc.Params.DriverID:='SQLite';
fdc.Params.Database:=dbpath;
fdc.LoginPrompt:=false;
fdc.Connected:=true;
Result:=fdc;
end;


end.
