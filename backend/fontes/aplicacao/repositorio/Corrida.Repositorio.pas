unit Corrida.Repositorio;

interface

uses
   System.SysUtils,
   Corrida,
   Corrida.Status,
   UUID;

type
   ECorridaNaoEncontrada = class(EArgumentException);

   TRepositorioCorrida = class abstract
   public
      procedure Salvar(pCorrida: TCorrida); virtual; abstract;
      procedure Atualizar(pCorrida: TCorrida); virtual; abstract;
      function ObterPorID(pID: TUUID): TCorrida; virtual; abstract;
      function ObterListaDeCorridasAtivasDoPassageiro(pIDDoPassageiro: TUUID): TListaDeCorridas;
      function ObterListaDeCorridasAtivasDoMotorista(pIDDoMotorista: TUUID): TListaDeCorridas;
      function ObterListaDeCorridasDoUsuario(pIDDoUsuario: TUUID; pConjuntoDeStatus: TConjuntoDeStatusCorrida): TListaDeCorridas; virtual; abstract;
   end;

implementation

{ TRepositorioCorrida }

function TRepositorioCorrida.ObterListaDeCorridasAtivasDoPassageiro(pIDDoPassageiro: TUUID): TListaDeCorridas;
begin
   Result := ObterListaDeCorridasDoUsuario(pIDDoPassageiro, [TStatusCorrida.Solicitada, TStatusCorrida.Aceita, TStatusCorrida.Iniciada]);
end;

function TRepositorioCorrida.ObterListaDeCorridasAtivasDoMotorista(pIDDoMotorista: TUUID): TListaDeCorridas;
begin
   Result := ObterListaDeCorridasDoUsuario(pIDDoMotorista, [TStatusCorrida.Aceita, TStatusCorrida.Iniciada]);
end;

end.
