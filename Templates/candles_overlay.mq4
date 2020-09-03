// Bar overlay template v1.2

#property copyright "Copyright © 2019, ProfitRobots"
#property link      "https://github.com/sibvic/mq4-templates"
#property strict

#property indicator_chart_window
#property indicator_buffers 8
input color Top_color = Green; // Top Color
input color Bottom_color = Red; // Bottom Color

#include <streams/CandleStreams.mq4>

CandleStreams Top;
CandleStreams Bottom;

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

int init()
{
   IndicatorObjPrefix = GenerateIndicatorPrefix("indi_short");
   IndicatorShortName("...");
   IndicatorDigits(Digits);

   int id = Top.RegisterStreams(0, Top_color);
   id = Bottom.RegisterStreams(id, Bottom_color);
   
   return 0;
}

int deinit()
{
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   return 0;
}

int start()
{
   int counted_bars = IndicatorCounted();
   int minBars = 1;
   int limit = MathMin(Bars - 1 - minBars, Bars - counted_bars - 1);
   for (int pos = limit; pos >= 0; pos--)
   {
      Top.Clear(pos);
      Bottom.Clear(pos);
      if (true)
         Top.Set(pos, Open[pos], High[pos], Low[pos], Close[pos]);
      else
         Bottom.Set(pos, Open[pos], High[pos], Low[pos], Close[pos]);
   }
   return 0;
}

