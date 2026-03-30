; extends

;javascript
(
  (script_element
    (raw_text) @injection.content) 
  (#set! injection.language "javascript")
)

; ; <script type="text/babel"> ... </script>
; (
;   (script_element
;     (start_tag
;       (attribute
;         (attribute_name) @_name
;         (quoted_attribute_value
;           (attribute_value) @_value)))
;     (raw_text) @injection.content)
;   (#eq? @_name "type")
;   (#match? @_value "text/babel")
;   (#set! injection.language "javascriptreact")
; )

