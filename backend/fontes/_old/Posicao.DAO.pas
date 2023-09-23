unit Posicao.DAO;

interface

uses
   System.Generics.Collections;

type
   TDadoPosicao = record
      ID: String;
      IDDaCorrida: String;
      Latitude: Double;
      Longitude: Double;
      Data: TDateTime;
   end;

   TListaDePosicoes = TList<TDadoPosicao>;

   TDAOPosicao = class abstract
   public
      procedure Salvar(pPosicao: TDadoPosicao); virtual; abstract;
      function ObterListaDePosicoesDaCorrida(pIDDaCorrida: String): TListaDePosicoes; virtual; abstract;
   end;

implementation

end.
