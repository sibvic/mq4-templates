// Dollar stop loss stream v1.0

#ifndef DollarStopLossProvider_IMP
#define DollarStopLossProvider_IMP

class DollarStopLossProvider : public IStopLossProvider
{
   TradingCalculator* _calculator;
   StopLimitType _stopLossType;
   double _stopLoss;
   bool _isBuy;
   ILotsProvider* _lotsProvider;
public:
   DollarStopLossProvider(TradingCalculator* calculator, StopLimitType stopLossType, double stopLoss, bool isBuy, ILotsProvider* lotsProvider)
   {
      _lotsProvider = lotsProvider;
      _isBuy = isBuy;
      _stopLoss = stopLoss;
      _stopLossType = stopLossType;
      _calculator = calculator;
   }

   virtual double GetValue(const int period, double entryPrice)
   {
      double amount = _lotsProvider.GetLots();
      return _calculator.CalculateStopLoss(_isBuy, _stopLoss, _stopLossType, amount, entryPrice);
   }
};

#endif