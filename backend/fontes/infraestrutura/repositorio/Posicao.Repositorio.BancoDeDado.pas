unit Posicao.Repositorio.BancoDeDado;

interface

uses
   System.SysUtils,
   Data.DB,
   BancoDeDado.Conexao,
   Posicao,
   Posicao.Repositorio,
   UUID;

type
   TRepositorioPosicaoBancoDeDado = class(TRepositorioPosicao)
   private
      FConexaoBancoDeDado: TConexaoBancoDeDado;
   public
      procedure Salvar(pPosicao: TPosicao); override;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: TUUID): TListaDePosicoes; override;
      constructor Create(pConexaoBancoDeDado: TConexaoBancoDeDado); reintroduce;
   end;

implementation

{ TRepositorioPosicaoBancoDeDado }

constructor TRepositorioPosicaoBancoDeDado.Create(pConexaoBancoDeDado: TConexaoBancoDeDado);
begin
   FConexaoBancoDeDado := pConexaoBancoDeDado;
end;

procedure TRepositorioPosicaoBancoDeDado.Salvar(pPosicao: TPosicao);
begin
   inherited;
   FConexaoBancoDeDado.Executar('INSERT INTO position ('+
                                '    position_id,'+
                                '    ride_id,'+
                                '    lat,'+
                                '    long,'+
                                '    date'+
                                ') VALUES ('+
                                '    :position_id,'+
                                '    :ride_id,'+
                                '    :lat,'+
                                '    :long,'+
                                '    :date'+
                                ')',
                                [pPosicao.ID,
                                 pPosicao.IDDaCorrida,
                                 pPosicao.Coordenada.Latitude,
                                 pPosicao.Coordenada.Longitude,
                                 pPosicao.Data],
                                [ftString,
                                 ftString,
                                 ftFloat,
                                 ftFloat,
                                 ftFloat]);
end;

function TRepositorioPosicaoBancoDeDado.ObterListaDePosicoesDaCorrida(pIDDaCorrida: TUUID): TListaDePosicoes;
begin
   Result := TListaDePosicoes.Create;
   try
      FConexaoBancoDeDado.Executar('SELECT position_id, ride_id, lat, long, date FROM position '+
                                   'WHERE ride_id = :ride_id order by date',
                                   [pIDDaCorrida.Valor], [ftString]);
      FConexaoBancoDeDado.DataSet.First;
      while not FConexaoBancoDeDado.DataSet.Eof do
      begin
         Result.Add(TPosicao.Restaurar(FConexaoBancoDeDado.DataSet.FieldByName('position_id').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('ride_id').AsString,
                                       FConexaoBancoDeDado.DataSet.FieldByName('lat').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('long').AsFloat,
                                       FConexaoBancoDeDado.DataSet.FieldByName('date').AsFloat));
         FConexaoBancoDeDado.DataSet.Next;
      end;
      if Result.Count = 0 then
         raise ENehumaPosicaoEncontrada.Create(Format('Nenhuma posição da corrida (ID %s) encontrada!', [pIDDaCorrida.Valor]));
   except
      Result.Destroy;
      raise;
   end;
end;

end.
