unit CasoDeUso.Fabrica;

interface

uses
   Repositorio.Fabrica,
   InscreverUsuario,
   ObterContaDeUsuario,
   RealizarLogin,
   SolicitarCorrida,
   AceitarCorrida,
   IniciarCorrida,
   AtualizarPosicao,
   FinalizarCorrida,
   ObterCorridas,
   ObterCorrida;

type
   TFabricaCasoDeUso = class
   private
      FFabricaRepositorio: TFabricaRepositorio;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      function InscreverUsuario: TInscreverUsuario;
      function ObterContaDeUsuario: TObterContaDeUsuario;
      function RealizarLogin: TRealizarLogin;
      function SolicitarCorrida: TSolicitarCorrida;
      function AceitarCorrida: TAceitarCorrida;
      function IniciarCorrida: TIniciarCorrida;
      function AtualizarPosicao: TAtualizarPosicao;
      function FinalizarCorrida: TFinalizarCorrida;
      function ObterCorridas: TObterCorridas;
      function ObterCorrida: TObterCorrida;
   end;

implementation

{ TFabricaCasoDeUso }

constructor TFabricaCasoDeUso.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FFabricaRepositorio := pFabricaRepositorio;
end;

function TFabricaCasoDeUso.AceitarCorrida: TAceitarCorrida;
begin
   Result := TAceitarCorrida.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.AtualizarPosicao: TAtualizarPosicao;
begin
   Result := TAtualizarPosicao.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.FinalizarCorrida: TFinalizarCorrida;
begin
   Result := TFinalizarCorrida.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.IniciarCorrida: TIniciarCorrida;
begin
   Result := TIniciarCorrida.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.InscreverUsuario: TInscreverUsuario;
begin
   Result := TInscreverUsuario.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.ObterContaDeUsuario: TObterContaDeUsuario;
begin
   Result := TObterContaDeUsuario.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.ObterCorrida: TObterCorrida;
begin
   Result := TObterCorrida.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.ObterCorridas: TObterCorridas;
begin
   Result := TObterCorridas.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.RealizarLogin: TRealizarLogin;
begin
   Result := TRealizarLogin.Create(FFabricaRepositorio);
end;

function TFabricaCasoDeUso.SolicitarCorrida: TSolicitarCorrida;
begin
   Result := TSolicitarCorrida.Create(FFabricaRepositorio);
end;

end.
