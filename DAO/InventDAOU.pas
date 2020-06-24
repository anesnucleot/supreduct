unit InventDAOU;

interface

uses
  System.Generics.Collections, InventDTOU;
type TListInventDTO=TObjectList<TInventDTO>;


Type TInventDAO=class(TObject)
  function getInvents:TListInventDTO;
  function getNbr:integer;
  function Save(vInventDTO:TInventDTO): integer;
end;


implementation



{ TInventDAO }

uses APIUtilsU, REST.Json, System.SysUtils;

function TInventDAO.getInvents: TListInventDTO;
var
  ListInvent:TListInventDTO;
  oInventDTO:TInventDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=self.getNbr;
  ListInvent:=TJson.JsonToObject<TListInventDTO>
  ('{"ownsObjects": true,"listHelper": ['+inttostr(vNbr)+'], "items":'+
  RestReqGet.create(nil,'invent/getInvents').Response.JSONValue.ToString+'}');
  result:=ListInvent;
end;

function TInventDAO.getNbr: integer;
begin
Result:=strtoint(RestReqGet.create(nil,'invent/getNbr').Response.JSONValue.ToString);

end;

function TInventDAO.Save(vInventDTO:TInventDTO): integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(vInventDTO),
'invent/setInvent');
end;

end.
