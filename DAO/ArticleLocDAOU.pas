unit ArticleLocDAOU;

interface


uses
  ArticleLocDTOU, APIUtilsU, FireDAC.UI.Intf, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Comp.Client, IOUtils, System.Generics.Collections;

type TListArticleLocDTO=TObjectList<TArticleLocDTO>;
type TArticleLocDAO=class(TObject)
FArticleLocDTO:TArticleLocDTO;
private
function getDataFromWeb:TListArticleLocDTO;
public
constructor create(oArticleLocDTO:TArticleLocDTO);overload;
constructor create;overload;
function save(varticleLocDTO:TArticleLocDTO):integer;
function isExist(varticleLocDTO:TArticleLocDTO):boolean;
function delete(varticleLocDTO:TArticleLocDTO):integer;
function getNbrArticle:integer;
function getNbrLike(str:string):integer;
function getListArticleLocs:TListArticleLocDTO;
function getListByText(textLike:string):TListArticleLocDTO;
function getMaxIdArticle: string;
procedure loadData(var varticleLocDTO: TarticleLocDTO);
procedure importDataFromWebToLocal;
procedure deleteAll;
{sadaoui :ajouter prix de carton}
function Prixcarton(varticleLocDTO:TArticleLocDTO):double;
{fin sadaoui}
end;


implementation

uses
  System.SysUtils, FMX.Dialogs, UConnection, MainU, ArticleWebDAOU,
  ArticleWebDTOU;

{ ArticleLocDAO }


constructor TArticleLocDAO.create(oArticleLocDTO: TArticleLocDTO);
begin
Self.FArticleLocDTO:=oArticleLocDTO;
end;

constructor TArticleLocDAO.create;
begin

end;

function TArticleLocDAO.delete(varticleLocDTO:TArticleLocDTO): integer;
begin
with TFdQuery.Create(nil) do
begin
  try
    if isExist(varticleLocDTO) then
    begin
      Connection:=Main.oconnection;
      SQL.Add('delete from tarticleloc ');
      SQL.Add(' where idArticleloc='+QuotedStr(varticleLocDTO.idarticleloc));
      ExecSQL;
    end;
  finally
    DisposeOf;
  end;
end;
end;

function TArticleLocDAO.getListArticleLocs:TListArticleLocDTO;
var varticleLocDTO:TArticleLocDTO;
i:integer;

begin
result:=TListArticleLocDTO.Create();
with TFDQuery.Create(nil) do
begin
  i:=0;
  Connection:=Main.oconnection;
  SQL.Add('select * from tarticleloc');
  Active:=true;
  First;
  while not Eof do
  begin
    varticleLocDTO:=TArticleLocDTO.create(FieldByName('idarticleloc').AsString);
    varticleLocDTO.idarticleloc:=FieldByName('idarticleloc').AsString;
    varticleLocDTO.desarticleloc:=FieldByName('desarticleloc').AsString;
    varticleLocDTO.lastprixachat:=FieldByName('lastprixachat').AsFloat;
    varticleLocDTO.prixvente:=FieldByName('prixvente').AsFloat;
    varticleLocDTO.uart:=FieldByName('uart').AsString;
    varticleLocDTO.lastqteachat:=FieldByName('lastqteachat').AsFloat;
    varticleLocDTO.qtestock:=FieldByName('qtestock').AsFloat;
    result.Add(varticleLocDTO);
    Next;
    Inc(i);
  end;
end;
end;

function TArticleLocDAO.getListByText(textLike: string): TListArticleLocDTO;
var
  ArtList:TListArticleLocDTO;
  OArt:TArticleLocDTO;
  i:Integer;
  vNbrLike:integer;
 varticleLocDTO:TArticleLocDTO;
begin
if textLike<>'' then
begin
  result:=TListArticleLocDTO.Create();
  with TFDQuery.Create(nil) do
  begin
    i:=0;
    Connection:=Main.oconnection;
    SQL.Add('select * from tarticleloc where desarticleloc like '+QuotedStr('%'+textLike+'%'));
    Active:=true;
    First;
    while not Eof do
    begin
      varticleLocDTO:=TArticleLocDTO.create(FieldByName('idarticleloc').AsString);
      varticleLocDTO.idarticleloc:=FieldByName('idarticleloc').AsString;
      varticleLocDTO.desarticleloc:=FieldByName('desarticleloc').AsString;
      varticleLocDTO.lastprixachat:=FieldByName('lastprixachat').AsFloat;
      varticleLocDTO.prixvente:=FieldByName('prixvente').AsFloat;
      varticleLocDTO.uart:=FieldByName('uart').AsString;
      varticleLocDTO.lastqteachat:=FieldByName('lastqteachat').AsFloat;
      varticleLocDTO.qtestock:=FieldByName('qtestock').AsFloat;
      result.Add(varticleLocDTO);
      Next;
      Inc(i);
    end;
  end;
end;
end;


function TArticleLocDAO.getNbrArticle: integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) as nbr from tarticleloc ');
  Active:=true;
  result:=FieldByName('nbr').AsInteger;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TArticleLocDAO.getDataFromWeb:TListArticleLocDTO;
var oListArticleLocDTO:TListArticleLocDTO;
oArticleWebDAO:TArticleWebDAO;
oArticleWebDTO:TArticleWebDTO;
oArticleLocDTO:TArticleLocDTO;
oListArticleWebDTO:TListArticleWebDTO;

begin
oArticleWebDAO:=TArticleWebDAO.create();
oListArticleLocDTO:=TListArticleLocDTO.Create;
oListArticleWebDTO:=oArticleWebDAO.getArticles;
for oArticleWebDTO in oListArticleWebDTO do
begin
  oArticleLocDTO:=TArticleLocDTO.create;
  oArticleLocDTO.idarticleloc:=oArticleWebDTO.idarticle;
  oArticleLocDTO.desarticleloc:=oArticleWebDTO.desarticle;
  oArticleLocDTO.lastprixachat:=oArticleWebDTO.lastprixachat;
  oArticleLocDTO.prixvente:=oArticleWebDTO.prixvente;
  oArticleLocDTO.lastqteachat:=oArticleWebDTO.lastqteachat;
  oArticleLocDTO.qtestock:=oArticleWebDTO.qtestock;
  oArticleLocDTO.uart:=oArticleWebDTO.uart;
  oListArticleLocDTO.Add(oArticleLocDTO);
//  oArticleLocDTO.DisposeOf;
end;
Result:=oListArticleLocDTO;
end;

procedure TArticleLocDAO.deleteAll;
begin
with TFdQuery.Create(nil) do
begin
  try
    Connection:=Main.oconnection;
    SQL.Add('delete from tarticleloc ');
    ExecSQL;
  finally
    DisposeOf;
  end;
end;


end;

procedure TArticleLocDAO.importDataFromWebToLocal;
var oListArticleLocDTO:TListArticleLocDTO;
oLisTArticleWebDTO:TLisTArticleWebDTO;
oArticleLocDAO:TArticleWebDAO;
oArticleWebDAO:TArticleWebDAO;
oArticleLocDTO:TArticleLocDTO;
i:integer;
begin
oListArticleLocDTO:=Self.getDataFromWeb;
i:=0;
Self.deleteAll;
for oArticleLocDTO in oListArticleLocDTO do
begin
  inc(i);
  Self.save(oArticleLocDTO);
end;
ShowMessage('transfert terminé');
end;

function TArticleLocDAO.isExist(varticleLocDTO:TArticleLocDTO):boolean;
begin
with TFdQuery.Create(nil) do
begin
  result:=false;
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) from tarticleloc where idarticleloc='+
  QuotedStr(varticleLocDTO.idarticleloc));
  Active:=true;
  result:=Fields[0].AsInteger>0;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;


function TArticleLocDAO.save(varticleLocDTO:TArticleLocDTO):integer;
begin
with TFdQuery.Create(nil) do
begin
  try
    if not isExist(varticleLocDTO) then
    begin
      Connection:=Main.oconnection;
      SQL.Add('insert into tarticleloc (idArticleloc,desArticleloc,LastPrixAchat,PrixVente,');
      SQL.Add('UArt,LastQteAchat) values (');
      SQL.Add(QuotedStr(varticleLocDTO.idarticleloc)+',');
      SQL.Add(QuotedStr(varticleLocDTO.desarticleloc)+',');
      SQL.Add(QuotedStr(floattostr(varticleLocDTO.lastprixachat))+',');
      SQL.Add(QuotedStr(floattostr(varticleLocDTO.prixvente))+',');
      SQL.Add(QuotedStr(varticleLocDTO.uart)+',');
      SQL.Add(QuotedStr(floattostr(varticleLocDTO.lastqteachat))+')');
      ExecSQL;
    end else
    begin
      Connection:=Main.oconnection;
      SQL.Add('update tarticleloc set ');
      SQL.Add('desArticleloc='+QuotedStr(varticleLocDTO.desArticleloc)+',');
      SQL.Add('LastPrixAchat='+QuotedStr(floattostr(varticleLocDTO.LastPrixAchat))+',');
      SQL.Add('PrixVente='+QuotedStr(floattostr(varticleLocDTO.PrixVente))+',');
      SQL.Add('UArt='+QuotedStr(varticleLocDTO.UArt)+',');
      SQL.Add('LastQteAchat='+QuotedStr(floattostr(varticleLocDTO.LastQteAchat)));
      SQL.Add(' where idArticleloc='+QuotedStr(varticleLocDTO.idarticleloc));
      ExecSQL;
    end;
  finally
    DisposeOf;
  end;
end;
end;


function TArticleLocDAO.getNbrLike(str:String): integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) from tarticleloc where desarticleloc like '+QuotedStr('%'+str+'%'));
  Active:=true;
  result:=Fields[0].AsInteger;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

procedure TArticleLocDAO.loadData(var varticleLocDTO: TarticleLocDTO);
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select * from tarticleloc where idarticleloc='+
  QuotedStr(varticleLocDTO.idarticleloc));
  Active:=true;
  varticleLocDTO.desarticleloc:=FieldByName('desarticleloc').AsString;
  varticleLocDTO.lastprixachat:=FieldByName('lastprixachat').AsFloat;
  varticleLocDTO.prixvente:=FieldByName('prixvente').AsFloat;
  varticleLocDTO.uart:=FieldByName('uart').AsString;
  varticleLocDTO.qtestock:=FieldByName('qtestock').AsFloat;
  varticleLocDTO.lastqteachat:=FieldByName('lastqteachat').AsFloat;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;


function TArticleLocDAO.Prixcarton(varticleLocDTO: TArticleLocDTO): double;
begin
with TFdQuery.Create(nil) do
begin
  try

    Connection:=Main.oconnection;
    SQL.Add('select lastprixachat*lastqteachat as montant '+
    ' from tarticleloc' );
    SQL.Add(' where tarticleloc.idarticleloc='+QuotedStr(varticleLocDTO.idarticleloc));
    Active:=true;
    if Fields[0].AsString<>'' then Result:=Fields[0].AsFloat else
    result:=0;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TArticleLocDAO.getMaxIdArticle: string;
begin

end;

end.
