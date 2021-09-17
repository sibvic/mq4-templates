

#property version   "1.0"
#property strict


enum CustomActionType
{
   No_Action,
   Buy,
   BuyLimit,
   BuyStop,
   Sell,
   SellLimit,
   SellStop,
   Close_Buy_Positions,
   Close_Sell_Positions,
   Close_All_Positions,
   Produce_Alert
};

input CustomActionType BB_Top_Line_Cross_Over        = Close_Buy_Positions;

#define ACT_ON_SWITCH_CONDITION
#define STOP_LOSS_FEATURE
#define TAKE_PROFIT_FEATURE
#define USE_MARKET_ORDERS
#define TRADING_TIME_FEATURE
#define POSITION_CAP_FEATURE 

enum TradingMode
{
   TradingModeLive, // Live
   TradingModeOnBarClose // On bar close
};

input string GeneralSection = ""; // == General ==
input string GeneralSectionDesc = "https://github.com/sibvic/mq4-templates/wiki/EA_Base-template-parameters"; // Description of parameters could be found at
input int price_shift = 10; // Price shift, pips
input ENUM_TIMEFRAMES trading_timeframe = PERIOD_CURRENT; // Trading timeframe
input bool ecn_broker = false; // ECN Broker? 
input TradingMode trigger_logic = TradingModeLive; // Trigger logic
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
   MartingaleOnLoss // Open another position on loss
};
enum MartingaleLotSizingType
{
   MartingaleLotSizingNo, // No lot sizing
   MartingaleLotSizingMultiplicator, // Using miltiplicator
   MartingaleLotSizingAdd // Addition
};
enum MartingaleStepSizeType
{
   MartingaleStepSizePips, // Pips
   MartingaleStepSizePercent, // %
};
#ifdef MARTINGALE_FEATURE
   input string MartingaleSection = ""; // == Martingale type ==
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
   string StopLossSection            = ""; // == Stop loss ==
   input StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
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
#ifdef NET_STOP_LOSS_FEATURE
   input string NetStopSection = ""; // == Net stop ==
   input StopLimitType net_stop_loss_type = StopLimitDoNotUse; // Net stop loss type
   input double net_stop_loss_value = 10; // Net stop loss value
#endif

#include <enums/TakeProfitType.mqh>
#ifdef TAKE_PROFIT_FEATURE
   input string TakeProfitSection            = ""; // == Take Profit ==
   input TakeProfitType take_profit_type = TPDoNotUse; // Take profit type
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
input bool print_log = false; // Print decisions into the log
input string log_file = "log.csv"; // Log file name (empty for auto naming)

#include <InstrumentInfo.mqh>
#include <conditions/ActOnSwitchCondition.mqh>
#include <conditions/DisabledCondition.mqh>
#include <conditions/MinMarginCondition.mqh>
#include <conditions/MaxSpreadCondition.mqh>
#include <Streams/AStream.mqh>
#include <Streams/PriceStream.mqh>
#include <OrdersIterator.mqh>
#include <TradingCalculator.mqh>
#include <Order.mqh>
#include <Actions/AAction.mqh>
#include <Actions/CreateTrailingStreamAction.mqh>
#include <Actions/PartialCloseOnProfitOrderAction.mqh>
#include <Actions/CreateMartingaleAction.mqh>
#include <Logic/ActionOnConditionController.mqh>
#include <Logic/ActionOnConditionLogic.mqh>
#include <Conditions/HitProfitCondition.mqh>
#include <Conditions/PositionLimitHitCondition.mqh>
#include <Actions/MoveNetStopLossAction.mqh>
#include <Actions/MoveNetTakeProfitAction.mqh>
#include <Actions/EntryAction.mqh>
#include <MoneyManagement/functions.mqh>
#include <TradingCommands.mqh>
#include <OrderBuilder.mqh>
#include <MarketOrderBuilder.mqh>
#include <EntryStrategy.mqh>
#include <Actions/MoveStopLossOnProfitOrderAction.mqh>
#include <Conditions/NoCondition.mqh>

#ifdef SHOW_ACCOUNT_STAT
#include <AccountStatistics.mqh>
   AccountStatistics *stats;
#endif

#include <actions/CreateTrailingAction.mqh>
#include <actions/CreateATRTrailingAction.mqh>
#include <actions/CloseAllAction.mqh>
#include <actions/CloseSideAction.mqh>
#include <streams/averages/AveragesStreamFactory.mqh>

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
      return _isBuy ? high : low;
   }
};
#endif

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
   OrderHandlers* orderHandlers, ActionOnConditionLogic* actions)
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
      martingale_step, openLongAction, openShortAction, max_longs, max_shorts, actions);
   openLongAction.Release();
   openShortAction.Release();
   
   martingaleAction.RestoreActions(_Symbol, magic_number);
   orderHandlers.AddOrderAction(martingaleAction);
   martingaleAction.Release();
}
#endif

AndCondition* CreateCloseCondition(string symbol, ENUM_TIMEFRAMES timeframe,  
   ICondition* mainCondition, ICondition* tradingTimeCondition)
{
   AndCondition* condition = new AndCondition();
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, mainCondition);
      condition.Add(switchCondition, false);
   #else
      condition.Add(mainCondition, true);
   #endif
   condition.Add(mainCondition, true);
   if (tradingTimeCondition != NULL)
   {
      condition.Add(tradingTimeCondition, true);
   }
   return condition;
}

AndCondition* CreateCondition(string symbol, ENUM_TIMEFRAMES timeframe, OrderSide orderSide, 
   ICondition* mainCondition, ICondition* tradingTimeCondition)
{
   AndCondition* condition = new AndCondition();
   if (position_cap)
   {
      int noOfPositions = orderSide == BuySide ? no_of_buy_position : no_of_sell_position;
      ICondition* limitCondition = new PositionLimitHitCondition(orderSide, magic_number, noOfPositions, no_of_positions, symbol);
      condition.Add(new NotCondition(limitCondition), false);
      limitCondition.Release();
   }
   if (max_spread > 0)
   {
      condition.Add(new MaxSpreadCondition(symbol, timeframe, max_spread), false);
   }
   if (cap_by_margin)
   {
      ICondition* minMarginCondition = new MinMarginCondition(min_margin);
      condition.Add(new NotCondition(minMarginCondition), false);
      minMarginCondition.Release();
   }
   #ifdef ACT_ON_SWITCH_CONDITION
      ActOnSwitchCondition* switchCondition = new ActOnSwitchCondition(symbol, timeframe, mainCondition);
      condition.Add(switchCondition, false);
   #else
      condition.Add(mainCondition, true);
   #endif
   if (tradingTimeCondition != NULL)
   {
      condition.Add(tradingTimeCondition, true);
   }
   return condition;
}

IAction* CreateAction(TradingCalculator* tradingCalculator, string symbol,
   ENUM_TIMEFRAMES timeframe, OrderSide orderSide, OrderHandlers* orderHandlers, bool market,
   ActionOnConditionLogic* actions, IStream* price)
{
   IMoneyManagementStrategy* moneyManagement = CreateMoneyManagementStrategy(tradingCalculator, symbol, timeframe,
      orderSide == BuySide, lots_type, lots_value, stop_loss_type, stop_loss_value, stop_loss_atr_multiplicator, 
      take_profit_type, take_profit_value, take_profit_atr_multiplicator);

   IEntryStrategy* entryStrategy;
   if (market)
   {
      entryStrategy = new MarketEntryStrategy(symbol, magic_number, slippage_points, actions, ecn_broker);
   }
   else
   {
      entryStrategy = new PendingEntryStrategy(symbol, magic_number, slippage_points, 
         price, price, actions, ecn_broker);
   }

   IAction* action = new EntryAction(entryStrategy, orderSide, moneyManagement, "", orderHandlers);
   entryStrategy.Release();
   tradingCalculator.Release();
   return action;
}

void CreateAction(CustomActionType actionType, ICondition* mainCondition, const string symbol, const ENUM_TIMEFRAMES timeframe, 
   TradingCalculator* tradingCalculator, ICondition* tradingTimeCondition)
{
   switch (actionType)
   {
      case No_Action:
         break;
      case Buy:
         {
            AndCondition* condition = CreateCondition(symbol, timeframe, BuySide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, BuySide, orderHandlers,
               true, actions, NULL);

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case BuyLimit:
         {
            SimplePriceStream* price = new SimplePriceStream(symbol, timeframe, PriceClose);
            price.SetShift(-price_shift);
            AndCondition* condition = CreateCondition(symbol, timeframe, BuySide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, BuySide, orderHandlers,
               false, actions, price);
            price.Release();

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case BuyStop:
         {
            SimplePriceStream* price = new SimplePriceStream(symbol, timeframe, PriceClose);
            price.SetShift(price_shift);
            AndCondition* condition = CreateCondition(symbol, timeframe, BuySide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, BuySide, orderHandlers,
               false, actions, price);
            price.Release();

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case Sell:
         {
            AndCondition* condition = CreateCondition(symbol, timeframe, SellSide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, SellSide, orderHandlers,
               true, actions, NULL);

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case SellLimit:
         {
            SimplePriceStream* price = new SimplePriceStream(symbol, timeframe, PriceClose);
            price.SetShift(price_shift);
            AndCondition* condition = CreateCondition(symbol, timeframe, SellSide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, SellSide, orderHandlers,
               false, actions, price);
            price.Release();

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case SellStop:
         {
            SimplePriceStream* price = new SimplePriceStream(symbol, timeframe, PriceClose);
            price.SetShift(-price_shift);
            AndCondition* condition = CreateCondition(symbol, timeframe, SellSide, mainCondition, tradingTimeCondition);
            IAction* action = CreateAction(tradingCalculator, symbol, timeframe, SellSide, orderHandlers,
               false, actions, price);
            price.Release();

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case Close_Buy_Positions:
         {
            AndCondition* condition = CreateCloseCondition(symbol, timeframe, mainCondition, tradingTimeCondition);
            IAction* action = new CloseSideAction(magic_number, slippage_points, BuySide);

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case Close_Sell_Positions:
         {
            AndCondition* condition = CreateCloseCondition(symbol, timeframe, mainCondition, tradingTimeCondition);
            IAction* action = new CloseSideAction(magic_number, slippage_points, SellSide);

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
      case Close_All_Positions:
         {
            AndCondition* condition = CreateCloseCondition(symbol, timeframe, mainCondition, tradingTimeCondition);
            IAction* action = new CloseAllAction(magic_number, slippage_points);

            actions.AddActionOnCondition(action, condition);
            
            condition.Release();
            action.Release();
         }
         break;
   }
}

void CreateActions(const string symbol, const ENUM_TIMEFRAMES timeframe, TradingCalculator* tradingCalculator, 
   ICondition* tradingTimeCondition)
{
   ICondition* mainCondition = NULL;
   CreateAction(BB_Top_Line_Cross_Over, mainCondition, symbol, timeframe, tradingCalculator, tradingTimeCondition);
   mainCondition.Release();
}

OrderHandlers* orderHandlers;
TradingCalculator* tradingCalculator;
ActionOnConditionLogic* actions;
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

   tradingCalculator = TradingCalculator::Create(_Symbol);
   string error;
   ICondition* tradingTimeCondition = NULL;
   #ifdef TRADING_TIME_FEATURE
      tradingTimeCondition = CreateTradingTimeCondition(start_time, stop_time, use_weekly_timing,
         week_start_day, week_start_time, week_stop_day, 
         week_stop_time, error);
      if (tradingTimeCondition == NULL)
      {
         Print("Error: " + error);
         return INIT_FAILED;
      }
   #endif
   if (!tradingCalculator.IsLotsValid(lots_value, lots_type, error))
   {
      if (tradingTimeCondition != NULL)
      {
         tradingTimeCondition.Release();
      }
      tradingCalculator.Release();
      tradingCalculator = NULL;
      Print("Error: " + error);
      return INIT_FAILED;
   }

   actions = new ActionOnConditionLogic();

   AOrderAction* trailingAction = CreateTrailing(_Symbol, (ENUM_TIMEFRAMES)_Period, actions);
   if (trailingAction != NULL)
   {
      trailingAction.RestoreActions(_Symbol, magic_number);
      orderHandlers.AddOrderAction(trailingAction);
      trailingAction.Release();
   }

   if (mandatory_closing && tradingTimeCondition != NULL)
   {
      NotCondition* condition = new NotCondition(tradingTimeCondition);
      IAction* action = new CloseAllAction(magic_number, slippage_points);
      actions.AddActionOnCondition(action, condition);
      action.Release();
      condition.Release();
   }

   if (breakeven_type != StopLimitDoNotUse)
   {
      #ifndef USE_NET_BREAKEVEN
         MoveStopLossOnProfitOrderAction* orderAction = new MoveStopLossOnProfitOrderAction(breakeven_type, breakeven_value, breakeven_level, NULL, actions);
         orderAction.RestoreActions(_Symbol, magic_number);
         orderHandlers.AddOrderAction(orderAction);
         orderAction.Release();
      #endif
   }

   CreateActions(_Symbol, (ENUM_TIMEFRAMES)_Period, tradingCalculator, tradingTimeCondition);

   if (tradingTimeCondition != NULL)
   {
      tradingTimeCondition.Release();
   }
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   orderHandlers.Clear();
   orderHandlers.Release();
   delete actions;
   if (tradingCalculator != NULL)
   {
      tradingCalculator.Release();
   }
}

void OnTick()
{
   int index = trigger_logic == TradingModeLive ? 0 : 1;
   actions.DoLogic(index, Time[index]);
}
