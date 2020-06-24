unit BarCodeLocDAOU;

interface

uses
  BarCodeLocDTOU, ArticleLocDTOU, APIUtilsU, REST.Json, System.Generics.Collections
  ,FireDAC.UI.Intf, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Comp.Client, IOUtils, FireDAC.DApt, FireDAC.Stan.Def,
  FireDAC.Stan.async;

type TlistBarCodeLocDTO=TObjectList<TbarCodeLocDTO>;
type TBarCodeLocDAO=class(TObject)
FBarCodeDTO:TbarCodeLocDTO;
FArticleDTO:TArticleLocDTO;
public
constructor create(vBarCodeDTO:TbarCodeLocDTO);overload;
constructor create;overload;
//function deleteLoc:integer;overload;
function getNbrBarCodeLoc:integer;
function getArticleLocDTO(vBarCodeDTO:TbarCodeLocDTO): TArticleLocDTO;


function getListBarCodeLoc:TlistBarCodeLocDTO;
function isExistLoc(vbarCodeDTO:TbarCodeLocDTO):boolean;
procedure loadData(var vbarCodeLocDTO:TbarCodeLocDTO);

procedure saveLoc(vbarCodeDTO:TbarCodeLocDTO);
function getDataFromWeb:TListBarCodeLocDTO;
procedure importDataFromWebToLocal;
procedure deleteAll;
end;

implementation

uses
  System.SysUtils, FMX.Dialogs,  UConnection, ArticleLocDAOU, MainU,
  BarCodeWebDAOU, BarCodeWebDTOU;

{ TArticleLocDAO }


constructor TBarCodeLocDAO.create(vBarCodeDTO: TbarCodeLocDTO);
begin
Self.FBarCodeDTO:=vBarCodeDTO;
end;

constructor TBarCodeLocDAO.create;
begin

end;

{function TBarCodeLocDAO.deleteLoc: integer;
begin

end; }

function TBarCodeLocDAO.getArticleLocDTO(vBarCodeDTO:TbarCodeLocDTO): TArticleLocDTO;
var oArticleLocDTO:TArticleLocDTO;
begin
with TFDQuery.Create(nil) do
begin
  Connection:=main.oconnection;
  SQL.Add('select idarticleloc from tbarcodeloc where idbarcodeloc = '+QuotedStr(vBarCodeDTO.idbarcodeloc));
  Active:=true;
  oArticleLocDTO:=TArticleLocDTO.create;
  oArticleLocDTO.idarticleloc:=FieldByName('idarticleloc').AsString;
  TArticleLocDAO.create.loadData(oArticleLocDTO);
  Result:=oArticleLocDTO;
end;

end;

function TBarCodeLocDAO.getNbrBarCodeLoc: integer;
begin

end;

function TBarCodeLocDAO.getListBarCodeLoc:TlistBarCodeLocDTO;
var vbarCodeLocDTO:TbarCodeLocDTO;
i:integer;

begin
result:=TlistBarCodeLocDTO.Create();
with TFDQuery.Create(nil) do
begin
  i:=0;
  Connection:=main.oconnection;
  SQL.Add('select * from tbarcodeloc');
  Active:=true;
  First;
  while not Eof do
  begin
    vbarCodeLocDTO:=TbarCodeLocDTO.create();
    vbarCodeLocDTO.idbarcodeloc:=FieldByName('idarticleloc').AsString;
    vbarCodeLocDTO.idbarcodeloc:=FieldByName('idbarcodeloc').AsString;
    vbarCodeLocDTO.symbole:=FieldByName('symbole').AsString;
    result.Add(vbarCodeLocDTO);
//    vbarCodeDTO.DisposeOf;
    Next;
    Inc(i);
  end;
end;
end;

function TBarCodeLocDAO.isExistLoc(vbarCodeDTO:TbarCodeLocDTO):boolean;
begin
with TFdQuery.Create(nil) do
begin
  result:=false;
  try
  Connection:=main.oconnection;
  SQL.Add('select count(*) from tbarcodeloc where idbarcodeloc='+
  QuotedStr(vbarCodeDTO.idbarcodeloc));
  Active:=true;
  result:=Fields[0].AsInteger>0;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

procedure TBarCodeLocDAO.loadData(var vbarCodeLocDTO: TbarCodeLocDTO);
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=main.oconnection;
  SQL.Add('select * from tbarcodeLoc where idbarcodeloc='+
  QuotedStr(vbarCodeLocDTO.idbarcodeloc));
  Active:=true;
  vbarCodeLocDTO.idarticleloc:=FieldByName('idarticleloc').AsString;
  vbarCodeLocDTO.symbole:=FieldByName('symbole').AsString;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

procedure TBarCodeLocDAO.saveLoc(vbarCodeDTO:TbarCodeLocDTO);
begin
with TFdQuery.Create(nil) do
begin
  if not isExistLoc(vbarCodeDTO) then
  begin
  try
    Connection:=main.oconnection;
    SQL.Add('insert into tbarcodeloc (idBarCodeloc,idArticleloc,symbole) values ('+
    QuotedStr(vbarCodeDTO.idbarcodeloc)+','
    +QuotedStr(vbarCodeDTO.idarticleloc)+
    ','+QuotedStr(vbarCodeDTO.symbole)+')');
    ExecSQL;
    finally
      DisposeOf;
    end;
  end else
  begin
    try
      Connection:=main.oconnection;
      SQL.Add('update tbarcode set idarticleloc='+
      QuotedStr(vbarCodeDTO.idarticleloc)+','
      +'symbole='+QuotedStr(vbarCodeDTO.symbole)+' where idbarcodeloc='+
      QuotedStr(vbarCodeDTO.idbarcodeloc));
      ExecSQL;
    finally
      DisposeOf;
    end;
  end;

end;

end;

function TBarCodeLocDAO.getDataFromWeb:TListBarCodeLocDTO;
var oListBarCodeLocDTO:TListBarCodeLocDTO;
oBarCodeWebDAO:TBarCodeWebDAO;
oBarCodeWebDTO:TBarCodeWebDTO;
oBarCodeLocDTO:TBarCodeLocDTO;
oListBarCodeWebDTO:TListBarCodeWeb;

begin
oBarCodeWebDAO:=TBarCodeWebDAO.create();
oListBarCodeLocDTO:=TListBarCodeLocDTO.Create;
oListBarCodeWebDTO:=oBarCodeWebDAO.getBarCodes;
for oBarCodeWebDTO in oListBarCodeWebDTO do
begin
  oBarCodeLocDTO:=TBarCodeLocDTO.create;
  oBarCodeLocDTO.idBarCodeloc:=oBarCodeWebDTO.idBarCode;
  oBarCodeLocDTO.idarticleloc:=oBarCodeWebDTO.idarticle;
  oBarCodeLocDTO.symbole:=oBarCodeWebDTO.symbole;
  oListBarCodeLocDTO.Add(oBarCodeLocDTO);
end;
Result:=oListBarCodeLocDTO;
end;

procedure TBarCodeLocDAO.deleteAll;
begin
with TFdQuery.Create(nil) do
begin
  try
    Connection:=Main.oconnection;
    SQL.Add('delete from tbarcodeloc ');
    ExecSQL;
  finally
    DisposeOf;
  end;
end;
end;

procedure TBarCodeLocDAO.importDataFromWebToLocal;
var oListBarCodeLocDTO:TListBarCodeLocDTO;
oLisTBarCodeWebDTO:TLisTBarCodeWeb;
oBarCodeLocDAO:TBarCodeWebDAO;
oBarCodeWebDAO:TBarCodeWebDAO;
oBarCodeLocDTO:TBarCodeLocDTO;
i:integer;
begin
oListBarCodeLocDTO:=Self.getDataFromWeb;
i:=0;
Self.deleteAll;
for oBarCodeLocDTO in oListBarCodeLocDTO do
begin
  inc(i);
  Self.saveloc(oBarCodeLocDTO);
end;
ShowMessage('transfert terminé');
end;


end.
