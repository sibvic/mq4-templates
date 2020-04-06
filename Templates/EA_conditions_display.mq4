// EA condition display v1.2

#property version   "1.0"
#property indicator_separate_window
#property strict
#property indicator_buffers 21

input color up_color = Green; // Up color
input color dn_color = Red; // Down color
input color ne_color = Gray; // Neutral color

#include <HeatMapValueCalculator.mq4>

HeatMapValueCalculator* conditions[];

string IndicatorName;
string IndicatorObjPrefix;

string GenerateIndicatorName(const string target)
{
   string name = target;
   int try = 2;
   while (WindowFind(name) != -1)
   {
      name = target + " #" + IntegerToString(try++);
   }
   return name;
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

int init()
{
   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   int rows = 3;
   int size = ArraySize(conditions);
   ArrayResize(conditions, size + rows);
   IndicatorBuffers(3 * rows);

   int id = 0;
   int index = 0;

   {
      ICondition* longCondition1 = new LongCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
      ICondition* shortCondition1 = new ShortCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
      conditions[index] = new HeatMapValueCalculator(index + 1, longCondition1, shortCondition1);
      id = conditions[index].RegisterStreams(id, up_color, dn_color, ne_color, "...");
      ++index;
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
         HeatMapValueCalculator* condition = conditions[conditionIndex];
         condition.UpdateValue(i);
      }
   }
   return 0;
}
