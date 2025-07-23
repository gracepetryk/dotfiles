; format-ignore
[
  ; ... refers to the portion that this indent query will have effects on
  (class_body)                        ; { ... } of `class X`
  (enum_body)                         ; { ... } of `enum X`
  (interface_body)                    ; { ... } of `interface X`
  (constructor_body)                  ; { `modifier` X() {...} } inside `class X`
  (annotation_type_body)              ; { ... } of `@interface X`
  (block)                             ; { ... } that's not mentioned in this scope
  (switch_block)                      ; { ... } in `switch X`
  (array_initializer)                 ; [1, 2]
  (annotation_argument_list)          ; @Annotation(...)
  (element_value_array_initializer)   ; { a, b } inside @Annotation()
] @indent.begin

(((_ !object
   (_ object: (_)) @indent.begin)
  (#set! indent.immediate 1))
 (#lua-match? @indent.begin "^[^\n]*\n[ 	]*%.")  ; indent chain only if first character of 2nd line is "."
 )

[
  ")"
  "}"
  "]"
] @indent.branch

(annotation_argument_list
  ")" @indent.end) ; This should be a special cased as `()` here doesn't have ending `;`

"}" @indent.end

(line_comment) @indent.ignore

[
  (ERROR)
  (block_comment)
] @indent.auto

((argument_list) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

((formal_parameters) @indent.align
   (#set! indent.open_delimiter "(")
   (#set! indent.close_delimiter ")"))
