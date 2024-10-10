// Int array v1.3
#include <PineScript/Array/IIntArray.mqh>

class IntArray : public IIntArray
{
   int _array[];
   int _defaultSize;
   int _defaultValue;
public:
   IntArray(int size, int defaultValue)
   {
      _defaultSize = size;
      Clear();
   }

   IIntArray* Clear()
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

   void Push(int value)
   {
      int size = ArraySize(_array);
      ArrayResize(_array, size + 1);
      _array[size] = value;
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
   
   IIntArray* Slice(int from, int to)
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