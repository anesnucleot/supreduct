unit BarCodeWebDTOU;

interface
uses ArticleWebDTOU;

type TBarCodeWebDTO=class(TObject)
  private
    Fidarticle: string;
    Fidbarcode: string;
    Fsymbole: string;
    procedure Setidarticle(const Value: string);
    procedure Setidbarcode(const Value: string);
    procedure Setsymbole(const Value: string);
  published

    property idarticle: string read Fidarticle write Setidarticle;
    property idbarcode: string read Fidbarcode write Setidbarcode;
    property symbole: string read Fsymbole write Setsymbole;


constructor create(id:string);

end;


implementation

{ CBarCode }

constructor TBarCodeWebDTO.create(id: string);
begin
Self.idBarCode:=id;
end;


procedure TBarCodeWebDTO.Setidarticle(const Value: string);
begin
  Fidarticle := Value;
end;

procedure TBarCodeWebDTO.Setidbarcode(const Value: string);
begin
  Fidbarcode := Value;
end;

procedure TBarCodeWebDTO.Setsymbole(const Value: string);
begin
  Fsymbole := Value;
end;

end.
