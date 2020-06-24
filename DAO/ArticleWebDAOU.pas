
unit ArticleWebDAOU;

interface

uses
  ArticleWebDTOU, APIUtilsU, REST.Json, System.Generics.Collections;
type TLisTArticleWebDTO=TObjectList<TArticleWebDTO>;
type TArticleWebDAO=class(TObject)
FArticleDTO:TArticleWebDTO;
public
constructor create(oArticleDTO:TArticleWebDTO);overload;
constructor create;overload;
function save:integer;
function delete:integer;
function getNbrArticle:integer;
function getNbrLike(str:string):integer;
function getListByText(textLike:string):TLisTArticleWebDTO;
function getArticles:TLisTArticleWebDTO;
function getMaxIdArticle: string;




end;


implementation

uses
  System.SysUtils, FMX.Dialogs;

{ TArticleWebDAO }


constructor TArticleWebDAO.create(oArticleDTO: TArticleWebDTO);
begin
Self.FArticleDTO:=oArticleDTO;
end;

constructor TArticleWebDAO.create;
begin

end;

function TArticleWebDAO.delete: integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(FArticleDTO),
'Article/delArticle');
end;

function TArticleWebDAO.getArticles: TLisTArticleWebDTO;
var
  ArtList:TLisTArticleWebDTO;
  OArt:TArticleWebDTO;
  i:Integer;
  vNbrLike:integer;
begin
vNbrLike:=Self.getNbrArticle;
ArtList:=TJson.JsonToObject<TLisTArticleWebDTO>
('{"ownsObjects": true,"listHelper": ['+inttostr(vNbrLike)+'], "items":'+
RestReqGet.create(nil,'Article/getArticles').Response.JSONValue.ToString+'}');
result:=ArtList;
end;

function TArticleWebDAO.getListByText(textLike: string): TLisTArticleWebDTO;
var
  ArtList:TLisTArticleWebDTO;
  OArt:TArticleWebDTO;
  i:Integer;
  vNbrLike:integer;
begin
{ @Contrainte txt="la premiere colonne de la table doit étre de type integer" }


if textLike<>'' then
begin
  vNbrLike:=self.getNbrLike(textLike);
  ArtList:=TJson.JsonToObject<TLisTArticleWebDTO>
  ('{"ownsObjects": true,"listHelper": ['+inttostr(vNbrLike)+'], "items":'+
  RestReqGet.create(nil,'Article/getArticlesLike/'+textLike).Response.JSONValue.ToString+'}');
  result:=ArtList;
end;
end;

function TArticleWebDAO.getNbrArticle: integer;
begin
Result:=strtoint(RestReqGet.create(nil,'Article/getNbr').Response.JSONValue.ToString);
end;

function TArticleWebDAO.Save: integer;
begin
RestReqPost.create(TJson.ObjectToJsonObject(FArticleDTO),
'Article/setArticle');
end;


function TArticleWebDAO.getNbrLike(str:String): integer;

var i:integer;

begin

i:=5;
{ @expl txt="ramene le nombre d'enregistrement des article selon la désignation qui contien le text str"}
Result:=strtoint(RestReqGet.create(nil,'Article/getNbrLike/'+str).Response.JSONValue.ToString);
end;




function TArticleWebDAO.getMaxIdArticle: string;
begin
Result:=FormatFloat('0000000',StrToInt(RestReqGet.create(nil,'Article/getMaxIdArticle').
Response.JSONValue.ToString)+1);
end;

end.

