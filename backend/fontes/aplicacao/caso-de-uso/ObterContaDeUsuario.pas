unit ObterContaDeUsuario;

interface

uses
   System.SysUtils,
   ContaDeUsuario,
   ContaDeUsuario.Repositorio,
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
      RepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   public
      constructor Create(pRepositorioContaUsuario: TRepositorioContaDeUsuario); reintroduce;
      function Executar(pID: String): TDadoSaidaObtencaoContaDeUsuario;
   end;

implementation

{ TObterContaDeUsuario }

constructor TObterContaDeUsuario.Create(
  pRepositorioContaUsuario: TRepositorioContaDeUsuario);
begin
   RepositorioContaDeUsuario := pRepositorioContaUsuario;
end;

function TObterContaDeUsuario.Executar(pID: String): TDadoSaidaObtencaoContaDeUsuario;
var
   lUUID : TUUID;
   lContaDeUsuario : TContaDeUsuario;
begin
   lUUID := TUUID.Create(pID);
   try
      lContaDeUsuario := RepositorioContaDeUsuario.ObterPorID(lUUID);
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
