// Regilar bearish divergence condition v1.3

#ifndef RegularBearishDivergenceCondition_IMP
#define RegularBearishDivergenceCondition_IMP

#include <TroughCondition.mq4>
#include <PeakCondition.mq4>
#include <../streams/PriceStream.mq4>

class RegularBearishDivergenceCondition : public AConditionBase
{
   ICondition* _priceCondition;
   ICondition* _indiCondition;
   SimplePriceStream* _price;
   IStream* _stream;
public:
   RegularBearishDivergenceCondition(IStream* stream, string symbol, ENUM_TIMEFRAMES timeframe)
      :AConditionBase("Regular bearish divergence")
   {
      _stream = stream;
      _stream.AddRef();
      _indiCondition = new PeakCondition(stream, 2);
      _price = new SimplePriceStream(symbol, timeframe, PriceHigh);
      _priceCondition = new PeakCondition(_price, 2);
   }

   ~RegularBearishDivergenceCondition()
   {
      _stream.Release();
      _price.Release();
      delete _priceCondition;
      delete _indiCondition;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      if (!(_indiCondition.IsPass(period, date) && _priceCondition.IsPass(period, date)))
      {
         return false;
      }
      double peaks, peaks_h;
      if (!_stream.GetValue(period, peaks) || !_price.GetValue(period, peaks_h))
      {
         return false;
      }
      for (int i = period; i < 1000; ++i)
      {
         if (_indiCondition.IsPass(i, 0) && _priceCondition.IsPass(i, 0))
         {
            double peaks_prev, peaks_h_prev;
            return _stream.GetValue(i, peaks_prev) 
               && _price.GetValue(i, peaks_h_prev)
               && peaks < peaks_prev && peaks_h > peaks_h_prev;
         }
      }
      return false;
   }
};

#endif