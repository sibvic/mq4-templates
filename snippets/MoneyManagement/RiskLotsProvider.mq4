// Risk lots provider v1.0

#ifndef RiskLotsProvider_IMP
#define RiskLotsProvider_IMP

class RiskLotsProvider : public ILotsProvider
{
   PositionSizeType _lotsType;
   double _lots;
   TradingCalculator *_calculator;
public:
   RiskLotsProvider(TradingCalculator *calculator, PositionSizeType lotsType, double lots, IStopLossStrategy* stopLoss)
   {
      _stopLoss = stopLoss;
      _calculator = calculator;
      _lotsType = lotsType;
      _lots = lots;
   }

   virtual double GetLots(int period, double entryPrice)
   {
      double stopLoss = stopLoss.GetValue(period, entryPrice);
      return _calculator.GetLots(_lotsType, _lots, stopLoss);
   }
};

#endif