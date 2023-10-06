; extends
(string
   (string_content) @start @injection.content
   (#match? @start "^( |\n)*(SELECT|INSERT|UPDATE|DELETE|(CREATE|DROP) (TABLE|VIEW))( |\n)")
   (#set! injection.language "sql"))

(string
   (string_start)
   .
   (string_content) @start
   .
   (interpolation)+
   (string_content) @rest @injection.content
   (#match? @start "^( |\n)*(SELECT|INSERT|UPDATE|DELETE|(CREATE|DROP) (TABLE|VIEW))( |\n)")
   (#set! injection.language "sql"))
