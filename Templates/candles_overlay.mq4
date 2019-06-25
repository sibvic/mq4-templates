// Bar overlay template v1.0

#property copyright "Copyright © 2019, ProfitRobots"
#property link      "https://github.com/sibvic/mq4-templates"
#property strict

#property indicator_chart_window
#property indicator_buffers 8
extern color Top_color = Green; // Top Color
extern color Bottom_color = Red; // Bottom Color

#include "CandleStreams.mq4"

CandleStreams Top;
CandleStreams Bottom;

int init()
{
   IndicatorShortName("...");
   IndicatorDigits(Digits);

   int id = Top.RegisterStreams(0, Top_color);
   id = Bottom.RegisterStreams(id, Bottom_color);
   
   return 0;
}

int deinit()
{
   return 0;
}

int start()
{
   if (Bars <= 3) 
      return 0;
   int ExtCountedBars = IndicatorCounted();
   if (ExtCountedBars < 0) 
      return -1;
   int limit = Bars - 2;
   if (ExtCountedBars > 2)
      limit = Bars - ExtCountedBars - 1;

   int pos = limit;
   while (pos >= 0)
   {
      Top.Clear(pos);
      Bottom.Clear(pos);
      if (true)
         Top.Set(pos, Open[pos], High[pos], Low[pos], Close[pos]);
      else
         Bottom.Set(pos, Open[pos], High[pos], Low[pos], Close[pos]);
   
      pos--;
   }
   return 0;
}

