// v1.0
// Wraps IIntStream and provides IStream

#ifndef IntToFloatStreamWrapper_IMPL
#define IntToFloatStreamWrapper_IMPL
#include <Streams/Abstract/AFloatStream.mqh>
#include <Streams/Interfaces/IIntStream.mqh>

class IntToFloatStreamWrapper : public AFloatStream
{
   IIntStream* _source;
public:
   IntToFloatStreamWrapper(IIntStream* source)
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