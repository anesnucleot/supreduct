unit FormatDateSQLiteU;

interface

uses
  System.SysUtils;

type FormatDateSQLite=class
  public

  function FormatDate(datef:TDate):string;
end;

implementation

{ StringUtils }



{ FormatDateSQLite }

function FormatDateSQLite.FormatDate(datef: TDate): string;
var Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  mois,jour : string;
begin
  Present:= Now;
  DecodeDate(Present, Year, Month, Day);

  if Month>9 then
  begin
    mois:= IntToStr(Month);
    end else
    begin
    mois:='0'+IntToStr(Month);
  end;

  if Day>9 then
  begin
    jour:= IntToStr(Day);
    end else
    begin
    jour:='0'+IntToStr(Day);
  end;
result:=IntToStr(Year)+'-'+mois+'-'+jour;

end;

end.
