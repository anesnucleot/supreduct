unit RInventDTOU;

interface
type TRInventDTO=class
  private
    Fqteinvent: double;
    Fidrinvent: integer;
    Fidinvent: integer;
    Fprixachat: double;
    Fidbarcode: string;
    procedure Setidbarcode(const Value: string);
    procedure Setidinvent(const Value: integer);
    procedure Setidrinvent(const Value: integer);
    procedure Setprixachat(const Value: double);
    procedure Setqteinvent(const Value: double);
  published
    property qteinvent: double read Fqteinvent write Setqteinvent;
    property idrinvent: integer read Fidrinvent write Setidrinvent;
    property prixachat: double read Fprixachat write Setprixachat;
    property idinvent: integer read Fidinvent write Setidinvent;
    property idbarcode: string read Fidbarcode write Setidbarcode;

end;

implementation
{ TRInventDTO }

procedure TRInventDTO.Setidbarcode(const Value: string);
begin
  Fidbarcode := Value;
end;

procedure TRInventDTO.Setidinvent(const Value: integer);
begin
  Fidinvent := Value;
end;

procedure TRInventDTO.Setidrinvent(const Value: integer);
begin
  Fidrinvent := Value;
end;

procedure TRInventDTO.Setprixachat(const Value: double);
begin
  Fprixachat := Value;
end;

procedure TRInventDTO.Setqteinvent(const Value: double);
begin
  Fqteinvent := Value;
end;

end.
