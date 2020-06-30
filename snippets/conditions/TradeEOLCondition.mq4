#include <ACondition.mq4>
#include <../Order.mq4>

// Trade end of life condition v1.0

#ifndef TradeEOLCondition_IMP
#define TradeEOLCondition_IMP

class TradeEOLCondition : public AConditionBase
{
   IOrder* _order;
   int _seconds;
public:
   TradeEOLCondition(IOrder* order, int seconds)
   {
      _order = order;
      _order.AddRef();
      _seconds = seconds;
   }

   ~TradeEOLCondition()
   {
      _order.Release();
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      if (!_order.Select())
      {
         return true;
      }
      datetime currentTime = TimeCurrent();
      datetime orderOpenTime = OrderOpenTime();
      return currentTime - orderOpenTime >= _seconds;
   }
};

#endif