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
    [TestCase('Deve aceitar um CPF válido','95818705552')]
    [TestCase('Deve aceitar um CPF válido com último digito igual a zero','01234567890')]
    [TestCase('Deve aceitar um CPF válido com máscara','565.486.780-60')]
    [TestCase('Deve aceitar um CPF válido com máscara e com dois dígitos iguais a zero','147.864.110-00')]
    procedure TestarValidacaoDeCPFCorreto(const pCPFValido: String);
    [Test]
    [TestCase('Deve rejeitar um CPF inválido','95818705500')]
    [TestCase('Deve rejeitar um CPF inválido','95818705550')]
    [TestCase('Deve rejeitar um CPF inválido com último digito igual a zero','00000000000')]
    [TestCase('Deve rejeitar um CPF válido com máscara inválida','565486780-60')]
    [TestCase('Deve rejeitar um CPF válido misturado com letras','565fsfs48wss678060ss')]
    [TestCase('Deve rejeitar um CPF inválido com comprimento menor que 11','14786411')]
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
