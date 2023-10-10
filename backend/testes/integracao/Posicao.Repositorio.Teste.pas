unit Posicao.Repositorio.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Posicao,
   Posicao.Repositorio,
   UUID,
   DUnitX.TestFramework;

type
   TRepositorioPosicaoTeste = class abstract
   protected
      FRepositorioPosicao: TRepositorioPosicao;
   public
      [Setup]
      procedure Inicializar; virtual; abstract;
      [TearDown]
      procedure Finalizar; virtual; abstract;
      [Test]
      procedure DeveSalvarPosicoesNaCorrida;
      [Test]
      procedure DeveObterPosicoesDaCorrida;
      [Test]
      procedure DeveDispararErroAoObterPosicoesDeCorridaSemPosicoes;
   end;

implementation

{ TRepositorioPosicaoTeste }

procedure TRepositorioPosicaoTeste.DeveSalvarPosicoesNaCorrida;
var lPosicao: TPosicao;
    lListaDePosicoesDaCorrida: TListaDePosicoes;
    lIDCorrida: TUUID;
begin
   lIDCorrida := TUUID.Create(TUUID.Gerar);
   try
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.877291364885657, -49.08225874081267, StrToDateTimeDef('17/09/2023 10:00:00', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.8773716281549, -49.08203741452999, StrToDateTimeDef('17/09/2023 10:00:10', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.877635537605425, -49.08208293312585, StrToDateTimeDef('17/09/2023 10:00:20', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.878860340067302, -49.08370642971138, StrToDateTimeDef('17/09/2023 10:00:30', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.878982142930248, -49.08432093077141, StrToDateTimeDef('17/09/2023 10:00:40', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.880315198704235, -49.08605063741393, StrToDateTimeDef('17/09/2023 10:00:50', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida.Valor, -26.881201638277044, -49.08570924794706, StrToDateTimeDef('17/09/2023 10:01:00', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lListaDePosicoesDaCorrida := FRepositorioPosicao.ObterListaDePosicoesDaCorrida(lIDCorrida);
      try
         Assert.AreEqual(7, lListaDePosicoesDaCorrida.Count);
         Assert.IsNotEmpty(lListaDePosicoesDaCorrida.Items[0].ID);
         Assert.AreEqual(lIDCorrida.Valor, lListaDePosicoesDaCorrida.Items[0].IDDaCorrida);
         Assert.AreEqual(-26.877291364885657, lListaDePosicoesDaCorrida.Items[0].Coordenada.Latitude);
         Assert.AreEqual(-49.08225874081267, lListaDePosicoesDaCorrida.Items[0].Coordenada.Longitude);
      finally
         lListaDePosicoesDaCorrida.Destroy;
      end;
   finally
      lIDCorrida.Destroy;
   end;
end;

procedure TRepositorioPosicaoTeste.DeveObterPosicoesDaCorrida;
var lPosicao: TPosicao;
    lListaDePosicoesDaCorrida: TListaDePosicoes;
    lIDCorrida1, lIDCorrida2: TUUID;
begin
   lIDCorrida1 := TUUID.Create(TUUID.Gerar);
   lIDCorrida2 := TUUID.Create(TUUID.Gerar);
   try
      lPosicao := TPosicao.Criar(lIDCorrida1.Valor, -26.877291364885657, -49.08225874081267, StrToDateTimeDef('17/09/2023 10:00:00', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida2.Valor, -26.8773716281549, -49.08203741452999, StrToDateTimeDef('17/09/2023 10:00:10', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida1.Valor, -26.877635537605425, -49.08208293312585, StrToDateTimeDef('17/09/2023 10:00:20', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida2.Valor, -26.878860340067302, -49.08370642971138, StrToDateTimeDef('17/09/2023 10:00:30', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida1.Valor, -26.878982142930248, -49.08432093077141, StrToDateTimeDef('17/09/2023 10:00:40', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida2.Valor, -26.880315198704235, -49.08605063741393, StrToDateTimeDef('17/09/2023 10:00:50', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lPosicao := TPosicao.Criar(lIDCorrida1.Valor, -26.881201638277044, -49.08570924794706, StrToDateTimeDef('17/09/2023 10:01:00', Now));
      try
         FRepositorioPosicao.Salvar(lPosicao);
      finally
         lPosicao.Destroy;
      end;
      lListaDePosicoesDaCorrida := FRepositorioPosicao.ObterListaDePosicoesDaCorrida(lIDCorrida1);
      try
         Assert.AreEqual(4, lListaDePosicoesDaCorrida.Count);
         Assert.IsNotEmpty(lListaDePosicoesDaCorrida.Items[3].ID);
         Assert.AreEqual(lIDCorrida1.Valor, lListaDePosicoesDaCorrida.Items[3].IDDaCorrida);
         Assert.AreEqual(-26.881201638277044, lListaDePosicoesDaCorrida.Items[3].Coordenada.Latitude);
         Assert.AreEqual(-49.08570924794706, lListaDePosicoesDaCorrida.Items[3].Coordenada.Longitude);
         Assert.AreEqual(StrToDateTimeDef('17/09/2023 10:01:00', Now), lListaDePosicoesDaCorrida.Items[3].Data);
      finally
         lListaDePosicoesDaCorrida.Destroy;
      end;
   finally
      lIDCorrida2.Destroy;
      lIDCorrida1.Destroy;
   end;
end;

procedure TRepositorioPosicaoTeste.DeveDispararErroAoObterPosicoesDeCorridaSemPosicoes;
var lIDCorrida: TUUID;
begin
   lIDCorrida := TUUID.Create(TUUID.Gerar);
   try
      Assert.WillRaiseWithMessage(
         procedure
         begin
            FRepositorioPosicao.ObterListaDePosicoesDaCorrida(lIDCorrida);
         end,
         ENehumaPosicaoEncontrada,
         Format('Nenhuma posição da corrida (ID %s) encontrada!', [lIDCorrida.Valor])
      );
   finally
      lIDCorrida.Destroy;
   end;
end;

end.
