unit SolicitarCorrida;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Corrida,
   Corrida.Repositorio,
   UUID;

type
   EContaDeUsuarioNaoEhPassageiro = class(EArgumentException);
   EPassageiroJaPossuiCorridaAtiva = class(EArgumentException);

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
      constructor Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaDeUsuario: TRepositorioContaDeUsuario); reintroduce;
      function Executar(pEntradaSolicitacaoDeCorrida: TDadoEntradaSolicitacaoCorrida): TDadoSaidaSolicitacaoCorrida;
   end;

implementation

{ TSolicitarCorrida }

constructor TSolicitarCorrida.Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaDeUsuario: TRepositorioContaDeUsuario);
begin
   FRepositorioContaUsuario := pRepositorioContaDeUsuario;
   FRepositorioCorrida      := pRepositorioCorrida;
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
            raise EContaDeUsuarioNaoEhPassageiro.Create('Conta de usuário não pertence a um passageiro!');
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
               raise EPassageiroJaPossuiCorridaAtiva.Create('Passageiro possui corridas ativas!');
         finally
            lListaDeCorridasAtivas.Destroy;
         end;
      except
         on E: Exception do
         begin
            if not (E is ENehumaCorridaEncontrada) then
               raise;
         end;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
