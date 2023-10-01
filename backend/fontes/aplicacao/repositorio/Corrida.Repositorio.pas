unit Corrida.Repositorio;

interface

uses
   System.SysUtils,
   Corrida,
   UUID;

type
   ECorridaNaoEncontrada = class(EArgumentException);

   TRepositorioCorrida = class abstract
   public
      procedure Salvar(pCorrida: TCorrida); virtual; abstract;
      procedure Atualizar(pCorrida: TCorrida); virtual; abstract;
      function ObterPorID(pID: TUUID): TCorrida; virtual; abstract;
      function ObterListaDeCorridasAtivasDoPassageiro(pIDDoPassageiro: TUUID): TListaDeCorridas; virtual; abstract;
      function ObterListaDeCorridasAtivasDoMotorista(pIDDoMotorista: TUUID): TListaDeCorridas; virtual; abstract;
   end;

implementation

end.
