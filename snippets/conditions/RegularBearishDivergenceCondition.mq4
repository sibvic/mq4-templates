// Regilar bearish divergence condition v2.0

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
   IStream* _data;
   int _right;
public:
   RegularBearishDivergenceCondition(IStream* stream, string symbol, ENUM_TIMEFRAMES timeframe, int left, int right)
      :AConditionBase("Regular bearish divergence")
   {
      _right = right;
      _data = stream;
      _data.AddRef();
      _indiCondition = new PeakCondition(stream, left, right);
      _price = new SimplePriceStream(symbol, timeframe, PriceHigh);
      _priceCondition = new PeakCondition(_price, left, right);
   }

   ~RegularBearishDivergenceCondition()
   {
      _data.Release();
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
      if (!_data.GetValue(period + _right, peaks) || !_price.GetValue(period + _right, peaks_h))
      {
         return false;
      }
      for (int i = period + 1; i < 1000; ++i)
      {
         if (_indiCondition.IsPass(i, 0) && _priceCondition.IsPass(i, 0))
         {
            double peaks_prev, peaks_h_prev;
            return _data.GetValue(i + _right, peaks_prev) 
               && _price.GetValue(i + _right, peaks_h_prev)
               && peaks < peaks_prev && peaks_h > peaks_h_prev;
         }
      }
      return false;
   }
};

#endif