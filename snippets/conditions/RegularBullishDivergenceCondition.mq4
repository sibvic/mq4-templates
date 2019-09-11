// Regilar bullush divergence condition v1.0

#ifndef RegularBullishDivergenceCondition_IMP
#define RegularBullishDivergenceCondition_IMP

#include <TroughCondition.mq4>
#include <PeakCondition.mq4>
#include <../streams/PriceStream.mq4>

class RegularBullishDivergenceCondition : public ICondition
{
   TroughCondition* _priceTrough;
   PeakCondition* _peak;
public:
   RegularBullishDivergenceCondition(IStream* stream, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _peak = new PeakCondition(stream, 2);
      PriceStream* low = new PriceStream(symbol, timeframe, PriceLow);
      _priceTrough = new TroughCondition(low, 2);
      low.Release();
   }

   ~RegularBullishDivergenceCondition()
   {
      delete _priceTrough;
      delete _peak;
   }

   virtual bool IsPass(const int period)
   {
      return _peak.IsPass(period) && _priceTrough.IsPass(period);
   }
};

#endif