;; extends

(assignment
  left: (identifier) @_name
  (#match? @_name "[qQ][uU][eE][rR][yY]$")
  right: (string (string_content) @injection.content (#set! injection.language "sql")))
