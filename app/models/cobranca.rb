class Cobranca < ApplicationRecord
  belongs_to :plano_de_pagamento

  enum metodo_pagamento: { boleto: 0, pix: 1 }
  enum status: { emitida: 0, paga: 1, cancelada: 2 }
  has_many :pagamentos
  before_create :gerar_codigo_pagamento
  def vencida?
    !paga? && !cancelada? && Date.current > data_vencimento
  end

  private

  def gerar_codigo_pagamento
    self.codigo_pagamento =
      if boleto?
        "341#{SecureRandom.hex(10)}" # linha digitável fake
      else
        "pix-#{SecureRandom.uuid}" # chave/código PIX fake
      end
  end
end
