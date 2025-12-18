;; extends


((string
   (string_content) @injection.content)
 (#match? @injection.content "\\v\\c^(\\s|\n)*(BEGIN TRANSACTION;|SELECT|INSERT|UPDATE|DELETE|CREATE TABLE|CREATE TEMP TABLE|DROP TABLE|--|DECLARE)(\\s|\n)")
 (#set! injection.language "sql"))

(block . (expression_statement
         (string
           (string_content) @injection.content)
     (#set! injection.include-children)
     (#set! injection.language "markdown")))

(module . (expression_statement
         (string
           (string_content) @injection.content)
     (#set! injection.include-children)
     (#set! injection.language "markdown")))
