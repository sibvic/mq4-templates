// Array v1.0
#include <Array/IArray.mqh>
#include <Array/LineArray.mqh>
#include <Array/IntArray.mqh>
#include <Array/FloatArray.mqh>

class Array
{
public:
   static void Unshift(IIntArray* array, int value)
   {
      if (array == NULL)
      {
         return;
      }
      array.Unshift(value);
   }

   static void Push(ILineArray* array, Line* value)
   {
      if (array == NULL)
      {
         return;
      }
      array.Push(value);
   }
   static void Push(IIntArray* array, int value)
   {
      if (array == NULL)
      {
         return;
      }
      array.Push(value);
   }
   static void Push(IFloatArray* array, double value)
   {
      if (array == NULL)
      {
         return;
      }
      array.Push(value);
   }

   static int Sum(IIntArray* array)
   {
      if (array == NULL)
      {
         return 0;
      }
      int sum = 0;
      for (int i = 0; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }
   static double Sum(IFloatArray* array)
   {
      if (array == NULL)
      {
         return 0;
      }
      double sum = 0;
      for (int i = 0; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }

   static int Pop(IIntArray* array)
   {
      if (array == NULL)
      {
         return 0;
      }
      return array.Pop();
   }

   static int Get(IIntArray* array, int index)
   {
      if (array == NULL)
      {
         return 0;
      }
      return array.Get(index);
   }
   static double Get(IFloatArray* array, int index)
   {
      if (array == NULL)
      {
         return 0;
      }
      return array.Get(index);
   }
};

