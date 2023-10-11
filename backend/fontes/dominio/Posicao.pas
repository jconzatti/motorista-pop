unit Posicao;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   Corrida.Status,
   Coordenada,
   UUID;

type
   TPosicao = class
   private
      FID: TUUID;
      FIDDaCorrida: TUUID;
      FCoordenada: TCoordenada;
      FData: TDateTime;
      constructor Create(pID: String;
                         pIDDaCorrida: string;
                         pLatitude: Double;
                         pLongitude: Double;
                         pData: TDateTime); reintroduce;
    function ObterID: String;
    function ObterIDDaCorrida: String;
   public
      class function Criar(pIDDaCorrida: string;
                           pLatitude: Double;
                           pLongitude: Double;
                           pData: TDateTime): TPosicao;
      class function Restaurar(pID: String;
                               pIDDaCorrida: string;
                               pLatitude: Double;
                               pLongitude: Double;
                               pData: TDateTime): TPosicao;
      destructor Destroy; override;
      property ID: String read ObterID;
      property IDDaCorrida: String read ObterIDDaCorrida;
      property Coordenada: TCoordenada read FCoordenada;
      property Data: TDateTime read FData;
   end;

   TListaDePosicoes = TObjectList<TPosicao>;

implementation

{ TPosicao }

constructor TPosicao.Create(pID, pIDDaCorrida: string; pLatitude,
  pLongitude: Double; pData: TDateTime);
begin
   FID := TUUID.Create(pID);
   FIDDaCorrida := TUUID.Create(pIDDaCorrida);
   FCoordenada := TCoordenada.Create(pLatitude, pLongitude);
   FData := pData;
end;

destructor TPosicao.Destroy;
begin
   if Assigned(FCoordenada) then
      FCoordenada.Destroy;
   if Assigned(FIDDaCorrida) then
      FIDDaCorrida.Destroy;
   if Assigned(FID) then
      FID.Destroy;
   inherited;
end;

class function TPosicao.Criar(pIDDaCorrida: string; pLatitude,
  pLongitude: Double; pData: TDateTime): TPosicao;
begin
   Result := TPosicao.Create(TUUID.Gerar, pIDDaCorrida, pLatitude, pLongitude, pData);
end;

class function TPosicao.Restaurar(pID, pIDDaCorrida: string; pLatitude,
  pLongitude: Double; pData: TDateTime): TPosicao;
begin
   Result := TPosicao.Create(pID, pIDDaCorrida, pLatitude, pLongitude, pData);
end;

function TPosicao.ObterID: String;
begin
   Result := FID.Valor;
end;

function TPosicao.ObterIDDaCorrida: String;
begin
   Result := FIDDaCorrida.Valor;
end;

end.
