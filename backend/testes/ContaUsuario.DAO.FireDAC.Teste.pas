unit ContaUsuario.DAO.FireDAC.Teste;

interface

uses
   System.SysUtils,
   ContaUsuario.DAO,
   ContaUsuario.DAO.FireDAC,
   DUnitX.TestFramework;

type
   [TestFixture]
   TDAOContaUsuarioFireDACTeste = class
   public
      [Test]
      procedure DeveSalvarUmaContaDeUsuarioEObterPorID;
      [Test]
      procedure DeveSalvarUmaContaDeUsuarioEObterPorEmail;
   end;

implementation

procedure TDAOContaUsuarioFireDACTeste.DeveSalvarUmaContaDeUsuarioEObterPorID;
var lDAOContaUsuario: TDAOContaUsuarioFireDAC;
    lGUID: TGUID;
    lContaUsuarioEntrada, lContaUsuarioSaida: TDadoContaUsuario;
begin
   lDAOContaUsuario := TDAOContaUsuarioFireDAC.Create;
   try
      CreateGUID(lGUID);
      lContaUsuarioEntrada.ID         := lGUID.ToString;
      lContaUsuarioEntrada.Nome       := 'John Doe';
      lContaUsuarioEntrada.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
      lContaUsuarioEntrada.CPF        := '958.187.055-52';
      lContaUsuarioEntrada.Passageiro := True;
      lContaUsuarioEntrada.Motorista  := False;
      lContaUsuarioEntrada.Data       := Now;
      lContaUsuarioEntrada.Verificada := False;
      CreateGUID(lGUID);
      lContaUsuarioEntrada.CodigoDeVerificacao := lGUID.ToString;
      lDAOContaUsuario.Salvar(lContaUsuarioEntrada);
      lContaUsuarioSaida := lDAOContaUsuario.ObterPorID(lContaUsuarioEntrada.ID);
      Assert.IsNotEmpty(lContaUsuarioSaida.ID);
      Assert.AreEqual(lContaUsuarioEntrada.Nome, lContaUsuarioSaida.Nome);
      Assert.AreEqual(lContaUsuarioEntrada.Email, lContaUsuarioSaida.Email);
      Assert.AreEqual(lContaUsuarioEntrada.CPF, lContaUsuarioSaida.CPF);
      Assert.IsTrue(lContaUsuarioSaida.Passageiro);
   finally
      lDAOContaUsuario.Destroy;
   end;
end;

procedure TDAOContaUsuarioFireDACTeste.DeveSalvarUmaContaDeUsuarioEObterPorEmail;
var lDAOContaUsuario: TDAOContaUsuarioFireDAC;
    lGUID: TGUID;
    lContaUsuarioEntrada, lContaUsuarioSaida: TDadoContaUsuario;
begin
   lDAOContaUsuario := TDAOContaUsuarioFireDAC.Create;
   try
      CreateGUID(lGUID);
      lContaUsuarioEntrada.ID         := lGUID.ToString;
      lContaUsuarioEntrada.Nome       := 'John Doe';
      lContaUsuarioEntrada.Email      := Format('john.doe.%d@gmail.com', [Random(100000000)]);
      lContaUsuarioEntrada.CPF        := '958.187.055-52';
      lContaUsuarioEntrada.Passageiro := True;
      lContaUsuarioEntrada.Motorista  := False;
      lContaUsuarioEntrada.Data       := Now;
      lContaUsuarioEntrada.Verificada := False;
      CreateGUID(lGUID);
      lContaUsuarioEntrada.CodigoDeVerificacao := lGUID.ToString;
      lDAOContaUsuario.Salvar(lContaUsuarioEntrada);
      lContaUsuarioSaida := lDAOContaUsuario.ObterPorEmail(lContaUsuarioEntrada.Email);
      Assert.IsNotEmpty(lContaUsuarioSaida.ID);
      Assert.AreEqual(lContaUsuarioEntrada.Nome, lContaUsuarioSaida.Nome);
      Assert.AreEqual(lContaUsuarioEntrada.Email, lContaUsuarioSaida.Email);
      Assert.AreEqual(lContaUsuarioEntrada.CPF, lContaUsuarioSaida.CPF);
      Assert.IsTrue(lContaUsuarioSaida.Passageiro);
   finally
      lDAOContaUsuario.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TDAOContaUsuarioFireDACTeste);
end.
