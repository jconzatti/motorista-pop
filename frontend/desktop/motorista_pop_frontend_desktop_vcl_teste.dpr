program motorista_pop_frontend_desktop_vcl_teste;

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
  Tela.Login in 'fontes\telas\Tela.Login.pas' {TelaLogin},
  Sessao.Usuario.Logado in 'fontes\infraestrutura\Sessao.Usuario.Logado.pas',
  HTTP.Cliente.Padrao in 'fontes\infraestrutura\http\HTTP.Cliente.Padrao.pas',
  HTTP.Cliente in 'fontes\infraestrutura\http\HTTP.Cliente.pas',
  ContaDeUsuario.Gateway in 'fontes\infraestrutura\gateway\ContaDeUsuario.Gateway.pas',
  ContaDeUsuario.Gateway.HTTP in 'fontes\infraestrutura\gateway\ContaDeUsuario.Gateway.HTTP.pas',
  JSON.Conversor in 'fontes\infraestrutura\json\JSON.Conversor.pas',
  Tela.Usuario.Inscricao in 'fontes\telas\Tela.Usuario.Inscricao.pas' {TelaInscricaoUsuario},
  Tela.Login.Teste in 'testes\ponta-a-ponta\Tela.Login.Teste.pas',
  ContaDeUsuario.Gateway.HTTP.Teste in 'testes\integracao\ContaDeUsuario.Gateway.HTTP.Teste.pas',
  Tela.Usuario.Inscricao.Teste in 'testes\ponta-a-ponta\Tela.Usuario.Inscricao.Teste.pas';

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
