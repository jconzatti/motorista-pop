unit Frame.Coordenada;

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
   Vcl.StdCtrls, Vcl.ExtCtrls;

type
   TFrameCoordenada = class(TFrame)
   LbTitulo: TLabel;
   FlowPanel: TFlowPanel;
   PanelLatitude: TPanel;
   EdLatitude: TEdit;
   LbLatitude: TLabel;
   PanelLongitude: TPanel;
   LbLongitude: TLabel;
   EdLongitude: TEdit;
   procedure EdLatitudeEnter(Sender: TObject);
   procedure EdLatitudeExit(Sender: TObject);
   procedure EdLongitudeEnter(Sender: TObject);
   procedure EdLongitudeExit(Sender: TObject);
   private
      FValorAnterior: String;
      function ObterLatitude: Double;
      function ObterLongitude: Double;
   public
      constructor Create(AOwner: TComponent; pTitulo: String); reintroduce;
      property Latitude: Double read ObterLatitude;
      property Longitude: Double read ObterLongitude;
   end;

implementation

{$R *.dfm}

{ TFrameCoordenada }

constructor TFrameCoordenada.Create(AOwner: TComponent; pTitulo: String);
begin
   inherited Create(AOwner);
   if AOwner is TWinControl then
      Parent := TWinControl(AOwner);
   if not pTitulo.IsEmpty then
      LbTitulo.Caption := pTitulo;

   EdLatitude.OnEnter := EdLatitudeEnter;
   EdLatitude.OnExit  := EdLatitudeExit;

   EdLongitude.OnEnter := EdLongitudeEnter;
   EdLongitude.OnExit  := EdLongitudeExit;
end;

procedure TFrameCoordenada.EdLatitudeEnter(Sender: TObject);
begin
   FValorAnterior := EdLatitude.Text;
end;

procedure TFrameCoordenada.EdLatitudeExit(Sender: TObject);
begin
   if FValorAnterior <> EdLatitude.Text then
      EdLatitude.Text := FormatFloat('##0.00#############', ObterLatitude);
end;

procedure TFrameCoordenada.EdLongitudeEnter(Sender: TObject);
begin
   FValorAnterior := EdLongitude.Text;
end;

procedure TFrameCoordenada.EdLongitudeExit(Sender: TObject);
begin
   if FValorAnterior <> EdLongitude.Text then
      EdLongitude.Text := FormatFloat('##0.00#############', ObterLongitude);
end;

function TFrameCoordenada.ObterLatitude: Double;
begin
   Result := StrToFloatDef(EdLatitude.Text, 0);
end;

function TFrameCoordenada.ObterLongitude: Double;
begin
   Result := StrToFloatDef(EdLongitude.Text, 0);
end;

end.
