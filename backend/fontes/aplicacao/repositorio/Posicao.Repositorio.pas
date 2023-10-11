unit Posicao.Repositorio;

interface

uses
   System.Classes,
   Posicao,
   UUID;

type
   ERepositorioPosicaoNaoEncontrada = class(EResNotFound);

   TRepositorioPosicao = class abstract
   public
      procedure Salvar(pPosicao: TPosicao); virtual; abstract;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: TUUID): TListaDePosicoes; virtual; abstract;
   end;

implementation

end.
