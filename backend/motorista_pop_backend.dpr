program motorista_pop_backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Email.Enviador.Gateway in 'fontes\infraestrutura\gateway\Email.Enviador.Gateway.pas',
  ContaDeUsuario in 'fontes\dominio\ContaDeUsuario.pas',
  CPF in 'fontes\dominio\CPF.pas',
  Email in 'fontes\dominio\Email.pas',
  Nome in 'fontes\dominio\Nome.pas',
  PlacaDeCarro in 'fontes\dominio\PlacaDeCarro.pas',
  UUID in 'fontes\dominio\UUID.pas',
  ContaDeUsuario.Repositorio in 'fontes\aplicacao\repositorio\ContaDeUsuario.Repositorio.pas',
  InscreverUsuario in 'fontes\aplicacao\caso-de-uso\InscreverUsuario.pas',
  ObterContaDeUsuario in 'fontes\aplicacao\caso-de-uso\ObterContaDeUsuario.pas',
  ContaDeUsuario.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\ContaDeUsuario.Repositorio.BancoDeDado.pas',
  ContaDeUsuario.Repositorio.Fake in 'fontes\infraestrutura\repositorio\ContaDeUsuario.Repositorio.Fake.pas',
  HTTP.Servidor.Horse in 'fontes\infraestrutura\http\HTTP.Servidor.Horse.pas',
  HTTP.Servidor in 'fontes\infraestrutura\http\HTTP.Servidor.pas',
  MotoristaPOP.Controlador.API.REST in 'fontes\infraestrutura\controlador\MotoristaPOP.Controlador.API.REST.pas',
  BancoDeDado.Conexao.FireDAC in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.FireDAC.pas',
  BancoDeDado.Conexao in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.pas',
  JSON.Conversor in 'fontes\infraestrutura\json\JSON.Conversor.pas',
  RealizarLogin in 'fontes\aplicacao\caso-de-uso\RealizarLogin.pas';

var
   lServidorHTTP: TServidorHTTP;
   lInscreverUsuario: TInscreverUsuario;
   lObterContaDeUsuario: TObterContaDeUsuario;
   lRealizarLogin: TRealizarLogin;
   lRepositorioContaDeUsuario: TRepositorioContaDeUsuario;
   lConexaoBancoDeDado: TConexaoBancoDeDado;
begin
   ReportMemoryLeaksOnShutdown := True;
   lConexaoBancoDeDado        := TConexaoBancoDeDadoFireDAC.Create;
   lRepositorioContaDeUsuario := TRepositorioContaDeUsuarioBancoDeDado.Create(lConexaoBancoDeDado);
   lInscreverUsuario          := TInscreverUsuario.Create(lRepositorioContaDeUsuario);
   lObterContaDeUsuario       := TObterContaDeUsuario.Create(lRepositorioContaDeUsuario);
   lRealizarLogin             := TRealizarLogin.Create(lRepositorioContaDeUsuario);
   lServidorHTTP              := TServidorHTTPHorse.Create;
   try
      TControladorMotoristaPOPAPIREST.Create(lServidorHTTP, lInscreverUsuario, lObterContaDeUsuario, lRealizarLogin);
   finally
      lServidorHTTP.Destroy;
      lRealizarLogin.Destroy;
      lObterContaDeUsuario.Destroy;
      lInscreverUsuario.Destroy;
      lRepositorioContaDeUsuario.Destroy;
      lConexaoBancoDeDado.Destroy;
   end;
end.
