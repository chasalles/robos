//+------------------------------------------------------------------+
//|                                                         CAUS.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Trade\SymbolInfo.mqh> 
#include <Trade\Trade.mqh>
#include <Generic\LinkedList.mqh>
#include "Preco.mq5"

CTrade trade; 
CSymbolInfo simbolo;
CLinkedList<Preco> linkedList*;

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
    PrintFormat("Moeda da conta - %s, níveis de MarginCall e StopOut são configurados em %s", currency,(stop_out_mode == ACCOUNT_STOPOUT_MODE_PERCENT)? "porcentagem" : " dinheiro"); 
    PrintFormat("MarginCall = %G, StopOut = %G", margin_call, stop_out); 

    //--- create timer
    EventSetTimer(60);
   
    trade = new CTrade();
    simbolo = new CSymbolInfo();
    linkedList = new CLinkedList<*Preco>();
    
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
