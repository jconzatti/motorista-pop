unit Posicao.DAO.FireDAC.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   Posicao.DAO,
   Posicao.DAO.FireDAC,
   DUnitX.TestFramework;

type
   [TestFixture]
   TDAOPosicaoFireDACTeste = class
   public
      [Test]
      procedure DeveSalvarPosicoesDeUmaCorrida;
      [Test]
      procedure DeveObterListaDePosicoesDeUmaCorrida;
   end;

implementation

{ TDAOPosicaoFireDACTeste }

procedure TDAOPosicaoFireDACTeste.DeveSalvarPosicoesDeUmaCorrida;
var
   lGUID: TGUID;
   lPosicao: TDadoPosicao;
   lDAOPosicao: TDAOPosicaoFireDAC;
begin
   lDAOPosicao := TDAOPosicaoFireDAC.Create;
   try
      CreateGUID(lGUID);
      lPosicao.ID := lGUID.ToString;
      CreateGUID(lGUID);
      lPosicao.IDDaCorrida := lGUID.ToString;
      lPosicao.Latitude    := -26.877291364885657;
      lPosicao.Longitude   := -49.08225874081267;
      lPosicao.Data        := Now;
      Assert.WillNotRaiseAny(
         procedure
         begin
            lDAOPosicao.Salvar(lPosicao);
         end
      );
   finally
      lDAOPosicao.Destroy;
   end;
end;

procedure TDAOPosicaoFireDACTeste.DeveObterListaDePosicoesDeUmaCorrida;

var
   lGUID: TGUID;
   lPosicao: TDadoPosicao;
   lDAOPosicao: TDAOPosicaoFireDAC;
   lListaDePosicoesDaCorrida: TListaDePosicoes;
begin
   lDAOPosicao := TDAOPosicaoFireDAC.Create;
   try
      CreateGUID(lGUID);
      lPosicao.IDDaCorrida := lGUID.ToString;

      CreateGUID(lGUID);
      lPosicao.ID := lGUID.ToString;
      lPosicao.Latitude  := -26.877291364885657;
      lPosicao.Longitude := -49.08225874081267;
      lPosicao.Data      := StrToDateTimeDef('17/09/2023 10:00:00', Now);
      lDAOPosicao.Salvar(lPosicao);

      CreateGUID(lGUID);
      lPosicao.ID := lGUID.ToString;
      lPosicao.Latitude  := -26.8773716281549;
      lPosicao.Longitude := -49.08203741452999;
      lPosicao.Data      := StrToDateTimeDef('17/09/2023 10:00:10', Now);
      lDAOPosicao.Salvar(lPosicao);

      CreateGUID(lGUID);
      lPosicao.ID := lGUID.ToString;
      lPosicao.Latitude  := -26.877635537605425;
      lPosicao.Longitude := -49.08208293312585;
      lPosicao.Data      := StrToDateTimeDef('17/09/2023 10:00:20', Now);
      lDAOPosicao.Salvar(lPosicao);

      CreateGUID(lGUID);
      lPosicao.ID := lGUID.ToString;
      lPosicao.Latitude  := -26.878860340067302;
      lPosicao.Longitude := -49.08370642971138;
      lPosicao.Data      := StrToDateTimeDef('17/09/2023 10:00:30', Now);
      lDAOPosicao.Salvar(lPosicao);

      lListaDePosicoesDaCorrida := lDAOPosicao.ObterListaDePosicoesDaCorrida(lPosicao.IDDaCorrida);
      try
         Assert.AreEqual(4, lListaDePosicoesDaCorrida.Count);
      finally
         lListaDePosicoesDaCorrida.Destroy;
      end;
   finally
      lDAOPosicao.Destroy;
   end;
end;

initialization
  TDUnitX.RegisterTestFixture(TDAOPosicaoFireDACTeste);
end.
