// Base EA template
// More templates and snippets on https://github.com/sibvic/mq4-templates

#property version   "1.0"
#property description "Developed by Victor Tereschenko: sibvic@gmail.com"
#property strict

#define ACT_ON_SWITCH_CONDITION
#define SHOW_ACCOUNT_STAT
#define REVERSABLE_LOGIC_FEATURE
#define STOP_LOSS_FEATURE input
#define NET_STOP_LOSS_FEATURE
#define USE_NET_BREAKEVEN
#define TAKE_PROFIT_FEATURE input
#define NET_TAKE_PROFIT_FEATURE
#define MARTINGALE_FEATURE
#define USE_MARKET_ORDERS
#define WEEKLY_TRADING_TIME_FEATURE
#define TRADING_TIME_FEATURE
#define POSITION_CAP_FEATURE 
#define WITH_EXIT_LOGIC

#ifdef SHOW_ACCOUNT_STAT
   string EA_NAME = "[EA NAME]";
#endif

enum TradingMode
{
   TradingModeLive, // Live
   TradingModeOnBarClose // On bar close
};

input string GeneralSection = ""; // == General ==
input string GeneralSectionDesc = "https://github.com/sibvic/mq4-templates/wiki/EA_Base-template-parameters"; // Description of parameters could be found at
input ENUM_TIMEFRAMES trading_timeframe = PERIOD_CURRENT; // Trading timeframe
input bool ecn_broker = false; // ECN Broker? 
input TradingMode entry_logic = TradingModeLive; // Entry logic
#ifdef WITH_EXIT_LOGIC
   input TradingMode exit_logic = TradingModeLive; // Exit logic
#endif
enum PositionSizeType
{
   PositionSizeAmount, // $
   PositionSizeContract, // In contracts
   PositionSizeEquity, // % of equity
   PositionSizeRisk // Risk in % of equity
};
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
#endif

#ifdef MARTINGALE_FEATURE
   input string MartingaleSection = ""; // == Martingale type ==
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
   input MartingaleType martingale_type = MartingaleDoNotUse; // Martingale type
   input MartingaleLotSizingType martingale_lot_sizing_type = MartingaleLotSizingNo; // Martingale lot sizing type
   input double martingale_lot_value = 1.5; // Matringale lot sizing value
   input MartingaleStepSizeType martingale_step_type = MartingaleStepSizePercent; // Step unit
   input double martingale_step = 5; // Open matringale position step
#endif

STOP_LOSS_FEATURE string StopLossSection            = ""; // == Stop loss ==
enum TrailingType
{
   TrailingDontUse, // No trailing
   TrailingPips // Use trailing in pips
};
enum StopLossType
{
   SLDoNotUse, // Do not use
   SLPercent, // Set in %
   SLPips, // Set in Pips
   SLDollar, // Set in $,
   SLAbsolute, // Set in absolite value (rate),
   SLAtr // Set in ATR(value) * mult
};
enum StopLimitType
{
   StopLimitDoNotUse, // Do not use
   StopLimitPercent, // Set in %
   StopLimitPips, // Set in Pips
   StopLimitDollar, // Set in $,
   StopLimitRiskReward, // Set in % of stop loss (take profit only)
   StopLimitAbsolute // Set in absolite value (rate)
};
#ifdef STOP_LOSS_FEATURE
   input StopLossType stop_loss_type = SLDoNotUse; // Stop loss type
   input double stop_loss_value            = 10; // Stop loss value
   input TrailingType trailing_type = TrailingDontUse; // Trailing type
   input double trailing_step = 10; // Trailing step
   input double trailing_start = 0; // Min distance to order to activate the trailing
   input StopLimitType breakeven_type = StopLimitDoNotUse; // Trigger type for the breakeven
   input double breakeven_value = 10; // Trigger for the breakeven
   input double breakeven_level = 0; // Breakeven target
#endif
#ifdef NET_STOP_LOSS_FEATURE
   input StopLimitType net_stop_loss_type = StopLimitDoNotUse; // Net stop loss type
   input double net_stop_loss_value = 10; // Net stop loss value
#endif

enum TakeProfitType
{
   TPDoNotUse, // Do not use
   TPPercent, // Set in %
   TPPips, // Set in Pips
   TPDollar, // Set in $,
   TPRiskReward, // Set in % of stop loss
   TPAbsolute, // Set in absolite value (rate),
   TPAtr // Set in ATR(value) * mult
};
#ifdef TAKE_PROFIT_FEATURE
   input string TakeProfitSection            = ""; // == Take Profit ==
   input TakeProfitType take_profit_type = TPDoNotUse; // Take profit type
   input double take_profit_value           = 10; // Take profit value
   input double take_profit_atr_multiplicator = 1; // Take profit multiplicator (for ATR TP)
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
   input StopLimitType net_take_profit_type = StopLimitDoNotUse; // Net take profit type
   input double net_take_profit_value = 10; // Net take profit value
#endif

#include <enums/DayOfWeek.mq4>
input string OtherSection            = ""; // == Other ==
input int magic_number        = 42; // Magic number
#ifdef TRADING_TIME_FEATURE
   input string start_time = "000000"; // Start time in hhmmss format
   input string stop_time = "000000"; // Stop time in hhmmss format
   input bool mandatory_closing = false; // Mandatory closing for non-trading time
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
input bool PrintLog = false; // Print decisions into the log (On bar close only!)

#include <Signaler.mq4>
#include <InstrumentInfo.mq4>
#include <conditions/ActOnSwitchCondition.mq4>
#include <conditions/DisabledCondition.mq4>
#include <Streams/AStream.mq4>
#ifndef USE_MARKET_ORDERS
   class LongEntryStream : public AStream
   {
   public:
      LongEntryStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
         :AStream(symbol, timeframe)
      {
      }

      bool GetValue(const int period, double &val)
      {
         val = iHigh(_symbol, _timeframe, period);
         return true;
      }
   };

   class ShortEntryStream : public AStream
   {
   public:
      ShortEntryStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
         :AStream(symbol, timeframe)
      {
      }

      bool GetValue(const int period, double &val)
      {
         val = iHigh(_symbol, _timeframe, period);
         return true;
      }
   };
#endif

#include <OrdersIterator.mq4>
#include <TradingCalculator.mq4>
#include <Order.mq4>
#include <Actions/AAction.mq4>
#include <Logic/ActionOnConditionController.mq4>
#include <Logic/ActionOnConditionLogic.mq4>
#include <Conditions/HitProfitCondition.mq4>
#ifdef NET_STOP_LOSS_FEATURE
#include <Actions/MoveNetStopLossAction.mq4>
#endif
#ifdef NET_TAKE_PROFIT_FEATURE
#include <Actions/MoveNetTakeProfitAction.mq4>
#endif
#include <MoneyManagement/MoneyManagementStrategy.mq4>
#include <MoneyManagement/RiskToRewardTakeProfitStrategy.mq4>
#include <MoneyManagement/PositionSizeRiskStopLossAndAmountStrategy.mq4>
#include <MoneyManagement/DefaultTakeProfitStrategy.mq4>
#include <MoneyManagement/ATRTakeProfitStrategy.mq4>
#include <MoneyManagement/DefaultStopLossAndAmountStrategy.mq4>
#ifdef MARTINGALE_FEATURE
#include <MartingaleStrategy.mq4>
#endif
#include <TradingCommands.mq4>
#include <CloseOnOpposite.mq4>
#ifdef POSITION_CAP_FEATURE
#include <PositionCap.mq4>
#endif
#include <OrderBuilder.mq4>
#include <MarketOrderBuilder.mq4>
#include <EntryStrategy.mq4>
#include <Actions/MoveStopLossOnProfitOrderAction.mq4>
#include <TradingController.mq4>
#include <Conditions/NoCondition.mq4>
#include <AccountStatistics.mq4>

TradingController *controllers[];
#ifdef SHOW_ACCOUNT_STAT
   AccountStatistics *stats;
#endif

#include <actions/CreateTrailingAction.mq4>
#include <actions/CloseAllAction.mq4>

#include <conditions/ABaseCondition.mq4>
#include <conditions/TradingTimeCondition.mq4>
#include <conditions/AndCondition.mq4>
#include <conditions/OrCondition.mq4>
#include <conditions/NotCondition.mq4>
#ifdef MARTINGALE_FEATURE
   #include <conditions/PriceMovedFromTradeOpenCondition.mq4>
#endif

class LongCondition : public ABaseCondition
{
public:
   LongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ShortCondition : public ABaseCondition
{
public:
   ShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ExitLongCondition : public ABaseCondition
{
public:
   ExitLongCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

class ExitShortCondition : public ABaseCondition
{
public:
   ExitShortCondition(const string symbol, ENUM_TIMEFRAMES timeframe)
      :ABaseCondition(symbol, timeframe)
   {

   }
   
   bool IsPass(const int period, const datetime date)
   {
      //TODO: implement
      return false;
   }
};

ICondition* CreateLongCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   if (trading_side == ShortSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }

   AndCondition* condition = new AndCondition();
   condition.Add(new LongCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      return (ICondition*) new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
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
   return new NoCondition();
}

ICondition* CreateShortCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   if (trading_side == LongSideOnly)
   {
      return (ICondition *)new DisabledCondition();
   }

   AndCondition* condition = new AndCondition();
   condition.Add(new ShortCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      return (ICondition*) new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
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
   return new NoCondition();
}

ICondition* CreateExitLongCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   AndCondition* condition = new AndCondition();
   condition.Add(new ExitLongCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      return (ICondition*) new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
   #else
      return (ICondition *)condition;
   #endif
}

ICondition* CreateExitShortCondition(string symbol, ENUM_TIMEFRAMES timeframe)
{
   AndCondition* condition = new AndCondition();
   condition.Add(new ExitShortCondition(symbol, timeframe), false);
   #ifdef ACT_ON_SWITCH_CONDITION
      return (ICondition*) new ActOnSwitchCondition(symbol, timeframe, (ICondition*) condition);
   #else
      return (ICondition *)condition;
   #endif
}

MoneyManagementStrategy* CreateMoneyManagementStrategy(TradingCalculator* tradingCalculator, string symbol,
   ENUM_TIMEFRAMES timeframe, bool isBuy)
{
   IStopLossAndAmountStrategy* sl = NULL;
   switch (stop_loss_type)
   {
      case SLDoNotUse:
         {
            if (lots_type == PositionSizeRisk)
               sl = new PositionSizeRiskStopLossAndAmountStrategy(tradingCalculator, lots_value, StopLimitDoNotUse, stop_loss_value, isBuy);
            else
               sl = new DefaultStopLossAndAmountStrategy(tradingCalculator, lots_type, lots_value, StopLimitDoNotUse, stop_loss_value, isBuy);
         }
         break;
      case SLPercent:
         {
            if (lots_type == PositionSizeRisk)
               sl = new PositionSizeRiskStopLossAndAmountStrategy(tradingCalculator, lots_value, StopLimitPercent, stop_loss_value, isBuy);
            else
               sl = new DefaultStopLossAndAmountStrategy(tradingCalculator, lots_type, lots_value, StopLimitPercent, stop_loss_value, isBuy);
         }
         break;
      case SLPips:
         {
            if (lots_type == PositionSizeRisk)
               sl = new PositionSizeRiskStopLossAndAmountStrategy(tradingCalculator, lots_value, StopLimitPips, stop_loss_value, isBuy);
            else
               sl = new DefaultStopLossAndAmountStrategy(tradingCalculator, lots_type, lots_value, StopLimitPips, stop_loss_value, isBuy);
         }
         break;
      case SLDollar:
         {
            if (lots_type == PositionSizeRisk)
               sl = new PositionSizeRiskStopLossAndAmountStrategy(tradingCalculator, lots_value, StopLimitDollar, stop_loss_value, isBuy);
            else
               sl = new DefaultStopLossAndAmountStrategy(tradingCalculator, lots_type, lots_value, StopLimitDollar, stop_loss_value, isBuy);
         }
         break;
      case SLAbsolute:
         {
            if (lots_type == PositionSizeRisk)
               sl = new PositionSizeRiskStopLossAndAmountStrategy(tradingCalculator, lots_value, StopLimitAbsolute, stop_loss_value, isBuy);
            else
               sl = new DefaultStopLossAndAmountStrategy(tradingCalculator, lots_type, lots_value, StopLimitAbsolute, stop_loss_value, isBuy);
         }
         break;
   }
   ITakeProfitStrategy* tp = NULL;
   switch (take_profit_type)
   {
      case TPDoNotUse:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitDoNotUse, take_profit_value, isBuy);
         break;
      case TPPercent:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitPercent, take_profit_value, isBuy);
         break;
      case TPPips:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitPips, take_profit_value, isBuy);
         break;
      case TPDollar:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitDollar, take_profit_value, isBuy);
         break;
      case TPRiskReward:
         tp = new RiskToRewardTakeProfitStrategy(take_profit_value, isBuy);
         break;
      case TPAbsolute:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitAbsolute, take_profit_value, isBuy);
         break;
      case TPAtr:
         tp = new ATRTakeProfitStrategy(symbol, timeframe, (int)take_profit_value, take_profit_atr_multiplicator, isBuy);
         break;
   }
   
   return new MoneyManagementStrategy(sl, tp);
}

TradingController *CreateController(const string symbol, const ENUM_TIMEFRAMES timeframe, string &error)
{
   #ifdef TRADING_TIME_FEATURE
      ICondition* tradingTimeCondition = CreateTradingTimeCondition(start_time, stop_time, use_weekly_timing,
         week_start_day, week_start_time, week_stop_day, 
         week_stop_time, error);
      if (tradingTimeCondition == NULL)
         return NULL;
   #endif

   TradingCalculator* tradingCalculator = TradingCalculator::Create(symbol);
   if (!tradingCalculator.IsLotsValid(lots_value, lots_type, error))
   {
      tradingTimeCondition.Release();
      delete tradingCalculator;
      return NULL;
   }

   Signaler* signaler = new Signaler(symbol, timeframe);
   signaler.SetMessagePrefix(symbol + "/" + signaler.GetTimeframeStr() + ": ");
   
   TradingController* controller = new TradingController(tradingCalculator, timeframe, timeframe, signaler);
   
   ActionOnConditionLogic* actions = new ActionOnConditionLogic();
   controller.SetActions(actions);
   controller.SetECNBroker(ecn_broker);
   
   if (breakeven_type != StopLimitDoNotUse)
   {
      #ifdef USE_NET_BREAKEVEN
      //TODO:controller.SetBreakeven(new NetBreakevenLogic(tradingCalculator, breakeven_type, breakeven_value, breakeven_level, signaler));
      #else
      MoveStopLossOnProfitOrderAction* orderAction = new MoveStopLossOnProfitOrderAction(breakeven_type, breakeven_value, breakeven_level, signaler, actions);
      controller.AddOrderAction(orderAction);
      orderAction.Release();
      #endif
   }

   switch (trailing_type)
   {
      case TrailingDontUse:
         break;
   #ifdef INDICATOR_BASED_TRAILING
      case TrailingIndicator:
         break;
   #endif
      case TrailingPips:
         {
            CreateTrailingAction* trailingAction = new CreateTrailingAction(trailing_start, trailing_step, actions);
            controller.AddOrderAction(trailingAction);
            trailingAction.Release();
         }
         break;
   }

   #ifdef MARTINGALE_FEATURE
      switch (martingale_type)
      {
         case MartingaleDoNotUse:
            controller.SetShortMartingaleStrategy(new NoMartingaleStrategy());
            controller.SetLongMartingaleStrategy(new NoMartingaleStrategy());
            break;
         case MartingaleOnLoss:
            {
               PriceMovedFromTradeOpenCondition* condition = new PriceMovedFromTradeOpenCondition(symbol, timeframe, martingale_step_type, martingale_step);
               controller.SetShortMartingaleStrategy(new ActiveMartingaleStrategy(tradingCalculator, martingale_lot_sizing_type, martingale_lot_value, condition));
               controller.SetLongMartingaleStrategy(new ActiveMartingaleStrategy(tradingCalculator, martingale_lot_sizing_type, martingale_lot_value, condition));
               condition.Release();
            }
            break;
      }
   #endif

   AndCondition* longCondition = new AndCondition();
   longCondition.Add(CreateLongCondition(symbol, timeframe), false);
   AndCondition* shortCondition = new AndCondition();
   shortCondition.Add(CreateShortCondition(symbol, timeframe), false);
   #ifdef TRADING_TIME_FEATURE
      longCondition.Add(tradingTimeCondition, true);
      shortCondition.Add(tradingTimeCondition, true);
   #endif
   tradingTimeCondition.Release();

   ICondition* longFilterCondition = CreateLongFilterCondition(symbol, timeframe);
   ICondition* shortFilterCondition = CreateShortFilterCondition(symbol, timeframe);

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
         controller.SetLongCondition(longCondition);
         controller.SetLongFilterCondition(longFilterCondition);
         controller.SetShortCondition(shortCondition);
         controller.SetShortFilterCondition(shortFilterCondition);
         controller.SetExitLongCondition(exitLongCondition);
         controller.SetExitShortCondition(exitShortCondition);
         break;
      case ReversalLogic:
         controller.SetLongCondition(shortCondition);
         controller.SetLongFilterCondition(shortFilterCondition);
         controller.SetShortCondition(longCondition);
         controller.SetShortFilterCondition(longFilterCondition);
         controller.SetExitLongCondition(exitShortCondition);
         controller.SetExitShortCondition(exitLongCondition);
         break;
   }
   if (mandatory_closing)
   {
      NotCondition* condition = new NotCondition(tradingTimeCondition);
      IAction* action = new CloseAllAction(magic_number, slippage_points);
      actions.AddActionOnCondition(action, condition);
      action.Release();
      condition.Release();
   }
   
   IMoneyManagementStrategy* longMoneyManagement = CreateMoneyManagementStrategy(tradingCalculator, symbol, timeframe, true);
   IMoneyManagementStrategy* shortMoneyManagement = CreateMoneyManagementStrategy(tradingCalculator, symbol, timeframe, false);
   controller.AddLongMoneyManagement(longMoneyManagement);
   controller.AddShortMoneyManagement(shortMoneyManagement);

   #ifdef NET_STOP_LOSS_FEATURE
      if (net_stop_loss_type != StopLimitDoNotUse)
      {
         IAction* action = new MoveNetStopLossAction(tradingCalculator, net_stop_loss_type, net_stop_loss_value, signaler, magic_number);
         NoCondition* condition = new NoCondition();
         actions.AddActionOnCondition(action, condition);
         action.Release();
      }
   #endif
   #ifdef NET_TAKE_PROFIT_FEATURE
      if (net_take_profit_type != StopLimitDoNotUse)
      {
         IAction* action = new MoveNetTakeProfitAction(tradingCalculator, net_take_profit_type, net_take_profit_value, signaler, magic_number);
         NoCondition* condition = new NoCondition();
         actions.AddActionOnCondition(action, condition);
         action.Release();
      }
   #endif

   if (close_on_opposite)
      controller.SetCloseOnOpposite(new DoCloseOnOppositeStrategy(slippage_points, magic_number));
   else
      controller.SetCloseOnOpposite(new DontCloseOnOppositeStrategy());

   #ifdef POSITION_CAP_FEATURE
      if (position_cap)
      {
         controller.SetLongPositionCap(new PositionCapStrategy(BuySide, magic_number, no_of_buy_position, no_of_positions, symbol));
         controller.SetShortPositionCap(new PositionCapStrategy(SellSide, magic_number, no_of_sell_position, no_of_positions, symbol));
      }
      else
      {
         controller.SetLongPositionCap(new NoPositionCapStrategy());
         controller.SetShortPositionCap(new NoPositionCapStrategy());
      }
   #endif

   controller.SetEntryLogic(entry_logic);
   #ifdef USE_MARKET_ORDERS
      controller.SetEntryStrategy(new MarketEntryStrategy(symbol, magic_number, slippage_points, actions));
   #else
      AStream *longPrice = new LongEntryStream(symbol, timeframe);
      AStream *shortPrice = new ShortEntryStream(symbol, timeframe);
      controller.SetEntryStrategy(new PendingEntryStrategy(symbol, magic_number, slippage_points, longPrice, shortPrice, actions));
   #endif
   controller.SetPrintLog(PrintLog);

   return controller;
}

int OnInit()
{
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

   string error;
   TradingController *controller = CreateController(_Symbol, trading_timeframe, error);
   if (controller == NULL)
   {
      Print(error);
      return INIT_FAILED;
   }
   int controllersCount = 0;
   ArrayResize(controllers, controllersCount + 1);
   controllers[controllersCount++] = controller;
   
   #ifdef SHOW_ACCOUNT_STAT
      stats = new AccountStatistics(EA_NAME);
   #endif
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
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
