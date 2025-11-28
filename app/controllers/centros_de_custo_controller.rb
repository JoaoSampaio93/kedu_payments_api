class CentrosDeCustoController < ApplicationController
  before_action :set_centro_de_custo, only: [:update]

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

  def update
    if @centro_de_custo.update(centro_de_custo_params)
      render json: @centro_de_custo, status: :ok
    else
      render json: { errors: @centro_de_custo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_centro_de_custo
    @centro_de_custo = CentroDeCusto.find_by(id: params[:id])

    return if @centro_de_custo.present?

    render json: { error: 'Centro de custo não encontrado' }, status: :not_found
  end

  def centro_de_custo_params
    params.require(:centro_de_custo).permit(:nome)
  end
end
