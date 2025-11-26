class CentrosDeCustoController < ApplicationController
  def index
    centros = CentroDeCusto.all
    render json: centros
  end

  def create
    centro = CentroDeCusto.new(centro_de_custo_params)

    if centro.save
      render json: centro, status: :created
    else
      render json: { errors: centro.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def centro_de_custo_params
    params.require(:centro_de_custo).permit(:nome)
  end
end
