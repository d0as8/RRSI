//+------------------------------------------------------------------+
//|                                                         RRSI.mq4 |
//|                                                            d0as8 |
//|                                                             1.00 |
//+------------------------------------------------------------------+
#property description "Relative Relative Strength Index"
#property copyright "d0as8"
#property version   "1.00"
#property strict

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   1

#property indicator_label1  "RSI High"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrSteelBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "RSI Slow"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrSpringGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_minimum  -0.5
#property indicator_maximum  +0.5
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT
#property indicator_levelcolor clrGray

double RSIBuffer1[];
double RSIBuffer2[];

input int    period1 = 25;   // High RSI period
input double trim1   = 0.30; // High RSI trim threshold
input int    period2 = 50;   // Slow RSI period
input double trim2   = 0.10; // Slow RSI trim threshold

int OnInit()
{
   SetIndexBuffer(0, RSIBuffer1);
   SetIndexBuffer(1, RSIBuffer2);

   IndicatorSetInteger(INDICATOR_LEVELS, 4);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, -trim1);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, +trim1);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 2, -trim2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 3, +trim2);
   
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i, limit;

   limit=rates_total-prev_calculated;
   if(0 < prev_calculated)
      limit++;

   for(i = 0; i < limit; i++) {
      RSIBuffer1[i] = iRSI(NULL, 0, period1, PRICE_WEIGHTED, i)/50 - 1.0;
      RSIBuffer2[i] = iRSI(NULL, 0, period2, PRICE_WEIGHTED, i)/50 - 1.0;

      if (trim1 >= MathAbs(RSIBuffer1[i])) RSIBuffer1[i] = 0;
      if (trim2 >= MathAbs(RSIBuffer2[i])) RSIBuffer2[i] = 0;

      if (0 == RSIBuffer1[i]) RSIBuffer2[i] = 0;
      if (0 == RSIBuffer2[i]) RSIBuffer1[i] = 0;
   }

   return(rates_total);
}