program motorista_pop;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  ContaUsuario.Servico in 'fontes\ContaUsuario.Servico.pas',
  Corrida.Servico in 'fontes\Corrida.Servico.pas',
  CPF.Validador in 'fontes\CPF.Validador.pas',
  ContaUsuario.DAO.FireDAC in 'fontes\ContaUsuario.DAO.FireDAC.pas',
  ContaUsuario.DAO in 'fontes\ContaUsuario.DAO.pas',
  Corrida.DAO.FireDAC in 'fontes\Corrida.DAO.FireDAC.pas',
  Corrida.DAO in 'fontes\Corrida.DAO.pas',
  Email.Enviador.Gateway in 'fontes\Email.Enviador.Gateway.pas';

var
   FDAOContaUsuario: TDAOContaUsuario;
   FDAOCorrida: TDAOCorrida;
   FServicoContaUsuario: TServicoContaUsuario;
   FServicoCorrida: TServicoCorrida;

procedure CriarContaDeUsuario(Req: THorseRequest; Res: THorseResponse);
var
   lJSONUsuario, lJSONErro: TJSONObject;
   lInscricaoUsuario: TDadoInscricaoContaUsuario;
begin
   try
      lJSONUsuario := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));
      try
         lInscricaoUsuario.Nome       := lJSONUsuario.GetValue<String>('nome');
         lInscricaoUsuario.Email      := lJSONUsuario.GetValue<String>('email');
         lInscricaoUsuario.CPF        := lJSONUsuario.GetValue<String>('cpf');
         lInscricaoUsuario.Passageiro := lJSONUsuario.GetValue<Boolean>('passageiro');
         lInscricaoUsuario.Motorista  := lJSONUsuario.GetValue<Boolean>('motorista');
         lJSONUsuario.TryGetValue<String>('placa_carro', lInscricaoUsuario.PlacaDoCarro);
         Res.ContentType('plain/text');
         Res.Send(FServicoContaUsuario.Inscrever(lInscricaoUsuario));
         Res.Status(201);
      finally
         lJSONUsuario.Destroy;
      end;
   except
      on E: Exception do
      begin
         lJSONErro := TJSONObject.Create;
         try
            lJSONErro.AddPair('mensagem', E.Message);
            lJSONErro.AddPair('classe', E.ClassName);
            lJSONErro.AddPair('tipo', 'erro');
            Res.ContentType('application/json');
            Res.Status(500);
            Res.Send(lJSONErro.ToJSON);
         finally
            lJSONErro.Destroy;
         end;
      end;
   end;
end;

procedure ObterContaDeUsuario(Req: THorseRequest; Res: THorseResponse);
var
   lJSONUsuario: TJSONObject;
   lUsuario: TDadoContaUsuario;
begin
   lUsuario := FServicoContaUsuario.Obter(Req.Params['id']);
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
end;

procedure ObterCorrida(Req: THorseRequest; Res: THorseResponse);
var
   lJSONCorrida, lJSONCoordenadasDeOrigem, lJSONCoordenadasDeDestino: TJSONObject;
   lCorrida: TDadoCorrida;
begin
   lCorrida := FServicoCorrida.Obter(Req.Params['id']);
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
end;

procedure SolicitarCorrida(Req: THorseRequest; Res: THorseResponse);
var
   lJSONSolicitacaoCorrida, lJSONCoordenadas, lJSONErro: TJSONObject;
   lEntradaSolicitacaoCorrida: TDadoSolicitacaoCorrida;
begin
   try
      lJSONSolicitacaoCorrida := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));
      try
         lEntradaSolicitacaoCorrida.IDDoPassageiro := lJSONSolicitacaoCorrida.GetValue<String>('id_passageiro');
         lJSONCoordenadas := lJSONSolicitacaoCorrida.GetValue<TJSONObject>('coordenada_origem');
         lEntradaSolicitacaoCorrida.DeLatitude  := lJSONCoordenadas.GetValue<Double>('latitude');
         lEntradaSolicitacaoCorrida.DeLongitude := lJSONCoordenadas.GetValue<Double>('longitude');
         lJSONCoordenadas := lJSONSolicitacaoCorrida.GetValue<TJSONObject>('coordenada_destino');
         lEntradaSolicitacaoCorrida.ParaLatitude  := lJSONCoordenadas.GetValue<Double>('latitude');
         lEntradaSolicitacaoCorrida.ParaLongitude := lJSONCoordenadas.GetValue<Double>('longitude');
         Res.ContentType('plain/text');
         Res.Send(FServicoCorrida.Solicitar(lEntradaSolicitacaoCorrida));
      finally
         lJSONSolicitacaoCorrida.Destroy;
      end;
   except
      on E: Exception do
      begin
         lJSONErro := TJSONObject.Create;
         try
            lJSONErro.AddPair('mensagem', E.Message);
            lJSONErro.AddPair('classe', E.ClassName);
            lJSONErro.AddPair('tipo', 'erro');
            Res.ContentType('application/json');
            Res.Status(500);
            Res.Send(lJSONErro.ToJSON);
         finally
            lJSONErro.Destroy;
         end;
      end;
   end;
end;

procedure IniciarServidor;
begin
   Writeln(Format('Servidor executando em %s:%d', [THorse.Host, THorse.Port]));
   Readln;
end;

begin
   ReportMemoryLeaksOnShutdown := True;

   FDAOContaUsuario     := TDAOContaUsuarioFireDAC.Create;
   FDAOCorrida          := TDAOCorridaFireDAC.Create;
   FServicoContaUsuario := TServicoContaUsuario.Create(FDAOContaUsuario);
   FServicoCorrida      := TServicoCorrida.Create(FDAOContaUsuario, FDAOCorrida);
   try
      THorse.Post('/usuario', CriarContaDeUsuario);
      THorse.Get('/usuario/:id', ObterContaDeUsuario);
      THorse.Get('/corrida/:id', ObterCorrida);
      THorse.Post('/corrida/solicitar', SolicitarCorrida);
      THorse.Listen(9000, IniciarServidor);
   finally
      FServicoCorrida.Destroy;
      FServicoContaUsuario.Destroy;
      FDAOCorrida.Destroy;
      FDAOContaUsuario.Destroy;
   end;
end.
