// Peak Condition v2.0

#include <conditions/ICondition.mqh>
#include <Streams/IStream.mqh>

#ifndef PeakCondition_IMP
#define PeakCondition_IMP

class PeakCondition : public AConditionBase
{
   IStream* _source;
   int _left;
   int _right;
public:
   PeakCondition(IStream* source, int left, int right)
   {
      _source = source;
      _source.AddRef();
      _left = left;
      _right = right;
   }

   ~PeakCondition()
   {
      _source.Release();
   }

   virtual bool IsPass(const int period, const datetime date)
   {
      double centerValue;
      if (!_source.GetValue(period + _right, centerValue))
         return false;

      for (int i = 0; i < _left; ++i)
      {
         double leftValue;
         if (!_source.GetValue(period + _right + i + 1, leftValue) || leftValue > centerValue)
            return false;
      }
      for (int i = 0; i < _right; ++i)
      {
         double rightValue;
         if (!_source.GetValue(period + i, rightValue) || rightValue > centerValue)
            return false;
      }
      return true;
   }

   virtual string GetLogMessage(const int period, const datetime date)
   {
      bool result = IsPass(period, date);
      return "Peak: " + (result ? "true" : "false");
   }
};

#endif