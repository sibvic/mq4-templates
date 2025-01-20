// Base EA template
// More templates and snippets on https://github.com/sibvic/mq4-templates
// You need:
// 1. To implement LongCondition, ShortCondition, ExitLongCondition and ExitShortCondition
// 2. To replace all includes with code from the snippets folder. You can use https://github.com/sibvic/MQ4Inject for that.

#property version   "1.0"
#property description "Developed by Victor Tereschenko: sibvic@gmail.com"
#property strict

#define ACT_ON_SWITCH_CONDITION
#define SHOW_ACCOUNT_STAT
#define REVERSABLE_LOGIC_FEATURE
#define STOP_LOSS_FEATURE
#define USE_NET_BREAKEVEN
#define TAKE_PROFIT_FEATURE
#define MARTINGALE_FEATURE
#define USE_MARKET_ORDERS
#define WEEKLY_TRADING_TIME_FEATURE
#define TRADING_TIME_FEATURE
#define POSITION_CAP_FEATURE 
#define WITH_EXIT_LOGIC
#define TWO_LEVEL_TP
#define CUSTOM_SL
#define CUSTOM_TP

#ifdef SHOW_ACCOUNT_STAT
   string EA_NAME = "[EA NAME]";
#endif

enum TradingMode
{
   TradingModeLive, // Live
   TradingModeOnBarClose // On bar close
};

input string GeneralSection = ""; // == General ==
input string symbols = ""; // Symbols to trade. Comma-separated. Use empty for on-chart symbol
input string GeneralSectionDesc = "https://github.com/sibvic/mq4-templates/wiki/EA_Base-template-parameters"; // Description of parameters could be found at
input ENUM_TIMEFRAMES trading_timeframe = PERIOD_CURRENT; // Trading timeframe
input bool ecn_broker = false; // Use hidden stop loss/take profit?
input TradingMode entry_logic = TradingModeLive; // Entry logic
#ifdef WITH_EXIT_LOGIC
   input TradingMode exit_logic = TradingModeLive; // Exit logic
#endif
#include <Enums/PositionSizeType.mqh>
enum LogicDirection
{
   DirectLogic, // Direct
   ReversalLogic // Reversal
};
enum TradingSide
{
   LongSideOnly, // Long
   ShortSideOnly, // Short
   BothSides // Both
};
input double lots_value = 0.1; // Position size
input PositionSizeType lots_type = PositionSizeContract; // Position size type
input int slippage_points = 3; // Slippage, points
input TradingSide trading_side = BothSides; // What trades should be taken
#ifdef REVERSABLE_LOGIC_FEATURE
   input LogicDirection logic_direction = DirectLogic; // Logic type
#else
   LogicDirection logic_direction = DirectLogic;
#endif
input double max_spread = 0; // Max spred, pips. 0 to disable
#ifdef USE_MARKET_ORDERS
   input bool close_on_opposite = true; // Close on opposite signal
#else
   bool close_on_opposite = false;
#endif

#ifdef POSITION_CAP_FEATURE
   input string CapSection = ""; // == Position cap ==
   input bool position_cap = false; // Position Cap
   input int no_of_positions = 1; // Max # of buy+sell positions
   input int no_of_buy_position = 1; // Max # of buy positions
   input int no_of_sell_position = 1; // Max # of sell positions
   input bool cap_by_margin = false; // Cap by usable margin
   input double min_margin = 50; // Min usable margin
#else
   bool position_cap = false;
   int no_of_positions = 1;
   int no_of_buy_position = 1;
   int no_of_sell_position = 1;
   bool cap_by_margin = false;
   double min_margin = 50;
#endif

enum MartingaleType
{
   MartingaleDoNotUse, // Do not use
   MartingaleOnLoss, // Open another position on loss
   MartingaleOnProfit // Open another position on profit
};
#include <enums/MartingaleLotSizingType.mqh>

enum MartingaleStepSizeType
{
   MartingaleStepSizePips, // Pips
   MartingaleStepSizePercent, // %
};
#ifdef MARTINGALE_FEATURE
   input string MartingaleSection = ""; // == Martingale ==
   input MartingaleType martingale_type = MartingaleDoNotUse; // Martingale type
   input MartingaleLotSizingType martingale_lot_sizing_type = MartingaleLotSizingNo; // Martingale lot sizing type
   input double martingale_lot_value = 1.5; // Matringale lot sizing value
   MartingaleStepSizeType martingale_step_type = MartingaleStepSizePips; // Step unit
   input double martingale_step = 50; // Open matringale position step
   input int max_longs = 5; // Max long positions
   input int max_shorts = 5; // Max short positions
#endif

enum TrailingType
{
   TrailingDontUse, // No trailing
   TrailingPips, // Use trailing in pips
   TrailingATR, // Use trailing with ATR start
   TrailingSLPercent, // Use trailing, in % of stop loss
};
#include <Enums/StopLossType.mqh>
#include <Enums/StopLimitType.mqh>
#include <Enums/MATypes.mqh>
enum TrailingTargetType
{
   TrailingTargetStep, // Move each n pips
   TrailingTargetMA, // Sync with MA
};
#ifdef STOP_LOSS_FEATURE
   input string StopLossSection            = ""; // == Stop loss ==
   input StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
   input bool use_net_stop_loss = false; // Use net stop loss
   input double stop_loss_value = 10; // Stop loss value
   input double stop_loss_atr_multiplicator = 1; // Stop loss multiplicator (for ATR SL)
   input TrailingType trailing_type = TrailingDontUse; // Trailing start type
   input double trailing_start = 0; // Min distance to order to activate the trailing
   input TrailingTargetType trailing_target_type = TrailingTargetStep; // Trailing target
   input double trailing_step = 10; // Trailing step
   input int trailing_ma_length = 14; // Trailing MA Length
   input MATypes trailing_ma_type = ma_sma; // Trailing MA Type
#else
   StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
   double stop_loss_value = 10;
   double stop_loss_atr_multiplicator = 1;
#endif
input string BreakevenSection = ""; // == Breakeven ==
input StopLimitType breakeven_type = StopLimitDoNotUse; // Trigger type for the breakeven
input double breakeven_value = 10; // Trigger for the breakeven
input double breakeven_level = 0; // Breakeven target

#include <enums/TakeProfitType.mqh>
#ifdef TAKE_PROFIT_FEATURE
   input string TakeProfitSection            = ""; // == Take Profit ==
   input TakeProfitType take_profit_type = TPDoNotUse; // Take profit type
   input bool use_net_take_profit = false; // Use net take profit
   #ifdef TWO_LEVEL_TP
   input double take_profit_value_1 = 10; // Take profit value
   input double take_profit_1_close = 50; // To close, %
   #endif
   input double take_profit_value = 10; // Take profit value
   input double take_profit_atr_multiplicator = 1; // Take profit multiplicator (for ATR TP)
#else
   TakeProfitType take_profit_type = TPDoNotUse;
   double take_profit_value = 10;
   double take_profit_atr_multiplicator = 1;
#endif

#include <enums/DayOfWeek.mqh>
input string OtherSection            = ""; // == Other ==
input int magic_number        = 42; // Magic number
input string trade_comment = ""; // Comment for orders
#ifdef TRADING_TIME_FEATURE
   input string start_time = "000000"; // Start time in hhmmss format
   input string stop_time = "000000"; // Stop time in hhmmss format
   input bool mandatory_closing = false; // Mandatory closing for non-trading time
#else
   string start_time = "000000"; // Start time in hhmmss format
   string stop_time = "000000"; // Stop time in hhmmss format
   bool mandatory_closing = false;
#endif
#ifdef WEEKLY_TRADING_TIME_FEATURE
   input bool use_weekly_timing = false; // Weekly time
   input DayOfWeek week_start_day = DayOfWeekSunday; // Start day
   input string week_start_time = "000000"; // Start time in hhmmss format
   input DayOfWeek week_stop_day = DayOfWeekSaturday; // Stop day
   input string week_stop_time = "235959"; // Stop time in hhmmss format
#else
   bool use_weekly_timing = false; // Weekly time
   DayOfWeek week_start_day = DayOfWeekSunday; // Start day
   string week_start_time = "000000"; // Start time in hhmmss format
   DayOfWeek week_stop_day = DayOfWeekSaturday; // Stop day
   string week_stop_time = "235959"; // Stop time in hhmmss format
#endif
#ifdef USE_REGIONAL_TIMEZONES
   input bool tokyo_tz = false; // Use Tokyo Timezone
   input bool ny_tz = false; // Use New-York Timezone
   input bool london_tz = false; // Use London Timezone
#endif
input bool print_log = false; // Print decisions into the log
input string log_file = "log.csv"; // Log file name (empty for auto naming)

#ifdef SHOW_ACCOUNT_STAT
   input string   DashboardSection            = ""; // == Dashboard ==
   input color color_text = White; // General text color
   input color color_buy_signal = Green; // Buy signal color
   input color color_sell_signal = Red; // Sell signal color
   input color color_profit = Green; // Profit color
   input color color_loss = Red; // Loss color
   input color background_color = DarkBlue; // Background color
   input int x = 50; // Dashboard X coordinate
   input int y = 50; // Dashboard Y coordinate
#endif

#include <Signaler.mqh>
#include <InstrumentInfo.mqh>
#include <conditions/ActOnSwitchCondition.mqh>
#include <conditions/DisabledCondition.mqh>
#include <conditions/MinMarginCondition.mqh>
#include <conditions/MaxSpreadCondition.mqh>
#include <Streams/AStream.mqh>
#include <Streams/PriceStream.mqh>
class EntryStreamData
{
   int refs;
public:
   EntryStreamData(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      refs = 1;
      //create common indicators here
   }
   ~EntryStreamData()
   {
      //delete common indicators here
   }
   void AddRef()
   {
      ++refs;
   }
   void Release()
   {
      if (--refs == 0)
      {
         delete &this;
      }
   }
};
#ifndef USE_MARKET_ORDERS
   class LongEntryStream : public AStream
   {
      EntryStreamData* data;
   public:
      LongEntryStream(const string symbol, const ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
         :AStream(symbol, timeframe)
      {
         this.data = data;
         data.AddRef();
      }
      ~LongEntryStream()
      {
         data.Release();
      }

      bool GetValue(const int period, double &val)
      {
         val = iHigh(_symbol, _timeframe, period);
         return true;
      }
   };

   class ShortEntryStream : public AStream
   {
      EntryStreamData* data;
   public:
      ShortEntryStream(const string symbol, const ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
         :AStream(symbol, timeframe)
      {
         this.data = data;
         data.AddRef();
      }
      ~ShortEntryStream()
      {
         data.Release();
      }

      bool GetValue(const int period, double &val)
      {
         val = iHigh(_symbol, _timeframe, period);
         return true;
      }
   };
#endif

#include <OrdersIterator.mqh>
#include <TradingCalculator.mqh>
#include <Order/IOrder.mqh>
#include <Actions/AAction.mqh>
#include <Actions/CreateTrailingStreamAction.mqh>
#include <Actions/PartialCloseOnProfitOrderAction.mqh>
#include <Logic/ActionOnConditionController.mqh>
#include <Logic/ActionOnConditionLogic.mqh>
#include <Conditions/HitProfitCondition.mqh>
#include <Conditions/PositionLimitHitCondition.mqh>
#include <Actions/MoveNetStopLossAction.mqh>
#include <Actions/MoveNetTakeProfitAction.mqh>
#include <Actions/EntryAction.mqh>
#include <MoneyManagement/functions.mqh>
#include <TradingCommands.mqh>
#include <CloseOnOpposite.mqh>
#include <OrderBuilder.mqh>
#include <MarketOrderBuilder.mqh>
#include <EntryStrategy.mqh>
#include <Actions/MoveStopLossOnProfitOrderAction.mqh>
#include <TradingController.mqh>
#include <Conditions/NoCondition.mqh>

TradingController *controllers[];
#ifdef SHOW_ACCOUNT_STAT
#include <AccountStatistics.mqh>
   AccountStatistics *stats;
#endif

#include <actions/CreateTrailingAction.mqh>
#include <actions/CreateATRTrailingAction.mqh>
#include <actions/CloseAllAction.mqh>
#include <streams/averages/AveragesStreamFactory.mqh>
#include <Streams/SimplePriceStream.mqh>

#include <conditions/ACondition.mqh>
#include <conditions/TradingTimeCondition.mqh>
#include <conditions/AndCondition.mqh>
#include <conditions/OrCondition.mqh>
#include <conditions/NotCondition.mqh>

#ifdef CUSTOM_SL
class CustomStopLossStrategy : public IStopLossStrategy
{
   bool _isBuy;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   CustomStopLossStrategy(string symbol, ENUM_TIMEFRAMES timeframe, bool isBuy)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _isBuy = isBuy;
   }

   virtual double GetValue(const int period, double entryPrice)
   {
      double high, low;
      GetHighLow(_symbol, _timeframe, high, low);
      return _isBuy ? low : high;
   }
private:
   void GetHighLow(string symbol, ENUM_TIMEFRAMES timeframe, double& high, double& low)
   {
      //TODO: implement
   }
};
#endif

#ifdef CUSTOM_TP
class CustomTakeProfitStrategy : public ITakeProfitStrategy
{
   bool _isBuy;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   CustomTakeProfitStrategy(string symbol, ENUM_TIMEFRAMES timeframe, bool isBuy)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _isBuy = isBuy;
   }

   virtual void GetTakeProfit(const int period, const double entryPrice, double stopLoss, double amount, double& takeProfit)
   {
      double high, low;
      GetHighLow(_symbol, _timeframe, high, low);
      takeProfit = _isBuy ? high : low;
   }
private:
   void GetHighLow(string symbol, ENUM_TIMEFRAMES timeframe, double& high, double& low)
   {
      //TODO: implement
   }
};
#endif

class LongCondition : public ACondition
{
   EntryStreamData* data;
public:
   LongCondition(const string symbol, ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
      :ACondition(symbol, timeframe)
   {
      this.data = data;
      data.AddRef();
   }
   ~LongCondition()
   {
      data.Release();
   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ShortCondition : public ACondition
{
   EntryStreamData* data;
public:
   ShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
      :ACondition(symbol, timeframe)
   {
      this.data = data;
      data.AddRef();
   }
   ~ShortCondition()
   {
      data.Release();
   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ExitLongCondition : public ACondition
{
public:
   ExitLongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ExitShortCondition : public ACondition
{
public:
   ExitShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

ICondition* CreateLongCondition(string symbol, ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
{
   if (trading_side == ShortSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }

   AndCondition* condition = new AndCondition();
   condition.Add(new LongCondition(symbol, timeframe, data), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
      condition.Release();
      return switchCondition;
   #else 
      return (ICondition*) condition;
   #endif
}

ICondition* CreateLongFilterCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   if (trading_side == ShortSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }
   AndCondition* condition = new AndCondition();
   condition.Add(new NoCondition(), false);
   return condition;
}

ICondition* CreateShortCondition(string symbol, ENUM_TIMEFRAMES timeframe, EntryStreamData* data)
{
   if (trading_side == LongSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }

   AndCondition* condition = new AndCondition();
   condition.Add(new ShortCondition(symbol, timeframe, data), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
      condition.Release();
      return switchCondition;
   #else 
      return (ICondition*) condition;
   #endif
}

ICondition* CreateShortFilterCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   if (trading_side == LongSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }
   AndCondition* condition = new AndCondition();
   condition.Add(new NoCondition(), false);
   return condition;
}

ICondition* CreateExitLongCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   AndCondition* condition = new AndCondition();
   condition.Add(new ExitLongCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
      condition.Release();
      return switchCondition;
   #else
      return (ICondition *)condition;
   #endif
}

ICondition* CreateExitShortCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   AndCondition* condition = new AndCondition();
   condition.Add(new ExitShortCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
      condition.Release();
      return switchCondition;
   #else
      return (ICondition *)condition;
   #endif
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

IStream* CreateTrailingStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
{
   if (trailing_target_type == TrailingTargetMA)
   {
      IStream* source = new SimplePriceStream(symbol, timeframe, PriceClose);
      IStream* trailingStream = AveragesStreamFactory::Create(source, trailing_ma_length, trailing_ma_type);
      source.Release();
      return trailingStream;
   }
   return NULL;
}

AOrderAction* CreateTrailing(const string symbol, const ENUM_TIMEFRAMES timeframe, ActionOnConditionLogic* actions)
{
   #ifdef STOP_LOSS_FEATURE
      switch (trailing_type)
      {
         case TrailingDontUse:
            return NULL;
      #ifdef INDICATOR_BASED_TRAILING
         case TrailingIndicator:
            return NULL;
      #endif
         case TrailingPips:
            {
               if (trailing_target_type == TrailingTargetStep)
               {
                  return new CreateTrailingAction(trailing_start, false, trailing_step, actions);
               }
               IStream* stream = CreateTrailingStream(symbol, timeframe);
               AOrderAction* action = new CreateTrailingStreamAction(trailing_start, false, stream, actions);
               stream.Release();
               return action;
            }
         case TrailingATR:
            return new CreateATRTrailingAction(symbol, timeframe, trailing_start, trailing_step, actions);
         case TrailingSLPercent:
            {
               if (trailing_target_type == TrailingTargetStep)
               {
                  return new CreateTrailingAction(trailing_start, true, trailing_step, actions);
               }
               IStream* stream = CreateTrailingStream(symbol, timeframe);
               AOrderAction* action = new CreateTrailingStreamAction(trailing_start, true, stream, actions);
               stream.Release();
               return action;
            }
      }
   #endif
   return NULL;
}

#ifdef MARTINGALE_FEATURE
void CreateMartingale(TradingCalculator* tradingCalculator, string symbol, ENUM_TIMEFRAMES timeframe, IEntryStrategy* entryStrategy, 
   OrderHandlers* orderHandlers, ActionOnConditionLogic* actions, bool inProfit)
{
   CustomLotsProvider* lots = new CustomLotsProvider();

   IStopLossStrategy* stopLoss = CreateStopLossStrategyForLots(lots, tradingCalculator, symbol, timeframe, true, stop_loss_type, stop_loss_value, stop_loss_atr_multiplicator);
   ITakeProfitStrategy* tp = CreateTakeProfitStrategy(tradingCalculator, symbol, timeframe, true, take_profit_type, take_profit_value, take_profit_atr_multiplicator);
   IMoneyManagementStrategy* longMoneyManagement = new MoneyManagementStrategy(lots, stopLoss, tp);
   IAction* openLongAction = new EntryAction(entryStrategy, BuySide, longMoneyManagement, "", orderHandlers, true);
   
   stopLoss = CreateStopLossStrategyForLots(lots, tradingCalculator, symbol, timeframe, false, stop_loss_type, stop_loss_value, stop_loss_atr_multiplicator);
   tp = CreateTakeProfitStrategy(tradingCalculator, symbol, timeframe, false, take_profit_type, take_profit_value, take_profit_atr_multiplicator);
   IMoneyManagementStrategy* shortMoneyManagement = new MoneyManagementStrategy(lots, stopLoss, tp);
   IAction* openShortAction = new EntryAction(entryStrategy, SellSide, shortMoneyManagement, "", orderHandlers, true);

   CreateMartingaleAction* martingaleAction = new CreateMartingaleAction(lots, martingale_lot_sizing_type, martingale_lot_value, 
      martingale_step, openLongAction, openShortAction, max_longs, max_shorts, actions, inProfit, magic_number);
   openLongAction.Release();
   openShortAction.Release();
   
   martingaleAction.RestoreActions(_Symbol, magic_number);
   orderHandlers.AddOrderAction(martingaleAction);
   martingaleAction.Release();
}
#endif

TradingController *CreateController(const string symbol, const ENUM_TIMEFRAMES timeframe, string algoId, string &error)
{
   #ifdef TRADING_TIME_FEATURE
      ICondition* tradingTimeCondition = CreateTradingTimeCondition(start_time, stop_time, use_weekly_timing,
         week_start_day, week_start_time, week_stop_day, 
         week_stop_time, error);
      if (tradingTimeCondition == NULL)
      {
         return NULL;
      }
   #else
      ICondition* tradingTimeCondition = NULL;
   #endif

   TradingCalculator* tradingCalculator = TradingCalculator::Create(symbol);
   if (tradingCalculator == NULL)
   {
      error = "Unknown symbol: " + symbol;
      return NULL;
   }
   if (!tradingCalculator.IsLotsValid(lots_value, lots_type, error))
   {
      #ifdef TRADING_TIME_FEATURE
         tradingTimeCondition.Release();
      #endif
      tradingCalculator.Release();
      return NULL;
   }

   Signaler* signaler = new Signaler();
   signaler.SetMessagePrefix(symbol + "/" + TimeframeToString(timeframe) + ": ");
   
   ICloseOnOppositeStrategy* closeOnOpposite = close_on_opposite 
      ? (ICloseOnOppositeStrategy*)new DoCloseOnOppositeStrategy(slippage_points, magic_number)
      : (ICloseOnOppositeStrategy*)new DontCloseOnOppositeStrategy();
   ActionOnConditionLogic* actions = new ActionOnConditionLogic();
   EntryStreamData* data = new EntryStreamData(symbol, timeframe);
   #ifdef USE_MARKET_ORDERS
      IEntryStrategy* entryStrategy = new MarketEntryStrategy(symbol, magic_number, slippage_points, actions, ecn_broker);
   #else
      AStream *longPrice = new LongEntryStream(symbol, timeframe, data);
      AStream *shortPrice = new ShortEntryStream(symbol, timeframe, data);
      IEntryStrategy* entryStrategy = new PendingEntryStrategy(symbol, magic_number, slippage_points, longPrice, shortPrice, actions, ecn_broker);
   #endif

   AndCondition* longCondition = new AndCondition();
   AndCondition* shortCondition = new AndCondition();
   #ifdef TRADING_TIME_FEATURE
      longCondition.Add(tradingTimeCondition, true);
      shortCondition.Add(tradingTimeCondition, true);
      tradingTimeCondition.Release();
   #endif
   #ifdef USE_REGIONAL_TIMEZONES
      OrCondition* regionalTimezonesCondition = new OrCondition();
      if (tokyo_tz)
      {
         regionalTimezonesCondition.Add(new TokyoTimezoneCondition(), false);
      }
      if (ny_tz)
      {
         regionalTimezonesCondition.Add(new NewYorkTimezoneCondition(), false);
      }
      if (london_tz)
      {
         regionalTimezonesCondition.Add(new LondonTimezoneCondition(), false);
      }
      longCondition.Add(regionalTimezonesCondition, true);
      shortCondition.Add(regionalTimezonesCondition, true);
      regionalTimezonesCondition.Release();
   #endif

   AndCondition* longFilterCondition = new AndCondition();
   AndCondition* shortFilterCondition = new AndCondition();

   switch (logic_direction)
   {
      case DirectLogic:
         longFilterCondition.Add(CreateLongFilterCondition(symbol, timeframe), false);
         shortFilterCondition.Add(CreateShortFilterCondition(symbol, timeframe), false);
         longCondition.Add(CreateLongCondition(symbol, timeframe, data), false);
         shortCondition.Add(CreateShortCondition(symbol, timeframe, data), false);
         break;
      case ReversalLogic:
         shortFilterCondition.Add(CreateLongFilterCondition(symbol, timeframe), false);
         longFilterCondition.Add(CreateShortFilterCondition(symbol, timeframe), false);
         longCondition.Add(CreateShortCondition(symbol, timeframe, data), false);
         shortCondition.Add(CreateLongCondition(symbol, timeframe, data), false);
         break;
   }
   data.Release();
   if (position_cap)
   {
      ICondition* buyLimitCondition = new PositionLimitHitCondition(BuySide, magic_number, no_of_buy_position, no_of_positions, symbol);
      ICondition* sellLimitCondition = new PositionLimitHitCondition(SellSide, magic_number, no_of_sell_position, no_of_positions, symbol);
      longFilterCondition.Add(new NotCondition(buyLimitCondition), false);
      shortFilterCondition.Add(new NotCondition(sellLimitCondition), false);
      buyLimitCondition.Release();
      sellLimitCondition.Release();
   }
   if (max_spread > 0)
   {
      longFilterCondition.Add(new MaxSpreadCondition(symbol, timeframe, max_spread), false);
      shortFilterCondition.Add(new MaxSpreadCondition(symbol, timeframe, max_spread), false);
   }
   if (cap_by_margin)
   {
      ICondition* minMarginCondition = new MinMarginCondition(min_margin);
      longFilterCondition.Add(new NotCondition(minMarginCondition), false);
      shortFilterCondition.Add(new NotCondition(minMarginCondition), false);
      minMarginCondition.Release();
   }
   
   EntryPositionController* longPosition = new EntryPositionController(BuySide, longCondition, longFilterCondition, 
      closeOnOpposite, signaler, "", "Buy");
   EntryPositionController* shortPosition = new EntryPositionController(SellSide, shortCondition, shortFilterCondition,
      closeOnOpposite, signaler, "", "Sell");
   longCondition.Release();
   shortCondition.Release();
   longFilterCondition.Release();
   shortFilterCondition.Release();
      
   closeOnOpposite.Release();
   
   TradingController* controller = new TradingController(tradingCalculator, timeframe, timeframe, actions, signaler, algoId);
   controller.AddLongPosition(longPosition);
   controller.AddShortPosition(shortPosition);
   
   if (breakeven_type != StopLimitDoNotUse)
   {
      #ifndef USE_NET_BREAKEVEN
         MoveStopLossOnProfitOrderAction* orderAction = new MoveStopLossOnProfitOrderAction(breakeven_type, breakeven_value, breakeven_level, signaler, actions);
         orderAction.RestoreActions(_Symbol, magic_number);
         orderHandlers.AddOrderAction(orderAction);
         orderAction.Release();
      #endif
   }
   #ifdef TWO_LEVEL_TP
   switch (take_profit_type)
   {
      case TPDoNotUse:
         break;
      case TPPercent:
         {
            PartialCloseOnProfitOrderAction* orderAction = new PartialCloseOnProfitOrderAction(StopLimitPercent, take_profit_value_1, take_profit_1_close, signaler, actions, slippage_points);
            orderHandlers.AddOrderAction(orderAction);
            orderAction.Release();
         }
         break;
      case TPPips:
         {
            PartialCloseOnProfitOrderAction* orderAction = new PartialCloseOnProfitOrderAction(StopLimitPips, take_profit_value_1, take_profit_1_close, signaler, actions, slippage_points);
            orderHandlers.AddOrderAction(orderAction);
            orderAction.Release();
         }
         break;
      case TPDollar:
         {
            PartialCloseOnProfitOrderAction* orderAction = new PartialCloseOnProfitOrderAction(StopLimitDollar, take_profit_value_1, take_profit_1_close, signaler, actions, slippage_points);
            orderHandlers.AddOrderAction(orderAction);
            orderAction.Release();
         }
         break;
      case TPRiskReward:
         {
            PartialCloseOnProfitOrderAction* orderAction = new PartialCloseOnProfitOrderAction(StopLimitRiskReward, take_profit_value_1, take_profit_1_close, signaler, actions, slippage_points);
            orderHandlers.AddOrderAction(orderAction);
            orderAction.Release();
         }
         break;
      case TPAbsolute:
         {
            PartialCloseOnProfitOrderAction* orderAction = new PartialCloseOnProfitOrderAction(StopLimitAbsolute, take_profit_value_1, take_profit_1_close, signaler, actions, slippage_points);
            orderHandlers.AddOrderAction(orderAction);
            orderAction.Release();
         }
         break;
      default:
         Print("Not supported take profit type");
         break;
   }
   #endif

   AOrderAction* trailingAction = CreateTrailing(symbol, timeframe, actions);
   if (trailingAction != NULL)
   {
      trailingAction.RestoreActions(_Symbol, magic_number);
      orderHandlers.AddOrderAction(trailingAction);
      trailingAction.Release();
   }

   #ifdef MARTINGALE_FEATURE
      switch (martingale_type)
      {
         case MartingaleOnLoss:
            {
               CreateMartingale(tradingCalculator, symbol, timeframe, entryStrategy, orderHandlers, actions, false);
            }
            break;
         case MartingaleOnProfit:
            {
               CreateMartingale(tradingCalculator, symbol, timeframe, entryStrategy, orderHandlers, actions, true);
            }
            break;
      }
   #endif

   #ifdef WITH_EXIT_LOGIC
      controller.SetExitLogic(exit_logic);
      ICondition* exitLongCondition = CreateExitLongCondition(symbol, timeframe);
      ICondition* exitShortCondition = CreateExitShortCondition(symbol, timeframe);
   #else
      ICondition* exitLongCondition = new DisabledCondition();
      ICondition* exitShortCondition = new DisabledCondition();
   #endif

   switch (logic_direction)
   {
      case DirectLogic:
         controller.SetExitLongCondition(exitLongCondition);
         controller.SetExitShortCondition(exitShortCondition);
         break;
      case ReversalLogic:
         controller.SetExitLongCondition(exitShortCondition);
         controller.SetExitShortCondition(exitLongCondition);
         break;
   }
   if (mandatory_closing && tradingTimeCondition != NULL)
   {
      NotCondition* condition = new NotCondition(tradingTimeCondition);
      IAction* action = new CloseAllAction(magic_number, slippage_points);
      actions.AddActionOnCondition(action, condition);
      action.Release();
      condition.Release();
   }
   
   IMoneyManagementStrategy* longMoneyManagement = CreateMoneyManagementStrategy(tradingCalculator, symbol, timeframe, true, 
      lots_type, lots_value, stop_loss_type, stop_loss_value, stop_loss_atr_multiplicator, take_profit_type, take_profit_value, take_profit_atr_multiplicator);
   IAction* openLongAction = new EntryAction(entryStrategy, BuySide, longMoneyManagement, "", orderHandlers);
   longPosition.AddAction(openLongAction);
   openLongAction.Release();
   IMoneyManagementStrategy* shortMoneyManagement = CreateMoneyManagementStrategy(tradingCalculator, symbol, timeframe, false, 
      lots_type, lots_value, stop_loss_type, stop_loss_value, stop_loss_atr_multiplicator, take_profit_type, take_profit_value, take_profit_atr_multiplicator);
   IAction* openShortAction = new EntryAction(entryStrategy, SellSide, shortMoneyManagement, "", orderHandlers);
   shortPosition.AddAction(openShortAction);
   openShortAction.Release();

   if (use_net_stop_loss && stop_loss_type != SLDoNotUse)
   {
      MoveNetStopLossAction* action = NULL;
      switch (stop_loss_type)
      {
         case SLPips:
            action = new MoveNetStopLossAction(tradingCalculator, StopLimitPips, stop_loss_value, magic_number);
            break;
         default:
            Alert("Selected stop loss type not supported for net stop loss");
            break;
      }
      #ifdef USE_NET_BREAKEVEN
         if (breakeven_type != StopLimitDoNotUse)
         {
            //TODO: use breakeven_type as well
            action.SetBreakeven(breakeven_value, breakeven_level);
         }
      #endif

      NoCondition* condition = new NoCondition();
      actions.AddActionOnCondition(action, condition);
      action.Release();
      condition.Release();
   }
   if (use_net_take_profit && take_profit_type != SLDoNotUse)
   {
      MoveNetTakeProfitAction* action = NULL;
      switch (take_profit_type)
      {
         case TPPips:
            action = new MoveNetTakeProfitAction(tradingCalculator, StopLimitPips, take_profit_value, magic_number);
            break;
         default:
            Alert("Selected take profit type not supported for net take profit");
            break;
      }

      NoCondition* condition = new NoCondition();
      actions.AddActionOnCondition(action, condition);
      action.Release();
      condition.Release();
   }

   controller.SetEntryLogic(entry_logic);
   controller.SetEntryStrategy(entryStrategy);
   entryStrategy.Release();
   if (print_log)
   {
      string name = log_file;
      if (name == "")
      {
         name = symbol;
      }
      if (algoId != "" && algoId != NULL)
      {
         name = name + "_" + algoId;
      }
      MqlDateTime current_time;
      string suffix = "";
      if (TimeToStruct(TimeCurrent(), current_time))
      {
         name = name + "_" + IntegerToString(current_time.hour) + "-" + IntegerToString(current_time.min) + "-" + IntegerToString(current_time.sec);
      }
      name = name + ".csv";
      controller.SetPrintLog(name);
   }
   tradingCalculator.Release();

   return controller;
}

OrderHandlers* orderHandlers;
int OnInit()
{
   orderHandlers = new OrderHandlers();
   #ifdef SHOW_ACCOUNT_STAT
      stats = NULL;
   #endif
   if (!IsDllsAllowed() && advanced_alert)
   {
      Print("Error: Dll calls must be allowed!");
      return INIT_FAILED;
   }
   #ifdef MARTINGALE_FEATURE
      if (lots_type == PositionSizeRisk && martingale_type == MartingaleOnLoss)
      {
         Print("Error: martingale_type couldn't be used with this lot type!");
         return INIT_FAILED;
      }
   #endif

   string toTrade[];
   StringSplit(symbols == "" ? _Symbol : symbols, ',', toTrade);
   for (int i = 0; i < ArraySize(toTrade); ++i)
   {
      string error;
      TradingController *controller = CreateController(toTrade[i], trading_timeframe, trade_comment, error);
      if (controller == NULL)
      {
         Print(error);
         return INIT_FAILED;
      }
      int controllersCount = 0;
      ArrayResize(controllers, controllersCount + 1);
      controllers[controllersCount++] = controller;
   }
   
   #ifdef SHOW_ACCOUNT_STAT
      stats = new AccountStatistics(background_color, x, y);
   #endif
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if (orderHandlers != NULL)
   {
      orderHandlers.Clear();
      orderHandlers.Release();
   }

   #ifdef SHOW_ACCOUNT_STAT
      delete stats;
   #endif
   int i_count = ArraySize(controllers);
   for (int i = 0; i < i_count; ++i)
   {
      delete controllers[i];
   }
}

void OnTick()
{
   int i_count = ArraySize(controllers);
   for (int i = 0; i < i_count; ++i)
   {
      controllers[i].DoTrading();
   }
   #ifdef SHOW_ACCOUNT_STAT
      stats.Update();
   #endif
}
