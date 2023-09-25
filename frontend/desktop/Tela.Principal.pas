unit Tela.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Tela.Login;

type
  TTelaPrincipal = class(TForm)
    LbTelaPrincipal: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TelaPrincipal: TTelaPrincipal;

implementation

{$R *.dfm}

procedure TTelaPrincipal.FormCreate(Sender: TObject);
var lTelaLogin: TTelaLogin;
begin
   lTelaLogin:= TTelaLogin.Create(self);
   try
      lTelaLogin.ShowModal;
   finally
      lTelaLogin.Destroy;
   end;
end;

end.
