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
  HTTP.Servidor.Horse in 'fontes\infraestrutura\http\HTTP.Servidor.Horse.pas',
  HTTP.Servidor in 'fontes\infraestrutura\http\HTTP.Servidor.pas',
  MotoristaPOP.Controlador.API.REST in 'fontes\infraestrutura\controlador\MotoristaPOP.Controlador.API.REST.pas',
  BancoDeDado.Conexao.FireDAC in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.FireDAC.pas',
  BancoDeDado.Conexao in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.pas',
  JSON.Conversor in 'fontes\infraestrutura\json\JSON.Conversor.pas',
  RealizarLogin in 'fontes\aplicacao\caso-de-uso\RealizarLogin.pas',
  SolicitarCorrida in 'fontes\aplicacao\caso-de-uso\SolicitarCorrida.pas',
  Coordenada in 'fontes\dominio\Coordenada.pas',
  Corrida in 'fontes\dominio\Corrida.pas',
  Corrida.Status in 'fontes\dominio\Corrida.Status.pas',
  Corrida.Repositorio in 'fontes\aplicacao\repositorio\Corrida.Repositorio.pas',
  Corrida.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\Corrida.Repositorio.BancoDeDado.pas',
  ObterCorridas in 'fontes\aplicacao\caso-de-uso\ObterCorridas.pas',
  ObterCorrida in 'fontes\aplicacao\caso-de-uso\ObterCorrida.pas',
  AceitarCorrida in 'fontes\aplicacao\caso-de-uso\AceitarCorrida.pas',
  IniciarCorrida in 'fontes\aplicacao\caso-de-uso\IniciarCorrida.pas',
  Repositorio.Fabrica in 'fontes\aplicacao\repositorio\Repositorio.Fabrica.pas',
  Posicao.Repositorio in 'fontes\aplicacao\repositorio\Posicao.Repositorio.pas',
  Posicao in 'fontes\dominio\Posicao.pas',
  Distancia.Calculador in 'fontes\dominio\Distancia.Calculador.pas',
  TarifaPorKM.Calculador in 'fontes\dominio\TarifaPorKM.Calculador.pas',
  AtualizarPosicao in 'fontes\aplicacao\caso-de-uso\AtualizarPosicao.pas',
  FinalizarCorrida in 'fontes\aplicacao\caso-de-uso\FinalizarCorrida.pas',
  CasoDeUso.Fabrica in 'fontes\aplicacao\caso-de-uso\CasoDeUso.Fabrica.pas',
  Repositorio.Fabrica.BancoDeDado in 'fontes\infraestrutura\repositorio\Repositorio.Fabrica.BancoDeDado.pas',
  Posicao.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\Posicao.Repositorio.BancoDeDado.pas',
  Hash.Gerador in 'fontes\dominio\Hash.Gerador.pas',
  Senha in 'fontes\dominio\Senha.pas';

var
   lServidorHTTP: TServidorHTTP;
   lConexaoBancoDeDado: TConexaoBancoDeDado;
   lFabricaRepositorio: TFabricaRepositorio;
   lFabricaCasoDeUso: TFabricaCasoDeUso;
begin
   ReportMemoryLeaksOnShutdown := True;
   lConexaoBancoDeDado := TConexaoBancoDeDadoFireDAC.Create;
   lFabricaRepositorio := TFabricaRepositorioBancoDeDado.Create(lConexaoBancoDeDado);
   lFabricaCasoDeUso   := TFabricaCasoDeUso.Create(lFabricaRepositorio);
   lServidorHTTP       := TServidorHTTPHorse.Create;
   try
      TControladorMotoristaPOPAPIREST.Create(lServidorHTTP, lFabricaCasoDeUso);
   finally
      lServidorHTTP.Destroy;
      lFabricaCasoDeUso.Destroy;
      lFabricaRepositorio.Destroy;
      lConexaoBancoDeDado.Destroy;
   end;
end.
