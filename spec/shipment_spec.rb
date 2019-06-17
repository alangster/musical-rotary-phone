require 'rspec'
require 'shipment'
require 'date'
require 'timecop'

describe Shipment do
  let(:full_attributes) do
    {
      first_name:    "Ben",
      last_name:     "Wyatt",
      number:        "SH432123",
      order_number:  "987654",
      shipment_date: "2018-12-10 15:08:58 -0000",
    }
  end

  let(:attributes_with_parent_order) do
    attributes = full_attributes.merge({ parent_number: "SH86739" })
    attributes.delete(:order_number)
    attributes
  end

  let(:default) { "N/A" }

  describe "#initialize" do
    context "with no parent number provided" do
      it "sets the non-shipment_date attributes" do
        shipment = Shipment.new(full_attributes)

        full_attributes.each do |key, value|
          expect(shipment.public_send(key)).to eq(value)
        end
        expect(shipment.parent_number).to eq(default)
      end
    end

    context "with a parent number provided" do
      it "sets the non-shipment_date attributes" do
        shipment = Shipment.new(attributes_with_parent_order)

        attributes_with_parent_order.each do |key, value|
          expect(shipment.public_send(key)).to eq(value)
        end
        expect(shipment.order_number).to eq(default)
      end
    end
  end

  describe "#to_str" do
    context "without a parent shipment" do
      it "returns a formatted string of the shipment's attributes" do
        shipment = Shipment.new(full_attributes)
        expect(shipment.to_str).to eq(
          "Number: #{full_attributes[:number]}, "\
          "Order Number: #{full_attributes[:order_number]}, "\
          "Shipped: #{full_attributes[:shipment_date]}, "\
          "First Name: #{full_attributes[:first_name]}, "\
          "Last Name: #{full_attributes[:last_name]}, "\
          "Parent Shipment: N/A"
        )
      end
    end

    context "with a parent shipment" do
      it "returns a formatted string of the shipment's attributes" do
        shipment = Shipment.new(attributes_with_parent_order)
        expect(shipment.to_str).to eq(
          "Number: #{attributes_with_parent_order[:number]}, "\
          "Order Number: N/A, "\
          "Shipped: #{attributes_with_parent_order[:shipment_date]}, "\
          "First Name: #{attributes_with_parent_order[:first_name]}, "\
          "Last Name: #{attributes_with_parent_order[:last_name]}, "\
          "Parent Shipment: #{attributes_with_parent_order[:parent_number]}"
        )
      end
    end
  end

  describe "#full_name" do
    it "returns the customer's first and last names" do
      shipment = Shipment.new(full_attributes)
      expect(shipment.full_name).to eq(
        "#{full_attributes[:first_name]} #{full_attributes[:last_name]}"
      )
    end
  end

  describe "#days_ago" do
    let(:shipment_date) { DateTime.parse(full_attributes[:shipment_date]) }

    context "when no days have passed" do
      it "returns 0" do
        shipment = Shipment.new(full_attributes)

        Timecop.freeze(shipment_date) do
          expect(shipment.days_ago).to eq(0)
        end
      end
    end

    context "when some days have passed" do
      it "returns the number of days since the shipment was shipped" do
        shipment = Shipment.new(full_attributes)
        days = 25

        Timecop.freeze(shipment_date + days) do
          expect(shipment.days_ago).to eq(days)
        end
      end
    end
  end

  describe "#attributes" do
    context "without computed properties" do
      it "returns a hash of the shipment's attributes" do
        shipment = Shipment.new(full_attributes)
        expect(shipment.attributes).to eq({
          number: full_attributes[:number],
          order_number: full_attributes[:order_number],
          shipment_date: full_attributes[:shipment_date],
          first_name: full_attributes[:first_name],
          last_name: full_attributes[:last_name],
          parent_number: "N/A"
        })
      end
    end

    context "with computed properties" do
      let(:shipment_date) { DateTime.parse(full_attributes[:shipment_date]) }

      it "returns a hash of the shipment's attributes plus full name and days ago" do
        shipment = Shipment.new(full_attributes)
        days = 100
        Timecop.freeze(shipment_date + days) do
          expect(shipment.attributes(true)).to eq({
            number: full_attributes[:number],
            order_number: full_attributes[:order_number],
            shipment_date: full_attributes[:shipment_date],
            first_name: full_attributes[:first_name],
            last_name: full_attributes[:last_name],
            parent_number: "N/A",
            full_name: "#{full_attributes[:first_name]} #{full_attributes[:last_name]}",
            days_ago: days
          })
        end
      end
    end
  end
end
