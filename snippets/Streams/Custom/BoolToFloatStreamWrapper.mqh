// v2.0
// Wraps IBoolStream and provides TIStream<double>

#ifndef BoolToFloatStreamWrapper_IMPL
#define BoolToFloatStreamWrapper_IMPL
#include <Streams/Abstract/TAStream.mqh>
#include <Streams/Interfaces/IBoolStream.mqh>

class BoolToFloatStreamWrapper : public TAStream<double>
{
   IBoolStream* _source;
public:
   BoolToFloatStreamWrapper(IBoolStream* source)
   {
      _source = source;
      _source.AddRef();
   }
   ~BoolToFloatStreamWrapper()
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