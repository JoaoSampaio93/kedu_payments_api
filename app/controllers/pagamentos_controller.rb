class PagamentosController < ApplicationController
  def create
    cobranca = Cobranca.find(params[:cobranca_id])

    if cobranca.cancelada?
      render json: { error: "Não é permitido registrar pagamento para cobrança cancelada" },
             status: :unprocessable_entity
      return
    end

    Pagamento.transaction do
      pagamento = cobranca.pagamentos.create!(
        valor: params[:valor],
        data_pagamento: params[:dataPagamento] || Time.current
      )

      cobranca.update!(status: :paga)

      render json: {
        pagamento_id: pagamento.id,
        cobranca_id: cobranca.id,
        status_cobranca: cobranca.status.upcase
      }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
