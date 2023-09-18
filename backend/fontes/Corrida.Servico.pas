unit Corrida.Servico;

interface

uses
   System.SysUtils,
   System.Math,
   ContaUsuario.DAO,
   Corrida.DAO,
   Posicao.DAO,
   Distancia.Calculador;

type
   TServicoCorrida = class
   private
      FDAOContaUsuario: TDAOContaUsuario;
      FDAOCorrida: TDAOCorrida;
      FDAOPosicao: TDAOPosicao;
      const TARIFA_POR_KM: Double = 2.1;
      procedure ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
      procedure ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
      procedure ValidarPassageiroComAlgumaCorridaAtiva(pIDDoPassageiro: String);
      procedure ValidarMotoristaComAlgumaCorridaAtiva(pIDDoMotorista: String);
      procedure ValidarCorridaEstaSolicitada(pIDDaCorrida: String);
      procedure ValidarCorridaEstaAceita(pIDDaCorrida: String);
      procedure ValidarCorridaEstaIniciada(pIDDaCorrida: String);
      function CalcularDistanciaPercorrida(pIDDaCorrida: String): Double;
   public
      constructor Create(pDAOContaUsuario: TDAOContaUsuario; pDAOCorrida: TDAOCorrida; pDAOPosicao: TDAOPosicao); reintroduce;
      function Solicitar(pEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida): String;
      procedure Aceitar(pIDDaCorrida, pIDDoMotorista: String);
      procedure Iniciar(pIDDaCorrida: String);
      procedure AtualizarPosicao(pIDDaCorrida: String; pLatitude, pLongitude: Double; pData: TDateTime);
      procedure Finalizar(pIDDaCorrida: String);
      function Obter(pID: String): TDadoCorrida;
   end;

implementation

{ TServicoCorrida }

constructor TServicoCorrida.Create(pDAOContaUsuario: TDAOContaUsuario; pDAOCorrida: TDAOCorrida; pDAOPosicao: TDAOPosicao);
begin
   FDAOContaUsuario := pDAOContaUsuario;
   FDAOCorrida := pDAOCorrida;
   FDAOPosicao := pDAOPosicao;
end;

function TServicoCorrida.Solicitar(pEntradaDaSolicitacaoDeCorrida: TDadoSolicitacaoCorrida): String;
var
   lGUID: TGUID;
   lCorrida: TDadoCorrida;
begin
   ValidarContaDeUsuarioEhPassageiro(pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro);
   ValidarPassageiroComAlgumaCorridaAtiva(pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro);
   CreateGUID(lGUID);
   lCorrida.ID             := lGUID.ToString;
   lCorrida.IDDoPassageiro := pEntradaDaSolicitacaoDeCorrida.IDDoPassageiro;
   lCorrida.Status         := 'requested';
   lCorrida.DeLatitude     := pEntradaDaSolicitacaoDeCorrida.DeLatitude;
   lCorrida.DeLongitude    := pEntradaDaSolicitacaoDeCorrida.DeLongitude;
   lCorrida.ParaLatitude   := pEntradaDaSolicitacaoDeCorrida.ParaLatitude;
   lCorrida.ParaLongitude  := pEntradaDaSolicitacaoDeCorrida.ParaLongitude;
   lCorrida.Data           := Now;
   FDAOCorrida.Salvar(lCorrida);
   Result := lCorrida.ID;
end;

procedure TServicoCorrida.Aceitar(pIDDaCorrida, pIDDoMotorista: String);
var
   lCorrida: TDadoCorrida;
begin
   ValidarContaDeUsuarioEhMotorista(pIDDoMotorista);
   ValidarCorridaEstaSolicitada(pIDDaCorrida);
   ValidarMotoristaComAlgumaCorridaAtiva(pIDDoMotorista);
   lCorrida.ID            := pIDDaCorrida;
   lCorrida.IDDoMotorista := pIDDoMotorista;
   lCorrida.Status        := 'accepted';
   FDAOCorrida.Atualizar(lCorrida);
end;

procedure TServicoCorrida.Iniciar(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   ValidarCorridaEstaAceita(pIDDaCorrida);
   lCorrida := FDAOCorrida.ObterPorID(pIDDaCorrida);
   lCorrida.ID     := pIDDaCorrida;
   lCorrida.Status := 'in_progress';
   FDAOCorrida.Atualizar(lCorrida);
end;

procedure TServicoCorrida.AtualizarPosicao(pIDDaCorrida: String; pLatitude,
  pLongitude: Double; pData: TDateTime);
var
   lGUID: TGUID;
   lPosicao: TDadoPosicao;
begin
   ValidarCorridaEstaIniciada(pIDDaCorrida);
   CreateGUID(lGUID);
   lPosicao.ID          := lGUID.ToString;
   lPosicao.IDDaCorrida := pIDDaCorrida;
   lPosicao.Latitude    := pLatitude;
   lPosicao.Longitude   := pLongitude;
   lPosicao.Data        := pData;
   FDAOPosicao.Salvar(lPosicao);
end;

procedure TServicoCorrida.Finalizar(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   ValidarCorridaEstaIniciada(pIDDaCorrida);
   lCorrida := FDAOCorrida.ObterPorID(pIDDaCorrida);
   lCorrida.ID        := pIDDaCorrida;
   lCorrida.Status    := 'completed';
   lCorrida.Distancia := CalcularDistanciaPercorrida(pIDDaCorrida);
   lCorrida.Tarifa    := RoundTo(lCorrida.Distancia * TARIFA_POR_KM, -2);
   FDAOCorrida.Atualizar(lCorrida);
end;

function TServicoCorrida.Obter(pID: String): TDadoCorrida;
begin
   Result := FDAOCorrida.ObterPorID(pID);
end;

procedure TServicoCorrida.ValidarContaDeUsuarioEhPassageiro(pIDDoUsuario: String);
var
   lContaDeUsuario: TDadoContaUsuario;
begin
   lContaDeUsuario := FDAOContaUsuario.ObterPorID(pIDDoUsuario);
   if not lContaDeUsuario.Passageiro then
      raise EArgumentException.Create('Conta de usuário não pertence a um passageiro!');
end;

procedure TServicoCorrida.ValidarContaDeUsuarioEhMotorista(pIDDoUsuario: String);
var
   lContaDeUsuario: TDadoContaUsuario;
begin
   lContaDeUsuario := FDAOContaUsuario.ObterPorID(pIDDoUsuario);
   if not lContaDeUsuario.Motorista then
      raise EArgumentException.Create('Conta de usuário não pertence a um motorista!');
end;

procedure TServicoCorrida.ValidarPassageiroComAlgumaCorridaAtiva(pIDDoPassageiro: String);
var lListaDeCorridasAtivas: TListaDeCorridas;
begin
   lListaDeCorridasAtivas := FDAOCorrida.ObterListaDeCorridasAtivasPeloIDDoPassageiro(pIDDoPassageiro);
   try
      if lListaDeCorridasAtivas.Count > 0 then
         raise EArgumentException.Create('Passageiro possui corridas ativas!');
   finally
      lListaDeCorridasAtivas.Destroy;
   end;
end;

procedure TServicoCorrida.ValidarMotoristaComAlgumaCorridaAtiva(
  pIDDoMotorista: String);
var lListaDeCorridasAtivas: TListaDeCorridas;
begin
   lListaDeCorridasAtivas := FDAOCorrida.ObterListaDeCorridasAtivasPeloIDDoMotorista(pIDDoMotorista);
   try
      if lListaDeCorridasAtivas.Count > 0 then
         raise EArgumentException.Create('Motorista possui corridas ativas!');
   finally
      lListaDeCorridasAtivas.Destroy;
   end;
end;

procedure TServicoCorrida.ValidarCorridaEstaSolicitada(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   lCorrida := Obter(pIDDaCorrida);
   if not lCorrida.Status.Equals('requested') then
      raise EArgumentException.Create('Corrida não solicitada!');
end;

procedure TServicoCorrida.ValidarCorridaEstaAceita(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   lCorrida := Obter(pIDDaCorrida);
   if not lCorrida.Status.Equals('accepted') then
      raise EArgumentException.Create('Corrida não aceita!');
end;

procedure TServicoCorrida.ValidarCorridaEstaIniciada(pIDDaCorrida: String);
var
   lCorrida: TDadoCorrida;
begin
   lCorrida := Obter(pIDDaCorrida);
   if not lCorrida.Status.Equals('in_progress') then
      raise EArgumentException.Create('Corrida não iniciada!');
end;

function TServicoCorrida.CalcularDistanciaPercorrida(
  pIDDaCorrida: String): Double;
var LListaDePosicoesDaCorrida: TListaDePosicoes;
  lPosicao, lPosicaoAnterior: TDadoPosicao;
  lCalculadorDistancia: TCalculadorDistancia;
begin
   Result := 0;
   LListaDePosicoesDaCorrida := FDAOPosicao.ObterListaDePosicoesDaCorrida(pIDDaCorrida);
   lCalculadorDistancia := TCalculadorDistancia.Create;
   try
      for lPosicao in LListaDePosicoesDaCorrida do
      begin
         if not lPosicaoAnterior.ID.IsEmpty then
            Result := Result +
                      lCalculadorDistancia.Calcular(lPosicaoAnterior.Latitude,
                                                    lPosicaoAnterior.Longitude,
                                                    lPosicao.Latitude,
                                                    lPosicao.Longitude);
         lPosicaoAnterior := lPosicao;
      end;
   finally
      lCalculadorDistancia.Destroy;
      LListaDePosicoesDaCorrida.Destroy;
   end;
end;

end.
