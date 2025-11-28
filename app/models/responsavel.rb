class Responsavel < ApplicationRecord
  has_many :planos_de_pagamento,
           class_name: 'PlanoDePagamento',
           dependent: :destroy

  validates :nome, presence: true
  validates :documento, presence: true, uniqueness: true
end
