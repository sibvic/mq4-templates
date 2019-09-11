// Alert signal v.2.2
// More templates and snippets on https://github.com/sibvic/mq4-templates

#ifndef AlertSignal_IMP
#define AlertSignal_IMP

#include <Streams/CandleStreams.mq4>

class AlertSignal
{
   double _signals[];
   ICondition* _condition;
   IStream* _price;
   Signaler* _signaler;
   string _message;
   datetime _lastSignal;
   CandleStreams* _candleStreams;
   bool _onBarClose;
public:
   AlertSignal(ICondition* condition, Signaler* signaler, bool onBarClose = false)
   {
      _condition = condition;
      _price = NULL;
      _candleStreams = NULL;
      _signaler = signaler;
      _onBarClose = onBarClose;
   }

   ~AlertSignal()
   {
      if (_price != NULL)
         _price.Release();
      if (_candleStreams != NULL)
         delete _candleStreams;
      delete _condition;
   }

   int RegisterStreams(int id, string name, int code, color clr, IStream* price)
   {
      _message = name;
      _price = price;
      _price.AddRef();
      SetIndexStyle(id + 0, DRAW_ARROW, 0, 2, clr);
      SetIndexBuffer(id + 0, _signals);
      SetIndexLabel(id + 0, name);
      SetIndexArrow(id + 0, code);
      
      return id + 1;
   }

   int RegisterStreams(int id, string name, color clr)
   {
      _message = name;
      _candleStreams = new CandleStreams();
      return _candleStreams.RegisterStreams(id, clr);
   }

   void Update(int period)
   {
      if (!_condition.IsPass(_onBarClose ? period + 1 : period))
      {
         if (_candleStreams != NULL)
            _candleStreams.Clear(period);
         else
            _signals[period] = EMPTY_VALUE;
         return;
      }

      if (period == 0)
      {
         string symbol = _signaler.GetSymbol();
         datetime dt = iTime(symbol, _signaler.GetTimeframe(), 0);
         if (_lastSignal != dt)
         {
            _signaler.SendNotifications(symbol + "/" + _signaler.GetTimeframeStr() + ": " + _message);
            _lastSignal = dt;
         }
      }

      if (_candleStreams != NULL)
      {
         _candleStreams.Set(period, Open[period], High[period], Low[period], Close[period]);
         return;
      }
      double price;
      if (!_price.GetValue(period, price))
         return;

      _signals[period] = price;
   }
};

#endif