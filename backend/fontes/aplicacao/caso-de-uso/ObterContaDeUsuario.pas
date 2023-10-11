unit ObterContaDeUsuario;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
   Repositorio.Fabrica,
   UUID;

type
   TDadoSaidaObtencaoContaDeUsuario = record
      ID: String;
      Nome: String;
      Email: String;
      CPF: String;
      Passageiro: Boolean;
      Motorista: Boolean;
      PlacaDoCarro: String;
      Data: TDateTime;
   end;

   TObterContaDeUsuario = class
   private
      FRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      constructor Create(pFabricaRepositorio: TFabricaRepositorio); reintroduce;
      destructor Destroy; override;
      function Executar(pID: String): TDadoSaidaObtencaoContaDeUsuario;
   end;

implementation

{ TObterContaDeUsuario }

constructor TObterContaDeUsuario.Create(pFabricaRepositorio: TFabricaRepositorio);
begin
   FRepositorioContaDeUsuario := pFabricaRepositorio.CriarRepositorioContaDeUsuario;
end;

destructor TObterContaDeUsuario.Destroy;
begin
   FRepositorioContaDeUsuario.Destroy;
   inherited;
end;

function TObterContaDeUsuario.Executar(pID: String): TDadoSaidaObtencaoContaDeUsuario;
var
   lUUID : TUUID;
   lContaDeUsuario : TContaDeUsuario;
begin
   lUUID := TUUID.Create(pID);
   try
      lContaDeUsuario := FRepositorioContaDeUsuario.ObterPorID(lUUID);
      try
         Result.ID           := lContaDeUsuario.ID;
         Result.Nome         := lContaDeUsuario.Nome;
         Result.Email        := lContaDeUsuario.Email;
         Result.CPF          := lContaDeUsuario.CPF;
         Result.Passageiro   := lContaDeUsuario.Passageiro;
         Result.Motorista    := lContaDeUsuario.Motorista;
         Result.PlacaDoCarro := lContaDeUsuario.PlacaDoCarro;
         Result.Data         := lContaDeUsuario.Data;
      finally
         lContaDeUsuario.Destroy;
      end;
   finally
      lUUID.Destroy;
   end;
end;

end.
