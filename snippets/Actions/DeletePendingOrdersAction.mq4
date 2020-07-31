#include <AAction.mq4>
#include <../OrdersIterator.mq4>
// Delete pending orders action v1.0

#ifndef DeletePendingOrdersAction_IMP
#define DeletePendingOrdersAction_IMP
class DeletePendingOrdersAction : public AAction
{
   int _magicNumber;
   int _slippagePoints;
public:
   DeletePendingOrdersAction(int magicNumber, int slippagePoints)
   {
      _magicNumber = magicNumber;
      _slippagePoints = slippagePoints;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      OrdersIterator toClose();
      toClose.WhenMagicNumber(_magicNumber).WhenOrder();
      while (toClose.Next())
      {
         OrderDelete(toClose.GetTicket());
      }
      return false;
   }
};
#endif