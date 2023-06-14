//+------------------------------------------------------------------+
//|                                      oa_NLV3_Core_12t20_R116.mq5 |
//|                                                               mp |
//|                                                                  |
//--------------------------------------------------------------------
// initiallot  to init
// init  / tp-sl / ne nyisson dupl�n / reverse positin / takar�t�s 
//+------------------------------------------------------------------+
#property copyright "mp"
#property link      ""
#property version   "1.00"


#include <mp\mp_mql4_functions.mqh>

   input int        in_maxpos               =2;  
   input Enum_CurrHandling  in_curr_handling =1;
   //input bool       in_b_compeetingbot      =true;
   input bool       in_b_fivedigitbroker    =true;
   input bool       in_b_run_multistrat     =true;
                     
   string           program_name="";
   input bool       in_strat_1=true;
   input bool       in_strat_2=false;   
   input bool       in_strat_3=false;    
   input bool       in_strat_4=false;    
   input bool       in_strat_5=false;   
   input bool       in_strat_6=false;      
   input bool       in_strat_7=false;  
   input bool       in_strat_8=false;   
   input bool       in_strat_9=false;   
   input bool       in_strat_10=false;      
   input bool       in_strat_11=false;      
   input bool       in_strat_12=false;      
   input bool       in_strat_13=false;      
   input bool       in_strat_14=false;      
   input bool       in_strat_15=false; 
   input bool       in_strat_16=false; 
   input bool       in_strat_17=false; 
   input bool       in_strat_18=false; 
   input bool       in_strat_19=false; 
   input bool       in_strat_20=false;      
   input int        in_test_strategies_to   =0;                  // 0 nem tesztel   -20-t�l 20-ig az adott sz�m� strat�gi�t teszteli vagy kihagyja

 
   input int        in_MAGIC_Rf             =106000;           int MAGIC_Rf_m[30]={0,0,0,0};
   input double     in_maxspread            =10.0;
   input double     in_ult_max_loss_percent =100.0; 
   input double     in_ult_win_percent      =100.0;  
   input double     in_ult_delayminutesafterloss=0;     

                                                         double   revkorr;
   input bool       in_money_management     =true;
   input bool       in_b_aggressive         =true;
   input int        in_hidden_equity        =0;   
   input bool       in_hidden_sl            =true;      
   input double     in_lots                 =0.1;                                                      
   input double     in_lots_multipliyer     =1.0;
   input double     in_lots_adjust          =1.0;
         double     in_maxlot               =50.0, in_maxequityperlot=2500;
                                                               int strat_nr=20; int strat_act;      //1      2        3        4        5       6      7 
                                                               bool strat_run[30]                  = {true  ,true    ,true    ,true   ,true   ,true   ,true,true   ,true,true   ,true,true   ,true ,true ,true ,true ,true ,true ,true ,true};
         bool       b_signal2_trading=false;                   bool b_signal2_trading_m[30]        = {false ,false   ,false   ,false  ,false  ,false,false  ,false,false  ,false,false  ,false  ,false,false,false,false,false,false,false};
 
   //  V ---------------------------------------------------------------------------------------------------------------------------------------------------------------   
   //    ------------------ to change ----------------------------------------------------------------------------------------------------------------------------------   

   input Enum_TimeFrames2 in_strat_period=P_M1;
   input int in_test_fromyear=201300;
   input Enum_Currency strat_symbol_e=Current;
   string strat_symbol=F_Curr(strat_symbol_e,Symbol());                                 //string strat_symbol_m[10]           ={"USDJPY","USDJPY","USDJPY","USDJPY","USDJPY","USDJPY"};

 
input double in_lots_equityperlot=50000;      double lots_equityperlot_m[30]={20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000};
   //    -------------  INNET�L KELL V�LTOZTATNI
double lots_equityperlot_ma[30]={20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000    ,20000};
Enum_TimeFrames2 strat_period_m[30]={P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1    ,P_M1};
Enum_Currency strat_symbol_m[30]={Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current    ,Current};
input double in_martingal=0;       double martingal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_ult_reverse=1;       int ult_reverse_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};

input int in_tradinghour_start=0;      int tradinghour_start_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_tradinghour_end=25;      int tradinghour_end_m[30]={25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25    ,25};
input int in_tradinghour=7;      int tradinghour_m[30]={7    ,9    ,15    ,16    ,5    ,0    ,8    ,15    ,12    ,11    ,15    ,14    ,9    ,8    ,18    ,14    ,10    ,13    ,12    ,4};
input int in_tradingfridaytill=18;      int tradingfridaytill_m[30]={18    ,18    ,16    ,16    ,18    ,16    ,18    ,18    ,16    ,18    ,16    ,16    ,16    ,16    ,18    ,16    ,16    ,16    ,16    ,18};
input int in_tradingdayoyearmax=400;      int tradingdayoyearmax_m[30]={400    ,400    ,365    ,365    ,400    ,365    ,400    ,400    ,365    ,400    ,365    ,365    ,365    ,365    ,400    ,365    ,365    ,365    ,365    ,400};
input int in_entry_type=0;      int entry_type_m[30]={0    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_entry_reverse=1;      int entry_reverse_m[30]={1    ,-1    ,1    ,-1    ,1    ,-1    ,1    ,1    ,-1    ,1    ,1    ,-1    ,1    ,-1    ,-1    ,1    ,1    ,1    ,1    ,-1};
input int in_entry_ordertype=1;      int entry_ordertype_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_entry_orderbridge=0;      double entry_orderbridge_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_entry_expire=120;      int entry_expire_m[30]={120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120    ,120};
input double in_delayminutes=0;      double delayminutes_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_delayminutesafterclose=20;      double delayminutesafterclose_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_delayminutesafterloss=60;      double delayminutesafterloss_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60};
input bool in_increase_lots=false;      bool increase_lots_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
input int in_increase_for_every=3;      int increase_for_every_m[30]={3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3};
input double in_increase_percent=0.1;      double increase_percent_m[30]={0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1    ,0.1};
input int in_step_type=1;      int step_type_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_step_up=5;      int step_up_m[30]={5    ,5    ,10    ,10    ,5    ,10    ,5    ,5    ,5    ,5    ,5    ,10    ,5    ,5    ,5    ,5    ,5    ,5    ,5    ,5};
input int in_step_down=30;      int step_down_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_step_down_first=60;      int step_down_first_m[30]={60    ,60    ,70    ,70    ,60    ,70    ,60    ,60    ,70    ,60    ,70    ,70    ,70    ,70    ,60    ,70    ,70    ,70    ,70    ,60};
input int in_step_down_minute=60;      int step_down_minute_m[30]={60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60    ,60};
input int in_step_max_nr=1;      int step_max_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_step_max_nr_down=3;      int step_max_nr_down_m[30]={3    ,3    ,1    ,1    ,3    ,1    ,3    ,3    ,1    ,3    ,1    ,1    ,1    ,1    ,3    ,1    ,1    ,1    ,1    ,3};
input double in_step_movegoal=0;      double step_movegoal_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_hedging_openafter=0;      double hedging_openafter_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_hedging_losspip=0;      double hedging_losspip_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_tp_price=0;      double tp_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_tp_avg=2000;      double tp_avg_m[30]={2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000    ,2000};
input double in_tp=30;      double tp_m[30]={30    ,30    ,35    ,35    ,30    ,25    ,30    ,45    ,30    ,45    ,15    ,25    ,15    ,15    ,15    ,15    ,15    ,15    ,15    ,20};
input bool in_b_letprofitrun=false;      bool b_letprofitrun_m[30]={false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false    ,false};
input int in_fallbackpip_min=6;      int fallbackpip_min_m[30]={6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6    ,6};
input int in_fallbackpip_max=20;      int fallbackpip_max_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_fallbackpercent_max=0.2;      double fallbackpercent_max_m[30]={0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2    ,0.2};
input double in_max_loss_percent=50;      double max_loss_percent_m[30]={50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50    ,50};
input double in_sl_price=0;      double sl_price_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl=35;      double sl_m[30]={35    ,45    ,45    ,35    ,25    ,45    ,25    ,25    ,39    ,35    ,32    ,45    ,32    ,39    ,35    ,45    ,39    ,39    ,32    ,45};
input double in_sl_trail=0;      double sl_trail_m[30]={0    ,0    ,8    ,8    ,0    ,8    ,0    ,0    ,8    ,0    ,8    ,8    ,8    ,8    ,0    ,8    ,8    ,8    ,8    ,0};
input double in_sl_step=0;      double sl_step_m[30]={0    ,0    ,1    ,1    ,0    ,1    ,0    ,0    ,1    ,0    ,1    ,1    ,1    ,1    ,0    ,1    ,1    ,1    ,1    ,0};
input double in_sl_step_first=0;      double sl_step_first_m[30]={0    ,0    ,1    ,1    ,0    ,1    ,0    ,0    ,1    ,0    ,1    ,1    ,1    ,1    ,0    ,1    ,1    ,1    ,1    ,0};
input double in_sl_onavgprice=0;      double sl_onavgprice_m[30]={0    ,0    ,10    ,10    ,0    ,10    ,0    ,0    ,10    ,0    ,10    ,10    ,10    ,10    ,0    ,10    ,10    ,10    ,10    ,0};
input int in_trailingstop_after_nr=0;      int trailingstop_after_nr_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_stop_after_nr=1;      int stop_after_nr_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_closeinstepup=0;      double closeinstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closepipstepup=0;      double closepipstepup_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closeinstepdown=0;      double closeinstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_closepipstepdown=0;      double closepipstepdown_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl_turn=0;      double sl_turn_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_sl_turnmult=0;      double sl_turnmult_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_closefridaynight=22;      int closefridaynight_m[30]={22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22    ,22};
input int in_closesar=0;              int closesar_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour_tillsection=1;      double stop_after_hour_tillsection_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input double in_stop_after_hour=20;      double stop_after_hour_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_stop_after_hour_minprofit=-2000;      double stop_after_hour_minprofit_m[30]={-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000};
input double in_stop_after_hour_minloss=0;      double stop_after_hour_minloss_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_hour2=3;      double stop_after_hour2_m[30]={3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,3    ,2    ,3    ,2    ,2    ,3    ,3    ,2    ,3    ,2    ,3    ,2};
input double in_stop_after_hour_minprofit2=-2000;      double stop_after_hour_minprofit2_m[30]={-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000    ,-2000};
input double in_stop_after_hour_minloss2=0;      double stop_after_hour_minloss2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_min=0;      double stop_after_lastopen_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_minprofit=0;      double stop_after_lastopen_minprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_stop_after_lastopen_maxprofit=0;      double stop_after_lastopen_maxprofit_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_signal_atr_max=1000;      double signal_atr_max_m[30]={1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,1000    ,2    ,1000    ,2    ,1000    ,2    ,4    ,1000    ,1000    ,4    ,2    ,2    ,1000};
input double in_signal_atr_min=0;      double signal_atr_min_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_atr_period=30;      int atr_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_signal_adx_limit=0;      double signal_adx_limit_m[30]={0    ,0    ,48    ,44    ,0    ,50    ,0    ,0    ,0    ,0    ,0    ,50    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_signal_adx_max=100;      double signal_adx_max_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input int in_adx_period=30;      int adx_period_m[30]={30    ,30    ,20    ,20    ,30    ,20    ,30    ,30    ,30    ,30    ,30    ,20    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_signal_adx_limit2=0;      double signal_adx_limit2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_adx_period2=20;      int adx_period2_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input double in_signal_stoch_down=100;      double signal_stoch_down_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input int in_stoch_period=30;      int stoch_period_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input double in_rsi_limit_down=100;      double rsi_limit_down_m[30]={100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100    ,100};
input double in_rsi_min_down=0;      double rsi_min_down_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_rsi_period=30;      int rsi_period_m[30]={30    ,30    ,10    ,10    ,30    ,10    ,30    ,30    ,30    ,30    ,30    ,10    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_bool_dev=0;      int bool_dev_m[30]={0    ,0    ,2    ,2    ,0    ,2    ,0    ,0    ,8    ,0    ,8    ,2    ,8    ,8    ,0    ,6    ,8    ,8    ,8    ,0};
input int in_bool_period=20;      int bool_period_m[30]={20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20    ,20};
input int in_bool_dev2=0;      int bool_dev2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,16    ,0    ,10    ,0    ,16    ,8    ,0    ,4    ,12    ,14    ,8    ,0};
input int in_bool_period2=30;      int bool_period2_m[30]={30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30    ,30};
input int in_bool_dev3=0;      int bool_dev3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,6    ,0    ,6    ,0    ,6    ,6    ,0    ,2    ,6    ,6    ,6    ,0};
input int in_bool_period3=40;      int bool_period3_m[30]={40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40    ,40};
input int in_stepmin1=5;      int stepmin1_m[30]={5    ,11    ,0    ,0    ,5    ,0    ,5    ,2    ,0    ,2    ,0    ,0    ,0    ,0    ,2    ,0    ,0    ,0    ,0    ,5};
input double in_steppip1=14;      double steppip1_m[30]={14    ,14    ,0    ,0    ,14    ,0    ,14    ,14    ,0    ,14    ,0    ,0    ,0    ,0    ,14    ,0    ,0    ,0    ,0    ,11};
input int in_stepmin2=0;      int stepmin2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_steppip2=0;      double steppip2_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_stepmin3=0;      int stepmin3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input double in_steppip3=0;      double steppip3_m[30]={0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0    ,0};
input int in_monday=1;      int monday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_tuesday=1;      int tuesday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_wednesday=1;      int wednesday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_thursday=1;      int thursday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_friday=1;      int friday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};
input int in_saturday=1;      int saturday_m[30]={1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1    ,1};

//---------   EDDIG VAN CSERE 
 
 
 #include <mp\expert\oa_nlv04_b02_131204.mq5>


 