// Default stop loss and amount strategy v1.0

#include <IStopLossAndAmountStrategy.mq4>
#include <../TradingCalculator.mq4>

#ifndef DefaultStopLossAndAmountStrategy_IMP
#define DefaultStopLossAndAmountStrategy_IMP

class DefaultStopLossAndAmountStrategy : public IStopLossAndAmountStrategy
{
   PositionSizeType _lotsType;
   double _lots;
   TradingCalculator *_calculator;
   StopLimitType _stopLossType;
   double _stopLoss;
   bool _isBuy;
public:
   DefaultStopLossAndAmountStrategy(TradingCalculator *calculator, PositionSizeType lotsType, double lots,
      StopLimitType stopLossType, double stopLoss, bool isBuy)
   {
      _isBuy = isBuy;
      _calculator = calculator;
      _lotsType = lotsType;
      _lots = lots;
      _stopLossType = stopLossType;
      _stopLoss = stopLoss;
   }
   
   void GetStopLossAndAmount(const int period, const double entryPrice, double &amount, double &stopLoss)
   {
      amount = _calculator.GetLots(_lotsType, _lots, 0.0);
      stopLoss = _calculator.CalculateStopLoss(_isBuy, _stopLoss, _stopLossType, amount, entryPrice);
   }
};

#endif