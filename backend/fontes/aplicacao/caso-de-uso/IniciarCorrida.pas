unit IniciarCorrida;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Corrida,
   Corrida.Repositorio,
   UUID;

type
   EContaDeUsuarioNaoEhMotorista = class(EArgumentException);

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
      constructor Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaUsuario: TRepositorioContaDeUsuario); reintroduce;
      procedure Executar(pEntradaInicioDeCorrida: TDadoEntradaInicioCorrida);
   end;

implementation

{ TIniciarCorrida }

constructor TIniciarCorrida.Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaUsuario: TRepositorioContaDeUsuario);
begin
   FRepositorioCorrida := pRepositorioCorrida;
   FRepositorioContaUsuario := pRepositorioContaUsuario;
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
            raise EContaDeUsuarioNaoEhMotorista.Create('Conta de usuário não pertence a um motorista! Somente motoristas podem iniciar corridas!');
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
