// EA condition display v1.2

#property version   "1.0"
#property indicator_separate_window
#property strict
#property indicator_buffers 21

input color up_color = Green; // Up color
input color dn_color = Red; // Down color
input color pos_color = Blue; // Positive color
input color ne_color = Gray; // Neutral color

#include <HeatMapValueCalculator.mq4>

IHeatMapValueCalculator* conditions[];

string IndicatorObjPrefix;

bool NamesCollision(const string name)
{
   for (int k = ObjectsTotal(); k >= 0; k--)
   {
      if (StringFind(ObjectName(0, k), name) == 0)
      {
         return true;
      }
   }
   return false;
}

string GenerateIndicatorPrefix(const string target)
{
   for (int i = 0; i < 1000; ++i)
   {
      string prefix = target + "_" + IntegerToString(i);
      if (!NamesCollision(prefix))
      {
         return prefix;
      }
   }
   return target;
}

#include <Conditions/ACondition.mq4>

class LongCondition : public ACondition
{
public:
   LongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ShortCondition : public ACondition
{
public:
   ShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

int CreateHeatmap(int id, int index, string name, ICondition* longCondition, ICondition* shortCondition)
{
   HeatMapValueCalculator* calc = new HeatMapValueCalculator(index + 1, longCondition, shortCondition);
   longCondition.Release();
   shortCondition.Release();
   conditions[index] = calc;
   return calc.RegisterStreams(id, up_color, dn_color, ne_color, name);
}

int CreateHeatmap(int id, int index, string name, ICondition* condition)
{
   SingleHeatMapValueCalculator* calc = new SingleHeatMapValueCalculator(index + 1, condition);
   condition.Release();
   conditions[index] = calc;
   return calc.RegisterStreams(id, pos_color, ne_color, name);
}

int init()
{
   IndicatorObjPrefix = GenerateIndicatorPrefix("indi_short");
   IndicatorShortName("...");

   int rows = 3;
   int size = ArraySize(conditions);
   ArrayResize(conditions, size + rows);
   IndicatorBuffers(3 * rows);

   int id = 0;
   int index = rows - 1;

   {
      MultiHeatMapValueCalculator* calc = new MultiHeatMapValueCalculator(index + 1);
      conditions[index] = calc;
      id = calc.RegisterStreams(id, up_color, new LongCondition(_Symbol, (ENUM_TIMEFRAMES)_Period), name);
   }
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, (ENUM_TIMEFRAMES)_Period), 
         new ShortCondition(_Symbol, (ENUM_TIMEFRAMES)_Period));
   }
   {
      id = CreateHeatmap(id, index--, "...", new LongCondition(_Symbol, (ENUM_TIMEFRAMES)_Period));
   }

   return 0;
}

int deinit()
{
   for (int i = 0; i < ArraySize(conditions); ++i)
   {
      delete conditions[i];
   }
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   return 0;
}

int start()
{
   int minBars = 1;
   int limit = MathMin(Bars - 1 - minBars, Bars - IndicatorCounted() - 1);
   for (int i = limit; i >= 0; i--)
   {
      for (int conditionIndex = 0; conditionIndex < ArraySize(conditions); ++conditionIndex)
      {
         conditions[conditionIndex].UpdateValue(i);
      }
   }
   return 0;
}
