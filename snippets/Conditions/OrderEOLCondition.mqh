#include <ACondition.mqh>
#include <../Order.mqh>

// Trade end of life condition v1.0

#ifndef OrderEOLCondition_IMP
#define OrderEOLCondition_IMP

class OrderEOLCondition : public AConditionBase
{
   IOrder* _order;
   int _seconds;
public:
   OrderEOLCondition(IOrder* order, int seconds)
   {
      _order = order;
      _order.AddRef();
      _seconds = seconds;
   }

   ~OrderEOLCondition()
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