class PlanoDePagamento < ApplicationRecord
  belongs_to :responsavel
  belongs_to :centro_de_custo
  has_many :cobrancas, dependent: :destroy

  accepts_nested_attributes_for :cobrancas

  def valor_total
    cobrancas.sum(:valor)
  end

  def self.criar_com_cobrancas!(payload)
    attrs = normalizar_payload(payload)

    transaction do
      plano = PlanoDePagamento.create!(
        responsavel_id: attrs[:responsavel_id],
        centro_de_custo_id: attrs[:centro_de_custo_id],
        cobrancas_attributes: attrs[:cobrancas_attributes]
      )

      plano
    end
  end

  def self.normalizar_payload(payload)
    payload = payload.to_h.deep_symbolize_keys

    responsavel_id      = payload[:responsavelId]   || payload[:responsavel_id]
    centro_de_custo_id  = payload[:centroDeCusto]   || payload[:centro_de_custo]
    cobrancas_raw       = payload[:cobrancas]       || []

    cobrancas_attributes = cobrancas_raw.map do |c|
      c = c.deep_symbolize_keys

      {
        valor: c[:valor],
        data_vencimento: c[:dataVencimento] || c[:data_vencimento],
        metodo_pagamento: (c[:metodoPagamento] || c[:metodo_pagamento]).to_s.downcase,
        status: :emitida
      }
    end

    {
      responsavel_id: responsavel_id,
      centro_de_custo_id: centro_de_custo_id,
      cobrancas_attributes: cobrancas_attributes
    }
  end
end
