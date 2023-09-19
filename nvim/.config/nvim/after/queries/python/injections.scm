; extends
((string_content) @injection.content
  (#match? @injection.content "^( |\n)*(SELECT|INSERT|UPDATE|DELETE|CREATE (TABLE|VIEW))( |\n)")
  (#set! injection.language "sql"))
