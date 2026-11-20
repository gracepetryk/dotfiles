;; extends

; sqlx::query!("..."), query_as!(T, r#"..."#), etc.
(macro_invocation
  macro: [
    (scoped_identifier
      name: (identifier) @_macro)
    (identifier) @_macro
  ]
  (token_tree
    [
      (string_literal
        (string_content) @injection.content)
      (raw_string_literal
        (string_content) @injection.content)
    ])
  (#any-of? @_macro
    "query" "query_as" "query_scalar"
    "query_unchecked" "query_as_unchecked" "query_scalar_unchecked")
  (#set! injection.language "sql"))

; sqlx::query("..."), sqlx::query_as::<_, T>("..."), etc.
(call_expression
  function: [
    (scoped_identifier
      path: (identifier) @_sqlx
      name: (identifier) @_fn)
    (generic_function
      function: (scoped_identifier
        path: (identifier) @_sqlx
        name: (identifier) @_fn))
  ]
  arguments: (arguments
    .
    [
      (string_literal
        (string_content) @injection.content)
      (raw_string_literal
        (string_content) @injection.content)
    ])
  (#eq? @_sqlx "sqlx")
  (#any-of? @_fn
    "query" "query_as" "query_scalar"
    "query_with" "query_as_with" "query_scalar_with")
  (#set! injection.language "sql"))
