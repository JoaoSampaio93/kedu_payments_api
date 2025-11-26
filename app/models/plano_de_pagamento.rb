class PlanoDePagamento < ApplicationRecord
  belongs_to :responsavel
  belongs_to :centro_de_custo
  has_many :cobrancas

  def valor_total
    cobrancas.sum(:valor)
  end
end
