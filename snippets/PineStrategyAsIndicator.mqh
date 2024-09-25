// Pine-script like strategy functions
// v1.0

#ifndef PineStrategy_IMPL
#define PineStrategy_IMPL

#include "Signaler.mqh"

class PineStrategy
{
public:
   static void Entry(Signaler* signaler, string id, bool longDirection)
   {
      signaler.SendNotifications(id);
   }
   
   static void Exit(Signaler* signaler, string id, string comment)
   {
      string message = id;
      if (comment != NULL)
      {
         message = message + ": " + comment;
      }
      signaler.SendNotifications(message);
   }
   
   static double GetPositionSize()
   {
      return 0;
   }
};

#endif 