class CentroDeCusto < ApplicationRecord
  has_many :planos_de_pagamento

  validates :nome, presence: true, uniqueness: true
end
