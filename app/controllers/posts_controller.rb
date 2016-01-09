class PostsController < ApplicationController
  before_filter :authenticate
  #  :except => [ :index, :show ]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.paginate(:page => params[:page], :per_page => 5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @post_attachments = @post.post_attachments.all
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post_attachment = @post.post_attachments.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json

   def create
     @post = Post.new(post_params)

     respond_to do |format|
       if @post.save
         if params[:post_attachments]
           params[:post_attachments]['avatar'].each do |a|
             @post_attachment = @post.post_attachments.create!(:avatar => a, :post_id => @post.id)
           end
            format.html { redirect_to @post, notice: 'Post was successfully created.' }
          else
            format.html { render :new }
            format.json { render json: @post.errors, status: :unprocessable_entity }
          end
        end
     end
   end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json

  def update
    update_attachments if params[:post_attachments]
      if @post.update(post_params)
          redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_attachments
      params[:post_attachments]['avatar'].each do |a|
        @post_attachment = @post.post_attachments.create!(:avatar => a)
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, )
    end

    def authenticate
      authenticate_or_request_with_http_basic do |name, password|
      name == "emmagilhuly" && password == "emmagilhuly"
      end
    end

end
