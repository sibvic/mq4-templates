// Heatmap v1.0

#property version   "1.0"
#property indicator_separate_window
#property strict
#property indicator_buffers 27

input bool Include_M1 = false; // Include M1
input bool Include_M5 = false; // Include M5
input bool Include_M15 = false; // Include M15
input bool Include_M30 = false; // Include M30
input bool Include_H1 = true; // Include H1
input bool Include_H4 = false; // Include H4
input bool Include_D1 = true; // Include D1
input bool Include_W1 = true; // Include W1
input bool Include_MN1 = false; // Include MN1
input color up_color = Green; // Up color
input color dn_color = Red; // Down color
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
      int index = period == 0 ? 0 : iBarShift(_symbol, _timeframe, date);
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
      int index = period == 0 ? 0 : iBarShift(_symbol, _timeframe, date);
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
   if (Include_M1)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_M1), 
         new ShortCondition(_Symbol, PERIOD_M1));
   }
   if (Include_M5)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_M5), 
         new ShortCondition(_Symbol, PERIOD_M5));
   }
   if (Include_M15)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_M15), 
         new ShortCondition(_Symbol, PERIOD_M15));
   }
   if (Include_M30)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_M30), 
         new ShortCondition(_Symbol, PERIOD_M30));
   }
   if (Include_H1)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_H1), 
         new ShortCondition(_Symbol, PERIOD_H1));
   }
   if (Include_H4)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_H4), 
         new ShortCondition(_Symbol, PERIOD_H4));
   }
   if (Include_D1)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_D1), 
         new ShortCondition(_Symbol, PERIOD_D1));
   }
   if (Include_W1)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_W1), 
         new ShortCondition(_Symbol, PERIOD_W1));
   }
   if (Include_MN1)
   {
      id = CreateHeatmap(id, index--, "...", 
         new LongCondition(_Symbol, PERIOD_MN1), 
         new ShortCondition(_Symbol, PERIOD_MN1));
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
