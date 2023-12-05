# Alan created the following code to keep track of items for a shopping cart application he's writing:

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

# Alyssa looked at the code and spotted a mistake. "This will fail when update_quantity is called", she says. Can you spot the mistake and how to address it?

# The mistake is that there is no quantity setter method so the quantity method call in the update_quantity method must be replaced with the actual instance variable @quantity.
# Or create a setter method and prepend the quantity method call with self.
