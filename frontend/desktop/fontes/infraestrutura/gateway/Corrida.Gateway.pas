unit Corrida.Gateway;

interface

type
   TCoodernadaSolicitacaoCorrida = record
      Latitude: Double;
      Longitude: Double;
   end;

   TDadoEntradaSolicitacaoCorrida = record
      IDDoPassageiro: String;
      De: TCoodernadaSolicitacaoCorrida;
      Para: TCoodernadaSolicitacaoCorrida;
   end;

   TDadoSaidaObtencaoCorridaAtiva = record
      Passageiro: String;
      Motorista: String;
      Status: String;
      Destino: TCoodernadaSolicitacaoCorrida;
   end;

   TGatewayCorrida = class abstract
   public
      function SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String; virtual; abstract;
      function ObterCorridaAtiva(pIDDoUsuario: String): TDadoSaidaObtencaoCorridaAtiva; virtual; abstract;
   end;

implementation

end.
