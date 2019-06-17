require 'date'

class Shipment

  attr_reader :first_name, :last_name, :number, :order_number, :parent_number,
    :shipment_date

  def initialize(attributes)
    @first_name = attributes.fetch(:first_name)
    @last_name = attributes.fetch(:last_name)
    @number = attributes.fetch(:number)
    @shipment_date = attributes.fetch(:shipment_date)

    set_defaults(attributes)
  end

  def attributes(with_computed_properties = false)
    attrs = {
      number: number,
      order_number: order_number,
      shipment_date: shipment_date,
      first_name: first_name,
      last_name: last_name,
      parent_number: parent_number,
    }

    if with_computed_properties
      attrs.merge!({
        full_name: full_name,
        days_ago: days_ago,
      })
    end

    attrs
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

  def set_defaults(attributes)
    %w(order_number parent_number).each do |attribute|
      value = attributes[attribute.to_sym]
      value = "N/A" if !value || value.empty?
      instance_variable_set("@#{attribute}", value)
    end
  end

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

