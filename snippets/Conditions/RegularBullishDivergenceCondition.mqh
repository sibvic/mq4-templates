// Regilar bullush divergence condition v3.0

#ifndef RegularBullishDivergenceCondition_IMP
#define RegularBullishDivergenceCondition_IMP

#include <TroughCondition.mqh>
#include <PeakCondition.mqh>
#include <../streams/PriceStream.mqh>

class RegularBullishDivergenceCondition : public AConditionBase
{
   ICondition* _priceCondition;
   ICondition* _indiCondition;
   SimplePriceStream* _price;
   TIStream<double>* _data;
   int _right;
public:
   RegularBullishDivergenceCondition(TIStream<double>* stream, string symbol, ENUM_TIMEFRAMES timeframe, int left, int right)
      :AConditionBase("Regular bullish divergence")
   {
      _right = right;
      _data = stream;
      _data.AddRef();
      _indiCondition = new TroughCondition(stream, left, right);
      _price = new SimplePriceStream(symbol, timeframe, PriceLow);
      _priceCondition = new TroughCondition(_price, left, right);
   }

   ~RegularBullishDivergenceCondition()
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
      double trough, trough_l;
      if (!_data.GetValue(period + _right, trough) || !_price.GetValue(period + _right, trough_l))
      {
         return false;
      }
      for (int i = period + 1; i < 1000; ++i)
      {
         if (_indiCondition.IsPass(i, 0) && _priceCondition.IsPass(i, 0))
         {
            double trough_prev, trough_l_prev;
            return _data.GetValue(i + _right, trough_prev) 
               && _price.GetValue(i + _right, trough_l_prev)
               && trough > trough_prev && trough_l < trough_l_prev;
         }
      }
      return false;
   }
};

#endif