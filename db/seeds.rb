Responsavel.destroy_all
CentroDeCusto.destroy_all
PlanoDePagamento.destroy_all
Cobranca.destroy_all
Pagamento.destroy_all

responsavel = Responsavel.create!(
  nome: 'João Responsável',
  documento: '123.456.789-00'
)

matricula     = CentroDeCusto.create!(nome: 'MATRICULA')
mensalidade   = CentroDeCusto.create!(nome: 'MENSALIDADE')
material_did  = CentroDeCusto.create!(nome: 'MATERIAL')

plano = PlanoDePagamento.create!(
  responsavel: responsavel,
  centro_de_custo: mensalidade
)

plano.cobrancas.create!(
  [
    {
      valor: 500.0,
      data_vencimento: Date.today + 10.days,
      metodo_pagamento: :boleto,
      status: :emitida
    },
    {
      valor: 500.0,
      data_vencimento: Date.today + 40.days,
      metodo_pagamento: :pix,
      status: :emitida
    }
  ]
)
