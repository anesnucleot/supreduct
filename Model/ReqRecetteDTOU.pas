unit ReqRecetteDTOU;

interface
type CReqRecetteDTO =class(TObject)
  private
    Frecette: Double;
    FDate_: String;
    procedure SetDate_(const Value: string);
    procedure Setrecette(const Value: Double);
  published
 property Date_:string read FDate_ write SetDate_;
 property recette:Double read Frecette write Setrecette;
end;

implementation

{ CReqRecette }

procedure CReqRecetteDTO.SetDate_(const Value: string);
begin
  FDate_ := Value;
end;

procedure CReqRecetteDTO.Setrecette(const Value: Double);
begin
  Frecette := Value;
end;

end.
