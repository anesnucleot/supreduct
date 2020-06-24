unit RInventDAOU;

interface
uses RInventDTOU, System.Generics.Collections;
type RInventListDTO=TObjectList<TRInventDTO>;
type TRInventDAO=class (TObject)
function getNewId:integer;
function save(vRInventDTO:TRInventDTO): integer;
function getRInventsByInvent(vInvent:integer): RInventListDTO;
function getNbrRInventsByInvent(vInvent:integer): integer;
function getNbr: integer;
end;

implementation

uses
  APIUtilsU, REST.Json, System.SysUtils;

{ TRInventDAO }

function TRInventDAO.getNbrRInventsByInvent(vInvent: integer): integer;
begin
Result:=strtoint(RestReqGet.create(nil,'rinvent/getNbrRInventsByInvent/'+IntToStr(vInvent)).Response.JSONValue.ToString);

end;

function TRInventDAO.getNewId: integer;
begin
Result:=StrToInt(RestReqGet.create(nil,'rinvent/getNewId').Response.JSONValue.ToString);
end;

function TRInventDAO.getRInventsByInvent(vInvent:integer): RInventListDTO;
  var ListRInvent:RInventListDTO;
  oRInventDTO:TRInventDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=self.getNbrRInventsByInvent(vInvent);
  ListRInvent:=TJson.JsonToObject<RInventListDTO>
  ('{"ownsObjects": true,"listHelper": ['+inttostr(vNbr)+'], "items":'+
  RestReqGet.create(nil,'rinvent/getRInventsByInvent/'+IntToStr(vInvent)).Response.JSONValue.ToString+'}');
  result:=ListRInvent;
end;

function TRInventDAO.getNbr: integer;
begin
Result:=strtoint(RestReqGet.create(nil,'rinvent/getNbr').Response.JSONValue.ToString);

end;


function TRInventDAO.save(vRInventDTO:TRInventDTO): integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(vRInventDTO),
'rinvent/setRInvent');
end;

end.
