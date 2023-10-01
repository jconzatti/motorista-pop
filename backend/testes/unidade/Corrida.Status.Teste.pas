unit Corrida.Status.Teste;

interface

uses
   Corrida.Status,
   DUnitX.TestFramework;

type
   [TestFixture]
   TStatusCorridaTeste = class
   public
      [Test]
      procedure TestarValorDeStatusDeCorridaSolicitada;
      [Test]
      procedure TestarValorDeStatusDeCorridaAceita;
      [Test]
      procedure TestarValorDeStatusDeCorridaIniciada;
      [Test]
      procedure TestarValorDeStatusDeCorridaFinalizada;
      [Test]
      procedure TestarValorDeStatusDeCorridaCancelada;
      [Test]
      procedure TestarStatusDeCorridaSolicitada;
      [Test]
      procedure TestarStatusDeCorridaAceita;
      [Test]
      procedure TestarStatusDeCorridaIniciada;
      [Test]
      procedure TestarStatusDeCorridaFinalizada;
      [Test]
      procedure TestarStatusDeCorridaCancelada;
      [Test]
      procedure NaoPodeAceitarUmStatusInvalido;
   end;

implementation


{ TStatusCorridaTeste }

procedure TStatusCorridaTeste.TestarValorDeStatusDeCorridaSolicitada;
begin
   Assert.AreEqual('requested', TStatusCorrida.Solicitada.Valor);
end;

procedure TStatusCorridaTeste.TestarValorDeStatusDeCorridaAceita;
begin
   Assert.AreEqual('accepted', TStatusCorrida.Aceita.Valor);
end;

procedure TStatusCorridaTeste.TestarValorDeStatusDeCorridaIniciada;
begin
   Assert.AreEqual('in_progress', TStatusCorrida.Iniciada.Valor);
end;

procedure TStatusCorridaTeste.TestarValorDeStatusDeCorridaFinalizada;
begin
   Assert.AreEqual('completed', TStatusCorrida.Finalizada.Valor);
end;

procedure TStatusCorridaTeste.TestarValorDeStatusDeCorridaCancelada;
begin
   Assert.AreEqual('canceled', TStatusCorrida.Cancelada.Valor);
end;

procedure TStatusCorridaTeste.TestarStatusDeCorridaSolicitada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Solicitada, TStatusCorrida.Status('requested'));
end;

procedure TStatusCorridaTeste.TestarStatusDeCorridaAceita;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Aceita, TStatusCorrida.Status('accepted'));
end;

procedure TStatusCorridaTeste.TestarStatusDeCorridaIniciada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Iniciada, TStatusCorrida.Status('in_progress'));
end;

procedure TStatusCorridaTeste.TestarStatusDeCorridaFinalizada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Finalizada, TStatusCorrida.Status('completed'));
end;

procedure TStatusCorridaTeste.TestarStatusDeCorridaCancelada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Cancelada, TStatusCorrida.Status('canceled'));
end;

procedure TStatusCorridaTeste.NaoPodeAceitarUmStatusInvalido;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Status('invalid')
      end,
      EStatusCorridaInvalido,
      'Valor do Status da corrida inválido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TStatusCorridaTeste);
end.
