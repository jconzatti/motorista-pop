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
      procedure CorridaSolicitadaNaoPodeSerSolicitadaNovamente;
      [Test]
      procedure CorridaSolicitadaPodeSerAceita;
      [Test]
      procedure CorridaSolicitadaNaoPodeSerIniciada;
      [Test]
      procedure CorridaSolicitadaNaoPodeSerFinalizada;
      [Test]
      procedure CorridaSolicitadaPodeSerCancelada;
      [Test]
      procedure CorridaAceitaNaoPodeSerSolicitadaNovamente;
      [Test]
      procedure CorridaAceitaNaoPodeSerAceitaNovamente;
      [Test]
      procedure CorridaAceitaPodeSerIniciada;
      [Test]
      procedure CorridaAceitaNaoPodeSerFinalizada;
      [Test]
      procedure CorridaAceitaPodeSerCancelada;
      [Test]
      procedure CorridaIniciadaNaoPodeSerSolicitadaNovamente;
      [Test]
      procedure CorridaIniciadaNaoPodeSerAceitaNovamente;
      [Test]
      procedure CorridaIniciadaNaoPodeSerIniciadaNovamente;
      [Test]
      procedure CorridaIniciadaPodeSerFinalizada;
      [Test]
      procedure CorridaIniciadaPodeSerCancelada;
      [Test]
      procedure CorridaFinalizadaNaoPodeSerSolicitadaNovamente;
      [Test]
      procedure CorridaFinalizadaNaoPodeSerAceitaNovamente;
      [Test]
      procedure CorridaFinalizadaNaoPodeSerIniciadaNovamente;
      [Test]
      procedure CorridaFinalizadaNaoPodeSerFinalizadaNovamente;
      [Test]
      procedure CorridaFinalizadaNaoPodeSerCancelada;
      [Test]
      procedure CorridaCanceladaNaoPodeSerSolicitada;
      [Test]
      procedure CorridaCanceladaNaoPodeSerAceita;
      [Test]
      procedure CorridaCanceladaNaoPodeSerIniciada;
      [Test]
      procedure CorridaCanceladaNaoPodeSerFinalizada;
      [Test]
      procedure CorridaCanceladaNaoPodeSerCanceladaNovamnte;
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

procedure TStatusCorridaTeste.CorridaSolicitadaNaoPodeSerSolicitadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Solicitada.TransicaoPara(TStatusCorrida.Solicitada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já está solicitada. Não pode ser solicitada novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaSolicitadaPodeSerAceita;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Aceita, TStatusCorrida.Solicitada.TransicaoPara(TStatusCorrida.Aceita));
end;

procedure TStatusCorridaTeste.CorridaSolicitadaNaoPodeSerIniciada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Solicitada.TransicaoPara(TStatusCorrida.Iniciada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida está solicitada. Não pode ser iniciada! Primeiro deve ser aceita por um motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaSolicitadaNaoPodeSerFinalizada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Solicitada.TransicaoPara(TStatusCorrida.Finalizada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida está solicitada. Não pode ser finalizada! Primeiro deve ser aceita e depois iniciada por um motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaSolicitadaPodeSerCancelada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Cancelada, TStatusCorrida.Solicitada.TransicaoPara(TStatusCorrida.Cancelada));
end;

procedure TStatusCorridaTeste.CorridaAceitaNaoPodeSerSolicitadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Aceita.TransicaoPara(TStatusCorrida.Solicitada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida foi aceita por um motorista. Não pode ser solicitada novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaAceitaNaoPodeSerAceitaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Aceita.TransicaoPara(TStatusCorrida.Aceita)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida foi aceita por um motorista. Não pode ser aceita por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaAceitaPodeSerIniciada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Iniciada, TStatusCorrida.Aceita.TransicaoPara(TStatusCorrida.Iniciada));
end;

procedure TStatusCorridaTeste.CorridaAceitaNaoPodeSerFinalizada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Aceita.TransicaoPara(TStatusCorrida.Finalizada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida foi aceita por um motorista. Não pode ser finalizada! Primeiro deve ser iniciada pelo motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaAceitaPodeSerCancelada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Cancelada, TStatusCorrida.Aceita.TransicaoPara(TStatusCorrida.Cancelada));
end;

procedure TStatusCorridaTeste.CorridaIniciadaNaoPodeSerSolicitadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Iniciada.TransicaoPara(TStatusCorrida.Solicitada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já iniciada pelo motorista. Não pode ser solicitada novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaIniciadaNaoPodeSerAceitaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Iniciada.TransicaoPara(TStatusCorrida.Aceita)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já iniciada pelo motorista. Não pode ser aceita por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaIniciadaNaoPodeSerIniciadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Iniciada.TransicaoPara(TStatusCorrida.Iniciada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já iniciada pelo motorista. Não pode ser iniciada por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaIniciadaPodeSerFinalizada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Finalizada, TStatusCorrida.Iniciada.TransicaoPara(TStatusCorrida.Finalizada));
end;

procedure TStatusCorridaTeste.CorridaIniciadaPodeSerCancelada;
begin
   Assert.AreEqual<TStatusCorrida>(TStatusCorrida.Cancelada, TStatusCorrida.Iniciada.TransicaoPara(TStatusCorrida.Cancelada));
end;


procedure TStatusCorridaTeste.CorridaFinalizadaNaoPodeSerSolicitadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Finalizada.TransicaoPara(TStatusCorrida.Solicitada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já finalizada pelo motorista. Não pode ser solicitada novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaFinalizadaNaoPodeSerAceitaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Finalizada.TransicaoPara(TStatusCorrida.Aceita)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já finalizada pelo motorista. Não pode ser aceita por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaFinalizadaNaoPodeSerIniciadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Finalizada.TransicaoPara(TStatusCorrida.Iniciada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já finalizada pelo motorista. Não pode ser iniciada por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaFinalizadaNaoPodeSerFinalizadaNovamente;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Finalizada.TransicaoPara(TStatusCorrida.Finalizada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já finalizada pelo motorista. Não pode ser finalizada por um motorista novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaFinalizadaNaoPodeSerCancelada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Finalizada.TransicaoPara(TStatusCorrida.Cancelada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já finalizada pelo motorista. Não pode ser cancelada!'
   );
end;

procedure TStatusCorridaTeste.CorridaCanceladaNaoPodeSerSolicitada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Cancelada.TransicaoPara(TStatusCorrida.Solicitada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida cancelada. Não pode ser solicitada novamente!'
   );
end;

procedure TStatusCorridaTeste.CorridaCanceladaNaoPodeSerAceita;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Cancelada.TransicaoPara(TStatusCorrida.Aceita)
      end,
      ETransicaoStatusCorridaInvalido,
     'Corrida cancelada. Não pode ser aceita por um motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaCanceladaNaoPodeSerIniciada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Cancelada.TransicaoPara(TStatusCorrida.Iniciada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida cancelada. Não pode ser iniciada por um motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaCanceladaNaoPodeSerFinalizada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Cancelada.TransicaoPara(TStatusCorrida.Finalizada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida cancelada. Não pode ser finalizada por um motorista!'
   );
end;

procedure TStatusCorridaTeste.CorridaCanceladaNaoPodeSerCanceladaNovamnte;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TStatusCorrida.Cancelada.TransicaoPara(TStatusCorrida.Cancelada)
      end,
      ETransicaoStatusCorridaInvalido,
      'Corrida já cancelada. Não pode ser cancelada novamente!'
   );
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
      'Valor "invalid" para Status da corrida inválido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TStatusCorridaTeste);
end.
