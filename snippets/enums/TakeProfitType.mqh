#ifndef TakeProfitType_IMP
#define TakeProfitType_IMP
enum TakeProfitType
{
   TPDoNotUse,    // Do not use
   TPPercent,     // Set in %
   TPPips,        // Set in Pips
   TPDollar,      // Set in $,
   TPRiskReward,  // Set in % of stop loss
   TPAbsolute,    // Set in absolite value (rate),
   TPAtr,         // Set in ATR(value) * mult
#ifdef CUSTOM_TP
   TPCustom       // Use custom strategy TP algorithm
#endif
};
#endif