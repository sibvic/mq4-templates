#include <AConditionBase.mqh>

// Line cross condition v2.0

#ifndef LineCrossCondition_IMP
#define LineCrossCondition_IMP

class LineCrossUpCondition : public AConditionBase
{
   string _lineId;
public:
   LineCrossUpCondition(string lineId)
      :AConditionBase("Line cross up")
   {
      _lineId = lineId;
   }

   bool IsPass(const int period, const datetime date)
   {
      double val0 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period);
      double val1 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period + 1);
      int x1 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _lineId, OBJPROP_TIME, 0));
      int x2 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _lineId, OBJPROP_TIME, 1));
      double y1 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 0);
      double y2 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 1);
      if (x1 > x2)
      {
         datetime temp = x1;
         x1 = x2;
         x2 = temp;
         double temp1 = y1;
         y1 = y2;
         y2 = temp1;
      }
      double a = (x2 - x1) == 0 ? 0 : ((y2 - y1) / (x2 - x1));
      double c = (y1 - a * x1);
      double y_current = a * period + c;
      double y_previous = a * (period + 1) + c;
      return y_current > val0 && y_previous <= val1;
   }
};

class LineCrossDownCondition : public AConditionBase
{
   string _lineId;
public:
   LineCrossDownCondition(string lineId)
      :AConditionBase("Line cross down")
   {
      _lineId = lineId;
   }

   bool IsPass(const int period, const datetime date)
   {
      double val0 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period);
      double val1 = iClose(_Symbol, (ENUM_TIMEFRAMES)_Period, period + 1);
      int x1 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _lineId, OBJPROP_TIME, 0));
      int x2 = iBarShift(_Symbol, (ENUM_TIMEFRAMES)_Period, ObjectGetInteger(0, _lineId, OBJPROP_TIME, 1));
      double y1 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 0);
      double y2 = ObjectGetDouble(0, _lineId, OBJPROP_PRICE, 1);
      if (x1 > x2)
      {
         datetime temp = x1;
         x1 = x2;
         x2 = temp;
         double temp1 = y1;
         y1 = y2;
         y2 = temp1;
      }
      double a = (x2 - x1) == 0 ? 0 : ((y2 - y1) / (x2 - x1));
      double c = (y1 - a * x1);
      double y_current = a * period + c;
      double y_previous = a * (period + 1) + c;
      return y_current < val0 && y_previous >= val1;
   }
};

#endif