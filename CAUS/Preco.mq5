class Preco{
  private:
    double valor;
    int vezes;
    
  public:
    void Preco(); // Constructor
    double getValor();
    int getVezes();
};

void Preco::Preco(){
}

double Preco::getValor(){
    return valor;
}

int Preco::getVezes(){
    return vezes;
}