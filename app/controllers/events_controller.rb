class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @people   = @event.people
    @expenses = @event.expenses
    @balances = calculate_balances
    @payments = calculate_payments
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :start_date, :end_date)
    end

    # TODO: Everything below here does not belong in the Controller

    def calculate_payments
      creditors = @balances.select { |_, cost| cost > 0 }.sort_by { |_, cost|  cost }.map { |person, cost| Event.transaction.new(cost, person) }
      debitors  = @balances.select { |_, cost| cost < 0 }.sort_by { |_, cost| -cost }.map { |person, cost| Event.transaction.new(cost, person) }

      equalize_payments(creditors, debitors)
    end

    def equalize_payments(creditors, debtors)
      equalization_transactions = Hash.new { |h, k| h[k] = [] }

      loop do
        break if creditors.length == 0 || debtors.length == 0
      
        max_owed  = creditors.pop
        min_payer = debtors.pop

        delta = max_owed.amount + min_payer.amount
        
        case
          when delta.zero? 
            equalization_transactions[min_payer.receiver] << max_owed
          
          when delta.positive?
            equalization_transactions[min_payer.receiver] << Event.transaction.new(min_payer.amount, max_owed.receiver)
            creditors << Event.transaction.new(delta, max_owed.receiver)
          
          when delta.negative?
            equalization_transactions[min_payer.receiver] << Event.transaction.new(max_owed.amount, max_owed.receiver)
            debtors << Event.transaction.new(delta, min_payer.receiver)
        end
      end

      equalization_transactions 
    end

    def calculate_balances
      user_balance = Hash.new(0)
      
      @event.expenses.each do |expense|
        user_balance[Person.find(expense.purchaser_id)] += expense.amount
        
        expense.people.each do |participant|
          user_balance[participant] -= expense.amount / expense.people.length.to_f
        end
      end

      user_balance
    end
end
