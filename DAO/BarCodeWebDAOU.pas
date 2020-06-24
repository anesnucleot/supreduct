unit BarCodeWebDAOU;

interface

uses
  BarCodeWebDTOU, ArticleWebDTOU, APIUtilsU, REST.Json
  ,FireDAC.UI.Intf, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Comp.Client, IOUtils, FireDAC.DApt, FireDAC.Stan.Def,
  FireDAC.Stan.async, System.Generics.Collections;

type TlistBarCodeWeb=TObjectList<TbarCodeWebDTO>;
//type TlistBarCodeLoc=TObjectList<TbarCodeLocDTO>;

type TBarCodeWebDAO=class(TObject)
FBarCodeDTO:TbarCodeWebDTO;
FArticleDTO:TArticleWebDTO;
public
constructor create(oBarCodeDTO:TbarCodeWebDTO);overload;
constructor create;overload;
function saveWeb:integer;
function deleteWeb:integer;
function getBarCodes: TListBarCodeWeb;
function getNbrBarCodeWeb:integer;
function getArticleWebDTO:TArticleWebDTO;
function isExistWeb:Boolean;

//function getListBarCodeLoc:TlistBarCodeLoc;
procedure deleteLoc(vbarCodeDTO: TbarCodeWebDTO);
function isExistLoc(vbarCodeDTO:TbarCodeWebDTO):boolean;
procedure saveLoc(vbarCodeDTO:TbarCodeWebDTO);


end;

implementation

uses
  System.SysUtils, FMX.Dialogs,  UConnection;

{ TArticleWebDAO }


constructor TBarCodeWebDAO.create(oBarCodeDTO: TbarCodeWebDTO);
begin
Self.FBarCodeDTO:=oBarCodeDTO;
end;

constructor TBarCodeWebDAO.create;
begin

end;

function TBarCodeWebDAO.deleteWeb: integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(FBarCodeDTO),
'BarCode/delBarCode');
end;

function TBarCodeWebDAO.getArticleWebDTO: TArticleWebDTO;
begin
Result:=TJSON.JsonToObject<TArticleWebDTO>(RestReqGet.create(nil,'BarCode/getArticle/'+Self.FBarCodeDTO.idbarcode).Response.JSONValue.ToString);
end;

function TBarCodeWebDAO.getNbrBarCodeWeb: integer;
begin
Result:=strtoint(RestReqGet.create(nil,'BarCode/getNbr').Response.JSONValue.ToString);
end;

function TBarCodeWebDAO.SaveWeb: integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(FBarCodeDTO),
'BarCode/setBarCode');
end;

function TBarCodeWebDAO.isExistWeb: Boolean;
begin
//ShowMessage(upperCase(RestReqGet.create(nil,'BarCode/isExist/'+Self.FBarCodeDTO.idBareCode).Response.JSONValue.ToString));
Result:=upperCase(RestReqGet.create(nil,'BarCode/isExist/'+Self.FBarCodeDTO.idbarcode).
Response.JSONValue.ToString)='TRUE';
end;

function TBarCodeWebDAO.getBarCodes: TListBarCodeWeb;
var
  ArtList:TListBarCodeWeb;
  i:Integer;
  vNbrLike:integer;
begin
vNbrLike:=Self.getNbrBarCodeWeb;
ArtList:=TJson.JsonToObject<TListBarCodeWeb>
('{"ownsObjects": true,"listHelper": ['+inttostr(vNbrLike)+'], "items":'+
RestReqGet.create(nil,'BarCode/getBarCodes').Response.JSONValue.ToString+'}');
result:=ArtList;
end;

procedure TBarCodeWebDAO.deleteLoc(vbarCodeDTO: TbarCodeWebDTO);
begin


end;

function TBarCodeWebDAO.isExistLoc(vbarCodeDTO:TbarCodeWebDTO):boolean;
begin
with TFdQuery.Create(nil) do
begin
  result:=false;
  try
  Connection:=Tconnection.Create(nil).connection;
  SQL.Add('select count(*) from tbarcode where idbarcode='+
  QuotedStr(vbarCodeDTO.idbarcode));
  Active:=true;
  result:=Fields[0].AsInteger>0;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;
procedure TBarCodeWebDAO.saveLoc(vbarCodeDTO:TbarCodeWebDTO);
begin
with TFdQuery.Create(nil) do
begin
  if not isExistLoc(vbarCodeDTO) then
  begin
  try
    Connection:=TConnection.Create(nil).connection;
    SQL.Add('insert into tbarcode values ('+QuotedStr(vbarCodeDTO.idbarcode)+','
    +QuotedStr(vbarCodeDTO.idarticle)+
    ','+QuotedStr(vbarCodeDTO.symbole)+')');
    ExecSQL;
    finally
      DisposeOf;
    end;
  end else
  begin
    try
      Connection:=TConnection.Create(nil).connection;
      SQL.Add('update tbarcode set idarticle='+
      QuotedStr(vbarCodeDTO.idarticle)+','
      +'symbole='+QuotedStr(vbarCodeDTO.symbole)+' where idbarcode='+
      QuotedStr(vbarCodeDTO.idbarcode));
      ExecSQL;
    finally
      DisposeOf;
    end;
  end;

end;

end;

end.
