// Trailing action v1.0

#include <AAction.mq4>
#include <../Order.mq4>
#include <../TradingCommands.mq4>
#include <../InstrumentInfo.mq4>

#ifndef TrailingAction_IMP
#define TrailingAction_IMP

class TrailingPipsAction : public AAction
{
   IOrder* _order;
   InstrumentInfo* _instrument;
   double _lastClose;
   double _distance;
public:
   TrailingPipsAction(IOrder* order, double distance)
   {
      _distance = distance;
      _order = order;
      _order.AddRef();
      _lastClose = 0;
      _instrument = NULL;
   }

   ~TrailingPipsAction()
   {
      _order.Release();
      delete _instrument;
   }

   virtual bool DoAction()
   {
      if (!_order.Select())
         return true;
      string symbol = OrderSymbol();
      double closePrice = iClose(symbol, PERIOD_M1, 0);
      if (_lastClose == 0)
      {
         _lastClose = closePrice;
         _instrument = new InstrumentInfo(symbol);
      }

      double stopLoss = OrderStopLoss();
      double stopDistance = MathAbs(closePrice - stopLoss) / _instrument.GetPipSize();
      if (stopDistance <= _distance)
         return false;

      int orderType = OrderType();
      if (orderType == OP_BUY)
      {
         string error;
         TradingCommands::MoveSL(OrderTicket(), closePrice - _distance * _instrument.GetPipSize(), error);
         _lastClose = closePrice;
      }
      else if (orderType == OP_SELL)
      {
         string error;
         TradingCommands::MoveSL(OrderTicket(), closePrice + _distance * _instrument.GetPipSize(), error);
         _lastClose = closePrice;
      }
      
      return false;
   }
};
#endif