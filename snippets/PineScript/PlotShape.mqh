// PlotShape v1.0
#ifndef PlotShape_IMPL
#define PlotShape_IMPL

class PlotShape
{
public:
   static void Set(double& plot[], int period, string location, double seriesValue, double& high[], double& low[], int shift)
   {
      if (seriesValue == EMPTY_VALUE)
      {
         plot[period] = EMPTY_VALUE;
         return;
      }
      if (location == "abovebar" || location == "top")
      {
         plot[period] = high[period + shift];
         return;
      }
      if (location == "belowbar" || location == "bottom")
      {
         plot[period] = low[period + shift];
         return;
      }
      plot[period] = seriesValue;
   }
};

#endif