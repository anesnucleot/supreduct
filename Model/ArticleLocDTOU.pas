unit ArticleLocDTOU;

interface

type TArticleLocDTO=class
  private
    Flastprixachat: double;
    Flastqteachat: double;
    Fqtestock: double;
    Fprixvente: double;
    Fidarticleloc: string;
    Fuart: string;
    Fdesarticleloc: string;

    procedure Setdesarticleloc(const Value: string);
    procedure Setidarticleloc(const Value: string);
    procedure Setlastprixachat(const Value: double);
    procedure Setlastqteachat(const Value: double);
    procedure Setprixvente(const Value: double);
    procedure Setqtestock(const Value: double);
    procedure Setuart(const Value: string);
  public
    constructor create();overload;
    constructor create(id:string);overload;
    property lastprixachat: double read Flastprixachat write Setlastprixachat;
    property lastqteachat: double read Flastqteachat write Setlastqteachat;
    property qtestock: double read Fqtestock write Setqtestock;
    property prixvente: double read Fprixvente write Setprixvente;
    property idarticleloc: string read Fidarticleloc write Setidarticleloc;
    property uart: string read Fuart write Setuart;
    property desarticleloc: string read Fdesarticleloc write Setdesarticleloc;
end;


implementation
{ TArticleLocDTO }

constructor TArticleLocDTO.create();
begin

end;

constructor TArticleLocDTO.create(id: string);
begin
Self.idarticleloc:=id;
end;


procedure TArticleLocDTO.Setdesarticleloc(const Value: string);
begin
  Fdesarticleloc := Value;
end;

procedure TArticleLocDTO.Setidarticleloc(const Value: string);
begin
  Fidarticleloc := Value;
end;

procedure TArticleLocDTO.Setlastprixachat(const Value: double);
begin
  Flastprixachat := Value;
end;

procedure TArticleLocDTO.Setlastqteachat(const Value: double);
begin
  Flastqteachat := Value;
end;

procedure TArticleLocDTO.Setprixvente(const Value: double);
begin
  Fprixvente := Value;
end;

procedure TArticleLocDTO.Setqtestock(const Value: double);
begin
  Fqtestock := Value;
end;

procedure TArticleLocDTO.Setuart(const Value: string);
begin
  Fuart := Value;
end;

end.
