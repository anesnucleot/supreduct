unit BarCodeLocDTOU;

interface
uses ArticleLocDTOU;

type TBarCodeLocDTO=class(TObject)
  private
    Fsymbole: string;
    Fidbarcodeloc: string;
    Fidarticleloc: string;
    procedure Setidarticleloc(const Value: string);
    procedure Setidbarcodeloc(const Value: string);
    procedure Setsymbole(const Value: string);
  public

    property idarticleloc: string read Fidarticleloc write Setidarticleloc;
    property idbarcodeloc: string read Fidbarcodeloc write Setidbarcodeloc;
    property symbole: string read Fsymbole write Setsymbole;
   {sadaoui}
    constructor create(id: string); overload;
    constructor create();overload;
    {fin sadaoui}

end;


implementation

{ TBarCodeLocDTO }
 constructor TBarCodeLocDTO.create(id: string);
begin
Self.idbarcodeloc:=id;
end;

constructor TBarCodeLocDTO.create;
begin

end;

procedure TBarCodeLocDTO.Setidarticleloc(const Value: string);
begin
  Fidarticleloc := Value;
end;

procedure TBarCodeLocDTO.Setidbarcodeloc(const Value: string);
begin
  Fidbarcodeloc := Value;
end;

procedure TBarCodeLocDTO.Setsymbole(const Value: string);
begin
  Fsymbole := Value;
end;

end.
