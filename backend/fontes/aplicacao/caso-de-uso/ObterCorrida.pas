unit ObterCorrida;

interface

uses
   System.SysUtils,
   Corrida,
   Corrida.Status,
   Corrida.Repositorio,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Repositorio.Fabrica,
   UUID;

type
   TCoodernadaObtencaoCorridas = record
      Latitude: Double;
      Longitude: Double;
   end;

   TPassageiroObtencaoCorridas = record
      ID: string;
      Nome: string;
      Email: string;
      CPF: string;
   end;

   TMotoristaObtencaoCorridas = record
      ID: string;
      Nome: string;
      Email: string;
      CPF: string;
      PlacaDoCarro: String;
   end;

   TDadoSaidaObtencaoCorrida = record
      ID: string;
      Passageiro: TPassageiroObtencaoCorridas;
      Motorista: TMotoristaObtencaoCorridas;
      Status: String;
      Origem: TCoodernadaObtencaoCorridas;
      Destino: TCoodernadaObtencaoCorridas;
      Data: TDateTime;
      Distancia: Double;
      Tarifa: Double;
   end;

   TObterCorrida = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      function CarregarDadoSaidaObtencaoCorrida(pCorrida: TCorrida):TDadoSaidaObtencaoCorrida;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pIDDaCorrida: String): TDadoSaidaObtencaoCorrida;
   end;

implementation

{ TObterCorrida }

constructor TObterCorrida.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaDeUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FRepositorioCorrida := pFabricaRepositorio.CriarRepositorioCorrida;
end;

destructor TObterCorrida.Destroy;
begin
   FRepositorioCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   inherited;
end;

function TObterCorrida.Executar(pIDDaCorrida: String): TDadoSaidaObtencaoCorrida;
var
   lID: TUUID;
   lCorrida: TCorrida;
begin
   lID := TUUID.Create(pIDDaCorrida);
   try
      lCorrida := FRepositorioCorrida.ObterPorID(lID);
      try
         Result := CarregarDadoSaidaObtencaoCorrida(lCorrida);
      finally
         lCorrida.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

function TObterCorrida.CarregarDadoSaidaObtencaoCorrida(pCorrida: TCorrida): TDadoSaidaObtencaoCorrida;
var
   lID: TUUID;
   lUsuario: TContaDeUsuario;
begin
   Result.ID                := pCorrida.ID;
   Result.Status            := pCorrida.Status.Valor;
   Result.Origem.Latitude   := pCorrida.De.Latitude;
   Result.Origem.Longitude  := pCorrida.De.Longitude;
   Result.Destino.Latitude  := pCorrida.Para.Latitude;
   Result.Destino.Longitude := pCorrida.Para.Longitude;
   Result.Data              := pCorrida.Data;
   Result.Distancia         := pCorrida.Distancia;
   Result.Tarifa            := pCorrida.Tarifa;

   lID := TUUID.Create(pCorrida.IDDoPassageiro);
   try
      lUsuario := FRepositorioContaDeUsuario.ObterPorID(lID);
      try
         Result.Passageiro.ID    := lID.Valor;
         Result.Passageiro.Nome  := lUsuario.Nome;
         Result.Passageiro.Email := lUsuario.Email;
         Result.Passageiro.CPF   := lUsuario.CPF;
      finally
         lUsuario.Destroy;
      end;
   finally
      lID.Destroy;
   end;

   if not pCorrida.IDDoMotorista.IsEmpty then
   begin
      lID := TUUID.Create(pCorrida.IDDoMotorista);
      try
         lUsuario := FRepositorioContaDeUsuario.ObterPorID(lID);
         try
            Result.Motorista.ID           := lID.Valor;
            Result.Motorista.Nome         := lUsuario.Nome;
            Result.Motorista.Email        := lUsuario.Email;
            Result.Motorista.CPF          := lUsuario.CPF;
            Result.Motorista.PlacaDoCarro := lUsuario.PlacaDoCarro;
         finally
            lUsuario.Destroy;
         end;
      finally
         lID.Destroy;
      end;
   end;
end;

end.
