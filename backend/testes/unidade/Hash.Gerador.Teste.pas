unit Hash.Gerador.Teste;

interface

uses
   Hash.Gerador,
   DUnitX.TestFramework;

type
   [TestFixture]
   TGeradorHashTeste = class
   public
      [Test]
      procedure DeveGerarHashSemAlgoritmo;
      [Test]
      procedure DeveGerarHashMD5;
      [Test]
      procedure DeveGerarHashSHA1;
      [Test]
      procedure DeveGerarHashSHA256;
      [Test]
      procedure DeveGerarHashSHA512;
   end;

implementation


{ TGeradorHashTeste }

procedure TGeradorHashTeste.DeveGerarHashSemAlgoritmo;
var
   lGeradorHash : TGeradorHash;
begin
   lGeradorHash := TGeradorHash.Create(TAlgoritimoHash.Nenhum);
   try
      Assert.AreEqual('123456@Bcdef&', lGeradorHash.GerarHash('123456@Bcdef&'));
   finally
      lGeradorHash.Destroy;
   end;
end;

procedure TGeradorHashTeste.DeveGerarHashMD5;
var
   lGeradorHash : TGeradorHash;
begin
   lGeradorHash := TGeradorHash.Create(TAlgoritimoHash.MD5);
   try
      Assert.AreEqual('bef0e969af27ce9b26d83b405cfe560f', lGeradorHash.GerarHash('123456@Bcdef&'));
   finally
      lGeradorHash.Destroy;
   end;
end;

procedure TGeradorHashTeste.DeveGerarHashSHA1;
var
   lGeradorHash : TGeradorHash;
begin
   lGeradorHash := TGeradorHash.Create(TAlgoritimoHash.SHA1);
   try
      Assert.AreEqual('d41694ec0d1f50db87b3d9e04eaa886c726558e5', lGeradorHash.GerarHash('123456@Bcdef&'));
   finally
      lGeradorHash.Destroy;
   end;
end;

procedure TGeradorHashTeste.DeveGerarHashSHA256;
var
   lGeradorHash : TGeradorHash;
begin
   lGeradorHash := TGeradorHash.Create(TAlgoritimoHash.SHA256);
   try
      Assert.AreEqual('3fff219bd347879e4b19a8992d1b48a235cce270db10dda233ba07181b061de6', lGeradorHash.GerarHash('123456@Bcdef&'));
   finally
      lGeradorHash.Destroy;
   end;
end;

procedure TGeradorHashTeste.DeveGerarHashSHA512;
var
   lGeradorHash : TGeradorHash;
begin
   lGeradorHash := TGeradorHash.Create(TAlgoritimoHash.SHA512);
   try
      Assert.AreEqual('b61e8ffcfc4207cc5ed251e39560060e5075799037a9ab440dc63fa49e15f507636fa8f175acde65e41d1f1c46c2af771b6d438a47894f66453ae1453f50fca8', lGeradorHash.GerarHash('123456@Bcdef&'));
   finally
      lGeradorHash.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TGeradorHashTeste);
end.
