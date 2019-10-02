// Stochastic conditions v1.0

#ifndef StochConditions_IMP
#define StochConditions_IMP
#include <ABaseCondition.mq4>

class StochKAboveDCondition : public ABaseCondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
public:
   StochKAboveDCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
   }

   bool IsPass(const int period)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      double signalValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_SIGNAL, period);
      return stochValue > signalValue;
   }
};

class StochKBelowDCondition : public ABaseCondition
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
public:
   StochKBelowDCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod)
      :ABaseCondition(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
   }

   bool IsPass(const int period)
   {
      double stochValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_MAIN, period);
      double signalValue = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, MODE_SIGNAL, period);
      return stochValue < signalValue;
   }
};
#endif