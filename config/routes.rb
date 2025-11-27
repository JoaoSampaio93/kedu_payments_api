Rails.application.routes.draw do
  resources :responsaveis, only: %i[create show index] do
    resources :planos_de_pagamento, only: [:index]
    get 'cobrancas', to: 'cobrancas#por_responsavel'
    get 'cobrancas/quantidade', to: 'cobrancas#quantidade_por_responsavel'
  end
  resources :planos_de_pagamento, only: %i[create show] do
    member do
      get :total
    end
  end
  resources :cobrancas, only: [] do
    resources :pagamentos, only: :create
  end
  resources :centros_de_custo, only: %i[index create]
end
