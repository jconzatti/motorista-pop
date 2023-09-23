program motorista_pop_teste;

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
  ContaUsuario.DAO.FireDAC in 'fontes\_old\ContaUsuario.DAO.FireDAC.pas',
  ContaUsuario.DAO in 'fontes\_old\ContaUsuario.DAO.pas',
  ContaUsuario.Servico in 'fontes\_old\ContaUsuario.Servico.pas',
  Corrida.DAO.FireDAC in 'fontes\_old\Corrida.DAO.FireDAC.pas',
  Corrida.DAO in 'fontes\_old\Corrida.DAO.pas',
  Corrida.Servico in 'fontes\_old\Corrida.Servico.pas',
  CPF.Validador in 'fontes\_old\CPF.Validador.pas',
  Distancia.Calculador in 'fontes\_old\Distancia.Calculador.pas',
  Posicao.DAO.FireDAC in 'fontes\_old\Posicao.DAO.FireDAC.pas',
  Posicao.DAO in 'fontes\_old\Posicao.DAO.pas',
  ContaUsuario.DAO.Fake in 'testes\_old\ContaUsuario.DAO.Fake.pas',
  ContaUsuario.DAO.FireDAC.Teste in 'testes\_old\ContaUsuario.DAO.FireDAC.Teste.pas',
  ContaUsuario.Servico.Teste in 'testes\_old\ContaUsuario.Servico.Teste.pas',
  Corrida.DAO.Fake in 'testes\_old\Corrida.DAO.Fake.pas',
  Corrida.DAO.FireDAC.Teste in 'testes\_old\Corrida.DAO.FireDAC.Teste.pas',
  Corrida.Servico.Teste in 'testes\_old\Corrida.Servico.Teste.pas',
  CPF.Validador.Teste in 'testes\_old\CPF.Validador.Teste.pas',
  Distancia.Calculador.Teste in 'testes\_old\Distancia.Calculador.Teste.pas',
  MotoristaPOP.API.Teste in 'testes\_old\MotoristaPOP.API.Teste.pas',
  Posicao.DAO.Fake in 'testes\_old\Posicao.DAO.Fake.pas',
  Posicao.DAO.FireDAC.Teste in 'testes\_old\Posicao.DAO.FireDAC.Teste.pas',
  ContaDeUsuario.Repositorio.BancoDeDado.FireDAC.Teste in 'testes\integracao\ContaDeUsuario.Repositorio.BancoDeDado.FireDAC.Teste.pas',
  ContaDeUsuario.Repositorio.BancoDeDado in 'fontes\infraestrutura\repositorio\ContaDeUsuario.Repositorio.BancoDeDado.pas',
  BancoDeDado.Conexao in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.pas',
  BancoDeDado.Conexao.FireDAC in 'fontes\infraestrutura\banco-de-dado\BancoDeDado.Conexao.FireDAC.pas',
  HTTP.Servidor in 'fontes\infraestrutura\http\HTTP.Servidor.pas',
  HTTP.Servidor.Horse in 'fontes\infraestrutura\http\HTTP.Servidor.Horse.pas',
  MotoristaPOP.Controlador.API.REST in 'fontes\infraestrutura\controlador\MotoristaPOP.Controlador.API.REST.pas';

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
