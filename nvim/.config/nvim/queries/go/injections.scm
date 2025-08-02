; SQL injection for Go string literals
(raw_string_literal
  (raw_string_literal_content) @injection.content
  (#match? @injection.content "(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP)")
  (#set! injection.language "sql"))

(interpreted_string_literal
  (escape_sequence)* @_escape
  (#match? @_escape "(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP)")
  (#set! injection.language "sql")) @injection.content

