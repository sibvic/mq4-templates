enum AveragesMethod
{
   SMA = MODE_SMA, // SMA
   EMA = MODE_EMA, // EMA
   SMMA = MODE_SMMA, // SMMA
   LWMA = MODE_LWMA, // LWMA
   WMA,
   SineWMA,
   TriMA,
   LSMA,
   HMA,
   ZeroLagEMA,
   DEMA,
   T3MA,
   ITrend,
   Median,
   GeoMean,
   REMA,
   ILRS,
   IE2,
   TriMAgen,
   JSmooth
};

double avg = iCustom(sym, tf, "averages", per*k, price, Mode, 0, i);

double temp = iCustom(NULL, 0, "averages", 0, 0);
   if (GetLastError() == ERR_INDICATOR_CANNOT_LOAD)
   {
      Alert("Please, install the 'averages' indicator (you can find it on FXCodeBase.com)");
      return INIT_FAILED;
   }

class ArrayStream : public IStream
{
public:
   double Buffer[];
   ArrayStream(const int streamId)
   {
      SetIndexBuffer(streamId, Buffer);
   }

   bool GetValue(const int period, double &val)
   {
      if (period >= Bars)
         return false;
      val = Buffer[period];
      return true;
   }
};

double workDsema[][_maWorkBufferx2];
#define _ema1 0
#define _ema2 1

double iDsema(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workDsema,0)!= Bars) ArrayResize(workDsema,Bars); instanceNo*=2;

   //
   //
   //
   //
   //
      
   double alpha = 2.0 /(1.0+MathSqrt(_length));
          workDsema[r][_ema1+instanceNo] = workDsema[r-1][_ema1+instanceNo]+alpha*(price                         -workDsema[r-1][_ema1+instanceNo]);
          workDsema[r][_ema2+instanceNo] = workDsema[r-1][_ema2+instanceNo]+alpha*(workDsema[r][_ema1+instanceNo]-workDsema[r-1][_ema2+instanceNo]);
   return(workDsema[r][_ema2+instanceNo]);
}

double workDema[][_maWorkBufferx2];
#define _dema1 0
#define _dema2 1

double iDema(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workDema,0)!= Bars) ArrayResize(workDema,Bars); instanceNo*=2;

   //
   //
   //
   //
   //
      
   double alpha = 2.0 / (1.0+_length);
          workDema[r][_dema1+instanceNo] = workDema[r-1][_dema1+instanceNo]+alpha*(price                         -workDema[r-1][_dema1+instanceNo]);
          workDema[r][_dema2+instanceNo] = workDema[r-1][_dema2+instanceNo]+alpha*(workDema[r][_dema1+instanceNo]-workDema[r-1][_dema2+instanceNo]);
   return(workDema[r][_dema1+instanceNo]*2.0-workDema[r][_dema2+instanceNo]);
}

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workSmma,0)!= Bars) ArrayResize(workSmma,Bars);

   //
   //
   //
   //
   //

   if (r<_length)
         workSmma[r][instanceNo] = price;
   else  workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/_length;
   return(workSmma[r][instanceNo]);
}

double workLwmp[][_maWorkBufferx1];
double iLwmp(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workLwmp,0)!= Bars) ArrayResize(workLwmp,Bars);
   
   //
   //
   //
   //
   //
   
   workLwmp[r][instanceNo] = price;
      double sumw = _length*_length;
      double sum  = sumw*price;

      for(int k=1; k<_length && (r-k)>=0; k++)
      {
         double weight = (_length-k)*(_length-k);
                sumw  += weight;
                sum   += weight*workLwmp[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

double workAlex[][_maWorkBufferx1];
double iAlex(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workAlex,0)!= Bars) ArrayResize(workAlex,Bars);
   if (_length<4) return(price);
   
   workAlex[r][instanceNo] = price;
      double sumw = _length-2;
      double sum  = sumw*price;

      for(int k=1; k<_length && (r-k)>=0; k++)
      {
         double weight = _length-k-2;
                sumw  += weight;
                sum   += weight*workAlex[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

double workTma[][_maWorkBufferx1];
double iTma(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workTma,0)!= Bars) ArrayResize(workTma,Bars);
   
   workTma[r][instanceNo] = price;

      double half = (_length+1.0)/2.0;
      double sum  = price;
      double sumw = 1;

      for(int k=1; k<_length && (r-k)>=0; k++)
      {
         double weight = k+1; if (weight > half) weight = _length-k;
                sumw  += weight;
                sum   += weight*workTma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}

double workSineWMA[][_maWorkBufferx1];
#define Pi 3.14159265358979323846264338327950288

double iSineWMA(double price, int _length, int r, int instanceNo=0)
{
   if (_length<1) return(price);
   if (ArrayRange(workSineWMA,0)!= Bars) ArrayResize(workSineWMA,Bars);
      
   workSineWMA[r][instanceNo] = price;
      double sum  = 0;
      double sumw = 0;
  
      for(int k=0; k<_length && (r-k)>=0; k++)
      { 
         double weight = MathSin(Pi*(k+1.0)/(_length+1.0));
                sumw  += weight;
                sum   += weight*workSineWMA[r-k][instanceNo]; 
      }
      return(sum/sumw);
}

double workHull[][_maWorkBufferx2];
double iHull(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workHull,0)!= Bars) ArrayResize(workHull,Bars);

      int Hma_length  = MathMax(_length,2);
      int Half_length = MathFloor(Hma_length/2);
      int Hull_length = MathFloor(MathSqrt(Hma_length));
      double hma,hmw,weight; instanceNo *= 2;

         workHull[r][instanceNo] = price;

         hmw = Half_length; hma = hmw*price; 
            for(int k=1; k<Half_length && (r-k)>=0; k++)
            {
               weight = Half_length-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][instanceNo];  
            }             
            workHull[r][instanceNo+1] = 2.0*hma/hmw;

         hmw = Hma_length; hma = hmw*price; 
            for(k=1; k<_length && (r-k)>=0; k++)
            {
               weight = Hma_length-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][instanceNo];
            }             
            workHull[r][instanceNo+1] -= hma/hmw;

         hmw = Hull_length; hma = hmw*workHull[r][instanceNo+1];
            for(k=1; k<Hull_length && (r-k)>=0; k++)
            {
               weight = Hull_length-k;
               hmw   += weight;
               hma   += weight*workHull[r-k][1+instanceNo];  
            }
   return(hma/hmw);
}

double workLinr[][_maWorkBufferx1];
double iLinr(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workLinr,0)!= Bars) ArrayResize(workLinr,Bars);
   
      _length = MathMax(_length,1);
      workLinr[r][instanceNo] = price;
         double lwmw = _length; double lwma = lwmw*price;
         double sma  = price;
         for(int k=1; k<_length && (r-k)>=0; k++)
         {
            double weight = _length-k;
                   lwmw  += weight;
                   lwma  += weight*workLinr[r-k][instanceNo];  
                   sma   +=        workLinr[r-k][instanceNo];
         }             
   
   return(3.0*lwma/lwmw-2.0*sma/_length);
}

double workIe2[][_maWorkBufferx1];
double iIe2(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workIe2,0)!= Bars) ArrayResize(workIe2,Bars);
   
      _length = MathMax(_length,1);
      workIe2[r][instanceNo] = price;
         double sumx=0, sumxx=0, sumxy=0, sumy=0;
         for (int k=0; k<_length; k++)
         {
            price = workIe2[r-k][instanceNo];
                   sumx  += k;
                   sumxx += k*k;
                   sumxy += k*price;
                   sumy  +=   price;
         }
         double tslope  = (_length*sumxy - sumx*sumy)/(sumx*sumx-_length*sumxx);
         double average = sumy/_length;
   return(((average+tslope)+(sumy+tslope*sumx)/_length)/2.0);
}

double workLeader[][_maWorkBufferx2];
double iLeader(double price, double _length, int r, int instanceNo=0)
{
   if (ArrayRange(workLeader,0)!= Bars) ArrayResize(workLeader,Bars); instanceNo*=2;

      _length = MathMax(_length,1);
      double alpha = 2.0/(_length+1.0);
         workLeader[r][instanceNo  ] = workLeader[r-1][instanceNo  ]+alpha*(price                          -workLeader[r-1][instanceNo  ]);
         workLeader[r][instanceNo+1] = workLeader[r-1][instanceNo+1]+alpha*(price-workLeader[r][instanceNo]-workLeader[r-1][instanceNo+1]);

   return(workLeader[r][instanceNo]+workLeader[r][instanceNo+1]);
}

double workSmooth[][_maWorkBufferx5];
double iSmooth(double price,int length,int r, int instanceNo=0)
{
   if (ArrayRange(workSmooth,0)!=Bars) ArrayResize(workSmooth,Bars); instanceNo *= 5;
 	if(r<=2) { workSmooth[r][instanceNo] = price; workSmooth[r][instanceNo+2] = price; workSmooth[r][instanceNo+4] = price; return(price); }
      
	double alpha = 0.45*(length-1.0)/(0.45*(length-1.0)+2.0);
   	  workSmooth[r][instanceNo+0] =  price+alpha*(workSmooth[r-1][instanceNo]-price);
	     workSmooth[r][instanceNo+1] = (price - workSmooth[r][instanceNo])*(1-alpha)+alpha*workSmooth[r-1][instanceNo+1];
	     workSmooth[r][instanceNo+2] =  workSmooth[r][instanceNo+0] + workSmooth[r][instanceNo+1];
	     workSmooth[r][instanceNo+3] = (workSmooth[r][instanceNo+2] - workSmooth[r-1][instanceNo+4])*MathPow(1.0-alpha,2) + MathPow(alpha,2)*workSmooth[r-1][instanceNo+3];
	     workSmooth[r][instanceNo+4] =  workSmooth[r][instanceNo+3] + workSmooth[r-1][instanceNo+4]; 
   return(workSmooth[r][instanceNo+4]);
}

double workSsm[][_maWorkBufferx2];
#define _tprice  0
#define _ssm    1

double workSsmCoeffs[][4];
#define __length 0
#define _c1     1
#define _c2     2
#define _c3     3

double iSsm(double price, double _length, int i, int instanceNo)
{
   if (ArrayRange(workSsm,0) !=Bars)                 ArrayResize(workSsm,Bars);
   if (ArrayRange(workSsmCoeffs,0) < (instanceNo+1)) ArrayResize(workSsmCoeffs,instanceNo+1);
   if (workSsmCoeffs[instanceNo][__length] != _length)
   {
      workSsmCoeffs[instanceNo][__length] = _length;
      double a1 = MathExp(-1.414*Pi/_length);
      double b1 = 2.0*a1*MathCos(1.414*Pi/_length);
         workSsmCoeffs[instanceNo][_c2] = b1;
         workSsmCoeffs[instanceNo][_c3] = -a1*a1;
         workSsmCoeffs[instanceNo][_c1] = 1.0 - workSsmCoeffs[instanceNo][_c2] - workSsmCoeffs[instanceNo][_c3];
   }

      int s = instanceNo*2;   
          workSsm[i][s+_tprice] = price;
          workSsm[i][s+_ssm]    = workSsmCoeffs[instanceNo][_c1]*(workSsm[i][s+_tprice]+workSsm[i-1][s+_tprice])/2.0 + 
                                  workSsmCoeffs[instanceNo][_c2]*workSsm[i-1][s+_ssm]                                + 
                                  workSsmCoeffs[instanceNo][_c3]*workSsm[i-2][s+_ssm]; 
   return(workSsm[i][s+_ssm]);
}

#define _length  0
#define _len     1
#define _weight  2

double  nlmvalues[3][_maWorkBufferx1];
double  nlmprices[ ][_maWorkBufferx1];
double  nlmalphas[ ][_maWorkBufferx1];

double iNonLagMa(double price, double length, int r, int instanceNo=0)
{
   if (ArrayRange(nlmprices,0) != Bars)       ArrayResize(nlmprices,Bars);
   if (ArrayRange(nlmvalues,0) <  instanceNo) ArrayResize(nlmvalues,instanceNo);
                               nlmprices[r][instanceNo]=price;
   if (length<3 || r<3) return(nlmprices[r][instanceNo]);
   
   if (nlmvalues[_length][instanceNo] != length  || ArraySize(nlmalphas)==0)
   {
      double Cycle = 4.0;
      double Coeff = 3.0*Pi;
      int    Phase = length-1;
      
         nlmvalues[_length][instanceNo] = length;
         nlmvalues[_len   ][instanceNo] = length*4 + Phase;  
         nlmvalues[_weight][instanceNo] = 0;

         if (ArrayRange(nlmalphas,0) < nlmvalues[_len][instanceNo]) ArrayResize(nlmalphas,nlmvalues[_len][instanceNo]);
         for (int k=0; k<nlmvalues[_len][instanceNo]; k++)
         {
            if (k<=Phase-1) 
                 double t = 1.0 * k/(Phase-1);
            else        t = 1.0 + (k-Phase+1)*(2.0*Cycle-1.0)/(Cycle*length-1.0); 
            double beta = MathCos(Pi*t);
            double g = 1.0/(Coeff*t+1); if (t <= 0.5 ) g = 1;
      
            nlmalphas[k][instanceNo]        = g * beta;
            nlmvalues[_weight][instanceNo] += nlmalphas[k][instanceNo];
         }
   }
   
   if (nlmvalues[_weight][instanceNo]>0)
   {
      double sum = 0;
           for (k=0; k < nlmvalues[_len][instanceNo]; k++) sum += nlmalphas[k][instanceNo]*nlmprices[r-k][instanceNo];
           return( sum / nlmvalues[_weight][instanceNo]);
   }
   else return(0);           
}