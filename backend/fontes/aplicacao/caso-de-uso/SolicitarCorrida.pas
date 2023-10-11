unit SolicitarCorrida;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   Corrida,
   Repositorio.Fabrica,
   ContaDeUsuario.Repositorio,
   Corrida.Repositorio,
   UUID;

type
   ESolicitacaoCorridaUsuarioNaoEhPassageiro = class(EArgumentException);
   ESolicitacaoCorridaPassageiroJaPossuiCorridaAtiva = class(EArgumentException);

   TCoodernadaSolicitacaoCorrida = record
      Latitude: Double;
      Longitude: Double;
   end;

   TDadoEntradaSolicitacaoCorrida = record
      IDDoPassageiro: String;
      De: TCoodernadaSolicitacaoCorrida;
      Para: TCoodernadaSolicitacaoCorrida;
   end;

   TDadoSaidaSolicitacaoCorrida = record
      IDDaCorrida: String;
   end;

   TSolicitarCorrida = class
   private
      FRepositorioContaUsuario: TRepositorioContaDeUsuario;
      FRepositorioCorrida: TRepositorioCorrida;
      procedure ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
      procedure ValidarPassageiroComAlgumaCorridaAtiva(pIDDoPassageiro: String);
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEntradaSolicitacaoDeCorrida: TDadoEntradaSolicitacaoCorrida): TDadoSaidaSolicitacaoCorrida;
   end;

implementation

{ TSolicitarCorrida }

constructor TSolicitarCorrida.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FRepositorioCorrida      := pFabricaRepositorio.CriarRepositorioCorrida;
end;

destructor TSolicitarCorrida.Destroy;
begin
   FRepositorioCorrida.Destroy;
   FRepositorioContaUsuario.Destroy;
   inherited;
end;

function TSolicitarCorrida.Executar(pEntradaSolicitacaoDeCorrida: TDadoEntradaSolicitacaoCorrida): TDadoSaidaSolicitacaoCorrida;
var
   lCorrida: TCorrida;
begin
   ValidarContaDeUsuarioEhPassageiro(pEntradaSolicitacaoDeCorrida.IDDoPassageiro);
   ValidarPassageiroComAlgumaCorridaAtiva(pEntradaSolicitacaoDeCorrida.IDDoPassageiro);
   lCorrida := TCorrida.Criar(pEntradaSolicitacaoDeCorrida.IDDoPassageiro,
                              pEntradaSolicitacaoDeCorrida.De.Latitude,
                              pEntradaSolicitacaoDeCorrida.De.Longitude,
                              pEntradaSolicitacaoDeCorrida.Para.Latitude,
                              pEntradaSolicitacaoDeCorrida.Para.Longitude);
   try
      FRepositorioCorrida.Salvar(lCorrida);
      Result.IDDaCorrida := lCorrida.ID;
   finally
      lCorrida.Destroy;
   end;
end;

procedure TSolicitarCorrida.ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
var lContaDeUsuario: TContaDeUsuario;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaUsuario.ObterPorID(lUUID);
      try
         if not lContaDeUsuario.Passageiro then
            raise ESolicitacaoCorridaUsuarioNaoEhPassageiro.Create('Conta de usuário não pertence a um passageiro!');
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

procedure TSolicitarCorrida.ValidarPassageiroComAlgumaCorridaAtiva(pIDDoPassageiro: String);
var lListaDeCorridasAtivas: TListaDeCorridas;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoPassageiro);
   try
      try
         lListaDeCorridasAtivas := FRepositorioCorrida.ObterListaDeCorridasAtivasDoPassageiro(lUUID);
         try
            if lListaDeCorridasAtivas.Count > 0 then
               raise ESolicitacaoCorridaPassageiroJaPossuiCorridaAtiva.Create('Passageiro possui corridas ativas!');
         finally
            lListaDeCorridasAtivas.Destroy;
         end;
      except
         on E: Exception do
         begin
            if not (E is ERepositorioCorridaNaoEncontrada) then
               raise;
         end;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
