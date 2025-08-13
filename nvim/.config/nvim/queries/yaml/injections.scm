((comment) @injection.content
  (#set! injection.language "comment"))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "before_script" "after_script" "cmds" "cmd" "sh")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

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
		 (#offset! @injection.content 0 1 0 0) )) @js_block_parent)))



(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "before_script" "after_script" "cmds" "sh")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; Prometheus Alertmanager ("expr")
(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "promql")))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "promql")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "promql")))))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "promql")
          (#offset! @injection.content 0 1 0 0))))))
