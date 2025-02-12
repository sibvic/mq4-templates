// Default lots provider v2.2

#include <MoneyManagement/ConstLotsValueProvider.mqh>

#ifndef DefaultLotsProvider_IMP
#define DefaultLotsProvider_IMP
class DefaultLotsProvider : public ILotsProvider
{
   PositionSizeType _lotsType;
   ILotsProvider* _lots;
   TradingCalculator *_calculator;
   int refs;
public:
   DefaultLotsProvider(TradingCalculator *calculator, PositionSizeType lotsType, double lots)
   {
      refs = 1;
      _calculator = calculator;
      _calculator.AddRef();
      _lotsType = lotsType;
      _lots = new ConstLotsValueProvider(lots);
   }

   DefaultLotsProvider(TradingCalculator *calculator, PositionSizeType lotsType, ILotsProvider* lots)
   {
      refs = 1;
      _calculator = calculator;
      _calculator.AddRef();
      _lotsType = lotsType;
      _lots = lots;
      _lots.AddRef();
   }

   ~DefaultLotsProvider()
   {
      _calculator.Release();
      _lots.Release();
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
      return _calculator.GetLots(_lotsType, _lots.GetValue(period, entryPrice), 0.0);
   }
};

#endif