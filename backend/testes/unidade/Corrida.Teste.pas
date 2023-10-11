unit Corrida.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Corrida,
   Corrida.Status,
   Posicao,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCorridaTeste = class
   public
      [Test]
      procedure DeveCriarUmaCorrida;
      [Test]
      procedure DeveRestaurarUmaCorrida;
      [Test]
      procedure DeveAceitarCorrida;
      [Test]
      procedure NaoPodeIniciarCorridaDeOutroMotorista;
      [Test]
      procedure NaoPodeFinalizarCorridaComPosicoesDeOutrasCorridas;
      [Test]
      procedure NaoPodeFinalizarCorridaDeOutroMotorista;
   end;

implementation


{ TCorridaTeste }

procedure TCorridaTeste.DeveCriarUmaCorrida;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Criar('3da32233e4d0404687de6d96d345410e', 0, 10, 90, 80);
   try
      Assert.IsNotEmpty(lCorrida.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410e', lCorrida.IDDoPassageiro);
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
end;

procedure TCorridaTeste.DeveRestaurarUmaCorrida;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Finalizada,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      Assert.AreEqual('3da32233e4d0404687de6d96d345410a', lCorrida.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410b', lCorrida.IDDoPassageiro);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410c', lCorrida.IDDoMotorista);
      Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Finalizada, lCorrida.Status);
      Assert.AreEqual<Double>(30, lCorrida.Tarifa);
      Assert.AreEqual<Double>(63, lCorrida.Distancia);
      Assert.AreEqual<Double>(0, lCorrida.De.Latitude);
      Assert.AreEqual<Double>(10, lCorrida.De.Longitude);
      Assert.AreEqual<Double>(90, lCorrida.Para.Latitude);
      Assert.AreEqual<Double>(80, lCorrida.Para.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lCorrida.Data));
   finally
      lCorrida.Destroy;
   end;
end;

procedure TCorridaTeste.DeveAceitarCorrida;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Solicitada,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      lCorrida.Aceitar('3da32233e4d0404687de6d96d345410d');
      Assert.AreEqual('3da32233e4d0404687de6d96d345410a', lCorrida.ID);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410b', lCorrida.IDDoPassageiro);
      Assert.AreEqual('3da32233e4d0404687de6d96d345410d', lCorrida.IDDoMotorista);
      Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Aceita, lCorrida.Status);
      Assert.AreEqual<Double>(30, lCorrida.Tarifa);
      Assert.AreEqual<Double>(63, lCorrida.Distancia);
      Assert.AreEqual<Double>(0, lCorrida.De.Latitude);
      Assert.AreEqual<Double>(10, lCorrida.De.Longitude);
      Assert.AreEqual<Double>(90, lCorrida.Para.Latitude);
      Assert.AreEqual<Double>(80, lCorrida.Para.Longitude);
      Assert.AreEqual<TDate>(Date, DateOf(lCorrida.Data));
   finally
      lCorrida.Destroy;
   end;
end;

procedure TCorridaTeste.NaoPodeIniciarCorridaDeOutroMotorista;
var lCorrida: TCorrida;
begin
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Aceita,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      Assert.WillRaiseWithMessage(
         procedure
         begin
            lCorrida.Iniciar('3da32233e4d0404687de6d96d345410d');
         end,
         ECorridaOutroMotorista,
         'Corrida já aceita por outro motorista!'
      );
   finally
      lCorrida.Destroy;
   end;
end;

procedure TCorridaTeste.NaoPodeFinalizarCorridaComPosicoesDeOutrasCorridas;
var lCorrida: TCorrida;
    lListaDePosicoesDaCorrida : TListaDePosicoes;
begin
   lListaDePosicoesDaCorrida := TListaDePosicoes.Create;
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Iniciada,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      lListaDePosicoesDaCorrida.Add(TPosicao.Criar('3da32233e4d0404687de6d96d345410a', 0, 10, Now));
      lListaDePosicoesDaCorrida.Add(TPosicao.Criar('3da32233e4d0404687de6d96d345410d', 90, 80, Now));
      Assert.WillRaiseWithMessage(
         procedure
         begin
            lCorrida.Finalizar('3da32233e4d0404687de6d96d345410c', lListaDePosicoesDaCorrida);
         end,
         ECorridaPosicaoOutraCorrida,
         'Posição pertence a outra corrida!'
      );
   finally
      lCorrida.Destroy;
      lListaDePosicoesDaCorrida.Destroy;
   end;
end;

procedure TCorridaTeste.NaoPodeFinalizarCorridaDeOutroMotorista;
var lCorrida: TCorrida;
    lListaDePosicoesDaCorrida : TListaDePosicoes;
begin
   lListaDePosicoesDaCorrida := TListaDePosicoes.Create;
   lCorrida := TCorrida.Restaurar('3da32233e4d0404687de6d96d345410a',
                                  '3da32233e4d0404687de6d96d345410b',
                                  '3da32233e4d0404687de6d96d345410c',
                                  TStatusCorrida.Iniciada,
                                  30, 63, 0, 10, 90, 80, Now);
   try
      lListaDePosicoesDaCorrida.Add(TPosicao.Criar('3da32233e4d0404687de6d96d345410a', 0, 10, Now));
      lListaDePosicoesDaCorrida.Add(TPosicao.Criar('3da32233e4d0404687de6d96d345410a', 90, 80, Now));
      Assert.WillRaiseWithMessage(
         procedure
         begin
            lCorrida.Finalizar('3da32233e4d0404687de6d96d345410d', lListaDePosicoesDaCorrida);
         end,
         ECorridaOutroMotorista,
         'Corrida já aceita por outro motorista!'
      );
   finally
      lCorrida.Destroy;
      lListaDePosicoesDaCorrida.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TCorridaTeste);
end.
