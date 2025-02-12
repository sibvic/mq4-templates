// Risk lots provider v2.3
#include <MoneyManagement/ILotsProvider.mqh>
#include <MoneyManagement/IStopLossStrategy.mqh>
#include <enums/PositionSizeType.mqh>
#include <TradingCalculator.mqh>

#ifndef RiskLotsProvider_IMP
#define RiskLotsProvider_IMP

class RiskLotsProvider : public ILotsProvider
{
   PositionSizeType _lotsType;
   ILotsProvider* _lotsValue;
   TradingCalculator *_calculator;
   IStopLossStrategy* _stopLoss;
   int refs;
public:
   RiskLotsProvider(TradingCalculator *calculator, PositionSizeType lotsType, double lots, IStopLossStrategy* stopLoss)
   {
      refs = 1;
      _stopLoss = stopLoss;
      _calculator = calculator;
      _calculator.AddRef();
      _lotsType = lotsType;
      _lotsValue = new ConstLotsValueProvider(lots);
   }

   RiskLotsProvider(TradingCalculator *calculator, PositionSizeType lotsType, ILotsProvider* lotsValue, IStopLossStrategy* stopLoss)
   {
      refs = 1;
      _stopLoss = stopLoss;
      _calculator = calculator;
      _calculator.AddRef();
      _lotsType = lotsType;
      _lotsValue = lotsValue;
      _lotsValue.AddRef();
   }

   ~RiskLotsProvider()
   {
      _calculator.Release();
      _lotsValue.Release();
   }

   void AddRef()
   {
      ++refs;
   }

   void Release()
   {
      --refs;
      if (refs == 0)
         delete &this;
   }

   virtual double GetValue(int period, double entryPrice)
   {
      double sl = _stopLoss.GetValue(period, entryPrice);
      return _calculator.GetLots(_lotsType, _lotsValue.GetValue(period, entryPrice), MathAbs(sl - entryPrice));
   }
};

#endif