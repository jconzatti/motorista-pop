unit CPF.Teste;

interface

uses
   System.SysUtils,
   CPF,
   DUnitX.TestFramework;

type
   [TestFixture]
   TCPFTeste = class
   public
      [Test]
      [TestCase('Deve criar um CPF válido','95818705552')]
      [TestCase('Deve criar um CPF válido com último digito igual a zero','01234567890')]
      [TestCase('Deve criar um CPF válido com máscara','565.486.780-60')]
      [TestCase('Deve criar um CPF válido com máscara e com dois dígitos iguais a zero','147.864.110-00')]
      procedure DeveCriarCPFValido(const pCPFValido: String);
      [Test]
      [TestCase('Não pode criar um CPF inválido','95818705500')]
      [TestCase('Não pode criar um CPF inválido','95818705550')]
      [TestCase('Não pode criar um CPF inválido com último digito igual a zero','00000000000')]
      [TestCase('Não pode criar um CPF válido com máscara inválida','565486780-60')]
      [TestCase('Não pode criar um CPF válido misturado com letras','565fsfs48wss678060ss')]
      [TestCase('Não pode criar um CPF inválido com comprimento menor que 11','14786411')]
      procedure NaoPodeCriarCPFInvalido(const pCPFInvalido: String);
   end;

implementation

{ TCPFTeste }

procedure TCPFTeste.DeveCriarCPFValido(const pCPFValido: String);
var lCPF : TCPF;
begin
   lCPF := TCPF.Create(pCPFValido);
   try
      Assert.AreEqual<String>(pCPFValido.Replace('.', '', [rfReplaceAll]).Replace('-',''), lCPF.Valor);
   finally
      lCPF.Destroy;
   end;
end;

procedure TCPFTeste.NaoPodeCriarCPFInvalido(const pCPFInvalido: String);
begin
   Assert.WillRaise(
      procedure
      begin
         TCPF.Create(pCPFInvalido);
      end,
      ECPFInvalido
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TCPFTeste);
end.
