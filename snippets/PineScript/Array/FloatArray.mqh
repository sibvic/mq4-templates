// Float array v1.3
#include <PineScript/Array/SimpleTypeArray.mqh>

class FloatArray : public SimpleTypeArray<double>
{
public:
   FloatArray(int size, double defaultValue)
      :SimpleTypeArray(size, defaultValue, EMPTY_VALUE)
   {
   }
};