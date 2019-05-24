class CreateBillService
  def initialize(attributes)
    @payable        = attributes[:payable]
    @logo_url       = attributes[:collection_logo_url]
    @title          = attributes[:collection_title]
    @collection_id  = attributes[:collection_id]
    @email          = attributes[:email]
    @name           = attributes[:name]
    @amount         = attributes[:amount]
    @description    = attributes[:description]
    @payment_method = attributes[:payment_method]
    @redirect_url   = attributes[:redirect_url]
  end

  def call
    @collection = find_or_create_collection if @payment_method == 'billplz'
    @bill = create_bill
  end

  def url
    @bill.payment_url
  end

  private
  def find_or_create_collection
    if @collection_id
      Pay::Collection.find_by_collection_id @collection_id
    else
      create_collection = CreateCollectionService.new(@title, @logo_url)
      create_collection.call
    end
  end

  def create_bill
    if @payment_method == 'billplz'
      create_bill = Billplz::CreateBill.new(@email, @name, @amount, @description, @redirect_url, @collection.collection_id)
      create_bill.call
      if create_bill.response['id']
        payment = @collection.payments.new(payment_params(create_bill.response))
        payment.payable = @payable
        payment.save
        payment
      else
        puts "Error cannot create bill #{create_bill.response}"
        nil
      end
    else
      @payable.build_payment(manual_payment_params).save
    end
  end

  def payment_params(response)
    {
      amount:         response['amount'],
      payment_url:    response['url'],
      bill_id:        response['id'],
      collection_id:  response['collection_id']
    }
  end

  def manual_payment_params
    {
      amount: @amount,
      payment_method: @payment_method,
      paid_at: DateTime.now
    }
  end
end
