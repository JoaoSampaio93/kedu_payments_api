class Pagamento < ApplicationRecord
  belongs_to :cobranca

  validates :valor, numericality: { greater_than: 0 }
  validates :data_pagamento, presence: true
end
