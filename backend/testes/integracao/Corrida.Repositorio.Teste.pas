unit Corrida.Repositorio.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Corrida,
   Corrida.Status,
   Corrida.Repositorio,
   Email,
   UUID,
   DUnitX.TestFramework;

type
   TRepositorioCorridaTeste = class abstract
   protected
      FRepositorioCorrida: TRepositorioCorrida;
   public
      [Setup]
      procedure Inicializar; virtual; abstract;
      [TearDown]
      procedure Finalizar; virtual; abstract;
      [Test]
      procedure DeveSalvarEAtualizarUmaCorridaEObterPorID;
      [Test]
      procedure NaoPodeObterCorridaPorIDNaoEncotrada;
      [Test]
      procedure DeveObterCorridasAtivasDoPassageiro;
      [Test]
      procedure DeveObterCorridasAtivasDoMotorista;
   end;

implementation


{ TRepositorioCorridaTeste }

procedure TRepositorioCorridaTeste.DeveSalvarEAtualizarUmaCorridaEObterPorID;
var lCorrida: TCorrida;
    lIDDaCorrida, lIDDoPassageiro: String;
    lID: TUUID;
begin
   lIDDoPassageiro := TUUID.Gerar;
   lCorrida := TCorrida.Criar(lIDDoPassageiro, 0, 10, 90, 80);
   try
      FRepositorioCorrida.Salvar(lCorrida);
      FRepositorioCorrida.Atualizar(lCorrida);
      lIDDaCorrida := lCorrida.ID;
   finally
      lCorrida.Destroy;
   end;
   lID := TUUID.Create(lIDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lID);
      try
         Assert.AreEqual(lID.Valor, lCorrida.ID);
         Assert.AreEqual(lIDDoPassageiro, lCorrida.IDDoPassageiro);
         Assert.IsEmpty(lCorrida.IDDoMotorista);
         Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Solicitada, lCorrida.Status);
         Assert.AreEqual<Double>(0, lCorrida.Tarifa);
         Assert.AreEqual<Double>(0, lCorrida.Distancia);
         Assert.AreEqual<Double>(0, lCorrida.De.Latitude);
         Assert.AreEqual<Double>(10, lCorrida.De.Longitude);
         Assert.AreEqual<Double>(90, lCorrida.Para.Latitude);
         Assert.AreEqual<Double>(80, lCorrida.Para.Longitude);
         Assert.AreEqual<TDate>(Date, DateOf(lCorrida.Data));
      finally
         lCorrida.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

procedure TRepositorioCorridaTeste.NaoPodeObterCorridaPorIDNaoEncotrada;
var lID: TUUID;
begin
   lID := TUUID.Create(TUUID.Gerar);
   try
      Assert.WillRaiseWithMessage(
         procedure
         begin
            FRepositorioCorrida.ObterPorID(lID)
         end,
         ECorridaNaoEncontrada,
         Format('Corrida com ID %s não encontada!', [lID.Valor])
      );
   finally
      lID.Destroy;
   end;
end;

procedure TRepositorioCorridaTeste.DeveObterCorridasAtivasDoPassageiro;
var
   lCorrida: TCorrida;
   LListaDeCorridasAtivas: TListaDeCorridas;
   lID : TUUID;
   lIDDoPassageiro: String;
begin
   lIDDoPassageiro := TUUID.Gerar;
   lCorrida := TCorrida.Criar(lIDDoPassageiro, 0, 10, 90, 80);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  lIDDoPassageiro,
                                  TUUID.Gerar,
                                  TStatusCorrida.Aceita,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  lIDDoPassageiro,
                                  TUUID.Gerar,
                                  TStatusCorrida.Iniciada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  lIDDoPassageiro,
                                  TUUID.Gerar,
                                  TStatusCorrida.Finalizada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  lIDDoPassageiro,
                                  TUUID.Gerar,
                                  TStatusCorrida.Cancelada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;

   lID := TUUID.Create(lIDDoPassageiro);
   try
      LListaDeCorridasAtivas := FRepositorioCorrida.ObterListaDeCorridasAtivasDoPassageiro(lID);
      try
         Assert.AreEqual(3, LListaDeCorridasAtivas.Count);
      finally
         LListaDeCorridasAtivas.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

procedure TRepositorioCorridaTeste.DeveObterCorridasAtivasDoMotorista;
var
   lCorrida: TCorrida;
   LListaDeCorridasAtivas: TListaDeCorridas;
   lID : TUUID;
   lIDDoMotorista: String;
begin
   lIDDoMotorista := TUUID.Gerar;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  TUUID.Gerar,
                                  lIDDoMotorista,
                                  TStatusCorrida.Aceita,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  TUUID.Gerar,
                                  lIDDoMotorista,
                                  TStatusCorrida.Iniciada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  TUUID.Gerar,
                                  lIDDoMotorista,
                                  TStatusCorrida.Finalizada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;
   lCorrida := TCorrida.Restaurar(TUUID.Gerar,
                                  TUUID.Gerar,
                                  lIDDoMotorista,
                                  TStatusCorrida.Cancelada,
                                  0, 0, 0, 10, 90, 80, Now);
   try
      FRepositorioCorrida.Salvar(lCorrida);
   finally
      lCorrida.Destroy;
   end;

   lID := TUUID.Create(lIDDoMotorista);
   try
      LListaDeCorridasAtivas := FRepositorioCorrida.ObterListaDeCorridasAtivasDoMotorista(lID);
      try
         Assert.AreEqual(2, LListaDeCorridasAtivas.Count);
      finally
         LListaDeCorridasAtivas.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

end.
