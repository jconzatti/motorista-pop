unit Tela.Login;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Net.HTTPClient,
  System.JSON,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TTelaLogin = class(TForm)
    LbEmail: TLabel;
    EdEmail: TEdit;
    BtnEntrar: TButton;
    LbNovoAqui: TLabel;
    BtnCriarConta: TButton;
    procedure BtnEntrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TTelaLogin.BtnEntrarClick(Sender: TObject);
var lHTTPClient : THTTPClient;
    lHTTPResposta: IHTTPResponse;
    lJSONPassagerioLogin: TJSONValue;
    lStream: TStringStream;
    lEmailDoPassageiro, lIDDoPassageiro: string;
begin
   lHTTPClient := THTTPClient.Create;
   lStream := TStringStream.Create;
   try
      lEmailDoPassageiro := EdEmail.Text;
      lHTTPResposta := lHTTPClient.Post(Format('http://localhost:9000/login/%s', [lEmailDoPassageiro]), lStream);
      lIDDoPassageiro := lHTTPResposta.ContentAsString;
      lJSONPassagerioLogin := TJSONObject.ParseJSONValue(lIDDoPassageiro);
      if Assigned(lJSONPassagerioLogin) then
      begin
         try
            if lHTTPResposta.StatusCode = 200 then
               lIDDoPassageiro := lJSONPassagerioLogin.GetValue<string>('IDDoUsuario');
         finally
            lJSONPassagerioLogin.Destroy;
         end;
      end;
   finally
      lStream.Destroy;
      lHTTPClient.Destroy;
   end;

   ShowMessageFmt('Seu login é: %s!', [lIDDoPassageiro]);
end;

end.
