// Float array v1.0
#include <Array/IFloatArray.mqh>

class FloatArray : public IFloatArray
{
   double array[];
   int _defaultSize;
   double _defaultValue;
public:
   FloatArray(int size, double defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IFloatArray* Clear()
   {
      ArrayResize(array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(double value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      for (int i = 0; i < size; ++i)
      {
         array[i + 1] = array[i];
      }
      array[0] = value;
   }

   int Size()
   {
      return ArraySize(array);
   }

   void Push(double value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
   }

   double Pop()
   {
      int size = ArraySize(array);
      double value = array[size - 1];
      ArrayResize(array, size - 1);
      return value;
   }

   double Get(int index)
   {
      return array[index];
   }

   double Shift()
   {
      int size = ArraySize(array);
      double value = array[0];
      for (int i = 0; i < size - 1; ++i)
      {
         array[i] = array[i + 1];
      }
      ArrayResize(array, size - 1);
      return value;
   }
   
   IFloatArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }
};