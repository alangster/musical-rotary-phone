## Notes
In the allotted time, I was unable to write a file allowing it to be run from the command line with, for example `ruby handle_shipments.rb` or something like that. However, loading `lib/shipments_handler.rb` into an IRB session allows you to do everything.

To run the specs, ensure you have the `rspec` and `timecop` gems installed, and then run `rspec spec/`.

`ShipmentsHandler` has the following methods:
* `.parse`
  * Takes the string of shipments data
* `#print_all_shipments`
  * Prints a formatted list of all the shipments
* `#find_shipment`
  * Accepts a shipment number and returns a hash of that shipment's attributes
* `#find_shipment_with_computed_properties`
  * Similar to `#find_shipment`, but includes the shipment's computed properties `full_name` and `days_ago`
* `#find_associated_shipments`
  * Accepts an order number and returns an array of hashes of the associated shipments' attributes
