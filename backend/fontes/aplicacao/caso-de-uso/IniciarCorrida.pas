unit IniciarCorrida;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Corrida,
   Corrida.Repositorio,
   Repositorio.Fabrica,
   UUID;

type
   EInicioCorridaUsuarioNaoEhMotorista = class(EArgumentException);

   TDadoEntradaInicioCorrida = record
      IDDoMotorista: String;
      IDDaCorrida: String;
   end;

   TIniciarCorrida = class
   private
      FRepositorioContaUsuario: TRepositorioContaDeUsuario;
      FRepositorioCorrida: TRepositorioCorrida;
      procedure ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      procedure Executar(pEntradaInicioDeCorrida: TDadoEntradaInicioCorrida);
   end;

implementation

{ TIniciarCorrida }

constructor TIniciarCorrida.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FRepositorioCorrida := pFabricaRepositorio.CriarRepositorioCorrida;
end;

destructor TIniciarCorrida.Destroy;
begin
   FRepositorioContaUsuario.Destroy;
   FRepositorioCorrida.Destroy;
   inherited;
end;

procedure TIniciarCorrida.Executar(
  pEntradaInicioDeCorrida: TDadoEntradaInicioCorrida);
var
   lCorrida: TCorrida;
   lIDCorrida : TUUID;
begin
   ValidarContaDeUsuarioEhMotorista(pEntradaInicioDeCorrida.IDDoMotorista);
   lIDCorrida := TUUID.Create(pEntradaInicioDeCorrida.IDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lIDCorrida);
      try
         lCorrida.Iniciar(pEntradaInicioDeCorrida.IDDoMotorista);
         FRepositorioCorrida.Atualizar(lCorrida);
      finally
         lCorrida.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

procedure TIniciarCorrida.ValidarContaDeUsuarioEhMotorista(
  pIDDoUsuario: String);
var lContaDeUsuario: TContaDeUsuario;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaUsuario.ObterPorID(lUUID);
      try
         if not lContaDeUsuario.Motorista then
            raise EInicioCorridaUsuarioNaoEhMotorista.Create('Conta de usuário não pertence a um motorista! Somente motoristas podem iniciar corridas!');
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
