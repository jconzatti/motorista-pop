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
  CPF.Validador in 'fontes\CPF.Validador.pas',
  CPF.Validador.Teste in 'testes\CPF.Validador.Teste.pas',
  ContaUsuario.Servico.Teste in 'testes\ContaUsuario.Servico.Teste.pas',
  ContaUsuario.Servico in 'fontes\ContaUsuario.Servico.pas',
  Corrida.Servico.Teste in 'testes\Corrida.Servico.Teste.pas',
  Corrida.Servico in 'fontes\Corrida.Servico.pas',
  ContaUsuario.DAO in 'fontes\ContaUsuario.DAO.pas',
  ContaUsuario.DAO.FireDAC in 'fontes\ContaUsuario.DAO.FireDAC.pas',
  Email.Enviador.Gateway in 'fontes\Email.Enviador.Gateway.pas',
  Corrida.DAO in 'fontes\Corrida.DAO.pas',
  Corrida.DAO.FireDAC in 'fontes\Corrida.DAO.FireDAC.pas',
  ContaUsuario.DAO.Fake in 'testes\ContaUsuario.DAO.Fake.pas',
  Corrida.DAO.Fake in 'testes\Corrida.DAO.Fake.pas',
  ContaUsuario.DAO.FireDAC.Teste in 'testes\ContaUsuario.DAO.FireDAC.Teste.pas',
  Corrida.DAO.FireDAC.Teste in 'testes\Corrida.DAO.FireDAC.Teste.pas',
  MotoristaPOP.API.Teste in 'testes\MotoristaPOP.API.Teste.pas',
  Posicao.DAO in 'fontes\Posicao.DAO.pas',
  Posicao.DAO.Fake in 'testes\Posicao.DAO.Fake.pas',
  Posicao.DAO.FireDAC in 'fontes\Posicao.DAO.FireDAC.pas',
  Posicao.DAO.FireDAC.Teste in 'testes\Posicao.DAO.FireDAC.Teste.pas',
  Distancia.Calculador.Teste in 'testes\Distancia.Calculador.Teste.pas',
  Distancia.Calculador in 'fontes\Distancia.Calculador.pas',
  InscreverUsuario.Teste in 'testes\integracao\InscreverUsuario.Teste.pas',
  InscreverUsuario in 'fontes\aplicacao\caso-de-uso\InscreverUsuario.pas',
  ContaDeUsuario.Teste in 'testes\unidade\ContaDeUsuario.Teste.pas',
  ContaDeUsuario in 'fontes\dominio\ContaDeUsuario.pas',
  UUID.Teste in 'testes\unidade\UUID.Teste.pas',
  UUID in 'fontes\dominio\UUID.pas',
  Nome.Teste in 'testes\unidade\Nome.Teste.pas',
  Nome in 'fontes\dominio\Nome.pas';

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
