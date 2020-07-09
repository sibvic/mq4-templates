#include <AAction.mq4>

// Delete pending order action v1.0

#ifndef DeletePendingOrderAction_IMP
#define DeletePendingOrderAction_IMP

class DeletePendingOrderAction : public AAction
{
   int _ticket;
   int _slippagePoints;
public:
   DeletePendingOrderAction(int ticket, int slippagePoints)
   {
      _slippagePoints = slippagePoints;
      _ticket = ticket;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!OrderSelect(_ticket, SELECT_BY_TICKET, MODE_TRADES))
      {
         return true;
      }
      int orderType = OrderType();
      if (orderType != OP_BUYSTOP && orderType != OP_BUYLIMIT && orderType != OP_SELLSTOP && orderType != OP_SELLLIMIT)
      {
         return true;
      }

      if (!OrderDelete(_ticket))
      {
         return false;
      }
      return true;
   }
};

#endif