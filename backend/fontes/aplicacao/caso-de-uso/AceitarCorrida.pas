unit AceitarCorrida;

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
   EMotoristaJaPossuiCorridaAtiva = class(EArgumentException);

   TDadoEntradaAceiteCorrida = record
      IDDoMotorista: String;
      IDDaCorrida: String;
   end;

   TAceitarCorrida = class
   private
      FRepositorioContaUsuario: TRepositorioContaDeUsuario;
      FRepositorioCorrida: TRepositorioCorrida;
      procedure ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
      procedure ValidarMotoristaComAlgumaCorridaAtiva(pIDDoMotorista: String);
   public
      constructor Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaDeUsuario: TRepositorioContaDeUsuario); reintroduce;
      procedure Executar(pEntradaAceiteDeCorrida: TDadoEntradaAceiteCorrida);
   end;

implementation

{ TAceitarCorrida }

constructor TAceitarCorrida.Create(pRepositorioCorrida: TRepositorioCorrida; pRepositorioContaDeUsuario: TRepositorioContaDeUsuario);
begin
   FRepositorioContaUsuario := pRepositorioContaDeUsuario;
   FRepositorioCorrida      := pRepositorioCorrida;
end;

procedure TAceitarCorrida.Executar(pEntradaAceiteDeCorrida: TDadoEntradaAceiteCorrida);
var
   lCorrida: TCorrida;
   lIDCorrida : TUUID;
begin
   ValidarContaDeUsuarioEhMotorista(pEntradaAceiteDeCorrida.IDDoMotorista);
   ValidarMotoristaComAlgumaCorridaAtiva(pEntradaAceiteDeCorrida.IDDoMotorista);
   lIDCorrida := TUUID.Create(pEntradaAceiteDeCorrida.IDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lIDCorrida);
      try
         lCorrida.Aceitar(pEntradaAceiteDeCorrida.IDDoMotorista);
         FRepositorioCorrida.Atualizar(lCorrida);
      finally
         lCorrida.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

procedure TAceitarCorrida.ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
var lContaDeUsuario: TContaDeUsuario;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoUsuario);
   try
      lContaDeUsuario := FRepositorioContaUsuario.ObterPorID(lUUID);
      try
         if not lContaDeUsuario.Motorista then
            raise EContaDeUsuarioNaoEhMotorista.Create('Conta de usuário não pertence a um motorista! Somente motoristas podem aceitar corridas!');
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

procedure TAceitarCorrida.ValidarMotoristaComAlgumaCorridaAtiva(pIDDoMotorista: String);
var lListaDeCorridasAtivas: TListaDeCorridas;
    lUUID : TUUID;
begin
   lUUID := TUUID.Create(pIDDoMotorista);
   try
      try
         lListaDeCorridasAtivas := FRepositorioCorrida.ObterListaDeCorridasAtivasDoMotorista(lUUID);
         try
            if lListaDeCorridasAtivas.Count > 0 then
               raise EMotoristaJaPossuiCorridaAtiva.Create('Motorista possui corridas ativas! Não pode aceitar corridas!');
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
