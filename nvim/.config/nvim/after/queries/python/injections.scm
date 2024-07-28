;; extends


((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*SELECT%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*INSERT%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*UPDATE%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*DELETE%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*CREATE TABLE%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*DROP TABLE%s")
 (#set! injection.language "sql"))

((string
   (string_content) @injection.content)
 (#lua-match? @injection.content "^%s*%-%-%s")
 (#set! injection.language "sql"))
