require 'active_support/all'
require 'csv'
require 'thor'
require "logging"

class Calculadora < Thor

  LOGGER = Logging.logger(STDOUT)

  desc "calcular as horas trabalhadas baseadas em um caminho de arquivo", "Ex: ruby calculadora.rb calcular [arquivo |path do arquivo|]"
  def calcular(arquivo)
    @diff_total = 0
    dias_trabalhados = CSV.read(arquivo, {headers: true}).select {|m| m['abono'] == "F"}
    LOGGER.info "----RELATORIO DO MES----"
    dias_trabalhados.each do |dia|
      inicio = Time.parse("2016-05-01 #{dia['inicio']}")
      saida = Time.parse("2016-05-01 #{dia['saida']}")
      diferenca = 9.hours - (saida - inicio)
      #desconta a hora do almoco 
      diferenca = diferenca - 1.hours if Time.at(diferenca).utc > Time.at(1.hours).utc
      if faltou? diferenca
        LOGGER.info "#{dia['dia']} - FALTOU! DIA DEVE SER LANÇADO COMO FALTA NO PAGGADOMESTICOS"
      elsif atrasou? diferenca
        LOGGER.info "#{dia['dia']} - #{formatar_saida(diferenca)}"
        @diff_total += diferenca
      end
    end
    LOGGER.info "TOTAL A DESCONTAR: #{formatar_saida(@diff_total)}"
    LOGGER.info "----FIM DO RELATORIO DO MES----"
    formatar_saida(@diff_total)
  end

  protected 

  def atrasou?(diferenca)
    return diferenca / 60 > 15
  end

  def faltou?(diferenca)
    return diferenca/60/60 == 8
  end

  def formatar_saida(valor)
    Time.at(valor.to_i.abs).utc.strftime "%H:%M:%S"
  end

end

Calculadora.start