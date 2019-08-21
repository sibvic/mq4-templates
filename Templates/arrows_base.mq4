// Arrows base v1.1

#property copyright "Copyright © 2019, "
#property link      ""
#property version   "1.0"
#property strict
#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 8

enum DisplayType
{
   Arrows, // Arrows
   Candles // Candles Color
};
input DisplayType Type = Arrows; // Presentation Type
input color up_color = Green; // Up color
input color down_color = Red; // Down color

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

#include <conditions/ICondition.mq4>
#include <InstrumentInfo.mq4>
#include <conditions/ABaseCondition.mq4>
#include <Streams/IStream.mq4>
#include <Streams/AStream.mq4>
#include <Streams/PriceStream.mq4>
#include <condition.mq4>
#include <signaler.mq4>
#include <AlertSignal.mq4>
#include <Streams/CandleStreams.mq4>

AlertSignal* up;
AlertSignal* down;
Signaler* mainSignaler;

class UpAlertCondition : public ABaseCondition
{
public:
   UpAlertCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

class DownAlertCondition : public ABaseCondition
{
public:
   DownAlertCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      //TODO: implement
      return false;
   }
};

int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }
   IndicatorName = GenerateIndicatorName("...");
   IndicatorObjPrefix = "__" + IndicatorName + "__";
   IndicatorShortName(IndicatorName);

   ICondition* upCondition = Complet ? new UpAlertConditionComplet(_Symbol, (ENUM_TIMEFRAMES)_Period) : new UpAlertCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
   ICondition* downCondition = Complet ? new DownAlertConditionComplet(_Symbol, (ENUM_TIMEFRAMES)_Period) : new DownAlertCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
   up = new AlertSignal(upCondition, mainSignaler);
   down = new AlertSignal(downCondition, mainSignaler);
      
   int id = 0;
   if (Type == Arrows)
   {
      PriceStream* highStream = new PriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceHigh);
      PriceStream* lowStream = new PriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceLow);
      id = up.RegisterStreams(id, "Up", 217, up_color, highStream);
      id = down.RegisterStreams(id, "Down", 218, down_color, lowStream);
      lowStream.Release();
      highStream.Release();
   }
   else
   {
      id = up.RegisterStreams(id, "Up", up_color);
      id = down.RegisterStreams(id, "Down", down_color);
   }

   return 0;
}

int deinit()
{
   delete mainSignaler;
   mainSignaler = NULL;
   delete up;
   up = NULL;
   delete down;
   down = NULL;
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   return 0;
}

int start()
{
   if (Bars <= 1) 
      return 0;
   int ExtCountedBars = IndicatorCounted();
   if (ExtCountedBars < 0) 
      return -1;
   int limit = ExtCountedBars > 1 ? Bars - ExtCountedBars - 1 : Bars - 1;
   for (int pos = limit; pos >= 0; --pos)
   {
      up.Update(pos);
      down.Update(pos);
   } 
   return 0;
}