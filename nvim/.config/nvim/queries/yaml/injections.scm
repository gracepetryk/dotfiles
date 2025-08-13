;; extends

(block_mapping
  (block_mapping_pair
    key: (flow_node) @_uses
    (#eq? @_uses "uses")
    value: (flow_node) @_action_name)
    (#lua-match? @_action_name "actions/github%-script@v[%.0-9]*$")
    (block_mapping_pair
      key: (flow_node) @_with
      (#eq? @_with "with")
      value: (block_node
	       (block_mapping
		 (block_mapping_pair
		   key: (flow_node) @_script
		   (#eq? @_script "script")
		   value: (block_node
			    (block_scalar) @injection.content)
		 (#set! injection.language "javascript")
		 (#offset! @injection.content 0 1 0 0) )))))


