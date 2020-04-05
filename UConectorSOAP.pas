unit UConectorSOAP;

interface

uses System.SysUtils, Xml.XMLDoc, Xml.xmldom, Xml.XMLIntf, Soap.SOAPHTTPTrans,
     Classes;

type
  TConectorRakuten = class
  private
    FEnvSaida: String;
    FEnvRetorno: String;
    FErro: String;
    FXmlRetorno: String;
    FXmlEnvio: String;
    FSoapAction: String;
    FURL: String;
    FRetData: String;
    FRetAcao: String;
    FRetDescricao: String;
    FRetStatus: Boolean;

    procedure SetErro(const Value: String);
    procedure SetXmlEnvio(const Value: String);
    procedure SetXmlRetorno(const Value: String);
    procedure SetSoapAction(const Value: String);
    procedure SetURL(const Value: String);
    procedure SetRetAcao(const Value: String);
    procedure SetRetData(const Value: String);
    procedure SetRetDescricao(const Value: String);
    procedure SetRetStatus(const Value: Boolean);
  protected
  public
  published
    Property XmlEnvio :  String read FXmlEnvio write SetXmlEnvio;
    Property XmlRetorno : String read FXmlRetorno write SetXmlRetorno;
    Property Erro : String read FErro write SetErro;
    Property SoapAction : String read FSoapAction write SetSoapAction;
    Property URL : String read FURL write SetURL;
    Property RetAcao : String read FRetAcao write SetRetAcao;
    Property RetData : String read FRetData write SetRetData;
    Property RetStatus : Boolean read FRetStatus write SetRetStatus;
    Property RetDescricao : String read FRetDescricao write SetRetDescricao;
    function ConsumirWebService : boolean;
  end;

implementation

{ TConectorRakuten }

function TConectorRakuten.ConsumirWebService: boolean;
var
   WebService : THTTPReqResp;
   RetStrem   : TMemoryStream;
   xml        : TStringlist;
   XRet       : TXMLDocument;
   LResponse  : IXMLNode;

   teste : String;
begin
  Result := False;

  WebService := THTTPReqResp.Create(nil);
  RetStrem := TMemoryStream.Create;
  xml := TStringList.Create;
  try
    XRet := TXMLDocument.Create(WebService);

    try
      WebService.SoapAction := SoapAction;
      WebService.URL        := URL;

      WebService.Execute(XmlEnvio,RetStrem);
      xml.LoadFromStream(RetStrem);
      XmlRetorno := xml.Text;

      XRet.LoadFromXML(xml.Text);
      XRet.Active := True;

      LResponse := XRet.ChildNodes[1];
      RetAcao := LResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes[0].Text;
      RetData := LResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes[1].Text;
      RetStatus := LResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes[2].Text = '1';
      RetDescricao:= LResponse.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes[3].Text;
    except
      on E : Exception do
        Erro := E.Message+sLineBreak+sLineBreak+XmlEnvio;
    end;

  finally
    Result := RetStatus;
    FreeAndNil(WebService);
    FreeAndNil(RetStrem);
    FreeAndNil(xml);
  end;

end;

procedure TConectorRakuten.SetXmlRetorno(const Value: String);
begin
  FXmlRetorno := Value;
end;

procedure TConectorRakuten.SetXmlEnvio(const Value: String);
begin
  FXmlEnvio := Value;
end;

procedure TConectorRakuten.SetErro(const Value: String);
begin
  FErro := Value;
end;

procedure TConectorRakuten.SetRetAcao(const Value: String);
begin
  FRetAcao := Value;
end;

procedure TConectorRakuten.SetRetData(const Value: String);
begin
  FRetData := Value;
end;

procedure TConectorRakuten.SetRetDescricao(const Value: String);
begin
  FRetDescricao := Value;
end;

procedure TConectorRakuten.SetRetStatus(const Value: Boolean);
begin
  FRetStatus := Value;
end;

procedure TConectorRakuten.SetSoapAction(const Value: String);
begin
  FSoapAction := Value;
end;

procedure TConectorRakuten.SetURL(const Value: String);
begin
  FURL := Value;
end;

end.
