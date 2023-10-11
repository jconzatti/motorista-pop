unit AtualizarPosicao;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   Posicao.Repositorio,
   Corrida,
   Corrida.Status,
   Corrida.Repositorio,
   Repositorio.Fabrica,
   Posicao,
   UUID;

type
   EAtualizacaoPosicaoCorridaNaoIniciada = class(EArgumentException);

   TDadoEntradaAtualizacaoPosicao = record
      IDDaCorrida: String;
      Latitude: Double;
      Longitude: Double;
      Data: TDateTime;
   end;

   TAtualizarPosicao = class
   private
      FRepositorioPosicao: TRepositorioPosicao;
      FRepositorioCorrida: TRepositorioCorrida;
      procedure ValidarCorridaIniciada(pIDDaCorrida: String);
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      procedure Executar(pEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao);
   end;

implementation

{ TAtualizarPosicao }

constructor TAtualizarPosicao.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioCorrida := pFabricaRepositorio.CriarRepositorioCorrida;
   FRepositorioPosicao := pFabricaRepositorio.CriarRepositorioPosicao;
end;

destructor TAtualizarPosicao.Destroy;
begin
   FRepositorioPosicao.Destroy;
   FRepositorioCorrida.Destroy;
   inherited;
end;

procedure TAtualizarPosicao.Executar(pEntradaAtualizacaoPosicao: TDadoEntradaAtualizacaoPosicao);
var
   lPosicao: TPosicao;
begin
   ValidarCorridaIniciada(pEntradaAtualizacaoPosicao.IDDaCorrida);
   lPosicao := TPosicao.Criar(pEntradaAtualizacaoPosicao.IDDaCorrida,
                              pEntradaAtualizacaoPosicao.Latitude,
                              pEntradaAtualizacaoPosicao.Longitude,
                              pEntradaAtualizacaoPosicao.Data);
   try
      FRepositorioPosicao.Salvar(lPosicao);
   finally
      lPosicao.Destroy;
   end;
end;

procedure TAtualizarPosicao.ValidarCorridaIniciada(pIDDaCorrida: String);
var
   lIDCorrida: TUUID;
   lCorrida: TCorrida;
begin
   lIDCorrida := TUUID.Create(pIDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lIDCorrida);
      try
         if lCorrida.Status <> TStatusCorrida.Iniciada then
            raise EAtualizacaoPosicaoCorridaNaoIniciada.Create('Posição da corrida não pode ser atualizada, pois a corrida não foi iniciada pelo motorista!');
      finally
         lCorrida.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

end.
