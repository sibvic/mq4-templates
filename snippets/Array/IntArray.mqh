// Int array v1.2
#include <Array/IIntArray.mqh>

class IntArray : public IIntArray
{
   int array[];
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
      ArrayResize(array, _defaultSize);
      for (int i = 0; i < _defaultSize; ++i)
      {
         array[i] = _defaultValue;
      }
      return &this;
   }

   void Unshift(int value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      for (int i = size - 1; i >= 0; --i)
      {
         array[i + 1] = array[i];
      }
      array[0] = value;
   }

   int Size()
   {
      return ArraySize(array);
   }

   void Push(int value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
   }

   int Pop()
   {
      int size = ArraySize(array);
      int value = array[size - 1];
      ArrayResize(array, size - 1);
      return value;
   }

   int Shift()
   {
      return Remove(0);
   }

   int Get(int index)
   {
      return array[index];
   }
   
   IIntArray* Slice(int from, int to)
   {
      return NULL; //TODO;
   }

   int Remove(int index)
   {
      int size = ArraySize(array);
      int value = array[index];
      for (int i = index; i < size - 1; ++i)
      {
         array[i] = array[i + 1];
      }
      ArrayResize(array, size - 1);
      return value;
   }
};