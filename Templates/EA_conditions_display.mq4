// EA condition display v1.0

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

int init()
{
   IndicatorBuffers(21);

   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   int size = ArraySize(conditions);
   ArrayResize(conditions, size + 3);

   int id = 0;

   LongCondition* longCondition1 = new LongCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
   ShortCondition* shortCondition1 = new ShortCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
   conditions[0] = new HeatMapValueCalculator(1, longCondition1, shortCondition1);
   id = conditions[0].RegisterStreams(id, up_color, dn_color, ne_color, "...");

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
   int counted_bars = IndicatorCounted();
   int limit = Bars - counted_bars - 1;
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
