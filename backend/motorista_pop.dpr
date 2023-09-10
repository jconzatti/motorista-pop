program motorista_pop;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  ContaUsuario.Servico in 'fontes\ContaUsuario.Servico.pas',
  Corrida.Servico in 'fontes\Corrida.Servico.pas',
  CPF.Validador in 'fontes\CPF.Validador.pas';

procedure ObterContaDeUsuario(Req: THorseRequest; Res: THorseResponse);
var
   lJSONUsuario: TJSONObject;
   lServicoContaUsuario: TServicoContaUsuario;
   lUsuario: TDadoContaUsuario;
begin
   lServicoContaUsuario := TServicoContaUsuario.Create;
   try
      lUsuario := lServicoContaUsuario.Obter(Req.Params['id']);
      lJSONUsuario := TJSONObject.Create;
      try
         lJSONUsuario.AddPair('id', lUsuario.ID);
         lJSONUsuario.AddPair('nome', lUsuario.Nome);
         lJSONUsuario.AddPair('email', lUsuario.Email);
         lJSONUsuario.AddPair('cpf', lUsuario.CPF);
         lJSONUsuario.AddPair('passageiro', TJSONBool.Create(lUsuario.Passageiro));
         lJSONUsuario.AddPair('motorista', TJSONBool.Create(lUsuario.Motorista));
         if lUsuario.Motorista then
            lJSONUsuario.AddPair('placa_carro', lUsuario.PlacaDoCarro);
         lJSONUsuario.AddPair('data', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', lUsuario.Data));
         Res.ContentType('application/json');
         Res.Send(lJSONUsuario.ToJSON);
      finally
         lJSONUsuario.Destroy;
      end;
   finally
      lServicoContaUsuario.Destroy;
   end;
end;

procedure ObterCorrida(Req: THorseRequest; Res: THorseResponse);
var
   lJSONCorrida, lJSONCoordenadasDeOrigem, lJSONCoordenadasDeDestino: TJSONObject;
   lServicoCorrida: TServicoCorrida;
   lCorrida: TDadoCorrida;
begin
   lServicoCorrida := TServicoCorrida.Create;
   try
      lCorrida := lServicoCorrida.Obter(Req.Params['id']);
      lJSONCorrida := TJSONObject.Create;
      try
         lJSONCorrida.AddPair('id', lCorrida.ID);
         lJSONCorrida.AddPair('id_passageiro', lCorrida.IDDoPassageiro);
         lJSONCorrida.AddPair('id_motorista', lCorrida.IDDoMotorista);
         lJSONCorrida.AddPair('status', lCorrida.Status);
         lJSONCorrida.AddPair('tarifa', TJSONNumber.Create(lCorrida.Tarifa));
         lJSONCorrida.AddPair('distancia', TJSONNumber.Create(lCorrida.Distancia));
         lJSONCoordenadasDeOrigem := TJSONObject.Create;
         lJSONCoordenadasDeOrigem.AddPair('latitude', TJSONNumber.Create(lCorrida.DeLatitude));
         lJSONCoordenadasDeOrigem.AddPair('longitude', TJSONNumber.Create(lCorrida.DeLongitude));
         lJSONCorrida.AddPair('coordenada_origem', lJSONCoordenadasDeOrigem);
         lJSONCoordenadasDeDestino := TJSONObject.Create;
         lJSONCoordenadasDeDestino.AddPair('latitude', TJSONNumber.Create(lCorrida.ParaLatitude));
         lJSONCoordenadasDeDestino.AddPair('longitude', TJSONNumber.Create(lCorrida.ParaLongitude));
         lJSONCorrida.AddPair('coordenada_destino', lJSONCoordenadasDeDestino);
         lJSONCorrida.AddPair('data', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', lCorrida.Data));
         Res.ContentType('application/json');
         Res.Send(lJSONCorrida.ToJSON);
      finally
         lJSONCorrida.Destroy;
      end;
   finally
      lServicoCorrida.Destroy;
   end;
end;

procedure SolicitarCorrida(Req: THorseRequest; Res: THorseResponse);
var
   lJSONSolicitacaoCorrida, lJSONCoordenadas: TJSONObject;
   lServicoCorrida: TServicoCorrida;
   lEntradaSolicitacaoCorrida: TDadoSolicitacaoCorrida;
begin
   lJSONSolicitacaoCorrida := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));
   try
      lEntradaSolicitacaoCorrida.IDDoPassageiro := lJSONSolicitacaoCorrida.GetValue<String>('id_passageiro');
      lJSONCoordenadas := lJSONSolicitacaoCorrida.GetValue<TJSONObject>('coordenada_origem');
      lEntradaSolicitacaoCorrida.DeLatitude  := lJSONCoordenadas.GetValue<Double>('latitude');
      lEntradaSolicitacaoCorrida.DeLongitude := lJSONCoordenadas.GetValue<Double>('longitude');
      lJSONCoordenadas := lJSONSolicitacaoCorrida.GetValue<TJSONObject>('coordenada_destino');
      lEntradaSolicitacaoCorrida.ParaLatitude  := lJSONCoordenadas.GetValue<Double>('latitude');
      lEntradaSolicitacaoCorrida.ParaLongitude := lJSONCoordenadas.GetValue<Double>('longitude');
      lServicoCorrida := TServicoCorrida.Create;
      try
         Res.ContentType('plain/text');
         Res.Send(lServicoCorrida.Solicitar(lEntradaSolicitacaoCorrida));
      finally
         lServicoCorrida.Destroy;
      end;
   finally
      lJSONSolicitacaoCorrida.Destroy;
   end;
end;

procedure IniciarServidor;
begin
   Writeln(Format('Servidor executando em %s:%d', [THorse.Host, THorse.Port]));
   Readln;
end;

begin
   ReportMemoryLeaksOnShutdown := True;
   THorse.Get('/usuario/:id', ObterContaDeUsuario);
   THorse.Get('/corrida/:id', ObterCorrida);
   THorse.Post('/corrida/solicitar', SolicitarCorrida);
   THorse.Listen(9000, IniciarServidor);
end.
