unit ReqRecetteDAOU;

interface

uses
  ReqRecetteDTOU, APIUtilsU, REST.Json, System.Generics.Collections;
type TListReqRecetteDTO=TObjectList<CReqRecetteDTO>;
type TReqRecetteDAO=class(TObject)
FReqRecetteDTO:CReqRecetteDTO;
public
constructor create(oReqRecetteDTO:CReqRecetteDTO);overload;
constructor create;overload;
function getNbr:integer;
function getRecette:TListReqRecetteDTO;

end;


implementation

uses
  System.SysUtils, FMX.Dialogs;

{ TReqRecetteDAO }


constructor TReqRecetteDAO.create(oReqRecetteDTO: CReqRecetteDTO);
begin
Self.FReqRecetteDTO:=oReqRecetteDTO;
end;

constructor TReqRecetteDAO.create;
begin

end;

function TReqRecetteDAO.getRecette: TListReqRecetteDTO;
var
  ReqRecetteList:TListReqRecetteDTO;
  OArt:CReqRecetteDTO;
  i:Integer;
  vNbr:integer;
begin
  vNbr:=self.getNbr;
  ReqRecetteList:=TJson.JsonToObject<TListReqRecetteDTO>
  ('{"ownsObjects": true,"listHelper": ['+inttostr(vNbr)+'], "items":'+
  RestReqGet.create(nil,'ReqRecette/getRecette').Response.JSONValue.ToString+'}');
  result:=ReqRecetteList;
end;

function TReqRecetteDAO.getNbr: integer;
begin
Result:=strtoint(RestReqGet.create(nil,'ReqRecette/getNbr').Response.JSONValue.ToString);
end;

end.
