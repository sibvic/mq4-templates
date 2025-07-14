// Close buy/sell side action v1.0

#include <Actions/AAction.mqh>
#include <OrdersIterator.mqh>
#include <TradingCommands.mqh>

#ifndef CloseSideAction_IMP
#define CloseSideAction_IMP

class CloseSideAction : public AAction
{
   int _magicNumber;
   double _slippagePoints;
   OrderSide _side;
public:
   CloseSideAction(int magicNumber, double slippagePoints, OrderSide side)
   {
      _side = side;
      _magicNumber = magicNumber;
      _slippagePoints = slippagePoints;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      OrdersIterator toClose();
      toClose.WhenMagicNumber(_magicNumber)
         .WhenTrade()
         .WhenSide(_side);
      return TradingCommands::CloseTrades(toClose, (int)_slippagePoints) > 0;
   }
};
#endif