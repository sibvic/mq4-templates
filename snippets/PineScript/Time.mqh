// Time-related functions from Pine Script
// v1.1

class PineScriptTime
{
public:
   static int Year(datetime time)
   {
      return TimeYear(time);
   }
   static int Year(datetime time, string timezone)
   {
      return TimeYear(time);
   }
   static int Month(datetime time)
   {
      return TimeMonth(time);
   }
   static int Month(datetime time, string timezone)
   {
      return TimeMonth(time);
   }
   static int DayOfMonth(datetime time)
   {
      return TimeDay(time);
   }
   static int DayOfMonth(datetime time, string timezone)
   {
      return TimeDay(time);
   }
   static int DayOfWeek(datetime time)
   {
      return TimeDayOfWeek(time);
   }
   static int DayOfWeek(datetime time, string timezone)
   {
      return TimeDayOfWeek(time);
   }
   static int Hour(datetime time)
   {
      return TimeHour(time);
   }
   static int Hour(datetime time, string timezone)
   {
      return TimeHour(time);
   }
   static int Minute(datetime time)
   {
      return TimeMinute(time);
   }
   static int Minute(datetime time, string timezone)
   {
      return TimeMinute(time);
   }
   static int Second(datetime time)
   {
      return TimeSeconds(time);
   }
   static int Second(datetime time, string timezone)
   {
      return TimeSeconds(time);
   }
   static int Sunday()
   {
      return 0;
   }
   static int Monday()
   {
      return 1;
   }
   static int Tuesday()
   {
      return 2;
   }
   static int Wednesday()
   {
      return 3;
   }
   static int Thursday()
   {
      return 4;
   }
   static int Friday()
   {
      return 5;
   }
   static int Saturday()
   {
      return 6;
   }
};