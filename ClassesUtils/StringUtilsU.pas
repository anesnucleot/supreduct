unit StringUtilsU;

interface

type StringUtils=class
  private
  str:string;
  public
  constructor create(vstr:string);
  function jsonToString:string;
  function DeleteGuillemets:string;
end;

implementation

{ StringUtils }

constructor StringUtils.create(vstr: string);
begin
Self.str:=vstr;
end;

function StringUtils.DeleteGuillemets: string;
var
  I: Integer;
  s:string;
begin
  s:='';
  for I := 1 to length(Self.str) do
  begin
    if (str[i]<>'"') then s:=s+str[i];
  end;
  result:=s;
end;

function StringUtils.jsonToString: string;
var
  I: Integer;
  s:string;
begin
s:='';
for I := 2 to length(Self.str)-1 do
begin
  s:=s+str[i];
end;
result:=s;
end;

end.
