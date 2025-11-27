class PlanosDePagamentoController < ApplicationController
  def create
    plano = PlanoDePagamento.criar_com_cobrancas!(plano_payload)

    render json: serialize_plano(plano), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: 'Erro ao criar plano de pagamento',
      details: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def show
    plano = PlanoDePagamento.find(params[:id])
    render json: serialize_plano(plano)
  end

  def total
    plano = PlanoDePagamento.find(params[:id])
    render json: { id: plano.id, valor_total: plano.valor_total.to_f }
  end

  def index
    responsavel = Responsavel.find(params[:responsavel_id])
    planos = responsavel.planos_de_pagamento.includes(:centro_de_custo, :cobrancas)
    render json: planos.map { |p| serialize_plano(p) }
  end

  private

  def plano_payload
    params.permit(
      :responsavelId,
      :responsavel_id,
      :centroDeCusto,
      :centro_de_custo,
      cobrancas: %i[
        valor
        dataVencimento
        data_vencimento
        metodoPagamento
        metodo_pagamento
      ]
    )
  end

  def serialize_plano(plano)
    {
      id: plano.id,
      responsavel: {
        id: plano.responsavel.id,
        nome: plano.responsavel.nome
      },
      centro_de_custo: {
        id: plano.centro_de_custo.id,
        nome: plano.centro_de_custo.nome
      },
      valor_total: plano.valor_total.to_f,
      cobrancas: plano.cobrancas.map do |c|
        {
          id: c.id,
          valor: c.valor.to_f,
          data_vencimento: c.data_vencimento,
          metodo_pagamento: c.metodo_pagamento.upcase,
          status: c.status.upcase,
          vencida: c.vencida?,
          codigo_pagamento: c.codigo_pagamento
        }
      end
    }
  end
end
