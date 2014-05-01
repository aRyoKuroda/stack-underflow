class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)

    respond_to do |format|
      if @answer.save
        if !@answer.question.nil?
          format.html { redirect_to @answer.question, notice: 'Answer was successfully created.' }
        else
          format.html { redirect_to @answer, notice: 'Answer was successfully created.' }
        end
        
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :no_content }
    end
  end

  def upvote
    @vote = AnswerVote.new
    @vote.answer_id = @answer.id
    @vote.user_id = current_user.id
    @vote.value = 1
    @vote.save
    redirect_to @answer.question, notice: "Answer is upvoted."
  end

  def downvote
    @vote = AnswerVote.new
    @vote.answer_id = @answer.id
    @vote.user_id = current_user.id
    @vote.value = -1
    @vote.save
    redirect_to @answer.question, notice: "Answer is downvoted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content, :user_id, :question_id)
    end
end
