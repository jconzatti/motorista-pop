program motorista_pop_frontend_desktop_vcl;

uses
  Vcl.Forms,
  Tela.Principal in 'fontes\telas\Tela.Principal.pas' {TelaPrincipal},
  Tela.Login in 'fontes\telas\Tela.Login.pas' {TelaLogin},
  Sessao.Usuario.Logado in 'fontes\infraestrutura\Sessao.Usuario.Logado.pas',
  ContaDeUsuario.Gateway.HTTP in 'fontes\infraestrutura\gateway\ContaDeUsuario.Gateway.HTTP.pas',
  ContaDeUsuario.Gateway in 'fontes\infraestrutura\gateway\ContaDeUsuario.Gateway.pas',
  HTTP.Cliente.Padrao in 'fontes\infraestrutura\http\HTTP.Cliente.Padrao.pas',
  HTTP.Cliente in 'fontes\infraestrutura\http\HTTP.Cliente.pas',
  Tela.Usuario.Inscricao in 'fontes\telas\Tela.Usuario.Inscricao.pas' {TelaInscricaoUsuario},
  JSON.Conversor in 'fontes\infraestrutura\json\JSON.Conversor.pas',
  Corrida.Gateway in 'fontes\infraestrutura\gateway\Corrida.Gateway.pas',
  Corrida.Gateway.HTTP in 'fontes\infraestrutura\gateway\Corrida.Gateway.HTTP.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TTelaPrincipal, TelaPrincipal);
  Application.Run;
end.
