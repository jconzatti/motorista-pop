unit Hash.Algoritimo.Teste;

interface

uses
   Hash.Gerador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TAlgoritimoHashTeste = class
   public
      [Test]
      procedure TestarValorDeAlgoritimoHashNenhum;
      [Test]
      procedure TestarValorDeAlgoritimoHashMD5;
      [Test]
      procedure TestarValorDeAlgoritimoHashSHA1;
      [Test]
      procedure TestarValorDeAlgoritimoHashSHA256;
      [Test]
      procedure TestarValorDeAlgoritimoHashSHA512;
      [Test]
      procedure TestarAlgoritimoHashNenhum;
      [Test]
      procedure TestarAlgoritimoHashMD5;
      [Test]
      procedure TestarAlgoritimoHashSHA1;
      [Test]
      procedure TestarAlgoritimoHashSHA256;
      [Test]
      procedure TestarAlgoritimoHashSHA512;
      [Test]
      procedure NaoPodeAceitarUmAlgoritimoHashInvalido;
   end;

implementation


{ TAlgoritimoHashTeste }

procedure TAlgoritimoHashTeste.TestarValorDeAlgoritimoHashNenhum;
begin
   Assert.IsEmpty(TAlgoritimoHash.Nenhum.Valor);
end;

procedure TAlgoritimoHashTeste.TestarValorDeAlgoritimoHashMD5;
begin
   Assert.AreEqual('md5',  TAlgoritimoHash.MD5.Valor);
end;

procedure TAlgoritimoHashTeste.TestarValorDeAlgoritimoHashSHA1;
begin
   Assert.AreEqual('sha1',  TAlgoritimoHash.SHA1.Valor);
end;

procedure TAlgoritimoHashTeste.TestarValorDeAlgoritimoHashSHA256;
begin
   Assert.AreEqual('sha256',  TAlgoritimoHash.SHA256.Valor);
end;

procedure TAlgoritimoHashTeste.TestarValorDeAlgoritimoHashSHA512;
begin
   Assert.AreEqual('sha512',  TAlgoritimoHash.SHA512.Valor);
end;

procedure TAlgoritimoHashTeste.TestarAlgoritimoHashNenhum;
begin
   Assert.AreEqual<TAlgoritimoHash>(TAlgoritimoHash.Nenhum,  TAlgoritimoHash.Algoritimo(''));
end;

procedure TAlgoritimoHashTeste.TestarAlgoritimoHashMD5;
begin
   Assert.AreEqual<TAlgoritimoHash>(TAlgoritimoHash.MD5,  TAlgoritimoHash.Algoritimo('md5'));
end;

procedure TAlgoritimoHashTeste.TestarAlgoritimoHashSHA1;
begin
   Assert.AreEqual<TAlgoritimoHash>(TAlgoritimoHash.SHA1,  TAlgoritimoHash.Algoritimo('sha1'));
end;

procedure TAlgoritimoHashTeste.TestarAlgoritimoHashSHA256;
begin
   Assert.AreEqual<TAlgoritimoHash>(TAlgoritimoHash.SHA256,  TAlgoritimoHash.Algoritimo('sha256'));
end;

procedure TAlgoritimoHashTeste.TestarAlgoritimoHashSHA512;
begin
   Assert.AreEqual<TAlgoritimoHash>(TAlgoritimoHash.SHA512,  TAlgoritimoHash.Algoritimo('sha512'));
end;

procedure TAlgoritimoHashTeste.NaoPodeAceitarUmAlgoritimoHashInvalido;
begin
   Assert.WillRaiseWithMessage(
      procedure
      begin
         TAlgoritimoHash.Algoritimo('invalid')
      end,
      EAlgoritimoHashInvalido,
      'Valor "invalid" para algorítimo hash inválido!'
   );
end;

initialization
   TDUnitX.RegisterTestFixture(TAlgoritimoHashTeste);
end.
