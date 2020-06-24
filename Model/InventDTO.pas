unit InventDTO;

interface
type TInventDTO=class(TObject)
  private
    Fdesinvent: string;
    Fidinvent: Integer;
    procedure Setdesinvent(const Value: string);
    procedure Setidinvent(const Value: Integer);
  public
    property desinvent: string read Fdesinvent write Setdesinvent;
    property idinvent: Integer read Fidinvent write Setidinvent;
end;

implementation

{ TInventDTO }

procedure TInventDTO.Setdesinvent(const Value: string);
begin
  Fdesinvent := Value;
end;

procedure TInventDTO.Setidinvent(const Value: Integer);
begin
  Fidinvent := Value;
end;

end.
