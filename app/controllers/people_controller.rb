class PeopleController < ApplicationController

  def new
  	@person = Person.new
  end

  def index
    @people = Person.find(:all)
  end

  def show
  	@person = Person.find(params[:id])
  end

  def edit
  	@person = Person.find(params[:id])
  end

  def create
  	@person = Person.new(params[:person])

  	  if @person.save
        redirect_to :action => 'index'
      else
        render action: "new"
      end
  end

  def update
    @person = Person.find(params[:id])

      if @person.update_attributes(params[:person])
        redirect_to @person, notice: 'User was successfully updated.'
      else
        render action: "edit"
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if false && @person.destroy
      redirect_to people_path
    else
      redirect_to people_path , :notice => 'Something is wrong'
    end
  end
end