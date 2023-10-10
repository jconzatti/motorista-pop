unit Corrida;

interface

uses
   System.SysUtils,
   System.Generics.Collections,
   Corrida.Status,
   Coordenada,
   UUID;

type
   EOutroMotorista = class(EArgumentException);

   TCorrida = class
   private
      FID: TUUID;
      FIDDoPassageiro: TUUID;
      FIDDoMotorista: TUUID;
      FStatus: TStatusCorrida;
      FTarifa: Double;
      FDistancia: Double;
      FDe: TCoordenada;
      FPara: TCoordenada;
      FData: TDateTime;
      constructor Create(pID: String;
                         pIDDoPassageiro: string;
                         pIDDoMotorista: String;
                         pStatus: TStatusCorrida;
                         pTarifa: Double;
                         pDistancia: Double;
                         pDeLatitude: Double;
                         pDeLongitude: Double;
                         pParaLatitude: Double;
                         pParaLongitude: Double;
                         pData: TDateTime); reintroduce;
    function ObterID: String;
    function ObterIDDoPassageiro: String;
    function ObterIDDoMotorista: String;
   public
      class function Criar(pIDDoPassageiro: string;
                           pDeLatitude: Double;
                           pDeLongitude: Double;
                           pParaLatitude: Double;
                           pParaLongitude: Double): TCorrida;
      class function Restaurar(pID: String;
                               pIDDoPassageiro: string;
                               pIDDoMotorista: String;
                               pStatus: TStatusCorrida;
                               pTarifa: Double;
                               pDistancia: Double;
                               pDeLatitude: Double;
                               pDeLongitude: Double;
                               pParaLatitude: Double;
                               pParaLongitude: Double;
                               pData: TDateTime): TCorrida;
      destructor Destroy; override;
      procedure Aceitar(pIDDoMotorista: string);
      procedure Iniciar(pIDDoMotorista: string);
      property ID: String read ObterID;
      property IDDoPassageiro: String read ObterIDDoPassageiro;
      property IDDoMotorista: String read ObterIDDoMotorista;
      property Status: TStatusCorrida read FStatus;
      property Tarifa: Double read FTarifa;
      property Distancia: Double read FDistancia;
      property De: TCoordenada read FDe;
      property Para: TCoordenada read FPara;
      property Data: TDateTime read FData;
   end;

   TListaDeCorridas = TList<TCorrida>;

implementation

{ TCorrida }

constructor TCorrida.Create(pID, pIDDoPassageiro, pIDDoMotorista: String;
  pStatus: TStatusCorrida; pTarifa, pDistancia, pDeLatitude, pDeLongitude,
  pParaLatitude, pParaLongitude: Double; pData: TDateTime);
begin
   FStatus         := pStatus;
   FTarifa         := pTarifa;
   FDistancia      := pDistancia;
   FData           := pData;

   FIDDoMotorista := nil;
   if not pIDDoMotorista.IsEmpty then
      FIDDoMotorista := TUUID.Create(pIDDoMotorista);

   FID             := TUUID.Create(pID);
   FIDDoPassageiro := TUUID.Create(pIDDoPassageiro);
   FDe             := TCoordenada.Create(pDeLatitude, pDeLongitude);
   FPara           := TCoordenada.Create(pParaLatitude, pParaLongitude);
end;

destructor TCorrida.Destroy;
begin
   if Assigned(FPara) then
      FPara.Destroy;
   if Assigned(FDe) then
      FDe.Destroy;
   if Assigned(FIDDoPassageiro) then
      FIDDoPassageiro.Destroy;
   if Assigned(FID) then
      FID.Destroy;
   if Assigned(FIDDoMotorista) then
      FIDDoMotorista.Destroy;
   inherited;
end;

class function TCorrida.Criar(pIDDoPassageiro: string; pDeLatitude,
  pDeLongitude, pParaLatitude, pParaLongitude: Double): TCorrida;
begin
   Result := TCorrida.Create(TUUID.Gerar, pIDDoPassageiro, '',
                             TStatusCorrida.Solicitada, 0, 0,
                             pDeLatitude, pDeLongitude,
                             pParaLatitude, pParaLongitude,
                             Now);
end;

class function TCorrida.Restaurar(pID, pIDDoPassageiro, pIDDoMotorista: String;
  pStatus: TStatusCorrida; pTarifa, pDistancia, pDeLatitude, pDeLongitude,
  pParaLatitude, pParaLongitude: Double; pData: TDateTime): TCorrida;
begin
   Result := TCorrida.Create(pID, pIDDoPassageiro, pIDDoMotorista,
                             pStatus, pTarifa, pDistancia,
                             pDeLatitude, pDeLongitude,
                             pParaLatitude, pParaLongitude,
                             pData);
end;

procedure TCorrida.Aceitar(pIDDoMotorista: string);
begin
   FStatus := FStatus.TransicaoPara(TStatusCorrida.Aceita);
   if Assigned(FIDDoMotorista) then
      FIDDoMotorista.Destroy;
   FIDDoMotorista := TUUID.Create(pIDDoMotorista);
end;

procedure TCorrida.Iniciar(pIDDoMotorista: string);
var lID: TUUID;
begin
   lID := TUUID.Create(pIDDoMotorista);
   try
      FStatus := FStatus.TransicaoPara(TStatusCorrida.Iniciada);
      if not FIDDoMotorista.Valor.Equals(lID.Valor) then
         raise EOutroMotorista.Create('Corrida já aceita por outro motorista!');
   finally
      lID.Destroy;
   end;
end;

function TCorrida.ObterID: String;
begin
   Result := FID.Valor;
end;

function TCorrida.ObterIDDoPassageiro: String;
begin
   Result := FIDDoPassageiro.Valor;
end;

function TCorrida.ObterIDDoMotorista: String;
begin
   Result := '';
   if Assigned(FIDDoMotorista) then
      Result := FIDDoMotorista.Valor;
end;

end.
