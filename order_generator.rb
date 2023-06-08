class Item
  attr_reader :quantity, :name, :price, :is_imported, :is_exempt

  def initialize(quantity, name, price, is_imported, is_exempt)
    @quantity = quantity.to_i
    @name = name
    @price = price.to_f
    @is_imported = is_imported
    @is_exempt = is_exempt
  end

  def calculate_tax
    tax = 0.0
    tax += 0.1 * price unless is_exempt
    tax += 0.05 * price if is_imported
    tax = round_tax(tax)
    tax
  end

  def calculate_total_price
    quantity * price + calculate_tax
  end

  private

  def round_tax(tax)
    (tax * 20.0).ceil / 20.0
  end
end

class Receipt
  attr_reader :items

  def initialize(items)
    @items = items
  end

  def generate_output
    total_sales_tax = 0.0
    total_cost = 0.0

    items.each do |item|
      tax = item.calculate_tax
      total_sales_tax += tax
      total_cost += item.calculate_total_price

      puts "#{item.quantity} #{item.name}: #{'%.2f' % item.calculate_total_price}"
    end

    puts "Sales Taxes: #{'%.2f' % total_sales_tax}"
    puts "Total: #{'%.2f' % total_cost}"
  end
end

def parse_input(input)
  items = []
  input.each_line do |line|
    quantity, description = line.split(" ", 2)
    match = /(?<imported>imported\s+)?(?<name>.+)\sat\s(?<price>\d+(\.\d{1,2})?)/.match(description)
    name = match[:name]
    price = match[:price]
    is_imported = match[:imported] ? true : false
    is_exempt = exempt_item?(name)
    items << Item.new(quantity.to_i, name, price, is_imported, is_exempt)
  end
  items
end

def exempt_item?(item_name)
  exempt_items = %w[book food medical chocolate]
  exempt_items.any? { |exempt_item| item_name.downcase.include?(exempt_item) }
end
