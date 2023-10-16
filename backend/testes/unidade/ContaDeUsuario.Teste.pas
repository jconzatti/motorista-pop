unit ContaDeUsuario.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   ContaDeUsuario,
   PlacaDeCarro,
   Hash.Gerador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TContaDeUsuarioTeste = class
   public
      [Test]
      procedure DeveCriarUmaContaDeUsuarioComoPassageiro;
      [Test]
      procedure NaoPodeCriarUmaContaDeUsuarioComoPassageiroComPlacaDeCarroInformada;
      [Test]
      procedure DeveCriarUmaContaDeUsuarioComoMotorista;
      [Test]
      procedure NaoPodeCriarUmaContaDeUsuarioComoMotoristaSemPlacaDeCarroInformada;
      [Test]
      procedure DeveRestaurarUmaContaDeUsuario;
   end;

implementation

procedure TContaDeUsuarioTeste.DeveCriarUmaContaDeUsuarioComoPassageiro;
var lContaDeUsuario : TContaDeUsuario;
begin
   lContaDeUsuario := TContaDeUsuario.CriarPassageiro('João Da Silva',
                                                      'joao.silva@mail.com',
                                                      '761.765.681-53',
                                                      'S3nh@F0rte');
   try
      Assert.IsNotEmpty(lContaDeUsuario.ID);
      Assert.AreEqual('João Da Silva', lContaDeUsuario.Nome);
      Assert.AreEqual('joao.silva@mail.com', lContaDeUsuario.Email);
      Assert.AreEqual('76176568153', lContaDeUsuario.CPF);
      Assert.IsTrue(lContaDeUsuario.Passageiro);
      Assert.IsFalse(lContaDeUsuario.Motorista);
      Assert.IsEmpty(lContaDeUsuario.PlacaDoCarro);
      Assert.IsFalse(lContaDeUsuario.Verificada);
      Assert.IsNotEmpty(lContaDeUsuario.CodigoDeVerificacao);
      Assert.AreEqual(Date, DateOf(lContaDeUsuario.Data));
   finally
      lContaDeUsuario.Destroy;
   end;
end;

procedure TContaDeUsuarioTeste.NaoPodeCriarUmaContaDeUsuarioComoPassageiroComPlacaDeCarroInformada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TContaDeUsuario.Criar('João Da Silva',
                               'joao.silva@mail.com',
                               '761.765.681-53',
                               True,
                               False,
                               'ABC1D23',
                               'S3nh@F0rte');
      end,
      EContaDeUsuarioPlacaDoCarroInformada,
      'Informada placa do carro, mas a conta de usuário não pertence a um motorista!'
   );
end;

procedure TContaDeUsuarioTeste.DeveCriarUmaContaDeUsuarioComoMotorista;
var lContaDeUsuario : TContaDeUsuario;
begin
   lContaDeUsuario := TContaDeUsuario.CriarMotorista('João Da Silva',
                                                     'joao.silva@mail.com',
                                                     '761.765.681-53',
                                                     'ABC1D23',
                                                     'S3nh@F0rte');
   try
      Assert.IsNotEmpty(lContaDeUsuario.ID);
      Assert.AreEqual('João Da Silva', lContaDeUsuario.Nome);
      Assert.AreEqual('joao.silva@mail.com', lContaDeUsuario.Email);
      Assert.AreEqual('76176568153', lContaDeUsuario.CPF);
      Assert.AreEqual('ABC1D23', lContaDeUsuario.PlacaDoCarro);
      Assert.IsFalse(lContaDeUsuario.Passageiro);
      Assert.IsTrue(lContaDeUsuario.Motorista);
      Assert.IsFalse(lContaDeUsuario.Verificada);
      Assert.IsNotEmpty(lContaDeUsuario.CodigoDeVerificacao);
      Assert.AreEqual(Date, DateOf(lContaDeUsuario.Data));
   finally
      lContaDeUsuario.Destroy;
   end;
end;

procedure TContaDeUsuarioTeste.NaoPodeCriarUmaContaDeUsuarioComoMotoristaSemPlacaDeCarroInformada;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TContaDeUsuario.Criar('João Da Silva',
                               'joao.silva@mail.com',
                               '761.765.681-53',
                               True,
                               True,
                               '',
                               'S3nh@F0rte');
      end,
      EPlacaDeCarroInvalida,
      'Placa de carro inválida!'
   );
end;

procedure TContaDeUsuarioTeste.DeveRestaurarUmaContaDeUsuario;
var lContaDeUsuario : TContaDeUsuario;
begin
   lContaDeUsuario := TContaDeUsuario.Restaurar('03dedb8c74204de58651c49952972a65',
                                                'João Da Silva',
                                                'joao.silva@mail.com',
                                                '761.765.681-53',
                                                False,
                                                True,
                                                'ABC1D23',
                                                StrToDateDef('15/09/2023 10:00:00', Date),
                                                True,
                                                '14dedb8c74204de58651c49952972a76',
                                                'S3nh@F0rte',
                                                TAlgoritimoHash.Nenhum);
   try
      Assert.AreEqual('03dedb8c74204de58651c49952972a65',lContaDeUsuario.ID);
      Assert.AreEqual('João Da Silva', lContaDeUsuario.Nome);
      Assert.AreEqual('joao.silva@mail.com', lContaDeUsuario.Email);
      Assert.AreEqual('76176568153', lContaDeUsuario.CPF);
      Assert.IsFalse(lContaDeUsuario.Passageiro);
      Assert.IsTrue(lContaDeUsuario.Motorista);
      Assert.AreEqual('ABC1D23', lContaDeUsuario.PlacaDoCarro);
      Assert.AreEqual(StrToDateDef('15/09/2023 10:00:00', Date), lContaDeUsuario.Data);
      Assert.IsTrue(lContaDeUsuario.Verificada);
      Assert.AreEqual('14dedb8c74204de58651c49952972a76',lContaDeUsuario.CodigoDeVerificacao);
   finally
      lContaDeUsuario.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TContaDeUsuarioTeste);
end.
