// Time-related functions from Pine Script
// v1.2

class PineScriptTime
{
public:
   static int Now()
   {
      return TimeCurrent() * 1000;
   }
   static int ToMS(datetime time)
   {
      return time * 1000;
   }
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
   static bool IsIntradayTradingTime(const MqlDateTime &current_time, int startTime, int endTime)
   {
      if (startTime == endTime)
      {
         return true;
      }
      int current_t = TimeToInt(current_time);
      if (startTime > endTime)
      {
         return current_t >= startTime || current_t <= endTime;
      }
      return current_t >= startTime && current_t <= endTime;
   }
   static int TimeToInt(const MqlDateTime &current_time)
   {
      return (current_time.hour * 60 + current_time.min) * 60 + current_time.sec;
   }
   
   static int ParseTime(const string time, string &error)
   {
      string items[];
      StringSplit(time, ':', items);
      int hours;
      int minutes;
      int seconds;
      if (ArraySize(items) > 1)
      {
         if (ArraySize(items) != 3)
         {
            error = "Bad format for " + time;
            return -1;
         }
         //hh:mm:ss
         seconds = (int)StringToInteger(items[2]);
         minutes = (int)StringToInteger(items[1]);
         hours = (int)StringToInteger(items[0]);
      }
      else if (StringLen(time) == 6)
      {
         //hhmmss
         int time_parsed = (int)StringToInteger(time);
         seconds = time_parsed % 100;
         
         time_parsed /= 100;
         minutes = time_parsed % 100;
         time_parsed /= 100;
         hours = time_parsed % 100;
      }
      else if (StringLen(time) == 4)
      {
         //hhmm
         int time_parsed = (int)StringToInteger(time);
         seconds = 0;
         minutes = time_parsed % 100;
         time_parsed /= 100;
         hours = time_parsed % 100;
      }
      else
      {
         error = "Unknown format: " + time;
         return -1;
      }
      if (hours > 24)
      {
         error = "Incorrect number of hours in " + time;
         return -1;
      }
      if (minutes > 59)
      {
         error = "Incorrect number of minutes in " + time;
         return -1;
      }
      if (seconds > 59)
      {
         error = "Incorrect number of seconds in " + time;
         return -1;
      }
      if (hours == 24 && (minutes != 0 || seconds != 0))
      {
         error = "Incorrect date";
         return -1;
      }
      return (hours * 60 + minutes) * 60 + seconds;
   }
};