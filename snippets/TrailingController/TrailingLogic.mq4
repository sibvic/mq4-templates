// Trailing logic v1.0

#include <TrailingController.mq4>
#include <ITrailingController.mq4>
#include <TrailingControllerATR.mq4>
#include <../InstrumentInfo.mq4>

#ifndef TrailingLogic_IMP
#define TrailingLogic_IMP

class TrailingLogic : public ITrailingLogic
{
   ITrailingController *_trailing[];
   TrailingType _trailingType;
   double _trailingStep;
   double _atrTrailingMultiplier;
   double _trailingStart;
   ENUM_TIMEFRAMES _timeframe;
   InstrumentInfo *_instrument;
public:
   TrailingLogic(TrailingType trailing, double trailingStep, double atrTrailingMultiplier
      , double trailingStart, ENUM_TIMEFRAMES timeframe)
   {
      _instrument = NULL;
      _trailingStart = trailingStart;
      _trailingType = trailing;
      _trailingStep = trailingStep;
      _atrTrailingMultiplier = atrTrailingMultiplier;
      _timeframe = timeframe;
   }

   ~TrailingLogic()
   {
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

   void Create(const int order, const double distancePips, const TrailingType trailingType, const double trailingStep
      , const double trailingStart)
   {
      if (!OrderSelect(order, SELECT_BY_TICKET, MODE_TRADES) || OrderCloseTime() != 0.0)
         return;

      string symbol = OrderSymbol();
      if (_instrument == NULL || symbol != _instrument.GetSymbol())
      {
         delete _instrument;
         _instrument = new InstrumentInfo(symbol);
      }
      double distance = distancePips * _instrument.GetPipSize();
      switch (trailingType)
      {
         case TrailingPips:
            CreateTrailing(order, distance, trailingStep * _instrument.GetPipSize(), trailingStart);
            break;
         case TrailingPercent:
            CreateTrailing(order, distance, distance * trailingStep / 100.0, trailingStart);
            break;
#ifdef USE_ATR_TRAILLING
         case TrailingATR:
            CreateATRTrailing(order, distance, (int)trailingStep, _atrTrailingMultiplier);
            break;
#endif
      }
   }

   void Create(const int order, const double distancePips)
   {
      Create(order, distancePips, _trailingType, _trailingStep, _trailingStart);
   }
private:
#ifdef USE_ATR_TRAILLING
   void CreateATRTrailing(const int order, const double distance, const int atrPeriod, const double multiplier)
   {
      int i_count = ArraySize(_trailing);
      for (int i = 0; i < i_count; ++i)
      {
         if (_trailing[i].GetType() != TrailingControllerTypeATR)
            continue;
         TrailingControllerATR *trailingController = (TrailingControllerATR *)_trailing[i];
         if (trailingController.SetOrder(order, distance, atrPeriod, multiplier, _timeframe))
         {
            return;
         }
      }

      TrailingControllerATR *trailingController = new TrailingControllerATR();
      trailingController.SetOrder(order, distance, atrPeriod, multiplier, _timeframe);

      ArrayResize(_trailing, i_count + 1);
      _trailing[i_count] = trailingController;
   }
#endif
   void CreateTrailing(const int order, const double distance, const double trailingStep, const double trailingStart)
   {
      int i_count = ArraySize(_trailing);
      for (int i = 0; i < i_count; ++i)
      {
         if (_trailing[i].GetType() != TrailingControllerTypeStandard)
            continue;
         TrailingController *trailingController = (TrailingController *)_trailing[i];
         if (trailingController.SetOrder(order, distance, trailingStep, trailingStart))
         {
            return;
         }
      }

      TrailingController *trailingController = new TrailingController();
      trailingController.SetOrder(order, distance, trailingStep, trailingStart);
      
      ArrayResize(_trailing, i_count + 1);
      _trailing[i_count] = trailingController;
   }
};

#endif