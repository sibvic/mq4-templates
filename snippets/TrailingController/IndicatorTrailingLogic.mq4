// Indicator trailing logic v1.0

#ifndef IndicatorTrailingLogic_IMP
#define IndicatorTrailingLogic_IMP

#include <../Streams/IStreamFactory.mq4>

class IndicatorTrailingLogic : public ITrailingLogic
{
   ITrailingController *_trailing[];
   InstrumentInfo *_instrument;
   IStreamFactory *_streamFactory;
   Signaler *_signaler;
public:
   IndicatorTrailingLogic(IStreamFactory *streamFactory, Signaler *signaler)
   {
      _streamFactory = streamFactory;
      _signaler = signaler;
      _instrument = NULL;
   }

   ~IndicatorTrailingLogic()
   {
      delete _streamFactory;
      delete _instrument;
      int i_count = ArraySize(_trailing);
      for (int i = 0; i < i_count; ++i)
      {
         delete _trailing[i];
      }
   }

   void DoLogic()
   {
      int i_count = ArraySize(_trailing);
      for (int i = 0; i < i_count; ++i)
      {
         _trailing[i].UpdateStop();
      }
   }

   void Create(const int order, const double stop)
   {
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return;

      string symbol = OrderSymbol();
      if (_instrument == NULL)
      {
         delete _instrument;
         _instrument = new InstrumentInfo(symbol);
      }
      if (symbol != _instrument.GetSymbol())
      {
         return;
      }
      IStream *stream = _streamFactory.Create(order);
      int i_count = ArraySize(_trailing);
      for (int i = 0; i < i_count; ++i)
      {
         if (_trailing[i].GetType() != TrailingControllerTypeStream)
            continue;
         StreamTrailingController *trailingController = (StreamTrailingController *)_trailing[i];
         if (trailingController.SetOrder(order, stream))
         {
            return;
         }
      }

      StreamTrailingController *trailingController = new StreamTrailingController(_signaler);
      trailingController.SetOrder(order, stream);
      
      ArrayResize(_trailing, i_count + 1);
      _trailing[i_count] = trailingController;
   }
};

#endif