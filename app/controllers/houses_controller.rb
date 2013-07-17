class HousesController < ApplicationController
  def new
    @house = House.new
  end

  def index
    @houses = House.find(:all)
  end

  def show
    @house = House.find(params[:id])
  end

  def edit
    @house = House.find(params[:id])
  end

  def create
    @house = House.new(params[:house])

      if @house.save
        redirect_to :action => 'index'
      else
        render action: "new"
      end
  end

  def update
    @house = House.find(params[:id])

      if @house.update_attributes(params[:house])
        redirect_to @house, notice: 'House was successfully updated.'
      else
        render action: "edit"
    end
  end

  def destroy
    @house = House.find(params[:id])
    if @house.destroy
      redirect_to houses_path
    else
      redirect_to houses_path , :notice => 'Something is wrong'
    end
  end

end
