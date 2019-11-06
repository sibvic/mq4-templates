// Price moved from trade open condition v1.0

#include <ABaseCondition.mq4>
#include <../TradingCalculator.mq4>

#ifndef PriceMovedFromTradeOpenCondition_IMP
#define PriceMovedFromTradeOpenCondition_IMP

class PriceMovedFromTradeOpenCondition : public ABaseCondition
{
   MartingaleStepSizeType _stepUnit;
   double _step;
   TradingCalculator *_calculator;
public:
   PriceMovedFromTradeOpenCondition(string symbol, ENUM_TIMEFRAMES timeframe, MartingaleStepSizeType stepUnit, double step)
      :ABaseCondition(symbol, timeframe)
   {
      _stepUnit = stepUnit;
      _step = step;
      _calculator = NULL;
   }

   ~PriceMovedFromTradeOpenCondition()
   {
      delete _calculator;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      string symbol = OrderSymbol();
      if (_calculator == NULL || _calculator.GetSymbol() != symbol)
      {
         delete _calculator;
         _calculator = TradingCalculator::Create(symbol);
      }

      if (OrderType() == OP_BUY)
         return NeedAnotherBuy();
      return NeedAnotherSell();
   }
private:
   bool NeedAnotherSell()
   {
      switch (_stepUnit)
      {
         case MartingaleStepSizePips:
            return (_calculator.GetBid() - OrderOpenPrice()) / _calculator.GetPipSize() > _step;
         case MartingaleStepSizePercent:
            {
               double openPrice = OrderOpenPrice();
               return (_calculator.GetBid() - openPrice) / openPrice > _step / 100.0;
            }
      }
      return false;
   }

   bool NeedAnotherBuy()
   {
      switch (_stepUnit)
      {
         case MartingaleStepSizePips:
            return (OrderOpenPrice() - _calculator.GetAsk()) / _calculator.GetPipSize() > _step;
         case MartingaleStepSizePercent:
            {
               double openPrice = OrderOpenPrice();
               return (openPrice - _calculator.GetAsk()) / openPrice > _step / 100.0;
            }
      }
      return false;
   }
};

#endif