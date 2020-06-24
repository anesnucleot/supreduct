unit APIUtilsU;
interface
uses REST.Client,REST.Types, System.Classes, System.JSON;

type RestReqGet =class(TRESTRequest)
published
constructor create(owner:TComponent;res: string);
end;

type RestReqPost =class(TRESTRequest)
published
constructor create(body:TJSonObject; res: string);
end;


implementation
uses MainU, FMX.Dialogs;

{ RestReq }

{ @Contrainte txt="le port doit étre 8080"}
constructor RestReqGet.create(owner: TComponent; res: string);
begin
inherited create(owner);
main.restClient1.BaseURL:='http://'+Main.EIP.text+':8080/APISup1/rest';
Self.Client:=Main.RESTClient1;
Self.Response:=TRESTResponse.Create(self);
Self.Method:=TRESTRequestMethod.rmGET;
Self.Resource:=res;
Self.Execute;
end;


constructor RestReqPost.create(body:TJSonObject; res: string);
begin
main.restClient1.BaseURL:='http://'+Main.EIP.text+':8080/APISup1/rest';
inherited create(nil);
Self.Client:=Main.RESTClient1;
Self.Method:=TRESTRequestMethod.rmPOST;
Self.Resource:=res;
//showmessage(body.ToString);
self.AddBody(body);
Self.Execute;
end;




end.
