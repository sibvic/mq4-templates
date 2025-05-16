// Hidden bullush divergence condition v3.0

#ifndef HiddenBullishDivergenceCondition_IMP
#define HiddenBullishDivergenceCondition_IMP

#include <TroughCondition.mqh>
#include <PeakCondition.mqh>
#include <../streams/PriceStream.mqh>

class HiddenBullishDivergenceCondition : public AConditionBase
{
   ICondition* _priceCondition;
   ICondition* _indiCondition;
   SimplePriceStream* _price;
   TIStream<double>* _stream;
public:
   HiddenBullishDivergenceCondition(TIStream<double>* stream, string symbol, ENUM_TIMEFRAMES timeframe, int left, int right)
      :AConditionBase("Hidden bullish divergence")
   {
      _stream = stream;
      _stream.AddRef();
      _indiCondition = new TroughCondition(stream, left, right);
      _price = new SimplePriceStream(symbol, timeframe, PriceLow);
      _priceCondition = new TroughCondition(_price, left, right);
   }

   ~HiddenBullishDivergenceCondition()
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
      double trough, trough_l;
      if (!_stream.GetValue(period, trough) || !_price.GetValue(period, trough_l))
      {
         return false;
      }
      for (int i = period; i < 1000; ++i)
      {
         if (_indiCondition.IsPass(i, 0) && _priceCondition.IsPass(i, 0))
         {
            double trough_prev, trough_l_prev;
            return _stream.GetValue(i, trough_prev) 
               && _price.GetValue(i, trough_l_prev)
               && trough < trough_prev && trough_l > trough_l_prev;
         }
      }
      return false;
   }
};

#endif