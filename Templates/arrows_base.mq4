// Arrows base v5.2

#property version   "1.0"
#property strict
#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 8

#define ACT_ON_SWITCH

enum SingalMode
{
   SingalModeLive, // Live
   SingalModeOnBarClose // On bar close
};

enum DisplayType
{
   Arrows, // Arrows
   ArrowsOnMainChart, // Arrows on main chart
   Candles, // Candles color
   Lines // Lines
};
input SingalMode signal_mode = SingalModeLive; // Signal mode
input DisplayType Type = Arrows; // Presentation Type
input double shift_arrows_pips = 0.1; // Shift arrows
input color up_color = Blue; // Up color
input color down_color = Red; // Down color

#include <conditions/ACondition.mq4>
#include <conditions/ActOnSwitchCondition.mq4>
#include <Streams/PriceStream.mq4>
#include <signaler.mq4>
#include <AlertSignal.mq4>
#include <Streams/CandleStreams.mq4>
#include <Streams/StreamWrapper.mq4>

AlertSignal* conditions[];
Signaler* mainSignaler;
StreamWrapper* customStream;

int CreateAlert(int id, ICondition* condition, IAction* action, int code, string message, color clr, PriceType priceType, int sign)
{
   int size = ArraySize(conditions);
   ArrayResize(conditions, size + 1);
   #ifdef ACT_ON_SWITCH
      ActOnSwitchCondition* upSwitch = new ActOnSwitchCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, condition);
      condition = upSwitch;
   #endif
   conditions[size] = new AlertSignal(condition, action, _Symbol, (ENUM_TIMEFRAMES)_Period, mainSignaler, signal_mode == SingalModeOnBarClose);
   condition.Release();
      
   switch (Type)
   {
      case Arrows:
         {
            id = conditions[size].RegisterStreams(id, message, code, clr, customStream);
         }
         break;
      case ArrowsOnMainChart:
         {
            SimplePriceStream* highStream = new SimplePriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, priceType);
            highStream.SetShift(shift_arrows_pips * sign);
            static int lastId = 1;
            id = conditions[size].RegisterArrows(id, message, IndicatorObjPrefix + IntegerToString(lastId++), code, clr, highStream);
            highStream.Release();
         }
         break;
      case Candles:
         {
            id = conditions[size].RegisterStreams(id, message, clr);
         }
         break;
      case Lines:
         {
            id = conditions[size].RegisterLines(id, message, IndicatorObjPrefix + IntegerToString(id), clr);
         }
         break;
   }
   return id;
}

int CreateAlert(int id, ENUM_TIMEFRAMES tf, color upColor, color downColor)
{
   ICondition* upCondition = (ICondition*) new UpCondition(_Symbol, tf);
   ICondition* downCondition = (ICondition*) new DownCondition(_Symbol, tf);
   id = CreateAlert(id, upCondition, NULL, 217, "Up " + TimeframeToString(tf), upColor, PriceHigh, 1);
   id = CreateAlert(id, downCondition, NULL, 218, "Down " + TimeframeToString(tf), downColor, PriceLow, -1);
   upCondition.Release();
   downCondition.Release();
   return id;
}

class UpCondition : public ACondition
{
public:
   UpCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class DownCondition : public ACondition
{
public:
   DownCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};
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

string TimeframeToString(ENUM_TIMEFRAMES tf)
{
   switch (tf)
   {
      case PERIOD_M1: return "M1";
      case PERIOD_M5: return "M5";
      case PERIOD_D1: return "D1";
      case PERIOD_H1: return "H1";
      case PERIOD_H4: return "H4";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_MN1: return "MN1";
      case PERIOD_W1: return "W1";
   }
   return "";
}

int init()
{
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }
   IndicatorBuffers(8);
   IndicatorObjPrefix = GenerateIndicatorPrefix("indi_short");
   IndicatorShortName("...");
   mainSignaler = new Signaler();
   mainSignaler.SetMessagePrefix(_Symbol + "/" + TimeframeToString((ENUM_TIMEFRAMES)_Period) + ": ");

   int id = 0;

   if (Type == Arrows)
   {
      customStream = new StreamWrapper(_Symbol, (ENUM_TIMEFRAMES)_Period);
   }
   {
      ICondition* upCondition = (ICondition*) new UpCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
      ICondition* downCondition = (ICondition*) new DownCondition(_Symbol, (ENUM_TIMEFRAMES)_Period);
      id = CreateAlert(id, (ENUM_TIMEFRAMES)_Period, up_color, down_color);
   }
   if (customStream != NULL)
   {
      id = customStream.RegisterInternalStream(id);
   }

   return 0;
}

int deinit()
{
   if (customStream != NULL)
   {
      customStream.Release();
      customStream = NULL;
   }
   delete mainSignaler;
   mainSignaler = NULL;
   for (int i = 0; i < ArraySize(conditions); ++i)
   {
      delete conditions[i];
   }
   ArrayResize(conditions, 0);
   ObjectsDeleteAll(ChartID(), IndicatorObjPrefix);
   return 0;
}

int start()
{
   int counted_bars = IndicatorCounted();
   if (counted_bars <= 0 || counted_bars > Bars)
   {
      //TODO: initialize your streams here
      //ArrayInitialize(ll, EMPTY_VALUE);
      if (customStream != NULL)
      {
         customStream.Init();
      }
      for (int i = 0; i < ArraySize(conditions); ++i)
      {
         AlertSignal* item = conditions[i];
         item.Init();
      }
   }
   int minBars = 1;
   int limit = MathMin(Bars - 1 - minBars, Bars - counted_bars - 1);
   for (int pos = limit; pos >= 0 && !IsStopped(); --pos)
   {
      if (customStream != NULL)
      {
         customStream.SetValue(pos, Close[pos]);
      }
      for (int i = 0; i < ArraySize(conditions); ++i)
      {
         AlertSignal* item = conditions[i];
         item.Update(pos);
      }
   } 
   return 0;
}