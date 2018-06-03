//+------------------------------------------------------------------+
//|                                                    Consolida.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\SymbolInfo.mqh> 
#include <Trade\Trade.mqh>

CTrade trade; 
CSymbolInfo simbolo;

int handleMA34M5;
double iMA34M5Buffer[]; 

int diario;

MqlRates priceM5[];
MqlRates priceD1[];

MqlDateTime mqlDataAtual;

datetime dataAtual;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   //--- Nome da empresa 
   string company = AccountInfoString(ACCOUNT_COMPANY);
   
   //--- Nome do cliente 
   string name = AccountInfoString(ACCOUNT_NAME); 
   
   //--- Número da conta 
   long login = AccountInfoInteger(ACCOUNT_LOGIN); 

   //--- Nome do servidor 
   string server = AccountInfoString(ACCOUNT_SERVER); 
   
   //--- Moeda da conta 
   string currency = AccountInfoString(ACCOUNT_CURRENCY); 
   
   //--- Conta demo, de torneio ou real 
   ENUM_ACCOUNT_TRADE_MODE account_type =(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE); 

   //--- Agora transforma o valor da enumeração em uma forma inteligível 
   string trade_mode = "";
   
   switch(account_type){ 
      case ACCOUNT_TRADE_MODE_DEMO: 
         trade_mode = "demo"; 
         break; 
      case ACCOUNT_TRADE_MODE_CONTEST: 
         trade_mode = "concurso"; 
         break; 
      default: 
         trade_mode = "real"; 
         break; 
   }
     
   //--- Stop Out é definida em percentagem ou dinheiro 
   ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode = (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
    
   //--- Obtém os valores dos níveis quando a Chamada de Margem e Stop Out (encerramento forçado) ocorrem 
   double margin_call = AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL); 
   
   double stop_out = AccountInfoDouble(ACCOUNT_MARGIN_SO_SO); 
   
   //--- Exibe informações resumidas sobre a conta 
   PrintFormat("A conta do do cliente '%s' #%d %s aberta em '%s' no servidor '%s'", name, login, trade_mode, company, server); 
   PrintFormat("Moeda da conta - %s, níveis de MarginCall e StopOut são configurados em %s", currency,(stop_out_mode==ACCOUNT_STOPOUT_MODE_PERCENT)? "porcentagem" : " dinheiro"); 
   PrintFormat("MarginCall = %G, StopOut = %G", margin_call, stop_out); 
 
//--- create timer
   EventSetTimer(60);
    
   trade = new CTrade();
   simbolo = new CSymbolInfo();
   
   Print("SIMBOLO: ", simbolo.Name());
   
   trade.SetExpertMagicNumber(891993);
   trade.SetTypeFilling(ORDER_FILLING_RETURN);
   trade.SetDeviationInPoints(100);
   trade.LogLevel(LOG_LEVEL_ERRORS);
   trade.SetAsyncMode(true);
        
   handleMA34M5 = iMA(NULL, PERIOD_M5, 34, 0, MODE_EMA, PRICE_CLOSE); 
   
   SetIndexBuffer(0, iMA34M5Buffer, INDICATOR_DATA);
    
   ArraySetAsSeries(iMA34M5Buffer, true); 
   ArraySetAsSeries(priceM5, true);
   ArraySetAsSeries(priceD1, true);

   diario = 1;

//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//--- destroy timer
   EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
    //---
   dataAtual = TimeCurrent();
   TimeToStruct(dataAtual, mqlDataAtual);
    
   int positionTotal = PositionsTotal();
    
   if(positionTotal == 0 && diario == 1){
      if(mqlDataAtual.hour == 9){
         entrada();
         diario = 0;
      }
   }else{
      if(mqlDataAtual.hour == 17){
         trade.PositionClose(_Symbol, ULONG_MAX);
         Print("POSITION CLOSE");
      }
   }
    
   if(mqlDataAtual.hour == 17){
      diario = 1;
   }
}
  
void entrada(){
   simbolo.Refresh();
   simbolo.RefreshRates();
    
   int elementosM5 = CopyRates(_Symbol, PERIOD_M5, 0, 10, priceM5);
   int elementosD1 = CopyRates(_Symbol, PERIOD_D1, 0, 10, priceD1);
        
   int copied2 = CopyBuffer(handleMA34M5, 0, 0, 10, iMA34M5Buffer);
    
   bool ops = false;
   bool opv = false;

   if(priceD1[1].open - priceD1[1].close < 0){
      ops = trade.PositionOpen(_Symbol, ORDER_TYPE_SELL, 1, 0, simbolo.Bid() + 200.0, simbolo.Bid() - 200.0, "VENDA REALIZADA");
      Print("VENDEU: ", trade.ResultRetcode());  
      Print("BID: ", simbolo.Bid());
   }else{
      opv = trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, 1, 0, simbolo.Ask() - 200.0, simbolo.Ask() + 200.0, "COMPRA REALIZADA");
      Print("COMPRA: ", trade.ResultRetcode());
      Print("ASK: ", simbolo.Ask());   
   }
}  
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
//---
}
  
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade(){
//---
}

//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result){
//---
}
//+------------------------------------------------------------------+
