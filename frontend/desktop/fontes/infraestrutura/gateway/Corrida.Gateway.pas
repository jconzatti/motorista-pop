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

   TGatewayCorrida = class abstract
   public
      function SolicitarCorrida(pDadoSolicitacaoCorrida: TDadoEntradaSolicitacaoCorrida): String; virtual; abstract;
   end;

implementation

end.
