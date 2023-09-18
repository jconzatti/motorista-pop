unit Corrida.DAO.FireDAC.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Corrida.DAO,
   Corrida.DAO.FireDAC,
   DUnitX.TestFramework;

type
   [TestFixture]
   TDAOCorridaFireDACTeste = class
   public
      [Test]
      procedure DeveSalvarUmaCorridaEObterPorID;
      [Test]
      procedure DeveAtualizarUmaCorrida;
      [Test]
      procedure DeveObterCorridasAtivasDoPassageiro;
      [Test]
      procedure DeveObterCorridasAtivasDoMotorista;
   end;

implementation

procedure TDAOCorridaFireDACTeste.DeveSalvarUmaCorridaEObterPorID;
var
   lGUID: TGUID;
   lCorridaEntrada, lCorridaSaida: TDadoCorrida;
   lDAOCorrida: TDAOCorridaFireDAC;
begin
   lDAOCorrida := TDAOCorridaFireDAC.Create;
   try
      CreateGUID(lGUID);
      lCorridaEntrada.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lCorridaEntrada.IDDoPassageiro := lGUID.ToString;
      lCorridaEntrada.Status         := 'requested';
      lCorridaEntrada.DeLatitude     := -26.877291364885657;
      lCorridaEntrada.DeLongitude    := -49.08225874081267;
      lCorridaEntrada.ParaLatitude   := -26.863202471813185;
      lCorridaEntrada.ParaLongitude  := -49.072482819584245;
      lCorridaEntrada.Data           := Now;
      lDAOCorrida.Salvar(lCorridaEntrada);
      lCorridaSaida := lDAOCorrida.ObterPorID(lCorridaEntrada.ID);
      Assert.IsNotEmpty(lCorridaSaida.ID);
      Assert.AreEqual('requested', lCorridaSaida.Status);
      Assert.AreEqual(Date, DateOf(lCorridaSaida.Data));
   finally
      lDAOCorrida.Destroy;
   end;
end;

procedure TDAOCorridaFireDACTeste.DeveAtualizarUmaCorrida;

var
   lGUID: TGUID;
   lCorridaEntrada, lCorridaSaida: TDadoCorrida;
   lDAOCorrida: TDAOCorridaFireDAC;
begin
   lDAOCorrida := TDAOCorridaFireDAC.Create;
   try
      CreateGUID(lGUID);
      lCorridaEntrada.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lCorridaEntrada.IDDoPassageiro := lGUID.ToString;
      lCorridaEntrada.Status         := 'requested';
      lCorridaEntrada.DeLatitude     := -26.877291364885657;
      lCorridaEntrada.DeLongitude    := -49.08225874081267;
      lCorridaEntrada.ParaLatitude   := -26.863202471813185;
      lCorridaEntrada.ParaLongitude  := -49.072482819584245;
      lCorridaEntrada.Data           := Now;
      lDAOCorrida.Salvar(lCorridaEntrada);

      CreateGUID(lGUID);
      lCorridaEntrada.IDDoMotorista := lGUID.ToString;
      lCorridaEntrada.Status        := 'completed';
      lCorridaEntrada.Distancia     := 4;
      lCorridaEntrada.Tarifa        := 8.4;
      lDAOCorrida.Atualizar(lCorridaEntrada);

      lCorridaSaida := lDAOCorrida.ObterPorID(lCorridaEntrada.ID);
      Assert.AreEqual(lCorridaEntrada.ID, lCorridaSaida.ID);
      Assert.AreEqual('completed', lCorridaSaida.Status);
      Assert.AreEqual(Date, DateOf(lCorridaSaida.Data));
      Assert.AreEqual(lCorridaEntrada.IDDoMotorista, lCorridaSaida.IDDoMotorista);
      Assert.AreEqual(lCorridaEntrada.Distancia, lCorridaSaida.Distancia);
      Assert.AreEqual(lCorridaEntrada.Tarifa, lCorridaSaida.Tarifa);
   finally
      lDAOCorrida.Destroy;
   end;
end;

procedure TDAOCorridaFireDACTeste.DeveObterCorridasAtivasDoPassageiro;
var
   lGUID: TGUID;
   lCorrida: TDadoCorrida;
   lDAOCorrida: TDAOCorridaFireDAC;
   LListaDeCorridasAtivas: TListaDeCorridas;
begin
   lDAOCorrida := TDAOCorridaFireDAC.Create;
   try
      CreateGUID(lGUID);
      lCorrida.IDDoPassageiro := lGUID.ToString;

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      CreateGUID(lGUID);
      lCorrida.IDDoMotorista := lGUID.ToString;
      lCorrida.Status := 'accepted';
      lDAOCorrida.Atualizar(lCorrida);

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      CreateGUID(lGUID);
      lCorrida.IDDoMotorista := lGUID.ToString;
      lCorrida.Status := 'in_progress';
      lDAOCorrida.Atualizar(lCorrida);

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      CreateGUID(lGUID);
      lCorrida.IDDoMotorista := lGUID.ToString;
      lCorrida.Status := 'completed';
      lDAOCorrida.Atualizar(lCorrida);

      LListaDeCorridasAtivas := lDAOCorrida.ObterListaDeCorridasAtivasPeloIDDoPassageiro(lCorrida.IDDoPassageiro);
      try
         Assert.AreEqual(3, LListaDeCorridasAtivas.Count);
      finally
         LListaDeCorridasAtivas.Destroy;
      end;
   finally
      lDAOCorrida.Destroy;
   end;
end;

procedure TDAOCorridaFireDACTeste.DeveObterCorridasAtivasDoMotorista;
var
   lGUID: TGUID;
   lCorrida: TDadoCorrida;
   lDAOCorrida: TDAOCorridaFireDAC;
   LListaDeCorridasAtivas: TListaDeCorridas;
begin
   lDAOCorrida := TDAOCorridaFireDAC.Create;
   try
      CreateGUID(lGUID);
      lCorrida.IDDoMotorista := lGUID.ToString;

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lCorrida.IDDoPassageiro := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      lCorrida.Status := 'accepted';
      lDAOCorrida.Atualizar(lCorrida);

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lCorrida.IDDoPassageiro := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      lCorrida.Status := 'in_progress';
      lDAOCorrida.Atualizar(lCorrida);

      CreateGUID(lGUID);
      lCorrida.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lCorrida.IDDoPassageiro := lGUID.ToString;
      lCorrida.Status         := 'requested';
      lCorrida.DeLatitude     := -26.877291364885657;
      lCorrida.DeLongitude    := -49.08225874081267;
      lCorrida.ParaLatitude   := -26.863202471813185;
      lCorrida.ParaLongitude  := -49.072482819584245;
      lCorrida.Data           := Now;
      lDAOCorrida.Salvar(lCorrida);
      lCorrida.Status := 'completed';
      lDAOCorrida.Atualizar(lCorrida);

      LListaDeCorridasAtivas := lDAOCorrida.ObterListaDeCorridasAtivasPeloIDDoMotorista(lCorrida.IDDoMotorista);
      try
         Assert.AreEqual(2, LListaDeCorridasAtivas.Count);
      finally
         LListaDeCorridasAtivas.Destroy;
      end;
   finally
      lDAOCorrida.Destroy;
   end;
end;

initialization
  TDUnitX.RegisterTestFixture(TDAOCorridaFireDACTeste);
end.
