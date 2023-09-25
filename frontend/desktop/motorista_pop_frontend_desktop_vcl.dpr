program motorista_pop_frontend_desktop_vcl;

uses
  Vcl.Forms,
  Tela.Principal in 'Tela.Principal.pas' {TelaPrincipal},
  Tela.Login in 'Tela.Login.pas' {TelaLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTelaPrincipal, TelaPrincipal);
  Application.Run;
end.
