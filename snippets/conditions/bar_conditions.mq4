// Bar condnitions v1.0

#ifndef BarConditions_IMP
#define BarConditions_IMP

#include <ACondition.mq4>
#include <../Streams/IBarStream.mq4>

class BarAscendingCondition : public ACondition
{
   IBarStream* _stream;
   int _periodShift;
public:
   BarAscendingCondition(IBarStream* stream)
   {
      _periodShift = 0;
      _stream = stream;
      _stream.AddRef();
   }

   ~BarAscendingCondition()
   {
      _stream.Release();
   }

   void SetPeriodShift(int shift)
   {
      _periodShift = shift;
   }

   virtual bool IsPass(const int period)
   {
      double open, close;
      return _stream.GetOpenClose(period + _periodShift, open, close) && open < close;
   }
};

class BarDescendingCondition : public ACondition
{
   IBarStream* _stream;
   int _periodShift;
public:
   BarDescendingCondition(IBarStream* stream)
   {
      _periodShift = 0;
      _stream = stream;
      _stream.AddRef();
   }

   ~BarDescendingCondition()
   {
      _stream.Release();
   }

   void SetPeriodShift(int shift)
   {
      _periodShift = shift;
   }

   virtual bool IsPass(const int period)
   {
      double open, close;
      return _stream.GetOpenClose(period + _periodShift, open, close) && open > close;
   }
};
#endif