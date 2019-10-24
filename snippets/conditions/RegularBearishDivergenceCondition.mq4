// Regilar bearish divergence condition v1.1

#ifndef RegularBearishDivergenceCondition_IMP
#define RegularBearishDivergenceCondition_IMP

#include <TroughCondition.mq4>
#include <PeakCondition.mq4>
#include <../streams/PriceStream.mq4>

class RegularBearishDivergenceCondition : public ICondition
{
   TroughCondition* _trough;
   PeakCondition* _pricePeak;
public:
   RegularBearishDivergenceCondition(IStream* stream, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _trough = new TroughCondition(stream, 2);
      PriceStream* high = new PriceStream(symbol, timeframe, PriceHigh);
      _pricePeak = new PeakCondition(high, 2);
      high.Release();
   }

   ~RegularBearishDivergenceCondition()
   {
      delete _pricePeak;
      delete _trough;
   }

   virtual bool IsPass(const int period)
   {
      return _trough.IsPass(period) && _pricePeak.IsPass(period);
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Regular bearish divergence: " + (result ? "true" : "false");
   }
};

#endif