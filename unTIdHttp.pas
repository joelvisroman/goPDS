unit unTIdHttp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler, IdMultipartFormData, XmlDoc,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Soap.SOAPHTTPTrans,IdURI,
  Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient, HTTPApp, XMLIntf, ActiveX;
type
  TForm1 = class(TForm)
    MemoResp: TMemo;
    btnSend: TButton;
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSendClick(Sender: TObject);
var
  reqXML: TStream;
  sSend: String;
  idCertSSL : TIdSSLIOHandlerSocketOpenSSL;
  docLoad: IXMLDocument;
  IdHTTP1 : TIdHTTP;
begin
  MemoResp.Lines.Clear;
  try
    docLoad := TXMLDocument.Create(nil);
    docLoad.LoadFromFile('..\..\NHS.xml');

    {adds XML parameters}
    docLoad.XML.Text := StringReplace(docLoad.XML.Text, 'EVO_DOB', '19770705', [rfReplaceAll]);
    docLoad.XML.Text := StringReplace(docLoad.XML.Text, 'EVO_GENDER', '2', [rfReplaceAll]);
    docLoad.XML.Text := StringReplace(docLoad.XML.Text, 'EVO_GIVEN', 'LILITH', [rfReplaceAll]);
    docLoad.XML.Text := StringReplace(docLoad.XML.Text, 'EVO_FAMILY', 'LAWALI', [rfReplaceAll]);
    docLoad.XML.Text := StringReplace(docLoad.XML.Text, 'EVO_POSTAL', 'SK8 5HS', [rfReplaceAll]);

    reqXML := TStringStream.Create(docLoad.XML.Text, TEncoding.UTF8);
    try
      idCertSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdHTTP1 := TIdHTTP.Create(nil);
      try
        idCertSSL.SSLOptions.CertFile := '..\..\cert.pem';
        idCertSSL.SSLOptions.KeyFile := '..\..\key.pem';
        idCertSSL.SSLOptions.Method := sslvSSLv23;

        IdHTTP1.Request.Clear;
        IdHTTP1.IOHandler := idCertSSL;
        IdHTTP1.Request.CustomHeaders.AddValue('SOAPAction','"urn:nhs-itk:services:201005:getNHSNumber-v1-0"');

        sSend := IdHTTP1.Post('https://192.168.128.11:443/smsp/pds', reqXML);

        MemoResp.Lines.Add(IdHTTP1.ResponseText);
        MemoResp.Lines.Add(sSend);
        MemoResp.Lines.Add('NHS Number: ' + Copy(sSend, Pos(' extension=', sSend) + 12, 10));
      finally
        idCertSSL.Free;
        IdHTTP1.Free;
      end;
    finally
      FreeAndNil(reqXML);
      docLoad := Nil;
    end;
  except
   On E : EIdHTTPProtocolException do
   begin
      MemoResp.Lines.Clear;
      MemoResp.Lines.Add(E.ErrorMessage);
   end;
   On E : Exception do
   begin
     MemoResp.Lines.Clear;
     MemoResp.Lines.Add(E.Message);
   end;
  end;
end;
end.
