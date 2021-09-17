// Trough Condition v2.0


#include <conditions/ICondition.mqh>
#include <../streams/IStream.mqh>

#ifndef TroughCondition_IMP
#define TroughCondition_IMP

class TroughCondition : public AConditionBase
{
   IStream* _source;
   int _left;
   int _right;
public:
   TroughCondition(IStream* source, int left, int right)
   {
      _source = source;
      _source.AddRef();
      _left = left;
      _right = right;
   }

   ~TroughCondition()
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
         if (!_source.GetValue(period + _right + i + 1, leftValue) || leftValue < centerValue)
            return false;
      }
      for (int i = 0; i < _right; ++i)
      {
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