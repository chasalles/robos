class Preco{
    private:
        double valor;
        int vezes;
    
    public:
        Preco(){
            valor = 0;
            vezes = 0;
        }
        
        double getValor(){
            return valor;
        }
    
        int getVezes(){
            return vezes;
        }
};