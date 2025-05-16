#ifndef FixnanStream_IMP
#define FixnanStream_IMP
// Fix NAN stream v2.0

#include <Streams/AOnStream.mqh>

class FixnanStream : public AOnStream
{
   int _maxLookback;
public:
   FixnanStream(TIStream<double>* source)
      :AOnStream(source)
   {
      _maxLookback = 1000;
   }

   bool GetValue(const int period, double &val)
   {
      for (int i = 0; i < _maxLookback; ++i)
      {
         if (_source.GetValue(period + i, val))
         {
            return true;
         }
      }

      return false;
   }
};

class FixnanStreamFactory
{
public:
   static TIStream<double>* Create(TIStream<double>* source)
   {
      return new FixnanStream(source);
   }
};
#endif