unit ContaUsuario.DAO;

interface

type
   TDadoInscricaoContaUsuario = record
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
   end;

   TDadoContaUsuario = record
      ID: String;
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
      Data: TDateTime;
      Verificada: Boolean;
      CodigoDeVerificacao: String;
   end;

   TDAOContaUsuario = class abstract
   public
      procedure Salvar(pDadoContaUsuario: TDadoContaUsuario); virtual; abstract;
      function ObterPorEmail(pEmail: String): TDadoContaUsuario; virtual; abstract;
      function ObterPorID(pID: String): TDadoContaUsuario; virtual; abstract;
   end;

implementation

end.
