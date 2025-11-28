class PagamentosController < ApplicationController
  def create
    cobranca = Cobranca.find(params[:cobranca_id])
    pagamento = cobranca.registrar_pagamento!(
      valor: params[:valor],
      data_pagamento: params[:data_pagamento]
    )

    render json: {
      pagamento_id: pagamento.id,
      cobranca_id: cobranca.id,
      status_cobranca: cobranca.status.upcase
    }, status: :created
  rescue Cobranca::PagamentoInvalido => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
