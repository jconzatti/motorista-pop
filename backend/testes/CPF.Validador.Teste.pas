unit CPF.Validador.Teste;

interface

uses
   CPF.Validador,
   DUnitX.TestFramework;

type

  [TestFixture]
  TValidadorCPFTeste = class(TObject)
  public
    [Test]
    [TestCase('Deve aceitar um CPF v�lido','95818705552')]
    [TestCase('Deve aceitar um CPF v�lido com �ltimo digito igual a zero','01234567890')]
    [TestCase('Deve aceitar um CPF v�lido com m�scara','565.486.780-60')]
    [TestCase('Deve aceitar um CPF v�lido com m�scara e com dois d�gitos iguais a zero','147.864.110-00')]
    procedure TestarValidacaoDeCPFCorreto(const pCPFValido: String);
    [Test]
    [TestCase('Deve rejeitar um CPF inv�lido','95818705500')]
    [TestCase('Deve rejeitar um CPF inv�lido','95818705550')]
    [TestCase('Deve rejeitar um CPF inv�lido com �ltimo digito igual a zero','00000000000')]
    [TestCase('Deve rejeitar um CPF v�lido com m�scara inv�lida','565486780-60')]
    [TestCase('Deve rejeitar um CPF v�lido misturado com letras','565fsfs48wss678060ss')]
    [TestCase('Deve rejeitar um CPF inv�lido com comprimento menor que 11','14786411')]
    procedure TestarValidacaoDeCPFErrado(const pCPFInvalido: String);
  end;

implementation

procedure TValidadorCPFTeste.TestarValidacaoDeCPFCorreto(const pCPFValido: String);
var lValidadorDeCPF : TValidadorCPF;
begin
   lValidadorDeCPF := TValidadorCPF.Create;
   try
      Assert.IsTrue(lValidadorDeCPF.Validar(pCPFValido));
   finally
      lValidadorDeCPF.Destroy;
   end;
end;

procedure TValidadorCPFTeste.TestarValidacaoDeCPFErrado(const pCPFInvalido: String);
var lValidadorDeCPF : TValidadorCPF;
begin
   lValidadorDeCPF := TValidadorCPF.Create;
   try
      Assert.IsFalse(lValidadorDeCPF.Validar(pCPFInvalido));
   finally
      lValidadorDeCPF.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TValidadorCPFTeste);
end.
