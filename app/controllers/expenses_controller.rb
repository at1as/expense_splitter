class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  before_action :set_event,   only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @purchaser = Person.find(@expense.purchaser_id)
  end

  # GET /expenses/new
  def new
    @people    = @event.people
    @expense   = Expense.new
    @purchaser = @expense.purchaser_id
  end

  # GET /expenses/1/edit
  def edit
    @purchaser = @expense.purchaser_id
    @people    = @event.people
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params.tap { |p| p["event_id"] = @event.id })

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @event, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @event, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to @event, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end
    
    def set_event
      @event = Event.find(params[:event_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:name, :description, :amount, :purchaser_id, :person_ids => [])
    end
end
