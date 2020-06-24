unit ArticleWebDTOU;

interface

type TArticleWebDTO=class
  private
    Flastprixachat: double;
    Flastqteachat: double;
    Fqtestock: double;
    Fidarticle: string;
    Fdesarticle: string;
    Fprixvente: double;
    Fuart: string;
    procedure Setdesarticle(const Value: string);
    procedure Setidarticle(const Value: string);
    procedure Setlastprixachat(const Value: double);
    procedure Setlastqteachat(const Value: double);
    procedure Setprixvente(const Value: double);
    procedure Setqtestock(const Value: double);
    procedure Setuart(const Value: string);
  published

    property lastprixachat: double read Flastprixachat write Setlastprixachat;
    property lastqteachat: double read Flastqteachat write Setlastqteachat;
    property qtestock: double read Fqtestock write Setqtestock;
    property idarticle: string read Fidarticle write Setidarticle;
    property desarticle: string read Fdesarticle write Setdesarticle;
    property prixvente: double read Fprixvente write Setprixvente;
    property uart: string read Fuart write Setuart;

  constructor create (id:string);
end;


implementation







{ TArticleWebDTO }

constructor TArticleWebDTO.create(id: string);
begin
Self.idarticle:=id;
end;


procedure TArticleWebDTO.Setdesarticle(const Value: string);
begin
  Fdesarticle := Value;
end;

procedure TArticleWebDTO.Setidarticle(const Value: string);
begin
  Fidarticle := Value;
end;

procedure TArticleWebDTO.Setlastprixachat(const Value: double);
begin
  Flastprixachat := Value;
end;

procedure TArticleWebDTO.Setlastqteachat(const Value: double);
begin
  Flastqteachat := Value;
end;

procedure TArticleWebDTO.Setprixvente(const Value: double);
begin
  Fprixvente := Value;
end;

procedure TArticleWebDTO.Setqtestock(const Value: double);
begin
  Fqtestock := Value;
end;

procedure TArticleWebDTO.Setuart(const Value: string);
begin
  Fuart := Value;
end;

end.
