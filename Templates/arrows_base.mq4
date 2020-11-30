// Arrows base v5.1

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
   Candles // Candles color
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

int CreateAlert(int id, ICondition* upCondition, IAction* upAction, ICondition* downCondition, IAction* downAction, int upCode, int downCode, string upMessage = "Up", string downMessage = "Down")
{
   int size = ArraySize(conditions);
   ArrayResize(conditions, size + 2);
   #ifdef ACT_ON_SWITCH
      ActOnSwitchCondition* upSwitch = new ActOnSwitchCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, upCondition);
      upCondition.Release();
      upCondition = upSwitch;
      ActOnSwitchCondition* downSwitch = new ActOnSwitchCondition(_Symbol, (ENUM_TIMEFRAMES)_Period, downCondition);
      downCondition.Release();
      downCondition = downSwitch;
   #endif
   conditions[size] = new AlertSignal(upCondition, upAction, _Symbol, (ENUM_TIMEFRAMES)_Period, mainSignaler, signal_mode == SingalModeOnBarClose);
   conditions[size + 1] = new AlertSignal(downCondition, downAction, _Symbol, (ENUM_TIMEFRAMES)_Period, mainSignaler, signal_mode == SingalModeOnBarClose);
      
   switch (Type)
   {
      case Arrows:
         {
            id = conditions[size].RegisterStreams(id, upMessage, upCode, up_color, customStream);
            id = conditions[size + 1].RegisterStreams(id, downMessage, downCode, down_color, customStream);
         }
         break;
      case ArrowsOnMainChart:
         {
            SimplePriceStream* highStream = new SimplePriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceHigh);
            highStream.SetShift(shift_arrows_pips);
            SimplePriceStream* lowStream = new SimplePriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceLow);
            lowStream.SetShift(-shift_arrows_pips);
            id = conditions[size].RegisterArrows(id, upMessage, IndicatorObjPrefix + "_up", upCode, up_color, highStream);
            id = conditions[size + 1].RegisterArrows(id, downMessage, IndicatorObjPrefix + "_down", downCode, down_color, lowStream);
            lowStream.Release();
            highStream.Release();
         }
         break;
      case Candles:
         {
            id = conditions[size].RegisterStreams(id, upMessage, up_color);
            id = conditions[size + 1].RegisterStreams(id, downMessage, down_color);
         }
         break;
   }
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
      id = CreateAlert(id, upCondition, NULL, downCondition, NULL, 217, 218);
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