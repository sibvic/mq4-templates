// Bool array v1.0
#include <PineScript/Array/IBoolArray.mqh>

class BoolArray : public IBoolArray
{
   int _array[];
   int _defaultSize;
   int _defaultValue;
public:
   BoolArray(int size, int defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IBoolArray* Clear()
   {
      ArrayResize(_array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         _array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(int value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      for (int i = size - 1; i >= 0; --i)
      {
         _array[i + 1] = _array[i];
      }
      _array[0] = value;
   }

   int Size()
   {
      return ArraySize(_array);
   }

   IBoolArray* Push(int value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      _array[size] = value;
      return &this;
   }

   int Pop()
   {
      int size = ArraySize(_array);
      int value = _array[size - 1];
      ArrayResize(_array, size - 1);
      return value;
   }

   int Shift()
   {
      return Remove(0);
   }

   int Get(int index)
   {
      if (index < 0 || index >= Size())
      {
         return EMPTY_VALUE;
      }
      return _array[index];
   }
   
   void Set(int index, int value)
   {
      if (index < 0 || index >= Size())
      {
         return;
      }
      _array[index] = value;
   }
   
   IBoolArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   int Remove(int index)
   {
      int size = ArraySize(_array);
      int value = _array[index];
      for (int i = index; i < size - 1; ++i)
      {
         _array[i] = _array[i + 1];
      }
      ArrayResize(_array, size - 1);
      return value;
   }
   
   int Includes(int value)
   {
      int size = ArraySize(_array);
      for (int i = 0; i < size; ++i)
      {
         if (_array[i] == value)
         {
            return true;
         }
      }
      return false;
   }
};