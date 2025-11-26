class CobrancasController < ApplicationController
  def por_responsavel
    responsavel = Responsavel.find(params[:responsavel_id])

    cobrancas = Cobranca
                .joins(:plano_de_pagamento)
                .where(plano_de_pagamentos: { responsavel_id: responsavel.id })
                .includes(:plano_de_pagamento)

    render json: cobrancas.map { |c| serialize_cobranca(c) }
  end

  def quantidade_por_responsavel
    responsavel = Responsavel.find(params[:responsavel_id])

    total = Cobranca
            .joins(:plano_de_pagamento)
            .where(plano_de_pagamentos: { responsavel_id: responsavel.id })
            .count

    render json: {
      responsavel_id: responsavel.id,
      quantidade_cobrancas: total
    }
  end

  private

  def serialize_cobranca(c)
    {
      id: c.id,
      plano_id: c.plano_de_pagamento_id,
      valor: c.valor.to_f,
      data_vencimento: c.data_vencimento,
      metodo_pagamento: c.metodo_pagamento.upcase,
      codigo_pagamento: c.codigo_pagamento,
      status: c.status.upcase,
      vencida: c.vencida?
    }
  end
end
