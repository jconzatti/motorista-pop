program motorista_pop_backend_teste;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  InscreverUsuario.Teste in 'testes\integracao\InscreverUsuario.Teste.pas',
  InscreverUsuario in 'fontes\aplicacao\caso-de-uso\InscreverUsuario.pas',
  ContaDeUsuario.Teste in 'testes\unidade\ContaDeUsuario.Teste.pas',
  ContaDeUsuario in 'fontes\dominio\ContaDeUsuario.pas',
  UUID.Teste in 'testes\unidade\UUID.Teste.pas',
  UUID in 'fontes\dominio\UUID.pas',
  Nome.Teste in 'testes\unidade\Nome.Teste.pas',
  Nome in 'fontes\dominio\Nome.pas',
  CPF.Teste in 'testes\unidade\CPF.Teste.pas',
  CPF in 'fontes\dominio\CPF.pas',
  Email.Teste in 'testes\unidade\Email.Teste.pas',
  Email in 'fontes\dominio\Email.pas',
  PlacaDeCarro.Teste in 'testes\unidade\PlacaDeCarro.Teste.pas',
  PlacaDeCarro in 'fontes\dominio\PlacaDeCarro.pas',
  ContaDeUsuario.Repositorio in 'fontes\aplicacao\repositorio\ContaDeUsuario.Repositorio.pas',
  ContaDeUsuario.Repositorio.Fake in 'fontes\infraestrutura\repositorio\ContaDeUsuario.Repositorio.Fake.pas',
  ObterContaDeUsuario.Teste in 'testes\integracao\ObterContaDeUsuario.Teste.pas',
  ObterContaDeUsuario in 'fontes\aplicacao\caso-de-uso\ObterContaDeUsuario.pas',
  Email.Enviador.Gateway in 'fontes\infraestrutura\gateway\Email.Enviador.Gateway.pas',
  ContaDeUsuario.Repositorio.BancoDeDado.Conexao.FireDAC.Teste in 'testes\integracao\ContaDeUsuario.Repositorio.BancoDeDado.Conexao.FireDAC.Teste.pas',
  ContaDeUsuario.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\ContaDeUsuario.Repositorio.BancoDeDado.pas',
  BancoDeDado.Conexao in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.pas',
  BancoDeDado.Conexao.FireDAC in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.FireDAC.pas',
  HTTP.Servidor in 'fontes\infraestrutura\http\HTTP.Servidor.pas',
  HTTP.Servidor.Horse in 'fontes\infraestrutura\http\HTTP.Servidor.Horse.pas',
  MotoristaPOP.Controlador.API.REST in 'fontes\infraestrutura\controlador\MotoristaPOP.Controlador.API.REST.pas',
  JSON.Conversor in 'fontes\infraestrutura\json\JSON.Conversor.pas',
  HTTP.Resultado.Teste in 'testes\unidade\HTTP.Resultado.Teste.pas',
  RealizarLogin.Teste in 'testes\integracao\RealizarLogin.Teste.pas',
  RealizarLogin in 'fontes\aplicacao\caso-de-uso\RealizarLogin.pas',
  SolicitarCorrida.Teste in 'testes\integracao\SolicitarCorrida.Teste.pas',
  SolicitarCorrida in 'fontes\aplicacao\caso-de-uso\SolicitarCorrida.pas',
  Corrida.Repositorio in 'fontes\aplicacao\repositorio\Corrida.Repositorio.pas',
  Corrida in 'fontes\dominio\Corrida.pas',
  Corrida.Status in 'fontes\dominio\Corrida.Status.pas',
  Coordenada in 'fontes\dominio\Coordenada.pas',
  Corrida.Repositorio.Fake in 'fontes\infraestrutura\repositorio\Corrida.Repositorio.Fake.pas',
  Corrida.Status.Teste in 'testes\unidade\Corrida.Status.Teste.pas',
  Coordenada.Teste in 'testes\unidade\Coordenada.Teste.pas',
  Corrida.Teste in 'testes\unidade\Corrida.Teste.pas',
  JSON.Conversor.Teste in 'testes\unidade\JSON.Conversor.Teste.pas',
  ContaDeUsuario.Repositorio.Fake.Teste in 'testes\integracao\ContaDeUsuario.Repositorio.Fake.Teste.pas',
  BancoDeDado.Conexao.Teste in 'testes\integracao\BancoDeDado.Conexao.Teste.pas',
  Corrida.Repositorio.Fake.Teste in 'testes\integracao\Corrida.Repositorio.Fake.Teste.pas',
  Corrida.Repositorio.Teste in 'testes\integracao\Corrida.Repositorio.Teste.pas',
  ContaDeUsuario.Repositorio.Teste in 'testes\integracao\ContaDeUsuario.Repositorio.Teste.pas',
  Corrida.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\Corrida.Repositorio.BancoDeDado.pas',
  Corrida.Repositorio.BancoDeDado.Conexao.FireDAC.Teste in 'testes\integracao\Corrida.Repositorio.BancoDeDado.Conexao.FireDAC.Teste.pas',
  ObterCorridas.Teste in 'testes\integracao\ObterCorridas.Teste.pas',
  ObterCorridas in 'fontes\aplicacao\caso-de-uso\ObterCorridas.pas',
  AceitarCorrida.Teste in 'testes\integracao\AceitarCorrida.Teste.pas',
  AceitarCorrida in 'fontes\aplicacao\caso-de-uso\AceitarCorrida.pas',
  HTTP.Servidor.Fake in 'fontes\infraestrutura\http\HTTP.Servidor.Fake.pas',
  MotoristaPOP.Controlador.API.REST.Teste in 'testes\integracao\MotoristaPOP.Controlador.API.REST.Teste.pas',
  MotoristaPOP.Invocador.Cliente.API.REST.Teste in 'testes\ponta-a-ponta\MotoristaPOP.Invocador.Cliente.API.REST.Teste.pas',
  ObterCorrida.Teste in 'testes\integracao\ObterCorrida.Teste.pas',
  ObterCorrida in 'fontes\aplicacao\caso-de-uso\ObterCorrida.pas',
  IniciarCorrida.Teste in 'testes\integracao\IniciarCorrida.Teste.pas',
  IniciarCorrida in 'fontes\aplicacao\caso-de-uso\IniciarCorrida.pas',
  Posicao in 'fontes\dominio\Posicao.pas',
  Posicao.Teste in 'testes\unidade\Posicao.Teste.pas',
  Posicao.Repositorio in 'fontes\aplicacao\repositorio\Posicao.Repositorio.pas',
  Posicao.Repositorio.Teste in 'testes\integracao\Posicao.Repositorio.Teste.pas',
  Posicao.Repositorio.Fake.Teste in 'testes\integracao\Posicao.Repositorio.Fake.Teste.pas',
  Posicao.Repositorio.Fake in 'fontes\infraestrutura\repositorio\Posicao.Repositorio.Fake.pas',
  Posicao.Repositorio.BancoDeDado.Conexao.FireDAC.Teste in 'testes\integracao\Posicao.Repositorio.BancoDeDado.Conexao.FireDAC.Teste.pas',
  Posicao.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\Posicao.Repositorio.BancoDeDado.pas',
  AtualizarPosicao.Teste in 'testes\integracao\AtualizarPosicao.Teste.pas',
  AtualizarPosicao in 'fontes\aplicacao\caso-de-uso\AtualizarPosicao.pas',
  FinalizarCorrida.Teste in 'testes\integracao\FinalizarCorrida.Teste.pas',
  FinalizarCorrida in 'fontes\aplicacao\caso-de-uso\FinalizarCorrida.pas',
  Distancia.Calculador in 'fontes\dominio\Distancia.Calculador.pas',
  Distancia.Calculador.Teste in 'testes\unidade\Distancia.Calculador.Teste.pas',
  TarifaPorKM.Calculador.Teste in 'testes\unidade\TarifaPorKM.Calculador.Teste.pas',
  TarifaPorKM.Calculador in 'fontes\dominio\TarifaPorKM.Calculador.pas',
  Repositorio.Fabrica in 'fontes\aplicacao\repositorio\Repositorio.Fabrica.pas',
  Repositorio.Fabrica.Fake in 'fontes\infraestrutura\repositorio\Repositorio.Fabrica.Fake.pas',
  Repositorio.Fabrica.BancoDeDado in 'fontes\infraestrutura\repositorio\Repositorio.Fabrica.BancoDeDado.pas',
  CasoDeUso.Fabrica in 'fontes\aplicacao\caso-de-uso\CasoDeUso.Fabrica.pas',
  Hash.Gerador in 'fontes\dominio\Hash.Gerador.pas',
  Hash.Algoritimo.Teste in 'testes\unidade\Hash.Algoritimo.Teste.pas',
  Senha.Teste in 'testes\unidade\Senha.Teste.pas',
  Senha in 'fontes\dominio\Senha.pas',
  Hash.Gerador.Teste in 'testes\unidade\Hash.Gerador.Teste.pas',
  Token.Gerador.Teste in 'testes\unidade\Token.Gerador.Teste.pas',
  Token.Gerador in 'fontes\dominio\Token.Gerador.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
