#include <AConditionBase.mq4>

// Fibonacci cross condition v1.0

#ifndef FibCrossCondition_IMP
#define FibCrossCondition_IMP

class FibCrossUpCondition : public AConditionBase
{
   string _fibId;
   int _levelIndex;
public:
   FibCrossUpCondition(string fibId, int levelIndex)
      :AConditionBase("Fibonacci cross up")
   {
      _fibId = fibId;
      _levelIndex = levelIndex;
   }

   void SetId(string id)
   {
      _fibId = id;
   }

   bool IsPass(const int period, const datetime date)
   {
      double val0 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period);
      double val1 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period + 1);
      int x1 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _fibId, OBJPROP_TIME, 0));
      int x2 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _fibId, OBJPROP_TIME, 1));
      double y1 = ObjectGetDouble(0, _fibId, OBJPROP_PRICE, _levelIndex);
      return y1 > val0 && y1 <= val1;
   }
};

class FibCrossDownCondition : public AConditionBase
{
   string _fibId;
   int _levelIndex;
public:
   FibCrossDownCondition(string fibId, int levelIndex)
      :AConditionBase("Fibonacci cross down")
   {
      _fibId = fibId;
      _levelIndex = levelIndex;
   }

   void SetId(string id)
   {
      _fibId = id;
   }

   bool IsPass(const int period, const datetime date)
   {
      double val0 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period);
      double val1 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period + 1);
      int x1 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _fibId, OBJPROP_TIME, 0));
      int x2 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _fibId, OBJPROP_TIME, 1));
      double y1 = ObjectGetDouble(0, _fibId, OBJPROP_PRICE, _levelIndex);
      return y1 < val0 && y1 >= val1;
   }
};

#endif