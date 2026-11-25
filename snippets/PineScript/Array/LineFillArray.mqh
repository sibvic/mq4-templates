#ifndef LineFillArray_IMPL
#define LineFillArray_IMPL
// Linefill array v1.0
#include <PineScript/Array/CustomTypeArray.mqh>
#include <PineScript/Objects/LineFill.mqh>

class LineFillArray : public CustomTypeArray<LineFill*>
{
public:
   LineFillArray(int size, LineFill* defaultValue)
      :CustomTypeArray(size, defaultValue)
   {
   }
};
#endif
