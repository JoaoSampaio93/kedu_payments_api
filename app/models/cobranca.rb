class Cobranca < ApplicationRecord
  belongs_to :plano_de_pagamento
  has_one :pagamento, dependent: :destroy

  enum metodo_pagamento: { boleto: 0, pix: 1 }
  enum status: { emitida: 0, paga: 1, cancelada: 2 }

  before_create :gerar_codigo_pagamento

  validates :valor, numericality: { greater_than: 0 }
  validates :data_vencimento, presence: true
  validates :metodo_pagamento, presence: true
  validates :status, presence: true

  class PagamentoInvalido < StandardError; end

  def vencida?
    !paga? && !cancelada? && Date.current > data_vencimento
  end

  def registrar_pagamento!(valor:, data_pagamento: Time.current)
    raise PagamentoInvalido, 'Cobrança já está paga' if paga?
    raise PagamentoInvalido, 'Não é permitido registrar pagamento para cobrança cancelada' if cancelada?
    raise PagamentoInvalido, 'A data de pagamento não pode ser no passado' if data_pagamento.to_date < Date.current
    raise PagamentoInvalido, 'Não é permitido pagar uma cobrança vencida' if vencida?

    pagamento = nil

    transaction do
      pagamento = create_pagamento!(valor: valor, data_pagamento: data_pagamento)
      update!(status: :paga)
    end

    pagamento
  end

  private

  def gerar_codigo_pagamento
    self.codigo_pagamento =
      if boleto?
        "341#{SecureRandom.hex(10)}"
      else
        "pix-#{SecureRandom.uuid}"
      end
  end
end
