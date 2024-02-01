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
   
   static int Size(ILineArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IIntArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }
   static int Size(IFloatArray* array) { if (array == NULL) { return EMPTY_VALUE;} return array.Size(); }

   static void Shift(ILineArray* array) { if (array == NULL) { return; } array.Shift(); }
   static void Shift(IIntArray* array) { if (array == NULL) { return; } array.Shift(); }
   static void Shift(IFloatArray* array) { if (array == NULL) { return; } array.Shift(); }

   static int Max(IIntArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      int max = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int current = array.Get(i);
         if (max == EMPTY_VALUE || (current != EMPTY_VALUE && max < current))
         {
            max = current;
         }
      }
      return max;
   }
   static double Max(IFloatArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      double max = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double current = array.Get(i);
         if (max == EMPTY_VALUE || (current != EMPTY_VALUE && max < current))
         {
            max = current;
         }
      }
      return max;
   }
   static int Min(IIntArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      int min = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int current = array.Get(i);
         if (min == EMPTY_VALUE || (current != EMPTY_VALUE && min > current))
         {
            min = current;
         }
      }
      return min;
   }
   static double Min(IFloatArray* array)
   {
      if (array == NULL || array.Size() == 0) { return EMPTY_VALUE; }
      double min = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double current = array.Get(i);
         if (min == EMPTY_VALUE || (current != EMPTY_VALUE && min > current))
         {
            min = current;
         }
      }
      return min;
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

