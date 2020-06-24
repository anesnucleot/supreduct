unit PreAchatLocDAOU;

interface
uses PreAchatLocDTOU, System.Generics.Collections;
type TListPreAchatLocDTO=TObjectList<TPreAchatLocDTO>;

Type TPreAchatLocDAO =class(TObject)

function getPreAchatsLoc:TListPreAchatLocDTO;
function getNbr:integer;
function Saveloc(vpreachatlocDTO:TPreAchatLocDTO): integer;
function isExist(vpreachatLocDTO:TPreAchatLocDTO):boolean;
Function GetNewId:Integer;
function delete(vpreachatLocDTO:TPreAchatLocDTO): integer;
function hasDetail(vpreachatDTO: TPreAchatLocDTO): boolean;
end;

implementation

uses  FireDAC.Comp.Client, MainU, System.SysUtils,
  FormatDateSQLiteU, FMX.Dialogs, System.UITypes;

{ TPreAchatLocDAO }

function TPreAchatLocDAO.delete(vpreachatLocDTO: TPreAchatLocDTO): integer;
begin
if MessageDlg('Voulais vous vraiment supprimer?',TMsgDlgType.mtConfirmation,
[TmsgDlgBtn.mbOK,TmsgDlgBtn.mbCancel],0)=mrok then
begin
  if not hasDetail(vpreachatLocDTO) then
  begin
    with TFdQuery.Create(nil) do
    begin
      try
        if isExist(vpreachatLocDTO) then
        begin
          Connection:=Main.oconnection;
          SQL.Add('delete from tpreachatloc ');
          SQL.Add(' where idpreachatloc='+QuotedStr(IntToStr(vpreachatLocDTO.idpreachatloc)));
          ExecSQL;
        end;
      finally
        DisposeOf;
      end;
    end;
  end else showmessage('Vous devais supprimer les détails');
end;

end;

function TPreAchatLocDAO.getNbr: integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) as nbr from tpreachatloc ');
  Active:=true;
  result:=FieldByName('nbr').AsInteger;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;

function TPreAchatLocDAO.GetNewId: Integer;
begin
with TFdQuery.Create(nil) do
begin
  try
  Connection:=Main.oconnection;
  SQL.Add('select max(idpreachatloc) as id from tpreachatloc ');
  Active:=true;

  result:=FieldByName('id').AsInteger+1;

  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

function TPreAchatLocDAO.getPreAchatsLoc: TListPreAchatLocDTO;
var
preachatlist: TListPreAchatLocDTO;
i: integer;
vNbrLike:integer;
vpreachatLocDTO:TPreAchatLocDTO;

begin
   result:=TListPreAchatLocDTO.Create();
  with TFDQuery.Create(nil) do
  begin
    i:=0;
    Connection:=Main.oconnection;
    SQL.Add('select * from tpreachatloc ');
    Active:=true;
    First;
    while not Eof do
    begin

      vpreachatLocDTO:=TPreAchatLocDTO.create(FieldByName('idpreachatloc').AsInteger);
      vpreachatLocDTO.idpreachatloc:=FieldByName('idpreachatloc') .AsInteger;
      vpreachatLocDTO.despreachatloc:=FieldByName('despreachatloc') .AsString;
      vpreachatLocDTO.date_:=FieldByName('date_') .AsString;
      result.Add(vpreachatLocDTO);
      Next;
      Inc(i);
    end;
  end;
end;

function TPreAchatLocDAO.hasDetail(vpreachatDTO: TPreAchatLocDTO): boolean;
begin
with TFdQuery.Create(nil) do
begin
  try
    Connection:=Main.oconnection;
    SQL.Add('select count(*) as nbr '+
    ' from rpreachatloc where rpreachatloc.idpreachatloc='+
    QuotedStr(IntToStr(vpreachatDTO.idpreachatloc)));
    Active:=true;
    result:=Fields[0].AsInteger>0;
  finally
    Active:=false;
    DisposeOf;
  end;
end;
end;



function TPreAchatLocDAO.isExist(vpreachatLocDTO:TPreAchatLocDTO):boolean;
begin
with TFdQuery.Create(nil) do
begin
  result:=false;
  try
  Connection:=Main.oconnection;
  SQL.Add('select count(*) from tpreachatloc where idpreachatloc='+
  QuotedStr(IntToStr(vpreachatLocDTO.idpreachatloc)));
  Active:=true;
  result:=Fields[0].AsInteger>0;
  Active:=false;
  finally
    Active:=false;
    DisposeOf;
  end;
end;

end;

function TPreAchatLocDAO.Saveloc(vpreachatlocDTO: TPreAchatLocDTO): integer;
begin
with TFdQuery.Create(nil) do
begin
  try
    if not isExist(vpreachatlocDTO) then
    begin
      Connection:=Main.oconnection;
      SQL.Add('insert into tpreachatloc(idpreachatloc,despreachatloc,date_)');
      SQL.Add( 'values (');
      SQL.Add(QuotedStr(IntToStr(vpreachatlocDTO.idpreachatloc))+',');
      SQL.Add(QuotedStr(vpreachatlocDTO.despreachatloc)+',');
      SQL.Add(QuotedStr(FormatDateSQLite.Create.FormatDate(Now))+')');

      ExecSQL;
    end else
    begin
      Connection:=Main.oconnection;
      SQL.Add('update tpreachatloc set ');
      SQL.Add('despreachatloc='+QuotedStr(vpreachatlocDTO.despreachatloc)+',');
      SQL.Add('date_='+QuotedStr(FormatDateSQLite.Create.FormatDate(Now)));
      SQL.Add(' where idpreachatloc='+QuotedStr(IntToStr(vpreachatlocDTO.idpreachatloc)));
      ExecSQL;
    end;
  finally
    DisposeOf;
  end;
end;
end;

end.
