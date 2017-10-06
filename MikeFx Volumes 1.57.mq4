//+------------------------------------------------------------------+
//|                                               MikeFx Volumes.mq4 |
//|                                                     Michal Kukiz |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Kukiz"
#property link      "mikekukiz@gmail.com"
#property version   "1.56"
#property strict
#property indicator_separate_window

#property indicator_buffers 33
#property indicator_plots 25

#property indicator_minimum -1500
#property indicator_maximum 1000


#property indicator_color1 clrBlack
#property indicator_type1 DRAW_NONE
#property indicator_width1 1
#property indicator_label1 "Normal trend direction (export)"

#property indicator_color2 clrBlack
#property indicator_type2 DRAW_NONE
#property indicator_width2 1
#property indicator_label2 "Dynamic trend direction (export)"

#property indicator_color3 clrBlack
#property indicator_type3 DRAW_NONE
#property indicator_width3 1
#property indicator_label3 "Super-dynamic trend direction (export)"


#property indicator_color4 clrSilver
#property indicator_type4 DRAW_HISTOGRAM
#property indicator_width4 2
#property indicator_label4 "Real value"

#property indicator_color5 clrGreen
#property indicator_type5 DRAW_HISTOGRAM
#property indicator_width5 2
#property indicator_label5 "Volume Up"

#property indicator_color6 clrRed
#property indicator_type6 DRAW_HISTOGRAM
#property indicator_width6 2
#property indicator_label6 "Volume Down"

#property indicator_color7 clrOrange
#property indicator_type7 DRAW_HISTOGRAM
#property indicator_width7 2
#property indicator_label7 "Non-progressive volume"

#property indicator_color8 clrBlue
#property indicator_type8 DRAW_ARROW
#property indicator_width8 2
#property indicator_label8 "Preliminary signal"

#property indicator_color9 clrGreen
#property indicator_type9 DRAW_ARROW
#property indicator_width9 2
#property indicator_label9 "Buy"

#property indicator_color10 clrRed
#property indicator_type10 DRAW_ARROW
#property indicator_width10 2
#property indicator_label10 "Sell"

#property indicator_color11 clrBlue
#property indicator_type11 DRAW_ARROW
#property indicator_width11 2
#property indicator_label11 "Strong signal"


#property indicator_color12 clrRed
#property indicator_type12 DRAW_ARROW
#property indicator_width12 1
#property indicator_label12 "Trend Down - Normal"

#property indicator_color13 clrGreen
#property indicator_type13 DRAW_ARROW
#property indicator_width13 1
#property indicator_label13 "Trend Up - Normal"

#property indicator_color14 clrYellow
#property indicator_type14 DRAW_ARROW
#property indicator_width14 1
#property indicator_label14 "Trend Down (Unsure) - Normal"

#property indicator_color15 clrYellow
#property indicator_type15 DRAW_ARROW
#property indicator_width15 1
#property indicator_label15 "Trend Up (Unsure) - Normal"


#property indicator_color16 clrRed
#property indicator_type16 DRAW_ARROW
#property indicator_width16 1
#property indicator_label16 "Trend Down - Dynamic"

#property indicator_color17 clrGreen
#property indicator_type17 DRAW_ARROW
#property indicator_width17 1
#property indicator_label17 "Trend Up - Dynamic"

#property indicator_color18 clrYellow
#property indicator_type18 DRAW_ARROW
#property indicator_width18 1
#property indicator_label18 "Trend Down (Unsure) - Dynamic"

#property indicator_color19 clrYellow
#property indicator_type19 DRAW_ARROW
#property indicator_width19 1
#property indicator_label19 "Trend Up (Unsure) - Dynamic"


#property indicator_color20 clrRed
#property indicator_type20 DRAW_ARROW
#property indicator_width20 1
#property indicator_label20 "Trend Down - Super Dynamic"

#property indicator_color21 clrGreen
#property indicator_type21 DRAW_ARROW
#property indicator_width21 1
#property indicator_label21 "Trend Up - Super Dynamic"

#property indicator_color22 clrYellow
#property indicator_type22 DRAW_ARROW
#property indicator_width22 1
#property indicator_label22 "Trend Down (Unsure) - Super Dynamic"

#property indicator_color23 clrYellow
#property indicator_type23 DRAW_ARROW
#property indicator_width23 1
#property indicator_label23 "Trend Up (Unsure) - Super Dynamic"


#property indicator_color24 clrBlue
#property indicator_type24 DRAW_LINE
#property indicator_width24 1
#property indicator_label24 "Average"

#property indicator_color25 clrRed
#property indicator_type25 DRAW_ARROW
#property indicator_width25 2
#property indicator_label25 "Cancel"


#define ID "MikeFx 1.56 - "

#define TTT TIME_DATE|TIME_MINUTES|TIME_SECONDS

struct SInterval
{
   datetime first;
   datetime last;
   double mm;
};

enum Direction
{
  LOWER,
  NONE,
  UPPER
};

input int inMaxBars = 10000;      // Max bars for calculation (0 - all)
input int inSegmentMinProg = 2; // Progressive bars amount is greater than

input int inIntervals = 3;    // Interval count
input bool inSig = true;      // Draw rects with signals only
input bool inOpposite = true; // Show opposite signals only
input bool inDebug = false;   // Debug
input bool inSplashFilter = false; // Splash filtering
input bool inShowLines = true; // Show trend lines
input bool inShadowShortening = false; // Shadow Shortening

input string strenddirection = "---------- TREND DIRECTION ----------"; // ---------- TREND DIRECTION ----------
input int inNormalTrendDisplayLevel = -1100; // Display level for normal trend
input int inDynamicTrendDisplayLevel = -1250; // Display level for dynamic trend
input int inSuperDynamicTrendDisplayLevel = -1400; // Display level for super dynamic trend
input bool showNormalTrend = true;
input bool showDynamicTrend = true;
input bool showSuperDynamicTrend = true;
input bool inVolumeBreak = true; // Use volume break
input double inReversalRangeMultiplierNormal = 1.0; // Multiplier of reversal range - normal trend
input double inReversalRangeMultiplierDynamic = 1.0; // Multiplier of reversal range - dynamic trend
input double inReversalRangeMultiplierSuperDynamic = 1.0; // Multiplier of reversal range - super dynamic trend

input bool inReversalLevelsNormal = false; // Draw reversal levels - normal trend
input bool inReversalLevelsDynamic = false; // Draw reversal levels - dynamic trend
input bool inReversalLevelsSuperDynamic = false; // Draw reversal levels - super dynamic trend

input string smlabels = "---------- RATIO LABELS ----------"; // ---------- RATIO LABELS ----------
input string inLabelFont = "Arial"; // Font
input int inLabelSize = 9; // Size
input color inLabelColor = clrWhite; // Color
input bool inPips = true; // Pips ratio
input bool inDist = true; // Show distance
input bool inHalf = true; // Half volume add of two colored bars
input bool inProgressiveCounter = true; // Show progressive bars counter

input string srect = "---------- RECTANGLES ----------"; // ---------- RECTANGLES ----------
input bool inRects = false;    // Draw rectangles
input color inRectBuy = clrGreen; // Buy rect color
input color inRectSell = clrRed; // Sell rect color
input color inRectColor = clrMagenta; // Other rect color
input ENUM_LINE_STYLE inRectLine = STYLE_SOLID; // Rect line style
input int inRectWidth = 2; // Rect line width
input bool inRectBack = false; // Rect as background

input string ssegmentrect = "---------- SEGMENT RECTANGLES ----------"; // ---------- SEGMENT RECTANGLES ----------
input bool inDrawSegmentRects = true;    // Draw segment rectangles
input color inSegmentRectUpper = clrBlue; // Upper segment rect color
input color inSegmentRectLower = clrRed; // Lower segment rect color
input ENUM_LINE_STYLE inSegmentRectLine = STYLE_SOLID; // Segment rect line style
input int inSegmentRectWidth = 2; // Segment rect line width
input bool inSegmentRectBack = false; // Segment rect as background
input bool inSegmentRectMinProg = true; // Segment rects only with enough progressive bars

input string strend = "---------- MAIN TREND LINES ----------"; // ---------- MAIN TREND LINES ----------
input bool inDrawStrong = false; // Draw main-trend lines
input ENUM_LINE_STYLE inMainStyleV = STYLE_SOLID; // Main vertical lines style
input int inMainWidthV = 1; // Main vertical lines width
input ENUM_LINE_STYLE inMainStyleT = STYLE_SOLID; // Main trend lines style
input int inMainWidthT = 4; // Main trend lines width
input color inMainBuyV = clrGreen; // Main vertical line color (buy)
input color inMainBuyT = clrGreen; // Main trend line color (buy)
input color inMainSellV = clrRed; // Main vertical line color (sell)
input color inMainSellT = clrRed; // Main trend line color (sell)

input string smtrend = "---------- MINOR TREND LINES ----------"; // ---------- MINOR TREND LINES ----------
input bool inDrawTrend = false; // Draw mintor-trend lines
input ENUM_LINE_STYLE inMinorStyleV = STYLE_DASH; // Main vertical lines style
input int inMinorWidthV = 1; // Main vertical lines width
input ENUM_LINE_STYLE inMinorStyleT = STYLE_SOLID; // Minor trend lines style
input int inMinorWidthT = 2; // Minor trend lines width
input color inMinorBuyV = clrGreen; // Minor vertical line color (buy)
input color inMinorBuyT = clrGreen; // Minor trend line color (buy)
input color inMinorSellV = clrRed; // Minor vertical line color (sell)
input color inMinorSellT = clrRed; // Minor trend line color (sell)

input string srepainting = "---------- REPAINTING ----------"; // ---------- REPAINTING ----------
input bool inRepaint = false; // Repaint negligible volume bars

double NORMAL_TREND_EXPORT[]; // export for other indicators
double DYNAMIC_TREND_EXPORT[]; // export for other indicators
double SUPER_DYNAMIC_TREND_EXPORT[]; // export for other indicators

double MIDDLE[]; // used for calculations
double UP[]; // used for calculations
double DN[]; // used for calculations
double V[]; // used for calculations
double UP_DISPLAY[]; // used for display purposes (repainting possible)
double DN_DISPLAY[]; // used for display purposes (repainting possible)
double V_DISPLAY[]; // used for display purposes (repainting possible)
double NONPROG_DISPLAY[];
double SIG[];
double BUY[];
double SELL[];
double STRONGSIG[];
double TUP[];
double TDN[];
double TUP_NORMAL[];
double TDN_NORMAL[];
double T_NORMAL_U[];
double T_NORMAL_U2[];
double TUP_DYNAMIC[];
double TDN_DYNAMIC[];
double T_DYNAMIC_U[];
double T_DYNAMIC_U2[];
double TUP_SUPER_DYNAMIC[];
double TDN_SUPER_DYNAMIC[];
double T_SUPER_DYNAMIC_U[];
double T_SUPER_DYNAMIC_U2[];
double CANCEL[];
double AVERAGE[]; // w8wat

double HIGH_CALCULATED[];
double LOW_CALCULATED[];


double signal = 0;
datetime signallast = 0;
datetime stronglast = 0;
bool tfirst = true;

datetime rectlast = 0;
datetime rectll = 0;
color rlsig = 0;
color rllsig = 0;

bool hlCalculated = false;

const int NORMAL_TREND_BAR_N = 3;
const int SUPER_DYNAMIC_TREND_BAR_N = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, NORMAL_TREND_EXPORT);
   SetIndexBuffer(1, DYNAMIC_TREND_EXPORT);
   SetIndexBuffer(2, SUPER_DYNAMIC_TREND_EXPORT);

   SetIndexBuffer(3, V_DISPLAY);
   SetIndexBuffer(4, UP_DISPLAY);
   SetIndexBuffer(5, DN_DISPLAY);
   SetIndexBuffer(6, NONPROG_DISPLAY);

   SetIndexBuffer(7, SIG);
   SetIndexArrow(7, 172);
   SetIndexBuffer(8, BUY);
   SetIndexArrow(8, 233);
   SetIndexBuffer(9, SELL);
   SetIndexArrow(9, 234);

   SetIndexBuffer(10, STRONGSIG);
   SetIndexArrow(10, 203);

   SetIndexBuffer(11, TDN_NORMAL);
   SetIndexArrow(11, 110);
   SetIndexBuffer(12, TUP_NORMAL);
   SetIndexArrow(12, 110);
   SetIndexBuffer(13, T_NORMAL_U);
   SetIndexArrow(13, 110);
   SetIndexBuffer(14, T_NORMAL_U2);
   SetIndexArrow(14, 110);

   SetIndexBuffer(15, TDN_DYNAMIC);
   SetIndexArrow(15, 110);
   SetIndexBuffer(16, TUP_DYNAMIC);
   SetIndexArrow(16, 110);
   SetIndexBuffer(17, T_DYNAMIC_U);
   SetIndexArrow(17, 110);
   SetIndexBuffer(18, T_DYNAMIC_U2);
   SetIndexArrow(18, 110);

   SetIndexBuffer(19, TDN_SUPER_DYNAMIC);
   SetIndexArrow(19, 110);
   SetIndexBuffer(20, TUP_SUPER_DYNAMIC);
   SetIndexArrow(20, 110);
   SetIndexBuffer(21, T_SUPER_DYNAMIC_U);
   SetIndexArrow(21, 110);
   SetIndexBuffer(22, T_SUPER_DYNAMIC_U2);
   SetIndexArrow(22, 110);

   SetIndexBuffer(23, AVERAGE);
   SetIndexBuffer(24, CANCEL);

   SetIndexBuffer(25, MIDDLE);
   SetIndexBuffer(26, V);
   SetIndexBuffer(27, UP);
   SetIndexBuffer(28, DN);
   SetIndexBuffer(29, TDN);
   SetIndexBuffer(30, TUP);

   SetIndexBuffer(31, HIGH_CALCULATED);
   SetIndexBuffer(32, LOW_CALCULATED);

   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexStyle(2, DRAW_NONE);

   SetIndexStyle(7, DRAW_NONE);
   SetIndexStyle(8, DRAW_NONE);
   SetIndexStyle(9, DRAW_NONE);
   SetIndexStyle(10, DRAW_NONE);
   
   if (!showNormalTrend){
      SetIndexStyle(11,  DRAW_NONE);
      SetIndexStyle(12,  DRAW_NONE);      
      SetIndexStyle(13,  DRAW_NONE);      
      SetIndexStyle(14,  DRAW_NONE);      
   }
   if (!showDynamicTrend){
      SetIndexStyle(15,  DRAW_NONE);
      SetIndexStyle(16,  DRAW_NONE);      
      SetIndexStyle(17,  DRAW_NONE);      
      SetIndexStyle(18,  DRAW_NONE);      
   }
   
   if (!showSuperDynamicTrend){
      SetIndexStyle(19,  DRAW_NONE);
      SetIndexStyle(20,  DRAW_NONE);      
      SetIndexStyle(21,  DRAW_NONE);      
      SetIndexStyle(22,  DRAW_NONE);         
   }
   

   SetIndexStyle(24, DRAW_NONE);
   SetIndexStyle(25, DRAW_NONE);
   SetIndexStyle(26, DRAW_NONE);
   SetIndexStyle(27, DRAW_NONE);
   SetIndexStyle(28, DRAW_NONE);
   SetIndexStyle(29, DRAW_NONE);
   SetIndexStyle(30, DRAW_NONE);

   SetIndexStyle(31, DRAW_NONE);
   SetIndexStyle(32, DRAW_NONE);

   tfirst = true;
   signal = 0;
   signallast = 0;
   stronglast = 0;
   rectlast = rectll = 0;
   rlsig = 0;
   rllsig = 0;
   bool wtf = true;

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, ID);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
   //return rates_total;
   int pos = (prev_calculated > 0) ? prev_calculated : 4;
   int limit = (inMaxBars > 0) ? (int)MathMin(rates_total - pos, inMaxBars) : rates_total - pos;
   limit = MathMin(limit, Bars - inSegmentMinProg - 1);

   if (!hlCalculated)
   {
     for (int k = Bars - 1; k >= 1; --k)
       CalculateHighLow(k);

     hlCalculated = true;
   }

	for (int i = limit; i >= 1; --i )
	{
     CalculateHighLow(i);

	   Direction volumeDirection;
	   double m = (HIGH_CALCULATED[i+1] + LOW_CALCULATED[i+1])*0.5;

      // current segment: LOWER
      if (V[i + 1] < 0)
      {
         int lastProgressiveIndex = LastProgressiveIndex(i);
         double lastProgressiveHigh = HIGH_CALCULATED[lastProgressiveIndex];

         // breakout - UPPER segment starts
         if (Close[i] > lastProgressiveHigh)
         {
            volumeDirection = UPPER;

            UP[i] = NormalizeDouble(Volume[i], 0);
            DN[i] = EMPTY_VALUE;
         }

         // continue LOWER segment
         else
         {
            volumeDirection = LOWER;

            DN[i] = (-1)*NormalizeDouble(Volume[i], 0);
            UP[i] = EMPTY_VALUE;
         }
      }

      // current segment: UPPER
      else
      {
         int lastProgressiveIndex = LastProgressiveIndex(i);
         double lastProgressiveLow = LOW_CALCULATED[lastProgressiveIndex];

         // breakout - LOWER segment starts
         if (Close[i] < lastProgressiveLow)
         {
            volumeDirection = LOWER;

            DN[i] = (-1)*NormalizeDouble(Volume[i], 0);
            UP[i] = EMPTY_VALUE;
         }

         // continue UPPER segment
         else
         {
            volumeDirection = UPPER;

            UP[i] = NormalizeDouble(Volume[i], 0);
            DN[i] = EMPTY_VALUE;
         }
      }

      UP_DISPLAY[i] = UP[i];
      DN_DISPLAY[i] = DN[i];


      if (volumeDirection == UPPER)
      {
         if (inRepaint)
         {
            RepaintNegativeToZero(i);
         }

         if (inDrawSegmentRects)
         {
            if (i > 0)
               UpdateUpperSegmentRectangle(i);
         }
      }

      else if (volumeDirection == LOWER)
      {
         if (inRepaint)
         {
            RepaintPositiveToZero(i);
         }

         if (inDrawSegmentRects)
         {
            if (i > 0)
               UpdateLowerSegmentRectangle(i);
         }
      }

      double v = (UP[i] == EMPTY_VALUE) ? DN[i] : UP[i];
      bool progressive = IsProgressiveCandle(i);
      bool doji = IsDojiCandle(i);

      NONPROG_DISPLAY[i] = ((!progressive) || (doji)) ? v : EMPTY_VALUE;

      V[i] = NormalizeDouble(Volume[i],0) * ((UP[i] == EMPTY_VALUE) ? -1 : 1);
      V_DISPLAY[i] = V[i];
      MIDDLE[i] = v*0.5;

      AVERAGE[i] = ((progressive) && (!doji)) ? (v / 2) : (v / 4); // no, it's not an average


      handleNormalTrend(i);
      handleDynamicTrend(i);
      handleSuperDynamicTrend(i);
      
      UpdateExportValues(i);


      if (V[i+1]*V[i+2] < 0 && V[i+2]*V[i+3] < 0)
      {
         if (inSplashFilter)
         {
            V[i+2] *= -1;
            V_DISPLAY[i+2]*= -1;
         }

         if (SIG[i+2] != EMPTY_VALUE)
         {
            CANCEL[i+2] = SIG[i+2];
            SIG[i+2] = EMPTY_VALUE;
            STRONGSIG[i+2] = EMPTY_VALUE;
            if (ObjectDelete(0, ID+TimeToStr(Time[i], TTT)+" R"))
            {
               // rectlast = rectll;
               // rlsig = rllsig;
            }
            ObjectDelete(0, ID+TimeToStr(Time[i], TTT)+" RV");
            ObjectDelete(0, ID+TimeToStr(Time[i+2], TTT)+" TRENDV");
            ObjectDelete(0, ID+TimeToStr(Time[i+2], TTT)+" TREND");

         }
      }

      double h = 0, l = INT_MAX;
      double vmax = 0;
      int vidx = 0;
      double sum = 0;
      int ii = MathMax(i, 1);
      int j = ii, k = 0;
      int progressiveCounter = 0;

      for (j = ii; j < rates_total && V[ii]*V[j] > 0; ++j)
      {
         h = MathMax(h, HIGH_CALCULATED[j]);
         l = MathMin(l, LOW_CALCULATED[j]);
         if (MathAbs(V[j]) > vmax)
         {
            vmax = MathAbs(V[j]);
            vidx = j;
         }

         if ((IsCalculatedAsProgressive(j)) && (!IsDojiCandle(j)))
         {
            sum += (inHalf && NormalizeDouble(MIDDLE[j], 0) != NormalizeDouble(V[j]*0.5, 0)) ? MathAbs(V[j]*0.5) : MathAbs(V[j]);
         }
      }

      for (k = j; k < rates_total && V[k]*V[j] > 0; ++k)
      {
         if ((IsCalculatedAsProgressive(k)) && (!IsDojiCandle(k)))
         {
            ++progressiveCounter;
         }
      }

      int wnd = ChartWindowFind();

      if (progressiveCounter <= inSegmentMinProg)
      {
         ObjectDelete(0, ID + "VSUM" + TimeToStr(Time[k-1], TTT));
         ObjectDelete(0, ID + "RATIO" + TimeToStr(Time[k-1], TTT));

         if (inSegmentRectMinProg)
         {
            int sequenceStartIndex = VolumeSequenceStartIndex(j);

            if (sequenceStartIndex < Bars)
            {
               datetime sequenceStartTime = Time[sequenceStartIndex];
               string name = ID + TimeToStr(sequenceStartTime, TTT) + " SEGMENT RECT";
               ObjectDelete(0, name);
            }

            ObjectDelete(0, ID + "VSUM_RECT" + TimeToStr(Time[k-1], TTT));
         }
      }

      if (inDrawSegmentRects)
      {
         string content = DoubleToStr(sum, 0);

         if (inProgressiveCounter)
         {
            int currentProgressiveCounter = countProgressiveCandles(i);
            content += " (" + IntegerToString(currentProgressiveCounter) + ")";
         }

         if (V[(j+ii)/2] > 0)
         {
            TextCreate(0, ID + "VSUM_RECT" + TimeToStr(Time[j-1], TTT), Time[(j+ii)/2], h, content, inLabelFont, inLabelSize, inLabelColor, 0, ANCHOR_LOWER);
         }
         else
         {
            TextCreate(0, ID + "VSUM_RECT" + TimeToStr(Time[j-1], TTT), Time[(j+ii)/2], l, content, inLabelFont, inLabelSize, inLabelColor, 0, ANCHOR_UPPER);
         }
         
         double pp = (inPips) ? pip(Symbol()) : Point;
         TextCreate(wnd, ID + "VSUM" + TimeToStr(Time[j-1], TTT), Time[(j+ii)/2], V[vidx], DoubleToStr(sum, 0), inLabelFont, inLabelSize, inLabelColor, 0, ANCHOR_UPPER);

         if ((sum != 0) && (pp != 0))
         {
            TextCreate(wnd, ID + "RATIO" + TimeToStr(Time[j-1], TTT), Time[(j+ii)/2], V[vidx],
               (inDist) ? StringFormat("%s (%.1f)", DoubleToStr(((h-l)/pp)/sum, 4), (h-l)/pp) : DoubleToStr(((h-l)/pp)/sum, 4),
               inLabelFont, inLabelSize, inLabelColor, 0, ANCHOR_LOWER);
        }
      }

      checkForSignal(i);
      checkTrend(i+1);

      if (SIG[i+1] != EMPTY_VALUE)
      {
         color c = (SIG[i+1] > 0) ? inRectBuy : inRectSell;
         int begin = i+1;
         bool opp = false;
         if (SIG[i+1] > 0 && TDN[i+1] == 0)
            opp = true;
         if (SIG[i+1] < 0 && TUP[i+1] == 0)
            opp = true;

         if (MIDDLE[i+1] * MIDDLE[i+2] > 0)
         {
            begin = i+2;
            if (SIG[i+1] > 0 && TDN[i+2] == 0)
            {
               opp = true;
               if (inMaxBars > 0)
               {
                  TDN[i+1] = 0;
                  TUP[i+1] = EMPTY_VALUE;
               }
            }
            if (SIG[i+1] < 0 && TUP[i+2] == 0)
            {
               opp = true;
               if (inMaxBars > 0)
               {
                  TUP[i+1] = 0;
                  TDN[i+1] = EMPTY_VALUE;
               }
            }
         }

         if (inSig)
         {
            int e = begin - 2;
            double bot = LOW_CALCULATED[iLowestCalculatedIndex(e, 3)];
            double top = HIGH_CALCULATED[iHighestCalculatedIndex(e, 3)];

            string name = ID + TimeToStr(Time[i+2], TTT) + " TRENDV";
            //if (SIG[i+2] == EMPTY_VALUE)
            //   ObjectCreate(0, ID + TimeToStr(Time[i+2], TTT) + " TRENDV", OBJ_ARROW, 0, Time[i+1], bot);

            if (ObjectFind(0, name) >= 0 && SIG[i+2] == EMPTY_VALUE)
            {
               ObjectSetInteger(0, name, OBJPROP_TIME2, Time[i+1]);
               ObjectSetDouble(0, name, OBJPROP_PRICE2, Close[i+1]);
               //ObjectSetInteger(0, name, OBJPROP_TIME, Time[i+1]);
            }

            if (!inOpposite || (inOpposite && opp))
            {
               if (inRects)
                  drawRect(e, begin, bot, top, c);

               if (inDrawTrend )
               {
                  name = ID + TimeToStr(Time[begin], TTT) + " TREND";

                  ObjectCreate(0, name+"V", OBJ_VLINE, 0, Time[begin], 0);

                  ObjectSetInteger(0, name+"V", OBJPROP_COLOR, (c == inRectBuy) ? inMinorBuyV : inMinorSellV);
                  ObjectSetInteger(0, name+"V", OBJPROP_BACK, inRectBack);
                  ObjectSetInteger(0, name+"V", OBJPROP_STYLE, inMinorStyleV);
                  ObjectSetInteger(0, name+"V", OBJPROP_HIDDEN, true);
                  ObjectSetInteger(0, name+"V", OBJPROP_WIDTH, (inMinorStyleV != STYLE_SOLID) ? 1 : inMinorWidthV);

                  int shift = iBarShift(NULL, 0, rectlast);
                  if (inShowLines)
                  {
                     ObjectCreate(0, name, OBJ_TREND, 0, rectlast, Close[shift], Time[begin], Close[begin]);
                     ObjectSetInteger(0, name, OBJPROP_RAY, false);
                     ObjectSetInteger(0, name, OBJPROP_STYLE, inMinorStyleT);
                     ObjectSetInteger(0, name, OBJPROP_WIDTH, (inMinorStyleT != STYLE_SOLID) ? 1 : inMinorWidthT);
                     ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
                     color cc = (color)ObjectGetInteger(0, ID + TimeToStr(rectlast, TTT) + " TRENDV", OBJPROP_COLOR);
                     ObjectSetInteger(0, name, OBJPROP_COLOR, (rlsig == inRectBuy) ? inMinorBuyT : inMinorSellT);
                  }
               }

               rectll = rectlast;
               rllsig = rlsig;
               rectlast = Time[begin];
               rlsig = c;
            }
         }
      }
	 }

   return(rates_total);
}
//+------------------------------------------------------------------+


void CalculateHighLow(int i)
{
  if (inShadowShortening)
  {
    double upperShadow = High[i] - MathMax(Open[i], Close[i]);
    double lowerShadow = MathMin(Open[i], Close[i]) - Low[i];

    if (upperShadow > lowerShadow)
    {
      HIGH_CALCULATED[i] = MathMax(Open[i], Close[i]) + (upperShadow - lowerShadow);
      LOW_CALCULATED[i] = MathMin(Open[i], Close[i]);
    }

    else if (upperShadow < lowerShadow)
    {
      HIGH_CALCULATED[i] = MathMax(Open[i], Close[i]);
      LOW_CALCULATED[i] = MathMin(Open[i], Close[i]) - (lowerShadow - upperShadow);
    }

    else
    {
      HIGH_CALCULATED[i] = MathMax(Open[i], Close[i]);
      LOW_CALCULATED[i] = MathMin(Open[i], Close[i]);
    }
  }

  else
  {
    HIGH_CALCULATED[i] = High[i];
    LOW_CALCULATED[i] = Low[i];
  }
}


int iHighestCalculatedIndex(int start, int count)
{
  int index = start;
  double value = HIGH_CALCULATED[start];

  for (int i = start + 1; i < start + count; ++i)
  {
    if (HIGH_CALCULATED[i] > value)
    {
      index = i;
      value = HIGH_CALCULATED[i];
    }
  }

  return index;
}


int iLowestCalculatedIndex(int start, int count)
{
  int index = start;
  double value = LOW_CALCULATED[start];

  for (int i = start + 1; i < start + count; ++i)
  {
    if (LOW_CALCULATED[i] < value)
    {
      index = i;
      value = LOW_CALCULATED[i];
    }
  }

  return index;
}


double adj(const string symb)
{
   string s = (symb == NULL) ? Symbol() : symb;
   int d = (int)MarketInfo(s, MODE_DIGITS);
   double r = (d == 3 || d == 5) ? 10 : 1;
   if (StringFind(s, "GOLD") >= 0 || StringFind(s, "XAU") >= 0) r = 10;
   return r;
}

double pip(const string symb)
{
   string s = (symb == NULL) ? Symbol() : symb;
   return MarketInfo(s, MODE_POINT)*adj(symb);
}

void checkTrend(int off)
{
   static datetime last = 0;
   if (last == Time[off])
      return;
   last = Time[off];

   if (off > ArraySize(V)-inIntervals*2-1)
      return;

   int count = 0;
   int ii[2];
   ArrayFill(ii, 0, 0, 0);

   for (int i = off; i < ArraySize(V)-3; ++i)
   {
      if (V[i]*V[i+1] < 0 && V[i+1]*V[i+2] > 0)
         ii[count++] = i;
      if (count == 2)
         break;
   }

   if (count != 2)
      return;

   int begin1 = ii[0]+1;
   int end1 = ii[1];

   int ih1 = iHighestCalculatedIndex(begin1, end1-begin1+1);
   int il1 = iLowestCalculatedIndex(begin1, end1-begin1+1);

   double h1 = HIGH_CALCULATED[ih1];
   double l1 = LOW_CALCULATED[il1];

   int sig = -1;
   double vmax = 0;
   for (int i = begin1; i <= end1; ++i)
   {
      if (MathAbs(V[i]) > MathAbs(vmax)) vmax = V[i];
      if (SIG[i] != EMPTY_VALUE)
         sig = i;
   }

   if (inRects)
   {
      if (!inSig)
      {
         color c = (sig < 0) ? inRectColor : (SIG[sig] > 0 ? inRectBuy : inRectSell);
         drawRect(begin1, end1, l1, h1, c);
      }
   }

   if (V[off] > 0)
   {
      if (Close[off] > h1) { TUP[off] = 0; TDN[off] = EMPTY_VALUE; }
      else if (TDN[off+1] == EMPTY_VALUE || (DN[off+1] != EMPTY_VALUE && TUP[off+2] != EMPTY_VALUE))
      { TUP[off] = 0; TDN[off] = EMPTY_VALUE; }
      else TDN[off] = 0;
   }
   if (V[off] < 0)
   {
      if (Close[off] < l1) { TDN[off] = 0; TUP[off] = EMPTY_VALUE; }
      else if (TUP[off+1] == EMPTY_VALUE || (UP[off+1] != EMPTY_VALUE && TDN[off+2] != EMPTY_VALUE))
      { TDN[off] = 0; TUP[off] = EMPTY_VALUE; }
      else
      { TUP[off] = 0; TDN[off] = EMPTY_VALUE; }
   }
}


void checkForSignal(int off)
{
   static datetime last = 0;
   if (last == Time[off])
      return;
   last = Time[off];

   if (off > ArraySize(V)-inIntervals*2-1)
      return;

   bool second = (V[off+1]*V[off+2] > 0 && V[off+2]*V[off+3] < 0
               && MathAbs(V[off+1]) > MathAbs(V[off+2]));
   bool first = (V[off+1]*V[off+2] < 0);
   bool yes = first || second;
   int intervals = (second && signal == 0) ? inIntervals-1 : inIntervals;
   if (!yes)
      return;

   double max = -INT_MAX;
   double min = INT_MAX;
   double pmax = -INT_MAX;
   double pmin = INT_MAX;
   double v = MIDDLE[off+1];
   int count = 0, end = 0;
   int imax = 0, imin = 0;
   int ii[];
   ArrayResize(ii, intervals+1);

   for (int i = off+1; i < ArraySize(V)-intervals*2-1; ++i)
   {
      if (count == intervals)
      {
         if (V[i]*V[i+1] < 0 && V[i+1]*v < 0)
         {
            ii[count] = i;
            ++count;
         }
      }
      else if (V[i]*V[i+1] < 0 && V[i+1]*V[i+2] > 0 && V[i]*v < 0)
      {
         ii[count] = i;
         ++count;
         //INTERVAL[i+1] = 0;
      }

      if (i != off+1)
      {
         if (MIDDLE[i] > max) { max = MIDDLE[i]; imax = i; }
         if (MIDDLE[i] < min) { min = MIDDLE[i]; imin = i; }
         if (HIGH_CALCULATED[i] > pmax) { pmax = HIGH_CALCULATED[i]; }
         if (LOW_CALCULATED[i] < pmin) { pmin = LOW_CALCULATED[i]; }
      }

      end = i;
      if ((yes = (count == intervals+1)) == true)
         break;
   }

   if (!yes)
      return;

   if (inSplashFilter)
   {
      if (first)
         yes = V[off+2]*V[off+3] > 0;
      if (second)
         yes = V[off+3]*V[off+4] > 0;
   }

   if (second && SIG[off+2] != EMPTY_VALUE)
   {
      if ((SIG[off+2] > 0 && HIGH_CALCULATED[off+1] > HIGH_CALCULATED[off+2])
         || (SIG[off+2] < 0 && LOW_CALCULATED[off+1] < LOW_CALCULATED[off+2]))
      {
         CANCEL[off+2] = SIG[off+2];
         SIG[off+2] = EMPTY_VALUE;
         SIG[off+1] = signal = V[off+1]*1.3;

         if (signal > 0 && Close[off+1] > pmax)
            STRONGSIG[off+1] = SIG[off+1];
         if (signal < 0 && Close[off+1] < pmin)
            STRONGSIG[off+1] = SIG[off+1];

         if (STRONGSIG[off+2] != EMPTY_VALUE)
         {
            STRONGSIG[off+2] = EMPTY_VALUE;
            STRONGSIG[off+1] = SIG[off+1];
         }

         //ObjectSetInteger(0, ID + TimeToStr(Time[off+2], TTT) + " TRENDV", OBJPROP_TIME, Time[off+1]);
      }
   }
   else
   {
      if (v > 0 && v > max && yes)
      {
         SIG[off+1] = signal = V[off+1]*1.3;
         if (Close[off+1] > pmax)
            STRONGSIG[off+1] = SIG[off+1];
      }
      if (v < 0 && v < min && yes)
      {
         SIG[off+1] = signal = V[off+1]*1.3;
         if (Close[off+1] < pmin)
            STRONGSIG[off+1] = SIG[off+1];
      }
   }

   if (SIG[off+1] != EMPTY_VALUE)
   {
      if (signallast != 0)
      {
         string name = ID + TimeToStr(Time[off+2], TTT) + " TREND";
         int shift = iBarShift(NULL, NULL, signallast);
         if (ObjectFind(0, name) >= 0 && SIG[off+2] == EMPTY_VALUE)
         {
            //ObjectSetInteger(0, name, OBJPROP_TIME2, Time[off+1]);
            //ObjectSetDouble(0, name, OBJPROP_PRICE2, Close[off+1]);
         }

         /*else if (inDrawTrend)
         {
            name = ID + TimeToStr(Time[off+1], TTT) + " TREND";
            ObjectCreate(0, name, OBJ_TREND, 0, signallast, Close[shift], Time[off+1], Close[off+1]);
            ObjectSetInteger(0, name, OBJPROP_RAY, false);
            ObjectSetInteger(0, name, OBJPROP_STYLE, inMinorStyleT);
            ObjectSetInteger(0, name, OBJPROP_WIDTH, inMinorWidthT);
            ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
            ObjectSetInteger(0, name, OBJPROP_COLOR, (SIG[shift] > 0) ? inMinorBuyT : inMinorSellT);
         }*/

         name = ID + TimeToStr(Time[off+2], TTT) + " STRONG";
         if (ObjectFind(0, name) >= 0 && SIG[off+2] == EMPTY_VALUE)
         {
            ObjectSetInteger(0, name, OBJPROP_TIME2, Time[off+1]);
            ObjectSetDouble(0, name, OBJPROP_PRICE2, Close[off+1]);
         }

         if (ObjectFind(0, name+"V") >= 0 && SIG[off+2] == EMPTY_VALUE)
            ObjectSetInteger(0, name + "V", OBJPROP_TIME, Time[off+1]);

         name = ID + TimeToStr(Time[off+1], TTT) + " STRONG";
         if (ObjectFind(0, name) >= 0 && SIG[off+2] == EMPTY_VALUE && CANCEL[off+2] != EMPTY_VALUE)
         {
            ObjectDelete(name);
         }

         if (STRONGSIG[off+1] != EMPTY_VALUE && (inDrawStrong))
         {
            ObjectCreate(0, name+"V", OBJ_VLINE, 0, Time[off+1], 0);
            ObjectSetInteger(0, name+"V", OBJPROP_STYLE, inMainStyleV);
            ObjectSetInteger(0, name+"V", OBJPROP_WIDTH, (inMainStyleV != STYLE_SOLID) ? 1 : inMainWidthV);
            ObjectSetInteger(0, name+"V", OBJPROP_HIDDEN, true);
            ObjectSetInteger(0, name+"V", OBJPROP_COLOR, (STRONGSIG[off+1] > 0) ? inMainBuyV : inMainSellV);

            if (inShowLines)
            {
               shift = iBarShift(NULL, NULL, stronglast);
               if (shift != off+2
               || (shift == off+2 && STRONGSIG[shift]*STRONGSIG[off+1] < 0
                  && STRONGSIG[shift] != EMPTY_VALUE && STRONGSIG[shift+1] != EMPTY_VALUE))
                  ObjectCreate(0, name, OBJ_TREND, 0, stronglast, Close[shift], Time[off+1], Close[off+1]);
               ObjectSetInteger(0, name, OBJPROP_RAY, false);
               ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
               ObjectSetInteger(0, name, OBJPROP_STYLE, inMainStyleT);
               ObjectSetInteger(0, name, OBJPROP_WIDTH, (inMainStyleT != STYLE_SOLID) ? 1 : inMainWidthT);
               ObjectSetInteger(0, name, OBJPROP_COLOR, (STRONGSIG[shift] > 0) ? inMainBuyT : inMainSellT);
            }

            stronglast = Time[off+1];
         }

      }

      signallast = Time[off+1];
   }

   if (signal > 0 && V[off+1]*V[off+2] < 0 && V[off+1] < 0 && SIG[off+1] == EMPTY_VALUE)
      BUY[off+1] = V[off+1]*1.3;
   if (signal < 0 && V[off+1]*V[off+2] < 0 && V[off+1] > 0 && SIG[off+1] == EMPTY_VALUE)
      SELL[off+1] = V[off+1]*1.3;

   if (BUY[off+1] != EMPTY_VALUE || SELL[off+1] != EMPTY_VALUE)
      signal = 0;

   if (inDebug)
   {
      //if (SIG[off+1] == EMPTY_VALUE && BUY[off+1] == EMPTY_VALUE && SELL[off+1] == EMPTY_VALUE
      //   && (SIG[off+2] != EMPTY_VALUE || BUY[off+2] != EMPTY_VALUE || SELL[off+2] != EMPTY_VALUE))
      if (TimeHour(Time[off+1])==14 && TimeMinute(Time[off+1]) == 50)
      //if (SIG[off+1] != EMPTY_VALUE)
      {
         ObjectCreate(0, ID + TimeToStr(Time[off+1], TTT), OBJ_TREND, 1, Time[off+1], v, Time[end], v);
         ObjectSetInteger(0, ID + TimeToStr(Time[off+1], TTT), OBJPROP_RAY, false);
         ObjectSetInteger(0, ID + TimeToStr(Time[off+1], TTT), OBJPROP_STYLE, STYLE_DOT);

         double lvl = (v > 0) ? max : min;
         datetime st = (v > 0) ? Time[imax+1] : Time[imin+1];
         datetime fn = (v > 0) ? Time[imax] : Time[imin];
         ObjectCreate(0, ID + TimeToStr(st, TTT), OBJ_TREND, 1, st, lvl, fn, lvl);
         ObjectSetInteger(0, ID + TimeToStr(st, TTT), OBJPROP_RAY, false);
         ObjectSetInteger(0, ID + TimeToStr(st, TTT), OBJPROP_COLOR, clrMagenta);
         ObjectSetInteger(0, ID + TimeToStr(st, TTT), OBJPROP_WIDTH, 3);

         //for (int i = 0; i < ArraySize(ii); ++i)
         //   INTERVALS[ii[i]] = 0;
      }
   }
}


void drawRect(int begin, int end, double bottom, double top, color c)
{
   datetime t = (begin < 0) ? Time[0] - begin * PeriodSeconds() : Time[begin];
   string name = ID+TimeToStr(t, TTT)+" R";
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, Time[end], bottom, t, top);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_BACK, inRectBack);
   ObjectSetInteger(0, name, OBJPROP_STYLE, inRectLine);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, inRectWidth);
}


bool TextCreate(const int               sub_window=0,
                const string            name="Text",
                datetime                time=0,
                double                  price=0,
                const string            text="Text",
                const string            font="Arial",
                const int               font_size=10,
                const color             clr=clrRed,
                const double            angle=0.0,
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER,
                const bool              back=false,
                const bool              selection=false,
                const bool              hidden=true,
                const long              z_order=0,
                const long              chart_ID=0)
{
	ResetLastError();
	if(ObjectFind(chart_ID, name)<0)
	if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
	{
		Print(__FUNCTION__, ": ", GetLastError());
		return(false);
	}

	ObjectSetInteger(chart_ID,name,OBJPROP_TIME,time);
	ObjectSetDouble(chart_ID,name,OBJPROP_PRICE,price);
	ObjectSetInteger(chart_ID,name,OBJPROP_TIME,time);
	ObjectSetDouble(chart_ID,name,OBJPROP_PRICE,price);
	ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
	ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
	ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
	ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
	ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
	ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
	ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
	ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
	ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
	ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
	ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
	return(true);
}


bool UpVolume(int candleIndex)
{
   return (candleIndex < Bars) && (UP[candleIndex] != EMPTY_VALUE) && (DN[candleIndex] == EMPTY_VALUE);
}


bool DownVolume(int candleIndex)
{
   return (candleIndex < Bars) && (UP[candleIndex] == EMPTY_VALUE) && (DN[candleIndex] != EMPTY_VALUE);
}


Direction VolumeDirection(int candleIndex)
{
   if (UpVolume(candleIndex))
      return UPPER;

   else if (DownVolume(candleIndex))
      return LOWER;

   else
      return NONE;
}


bool IsProgressiveCandle(int candleIndex)
{
   int sequenceStart = VolumeSequenceStartIndex(candleIndex);

   if (candleIndex == sequenceStart)
      return true;

   if (UpVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] > HIGH_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
         }
      }

      return (candleIndex == lastProgressiveIndex);
   }

   else if (DownVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] < LOW_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
         }
      }

      return (candleIndex == lastProgressiveIndex);
   }

   return false;
}


bool IsCalculatedAsProgressive(int candleIndex)
{
   return ((UP[candleIndex] != EMPTY_VALUE) || (DN[candleIndex] != EMPTY_VALUE)) && (NONPROG_DISPLAY[candleIndex] == EMPTY_VALUE);
}


bool IsDojiCandle(int candleIndex)
{
  return (Close[candleIndex] == Open[candleIndex]);
}


Direction VolumeSegmentDirection(int candleIndex)
{
   Direction segmentDirection = VolumeDirection(candleIndex);
   int candleCounter = 1;

   while (candleCounter < inSegmentMinProg)
   {
      candleIndex++;
      Direction currentDirection = VolumeDirection(candleIndex);

      if (currentDirection == segmentDirection)
      {
         candleCounter++;
      }
      else
      {
         segmentDirection = currentDirection;
         candleCounter = 1;
      }
   }

   return segmentDirection;
}


int VolumeSequenceStartIndex(int candleIndex)
{
   Direction segmentDirection = VolumeDirection(candleIndex);

   if (segmentDirection != NONE)
   {
      while (VolumeDirection(candleIndex + 1) == segmentDirection)
      {
        candleIndex++;
      }
   }

   return candleIndex;
}


int LastProgressiveIndex(int candleIndex)
{
   int sequenceStart = VolumeSequenceStartIndex(candleIndex + 1);

   if (UpVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] > HIGH_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
         }
      }

      return lastProgressiveIndex;
   }

   else if (DownVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] < LOW_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
         }
      }

      return lastProgressiveIndex;
   }

   return candleIndex;
}


int countProgressiveCandles(int candleIndex)
{
   int sequenceStart = VolumeSequenceStartIndex(candleIndex + 1);
   int progressiveCounter = 1;

   if (UpVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] > HIGH_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
            progressiveCounter++;
         }
      }

      return progressiveCounter;
   }

   else if (DownVolume(sequenceStart))
   {
      int lastProgressiveIndex = sequenceStart;

      for (int i = sequenceStart - 1; i >= candleIndex; --i)
      {
         if (Close[i] < LOW_CALCULATED[lastProgressiveIndex])
         {
            lastProgressiveIndex = i;
            progressiveCounter++;
         }
      }

      return progressiveCounter;
   }

   return 0;
}


void drawFloorReversal(string trendType, int candleIndex, double price, color levelColor)
{
  datetime marker_time = Time[candleIndex];
  double marker_price = price;
  string marker_name = ID + trendType + " FLOOR " + IntegerToString(marker_time) + " " + DoubleToString(marker_price);

  ObjectCreate(marker_name, OBJ_ARROW, 0, marker_time, marker_price);
  ObjectSet(marker_name, OBJPROP_ARROWCODE, 4);
  ObjectSet(marker_name, OBJPROP_COLOR, levelColor);
}


void drawCeilReversal(string trendType, int candleIndex, double price, color levelColor)
{
   datetime marker_time = Time[candleIndex];
   double marker_price = price;
   string marker_name = ID + "CEIL " + IntegerToString(marker_time) + " " + DoubleToString(marker_price);

   ObjectCreate(marker_name, OBJ_ARROW, 0, marker_time, marker_price);
   ObjectSet(marker_name, OBJPROP_ARROWCODE, 4);
   ObjectSet(marker_name, OBJPROP_COLOR, levelColor);
}


Direction normalTrendDirection(int candleIndex)
{
   if (candleIndex < Bars)
   {
      if ((TUP_NORMAL[candleIndex] != EMPTY_VALUE) && (TDN_NORMAL[candleIndex] == EMPTY_VALUE))
         return UPPER;

      if ((TDN_NORMAL[candleIndex] != EMPTY_VALUE) && (TUP_NORMAL[candleIndex] == EMPTY_VALUE))
         return LOWER;
   }

   return NONE;
}


Direction dynamicTrendDirection(int candleIndex)
{
   if (candleIndex < Bars)
   {
      if ((TUP_DYNAMIC[candleIndex] != EMPTY_VALUE) && (TDN_DYNAMIC[candleIndex] == EMPTY_VALUE))
         return UPPER;

      if ((TDN_DYNAMIC[candleIndex] != EMPTY_VALUE) && (TUP_DYNAMIC[candleIndex] == EMPTY_VALUE))
         return LOWER;
   }

   return NONE;
}


Direction superDynamicTrendDirection(int candleIndex)
{
   if (candleIndex < Bars)
   {
      if ((TUP_SUPER_DYNAMIC[candleIndex] != EMPTY_VALUE) && (TDN_SUPER_DYNAMIC[candleIndex] == EMPTY_VALUE))
         return UPPER;

      if ((TDN_SUPER_DYNAMIC[candleIndex] != EMPTY_VALUE) && (TUP_SUPER_DYNAMIC[candleIndex] == EMPTY_VALUE))
         return LOWER;
   }

   return NONE;
}


void handleNormalTrend(int currentCandleIndex)
{
   // current trend (based on previous candle's trend; direction for current candle is to be determined)
   Direction currentTrendDirection = normalTrendDirection(currentCandleIndex + 1);

   // continue trend by default
   if (currentTrendDirection == UPPER)
   {
      TUP_NORMAL[currentCandleIndex] = inNormalTrendDisplayLevel;
      TDN_NORMAL[currentCandleIndex] = EMPTY_VALUE;
   }
   else if (currentTrendDirection == LOWER)
   {
      TDN_NORMAL[currentCandleIndex] = inNormalTrendDisplayLevel;
      TUP_NORMAL[currentCandleIndex] = EMPTY_VALUE;
   }
   else
   {
      TDN_NORMAL[currentCandleIndex] = EMPTY_VALUE;
      TUP_NORMAL[currentCandleIndex] = EMPTY_VALUE;
   }

   T_NORMAL_U[currentCandleIndex] = T_NORMAL_U[currentCandleIndex + 1];


   // index of "reference" candle (to be determined, -1 means "not found")
   int referenceIndex = -1;

   // reference volume - to be calculated
   double referenceVolume = 0;

   // index of last candle from previous segment (not necessary confirmed; just before current segment)
   int previousSegmentLast = PreviousSegmentLastIndex(currentCandleIndex);

   // previous segment already exists
   if (previousSegmentLast < Bars)
   {
      if (currentTrendDirection == UPPER)
      {
         int lastNthFromUpper = lastNthProgressiveFromUpperSegmentIndex(currentCandleIndex + 1, NORMAL_TREND_BAR_N);
         int lastFromLower = lastProgressiveFromConfirmedLowerSegmentIndex(previousSegmentLast);

         if ((lastNthFromUpper != -1) && (lastFromLower != -1))
         {
            if (lastNthFromUpper < lastFromLower)
            {
               referenceIndex = lastNthFromUpper;
               referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
               //Print("reference index: " + TimeToStr(Time[referenceIndex]) + ", total prog N: " + referenceVolume);
            }

            else
            {
               referenceIndex = lastFromLower;
               referenceVolume = -DN[lastFromLower];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " UP " + TimeToStr(Time[referenceIndex]) + " (nth from upper: " + TimeToStr(Time[lastNthOrFirstFromUpper]) + ", last from lower: " + TimeToStr(Time[lastFromLower]) + ")");
         }
      }

      else if (currentTrendDirection == LOWER)
      {
         int lastNthFromLower = lastNthProgressiveFromLowerSegmentIndex(currentCandleIndex + 1, NORMAL_TREND_BAR_N);
         int lastFromUpper = lastProgressiveFromConfirmedUpperSegmentIndex(previousSegmentLast);

         if ((lastNthFromLower != -1) && (lastFromUpper != -1))
         {
            if (lastNthFromLower < lastFromUpper)
            {
               referenceIndex = lastNthFromLower;
               referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
               // Print("reference index: " + TimeToStr(Time[referenceIndex]) + ", total prog N: " + referenceVolume);
            }

            else
            {
               referenceIndex = lastFromUpper;
               referenceVolume = UP[lastFromUpper];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " DN " + TimeToStr(Time[referenceIndex]) + " (nth from lower: " + TimeToStr(Time[lastNthOrFirstFromLower]) + ", last from upper: " + TimeToStr(Time[lastFromUpper]) + ")");
         }
      }

      else
      {
         int lastNthFromUpper = lastNthProgressiveFromUpperSegmentIndex(previousSegmentLast, NORMAL_TREND_BAR_N);
         int lastNthFromLower = lastNthProgressiveFromLowerSegmentIndex(previousSegmentLast, NORMAL_TREND_BAR_N);

         if ((lastNthFromUpper != -1) && (lastNthFromLower != -1))
         {
            referenceIndex = MathMin(lastNthFromUpper, lastNthFromLower);
            referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
         }
      }

      if (referenceIndex != -1)
      {
         double referenceHigh = HIGH_CALCULATED[referenceIndex];
         double referenceLow = LOW_CALCULATED[referenceIndex];
         double referenceFloor = referenceLow - inReversalRangeMultiplierNormal * (referenceHigh - referenceLow);
         double referenceCeil = referenceHigh + inReversalRangeMultiplierNormal * (referenceHigh - referenceLow);

         double currentSegmentTotalVolume = totalProgressiveVolumeFromSegment(currentCandleIndex);

         if (inReversalLevelsNormal)
         {
            if (currentTrendDirection != LOWER)
            {
               drawFloorReversal("N", currentCandleIndex, referenceFloor, clrRed);
            }

            if (currentTrendDirection != UPPER)
            {
               drawCeilReversal("N", currentCandleIndex, referenceCeil, clrGreen);
            }
         }

         if ((Close[currentCandleIndex] < referenceFloor) && (currentTrendDirection != LOWER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TDN_NORMAL[currentCandleIndex] = inNormalTrendDisplayLevel;
               TUP_NORMAL[currentCandleIndex] = EMPTY_VALUE;
               T_NORMAL_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_NORMAL_U[currentCandleIndex] = inNormalTrendDisplayLevel;
            }
         }

         else if ((Close[currentCandleIndex] > referenceCeil) && (currentTrendDirection != UPPER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TUP_NORMAL[currentCandleIndex] = inNormalTrendDisplayLevel;
               TDN_NORMAL[currentCandleIndex] = EMPTY_VALUE;
               T_NORMAL_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_NORMAL_U[currentCandleIndex] = inNormalTrendDisplayLevel;
            }
         }

         else if (T_NORMAL_U[currentCandleIndex] != EMPTY_VALUE)
         {
            if (TUP_NORMAL[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedUpperSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] > HIGH_CALCULATED[reactivationReference])
                  T_NORMAL_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else if (TDN_NORMAL[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedLowerSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] < LOW_CALCULATED[reactivationReference])
                  T_NORMAL_U[currentCandleIndex] = EMPTY_VALUE;
            }
         }
      }
   }
}


void handleDynamicTrend(int currentCandleIndex)
{
   // current trend (based on previous candle's trend; direction for current candle is to be determined)
   Direction currentTrendDirection = dynamicTrendDirection(currentCandleIndex + 1);

   // continue trend by default
   if (currentTrendDirection == UPPER)
   {
      TUP_DYNAMIC[currentCandleIndex] = inDynamicTrendDisplayLevel;
      TDN_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }
   else if (currentTrendDirection == LOWER)
   {
      TDN_DYNAMIC[currentCandleIndex] = inDynamicTrendDisplayLevel;
      TUP_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }
   else
   {
      TDN_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
      TUP_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }

   T_DYNAMIC_U[currentCandleIndex] = T_DYNAMIC_U[currentCandleIndex + 1];


   // index of "reference" candle (to be determined, -1 means "not found")
   int referenceIndex = -1;

   // reference volume - to be calculated
   double referenceVolume = 0;

   // index of last candle from previous segment (not necessary confirmed; just before current segment)
   int previousSegmentLast = PreviousSegmentLastIndex(currentCandleIndex);

   // previous segment already exists
   if (previousSegmentLast < Bars)
   {
      if (currentTrendDirection == UPPER)
      {
         int lastNthOrFirstFromUpper = lastNthOrFirstProgressiveFromUpperSegmentIndex(currentCandleIndex + 1, NORMAL_TREND_BAR_N);
         int lastFromLower = lastProgressiveFromConfirmedLowerSegmentIndex(previousSegmentLast);

         if ((lastNthOrFirstFromUpper != -1) && (lastFromLower != -1))
         {
            if (lastNthOrFirstFromUpper < lastFromLower)
            {
               referenceIndex = lastNthOrFirstFromUpper;
               referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
            }

            else
            {
               referenceIndex = lastFromLower;
               referenceVolume = -DN[lastFromLower];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " UP " + TimeToStr(Time[referenceIndex]) + " (nth from upper: " + TimeToStr(Time[lastNthOrFirstFromUpper]) + ", last from lower: " + TimeToStr(Time[lastFromLower]) + ")");
         }
      }

      else if (currentTrendDirection == LOWER)
      {
         int lastNthOrFirstFromLower = lastNthOrFirstProgressiveFromLowerSegmentIndex(currentCandleIndex + 1, NORMAL_TREND_BAR_N);
         int lastFromUpper = lastProgressiveFromConfirmedUpperSegmentIndex(previousSegmentLast);

         if ((lastNthOrFirstFromLower != -1) && (lastFromUpper != -1))
         {
            if (lastNthOrFirstFromLower < lastFromUpper)
            {
               referenceIndex = lastNthOrFirstFromLower;
               referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
            }

            else
            {
               referenceIndex = lastFromUpper;
               referenceVolume = UP[lastFromUpper];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " DN " + TimeToStr(Time[referenceIndex]) + " (nth from lower: " + TimeToStr(Time[lastNthOrFirstFromLower]) + ", last from upper: " + TimeToStr(Time[lastFromUpper]) + ")");
         }
      }

      else
      {
         int lastNthOrFirstFromUpper = lastNthOrFirstProgressiveFromUpperSegmentIndex(previousSegmentLast, NORMAL_TREND_BAR_N);
         int lastNthOrFirstFromLower = lastNthOrFirstProgressiveFromLowerSegmentIndex(previousSegmentLast, NORMAL_TREND_BAR_N);

         if ((lastNthOrFirstFromUpper != -1) && (lastNthOrFirstFromLower != -1))
         {
            referenceIndex = MathMin(lastNthOrFirstFromUpper, lastNthOrFirstFromLower);
            referenceVolume = totalProgressiveVolumeNextN(referenceIndex, NORMAL_TREND_BAR_N);
         }
      }

      if (referenceIndex != -1)
      {
         double referenceHigh = HIGH_CALCULATED[referenceIndex];
         double referenceLow = LOW_CALCULATED[referenceIndex];
         double referenceFloor = referenceLow - inReversalRangeMultiplierDynamic * (referenceHigh - referenceLow);
         double referenceCeil = referenceHigh + inReversalRangeMultiplierDynamic * (referenceHigh - referenceLow);

         double currentSegmentTotalVolume = totalProgressiveVolumeFromSegment(currentCandleIndex);

         if (inReversalLevelsDynamic)
         {
            if (currentTrendDirection != LOWER)
            {
               drawFloorReversal("D", currentCandleIndex, referenceFloor, clrOrange);
            }

            if (currentTrendDirection != UPPER)
            {
               drawCeilReversal("D", currentCandleIndex, referenceCeil, clrLime);
            }
         }

         if ((Close[currentCandleIndex] < referenceFloor) && (currentTrendDirection != LOWER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TDN_DYNAMIC[currentCandleIndex] = inDynamicTrendDisplayLevel;
               TUP_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
               T_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_DYNAMIC_U[currentCandleIndex] = inDynamicTrendDisplayLevel;
            }
         }

         else if ((Close[currentCandleIndex] > referenceCeil) && (currentTrendDirection != UPPER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TUP_DYNAMIC[currentCandleIndex] = inDynamicTrendDisplayLevel;
               TDN_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
               T_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_DYNAMIC_U[currentCandleIndex] = inDynamicTrendDisplayLevel;
            }
         }

         else if (T_DYNAMIC_U[currentCandleIndex] != EMPTY_VALUE)
         {
            if (TUP_DYNAMIC[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedUpperSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] > HIGH_CALCULATED[reactivationReference])
                  T_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else if (TDN_DYNAMIC[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedLowerSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] < LOW_CALCULATED[reactivationReference])
                  T_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
         }
      }
   }
}


void handleSuperDynamicTrend(int currentCandleIndex)
{
   // current trend (based on previous candle's trend; direction for current candle is to be determined)
   Direction currentTrendDirection = superDynamicTrendDirection(currentCandleIndex + 1);

   // continue trend by default
   if (currentTrendDirection == UPPER)
   {
      TUP_SUPER_DYNAMIC[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
      TDN_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }
   else if (currentTrendDirection == LOWER)
   {
      TDN_SUPER_DYNAMIC[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
      TUP_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }
   else
   {
      TDN_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
      TUP_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
   }

   T_SUPER_DYNAMIC_U[currentCandleIndex] = T_SUPER_DYNAMIC_U[currentCandleIndex + 1];


   // index of "reference" candle (to be determined, -1 means "not found")
   int referenceIndex = -1;

   // reference volume - to be calculated
   double referenceVolume = 0;

   // index of last candle from previous segment (not necessary confirmed; just before current segment)
   int previousSegmentLast = PreviousSegmentLastIndex(currentCandleIndex);

   // previous segment already exists
   if (previousSegmentLast < Bars)
   {
      if (currentTrendDirection == UPPER)
      {
         int lastNthFromUpper = lastNthProgressiveFromUpperSegmentIndex(currentCandleIndex + 1, SUPER_DYNAMIC_TREND_BAR_N);
         int lastFromLower = lastProgressiveFromConfirmedLowerSegmentIndex(previousSegmentLast);

         if ((lastNthFromUpper != -1) && (lastFromLower != -1))
         {
            if (lastNthFromUpper < lastFromLower)
            {
               referenceIndex = lastNthFromUpper;
               referenceVolume = UP[referenceIndex];
            }

            else
            {
               referenceIndex = lastFromLower;
               referenceVolume = -DN[lastFromLower];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " UP " + TimeToStr(Time[referenceIndex]) + " (nth from upper: " + TimeToStr(Time[lastNthOrFirstFromUpper]) + ", last from lower: " + TimeToStr(Time[lastFromLower]) + ")");
         }
      }

      else if (currentTrendDirection == LOWER)
      {
         int lastNthFromLower = lastNthProgressiveFromLowerSegmentIndex(currentCandleIndex + 1, SUPER_DYNAMIC_TREND_BAR_N);
         int lastFromUpper = lastProgressiveFromConfirmedUpperSegmentIndex(previousSegmentLast);

         if ((lastNthFromLower != -1) && (lastFromUpper != -1))
         {
            if (lastNthFromLower < lastFromUpper)
            {
               referenceIndex = lastNthFromLower;
               referenceVolume = -DN[referenceIndex];
            }

            else
            {
               referenceIndex = lastFromUpper;
               referenceVolume = UP[lastFromUpper];
            }

            // Print(TimeToStr(Time[currentCandleIndex]) + " DN " + TimeToStr(Time[referenceIndex]) + " (nth from lower: " + TimeToStr(Time[lastNthOrFirstFromLower]) + ", last from upper: " + TimeToStr(Time[lastFromUpper]) + ")");
         }
      }

      else
      {
         int lastNthFromUpper = lastNthProgressiveFromUpperSegmentIndex(previousSegmentLast, SUPER_DYNAMIC_TREND_BAR_N);
         int lastNthFromLower = lastNthProgressiveFromLowerSegmentIndex(previousSegmentLast, SUPER_DYNAMIC_TREND_BAR_N);

         if ((lastNthFromUpper != -1) && (lastNthFromLower != -1))
         {
            referenceIndex = MathMin(lastNthFromUpper, lastNthFromLower);
            referenceVolume = UP[referenceIndex] + (-DN[referenceIndex]);
         }
      }

      if (referenceIndex != -1)
      {
         double referenceHigh = HIGH_CALCULATED[referenceIndex];
         double referenceLow = LOW_CALCULATED[referenceIndex];
         double referenceFloor = referenceLow - inReversalRangeMultiplierSuperDynamic * (referenceHigh - referenceLow);
         double referenceCeil = referenceHigh + inReversalRangeMultiplierSuperDynamic * (referenceHigh - referenceLow);

         double currentSegmentTotalVolume = totalProgressiveVolumeFromSegment(currentCandleIndex);

         if (inReversalLevelsSuperDynamic)
         {
            if (currentTrendDirection != LOWER)
            {
               drawFloorReversal("S", currentCandleIndex, referenceFloor, clrYellow);
            }

            if (currentTrendDirection != UPPER)
            {
               drawCeilReversal("S", currentCandleIndex, referenceCeil, clrAqua);
            }
         }

         if ((Close[currentCandleIndex] < referenceFloor) && (currentTrendDirection != LOWER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TDN_SUPER_DYNAMIC[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
               TUP_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
               T_SUPER_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_SUPER_DYNAMIC_U[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
            }
         }

         else if ((Close[currentCandleIndex] > referenceCeil) && (currentTrendDirection != UPPER))
         {
            if ((currentSegmentTotalVolume > referenceVolume) || (!inVolumeBreak))
            {
               TUP_SUPER_DYNAMIC[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
               TDN_SUPER_DYNAMIC[currentCandleIndex] = EMPTY_VALUE;
               T_SUPER_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else
            {
               T_SUPER_DYNAMIC_U[currentCandleIndex] = inSuperDynamicTrendDisplayLevel;
            }
         }

         else if (T_SUPER_DYNAMIC_U[currentCandleIndex] != EMPTY_VALUE)
         {
            if (TUP_SUPER_DYNAMIC[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedUpperSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] > HIGH_CALCULATED[reactivationReference])
                  T_SUPER_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
            else if (TDN_SUPER_DYNAMIC[currentCandleIndex] != EMPTY_VALUE)
            {
               int reactivationReference = lastProgressiveFromConfirmedLowerSegmentIndex(currentCandleIndex + 1);

               if (Close[currentCandleIndex] < LOW_CALCULATED[reactivationReference])
                  T_SUPER_DYNAMIC_U[currentCandleIndex] = EMPTY_VALUE;
            }
         }
      }
   }
}


int lastNthProgressiveFromUpperSegmentIndex(int candleIndex, int n)
{
   int counter = 0;

   while (candleIndex < Bars)
   {
      if (UP[candleIndex] != EMPTY_VALUE)
      {
         if (IsCalculatedAsProgressive(candleIndex))
         {
            counter++;

            if (counter == n)
               return candleIndex;
         }
      }
      else
         counter = 0;

      candleIndex++;
   }

   return -1;
}


int lastNthProgressiveFromLowerSegmentIndex(int candleIndex, int n)
{
   int counter = 0;

   while (candleIndex < Bars)
   {
      if (DN[candleIndex] != EMPTY_VALUE)
      {
         if (IsCalculatedAsProgressive(candleIndex))
         {
            counter++;

            if (counter == n)
               return candleIndex;
         }
      }
      else
         counter = 0;

      candleIndex++;
   }

   return -1;
}


int lastNthOrFirstProgressiveFromUpperSegmentIndex(int candleIndex, int n)
{
   int counter = 0;
   int lastFound = -1;

   while (candleIndex < Bars)
   {
      if (UP[candleIndex] != EMPTY_VALUE)
      {
         if (IsCalculatedAsProgressive(candleIndex))
         {
            counter++;
            lastFound = candleIndex;

            if (counter == n)
               return lastFound;
         }
      }
      else
      {
         if (counter != 0)
            return lastFound;
      }

      candleIndex++;
   }

   return -1;
}


int lastNthOrFirstProgressiveFromLowerSegmentIndex(int candleIndex, int n)
{
   int counter = 0;
   int lastFound = -1;

   while (candleIndex < Bars)
   {
      if (DN[candleIndex] != EMPTY_VALUE)
      {
         if (IsCalculatedAsProgressive(candleIndex))
         {
            counter++;
            lastFound = candleIndex;

            if (counter == n)
               return lastFound;
         }
      }
      else
      {
         if (counter != 0)
            return lastFound;
      }

      candleIndex++;
   }

   return -1;
}


int lastProgressiveFromConfirmedSegmentIndex(int candleIndex)
{
   Direction currentSegmentDirection = NONE;
   int lastProgressiveIndex = -1;
   int progressiveCounter = 0;

   while ((candleIndex < Bars) && (progressiveCounter <= inSegmentMinProg))
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         Direction candleDirection = VolumeDirection(candleIndex);

         if (candleDirection != currentSegmentDirection)
         {
            currentSegmentDirection = candleDirection;
            lastProgressiveIndex = candleIndex;
            progressiveCounter = 1;
         }

         else
         {
            progressiveCounter++;
         }
      }

      candleIndex++;
   }

   if (progressiveCounter > inSegmentMinProg)
   {
      return lastProgressiveIndex;
   }

   return -1;
}


int lastProgressiveFromConfirmedUpperSegmentIndex(int candleIndex)
{
   Direction currentSegmentDirection = NONE;
   int lastProgressiveIndex = -1;
   int progressiveCounter = 0;

   while ((candleIndex < Bars) && ((progressiveCounter <= inSegmentMinProg) || (currentSegmentDirection != UPPER)))
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         Direction candleDirection = VolumeDirection(candleIndex);

         if (candleDirection != currentSegmentDirection)
         {
            currentSegmentDirection = candleDirection;
            lastProgressiveIndex = candleIndex;
            progressiveCounter = 1;
         }

         else
         {
            progressiveCounter++;
         }
      }

      candleIndex++;
   }

   if ((progressiveCounter > inSegmentMinProg) && (currentSegmentDirection == UPPER))
   {
      return lastProgressiveIndex;
   }

   return -1;
}


int lastProgressiveFromConfirmedLowerSegmentIndex(int candleIndex)
{
   Direction currentSegmentDirection = NONE;
   int lastProgressiveIndex = -1;
   int progressiveCounter = 0;

   while ((candleIndex < Bars) && ((progressiveCounter <= inSegmentMinProg) || (currentSegmentDirection != LOWER)))
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         Direction candleDirection = VolumeDirection(candleIndex);

         if (candleDirection != currentSegmentDirection)
         {
            currentSegmentDirection = candleDirection;
            lastProgressiveIndex = candleIndex;
            progressiveCounter = 1;
         }

         else
         {
            progressiveCounter++;
         }
      }

      candleIndex++;
   }

   if ((progressiveCounter > inSegmentMinProg) && (currentSegmentDirection == LOWER))
   {
      return lastProgressiveIndex;
   }

   return -1;
}


int PreviousSegmentLastIndex(int candleIndex)
{
   Direction currentDirection = VolumeDirection(candleIndex);

   do
   {
      candleIndex++;
   }
   while ((VolumeDirection(candleIndex) == currentDirection) && (candleIndex < Bars));

   return candleIndex;
}


double totalProgressiveVolumeFromSegment(int candleIndex)
{
   Direction currentDirection = VolumeDirection(candleIndex);
   double totalVolume = 0;

   do
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         if (currentDirection == UPPER)
            totalVolume += UP[candleIndex];

         else if (currentDirection == LOWER)
            totalVolume += (-DN[candleIndex]);
      }

      candleIndex++;
   }
   while ((VolumeDirection(candleIndex) == currentDirection) && (candleIndex < Bars));

   return totalVolume;
}


/*
double totalProgressiveVolumeToTheEndOfSegment(int candleIndex)
{
   Direction currentDirection = VolumeDirection(candleIndex);
   double totalVolume = 0;

   do
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         if (currentDirection == UPPER)
            totalVolume += UP[candleIndex];

         else if (currentDirection == LOWER)
            totalVolume += (-DN[candleIndex]);
      }

      candleIndex--;
   }
   while ((candleIndex >= 0) && (VolumeDirection(candleIndex) == currentDirection));

   return totalVolume;
}
*/


double totalProgressiveVolumeNextN(int candleIndex, int progressivesLimit)
{
   Direction currentDirection = VolumeDirection(candleIndex);
   double totalVolume = 0;
   int progressiveCount = 0;

   do
   {
      if (IsCalculatedAsProgressive(candleIndex))
      {
         if (currentDirection == UPPER)
            totalVolume += UP[candleIndex];

         else if (currentDirection == LOWER)
            totalVolume += (-DN[candleIndex]);

         progressiveCount++;
      }

      candleIndex--;
   }
   while ((candleIndex >= 0) && (progressiveCount < progressivesLimit) && (VolumeDirection(candleIndex) == currentDirection));

   return totalVolume;
}


void RepaintPositiveToZero(int candleIndex)
{
   Direction segmentDirection = VolumeSegmentDirection(candleIndex);

   if (segmentDirection == LOWER)
   {
      int segmentCandleCounter = 0;

      while ((segmentCandleCounter < inSegmentMinProg) && (candleIndex < Bars))
      {
         Direction currentDirection = VolumeDirection(candleIndex);

         if (currentDirection == LOWER)
         {
            segmentCandleCounter++;
         }
         else
         {
            // Print("repaint UP to zero: " + TimeToStr(Time[candleIndex]));

            segmentCandleCounter = 0;

            UP_DISPLAY[candleIndex] = EMPTY_VALUE;
            NONPROG_DISPLAY[candleIndex] = EMPTY_VALUE;
            V_DISPLAY[candleIndex] = EMPTY_VALUE;
         }

         candleIndex++;
      }
   }
}


void RepaintNegativeToZero(int candleIndex)
{
   Direction segmentDirection = VolumeSegmentDirection(candleIndex);

   if (segmentDirection == UPPER)
   {
      int segmentCandleCounter = 0;

      while ((segmentCandleCounter < inSegmentMinProg) && (candleIndex < Bars))
      {
         Direction currentDirection = VolumeDirection(candleIndex);

         if (currentDirection == UPPER)
         {
            segmentCandleCounter++;
         }
         else
         {
            // Print("repaint DN to zero: " + TimeToStr(Time[candleIndex]));

            segmentCandleCounter = 0;

            DN_DISPLAY[candleIndex] = EMPTY_VALUE;
            NONPROG_DISPLAY[candleIndex] = EMPTY_VALUE;
            V_DISPLAY[candleIndex] = EMPTY_VALUE;
         }

         candleIndex++;
      }
   }
}


void UpdateUpperSegmentRectangle(int candleIndex)
{
  int sequenceStartIndex = VolumeSequenceStartIndex(candleIndex);
  datetime sequenceStartTime = Time[sequenceStartIndex];

  string name = ID + TimeToStr(sequenceStartTime, TTT) + " SEGMENT RECT";

  int lowestIndex = iLowestCalculatedIndex(candleIndex, sequenceStartIndex - candleIndex + 1);
  int highestIndex = iHighestCalculatedIndex(candleIndex, sequenceStartIndex - candleIndex + 1);
  double bottom = LOW_CALCULATED[lowestIndex];
  double top = HIGH_CALCULATED[highestIndex];

  ObjectDelete(0, name);

  ObjectCreate(0, name, OBJ_RECTANGLE, 0, sequenceStartTime, bottom, Time[candleIndex], top);
  ObjectSetInteger(0, name, OBJPROP_COLOR, inSegmentRectUpper);
  ObjectSetInteger(0, name, OBJPROP_BACK, inSegmentRectBack);
  ObjectSetInteger(0, name, OBJPROP_STYLE, inSegmentRectLine);
  ObjectSetInteger(0, name, OBJPROP_WIDTH, inSegmentRectWidth);
}


void UpdateLowerSegmentRectangle(int candleIndex)
{
  int sequenceStartIndex = VolumeSequenceStartIndex(candleIndex);
  datetime sequenceStartTime = Time[sequenceStartIndex];

  string name = ID + TimeToStr(sequenceStartTime, TTT) + " SEGMENT RECT";

  int lowestIndex = iLowestCalculatedIndex(candleIndex, sequenceStartIndex - candleIndex + 1);
  int highestIndex = iHighestCalculatedIndex(candleIndex, sequenceStartIndex - candleIndex + 1);
  double bottom = LOW_CALCULATED[lowestIndex];
  double top = HIGH_CALCULATED[highestIndex];

  ObjectDelete(0, name);

  ObjectCreate(0, name, OBJ_RECTANGLE, 0, sequenceStartTime, bottom, Time[candleIndex], top);
  ObjectSetInteger(0, name, OBJPROP_COLOR, inSegmentRectLower);
  ObjectSetInteger(0, name, OBJPROP_BACK, inSegmentRectBack);
  ObjectSetInteger(0, name, OBJPROP_STYLE, inSegmentRectLine);
  ObjectSetInteger(0, name, OBJPROP_WIDTH, inSegmentRectWidth);
}


void UpdateExportValues(int candleIndex)
{
   double normalValue = DirectionToDouble(normalTrendDirection(candleIndex));
   double dynamicValue = DirectionToDouble(dynamicTrendDirection(candleIndex));
   double superDynamicValue = DirectionToDouble(superDynamicTrendDirection(candleIndex));

   NORMAL_TREND_EXPORT[candleIndex] = normalValue;
   DYNAMIC_TREND_EXPORT[candleIndex] = dynamicValue;
   SUPER_DYNAMIC_TREND_EXPORT[candleIndex] = superDynamicValue;
}


double DirectionToDouble(Direction direction)
{
   switch (direction)
   {
      case UPPER: return 1.0;
      case LOWER: return -1.0;
      default: return 0.0;
   }
}


Direction DoubleToDirection(double direction)
{
   if (direction == 1.0)
      return UPPER;
      
   if (direction == -1.0)
      return LOWER;
      
   return NONE;
}
