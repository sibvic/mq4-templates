// Abstract implementation for IBoxStream v1.0

#ifndef ABoxStream_IMPL
#define ABoxStream_IMPL

#include <Streams/Interfaces/IBoxStream.mqh>

class ABoxStream : public IBoxStream
{
   int _refs;   
public:
   ABoxStream()
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
