class PostsController < ApplicationController
  before_action :authorize
  # 新規投稿ページ
  def new
    @post = Post.new
  end
  
  # 投稿処理
  def create
    @post = Post.new(post_params)
    upload_file = params[:post][:upload_file]
    # 投稿画像がない場合
    if upload_file.blank?
      flash[:danger] = "投稿には画像が必須です。"
      redirect_to new_post_path and return
    else
      upload_file_name = upload_file.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name
      
      File.open(output_path, 'w+b') do |f|
        f.write(upload_file.read)
      end
    end
    # post_imagesテーブルに登録するファイル名をPostインスタンスに格納
    @post.post_images.new(name: upload_file_name)
    if @post.save
      # 成功
      
      redirect_to top_path
      flash[:success] = "投稿しました。"
    else
      # 失敗
      flash[:danger] = "投稿に失敗しました。"
      redirect_to new_post_path
    end
  end 
  
  # 投稿を削除
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      # success
      
      redirect_to top_path
      flash[:success] = "投稿を削除しました。"
    else
      #fai

      redirect_to top_path
      flash[:danger] = "削除に失敗しました。"
    end  
  end
  
  # いいね処理
  def like
    @post = Post.find(params[:id])
    if PostLike.exists?(post_id: @post.id, user_id: current_user.id)
      # いいねを削除
      PostLike.find_by(post_id: @post.id, user_id: current_user.id).destroy
    else
      # いいねを登録
      PostLike.create(post_id: @post.id, user_id: current_user.id)
    end
    redirect_to top_path and return
  end
  
  #コメント投稿
  def comment
    @post = Post.find(params[:id])
    # コメント保存
    @post.post_comments.create(post_comment_params)
    p post_comment_params
    redirect_to top_path and return
  end
  # コメント用パラメータを取得
  def post_comment_params
    params.require(:post_comment).permit(:comment).merge(user_id: current_user.id)
  end
  
   private
  def post_params
    params.require(:post).permit(:caption).merge(user_id: current_user.id)
  end
end
