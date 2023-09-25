unit JSON.Conversor.Teste;

interface

uses
   System.SysUtils,
   System.DateUtils,
   System.JSON,
   System.Generics.Collections,
   JSON.Conversor,
   DUnitX.TestFramework;

type
   TSimples = record
      Codigo: Integer;
      Descricao: string;
      Valor: Double;
      Data: TDate;
      Hora: TTime;
      DataEHora: TDateTime;
   end;

   TComplexo = record
      Codigo: Integer;
      Simples: TSimples;
      ListaDeSimples: array of TSimples;
      ListaDeInteiros: array of Integer;
   end;

   [TestFixture]
   TConversorJSONTeste = class
   public
      [Test]
      procedure DeveConverterObjetoSimplesParaJSON;
      [Test]
      procedure DeveConverterObjetoComplexoParaJSON;
      [Test]
      procedure DeveConverterJSONParaObjetoSimples;
      [Test]
      procedure DeveConverterJSONParaObjetoComplexo;
   end;

implementation


{ TConversorJSONTeste }

procedure TConversorJSONTeste.DeveConverterObjetoSimplesParaJSON;
var lSimples: TSimples;
    lJSONSimples: TJSONValue;
    lConversorJSON: TConversorJSON;
begin
   lSimples.Codigo    := 5;
   lSimples.Descricao := 'Teste de descrição';
   lSimples.Valor     := 50.50;
   lSimples.Data      := Date;
   lSimples.Hora      := Time;
   lSimples.DataEHora := Now;
   lConversorJSON := TConversorJSON.Create;
   try
      lJSONSimples := lConversorJSON.ConverterParaJSON<TSimples>(lSimples);
      try
         Assert.AreEqual(lSimples.Codigo, lJSONSimples.GetValue<Integer>('Codigo'));
         Assert.AreEqual(lSimples.Descricao, lJSONSimples.GetValue<string>('Descricao'));
         Assert.AreEqual(lSimples.Valor, lJSONSimples.GetValue<double>('Valor'));
         Assert.AreEqual(lSimples.Data, lJSONSimples.GetValue<TDate>('Data'));
         Assert.AreEqual(lSimples.Hora, lJSONSimples.GetValue<TTime>('Hora'));
         Assert.AreEqual(lSimples.DataEHora, lJSONSimples.GetValue<TDateTime>('DataEHora'));
      finally
         lJSONSimples.Destroy;
      end;
   finally
      lConversorJSON.Destroy;
   end;
end;

procedure TConversorJSONTeste.DeveConverterObjetoComplexoParaJSON;
var lComplexo: TComplexo;
    lJSONComplexo, lJSONSimples: TJSONValue;
    lJSONArrayDeSimples, lJSONArrayDeInteiros: TJSONArray;
    lConversorJSON: TConversorJSON;
begin
   lComplexo.Codigo            := 10;
   lComplexo.Simples.Codigo    := 5;
   lComplexo.Simples.Descricao := 'Teste de descrição';
   lComplexo.Simples.Valor     := 50.50;
   lComplexo.Simples.Data      := Date;
   lComplexo.Simples.Hora      := Time;
   lComplexo.Simples.DataEHora := Now;

   SetLength(lComplexo.ListaDeSimples, 3);

   lComplexo.ListaDeSimples[0].Codigo    := 6;
   lComplexo.ListaDeSimples[0].Descricao := 'Teste de descrição 1';
   lComplexo.ListaDeSimples[0].Valor     := 50.51;
   lComplexo.ListaDeSimples[0].Data      := Date;
   lComplexo.ListaDeSimples[0].Hora      := Time;
   lComplexo.ListaDeSimples[0].DataEHora := Now;

   lComplexo.ListaDeSimples[1].Codigo    := 7;
   lComplexo.ListaDeSimples[1].Descricao := 'Teste de descrição 2';
   lComplexo.ListaDeSimples[1].Valor     := 50.52;
   lComplexo.ListaDeSimples[1].Data      := Date;
   lComplexo.ListaDeSimples[1].Hora      := Time;
   lComplexo.ListaDeSimples[1].DataEHora := Now;

   lComplexo.ListaDeSimples[2].Codigo    := 8;
   lComplexo.ListaDeSimples[2].Descricao := 'Teste de descrição 3';
   lComplexo.ListaDeSimples[2].Valor     := 50.53;
   lComplexo.ListaDeSimples[2].Data      := Date;
   lComplexo.ListaDeSimples[2].Hora      := Time;
   lComplexo.ListaDeSimples[2].DataEHora := Now;

   SetLength(lComplexo.ListaDeInteiros, 6);
   lComplexo.ListaDeInteiros[0] := 828;
   lComplexo.ListaDeInteiros[1] := 309;
   lComplexo.ListaDeInteiros[2] := 910;
   lComplexo.ListaDeInteiros[3] := 777;
   lComplexo.ListaDeInteiros[4] := 869;
   lComplexo.ListaDeInteiros[5] := 210;

   lConversorJSON := TConversorJSON.Create;
   try
      lJSONComplexo := lConversorJSON.ConverterParaJSON<TComplexo>(lComplexo);
      try
         Assert.AreEqual(lComplexo.Codigo, lJSONComplexo.GetValue<Integer>('Codigo'));

         lJSONSimples := lJSONComplexo.GetValue<TJSONValue>('Simples');
         Assert.AreEqual(lComplexo.Simples.Codigo, lJSONSimples.GetValue<Integer>('Codigo'));
         Assert.AreEqual(lComplexo.Simples.Descricao, lJSONSimples.GetValue<string>('Descricao'));
         Assert.AreEqual(lComplexo.Simples.Valor, lJSONSimples.GetValue<double>('Valor'));
         Assert.AreEqual(lComplexo.Simples.Data, lJSONSimples.GetValue<TDate>('Data'));
         Assert.AreEqual(lComplexo.Simples.Hora, lJSONSimples.GetValue<TTime>('Hora'));
         Assert.AreEqual(lComplexo.Simples.DataEHora, lJSONSimples.GetValue<TDateTime>('DataEHora'));

         lJSONArrayDeSimples := lJSONComplexo.GetValue<TJSONArray>('ListaDeSimples');
         Assert.AreEqual(3, lJSONArrayDeSimples.Count);

         lJSONArrayDeInteiros := lJSONComplexo.GetValue<TJSONArray>('ListaDeInteiros');
         Assert.AreEqual(6, lJSONArrayDeInteiros.Count);
      finally
         lJSONComplexo.Destroy;
      end;
   finally
      lConversorJSON.Destroy;
   end;
end;

procedure TConversorJSONTeste.DeveConverterJSONParaObjetoSimples;
var lSimples: TSimples;
    lJSONSimples: TJSONObject;
    lConversorJSON: TConversorJSON;
begin
   lJSONSimples := TJSONObject.Create;
   try
      lJSONSimples.AddPair('Codigo', TJSONNumber.Create(555));
      lJSONSimples.AddPair('Descricao', 'Teste de descrição');
      lJSONSimples.AddPair('Valor', TJSONNumber.Create(555.55));
      lJSONSimples.AddPair('Data', DateToISO8601(StrToDateDef('24/09/2023', Date)));
      lJSONSimples.AddPair('Hora', DateToISO8601(StrToTimeDef('10:15:30', Time)));
      lJSONSimples.AddPair('DataEHora', DateToISO8601(StrToDateTimeDef('24/09/2023 10:15:30', Now)));
      lConversorJSON := TConversorJSON.Create;
      try
         lSimples := lConversorJSON.ConverterParaObjeto<TSimples>(lJSONSimples);
         Assert.AreEqual(555, lSimples.Codigo);
         Assert.AreEqual('Teste de descrição', lSimples.Descricao);
         Assert.AreEqual(555.55, lSimples.Valor);
         Assert.AreEqual('24/09/2023', FormatDateTime('dd/mm/yyyy', lSimples.Data));
         Assert.AreEqual('10:15:30', FormatDateTime('hh:nn:ss', lSimples.Hora));
         Assert.AreEqual('24/09/2023 10:15:30', FormatDateTime('dd/mm/yyyy hh:nn:ss', lSimples.DataEHora));
      finally
         lConversorJSON.Destroy;
      end;
   finally
      lJSONSimples.Destroy;
   end;
end;

procedure TConversorJSONTeste.DeveConverterJSONParaObjetoComplexo;
var lComplexo: TComplexo;
    lJSONComplexo, lJSONSimples: TJSONObject;
    lJSONArrayDeSimples, lJSONArrayDeInteiros: TJSONArray;
    lConversorJSON: TConversorJSON;
begin
   lJSONComplexo := TJSONObject.Create;
   try
      lJSONComplexo.AddPair('Codigo', TJSONNumber.Create(300));

      lJSONSimples := TJSONObject.Create;
      lJSONSimples.AddPair('Codigo', TJSONNumber.Create(555));
      lJSONSimples.AddPair('Descricao', 'Teste de descrição');
      lJSONSimples.AddPair('Valor', TJSONNumber.Create(555.55));
      lJSONSimples.AddPair('Data', DateToISO8601(StrToDateDef('24/09/2023', Date)));
      lJSONSimples.AddPair('Hora', DateToISO8601(StrToTimeDef('10:15:30', Time)));
      lJSONSimples.AddPair('DataEHora', DateToISO8601(StrToDateTimeDef('24/09/2023 10:15:30', Now)));
      lJSONComplexo.AddPair('Simples', lJSONSimples);

      lJSONArrayDeSimples := TJSONArray.Create;
      lJSONArrayDeSimples.AddElement(TJSONObject.Create);
      TJSONObject(lJSONArrayDeSimples.Items[0]).AddPair('Codigo', TJSONNumber.Create(78));
      lJSONArrayDeSimples.AddElement(TJSONObject.Create);
      TJSONObject(lJSONArrayDeSimples.Items[1]).AddPair('Codigo', TJSONNumber.Create(79));
      lJSONArrayDeSimples.AddElement(TJSONObject.Create);
      TJSONObject(lJSONArrayDeSimples.Items[2]).AddPair('Codigo', TJSONNumber.Create(80));
      lJSONComplexo.AddPair('ListaDeSimples', lJSONArrayDeSimples);

      lJSONArrayDeInteiros := TJSONArray.Create;
      lJSONArrayDeInteiros.AddElement(TJSONNumber.Create(1));
      lJSONArrayDeInteiros.AddElement(TJSONNumber.Create(2));
      lJSONArrayDeInteiros.AddElement(TJSONNumber.Create(3));
      lJSONArrayDeInteiros.AddElement(TJSONNumber.Create(4));
      lJSONArrayDeInteiros.AddElement(TJSONNumber.Create(5));
      lJSONComplexo.AddPair('ListaDeInteiros', lJSONArrayDeInteiros);

      lConversorJSON := TConversorJSON.Create;
      try
         lComplexo := lConversorJSON.ConverterParaObjeto<TComplexo>(lJSONComplexo);
         Assert.AreEqual(300, lComplexo.Codigo);
         Assert.AreEqual(555, lComplexo.Simples.Codigo);
         Assert.AreEqual('Teste de descrição', lComplexo.Simples.Descricao);
         Assert.AreEqual(555.55, lComplexo.Simples.Valor);
         Assert.AreEqual('24/09/2023', FormatDateTime('dd/mm/yyyy', lComplexo.Simples.Data));
         Assert.AreEqual('10:15:30', FormatDateTime('hh:nn:ss', lComplexo.Simples.Hora));
         Assert.AreEqual('24/09/2023 10:15:30', FormatDateTime('dd/mm/yyyy hh:nn:ss', lComplexo.Simples.DataEHora));
         Assert.AreEqual<Integer>(3, Length(lComplexo.ListaDeSimples));
         Assert.AreEqual(78, lComplexo.ListaDeSimples[0].Codigo);
         Assert.AreEqual(79, lComplexo.ListaDeSimples[1].Codigo);
         Assert.AreEqual(80, lComplexo.ListaDeSimples[2].Codigo);
         Assert.AreEqual<Integer>(5, Length(lComplexo.ListaDeInteiros));
         Assert.AreEqual(1, lComplexo.ListaDeInteiros[0]);
         Assert.AreEqual(2, lComplexo.ListaDeInteiros[1]);
         Assert.AreEqual(3, lComplexo.ListaDeInteiros[2]);
         Assert.AreEqual(4, lComplexo.ListaDeInteiros[3]);
         Assert.AreEqual(5, lComplexo.ListaDeInteiros[4]);
      finally
         lConversorJSON.Destroy;
      end;
   finally
      lJSONComplexo.Destroy;
   end;
end;

initialization
   TDUnitX.RegisterTestFixture(TConversorJSONTeste);
end.
