class Cobranca < ApplicationRecord
  belongs_to :plano_de_pagamento
  has_many :pagamentos, dependent: :destroy

  enum metodo_pagamento: { boleto: 0, pix: 1 }
  enum status: { emitida: 0, paga: 1, cancelada: 2 }

  before_create :gerar_codigo_pagamento

  validates :valor, numericality: { greater_than: 0 }
  validates :data_vencimento, presence: true
  validates :metodo_pagamento, presence: true
  validates :status, presence: true

  def vencida?
    !paga? && !cancelada? && Date.current > data_vencimento
  end

  private

  def gerar_codigo_pagamento
    self.codigo_pagamento =
      if boleto?
        "341#{SecureRandom.hex(10)}" # simulando linha digitável de boleto
      else
        "pix-#{SecureRandom.uuid}"   # simulando código/chave PIX
      end
  end
end
