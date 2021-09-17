// StDev stream v1.1

#include <IStream.mqh>

#ifndef StDev_IMP

class StDevStream : public IStream
{
   int _references;
   IStream* _source;
   int _period;
public:
   StDevStream(IStream* __source, int period)
   {
      _references = 1;
      _source = __source;
      _source.AddRef();
      _period = period;
   }
   
   ~StDevStream()
   {
      _source.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double sum = 0;
      double ssum = 0;
      for (int i = 0; i < _period; i++)
      {
         double __data;
         if (!_source.GetValue(period + i, __data))
            return false;
         sum += __data;
         ssum += MathPow(__data, 2);
      }
      val = MathSqrt((ssum * _period - sum * sum) / (_period * (_period - 1)));
      return true;
   }

   void AddRef()
   {
      ++_references;
   }

   void Release()
   {
      --_references;
      if (_references == 0)
         delete &this;
   }
};

#define StDev_IMP
#endif