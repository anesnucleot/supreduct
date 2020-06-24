unit PreAchatLocDTOU;

interface
type TPreAchatLocDTO=class(TObject)
  private
    Fdate_: string;
    Fidpreachatloc: Integer;
    Fdespreachatloc: string;
    procedure Setdate_(const Value: string);
    procedure Setdespreachatloc(const Value: string);
    procedure Setidpreachatloc(const Value: Integer);
  public
 constructor create();overload;
 constructor create(id:Integer);overload;
property idpreachatloc:Integer read Fidpreachatloc write Setidpreachatloc;
property despreachatloc:string read Fdespreachatloc write Setdespreachatloc;
property date_  :string read Fdate_ write Setdate_;

end;

implementation

{ TPreAchatLocDTO }

constructor TPreAchatLocDTO.create(id: integer);
begin
self.idpreachatloc:=id;
end;

constructor TPreAchatLocDTO.create;
begin

end;

procedure TPreAchatLocDTO.Setdate_(const Value: string);
begin
  Fdate_ := Value;
end;

procedure TPreAchatLocDTO.Setdespreachatloc(const Value: string);
begin
  Fdespreachatloc := Value;
end;

procedure TPreAchatLocDTO.Setidpreachatloc(const Value: Integer);
begin
  Fidpreachatloc := Value;
end;

end.
