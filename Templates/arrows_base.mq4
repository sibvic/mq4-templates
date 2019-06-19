#property copyright "Copyright © 2019, "
#property link      ""
#property version   "1.0"
#property strict
#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 2

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

#include "InstrumentInfo.mq4"
#include "Streams/IStream.mq4"
#include "Streams/AStream.mq4"
#include "Streams/PriceStream.mq4"
#include "condition.mq4"
#include "signaler.mq4"
#include "AlertSignal.mq4"

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

   mainSignaler = new Signaler(_Symbol, (ENUM_TIMEFRAMES)_Period);
   PriceStream* highStream = new PriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceHigh);
   PriceStream* lowStream = new PriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceLow);

   int id = 0;
   up = new AlertSignal(new UpAlertCondition(_Symbol, (ENUM_TIMEFRAMES)_Period), highStream, mainSignaler);
   id = up.RegisterStreams(id, "Up", 218, Red);
   down = new AlertSignal(new DownAlertCondition(_Symbol, (ENUM_TIMEFRAMES)_Period), lowStream, mainSignaler);
   id = down.RegisterStreams(id, "Down", 217, Green);
   lowStream.Release();
   highStream.Release();

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