#include <../enums/TakeProfitType.mq4>
#include <../enums/StopLossType.mq4>
#include <../enums/PositionSizeType.mq4>
#include <IStopLossStrategy.mq4>
#include <DefaultStopLossStrategy.mq4>
#include <HighLowStopLossStrategy.mq4>
#include <MoneyManagementStrategy.mq4>
#include <ATRStopLossStrategy.mq4>
#include <RiskBalanceStopLossStrategy.mq4>
#include <ILotsProvider.mq4>
#include <RiskLotsProvider.mq4>
#include <DefaultLotsProvider.mq4>
#include <DollarStopLossStrategy.mq4>
#include <ITakeProfitStrategy.mq4>
#include <DefaultTakeProfitStrategy.mq4>
#include <RiskToRewardTakeProfitStrategy.mq4>
#include <ATRTakeProfitStrategy.mq4>
#include <../TradingCalculator.mq4>

#ifndef MoneyManagementFunctions_IMP
#define MoneyManagementFunctions_IMP

IStopLossStrategy* CreateStopLossStrategy(TradingCalculator* tradingCalculator, string symbol,
   ENUM_TIMEFRAMES timeframe, bool isBuy, StopLossType stopLossType, double stopLossValue, double stopLosstAtrMultiplicator)
{
   switch (stopLossType)
   {
      case SLDoNotUse:
         return new DefaultStopLossStrategy(tradingCalculator, StopLimitDoNotUse, stopLossValue, isBuy);
      case SLPercent:
         return new DefaultStopLossStrategy(tradingCalculator, StopLimitPercent, stopLossValue, isBuy);
      case SLPips:
         return new DefaultStopLossStrategy(tradingCalculator, StopLimitPips, stopLossValue, isBuy);
      case SLAbsolute:
         return new DefaultStopLossStrategy(tradingCalculator, StopLimitAbsolute, stopLossValue, isBuy);
      case SLHighLow:
         return new HighLowStopLossStrategy((int)stopLossValue, isBuy, symbol, timeframe);
      case SLAtr:
         return new ATRStopLossStrategy(symbol, timeframe, (int)stopLossValue, stopLosstAtrMultiplicator, isBuy);
      case SLDollar:
      case SLRiskBalance:
         Print("Not supported stop loss and amount types");
         return NULL; // Not supported at all
   }
   return NULL;
}

MoneyManagementStrategy* CreateMoneyManagementStrategy(TradingCalculator* tradingCalculator, string symbol,
   ENUM_TIMEFRAMES timeframe, bool isBuy, PositionSizeType lotsType, double lotsValue,
   StopLossType stopLossType, double stopLossValue, double stopLosstAtrMultiplicator,
   TakeProfitType takeProfitType, double takeProfitValue, double takeProfitAtrMultiplicator)
{
   ILotsProvider* lots = NULL;
   IStopLossStrategy* stopLoss = NULL;
   switch (lotsType)
   {
      case PositionSizeRisk:
         stopLoss = CreateStopLossStrategy(tradingCalculator, symbol, timeframe, isBuy, stopLossType, stopLossValue, stopLosstAtrMultiplicator);
         lots = new RiskLotsProvider(tradingCalculator, lotsType, lotsValue, stopLoss);
         break;
      default:
         lots = new DefaultLotsProvider(tradingCalculator, lotsType, lotsValue);
         switch (stopLossType)
         {
            case SLDollar:
               stopLoss = new DollarStopLossStrategy(tradingCalculator, stopLossValue, isBuy, lots);
               break;
            case SLRiskBalance:
               stopLoss = new RiskBalanceStopLossStrategy(tradingCalculator, stopLossValue, isBuy, lots);
               break;
            default:
               stopLoss = CreateStopLossStrategy(tradingCalculator, symbol, timeframe, isBuy, stopLossType, stopLossValue, stopLosstAtrMultiplicator);
               break;
         }
         break;
   }
   ITakeProfitStrategy* tp = NULL;
   switch (takeProfitType)
   {
      case TPDoNotUse:
         tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitDoNotUse, takeProfitValue, isBuy);
         break;
      #ifdef TAKE_PROFIT_FEATURE
         case TPPercent:
            tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitPercent, takeProfitValue, isBuy);
            break;
         case TPPips:
            tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitPips, takeProfitValue, isBuy);
            break;
         case TPDollar:
            tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitDollar, takeProfitValue, isBuy);
            break;
         case TPRiskReward:
            tp = new RiskToRewardTakeProfitStrategy(takeProfitValue, isBuy);
            break;
         case TPAbsolute:
            tp = new DefaultTakeProfitStrategy(tradingCalculator, StopLimitAbsolute, takeProfitValue, isBuy);
            break;
         case TPAtr:
            tp = new ATRTakeProfitStrategy(symbol, timeframe, (int)takeProfitValue, takeProfitAtrMultiplicator, isBuy);
            break;
      #endif
   }
   
   return new MoneyManagementStrategy(lots, stopLoss, tp);
}
#endif