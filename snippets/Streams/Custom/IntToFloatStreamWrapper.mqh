// v2.1
// Wraps TIStream<int> and provides TIStream<double>

#ifndef IntToFloatStreamWrapper_IMPL
#define IntToFloatStreamWrapper_IMPL
#include <Streams/Abstract/TAStream.mqh>

class IntToFloatStreamWrapper : public TAStream<double>
{
   TIStream<int>* _source;
public:
   IntToFloatStreamWrapper(TIStream<int>* source)
   {
      _source = source;
      _source.AddRef();
   }
   ~IntToFloatStreamWrapper()
   {
      _source.Release();
   }

   int Size()
   {
      return _source.Size();
   }
   bool GetValue(const int period, double &val)
   {
      int intVal;
      if (!_source.GetValue(period, intVal))
      {
         return false;
      }
      val = intVal;
      return true;
   }
};
#endif