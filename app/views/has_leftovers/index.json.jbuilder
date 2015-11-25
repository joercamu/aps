json.array!(@has_leftovers) do |has_leftover|
	json.extract! has_leftover, :order_id, :leftover_id, :quantity
end