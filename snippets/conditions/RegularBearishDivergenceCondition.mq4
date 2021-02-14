// Regilar bearish divergence condition v1.2

#ifndef RegularBearishDivergenceCondition_IMP
#define RegularBearishDivergenceCondition_IMP

#include <TroughCondition.mq4>
#include <PeakCondition.mq4>
#include <../streams/PriceStream.mq4>

class RegularBearishDivergenceCondition : public AConditionBase
{
   TroughCondition* _trough;
   PeakCondition* _pricePeak;
public:
   RegularBearishDivergenceCondition(IStream* stream, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _trough = new TroughCondition(stream, 2);
      SimplePriceStream* high = new SimplePriceStream(symbol, timeframe, PriceHigh);
      _pricePeak = new PeakCondition(high, 2);
      high.Release();
   }

   ~RegularBearishDivergenceCondition()
   {
      delete _pricePeak;
      delete _trough;
   }

   virtual bool IsPass(const int period, datetime date)
   {
      return _trough.IsPass(period, date) && _pricePeak.IsPass(period, date);
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Regular bearish divergence: " + (result ? "true" : "false");
   }
};

#endif