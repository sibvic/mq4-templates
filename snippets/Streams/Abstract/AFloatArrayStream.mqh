// Abstract implementation for IFloatArrayStream v1.0

#ifndef AFloatArrayStream_IMPL
#define AFloatArrayStream_IMPL

#include <Streams/Interfaces/IFloatArrayStream.mqh>

class AFloatArrayStream : public IFloatArrayStream
{
   int _refs;   
public:
   AFloatArrayStream()
   {
      _refs = 1;
   }

   void AddRef()
   {
      _refs++;
   }
   void Release()
   {
      if (--_refs == 0)
      {
         delete &this;
      }
   }
};

#endif
