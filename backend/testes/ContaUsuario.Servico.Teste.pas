unit ContaUsuario.Servico.Teste;

interface

uses
   System.Math,
   System.SysUtils,
   ContaUsuario.DAO,
   ContaUsuario.DAO.Fake,
   ContaUsuario.Servico,
   DUnitX.TestFramework;

type
   [TestFixture]
   TServicoContaUsuarioTeste = class
   private
      FDAOContaUsuario : TDAOContaUsuarioFake;
   public
      [Setup]
      procedure Inicializar;
      [TearDown]
      procedure Finalizar;
      [Test]
      procedure DeveCriarUmPassageiro;
      [Test]
      procedure NaoDeveCriarUmPassageiroComCPFInvalido;
      [Test]
      procedure NaoDeveCriarUmPassageiroComNomeInvalido;
      [Test]
      procedure NaoDeveCriarUmPassageiroComEmailInvalido;
      [Test]
      procedure NaoDeveCriarUmPassageiroComEmailJaExistente;
      [Test]
      procedure DeveCriarUmMotorista;
      [Test]
      procedure NaoDeveCriarUmMotoristaComPlacaDoCarroInvalida;
   end;

implementation


{ TServicoContaUsuarioTeste }

procedure TServicoContaUsuarioTeste.Inicializar;
begin
   FDAOContaUsuario := TDAOContaUsuarioFake.Create;
end;

procedure TServicoContaUsuarioTeste.Finalizar;
begin
   FDAOContaUsuario.Destroy;
end;

procedure TServicoContaUsuarioTeste.DeveCriarUmPassageiro;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lSaidaDaContaDeUsuario: TDadoContaUsuario;
    IDDaContaDeUsuario: string;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.Passageiro := True;
   lEntradaDaContaDeUsuario.Motorista  := False;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      IDDaContaDeUsuario := lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
      lSaidaDaContaDeUsuario := lServicoContaUsuario.Obter(IDDaContaDeUsuario);
      Assert.IsNotEmpty(lSaidaDaContaDeUsuario.ID);
      Assert.AreEqual(lSaidaDaContaDeUsuario.Nome, lEntradaDaContaDeUsuario.Nome);
      Assert.AreEqual(lSaidaDaContaDeUsuario.Email, lEntradaDaContaDeUsuario.Email);
      Assert.AreEqual(lSaidaDaContaDeUsuario.CPF, lEntradaDaContaDeUsuario.CPF);
      Assert.IsTrue(lSaidaDaContaDeUsuario.Passageiro);
   finally
      lServicoContaUsuario.Destroy;
   end;
end;

procedure TServicoContaUsuarioTeste.NaoDeveCriarUmPassageiroComCPFInvalido;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         lEntradaDaContaDeUsuario.Nome  := 'John Doe';
         lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
         lEntradaDaContaDeUsuario.CPF   := '958.187.055-00';
         lEntradaDaContaDeUsuario.Passageiro := True;
         lEntradaDaContaDeUsuario.Motorista  := False;
         lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
         try
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
         finally
            lServicoContaUsuario.Destroy;
         end;
      end,
      EArgumentException,
      'CPF inválido!'
   );
end;

procedure TServicoContaUsuarioTeste.NaoDeveCriarUmPassageiroComNomeInvalido;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         lEntradaDaContaDeUsuario.Nome  := 'John';
         lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
         lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
         lEntradaDaContaDeUsuario.Passageiro := True;
         lEntradaDaContaDeUsuario.Motorista  := False;
         lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
         try
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
         finally
            lServicoContaUsuario.Destroy;
         end;
      end,
      EArgumentException,
      'Nome inválido!'
   );
end;

procedure TServicoContaUsuarioTeste.NaoDeveCriarUmPassageiroComEmailInvalido;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         lEntradaDaContaDeUsuario.Nome  := 'John Doe';
         lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@', [Random(100000000)]);
         lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
         lEntradaDaContaDeUsuario.Passageiro := True;
         lEntradaDaContaDeUsuario.Motorista  := False;
         lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
         try
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
         finally
            lServicoContaUsuario.Destroy;
         end;
      end,
      EArgumentException,
      'e-mail inválido!'
   );
end;

procedure TServicoContaUsuarioTeste.NaoDeveCriarUmPassageiroComEmailJaExistente;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         lEntradaDaContaDeUsuario.Nome  := 'John Doe';
         lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
         lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
         lEntradaDaContaDeUsuario.Passageiro := True;
         lEntradaDaContaDeUsuario.Motorista  := False;
         lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
         try
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
         finally
            lServicoContaUsuario.Destroy;
         end;
      end,
      Exception,
      'Conta de usuário já existe!'
   );
end;

procedure TServicoContaUsuarioTeste.DeveCriarUmMotorista;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
    lSaidaDaContaDeUsuario: TDadoContaUsuario;
    IDDaContaDeUsuario: string;
begin
   lEntradaDaContaDeUsuario.Nome  := 'John Doe';
   lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
   lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
   lEntradaDaContaDeUsuario.PlacaDoCarro := 'AAA9999';
   lEntradaDaContaDeUsuario.Passageiro := False;
   lEntradaDaContaDeUsuario.Motorista  := True;
   lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   try
      IDDaContaDeUsuario := lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
      lSaidaDaContaDeUsuario := lServicoContaUsuario.Obter(IDDaContaDeUsuario);
      Assert.IsNotEmpty(lSaidaDaContaDeUsuario.ID);
      Assert.AreEqual(lSaidaDaContaDeUsuario.Nome, lEntradaDaContaDeUsuario.Nome);
      Assert.AreEqual(lSaidaDaContaDeUsuario.Email, lEntradaDaContaDeUsuario.Email);
      Assert.AreEqual(lSaidaDaContaDeUsuario.CPF, lEntradaDaContaDeUsuario.CPF);
      Assert.IsTrue(lSaidaDaContaDeUsuario.Motorista);
   finally
      lServicoContaUsuario.Destroy;
   end;
end;

procedure TServicoContaUsuarioTeste.NaoDeveCriarUmMotoristaComPlacaDoCarroInvalida;
var lEntradaDaContaDeUsuario: TDadoInscricaoContaUsuario;
    lServicoContaUsuario: TServicoContaUsuario;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         lEntradaDaContaDeUsuario.Nome  := 'John Doe';
         lEntradaDaContaDeUsuario.Email := Format('john.doe.%d@gmail.com', [Random(100000000)]);
         lEntradaDaContaDeUsuario.CPF   := '958.187.055-52';
         lEntradaDaContaDeUsuario.PlacaDoCarro := 'AAA999';
         lEntradaDaContaDeUsuario.Passageiro := False;
         lEntradaDaContaDeUsuario.Motorista  := True;
         lServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
         try
            lServicoContaUsuario.Inscrever(lEntradaDaContaDeUsuario);
         finally
            lServicoContaUsuario.Destroy;
         end;
      end,
      EArgumentException,
      'Placa do carro inválida!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TServicoContaUsuarioTeste);
end.
