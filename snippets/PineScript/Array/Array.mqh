// Array v1.7
#include <PineScript/Array/IArray.mqh>
#include <PineScript/Array/LineArray.mqh>
#include <PineScript/Array/LabelArray.mqh>
#include <PineScript/Array/IntArray.mqh>
#include <PineScript/Array/BoolArray.mqh>
#include <PineScript/Array/FloatArray.mqh>
#include <PineScript/Array/BoxArray.mqh>
#include <PineScript/Array/StringArray.mqh>
#include <PineScript/Array/ColorArray.mqh>
#include <PineScript/Array/CustomTypeArray.mqh>
#include <PineScript/Array/SimpleTypeArray.mqh>

class Array
{
public:
   template <typename ARRAY_TYPE, typename VALUE_TYPE>
   static void Unshift(ARRAY_TYPE array, VALUE_TYPE value) { if (array == NULL) { return; } array.Unshift(value); }
   
   static double Avg(ISimpleTypeArray<double>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return EMPTY_VALUE;
      }
      return Sum(array) / array.Size();
   }
   static double Avg(ISimpleTypeArray<int>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return EMPTY_VALUE;
      }
      return Sum(array) / array.Size();
   }
   static double Sum(ISimpleTypeArray<double>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return EMPTY_VALUE;
      }
      double sum = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }
   static int Sum(ISimpleTypeArray<int>* array)
   {
      if (array == NULL || array.Size() == 0)
      {
         return INT_MIN;
      }
      int sum = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         sum += array.Get(i);
      }
      return sum;
   }
   
   static double Min(ISimpleTypeArray<double>* array, int nth)
   {
      if (array == NULL || array.Size() == 0 || nth != 0)
      {
         return EMPTY_VALUE;
      }
      double minVal = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double val = array.Get(i);
         if (minVal > val)
         {
            minVal = val;
         }
      }
      return minVal;
   }
   static int Min(ISimpleTypeArray<int>* array, int nth)
   {
      if (array == NULL || array.Size() == 0 || nth != 0)
      {
         return INT_MIN;
      }
      int minVal = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int val = array.Get(i);
         if (minVal > val)
         {
            minVal = val;
         }
      }
      return minVal;
   }
   static double Max(ISimpleTypeArray<double>* array, int nth)
   {
      if (array == NULL || array.Size() == 0 || nth != 0)
      {
         return EMPTY_VALUE;
      }
      double maxVal = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         double val = array.Get(i);
         if (maxVal < val)
         {
            maxVal = val;
         }
      }
      return maxVal;
   }
   static int Max(ISimpleTypeArray<int>* array, int nth)
   {
      if (array == NULL || array.Size() == 0 || nth != 0)
      {
         return INT_MIN;
      }
      int maxVal = array.Get(0);
      for (int i = 1; i < array.Size(); ++i)
      {
         int val = array.Get(i);
         if (maxVal < val)
         {
            maxVal = val;
         }
      }
      return maxVal;
   }
   template <typename DUMMY_TYPE, typename ARRAY_TYPE>
   static int Size(ARRAY_TYPE array, int defaultValue) { if (array == NULL) { return INT_MIN;} return array.Size(); }

   template <typename ARRAY_TYPE>
   static void Clear(ARRAY_TYPE array) { if (array == NULL) { return;} array.Clear(); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename VALUE_TYPE>
   static RETURN_TYPE IndexOf(ARRAY_TYPE array, VALUE_TYPE value, RETURN_TYPE notFoundValue)
   {
      if (array == NULL)
      {
         return notFoundValue;
      }
      int n = array.Size();
      for (int i = 0; i < n; ++i)
      {
         if (array.Get(i) == value)
         {
            return (RETURN_TYPE)i;
         }
      }
      return notFoundValue;
   }

   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE Shift(ARRAY_TYPE array, VALUE_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Shift(); }

   template <typename ARRAY_TYPE, typename VALUE_TYPE>
   static void Push(ARRAY_TYPE array, VALUE_TYPE value) { if (array == NULL) { return; } array.Push(value); }
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE First(ARRAY_TYPE array, VALUE_TYPE defaultValue)
   {
      if (array == NULL || array.Size() == 0) { return defaultValue; } 
      return array.Get(0);
   }
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE Last(ARRAY_TYPE array, VALUE_TYPE defaultValue)
   {
      if (array == NULL || array.Size() == 0) { return defaultValue; } 
      return array.Get(array.Size() - 1);
   }
   
   template <typename VALUE_TYPE, typename ARRAY_TYPE>
   static VALUE_TYPE Pop(ARRAY_TYPE array, VALUE_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Pop(); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static RETURN_TYPE Get(ARRAY_TYPE array, int index, RETURN_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Get(index); }
   
   template <typename ARRAY_TYPE, typename DUMMY_TYPE, typename VALUE_TYPE>
   static void Set(ARRAY_TYPE array, int index, VALUE_TYPE value) { if (array == NULL) { return; } array.Set(index, value); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static RETURN_TYPE Remove(ARRAY_TYPE array, int index, RETURN_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Remove(index); }
   
   template <typename DUMMY_TYPE, typename ARRAY_TYPE, typename VALUE_TYPE>
   static int Includes(ARRAY_TYPE* array, VALUE_TYPE value) { if (array == NULL) { return -1; } return array.Includes(value); }

   template <typename RETURN_TYPE, typename ARRAY_TYPE, typename DUMMY_TYPE>
   static ARRAY_TYPE PercentRank(ISimpleTypeArray<ARRAY_TYPE>* array) { if (array == NULL) { return -1; } return array.PercentRank(index); }

   template<typename TYPE>
   static double StdevImpl(ISimpleTypeArray<TYPE>* array, bool biased, TYPE emptyValue)
   {
      if (array == NULL)
      {
         return emptyValue;
      }
      int size = array.Size();
      if (size == 0)
      {
         return emptyValue;
      }
      if (!biased && size < 2)
      {
         return emptyValue;
      }
      double sum = 0;
      double ssum = 0;
      for (int i = 0; i < size; i++)
      {
         double v = (double)array.Get(i);
         sum += v;
         ssum += v * v;
      }
      double num = size * ssum - sum * sum;
      if (num < 0)
      {
         num = 0;
      }
      double denom = biased ? (double)size * (double)size : (double)size * (double)(size - 1);
      return MathSqrt(num / denom);
   }
   template<typename TYPE>
   static double StdevImpl(ISimpleTypeArray<TYPE>* array, TYPE emptyValue)
   {
      return StdevImpl(array, false, emptyValue);
   }
   static double Stdev(ISimpleTypeArray<int>* array, bool biased) { return StdevImpl<int>(array, biased, INT_MIN); }
   static double Stdev(ISimpleTypeArray<double>* array, bool biased) { return StdevImpl<double>(array, biased, EMPTY_VALUE); }
   static double Stdev(ISimpleTypeArray<int>* array) { return StdevImpl<int>(array, INT_MIN); }
   static double Stdev(ISimpleTypeArray<double>* array) { return StdevImpl<double>(array, EMPTY_VALUE); }
   
   template <typename ARRAY_TYPE, typename DUMMY_TYPE>
   static ARRAY_TYPE Copy(ARRAY_TYPE array, ARRAY_TYPE emptyValue) { if (array == NULL) { return emptyValue; } return array.Copy(); }

   template <typename ARRAY_TYPE, typename DUMMY_TYPE1>
   static void Sort(ARRAY_TYPE array, string order) { if (array == NULL) { return; } array.Sort(order == "ascending"); }
    
   static string Join(IStringArray* array, string concat)
   {
      string res = "";
      for (int i = 0; i < array.Size(); ++i)
      {
         string val = array.Get(i);
         if (val == NULL)
         {
            continue;
         }
         if (i > 0)
         {
            res += concat;
         }
         res += array.Get(i);
      }
      return res;
   }
};

