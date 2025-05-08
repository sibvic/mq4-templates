// float array interface v1.2
#ifndef IFloatArray_IMPL
#define IFloatArray_IMPL
#include <PineScript/Array/ITArray.mqh>

class IFloatArray : public ITArray<double>
{
public:
   virtual IFloatArray* Slice(int from, int to) = 0;
   virtual IFloatArray* Clear() = 0;
};
#endif