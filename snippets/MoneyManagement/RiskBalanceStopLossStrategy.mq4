#include <IStopLossStrategy.mq4>

// Risks % of the balance v1.1

#ifndef RiskBalanceStopLossStrategy_IMP
#define RiskBalanceStopLossStrategy_IMP

class RiskBalanceStopLossStrategy : public IStopLossStrategy
{
   TradingCalculator* _calculator;
   double _stopLoss;
   bool _isBuy;
   ILotsProvider* _lotsStrategy;
public:
   RiskBalanceStopLossStrategy(TradingCalculator* calculator, double stopLoss, bool isBuy, ILotsProvider* lotsStrategy)
   {
      _lotsStrategy = lotsStrategy;
      _isBuy = isBuy;
      _stopLoss = stopLoss / 100.0;
      _calculator = calculator;
      _calculator.AddRef();
   }

   ~RiskBalanceStopLossStrategy()
   {
      _calculator.Release();
   }

   virtual double GetValue(const int period, double entryPrice)
   {
      double amount = _lotsStrategy.GetValue(period, entryPrice);
      double dollars = AccountBalance() * _stopLoss;

      return _calculator.CalculateStopLoss(_isBuy, dollars, StopLimitDollar, amount, entryPrice);
   }
};

#endif