// Partial close of the order action v1.0

#include <Actions/AAction.mqh>
#include <Order.mqh>
#include <InstrumentInfo.mqh>
#include <TradingCommands.mqh>

#ifndef PartialCloseOrderAction_IMP
#define PartialCloseOrderAction_IMP

class PartialCloseOrderAction : public AAction
{
   IOrder* _order;
   int _slippagePoints;
   double _toClose;
public:
   PartialCloseOrderAction(IOrder* order, double toClose, int slippagePoints)
   {
      _order = order;
      _order.AddRef();
      _toClose = toClose;
      _slippagePoints = slippagePoints;
   }

   ~PartialCloseOrderAction()
   {
      _order.Release();
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!_order.Select() || OrderCloseTime() != 0)
      {
         return false;
      }

      int orderType = OrderType();
      string error;
      double price = orderType == OP_BUY ? InstrumentInfo::GetBid(OrderSymbol()) : InstrumentInfo::GetAsk(OrderSymbol());
      if (!TradingCommands::CloseCurrentOrder(price, _slippagePoints, _toClose, error))
      {
         Print("Position close error: " + error);
         return false;
      }
      return true;
   }
};

#endif