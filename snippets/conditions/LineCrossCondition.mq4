#include <AConditionBase.mq4>

// Line cross condition v1.0

#ifndef LineCrossCondition_IMP
#define LineCrossCondition_IMP

class LineCrossCondition : public AConditionBase
{
   string _lineId;
public:
   LineCrossCondition(string lineId)
      :AConditionBase("Line cross")
   {
      _lineId = lineId;
   }

   bool IsPass(const int period, const datetime date)
   {
      double val0 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period);
      double val1 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period + 1);
      double y0 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 0);
      double y1 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 1);
      double x0 = ObjectGetInteger(0, _lineId, OBJPROP_TIME, 0);
      double x1 = ObjectGetInteger(0, _lineId, OBJPROP_TIME, 1);
      if (y0 > 0 && y1 > 0 && x0 > 0 && x1 > 0)
      {
         double d1 = (y0 - y1) * iTime(_symbol, (ENUM_TIMEFRAMES)_Period, period) + (x1 - x0) * val0 + (x0 * y1 - x1 * y0);
         double d2 = (y0 - y1) * iTime(_symbol, (ENUM_TIMEFRAMES)_Period, period + 1) + (x1 - x0) * val1 + (x0 * y1 - x1 * y0);
         double d = d1 * d2;
         return d < 0 || d1 == 0;
      }
      return false;
   }
};

#endif