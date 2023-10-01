unit HTTP.Cliente;

interface

type
   TRespostaHTTP = record
      Dado: String;
      CodigoDeRespostaHTTP : Integer;
   end;

   TClienteHTTP = class abstract
   public
      function Post(pURL, pDado: String): TRespostaHTTP; virtual; abstract;
      function Get(pURL: String): TRespostaHTTP; virtual; abstract;
   end;

implementation

end.
