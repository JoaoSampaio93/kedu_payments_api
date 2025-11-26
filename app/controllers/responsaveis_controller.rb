class ResponsaveisController < ApplicationController
  def create
    responsavel = Responsavel.new(responsavel_params)

    if responsavel.save
      render json: responsavel, status: :created
    else
      render json: { errors: responsavel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    responsavel = Responsavel.find(params[:id])
    render json: responsavel
  end

  def index
    responsaveis = Responsavel.all
    render json: responsaveis
  end

  private

  def responsavel_params
    params.require(:responsavel).permit(:nome, :documento)
  end
end
