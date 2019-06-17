require 'date'

class Shipment

  attr_reader :first_name, :last_name, :number, :order_number, :parent_number,
    :shipment_date

  def initialize(attributes)
    @first_name = attributes.fetch(:first_name)
    @last_name = attributes.fetch(:last_name)
    @number = attributes.fetch(:number)
    @order_number = attributes.fetch(:order_number)
    @parent_number = attributes.fetch(:parent_number, "N/A")
    @shipment_date = attributes.fetch(:shipment_date)
  end

  def to_str
    [
      number_string,
      order_number_string,
      shipment_date_string,
      first_name_string,
      last_name_string,
      parent_shipment_string,
    ].join(", ")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def days_ago
    today = Date.today
    shipped = DateTime.parse(shipment_date).to_date
    (today - shipped).to_i
  end

  private

  def number_string
    "Number: #{number}"
  end

  def order_number_string
    "Order Number: #{order_number}"
  end

  def shipment_date_string
    "Shipped: #{shipment_date}"
  end

  def first_name_string
    "First Name: #{first_name}"
  end

  def last_name_string
    "Last Name: #{last_name}"
  end

  def parent_shipment_string
    "Parent Shipment: #{parent_number}"
  end
end

