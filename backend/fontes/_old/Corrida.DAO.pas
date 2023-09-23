unit Corrida.DAO;

interface

uses
   System.Generics.Collections;

type
   TDadoSolicitacaoCorrida = record
      IDDoPassageiro: String;
      DeLatitude: Double;
      DeLongitude: Double;
      ParaLatitude: Double;
      ParaLongitude: Double;
   end;

   TDadoCorrida = record
      ID: String;
      IDDoPassageiro: String;
      IDDoMotorista: String;
      Status: String;
      Tarifa: Double;
      Distancia: Double;
      DeLatitude: Double;
      DeLongitude: Double;
      ParaLatitude: Double;
      ParaLongitude: Double;
      Data: TDateTime;
   end;

   TListaDeCorridas = TList<TDadoCorrida>;

   TDAOCorrida = class abstract
   public
      procedure Salvar(pDadoCorrida: TDadoCorrida); virtual; abstract;
      procedure Atualizar(pDadoCorrida: TDadoCorrida); virtual; abstract;
      function ObterPorID(pID: String): TDadoCorrida; virtual; abstract;
      function ObterListaDeCorridasAtivasPeloIDDoPassageiro(pIDDoPassageiro: String): TListaDeCorridas; virtual; abstract;
      function ObterListaDeCorridasAtivasPeloIDDoMotorista(pIDDoMotorista: String): TListaDeCorridas; virtual; abstract;
   end;

implementation

end.
