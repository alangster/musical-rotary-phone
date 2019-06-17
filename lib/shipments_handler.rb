require_relative 'shipment'

class ShipmentsHandler
  class << self
    def parse(shipment_data)
      raw_shipments = shipment_data.split("\n")
      shipments = raw_shipments.map do |raw_shipment|
        Shipment.new(shipment_attributes(raw_shipment))
      end

      new(shipments)
    end

    private

    def shipment_attributes(shipment_string)
      attributes = shipment_string.split(",").map(&:strip)
      {
        number:        attributes[0],
        order_number:  attributes[1],
        shipment_date: attributes[2],
        first_name:    attributes[3],
        last_name:     attributes[4],
        parent_number: attributes[5],
      }
    end
  end

  attr_reader :shipments

  def initialize(shipments)
    @shipments = shipments
  end

  def print_all_shipments
    shipments.each.with_index do |shipment, index|
      print "Shipment ##{index + 1}:\n"
      print shipment.to_str
      print "\n\n" unless index == shipments.count - 1
    end
    self
  end

  def find_shipment(shipment_number)
    shipment = fetch_shipment(shipment_number)
    shipment.attributes if shipment
  end

  def find_shipment_with_computed_properties(shipment_number)
    shipment = fetch_shipment(shipment_number)
    shipment.attributes(true) if shipment
  end

  def find_associated_shipments(order_number)
    associated_shipments = shipments.select do |shipment|
      shipment.order_number == order_number
    end

    associated_shipments.map do |shipment|
      shipment.attributes(true)
    end
  end

  private

  def fetch_shipment(number)
    shipments.find do |shipment|
      shipment.number == number
    end
  end
end
