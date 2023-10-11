unit FinalizarCorrida;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Corrida,
   Corrida.Repositorio,
   Posicao,
   Posicao.Repositorio,
   Repositorio.Fabrica,
   UUID;

type
   EFinalizacaoCorridaUsuarioNaoEhMotorista = class(EArgumentException);

   TDadoEntradaFinalizacaoCorrida = record
      IDDoMotorista: String;
      IDDaCorrida: String;
   end;

   TDadoSaidaFinalizacaoCorrida = record
      IDDaCorrida: String;
      Distancia: Double;
      Tarifa: Double;
   end;

   TFinalizarCorrida = class
   private
      FRepositorioContaUsuario: TRepositorioContaDeUsuario;
      FRepositorioCorrida: TRepositorioCorrida;
      FRepositorioPosicao: TRepositorioPosicao;
      procedure ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEntradaFinalizacaoDaCorrida: TDadoEntradaFinalizacaoCorrida): TDadoSaidaFinalizacaoCorrida;
   end;

implementation

{ TFinalizarCorrida }

constructor TFinalizarCorrida.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FRepositorioCorrida := pFabricaRepositorio.CriarRepositorioCorrida;
   FRepositorioPosicao := pFabricaRepositorio.CriarRepositorioPosicao;
end;

destructor TFinalizarCorrida.Destroy;
begin
   FRepositorioPosicao.Destroy;
   FRepositorioCorrida.Destroy;
   FRepositorioContaUsuario.Destroy;
   inherited;
end;

function TFinalizarCorrida.Executar(pEntradaFinalizacaoDaCorrida: TDadoEntradaFinalizacaoCorrida): TDadoSaidaFinalizacaoCorrida;
var
   lCorrida: TCorrida;
   lIDCorrida : TUUID;
   lPosicoesDaCorrida : TListaDePosicoes;
begin
   Result := Default(TDadoSaidaFinalizacaoCorrida);
   ValidarContaDeUsuarioEhMotorista(pEntradaFinalizacaoDaCorrida.IDDoMotorista);
   lIDCorrida := TUUID.Create(pEntradaFinalizacaoDaCorrida.IDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lIDCorrida);
      try
         lPosicoesDaCorrida := FRepositorioPosicao.ObterListaDePosicoesDaCorrida(lIDCorrida);
         try
            lCorrida.Finalizar(pEntradaFinalizacaoDaCorrida.IDDoMotorista, lPosicoesDaCorrida);
            FRepositorioCorrida.Atualizar(lCorrida);
            Result.IDDaCorrida := lCorrida.ID;
            Result.Distancia   := lCorrida.Distancia;
            Result.Tarifa      := lCorrida.Tarifa;
         finally
            lPosicoesDaCorrida.Destroy;
         end;
      finally
         lCorrida.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

procedure TFinalizarCorrida.ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
var lContaDeUsuario: TContaDeUsuario;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaUsuario.ObterPorID(lUUID);
      try
         if not lContaDeUsuario.Motorista then
            raise EFinalizacaoCorridaUsuarioNaoEhMotorista.Create('Conta de usuário não pertence a um motorista! Somente motoristas podem finalizar corridas!');
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
