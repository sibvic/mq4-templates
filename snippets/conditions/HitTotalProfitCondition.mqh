#include <AConditionBase.mqh>
// Hit total profit condition v1.0

#ifndef HitTotalProfitCondition_IMP
#define HitTotalProfitCondition_IMP

class HitTotalProfitCondition : public AConditionBase
{
   double _totalProfit;
   bool _percentage;
public:
   HitTotalProfitCondition(double totalProfit, bool percentage)
   {
      _percentage = percentage;
      _totalProfit = totalProfit;
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      if (_percentage)
      {
         return AccountBalance() * _totalProfit / 100.0 <= AccountEquity();
      }
      return AccountEquity() - AccountBalance() >= _totalProfit;
   }
};
#endif