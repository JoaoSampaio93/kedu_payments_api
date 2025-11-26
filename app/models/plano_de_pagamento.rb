class PlanoDePagamento < ApplicationRecord
  belongs_to :responsavel
  belongs_to :centro_de_custo
end
