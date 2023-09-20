unit UUID.Teste;

interface

uses
   UUID,
   DUnitX.TestFramework;

type
   [TestFixture]
   TUUIDTeste = class
   public
      [Test]
      procedure DeverCriarUUIDValido;
      [Test]
      procedure NaoPodeCriarUUIDInvalido;
      [Test]
      procedure DeverGerarUUIDValido;
   end;

implementation

procedure TUUIDTeste.DeverCriarUUIDValido;
var lUUID : TUUID;
begin
   lUUID := TUUID.Create('03dedb8c74204de58651c49952972a65');
   try
      Assert.AreEqual<String>('03dedb8c74204de58651c49952972a65', lUUID.Valor);
   finally
      lUUID.Destroy;
   end;
end;

procedure TUUIDTeste.NaoPodeCriarUUIDInvalido;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TUUID.Create('jonh doe');
      end,
      EUUIDInvalido,
      'UUID inválido!'
   );
end;

procedure TUUIDTeste.DeverGerarUUIDValido;
var lUUIDGerado: String;
    lUUID : TUUID;
begin
   lUUIDGerado := TUUID.Gerar;
   lUUID := TUUID.Create(lUUIDGerado);
   try
      Assert.AreEqual<String>(lUUIDGerado, lUUID.Valor);
   finally
      lUUID.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TUUIDTeste);
end.
