class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :edit, :destroy ]

  def index
    query = "SELECT * FROM prototypes"
    @prototypes = Prototype.find_by_sql(query)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
        redirect_to root_path
    else
       render :new,status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
    if current_user != @prototype.user.id
      redirect_to action: :index
    end

  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  def update
    @prototype = Prototype.find(params[:id])
   if @prototype.update(prototype_params)
     redirect_to prototype_path(@prototype.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:image, :title, :catch_copy, :concept).merge(user_id: current_user.id)
  end

end
