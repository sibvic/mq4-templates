// Heatmap value calculator v2.1

#include <Conditions/ICondition.mq4>

#ifndef IHeatMapValueCalculator_IMP
#define IHeatMapValueCalculator_IMP

class IHeatMapValueCalculator
{
public:
   virtual void UpdateValue(const int period) = 0;
};

class HeatMapValueCalculator : public IHeatMapValueCalculator
{
   double _value;
   ICondition* _upCondition;
   ICondition* _downCondition;
   double up[];
   double dn[];
   double nt[];
public:
   HeatMapValueCalculator(const double value, ICondition* upCondition, ICondition* downCondition)
   {
      _upCondition = upCondition;
      _upCondition.AddRef();
      _downCondition = downCondition;
      _downCondition.AddRef();
      _value = value;
   }

   ~HeatMapValueCalculator()
   {
      _upCondition.Release();
      _downCondition.Release();
   }

   int RegisterStreams(int id, color upClor, color downColor, color neutralColor, string name)
   {
      SetIndexBuffer(id, nt);
      SetIndexStyle(id, DRAW_ARROW, EMPTY, EMPTY, neutralColor);
      SetIndexArrow(id, 110);
      SetIndexLabel(id, name + " N");
      ++id;

      SetIndexBuffer(id, up);
      SetIndexStyle(id, DRAW_ARROW, EMPTY, EMPTY, upClor);
      SetIndexArrow(id, 110);
      SetIndexLabel(id, name + " U");
      ++id;

      SetIndexBuffer(id, dn);
      SetIndexStyle(id, DRAW_ARROW, EMPTY, EMPTY, downColor);
      SetIndexArrow(id, 110);
      SetIndexLabel(id, name + " D");
      ++id;

      return id;
   }

   void UpdateValue(const int period)
   {
      up[period] = EMPTY_VALUE;
      dn[period] = EMPTY_VALUE;
      nt[period] = EMPTY_VALUE;
      if (_upCondition.IsPass(period, Time[period]))
         up[period] = _value;
      else if (_downCondition.IsPass(period, Time[period]))
         dn[period] = _value;
      else
         nt[period] = _value;
   }
};

class SingleHeatMapValueCalculator : public IHeatMapValueCalculator
{
   double _value;
   ICondition* _condition;
   double pos[];
   double nt[];
public:
   SingleHeatMapValueCalculator(const double value, ICondition* condition)
   {
      _condition = condition;
      _condition.AddRef();
      _value = value;
   }

   ~SingleHeatMapValueCalculator()
   {
      _condition.Release();
   }

   int RegisterStreams(int id, color positiveColor, color neutralColor, string name)
   {
      SetIndexBuffer(id, nt);
      SetIndexStyle(id, DRAW_ARROW, EMPTY, EMPTY, neutralColor);
      SetIndexArrow(id, 110);
      SetIndexLabel(id, name + " N");
      ++id;

      SetIndexBuffer(id, pos);
      SetIndexStyle(id, DRAW_ARROW, EMPTY, EMPTY, positiveColor);
      SetIndexArrow(id, 110);
      SetIndexLabel(id, name + " P");
      ++id;

      return id;
   }

   void UpdateValue(const int period)
   {
      pos[period] = EMPTY_VALUE;
      nt[period] = EMPTY_VALUE;
      if (_condition.IsPass(period, Time[period]))
         pos[period] = _value;
      else
         nt[period] = _value;
   }
};

#endif