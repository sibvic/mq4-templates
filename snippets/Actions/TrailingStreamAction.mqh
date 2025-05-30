#include <Order/IOrder.mqh>
#include <Actions/AAction.mqh>
#include <InstrumentInfo.mqh>
#include <TradingCommands.mqh>
#include <Streams/Interfaces/TIStream.mqh>

// Trailiong stream action v2.0

class TrailingStreamAction : public AAction
{
   IOrder* _order;
   InstrumentInfo* _instrument;
   TIStream<double>* _stream;
public:
   TrailingStreamAction(IOrder* order, TIStream<double>* stream)
   {
      _stream = stream;
      _stream.AddRef();
      _order = order;
      _order.AddRef();
      _instrument = NULL;
   }

   ~TrailingStreamAction()
   {
      _stream.Release();
      _order.Release();
      delete _instrument;
   }

   virtual bool DoAction(const int period, const datetime date)
   {
      if (!_order.Select())
      {
         return true;
      }

      double newStop;
      if (!_stream.GetValue(period, newStop) || newStop == 0.0)
      {
         return false;
      }
      
      string error;
      TradingCommands::MoveSL(OrderTicket(), newStop, error);
      
      return false;
   }
};