require 'rspec'
require 'shipments_handler'
require 'shipment'

describe ShipmentsHandler do
  let(:shipments_data) do
    "SH348503,O567843,2018-12-10 15:08:58 -0000,Jane,Smith,
    SH927813,,2018-12-15 09:49:35 -0000,Rebecca,Jones,SH907346"
  end

  let(:shipment_one_attributes) do
    {
      first_name:    "Ben",
      last_name:     "Wyatt",
      number:        "SH432123",
      order_number:  "987654",
      shipment_date: "2018-12-10 15:08:58 -0000",
    }
  end

  let(:shipment_two_attributes) do
    {
      first_name:    "Leslie",
      last_name:     "Knope",
      number:        "SH452098",
      order_number:  "983601",
      shipment_date: "2018-11-19 14:28:08 -0000",
    }
  end

  let(:shipments) do
    [
      Shipment.new(shipment_one_attributes),
      Shipment.new(shipment_two_attributes),
    ]
  end

  describe ".parse" do
    it "returns a ShipmentsHandler for the shipments in the data" do
      handler = ShipmentsHandler.parse(shipments_data)
      expect(handler.shipments.count).to eq(2)
    end
  end

  describe "#initialize" do
    it "sets the shipments collection to the provided shipments" do
      handler = ShipmentsHandler.new(shipments)
      expect(handler.shipments).to eq(shipments)
    end
  end

  describe "#print_all_shipments" do
    it "prints the string versions of each shipment" do
      handler = ShipmentsHandler.new(shipments)
      expect {
        handler.print_all_shipments
      }.to output(
        "Shipment #1:\n" +
        "#{shipments.first.to_str}\n\n" +
        "Shipment #2:\n" +
        "#{shipments.last.to_str}"
      ).to_stdout
    end

    it "returns itself" do
      handler = ShipmentsHandler.new(shipments)
      expect(handler.print_all_shipments).to be(handler)
    end
  end

  describe "#find_shipment" do
    context "when the shipment exists" do
      let(:shipment) { shipments.last }

      it "returns the attributes of the shipment" do
        attrs = "attrs"
        allow(shipment).to receive(:attributes) { attrs }

        handler = ShipmentsHandler.new(shipments)
        expect(handler.find_shipment(shipment.number)).to eq(attrs)
      end
    end

    context "when the shipment does not exist" do
      it "returns nil" do
        handler = ShipmentsHandler.new(shipments)
        expect(handler.find_shipment(
          shipments.map(&:number).inject(:+).to_s
        )).to be_nil
      end
    end
  end

  describe "#find_shipment_with_computed_properties" do
    context "when the shipment exists" do
      let(:shipment) { shipments.last }

      it "returns the attributes of the shipment" do
        attrs = "attrs"
        allow(shipment).to receive(:attributes).with(true) { attrs }

        handler = ShipmentsHandler.new(shipments)
        expect(handler.find_shipment_with_computed_properties(
          shipment.number
        )).to eq(attrs)
      end
    end

    context "when the shipment does not exist" do
      it "returns nil" do
        handler = ShipmentsHandler.new(shipments)
        expect(handler.find_shipment_with_computed_properties(
          shipments.map(&:number).inject(:+)
        )).to be_nil
      end
    end
  end

  describe "#find_associated_shipments" do
    context "when there are no associated shipments" do
      it "returns an empty array" do
        handler = ShipmentsHandler.new(shipments)
        expect(handler.find_associated_shipments("00000")).to be_empty
      end
    end

    context "when there is one shipment" do
      let(:shipment_one) { Shipment.new(shipment_one_attributes) }
      let(:shipment_two) { Shipment.new(shipment_two_attributes) }

      it "returns an array containing the attributes of the shipment" do
        attrs = "attrs"
        allow(shipment_one).to receive(:attributes).with(true) { attrs }

        handler = ShipmentsHandler.new([shipment_one, shipment_two])

        expect(handler.find_associated_shipments(
          shipment_one_attributes[:order_number]
        )).to eq([attrs])
      end
    end

    context "when there are multiple associated shipments" do
      let(:shipment_one) { Shipment.new(shipment_one_attributes) }
      let(:shipment_two) { Shipment.new(shipment_two_attributes) }
      let(:shipment_three) do
        Shipment.new({
          first_name:    "Ann",
          last_name:     "Perkins",
          number:        "SH499993",
          order_number:  shipment_one_attributes[:order_number],
          shipment_date: "2018-02-20 15:08:58 -0000",
        })
      end

      it "returns an array containing the attributes of all associated shipments" do
        attrs_one = "attrs_one"
        attrs_three = "attrs_three"
        allow(shipment_one).to receive(:attributes).with(true) { attrs_one }
        allow(shipment_three).to receive(:attributes).with(true) { attrs_three }

        handler = ShipmentsHandler.new([shipment_one, shipment_two, shipment_three])

        expect(handler.find_associated_shipments(
          shipment_one_attributes[:order_number]
        )).to eq([attrs_one, attrs_three])
      end
    end
  end
end
