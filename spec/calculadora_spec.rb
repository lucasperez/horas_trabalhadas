require File.expand_path("./calculadora.rb")

RSpec.describe Calculadora, "#calcular" do 
  
  context "quando tem apenas 1 dia sem abono" do
    before do
      @file = File.read('spec/fixtures/1_dia_sem_abono.csv')
    end
    it "deve ler apenas o dia e calcular a diferenca de 1 dia" do
      diferenca = Calculadora.new.calcular("spec/fixtures/1_dia_sem_abono.csv")
      expect(diferenca).to eq "01:45:00"
    end
  end

  context "quando tem 2 dias sem abono" do
    before do
      @file = File.read('spec/fixtures/1_dia_sem_abono.csv')
    end
    it "deve ler todos os dias e acumular a diff" do
      diferenca = Calculadora.new.calcular("spec/fixtures/2_dias_sem_abono.csv")
      expect(diferenca).to eq "02:05:00"
    end
  end

  context "quando tem 1 dia com abono e 2 sem abono" do
    before do
      @file = File.read('spec/fixtures/1_dia_com_abono_e_2_sem_abono.csv')
    end
    it "deve ler todos os dias e acumular a diff" do
      diferenca = Calculadora.new.calcular("spec/fixtures/1_dia_com_abono_e_2_sem_abono.csv")
      expect(diferenca).to eq "02:05:00"
    end
  end

  context "quando tem um mes inteiro" do
    before do
      @file = File.read('spec/fixtures/0516.csv')
    end
    it "deve ler todos os dias e acumular a diff" do
      diferenca = Calculadora.new.calcular("spec/fixtures/0516.csv")
      expect(diferenca).to eq "06:25:00"
    end
  end
end