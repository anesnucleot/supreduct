unit RPreAchatLocDTOU;

interface
TYPE TRPreAchatLocDTO =class(TObject)
  private
    Fprixpreachatloc: Double;
    Fqtepreachatloc: Double;
    Fidbarcodeloc: string;
    Fidrpreachatloc: Integer;
    Fidpreachatloc: Integer;
    procedure Setidbarcodeloc(const Value: string);
    procedure Setidpreachatloc(const Value: Integer);
    procedure Setidrpreachatloc(const Value: Integer);
    procedure Setprixpreachatloc(const Value: Double);
    procedure Setqtepreachatloc(const Value: Double);
  public
  constructor create();overload;
  constructor create(id:Integer);overload;
  property idpreachatloc:Integer read Fidpreachatloc write Setidpreachatloc;
  property idrpreachatloc:Integer read Fidrpreachatloc write Setidrpreachatloc;
  property idbarcodeloc:string read Fidbarcodeloc write Setidbarcodeloc;
  property prixpreachatloc: Double read Fprixpreachatloc write Setprixpreachatloc;
  property qtepreachatloc: Double read Fqtepreachatloc write Setqtepreachatloc;

end;

implementation

{ TRPreAchatLocDTO }

constructor TRPreAchatLocDTO.create(id: Integer);
begin
self.idrpreachatloc:=id;
end;

constructor TRPreAchatLocDTO.create;
begin

end;

procedure TRPreAchatLocDTO.Setidbarcodeloc(const Value: string);
begin
  Fidbarcodeloc := Value;
end;

procedure TRPreAchatLocDTO.Setidpreachatloc(const Value: Integer);
begin
  Fidpreachatloc := Value;
end;

procedure TRPreAchatLocDTO.Setidrpreachatloc(const Value: Integer);
begin
  Fidrpreachatloc := Value;
end;

procedure TRPreAchatLocDTO.Setprixpreachatloc(const Value: Double);
begin
  Fprixpreachatloc := Value;
end;

procedure TRPreAchatLocDTO.Setqtepreachatloc(const Value: Double);
begin
  Fqtepreachatloc := Value;
end;

end.
