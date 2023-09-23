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
      [TestCase('Deve criar um CPF v�lido','95818705552')]
      [TestCase('Deve criar um CPF v�lido com �ltimo digito igual a zero','01234567890')]
      [TestCase('Deve criar um CPF v�lido com m�scara','565.486.780-60')]
      [TestCase('Deve criar um CPF v�lido com m�scara e com dois d�gitos iguais a zero','147.864.110-00')]
      procedure DeveCriarCPFValido(const pCPFValido: String);
      [Test]
      [TestCase('N�o pode criar um CPF inv�lido','95818705500')]
      [TestCase('N�o pode criar um CPF inv�lido','95818705550')]
      [TestCase('N�o pode criar um CPF inv�lido com �ltimo digito igual a zero','00000000000')]
      [TestCase('N�o pode criar um CPF v�lido com m�scara inv�lida','565486780-60')]
      [TestCase('N�o pode criar um CPF v�lido misturado com letras','565fsfs48wss678060ss')]
      [TestCase('N�o pode criar um CPF inv�lido com comprimento menor que 11','14786411')]
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
