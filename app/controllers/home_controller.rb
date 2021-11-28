class HomeController < ApplicationController
    skip_before_action :verify_authenticity_token
   # before_action :home_params
    def index

    end

    def results
        dna = Dna.new(params[:sequence])
        @forward_results = dna.find_primers(params[:minPmBp].to_i,params[:maxPmBp].to_i,params[:minGc].to_i,params[:maxGc].to_i,params[:minTm].to_i,params[:maxTm].to_i)
        @reverse_results = dna.find_reverse_primers(@forward_results, params[:minAmpBp].to_i, params[:maxAmpBp].to_i, params[:minPmBp].to_i,params[:maxPmBp].to_i,params[:minGc].to_i,params[:maxGc].to_i,params[:minTm].to_i,params[:maxTm].to_i)
    end
    private
    def params
        params = request.parameters
    end

end