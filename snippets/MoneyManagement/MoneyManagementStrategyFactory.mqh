// Money management strategy factor v1.0
#include <MoneyManagement/ConstLotsValueProvider.mqh>
#include <MoneyManagement/MoneyManagementStrategy.mqh>

#ifndef MoneyManagementStrategyFactory_IMPL
#define MoneyManagementStrategyFactory_IMPL

class MoneyManagementStrategyFactory
{
public:
   static MoneyManagementStrategy* Create(TradingCalculator* tradingCalculator, string symbol,
      ENUM_TIMEFRAMES timeframe, bool isBuy, PositionSizeType lotsType, ILotsProvider* lotsValue,
      StopLossType stopLossType, double stopLossValue, double stopLossAtrMultiplicator,
      TakeProfitType takeProfitType, double takeProfitValue, double takeProfitAtrMultiplicator)
   {
      ILotsProvider* lots = NULL;
      IStopLossStrategy* stopLoss = NULL;
      switch (lotsType)
      {
         case PositionSizeRisk:
            stopLoss = CreateStopLossStrategy(tradingCalculator, symbol, timeframe, isBuy, stopLossType, stopLossValue, stopLossAtrMultiplicator);
            lots = new RiskLotsProvider(tradingCalculator, lotsType, lotsValue, stopLoss);
            break;
         default:
            lots = new DefaultLotsProvider(tradingCalculator, lotsType, lotsValue);
            stopLoss = CreateStopLossStrategyForLots(lots, tradingCalculator, symbol, timeframe, isBuy, stopLossType, stopLossValue, stopLossAtrMultiplicator);
            break;
      }
      ITakeProfitStrategy* tp = CreateTakeProfitStrategy(tradingCalculator, symbol, timeframe, isBuy, takeProfitType, takeProfitValue, takeProfitAtrMultiplicator);
      return new MoneyManagementStrategy(lots, stopLoss, tp);
   }
   
   static MoneyManagementStrategy* Create(TradingCalculator* tradingCalculator, string symbol,
      ENUM_TIMEFRAMES timeframe, bool isBuy, PositionSizeType lotsType, double lotsValue,
      StopLossType stopLossType, double stopLossValue, double stopLossAtrMultiplicator,
      TakeProfitType takeProfitType, double takeProfitValue, double takeProfitAtrMultiplicator)
   {
      ConstLotsValueProvider* lotsValueProvider = new ConstLotsValueProvider(lotsValue);
      MoneyManagementStrategy* strategy = Create(tradingCalculator, symbol, timeframe, isBuy, lotsType, lotsValueProvider,
         stopLossType, stopLossValue, stopLossAtrMultiplicator, takeProfitType, takeProfitValue, takeProfitAtrMultiplicator);
      lotsValueProvider.Release();
      return strategy;
   }
};
#endif