unit BancoDeDado.Conexao;

interface

uses
   Data.DB;

type
   TConexaoBancoDeDado = class abstract
   protected
      function ObterDataSet: TDataSet; virtual; abstract;
   public
      procedure Executar(const pComandoSQL: String; const pListaParametro: array of Variant; const pListaTipo: array of TFieldType); overload; virtual; abstract;
      procedure Executar(const pComandoSQL: String; const pListaParametro: array of Variant); overload;
      procedure Executar(const pComandoSQL: String); overload;
      function TentaExecutar(const pComandoSQL: String; const pListaParametro: array of Variant; const pListaTipo: array of TFieldType): Boolean; overload;
      function TentaExecutar(const pComandoSQL: String; const pListaParametro: array of Variant): Boolean; overload;
      function TentaExecutar(const pComandoSQL: String): Boolean; overload;
      property DataSet: TDataSet read ObterDataSet;
   end;

implementation

procedure TConexaoBancoDeDado.Executar(const pComandoSQL: String; const pListaParametro: array of Variant);
begin
   Executar(pComandoSQL, pListaParametro, []);
end;

procedure TConexaoBancoDeDado.Executar(const pComandoSQL: String);
begin
   Executar(pComandoSQL, []);
end;

function TConexaoBancoDeDado.TentaExecutar(const pComandoSQL: String; const pListaParametro: array of Variant; const pListaTipo: array of TFieldType): Boolean;
begin
   try
      Executar(pComandoSQL, pListaParametro, pListaTipo);
      Result := True;
   except
      Result := False;
   end;
end;

function TConexaoBancoDeDado.TentaExecutar(const pComandoSQL: String; const pListaParametro: array of Variant): Boolean;
begin
   Result := TentaExecutar(pComandoSQL, pListaParametro, []);
end;

function TConexaoBancoDeDado.TentaExecutar(const pComandoSQL: String): Boolean;
begin
   Result := TentaExecutar(pComandoSQL, []);
end;

end.
