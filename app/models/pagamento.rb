class Pagamento < ApplicationRecord
  belongs_to :cobranca

  validates :valor, numericality: { greater_than: 0 }
  validates :data_pagamento, presence: true
  validate  :data_pagamento_nao_pode_ser_no_passado

  private

  def data_pagamento_nao_pode_ser_no_passado
    return if data_pagamento.blank?

    if data_pagamento.to_date < Date.current
      errors.add(:data_pagamento, "não pode ser no passado")
    end
  end
end