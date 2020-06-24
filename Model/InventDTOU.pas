unit InventDTOU;

interface
type TInventDTO=class(TObject)
  private
    Fdesinvent: string;
    Fdate_: string;
    Fidinvent: Integer;
    procedure Setdate_(const Value: string);
    procedure Setdesinvent(const Value: string);
    procedure Setidinvent(const Value: Integer);
  published

    property desinvent: string read Fdesinvent write Setdesinvent;
    property idinvent: Integer read Fidinvent write Setidinvent;
    property date_:string read Fdate_ write Setdate_;
end;

implementation
{ TInventDTO }

procedure TInventDTO.Setdate_(const Value: string);
begin
  Fdate_ := Value;
end;

procedure TInventDTO.Setdesinvent(const Value: string);
begin
  Fdesinvent := Value;
end;

procedure TInventDTO.Setidinvent(const Value: Integer);
begin
  Fidinvent := Value;
end;

end.
