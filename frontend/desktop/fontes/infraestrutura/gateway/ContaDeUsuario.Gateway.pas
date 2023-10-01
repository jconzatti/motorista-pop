unit ContaDeUsuario.Gateway;

interface

type
   TDadoSaidaObtencaoPorIDContaDeUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      PlacaDoCarro: String;
      Passageiro: Boolean;
      Motorista: Boolean;
   end;

   TDadoEntradaInscricaoContaDeUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
   end;

   TGatewayContaDeUsuario = class abstract
   public
      function RealizarLogin(pEmail: String): String; virtual; abstract;
      function ObterPorID(pID: String): TDadoSaidaObtencaoPorIDContaDeUsuario; virtual; abstract;
      function InscreverUsuario(pDadoUsuario: TDadoEntradaInscricaoContaDeUsuario): String; virtual; abstract;
   end;

implementation

end.
