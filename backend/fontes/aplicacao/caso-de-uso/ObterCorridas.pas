unit ObterCorridas;

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
   TDadoEntradaObtencaoCorridas = record
      IDDoUsuario: string;
      ListaDeStatus: TArray<String>;
   end;

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
   end;

   TDadoSaidaObtencaoCorridas = TArray<TDadoSaidaObtencaoCorrida>;

   TObterCorridas = class
   private
      FRepositorioCorrida: TRepositorioCorrida;
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
      function CarregarDadoSaidaObtencaoCorrida(pCorrida: TCorrida):TDadoSaidaObtencaoCorrida;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pEntradaObtencaoCorridas: TDadoEntradaObtencaoCorridas): TDadoSaidaObtencaoCorridas;
   end;

implementation

{ TObterCorridas }

constructor TObterCorridas.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaDeUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
   FRepositorioCorrida := pFabricaRepositorio.CriarRepositorioCorrida;
end;

destructor TObterCorridas.Destroy;
begin
   FRepositorioCorrida.Destroy;
   FRepositorioContaDeUsuario.Destroy;
   inherited;
end;

function TObterCorridas.Executar(pEntradaObtencaoCorridas: TDadoEntradaObtencaoCorridas): TDadoSaidaObtencaoCorridas;
var
   lListaDeCorridas: TListaDeCorridas;
   lID: TUUID;
   lConjuntoDeStatusDeCorrida: TConjuntoDeStatusCorrida;
   lStatusDeCorrida: String;
   I: Integer;
begin
   lID := TUUID.Create(pEntradaObtencaoCorridas.IDDoUsuario);
   try
      lConjuntoDeStatusDeCorrida := [];
      for lStatusDeCorrida in pEntradaObtencaoCorridas.ListaDeStatus do
         lConjuntoDeStatusDeCorrida := lConjuntoDeStatusDeCorrida + [TStatusCorrida.Status(lStatusDeCorrida)];
      lListaDeCorridas := FRepositorioCorrida.ObterListaDeCorridasDoUsuario(lID, lConjuntoDeStatusDeCorrida);
      try
         SetLength(Result, lListaDeCorridas.Count);

         for I := 0 to lListaDeCorridas.Count - 1 do
            Result[I] := CarregarDadoSaidaObtencaoCorrida(lListaDeCorridas.Items[I]);
      finally
         lListaDeCorridas.Destroy;
      end;
   finally
      lID.Destroy;
   end;
end;

function TObterCorridas.CarregarDadoSaidaObtencaoCorrida(pCorrida: TCorrida): TDadoSaidaObtencaoCorrida;
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
