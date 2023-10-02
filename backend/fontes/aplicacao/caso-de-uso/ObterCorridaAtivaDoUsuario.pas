unit ObterCorridaAtivaDoUsuario;

interface

uses
   System.SysUtils,
   Corrida,
   Corrida.Status,
   Corrida.Repositorio,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   UUID;

type
   EUsuarioNaoPossuiCorridaAtiva = class(EArgumentException);
   TCoodernadaObtencaoCorridaAtiva = record
      Latitude: Double;
      Longitude: Double;
   end;

   TDadoSaidaObtencaoCorridaAtiva = record
      Passageiro: String;
      Motorista: String;
      Status: String;
      Destino: TCoodernadaObtencaoCorridaAtiva;
   end;

   TObterCorridaAtivaDoUsuario = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      function ObterNomeDoUsuario(pIDDoUsuario: String):String;
      function ObterListaDeCorridasAtivasDoUsuario(pIDDoUsuario: String): TListaDeCorridas;
   public
      constructor Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaDeUsuario: TRepositorioContaDeUsuario); reintroduce;
      function Executar(pIDDoUsuario: String): TDadoSaidaObtencaoCorridaAtiva;
   end;

implementation

{ TObterCorridaAtivaDoUsuario }

constructor TObterCorridaAtivaDoUsuario.Create(pRepositorioCorrida: TRepositorioCorrida;
  pRepositorioContaDeUsuario: TRepositorioContaDeUsuario);
begin
   FRepositorioCorrida := pRepositorioCorrida;
   FRepositorioContaDeUsuario := pRepositorioContaDeUsuario;
end;

function TObterCorridaAtivaDoUsuario.Executar(pIDDoUsuario: String): TDadoSaidaObtencaoCorridaAtiva;
var
   lListaDeCorridasAtivas: TListaDeCorridas;
begin
   lListaDeCorridasAtivas := ObterListaDeCorridasAtivasDoUsuario(pIDDoUsuario);
   try
      if lListaDeCorridasAtivas.Count = 0 then
         raise EUsuarioNaoPossuiCorridaAtiva.Create('O usuário não possui corrida ativa!');
      Result.Status            := lListaDeCorridasAtivas.Items[0].Status.Valor;
      Result.Destino.Latitude  := lListaDeCorridasAtivas.Items[0].Para.Latitude;
      Result.Destino.Longitude := lListaDeCorridasAtivas.Items[0].Para.Longitude;
      Result.Passageiro        := ObterNomeDoUsuario(lListaDeCorridasAtivas.Items[0].IDDoPassageiro);
      if not lListaDeCorridasAtivas.Items[0].IDDoMotorista.IsEmpty then
         Result.Motorista := ObterNomeDoUsuario(lListaDeCorridasAtivas.Items[0].IDDoMotorista);
   finally
      lListaDeCorridasAtivas.Destroy;
   end;
end;

function TObterCorridaAtivaDoUsuario.ObterListaDeCorridasAtivasDoUsuario(pIDDoUsuario: String): TListaDeCorridas;
var
   lUsuario: TContaDeUsuario;
   lID: TUUID;
begin
   lID := TUUID.Create(pIDDoUsuario);
   try
      lUsuario := FRepositorioContaDeUsuario.ObterPorID(lID);
      try
         if lUsuario.Passageiro then
            Result := FRepositorioCorrida.ObterListaDeCorridasAtivasDoPassageiro(lID)
         else if lUsuario.Motorista then
            Result := FRepositorioCorrida.ObterListaDeCorridasAtivasDoMotorista(lID)
         else
            Result := TListaDeCorridas.Create;
      finally
         lUsuario.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

function TObterCorridaAtivaDoUsuario.ObterNomeDoUsuario(
  pIDDoUsuario: String): String;
var lID: TUUID;
    lUsuario: TContaDeUsuario;
begin
   lID := TUUID.Create(pIDDoUsuario);
   try
      lUsuario := FRepositorioContaDeUsuario.ObterPorID(lID);
      try
         Result := lUsuario.Nome;
      finally
         lUsuario.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

end.
