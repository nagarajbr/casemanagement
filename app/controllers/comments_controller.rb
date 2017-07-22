class CommentsController < AttopAncestorController

  def create
    @comment = Comment.new
    @comment.subject = params[:subject]
    @comment.comment = params[:comment]
    @comment.url = URI(request.referer).path
    if @comment.save
      @show_arwins_comments_form = true
      redirect_to :back
    else
      # flash[:notice] = "Failed to send feedback."
      redirect_to :back
    end
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("CommentsController","create",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Error when sending feedback."
    redirect_to_back
  end

end