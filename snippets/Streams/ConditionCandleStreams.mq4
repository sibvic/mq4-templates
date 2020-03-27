// Condition candle streams v1.0

#include <../Conditions/ICondition.mq4>

#ifndef ConditionCandleStreams_IMP
#define ConditionCandleStreams_IMP

class ConditionCandleStreams
{
   ICondition* _condition;
public:
   ~ConditionCandleStreams()
   {
      _condition.Release();
   }

   double OpenStream[];
   double CloseStream[];
   double HighStream[];
   double LowStream[];
   int RegisterStreams(const int id, const color clr, ICondition* condition)
   {
      SetIndexStyle(id + 0, DRAW_HISTOGRAM, STYLE_SOLID, 5, clr);
      SetIndexBuffer(id + 0, OpenStream);
      SetIndexLabel(id + 0, "Open");
      SetIndexStyle(id + 1, DRAW_HISTOGRAM, STYLE_SOLID, 5, clr);
      SetIndexBuffer(id + 1, CloseStream);
      SetIndexLabel(id + 1, "Close");
      SetIndexStyle(id + 2, DRAW_HISTOGRAM, STYLE_SOLID, 1, clr);
      SetIndexBuffer(id + 2, HighStream);
      SetIndexLabel(id + 2, "High");
      SetIndexStyle(id + 3, DRAW_HISTOGRAM, STYLE_SOLID, 1, clr);
      SetIndexBuffer(id + 3, LowStream);
      SetIndexLabel(id + 3, "Low");
      _condition = condition;
      _condition.AddRef();
      return id + 4;
   }

   void AddTick(const int index, const double val)
   {
      if (OpenStream[index] == EMPTY_VALUE)
      {
         Set(index, val, val, val, val);
         return;
      }
      HighStream[index] = MathMax(HighStream[index], val);
      LowStream[index] = MathMin(LowStream[index], val);
      CloseStream[index] = val;
   }

   bool Set(const int index, const double open, const double high, const double low, const double close)
   {
      if (_condition.IsPass(index, Time[index]))
      {
         OpenStream[index] = open;
         HighStream[index] = high;
         LowStream[index] = low;
         CloseStream[index] = close;
         return true;
      }
      OpenStream[index] = EMPTY_VALUE;
      CloseStream[index] = EMPTY_VALUE;
      HighStream[index] = EMPTY_VALUE;
      LowStream[index] = EMPTY_VALUE;
      return false;
   }
};

#endif