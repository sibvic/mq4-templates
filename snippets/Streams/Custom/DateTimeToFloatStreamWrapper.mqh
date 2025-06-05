// v2.0
// Wraps IDateTimeStream and provides TIStream<double>

#ifndef DateTimeToFloatStreamWrapper_IMPL
#define DateTimeToFloatStreamWrapper_IMPL
#include <Streams/Abstract/TAStream.mqh>
#include <Streams/Interfaces/TIStream.mqh>

class DateTimeToFloatStreamWrapper : public TAStream<double>
{
   TIStream<datetime>* _source;
public:
   DateTimeToFloatStreamWrapper(TIStream<datetime>* source)
   {
      _source = source;
      _source.AddRef();
   }
   ~DateTimeToFloatStreamWrapper()
   {
      _source.Release();
   }

   int Size()
   {
      return _source.Size();
   }
   bool GetValue(const int period, double &val)
   {
      datetime intVal;
      if (!_source.GetValue(period, intVal))
      {
         return false;
      }
      val = intVal;
      return true;
   }
};
#endif