// Trough Condition v1.1


#include <conditions/ICondition.mq4>
#include <../streams/IStream.mq4>

#ifndef TroughCondition_IMP
#define TroughCondition_IMP

class TroughCondition : public ICondition
{
   IStream* _source;
   int _bars;
public:
   TroughCondition(IStream* source, int bars)
   {
      _source = source;
      _source.AddRef();
      _bars = bars;
   }

   ~TroughCondition()
   {
      _source.Release();
   }

   virtual bool IsPass(const int period)
   {
      double centerValue;
      if (!_source.GetValue(period + _bars, centerValue))
         return false;

      for (int i = 0; i < _bars; ++i)
      {
         double leftValue;
         if (!_source.GetValue(period + _bars + i + 1, leftValue) || leftValue < centerValue)
            return false;
         double rightValue;
         if (!_source.GetValue(period + i, rightValue) || rightValue < centerValue)
            return false;
      }
      return true;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Trough: " + (result ? "true" : "false");
   }
};

#endif