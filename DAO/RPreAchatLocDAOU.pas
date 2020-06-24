unit RPreAchatLocDAOU;

interface
uses RInventDTOU, System.Generics.Collections,RPreAchatLocDTOU,
  PreAchatLocDTOU;
type RPreAchatListDTO=TObjectList<TRPreAchatLocDTO>;
type TRPreAchatLocDAO=class (TObject)
function isExist(vRpreachatLocDTO:TRPreAchatLocDTO):boolean;
function getNewId:integer;
function saveLoc(vRPreAchatLocDTO:TRPreAchatLocDTO): integer;
function getRPreAchatsByPreAchat(vpreAchat:integer): RPreAchatListDTO;
function getNbrRPreAchatsByPreAchat(vpreAchat:integer): integer;
function getNbr: integer;
function delete(vRpreachatLocDTO:TRPreAchatLocDTO): integer;
function deleteAll(vpreachatDTO:TPreAchatLocDTO): integer;
function totalMontants(vpreachatDTO:TPreAchatLocDTO): Double;
end;

implementation

uses
  APIUtilsU, REST.Json, System.SysUtils, FireDAC.Comp.Client, MainU,
  PreAchatLocDAOU, FMX.Dialogs, System.UITypes ;

{ TRInventDAO }

function TRPreAchatLocDAO.isExist(vRpreachatLocDTO:TRPreAchatLocDTO):boolean;
begin
with TFdQuery.Create(nil) do
begin
  result:=false;
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) from rpreachatloc where idrpreachatloc='+
  QuotedStr(IntToStr(vRpreachatLocDTO.idrpreachatloc)));
  Active:=true;
  result:=Fields[0].AsInteger>0;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

function TRPreAchatLocDAO.getNbrRPreAchatsByPreAchat(vpreAchat:integer): integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) as nbr from rpreachatloc where idpreachatloc='+QuotedStr(IntToStr(vpreAchat)));
  Active:=true;
  result:=Fields[0].AsInteger;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TRPreAchatLocDAO.getNewId: integer;
begin
with TFdQuery.Create(nil) do
begin
  try
    Connection:=Main.oconnection;
    SQL.Add('select max(idrpreachatloc) as id from rpreachatloc ');
    Active:=true;

    if FieldByName('id').AsString='' then
    result:=1 else
    result:=FieldByName('id').AsInteger+1;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TRPreAchatLocDAO.getRPreAchatsByPreAchat(vpreAchat:integer): RPreAchatListDTO;
var vPreachatLocDTO:TRPreAchatLocDTO;
i:integer;

begin
result:=RPreAchatListDTO.Create();
with TFDQuery.Create(nil) do
begin
  i:=0;
  Connection:=Main.oconnection;
  SQL.Add('select * from rpreachatloc where idpreachatloc='+QuotedStr(IntToStr(vpreAchat)));
  Active:=true;
  First;
  while not Eof do
  begin
    vPreachatLocDTO:=TRPreAchatLocDTO.create(FieldByName('idrpreachatloc').AsInteger);
    vPreachatLocDTO.idrpreachatloc:=FieldByName('idrpreachatloc').AsInteger;
    vPreachatLocDTO.idpreachatloc:=FieldByName('idpreachatloc').AsInteger;
    vPreachatLocDTO.idbarcodeloc:=FieldByName('idbarcodeloc').AsString;
    vPreachatLocDTO.prixpreachatloc:=FieldByName('prixpreachatloc').AsFloat;
    vPreachatLocDTO.qtepreachatloc:=FieldByName('qtepreachatloc').AsFloat;
    result.Add(vPreachatLocDTO);
    Next;
    Inc(i);
  end;
end;
end;


function TRPreAchatLocDAO.deleteAll(vpreachatDTO: TPreAchatLocDTO): integer;
 var oPreAchatLocDAO :TPreAchatLocDAO;
begin
if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
begin
  oPreAchatLocDAO:= TPreAchatLocDAO.Create;
  with TFdQuery.Create(nil) do
  begin
    try
      if  oPreAchatLocDAO.isExist(vpreachatDTO)  then
      begin
        Connection:=Main.oconnection;
        SQL.Add('delete from rpreachatloc ');
        SQL.Add(' where idpreachatloc='+QuotedStr(IntToStr(vpreachatDTO.idpreachatloc)));
        ExecSQL;
      end;
    finally
      DisposeOf;
    end;
  end;
end;
end;

function TRPreAchatLocDAO.getNbr: integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) as nbr from rpreachatloc' );
  Active:=true;
  result:=Fields[0].AsInteger;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;


function TRPreAchatLocDAO.saveLoc(vRPreAchatLocDTO:TRPreAchatLocDTO): integer;
begin
with TFdQuery.Create(nil) do
begin
  try
    if not isExist(vRPreAchatLocDTO) then
    begin
      Connection:=Main.oconnection;
      SQL.Add('insert into rpreachatloc(idrpreachatloc,idpreachatloc,idbarcodeloc,');
      SQL.Add( ' qtepreachatloc,prixpreachatloc) values (');
      SQL.Add(QuotedStr(IntToStr(vRPreAchatLocDTO.idrpreachatloc))+',');
      SQL.Add(QuotedStr(IntToStr(vRPreAchatLocDTO.idpreachatloc))+',');
      SQL.Add(QuotedStr(vRPreAchatLocDTO.idbarcodeloc)+',');
      SQL.Add(QuotedStr(FloatToStr(vRPreAchatLocDTO.qtepreachatloc))+',');
      SQL.Add(QuotedStr(FloatToStr(vRPreAchatLocDTO.prixpreachatloc))+')');

      ExecSQL;
    end else
    begin
      Connection:=Main.oconnection;
      SQL.Add('update rpreachatloc set ');
      SQL.Add('qtepreachatloc='+QuotedStr(FloatToStr(vRPreAchatLocDTO.qtepreachatloc))+',');
      SQL.Add('prixpreachatloc='+QuotedStr(FloatToStr(vRPreAchatLocDTO.prixpreachatloc)));
      SQL.Add(' where idrpreachatloc='+QuotedStr(IntToStr(vRPreAchatLocDTO.idrpreachatloc)));
      ExecSQL;
    end;
  finally
    DisposeOf;
  end;
end;
end;


function TRPreAchatLocDAO.totalMontants(
  vpreachatDTO: TPreAchatLocDTO): Double;
 begin
 with TFdQuery.Create(nil) do
begin
  try
    Connection:=Main.oconnection;
    SQL.Add('select sum(rpreachatloc.qtepreachatloc*rpreachatloc.prixpreachatloc*tarticleloc.LastQteAchat) as tot '+
    ' from rpreachatloc,tbarcodeloc,tarticleloc' );
    SQL.Add(' where rpreachatloc.idbarcodeloc=tbarcodeloc.idbarcodeloc '+
    ' and tbarcodeloc.idarticleloc=tarticleloc.idarticleloc '+
    ' and rpreachatloc.idpreachatloc='+QuotedStr(IntToStr(vpreachatDTO.idpreachatloc)));
    Active:=true;
    if Fields[0].AsString<>'' then Result:=Fields[0].AsFloat else
    result:=0;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TRPreAchatLocDAO.delete(vRpreachatLocDTO:TRPreAchatLocDTO):integer;
 begin
// if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
//[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
//begin
  with TFdQuery.Create(nil) do
  begin
  try
    if isExist(vRpreachatLocDTO) then
    begin
      Connection:=Main.oconnection;
      SQL.Add('delete from rpreachatloc ');
      SQL.Add(' where idrpreachatloc='+QuotedStr(IntToStr(vRpreachatLocDTO.idrpreachatloc)));
      ExecSQL;
    end;
  finally
    DisposeOf;
  end;
  end;
end;
//end;

end.
