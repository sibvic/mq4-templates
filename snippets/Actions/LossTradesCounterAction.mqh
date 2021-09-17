// Loss trades counter action v1.0

#ifndef LossTradesCounterAction_IMP
#define LossTradesCounterAction_IMP

class LossTradesCounterAction : public AAction
{
public:
   int LossTradesCount;

   LossTradesCounterAction()
   {
      LossTradesCount = 0;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (OrderClosePrice() == OrderStopLoss())
         LossTradesCount += 1;
      else
         LossTradesCount = 0;
      return false;
   }
   virtual bool SetOrder(const int order)
   {
      return true;
   }
};

#endif